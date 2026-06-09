# Data Dictionary

## Staging Models

### `staging.clinical`

Cleaned clinical records for all 1,098 TCGA-BRCA patients.

| Column | Type | Description |
|---|---|---|
| `patient_id` | VARCHAR | TCGA patient barcode (e.g. TCGA-A7-A0DC) |
| `stage` | VARCHAR | Raw AJCC pathologic stage string (e.g. Stage IIA) |
| `stage_group` | VARCHAR | Extracted stage roman numeral (I, II, III, IV) |
| `age_at_diagnosis_years` | DOUBLE | Age at diagnosis in years (days / 365.25) |
| `year_of_diagnosis` | INTEGER | Calendar year of diagnosis |
| `is_deceased` | BOOLEAN | True if patient died during follow-up |
| `overall_survival_days` | INTEGER | Days to death or last follow-up |
| `gender` | VARCHAR | Patient gender |
| `race` | VARCHAR | Patient race (NULL where 'not reported') |
| `ethnicity` | VARCHAR | Patient ethnicity (NULL where 'not reported') |
| `primary_diagnosis` | VARCHAR | Histology description |
| `laterality` | VARCHAR | Tumor laterality (Left/Right) |
| `had_prior_malignancy` | BOOLEAN | True if prior malignancy |
| `had_prior_treatment` | BOOLEAN | True if prior treatment |

### `staging.mutations`

Somatic mutations from TCGA-BRCA MAF files. 140 raw columns reduced to analytically relevant subset.

| Column | Type | Description |
|---|---|---|
| `patient_id` | VARCHAR | TCGA patient barcode (first 12 chars of sample barcode) |
| `sample_barcode` | VARCHAR | Full tumor sample barcode |
| `gene_symbol` | VARCHAR | HGNC gene symbol (e.g. TP53, PIK3CA) |
| `chromosome` | VARCHAR | Chromosome |
| `start_pos` | INTEGER | Genomic start position (GRCh38) |
| `end_pos` | INTEGER | Genomic end position (GRCh38) |
| `variant_classification` | VARCHAR | Mutation consequence (e.g. Missense_Mutation) |
| `variant_type` | VARCHAR | SNP, INS, or DEL |
| `ref_allele` | VARCHAR | Reference allele |
| `alt_allele` | VARCHAR | Alternate allele |
| `tumor_depth` | INTEGER | Total read depth in tumor |
| `tumor_alt_count` | INTEGER | Alternate allele read count |
| `vaf` | DOUBLE | Variant allele frequency (alt / depth) |
| `impact` | VARCHAR | VEP impact: HIGH, MODERATE, LOW, MODIFIER |
| `impact_rank` | INTEGER | Numeric rank: HIGH=3, MODERATE=2, LOW=1, MODIFIER=0 |
| `is_pass` | BOOLEAN | True if variant passed all GDC filters |

### `staging.rna_expression`

Long-format STAR-Counts RNA-seq data. One row per gene per sample.

| Column | Type | Description |
|---|---|---|
| `gene_id` | VARCHAR | Ensembl gene ID, version stripped (e.g. ENSG00000000003) |
| `sample_barcode` | VARCHAR | Full sample barcode |
| `patient_id` | VARCHAR | TCGA patient barcode |
| `raw_count` | INTEGER | Unstranded read count |

---

## Mart Models

### `marts.tmb`

Tumor mutation burden per patient.

| Column | Type | Description |
|---|---|---|
| `patient_id` | VARCHAR | TCGA patient barcode |
| `coding_mutation_count` | INTEGER | Coding mutations passing all filters |
| `tmb` | DOUBLE | TMB in mut/Mb (coding_mutation_count / 38.0) |

### `marts.survival`

Patient-level survival table joining clinical and TMB. Primary mart for analysis.

| Column | Type | Description |
|---|---|---|
| `patient_id` | VARCHAR | TCGA patient barcode |
| `overall_survival_days` | INTEGER | Days to death or last follow-up |
| `vital_status` | INTEGER | Event indicator: 1=deceased, 0=censored |
| `stage_group` | VARCHAR | AJCC stage (I, II, III, IV) |
| `age_at_diagnosis_years` | DOUBLE | Age at diagnosis in years |
| `primary_diagnosis` | VARCHAR | Histology |
| `had_prior_treatment` | BOOLEAN | Prior treatment flag |
| `coding_mutation_count` | INTEGER | From marts.tmb |
| `tmb` | DOUBLE | Tumor mutation burden (mut/Mb) |
| `tmb_group` | VARCHAR | TMB category: low/medium/high |
