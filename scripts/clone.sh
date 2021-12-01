#!/bin/bash

echo "Cloning Minesweeper repositories"
cd ..

if [ ! -f "minesweeper-public/.git" ]; then
    echo 'MineSweeper submodule not found, calling "git submodule init"...'
    cd minesweeper-public
    git submodule init
    cd ..
fi

if [ ! -f "jemalloc-msweeper-public/.git" ]; then
    echo 'JeMalloc (msweeper) submodule not found, calling "git submodule init"...'
    cd jemalloc-msweeper-public
    git submodule init
    cd ..
fi

echo "Done cloning/already cloned."

cd scripts

