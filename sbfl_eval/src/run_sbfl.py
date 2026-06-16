import subprocess
import sys
import os
import argparse
import json
import tempfile
import shutil
import time
import math
from sbfl_eval.src.parallel_executor import run_parallel_or_seq

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

PLUGIN_PATH = os.path.abspath(os.path.join(
    SCRIPT_DIR, "..", "coverage", "src", "bin", "Release", "net8.0", "DafnyTestCoverage.dll"
))

RUNTIME_PATH = os.path.abspath(os.path.join(
    SCRIPT_DIR, "..", "coverage", "src", "CoverageRuntime.cs"
))

EXTERN_PATH = os.path.abspath(os.path.join(
    SCRIPT_DIR, "..", "coverage", "src", "CoverageExterns.dfy"
))

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
        
        # --- DSTAR (using * = 2 based on your original script) ---
        denom_dstar = n_cp + n_uf
        dstar = ((n_cf ** 2) / denom_dstar) if denom_dstar > 0 else 0.0
        
        results["ochiai"].append({"line": line, "score": ochiai})
        results["tarantula"].append({"line": line, "score": tarantula})
        results["dstar"].append({"line": line, "score": dstar})
        
    for metric in results:
        results[metric].sort(key=lambda x: (-x['score'], x['line']))
        
    return results

def run_coverage_on_file(dafny_file, dafny_cmd):
    """Runs Dafny coverage on a single file securely inside a temporary folder."""
    with tempfile.TemporaryDirectory() as temp_dir:
        filename = os.path.basename(dafny_file)
        temp_dfy_path = os.path.join(temp_dir, filename)
        shutil.copyfile(dafny_file, temp_dfy_path)
        
        cmd = [
            dafny_cmd, "test", temp_dfy_path, 
            RUNTIME_PATH, EXTERN_PATH,
            "--plugin", PLUGIN_PATH, 
            "--no-verify", "--allow-warnings"
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=temp_dir)
            output = result.stdout + result.stderr
        except FileNotFoundError:
            print(f"\n[ERROR] Could not find the Dafny executable at: '{dafny_cmd}'")
            sys.exit(1)

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

    if not coverage_data:
        print(f"\n[WARNING] No tests were run for '{os.path.basename(dafny_file)}'!")
        return {}

    formatted_data = {}
    for test_name, info in coverage_data.items():
        formatted_data[test_name] = {
            "passed": info["passed"],
            "coverage": sorted(list(info["coverage"]))
        }

    return formatted_data

def _process_single_file_wrapper(filename, folder_path, dafny_cmd):
    """Helper wrapper to maintain the association between filename and its coverage."""
    file_path = os.path.join(folder_path, filename)
    coverage = run_coverage_on_file(file_path, dafny_cmd)
    return filename, coverage

def process_folder(folder_path, dafny_cmd):
    """Scans a folder, processes all .dfy files in parallel, and returns the aggregated JSON dict."""
    aggregated_results = {}
    files = [f for f in os.listdir(folder_path) if f.endswith('.dfy')]
    
    if not files:
        print(f"[SKIP] No .dfy files found in '{folder_path}'")
        return {} 

    folder_name = os.path.basename(folder_path)
    
    # Offload to your parallel executor
    results = run_parallel_or_seq(
        files, 
        _process_single_file_wrapper, 
        f"  Analyzing {folder_name}", 
        folder_path, 
        dafny_cmd, 
        parallel=True
    )
    
    # Reconstruct the aggregated dictionary
    for filename, file_coverage in results:
        if file_coverage:
            aggregated_results[filename] = file_coverage
        
    return aggregated_results

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Dafny Batch Coverage & SBFL Generator")
    parser.add_argument("--input", default="dataset", help="Root folder containing subfolders of Dafny test files")
    parser.add_argument("--output", default="results", help="Directory to save the output JSONs")
    parser.add_argument("--dafny", default="dafny", help="Path to your dafny executable")
    
    args = parser.parse_args()
    
    if not os.path.isdir(args.input):
        print(f"Error: Directory '{args.input}' not found.")
        sys.exit(1)

    if os.path.isdir(args.dafny):
        potential_executable = os.path.join(args.dafny, "dafny")
        if os.path.exists(potential_executable):
            args.dafny = potential_executable
        else:
            print(f"Error: '{args.dafny}' is a folder missing a 'dafny' executable.")
            sys.exit(1)

    os.makedirs(args.output, exist_ok=True)

    subfolders = [f.path for f in os.scandir(args.input) if f.is_dir()]
    
    if not subfolders:
        print(f"Error: No subfolders found inside '{args.input}'.")
        sys.exit(1)

    print(f"Found {len(subfolders)} folders to process in: {args.input}\n")
    
    folder_stats = {}

    for folder in subfolders:
        folder_name = os.path.basename(folder)
        print(f"=== Processing Folder: {folder_name} ===")
        
        start_time = time.time()
        
        coverage_data = process_folder(folder, args.dafny)
        
        num_files_saved = 0
        if coverage_data:
            num_files_saved = len(coverage_data)
            
            # Save Coverage
            coverage_output_file = os.path.join(args.output, f"{folder_name}_coverage.json")
            with open(coverage_output_file, "w") as outfile:
                json.dump(coverage_data, outfile, indent=2)
            print(f"  -> Saved {num_files_saved} coverage files to: {coverage_output_file}")

            # Calculate and Save SBFL
            print(f"  -> Computing SBFL metrics...")
            sbfl_results = {}
            for filename, test_data in coverage_data.items():
                sbfl_results[filename] = calculate_file_metrics(test_data)

            sbfl_output_file = os.path.join(args.output, f"{folder_name}_results.json")
            with open(sbfl_output_file, "w") as outfile:
                json.dump(sbfl_results, outfile, indent=2)
            print(f"  -> Saved SBFL metrics to: {sbfl_output_file}\n")
            
        else:
            print(f"  -> No data to save for {folder_name}\n")

        end_time = time.time()
        
        # Save stats for the summary
        folder_stats[folder_name] = {
            "time": end_time - start_time,
            "files": num_files_saved
        }

    # Final summary output
    print("--------------------------------------------------")
    print(" EXECUTION SUMMARY")
    print("--------------------------------------------------")
    for folder_name, stats in folder_stats.items():
        print(f" [{folder_name}]")
        print(f"    -> Time:  {stats['time'] / 60:.4f} minutes")
        print(f"    -> Files: {stats['files']} files stored in {folder_name}_coverage.json & {folder_name}_results.json")