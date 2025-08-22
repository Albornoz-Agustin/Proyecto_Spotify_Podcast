<p align="center">
  <img src="docs/img/logo.png" alt="Logo del proyecto" width="160">
</p>

<h1 align="center">Proyecto Spotify Podcasts (2019–2024)</h1>
<p align="center">
  Análisis de la evolución de episodios de podcast en Spotify mediante <strong>API + Python + Power BI + MySQL</strong>.
</p>

<p align="center">
  <a href="PowerBI_Reporte.url">🔗 Abrir reporte en Power BI Service</a>
</p>

---

## Resumen ejecutivo

Este proyecto analiza la publicación de episodios de podcast en Spotify entre 2019 y 2024.  
Se recopilaron **83 315 episodios** correspondientes a **159 podcasts** en **6 países** (AR, ES, BR, PT, US, GB) y **3 idiomas** (es, pt, en). Tras limpieza y depuración, el análisis se realizó sobre **54 212 episodios** de **118 podcasts**.  
Los datos se obtuvieron vía **API de Spotify**, se procesaron en **Python** y se visualizaron en **Power BI**; la consistencia se validó con **MySQL**.

> Objetivo: describir tendencias, estructura y cambios en la producción de podcasts (pre-pandemia, pandemia, post-pandemia) y documentar un flujo reproducible de extremo a extremo.

---

## Tabla de contenidos
- [Datos y fuentes](#datos-y-fuentes)
- [Metodología](#metodología)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Cómo reproducir](#cómo-reproducir)
- [Principales hallazgos](#principales-hallazgos)
- [Dashboard (Power BI)](#dashboard-power-bi)
- [SQL y validación](#sql-y-validación)
- [Roadmap](#roadmap)
- [Equipo](#equipo)
- [Licencia](#licencia)

---

## Datos y fuentes

- **Fuente primaria:** API oficial de Spotify (búsqueda por palabra clave, paginación, filtros por país, idioma y fechas).
- **Cobertura original:** 83 315 episodios · 159 podcasts · 6 países · 3 idiomas.  
- **Dataset analizado tras limpieza:** 54 212 episodios · 118 podcasts · 17 variables.
- **Formato:** CSV limpio apto para Python/Power BI/SQL.

> Ver detalles en `Script_final.ipynb` y en la memoria del proyecto.

---

## Metodología

1. **Extracción**  
   Autenticación y paginación de la API de Spotify; armado de DataFrame con variables clave (fecha, duración, show/editorial, etc.).

2. **Limpieza y features**  
   - Filtro temporal 2019–2024.  
   - Conversión de fechas y descomposición (año/mes).  
   - Estandarización de país/idioma; normalización de texto.  
   - Variables derivadas: `categoria_duracion`, `periodo_pandemia`, métricas de proporción.  
   - Separación de tablas (episodios/podcasts) para modelado en Power BI.

3. **Análisis en Python**  
   Estadísticos descriptivos, distribuciones, outliers, correlaciones.

4. **Visualización en Power BI**  
   Modelo estrella (HechosEpisodios, DimPodcast, DimCalendario), DAX y storytelling analítico.

5. **Validación con MySQL**  
   Carga del CSV y consultas de control (conteos, distintivos, comparativas).

---

## Estructura del repositorio
