#!/bin/bash

echo "===== Cloning Minesweeper repositories"

git submodule init
git submodule update --remote

echo "===== Done cloning/already cloned."

