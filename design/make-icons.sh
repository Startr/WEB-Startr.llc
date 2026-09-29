#!/usr/bin/env bash
# Regenerate every icon from one source: public/assets/startr-logo.png.
#
# The logo is 400x400 with a ragged painted rim, so each icon starts from a
# clean disc: scale 1.18 about the centre, then mask to a circle. The 512px
# outputs are upscaled from that 400px source; replace the source with a
# larger master to sharpen them.
set -euo pipefail
cd "$(dirname "$0")/.."

SRC=public/assets/startr-logo.png
OUT=public/assets
BG="#1b1233"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Clean disc, 512px, transparent outside the circle. -strip drops the
# source's ~16 KB of EXIF/XMP/ICC, which would otherwise ride into every icon.
magick "$SRC" -strip -filter Lanczos -resize 604x604 -gravity center -extent 512x512 "$TMP/scaled.png"
magick -size 512x512 xc:none -fill white -draw "circle 256,256 256,1" "$TMP/mask.png"
magick "$TMP/scaled.png" "$TMP/mask.png" -alpha off -compose CopyOpacity -composite "$TMP/disc.png"

# Browser tab icons come from the S monogram: the wordmark is unreadable
# below ~48px. Render the master first with `make favicon`.
MONO=design/favicon-master.png
[ -f "$MONO" ] || { echo "missing $MONO: run make favicon first" >&2; exit 1; }
magick "$MONO" -strip -filter Lanczos -resize 32x32 "$OUT/favicon-32x32.png"
magick "$MONO" -strip -filter Lanczos -resize 16x16 "$OUT/favicon-16x16.png"
magick "$MONO" -strip -define icon:auto-resize=48,32,16 public/favicon.ico

# Home-screen icons. iOS paints transparency black, so it gets a solid ground.
# Icons on a solid ground drop to a 256-colour palette: a third of the size,
# no visible banding. The transparent ones compress worse that way, so not them.
QUANT=(-dither FloydSteinberg -colors 256 -define png:compression-level=9)
magick -size 180x180 "xc:$BG" \( "$TMP/disc.png" -resize 164x164 \) -gravity center -composite "${QUANT[@]}" "$OUT/apple-touch-icon.png"
magick "$TMP/disc.png" -filter Lanczos -resize 192x192 "$OUT/android-chrome-192x192.png"
cp "$TMP/disc.png" "$OUT/android-chrome-512x512.png"

# Maskable: the disc inside the 80% safe zone, on a solid ground, so any
# launcher mask shape keeps the whole logo.
magick -size 512x512 "xc:$BG" \( "$TMP/disc.png" -resize 400x400 \) -gravity center -composite "${QUANT[@]}" "$OUT/maskable-512x512.png"

echo "icons written to $OUT and public/favicon.ico"
