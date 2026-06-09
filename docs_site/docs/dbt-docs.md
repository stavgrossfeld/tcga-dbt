# dbt Documentation

The full dbt docs site includes the lineage DAG, column-level descriptions, and test results for all staging and mart models.

[**→ Open dbt Docs**](https://stavgrossfeld.github.io/tcga-dbt/dbt-docs/index.html){ .md-button .md-button--primary target="_blank" }

---

## What's inside

- **Lineage graph** — visual DAG from raw sources through staging to marts
- **Model descriptions** — purpose and SQL for each model
- **Column descriptions** — type, description, and tests for every column
- **Test results** — not_null and unique constraint coverage

## Models at a glance

```mermaid
flowchart TD
    A[raw.clinical] --> B[staging.clinical]
    C[raw.maf] --> D[staging.mutations]
    E[raw.rna_expression] --> F[staging.rna_expression]
    B --> G[marts.tmb]
    D --> G
    B --> H[marts.survival]
    G --> H

    style A fill:#e8f0fe,stroke:#4a6cf7
    style C fill:#e8f0fe,stroke:#4a6cf7
    style E fill:#e8f0fe,stroke:#4a6cf7
    style B fill:#fce8ff,stroke:#9b4dca
    style D fill:#fce8ff,stroke:#9b4dca
    style F fill:#fce8ff,stroke:#9b4dca
    style G fill:#e8fff0,stroke:#2e7d32
    style H fill:#e8fff0,stroke:#2e7d32
```
