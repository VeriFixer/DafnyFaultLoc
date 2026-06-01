import subprocess
import sys
import os
import argparse
import json
import tempfile
import shutil

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

PLUGIN_PATH = os.path.abspath(os.path.join(
    SCRIPT_DIR, "coverage", "src", "bin", "Release", "net8.0", "DafnyTestCoverage.dll"
))

def run_coverage_on_file(dafny_file, dafny_cmd):
    """Runs Dafny coverage on a single file securely inside a temporary folder."""
    
    with tempfile.TemporaryDirectory() as temp_dir:
        filename = os.path.basename(dafny_file)
        temp_dfy_path = os.path.join(temp_dir, filename)
        shutil.copyfile(dafny_file, temp_dfy_path)
        
        cmd = [
            dafny_cmd, "test", temp_dfy_path, 
            "--plugin", PLUGIN_PATH, 
            "--no-verify"
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
        print("--- RAW DAFNY OUTPUT FOR DEBUGGING ---")
        print(output)
        print("--------------------------------------\n")
        return {}

    formatted_data = {}
    for test_name, info in coverage_data.items():
        formatted_data[test_name] = {
            "passed": info["passed"],
            "coverage": list(info["coverage"])
        }

    return formatted_data


def process_folder(folder_path, dafny_cmd):
    """Scans a folder, processes all .dfy files, and returns the aggregated JSON dict."""
    aggregated_results = {}
    
    files = [f for f in os.listdir(folder_path) if f.endswith('.dfy')]
    
    if not files:
        print(f"No .dfy files found in '{folder_path}'")
        sys.exit(0)

    for i, filename in enumerate(files, 1):
        file_path = os.path.join(folder_path, filename)
        print(f"[{i}/{len(files)}] Analyzing {filename}...")
        
        file_coverage = run_coverage_on_file(file_path, dafny_cmd)
        
        if file_coverage:
            aggregated_results[filename] = file_coverage
        
    return aggregated_results


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Dafny Batch Coverage Generator")
    parser.add_argument("input_folder", help="Folder containing the Dafny test files")
    parser.add_argument("--output", default="coverage.json", help="Path to save the output JSON")
    parser.add_argument("--dafny", default="/Users/Sofia/dafny/Binaries/dafny", help="Path to your dafny executable")
    
    args = parser.parse_args()
    
    if not os.path.isdir(args.input_folder):
        print(f"Error: Directory '{args.input_folder}' not found.")
        sys.exit(1)

    if os.path.isdir(args.dafny):
        potential_executable = os.path.join(args.dafny, "dafny")
        if os.path.exists(potential_executable):
            args.dafny = potential_executable
        else:
            print(f"Error: '{args.dafny}' is a folder missing a 'dafny' executable.")
            sys.exit(1)

    print(f"Starting batch coverage on folder: {args.input_folder}\n")
    final_json_data = process_folder(args.input_folder, args.dafny)
    
    with open(args.output, "w") as outfile:
        json.dump(final_json_data, outfile, indent=2)
        
    print(f"\n✅ Success! Coverage data saved to: {args.output}")