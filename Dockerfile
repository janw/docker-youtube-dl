
FROM lsiobase/alpine:3.10
ARG BUILD_DATE
ARG VCS_REF
ENV YDL_SIGNING_KEY=ED7F5BF46B3BBED81C87368E2C393E0F18A9236D


ENV LOG=yes
RUN apk add --no-cache ca-certificates wget ffmpeg python gnupg bash && \
    LATEST=$(wget -qO- https://api.github.com/repos/rg3/youtube-dl/releases/latest | \
        grep '"tag_name": ' | sed -E 's/.*"([^"]+)".*/\1/') && \
    wget -q https://github.com/rg3/youtube-dl/releases/download/$LATEST/youtube-dl -O /usr/local/bin/youtube-dl && \
    wget -q https://github.com/rg3/youtube-dl/releases/download/$LATEST/youtube-dl.sig -O /tmp/youtube-dl.sig && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys $YDL_SIGNING_KEY && \
    gpg --verify /tmp/youtube-dl.sig /usr/local/bin/youtube-dl && \
    SHA256=$(wget -qO- https://github.com/rg3/youtube-dl/releases/download/$LATEST/SHA2-256SUMS | head -n 1 | cut -d " " -f 1) && \
    [ $(sha256sum /usr/local/bin/youtube-dl | cut -d " " -f 1) = "$SHA256" ] && \
    apk del gnupg wget && \
    rm -rf /var/cache/apk/* /tmp/youtube-dl.sig && \
    chmod +x /usr/local/bin/youtube-dl

HEALTHCHECK --interval=1m --start-period=15s --retries=1 CMD [ "test", "-f", "/tmp/healthy" ]

COPY root/ /
COPY entrypoint.sh /
COPY config/ /config
VOLUME /downloads
