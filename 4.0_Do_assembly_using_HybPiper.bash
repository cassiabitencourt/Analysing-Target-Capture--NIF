#!/bin/bash
#
#SBATCH --chdir=/path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored/assembly
#SBATCH --job-name=HybPiper
#SBATCH --partition=long
#SBATCH --array=1-353%10   
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --mail-user=email@kew.org
#SBATCH --mail-type=END,FAIL

# Print the SLURM array task ID
echo $SLURM_ARRAY_TASK_ID

# Retrieve sample name from FamilyList.txt using SLURM array task ID
name=$(awk -v lineid=$SLURM_ARRAY_TASK_ID 'NR==lineid{print;exit}' /path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored/assembly/FamilyList.txt)

# Print the sample name
echo $name

# Change to the temporary directory
cd $TMPDIR

# Assemble targeted angio353 baits loci using HybPiper
hybpiper assemble \
  -t_dna /path/to/my/working/directory/on/the/HPC/cluster/where/all/the/target/file/is/stored/targetfile.fasta \
  --readfiles /path/to/directory/where/all/the/trimmed/data/is/stored/trimmed_file/"$name"_R1_Tpaired.fastq.gz /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/trimmed_file/"$name"_R2_Tpaired.fastq.gz \
  --prefix $name \
  --bwa \
  --cov_cutoff 8 \
  --cpu ${SLURM_CPUS_PER_TASK}

# Copy results back to the original folder
# Copy folders
parallel 'cp -r {} /path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored/assembly/' ::: *
# Copy files
parallel 'cp {} /path/to/my/working/directory/on/the/HPC/cluster/where/all/the/raw/data/is/stored/assembly/' ::: *
