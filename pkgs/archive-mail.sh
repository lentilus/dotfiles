#!/usr/bin/env bash

#
# A small shell script using pgpmime-dectypt to archive encrypted email
# in plain text for offline use.
#

set -euo pipefail

SRC="$1"
DEST="$2"

if [ ! -d "$SRC" ]; then
  echo "Source maildir not found: $SRC" >&2
  exit 1
fi

if [ "$SRC" = "$DEST" ]; then
  echo "Source and destination must be different." >&2
  exit 1
fi

# Try to canonicalize paths to ensure DEST is not inside SRC (best-effort)
canonicalize() {
  if command -v readlink >/dev/null 2>&1; then
    readlink -f -- "$1" || echo "$1"
  else
    # fallback: return as-is
    echo "$1"
  fi
}
SRC_CAN=$(canonicalize "$SRC")
DEST_CAN=$(canonicalize "$DEST")
case "$DEST_CAN" in
  "$SRC_CAN"/*)
    echo "Destination must not be inside the source maildir (risk of leaking decrypted files back)." >&2
    exit 1
    ;;
esac

# Create maildir structure in DEST
mkdir -p "$DEST"/{tmp,new,cur} || {
  echo "Failed to create destination maildir directories under $DEST" >&2
  exit 1
}

# timestamp helper (nanosecond where available)
get_ts() {
  date +%s%N 2>/dev/null || date +%s
}

# make_finalname: preserve basename; if collision, append .<ts>.<pid>[.<counter>]
make_finalname() {
  local base="$1" dst_new="$2"
  if [ ! -e "$dst_new/$base" ]; then
    printf '%s' "$base"
    return 0
  fi

  local ts pid name_no_ext ext candidate i=0
  ts=$(get_ts)
  pid="$$"

  if [[ "$base" == *.* ]]; then
    name_no_ext="${base%.*}"
    ext=".${base##*.}"
  else
    name_no_ext="$base"
    ext=""
  fi

  while :; do
    if [ "$i" -eq 0 ]; then
      candidate="${name_no_ext}.${ts}.${pid}${ext}"
    else
      candidate="${name_no_ext}.${ts}.${pid}.${i}${ext}"
    fi
    if [ ! -e "$dst_new/$candidate" ]; then
      printf '%s' "$candidate"
      return 0
    fi
    i=$((i+1))
  done
}

# Process files in new/ and cur/
for sub in new cur; do
  src_dir="$SRC/$sub"
  [ -d "$src_dir" ] || continue

  # find files safely, handle weird names
  find "$src_dir" -maxdepth 1 -type f -print0 2>/dev/null |
  while IFS= read -r -d '' srcfile; do
    [ -f "$srcfile" ] || continue

    base="$(basename -- "$srcfile")"

    # Create a secure temporary file inside DEST/tmp (mktemp creates the file)
    tmpfile=$(mktemp "$DEST/tmp/${base}.tmp.XXXXXX") || {
      echo "mktemp failed for $base" >&2
      continue
    }

    # Ensure tmpfile is removed on failure for this item
    cleanup_tmp() {
      [ -f "$tmpfile" ] && rm -f -- "$tmpfile"
    }

    # Run decrypt (reads srcfile -> stdout -> $tmpfile)
    if pgpmime-decrypt < "$srcfile" > "$tmpfile"; then
      chmod 600 "$tmpfile" 2>/dev/null || true

      # decide final name (preserve basename if possible)
      finalname="$(make_finalname "$base" "$DEST/new")"
      finalpath="$DEST/new/$finalname"

      # Atomic move into new/
      if mv -f -- "$tmpfile" "$finalpath"; then
        # remove original encrypted file only after success
        if rm -f -- "$srcfile"; then
          printf 'OK: %s -> %s\n' "$srcfile" "$finalpath"
        else
          echo "Warning: decrypted but failed to remove original: $srcfile" >&2
        fi
      else
        echo "Error: failed to move decrypted file into $DEST/new for $srcfile" >&2
        cleanup_tmp
      fi
    else
      echo "Decrypt failed for: $srcfile" >&2
      cleanup_tmp
      # leave the original encrypted file alone for inspection/retry
    fi
  done
done
