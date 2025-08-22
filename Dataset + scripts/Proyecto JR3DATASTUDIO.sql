/* 
Spotify Podcast --- Proyecto integrador ---- Grupo: JR3 Data Studio --- Unicorn Academy 
MySQL verion 9.2.0
Este script presenta un  forma de comprobar los datos obtenidos con Python y Power Bi son los mismos y como ejercicio para no desaprovechar lo aprendido.

*/ 
SELECT VERSION();


--  Crear base de datos 2 FORMAS
CREATE SCHEMA spotify_podcast;
USE spotify_podcast;

CREATE DATABASE IF NOT EXISTS spotify_podcast
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE spotify_podcast;

--  Crear tabla
DROP TABLE IF EXISTS spotify_2019_2024;
CREATE TABLE spotify_2019_2024 (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  episodio_id        VARCHAR(128) NOT NULL,  
  podcast_id         VARCHAR(128) NOT NULL,  
  nombre_podcast     VARCHAR(255) NOT NULL,
  nombre_episodio    VARCHAR(255) NOT NULL,
  pais               VARCHAR(64)  NOT NULL,
  idioma_show        VARCHAR(32)  NOT NULL,
  categoria          VARCHAR(128) NULL,
  editorial          VARCHAR(255) NULL,
  total_episodios    INT          NULL,
  proporcion_episodios DECIMAL(9,6) NULL,
  fecha_lanzamiento  DATE         NULL,
  año                SMALLINT     NULL,
  mes                TINYINT      NULL,
  duracion_min       DECIMAL(6,2) NULL,
  categoria_duracion VARCHAR(32)  NULL,
  periodo_pandemia   VARCHAR(32)  NULL,

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY uq_ep (episodio_id),

  INDEX idx_pais (pais),
  INDEX idx_idioma (idioma_show),
  INDEX idx_fecha (fecha_lanzamiento),
  INDEX idx_show  (podcast_id)
);



--  Comprobaciones
SELECT COUNT(*) AS total_filas FROM spotify_2019_2024;
SELECT COUNT(DISTINCT podcast_id) AS shows_unicos FROM spotify_2019_2024;
SELECT COUNT(DISTINCT episodio_id) AS episodios_unicos FROM spotify_2019_2024;
SHOW WARNINGS;


-- Comprobar coincidencias en todas las columnas 
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
FROM spotify_2019_2024;


-- Contar cuántos países distintos hay
SELECT COUNT(DISTINCT pais) AS total_paises_distintos
FROM spotify_2019_2024;

SELECT 
    COUNT(pais) AS total_registros_no_nulos,
    COUNT(DISTINCT pais) AS total_paises_distintos
FROM spotify_2019_2024;


-- países y sus totales de episodios

SELECT pais, COUNT(*) AS total_episodios
FROM spotify_2019_2024
GROUP BY pais
ORDER BY total_episodios DESC;


--  DISTRIBUCION POR CATEGORIA Y DURACION 
SELECT 
    categoria_duracion,
    COUNT(*) AS total_episodios,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM spotify_2019_2024), 2) AS porcentaje
FROM spotify_2019_2024
GROUP BY categoria_duracion
ORDER BY total_episodios DESC;

-- Comparaion total_epidodios por periodos de pre-post y pandemia
SELECT 
    periodo_pandemia,
    COUNT(*) AS total_episodios
FROM spotify_2019_2024
GROUP BY periodo_pandemia
ORDER BY FIELD(periodo_pandemia, 'Pre-Pandemia', 'Pandemia', 'Post-Pandemia');


/* POSIBLES RANKINS QUE VER */ 
-- TOP 15 PODCAST CON MAS EPISODIOS 
SELECT 
    podcast_id,
    nombre_podcast,
    COUNT(*) AS total_episodios
FROM spotify_2019_2024
GROUP BY podcast_id, nombre_podcast
ORDER BY total_episodios DESC
LIMIT 15;

-- Top países por volumen de episodios

SELECT 
    pais,
    COUNT(*) AS total_episodios
FROM spotify_2019_2024
GROUP BY pais
ORDER BY total_episodios DESC;

-- Podcast con mayor duración promedio

SELECT 
    podcast_id,
    nombre_podcast,
    ROUND(AVG(duracion_min), 2) AS duracion_promedio
FROM spotify_2019_2024
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
FROM spotify_2019_2024
GROUP BY pais, podcast_id, nombre_podcast
ORDER BY pais, total_episodios DESC;

-- Ranking Global 
SELECT 
    ROW_NUMBER() OVER (ORDER BY duracion_min DESC) AS ranking,
    episodio_id,
    nombre_episodio,
    duracion_min
FROM spotify_2019_2024
WHERE duracion_min IS NOT NULL
ORDER BY ranking;


-- episodios más largos,  con posición numérica sin empates.

SELECT 
    ROW_NUMBER() OVER (ORDER BY duracion_min DESC) AS ranking,
    episodio_id,
    nombre_episodio,
    duracion_min
FROM spotify_2019_2024
WHERE duracion_min IS NOT NULL
ORDER BY ranking;



/* OUTLIERS */ 
-- Detectar outliers por desviacion estandar
WITH stats AS (
    SELECT 
        AVG(duracion_min) AS media,
        STDDEV(duracion_min) AS sd
    FROM spotify_2019_2024
    WHERE duracion_min IS NOT NULL
)
SELECT 
    s.media,
    s.sd,
    e.*
FROM spotify_2019_2024 e
JOIN stats s
  ON e.duracion_min < (s.media - 3 * s.sd)
  OR e.duracion_min > (s.media + 3 * s.sd)
ORDER BY e.duracion_min DESC;

-- Cuantos outliers tenemos 

WITH stats AS (
    SELECT 
        AVG(duracion_min) AS media,
        STDDEV(duracion_min) AS sd
    FROM spotify_2019_2024
    WHERE duracion_min IS NOT NULL
)
SELECT 
    COUNT(*) AS total_outliers
FROM spotify_2019_2024 e
JOIN stats s
  ON e.duracion_min < (s.media - 3 * s.sd)
  OR e.duracion_min > (s.media + 3 * s.sd);
  
  -- como determinamos que  episodios > 120 min serian los outlier 
  USE spotify_podcast;

SELECT *
FROM spotify_2019_2024
WHERE duracion_min > 120
ORDER BY duracion_min DESC;

-- entonces ¿ cuántos outliers hay?

SELECT COUNT(*) AS total_outliers_mayor_120
FROM spotify_2019_2024
WHERE duracion_min > 120;



