#!/bin/bash
#
#SBATCH --chdir=/mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB
#SBATCH --job-name=trimmomatic
#SBATCH --partition=medium
#SBATCH --cpus-per-task=10
#SBATCH --mem=24G
#SBATCH --mail-user=c.bitencourt@kew.org
#SBATCH --mail-type=END,FAIL

### trim the reads
###TRIMMOMATIC (one option among others)
# The path of the adapter list given to Trimmomatic has to be specified relative to where the command is run, it does not work with absolute path apparently
#/mnt/shared/scratch/cbitenco/apps/conda/share/

for f in *R1.fastq.gz; 
do (java -jar /mnt/shared/scratch/cbitenco/apps/conda/share/trimmomatic-0.38-0/trimmomatic.jar PE -phred33 $f ${f/R1.fastq.gz}R2.fastq.gz ${f/R1.fastq.gz}R1_Tpaired.fastq.gz ${f/R1.fastq.gz}R1_Tunpaired.fastq.gz ${f/R1.fastq.gz}R2_Tpaired.fastq.gz ${f/R1.fastq.gz}R2_Tunpaired.fastq.gz ILLUMINACLIP:/mnt/shared/scratch/cbitenco/apps/conda/share/trimmomatic-0.38-0/adapters/TruSeq3-PE-2.fa:1:30:6 LEADING:28 TRAILING:28 SLIDINGWINDOW:4:30 MINLEN:36 -threads 12); 
done

mkdir trimmed_file	
mv *Tpaired.fastq.gz trimmed_file
mv *Tunpaired.fastq.gz trimmed_file
cd ./trimmed_file

#Use MultiQC again to generate a report for all your sample after trimming
#https://protect-eu.mimecast.com/s/KNJjCJNR8HBXL6VuGJ4GB/
multiqc ./ ### done on every folder with fastqc reports in it. I.e., done for each of the 15 sequencing runs.

# Look at the fastqc and decide if ok, if not redo it all better
