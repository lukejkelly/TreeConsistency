# run revbayes on each file in configs/
for FILE in configs/*; do
    rb --file $FILE
done
