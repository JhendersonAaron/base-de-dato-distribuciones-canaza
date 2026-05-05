
    
    

select
    entidad_key as unique_field,
    count(*) as n_records

from "canaza_dw"."marts"."dim_entidad"
where entidad_key is not null
group by entidad_key
having count(*) > 1


