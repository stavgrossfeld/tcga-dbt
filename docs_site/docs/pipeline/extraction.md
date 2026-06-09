# Extraction

The extraction stage downloads TCGA-BRCA data from the NCI GDC and loads it into DuckDB.

## Prerequisites

- R >= 4.3
- renv (`renv::restore()` to install packages)
- GDC client binary in `extraction/`

## Running

```bash
cd extraction
Rscript extract_tcga.R
```

## What it downloads

| Step | Data | Rows |
|---|---|---|
| Clinical | Patient demographics, staging, survival, treatment | ~1,098 |
| MAF | Somatic mutations (masked, open access) | ~90,000 |
| RNA-seq | STAR-Counts gene expression (primary tumor only) | ~600,000 |

## Scaling RNA-seq

RNA-seq is expensive to download. Control the number of patients with `N_PATIENTS` at the top of `extract_tcga.R`:

```r
N_PATIENTS <- 10   # change to scale up, Inf for full cohort
```

## Output

All tables are written to the `raw` schema in `data/tcga_brca.duckdb`.

```sql
SELECT table_schema, table_name 
FROM information_schema.tables 
WHERE table_schema = 'raw';
```
