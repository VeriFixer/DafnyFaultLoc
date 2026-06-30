# Dafny Test Coverage Plugin

This plugin returns the test coverage of each test over a Dafny program.

## Usage

Inside the `coverage` folder run:

```bash
python3 run/coverage.py example/example.dfy
```

Optionally, you can pass your Dafny's location using the `--dafny` flag:

```bash
python3 run/coverage.py example/example.dfy --dafny /path/to/dafny
```

## Example Output

Given a Dafny test file, the standard output of the program will look something like this:
```
--- COVERAGE SUMMARY FOR: example/example.dfy ---
❌ FAIL | Test1: Covered lines [6, 7]
❌ FAIL | Test100: Covered lines [6, 7]
✅ PASS | Test0: Covered lines [6, 9, 10]
❌ FAIL | TestN1: Covered lines [6, 9, 12, 13]
❌ FAIL | TestN100: Covered lines [6, 9, 12, 13]
```

## Known Limitations

Although this plugin is robust enough to support infinite while loops, it is currently unable to support infinite recursive calls.