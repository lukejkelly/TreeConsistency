# run mrbayes on each file in configs/
for FILE in configs/un*; do
    FILENAME=$(basename "$FILE")
    FILESTEM=${FILENAME/.mb/}
    echo starting ${FILESTEM//-/ } at $(date)
    mb configs/"$FILESTEM".mb > out/"$FILESTEM".log
done
