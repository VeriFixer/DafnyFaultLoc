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
    "SpecBva": "#d62728",
    "Combined": "#000000"  # Black color for combined visibility
}

STRATEGY_MARKERS = {
    "Block": "o",
    "Path": "s",
    "Spec": "^",
    "SpecBva": "D",
    "Combined": "*"       # Star marker for the combined metric
}

LABEL_MAP = {
    "block": "Block",
    "path": "Path",
    "spec": "Spec",
    "spec_bva": "SpecBva",
    "combined": "Combined"
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

# ==========================================
# Main Execution
# ==========================================
def main():
    parser = argparse.ArgumentParser(description="Calculate complementarity between SBFL strategies.")
    parser.add_argument(
        '--metrics',
        nargs='+',
        default=None,
        help="List of metrics to include. If omitted, all available metrics are shown."
    )
    parser.add_argument(
        '--strategies',
        nargs='+',
        default=None,
        help="List of strategies to combine (e.g., Block Spec). If omitted, all found strategies are used."
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
    
    combine_labels = []
    if args.strategies:
        target_labels = [s.lower() for s in args.strategies]
        combine_labels = [lbl for lbl in raw_labels if clean_label(lbl).lower() in target_labels]
        if len(combine_labels) < 2:
            print(f"Error: Found only {len(combine_labels)} matching strategies. Need at least 2 for complementarity.")
            sys.exit(1)
    else:
        combine_labels = raw_labels[:]

    print(f"Loaded all strategies for comparison: {', '.join([clean_label(lbl) for lbl in raw_labels])}")
    print(f"Calculating 'Combined' metric using ONLY: {', '.join([clean_label(lbl) for lbl in combine_labels])}")

    file_paths = [os.path.join(RESULTS_ROOT, f"{lbl}_results.json") for lbl in raw_labels]

    file_paths = [os.path.join(RESULTS_ROOT, f"{lbl}_results.json") for lbl in raw_labels]
    print(f"Combining Strategies: {', '.join([clean_label(lbl) for lbl in raw_labels])}")

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
            sys.exit(1)
        metrics = args.metrics
    else:
        metrics = available_metrics
        
    print(f"Processing Metrics: {', '.join(metrics)}")

    # ---------------------------------------------------------
    # Parse and Store Data Per-Mutant for Complementarity
    # ---------------------------------------------------------
    mutant_data = {}
    
    for i, res_file in enumerate(file_paths):
        raw_label = raw_labels[i]
        with open(res_file, 'r') as f:
            data = json.load(f)
            
        for filename, true_bug_lines in truth_data.items():
            results_key = filename.replace('.dfy', '.test.dfy')
            if results_key not in mutant_data:
                mutant_data[results_key] = {}
                
            is_zero_fail = False
            ranks_dict = {}
            is_present = results_key in data
            
            if is_present:
                if not data[results_key]:
                    is_zero_fail = True
                else:
                    first_metric = next(iter(data[results_key]))
                    metric_data = data[results_key].get(first_metric)
                    
                    if not metric_data or metric_data[0]["score"] == 0.0:
                        is_zero_fail = True
                    else:
                        for metric in metrics:
                            if metric in data[results_key]:
                                r, e = get_fair_rank(data[results_key][metric], true_bug_lines)
                                if r is not None:
                                    ranks_dict[metric] = (r, e)
                                    
            mutant_data[results_key][raw_label] = {
                'present': is_present,
                'zero_fail': is_zero_fail,
                'ranks': ranks_dict
            }

    # ---------------------------------------------------------
    # Aggregate Stats (Including Virtual "Combined" Strategy)
    # ---------------------------------------------------------
    all_labels = raw_labels + ["combined"]
    display_labels = combine_labels + ["combined"] # Only show these in output
    
    ranks = {label: {m: [] for m in metrics} for label in all_labels}
    exams = {label: {m: [] for m in metrics} for label in all_labels}
    zero_fails = {label: 0 for label in all_labels}
    total_mutants = {label: 0 for label in all_labels}
    stats = {label: {} for label in all_labels}

    for m_key, strategies_dict in mutant_data.items():
        for lbl in raw_labels:
            s_data = strategies_dict.get(lbl, {})
            if s_data.get('present', False):
                total_mutants[lbl] += 1
                if s_data.get('zero_fail', False):
                    zero_fails[lbl] += 1
                    
        present_in_any = any(strategies_dict.get(lbl, {}).get('present', False) for lbl in combine_labels)
        if present_in_any:
            total_mutants["combined"] += 1
            all_zero_fails = all(
                strategies_dict.get(lbl, {}).get('zero_fail', False) 
                for lbl in combine_labels if strategies_dict.get(lbl, {}).get('present', False)
            )
            if all_zero_fails:
                zero_fails["combined"] += 1

    common_mutants = {}
    for m_key, strategies_dict in mutant_data.items():
        triggered_by_all = True
        for lbl in raw_labels:
            s_data = strategies_dict.get(lbl, {})
            if not s_data.get('present', False) or s_data.get('zero_fail', True):
                triggered_by_all = False
                break
                
        if triggered_by_all:
            common_mutants[m_key] = strategies_dict

    print(f"\n[INFO] Found {len(common_mutants)} mutants triggered by ALL {len(raw_labels)} original strategies.")
    print("[INFO] SBFL metrics will be calculated strictly on this common subset.")

    for m_key, strategies_dict in common_mutants.items():
        for lbl in raw_labels:
            s_ranks = strategies_dict[lbl].get('ranks', {})
            for metric in metrics:
                if metric in s_ranks:
                    ranks[lbl][metric].append(s_ranks[metric][0])
                    exams[lbl][metric].append(s_ranks[metric][1])
                    
        for metric in metrics:
            best_r = None
            best_e = None
            for lbl in combine_labels:
                s_ranks = strategies_dict[lbl].get('ranks', {})
                if metric in s_ranks:
                    r, e = s_ranks[metric]
                    if best_r is None or r < best_r:
                        best_r = r
                        best_e = e
            
            if best_r is not None:
                ranks["combined"][metric].append(best_r)
                exams["combined"][metric].append(best_e)

    # --- CONSOLE OUTPUT & STATS CALCULATION ---
    print("\n" + "="*105)
    print(f" 🐛 SBFL APPROACH COMPARISON (WITH COMBINED METRIC)")
    print("="*105)
    print(f"{'Metric':<14} | {'Approach':<15} | {'Top-1 (%)':<9} | {'Top-3 (%)':<9} | {'Top-5 (%)':<9} | {'MRR':<7} | {'Avg Rank':<8} | {'EXAM (%)':<8}")
    print("-" * 105)

    for metric in metrics:
        for label in all_labels:
            stats[label][metric] = calculate_stats(ranks[label][metric], exams[label][metric])
            
        for label in display_labels:
            s = stats[label][metric]
            m_label = metric.capitalize() if label == display_labels[0] else ""
            formatted_label = clean_label(label)
            
            print(f"{m_label:<14} | {formatted_label:<15} | {s['top_1_pct']:<9.1f} | {s['top_3_pct']:<9.1f} | {s['top_5_pct']:<9.1f} | {s['mrr']:<7.3f} | {s['avg_rank']:<8.2f} | {s['avg_exam']:<8.2f}")
        print("-" * 105)

    # --- FILE EXPORTS (ALL METRICS FOR REPO) ---
    TABLES_ROOT.mkdir(parents=True, exist_ok=True)
    
    latex_rows = []
    for metric in metrics:
        for label in display_labels:
            s = stats[label][metric]
            formatted_label = "\\textbf{" + clean_label(label) + "}" if label == "combined" else clean_label(label)
            m_label = metric.replace("_", "\\_").capitalize() if label == display_labels[0] else ""
            
            latex_rows.append(f"{m_label} & {formatted_label} & {s['top_1_pct']:.1f}\\% & {s['top_3_pct']:.1f}\\% & {s['top_5_pct']:.1f}\\% & {s['mrr']:.3f} & {s['avg_rank']:.2f} & {s['avg_exam']:.2f}\\% \\\\")
        latex_rows.append("\\hline")

    latex_path = os.path.join(TABLES_ROOT, "complementarity_metrics_table.tex")
    with open(latex_path, 'w') as f:
        f.write("\\begin{table}[htbp]\n\\centering\n")
        f.write("\\caption{Fault Localisation Complementarity Performance}\n\\label{tab:complementarity_results}\n")
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
        "top_1_pct": {"title": "Complementarity: Top-1 Accuracy", "ylabel": "Top-1 Accuracy (%)"},
        "top_3": {"title": "Complementarity: Top-3 Accuracy", "ylabel": "Top-3 Accuracy (Count)"},
        "top_5": {"title": "Complementarity: Top-5 Accuracy", "ylabel": "Top-5 Accuracy (Count)"},
        "mrr": {"title": "Complementarity: Mean Reciprocal Rank", "ylabel": "MRR (Higher is Better)"},
        "avg_rank": {"title": "Complementarity: Average Rank", "ylabel": "Average Rank (Lower is Better)"},
        "avg_exam": {"title": "Complementarity: EXAM Score", "ylabel": "EXAM Score (%) (Lower is Better)"}
    }

    for stat_key, config in plot_configs.items():
        plt.figure(figsize=(10, 6))
        
        for label in display_labels:
            formatted_label = clean_label(label)
            y_vals = [stats[label][m][stat_key] for m in metrics]
            
            color = STRATEGY_COLORS.get(formatted_label, "#999999")
            marker = STRATEGY_MARKERS.get(formatted_label, 'o')
            
            lw = 3.5 if label == "combined" else 2.0

            plt.plot(x_labels, y_vals, marker=marker, linewidth=lw, markersize=9, 
                     label=formatted_label, color=color, alpha=0.9)

        plt.title(config["title"], pad=15)
        plt.ylabel(config["ylabel"])
        plt.xlabel('Similarity Coefficient')
        
        if len(metrics) > 4:
            plt.xticks(rotation=45, ha='right')
            
        plt.legend(title="Strategy", frameon=True, fancybox=True, shadow=True)
        
        filename = f"complementarity_{stat_key}_comparison.png"
        plot_path = os.path.join(GRAPHS_ROOT, filename)
        plt.savefig(plot_path)
        plt.close()

    print(f"Saved {len(plot_configs)} individual complementarity graphs to: {GRAPHS_ROOT}\n")


if __name__ == "__main__":
    main()