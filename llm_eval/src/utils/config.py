"""Central configuration for LLM-based fault localisation pipeline

Marker-based root discovery, path constants.
"""

from pathlib import Path
import os
from multiprocessing import cpu_count
from enum import Enum

import psutil


def find_repo_root(marker: str = ".repo_llm_marker") -> Path:
    """Walk up from this file looking for the marker file.

    Args:
        marker: Filename to search for.

    Returns:
        Path to the directory containing the marker.

    Raises:
        FileNotFoundError: If marker not found traversing up from __file__.
    """
    current: Path = Path(__file__).resolve().parent
    while str(current) != current.root:
        if (current / marker).exists():
            return current
        current = current.parent
    raise FileNotFoundError(
        f"Could not find '{marker}'. Ensure you're running inside the llm_eval repo."
    )

# ---------------------------------------------------------------------------
# Enums — type-safe strategy selection
# ---------------------------------------------------------------------------

class ExampleStrategy(Enum):
    """Example retrieval strategy for prompt augmentation."""
    NONE = "NONE"
    RANDOM = "RANDOM"
    TFIDF = "TFIDF"
    EMBEDDED = "EMBEDDED"
    DYNAMIC = "DYNAMIC"

# === Repository Structure ===
BASE_PATH: Path = find_repo_root()
DATASET_ROOT: Path = BASE_PATH / f"dataset"
RESULTS_ROOT: Path = BASE_PATH / f"results"
GRAPHS_ROOT: Path = BASE_PATH / f"results" / "graphs"
TABLES_ROOT: Path = BASE_PATH / f"results" / "tables"
DAFNY_ASSERTION_DATASET: Path = BASE_PATH / "dataset/dafny_assertion_dataset"

# === test_gen_eval Structure to gather dataset from ===
TEST_GEN_DATASET_ROOT: Path = BASE_PATH.parent / "external" / "dafny_test_gen" / "Evaluation" / "dataset"
TEST_GEN_FORMATTED_ROOT: Path = BASE_PATH.parent / "external" / "dafny_test_gen" / "Evaluation" / "dataset" / "selected_programs_formatted"
TEST_GEN_DATASET_OUT_ROOT: Path = BASE_PATH.parent / "external" / "dafny_test_gen" / "Evaluation" / "dataset_output"
TEST_GEN_RESULTS_ROOT: Path = BASE_PATH.parent / "external" / "dafny_test_gen" / "Evaluation" / "results"

COVERAGE_ROOT: Path = BASE_PATH.parent / "sbfl_eval" / "results"

# === Coverage Plugin Structure ===
PLUGIN_PATH: Path = BASE_PATH.parent / "coverage" / "src" / "bin" / "Release" / "net8.0" / "DafnyTestCoverage.dll"
RUNTIME_PATH: Path = BASE_PATH.parent / "coverage" / "src" / "CoverageRuntime.cs"
EXTERN_PATH: Path = BASE_PATH.parent / "coverage" / "src" / "CoverageExterns.dfy"

# === Dafny Binary ===
_DAFNY_BINARY_LOCAL: Path = BASE_PATH.parent / "external" / "dafny_test_gen" / "Binaries" / "Dafny"
DAFNY_BINARY: Path = _DAFNY_BINARY_LOCAL if _DAFNY_BINARY_LOCAL.exists() else Path("dafny")

# === Memory Limit for Dafny/Z3 solver (MB) ===
# Default: 75% of total system RAM. Override with MT_MAX_MEMORY_MB env var.
MAX_JOBS: int = max(1, int(os.environ.get("MT_MAX_JOBS", str(max(int(cpu_count() / 2), 1)))))
_total_ram_mb = psutil.virtual_memory().total // (1024 * 1024)
DAFNY_MAX_MEMORY_MB: int = int(os.environ.get(
    "MT_MAX_MEMORY_MB",
    str(int(_total_ram_mb * 0.75/ MAX_JOBS)),
))