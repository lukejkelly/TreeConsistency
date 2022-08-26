#!/bin/bash

bash run/constrained.sh
R -f src/constrained-plot.r

bash run/unconstrained.sh
R -f src/unconstrained-plot.r
