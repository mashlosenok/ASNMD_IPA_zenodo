#!/usr/bin/bash

#SBATCH --job-name=split_reads_sampl
#SBATCH --partition=cpu
#SBATCH --chdir=/gss/mvlasenok/GTEX_ASNMD_IPA/novel_junc_ATEPE/
#SBATCH --output=logs/%x.out
#SBATCH --error=logs/%x.err

zcat /gss/dplab/data/GTEX/GRCh38/pyIPSA/J6_merged.csv.gz | \
cut -f1,2,7 -d","|tr ',' '\t'| \
awk 'NR==FNR{r[$3]=1;next}r[$1]' ATE_PE.junctions.PE_id.n260.tsv - > junction_counts.n260.per_sample.tsv