import json
import os
import glob
import sys
import math
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

from src.utils.config import (
    DATASET_ROOT,
    RESULTS_ROOT,
)

# ==========================================
# Configurations & Styling
# ==========================================
sns.set_theme(style="whitegrid", context="paper")
plt.rcParams.update({
    'font.size': 12,
    'axes.labelsize': 14,
    'axes.titlesize': 14,
    'legend.fontsize': 11,
    'xtick.labelsize': 11,
    'ytick.labelsize': 11,
    'figure.dpi': 300,
    'savefig.bbox': 'tight',
    'font.family': 'serif'
})

STRATEGY_COLORS = {
    "Block": "#1f77b4",
    "Path": "#ff7f0e",
    "Spec": "#2ca02c",
    "SpecBva": "#d62728",
    "SpecBva+Block": "#9467bd",
    "SpecBva+Path": "#8c564b",
    "Spec+Block": "#e377c2",
    "Spec+Path": "#7f7f7f"
}

STRATEGY_MARKERS = {
    "Block": "o",
    "Path": "s",
    "Spec": "^",
    "SpecBva": "D",
    "SpecBva+Block": "v",
    "SpecBva+Path": "p",
    "Spec+Block": "*",
    "Spec+Path": "X"
}

LABEL_MAP = {
    "tests_block": "Block",
    "tests_path": "Path",
    "tests_spec": "Spec",
    "tests_spec_bva": "SpecBva",
    "combined_spec_bva_block": "SpecBva+Block",
    "combined_spec_bva_path": "SpecBva+Path",
    "combined_spec_block": "Spec+Block",
    "combined_spec_path": "Spec+Path"
}

def clean_label(raw_label):
    return LABEL_MAP.get(raw_label, raw_label)

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
        clean_line = line.strip()
        if clean_line and clean_line != "{" and clean_line != "}" and not clean_line.startswith("//"):
            count += 1
            
    return count, curr_idx

def get_fair_rank(ranked_list, target_lines):
    if not isinstance(target_lines, list):
        target_lines = [target_lines]

    total_lines = len(ranked_list)
    for i, item in enumerate(ranked_list):
        if item['line'] in target_lines:
            score = item['score']
            block_start = i
            while block_start > 0 and ranked_list[block_start - 1]['score'] == score:
                block_start -= 1
            block_end = i
            while block_end < len(ranked_list) - 1 and ranked_list[block_end + 1]['score'] == score:
                block_end += 1
            
            fair_rank = sum(range(block_start + 1, block_end + 2)) / (block_end - block_start + 1)
            exam_score = fair_rank / total_lines if total_lines > 0 else 0
            return fair_rank, exam_score
            
    return None, None

def get_qualified_files(folder_path, threshold=8):
    qualified = set()
    dfy_files = glob.glob(os.path.join(folder_path, "*.dfy"))
    for f in dfy_files:
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
                qualified.add(os.path.basename(f))
    return qualified

def calculate_stats(ranks_list, exams_list):
    if not ranks_list:
        return {"top_1": 0, "top_1_pct": 0.0, "top_3": 0, "top_3_pct": 0.0, 
                "top_5": 0, "top_5_pct": 0.0, "mrr": 0.0, "avg_rank": 0.0, 
                "avg_exam": 0.0, "total": 0}
    
    total = len(ranks_list)
    top_1 = sum(1 for r in ranks_list if r <= 1.0)
    top_3 = sum(1 for r in ranks_list if r <= 3.0)
    top_5 = sum(1 for r in ranks_list if r <= 5.0)
    
    return {
        "top_1": top_1,
        "top_1_pct": (top_1 / total) * 100,
        "top_3": top_3,
        "top_3_pct": (top_3 / total) * 100,
        "top_5": top_5,
        "top_5_pct": (top_5 / total) * 100,
        "mrr": sum(1.0 / r for r in ranks_list) / total,
        "avg_rank": sum(ranks_list) / total,
        "avg_exam": sum(exams_list) / total * 100, 
        "total": total
    }

