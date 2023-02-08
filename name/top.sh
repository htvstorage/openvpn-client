total=`cat hose.txt |wc -l`;
count=0;
echo > update.txt
for s in `cat hose.txt`; do 
   ##echo $s;
   ##expr length $s
   current=`date +%s%3N`; 
   current=`bc <<< $current'/(5*60*1000)*5*60*1000 + 7*60*60*1000 - 60*60*1000'`;
   Y=`date +"%Y"`;
   m=`date +"%m"`;
   d=`date +"%d"`;   
   ##echo $s;
   for x in `ls trans/20230208/$s*.txt`; do 
      awk -F, -v current=$current -v symbol=$s -v Y=$Y -v m=$m -v d=$d\
      '{t=substr($5,2,8);  gsub(":"," ",t);  time=mktime(Y" "m" "d" "t)*1000; if(time > current) {print symbol" "time" "$1" "$2" "$3" "$0}}'\
      $x; 
   done >> update.txt
done
grep sd update.txt|sort -nk5|tail -n 20
grep bu update.txt|sort -nk5|tail -n 20