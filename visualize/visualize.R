library(duckdb)
library(DBI)
library(dplyr)
library(tibble)
DB_PATH = './data/tcga_brca.duckdb'
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
