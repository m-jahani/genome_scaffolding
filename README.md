# Genome Scaffolding

Different tools for scaffolding genome assembly with HiC
_________________________________________________________
## SALSA

SALSA scaffolding pipeline on Computecanada


Runs as:
```
 bash SALSA_PIPELINE.sh REF GRAPH SRA IN_DIR ASSEM_NAME SAVE_DIR BIN
```


* REF = directory to assembly fasta file

* GRAPH = directory to graph assembly file

* SRA = basename of HiC fastq files Dovetail.HiC_

* IN_DIR = directory for HiC reads

* ASSEM_NAME = Assembly name

* SAVE_DIR = Saving directory

* BIN = directory of SALSA (contains the pipeline)



## 3D-DNA

HiC scaffolding of genome assemblies with Juicer and 3DDNA

## scaffolding_pipeline.sh

Run as:
```
bash scaffolding_pipeline.sh *hic.hap1.p_ctg.fasta PREFIX JUCIER_DIR
```

