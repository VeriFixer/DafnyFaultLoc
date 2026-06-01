import subprocess
import sys
import os
import argparse

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

PLUGIN_PATH = os.path.abspath(os.path.join(
    SCRIPT_DIR, "..", "src", "bin", "Release", "net8.0", "DafnyTestCoverage.dll"
))

def run_coverage(dafny_file, dafny_cmd):
    cmd = [
        dafny_cmd, "test", dafny_file, 
        "--plugin", PLUGIN_PATH, 
        "--no-verify"
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    output = result.stdout + result.stderr

    coverage_data = {}
    current_test = None

    for line in output.splitlines():
        line = line.strip()
        
        if "--- RUNNING TEST:" in line:
            current_test = line.split("--- RUNNING TEST: ")[1].split(" ---")[0]
            coverage_data[current_test] = {"lines": set(), "passed": True}
            
        elif line.startswith("COVERAGE_LINE:") and current_test:
            line_num = int(line.split(":")[1].strip())
            coverage_data[current_test]["lines"].add(line_num)
            
        elif line == "FAILED" and current_test:
            coverage_data[current_test]["passed"] = False

    if not coverage_data:
        print("\n[ERROR] No coverage data was found. Dafny likely failed to run.")
        print("--- RAW DAFNY OUTPUT FOR DEBUGGING ---")
        print(output)
        print("--------------------------------------")
        sys.exit(1)

    return coverage_data

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Dafny Code Coverage Runner")
    
    parser.add_argument("filename", help="The .dfy file you want to test")
    
    parser.add_argument("--dafny", default="dafny", 
                        help="Path to your dafny executable (default: 'dafny')")
    
    args = parser.parse_args()
    
    if not os.path.exists(args.filename):
        print(f"Error: File '{args.filename}' not found.")
        sys.exit(1)

    data = run_coverage(args.filename, args.dafny)
    
    print(f"\n--- COVERAGE SUMMARY FOR: {args.filename} ---")
    for test, info in data.items():
        status = "✅ PASS" if info['passed'] else "❌ FAIL"
        lines = sorted(list(info['lines']))
        print(f"{status} | {test}: Covered lines {lines}")