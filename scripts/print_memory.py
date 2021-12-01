#!/bin/python3

from io import StringIO
import itertools 
import pandas as pd
import sys

BENCHMARKS = ["astar", "bzip2", "dealII", "gcc", "gobmk", "h264ref", "hmmer", "lbm", "libquantum", "mcf", "milc", "namd", "omnetpp", "perlbench", "povray", "sjeng", "soplex", "sphinx3", "xalancbmk"]

def spec_strip_name(name):
    return name.split(".")[-1]


# Discard unnecessary columns & give sensible names
def fix_column_names(dataframe):
    return dataframe.drop(columns=["#"])\
                    .rename(columns={"Elapsed time": "time", "CPU (%)": "cpu", "Real (MB)": "mem", "Virtual (MB)": "virt"})

# HACK to remove the footprint of the SPEC tools.
# Not doing this would skew the results in our favour for two reasons:
#     1. The first and last few seconds of the run are unaffected by adding
#        MineSweeper, therefore including them reduces relative overheads.
#     2. Including the static ~60MiB footprint of SPEC over the whole run
#        significantly reduces relative memory overheads.
# Method: Find the time at start & end of the minesweeper run where the virtual
#         memory footprint is <2TiB (i.e. no shadow map exists), and remove
#         this many seconds from both the baseline and minesweeper runs.
#         Then, subtract 60MiB from all recorded physical memory usage entries
#         in both runs.
def remove_spec(base, minesweeper, corr=60.0):
    m_end_time = minesweeper.iloc[-1].time

    # Filter minesweeper run
    minesweeper = minesweeper.loc[minesweeper.virt.ge(2000000.0)]
    if (minesweeper.time.count() == 0):
        print("ERROR: Virtual memory usage never above 2TiB!")
        print("       Did MineSweeper ever get loaded?")
        sys.exit(102)

    # Find time amount removed at the start and at the end
    min_time = minesweeper.iloc[0].time
    max_time = m_end_time - minesweeper.iloc[-1].time

    # Find first and last baseline sample with the same amount of time removed
    base_min_ind = base.time.ge(min_time).idxmax()
    base_max_ind = base.time.ge(base.iloc[-1].time - max_time).idxmax()-1

    # Remove these intervals from the start and end of the baseline run
    base = base.loc[base_min_ind:base_max_ind]

    # Adjust both traces to start at time 0
    base.time -= base.time.iloc[0]
    minesweeper.time -= minesweeper.time.iloc[0]
    
    # Adjust memory usage by -60MiB
    base.mem -= corr
    minesweeper.mem -= corr
    
    return (base,minesweeper)

# Read in data for a benchmark
def read_all():
    results = pd.DataFrame(index=pd.Index(BENCHMARKS))
    for benchmark in BENCHMARKS:
        print(f"Reading {benchmark}...")
        try:
            base = pd.read_fwf(f"{DIR}/{benchmark}-je.txt")
            minesweeper = pd.read_fwf(f"{DIR}/{benchmark}-minesweeper.txt")

            base, minesweeper = remove_spec(fix_column_names(base), fix_column_names(minesweeper))

            results["baseline"].loc[benchmark] = base["mem"].mean()
            results["minesweeper"].loc[benchmark] = minesweeper["mem"].mean()
        except FileNotFoundError as e:
            print("")
            print(e)
    print(f"Done reading traces!")
    return results

def gmean(df):
    return (df**(1/len(df.index))).prod()

DIR="../ps"

print(f"Reading psrecord memory traces from directory: {DIR}")

results = read_all()

print("========================================")
print("==== Memory usage: =====================")
print("========================================")
print(results)
print("")

overhead = results["minesweeper"] / results["baseline"]
overhead.loc["geomean"] = gmean(overhead)

print("========================================")
print("==== Overhead: =========================")
print("========================================")
print(overhead)

bmarks = ["astar", "bzip2", "dealII", "gcc", "gobmk", "h264ref", "hmmer", "lbm", "libquantum", "mcf", "milc", "namd", "omnetpp", "perlbench", "povray", "sjeng", "soplex", "sphinx3", "xalancbmk"]
failed = []
for bmark in bmarks:
    if bmark in overhead.index:
        continue
    failed.append(bmark)

if len(failed) != 0:
    print("!!! The following benchmarks failed to run:")
    print("\n".join(failed)
