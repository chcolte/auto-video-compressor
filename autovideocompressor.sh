#!/bin/bash

# Settings
ARRAY_LEN=2
WATCH_DIR=("/path/to/watch" "/path/to/watch2")
OUTPUT_DIR=("/path/to/output" "/path/to/output2")
PROCESSED_DIR=("/path/to/processed" "/path/to/processed2")
FFMPEG_OPTIONS="-c:a copy -c:v libx265 -crf 22 -tag:v hvc1"
SLEEP_INTERVAL=60
LOG_FILE="/path/to/log_file.log"

# Log output function with timestamp
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}

# Create directories if they don't exist
# mkdir -p "$OUTPUT_DIR"
# mkdir -p "$PROCESSED_DIR"

while true; do
  for ((i=0; i<ARRAY_LEN; i++)) do
    file=""
    while IFS= read -r -d '' f; do
      file="$f"
      break  # Only process the first file found
    done < <(find "${WATCH_DIR[i]}" -maxdepth 1 -type f \( -name "*.mp4" -o -name "*.avi" -o -name "*.mov" -o -name "*.mkv" -o -name "*.wmv" \) -print0)
  
    if [ -z "$file" ]; then
      log "No video files found in the watch directory. Retrying in ${SLEEP_INTERVAL} seconds."
      sleep "$SLEEP_INTERVAL"
      continue
    fi
  
    # Generate output file name
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename_without_extension="${filename%.*}"
    output_file="${OUTPUT_DIR[i]}/${filename_without_extension}_compressed.${extension}"
  
    # Execute video compression with ffmpeg
    log "Starting video compression for: $file"
    ffmpeg -i "$file" $FFMPEG_OPTIONS "$output_file" > /dev/null 2>&1
  
    if [ $? -eq 0 ]; then
      log "Video compression completed: $file -> $output_file"
      mv "$file" "${PROCESSED_DIR[i]}/"
      log "Moved file to processed directory: ${PROCESSED_DIR[i]}"
    else
      log "Video compression failed for: $file"
    fi
  done
done

