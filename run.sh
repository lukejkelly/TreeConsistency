# constrained
R -f src/constrained-setup.r
bash run/constrained.sh
R -f src/constrained-plot.r

# unconstrained
R -f src/unconstrained-setup.r
bash run/unconstrained.sh
R -f src/unconstrained-plot.r
