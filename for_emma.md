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
