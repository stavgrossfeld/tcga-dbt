# Pipeline Overview

The pipeline has three independent stages connected by a shared DuckDB file.

## Architecture

```mermaid
flowchart LR
    subgraph extraction["extraction/  (R + renv)"]
        A[TCGAbiolinks\nGDC API]
    end

    subgraph db["data/tcga_brca.duckdb"]
        direction TB
        R[raw schema]
        S[staging schema]
        M[marts schema]
        R --> S --> M
    end

    subgraph transform["transform/  (dbt + uv)"]
        B[staging models\nmart models]
    end

    subgraph visualize["visualize/  (R + Quarto)"]
        C[ggplot2\nsurvival\nmaftools]
    end

    A -->|writes| R
    B -->|reads raw\nwrites staging/marts| db
    C -->|reads staging\n& marts| M

    style extraction fill:#e8f0fe,stroke:#4a6cf7
    style db fill:#fff8e1,stroke:#f9a825
    style transform fill:#fce8ff,stroke:#9b4dca
    style visualize fill:#e8fff0,stroke:#2e7d32
```

## Contract

The only dependency between stages is the DuckDB file at `data/tcga_brca.duckdb`. It must contain:

| Table | Written by | Read by |
|---|---|---|
| `raw.clinical` | extraction | dbt, R |
| `raw.maf` | extraction | dbt, R |
| `raw.rna_expression` | extraction | dbt, R |
| `staging.*` | dbt | R |
| `marts.*` | dbt | R |

## Running the full pipeline

```bash
# Step 1 — extract
cd extraction
Rscript extract_tcga.R

# Step 2 — transform
cd transform
uv run dbt run --profiles-dir .

# Step 3 — analyze
quarto render visualize/visualize.qmd
```

Or use the Makefile:

```bash
make all
```
