# DafnyFaultLoc: Fault Localisation in Dafny

[![Dafny](https://img.shields.io/badge/Dafny-v4.11.0-blue.svg)](https://github.com/dafny-lang/dafny)
[![Z3](https://img.shields.io/badge/Z3-v4.12.1-red.svg)](https://github.com/Z3Prover/z3)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains the replication package and evaluation frameworks for the Master's dissertation **"Specification-Driven Test Generation for Fault Localisation in Dafny"**. 

While software verification offers strong mathematical guarantees of correctness, debugging verification failures is notoriously complex. This project bridges this gap by reconciling formal verification with the practical utility of testing. It includes the evaluation of two automated fault localisation approaches: **Spectrum-Based Fault Localisation (SBFL)** and **LLM-based Fault Localisation**.

## Key Contributions & Findings

* **[DSpec2Test](https://github.com/VeriFixer/DSpec2Test) (Submodule):** A novel specification-driven test generator for Dafny that uses Disjunctive Normal Form (DNF) for Equivalence Class Partitioning and Boundary Value Analysis (BVA). Evaluated on the [DafnyBench](https://github.com/sun-wendy/DafnyBench) dataset, this black-box approach (*SpecBva*) killed **91.5%** of realistically-killable mutants, outperforming traditional white-box approaches.

* **Custom Code Coverage Plugin:** The first per-test code coverage plugin for Dafny, designed to seamlessly handle infinite loops and recursive calls. Exact information on how to run it can be found [here](https://github.com/VeriFixer/DafnyFaultLoc/blob/main/coverage/README.md).

* **SBFL vs. LLM Evaluation:** In our SBFL evaluation, the combination of black-box (*SpecBva*) and white-box testing paired with the Ochiai coefficient yielded the best results (46.5% Top-1 accuracy). However, our non-deterministic LLM-based approach (using `gpt-5-mini`) drastically outperformed SBFL on complex codebases, achieving an Exact Match of ~75% and an Any Match exceeding 90%.

## Repository Structure

The repository is organised into modular components to facilitate reproducibility:

```python
|
|_ coverage/         # Custom Dafny plugin for per-test execution tracing.
|   |_ example/      # Example program to experiment coverage extraction.
|   |_ run/          # Execution scripts for the coverage pipeline.
|   |_ src/          # Source code for the Dafny plugin.
|   |_ README.md     # Specific instructions for building and running the plugin.
|
|_ external/
|   |_ dafny_test_gen/ # Submodule pointing to DSpec2Test
|
|_ llm_eval/         # Framework for LLM-based Fault Localisation (gpt-5-mini)
|   |_ dataset/      # Filtered subset of DafnyBench with generated tests
|   |_ results/      # LLLM-based fault localisation results
|   |_ src/          # LLLM-based fault localisation source code
|   |_ requirements.txt
|
|_ sbfl_eval/        # Framework for Spectrum-Based Fault Localisation
    |_ dataset/      # Filtered subset of DafnyBench with generated tests
    |_ results/      # SBFL results
    |_ src/          # SBFL source code
    |_ requirements.txt
````

## Acknowledgements

This work is financed by National Funds through the FCT (Fundação para a Ciência e a Tecnologia, I.P.) within the VeriFixer project ([Reference: 2023.15557.PEX](https://doi.org/10.54499/2023.15557.PEX)). Portions of this work have been accepted for presentation at the IEEE/ACM International Conference on Automated Software Engineering (ASE) 2026