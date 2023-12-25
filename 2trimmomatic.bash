#!/bin/bash

# Set SLURM options (SBATCH) for job submission
#SBATCH --chdir=/path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored
#SBATCH --job-name=trimmomatic
#SBATCH --partition=medium
#SBATCH --cpus-per-task=10
#SBATCH --mem=24G
#SBATCH --mail-user=email@kew.org
#SBATCH --mail-type=END,FAIL

### Trim the reads

# Loop through all files with the pattern *R1.fastq.gz for trimming
for f in *R1.fastq.gz; do
    (
        # Use Trimmomatic to perform paired-end trimming
        java -jar /path/to/the/directory/where/the/program/is/trimmomatic-0.38-0/trimmomatic.jar \
        PE -phred33 $f \
        ${f/R1.fastq.gz}R2.fastq.gz \
        ${f/R1.fastq.gz}R1_Tpaired.fastq.gz \
        ${f/R1.fastq.gz}R1_Tunpaired.fastq.gz \
        ${f/R1.fastq.gz}R2_Tpaired.fastq.gz \
        ${f/R1.fastq.gz}R2_Tunpaired.fastq.gz \
        ILLUMINACLIP:/path/to/the/directory/where/adapters/are/trimmomatic-0.38-0/adapters/TruSeq3-PE-2.fa:1:30:6 \
        LEADING:28 TRAILING:28 SLIDINGWINDOW:4:30 MINLEN:36 -threads 12
    )
done

# Create a directory to store trimmed files
mkdir trimmed_file

# Move trimmed files to the created directory
mv *Tpaired.fastq.gz trimmed_file
mv *Tunpaired.fastq.gz trimmed_file

# Change the working directory to the trimmed_file directory
cd ./trimmed_file

# Use MultiQC to generate a report for all samples after trimming
multiqc ./
