#!/bin/bash
#SBATCH --job-name=antismahstest
#SBATCH --output=logs/init.%a.log
#SBATCH --mail-user=lotuslofgren@gmail.com
#SBATCH --mail-type=FAIL,END
#SBATCH --time=2:00:00
#SBATCH --mem=5G
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=8
#SBATCH --partition=common

#initiate file structure
while read JGI_CODE; do

#put them in the right place
#get gff3
mkdir /hpc/group/vilgalyslab/lal76/PMI_metaSMC/genomes/$JGI_CODE/
mkdir /hpc/group/vilgalyslab/lal76/PMI_metaSMC/genomes/$JGI_CODE/fasta/
mkdir /hpc/group/vilgalyslab/lal76/PMI_metaSMC/genomes/$JGI_CODE/gff/
mkdir /hpc/group/vilgalyslab/lal76/PMI_metaSMC/genomes/$JGI_CODE/antismash_results

done < genomes.txt

