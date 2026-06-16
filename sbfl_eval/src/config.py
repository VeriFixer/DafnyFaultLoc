"""Central configuration for SBFL pipeline

Marker-based root discovery, path constants.
"""

from pathlib import Path
import os
from multiprocessing import cpu_count

import psutil


def find_repo_root(marker: str = ".repo_sbfl_marker") -> Path:
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
        f"Could not find '{marker}'. Ensure you're running inside the sbfl_eval repo."
    )


# === Repository Structure ===
BASE_PATH: Path = find_repo_root()
DATASET_ROOT: Path = BASE_PATH / "dataset"
RESULTS_ROOT: Path = BASE_PATH / "results"

# === test_gen_eval Structure to gather dataset from ===
TEST_GEN_GROUND_TRUTH_ROOT: Path = BASE_PATH.parent / "test_gen_eval" / "dataset" / "data"
TEST_GEN_DATASET_OUT_ROOT: Path = BASE_PATH.parent / "test_gen_eval" / "dataset_output"
TEST_GEN_RESULTS_ROOT: Path = BASE_PATH.parent / "test_gen_eval" / "results"

# === Coverage Plugin Structure ===
PLUGIN_PATH: Path = BASE_PATH.parent / "coverage" / "src" / "bin" / "Release" / "net8.0" / "DafnyTestCoverage.dll"
RUNTIME_PATH: Path = BASE_PATH.parent / "coverage" / "src" / "CoverageRuntime.cs"
EXTERN_PATH: Path = BASE_PATH.parent / "coverage" / "src" / "CoverageExterns.cs"

# === Dafny Binary ===
_DAFNY_BINARY_LOCAL: Path = BASE_PATH.parent.parent / "dafny" / "Binaries" / "Dafny"
DAFNY_BINARY: Path = _DAFNY_BINARY_LOCAL if _DAFNY_BINARY_LOCAL.exists() else Path("dafny")

# === Repetition cut-off for each strategy ===
BLOCK_REP: 10
PATH_REP: 10
SPEC_REP: 10
SPEC_BVA_REP: 10

# === Memory Limit for Dafny/Z3 solver (MB) ===
# Default: 75% of total system RAM. Override with MT_MAX_MEMORY_MB env var.
MAX_JOBS: int = max(1, int(os.environ.get("MT_MAX_JOBS", str(max(int(cpu_count() / 2), 1)))))
_total_ram_mb = psutil.virtual_memory().total // (1024 * 1024)
DAFNY_MAX_MEMORY_MB: int = int(os.environ.get(
    "MT_MAX_MEMORY_MB",
    str(int(_total_ram_mb * 0.75/ MAX_JOBS)),
))