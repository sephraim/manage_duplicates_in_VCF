# Manage Duplicates In VCF

## Description

View and remove duplicate variants in a VCF file. A duplicate variant is when multiple records have the same CHROM, POS, REF, and ALT.

## Example usage

There are 3 scripts available for managing duplicates, each of which produce slightly different output. All scripts can handle *.vcf*, *.vcf.gz*, *.bcf*, and *.bcf.gz* files as input.

For the examples below, let's say we have a VCF file called *with_dups.vcf.gz* that contains both duplicate and non-duplicate variants:

    $ zcat with_dups.vcf.gz
    ##fileformat=VCFv4.1
    ##INFO=<ID=COMMENTS,Number=1,Type=String,Description="Comments">
    #CHROM  POS       ID        REF  ALT  QUAL  FILTER  INFO
    10      73269880  ID111111  G    CA   .     .       COMMENTS=Duplicate_1A
    10      73269880  ID222222  G    CAC  .     .       COMMENTS=Duplicate_1B
    10      73269880  ID333333  G    CAC  .     .       COMMENTS=Duplicate_2B
    10      73269880  ID444444  G    CA   .     .       COMMENTS=Duplicate_2A
    10      73269885  ID555555  C    G    .     .       COMMENTS=Not_a_duplicate

### *find\_duplicate\_variants.sh*

This script will find all records that have the same CHROM, POS, REF, and ALT.

    $ ./find_duplicate_variants.sh with_dups.vcf.gz > duplicate_lines.txt

The output will look as follows:

    $ cat duplicate_lines.txt
    10      73269880  ID111111  G    CA   .     .       COMMENTS=Duplicate_1A
    10      73269880  ID222222  G    CAC  .     .       COMMENTS=Duplicate_1B
    10      73269880  ID333333  G    CAC  .     .       COMMENTS=Duplicate_2B
    10      73269880  ID444444  G    CA   .     .       COMMENTS=Duplicate_2A
    
As you can see, no header information gets printed in the output.

### *remove\_duplicate\_variants.sh*

This script will de-duplicate a VCF file. In a group of duplicate variants, the script will automatically pick *one* of the duplicate variants and discard the rest. The variant that is picked is the one that comes first in sorting order.

You can run the script like follows:

    $ ./remove_duplicate_variants.sh with_dups.vcf.gz > no_dups.vcf

The output will look like this:

    $ cat no_dups.vcf
    ##fileformat=VCFv4.1
    ##INFO=<ID=COMMENTS,Number=1,Type=String,Description="Comments">
    #CHROM  POS       ID        REF  ALT  QUAL  FILTER  INFO
    10      73269880  ID111111  G    CA   .     .       COMMENTS=Duplicate_1A
    10      73269880  ID222222  G    CAC  .     .       COMMENTS=Duplicate_1B
    10      73269885  ID555555  C    G    .     .       COMMENTS=Not_a_duplicate

### *remove\_lines\_from\_VCF.sh*

This script allows the user to specify which records to remove from a VCF file. While *remove\_duplicate\_variants.sh* will pick which records to remove for you, *remove\_lines\_from\_VCF.sh* allows you to choose which records to remove by specifying them in a separate file.

The example above kept `Duplicate_1A` and `Duplicate_1B` and removed `Duplicate_2A` and `Duplicate_2B`. Let's say instead that now we want to remove `Duplicate_1A` and `Duplicate_1B` and keep the others. The following is an example of how to put the records you want to remove into a separate text file called *lines2remove.txt* using the *find\_duplicate\_variants.sh* script:

    $ ./find_duplicate_variants.sh example.vcf.gz | grep 'Duplicate_1' > lines2remove.txt
    $ cat lines2remove.txt
    10      73269880  ID111111  G    CA   .     .       COMMENTS=Duplicate_1A
    10      73269880  ID222222  G    CAC  .     .       COMMENTS=Duplicate_1B

Now use the *remove\_lines\_from\_VCF.sh* script to remove the records specified in *lines2remove.txt* from the VCF file. This script requires two arguments; the first argument is your input VCF file (e.g. *with\_dups.vcf.gz*), and the second argument is the text file containing the records you would like to remove from the input VCF (e.g. *lines2remove.txt*)

    $ ./remove_lines_from_VCF.sh with_dups.vcf.gz lines2remove.txt > modified.vcf
    $ cat modified.vcf
    ##fileformat=VCFv4.1
    ##INFO=<ID=COMMENTS,Number=1,Type=String,Description="Comments">
    #CHROM  POS       ID        REF  ALT  QUAL  FILTER  INFO
    10      73269880  ID333333  G    CAC  .     .       COMMENTS=Duplicate_2B
    10      73269880  ID444444  G    CA   .     .       COMMENTS=Duplicate_2A
    10      73269885  ID555555  C    G    .     .       COMMENTS=Not_a_duplicate

## Requirements

`bcftools` must be in your `$PATH` (download it [here](https://github.com/samtools/bcftools/releases))


## Author

Sean Ephraim
