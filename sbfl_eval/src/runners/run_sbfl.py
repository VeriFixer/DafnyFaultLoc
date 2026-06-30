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

def calculate_file_metrics(file_data):
    """Calculates SBFL (Ochiai, Tarantula, DStar) metrics for a given file's coverage data."""
    all_lines = set()
    total_failed = 0
    total_passed = 0
    
    for test, info in file_data.items():
        all_lines.update(info['coverage'])
        if info['passed']:
            total_passed += 1
        else:
            total_failed += 1
            
    results = {"ochiai": [], "tarantula": [], "dstar": []}
    
    for line in all_lines:
        n_cf = 0
        n_cp = 0
        
        for test, info in file_data.items():
            if line in info['coverage']:
                if info['passed']:
                    n_cp += 1
                else:
                    n_cf += 1
                    
        n_uf = total_failed - n_cf
        n_us = total_passed - n_cp
        
        # --- OCHIAI ---
        denom_ochiai = math.sqrt(total_failed * (n_cf + n_cp))
        ochiai = (n_cf / denom_ochiai) if denom_ochiai > 0 else 0.0
        
        # --- TARANTULA ---
        fail_ratio = (n_cf / total_failed) if total_failed > 0 else 0.0
        pass_ratio = (n_cp / total_passed) if total_passed > 0 else 0.0
        denom_tarantula = fail_ratio + pass_ratio
        tarantula = (fail_ratio / denom_tarantula) if denom_tarantula > 0 else 0.0
        
        # --- DSTAR ---
        denom_dstar = n_cp + n_uf
        dstar = ((n_cf ** 2) / denom_dstar) if denom_dstar > 0 else 0.0
        
        results["ochiai"].append({"line": line, "score": ochiai})
        results["tarantula"].append({"line": line, "score": tarantula})
        results["dstar"].append({"line": line, "score": dstar})
        
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
            coverage_data[current_test] = {"passed": True, "coverage": set()}
            
        elif line.startswith("COVERAGE_LINE:") and current_test:
            line_num = int(line.split(":")[1].strip())
            coverage_data[current_test]["coverage"].add(line_num)
            
        elif line == "FAILED" and current_test:
            coverage_data[current_test]["passed"] = False

    formatted_data = {}
    for test_name, info in coverage_data.items():
        formatted_data[test_name] = {
            "passed": info["passed"],
            "coverage": sorted(list(info["coverage"]))
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
            coverage = set()

            if result.returncode != 0 or "Unhandled exception" in output:
                crashed = True

            for line in output.splitlines():
                line = line.strip()
                if line.startswith("COVERAGE_LINE:"):
                    line_num = int(line.split(":")[1].strip())
                    coverage.add(line_num)
                elif line == "PASS":
                    passed = True
                elif line == "FAILED":
                    passed = False

            formatted_data[test_name] = {
                "passed": passed and not crashed,
                "coverage": sorted(list(coverage))
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

    os.makedirs(RESULTS_ROOT, exist_ok=True)

    subfolders = [f.path for f in os.scandir(DATASET_ROOT) if f.is_dir()]
    
    if not subfolders:
        print(f"\n[ERROR] No subfolders found inside '{DATASET_ROOT}'.")
        sys.exit(1)

    print(f"Found {len(subfolders)} folders to process in: {DATASET_ROOT}\n")
    
    folder_stats = {}

    for folder in subfolders:
        folder_name = os.path.basename(folder)
        print(f"=== Processing Folder: {folder_name} ===")

        strategy_name = folder_name.removeprefix('tests_')
        
        start_time = time.time()
        
        coverage_data = process_folder(folder, DAFNY_BINARY)
        
        num_files_saved = 0
        if coverage_data:
            num_files_saved = len(coverage_data)
            
            coverage_output_file = os.path.join(RESULTS_ROOT, f"{strategy_name}_coverage.json")
            with open(coverage_output_file, "w") as outfile:
                json.dump(coverage_data, outfile, indent=2)
            print(f"  -> Saved {num_files_saved} coverage files to: {coverage_output_file}")

            print(f"  -> Computing SBFL metrics...")
            sbfl_results = {}
            for filename, test_data in coverage_data.items():
                sbfl_results[filename] = calculate_file_metrics(test_data)

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
        print(f"    -> Files: {stats['files']} files stored in {strategy_name}_coverage.json & {strategy_name}_results.json")


if __name__ == "__main__":
    main()