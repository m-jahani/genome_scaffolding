#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --mem=255000M

ASSEMBLY=$1 #assembly name #Kalea.hic.hap1.p_ctg.fasta
PREFIX=$2 #scaffoldinf name in working directory #Kalea_hap1 in /home/mjahani/scratch/opt/juicer/scaffolding
JUCIER_DIR=$3 #/lustre04/scratch/mjahani/opt/juicer

module load bwa
module load scipy-stack
module load java

bwa index ${JUCIER_DIR}/references/${ASSEMBLY}

cd ${JUCIER_DIR}/restriction_sites
python ${JUCIER_DIR}/misc/generate_site_positions.py MboI $PREFIX ${JUCIER_DIR}/references/${ASSEMBLY}
awk 'BEGIN{OFS="\t"}{print $1, $NF}' ${PREFIX}_MboI.txt > ${JUCIER_DIR}/chromosome_size/${PREFIX}.chrom.sizes
cd ${JUCIER_DIR}/scaffolding/${PREFIX}
${JUCIER_DIR}/scripts/juicer.sh \
  -g $PREFIX \
  -s MboI \
  -z ${JUCIER_DIR}/references/${ASSEMBLY} \
  -y ${JUCIER_DIR}/restriction_sites/${PREFIX}_MboI.txt \
  -p ${JUCIER_DIR}/chromosome_size/${PREFIX}.chrom.sizes \
  -D $JUCIER_DIR
