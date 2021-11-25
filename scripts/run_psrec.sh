#!/bin/bash

cd ../SPEC
source ./shrc

if [ -z "$1" ]
    then benchmarks="astar bzip2 dealII gcc gobmk h264ref hmmer lbm libquantum mcf milc namd omnetpp perlbench povray sjeng soplex sphinx3 xalancbmk"
    else benchmarks="$@"
fi

mkdir -p ../ps

for BENCHMARK in $benchmarks
do
    for CONFIG in je minesweeper
    do
        echo "=== Running $BENCHMARK for configuration $CONFIG"
        runspec --config=$CONFIG.cfg --action=setup ${BENCHMARK} -I
        ../psrecord --include-children --interval 0.5 --log "../ps/${BENCHMARK}-${CONFIG}.txt" "runspec --size=ref --iterations=1 --config=$CONFIG.cfg ${BENCHMARK}"
    done
done

cd ../scripts

