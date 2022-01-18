#!/bin/bash

JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

# Load modules
module load bwa
module load samtools

PREFIX=$1
REF=$2
SAVE_DIR=$3

cd $SAVE_DIR

bwa index -a bwtsw -p $PREFIX $REF
samtools faidx $REF

echo "Program finished with exit code $? at: $(date)" >>$JOBINFO
