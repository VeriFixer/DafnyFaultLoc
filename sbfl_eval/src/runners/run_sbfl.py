import subprocess
from tqdm import tqdm
import sys
import os
import argparse
import json
import tempfile
import shutil
import time
import math
import re
from src.utils.parallel_executor import run_parallel_or_seq
from src.utils.config import (
    DAFNY_BINARY,
    DATASET_ROOT, 
    RESULTS_ROOT,
    PLUGIN_PATH,
    RUNTIME_PATH,
    EXTERN_PATH,
    DAFNY_MAX_MEMORY_MB,
    TIMEOUT
)

def calculate_file_metrics(file_data, target_metrics):
    """Calculates SBFL metrics"""
    
    AVAILABLE_METRICS = [
        "ochiai", "ochiai_prox",
        "tarantula", "tarantula_prox",
        "dstar2", "dstar2_prox",
        "dstar3", "dstar3_prox",
        "naish2", "naish2_prox"
    ]
    
    if "all" in target_metrics:
        target_metrics = AVAILABLE_METRICS
    else:
        invalid = [m for m in target_metrics if m not in AVAILABLE_METRICS]
        if invalid:
            print(f"\n[ERROR] Invalid metrics selected: {invalid}")
            print(f"Available metrics: {AVAILABLE_METRICS}")
            sys.exit(1)

    all_lines = set()
    total_failed = 0
    total_passed = 0
    
    for test, info in file_data.items():
        all_lines.update(info['coverage'])
        if info['passed']:
            total_passed += 1
        else:
            total_failed += 1
            
    results = {metric: [] for metric in target_metrics}
    
    decay_factor = 0.1 
    
    for line in all_lines:
        n_cf = 0
        n_cp = 0
        prox_weights = []
        
        for test, info in file_data.items():
            trace = info['coverage']
            
            if line in trace:
                if info['passed']:
                    n_cp += 1
                else:
                    n_cf += 1
                    
                    last_idx = len(trace) - 1 - trace[::-1].index(line)
                    distance = len(trace) - 1 - last_idx
                    
                    weight = math.exp(-decay_factor * distance)
                    prox_weights.append(weight)
                    
        n_uf = total_failed - n_cf
        n_us = total_passed - n_cp
        #avg_prox_weight = sum(prox_weights) / len(prox_weights) if prox_weights else 0.0
        #max_prox_weight = max(prox_weights) if prox_weights else 0.0
        weighted_n_cf = sum(prox_weights)
        weighted_n_uf = total_failed - weighted_n_cf

        # --- STANDARD OCHIAI ---
        denom_ochiai = math.sqrt(total_failed * (n_cf + n_cp))
        ochiai = (n_cf / denom_ochiai) if denom_ochiai > 0 else 0.0
        
        # --- PROXIMITY-WEIGHTED OCHIAI ---
        squared_weighted_n_cf = sum(w ** 2 for w in prox_weights)
        denom_ochiai_prox = math.sqrt(total_failed * (squared_weighted_n_cf + n_cp))
        ochiai_prox = (weighted_n_cf / denom_ochiai_prox) if denom_ochiai_prox > 0 else 0.0

        # --- TARANTULA ---
        fail_ratio = (n_cf / total_failed) if total_failed > 0 else 0.0
        pass_ratio = (n_cp / total_passed) if total_passed > 0 else 0.0
        denom_tarantula = fail_ratio + pass_ratio
        tarantula = (fail_ratio / denom_tarantula) if denom_tarantula > 0 else 0.0

        # --- PROXIMITY-WEIGHTED TARANTULA ---
        fail_ratio = (weighted_n_cf / total_failed) if total_failed > 0 else 0.0
        pass_ratio = (n_cp / total_passed) if total_passed > 0 else 0.0
        denom_tarantula = fail_ratio + pass_ratio
        tarantula_prox = (fail_ratio / denom_tarantula) if denom_tarantula > 0 else 0.0
        
        # --- DSTAR2 ---
        denom_dstar = n_cp + n_uf
        dstar2 = ((n_cf ** 2) / denom_dstar) if denom_dstar > 0 else 9e10

        # --- PROXIMITY-WEIGHTED DSTAR2 ---
        denom_dstar_prox = n_cp + weighted_n_uf
        dstar2_prox = ((weighted_n_cf ** 2) / denom_dstar_prox) if denom_dstar_prox > 0 else 9e10

        # --- DSTAR3 ---
        dstar3 = ((n_cf ** 3) / denom_dstar) if denom_dstar > 0 else 9e10

        # --- PROXIMITY-WEIGHTED DSTAR3 ---
        dstar3_prox = ((weighted_n_cf ** 3) / denom_dstar_prox) if denom_dstar_prox > 0 else 9e10

        # --- STANDARD NAISH2 ---
        penalty = n_cp / (total_passed + 1.0)
        naish2 = (total_failed + 1.0) - penalty if n_cf == total_failed else n_cf - penalty
                    
        # --- PROXIMITY-WEIGHTED NAISH2 ---
        if n_cf == total_failed:
            naish2_prox = total_failed + weighted_n_cf - penalty
        else:
            naish2_prox = weighted_n_cf - penalty

        if "ochiai" in results: results["ochiai"].append({"line": line, "score": ochiai})
        if "ochiai_prox" in results: results["ochiai_prox"].append({"line": line, "score": ochiai_prox})
        if "tarantula" in results: results["tarantula"].append({"line": line, "score": tarantula})
        if "tarantula_prox" in results: results["tarantula_prox"].append({"line": line, "score": tarantula_prox})
        if "dstar2" in results: results["dstar2"].append({"line": line, "score": dstar2})
        if "dstar2_prox" in results: results["dstar2_prox"].append({"line": line, "score": dstar2_prox})
        if "dstar3" in results: results["dstar3"].append({"line": line, "score": dstar3})
        if "dstar3_prox" in results: results["dstar3_prox"].append({"line": line, "score": dstar3_prox})
        if "naish2" in results: results["naish2"].append({"line": line, "score": naish2})
        if "naish2_prox" in results: results["naish2_prox"].append({"line": line, "score": naish2_prox})
                
        
    for metric in results:
        results[metric].sort(key=lambda x: (-x['score'], x['line']))
        
    return results

