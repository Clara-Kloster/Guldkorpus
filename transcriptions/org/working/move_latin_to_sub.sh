
for FILE in $(cat latin.txt)
do
  echo "$FILE"
  cp "$FILE" latin/
done