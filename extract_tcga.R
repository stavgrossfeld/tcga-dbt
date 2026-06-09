library(TCGAbiolinks)
library(duckdb)
library(DBI)
library(dplyr)
library(tibble)
library(SummarizedExperiment)


DB_PATH    <- here::here("dbt_project", "tcga_brca.duckdb")
N_PATIENTS <- 10   # change this to scale up

con <- dbConnect(duckdb(), dbdir = DB_PATH, read_only = FALSE)
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS raw")

# ── Helpers ───────────────────────────────────────────────────────────────────
write_raw <- function(con, table_name, df) {
  dbWriteTable(con, Id(schema = "raw", table = table_name),
               as.data.frame(df), overwrite = TRUE)
  n <- dbGetQuery(con,
    sprintf("SELECT COUNT(*) AS n FROM raw.%s", table_name))$n
  message(sprintf("  raw.%-20s %s rows", table_name, format(n, big.mark = ",")))
}

safe_download <- function(query, label) {
  tryCatch(
    GDCdownload(query, method = "client"),
    error = \(e) stop(label, " download failed: ", conditionMessage(e))
  )
}

# ── 1. Clinical ───────────────────────────────────────────────────────────────
message("\n--- [1/3] Clinical ---")
clin_raw <- GDCquery_clinic(project = "TCGA-BRCA", type = "clinical")
clin_clean <- clin_raw %>%
  mutate(across(where(is.list),
                ~ sapply(., \(x) paste(unique(x), collapse = ", "))))
write_raw(con, "clinical", clin_clean)

# ── 2. MAF / Somatic mutations ────────────────────────────────────────────────
message("\n--- [2/3] MAF ---")
query_maf <- GDCquery(
  project       = "TCGA-BRCA",
  data.category = "Simple Nucleotide Variation",
  access        = "open",
  data.type     = "Masked Somatic Mutation",
  workflow.type = "Aliquot Ensemble Somatic Variant Merging and Masking"
)
safe_download(query_maf, "MAF")
maf_data <- GDCprepare(query_maf)
write_raw(con, "maf", maf_data)

# ── 3. RNA-seq (pilot N patients, primary tumor only) ─────────────────────────
message(sprintf("\n--- [3/3] RNA-seq (%d patients) ---", N_PATIENTS))

pilot_ids <- dbGetQuery(
  con,
  sprintf("SELECT submitter_id FROM raw.clinical LIMIT %d", N_PATIENTS)
)$submitter_id

# First query to get the manifest, then filter to primary tumor only
query_rna <- GDCquery(
  project       = "TCGA-BRCA",
  data.category = "Transcriptome Profiling",
  data.type     = "Gene Expression Quantification",
  workflow.type = "STAR - Counts",
  barcode       = pilot_ids
)

manifest <- getResults(query_rna)
message(sprintf("  Manifest returned %d files across %d sample types",
                nrow(manifest), length(unique(manifest$sample_type))))
print(table(manifest$sample_type))

# Keep one primary tumour per patient
manifest_pt <- manifest %>%
  filter(grepl("-01[A-Z]-", cases)) %>%
  group_by(patient = substr(cases, 1, 12)) %>%
  dplyr::slice(1) %>%
  ungroup()

message(sprintf("  After filtering: %d primary-tumor samples", nrow(manifest_pt)))

query_rna_exact <- GDCquery(
  project       = "TCGA-BRCA",
  data.category = "Transcriptome Profiling",
  data.type     = "Gene Expression Quantification",
  workflow.type = "STAR - Counts",
  barcode       = manifest_pt$cases
)

safe_download(query_rna_exact, "RNA")
rna_se <- GDCprepare(query_rna_exact)

counts_matrix <- assay(rna_se, "unstranded")

rna_df <- counts_matrix %>%
  as.data.frame() %>%
  rownames_to_column("gene_id") %>%
  tidyr::pivot_longer(
    cols      = -gene_id,
    names_to  = "sample_barcode",
    values_to = "count"
  )

write_raw(con, "rna_expression", rna_df)

# ── Done ──────────────────────────────────────────────────────────────────────
message("\n--- All raw tables loaded ---")
dbDisconnect(con, shutdown = TRUE)










con <- dbConnect(duckdb(), dbdir = DB_PATH, read_only = TRUE)

# browse tables
dbListTables(con)

# quick looks
dbGetQuery(con, "SELECT * FROM raw.clinical LIMIT 5")
dbGetQuery(con, "SELECT * FROM raw.maf LIMIT 5")
dbGetQuery(con, "SELECT * FROM raw.rna_expression LIMIT 5")

# row counts
dbGetQuery(con, "SELECT 
  (SELECT COUNT(*) FROM raw.clinical)      AS clinical_rows,
  (SELECT COUNT(*) FROM raw.maf)           AS maf_rows,
  (SELECT COUNT(*) FROM raw.rna_expression) AS rna_rows
")

dbDisconnect(con, shutdown = TRUE)