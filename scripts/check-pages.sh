#!/usr/bin/env bash
# Fail if a resume PDF has more than 2 pages (hard max). Prefer 1 page.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <resume.pdf>" >&2
  exit 2
fi

pdf="$1"
if [[ ! -f "$pdf" ]]; then
  echo "error: file not found: $pdf" >&2
  exit 2
fi

if ! command -v pdfinfo >/dev/null 2>&1; then
  echo "error: pdfinfo not found (install poppler-utils / xpdf tools)" >&2
  exit 2
fi

pages="$(pdfinfo "$pdf" | awk -F: '/^Pages:/ { gsub(/[[:space:]]/, "", $2); print $2; exit }')"
if [[ -z "$pages" || ! "$pages" =~ ^[0-9]+$ ]]; then
  echo "error: could not read Pages from pdfinfo for $pdf" >&2
  exit 2
fi

echo "Pages: $pages ($pdf)"
if (( pages > 2 )); then
  echo "error: resume exceeds hard max of 2 pages (got $pages). Trim content." >&2
  exit 1
fi

if (( pages == 2 )); then
  echo "warning: 2 pages — prefer 1 when content allows."
fi

exit 0
