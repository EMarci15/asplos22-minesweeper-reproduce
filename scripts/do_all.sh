#!/bin/bash

# Install dependencies
./dependencies.sh

# Clone the two MineSweeper repositories:
#     minesweeper contains the main code
#     jemalloc-msweeper contains a minimally modified jemalloc version
./clone.sh

# Build SPEC, JeMalloc and MineSweeper
./build.sh
mkdir -p ../results

# Run time slowdown analysis (run+result processing)
./run_spec.sh
./print_time.py >../results/time.txt

# Run memory slowdown analysis (run+result processing)
./run_psrec.sh
./print_memory.py >../results/memory.txt

# Print the final results
cat ../results/time.txt
cat ../results/memory.txt
