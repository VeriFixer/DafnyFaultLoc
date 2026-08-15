import json
import csv
import os
import sys
import argparse
import matplotlib.pyplot as plt
import seaborn as sns
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
    "block": "Block",
    "path": "Path",
    "spec": "Spec",
    "spec_bva": "SpecBva"
}

def clean_label(raw_label):
    return LABEL_MAP.get(raw_label, raw_label)

# ==========================================
# Helper Functions
# ==========================================
def get_fair_rank(ranked_list, target_lines):
    if not isinstance(target_lines, list):
        target_lines = [target_lines]

    target_lines = [str(t) for t in target_lines]
    total_lines = len(ranked_list)
    for i, item in enumerate(ranked_list):
        if str(item['line']) in target_lines:
            score = round(item['score'], 8)
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

""" def get_optimistic_rank(ranked_list, target_lines):
    if not isinstance(target_lines, list):
        target_lines = [target_lines]

    target_lines = [str(t) for t in target_lines]
    total_lines = len(ranked_list)
    for i, item in enumerate(ranked_list):
        if str(item['line']) in target_lines:
            score = round(item['score'], 8)

            block_start = i
            while block_start > 0 and ranked_list[block_start - 1]['score'] == score:
                block_start -= 1

            optimistic_rank = block_start + 1 
            exam_score = optimistic_rank / total_lines if total_lines > 0 else 0
            
            return optimistic_rank, exam_score
            
    return None, None """

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
    parser = argparse.ArgumentParser(description="Generate tables and plots for SBFL metrics.")
    parser.add_argument(
        '--metrics',
        nargs='+',
        default=None,
        help="List of metrics to include in tables and plots. If omitted, all available metrics are shown."
    )
    args = parser.parse_args()

    if not os.path.isdir(RESULTS_ROOT):
        print(f"Error: Directory '{RESULTS_ROOT}' not found.")
        sys.exit(1)

    result_files = [f for f in os.listdir(RESULTS_ROOT) if f.endswith('_results.json')]
    
    if not result_files:
        print(f"Error: No files ending in '_results.json' found in {RESULTS_ROOT}.")
        sys.exit(1)

    raw_labels = [f.replace('_results.json', '') for f in result_files]
    raw_labels.sort(key=lambda x: clean_label(x))
    file_paths = [os.path.join(RESULTS_ROOT, f"{lbl}_results.json") for lbl in raw_labels]

    print(f"Found {len(raw_labels)} approaches: {', '.join([clean_label(lbl) for lbl in raw_labels])}")

    with open(os.path.join(DATASET_ROOT, "ground_truth.json"), 'r') as f: 
        truth_data = json.load(f)

    available_metrics = []
    with open(file_paths[0], 'r') as f:
        sample_data = json.load(f)
        if sample_data:
            first_key = next(iter(sample_data))
            available_metrics = list(sample_data[first_key].keys())
            
    if not available_metrics:
        print("Error: Could not determine metrics from result files.")
        sys.exit(1)

    if args.metrics:
        invalid = [m for m in args.metrics if m not in available_metrics]
        if invalid:
            print(f"\n[ERROR] Invalid metrics selected: {invalid}")
            print(f"Available metrics in data: {available_metrics}")
            sys.exit(1)
        metrics = args.metrics
    else:
        metrics = available_metrics
        
    print(f"Processing Metrics: {', '.join(metrics)}")

    ranks = {label: {m: [] for m in metrics} for label in raw_labels}
    exams = {label: {m: [] for m in metrics} for label in raw_labels}
    stats = {label: {} for label in raw_labels}

    zero_fails = {label: 0 for label in raw_labels}
    total_mutants = {label: 0 for label in raw_labels}

    all_data = {}
    for i, res_file in enumerate(file_paths):
        raw_label = raw_labels[i]
        with open(res_file, 'r') as f:
            all_data[raw_label] = json.load(f)
    common_triggered_mutants = []

    for filename, true_bug_lines in truth_data.items():
        results_key = filename.replace('.dfy', '.test.dfy')
        
        triggered_by_all = True
        
        for raw_label in raw_labels:
            data = all_data[raw_label]
            if results_key in data:
                total_mutants[raw_label] += 1
                
                if not data[results_key]: 
                    zero_fails[raw_label] += 1
                    triggered_by_all = False
                else:
                    first_metric = next(iter(data[results_key]))
                    metric_data = data[results_key].get(first_metric)
                    
                    if not metric_data or metric_data[0]["score"] == 0.0:
                        zero_fails[raw_label] += 1
                        triggered_by_all = False
            else:
                triggered_by_all = False
                
        if triggered_by_all:
            common_triggered_mutants.append((results_key, true_bug_lines))

    print(f"\n[INFO] Found {len(common_triggered_mutants)} mutants triggered by ALL strategies.")
    print("[INFO] SBFL metrics will be calculated strictly on this common subset.")

    for results_key, true_bug_lines in common_triggered_mutants:
        for raw_label in raw_labels:
            data = all_data[raw_label]
            
            for metric in metrics:
                if metric not in data[results_key]:
                    continue
                    
                r, e = get_fair_rank(data[results_key][metric], true_bug_lines)

                if r is not None: 
                    ranks[raw_label][metric].append(r)
                    exams[raw_label][metric].append(e)

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

    # --- FILE EXPORTS (ALL METRICS FOR REPO) ---
    TABLES_ROOT.mkdir(parents=True, exist_ok=True)
    
    latex_rows = []
    for metric in metrics:
        for raw_label in raw_labels:
            s = stats[raw_label][metric]
            formatted_label = clean_label(raw_label)
            m_label = metric.replace("_", "\\_").capitalize() if raw_label == raw_labels[0] else ""
            
            latex_rows.append(f"{m_label} & {formatted_label} & {s['top_1_pct']:.1f}\\% & {s['top_3_pct']:.1f}\\% & {s['top_5_pct']:.1f}\\% & {s['mrr']:.3f} & {s['avg_rank']:.2f} & {s['avg_exam']:.2f}\\% \\\\")
        latex_rows.append("\\hline")

    latex_path = os.path.join(TABLES_ROOT, "selected_metrics_table.tex")
    with open(latex_path, 'w') as f:
        f.write("\\begin{table}[htbp]\n\\centering\n")
        f.write("\\caption{Fault Localisation Performance by Test Generation Strategy and Metric}\n\\label{tab:metrics_results}\n")
        f.write("\\begin{tabular}{l l c c c c c c}\n\\hline\n")
        f.write("\\textbf{Metric} & \\textbf{Strategy} & \\textbf{Top-1 (\\%)} & \\textbf{Top-3 (\\%)} & \\textbf{Top-5 (\\%)} & \\textbf{MRR} & \\textbf{Avg Rank} & \\textbf{EXAM (\\%)} \\\\\n\\hline\n")
        for row in latex_rows:
            f.write(row + "\n")
        f.write("\\end{tabular}\n")
        f.write("\\end{table}\n")

    print(f"\nSaved LaTeX table to: {latex_path}")

    # --- VISUALIZATIONS (INDIVIDUAL GRAPHS) ---
    GRAPHS_ROOT.mkdir(parents=True, exist_ok=True)
    x_labels = [m.replace("_", " ").capitalize() for m in metrics]

    plot_configs = {
        "top_1_pct": {"title": "Top-1 Accuracy Across Similarity Coefficients", "ylabel": "Top-1 Accuracy (%)"},
        "top_3": {"title": "Top-3 Accuracy Across Similarity Coefficients", "ylabel": "Top-3 Accuracy (Count)"},
        "top_5": {"title": "Top-5 Accuracy Across Similarity Coefficients", "ylabel": "Top-5 Accuracy (Count)"},
        "mrr": {"title": "Mean Reciprocal Rank Across Similarity Coefficients", "ylabel": "MRR (Higher is Better)"},
        "avg_rank": {"title": "Average Rank Across Similarity Coefficients", "ylabel": "Average Rank (Lower is Better)"},
        "avg_exam": {"title": "EXAM Score Across Similarity Coefficients", "ylabel": "EXAM Score (%) (Lower is Better)"}
    }

    for stat_key, config in plot_configs.items():
        plt.figure(figsize=(10, 6)) # slightly wider to accommodate more metrics
        
        for raw_label in raw_labels:
            formatted_label = clean_label(raw_label)
            y_vals = [stats[raw_label][m][stat_key] for m in metrics]
            
            color = STRATEGY_COLORS.get(formatted_label, None)
            marker = STRATEGY_MARKERS.get(formatted_label, 'o')

            plt.plot(x_labels, y_vals, marker=marker, linewidth=2.5, markersize=9, 
                     label=formatted_label, color=color, alpha=0.9)

        plt.title(config["title"], pad=15)
        plt.ylabel(config["ylabel"])
        plt.xlabel('Similarity Coefficient')
        
        # Rotate x labels slightly if there are many metrics
        if len(metrics) > 4:
            plt.xticks(rotation=45, ha='right')
            
        plt.legend(title="Strategy", frameon=True, fancybox=True, shadow=True)
        
        filename = f"sbfl_{stat_key}_comparison.png"
        plot_path = os.path.join(GRAPHS_ROOT, filename)
        plt.savefig(plot_path)
        plt.close()

    print(f"Saved {len(plot_configs)} individual graphs to: {GRAPHS_ROOT}\n")

if __name__ == "__main__":
    main()