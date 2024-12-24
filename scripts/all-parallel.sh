#!/bin/bash

# run all analysis steps
bash scripts/clean.sh
bash scripts/trees.sh
bash scripts/data.sh
bash scripts/model.sh
bash scripts/run-parallel.sh
bash scripts/plot.sh
