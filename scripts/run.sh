# path to revbayes executable
RB=/Users/kelly/.bin/rb

# execute revbayes on each run file
mkdir -p out
for FILE in run/*; do
    "$RB" --file $FILE
done
