#!/bin/bash
#
#SBATCH--chdir=/mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/assembly
#SBATCH --job-name=HybPiper
#SBATCH --partition=long
#SBATCH --array=1-342%15   
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=24G
#SBATCH --mail-user=c.bitencourt@kew.org
#SBATCH --mail-type=END,FAIL


echo $SLURM_ARRAY_TASK_ID

name=$(awk -v lineid=$SLURM_ARRAY_TASK_ID 'NR==lineid{print;exit}' /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/assembly/Apocynaceaelist.txt)

echo $name


## We need to do hybpiper on cropdiversity's local scratch because HybPiper produces A LOT of temporary files and folders.
## The local scratch directory is a directory that is temporary and only produced while the analysis is running.
## We then have to copy all of the results into our own folder before the script ends, otherwise everything from that run is deleted when the local scratch is deleted automatically.
## see https://help.cropdiversity.ac.uk/data-storage.html#local-scratch 

cd $TMPDIR


#----- Assembling targetted angio353 baits loci - Run Hypiper ----- 
#### YOU NEED TO CHECK IF YOUR FILES AFTER TRIM ARE ZIPPED, IF YES ... ####

#### FIRST, UNZIP THE READ FILES ####
#parallel -j12 "gunzip {}" ::: *.fastq.gz


#Run hybpiper

hybpiper assemble \
  -t_dna /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/working/apocynaceae_targetfile.fasta \
  --readfiles /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/trimmed_file/"$name"_R1_Tpaired.fastq.gz /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/trimmed_file/"$name"_R2_Tpaired.fastq.gz \
  --prefix $name \
  --bwa \
  --cov_cutoff 8 \
  --cpu ${SLURM_CPUS_PER_TASK}

# At this stage you have a folder per sample, and in each sample you have a folder per gene, containing the corresponding concatenated exons sequences for this gene for this sample.


## Copy all the results back into your own folder
#Copy folders
parallel 'cp -r {} /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/assembly/' ::: *
#Copy files
parallel 'cp {} /mnt/shared/projects/rbgk/projects/cbitencourt/Apocys/PAFTOL_1KP_NIF-CB/assembly/' ::: *