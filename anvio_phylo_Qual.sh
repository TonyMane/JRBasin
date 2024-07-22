#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-frankstewart        #specify the account to use
#SBATCH --job-name=sample            # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=16              # number of cores to allocate
#SBATCH --mem=24G                    # 2000 MB of Memory allocated; set --mem with care
#SBATCH --time=0-10:00:01                 # Maximum job run time
##SBATCH --array=1-3                  # Number of jobs in array
#SBATCH --output=example-%j.out
#SBATCH --error=example-%j.err

## Run 'man sbatch' for more information on the options above.
source /home/v95j955/miniconda3/etc/profile.d/conda.sh
conda activate anvio-dev
cd /home/v95j955/6092/MAG_dRep/dereplicated_genomes/

#fixes the fasta file names, required for anvio.
for i in *.fasta; 
do anvi-script-reformat-fasta "$i" -o "$i".fixed.fa --simplify-names;
done;

#generates the contigs databases.
for i in *fixed.fa; 
do anvi-gen-contigs-database -f "$i" -o "$i".db;
done;

#run hidden markov models.
for i in *db; 
do anvi-run-hmms -c "$i"; 
done;

#run single copy marker taxonomy.
for i in *db; 
do anvi-run-scg-taxonomy -c "$i" --min-percent-identity 70; 
done;

#estimate the taxonomic association of ribosomal markers, prints the output to a file with extension 'taxonony'.
for i in *db; 
do anvi-estimate-scg-taxonomy -c "$i" -o "$i".taxonomy --just-do-it; 
done;

#estimate the completion, redundancy of the genomes, prints the output to a file with extension 'complete'.
for i in *db; 
do anvi-estimate-genome-completeness -c "$i" -o "$i".complete; 
done;
