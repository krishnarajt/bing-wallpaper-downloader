#!/bin/sh
set -e

MARKET=${MARKET:-en-US}
OUTPUT_DIR=${OUTPUT_DIR:-/wallpapers}

mkdir -p "$OUTPUT_DIR"

API_URL="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=$MARKET"
JSON=$(wget -qO- "$API_URL")

IMG_PATH=$(echo "$JSON" | grep -o '"url":"[^"]*' | head -n1 | cut -d'"' -f4)

# Force UHD resolution
IMG_PATH=$(echo "$IMG_PATH" | sed 's/[0-9]*x[0-9]*\.jpg/_UHD.jpg/')

FULL_URL="https://www.bing.com$IMG_PATH"

DATE=$(date +%Y-%m-%d)
DEST="$OUTPUT_DIR/bing-$DATE.jpg"

if [ -f "$DEST" ]; then
    echo "Already downloaded today."
    exit 0
fi

wget -q "$FULL_URL" -O "$DEST"
ln -sf "$DEST" "$OUTPUT_DIR/latest.jpg"

echo "Saved $DEST"