def calculate_sbfl_for_file(file_data):
    all_lines = set()
    total_failed = 0
    total_passed = 0
    
    for test, info in file_data.items():
        all_lines.update(info['coverage'])
        if info['passed']: total_passed += 1
        else: total_failed += 1
            
    results = {"ochiai": [], "tarantula": [], "dstar": []}
    if not all_lines: return results
    
    if total_failed == 0: 
        return results
        
    for line in all_lines:
        n_cf = 0
        n_cp = 0
        
        for test, info in file_data.items():
            if line in info['coverage']:
                if info['passed']: n_cp += 1
                else: n_cf += 1
                    
        n_uf = total_failed - n_cf
        
        denom_ochiai = math.sqrt(total_failed * (n_cf + n_cp))
        ochiai = (n_cf / denom_ochiai) if denom_ochiai > 0 else 0.0
        
        fail_ratio = (n_cf / total_failed) if total_failed > 0 else 0.0
        pass_ratio = (n_cp / total_passed) if total_passed > 0 else 0.0
        denom_tarantula = fail_ratio + pass_ratio
        tarantula = (fail_ratio / denom_tarantula) if denom_tarantula > 0 else 0.0
        
        denom_dstar = n_cp + n_uf
        dstar = ((n_cf ** 2) / denom_dstar) if denom_dstar > 0 else 0.0
        
        results["ochiai"].append({"line": line, "score": ochiai})
        results["tarantula"].append({"line": line, "score": tarantula})
        results["dstar"].append({"line": line, "score": dstar})
        
    for metric in results:
        results[metric].sort(key=lambda x: (-x['score'], x['line']))
        
    return results

def merge_coverages(cov1, cov2, label1, label2):
    merged = {}
    if cov1:
        for k, v in cov1.items(): merged[f"{k}_{label1}"] = v
    if cov2:
        for k, v in cov2.items(): merged[f"{k}_{label2}"] = v
    return merged

