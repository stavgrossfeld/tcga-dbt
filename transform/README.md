# transform

dbt project that builds staging and mart models on top of the raw TCGA-BRCA tables in DuckDB.

## Prerequisites

- Python 3.12 (3.14 is not yet supported by dbt)
- [uv](https://docs.astral.sh/uv/)

Install dependencies:

```bash
uv sync
```

## Running

```bash
# run all models
uv run dbt run --profiles-dir .

# run only staging models
uv run dbt run --profiles-dir . --select staging

# test
uv run dbt test --profiles-dir .

# generate and serve docs
uv run dbt docs generate --profiles-dir .
uv run dbt docs serve
```

## Database path

The profile at `profiles.yml` defaults to `../data/tcga_brca.duckdb`. Override with the `TCGA_DB_PATH` environment variable if your data lives elsewhere:

```bash
TCGA_DB_PATH=/path/to/tcga_brca.duckdb uv run dbt run --profiles-dir .
```

## Project layout

```
transform/
├── dbt_project.yml
├── profiles.yml
├── models/
│   ├── staging/       # one model per raw table — rename, cast, clean
│   └── marts/         # joined, analysis-ready tables
└── tests/             # custom SQL tests
```

## Models

### Staging

| Model | Source | Key transformations |
|---|---|---|
| `stg_clinical` | `raw.clinical` | Rename columns, derive age in years, normalize nulls, extract stage group |
| `stg_mutations` | `raw.maf` | Select relevant columns, extract patient ID from barcode, compute VAF, rank impact |
| `stg_rna_expression` | `raw.rna_expression` | Strip Ensembl version suffix, extract patient ID from barcode |

### Marts

_Not yet built._
