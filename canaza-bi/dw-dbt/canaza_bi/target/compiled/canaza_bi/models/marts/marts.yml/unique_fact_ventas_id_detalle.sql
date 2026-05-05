
    
    

select
    id_detalle as unique_field,
    count(*) as n_records

from "canaza_dw"."marts"."fact_ventas"
where id_detalle is not null
group by id_detalle
having count(*) > 1


