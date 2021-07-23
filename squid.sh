docker run --rm -t --net=container:vpn \
  --name docker_squid \
  -c 256 -m 256m \
  -e PGID=1000 -e PUID=1000 \
  -v $PWD/data/config:/etc/squid \
  -v $PWD/data/cache:/var/cache/squid \
  -v /etc/hosts:/etc/hosts:ro \
  -v /etc/localtime:/etc/localtime:ro \
  woahbase/alpine-squid:x86_64

