FROM alpine:latest
MAINTAINER docker@chabs.name

ENV AMULE_VERSION 2.3.3

RUN apk --update add gd geoip libpng libwebp pwgen sudo zlib bash
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  amule

# Install a nicer web ui
RUN cd /usr/share/amule/webserver \
    && git clone https://github.com/MatteoRagni/AmuleWebUI-Reloaded \
    && rm -rf AmuleWebUI-Reloaded/.git AmuleWebUI-Reloaded/doc-images

# Add startup script
ADD amule.sh /home/amule/amule.sh

# Final cleanup
RUN chmod a+x /home/amule/amule.sh \
    && rm -rf /var/cache/apk/* && rm -rf /opt \
    && apk del build-dependencies

EXPOSE 4711/tcp 4712/tcp 4672/udp 4665/udp 4662/tcp 4661/tcp

ENTRYPOINT ["/home/amule/amule.sh"]
