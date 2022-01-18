#!/bin/bash
JOBINFO=${SLURM_JOB_ID}_${SLURM_JOB_NAME}
echo "Starting run at: $(date)" >>$JOBINFO

#Load modules
module load boost
module load StdEnv/2020
module load gcc/9.3.0
module load pbsuite/15.8.24
module load python/2.7.18
module load genometools

REF=$1
FAIDX=$2
REP_DIR=$3
REP_LABEL=$4
FINAL=$5
GRAPH=$6

echo "###Step 6: SALSA scaffolding"
python ~/bin/SALSA/run_pipeline.py -a $REF -l $FAIDX -b ${REP_DIR}/${REP_LABEL}.bed -c 5000 -e GATC -o $FINAL -m yes -g $GRAPH

gt seqstat -contigs -genome 790000000 ${FINAL}/scaffolds_FINAL.fasta >${FINAL}/scaffolds_FINAL.GT.stats

echo "Program finished with exit code $? at: $(date)" >>$JOBINFO
