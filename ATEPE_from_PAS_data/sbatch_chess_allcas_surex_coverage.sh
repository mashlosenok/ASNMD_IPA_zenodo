#!/usr/bin/bash

#SBATCH --job-name=chess_sample_surex
#SBATCH --chdir=/gss/mvlasenok/GTEX_ASNMD_IPA/all_cod_exons_I1I2  
#SBATCH --partition=cpu
#SBATCH --ntasks=8
#SBATCH --array=189
#SBATCH --output=%x_%a.out
#SBATCH --error=%x_%a.err

module load ScriptLang/python/3.8.3;

#fs=$(cut -f2 /gss/dplab/data/GTEX/GRCh38/coverage/config/samples.tsv|tail -n+2|head -n $(( ${SLURM_ARRAY_TASK_ID}*50 )) |tail -n50|sed 's/^/\/gss\/dplab\/data\/GTEX\/GRCh38\/coverage\/bw_BPM\//;s/$/.bw/')
fs=$(cut -f2 /gss/dplab/data/GTEX/GRCh38/coverage/config/samples.tsv|tail -n23|sed 's/^/\/gss\/dplab\/data\/GTEX\/GRCh38\/coverage\/bw_BPM\//;s/$/.bw/') #last run

#surrounding exons
mkdir -p coverage_samples_surexon;
if ! test -f coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.tab; then
    echo batch${SLURM_ARRAY_TASK_ID};
    multiBigwigSummary BED-file \
    --verbose \
    -b ${fs} \
    -o coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.npz \
    --numberOfProcessors 8 \
    --BED ../chess.v313.surexon_windows.bed \
    --outRawCounts coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.tab;
    rm -f coverage_samples_surexon/batch${SLURM_ARRAY_TASK_ID}.npz ;
fi
#%x_%a - for id in the output filename