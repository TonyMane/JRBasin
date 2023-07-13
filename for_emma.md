Open R-studio on macosx. Phyloseq, tidyverse and dplyr 'should' be installed (i think MicroViz/phyloseq require these).
Also install the 'phyloschuyler' package, which is just a bunch of scripts/functions for manipulating phyloseq objects.
```
>library(phyloseq)
>library(tidyverse)
>load("JRW_simplePhyloSeq_07102023.rds")
>library(dplyr)
>install.packages("remotes")
remotes::install_github("schuyler-smith/phyloschuyler")
>library(phyloschuyler)
```
Note, i'm assuming that you are starting R-studio in your home directory, and that the JRW_simplePhyloSeq_07102023.rds file is present in that directory. 
After loading, you should be able to access five objects, one of which is a phyloseq object called 'ps'.
```
>objects()
[1] "ps"            "sample.names"  "samples.out"   "seqtab"        "seqtab.nochim"
```
'ps' should have data on its contents (sample number, metadata variables, nucleotide sequences).
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
Just as an example, lets just look at the beginning (or 'head') of the tax_table().
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
The taxonomic IDs of each ASV have been identified using a separate program (dada2, assignTaxonomy). That program 
uses a naive baysian classifier to infer identity of each ASV using the SILVA rRNA gene database (version 138).
You can do the same thing for the 'sample_data', 'otu_table'.
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
Prior to moving forward, we typically want to remove eukaryotic associated sequences from our samples.
The phyloschuler package has commands that make this fairly easy. 
I don't have a reference for it, but chloroplasts and mitochondrial signals can be identified at the Order and Class levels
respectively. 
```
ps.clean <- ps %>%
  taxa_prune("Chloroplast", "Order") %>%
  taxa_prune("Mitochondria", "Family")
```
Ok, now we have phyloseq object (ps.clean) that we can further manipulate. Its not uncommon in microbiome 
analyses to rarefy to an even sequence depth. Or, at least remove samples with less than some number of sequences.
You can get a sense of how deeply sequenced versus how poorly sequenced your ASV/sample table is with some simple base-R/phyloseq commands:
```
>sort(colSums(t(otu_table(ps.clean))))
E4-JRW2-RR04-Time7-1     H4-JRW2-RR04-Time8-2     G4-JRW2-RR04-Time8-1     D4-JRW2-RR04-Time6-2 
                       0                        0                        2                      102 
E11-JRW1-04182022-RW04-2      H2-JRW1-R05-Time5-1 G11-JRW1-04192022-LL02-1     B8-JRW2-PC10-Time5-2 
                     858                    13569                    14466                    16026 
     E2-JRW1-R05-Time6-2      C2-JRW1-R05-Time7-2      F2-JRW1-R05-Time6-1      G2-JRW1-R05-Time5-2 
                   18561                    18739                    19246                    19456 
    G8-JRW2-PC10-Time8-1     H8-JRW2-PC10-Time8-2      B2-JRW1-R05-Time8-1    H11-SI-INLET-Postive3 
                   20927                    22299                    23187                    24811 
    H7-JRW2-PC10-Time4-2     E7-JRW2-PC10-Time3-1      A2-JRW1-R05-Time8-2     A8-JRW2-PC10-Time5-1 
                   25278                    26305                    26351                    26606 
    G7-JRW2-PC10-Time4-1     A7-JRW2-PC10-Time1-1     B7-JRW2-PC10-Time1-2      H6-SI-INLET-Postive 
                   26813                    27737                    27846                    28113 
    C7-JRW2-PC10-Time2-1     F9-SI-INLET-Postive2     F8-JRW2-PC10-Time7-2     D8-JRW2-PC10-Time6-2 
                   28340                    30093                    31438                    32490 
    G3-JRW2-RR04-Time4-1     C8-JRW2-PC10-Time6-1     F7-JRW2-PC10-Time3-2     D7-JRW2-PC10-Time2-2 
                   32834                    35005                    35595                    36410 
    G5-JRW2-LL05-Time4-1 C11-JRW1-04192022-RW08-2  G9-JRW2-06072022-PW01-1     F6-JRW2-LL05-Time8-1 
                   38782                    40927                    42094                    42898 
D11-JRW1-04192022-RW04-2     H5-JRW2-LL05-Time4-2 G10-JRW2-06062022-RW04-4  C9-JRW2-06092022-LW05-1 
                   43794                    43874                    44354                    44468 
    C6-JRW2-LL05-Time6-2 A11-JRW2-06062022-RW04-1     B4-JRW2-RR04-Time5-2     F5-JRW2-LL05-Time3-2 
                   44596                    44600                    44646                    45131 
    G6-JRW2-LL05-Time8-2     C5-JRW2-LL05-Time2-1     E8-JRW2-PC10-Time7-1     H3-JRW2-RR04-Time4-2 
                   45771                    47197                    47350                    48312 
E10-JRW1-04182022-RW08-2     B5-JRW2-LL05-Time1-2 H10-JRW2-06062022-RW04-3  H9-JRW3-08012022-PW03-1 
                   48899                    51167                    52223                    54860 
F11-JRW1-04192022-RW01-1     B3-JRW2-RR04-Time1-2     A3-JRW2-RR04-Time1-1     D6-JRW2-LL05-Time7-1 
                   56163                    58457                    59022                    59485 
F10-JRW2-06062022-RW04-2 B11-JRW1-04192022-IS02-2     A6-JRW2-LL05-Time5-1 B10-JRW3-08012022-LW03-2 
                   60407                    61771                    62410                    62456 
    B6-JRW2-LL05-Time5-2 A10-JRW3-08012022-RW04-1     E5-JRW2-LL05-Time3-1     D3-JRW2-RR04-Time2-2 
                   63943                    64260                    65117                    66109 
    F3-JRW2-RR04-Time3-2     A4-JRW2-RR04-Time5-1     A5-JRW2-LL05-Time1-1     D5-JRW2-LL05-Time2-2 
                   72541                    74847                    80165                    81197 
    C4-JRW2-RR04-Time6-1     C3-JRW2-RR04-Time2-1     F4-JRW2-RR04-Time7-2     E3-JRW2-RR04-Time3-1 
                   81723                    86707                    97163                    99738 
C10-JRW3-08012022-RW01-1     E6-JRW2-LL05-Time7-2 D10-JRW3-08012022-LW05-1 
                  116138                   208431                   274858
```
The aforementioned was just to get you familiarized with R/phyloseq... sorry if any of that was too basic.
Anyhow! Now onto microviz. 
Rather than look at 'all' the JRW at once, you might find it a bit more useful to just look at one time (but you don't have to, just a suggestion).
If, for example, you wanted to re-create some of the ordinations i made that looking the stream channel samples and the wells from our
first sampling trip in April 2022, you first extract all the sample associated with that sampling trip using the following:
```
JRW1 = subset_samples(ps.rare, Date == "JRW1")
```
Now you can try and put this through the validation/tax_fix commands provided in microviz.

```
pseq <- JRW1 %>%
  tax_fix() %>%
  phyloseq_validate()
```
