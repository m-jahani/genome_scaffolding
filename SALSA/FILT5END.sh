#!/bin/bash

JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

# Load modules
module load samtools
module load perl

RAW_DIR=$1
SRA=$2
READ=$3
FILTER=$4
FILT_DIR=$5

samtools view -h ${RAW_DIR}/${SRA}${READ}.bam | perl $FILTER | samtools view -Sb - >${FILT_DIR}/${SRA}${READ}.bam

rm ${RAW_DIR}/${SRA}${READ}.bam

echo "Program finished with exit code $? at: $(date)" >>$JOBINFO
