select
    row_number() over (order by cod_tipo_cpe) as tipo_cpe_key,
    cod_tipo_cpe,
    desc_tipo_cpe
from "canaza_dw"."marts_staging"."stg_tipo_comprobante"