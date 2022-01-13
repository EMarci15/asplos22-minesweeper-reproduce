#!/bin/bash

cd ..
mkdir -p lib

echo "===== Building JeMalloc"
cd jemalloc-msweeper-public
mkdir -p build
./autogen.sh --prefix=$(pwd)/build
make
make install

cp build/lib/libjemalloc.so ../lib/libjemalloc.so || { echo "JeMalloc failed to build!"; exit 1; }

echo "===== Building MineSweeper"
cd ../minesweeper-public
ln -s ../jemalloc-msweeper-public/include/jemalloc/ jemalloc
LDIR=$(pwd)/../lib make opt || { echo "MineSweeper failed to build!"; exit 1; }

cd ../scripts
echo "===== Done building MineSweeper & JeMalloc"

if [ ! -f "../lib/libjemalloc.so" ];
then
    echo "lib/libjemalloc.so not found. Build failed?"
    exit 1
fi

if [ ! -f "../lib/libminesweeper.so" ];
then
    echo "lib/libminesweeper.so not found. Build failed?"
    exit 1
fi

