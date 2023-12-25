#!/bin/bash
#
# Set the working directory
#SBATCH --chdir=/path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored

# Job parameters
#SBATCH --job-name=fastqc
#SBATCH --partition=medium
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --export=ALL
#SBATCH --mail-user=email@kew.org
#SBATCH --mail-type=END,FAIL

# Load required modules (modify as needed)
module load fastqc
module load multiqc

# Run FastQC on all .fastq.gz files in the current directory
for f in *.fastq.gz; do
    fastqc "$f"
done

# Create a directory for storing FastQC results
mkdir -p /path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored/fastqc_pre_trim

# Move FastQC output files to the new directory
mv *.zip *.html /path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored/fastqc_pre_trim

# Use MultiQC to collate all QC information into one place
# Run MultiQC on the directory containing FastQC results
multiqc /path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored/fastqc_pre_trim
