/* 
Spotify Podcasts --- Proyecto integrador ---- Grupo: JR3 Data Studio --- Unicorn Academy 
MySQL verion 9.2.0
Este script presenta un  forma de comprobar los datos obtenidos con Python y Power Bi son los mismos y como ejercicio para no desaprovechar lo aprendido.
Si necesitas 
*/ 
SELECT VERSION();

SHOW VARIABLES LIKE 'secure_file_priv';


-- 1) CREACIÓN DE LA BASE DE DATOS Y TABLA

DROP DATABASE IF EXISTS spotify_podcasts;
CREATE DATABASE spotify_podcasts
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE spotify_podcasts;

DROP TABLE IF EXISTS podcasts_limpio;

CREATE TABLE podcasts_limpio (
  id                     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  pais                   VARCHAR(10),
  idioma_show            VARCHAR(10),
  categoria              VARCHAR(200),
  podcast_id             VARCHAR(128),
  nombre_podcast         VARCHAR(512),
  editorial              VARCHAR(512),
  total_episodios        INT,
  episodios_descargados  INT,
  proporcion_episodios   DECIMAL(10,6),
  episodio_id            VARCHAR(128),
  nombre_episodio        VARCHAR(1000),
  fecha_lanzamiento      DATE,
  `año`                  SMALLINT,
  `mes`                  TINYINT,
  duracion_min           INT,
  categoria_duracion     VARCHAR(50),
  periodo_pandemia       VARCHAR(30),
  PRIMARY KEY (id),
  KEY idx_podcast_id (podcast_id),
  KEY idx_episodio_id (episodio_id),
  KEY idx_pais (pais),
  KEY idx_idioma (idioma_show),
  KEY idx_fecha (fecha_lanzamiento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 2) CARGA DEL CSV (SIN LOCAL, DESDE secure_file_priv)
--    el archivo está en: C:\ProgramData\MySQL\MySQL Server 9.2\Uploads\spotify_podcasts_limpio_2019_2024.csv

TRUNCATE TABLE podcasts_limpio;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 9.2\\Uploads\\spotify_podcasts_limpio_2019_2024.csv'
INTO TABLE podcasts_limpio
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES

(@pais,@idioma_show,@categoria,@podcast_id,@nombre_podcast,@editorial,
 @total_episodios,@episodios_descargados,@proporcion_episodios,
 @episodio_id,@nombre_episodio,@fecha_lanzamiento,
 @anio,@mes,@duracion_min,@categoria_duracion,@periodo_pandemia)
SET
  pais                   = NULLIF(@pais,''),
  idioma_show            = NULLIF(@idioma_show,''),
  categoria              = NULLIF(@categoria,''),
  podcast_id             = NULLIF(@podcast_id,''),
  nombre_podcast         = NULLIF(@nombre_podcast,''),
  editorial              = NULLIF(@editorial,''),
  total_episodios        = NULLIF(@total_episodios,''),
  episodios_descargados  = NULLIF(@episodios_descargados,''),
  proporcion_episodios   = NULLIF(@proporcion_episodios,''),
  episodio_id            = NULLIF(@episodio_id,''),
  nombre_episodio        = NULLIF(@nombre_episodio,''),
  fecha_lanzamiento      = CASE
                             WHEN @fecha_lanzamiento IN ('','0000-00-00') THEN NULL
                             ELSE STR_TO_DATE(@fecha_lanzamiento,'%Y-%m-%d')
                           END,
  `año`                  = NULLIF(@anio,''),
  `mes`                  = NULLIF(@mes,''),
  duracion_min           = NULLIF(@duracion_min,''),
  categoria_duracion     = NULLIF(@categoria_duracion,''),
  periodo_pandemia       = NULLIF(@periodo_pandemia,'');

-- (Opcional) Ver advertencias de la carga
SELECT @@warning_count AS warnings;
SHOW WARNINGS LIMIT 50;


-- 3) VERIFICACIONES CLAVE
-- Totales esperados: 54 212 episodios, 118 podcasts, 6 países (AR,BR,ES,GB,PT,US), 3 idiomas (EN,ES,PT)

-- Resumen o vision general
SELECT COUNT(*)                                   AS total_episodios,
       COUNT(DISTINCT podcast_id)                 AS podcasts_distintos,
       COUNT(DISTINCT pais)                       AS num_paises,
       GROUP_CONCAT(DISTINCT pais ORDER BY pais)  AS lista_paises,
       COUNT(DISTINCT idioma_show)                AS num_idiomas,
       GROUP_CONCAT(DISTINCT idioma_show ORDER BY idioma_show) AS lista_idiomas
FROM podcasts_limpio;

-- Número de categorías distintas
SELECT COUNT(DISTINCT categoria) AS num_categorias
FROM podcasts_limpio;

-- Número total de columnas
SELECT COUNT(*) AS total_columnas
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'spotify_podcasts'
  AND table_name   = 'podcasts_limpio';

-- Vista rápida de 10 primeras filas (para inspección visual)
SELECT *
FROM podcasts_limpio
LIMIT 10;

-- Diagnóstico de valores de 'pais' (por si hay espacios/minúsculas)
SELECT CONCAT('[', COALESCE(pais,'NULL'), ']') AS pais_valor,
       LENGTH(pais) AS len,
       HEX(pais)    AS hex,
       COUNT(*)     AS n
FROM podcasts_limpio
GROUP BY pais_valor, len, hex
ORDER BY n DESC;



