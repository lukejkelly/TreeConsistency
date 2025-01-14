#!/bin/bash

# sample finite sites data then process into subsequences
mkdir -p data/raw data/proc
R -f code/data/generate-data.R
R -f code/data/process-data.R
