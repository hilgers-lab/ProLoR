<!-- badges: start -->

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/hilgers-lab/LATER)
[![Maintained?](https://img.shields.io/badge/Maintained%3F-Yes-brightgreen)](https://github.com/hilgers-lab/LATER/graphs/contributors)
[![Install](https://img.shields.io/badge/Install-Github-brightgreen)](#installation)
[![Downloads](https://img.shields.io/github/downloads/hilgers-lab/LATER/total)]()
![GitHub](https://img.shields.io/github/license/hilgers-lab/LATER)
[![DOI](https://zenodo.org/badge/463514279.svg)](https://zenodo.org/badge/latestdoi/463514279)

<!-- badges: end -->

# LATER
## Long-read Analysis of transcription Termination Estimation and Recognition
-------


## Installation 

```
install.packages("devtools")
devtools::install_github("hilgers-lab/LATER", build = TRUE, build_vignettes = TRUE)
```

The vignette contains some examples and interpretation of the results of the analysis 
```
library(LATER)
vignette("LATER")
```

## Usage

LATER estimates transcriptional biases in APA using long read sequencing data 

# Input data: 
  * Genome Alignment bam files [minimap2](https://github.com/lh3/minimap2) using parameters `minimap2 -ax splice -u f annotation/genome.fa long_read.fastq.gz | samtools sort -@ 4 -o output.bam - samtools index output.bam`
  * Reference annotation in gtf format. Example file [here](https://github.com/hilgers-lab/LATER/blob/master/inst/exdata/dm6.annot.gtf.gz) 

### Database creation 

First, a database of 5'-3' isoforms is created based on the reference annotation provided. Combinations are computed based on isoform sets TSS and PA sites are merged in a window. This outputs a dataframe with the classification of genes by their TSS and PA site status 


```
ref_path <- system.file("exdata/dmel_reference_annotation.gtf.gz", 
                        package = 'LATER')
reference_annotation <- rtracklayer::import.gff(ref_path)
protein_coding_exons <- reference_annotation[reference_annotation$type == "exon" & reference_annotation$gene_biotype == "protein_coding"]
protein_coding_genes <- reference_annotation[reference_annotation$type == "gene" & reference_annotation$gene_biotype == "protein_coding"]
# Prepare isoformData object 
isoformData <- prepareIsoformDatabase(protein_coding_exons, 
                                        tss.window = 50, 
                                        tes.window = 150)
```

### Counting links 

To account for accurate quantification we develop a counter for long read sequencing data. Aligned reads to the genome are trimmed to their most 5' and 3' end keeping the read identity only reads mapping to both TSS and PA site in the reference, are considered for the analisys. Reads are then summarized in counts per million for further processing. 

```
bamPath <- system.file("exdata/testBam.bam", package = 'LATER')
countData <- countLinks(bamPath, isoformData)
```


### Estimating promoter dominance and Transcriptional biases 

Promoter dominance estimates are calculated as perfomed in (Alfonso-Gonzalez, et al., 2022). This function outputs per promoter biases in expression of a given 3'end of the gene. 
Transcriptional biases are calculated by estimating using the joint frequencies of TSS-PA site combinations per gene. Coupling events per gene are estimated using multinomial testing using chi-square. Statistical testing is also available with `fisher.test()` using method="fisher".  

```
gene_bias_estimates <- estimatePromoterDominance(countData, isoformData, method="fisher")
```
# Release 

Release 0.1.2.1

Release date: 9th Dec 2024

## Contact

Developer Carlos Alfonso-Gonzalez. For questions or feedback you can contact:
alfonso@ie-freiburg.mpg.de





