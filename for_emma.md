Open R-studio on macosx. 
```
>library(phyloseq)
>library(tidyverse)
>load("JRW_simplePhyloSeq_07102023.rds")
```
Note, i'm assuming that you are starting R-studio in your home directory, and that the JRW_simplePhyloSeq_07102023.rds file is present in that directory. 
After loading, you should be able to access five objects, one of which is a phyloseq object called 'ps'.
```
>objects()
[1] "ps"            "sample.names"  "samples.out"   "seqtab"        "seqtab.nochim"
```
'ps' should be provide data on its contents (sample number, metadata variables, nucleotide sequences).
```
>ps
phyloseq-class experiment-level object
otu_table()   OTU Table:         [ 73741 taxa and 75 samples ]
sample_data() Sample Data:       [ 75 samples by 28 sample variables ]
tax_table()   Taxonomy Table:    [ 73741 taxa by 7 taxonomic ranks ]
refseq()      DNAStringSet:      [ 73741 reference sequences ]
```
You can see there are 75 samples and 73741 amplicon sequence variants (ASVs, or 'species'). 
The 'otu_table()' could be called an 'ASV_table()'... basically the same thing. 
The 'tax_table' has taxonomic information for ASVs.
The 'sample_data()' contains any metadata associated with your samples. Things like where the samples came from, when they were collected, 
chemical/physical data if present.
All of these data can be looked at, modified, exported. 
Just as an example, lets just look at the beginning of an tax_table().
```
>head(tax_table(ps))
Taxonomy Table:     [6 taxa by 7 taxonomic ranks]:
     Kingdom    Phylum          Class            Order              Family              Genus           
ASV1 "Bacteria" "Bacteroidota"  "Bacteroidia"    "Flavobacteriales" "Flavobacteriaceae" "Flavobacterium"
ASV2 "Bacteria" "Bacteroidota"  "Bacteroidia"    "Flavobacteriales" "Flavobacteriaceae" "Flavobacterium"
ASV3 "Bacteria" "Cyanobacteria" "Cyanobacteriia" "Chloroplast"      NA                  NA              
ASV4 "Bacteria" "Cyanobacteria" "Cyanobacteriia" "Chloroplast"      NA                  NA              
ASV5 "Bacteria" "Cyanobacteria" "Cyanobacteriia" "Chloroplast"      NA                  NA              
ASV6 "Bacteria" "Cyanobacteria" "Cyanobacteriia" "Chloroplast"      NA                  NA              
     Species         
ASV1 NA              
ASV2 "saccharophilum"
ASV3 NA              
ASV4 NA              
ASV5 NA              
ASV6 NA
```
