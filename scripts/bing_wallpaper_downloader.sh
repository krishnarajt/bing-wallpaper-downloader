#!/bin/sh
set -e

MARKET=${MARKET:-en-IN}
OUTPUT_DIR=${OUTPUT_DIR:-/wallpapers}

mkdir -p "$OUTPUT_DIR"

API_URL="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=$MARKET"

echo "Fetching Bing metadata..."
JSON=$(wget -qO- "$API_URL")

# Extract image path from JSON
IMG_PATH=$(echo "$JSON" | grep -o '"url":"[^"]*' | head -n1 | cut -d'"' -f4)

BASE_URL="https://www.bing.com$IMG_PATH"

# Extract original filename from id= parameter
ORIGINAL_FILENAME=$(echo "$BASE_URL" | sed -n 's/.*id=\([^&]*\).*/\1/p')

if [ -z "$ORIGINAL_FILENAME" ]; then
    echo "Failed to extract filename."
    exit 1
fi

# Build UHD filename correctly
UHD_FILENAME=$(echo "$ORIGINAL_FILENAME" | sed 's/_[0-9]*x[0-9]*\.jpg$/_UHD.jpg/')

UHD_URL=$(echo "$BASE_URL" | sed "s|$ORIGINAL_FILENAME|$UHD_FILENAME|")
ORIGINAL_URL="$BASE_URL"

DEST="$OUTPUT_DIR/$ORIGINAL_FILENAME"

if [ -f "$DEST" ]; then
    echo "Already downloaded: $ORIGINAL_FILENAME"
    exit 0
fi

echo "Testing UHD availability..."

# Check if UHD exists and is valid
if wget -q --spider "$UHD_URL"; then
    echo "UHD available. Downloading..."
    FINAL_URL="$UHD_URL"
    FINAL_FILENAME="$UHD_FILENAME"
else
    echo "UHD not available. Falling back to 1080p."
    FINAL_URL="$ORIGINAL_URL"
    FINAL_FILENAME="$ORIGINAL_FILENAME"
fi

DEST="$OUTPUT_DIR/$FINAL_FILENAME"

echo "Downloading: $FINAL_URL"

wget -q -L "$FINAL_URL" -O "$DEST" || {
    echo "Download failed."
    exit 1
}

# Verify file is not empty
if [ ! -s "$DEST" ]; then
    echo "Downloaded file is empty."
    rm -f "$DEST"
    exit 1
fi

ln -sf "$DEST" "$OUTPUT_DIR/latest.jpg"

echo "Saved $DEST"