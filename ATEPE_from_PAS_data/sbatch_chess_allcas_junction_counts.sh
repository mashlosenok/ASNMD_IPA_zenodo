#!/usr/bin/bash

#SBATCH --job-name=chess_sample_split_reads
#SBATCH --partition=cpu
#SBATCH --output=%x.out
#SBATCH --error=%x.err

zcat /gss/dplab/data/GTEX/GRCh38/pyIPSA/J6_merged.csv.gz | \
cut -f1,2,7 -d","|tr ',' '\t'| \
awk 'NR==FNR{r[$3]=1;next}r[$1]' /gss/mvlasenok/references/chess.v313.cassette_ex_junc.tsv - > all_cod_exons_I1I2/chess.cassette_ex_junction_counts.per_sample.tsv