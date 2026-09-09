---
name: griddo-core
description: >
  Contrato de @griddo/core para instancias: qué exporta exactamente (componentes, hooks, funciones
  y los namespaces de tipos Schema, Fields, Core, Theme), qué providers hay que montar (SiteProvider,
  PageProvider, I18nProvider), qué renderers existen (gatsby, editor, preview, forms, ssg, sharedPage)
  y qué cambia cada uno, peer dependencies, el CLI griddo-autotypes y el puente __AT__ de autotypes.d.ts.
  Usar cuando el developer pregunte "qué exporta @griddo/core", "este import de @griddo/core falla",
  "qué renderer", "SiteProvider", "PageProvider", "autotypes", "autotypes.d.ts", "__AT__",
  "namespace Schema / Fields / Core / Theme", "peer dependencies", "está deprecado X",
  "qué versión de React", o dude de si algo es API pública o interna de core.
---

# griddo-core: contrato de `@griddo/core`

Esta skill es la **referencia de contrato** de `@griddo/core`, la librería que toda instancia importa.
Sus referencias se **generan desde el monorepo de Griddo** (`packages/griddo-core/llms-doc/`, filtradas
por audiencia «consumidor»/«ambos») y llevan una cabecera con la versión y el commit de origen. No las
edites a mano: se sobrescriben en el siguiente sync.

Úsala para responder **qué existe y bajo qué condiciones**. Para el *cómo* (ejemplos de uso, recetas)
complementa con `griddo-hooks`, `griddo-field-reference` y `griddo-schema`.

## Tabla de referencias

<!-- dx-sync:references:start -->
| Referencia | Tema | Resumen |
|---|---|---|
| `references/api-publica.md` | api-publica | Superficie pública de `@griddo/core` — componentes, hooks, contextos, funciones y utilidades exportadas por el barrel `src/index.ts`. |
| `references/autotypes.md` | autotypes | Binario `griddo-autotypes` — entrypoint, parsers, salida, errores y cómo encaja con el sistema de tipos. |
| `references/configuracion.md` | configuracion | Peer deps, Provider tree obligatorio, renderers, autotypes y la cadena de configuración que `@griddo/core` requiere del consumidor. |
| `references/flujo.md` | flujo | Ciclo de consumo de `@griddo/core` — build de instancia (autotypes), runtime (Provider tree + render), y dependencias con `@griddo/cx`, `@griddo/components`, `@griddo/ax`. |
| `references/tipos-y-schemas.md` | tipos-y-schemas | Sistema de tipos de `@griddo/core` — `Schema` (lo que declara la instancia), `Fields` (lo que devuelve la API), `Core` (entidades runtime) y `Theme`. |
<!-- dx-sync:references:end -->

## Cómo usar esta skill

1. **Antes de afirmar que algo se exporta de `@griddo/core`**, compruébalo en `references/api-publica.md`.
   Si no está ahí, no es API pública: puede ser un wrapper de la instancia (`GriddoModule`,
   `GriddoComponent` viven en `@ui/modules` y `@ui/components`) o un hook de la instancia.
2. **Un import falla o un tipo sale `any`** → `references/configuracion.md` (providers, peer deps) y
   `references/autotypes.md` (si `autotypes.d.ts` no está generado, los tipos genéricos caen a `string`/`any`).
3. **Comportamiento distinto en el editor y en el sitio publicado** → sección «Renderers» de
   `references/configuracion.md` y «Renderers y sus efectos» de `references/flujo.md`.
4. **Qué campos admite un `Schema.Module`, `Schema.Template`, content type o form** →
   `references/tipos-y-schemas.md` (namespaces y ficheros `schema-fields/*`), y para cada field concreto
   la skill `griddo-field-reference`.
5. **Deprecaciones**: `api-publica.md` marca lo deprecado (`<Link>`, `<CloudinaryImage>`, `useImage`,
   `useLink`, …). No generes código con símbolos deprecados; propone el reemplazo indicado.

## Notas importantes

- La cabecera `<!-- griddo-dx-sync … -->` de cada referencia dice **de qué versión del monorepo** sale.
  Si la instancia del developer pinea una versión anterior de `@griddo/core`, avisa de que puede haber
  diferencias y pídele su `package.json`.
- Los paths de código que aparecen en las referencias (`src/...`) son del **paquete `@griddo/core`**, no
  de la instancia: sirven para orientarse, no para importar desde ellos.
- Prosa en español, código en inglés, como el resto del plugin.
