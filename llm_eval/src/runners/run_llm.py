import re
import time
import json
from pathlib import Path
from src.llm.llm_create import create_llm
from src.utils.config import DATASET_ROOT, RESULTS_ROOT

SELECTED_STRATEGIES = ["path"] #, "path", "spec", "block" 
SELECTED_MODELS = ["gpt-5-mini"] # "claude-sonnet-4.5" 

experiment_report = {
    "no_tests": {},
    "all_tests": {},
    "total_execution_time": 0
}

def get_system_prompt():
    return (
        "You are an expert formal verification engineer specializing in Dafny. "
        "Your task is to perform precise fault localization. You will be provided "
        "with a specific Dafny program, and, occasionally, its test cases. "
        "Do not hallucinate external context. "
        "Your output MUST be a valid JSON object with exactly two keys: 'lines' (a list of integers representing the buggy line numbers) "
        "and 'reason' (a single-sentence string explaining the root cause). Do not output any other text or explanation."
    )

def generate_no_tests_prompt(method_code):
    return f"""[TASK INSTRUCTION]
Analyze the code and locate the bug based purely on the specification constraints.

[DAFNY PROGRAM]
{method_code}

[OUTPUT FORMAT]
Provide ONLY a valid JSON object in the following format:
```json
{{
    "lines": [<int>, ...],
    "reason": "<one sentence reasoning>"
}}
```"""

def generate_all_tests_prompt(method_code, all_tests):
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

def parse_llm_response(response_text: str) -> tuple[list[int], str]:
    """
    Extracts the JSON object from the LLM output.
    Handles raw JSON as well as JSON wrapped in markdown code blocks.
    """
    lines = []
    reason = "Failed to extract explanation."
    
    strict_match = re.search(r'```json\s*(\{.*?\})\s*```', response_text.strip(), re.DOTALL)
    
    if strict_match:
        json_str = strict_match.group(1)
    else:
        greedy_match = re.search(r'\{.*\}', response_text.strip(), re.DOTALL)
        if greedy_match:
            json_str = greedy_match.group(0)
    
    if json_str:
        try:
            parsed_data = json.loads(json_str)
            
            # Extract lines safely
            if "lines" in parsed_data and isinstance(parsed_data["lines"], list):
                lines = [int(x) for x in parsed_data["lines"] if str(x).strip().lstrip('-').isdigit()]
                
            # Extract reason safely
            if "reason" in parsed_data and isinstance(parsed_data["reason"], str):
                reason = parsed_data["reason"].strip()
                
        except json.JSONDecodeError:
            reason = "Failed to parse JSON. Raw output was invalid."
    else:
        # Fallback if no curly braces are found at all
        reason = "No JSON object found in response."

    return lines, reason

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

def load_existing_json(json_path: Path) -> dict:
    if json_path.exists():
        try:
            return json.loads(json_path.read_text(encoding="utf-8"))
        except Exception:
            print(f"Warning: Corrupt JSON detected at {json_path.name}. Creating a fresh database.")
    return {}

def save_json_results(json_path: Path, data: dict):
    json_path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(data, indent=4), encoding="utf-8")

