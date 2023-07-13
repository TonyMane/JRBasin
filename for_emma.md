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
You can do the same thing for the 'meta_data', 'otu_table'.
```
> head(sample_data(ps))
Sample Data:        [6 samples by 28 sample variables]:
                                          Subject Environment     Site       Time Color_Environment Site_Abbr
A10-JRW3-08012022-RW04-1 A10-JRW3-08012022-RW04-1        Well RailRoad Subsurface             Black         R
A11-JRW2-06062022-RW04-1 A11-JRW2-06062022-RW04-1        Well RailRoad Subsurface             Black         R
A2-JRW1-R05-Time8-2           A2-JRW1-R05-Time8-2      Stream RailRoad      Time8              Blue         R
A3-JRW2-RR04-Time1-1         A3-JRW2-RR04-Time1-1      Stream RailRoad      Time1              Blue         R
A4-JRW2-RR04-Time5-1         A4-JRW2-RR04-Time5-1      Stream RailRoad      Time5              Blue         R
A5-JRW2-LL05-Time1-1         A5-JRW2-LL05-Time1-1      Stream   LowerL      Time1              Blue         L
                         Site_Abr_Color Date           New_NAME Period Period_Color Temp   SC   EC percDO    DO   pH
A10-JRW3-08012022-RW04-1            Red JRW3               <NA>   <NA>         <NA> 19.0 1215 1073    6.3  0.34 6.87
A11-JRW2-06062022-RW04-1            Red JRW2               <NA>   <NA>         <NA>  8.5  415  280   13.0  1.28 7.05
A2-JRW1-R05-Time8-2                 Red JRW1  RR_042022_0500_r2   DAWN       orange   NA   NA   NA     NA    NA   NA
A3-JRW2-RR04-Time1-1                Red JRW2  RR_061022_1700_r1   DUSK         blue 17.1  272  234   70.9  5.82 7.85
A4-JRW2-RR04-Time5-1                Red JRW2 RR_0611222_1200_r1  NIGHT        black 16.1 1048  869   92.4  7.73 7.86
A5-JRW2-LL05-Time1-1             Orange JRW2  LL_060922_1700_r1   DUSK         blue 26.7  757  781  151.7 10.37 8.53
                         BP_mmHg     NH4  NO3_NO2        IC        TC     NPOC     TN      SO4        Cl          NO3
A10-JRW3-08012022-RW04-1   652.5 0.02992 -0.02364 109.30000 115.91793 4.480699 0.3282 86.06661 16.432639  0.002135693
A11-JRW2-06062022-RW04-1   651.3 0.34370  0.08531 105.23015 110.04747 2.788525 0.5253 81.64734 18.604332  0.242800397
A2-JRW1-R05-Time8-2           NA 4.27700  0.07963  81.94229  75.79873 4.001532 4.3380 91.03146 20.272319  4.246354042
A3-JRW2-RR04-Time1-1       650.2 1.27200  0.17350  81.84015  90.11747 5.093525 1.5952 22.80468  1.270784 98.913255470
A4-JRW2-RR04-Time5-1       649.2 1.52600  0.10020  83.23015  91.03747 4.711525 1.7072 21.67166  1.543431 98.482269050
A5-JRW2-LL05-Time1-1       654.7 2.76700  0.03367  62.29015  73.46747 7.410525 2.9452 12.84826  2.920159 55.862744590
                                 NO2
A10-JRW3-08012022-RW04-1 0.011156241
A11-JRW2-06062022-RW04-1 0.002760017
A2-JRW1-R05-Time8-2      0.004492473
A3-JRW2-RR04-Time1-1     0.006516773
A4-JRW2-RR04-Time5-1     0.005103584
A5-JRW2-LL05-Time1-1     0.002593932
```
