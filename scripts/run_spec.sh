#!/bin/bash

echo "===== Running SPEC for time overhead"

./update_runs.py

cd ../SPEC

. ./shrc

echo "===== Running Baseline for time overhead"
runspec --config=je.cfg --action=run --size=ref --noreportable --iterations=1 astar bzip2 dealII gcc gobmk h264ref hmmer lbm libquantum mcf milc namd omnetpp perlbench povray sjeng soplex sphinx3 xalancbmk -I

echo "===== Running Minesweeper for time overhead"
runspec --config=minesweeper.cfg --action=run --size=ref --noreportable --iterations=1 astar bzip2 dealII gcc gobmk h264ref hmmer lbm libquantum mcf milc namd omnetpp perlbench povray sjeng soplex sphinx3 xalancbmk -I

echo "===== Done running SPEC for time overhead"

cd ../scripts
