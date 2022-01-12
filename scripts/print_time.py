#!/usr/bin/python3

from io import StringIO
import itertools 
import pandas as pd
import sys
    
def spec_strip_name(name):
    return name.split(".")[-1]

def gmean(df):
    return (df**(1/len(df.index))).prod()

def read_spec_txt(filename):
    with open(filename,"r") as f:
        f = list(\
              itertools.takewhile(lambda s : s.startswith("4"),\
                list(itertools.dropwhile(lambda s : not s.startswith("="),f))[1:]))
        sio = StringIO(''.join(f))
        
        df = pd.read_fwf(sio, header=None, names=["benchmark", "ref", "time", "ratio", "x"], )\
               .drop(columns=["ref", "ratio", "x"])\
               .dropna()
        df = df.reset_index(drop=True).set_index("benchmark", drop=True)
        df.index = df.index.map(spec_strip_name)
        return df

def read_spec(num, DIR):
    try:
        i = read_spec_txt(f"{DIR}/CINT2006.{num:03}.txt")
        fp = read_spec_txt(f"{DIR}/CFP2006.{num:03}.txt")
    except FileNotFoundError:
        i = read_spec_txt(f"{DIR}/CINT2006.{num:03}.ref.txt")
        fp = read_spec_txt(f"{DIR}/CFP2006.{num:03}.ref.txt")
    return pd.concat([i,fp])

print("===== Printing time overhead")
print("Finding results...")
DIR="../SPEC/result"
try:
    with open("../runs.txt","r") as f:
        ls = [line.rstrip() for line in f.readlines()]
        assert (len(ls) >= 2)
        assert ("BASELINE" in ls[0])
        BASELINE = int(ls[0].split("=")[-1])
        assert ("MINESWEEPER" in ls[1])
        MINESWEEPER = int(ls[1].split("=")[-1])
except FileNotFoundError as e:
    print("Can't find ../runs.txt!")
    print("Make sure you run the experiments first, and start this script from the 'scripts' folder")
    sys.exit(101)

print(f"Reading spec2006 results from directory: {DIR}")
print(f"Reading BASELINE ({BASELINE:03})")
base = read_spec(BASELINE, DIR)
print(f"Reading MINESWEEPER ({MINESWEEPER:03})")
minesweeper = read_spec(MINESWEEPER, DIR)

results = pd.DataFrame()
results["baseline"] = base["time"]
results["minesweeper"] = minesweeper["time"]

print("========================================")
print("==== Runtimes: =========================")
print("========================================")
print(results)
print("")

slowdown = results["minesweeper"] / results["baseline"]
slowdown.loc["geomean"] = gmean(slowdown)

print("========================================")
print("==== Slowdown: =========================")
print("========================================")
print(slowdown)

bmarks = ["astar", "bzip2", "dealII", "gcc", "gobmk", "h264ref", "hmmer", "lbm", "libquantum", "mcf", "milc", "namd", "omnetpp", "perlbench", "povray", "sjeng", "soplex", "sphinx3", "xalancbmk"]
failed = []
for bmark in bmarks:
    if bmark in slowdown.index:
        continue
    failed.append(bmark)

if len(failed) != 0:
    print("!!! The following benchmarks failed to run:")
    print("\n".join(failed))

