#!/bin/bash

mkdir data configs run out figs

R -f src/constrained-setup.r
R -f src/unconstrained-setup.r
