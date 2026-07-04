import os
import json
import re
import glob
import argparse

from src.utils.config import (
    DATASET_ROOT,
    TEST_GEN_DATASET_ROOT,
    TEST_GEN_DATASET_OUT_ROOT,
    TEST_GEN_RESULTS_ROOT,
    COVERAGE_ROOT,
    TEST_GEN_FORMATTED_ROOT
)


def is_line_executable(line_text):
    text = line_text.strip()
    if not text:
        return False
    if text == '{' or text == '}':
        return False
    if text.startswith('//'):
        return False
    return True


def get_method_body_lines(content, attribute_idx):
    line_end = content.find('\n', attribute_idx)
    if line_end == -1: line_end = len(content)
    
    open_idx = content.find('{', line_end)
    if open_idx == -1:
        return 0, len(content)

    brace_count = 0
    curr_idx = open_idx
    
    while curr_idx < len(content):
        if content[curr_idx] == '{':
            brace_count += 1
        elif content[curr_idx] == '}':
            brace_count -= 1
            if brace_count == 0:
                break
        curr_idx += 1
    
    body = content[open_idx + 1 : curr_idx]
    
    count = 0
    for line in body.splitlines():
        if is_line_executable(line):
            count += 1
            
    return count, curr_idx


def get_qualified_mutants(base_out_dir, strategies, threshold=8):
    """
    Scans the mutant output folders and returns a set of specific mutant names 
    (e.g., 'ProgramA__mutant1') that reach the executable line threshold.
    """
    qualified = set()
    for strat in strategies:
        folder_path = os.path.join(base_out_dir, f"selected_programs_mutants_with_tests_{strat}", "all")
        if not os.path.exists(folder_path):
            continue
            
        dfy_files = glob.glob(os.path.join(folder_path, "*.test.dfy"))
        for f in dfy_files:
            mutant_name = os.path.basename(f).replace(".test.dfy", "")
            
            if mutant_name in qualified:
                continue
                
            with open(f, 'r', encoding='utf-8') as file:
                content = file.read()
                search_idx = 0
                max_len = 0
                while True:
                    idx = content.find("{:testEntry}", search_idx)
                    if idx == -1: break
                    size, new_idx = get_method_body_lines(content, idx)
                    max_len = max(max_len, size)
                    search_idx = new_idx
                
                if max_len >= threshold:
                    qualified.add(mutant_name)
                    
    return qualified


def process_ground_truth(src_path, dest_path):
    if not os.path.exists(src_path):
        print(f"[WARNING]: {src_path} not found.")
        return

    with open(src_path, 'r', encoding='utf-8') as f:
        gt_data = json.load(f)

    updated_gt = {}
    for mutant_key, bug_lines in gt_data.items():
        if not isinstance(bug_lines, list):
            bug_lines = [bug_lines]
        
        bug_lines = [max(1, line - 2) for line in bug_lines]
        orig_name = mutant_key.rsplit("__", 1)[0] + ".dfy"
        orig_path = os.path.join(TEST_GEN_FORMATTED_ROOT, orig_name)
        
        new_bug_lines = set(bug_lines)
        
        if os.path.exists(orig_path):
            with open(orig_path, 'r', encoding='utf-8') as f:
                file_lines = f.readlines()
                
            for target in bug_lines:
                idx = target - 1 
                
                if 0 <= idx < len(file_lines):
                    if not is_line_executable(file_lines[idx]):
                        for offset in range(1, 11):
                            if idx + offset < len(file_lines) and is_line_executable(file_lines[idx + offset]):
                                new_bug_lines.add(target + offset)
                                break
                            if idx - offset >= 0 and is_line_executable(file_lines[idx - offset]):
                                new_bug_lines.add(target - offset)
                                break
        else:
            print(f"[WARNING] Original file not found for trace checking: {orig_path}")
        
        updated_gt[mutant_key] = sorted(list(new_bug_lines))
        
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    with open(dest_path, 'w', encoding='utf-8') as f:
        json.dump(updated_gt, f, indent=4)
        
    print(f"Processed and saved smart ground_truth.json to {dest_path}")


def get_shared_programs_for_combo(base_dir, strategies, max_rep=10):
    all_encountered = set()
    unsupported_in_combo = set()
    
    for x in range(1, max_rep + 1):
        for strategy in strategies:
            strat_path = os.path.join(base_dir, f"results_{strategy}", f"results_{strategy}_rep_{x}.json")
            
            if os.path.exists(strat_path):
                with open(strat_path, 'r') as sf:
                    data = json.load(sf)
                
                timing_data = data.get("timing", {}).get("per_program", {})
                for prog in timing_data.keys():
                    all_encountered.add(prog.replace(".dfy", ""))
                
                not_supported_list = data.get("not_supported", [])
                for item in not_supported_list:
                    if isinstance(item, dict) and "program" in item:
                        unsupported_in_combo.add(item["program"].replace(".dfy", ""))

    shared_programs = all_encountered - unsupported_in_combo
    return shared_programs


