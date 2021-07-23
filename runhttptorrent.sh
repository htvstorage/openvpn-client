mkdir -p downloads
docker run -d -p 3000:3000 -v $PWD/downloads:/downloads jpillora/cloud-torrent
docker run -dit --name my-apache-app -p 8081:80 -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4


