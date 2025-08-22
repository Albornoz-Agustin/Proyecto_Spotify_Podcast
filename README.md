<p align="center">
  <img src="img/logoJR3.png" alt="Logo del proyecto" width="160">
</p>

<h1 align="center">Proyecto Spotify Podcasts (2019–2024)</h1>
<p align="center">
  Análisis de la evolución de episodios de podcast en Spotify mediante <strong>API + Python + Power BI + MySQL</strong>.
</p>

<p align="center">
  <a href="https://app.powerbi.com/view?r=eyJrIjoiMGJkMzBiMmEtNzdiYS00ZDI0LTgyYjEtZDIxMThlYzQyYTVkIiwidCI6IjRkMWM0Yzk5LTdiMGUtNDk4Ny1hMTY4LTc4NTJkNjViMzYzMCJ9">🔗 Abrir reporte en Power BI Service</a>
</p>

---

## Resumen ejecutivo

Este proyecto analiza la publicación de episodios de podcast en Spotify entre 2019 y 2024.  
Se recopilaron **83 315 episodios** correspondientes a **159 podcasts** en **6 países** (AR, ES, BR, PT, US, GB) y **3 idiomas** (es, pt, en). Tras limpieza y depuración, el análisis se realizó sobre **54 212 episodios** de **118 podcasts**.  
Los datos se obtuvieron vía **API de Spotify**, se procesaron en **Python** y se visualizaron en **Power BI**; la consistencia se validó con **MySQL**.

> **Objetivo.** Describir tendencias, estructura y cambios en la producción de podcasts (pre-pandemia, pandemia, post-pandemia) y documentar un flujo reproducible de extremo a extremo.

---

## Tabla de contenidos
- [Datos y fuentes](#datos-y-fuentes)
- [Metodología](#metodología)
- [Cómo reproducir](#cómo-reproducir)
- [Principales hallazgos](#principales-hallazgos)
- [Dashboard (Power BI)](#dashboard-power-bi)
- [SQL y validación](#sql-y-validación)
- [Roadmap](#roadmap)
- [Equipo](#equipo)
- [Licencia](#licencia)
- [Estructura del repositorio](#estructura-del-repositorio)

---

## Datos y fuentes

- **Fuente primaria:** API oficial de Spotify (búsqueda por palabra clave, paginación, filtros por país, idioma y fechas).
- **Cobertura original:** 83 315 episodios · 159 podcasts · 6 países · 3 idiomas.  
- **Dataset analizado tras limpieza:** 54 212 episodios · 118 podcasts · 17 variables.
- **Formato:** CSV limpio apto para Python / Power BI / SQL.

> Detalles adicionales en `Script_final.ipynb` y en la memoria del proyecto (PDF).

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
   Estadísticos descriptivos, distribuciones, outliers y correlaciones.

4. **Visualización en Power BI**  
   Modelo estrella (HechosEpisodios, DimPodcast, DimCalendario), medidas DAX y storytelling analítico.

5. **Validación con MySQL**  
   Carga del CSV y consultas de control (conteos, distintivos, comparativas).

---

## Cómo reproducir

**Requisitos**  
   - Sugeridos: Python 3.12, pandas, matplotlib, seaborn, Jupyter.  
   - Crear entorno | python -m venv .venv.  
   - Windows | venv\Scripts\activate.  
   - Linux/Mac | source.venv/bin/activate.  
   - Instalar dependencias | pip install -r requirements.txt.
   - Ejecutar notebooks | jupyter notebook.
   - Orden recomendado: Script_limpieza_del_set.ipynb → Script_final.ipynb

> Para re-extraer datos desde Spotify necesitarás credenciales propias `(.env con SPOTIFY_CLIENT_ID y SPOTIFY_CLIENT_SECRET)`. Para reproducir el análisis basta con el dataset limpio y los notebooks.

---

## Principales hallazgos

**Principales hallazgos**  
   - Expansión 2020–2021: pico de producción y de episodios disponibles durante la pandemia.  
   - Ajuste de formato: caída de la duración media en 2020; leve recuperación posterior sin alcanzar niveles de 2019.  
   - Outliers: valores extremos inflan medias y varianzas; filtrarlos mejora la representatividad del episodio típico.  
   - Correlaciones: relación casi perfecta entre catálogo total y episodios disponibles; correlación negativa moderada con la duración.  

>Detalles cuantitativos y tablas en la memoria y en el notebook principal.

---

## Dashboard (Power BI)
   - Reporte en Power BI Service: abrir el dashboard.  
   - Estructura por secciones: *Análisis General · Evolución de Producción · Impacto Pre/Post Pandemia · Distribución · Outliers*.  
   - Modelo: tabla de hechos a nivel de episodio y dimensiones de Podcast y Calendario.  

---


## SQL y validación
   - Base cargada en MySQL y validada con consultas de control (totales, distintivos, comparativas por periodo).  
   - Uso de *LOAD DATA INFILE* (cuando aplica) para carga eficiente y consistencia de tipos.  
   - Modelo: tabla de hechos a nivel de episodio y dimensiones de Podcast y Calendario.  

---


## Roadmap
   - Normalizar por antigüedad del podcast para medir productividad relativa.  
   - Modelos de tendencia (STL/Prophet) sobre serie año-mes.  
   - Análisis de texto (NLP) de títulos/categorías.
   - Pipeline de actualización automática del dashboard.

---


## Equipo
 **Agustin Albornoz** | 
 **Raquel Lorenzo** | 
 **Ramyi Gossen** | 

---

## Licencia

>Repositorio con fines educativos *Unicorn Academy*


## Estructura del repositorio

```text
.
├── Dataset + scripts/                 # Datos y utilidades
├── img/
│   └── logoJR3.png                    # Logo usado en el README
├── Script_final.ipynb                 # Análisis / modelo principal
├── Script_limpieza_del_set.ipynb      # Limpieza y preparación
├── Proyecto Podscasts -JR3DATASTUDIO-.sql
├── Presentacion_Podcasts_Python_PowerBI.pptx
├── Memoria- Proyecto Podcasts Spotify- JR3 Data Studio.pdf
├── PowerBI_Reporte.url                # Acceso directo (Windows) al reporte
└── requirements.txt

