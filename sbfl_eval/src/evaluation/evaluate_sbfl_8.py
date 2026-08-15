import json
import csv
import os
import sys
import argparse
import glob
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
    "Combined": "#000000"
}

STRATEGY_MARKERS = {
    "Block": "o",
    "Path": "s",
    "Spec": "^",
    "SpecBva": "D",
    "Combined": "*"
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

    global_labels = [f.replace('_results.json', '') for f in result_files]
    global_labels.sort(key=lambda x: clean_label(x))
    
    raw_labels = global_labels.copy()

    if args.strategies:
        target_labels = [s.lower() for s in args.strategies]
        filtered_labels = [lbl for lbl in raw_labels if clean_label(lbl).lower() in target_labels]
        if len(filtered_labels) < 2:
            print(f"Error: Found only {len(filtered_labels)} matching strategies. Need at least 2 for complementarity.")
            sys.exit(1)
        raw_labels = filtered_labels

    print(f"Global Pool (determining common mutants): {', '.join([clean_label(lbl) for lbl in global_labels])}")
    print(f"Evaluating Strategies: {', '.join([clean_label(lbl) for lbl in raw_labels])}")

    with open(os.path.join(DATASET_ROOT, "ground_truth.json"), 'r') as f: 
        truth_data = json.load(f)

    ref_folder = os.path.join(DATASET_ROOT, "tests_block") 
    qualified_programs = get_qualified_files(ref_folder, threshold=8)
    print(f"Filtering: Only including {len(qualified_programs)} programs with >= 8 lines.")

    available_metrics = []
    with open(os.path.join(RESULTS_ROOT, f"{global_labels[0]}_results.json"), 'r') as f:
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
    
    for lbl in global_labels:
        res_file = os.path.join(RESULTS_ROOT, f"{lbl}_results.json")
        with open(res_file, 'r') as f:
            data = json.load(f)
            
        for filename, true_bug_lines in truth_data.items():
            if filename.replace('.dfy', '.test.dfy') not in qualified_programs:
                continue

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
                                    
            mutant_data[results_key][lbl] = {
                'present': is_present,
                'zero_fail': is_zero_fail,
                'ranks': ranks_dict
            }

    # ---------------------------------------------------------
    # Aggregate Stats (Including Virtual "Combined" Strategy)
    # ---------------------------------------------------------
    all_labels = raw_labels + ["combined"]
    
    ranks = {label: {m: [] for m in metrics} for label in all_labels}
    exams = {label: {m: [] for m in metrics} for label in all_labels}

    common_mutants = {}
    for m_key, strategies_dict in mutant_data.items():
        triggered_by_all = True
        for lbl in global_labels:
            s_data = strategies_dict.get(lbl, {})
            if not s_data.get('present', False) or s_data.get('zero_fail', True):
                triggered_by_all = False
                break
                
        if triggered_by_all:
            common_mutants[m_key] = strategies_dict

    print(f"\n[INFO] Found {len(common_mutants)} mutants successfully triggered by ALL {len(global_labels)} global strategies.")
    print(f"[INFO] SBFL metrics will be calculated strictly on this common subset.")

    for m_key, strategies_dict in common_mutants.items():
        for raw_label in raw_labels:
            s_ranks = strategies_dict[raw_label].get('ranks', {})
            for metric in metrics:
                if metric in s_ranks:
                    ranks[raw_label][metric].append(s_ranks[metric][0])
                    exams[raw_label][metric].append(s_ranks[metric][1])
                    
        for metric in metrics:
            best_r = None
            best_e = None
            for lbl in raw_labels:
                s_ranks = strategies_dict.get(lbl, {}).get('ranks', {})
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

    stats = {label: {} for label in all_labels}
    for metric in metrics:
        for label in all_labels:
            s = calculate_stats(ranks[label][metric], exams[label][metric])
            stats[label][metric] = s
            
            m_label = metric.capitalize() if label == all_labels[0] else ""
            formatted_label = clean_label(label)
            
            print(f"{m_label:<14} | {formatted_label:<15} | {s['top_1_pct']:<9.1f} | {s['top_3_pct']:<9.1f} | {s['top_5_pct']:<9.1f} | {s['mrr']:<7.3f} | {s['avg_rank']:<8.2f} | {s['avg_exam']:<8.2f}")
        print("-" * 105)

    # --- FILE EXPORTS (ALL METRICS FOR REPO) ---
    TABLES_ROOT.mkdir(parents=True, exist_ok=True)
    
    latex_rows = []
    for metric in metrics:
        for label in all_labels:
            s = stats[label][metric]
            formatted_label = "\\textbf{" + clean_label(label) + "}" if label == "combined" else clean_label(label)
            m_label = metric.replace("_", "\\_").capitalize() if label == all_labels[0] else ""
            
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
        
        for label in all_labels:
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