#!/bin/bash

##
# Remove Lines From VCF
#
# This will remove *all* VCF lines that match any of the lines in the
# lines file.
# 
# Input:
#   vcf[.gz] or bcf[.gz]
# 
# Output:
#   vcf
# 
# Example usage:
#   ./remove_lines_from_VCF.sh my.vcf.gz lines2remove.txt > modified.vcf
##

vcf=$(echo $1 | sed 's/^ *\| *$//g')   # <-- Input VCF
lines=$(echo $2 | sed 's/^ *\| *$//g') # <-- Lines to remove from VCF

if [ ! -f "$vcf" ]; then
  echo "ERROR: Must supply a .vcf[.gz] or .bcf[.gz] file" >&2
  exit 1
fi

if [ ! -f "$lines" ]; then
  echo "ERROR: Must supply a file of lines to remove" >&2
  exit 1
fi

bcftools view -O v "$vcf" \
  | grep -vFxf "$2"
