# Transform

The transform stage builds staging and mart models on top of the raw DuckDB tables using dbt.

## Prerequisites

- Python 3.12
- uv

```bash
cd transform
uv sync
```

## Running

```bash
# all models
uv run dbt run --profiles-dir .

# staging only
uv run dbt run --profiles-dir . --select staging

# marts only
uv run dbt run --profiles-dir . --select marts
```

## Models

### Staging

One model per raw table. Cleans, renames, and casts — no joins.

| Model | Source | Key transforms |
|---|---|---|
| `staging.clinical` | `raw.clinical` | Age in years, stage group extraction, null normalization |
| `staging.mutations` | `raw.maf` | Column selection, VAF computation, impact ranking, patient ID extraction |
| `staging.rna_expression` | `raw.rna_expression` | Ensembl version stripping, patient ID extraction |

### Marts

Joined, analysis-ready tables.

| Model | Description |
|---|---|
| `marts.tmb` | Tumor mutation burden per patient (coding mutations / 38 Mb) |
| `marts.survival` | Clinical + TMB joined, one row per patient, ready for survival analysis |

## Database path

Configured in `profiles.yml`. Defaults to `../data/tcga_brca.duckdb`. Override with env var:

```bash
TCGA_DB_PATH=/path/to/tcga_brca.duckdb uv run dbt run --profiles-dir .
```

## Docs

```bash
uv run dbt docs generate --profiles-dir .
uv run dbt docs serve
```
