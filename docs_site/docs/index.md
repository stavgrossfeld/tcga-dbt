# TCGA-BRCA Pipeline

An end-to-end analytical pipeline for breast cancer genomic data. Raw clinical, somatic mutation, and RNA-seq data are downloaded from the NCI GDC, transformed with dbt, and analyzed in R.

## Quick Links

<div class="grid cards" markdown>

-   :material-chart-line: **[Analysis](https://stavgrossfeld.github.io/tcga-dbt/visualization/index.html)**

    Survival curves, oncoplot, multivariate Cox regression

-   :material-database: **[dbt Docs](https://stavgrossfeld.github.io/tcga-dbt/dbt-docs/index.html)**

    Interactive data catalog and lineage DAG

-   :material-github: **[GitHub](https://github.com/stavgrossfeld/tcga-dbt)**

    Source code

</div>

## Pipeline Overview

```
NCI GDC API
    ↓  TCGAbiolinks / R
DuckDB  →  raw.clinical  ·  raw.maf  ·  raw.rna_expression
    ↓  dbt
       staging.clinical  ·  staging.mutations  ·  staging.rna_expression
    ↓
       marts.tmb  ·  marts.survival
    ↓  R / Quarto
Survival analysis  ·  Mutation landscape  ·  Cox regression
```

## Key Findings

| Finding | Result |
|---|---|
| Stage vs survival | Log-rank p < 0.0001, Stage IV HR = 10.3x |
| Top mutated genes | TP53 34%, PIK3CA 34%, CDH1 13% |
| TMB univariate | Not significant (p = 0.46) |
| TMB multivariate | Independent predictor (HR = 1.035, p = 0.013) |

## Stack

| Layer | Tool |
|---|---|
| Extraction | R, TCGAbiolinks, GDC Transfer Tool |
| Storage | DuckDB |
| Transformation | dbt-duckdb |
| Analysis | R, survival, maftools, ggplot2 |
| Publishing | Quarto, MkDocs Material, GitHub Pages |
