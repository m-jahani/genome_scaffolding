#!/bin/bash
#Hic scaffolding whith juicer and 3D-DNA
#Mojtaba jahani Sep 2021

ACCOUNT=def-rieseber
CPU=64 #N of cores
BIN=/home/mjahani/scratch/bin #scripts directory
#################################################ARGUMENTS###################################################
ASSEMBLY=$1 #assembly name #Kalea.hic.hap1.p_ctg.fasta
PREFIX=$2 #scaffoldinf name in working directory #Kalea_hap1 in /home/mjahani/scratch/opt/juicer/scaffolding
JUCIER_DIR=$3 #/lustre04/scratch/mjahani/opt/juicer
#############################################################################################################

###############################################DIRECTORIES###################################################
THREED_DNA_SCAFFOLDING_DIR=${JUCIER_DIR}/scaffolding/${PREFIX}/3D_DNA
#############################################################################################################
#################################################SCRIPTS#####################################################
JUICER_SCRIPT=${BIN}/JUICER.sh
THREED_DNA_SCRIPT=${BIN}/3DDNA.sh
###################################################RUN#######################################################

echo "### Step 0: Check output directories exist & create them as needed"
[ -d $THREED_DNA_SCAFFOLDING_DIR ] || mkdir -p $THREED_DNA_SCAFFOLDING_DIR

echo "### Step 1: Juicer"
#jid1=$(sbatch --cpus-per-task=${CPU} --job-name=JUICER_${PREFIX} --output=${JUCIER_DIR}/scaffolding/${PREFIX}/${PREFIX}_juicer.log --account=${ACCOUNT} $JUICER_SCRIPT $ASSEMBLY $PREFIX $JUCIER_DIR)

echo "### Step 2: 3D-DNA"
#jid2=$(sbatch --dependency=afterany:${jid1/Submitted batch job /} --cpus-per-task=${CPU} --job-name=3D-DNA_${PREFIX} --account=${ACCOUNT} --output=${JUCIER_DIR}/scaffolding/${PREFIX}/${PREFIX}.3D_DNA.log  $THREED_DNA_SCRIPT  $ASSEMBLY $PREFIX $JUCIER_DIR $THREED_DNA_SCAFFOLDING_DIR)
jid2=$(sbatch  --cpus-per-task=${CPU} --job-name=3D-DNA_${PREFIX} --account=${ACCOUNT} --output=${JUCIER_DIR}/scaffolding/${PREFIX}/${PREFIX}.3D_DNA.log $THREED_DNA_SCRIPT $ASSEMBLY $PREFIX $JUCIER_DIR $THREED_DNA_SCAFFOLDING_DIR)

