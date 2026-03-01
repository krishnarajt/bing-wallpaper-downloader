

# #!/bin/sh
# if you are only using docker. 
# set -eu

# TRIGGER_SCHEDULE="${TRIGGER_SCHEDULE:-0 */6 * * *}"
# OUTPUT_DIR="${OUTPUT_DIR:-/wallpapers}"
# CRON_FILE="/etc/crontabs/root"

# mkdir -p "$OUTPUT_DIR"

# # Run once on startup so the volume is populated immediately.
# /usr/local/bin/bing_wallpaper_downloader.sh

# printf '%s %s >> /proc/1/fd/1 2>> /proc/1/fd/2\n' \
#   "$TRIGGER_SCHEDULE" \
#   "/usr/local/bin/bing_wallpaper_downloader.sh" > "$CRON_FILE"

# exec crond -f -l 8

#!/bin/sh
exec /usr/local/bin/bing_wallpaper_downloader.sh