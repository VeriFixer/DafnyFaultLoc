import json
import os
import sys
import matplotlib.pyplot as plt
import numpy as np
import csv
from scipy.stats import spearmanr

from src.utils.config import (
    DATASET_ROOT,
    RESULTS_ROOT,
    GRAPHS_ROOT,
    TABLES_ROOT
)

def get_fair_rank_and_exam(ranked_list, target_lines):
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

def main():
    if not os.path.isdir(RESULTS_ROOT):
        sys.exit(f"Error: Directory '{RESULTS_ROOT}' not found.")

    with open(os.path.join(DATASET_ROOT, "ground_truth.json"), 'r') as f: 
        truth_data = json.load(f)

    metric_to_analyze = "ochiai" 
    result_files = [f for f in os.listdir(RESULTS_ROOT) if f.endswith('_results.json')]
    labels = [f.replace('_results.json', '') for f in result_files]

    # Store continuous data: approach -> {ratios: [], exams: [], mrrs: []}
    continuous_data = {label: {'ratios': [], 'exams': [], 'mrrs': []} for label in labels}

    # Debug trackers
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
                rank, exam = get_fair_rank_and_exam(sbfl_data[results_key][metric_to_analyze], true_bug_lines)
                
                possible_keys = [filename, results_key, filename.replace('.dfy', '')]
                passes, fails = get_pass_fail_counts(coverage_file, possible_keys)
                
                if passes is None:
                    missing_cov_files += 1
                    continue
                if passes == -1:
                    missing_keys += 1
                    continue
                    
                total_tests = passes + fails
                
                if rank is not None and total_tests > 0 and fails > 0:
                    fail_ratio = fails / total_tests
                    mrr = 1.0 / rank
                    
                    continuous_data[label]['ratios'].append(fail_ratio)
                    continuous_data[label]['exams'].append(exam * 100) # Store EXAM as a percentage
                    continuous_data[label]['mrrs'].append(mrr)

    if missing_cov_files > 0:
        print(f"⚠️ WARNING: Could not find the coverage JSON file for {missing_cov_files} items.")
    if missing_keys > 0:
        print(f"⚠️ WARNING: Found the coverage file, but could not match {missing_keys} keys inside it.")

    # --- STATISTICAL OUTPUT ---
    print("\n" + "="*80)
    print(" 📈 CONTINUOUS STATISTICAL CORRELATION (Spearman's Rho)")
    print("="*80)
    print("Note: Spearman ranges from -1 to 1.")
    print("For MRR: Positive correlation means higher ratio = better performance.")
    print("For EXAM: Negative correlation means higher ratio = better performance (less code to read).\n")
    
    print(f"{'Approach':<20} | {'N (Mutants)':<12} | {'Ratio vs MRR (ρ)':<18} | {'Ratio vs EXAM (ρ)':<18}")
    print("-" * 75)

    TABLES_ROOT.mkdir(parents=True, exist_ok=True)
    csv_path = os.path.join(TABLES_ROOT, "continuous_ratio_stats.csv")
    
    with open(csv_path, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Approach", "N (Mutants)", "Spearman Rho (MRR)", "P-Value (MRR)", "Spearman Rho (EXAM)", "P-Value (EXAM)"])
        
        for label in labels:
            ratios = continuous_data[label]['ratios']
            mrrs = continuous_data[label]['mrrs']
            exams = continuous_data[label]['exams']
            
            if len(ratios) > 1:
                rho_mrr, p_mrr = spearmanr(ratios, mrrs)
                rho_exam, p_exam = spearmanr(ratios, exams)
                
                print(f"{label:<20} | {len(ratios):<12} | {rho_mrr:>8.3f} (p={p_mrr:.3f}) | {rho_exam:>8.3f} (p={p_exam:.3f})")
                writer.writerow([label, len(ratios), f"{rho_mrr:.3f}", f"{p_mrr:.3f}", f"{rho_exam:.3f}", f"{p_exam:.3f}"])
            else:
                print(f"{label:<20} | {len(ratios):<12} | Insufficient data for correlation.")

    # --- VISUALIZATION: SCATTER PLOT WITH TRENDLINE ---
    GRAPHS_ROOT.mkdir(parents=True, exist_ok=True)
    
    # Calculate grid size based on number of labels
    num_plots = len(labels)
    cols = 2 if num_plots > 1 else 1
    rows = (num_plots + 1) // 2
    
    fig, axes = plt.subplots(rows, cols, figsize=(8 * cols, 6 * rows))
    
    # Handle the case where axes might not be an array (if rows=1, cols=1)
    if num_plots == 1:
        axes = [axes]
    else:
        axes = axes.flatten()
    
    for i, label in enumerate(labels):
        if i >= len(axes): break
        
        ratios = np.array(continuous_data[label]['ratios'])
        exams = np.array(continuous_data[label]['exams'])
        
        ax = axes[i]
        # Use scatter with low alpha so dense clusters get darker
        ax.scatter(ratios, exams, alpha=0.3, color='royalblue', edgecolors='none', s=40)
        
        # Add a simple polynomial trend line (degree 2 to catch curves)
        if len(ratios) > 10:
            z = np.polyfit(ratios, exams, 2)
            p = np.poly1d(z)
            x_trend = np.linspace(min(ratios), max(ratios), 100)
            ax.plot(x_trend, p(x_trend), "darkorange", linewidth=2.5, label="Trendline")

        ax.set_title(f"{label} (N={len(ratios)})", fontsize=14, fontweight='bold')
        ax.set_xlabel("Failing Test Ratio", fontsize=12)
        ax.set_ylabel("EXAM Score % (Lower is Better)", fontsize=12)
        ax.set_ylim(-5, max(100, max(exams) + 5 if len(exams) > 0 else 100))
        ax.grid(True, linestyle='--', alpha=0.5)
        if len(ratios) > 10:
            ax.legend()

    # Hide any unused subplots
    for j in range(i + 1, len(axes)):
        fig.delaxes(axes[j])

    plt.tight_layout()
    plot_path = os.path.join(GRAPHS_ROOT, "continuous_ratio_scatter.png")
    plt.savefig(plot_path, dpi=300)
    print(f"\nSaved visualization to: {plot_path}")
    print(f"Saved stats table to: {csv_path}")

if __name__ == "__main__":
    main()