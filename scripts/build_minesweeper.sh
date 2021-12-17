#!/bin/bash

cd ..
mkdir -p lib

echo "===== Building JeMalloc"
cd jemalloc-msweeper-public
mkdir -p build
./autogen.sh --prefix=$(pwd)/build
make
make install

cp build/lib/libjemalloc.so ../lib/libjemalloc.so

echo "===== Building MineSweeper"
cd ../minesweeper-public
ln -s ../jemalloc-msweeper-public/include/jemalloc/ jemalloc
LDIR=$(pwd)/../lib make minesweeper

echo "===== Done building MineSweeper & JeMalloc"

