# execute revbayes on each run file
mkdir -p out
for FILE in run/*; do
    rb --file $FILE
done
