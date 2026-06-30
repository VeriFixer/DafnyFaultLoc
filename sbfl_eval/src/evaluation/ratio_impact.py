import json
import csv
import os
import sys
import math
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
    'axes.labelsize': 12,
    'axes.titlesize': 14,
    'legend.fontsize': 11,
    'xtick.labelsize': 10,
    'ytick.labelsize': 10,
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
        return None, None 
    
    with open(coverage_file_path, 'r') as f:
        cov_data = json.load(f)
        
    actual_key = None
    for key in possible_keys:
        if key in cov_data:
            actual_key = key
            break
            
    if not actual_key:
        return -1, -1 
        
    passed = sum(1 for test in cov_data[actual_key].values() if test.get('passed') == True)
    failed = sum(1 for test in cov_data[actual_key].values() if test.get('passed') == False)
    
    return passed, failed

def main():
    if not os.path.isdir(RESULTS_ROOT):
        sys.exit(f"Error: Directory '{RESULTS_ROOT}' not found.")

    with open(os.path.join(DATASET_ROOT, "ground_truth.json"), 'r') as f: 
        truth_data = json.load(f)

    metric_to_analyze = "ochiai" 
    
    result_files = [f for f in os.listdir(RESULTS_ROOT) if f.endswith('_results.json')]
    labels = [f.replace('_results.json', '') for f in result_files]

    # Store raw (fail_ratio, rank) tuples instead of pre-binning
    analysis_data = {label: [] for label in labels}

    missing_cov_files = 0
    missing_keys = 0

    for i, res_file in enumerate(result_files):
        label = labels[i]
        with open(os.path.join(RESULTS_ROOT, res_file), 'r') as f:
            sbfl_data = json.load(f)
            
        coverage_file = os.path.join(RESULTS_ROOT, f"{label}_coverage.json") 
            
        for filename, true_bug_lines in truth_data.items():
            results_key = filename.replace('.dfy', '.test.dfy')
            
            if results_key in sbfl_data and metric_to_analyze in sbfl_data[results_key]:
                rank = get_fair_rank(sbfl_data[results_key][metric_to_analyze], true_bug_lines)
                
                possible_keys = [filename, results_key, filename.replace('.dfy', '')]
                passes, fails = get_pass_fail_counts(coverage_file, possible_keys)
                
                if passes is None:
                    missing_cov_files += 1
                    continue
                if passes == -1:
                    missing_keys += 1
                    continue
                
                total_tests = passes + fails
                
                # Only log if there are failing tests to compute a valid ratio
                if rank is not None and total_tests > 0 and fails > 0:
                    fail_ratio = fails / total_tests
                    analysis_data[label].append((fail_ratio, rank))

    if missing_cov_files > 0:
        print(f"⚠️ WARNING: Could not find the coverage JSON file for {missing_cov_files} items.")
    if missing_keys > 0:
        print(f"⚠️ WARNING: Found the coverage file, but could not match {missing_keys} keys inside it.")

    # --- SETUP 10 BINS FOR HISTOGRAM ---
    num_bins = 10
    bin_edges = np.linspace(0, 1.0, num_bins + 1)
    bin_labels = [f"{int(bin_edges[j]*100)}-{int(bin_edges[j+1]*100)}%" for j in range(num_bins)]

    # --- TERMINAL & CSV OUTPUT ---
    TABLES_ROOT.mkdir(parents=True, exist_ok=True)
    csv_path = os.path.join(TABLES_ROOT, "ratio_impact_table.csv")
    
    print("\n" + "="*80)
    print(" 📊 IMPACT OF FAILING TEST RATIO ON OCHIAI ACCURACY (HISTOGRAM BINS)")
    print("="*80)
    
    # Pre-calculate bin stats to use for both CSV and Plotting
    plot_stats = {label: [] for label in labels}

    with open(csv_path, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Approach", "Failing Ratio Bin", "Mutant Count", "Top-1 Acc (%)", "MRR"])
        
        for label in labels:
            clean_name = clean_label(label)
            print(f"\nApproach: {clean_name}")
            print(f"{'Ratio Bin':<15} | {'Count':<7} | {'Top-1 (%)':<10} | {'MRR':<7}")
            print("-" * 50)
            
            for j in range(num_bins):
                low, high = bin_edges[j], bin_edges[j+1]
                
                # Include exactly 0.0 in the first bin; otherwise strictly > low
                if j == 0:
                    ranks = [r for ratio, r in analysis_data[label] if low <= ratio <= high]
                else:
                    ranks = [r for ratio, r in analysis_data[label] if low < ratio <= high]
                
                count = len(ranks)
                if count > 0:
                    top1 = sum(1 for r in ranks if r <= 1.0) / count * 100
                    mrr = sum(1.0 / r for r in ranks) / count
                else:
                    top1, mrr = 0.0, 0.0
                
                plot_stats[label].append(top1)
                
                print(f"{bin_labels[j]:<15} | {count:<7} | {top1:<10.1f} | {mrr:<7.3f}")
                writer.writerow([clean_name, bin_labels[j], count, f"{top1:.1f}", f"{mrr:.3f}"])

    # --- HISTOGRAM / BAR CHART VISUALIZATION ---
    GRAPHS_ROOT.mkdir(parents=True, exist_ok=True)
    
    # Calculate grid layout for subplots (e.g., 2 columns)
    n_strategies = len(labels)
    cols = 2 if n_strategies > 1 else 1
    rows = math.ceil(n_strategies / cols)
    
    fig, axes = plt.subplots(rows, cols, figsize=(7 * cols, 5 * rows), squeeze=False)
    axes = axes.flatten()
    
    x_pos = np.arange(len(bin_labels))
    
    for i, label in enumerate(labels):
        ax = axes[i]
        clean_name = clean_label(label)
        color = STRATEGY_COLORS.get(clean_name, "#7f7f7f")
        
        ax.bar(x_pos, plot_stats[label], color=color, edgecolor='black', alpha=0.8)
        
        ax.set_title(f'{clean_name}')
        ax.set_xlabel('Percentage of Failing Tests')
        ax.set_ylabel('Top-1 Accuracy (%)')
        ax.set_xticks(x_pos)
        ax.set_xticklabels(bin_labels, rotation=45, ha="right")
        ax.set_ylim(0, 105) # Fixed Y-axis to make cross-strategy comparison easy
        ax.grid(axis='y', linestyle='--', alpha=0.6)

    # Hide any unused subplots (if n_strategies is odd)
    for j in range(i + 1, len(axes)):
        axes[j].set_visible(False)

    plt.suptitle('Impact of Failing Test Ratio on Top-1 FL Accuracy', fontsize=16, y=1.02)
    plt.tight_layout()
    
    plot_path = os.path.join(GRAPHS_ROOT, "failing_ratio_histograms.png")
    plt.savefig(plot_path, dpi=300)
    
    print(f"\nSaved histogram visualization to: {plot_path}")
    print(f"Saved table to: {csv_path}")

if __name__ == "__main__":
    main()