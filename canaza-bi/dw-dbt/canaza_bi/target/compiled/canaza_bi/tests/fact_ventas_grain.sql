select
    id_detalle,
    count(*) as repeticiones
from "canaza_dw"."marts"."fact_ventas"
group by id_detalle
having count(*) > 1