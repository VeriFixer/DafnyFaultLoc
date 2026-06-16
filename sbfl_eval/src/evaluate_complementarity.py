import json
import math
import argparse
import sys
import os

def calculate_sbfl_for_file(file_data):
    all_lines = set()
    total_failed = 0
    total_passed = 0
    
    for test, info in file_data.items():
        all_lines.update(info['coverage'])
        if info['passed']: total_passed += 1
        else: total_failed += 1
            
    results = {"ochiai": [], "tarantula": [], "dstar": []}
    if not all_lines: return results
        
    for line in all_lines:
        n_cf = 0
        n_cp = 0
        
        for test, info in file_data.items():
            if line in info['coverage']:
                if info['passed']: n_cp += 1
                else: n_cf += 1
                    
        n_uf = total_failed - n_cf
        
        denom_ochiai = math.sqrt(total_failed * (n_cf + n_cp))
        ochiai = (n_cf / denom_ochiai) if denom_ochiai > 0 else 0.0
        
        fail_ratio = (n_cf / total_failed) if total_failed > 0 else 0.0
        pass_ratio = (n_cp / total_passed) if total_passed > 0 else 0.0
        denom_tarantula = fail_ratio + pass_ratio
        tarantula = (fail_ratio / denom_tarantula) if denom_tarantula > 0 else 0.0
        
        denom_dstar = n_cp + n_uf
        dstar = ((n_cf ** 2) / denom_dstar) if denom_dstar > 0 else 0.0
        
        results["ochiai"].append({"line": line, "score": ochiai})
        results["tarantula"].append({"line": line, "score": tarantula})
        results["dstar"].append({"line": line, "score": dstar})
        
    for metric in results:
        results[metric].sort(key=lambda x: (-x['score'], x['line']))
        
    return results

def get_fair_rank(ranked_list, target_lines):
    if not isinstance(target_lines, list):
        target_lines = [target_lines]

    for i, item in enumerate(ranked_list):
        if item['line'] in target_lines:
            score = item['score']
            block_start = i
            while block_start > 0 and ranked_list[block_start - 1]['score'] == score: block_start -= 1
            block_end = i
            while block_end < len(ranked_list) - 1 and ranked_list[block_end + 1]['score'] == score: block_end += 1
            return sum(range(block_start + 1, block_end + 2)) / (block_end - block_start + 1)
    return None

def calculate_stats(ranks_list):
    if not ranks_list:
        return {"top_1": 0, "top_3": 0, "top_5": 0, "mrr": 0.0, "avg_rank": 0.0}
    return {
        "top_1": sum(1 for r in ranks_list if r <= 1.0),
        "top_3": sum(1 for r in ranks_list if r <= 3.0),
        "top_5": sum(1 for r in ranks_list if r <= 5.0),
        "mrr": sum(1.0 / r for r in ranks_list) / len(ranks_list),
        "avg_rank": sum(ranks_list) / len(ranks_list)
    }

def main():
    parser = argparse.ArgumentParser(description="Merge and Analyze SBFL Complementarity dynamically")
    parser.add_argument("--folder", default="results", help="Folder containing *_coverage.json files")
    parser.add_argument("--truth", default="dataset/ground_truth.json", required=True, help="Path to ground truth JSON")
    parser.add_argument("--save-merged", help="Optional path to save the merged coverage JSON file")
    args = parser.parse_args()

    if not os.path.isdir(args.folder):
        print(f"Error: Directory '{args.folder}' not found.")
        sys.exit(1)

    cov_files = [f for f in os.listdir(args.folder) if f.endswith('_coverage.json')]
    
    if not cov_files:
        print(f"Error: No files ending in '_coverage.json' found in {args.folder}.")
        sys.exit(1)

    labels = [f.replace('_coverage.json', '') for f in cov_files]
    file_paths = [os.path.join(args.folder, f) for f in cov_files]

    print(f"Merging {len(labels)} coverage files: {', '.join(labels)}")

    with open(args.truth, 'r') as f: truth_data = json.load(f)

    # 1. Load Data
    all_cov_data = {}
    for i, path in enumerate(file_paths):
        with open(path, 'r') as f:
            all_cov_data[labels[i]] = json.load(f)

    # 2. Merge Coverage Data
    merged_data = {}
    all_filenames = set()
    for data in all_cov_data.values():
        all_filenames.update(data.keys())

    for fname in all_filenames:
        merged_data[fname] = {}
        for label, cov_dict in all_cov_data.items():
            if fname in cov_dict:
                for test_name, test_info in cov_dict[fname].items():
                    # Prefix/suffix the test name to avoid collisions across files
                    merged_data[fname][f"{test_name}_{label}"] = test_info

    if args.save_merged:
        with open(args.save_merged, 'w') as f: json.dump(merged_data, f, indent=2)
        print(f"💾 Saved merged coverage file to {args.save_merged}")

    # 3. Run SBFL Pipelines
    metrics = ["ochiai", "tarantula", "dstar"]
    approaches = labels + ["Combined (Merged)"]
    ranks = {app: {m: [] for m in metrics} for app in approaches}

    print("🔄 Processing and ranking files...")
    for filename, true_bug_lines in truth_data.items():
        
        # Calculate for individual approaches
        for label in labels:
            scores = calculate_sbfl_for_file(all_cov_data[label].get(filename, {}))
            for m in metrics:
                r = get_fair_rank(scores.get(m, []), true_bug_lines)
                if r is not None: ranks[label][m].append(r)

        # Calculate for Combined
        c_scores = calculate_sbfl_for_file(merged_data.get(filename, {}))
        for m in metrics:
            rc = get_fair_rank(c_scores.get(m, []), true_bug_lines)
            if rc is not None: ranks["Combined (Merged)"][m].append(rc)

    # 4. Print Comparison Table
    print("\n" + "="*95)
    print(f" 🧩 SBFL COMPLEMENTARITY ANALYSIS ({len(labels)} inputs)")
    print("="*95)
    print(f"{'Metric':<10} | {'Configuration':<20} | {'Top-1':<7} | {'Top-3':<7} | {'Top-5':<7} | {'MRR':<7} | {'Avg Rank':<8}")
    print("-" * 95)

    for m in metrics:
        for app in approaches:
            stats = calculate_stats(ranks[app][m])
            m_str = m.capitalize() if app == labels[0] else ""
            print(f"{m_str:<10} | {app:<20} | {stats['top_1']:<7} | {stats['top_3']:<7} | {stats['top_5']:<7} | {stats['mrr']:<7.3f} | {stats['avg_rank']:<8.2f}")
        print("-" * 95)

if __name__ == "__main__":
    main()