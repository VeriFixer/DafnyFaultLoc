import json
import os
import sys
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

from src.utils.config import (
    DATASET_ROOT,
    RESULTS_ROOT,
    GRAPHS_ROOT,
    TABLES_ROOT,
    COVERAGE_ROOT
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
def calculate_classification_metrics(predicted_lines, actual_lines):
    """Calculates Precision, Recall, F1, Exact Match, and Overlap."""
    if not isinstance(predicted_lines, list):
        predicted_lines = []
    if not isinstance(actual_lines, list):
        actual_lines = [actual_lines]

    pred_set = set(predicted_lines)
    actual_set = set(actual_lines)
    
    if not pred_set and not actual_set:
        return 1.0, 1.0, 1.0, True, True 
    if not pred_set or not actual_set:
        return 0.0, 0.0, 0.0, False, False
        
    tp = len(pred_set.intersection(actual_set))
    fp = len(pred_set - actual_set)
    fn = len(actual_set - pred_set)
    
    precision = tp / (tp + fp) if (tp + fp) > 0 else 0.0
    recall = tp / (tp + fn) if (tp + fn) > 0 else 0.0
    f1 = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0.0
    exact_match = (pred_set == actual_set)
    any_overlap = tp > 0
    
    return precision, recall, f1, exact_match, any_overlap

def aggregate_stats(metrics_dict):
    """Averages the metrics across all evaluated files."""
    total = len(metrics_dict["precision"])
    if total == 0:
        return {"precision": 0.0, "recall": 0.0, "f1": 0.0, "exact_match": 0.0, "any_overlap": 0.0, "total": 0}
    
    return {
        "precision": sum(metrics_dict["precision"]) / total * 100,
        "recall": sum(metrics_dict["recall"]) / total * 100,
        "f1": sum(metrics_dict["f1"]) / total * 100,
        "exact_match": sum(metrics_dict["exact_match"]) / total * 100,
        "any_overlap": sum(metrics_dict["any_overlap"]) / total * 100,
        "total": total
    }

# ==========================================
# Main Execution
# ==========================================
def main():
    target_results_dir = os.path.join(RESULTS_ROOT, "all_tests")
    if not os.path.isdir(target_results_dir):
        target_results_dir = RESULTS_ROOT

    result_files = [f for f in os.listdir(target_results_dir) if f.endswith('_results.json')]
    
    if not result_files:
        print(f"Error: No files ending in '_results.json' found in {target_results_dir}.")
        sys.exit(1)

    raw_labels = [f.replace('_results.json', '') for f in result_files]
    raw_labels.sort(key=lambda x: clean_label(x))
    file_paths = [os.path.join(target_results_dir, f"{lbl}_results.json") for lbl in raw_labels]

    print(f"Found {len(raw_labels)} approaches: {', '.join([clean_label(lbl) for lbl in raw_labels])}")

    ground_truth_path = os.path.join(DATASET_ROOT, "ground_truth.json")
    with open(ground_truth_path, 'r') as f: 
        truth_data = json.load(f)

    # Tracking dictionaries for all three groups
    groups = ["all", "has_failing", "passing_only"]
    raw_metrics = {
        label: {
            g: {"precision": [], "recall": [], "f1": [], "exact_match": [], "any_overlap": []} 
            for g in groups
        } for label in raw_labels
    }
    
    stats = {label: {} for label in raw_labels}
    missing_predictions = {label: {g: 0 for g in groups} for label in raw_labels}
    
    # NEW: Dictionary to store the names of programs that had NO overlap
    no_overlap_programs = {label: [] for label in raw_labels}

    # Extract performance metrics
    for i, res_file in enumerate(file_paths):
        raw_label = raw_labels[i]
        
        coverage_path = os.path.join(COVERAGE_ROOT, f"{raw_label}_coverage.json")
        coverage_data = {}
        if os.path.exists(coverage_path):
            with open(coverage_path, 'r') as cf:
                coverage_data = json.load(cf)

        with open(res_file, 'r') as f:
            data = json.load(f)
            
        for filename, true_bug_lines in truth_data.items():
            results_key = filename.replace('.dfy', '.test.dfy')
            if results_key in data:
                file_results = data[results_key]
                
                # Check coverage data to see if this file had any failing tests
                file_coverage = coverage_data.get(results_key, {})
                has_failing_tests = any(not t_info.get("passed", True) for t_info in file_coverage.values())
                
                target_groups = ["all", "has_failing" if has_failing_tests else "passing_only"]
                
                model_keys = list(file_results.keys())
                if not model_keys:
                    for g in target_groups:
                        missing_predictions[raw_label][g] += 1
                    no_overlap_programs[raw_label].append((results_key, true_bug_lines, [], has_failing_tests))
                    continue
                
                model_key = model_keys[0]
                predicted_lines = file_results[model_key].get("lines", [])
                
                if not predicted_lines:
                    for g in target_groups:
                        missing_predictions[raw_label][g] += 1

                p, r, f1, em, overlap = calculate_classification_metrics(predicted_lines, true_bug_lines)
                
                # NEW: Track if there was absolutely no overlap
                if not overlap:
                    no_overlap_programs[raw_label].append((results_key, true_bug_lines, predicted_lines, has_failing_tests))

                for g in target_groups:
                    raw_metrics[raw_label][g]["precision"].append(p)
                    raw_metrics[raw_label][g]["recall"].append(r)
                    raw_metrics[raw_label][g]["f1"].append(f1)
                    raw_metrics[raw_label][g]["exact_match"].append(1 if em else 0)
                    raw_metrics[raw_label][g]["any_overlap"].append(1 if overlap else 0)

    # --- CONSOLE OUTPUT: PRINT STATS ---
    console_configs = [
        ("all", "ALL PROGRAMS (AGGREGATE)"),
        ("has_failing", "WITH FAILING TESTS (>0)"), 
        ("passing_only", "PASSING ONLY (0 FAILING)")
    ]

    for group_key, group_title in console_configs:
        print("\n" + "="* 111)
        print(f" 🤖 LLM FAULT LOCALIZATION - {group_title}")
        print("="* 111)
        print(f"{'Strategy':<15} | {'N':<5} | {'Precision (%)':<15} | {'Recall (%)':<12} | {'F1 Score (%)':<14} | {'Exact Match (%)':<17} | {'Any Overlap (%)':<15}")
        print("-" * 111)

        for raw_label in raw_labels:
            s = aggregate_stats(raw_metrics[raw_label][group_key])
            stats[raw_label][group_key] = s
            formatted_label = clean_label(raw_label)
            
            print(f"{formatted_label:<15} | {s['total']:<5} | {s['precision']:<15.2f} | {s['recall']:<12.2f} | {s['f1']:<14.2f} | {s['exact_match']:<17.2f} | {s['any_overlap']:<15.2f}")
        print("-" * 111)

    # --- CONSOLE OUTPUT: PROGRAMS WITH NO OVERLAP ---
    """ print("\n" + "="* 111)
    print(" 🔍 PROGRAMS WITH NO OVERLAP (Manual Inspection Required)")
    print("="* 111)
    for raw_label in raw_labels:
        formatted_label = clean_label(raw_label)
        programs = no_overlap_programs[raw_label]
        print(f"\n--- Strategy: {formatted_label} ({len(programs)} programs missed completely) ---")
        if not programs:
            print("  [Perfect! Every program had at least one overlapping line.]")
        else:
            for prog, true_lines, pred_lines, had_failing in programs:
                test_status = ">0 Failing" if had_failing else "0 Failing"
                print(f"  - {prog:<55} | State: {test_status:<10} | True: {str(true_lines):<12} | Pred: {pred_lines}")
 """

    # --- FILE EXPORTS (THREE LATEX TABLES) ---
    TABLES_ROOT.mkdir(parents=True, exist_ok=True)
    
    table_configs = [
        ("all", "all", "All Programs"),
        ("has_failing", "failing", "Programs With Failing Tests"), 
        ("passing_only", "passing", "Programs Without Failing Tests")
    ]

    for group_key, file_suffix, title_suffix in table_configs:
        latex_rows = []
        for raw_label in raw_labels:
            s = stats[raw_label][group_key]
            formatted_label = clean_label(raw_label)
            latex_rows.append(f"{formatted_label} & {s['total']} & {s['precision']:.2f}\\% & {s['recall']:.2f}\\% & {s['f1']:.2f}\\% & {s['exact_match']:.2f}\\% & {s['any_overlap']:.2f}\\% \\\\")
        
        latex_path = os.path.join(TABLES_ROOT, f"llm_metrics_{file_suffix}_table.tex")
        with open(latex_path, 'w') as f:
            f.write("\\begin{table}[htbp]\n\\centering\n")
            f.write(f"\\caption{{LLM Fault Localisation Performance ({title_suffix})}}\n\\label{{tab:llm_metrics_{file_suffix}}}\n")
            f.write("\\begin{tabular}{l c c c c c c}\n\\hline\n")
            f.write("\\textbf{Strategy} & \\textbf{N} & \\textbf{Precision} & \\textbf{Recall} & \\textbf{F1 Score} & \\textbf{Exact Match} & \\textbf{Any Overlap} \\\\\n\\hline\n")
            for row in latex_rows:
                f.write(row + "\n")
            f.write("\\hline\n\\end{tabular}\n")
            f.write("\\end{table}\n")

    print(f"\nSaved 3 LaTeX tables to: {TABLES_ROOT}")

    # --- VISUALIZATIONS (GROUPED BAR CHARTS) ---
    GRAPHS_ROOT.mkdir(parents=True, exist_ok=True)
    
    plot_configs = {
        "precision": "Precision (%)",
        "recall": "Recall (%)",
        "f1": "F1 Score (%)",
        "exact_match": "Exact Match (%)",
        "any_overlap": "Any Overlap (%)"
    }

    # Flatten data for Seaborn grouped bar plots (Including All, Failing, and Passing)
    plot_data = []
    group_mapping = [
        ("all", "All Programs"),
        ("has_failing", ">0 Failing Tests"), 
        ("passing_only", "0 Failing Tests")
    ]
    
    for raw_label in raw_labels:
        formatted_label = clean_label(raw_label)
        for group_key, group_name in group_mapping:
            for metric_key in plot_configs.keys():
                plot_data.append({
                    "Strategy": formatted_label,
                    "Test Status": group_name,
                    "Metric": metric_key,
                    "Value": stats[raw_label][group_key][metric_key]
                })
    
    df = pd.DataFrame(plot_data)

    for metric_key, y_label in plot_configs.items():
        plt.figure(figsize=(12, 6))
        
        metric_df = df[df["Metric"] == metric_key]
        
        ax = sns.barplot(
            data=metric_df, 
            x="Strategy", 
            y="Value", 
            hue="Test Status",
            palette={"All Programs": "#2ca02c", ">0 Failing Tests": "#d62728", "0 Failing Tests": "#1f77b4"} 
        )
        
        # Add value labels
        for p in ax.patches:
            height = p.get_height()
            if height > 0:
                ax.annotate(f"{height:.1f}%", 
                            (p.get_x() + p.get_width() / 2., height), 
                            ha='center', va='center', xytext=(0, 8), 
                            textcoords='offset points', fontsize=8)

        plt.title(f"{y_label} Comparison: All vs. Failing vs. Passing", pad=15)
        plt.ylabel(y_label)
        plt.xlabel('Test Generation Strategy')
        plt.ylim(0, max(metric_df["Value"]) + 20 if not metric_df.empty else 100)
        
        plt.legend(title="Program Test State", bbox_to_anchor=(1.05, 1), loc='upper left')
        
        filename = f"llm_{metric_key}_split_comparison.png"
        plot_path = os.path.join(GRAPHS_ROOT, filename)
        plt.savefig(plot_path, bbox_inches='tight')
        plt.close()

    print(f"Saved {len(plot_configs)} grouped bar charts to: {GRAPHS_ROOT}\n")

if __name__ == "__main__":
    main()