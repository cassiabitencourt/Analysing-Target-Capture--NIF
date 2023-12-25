#!/bin/bash
#
#SBATCH --chdir=/path/to/directory/where/all/the/trimmed/data/is/stored/trimmed_file
#SBATCH --job-name=generatelist
#SBATCH --partition=medium
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --mail-user=email@kew.org
#SBATCH --mail-type=END,FAIL

# Prepare some inputs for HybPiper

# Navigate to the trimmed folder
cd /path/to/directory/where/all/the/trimmed/data/is/stored/trimmed_file

# Remove any control files you don't want to run through HybPiper
# Example: rm Undetermined_S0_L001_R*

# Create a list of file names (common part to R1 and R2) in FamilyList.txt
for f in *_1_Tpaired.fastq; do
  echo "${f/_1_Tpaired.fastq}" >> FamilyList.txt
done

# Check that the list is created
echo "Contents of FamilyList.txt:"
cat FamilyList.txt

# Get the fasta of the target cds (exons concatenated) in nucleotide format, here called xxxxx.fasta
# Add your command to generate the fasta file here
# Example: command_to_generate_fasta > xxxxx.fasta

# Print a message indicating the script has been completed
echo "Script execution completed."
