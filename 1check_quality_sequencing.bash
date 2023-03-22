#!/bin/bash
#

#SBATCH --chdir=/mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB
#SBATCH --job-name=fastqc
#SBATCH --partition=medium
#SBATCH --cpus-per-task=10
#SBATCH --mem=24G
#SBATCH --export=ALL
#SBATCH --mail-user=c.bitencourt@kew.org
#SBATCH --mail-type=END,FAIL

for f in *.fastq.gz; 
do (fastqc $f); 
done

mkdir /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/fastqc_pre_trim
mv *.zip /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/fastqc_pre_trim
mv *.html /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/fastqc_pre_trim

#Use MultiQC to collate all QC information into one place, and to generate useful output files for all samples
#https://protect-eu.mimecast.com/s/KNJjCJNR8HBXL6VuGJ4GB/
multiqc ./ ### done on every folder with fastqc reports in it. I.e., done for each of the 15 sequencing runs.