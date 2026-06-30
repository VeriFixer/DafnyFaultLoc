import json
import os
import glob
import json
import csv
import os
import sys
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
    "SpecBva": "#d62728"
}

STRATEGY_MARKERS = {
    "Block": "o",
    "Path": "s",
    "Spec": "^",
    "SpecBva": "D"
}

LABEL_MAP = {
    "tests_block": "Block",
    "tests_path": "Path",
    "tests_spec": "Spec",
    "tests_spec_bva": "SpecBva"
}

def clean_label(raw_label):
    return LABEL_MAP.get(raw_label, raw_label)

def get_method_body_lines(content, attribute_idx):
    """Reuses the logic to find the size of the implementation."""
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

def get_qualified_files(folder_path, threshold=5):
    """Scans one folder to build a set of files that meet the size criteria."""
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

def main():
    ref_folder = os.path.join(DATASET_ROOT, "tests_block") 
    qualified_programs = get_qualified_files(ref_folder, threshold=8)
    
    print(f"Filtering: Only including {len(qualified_programs)} programs with >= 8 lines.")

    result_files = [f for f in os.listdir(RESULTS_ROOT) if f.endswith('_results.json')]
    
    if not result_files:
        print(f"Error: No files ending in '_results.json' found in {RESULTS_ROOT}.")
        sys.exit(1)

    raw_labels = [f.replace('_results.json', '') for f in result_files]
    raw_labels.sort(key=lambda x: clean_label(x))
    file_paths = [os.path.join(RESULTS_ROOT, f"{lbl}_results.json") for lbl in raw_labels]  # fix #2


    print(f"Found {len(raw_labels)} approaches: {', '.join([clean_label(lbl) for lbl in raw_labels])}")

    with open(os.path.join(DATASET_ROOT, "ground_truth.json"), 'r') as f: 
        truth_data = json.load(f)

    metrics = ["ochiai", "tarantula", "dstar"]
    ranks = {label: {m: [] for m in metrics} for label in raw_labels}
    exams = {label: {m: [] for m in metrics} for label in raw_labels}
    stats = {label: {} for label in raw_labels}

    zero_fails = {label: 0 for label in raw_labels}
    total_mutants = {label: 0 for label in raw_labels}

    for i, res_file in enumerate(file_paths):
        raw_label = raw_labels[i]
        with open(res_file, 'r') as f:
            data = json.load(f)
            
        for filename, true_bug_lines in truth_data.items():
            # FILTRATION STEP
            if filename.replace('.dfy', '.test.dfy') not in qualified_programs:
                continue
                
            results_key = filename.replace('.dfy', '.test.dfy')
            if results_key in data:
                total_mutants[raw_label] += 1
                
                # Check if the highest score is 0.0 (meaning 0 failing tests triggered)
                if data[results_key]["ochiai"] and data[results_key]["ochiai"][0]["score"] == 0.0:
                    zero_fails[raw_label] += 1
                    continue

                for metric in metrics:
                    r, e = get_fair_rank(data[results_key][metric], true_bug_lines)

                    bug_line_score = next((item['score'] for item in data[results_key][metric] if item['line'] in true_bug_lines), 0.0)

                    if r is not None: 
                        ranks[raw_label][metric].append(r)
                        exams[raw_label][metric].append(e)

    # --- CONSOLE OUTPUT: FAILING TEST STATS ---
    print("\n" + "="*50)
    print(" 📉 ZERO-FAILURE MUTANT STATISTICS")
    print("="*50)
    for raw_label in raw_labels:
        formatted_label = clean_label(raw_label)
        total = total_mutants[raw_label]
        zero = zero_fails[raw_label]
        pct = (zero / total) * 100 if total > 0 else 0
        print(f"{formatted_label:<12}: {zero:<4} out of {total:<4} mutants ({pct:.1f}%) had 0 failing tests. (Valid = {(total-zero):<4})")

    # --- CONSOLE OUTPUT & STATS CALCULATION ---
    print("\n" + "="*100)
    print(f" 🐛 SBFL APPROACH COMPARISON ({len(raw_labels)} Methods)")
    print("="*100)
    print(f"{'Metric':<14} | {'Approach':<15} | {'Top-1 (%)':<9} | {'Top-3 (%)':<9} | {'Top-5 (%)':<9} | {'MRR':<7} | {'Avg Rank':<8} | {'EXAM (%)':<8}")
    print("-" * 100)

    for metric in metrics:
        for raw_label in raw_labels:
            s = calculate_stats(ranks[raw_label][metric], exams[raw_label][metric])
            stats[raw_label][metric] = s
            
            m_label = metric.capitalize() if raw_label == raw_labels[0] else ""
            formatted_label = clean_label(raw_label)
            
            print(f"{m_label:<14} | {formatted_label:<15} | {s['top_1_pct']:<9.1f} | {s['top_3_pct']:<9.1f} | {s['top_5_pct']:<9.1f} | {s['mrr']:<7.3f} | {s['avg_rank']:<8.2f} | {s['avg_exam']:<8.2f}")
        print("-" * 100)

if __name__ == "__main__":
    main()