#!/usr/bin/env sh
# aerc-save-decrypted-multi.sh
#
# Usage:
#   aerc-save-decrypted-multi.sh /path/to/Maildir/INBOX
#
# Reads stdin (single RFC-2822 message or mbox stream) and saves each message
# into the provided Maildir. Prints one saved path per message.
#
# Configuration (edit vars below as desired):
#   MARK_AS_READ="yes"      -> write into cur with :2,S (seen)
#   MARK_AS_READ="no"       -> write into new (unread)
#   INSERT_AUDIT_HEADER="no"-> "yes" to add X-Archived-At: timestamp in header block

set -euo pipefail

# ------------------ configuration ------------------
MARK_AS_READ="yes"
INSERT_AUDIT_HEADER="no"
# ---------------------------------------------------

usage() {
  printf 'Usage: %s /path/to/Maildir/INBOX\n' "$(basename "$0")" >&2
  exit 2
}

# require destination Maildir as first arg
if [ "${#}" -lt 1 ]; then
  usage
fi

OFFLINE_MAILDIR="$1"

# ensure Maildir structure exists
umask 077
mkdir -p "${OFFLINE_MAILDIR}/cur" "${OFFLINE_MAILDIR}/new" "${OFFLINE_MAILDIR}/tmp"

# temp resources
TMPIN="$(mktemp)" || { printf 'error: cannot create temp file\n' >&2; exit 3; }
SPLITDIR="$(mktemp -d)" || { rm -f "$TMPIN"; printf 'error: cannot create temp dir\n' >&2; exit 4; }
trap 'rm -f "$TMPIN"; rm -rf "$SPLITDIR"' EXIT

# read all stdin into temp file
cat - > "$TMPIN"
[ -s "$TMPIN" ] || { printf 'error: no input on stdin\n' >&2; exit 5; }

# helper: optionally insert X-Archived-At header into header block of a file
maybe_insert_audit_header() {
  src="$1"
  if [ "${INSERT_AUDIT_HEADER}" = "yes" ]; then
    NOW="$(date --rfc-3339=seconds 2>/dev/null || date -Iseconds)"
    awk -v arch="X-Archived-At: $NOW" '
      BEGIN { hdr=1 }
      {
        if (hdr && NF==0) {
          print arch
          print ""
          hdr=0
          next
        }
        print
      }
    ' "$src" > "${src}.withhdr" && mv "${src}.withhdr" "$src"
  fi
}

# split mbox (if it is mbox) or copy single message to splitdir
if grep -q '^From ' "$TMPIN"; then
  awk -v outdir="$SPLITDIR" '
    /^From / {
      if (outfile) close(outfile)
      msg++
      outfile = sprintf("%s/msg%05d.eml", outdir, msg)
      next
    }
    {
      if (!outfile) {
        msg++
        outfile = sprintf("%s/msg%05d.eml", outdir, msg)
      }
      print >> outfile
    }
  ' "$TMPIN"
else
  cp "$TMPIN" "${SPLITDIR}/msg00001.eml"
fi

save_one() {
  src="$1"

  # optionally add audit header
  maybe_insert_audit_header "$src"

  # best-effort extract Date: header
  DATE_HDR="$(awk 'BEGIN{IGNORECASE=1} /^Date:[[:space:]]*/ { sub(/^[Dd]ate:[[:space:]]*/, ""); print; exit }' "$src" || true)"

  if [ -n "$DATE_HDR" ] && TS="$(date -d "$DATE_HDR" +%s 2>/dev/null)"; then
    :
  else
    TS="$(date +%s)"
  fi

  RAND="$$_$RANDOM"
  HOST="$(hostname -s 2>/dev/null || printf 'host')"

  if [ "${MARK_AS_READ}" = "yes" ]; then
    FNAME="${TS}.${RAND}.${HOST}:2,S"
    OUTPATH="${OFFLINE_MAILDIR}/cur/${FNAME}"
  else
    FNAME="${TS}.${RAND}.${HOST}"
    OUTPATH="${OFFLINE_MAILDIR}/new/${FNAME}"
  fi

  # atomic move into Maildir
  mv "$src" "$OUTPATH"
  chmod 0600 "$OUTPATH"
  chown "$(id -u):$(id -g)" "$OUTPATH" 2>/dev/null || true

  # set file mtime from Date: header if parseable (best-effort)
  if [ -n "$DATE_HDR" ]; then
    touch -d "$DATE_HDR" "$OUTPATH" 2>/dev/null || true
  fi

  printf '%s\n' "$OUTPATH"
}

# iterate saved split files in numeric order and save them
for f in "$SPLITDIR"/msg*.eml; do
  [ -e "$f" ] || continue
  save_one "$f"
done

exit 0
