sudo apt update; 
sudo apt install 7zip;
d=`date +'%Y%m%d'`
7zz a data$d".7z" data$d".txt"
7zz a data3$d".7z" data3$d".txt"
7zz a data_ps_$d".7z" data_ps_$d".txt"
cd /workspace/openvpn-client/name/websocket
git add data$d.7z 
git add data3$d.7z
git add data_ps_$d".7z"
git commit -m "add"
git push




