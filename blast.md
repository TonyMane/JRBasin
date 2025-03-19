I typically use blast (or some variant of blast) to identify the presence of genes in a metagenome. To explore sequence space to the fullest, i like to screen the metagenomes prior to doing any asssembly/binning. Its probably good practice to quality filter samples prior to this type of analysis, but, some sequencing runs are so super high quality that you can get away with not cleaning/trimming before had (although i would def do this prior to any assemblying). I typically use sickle for this type of work-flow. 
So, this little workflow assumes that you have access to some sort of fastq file (post-cleaned, or not, and it can either compressed (i.e. "fastq.gz" or unzipped "fastq"). I typically just use the forward (i.e. "R1.fastq.gz" or "R1.fastq") files. You will also need diamond and microbe-census installed. 
There are multiple types of blast. Nucleotide blast (blastn) queries a nucleotide file against a nucleotide database. Translated blast (BLASTX) queries a nucleotide sequence against a protein database after conversion of the nucleotide query into protein space in 6 different reading frames (3 forward, 3 reverse). This is what I use most often, and what we'll use here. Protein blast (BLASTP) compares a protein fasta file against a protein database file. I typically use this when looking at protein translations from genomes (or MAGs, after having some sort of assembly/binning done). There are several other types of BLAST variants (i.e. short read blast, MAGIC-blast, t-blast-n, for protein versus nucleotide databases). Read the docs for more information: https://ftp.ncbi.nlm.nih.gov/pub/factsheets/HowTo_BLASTGuide.pdf. The most recent version of BLAST (BLASTX+) is still a bit slow. However, a faster iteration has been published, called diamond, https://github.com/bbuchfink/diamond. The commands are slighlty different than blast, but the output can be formatted to look exactly like the original version of blast (tab delimited, format 6). 
Installing should be fairly easy, it might already be installed. To see, just type the following:

```
diamond
Error: Syntax: diamond COMMAND [OPTIONS]. To print help message: diamond help
```
If its installed you should see 

Error: Syntax: diamond COMMAND [OPTIONS]. To print help message: diamond help

If you want see all the options associated with diamond, try 'diamond help'. Might be worth it at some point.
If you don't have it installed, try the below.

```
conda install bioconda/label/cf201901::diamond

```
Once installed, you'll need to have a file (a fasta file of proteins) to use as a database. For all the analyses i've been showing thus far (i.e. narG, norB, nosZ) have been generated using a pre-compiled set protein genes developed by Chris Greening's group in Australia. https://bridges.monash.edu/articles/online_resource/Compiled_Greening_lab_metabolic_marker_gene_databases/14431208
Download this from the link and put onto your tempest home directory. Lets just start with a single protein sequence file to use as a database. Lets use nitrouse oxide reductase (nosZ), 'Nitrous oxide reductase NosZ sequences.fasta'.

```
diamond makedb --in Nitrous\ oxide\ reductase\ NosZ\ sequences.fasta --db Nitrous\ oxide\ reductase\ NosZ\ sequences.fasta.dmnd
```
The output file with extension 'dmnd' is now searchable by diamond blastx, and we can evaluate nosZ gene frequencies/relative abundance in a metagenome(s). 
The metagenome i'm using here is called 'JRW_metaG_04182022_RW04.R1.fastq'.

```
diamond blastx -q JRW_metaG_04182022_RW04.R1.fastq -d /home/v95j955/'Nitrous oxide reductase NosZ sequences.fasta.dmnd' -f 6 -k 1 --id 70 --min-score 50 --query-cover 75 -o JRW_metaG_04182022_RW04.R1.fastq.nosZ
```
The above line will in on tempest. However, its probably best practice to not run this type of analysis on a head-node. Rather, you should probably use 'sbatch'. Below is what a pbs script would like:

```
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
#SBATCH --mem=24G                     # 2000 MB of Memory allocated; set --mem with care
#SBATCH --time=1-00:00:01                 # Maximum job run time
##SBATCH --array=1-3                  # Number of jobs in array
#SBATCH --output=example-%j.out
#SBATCH --error=example-%j.err

## Run 'man sbatch' for more information on the options above.

diamond blastx -q JRW_metaG_04182022_RW04.R1.fastq -d /home/v95j955/'Nitrous oxide reductase NosZ sequences.fasta.dmnd' -f 6 -k 1 --id 70 --min-score 50 --query-cover 75 -o JRW_metaG_04182022_RW04.R1.fastq.nosZ
```
If you copy and paste that into a file called 'blastx_practice.sh', and then modify the --acount (probably stephanieewing versus frankstewart), this script should work as is (assuming you have fastq file called JRW_metaG_04182022_RW04.R1.fastq, however, this could be one of the soil metagenomes as well, and you can change this to whatever you want to call it). 

But getting back to the actual command we ran. The '-q' variable is the input metagenome. The database file is the '-d' parameter. The '-f' flage tells use to print the output in tab-delimited file.
The '-k' flag tells use how many postive hits to print. I choose 1 here, because i am interested solely in evaluating the relative abundance of genes identified as a nosZ variant. The '--id' is the percent amino-acid identity that should be observed between a query sequence in the metagenome and a given protein in the database. This is probably one of the more important parameters to understand. At 70% id, we can be reasonably sure our postive hits are positive. However, there are some genes that have shared evolutionary trajectories, yet distinct functions, with other genes such that 70% is too low. This is the case of ammonia monooxygeneases and methane monooxygenases, I typically use tighter (i.e. high %ids). However, for most of the genes in the greening database (51 i think), 70% is a good threshold. The 'min-score' is a data-indepenendent cummulative score. If you want better explanations on bit-score/evalues, see:
https://www.metagenomics.wiki/tools/blast/evalue

I recommend at least looking at the output of the blast search:
```
head JRW_metaG_04182022_RW04.R1.fastq.nosZ
```
you should see something like this:
```
VH00301:352:AAC73JMHV:1:1101:44438:2325 WP_009206857.1  70.0    50      15      0       1       150     426     475     4.6e-18 81.3
VH00301:352:AAC73JMHV:1:1101:54834:6282 WP_068637089.1  86.0    50      7       0       151     2       192     241     2.1e-23 99.0
VH00301:352:AAC73JMHV:1:1101:47846:8005 WP_041347318.1  77.6    49      11      0       149     3       571     619     1.8e-22 95.9
VH00301:352:AAC73JMHV:1:1101:64566:9349 WP_011287329.1  81.6    49      9       0       3       149     685     733     3.2e-19 85.1
VH00301:352:AAC73JMHV:1:1101:21280:11318        WP_041355904.1  92.0    50      4       0       150     1       443     492     8.7e-25 103.6
VH00301:352:AAC73JMHV:1:1101:60685:12094        WP_041347318.1  77.6    49      11      0       149     3       571     619     1.8e-22 95.9
VH00301:352:AAC73JMHV:1:1101:17322:13760        WP_027458136.1  86.0    50      7       0       2       151     296     345     9.0e-22 93.6
VH00301:352:AAC73JMHV:1:1101:33588:14120        WP_015767852.1  96.0    50      2       0       2       151     260     309     1.0e-25 106.7
VH00301:352:AAC73JMHV:1:1101:58772:17944        WP_009206857.1  95.9    49      2       0       3       149     112     160     6.0e-26 107.5
VH00301:352:AAC73JMHV:1:1101:27529:18777        WP_012962813.1  72.0    50      14      0       151     2       199     248     8.4e-20 87.0
```
The first column is the subject ID (a sequence from your metagenomic search), the second is query from the database. The 3rd column is the percent-id. Note, nothing less that 70% (because thats the threshold we set the search at). I can never remember what columns 4-10 represent, but use this: https://www.metagenomics.wiki/tools/blast/blastn-output-format-6. Column 11 is the e-value (which look low, to be epected, typically want these below 1e-10), and the bit-score (again nothing lower than 50). 

Because each positive subject ID has one line assocaited with its postivive query in the database, we can count the lines in this file using 'wc' (a simple unix command) to see how many sequences (or counts) associated with nosZ are present in this metagenome.

```
wc -l JRW_metaG_04182022_RW04.R1.fastq.nosZ
```
You should see:
```
13422
```
In the excel sheet i sent around, this would represent the 'Count' column. 
There are numerous ways to normalize this number. One way is referred to as reads per-kilobase million sequences (i.e. RPKM).
This is pretty easy to do, but does not take into the underlying heterogeneity in average genome sizes (AGS) (microbial genome sizes) observed between metagenomic samples. 
This can significantly alter the interpretation of gene count data. 
A initial observation and report of AGS relevance: https://link.springer.com/article/10.1186/gb-2007-8-1-r10. 
An initial method for correcting: https://www.nature.com/articles/ismej201029. 
The most update method for correction: https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0611-7.
This last one also has a precompiled package called 'microbe_census' associated with its publication. 
I think you have this installed. normalization of gene count data based on genome size (or equivilents) is often termed reads-per kilobase genome equivalent (RPKG).  
To get this number, its not too difficult (just one command). On tempest, i installed this all installed in conda environment called microbe (i think we did this too with your environment?).

```
conda activate microbe
```
then, run:
```
run_microbe_census.py JRW_metaG_04182022_RW04.R1.fastq JRW_metaG_04182022_RW04.R1.fastq.mcs -t 24
```
the output of this file will have and id called 'genome_equivalents'.
the number 'should' be 9824.08864035. to see, just do:
```
cat JRW_metaG_04182022_RW04.R1.fastq.mcs
```
or 
```
grep "genome_equivalents" JRW_metaG_04182022_RW04.R1.fastq.mcs
```
which should print:
```
genome_equivalents:     9824.08864035
```
Ok, to get the RPKG value for nosZ, we just do the following:
RPKG= {gene count/gene size (in kilo bp)}/genome_equivalents
the gene size for nosZ is ~1.9 kilobase pairs. 

So here, RPKG_nosZ = {(13422)/(1.9)}/9824.08864035 = 0.7190703

Note, in the excel sheet i sent over. the 'length' of the gene is actually in amino acids.
to get the average base-pairs you would just multiply the amino acid number by 3 (3 bp per amino acid sequence).
then to get to kilobasepairs, divide by the bp by 1000 (kbp). this is all done in the 'RPKG' column. 

So of the 9824 genome equivilants, ~70% have a nosZ gene. This would mean the liklihood of us encountering a cell harboring this gene is quite high, and that the potential for nitrous oxide consumption is well represented throughout the community. 

We probably have lots of metagenomes we would like to do this type of analysis on. You could go one metagenome at a time. Or you run a for loop.
Lets use some of the most recent 2024 JRW data in (TEMP_collab_directories/20250228_A_DNASeq_PE150) on tempest.
If you change into this directory you should see n=14 'R1.fastq.gz' files. To run diamond-blastx on all these, you run the following:
'''
cd /home/v95j955/20250228_A_DNASeq_PE150/
for i in *R1.fastq.gz;
do diamond blastx -q "$i" -d /home/v95j955/databases/greening/'Nitrous oxide reductase NosZ sequences.fasta.dmnd' -f 6 -k 1 --id 70 --min-score 50 --query-cover 75 -o "$i".nosZ;
done;
'''

