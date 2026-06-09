with source as (
    select * from raw.rna_expression
),

renamed as (
    select
        -- strip version suffix: ENSG00000000003.15 → ENSG00000000003
        split_part(gene_id, '.', 1)         as gene_id,

        sample_barcode,
        substr(sample_barcode, 1, 12)       as patient_id,

        count                               as raw_count

    from source
)

select * from renamed