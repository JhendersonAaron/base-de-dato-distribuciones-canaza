
    
    

select
    cod_tipo_cpe as unique_field,
    count(*) as n_records

from "canaza_dw"."marts"."dim_tipo_cpe"
where cod_tipo_cpe is not null
group by cod_tipo_cpe
having count(*) > 1


