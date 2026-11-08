
#!/usr/bin/env bash

# uses imagemagick 6
set -euo pipefail

# Directories (relative to project root)
INPUT_DIR="assets/images"
OUTPUT_DIR="assets/optimized"

# Image settings
MAX_DIMENSION=2400
QUALITY=82

# Check dependencies
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed."
    echo "Install with: sudo apt install imagemagick"
    exit 1
fi

# Check input directory
if [[ ! -d "$INPUT_DIR" ]]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Optimizing images..."
echo "Input:  $INPUT_DIR"
echo "Output: $OUTPUT_DIR"
echo

count=0

while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    name="${filename%.*}"
    output="$OUTPUT_DIR/$name.webp"

    echo "Converting: $filename"

    convert "$file" \
        -auto-orient \
        -resize "${MAX_DIMENSION}x${MAX_DIMENSION}>" \
        -quality "$QUALITY" \
        "$output"

    ((count+=1))

done < <(
    find "$INPUT_DIR" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
        -print0
)

echo
echo "Done! Optimized $count images."
echo "Output directory: $OUTPUT_DIR"
