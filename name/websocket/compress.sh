sudo apt update; 
sudo apt install 7zip;
d=`date +'%Y%m%d'`
7zz a data$d".7z" data$d".txt"
cd /workspace/openvpn-client/name/websocket
git add "./data"$d".7z"
git commit -m "add"
git push




