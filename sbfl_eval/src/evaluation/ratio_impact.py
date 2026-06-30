import json
import csv
import os
import sys
import matplotlib.pyplot as plt
import numpy as np

from src.utils.config import (
    DATASET_ROOT,
    RESULTS_ROOT,
    GRAPHS_ROOT,
    TABLES_ROOT
)

# ==========================================
# Configurations & Styling
# ==========================================
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
    "block": "Block",
    "path": "Path",
    "spec": "Spec",
    "spec_bva": "SpecBva"
}

def clean_label(raw_label):
    return LABEL_MAP.get(raw_label, raw_label)

def get_fair_rank(ranked_list, target_lines):
    if not isinstance(target_lines, list):
        target_lines = [target_lines]

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
            return fair_rank
    return None

def get_pass_fail_counts(coverage_file_path, possible_keys):
    if not os.path.exists(coverage_file_path):
        return None, None # Using None to indicate missing file
    
    with open(coverage_file_path, 'r') as f:
        cov_data = json.load(f)
        
    # Try multiple key formats to guarantee a match
    actual_key = None
    for key in possible_keys:
        if key in cov_data:
            actual_key = key
            break
            
    if not actual_key:
        return -1, -1 # Using -1 to indicate missing key
        
    passed = sum(1 for test in cov_data[actual_key].values() if test.get('passed') == True)
    failed = sum(1 for test in cov_data[actual_key].values() if test.get('passed') == False)
    
    return passed, failed

def get_ratio_bin(fail_ratio):
    if fail_ratio == 0:
        return "0% (No Fails)"
    elif fail_ratio <= 0.25:
        return "1-25%"
    elif fail_ratio <= 0.50:
        return "26-50%"
    elif fail_ratio <= 0.75:
        return "51-75%"
    else:
        return ">75%"

def main():
    if not os.path.isdir(RESULTS_ROOT):
        sys.exit(f"Error: Directory '{RESULTS_ROOT}' not found.")

    with open(os.path.join(DATASET_ROOT, "ground_truth.json"), 'r') as f: 
        truth_data = json.load(f)

    metric_to_analyze = "ochiai" 
    
    result_files = [f for f in os.listdir(RESULTS_ROOT) if f.endswith('_results.json')]
    labels = [f.replace('_results.json', '') for f in result_files]

    bin_labels = ["1-25%", "26-50%", "51-75%", ">75%"]
    analysis_data = {label: {b: [] for b in bin_labels} for label in labels}

    # Debug trackers
    missing_cov_files = 0
    missing_keys = 0

    for i, res_file in enumerate(result_files):
        label = labels[i]
        with open(os.path.join(RESULTS_ROOT, res_file), 'r') as f:
            sbfl_data = json.load(f)
            
        # Pointing to RESULTS_ROOT as requested
        coverage_file = os.path.join(RESULTS_ROOT, f"{label}_coverage.json") 
            
        for filename, true_bug_lines in truth_data.items():
            results_key = filename.replace('.dfy', '.test.dfy')
            
            if results_key in sbfl_data and metric_to_analyze in sbfl_data[results_key]:
                rank = get_fair_rank(sbfl_data[results_key][metric_to_analyze], true_bug_lines)
                
                # We give the function multiple keys to try just in case!
                possible_keys = [filename, results_key, filename.replace('.dfy', '')]
                passes, fails = get_pass_fail_counts(coverage_file, possible_keys)
                
                # Debug logging
                if passes is None:
                    missing_cov_files += 1
                    continue
                if passes == -1:
                    missing_keys += 1
                    continue
                
                total_tests = passes + fails
                
                if rank is not None and total_tests > 0 and fails > 0:
                    fail_ratio = fails / total_tests
                    ratio_bin = get_ratio_bin(fail_ratio)
                    
                    if ratio_bin in analysis_data[label]:
                        analysis_data[label][ratio_bin].append(rank)

    if missing_cov_files > 0:
        print(f"⚠️ WARNING: Could not find the coverage JSON file for {missing_cov_files} items. Check naming convention (e.g., '{labels[0]}_coverage.json').")
    if missing_keys > 0:
        print(f"⚠️ WARNING: Found the coverage file, but could not match {missing_keys} keys inside it. Check the JSON keys.")

    # --- TERMINAL & CSV OUTPUT ---
    TABLES_ROOT.mkdir(parents=True, exist_ok=True)
    csv_path = os.path.join(TABLES_ROOT, "ratio_impact_table.csv")
    
    print("\n" + "="*80)
    print(" 📊 IMPACT OF FAILING TEST RATIO ON OCHIAI ACCURACY")
    print("="*80)
    
    with open(csv_path, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Approach", "Failing Ratio Bin", "Mutant Count", "Top-1 Acc (%)", "MRR"])
        
        for label in labels:
            clean_name = clean_label(label)

            print(f"\nApproach: {clean_name}")
            print(f"{'Ratio Bin':<15} | {'Count':<7} | {'Top-1 (%)':<10} | {'MRR':<7}")
            print("-" * 50)
            
            for b in bin_labels:
                ranks = analysis_data[label][b]
                count = len(ranks)
                if count > 0:
                    top1 = sum(1 for r in ranks if r <= 1.0) / count * 100
                    mrr = sum(1.0 / r for r in ranks) / count
                else:
                    top1, mrr = 0.0, 0.0
                
                print(f"{b:<15} | {count:<7} | {top1:<10.1f} | {mrr:<7.3f}")
                writer.writerow([clean_name, b, count, f"{top1:.1f}", f"{mrr:.3f}"])

    GRAPHS_ROOT.mkdir(parents=True, exist_ok=True)
    fig, ax1 = plt.subplots(figsize=(10, 6))
    
    colors = plt.cm.tab10(np.linspace(0, 1, len(labels)))
    x = np.arange(len(bin_labels))
    
    for i, label in enumerate(labels):
        clean_name = clean_label(label)
        color = STRATEGY_COLORS.get(clean_name, "#7f7f7f")
        marker = STRATEGY_MARKERS.get(clean_name, "o")
        top1_vals = []
        for b in bin_labels:
            ranks = analysis_data[label][b]
            val = (sum(1 for r in ranks if r <= 1.0) / len(ranks) * 100) if len(ranks) > 0 else 0
            top1_vals.append(val)
            
        ax1.plot(x, top1_vals, marker=marker, color=color, linewidth=2, label=clean_name)

    ax1.set_xlabel('Percentage of Failing Testss')
    ax1.set_ylabel('Top-1 Accuracy (%)')
    ax1.set_title(f'Impact of Failing Test Ratio on Top-1 FL Accuracy (Ochiai)')
    ax1.set_xticks(x)
    ax1.set_xticklabels(bin_labels)
    ax1.grid(True, linestyle='--', alpha=0.6)
    ax1.legend(title="Strategy")

    plt.tight_layout()
    plot_path = os.path.join(GRAPHS_ROOT, "failing_ratio_impact.png")
    plt.savefig(plot_path, dpi=300)
    print(f"\nSaved visualization to: {plot_path}")
    print(f"Saved table to: {csv_path}")

if __name__ == "__main__":
    main()