# Build y publicación de una instancia Griddo

Cómo se convierte tu instancia en un sitio publicado, y qué parte de eso está en tus manos.

## Qué es `@griddo/cx` y qué no es

`@griddo/cx` es el paquete que construye tu sitio. Dos cosas que sorprenden y explican la mayoría de las
dudas:

**El proyecto Gatsby es el paquete, no tu repo.** `gatsby-config.ts`, `gatsby-node.ts`, `gatsby-ssr.tsx` y
`gatsby-browser.tsx` viven dentro de `@griddo/cx`, y `gatsby build` se lanza con el directorio de trabajo
ahí. Tu instancia aporta **componentes, plantillas y configuración**; no aporta el proyecto Gatsby. Por eso
no puedes añadir un plugin de Gatsby en tu `package.json` y esperar que se cargue: la config no es tuya. Si
necesitas algo del `<head>` o del `<body>`, la vía es `builder.ssr.js` de tu instancia — mira la skill
`griddo-performance`.

**CX no publica.** Al terminar deja el bundle construido y una señal de que fue bien. Quien lo sube y quien
invalida el CDN es un proceso externo. Consecuencia práctica: si tu cambio **está construido pero no se ve
en producción**, el problema está después de CX, no en tu código.

El ciclo, en una línea: leer el contenido → escribir un store en disco → `gatsby build` → sincronizar la
salida al bundle publicable → avisar de que terminó.

## Por qué tu sitio no se ha reconstruido

Cada dominio recibe un **modo de render** al empezar el ciclo. Los tres que decide el sistema al arrancar:

| Modo | Significa |
|---|---|
| `FROM_SCRATCH` | Se reconstruye el dominio entero; el bundle anterior se descarta |
| `INCREMENTAL` | Hay un bundle válido: solo se procesan las páginas nuevas, cambiadas o eliminadas |
| `IDLE` | **Nada que hacer: el dominio se salta por completo** |

Y los dos que son resultado: `COMPLETED` (terminó limpio) y `ERROR` (algo falló, y el siguiente ciclo
empezará de cero).

El modo se resuelve por reglas ordenadas y **gana la primera que hace match**:

1. No hay bundle previo de ese dominio → `FROM_SCRATCH` (primer render, o alguien lo borró)
2. El render anterior no terminó (murió a media) → `FROM_SCRATCH`
3. El render anterior acabó en error → `FROM_SCRATCH`
4. **El commit del código ha cambiado** → `FROM_SCRATCH`
5. **No hay actividad** (sin cambios de contenido que renderizar) → `IDLE`
6. En cualquier otro caso → `INCREMENTAL`

Dos lecturas que te ahorran tiempo:

- **Si has tocado código, el render es completo** (regla 4). No esperes un incremental tras un deploy.
- **Si no has tocado nada y no ves tu cambio, probablemente fue `IDLE`** (regla 5): el dominio se saltó
  entero, sin construir nada. Un cambio de contenido sin publicar no cuenta como actividad.

**El sistema registra siempre la razón, no solo el modo, y al diagnosticar la razón vale más.** Si tienes
que abrir una incidencia, pide la razón del modo de ese dominio: distingue «no había nada que hacer» de «el
render anterior se murió», que se parecen desde fuera y no se arreglan igual.

El modo se congela al principio del ciclo. Si el mundo cambia a mitad, el render no se entera hasta el
ciclo siguiente.

## Dos cosas de tu instancia que rompen el build

### Tu `tsconfig.json` tiene que existir y tener `paths`

Al cargarse, el paquete lee el `tsconfig.json` (o `jsconfig.json`) **de tu instancia** y recorre
`compilerOptions.paths` para resolver dónde están tus componentes. Si tu instancia no tiene ese fichero, o
lo tiene sin `paths`, **el import del paquete revienta antes de que el build empiece**. El síntoma es un
error de carga, no un fallo de compilación, así que no lo busques en tus componentes: mira primero que el
`tsconfig.json` esté en la raíz y declare sus `paths`.

El starter ya viene con esto resuelto (`@/*`, `@ui/*`, `@schemas/*`). Si lo has reescrito, mantén los
`paths`.

### Cualquier `.xml` que dejes en la salida acaba publicado

Al sincronizar la salida se copian **todos** los `.xml` que encuentra, conservando su ruta relativa,
mientras que en destino solo se limpian los que se llaman `sitemap.xml` o empiezan por `sitemap-`. Un `.xml`
suelto que genere tu instancia se publica y no se borra en el render siguiente. Si generas XML que no es un
sitemap, no lo dejes en la salida del build.

## Dónde busca CX tus componentes

Depende de dónde esté instalado el paquete:

- **En un repo de cliente** (lo normal): la raíz de tu repositorio.
- **En el monorepo de Griddo**: el paquete de componentes.

Si has movido tus componentes de sitio y el build no los encuentra, es esto lo que hay que revisar, junto
con los `paths` del `tsconfig`.

## Relacionado

- `griddo-performance` — `builder.ssr.js`, límites de datos, imágenes y paginación.
- `griddo-setup` — estructura del proyecto y arranque.
- `griddo-core` — qué exporta `@griddo/core` y qué providers necesita tu árbol.
