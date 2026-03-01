FROM alpine:3.21

RUN apk add --no-cache ca-certificates wget tzdata

COPY scripts/bing_wallpaper_downloader.sh /usr/local/bin/bing_wallpaper_downloader.sh
COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/bing_wallpaper_downloader.sh /usr/local/bin/docker-entrypoint.sh

ENV OUTPUT_DIR=/wallpapers
ENV TRIGGER_SCHEDULE="0 */6 * * *"

VOLUME ["/wallpapers"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
