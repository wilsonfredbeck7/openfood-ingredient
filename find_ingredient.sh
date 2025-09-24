#!/usr/bin/env bash
# Usage: ./find_ingredient.sh -i "<ing$
# Input: products.csv (TSV) must exist$
# Output: product_name<TAB>code for ma$
set -euo pipefail # safer Bash: fail o$
# Allow up to 1 GB per field
export CSVKIT_FIELD_SIZE_LIMIT=$((1024$
INGREDIENT=""; DATA_DIR=""; CSV=""
usage() {
echo "Usage: $0 -i \"<ingredient>\" -d$
echo " -i ingredient to search (case-i$
echo " -d folder containing products.c$
echo " -h show help"
}
# Parse flags (getopts)
while getopts ":i:d:h" opt; do
case "$opt" in
i) INGREDIENT="$OPTARG" ;;
d) DATA_DIR="$OPTARG" ;;
h) usage; exit 0 ;;
*) usage; exit 1 ;;
esac
done
# Validate inputs
[ -z "${INGREDIENT:-}" ] && { echo "ER$
[ -z "${DATA_DIR:-}" ] && { echo "ERRO$
CSV="$DATA_DIR/products.csv"
[ -s "$CSV" ] || { echo "ERROR: $CSV n$
# Check csvkit tools
for cmd in csvcut csvgrep csvformat; do
command -v "$cmd" >/dev/null 2>&1 || {$
1; }
done
# Normalize Windows CRs (if any) into $
tmp_csv="$(mktemp)"
tr -d '\r' < "$CSV" > "$tmp_csv"
# Pipeline:
tmp_matches="$(mktemp)"
csvcut -t -c ingredients_text,product_$
| csvgrep -c ingredients_text -r "(?i)$
| csvcut -c product_name,code \
| csvformat -T \
| tail -n +2 \
| tee "$tmp_matches"
count="$(wc -l < "$tmp_matches" | tr -$
echo "----"
echo "Found ${count} product(s) contai$

# cleanup
rm -f "$tmp_csv" "$tmp_matches"