-- OTRAS CONSULTAS RÁPIDAS ----

SELECT 
    COUNT(*) AS total_episodios,
    COUNT(DISTINCT podcast_id) AS total_podcasts,
    COUNT(DISTINCT categoria) AS total_categorias,
    COUNT(DISTINCT pais) AS total_paises,
    COUNT(DISTINCT idioma_show) AS total_idiomas,
    MIN(fecha_lanzamiento) AS fecha_minima,
    MAX(fecha_lanzamiento) AS fecha_maxima,
    MIN(duracion_min) AS duracion_minima,
    MAX(duracion_min) AS duracion_maxima,
    ROUND(AVG(duracion_min), 2) AS duracion_promedio_minutos,
    ROUND(AVG(proporcion_episodios), 4) AS proporcion_promedio
FROM podcasts_limpio;



-- Contar cuántos países distintos hay
SELECT COUNT(DISTINCT pais) AS total_paises_distintos
FROM podcasts_limpio;

SELECT 
    COUNT(pais) AS total_registros_no_nulos,
    COUNT(DISTINCT pais) AS total_paises_distintos
FROM podcasts_limpio;

-- Países y sus totales de episodios
SELECT pais, COUNT(*) AS total_episodios
FROM podcasts_limpio
GROUP BY pais
ORDER BY total_episodios DESC;

-- Comparacion total_epidodios por periodos de pre-post y pandemia
SELECT 
    periodo_pandemia,
    COUNT(*) AS total_episodios
FROM podcasts_limpio
GROUP BY periodo_pandemia
ORDER BY FIELD(periodo_pandemia, 'Pre-Pandemia', 'Pandemia', 'Post-Pandemia');


/* POSIBLES RANKINS QUE VER */ 
-- TOP 15 PODCAST CON MAS EPISODIOS 
SELECT 
    podcast_id,
    nombre_podcast,
    COUNT(*) AS total_episodios
FROM podcasts_limpio
GROUP BY podcast_id, nombre_podcast
ORDER BY total_episodios DESC
LIMIT 15;

-- Top países por volumen de episodios

SELECT 
    pais,
    COUNT(*) AS total_episodios
FROM podcasts_limpio
GROUP BY pais
ORDER BY total_episodios DESC;

-- Podcast con mayor duración promedio

SELECT 
    podcast_id,
    nombre_podcast,
    ROUND(AVG(duracion_min), 2) AS duracion_promedio
FROM podcasts_limpio
WHERE duracion_min IS NOT NULL
GROUP BY podcast_id, nombre_podcast
ORDER BY duracion_promedio DESC
LIMIT 10;

-- pais y Podcast con mas episodios

SELECT 
    pais,
    podcast_id,
    nombre_podcast,
    COUNT(*) AS total_episodios
FROM podcasts_limpio
GROUP BY pais, podcast_id, nombre_podcast
ORDER BY pais, total_episodios DESC;

-- Ranking Global 
SELECT 
    ROW_NUMBER() OVER (ORDER BY duracion_min DESC) AS ranking,
    episodio_id,
    nombre_episodio,
    duracion_min
FROM podcasts_limpio
WHERE duracion_min IS NOT NULL
ORDER BY ranking;


-- episodios más largos,  con posición numérica sin empates.

SELECT 
    ROW_NUMBER() OVER (ORDER BY duracion_min DESC) AS ranking,
    episodio_id,
    nombre_episodio,
    duracion_min
FROM podcasts_limpio
WHERE duracion_min IS NOT NULL
ORDER BY ranking;



/* OUTLIERS */ 
-- Detectar outliers por desviacion estandar
WITH stats AS (
    SELECT 
        AVG(duracion_min) AS media,
        STDDEV(duracion_min) AS sd
    FROM podcasts_limpio
    WHERE duracion_min IS NOT NULL
)
SELECT 
    s.media,
    s.sd,
    e.*
FROM podcasts_limpio e
JOIN stats s
  ON e.duracion_min < (s.media - 3 * s.sd)
  OR e.duracion_min > (s.media + 3 * s.sd)
ORDER BY e.duracion_min DESC;

-- Cuantos outliers tenemos 

WITH stats AS (
    SELECT 
        AVG(duracion_min) AS media,
        STDDEV(duracion_min) AS sd
    FROM podcasts_limpio
    WHERE duracion_min IS NOT NULL
)
SELECT 
    COUNT(*) AS total_outliers
FROM podcasts_limpio e
JOIN stats s
  ON e.duracion_min < (s.media - 3 * s.sd)
  OR e.duracion_min > (s.media + 3 * s.sd);
  
  -- como determinamos que  episodios > 120 min serian los outlier 
  USE spotify_podcasts;

SELECT *
FROM podcasts_limpio
WHERE duracion_min > 120
ORDER BY duracion_min DESC;

-- entonces ¿ cuántos outliers hay?

SELECT COUNT(*) AS total_outliers_mayor_120
FROM podcasts_limpio
WHERE duracion_min >120;

SELECT COUNT(*) AS nulos_duracion
FROM podcasts_limpio
WHERE duracion_min IS NULL;


SELECT ROUND(AVG(duracion_min), 2) AS promedio_sin_outliers
FROM podcasts_limpio
WHERE duracion_min IS NOT NULL
  AND duracion_min <= 120;

SELECT episodio_id, nombre_episodio, duracion_min
FROM podcasts_limpio
WHERE duracion_min = (SELECT MAX(duracion_min) FROM podcasts_limpio);

