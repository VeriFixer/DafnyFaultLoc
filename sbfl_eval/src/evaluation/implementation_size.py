import os
import glob
import statistics
import matplotlib.pyplot as plt
from pathlib import Path

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

from src.utils.config import (
    GRAPHS_ROOT
)


def get_method_body_lines(content, attribute_idx):
    # 1. Find the end of the current line to move past the {:testEntry} attribute
    line_end = content.find('\n', attribute_idx)
    if line_end == -1: line_end = len(content)
    
    # 2. Now look for the opening brace of the method body AFTER the attribute line
    open_idx = content.find('{', line_end)
    if open_idx == -1:
        return 0, len(content)

    # 3. Proceed with the brace counting (same as before)
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
    
    # Robust line counting
    count = 0
    for line in body.splitlines():
        clean_line = line.strip()
        if clean_line and clean_line != "{" and clean_line != "}" and not clean_line.startswith("//"):
            count += 1
            
    return count, curr_idx


def process_directory(directory="."):
    """Scans for .dfy files and calculates the {:testEntry} sizes."""
    dfy_files = glob.glob(os.path.join(directory, "*.dfy"))

    if not dfy_files:
        print("[SKIP] No .dfy files found in the current directory.")
        return

    file_stats = {}
    total_methods = 0
    total_lines = 0
    
    for filepath in dfy_files:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            
        search_idx = 0
        max_len = -1
        
        # Loop to catch multiple {:testEntry} flags in the same file
        while True:
            idx = content.find("{:testEntry}", search_idx)
            if idx == -1:
                break
                
            length, new_idx = get_method_body_lines(content, idx)
            
            # Keep only the largest method size
            if length > max_len:
                max_len = length
                
            search_idx = new_idx
            
        if max_len != -1:
            file_stats[os.path.basename(filepath)] = max_len
            total_methods += 1
            total_lines += max_len

    # --- Console Output ---
    print("--------------------------------------------------")
    print(" {:testEntry} IMPLEMENTATION SIZES")
    print("--------------------------------------------------")
    
    biggerThan8 = 0
    zero_line_files = [] 
    
    for fname, size in file_stats.items():
        if size >= 8:
            biggerThan8 += 1
            print(f" [FILE] {fname:<25} -> {size} lines")
        elif size == 0:
            zero_line_files.append(fname)
        
    print("-" * 50)
    print(f"There are {biggerThan8} programs with 8 or more lines of code")
    print("-" * 50)
    
    if zero_line_files:
        print(" EMPTY IMPLEMENTATIONS (0 Lines):")
        for fname in zero_line_files:
            print(f" [EMPTY] {fname}")
        print("-" * 50)
    
    # Final Summary (Now includes Median)
    if total_methods > 0:
        sizes = list(file_stats.values()) # Extracted here for median and plot
        avg = total_lines / total_methods
        med = statistics.median(sizes)
        
        print(f" Total files: {len(dfy_files)}")
        print(f" Files with testEntry: {total_methods}")
        print(f" Average implementation size: {avg:.2f} lines")
        print(f" Median implementation size:  {med} lines")
    else:
        print(" No methods flagged with {:testEntry} were found.")
        sizes = [] # Empty list fallback
    print("--------------------------------------------------\n")

    # --- Boxplot Generation ---
    if sizes:
        # Create and format the plot
        plt.figure(figsize=(8, 3))
        
        # Create a horizontal boxplot
        plt.boxplot(sizes, orientation='horizontal', patch_artist=True, 
                    boxprops=dict(facecolor='lightblue', color='blue'),
                    medianprops=dict(color='red', linewidth=2), widths=[0.5])
        
        plt.title("Distribution of implementation sizes across programs")
        plt.xlabel("Lines of Implementation Code")
        plt.yticks([])
        
        # Add a light grid for easier reading
        plt.grid(axis='x', linestyle='--', alpha=0.7)

        graphs_dir = Path(GRAPHS_ROOT)
        graphs_dir.mkdir(parents=True, exist_ok=True)
        
        plt.savefig(graphs_dir / "implementation_size.png")
        plt.close


if __name__ == "__main__":
    process_directory("dataset/tests_block")