def extract_failing_tests(content, failing_test_names):
    pattern = re.compile(r"^[ \t]*method\s+\{:(?:test)\}\s+(\w+)", re.MULTILINE)
    matches = list(pattern.finditer(content))
    
    if not matches:
        return content.strip(), []
        
    # The base program is everything before the very first test method starts
    base_program = content[:matches[0].start()].strip()
    failing_tests_code = []
    
    for match in matches:
        test_name = match.group(1)
        if test_name in failing_test_names:
            # Start looking for the opening brace AFTER the method name
            open_brace_idx = content.find('{', match.end())
            if open_brace_idx == -1:
                continue
                
            brace_count = 0
            curr_idx = open_brace_idx
            
            while curr_idx < len(content):
                if content[curr_idx] == '{':
                    brace_count += 1
                elif content[curr_idx] == '}':
                    brace_count -= 1
                    if brace_count == 0:
                        break
                curr_idx += 1
                
            # Extract from the very start of the match (e.g. `method {:test}...`) up to the closing brace
            test_code = content[match.start():curr_idx+1]
            failing_tests_code.append(test_code)
            break # Get only the first failing test
            
    return base_program, failing_tests_code

def copy_and_filter_test_file(src_path, dest_path, failing_test_names):
    with open(src_path, 'r', encoding='utf-8') as src_file:
        lines = src_file.readlines()
        
    out_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Clean Z3 Prover errors
        if line.startswith("Prover error:"):
            i += 1
            if i < len(lines) and lines[i].strip() == "":
                i += 1
            continue 

        # Clean Comments
        if line.startswith("//"):
            i += 1
            if i < len(lines) and lines[i].strip() == "":
                i += 1
            continue 
                
        out_lines.append(line)
        i += 1
        
    content = "".join(out_lines)
    
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    
    with open(dest_path, 'w', encoding='utf-8') as dest_file:
        dest_file.write(content)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    """Parse CLI arguments."""
    parser = argparse.ArgumentParser(
        description="Generate dataset of shared Dafny programs with failing tests."
    )   
    parser.add_argument(
        "--strategies",
        nargs='+',
        type=str,
        help="Comma-separated strategy mode names to run, or 'all' (default: all)",
    )
    parser.add_argument(
        "--min-lines",
        type=int,
        default=8,
        help="Minimum number of lines of a mutants implementation (default = 8)",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> None:
    args = parse_args(argv)

    if args.strategies:
        strategies_list = args.strategies
    else:
        strategies_list = []
        if os.path.exists(COVERAGE_ROOT):
            for file_name in os.listdir(COVERAGE_ROOT):
                if file_name.endswith("_coverage.json"):
                    strategy_name = file_name.replace("_coverage.json", "")
                    strategies_list.append(strategy_name)
        
        if not strategies_list:
            print(f"[ERROR] No strategies provided and no *_coverage.json files found in {COVERAGE_ROOT}.")
            return

    print(f"Running with strategies: {strategies_list}")
    os.makedirs(DATASET_ROOT, exist_ok=True)
    
    # 1. Process Ground Truth
    ground_truth_src = os.path.join(TEST_GEN_DATASET_ROOT, "ground_truth.json")
    ground_truth_dest = os.path.join(DATASET_ROOT, "ground_truth.json")
    process_ground_truth(ground_truth_src, ground_truth_dest)

    # 2. Apply Shared Programs (Base level)
    print("Scanning for shared programs across all strategies...")
    shared_programs = get_shared_programs_for_combo(TEST_GEN_RESULTS_ROOT, strategies_list, max_rep=10)
    print(f"Found {len(shared_programs)} base programs compatible across all strategies.")

    # 3. Apply Threshold Filtering (Mutant level)
    print("Scanning mutants for executable lines threshold (>= 8) in the generated tests...")
    qualified_mutants = get_qualified_mutants(TEST_GEN_DATASET_OUT_ROOT, strategies_list, threshold=args.min_lines)
    print(f"Found {len(qualified_mutants)} mutants meeting the threshold across all strategies.")

    # 4. Process and Export the Filtered Tests per Strategy
    for strategy in strategies_list:
        coverage_path = os.path.join(COVERAGE_ROOT, f"{strategy}_coverage.json")
        coverage_data = {}
        
        if os.path.exists(coverage_path):
            with open(coverage_path, 'r', encoding='utf-8') as f:
                coverage_data = json.load(f)
            print(f"Loaded {strategy} coverage data for {len(coverage_data)} files.")
        else:
            print(f"[WARNING] Coverage file not found at {coverage_path}. Skipping tests extraction for '{strategy}'.")
            continue

        src_folder = os.path.join(TEST_GEN_DATASET_OUT_ROOT, f"selected_programs_mutants_with_tests_{strategy}", "all")
        dest_folder = os.path.join(DATASET_ROOT, f"tests_{strategy}")
        
        if not os.path.exists(src_folder):
            print(f"[WARNING]: Folder {src_folder} not found. Skipping strategy '{strategy}'.")
            continue
            
        processed_count = 0
        for file_name in os.listdir(src_folder):
            if not file_name.endswith(".test.dfy"):
                continue

            mutant_name = file_name.replace(".test.dfy", "")
            prog_name = mutant_name.rsplit("__", 1)[0]
            
            # The base program must be shared AND this specific mutant must meet the length threshold
            if prog_name in shared_programs and mutant_name in qualified_mutants:
                src_file_path = os.path.join(src_folder, file_name)
                dest_file_path = os.path.join(dest_folder, file_name)
                
                file_coverage = coverage_data.get(file_name, {})
                failing_tests = [t_name for t_name, t_info in file_coverage.items() if not t_info.get("passed", True)]
                
                copy_and_filter_test_file(src_file_path, dest_file_path, failing_tests)
                processed_count += 1
                
        print(f"Processed {processed_count} files for 'tests_{strategy}'")

if __name__ == "__main__":
    main()