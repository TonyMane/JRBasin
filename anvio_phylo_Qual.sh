source /home/v95j955/miniconda3/etc/profile.d/conda.sh
conda activate anvio-dev
#fixes the fasta file names, required for anvio.
for i in *.fasta; 
do anvi-script-reformat-fasta "$i" -o "$i".fixed.fa --simplify-names;
done;

#generates the contigs databases.
for i in *fixed.fa; 
do anvi-gen-contigs-database -f "$i" -o "$i".db;
done;

#creates a contigs database.
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
