select
    id_detalle,
    count(*) as repeticiones
from {{ ref('fact_ventas') }}
group by id_detalle
having count(*) > 1