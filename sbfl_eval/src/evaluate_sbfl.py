import json
import argparse
import os
import sys
import matplotlib.pyplot as plt
import numpy as np

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
            return sum(range(block_start + 1, block_end + 2)) / (block_end - block_start + 1)
    return None

def calculate_stats(ranks_list):
    if not ranks_list:
        return {"top_1": 0, "top_3": 0, "top_5": 0, "mrr": 0.0, "avg_rank": 0.0, "total": 0}
    return {
        "top_1": sum(1 for r in ranks_list if r <= 1.0),
        "top_3": sum(1 for r in ranks_list if r <= 3.0),
        "top_5": sum(1 for r in ranks_list if r <= 5.0),
        "mrr": sum(1.0 / r for r in ranks_list) / len(ranks_list),
        "avg_rank": sum(ranks_list) / len(ranks_list),
        "total": len(ranks_list)
    }

def main():
    parser = argparse.ArgumentParser(description="Evaluate multiple SBFL approaches from a folder")
    parser.add_argument("--folder", default="results", help="Folder containing *_results.json files")
    parser.add_argument("--truth", default="dataset/ground_truth.json", help="Path to ground truth JSON")
    args = parser.parse_args()

    if not os.path.isdir(args.folder):
        print(f"Error: Directory '{args.folder}' not found.")
        sys.exit(1)

    # Automatically find all _results.json files
    result_files = [f for f in os.listdir(args.folder) if f.endswith('_results.json')]
    
    if not result_files:
        print(f"Error: No files ending in '_results.json' found in {args.folder}.")
        sys.exit(1)

    # Extract labels (everything before _results.json)
    labels = [f.replace('_results.json', '') for f in result_files]
    file_paths = [os.path.join(args.folder, f) for f in result_files]

    print(f"Found {len(labels)} approaches: {', '.join(labels)}")

    with open(args.truth, 'r') as f: 
        truth_data = json.load(f)

    metrics = ["ochiai", "tarantula", "dstar"]
    ranks = {label: {m: [] for m in metrics} for label in labels}
    stats = {label: {} for label in labels}

    # Extract ranks for all approaches
    for i, res_file in enumerate(file_paths):
        label = labels[i]
        with open(res_file, 'r') as f:
            data = json.load(f)
            
        for filename, true_bug_lines in truth_data.items():
            if filename in data:
                for metric in metrics:
                    r = get_fair_rank(data[filename][metric], true_bug_lines)
                    if r is not None: 
                        ranks[label][metric].append(r)

    # --- CONSOLE TABLE OUTPUT ---
    print("\n" + "="*95)
    print(f" 🐛 SBFL APPROACH COMPARISON ({len(labels)} Methods)")
    print("="*95)
    print(f"{'Metric':<10} | {'Approach':<20} | {'Top-1':<7} | {'Top-3':<7} | {'Top-5':<7} | {'MRR':<7} | {'Avg Rank':<8}")
    print("-" * 95)

    for metric in metrics:
        for label in labels:
            s = calculate_stats(ranks[label][metric])
            stats[label][metric] = s
            
            m_label = metric.capitalize() if label == labels[0] else ""
            print(f"{m_label:<10} | {label:<20} | {s['top_1']:<7} | {s['top_3']:<7} | {s['top_5']:<7} | {s['mrr']:<7.3f} | {s['avg_rank']:<8.2f}")
        print("-" * 95)

    # --- VISUALIZATIONS ---
    fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(20, 6))
    x = np.arange(len(metrics))
    num_approaches = len(labels)
    total_width = 0.8
    width = total_width / num_approaches
    colors = plt.cm.tab10(np.linspace(0, 1, max(10, num_approaches)))

    for i, label in enumerate(labels):
        offset = x - (total_width / 2) + (i * width) + (width / 2)
        top1_vals = [stats[label][m]["top_1"] for m in metrics]
        ax1.bar(offset, top1_vals, width, label=label, color=colors[i])
        
        top3_vals = [stats[label][m]["top_3"] for m in metrics]
        ax2.bar(offset, top3_vals, width, label=label, color=colors[i])

    ax1.set_title('Top-1 Accuracy Comparison')
    ax1.set_ylabel('Bugs Localized at Rank 1')
    ax1.set_xticks(x)
    ax1.set_xticklabels([m.capitalize() for m in metrics])
    ax1.legend()

    ax2.set_title('Top-3 Accuracy Comparison')
    ax2.set_ylabel('Bugs Localized at Rank <= 3')
    ax2.set_xticks(x)
    ax2.set_xticklabels([m.capitalize() for m in metrics])
    ax2.legend()

    box_data = []
    positions = []
    box_colors = []
    
    for i, m in enumerate(metrics):
        for j, label in enumerate(labels):
            box_data.append(ranks[label][m])
            positions.append(i * (num_approaches + 1) + j)
            box_colors.append(colors[j])

    bplot = ax3.boxplot(box_data, positions=positions, patch_artist=True, widths=0.6)
    
    for patch, color in zip(bplot['boxes'], box_colors):
        patch.set_facecolor(color)
        patch.set_alpha(0.7)

    ax3.set_title('Rank Distribution (Lower is Better)')
    ax3.set_ylabel('Rank Position')
    ax3.set_yscale('log')
    tick_positions = [i * (num_approaches + 1) + (num_approaches - 1) / 2 for i in range(len(metrics))]
    ax3.set_xticks(tick_positions)
    ax3.set_xticklabels([m.capitalize() for m in metrics])
    
    from matplotlib.patches import Patch
    legend_elements = [Patch(facecolor=colors[i], label=labels[i]) for i in range(num_approaches)]
    ax3.legend(handles=legend_elements)

    plt.tight_layout()
    plt.savefig("sbfl_comparison_charts.png", dpi=300)
    print("\n✅ Visualizations saved to sbfl_comparison_charts.png\n")

if __name__ == "__main__":
    main()