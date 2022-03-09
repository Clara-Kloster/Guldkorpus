
for FILE in *.dipl
do
  mv "$FILE" ${FILE:4:7}
done