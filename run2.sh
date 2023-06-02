# run revbayes on each file in configs/
for FILE in configs/kingman-*; do
    rb --file $FILE
done &
for FILE in configs/uniform-*; do
    rb --file $FILE
done &
wait
