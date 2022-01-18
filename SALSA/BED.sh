#!/bin/bash

JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

#Load modules
module load bedtools

REP_DIR=$1
REP_LABEL=$2

echo "###Step 5: generate bed file"
bamToBed -i ${REP_DIR}/${REP_LABEL}.bam >${REP_DIR}/${REP_LABEL}.bed
sort -k 4 ${REP_DIR}/${REP_LABEL}.bed >${REP_DIR}/tmp && mv ${REP_DIR}/tmp ${REP_DIR}/${REP_LABEL}.bed

echo "Program finished with exit code $? at: $(date)" >>$JOBINFO
