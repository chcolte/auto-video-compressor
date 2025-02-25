#!/bin/bash

# Settings
WATCH_DIR="/path/to/watch"
OUTPUT_DIR="/path/to/output"
PROCESSED_DIR="/path/to/processed"
FFMPEG_OPTIONS="-c:v libx265 -preset medium -crf 23 -c:a aac -b:a 128k"
SLEEP_INTERVAL=60
LOG_FILE="/path/to/log_file.log"

# Log output function with timestamp
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}

# Create directories if they don't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$PROCESSED_DIR"

while true; do

  file=""
  while IFS= read -r -d '' f; do
    file="$f"
    break  # Only process the first file found
  done < <(find "$WATCH_DIR" -maxdepth 1 -type f \( -name "*.mp4" -o -name "*.avi" -o -name "*.mov" -o -name "*.mkv" -o -name "*.wmv" \) -print0)

  if [ -z "$file" ]; then
    log "No video files found in the watch directory. Retrying in ${SLEEP_INTERVAL} seconds."
    sleep "$SLEEP_INTERVAL"
    continue
  fi

  # Generate output file name
  filename=$(basename "$file")
  extension="${filename##*.}"
  filename_without_extension="${filename%.*}"
  output_file="$OUTPUT_DIR/${filename_without_extension}_compressed.${extension}"

  # Execute video compression with ffmpeg
  log "Starting video compression for: $file"
  ffmpeg -i "$file" $FFMPEG_OPTIONS "$output_file" > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    log "Video compression completed: $file -> $output_file"
    mv "$file" "$PROCESSED_DIR/"
    log "Moved file to processed directory: $PROCESSED_DIR"
  else
    log "Video compression failed for: $file"
  fi

done

