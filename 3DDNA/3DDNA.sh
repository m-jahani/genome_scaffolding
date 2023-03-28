#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --mem=255000M


ASSEMBLY=$1 #assembly name #Kalea.hic.hap1.p_ctg.fasta
PREFIX=$2 #scaffoldinf name in working directory #Kalea_hap1 in /home/mjahani/scratch/opt/juicer/scaffolding
JUCIER_DIR=$3 #/lustre04/scratch/mjahani/opt/juicer
THREED_DNA_SCAFFOLDING_DIR=$4 #directory to save scaffolding result by 3D-DNA

module load scipy-stack
module load java

cd $THREED_DNA_SCAFFOLDING_DIR

bash ${JUCIER_DIR}/3d-dna/run-asm-pipeline.sh -i 5000 -r 0  --editor-repeat-coverage 5 --editor-coarse-resolution 100000 --editor-coarse-region 500000  ${JUCIER_DIR}/references/${ASSEMBLY} ${JUCIER_DIR}/scaffolding/${PREFIX}/aligned/merged_nodups.txt

#only as atest
#bash ${JUCIER_DIR}/3d-dna/run-asm-pipeline.sh -i 5000 -r 3 --editor-coarse-resolution 500000 --editor-coarse-region 1000000 --editor-saturation-centile 1 --editor-repeat-coverage 1 --editor-coarse-stringency 70  ${JUCIER_DIR}/references/${ASSEMBLY} ${JUCIER_DIR}/scaffolding/${PREFIX}/aligned/merged_nodups.txt
