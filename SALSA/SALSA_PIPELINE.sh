#!/bin/bash
#SALSA scaffolding pipeline
#Mojtaba jahani Jan 2022

CPU=64 #N of cores
MEMORY=255000M
MAPQ_FILTER=10
ACCOUNT=def-rieseber
#################################################ARGUMENTS###################################################
REF=$1    #/data/users/mjahani/scaffolding/REF/sunflower_scaffolds.fasta #refrence genome
GRAPH=$2
SRA=$3    #Dovetail.HiC_  #basename of HiC fastq files
IN_DIR=$4 #/data/users/mjahani/scaffolding/HiC #directory for HiC reads
ASSEM_NAME=$5
SAVE_DIR=$6
BIN=$7 #where the SALSA scripts are
#############################################################################################################

###############################################LABELS&FILES##################################################
PREFIX=${REF##*/}         #assembely index name
FAIDX=${REF}.fai          #samtools faidx
LABEL=${PREFIX%%fasta}HiC #overall_exp_name
REP_LABEL=${LABEL}_FINAL
#############################################################################################################

###############################################DIRECTORIES###################################################
RAW_DIR=${SAVE_DIR}/BAM                    #/path/to/write/out/bams'
FILT_DIR=${SAVE_DIR}/FILT_BAM              #/path/to/write/out/filtered/bams
TMP_DIR=${SAVE_DIR}/TMP                    #/path/to/write/out/temporary/files
PAIR_DIR=${SAVE_DIR}/PAIR_BAM              #/path/to/write/out/paired/bams
REP_DIR=${SAVE_DIR}/REP                    #/path/to/where/you/want/deduplicated/files
FINAL=${SAVE_DIR}/SCAFF/${REP_LABEL}_SALSA #/path/to/write/out/final/scaffolding
############################################################################################################

#################################################SCRIPTS#####################################################
FILTER=${BIN}/filter_five_end.pl         #/path/to/filter_five_end.pl
COMBINER=${BIN}/two_read_bam_combiner.pl #/path/to/two_read_bam_combiner.pl
STATS=${BIN}/get_stats.pl                #/path/to/get_stats.pl
BWAINDEX=${BIN}/BWAINDEX.sh
BWAMAP=${BIN}/BWAMAP.sh
FILT5END=${BIN}/FILT5END.sh
BAMMERGE=${BIN}/BAMMERGE.sh
BAMDUPLICATES=${BIN}/BAMDUPLICATES.sh
BED=${BIN}/BED.sh
SALSA=${BIN}/SALSA.sh
#############################################################################################################

echo "### Step 0: Check output directories exist & create them as needed"

[ -d $RAW_DIR ] || mkdir -p $RAW_DIR
[ -d $RAW_DIR ] || mkdir -p $RAW_DIR
[ -d $FILT_DIR ] || mkdir -p $FILT_DIR
[ -d $TMP_DIR ] || mkdir -p $TMP_DIR
[ -d $PAIR_DIR ] || mkdir -p $PAIR_DIR
[ -d $REP_DIR ] || mkdir -p $REP_DIR
[ -d $SALSA_SCAFFOLD ] || mkdir -p $SALSA_SCAFFOLD
[ -d $FINAL ] || mkdir -p $FINAL

#echo "### Step 0: Index reference"
jid1=$(sbatch --cpus-per-task=${CPU} --job-name=bwa_index_${ASSEM_NAME} --time=00:30:00 --mem=${MEMORY} --output=${SAVE_DIR}/bwa_index_${ASSEM_NAME} --account=${ACCOUNT} $BWAINDEX $PREFIX $REF $SAVE_DIR)

echo "### Step 1.A: FASTQ to BAM (1st)"
jid2=$(sbatch --dependency=afterany:${jid1/Submitted batch job /} --cpus-per-task=${CPU} --job-name=bwa_mapping_R1_${ASSEM_NAME} --time=06:00:00 --mem=${MEMORY} --output=${RAW_DIR}/bwa_mapping_R1_${ASSEM_NAME} --account=${ACCOUNT} $BWAMAP $REF $IN_DIR $SRA R1 $RAW_DIR)

echo "### Step 1.B: FASTQ to BAM (2nd)"
jid3=$(sbatch --dependency=afterany:${jid1/Submitted batch job /} --cpus-per-task=${CPU} --job-name=bwa_mapping_R2_${ASSEM_NAME} --time=06:00:00 --mem=${MEMORY} --output=${RAW_DIR}/bwa_mapping_R2_${ASSEM_NAME} --account=${ACCOUNT} $BWAMAP $REF $IN_DIR $SRA R2 $RAW_DIR)

echo "### Step 2.A: Filter 5' end (1st)"
jid4=$(sbatch --dependency=afterany:${jid2/Submitted batch job /}:${jid3/Submitted batch job /} --cpus-per-task=${CPU} --job-name=FILTER_5END_R1_${ASSEM_NAME} --time=02:00:00 --mem=${MEMORY} --output=${FILT_DIR}/FILTER_5END_R2_${ASSEM_NAME} --account=${ACCOUNT} $FILT5END $RAW_DIR $SRA R1 $FILTER $FILT_DIR)

echo "### Step 2.B: Filter 5' end (2nd)"
jid5=$(sbatch --dependency=afterany:${jid2/Submitted batch job /}:${jid3/Submitted batch job /} --cpus-per-task=${CPU} --job-name=FILTER_5END_R1_${ASSEM_NAME} --time=02:00:00 --mem=${MEMORY} --output=${FILT_DIR}/FILTER_5END_R2_${ASSEM_NAME} --account=${ACCOUNT} $FILT5END $RAW_DIR $SRA R2 $FILTER $FILT_DIR)

echo "### Step 3A: Pair reads & mapping quality filter"
echo "### Step 3.B: Add read group"
jid6=$(sbatch --dependency=afterany:${jid4/Submitted batch job /}:${jid5/Submitted batch job /} --cpus-per-task=${CPU} --job-name=BAM_MERGE_${ASSEM_NAME} --time=04:00:00 --mem=${MEMORY} --output=${PAIR_DIR}/BAM_MERGE_${ASSEM_NAME} --account=${ACCOUNT} $BAMMERGE $COMBINER $FILT_DIR $SRA $MAPQ_FILTER $FAIDX $TMP_DIR $PAIR_DIR $LABEL)

echo "### Step 4: Mark duplicates"
jid7=$(sbatch --dependency=afterany:${jid6/Submitted batch job /} --cpus-per-task=${CPU} --job-name=BAM_DUPLICATES_${ASSEM_NAME} --time=04:00:00 --mem=${MEMORY} --output=${TMP_DIR}/BAM_DUPLICATES_${ASSEM_NAME} --account=${ACCOUNT} $BAMDUPLICATES $PAIR_DIR $SRA $REP_DIR $REP_LABEL $TMP_DIR $STATS)

echo "###Step 5: generate bed file"
jid8=$(sbatch --dependency=afterany:${jid7/Submitted batch job /} --cpus-per-task=${CPU} --job-name=BED_${ASSEM_NAME} --time=01:00:00 --mem=${MEMORY} --output=${REP_DIR}/BED_${ASSEM_NAME} --account=${ACCOUNT} $BED $REP_DIR $REP_LABEL)

echo "###Step 6: SALSA scaffolding"
jid9=$(sbatch --dependency=afterany:${jid8/Submitted batch job /} --cpus-per-task=${CPU} --job-name=SALSA_${ASSEM_NAME} --time=03:00:00 --mem=${MEMORY} --output=${REP_DIR}/SALSA_${ASSEM_NAME} --account=${ACCOUNT} $SALSA $REF $FAIDX $REP_DIR $REP_LABEL $FINAL $GRAPH)
