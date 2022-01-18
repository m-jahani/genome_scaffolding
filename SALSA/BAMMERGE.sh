#!/bin/bash


JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

# Load modules
module load samtools
module load perl
module load picard


COMBINER=$1
FILT_DIR=$2
SRA=$3
MAPQ_FILTER=$4
FAIDX=$5
TMP_DIR=$6
PAIR_DIR=$7
LABEL=$8

echo "### Step 3A: Pair reads & mapping quality filter"
perl $COMBINER ${FILT_DIR}/${SRA}R1.bam ${FILT_DIR}/${SRA}R2.bam samtools $MAPQ_FILTER | samtools view -bS -t $FAIDX - | samtools sort -@ $SLURM_CPUS_PER_TASK -o ${TMP_DIR}/${SRA}.bam -
rm ${FILT_DIR}/${SRA}R1.bam ${FILT_DIR}/${SRA}R2.bam

echo "### Step 3.B: Add read group"
java -jar $EBROOTPICARD/picard.jar AddOrReplaceReadGroups INPUT=${TMP_DIR}/${SRA}.bam OUTPUT=${PAIR_DIR}/${SRA}.bam ID=${SRA} LB=${SRA} SM=${LABEL} PL=ILLUMINA PU=none
rm ${TMP_DIR}/${SRA}.bam
echo "Program finished with exit code $? at: $(date)" >>$JOBINFO
