
    
    

select
    fecha as unique_field,
    count(*) as n_records

from "canaza_dw"."marts"."dim_fecha"
where fecha is not null
group by fecha
having count(*) > 1


