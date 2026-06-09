with clinical as (
    select * from staging.clinical
),

tmb as (
    select * from marts.tmb
)

select
    c.patient_id,
    c.overall_survival_days,
    c.is_deceased::int           as vital_status,
    c.stage_group,
    c.age_at_diagnosis_years,
    c.primary_diagnosis,
    c.had_prior_treatment,
    t.coding_mutation_count,
    t.tmb,
    case
    when t.tmb <= 5  then 'low'
    when t.tmb <= 20 then 'medium'
    when t.tmb > 20  then 'high'
    end as tmb_group

from clinical c
left join tmb t using (patient_id)
where c.overall_survival_days is not null