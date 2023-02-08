for s in `cat symbols.txt`; do 
echo $s; 
for x in `ls agg/*/$s*csv`; do awk -F, 'END{print substr(FILENAME,5,8)" "substr(FILENAME,14,3)" "$2" "$3" "$4" " }' $x; done |sort -nk1|egrep -v "20221207|20221208|20221209" >> all/$s.txt
done

total=`cat symbols.txt |wc -l`;
count=0;
for s in `cat symbols.txt`; do
count=`bc <<< $count' +1'`
echo $s" "$count"/"$total" "`bc <<< 'scale=4; '$count'*100/'$total`
   tail -n 10 all/$s.txt > process/$s.txt
done


for s in `cat symbols.txt`; do 
   awk 'BEGIN{sum = 0}{ sum += $4}END{print $2" "sum}' process/$s.txt
done
