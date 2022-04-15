#!/bin/bash
#SBATCH --job-name=antismahstest
#SBATCH --output=logs/run_antismash.%a.log
#SBATCH --mail-user=lotuslofgren@gmail.com
#SBATCH --mail-type=FAIL,END
#SBATCH --time=2:00:00
#SBATCH --mem=20G
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=8
#SBATCH --partition=common

source /hpc/group/vilgalyslab/lal76/miniconda3/etc/profile.d/conda.sh
conda activate /hpc/group/vilgalyslab/lal76/miniconda3/envs/antismash

CPU=1
if [ ! -z $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi
OUTDIR=antismash_results
SAMPFILE=genomes.txt
N=${SLURM_ARRAY_TASK_ID}
if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi
MAX=`wc -l $SAMPFILE | awk '{print $1}'`

if [ $N -gt $MAX ]; then
    echo "$N is too big, only $MAX lines in $SAMPFILE"
    exit
fi

#IFS=/t
IFS=$(echo -en "\n\b")
INPUTFOLDER=genomes

cat $SAMPFILE | sed -n ${N}p | while read BASE PREFIX
do
	name=$BASE
 	species=''
	gunzip /hpc/group/vilgalyslab/lal76/PMI_metaSMC/$INPUTFOLDER/$name/fasta/*
	gunzip /hpc/group/vilgalyslab/lal76/PMI_metaSMC/$INPUTFOLDER/$name/gff/*
	if [ ! -d $INPUTFOLDER/$name/$OUTDIR ]; then
		echo "No antismash folder for ${name}"
		exit
 	fi
	echo "processing $name"
	#if [[ ! -d $INPUTFOLDER/$name/$OUTDIR && ! -s $INPUTFOLDER/$name/$OUTDIR/index.html ]]; then
	#	antismash --taxon fungi --output-dir $OUTDIR/$name/antismash_local  --genefinding-tool none \
	#    --asf --fullhmmer --cassis --clusterhmmer --asf --cb-general --pfam2go --cb-subclusters --cb-knownclusters -c $CPU \
	#    $OUTDIR/$name/$INPUTFOLDER/*.gbk
	antismash /hpc/group/vilgalyslab/lal76/PMI_metaSMC/$INPUTFOLDER/$name/fasta/*.fasta --taxon fungi --output-dir /hpc/group/vilgalyslab/lal76/PMI_metaSMC/$INPUTFOLDER/$name/$OUTDIR/ --genefinding-gff3 /hpc/group/vilgalyslab/lal76/PMI_metaSMC/$INPUTFOLDER/$name/gff/*.gff3
	#fi
done

      #  antismash $INPUTFOLDER/$name/fasta/Umbelo1_AssemblyScaffolds.fasta --taxon fungi --output-dir $INPUTFOLDER/$name/$OUTDIR/ --genefinding-gff3 $INPUTFOLDER/$name/gff/Umbelo1_GeneCatalog_20190614.gff3 \
       #  --cb-general --cb-subclusters --cb-knownclusters \
       #          --pfam2go -c $CPU 
