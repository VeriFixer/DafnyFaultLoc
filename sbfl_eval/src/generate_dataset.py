import os
import json
import shutil
import re
from src.config import (
    DATASET_ROOT,
    TEST_GEN_GROUND_TRUTH_ROOT,
    TEST_GEN_DATASET_OUT_ROOT,
    TEST_GEN_RESULTS_ROOT,
    BLOCK_REP,
    PATH_REP,
    SPEC_REP,
    SPEC_BVA_REP
)

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
    Copies a test file but truncates it at the specified repetition cutoff.
    If the file has fewer repetitions than the cutoff, it is copied entirely.
    """
    repeat_pattern = re.compile(r'//\s*REPEAT\s+(\d+)\s*-\s*TIME:')
    
    with open(src_path, 'r', encoding='utf-8') as src_file:
        lines = src_file.readlines()
        
    out_lines = []
    for line in lines:
        match = repeat_pattern.search(line)
        if match:
            current_rep = int(match.group(1))
            
            if current_rep == cutoff_rep:
                out_lines.append(line)
                break
                
        out_lines.append(line)
        
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
    
    ground_truth_src = os.path.join(TEST_GEN_GROUND_TRUTH_ROOT, "ground_truth.json")
    ground_truth_dest = os.path.join(DATASET_ROOT, "ground_truth.json")
    
    if os.path.exists(ground_truth_src):
        shutil.copy2(ground_truth_src, ground_truth_dest)
        print(f"✓ Copied ground_truth.json to {DATASET_ROOT}")
    else:
        print(f"⚠ Warning: {ground_truth_src} not found.")

    print("Scanning for shared programs across all strategies (max_rep=10)...")
    shared_programs = get_shared_programs_for_combo(
        base_dir=TEST_GEN_RESULTS_ROOT, 
        strategies=strategies_list, 
        max_rep=10
    )
    print(f"✓ Found {len(shared_programs)} highly-compatible programs.")

    for strategy, cutoff in strategy_cutoffs.items():
        src_folder = os.path.join(TEST_GEN_DATASET_OUT_ROOT, f"tests_{strategy}")
        dest_folder = os.path.join(DATASET_ROOT, f"tests_{strategy}")
        
        if not os.path.exists(src_folder):
            print(f"⚠ Warning: Folder {src_folder} not found. Skipping strategy '{strategy}'.")
            continue
            
        processed_count = 0
        for file_name in os.listdir(src_folder):
            prog_name = file_name.replace(".test.dfy", "") 
            
            if prog_name in shared_programs:
                src_file_path = os.path.join(src_folder, file_name)
                dest_file_path = os.path.join(dest_folder, file_name)
                
                copy_and_truncate_test_file(src_file_path, dest_file_path, cutoff)
                processed_count += 1
                
        print(f"✓ Processed {processed_count} files for 'tests_{strategy}' (Cutoff: Rep {cutoff})")

if __name__ == "__main__":
    main()