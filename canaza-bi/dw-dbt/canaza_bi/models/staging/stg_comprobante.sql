select
    id_comprobante,
    fecha_emision,
    fecha_vcto,
    cod_tipo_cpe,
    serie,
    numero,
    id_entidad,
    ruc_dni,
    moneda,
    mto_gravada,
    mto_igv,
    mto_descuento,
    mto_total,
    pagado,
    forma_pago,
    anulado
from raw.comprobante
where anulado = false