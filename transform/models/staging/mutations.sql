with source as (
    select * from raw.maf
),

renamed as (
    select
        -- barcode surgery
        Tumor_Sample_Barcode                            as sample_barcode,
        substr(Tumor_Sample_Barcode, 1, 12)             as patient_id,

        Hugo_Symbol                                     as gene_symbol,
        Entrez_Gene_Id                                  as entrez_gene_id,
        Chromosome                                      as chromosome,
        Start_Position                                  as start_pos,
        End_Position                                    as end_pos,

        Variant_Classification                          as variant_classification,
        Variant_Type                                    as variant_type,
        Reference_Allele                                as ref_allele,
        Tumor_Seq_Allele2                               as alt_allele,

        t_depth                                         as tumor_depth,
        t_alt_count                                     as tumor_alt_count,
        round(t_alt_count::double / nullif(t_depth, 0), 4) as vaf,

        IMPACT                                          as impact,
        case IMPACT
            when 'HIGH'     then 3
            when 'MODERATE' then 2
            when 'LOW'      then 1
            else                 0
        end                                             as impact_rank,

        GDC_FILTER                                      as gdc_filter,
        GDC_FILTER is null                              as is_pass

    from source
)

select * from renamed