# sample finite sites JC69 alleles then process into subsequences
mkdir -p data/{raw,proc}
R -f code/data/generate-data.R
R -f code/data/process-data.R
