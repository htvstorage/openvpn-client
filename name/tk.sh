for s in `cat symbols.txt`; do 
echo $s; 
for x in `ls agg/*/$s*csv`; do awk -F, 'BEGIN{val_sd=0;val_bu=0;}{val_sd += $35; val_bu += $34;}END{print substr(FILENAME,5,8)" "substr(FILENAME,14,3)" "$2" "$3" "$6" "val_bu" "val_sd }' $x; done |sort -nk1|egrep -v "20221207|20221208|20221209" > all/$s.txt
for x in `ls agg/*/$s*csv`; do awk -F, '{print substr(FILENAME,5,8)" "substr(FILENAME,14,3)" "$2" "$3" "$4" "$5" "$6 }' $x; done |sort -nk1|egrep -v "20221207|20221208|20221209" > all/$s"avg".txt
done

total=`cat symbols.txt |wc -l`;
count=0;
for s in `cat symbols.txt`; do
count=`bc <<< $count' +1'`
echo $s" "$count"/"$total" "`bc <<< 'scale=4; '$count'*100/'$total`
   tail -n 15 all/$s.txt > process/$s.txt
done


for s in `cat symbols.txt`; do 
   awk 'BEGIN{sum = 0}{ sum += $4}END{print $2" "sum}' process/$s.txt
done

for s in `cat symbols.txt`; do 
   awk 'BEGIN{sum = 0; sum_sd; sum_bu; sum_val}{ sum += $4; sum_sd += $7; sum_bu += $6; sum_val+= $5}END{if(sum_sd == 0) sum_sd = 0.001; print $2" "sum" bu "sum_bu" sd "sum_sd" sum_val "sum_val" busd "(sum_bu/sum_sd)}' process/$s.txt
done


total=`cat symbols.txt |wc -l`;
count=0;
for s in `cat symbols.txt`; do
count=`bc <<< $count' +1'`
echo $s" "$count"/"$total" "`bc <<< 'scale=4; '$count'*100/'$total`
grep -v acum_busd all/$s"avg.txt"|awk 'BEGIN{sum = 0; sum_sd; sum_bu; count; minbusd=99999999999; maxbusd=-99999999999; minsd=99999999999; maxsd=-99999999999; minbu=99999999999; maxbu=-99999999999}'\
'{ sum += $4; sum_sd += $7; sum_bu += $6; count += 1; if(minbusd> $4) minbusd = $4; if(maxbusd < $4) maxbusd = $4;'\
'if(minsd> $7 && length($7) > 0) minsd = $7; if(maxsd < $7) maxsd = $7;'\
'if(minbu > $6 && length($6) > 0) minbu = $6; if(maxbu < $6) maxbu = $6;}'\
'END{if(sum_sd == 0) sum_sd = 0.001; print $2" "sum" bu "sum_bu" sd "sum_sd" busd "sum_bu/sum_sd" '\
'abu "int(sum_bu/count)" asd "int(sum_sd/count)" abusd "int(sum/count)" minbusd "minbusd" maxbusd "maxbusd" minsd "minsd" maxsd "maxsd" minbu "minbu" maxbu "maxbu}' > process/$s"avg.txt"
done

