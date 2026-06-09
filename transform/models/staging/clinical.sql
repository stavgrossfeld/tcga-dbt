with source as (
    select * from raw.clinical
),

renamed as (
    select
        submitter_id                                    as patient_id,
        ajcc_pathologic_stage                           as stage,
        -- extract roman numeral only: "Stage IIA" → "II"
        regexp_replace(ajcc_pathologic_stage, 'Stage ([IVX]+).*', '\1') as stage_group,

        round(age_at_diagnosis / 365.25, 1)            as age_at_diagnosis_years,
        year_of_diagnosis,

        vital_status = 'Dead'                          as is_deceased,
        coalesce(days_to_death, days_to_last_follow_up) as overall_survival_days,

        gender,
        nullif(race, 'not reported')                   as race,
        nullif(ethnicity, 'not reported')              as ethnicity,

        primary_diagnosis,
        laterality,
        prior_malignancy = 'yes'                       as had_prior_malignancy,
        prior_treatment = 'Yes'                        as had_prior_treatment

    from source
)

select * from renamed