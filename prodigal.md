Some basic prodigal use. Please read the actual publication associated with prodigal
https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-11-119
Prodigal was installed using 'mamba', should be available without loading any conda environments.
```
source /home/p21r674/miniconda3/etc/profile.d/conda.sh
cd /home/p21r674/amazon_space/COA_6092/6092_sickle/CN/CN_maxbin/maxbin_pick
#With just nucleotides being called, '-d' option/output.
prodigal -i long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta -d long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna

#With amino acid output, '-a' option/output.
prodigal -i long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta -d long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.fna -a long_maxbin_output_CN_04_15_20230718_A1_6092_S1_L001_R1.001.fasta.faa

#A simple loop to run prodigal over several genomes
for i in *.fasta; do prodigal -i "$i" -d "$i".fna; done;
```
