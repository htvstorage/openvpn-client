 for x in {1..388} ; do
 #echo $x;
 	p="";
 	if [ $x -ge 1 ] && [ $x -le 9 ] 
	then
 		p="000"$x
 	elif [ $x -ge 10 ] && [ $x -le 99 ] 
	then
		p="00"$x
	elif [ $x -ge 100 ] && [ $x -le 388 ]
	then
		p="0"$x
	else
		echo "ok"
	fi

 echo $p;


curl 'https://ia803408.us.archive.org/BookReader/BookReaderImages.php?zip=/18/items/chontentheophuon0000unse/chontentheophuon0000unse_jp2.zip&file=chontentheophuon0000unse_jp2/chontentheophuon0000unse_'$p'.jp2&id=chontentheophuon0000unse&scale=1&rotate=0' \
  -H 'authority: ia803408.us.archive.org' \
  -H 'pragma: no-cache' \
  -H 'cache-control: no-cache' \
  -H 'sec-ch-ua: "Chromium";v="92", " Not A;Brand";v="99", "Google Chrome";v="92"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36 SFive/73.0' \
  -H 'accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: no-cors' \
  -H 'sec-fetch-dest: image' \
  -H 'referer: https://archive.org/details/chontentheophuon0000unse/page/8/mode/2up' \
  -H 'accept-language: en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7' \
  -H 'cookie: donation-identifier=1a94abb85d74ced6b3c39a210368f51f; abtest-identifier=496cb9cdddfd00d09583b004bf483fff; test-cookie=1; logged-in-sig=1694761190%201663225190%20StCzzrbVafb%2BcT0vsOCDBiVcnqco1yRODjnh6zWJFSVxw8s5Usdr0LOPKvU1s7OJqmIipISkVR43NR6AXBUM308x7u2GNESG5JeemZDYs17m6VY%2FOrDsToafRwga9coXjcQGVIwLmL%2B9jlmVUdiKziBmKfsg527tlrAA%2BL8kQGo%3D; logged-in-user=trinhvanhung%40gmail.com; PHPSESSID=nj5pfgiu2bbantr7t5f1e4essa; collections=printdisabled; br-loan-chontentheophuon0000unse=1; ol-auth-url=%2F%2Farchive.org%2Fservices%2Fborrow%2FXXX%3Fmode%3Dauth; loan-chontentheophuon0000unse=1663312297-0ca0c30bf9501f42fa1ed65f3f35e049' \
  --compressed -o $p".jpg"


 done
