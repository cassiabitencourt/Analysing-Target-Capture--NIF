#!/bin/bash
#
#SBATCH --chdir=/mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/trimmed_file
#SBATCH --job-name=create-the-list
#SBATCH --partition=medium
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --mail-user=c.bitencourt@kew.org
#SBATCH --mail-type=END,FAIL

#----------------------------------------------- Get a file with CDS for each sample for each gene------------------------------------

### Now we only have the good data, so we can look into them and search the reads likely coming from our target genes
### We use Hybpiper, but this pipeline will need improvement 
### Some improvements are already implemented in PAFTools, and I am also working on it, but to learn and have a rough idea of what is in there Hybpiper is fine
### The principle of the pipeline is:
	## 1- Map reads against the target genes from one or multiple references (those used to design the baitkit for instance) --> 			## bwa or blast
	## 2- Assemble the reads corresponding to each gene, which will result in one or many contigs for one given gene --> 
	## 3- Decide which contig(s) to keep for each gene, put them together(?)
	##4- Map the final gene contig(s) against the reference and use the reference as well as typical intron motifs to find 			##intron/exon boundaries
	## 5- Keep exons only, and concatenate them ---> all of that is made by exonerate.py in the Hybpiper suite
	## 6- Keep introns only, and concatenate them(?) ---> this is optional, done by intronerate.py in the Hybpiper suite



### Prepare some inputs for Hypiper
# In the folder trimmed, make a list of the file names (only the part common to R1 and R2, for instance Pterocarpus-angolensis_S8_L001_) #using for instance the text editor vi
# first if you had a control that you don't want to run through hybpiper, here called undertermined, remove it from the folder with mv or remove it at all with rm
#rm Undetermined_S0_L001_R*
# then create the list:

for f in *_1_Tpaired.fastq; do (echo ${f/_1_Tpaired.fastq} >> Apocynaceaelist.txt); done

# check that it worked:

less Apocynaceaelist.txt

# get the fasta of the target cds (exons concatenated) in nucleotide format, here called xxxxx.fasta
