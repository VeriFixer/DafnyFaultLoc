import os
import json
import shutil
import re
from src.utils.config import (
    DATASET_ROOT,
    TEST_GEN_DATASET_ROOT,
    TEST_GEN_DATASET_OUT_ROOT,
    TEST_GEN_RESULTS_ROOT,
    BLOCK_REP,
    PATH_REP,
    SPEC_REP,
    SPEC_BVA_REP,
    TEST_GEN_FORMATTED_ROOT
)

def is_line_executable(line_text):
    """
    Heuristic to determine if a line in Dafny translates to executable code.
    Ignores empty lines, solitary braces, and line comments.
    """
    text = line_text.strip()
    if not text:
        return False
    if text == '{' or text == '}':
        return False
    if text.startswith('//'):
        return False
    return True

def process_ground_truth(src_path, dest_path):
    """
    Reads the ground truth, maps it to the original files, and adds the nearest 
    executable line if the annotated bug line is non-executable (e.g. a bracket).
    """
    if not os.path.exists(src_path):
        print(f"[WARNING]: {src_path} not found.")
        return

    with open(src_path, 'r', encoding='utf-8') as f:
        gt_data = json.load(f)

    updated_gt = {}
    for mutant_key, bug_lines in gt_data.items():
        if not isinstance(bug_lines, list):
            bug_lines = [bug_lines]
        
        orig_name = mutant_key.rsplit("__", 1)[0] + ".dfy"
        orig_path = os.path.join(TEST_GEN_FORMATTED_ROOT, orig_name)
        
        new_bug_lines = set(bug_lines)
        
        if os.path.exists(orig_path):
            with open(orig_path, 'r', encoding='utf-8') as f:
                file_lines = f.readlines()
                
            for target in bug_lines:
                idx = target - 1  # Convert 1-based line number to 0-based array index
                
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
        
        # Save back as a sorted list
        updated_gt[mutant_key] = sorted(list(new_bug_lines))
        
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    with open(dest_path, 'w', encoding='utf-8') as f:
        json.dump(updated_gt, f, indent=4)
        
    print(f"Processed and saved smart ground_truth.json to {dest_path}")

def get_shared_programs_for_combo(base_dir, strategies, max_rep):
    """
    Finds the exact set of programs that are supported by ALL strategies 
    in the given combination, across all X repetitions.
    """
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

def copy_and_truncate_test_file(src_path, dest_path, cutoff_rep):
    """
    Copies a test file, removes Z3 Prover errors, and truncates it at 
    the specified repetition cutoff.
    """
    repeat_pattern = re.compile(r'//\s*REPEAT\s+(\d+)\s*-\s*TIME:')
    
    with open(src_path, 'r', encoding='utf-8') as src_file:
        lines = src_file.readlines()
        
    out_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        if line.startswith("Prover error:"):
            i += 1
            
            if i < len(lines) and lines[i].strip() == "":
                i += 1
            continue 
            
        # 3. Handle truncation logic
        match = repeat_pattern.search(line)
        if match:
            current_rep = int(match.group(1))
            
            if current_rep == cutoff_rep:
                out_lines.append(line)
                break
                
        out_lines.append(line)
        i += 1
        
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    
    with open(dest_path, 'w', encoding='utf-8') as dest_file:
        dest_file.writelines(out_lines)

def main():
    strategy_cutoffs = {
        "block": BLOCK_REP,
        "path": PATH_REP,
        "spec": SPEC_REP,
        "spec_bva": SPEC_BVA_REP
    }
    
    strategies_list = list(strategy_cutoffs.keys())
    
    os.makedirs(DATASET_ROOT, exist_ok=True)
    
    ground_truth_src = os.path.join(TEST_GEN_DATASET_ROOT, "ground_truth.json")
    ground_truth_dest = os.path.join(DATASET_ROOT, "ground_truth.json")
    
    process_ground_truth(ground_truth_src, ground_truth_dest)

    print("Scanning for shared programs across all strategies (max_rep=10)...")
    shared_programs = get_shared_programs_for_combo(
        base_dir=TEST_GEN_RESULTS_ROOT, 
        strategies=strategies_list, 
        max_rep=10
    )
    print(f"Found {len(shared_programs)} programs compatible across all strategies.")

    for strategy, cutoff in strategy_cutoffs.items():
        src_folder = os.path.join(TEST_GEN_DATASET_OUT_ROOT, f"selected_programs_mutants_with_tests_{strategy}", "all")
        dest_folder = os.path.join(DATASET_ROOT, f"tests_{strategy}")
        
        if not os.path.exists(src_folder):
            print(f"[WARNING]: Folder {src_folder} not found. Skipping strategy '{strategy}'.")
            continue
            
        processed_count = 0
        for file_name in os.listdir(src_folder):
            if not file_name.endswith(".test.dfy"):
                continue

            prog_name = file_name.replace(".test.dfy", "").rsplit("__", 1)[0]
            
            if prog_name in shared_programs:
                src_file_path = os.path.join(src_folder, file_name)
                dest_file_path = os.path.join(dest_folder, file_name)
                
                copy_and_truncate_test_file(src_file_path, dest_file_path, cutoff)
                processed_count += 1
                
        print(f"Processed {processed_count} files for 'tests_{strategy}' (Cutoff: Rep {cutoff})")

if __name__ == "__main__":
    main()