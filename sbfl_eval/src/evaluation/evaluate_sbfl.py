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

    metrics = ["ochiai", "tarantula", "dstar"]
    ranks = {label: {m: [] for m in metrics} for label in raw_labels}
    exams = {label: {m: [] for m in metrics} for label in raw_labels}
    stats = {label: {} for label in raw_labels}

    # Tracking 0-failing test mutants
    zero_fails = {label: 0 for label in raw_labels}
    total_mutants = {label: 0 for label in raw_labels}

    # Extract ranks for all approaches
    for i, res_file in enumerate(file_paths):
        raw_label = raw_labels[i]
        with open(res_file, 'r') as f:
            data = json.load(f)
            
        for filename, true_bug_lines in truth_data.items():
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

    # --- FILE EXPORTS (ALL METRICS FOR REPO) ---
    TABLES_ROOT.mkdir(parents=True, exist_ok=True)
    
    latex_rows = []
    for metric in metrics:
        for raw_label in raw_labels:
            s = stats[raw_label][metric]
            formatted_label = clean_label(raw_label)
            m_label = metric.capitalize() if raw_label == raw_labels[0] else ""
            
            latex_rows.append(f"{m_label} & {formatted_label} & {s['top_1_pct']:.1f}\\% & {s['top_3_pct']:.1f}\\% & {s['top_5_pct']:.1f}\\% & {s['mrr']:.3f} & {s['avg_rank']:.2f} & {s['avg_exam']:.2f}\\% \\\\")
        latex_rows.append("\\hline")

    latex_path = os.path.join(TABLES_ROOT, "all_metrics_table.tex")
    with open(latex_path, 'w') as f:
        f.write("\\begin{table}[htbp]\n\\centering\n")
        f.write("\\caption{Fault Localisation Performance by Test Generation Strategy and Metric}\n\\label{tab:all_metrics_results}\n")
        f.write("\\begin{tabular}{l l c c c c c c}\n\\hline\n")
        f.write("\\textbf{Metric} & \\textbf{Strategy} & \\textbf{Top-1 (\\%)} & \\textbf{Top-3 (\\%)} & \\textbf{Top-5 (\\%)} & \\textbf{MRR} & \\textbf{Avg Rank} & \\textbf{EXAM (\\%)} \\\\\n\\hline\n")
        for row in latex_rows:
            f.write(row + "\n")
        f.write("\\end{tabular}\n")
        f.write("\\end{table}\n")

    print(f"\nSaved LaTeX table to: {latex_path}")

    # --- VISUALIZATIONS (INDIVIDUAL GRAPHS) ---
    GRAPHS_ROOT.mkdir(parents=True, exist_ok=True)
    x_labels = [m.capitalize() for m in metrics]

    plot_configs = {
        "top_1_pct": {"title": "Top-1 Accuracy Across Similarity Coefficients", "ylabel": "Top-1 Accuracy (%)"},
        "top_3": {"title": "Top-3 Accuracy Across Similarity Coefficients", "ylabel": "Top-3 Accuracy (Count)"},
        "top_5": {"title": "Top-5 Accuracy Across Similarity Coefficients", "ylabel": "Top-5 Accuracy (Count)"},
        "mrr": {"title": "Mean Reciprocal Rank Across Similarity Coefficients", "ylabel": "MRR (Higher is Better)"},
        "avg_rank": {"title": "Average Rank Across Similarity Coefficients", "ylabel": "Average Rank (Lower is Better)"},
        "avg_exam": {"title": "EXAM Score Across Similarity Coefficients", "ylabel": "EXAM Score (%) (Lower is Better)"}
    }

    for stat_key, config in plot_configs.items():
        plt.figure(figsize=(8, 6))
        
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
        
        plt.legend(title="Strategy", frameon=True, fancybox=True, shadow=True)
        
        filename = f"sbfl_{stat_key}_comparison.png"
        plot_path = os.path.join(GRAPHS_ROOT, filename)
        plt.savefig(plot_path)
        plt.close()

    print(f"Saved {len(plot_configs)} individual graphs to: {GRAPHS_ROOT}\n")

if __name__ == "__main__":
    main()