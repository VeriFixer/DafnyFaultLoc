import time
import re
from pathlib import Path
from src.llm.llm_create import create_llm
from src.llm.llm_model_registry import MODEL_REGISTRY
from src.utils.config import DATASET_ROOT

SELECTED_STRATEGIES = ["spec_bva"] 
SELECTED_MODELS = ["gpt-5-mini", "claude-sonnet-4.5"]

def get_system_prompt():
    return (
        "You are an expert formal verification engineer specializing in Dafny. "
        "Your task is to perform precise fault localization. You will be provided "
        "with a specific Dafny program, and, occasionally, its test cases. "
        "Do not hallucinate external context. "
        "Your output MUST be a valid JSON object with exactly two keys: 'lines' (a list of integers representing the buggy line numbers) "
        "and 'reason' (a single-sentence string explaining the root cause). Do not output any other text or explanation."
    )

def generate_user_prompt(method_code, all_tests):
    return f"""[TASK INSTRUCTION]
    Analyze the code and the following tests. Locate the bug.

    [DAFNY PROGRAM]
    {method_code}

    [TESTS]
    {all_tests}

    [OUTPUT FORMAT]
    Provide ONLY a valid JSON object in the following format:
    ```json
    {{
        "lines": [<int>, ...],
        "reason": "<one sentence reasoning>"
    }}
    ```"""

def parse_dafny_file(file_path: Path):
    try:
        content = file_path.read_text(encoding="utf-8")
        lines = content.splitlines()
        
        test_method_pattern = re.compile(r'method\s+\{\s*:test\}\s+([a-zA-Z0-9_]+)')
        
        split_index = None
        for idx, line in enumerate(lines):
            if test_method_pattern.match(line.strip()):
                split_index = idx
                break
                
        if split_index is None:
            return None, None
            
        method_part = "\n".join(lines[:split_index])
        test_part = "\n".join(lines[split_index:])
        
        return method_part.strip(), test_part.strip()
        
    except Exception as e:
        print(f"Error reading file {file_path.name}: {e}")
        return None, None

def run_dataset_cost_estimation():
    print("==================================================")
    print("   STARTING REAL DATASET COST ESTIMATION          ")
    print("==================================================")
    
    if not DATASET_ROOT.exists():
        print(f"ERROR: DATASET_ROOT path does not exist: {DATASET_ROOT.resolve()}")
        return

    # Use the cost stub provider to safely count real tokens without hitting APIs
    llm = create_llm("llm", "cost_stub_almost_real")
    
    total_files_processed = 0

    # 1. Iterate through your selected strategies
    for strategy in SELECTED_STRATEGIES:
        strategy_folder = DATASET_ROOT / f"tests_{strategy}"
        
        if not strategy_folder.exists():
            print(f"Warning: Folder {strategy_folder.name} not found. Skipping.")
            continue
            
        print(f"\nProcessing strategy folder: {strategy_folder.name}...")
        
        # 2. Iterate through all files in the strategy folder
        for file_path in strategy_folder.glob("*"):
            if not file_path.is_file():
                continue
                
            method_code, all_tests = parse_dafny_file(file_path)
            
            if not method_code or not all_tests:
                continue
                
            # 4. Generate the prompt using real content and pass to token counter stub
            llm.set_system_prompt(get_system_prompt())
            prompt = generate_user_prompt(method_code, all_tests)
            llm.get_response(prompt)
            
            total_files_processed += 1

    print("\n--------------------------------------------------")
    print(f"Dataset Processing Summary:")
    print(f" - Programs processed: {total_files_processed}")
    print("--------------------------------------------------")

    if total_files_processed == 0:
        print("No valid files were processed. Check your paths and executable line counts.")
        return

    # 5. Output comparison pricing tables for your chosen models
    for model_name in SELECTED_MODELS:
        if model_name not in MODEL_REGISTRY:
            print(f"Model {model_name} not found in registry.")
            continue
            
        print(f"\n[ESTIMATED BUDGET FOR MODEL: {model_name}]")
        model_info = MODEL_REGISTRY[model_name]
        llm.get_cost_statistics(model_info)

if __name__ == "__main__":
    run_dataset_cost_estimation()