def run_coverage_fast(dafny_file, dafny_cmd):
    """The fast path: Attempts to run all tests in the file at once in a sandbox."""
    
    with tempfile.TemporaryDirectory() as temp_dir:
        filename = os.path.basename(dafny_file)
        temp_dfy_path = os.path.join(temp_dir, filename)
        shutil.copyfile(dafny_file, temp_dfy_path)
        
        cmd = [
            dafny_cmd, "test", temp_dfy_path, 
            RUNTIME_PATH, EXTERN_PATH,
            f"--plugin:{PLUGIN_PATH},max_iter=5000",
            "--no-verify", "--allow-warnings",
            f"--solver-option:O:memory_max_size={DAFNY_MAX_MEMORY_MB}"
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=temp_dir, timeout=TIMEOUT)
            output = result.stdout + result.stderr
        except FileNotFoundError:
            print(f"\n[ERROR] Could not find executable at: '{dafny_cmd}'")
            sys.exit(1)
        except subprocess.TimeoutExpired as e:
            output = ""
            if e.stdout:
                output += e.stdout.decode('utf-8', errors='ignore')
            if e.stderr:
                output += e.stderr.decode('utf-8', errors='ignore')
            print(f"\n[ERROR] Timedout: '{filename}'")
            return None

    if "Unhandled exception" in output or (result.returncode != 0 and "COVERAGE_LINE" not in output):
        return None

    coverage_data = {}
    current_test = None

    for line in output.splitlines():
        line = line.strip()
        
        if "--- RUNNING TEST:" in line:
            current_test = line.split("--- RUNNING TEST: ")[1].split(" ---")[0]
            coverage_data[current_test] = {"passed": True, "coverage": []}
            
        elif line.startswith("COVERAGE_LINE:") and current_test:
            line_num = int(line.split(":")[1].strip())
            coverage_data[current_test]["coverage"].append(line_num)
            
        elif line == "FAILED" and current_test:
            coverage_data[current_test]["passed"] = False

    formatted_data = {}
    for test_name, info in coverage_data.items():
        formatted_data[test_name] = {
            "passed": info["passed"],
            "coverage": info["coverage"]
        }

    return formatted_data

def run_coverage_isolated(dafny_file, dafny_cmd):
    """The slow path: Isolates each test to survive native crashes."""
    with open(dafny_file, 'r', encoding='utf-8') as f:
        code = f.read()

    test_pattern = re.compile(r'method\s+\{:test\}\s*([a-zA-Z0-9_]+)')
    test_names = test_pattern.findall(code)
    formatted_data = {}

    if not test_names:
        return formatted_data

    with tempfile.TemporaryDirectory() as temp_dir:
        for test_name in test_names:
            temp_code = re.sub(r'\{:test\}', '/* disabled */', code)
            temp_code = re.sub(rf'/\*\s*disabled\s*\*/(\s*{test_name}\b)', r'{:test}\1', temp_code)

            filename = os.path.basename(dafny_file).replace('.dfy', f'_{test_name}.dfy')
            temp_dfy_path = os.path.join(temp_dir, filename)

            with open(temp_dfy_path, 'w', encoding='utf-8') as f:
                f.write(temp_code)

            cmd = [
                dafny_cmd, "test", temp_dfy_path, 
                RUNTIME_PATH, EXTERN_PATH,
                "--plugin", PLUGIN_PATH, 
                "--no-verify", "--allow-warnings",
                f"--solver-option:O:memory_max_size={DAFNY_MAX_MEMORY_MB}"
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=temp_dir)
            output = result.stdout + result.stderr

            passed = False
            crashed = False
            coverage = []

            if result.returncode != 0 or "Unhandled exception" in output:
                crashed = True

            for line in output.splitlines():
                line = line.strip()
                if line.startswith("COVERAGE_LINE:"):
                    line_num = int(line.split(":")[1].strip())
                    coverage.append(line_num)
                elif line == "PASS":
                    passed = True
                elif line == "FAILED":
                    passed = False

            formatted_data[test_name] = {
                "passed": passed and not crashed,
                "coverage": coverage
            }

    return formatted_data

