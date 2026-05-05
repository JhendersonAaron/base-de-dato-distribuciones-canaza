select distinct
    dense_rank() over (order by cod_tipo_cpe)    as tipo_cpe_key,
    cod_tipo_cpe,
    desc_tipo_cpe
from {{ ref('stg_tipo_comprobante') }}