def main():
    ref_folder = os.path.join(DATASET_ROOT, "tests_block") 
    qualified_programs = get_qualified_files(ref_folder, threshold=8)
    
    print(f"Filtering: Only including {len(qualified_programs)} programs with >= 8 lines.")

    # 1. Load Standard Result Files
    result_files = [f for f in os.listdir(RESULTS_ROOT) if f.endswith('_results.json')]
    if not result_files:
        print(f"Error: No files ending in '_results.json' found in {RESULTS_ROOT}.")
        sys.exit(1)

    standard_labels = [f.replace('_results.json', '') for f in result_files]
    standard_labels.sort(key=lambda x: clean_label(x))
    
    # 2. Add Combined Labels
    combined_labels = [
        "combined_spec_bva_block", 
        "combined_spec_bva_path",
        "combined_spec_block",
        "combined_spec_path"
    ]
    all_labels = standard_labels + combined_labels

    print(f"Approaches to evaluate: {', '.join([clean_label(lbl) for lbl in all_labels])}")

    # Load Ground Truth
    with open(os.path.join(DATASET_ROOT, "ground_truth.json"), 'r') as f: 
        truth_data = json.load(f)

    metrics = ["ochiai", "tarantula", "dstar"]
    ranks = {label: {m: [] for m in metrics} for label in all_labels}
    exams = {label: {m: [] for m in metrics} for label in all_labels}
    stats = {label: {} for label in all_labels}
    zero_fails = {label: 0 for label in all_labels}
    total_mutants = {label: 0 for label in all_labels}

    # ==========================================
    # Dynamic Coverage Loader
    # ==========================================
    all_cov_data = {}
    for f in os.listdir(RESULTS_ROOT):
        if f.endswith('_coverage.json'):
            label = f.replace('_coverage.json', '')
            with open(os.path.join(RESULTS_ROOT, f), 'r') as fp:
                all_cov_data[label] = json.load(fp)

    # Find the specific keys dynamically
    key_bva = next((k for k in all_cov_data.keys() if "spec_bva" in k), None)
    key_spec = next((k for k in all_cov_data.keys() if "spec" in k and "bva" not in k), None)
    key_block = next((k for k in all_cov_data.keys() if "block" in k and "bva" not in k), None)
    key_path = next((k for k in all_cov_data.keys() if "path" in k and "bva" not in k), None)

    if not key_bva: print("⚠️ Warning: SpecBva coverage not found, SpecBva combinations will be empty!")
    if not key_spec: print("⚠️ Warning: Standard Spec coverage not found, Spec combinations will be empty!")
    if not key_block: print("⚠️ Warning: Block coverage not found, Block combinations will be empty!")
    if not key_path: print("⚠️ Warning: Path coverage not found, Path combinations will be empty!")

    # --- PROCESS STANDARD RESULTS ---
    for raw_label in standard_labels:
        res_file = os.path.join(RESULTS_ROOT, f"{raw_label}_results.json")
        with open(res_file, 'r') as f:
            data = json.load(f)
            
        for filename, true_bug_lines in truth_data.items():
            if filename.replace('.dfy', '.test.dfy') not in qualified_programs:
                continue
                
            results_key = filename.replace('.dfy', '.test.dfy')
            if results_key in data:
                total_mutants[raw_label] += 1
                
                # Check for zero fails
                metric_data = data[results_key]["ochiai"]
                if not metric_data or metric_data[0]["score"] == 0.0:
                    zero_fails[raw_label] += 1
                    continue

                for metric in metrics:
                    r, e = get_fair_rank(data[results_key][metric], true_bug_lines)
                    if r is not None: 
                        ranks[raw_label][metric].append(r)
                        exams[raw_label][metric].append(e)

    # --- PROCESS COMBINED RESULTS ---
    for filename, true_bug_lines in truth_data.items():
        if filename.replace('.dfy', '.test.dfy') not in qualified_programs:
            continue
            
        cov_key = filename.replace('.dfy', '.test.dfy')
        
        # Grab coverage info
        cov_bva = all_cov_data[key_bva].get(cov_key, {}) if key_bva else {}
        cov_spec = all_cov_data[key_spec].get(cov_key, {}) if key_spec else {}
        cov_block = all_cov_data[key_block].get(cov_key, {}) if key_block else {}
        cov_path = all_cov_data[key_path].get(cov_key, {}) if key_path else {}
        
        combos = {
            "combined_spec_bva_block": merge_coverages(cov_bva, cov_block, "bva", "block"),
            "combined_spec_bva_path": merge_coverages(cov_bva, cov_path, "bva", "path"),
            "combined_spec_block": merge_coverages(cov_spec, cov_block, "spec", "block"),
            "combined_spec_path": merge_coverages(cov_spec, cov_path, "spec", "path")
        }
        
        for label, merged_cov in combos.items():
            if not merged_cov:
                continue
                
            total_mutants[label] += 1
            scores = calculate_sbfl_for_file(merged_cov)
            
            # Skip if there were zero tests that failed the combined execution
            if not scores["ochiai"] or scores["ochiai"][0]["score"] == 0.0:
                zero_fails[label] += 1
                continue
                
            for metric in metrics:
                r, e = get_fair_rank(scores[metric], true_bug_lines)
                if r is not None:
                    ranks[label][metric].append(r)
                    exams[label][metric].append(e)

    # --- CONSOLE OUTPUT: FAILING TEST STATS ---
    print("\n" + "="*55)
    print(" 📉 ZERO-FAILURE MUTANT STATISTICS")
    print("="*55)
    for raw_label in all_labels:
        formatted_label = clean_label(raw_label)
        total = total_mutants[raw_label]
        zero = zero_fails[raw_label]
        pct = (zero / total) * 100 if total > 0 else 0
        print(f"{formatted_label:<15}: {zero:<4} out of {total:<4} mutants ({pct:.1f}%) had 0 failing tests. (Valid = {(total-zero):<4})")

    # --- CONSOLE OUTPUT & STATS CALCULATION ---
    print("\n" + "="*105)
    print(f" 🐛 SBFL APPROACH COMPARISON ({len(all_labels)} Methods)")
    print("="*105)
    print(f"{'Metric':<14} | {'Approach':<15} | {'Top-1 (%)':<9} | {'Top-3 (%)':<9} | {'Top-5 (%)':<9} | {'MRR':<7} | {'Avg Rank':<8} | {'EXAM (%)':<8}")
    print("-" * 105)

    for metric in metrics:
        for raw_label in all_labels:
            s = calculate_stats(ranks[raw_label][metric], exams[raw_label][metric])
            stats[raw_label][metric] = s
            
            m_label = metric.capitalize() if raw_label == all_labels[0] else ""
            formatted_label = clean_label(raw_label)
            
            print(f"{m_label:<14} | {formatted_label:<15} | {s['top_1_pct']:<9.1f} | {s['top_3_pct']:<9.1f} | {s['top_5_pct']:<9.1f} | {s['mrr']:<7.3f} | {s['avg_rank']:<8.2f} | {s['avg_exam']:<8.2f}")
        print("-" * 105)

if __name__ == "__main__":
    main()