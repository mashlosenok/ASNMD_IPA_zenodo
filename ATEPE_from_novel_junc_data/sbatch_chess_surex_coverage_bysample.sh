#!/usr/bin/bash

#SBATCH --job-name=surex_sample
#SBATCH --chdir=/gss/mvlasenok/GTEX_ASNMD_IPA/novel_junc_ATEPE  
#SBATCH --partition=cpu
#SBATCH --ntasks=8
#SBATCH --array=189
#SBATCH --output=logs/%x_%a.out
#SBATCH --error=logs/%x_%a.err

module load ScriptLang/python/3.8.3;

#fs=$(cut -f2 /gss/dplab/data/GTEX/GRCh38/coverage/config/samples.tsv|tail -n+2|head -n $(( ${SLURM_ARRAY_TASK_ID}*50 )) |tail -n50|sed 's/^/\/gss\/dplab\/data\/GTEX\/GRCh38\/coverage\/bw_BPM\//;s/$/.bw/')
fs=$(cut -f2 /gss/dplab/data/GTEX/GRCh38/coverage/config/samples.tsv|tail -n23|sed 's/^/\/gss\/dplab\/data\/GTEX\/GRCh38\/coverage\/bw_BPM\//;s/$/.bw/') #last run

#surrounding exons
mkdir -p coverage_samples_surexon;
if ! test -f coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.sort.tab; then
    echo batch${SLURM_ARRAY_TASK_ID};
    multiBigwigSummary BED-file \
    --verbose \
    -b ${fs} \
    -o coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.npz \
    --numberOfProcessors 8 \
    --BED ATE_PE_e1_e2.PE_id.uniq_sur_ex.n260.bed \
    --outRawCounts coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.tab;
    rm -f coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.npz ;
    sort -k1,1 -k2,2n coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.tab > coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.sort.tab;
    rm coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.tab ;
fi
#only last
cut -f 1-3 ATE_PE_e1_e2.PE_id.uniq_sur_ex.n260.bed |sort -k1,1 -k2,2n |sed '1ichr\tstart\tend' > ATE_PE_sur_ex_cov.n260.tsv
for f in coverage_samples_surexon/batch*.sort.tab; do \
    cut -f 1-3 --complement $f | paste ATE_PE_sur_ex_cov.n260.tsv - > ATE_PE_sur_ex_cov.n260.tsv.tmp;
    mv ATE_PE_sur_ex_cov.n260.tsv.tmp ATE_PE_sur_ex_cov.n260.tsv;
done
#%x_%a - for id in the output filename