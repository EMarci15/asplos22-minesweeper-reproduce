#!/usr/bin/python3

import os

runs = [int(file.split(".")[1]) for file in os.listdir("../SPEC/result")\
          if (("CPU2006." in file) and (".log" in file))]
runs.append(-1)
last_run = max(runs)

print(f"Last run: {last_run:03}.")
print(f"Logging: BASELINE={last_run+1:03} MINESWEEPER={last_run+2:03}")

with open("../runs.txt", "w") as f:
  f.write(f"BASELINE={last_run+1:03}\nMINESWEEPER={last_run+2:03}\n")
  f.close()

