# extraction

R project that downloads TCGA-BRCA data from the NCI GDC and loads it into DuckDB.

## Prerequisites

- R >= 4.3
- [renv](https://rstudio.github.io/renv/) for package management
- The GDC client binary (`gdc-client`) in this directory — download from https://gdc.cancer.gov/access-data/gdc-data-transfer-tool

Restore R packages:

```r
renv::restore()
```

## Running

```bash
Rscript extract_tcga.R
```

Writes to `../data/tcga_brca.duckdb`, creating it if it doesn't exist.

## What it downloads

| Step | Data | Notes |
|---|---|---|
| 1 | Clinical records | All 1,098 TCGA-BRCA patients |
| 2 | Somatic mutations (MAF) | Full cohort, open-access masked calls |
| 3 | RNA-seq counts | Primary tumor samples only, limited to `N_PATIENTS` |

## Scaling RNA-seq

RNA-seq is expensive to download. The script defaults to 10 patients:

```r
N_PATIENTS <- 10   # change this to scale up
```

Increase this value before running to include more patients. Full cohort is ~1,100.

## Output schema

All tables are written to the `raw` schema in DuckDB:

| Table | Rows (default) | Description |
|---|---|---|
| `raw.clinical` | ~1,098 | Patient demographics, diagnosis, staging, survival, treatment |
| `raw.maf` | ~90,000 | Somatic mutations with variant classification, allele counts, VEP annotations |
| `raw.rna_expression` | ~606,000 | Long-format gene counts: one row per gene per sample |
