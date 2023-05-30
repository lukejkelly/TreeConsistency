# run revbayes on each file in configs/
mkdir -p out
for FILE in configs/*; do
    rb --file $FILE
done
