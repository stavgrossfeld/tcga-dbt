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

```mermaid
flowchart TD
    GDC[NCI GDC API] -->|TCGAbiolinks / R| RAW

    subgraph RAW["DuckDB — raw schema"]
        R1[raw.clinical]
        R2[raw.maf]
        R3[raw.rna_expression]
    end

    subgraph STG["DuckDB — staging schema  (dbt)"]
        S1[staging.clinical]
        S2[staging.mutations]
        S3[staging.rna_expression]
    end

    subgraph MRT["DuckDB — marts schema  (dbt)"]
        M1[marts.tmb]
        M2[marts.survival]
    end

    VIZ[R / Quarto\nSurvival · Mutations · Cox]

    R1 --> S1
    R2 --> S2
    R3 --> S3
    S1 --> M1
    S2 --> M1
    S1 --> M2
    M1 --> M2
    M2 --> VIZ

    style GDC fill:#e8f0fe,stroke:#4a6cf7
    style RAW fill:#fff8e1,stroke:#f9a825
    style STG fill:#fce8ff,stroke:#9b4dca
    style MRT fill:#e8fff0,stroke:#2e7d32
    style VIZ fill:#fde8e8,stroke:#c62828
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
