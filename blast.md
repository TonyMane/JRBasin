I typically use blast (or some variant of blast) to identify the presence of genes in a metagenome. To explore sequence space to the fullest, i like to screen the metagenomes prior to doing any asssembly/binning. However, its probably good practice to at the least quality filter samples prior to this type of analysis. I typically use sickle for this type of work-flow, and i think i have communicated how to run sickle elsewhere. So, this little workflow assumes that you have access to a cleaned fastq file. I also evaluate gene presence using the forward reads only. You will also need diamond and microbe-census installed. 
There are multiple types of blast. Nucleotide blast (blastn) queries a nucleotide file against a nucleotide database. Translated blast (BLASTX) queries a nucleotide sequence against a protein database after conversion of the nucleotide query into protein space in 6 different reading frames (3 forward, 3 reverse). This is what I use most often, and what we'll use here. Protein blast (BLASTP) compares a protein fasta file against a protein database file. I typically use this when looking at protein translations from genomes. There are several other types of BLAST variants (i.e. short read blast, MAGIC-blast, t-blast-n, for protein versus nucleotide databases). Read the docs for more information: https://ftp.ncbi.nlm.nih.gov/pub/factsheets/HowTo_BLASTGuide.pdf. The most recent version of BLAST (BLASTX+) is still a bit slow. however, a faster iteration has been published, called diamond, https://github.com/bbuchfink/diamond. The commands are slighlty different than blast, but the output can be formatted to look exactly like the original version of blast (tab delimited, format 6). 
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
