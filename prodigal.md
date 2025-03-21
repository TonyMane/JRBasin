Some basic prodigal use. Please read the actual publication associated with prodigal
https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-11-119

Prodigal was installed using 'mamba', should be available without loading any conda environments.
```
source /home/p21r674/miniconda3/etc/profile.d/conda.sh
cd /home/p21r674/amazon_space/COA_6092/6092_sickle/CN/CN_maxbin/maxbin_pick
#With just nucleotides being called, '-d' option/output.
prodigal -i long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta -d long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna

#not a bad idea to see how many genes have been written- can do this with grep.
grep -c ">" long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna
#Or use a wild card, will work even with just one file, but more useful if you have several *.fna files (which you eventually will).
grep -c ">" *.fna

#With amino acid output, '-a' option/output.
prodigal -i long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta -d long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna -a long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.faa

#A simple loop to run prodigal over several genomes
for i in *.fasta; do prodigal -i "$i" -d "$i".fna; done;
```
Also installed diamond using mamba. This should run without having to load any other conda environments.
Probably a good idea to read the manuscript associated with diamond.
https://www.nature.com/articles/nmeth.3176

```
#first we need a database. can be just about any number of proteins- as long they are in a fasta file, ussually denoted as '.faa'.
cp /home/p21r674/Greening_lab_metabolic_marker_gene_databases/Particulate\ methane\ monooxygenase\ PmoA.fasta ./
diamond makedb --in Particulate\ methane\ monooxygenase\ PmoA.fasta -d Particulate\ methane\ monooxygenase\ PmoA.fasta.dmnd
#Now we can perform translated blasts (i.e. blastx) with diamond
diamond blastx -q long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna -d Particulate\ methane\ monooxygenase\ PmoA.fasta.dmnd -f 6
#The above would run on the command line and print the result (if any) to stanard output. Can write to a file with '-o' option.
diamond blastx -q long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna -d Particulate\ methane\ monooxygenase\ PmoA.fasta.dmnd -f 6 -o long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna.pmoA
#A for loop can be used to blast over several nucleotid files.
for i in *.fna; do diamond blastx -q "$i" -d Particulate\ methane\ monooxygenase\ PmoA.fasta.dmnd -f 6 -o "$i".pmoA;
```
The above prodigal commands are run using the default parameters, which are set fairly high (in my opinion).
This means that the liklihood of false positives is also high. We can change this by decreasing the e-value threshold,
increasing the percent identity required between a query and the database, and increasing the bit-score. 
For most of the genes in the greening lab database file, an amino acid identity of at least 70% should be used.
For some genes even higher (nxrA, narG, amoA variants). 

```
diamond blastx -q long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna -d Particulate\ methane\ monooxygenase\ PmoA.fasta.dmnd -f 6 --min-score 50 --id 70
```
to search across several gene files, using the below:

```
for i in *.fna; do diamond blastx -q "$i" -d Particulate\ methane\ monooxygenase\ PmoA.fasta.dmnd -f 6 --min-score 50 --id 70 -o "$i".pmoA; done;
```