def run_experiment_no_tests():
    print(f"\n=== STARTING EXPERIMENT 1 (NO TESTS) ===")
    exp_start_time = time.perf_counter()
    
    for strategy in SELECTED_STRATEGIES:
        print(f"  Processing Strategy Folder: {strategy}")

        strat_start_time = time.perf_counter()
        experiment_report["no_tests"][strategy] = {}

        strategy_folder = DATASET_ROOT / f"tests_{strategy}"
        if not strategy_folder.exists(): continue
            
        json_path = RESULTS_ROOT / "no_tests" / f"{strategy}_results.json"
        results_db = load_existing_json(json_path)
        
        for model_name in SELECTED_MODELS:
            print(f"    Running model: {model_name}")
            model_start_time = time.perf_counter()

            if model_name not in experiment_report["no_tests"][strategy]:
                experiment_report["no_tests"][strategy][model_name] = {
                    "files_processed": 0,
                    "input_tokens": 0,
                    "output_tokens": 0,
                    "total_cost_usd": 0.0,
                    "time_seconds": 0.0
                }
            
            processed = 0
            for file_path in strategy_folder.glob("*"):
                if not file_path.is_file(): continue
                
                method_code, _ = parse_dafny_file(file_path)
                if not method_code:
                    continue
                
                filename = file_path.name
                
                if filename in results_db and model_name in results_db[filename]:
                    continue 

                llm = create_llm("llm", model_name)
                llm.set_system_prompt(get_system_prompt())

                prompt = generate_no_tests_prompt(method_code)

                max_retries = 5
                base_delay = 1.5
                
                for attempt in range(max_retries):
                    try:
                        response = llm.get_response(prompt)
                        lines, reason = parse_llm_response(response)

                        snapshot = llm.get_cost_snapshot()
                        
                        report_ref = experiment_report["no_tests"][strategy][model_name]
                        report_ref["input_tokens"] += snapshot.total_tokens_input
                        report_ref["output_tokens"] += snapshot.total_tokens_output
                        report_ref["total_cost_usd"] += snapshot.total_cost_usd
                        report_ref["files_processed"] += 1
                        
                        if filename not in results_db:
                            results_db[filename] = {}
                            
                        results_db[filename][model_name] = {
                            "lines": lines,
                            "reason": reason
                        }
                        
                        processed += 1
                        if processed % 50 == 0: 
                            save_json_results(json_path, results_db)
                            print(f"      [Checkpoint] Processed and saved {processed} files...")

                        break
                    
                    except Exception as e:
                        print(f"      API Error on {filename} (Attempt {attempt + 1}/{max_retries}): {e}")
                        if attempt < max_retries - 1:
                            sleep_time = base_delay * (2 ** attempt) 
                            print(f"      Waiting {sleep_time} seconds before retrying...")
                            time.sleep(sleep_time)
                        else:
                            print(f"      Gave up on {filename} after {max_retries} attempts.")
                            if filename not in results_db:
                                results_db[filename] = {}
                            results_db[filename][model_name] = {
                                "lines": [],
                                "reason": "ERROR: Max retries exceeded or API failure."
                            }
                            processed += 1

                            if processed % 50 == 0: 
                                save_json_results(json_path, results_db)
                                print(f"      [Checkpoint] Processed and saved {processed} files...")
        
            save_json_results(json_path, results_db)
            print(f"    [Saved] {processed} files for {model_name} written to disk.")

            model_end_time = time.perf_counter()
            experiment_report["no_tests"][strategy][model_name]["time_seconds"] = round(model_end_time - model_start_time, 2)
            print(f"    [Time] {model_name} took {experiment_report['no_tests'][strategy][model_name]['time_seconds']} seconds.")
        
        strat_end_time = time.perf_counter()
        experiment_report["no_tests"][strategy]["total_strategy_time"] = round(strat_end_time - strat_start_time, 2)
        print(f"  [Time] Strategy '{strategy}' took {experiment_report['no_tests'][strategy]['total_strategy_time']} seconds.")

    exp_end_time = time.perf_counter()
    experiment_report["no_tests"]["total_experiment_time"] = round(exp_end_time - exp_start_time, 2)
    print(f"[Time] EXPERIMENT 1 took {experiment_report['no_tests']['total_experiment_time']} seconds.\n")

