# asplos22-minesweeper-reproduce

This is the artifact for the ASPLOS'22 paper **MineSweeper: a "clean sweep" for drop-in use-after-free prevention**.

## Contents
This directory contains scripts to build, run and evaluate our implementation's time and memory usage cost over the C/C++ portion of the SPEC CPU&copy; 2006 benchmark suite.

The implementation itself comes in two separate repositories. These are added as submodules to this one, therefore you can get them by using the `--recurse-submodules` option when cloning this repository:

> git clone --recurse-submodules https://github.com/EMarci15/asplos22-minesweeper-reproduce.git

*(Note: If you cloned without this option, the folders `minesweeper-public` and `jemalloc-msweeper-public` will be empty, but the script will populate them for you by calling `scripts/clone.sh`)*

For license reasons, we cannot include the SPEC files, so you will need to add your .iso disk image yourself. Add this to the root directory of this repository.

## How to run
After cloning the repository and inserting the SPEC .iso disk image (as described above), you can simply build, run and evaluate the results as follows:


    cd scripts
    ./do_all.sh

If debugging is needed, you want to customise your run (e.g. because you do not have sudo rights), or you just want to build the repository, you can also issue the commands manually. See `scripts/do_all.sh` for details of what each script does, and what order they are designed to be invoked in. ***Note: All the scripts need to be invoked with the working directory set to `asplos22-minesweeper-reproduce/scripts`!***

The results will be printed to the screen and placed in two text files in the `results` folder.

## System requirements
We created and tested this artifact on Ubuntu 14.04 and 20.04. Older versions, or a different Linux distribution should also work, but this is untested, and you may need to change the package names and/or their install method (see `scripts/dependencies.sh`). The artifact is designed to run on x86_64, and some implementation details are specific to this, however porting to different architectures should be possible.

## Results to expect
As reported in the paper, this setup[^1] produced the following results on our machine in terms of geometric mean over the whole benchmark set:

**Slowdown: 4.9%**
**Memory over: 14.8%**

Every system differs, and you might see somewhat different results (on another machine we saw lower partial overheads, and we saw higher overheads for schemes we reproduced than reported in the original papers), but the results should be in the same region.

Note that failures will change the geomean results, so watch out for this if the script reports failed benchmarks. For us, *soplex* failed (both baseline and minesweeper runs), but the other benchmarks ran correctly.

[^1]: For the reported results, we took the median of three runs, whereas the artifact only runs the tests a single time to save time.
