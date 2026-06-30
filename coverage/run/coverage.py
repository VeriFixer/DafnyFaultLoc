import subprocess
import sys
import os
import argparse
import tempfile
import re

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

PLUGIN_PATH = os.path.abspath(os.path.join(
    SCRIPT_DIR, "..", "src", "bin", "Release", "net8.0", "DafnyTestCoverage.dll"
))

RUNTIME_PATH = os.path.abspath(os.path.join(
    SCRIPT_DIR, "..", "src", "CoverageRuntime.cs"
))

EXTERN_PATH = os.path.abspath(os.path.join(
    SCRIPT_DIR, "..", "src", "CoverageExterns.dfy"
))

def run_coverage(dafny_file, dafny_cmd):
    with open(dafny_file, 'r', encoding='utf-8') as f:
        code = f.read()

    # Find all test methods (ignoring testEntry)
    test_pattern = re.compile(r'method\s+\{:test\}\s*([a-zA-Z0-9_]+)')
    test_names = test_pattern.findall(code)

    coverage_data = {}

    if not test_names:
        print("\n[ERROR] No methods marked with {:test} were found.")
        sys.exit(1)

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
                "--no-verify"
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=temp_dir)
            output = result.stdout + result.stderr

            passed = False
            crashed = False
            lines = set()

            if result.returncode != 0 or "Unhandled exception" in output:
                crashed = True
                #print(f"  -> [{test_name}] Native exception caught. Marked as failed.")

            for line in output.splitlines():
                line = line.strip()
                if line.startswith("COVERAGE_LINE:"):
                    line_num = int(line.split(":")[1].strip())
                    lines.add(line_num)
                elif line == "PASS":
                    passed = True
                elif line == "FAILED":
                    passed = False

            coverage_data[test_name] = {
                "passed": passed and not crashed,
                "lines": lines
            }

    return coverage_data

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Dafny Code Coverage Runner")
    parser.add_argument("filename", help="The .dfy file you want to test")
    parser.add_argument("--dafny", default="dafny", help="Path to your dafny executable")
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