def run_coverage_on_file(dafny_file, dafny_cmd):
    """Wrapper that tries the fast path, and falls back to isolation if needed."""
    
    data = run_coverage_fast(dafny_file, dafny_cmd)
    
    if data is None:
        filename = os.path.basename(dafny_file)
        tqdm.write(f"  [CRASH] {filename}: Falling back to test isolation...")
        data = run_coverage_isolated(dafny_file, dafny_cmd)
        
    return data

def _process_single_file_wrapper(filename, folder_path, dafny_cmd):
    """Helper wrapper to maintain the association between filename and its coverage."""
    file_path = os.path.join(folder_path, filename)
    coverage = run_coverage_on_file(file_path, dafny_cmd)
    return filename, coverage

def process_folder(folder_path, dafny_cmd):
    """Scans a folder, processes all .dfy files in parallel, and returns the aggregated JSON dict."""
    aggregated_results = {}
    files = [f for f in os.listdir(folder_path) if f.endswith('.test.dfy')]
    
    if not files:
        print(f"[SKIP] No .dfy files found in '{folder_path}'")
        return {} 

    folder_name = os.path.basename(folder_path)
    
    results = run_parallel_or_seq(
        files, 
        _process_single_file_wrapper, 
        f"  Analyzing {folder_name}", 
        folder_path, 
        dafny_cmd, 
        parallel=True
    )
    
    for filename, file_coverage in results:
        if file_coverage:
            aggregated_results[filename] = file_coverage
        
    return aggregated_results

    
def main() -> None:
    parser = argparse.ArgumentParser(description="Process Dafny coverage and calculate SBFL metrics.")
    parser.add_argument(
        '--metrics', 
        nargs='+', 
        default=["all"], 
        help="List of metrics to run. Default is 'all'. Options: ochiai, ochiai_prox, tarantula, tarantula_prox, dstar2, dstar2_prox, dstar3, dstar3_prox, naish2, naish2_prox"
    )
    args = parser.parse_args()
    
    os.makedirs(RESULTS_ROOT, exist_ok=True)

    subfolders = [f.path for f in os.scandir(DATASET_ROOT) if f.is_dir()]
    
    if not subfolders:
        print(f"\n[ERROR] No subfolders found inside '{DATASET_ROOT}'.")
        sys.exit(1)

    print(f"Found {len(subfolders)} folders to process in: {DATASET_ROOT}\n")
    print(f"Running metrics: {', '.join(args.metrics)}\n")
    
    folder_stats = {}

    for folder in subfolders:
        folder_name = os.path.basename(folder)
        print(f"=== Processing Folder: {folder_name} ===")

        strategy_name = folder_name.removeprefix('tests_')
        
        start_time = time.time()
        
        coverage_output_file = os.path.join(RESULTS_ROOT, f"{strategy_name}_coverage.json")
        coverage_data = None
                
        # Check if coverage data already exists for this strategy
        if os.path.exists(coverage_output_file):
            print(f"  -> Existing coverage file found. Loading: {coverage_output_file}")
            try:
                with open(coverage_output_file, 'r') as infile:
                    coverage_data = json.load(infile)
            except json.JSONDecodeError:
                print(f"  -> [ERROR] Failed to read {coverage_output_file}. Recalculating...")
                coverage_data = None

        # If it doesn't exist (or failed to load), calculate it
        if coverage_data is None:
            coverage_data = process_folder(folder, DAFNY_BINARY)
            
            if coverage_data:
                with open(coverage_output_file, "w") as outfile:
                    json.dump(coverage_data, outfile, indent=2)
                print(f"  -> Saved {len(coverage_data)} coverage files to: {coverage_output_file}")
        
        num_files_saved = 0
        if coverage_data:
            num_files_saved = len(coverage_data)
            
            print(f"  -> Computing SBFL metrics...")
            sbfl_results = {}
            for filename, test_data in coverage_data.items():
                sbfl_results[filename] = calculate_file_metrics(test_data, args.metrics)

            sbfl_output_file = os.path.join(RESULTS_ROOT, f"{strategy_name}_results.json")
            with open(sbfl_output_file, "w") as outfile:
                json.dump(sbfl_results, outfile, indent=2)
            print(f"  -> Saved SBFL metrics to: {sbfl_output_file}\n")
            
        else:
            print(f"  -> No data to save for {folder_name}\n")

        end_time = time.time()
        
        folder_stats[folder_name] = {
            "time": end_time - start_time,
            "files": num_files_saved
        }

    print("--------------------------------------------------")
    print(" EXECUTION SUMMARY")
    print("--------------------------------------------------")
    for folder_name, stats in folder_stats.items():
        print(f" [{folder_name}]")
        print(f"    -> Time:  {stats['time'] / 60:.4f} minutes")
        print(f"    -> Files: {stats['files']} files stored in {folder_name.removeprefix('tests_')}_coverage.json & results.json")

if __name__ == "__main__":
    main()