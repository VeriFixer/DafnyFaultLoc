"""Extract mutated line numbers from generated mutants.

CLI tool to compare original .dfy files against their generated mutants
and output a JSON file mapping each mutant to the line number that was changed.

Usage:
    python extract_lines.py --original-dir dataset/selected_programs/ \
                            --mutated-dir dataset/selected_programs_mutants/ \
                            --output-json results/mutated_lines.json
"""

import argparse
import difflib
import json
import logging
import sys
from pathlib import Path

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
logger = logging.getLogger(__name__)


def extract_mutated_line_number(original_path: Path, mutant_path: Path) -> int | None:
    """Returns the starting line number where the mutation occurred."""
    original_lines = original_path.read_text(encoding="utf-8").splitlines(keepends=True)
    mutant_lines = mutant_path.read_text(encoding="utf-8").splitlines(keepends=True)

    # n=0 ensures we only get the exact changed lines, no context lines
    diff = difflib.unified_diff(original_lines, mutant_lines, n=0)
    
    for line in diff:
        if line.startswith("@@"):
            parts = line.split(" ")
            if len(parts) >= 3:
                mutant_info = parts[2]
                line_num_str = mutant_info.replace('+', '').split(',')[0]
                return int(line_num_str)
            
    return None


def map_mutations(original_dir: Path, mutated_dir: Path) -> dict[str, int | None]:
    """Iterate over original files and matching mutant folders to extract line numbers."""
    results = {}
    
    if not original_dir.is_dir():
        logger.error("Original directory not found: %s", original_dir)
        sys.exit(1)
    if not mutated_dir.is_dir():
        logger.error("Mutated directory not found: %s", mutated_dir)
        sys.exit(1)

    original_files = sorted(original_dir.glob("*.dfy"))
    if not original_files:
        logger.warning("No .dfy files found in %s", original_dir)

    for orig_path in original_files:
        stem = orig_path.stem
        mutant_folder = mutated_dir / stem
        
        if not mutant_folder.is_dir():
            logger.warning("Mutant folder missing for %s (Expected: %s)", orig_path.name, mutant_folder)
            continue
            
        mutants = sorted(mutant_folder.glob("*.dfy"))
        for mutant_path in mutants:
            line_num = extract_mutated_line_number(orig_path, mutant_path)
            
            key = f"{mutant_path.name}"
            results[key] = line_num

    return results


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Extract mutated line numbers into a JSON file."
    )
    parser.add_argument(
        "--original-dir", 
        type=Path, 
        required=True, 
        help="Directory containing original .dfy files"
    )
    parser.add_argument(
        "--mutated-dir", 
        type=Path, 
        required=True, 
        help="Directory containing folders of mutant files"
    )
    parser.add_argument(
        "--output-json", 
        type=Path, 
        default=Path("mutated_lines.json"), 
        help="Output JSON file path (default: mutated_lines.json)"
    )
    args = parser.parse_args(argv)

    logger.info("Starting mutation line extraction...")
    
    mapping = map_mutations(args.original_dir, args.mutated_dir)
    
    args.output_json.parent.mkdir(parents=True, exist_ok=True)
    with open(args.output_json, "w", encoding="utf-8") as f:
        json.dump(mapping, f, indent=4)
        
    logger.info("Successfully processed %d mutant files.", len(mapping))
    logger.info("Results saved to %s", args.output_json)


if __name__ == "__main__":
    main()