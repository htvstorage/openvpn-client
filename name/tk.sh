for s in `cat symbols.txt`; do 
echo $s; 
for x in `ls agg/*/$s*csv`; do awk -F, 'END{print substr(FILENAME,5,8)" "substr(FILENAME,14,3)" "$2" "$3 }' $x; done |sort -nk1|egrep -v "20221207|20221208|20221209" >> all/$s.txt
done
