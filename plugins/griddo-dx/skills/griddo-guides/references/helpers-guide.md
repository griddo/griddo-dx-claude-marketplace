# Griddo helpers: GriddoImageExp y GriddoLink

En Griddo disponemos de varios hooks, componentes y funciones útiles para instancias.

## `<GriddoImageExp>`

Componente imagen "compatible" con el field `ImageField` de Griddo.
Se basa en los estándares actuales de HTML utilizando `<picture>` para el fallback de formatos (actualmente avid, webp y jpg).

Responsive utilizando `<sources>` y `sizes` de igual manera que en HTML.

Lazy loading, priority, etc..

Soporta Art-Direction. Esto hace posible que por ejemplo en móvil se pueda mostrar una imagen (cat.jpg) y en desktop otra imagen totalmente distinta (dog.jpg).

Un uso más normal sería mostrar la misma "imagen" pero con distinto aspect-ratio: móvil: 9:16 y en desktop 16:9. En este caso no sería la misma imagen centrada por CSS , serían dos imágenes (dos descargas) distintas optimizadas tanto por peso como por recorte para los distintos dispositivos.

## `<GriddoLink>`

Utilizar el router interno del SSG (Actualmente Gatsby) para enlaces internos y externos de página (en externos se comporta como una etiqueta `<a>`).