def run_experiment_all_tests():
    print(f"\n=== STARTING EXPERIMENT 2 (ALL TESTS) ===")
    exp_start_time = time.perf_counter()
    
    for strategy in SELECTED_STRATEGIES:
        print(f"  Processing Strategy Folder: {strategy}")
        strat_start_time = time.perf_counter()
        experiment_report["all_tests"][strategy] = {}
        strategy_folder = DATASET_ROOT / f"tests_{strategy}"
        if not strategy_folder.exists(): continue
            
        json_path = RESULTS_ROOT / "all_tests" / f"{strategy}_results.json"
        results_db = load_existing_json(json_path)
        
        for model_name in SELECTED_MODELS:
            print(f"    Running model: {model_name}")
            model_start_time = time.perf_counter()

            if model_name not in experiment_report["all_tests"][strategy]:
                experiment_report["all_tests"][strategy][model_name] = {
                    "files_processed": 0,
                    "input_tokens": 0,
                    "output_tokens": 0,
                    "total_cost_usd": 0.0,
                    "time_seconds": 0.0
                }
            
            processed = 0
            for file_path in strategy_folder.glob("*"):
                if not file_path.is_file(): continue
                
                method_code, all_tests = parse_dafny_file(file_path)
                if not method_code:
                    continue
                
                filename = file_path.name
                
                if filename in results_db and model_name in results_db[filename]:
                    continue 

                llm = create_llm("llm", model_name)
                llm.set_system_prompt(get_system_prompt())

                prompt = generate_all_tests_prompt(method_code, all_tests)

                max_retries = 5
                base_delay = 1.5
                
                for attempt in range(max_retries):
                    try:
                        response = llm.get_response(prompt)
                        lines, reason = parse_llm_response(response)

                        snapshot = llm.get_cost_snapshot()

                        report_ref = experiment_report["all_tests"][strategy][model_name]
                        report_ref["input_tokens"] += snapshot.total_tokens_input
                        report_ref["output_tokens"] += snapshot.total_tokens_output
                        report_ref["total_cost_usd"] += snapshot.total_cost_usd
                        report_ref["files_processed"] += 1
                        
                        if filename not in results_db:
                            results_db[filename] = {}
                            
                        results_db[filename][model_name] = {
                            "lines": lines,
                            "reason": reason
                        }
                        
                        processed += 1
                        if processed % 50 == 0: 
                            save_json_results(json_path, results_db)
                            print(f"      [Checkpoint] Processed and saved {processed} files...")

                        break

                    except Exception as e:
                        print(f"      API Error on {filename} (Attempt {attempt + 1}/{max_retries}): {e}")
                        if attempt < max_retries - 1:
                            sleep_time = base_delay * (2 ** attempt) 
                            print(f"      Waiting {sleep_time} seconds before retrying...")
                            time.sleep(sleep_time)
                        else:
                            print(f"      Gave up on {filename} after {max_retries} attempts.")
                            if filename not in results_db:
                                results_db[filename] = {}
                            results_db[filename][model_name] = {
                                "lines": [],
                                "reason": "ERROR: Max retries exceeded or API failure."
                            }
                            processed += 1

                            if processed % 50 == 0: 
                                save_json_results(json_path, results_db)
                                print(f"      [Checkpoint] Processed and saved {processed} files...")

            save_json_results(json_path, results_db)
            print(f"    [Saved] {processed} files for {model_name} written to disk.")

            model_end_time = time.perf_counter()
            experiment_report["all_tests"][strategy][model_name]["time_seconds"] = round(model_end_time - model_start_time, 2)
            print(f"    [Time] {model_name} took {experiment_report['all_tests'][strategy][model_name]['time_seconds']} seconds.")
        
        strat_end_time = time.perf_counter()
        experiment_report["all_tests"][strategy]["total_strategy_time"] = round(strat_end_time - strat_start_time, 2)
        print(f"  [Time] Strategy '{strategy}' took {experiment_report['all_tests'][strategy]['total_strategy_time']} seconds.")

    exp_end_time = time.perf_counter()
    experiment_report["all_tests"]["total_experiment_time"] = round(exp_end_time - exp_start_time, 2)
    print(f"[Time] EXPERIMENT 2 took {experiment_report['all_tests']['total_experiment_time']} seconds.\n")

def main():
    RESULTS_ROOT.mkdir(parents=True, exist_ok=True)
    global_start = time.perf_counter()
    
    run_experiment_all_tests()
    #run_experiment_no_tests()
    
    global_end = time.perf_counter()
    experiment_report["total_execution_time"] = round(global_end - global_start, 2)
    
    timings_path = RESULTS_ROOT / "execution_timings.json"
    save_json_results(timings_path, experiment_report)
    
    print(f"\nALL EXPERIMENTS COMPLETED SUCCESSFULLY IN {experiment_report['total_execution_time']} SECONDS.")
    print(f"Timing report saved to: {timings_path}")

if __name__ == "__main__":
    main()