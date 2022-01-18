#!/bin/bash

JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

#Load modules
module load samtools
module load perl
module load picard

PAIR_DIR=$1
SRA=$2
REP_DIR=$3
REP_LABEL=$4
TMP_DIR=$5
STATS=$6

echo "### Step 4: Mark duplicates and stats"
java -jar $EBROOTPICARD/picard.jar MarkDuplicates INPUT=${PAIR_DIR}/${SRA}.bam OUTPUT=${REP_DIR}/${REP_LABEL}.bam METRICS_FILE=${REP_DIR}/metrics.${REP_LABEL}.txt TMP_DIR=${TMP_DIR} ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=TRUE MAX_SEQUENCES_FOR_DISK_READ_ENDS_MAP=10000 MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000
rm ${PAIR_DIR}/${SRA}.bam
samtools index ${REP_DIR}/${REP_LABEL}.bam
perl $STATS ${REP_DIR}/${REP_LABEL}.bam >${REP_DIR}/${REP_LABEL}.bam.stats

echo "Program finished with exit code $? at: $(date)" >>$JOBINFO
