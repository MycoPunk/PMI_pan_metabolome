#!/bin/bash
#SBATCH --job-name=antismahstest
#SBATCH --output=logs/antismash.%a.log
#SBATCH --mail-user=lotuslofgren@gmail.com
#SBATCH --mail-type=FAIL,END
#SBATCH --time=2:00:00
#SBATCH --mem=5G
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=8
#SBATCH --partition=common

#get gff3
#python3 scripts/jgi-query.py Umbelo1 -r .gff3.gz

#get fasta
#python3 scripts/jgi-query.py Umbelo1 -r _AssemblyScaffolds.fasta.gz 

#put them in the right place
JGI_CODE=Umbelo1
#get gff3
python3 scripts/jgi-query.py $JGI_CODE -r .gff3.gz

#get fasta
python3 scripts/jgi-query.py $JGI_CODE -r _AssemblyScaffolds.fasta.gz 
