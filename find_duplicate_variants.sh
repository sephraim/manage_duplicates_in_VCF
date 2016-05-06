#!/bin/bash

##
# Find Duplicates
#
# This script will find all records that have the same
# CHROM, POS, REF, and ALT. No header information will
# be printed.
#
# Input:
#  vcf[.gz] or bcf[.gz]
# Output:
#  txt (exactly like a VCF file, but with no header lines)
#
# Example usage:
#   ./find_duplicates.sh my.vcf.gz > duplicate_lines.txt
##

vcf="$1"
dups="/tmp/$RANDOM$RANDOM$RANDOM"
#bed="/Users/sephraim/data/references/DVD_genes.tmp.bed"

# Get list of duplicate variants
#bcftools query -R "$bed" -f '%CHROM\t%POS\t%REF\t%ALT\n' "$vcf" | awk 'seen[$0]++' | sort -u > "$dups"
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' "$vcf" | awk 'seen[$0]++' | sort -u > "$dups"

if [ -s "$dups" ]; then
  # Print duplicates in VCF
  bcftools view -H -O v -R "$dups" "$vcf" \
    | grep -Ef <(awk 'BEGIN{FS=OFS="\t";print "#"};{print "^"$1,$2,"[^\t]+",$3,$4"\t"}' "$dups")
else
  # No duplicates
  echo "No duplicates found" >&2
fi

# Cleanup
rm $dups
