SELECT 
    e.denominacion AS cliente,
    p.descripcion AS producto,
    SUM(h.cantidad) AS cantidad_total,
    SUM(h.mto_total_linea) AS inversion_cliente
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_entidad e ON h.id_dim_entidad = e.id_dim_entidad
JOIN canaza_datamart.d_producto p ON h.id_dim_producto = p.id_dim_producto
GROUP BY e.denominacion, p.descripcion



SELECT 
    t.nombre_dia AS dia,
    COUNT(h.id_hecho) AS cantidad_ventas,
    SUM(h.mto_total_linea) AS total_soles
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.nombre_dia, t.dia_semana
ORDER BY t.dia_semana ASC;


DESCRIBE canaza_datamart.hventa;

DESCRIBE canaza_datamart.d_tiempo;


SELECT 
    e.denominacion AS cliente,
    COUNT(h.id_hecho) AS total_compras,
    SUM(h.mto_total_linea) AS total_invertido
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_entidad e ON h.id_dim_entidad = e.id_dim_entidad
GROUP BY e.denominacion
ORDER BY total_invertido DESC
LIMIT 10;


SELECT 
    p.desc_categoria AS categoria,
    SUM(h.mto_total_linea) AS ingresos_totales,
    SUM(h.costo_unit * h.cantidad) AS costo_total,
    SUM(h.mto_total_linea - (h.costo_unit * h.cantidad)) AS ganancia_neta,
    ROUND((SUM(h.mto_total_linea - (h.costo_unit * h.cantidad)) / SUM(h.mto_total_linea)) * 100, 2) AS porcentaje_margen
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_producto p ON h.id_dim_producto = p.id_dim_producto
GROUP BY p.desc_categoria
ORDER BY ganancia_neta DESC;

DESCRIBE canaza_datamart.d_producto;


SELECT 
    id_dim_producto AS ID,
    desc_categoria AS categoria,
    descripcion AS nombre_producto,
    precio_venta AS precio,
    costo_compra AS costo,
    cod_unidad_med AS unidad
FROM canaza_datamart.d_producto
WHERE es_vigente = 1
ORDER BY desc_categoria, descripcion;


SELECT COUNT(*) AS total_productos 
FROM canaza_datamart.d_producto;

SELECT COUNT(*) AS total_clientes 
FROM canaza_datamart.d_entidad;


SELECT COUNT(DISTINCT id_dim_entidad) AS clientes_activos 
FROM canaza_datamart.hventa;


SELECT COUNT(*) AS total_clientes 
FROM canaza_datamart.d_entidad;


SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE canaza_datamart.d_tipo_cpe;
SET FOREIGN_KEY_CHECKS = 1;


SELECT 
    SUM(mto_total_linea) AS ingresos_brutos,
    SUM(costo_unit * cantidad) AS inversion_en_stock,
    SUM(mto_total_linea - (costo_unit * cantidad)) AS utilidad_neta,
    ROUND(AVG((mto_total_linea - (costo_unit * cantidad)) / mto_total_linea) * 100, 2) AS porcentaje_margen_promedio
FROM canaza_datamart.hventa;