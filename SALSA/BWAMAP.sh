#!/bin/bash

JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

# Load modules
module load bwa
module load samtools

REF=$1
IN_DIR=$2
SRA=$3
READ=$4
RAW_DIR=$5

bwa mem -t $SLURM_CPUS_PER_TASK $REF ${IN_DIR}/${SRA}${READ}.fastq.gz | samtools view -@ $SLURM_CPUS_PER_TASK -Sb - >${RAW_DIR}/${SRA}${READ}.bam

echo "Program finished with exit code $? at: $(date)" >>$JOBINFO
