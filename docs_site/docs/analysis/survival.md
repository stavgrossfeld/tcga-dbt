# Analysis

The full interactive analysis including survival curves, oncoplot, multivariate Cox regression, and data previews is available as a standalone Quarto page.

[**→ Open Analysis**](https://stavgrossfeld.github.io/tcga-dbt/visualization/index.html){ .md-button .md-button--primary target="_blank" }

---

## Summary of Findings

### Stage vs Overall Survival

Kaplan-Meier curves stratified by AJCC pathologic stage show highly significant separation (log-rank **p < 0.0001**).

| Stage | n | Median OS |
|---|---|---|
| I | 182 | Not reached |
| II | 621 | Not reached |
| III | 249 | ~4,000 days |
| IV | 20 | ~1,500 days |

Stage IV patients have **10.3x higher mortality risk** vs Stage I in multivariate Cox regression.

### TMB vs Overall Survival

Tumor mutation burden does not significantly stratify survival in univariate analysis (log-rank **p = 0.46**), consistent with breast cancer's immunologically cold phenotype.

However, TMB shows a modest independent effect in multivariate Cox regression (HR = 1.035, p = 0.013) after adjusting for stage and age.

### Multivariate Cox Regression

| Variable | HR | 95% CI | p |
|---|---|---|---|
| Stage III | 3.72 | 2.01 – 6.88 | < 0.0001 |
| Stage IV | 10.25 | 4.86 – 21.6 | < 0.0001 |
| Age (per year) | 1.04 | 1.02 – 1.05 | < 0.0001 |
| TMB (per unit) | 1.04 | 1.01 – 1.06 | 0.013 |

### Gene Mutation Effects

No individual driver gene mutation reaches significance after adjusting for stage and age — consistent with these genes being subtype markers rather than independent prognostic factors.
