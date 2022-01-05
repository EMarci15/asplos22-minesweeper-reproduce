#!/bin/bash

cd ..

echo "===== Building SPEC"

if [ ! -d "SPEC" ]
then
    echo "Looking for SPEC ISO file:"
    ls *cpu2006*.iso || { echo "SPEC ISO not found!"; exit 1; }

    mkdir -p specmnt

    sudo mount -o loop *cpu2006*.iso specmnt

    mkdir -p SPEC

    cd specmnt
    ./install.sh -d ../SPEC
    cd ..
    sudo umount specmnt
    rm -r specmnt
else
    echo "SPEC directory already exists, skipping install."
    echo "To force reinstall, run 'rm -rf SPEC' in the base directory."
fi

cp spec_confs/x86_64_base.cfg SPEC/config/base.cfg
cp spec_confs/x86_64_je.cfg SPEC/config/je.cfg
cp spec_confs/x86_64_minesweeper.cfg SPEC/config/minesweeper.cfg

export LDIR="$(pwd)/lib"
sed -i "s~LIBDIR~${LDIR}~g" SPEC/config/je.cfg
sed -i "s~LIBDIR~${LDIR}~g" SPEC/config/minesweeper.cfg

echo "===== Building SPEC benchmarks"

cd SPEC
. ./shrc
runspec --config=base.cfg --action=build astar bzip2 dealII gcc gobmk h264ref hmmer lbm libquantum mcf milc namd omnetpp perlbench povray sjeng soplex sphinx3 xalancbmk -I

cd ../scripts

echo "===== Done building SPEC & benchmarks"
