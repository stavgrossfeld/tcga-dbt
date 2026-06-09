with source as (
    select * from staging.mutations
),

coding_mutation_ct as (
    select
        patient_id,
        count(*) filter (
            where variant_classification not in (
                'Silent', 'Intron', '3''UTR', '5''UTR',
                'RNA', 'IGR', '3''Flank', '5''Flank'
            )
            and is_pass
        ) as coding_mutation_count

    from source
    group by patient_id
)

select
    patient_id,
    coding_mutation_count,
    round(coding_mutation_count / 38.0, 2) as tmb
from coding_mutation_ct