select
    id_comprobante,
    fecha_emision,
    cod_tipo_cpe,
    serie,
    numero,
    id_entidad,
    mto_gravada,
    mto_igv,
    mto_descuento,
    mto_total,
    anulado
from raw.comprobante
where anulado = false