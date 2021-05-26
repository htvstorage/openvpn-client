FROM alpine
MAINTAINER David Personette <dperson@gmail.com>

# Install openvpn
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add bash curl ip6tables iptables openvpn \
                shadow tini tzdata squid dhcp && \
    touch /var/lib/dhcp/dhcpd.leases && \
    addgroup -S vpn && \
    rm -rf /tmp/*

COPY start2.sh /usr/bin/
COPY root/ /

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
             CMD curl -LSs 'https://api.ipify.org'

VOLUME ["/vpn"]
VOLUME /etc/dhcp/
VOLUME /var/cache/squid/ /etc/squid/

EXPOSE 67/udp 67/tcp
EXPOSE 3128 3129


ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/start2.sh"]
