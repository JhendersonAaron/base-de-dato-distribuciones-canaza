SET FOREIGN_KEY_CHECKS = 0;

-- Ahora intenta ejecutar de nuevo el script que te dio error (el 05 o 06)
-- Y al finalizar todos, vuelve a encender la protección:
-- SET FOREIGN_KEY_CHECKS = 1;


-- Esto consulta tu nuevo DataMart (la base de reportes)
USE canaza_datamart;

SELECT 
    (SELECT COUNT(*) FROM d_cliente) AS total_clientes,
    (SELECT COUNT(*) FROM d_producto) AS total_productos,
    (SELECT SUM(monto_total) FROM hventa) AS venta_total_soles;
    
    SHOW TABLES FROM canaza_datamart;
    
    SELECT COUNT(*) FROM canaza_oltp.cliente;
    
    
    USE canaza_datamart;

SELECT 
    (SELECT COUNT(*) FROM d_entidad) AS total_clientes_entidades,
    (SELECT COUNT(*) FROM d_producto) AS total_productos,
    (SELECT SUM(monto_total) FROM hventa) AS venta_total_soles;
    
    
    SELECT t.mes_nombre, SUM(h.monto_total) as venta_mensual
FROM hventa h
JOIN d_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.mes_nombre;


DESCRIBE canaza_datamart.d_tiempo;


SELECT 
    t.anio, 
    t.nombre_mes, 
    SUM(h.monto_total) AS venta_total_mensual
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes, t.nombre_mes
ORDER BY t.anio, t.mes;



DESCRIBE canaza_datamart.hventa;


SELECT 
    t.anio, 
    t.nombre_mes, 
    SUM(h.mto_total_linea) AS venta_total_mensual
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes, t.nombre_mes
ORDER BY t.anio, t.mes;


DESCRIBE canaza_datamart.d_entidad;

SELECT 
    e.denominacion AS cliente, 
    SUM(h.mto_total_linea) AS total_comprado
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_entidad e ON h.id_dim_entidad = e.id_dim_entidad
GROUP BY e.denominacion
ORDER BY total_comprado DESC
LIMIT 10;



SET FOREIGN_KEY_CHECKS = 1;


SELECT 
    t.anio, 
    t.nombre_mes, 
    SUM(h.mto_total_linea) AS venta_total_mensual
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes, t.nombre_mes
ORDER BY t.anio, t.mes;



SELECT 
    p.descripcion AS producto, 
    p.desc_categoria AS categoria,
    SUM(h.cantidad) AS unidades_vendidas,
    SUM(h.mto_total_linea) AS total_dinero
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_producto p ON h.id_dim_producto = p.id_dim_producto
GROUP BY p.descripcion, p.desc_categoria
ORDER BY total_dinero DESC
LIMIT 15;

DESCRIBE canaza_datamart.d_producto;



SELECT 
    p.descripcion AS producto, 
    p.desc_categoria AS categoria,
    SUM(h.margen_bruto) AS ganancia_total,
    ROUND((SUM(h.margen_bruto) / SUM(h.mto_total_linea)) * 100, 2) AS porcentaje_margen
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_producto p ON h.id_dim_producto = p.id_dim_producto
GROUP BY p.descripcion, p.desc_categoria
ORDER BY ganancia_total DESC
LIMIT 10;



SELECT 
    t.nombre_dia, 
    SUM(h.mto_total_linea) AS venta_total
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.dia_semana, t.nombre_dia
ORDER BY t.dia_semana;



SELECT 
    t.anio, 
    t.nombre_mes, 
    SUM(h.mto_total_linea) AS venta_mes_actual,
    LAG(SUM(h.mto_total_linea)) OVER (ORDER BY t.anio, t.mes) AS venta_mes_anterior,
    ROUND(((SUM(h.mto_total_linea) - LAG(SUM(h.mto_total_linea)) OVER (ORDER BY t.anio, t.mes)) / LAG(SUM(h.mto_total_linea)) OVER (ORDER BY t.anio, t.mes)) * 100, 2) AS crecimiento_porcentual
FROM canaza_datamart.hventa h
JOIN canaza_datamart.d_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY t.anio, t.mes, t.nombre_mes;