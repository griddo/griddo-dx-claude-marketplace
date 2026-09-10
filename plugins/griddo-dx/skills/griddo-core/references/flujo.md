<!-- griddo-dx-sync
GENERADO desde el monorepo griddo/griddo — NO EDITAR A MANO: el siguiente sync lo sobrescribe.
fuente:   packages/griddo-core/llms-doc/flujo.md
monorepo: v12.8.4 @ 8145d53a63
fecha:    2026-09-10
-->

# Flujo de consumo

## TL;DR

- `@griddo/core` se consume en **dos momentos distintos**: (1) build de la instancia (binario `griddo-autotypes` lee `griddo.config.ts` y emite `autotypes.d.ts`), (2) runtime (la instancia importa componentes/hooks/contextos para renderizar páginas en cualquiera de los renderers).
- En runtime hay **6 renderers** posibles (`gatsby`, `editor`, `preview`, `forms`, `ssg`, `sharedPage`), cada uno con un comportamiento ligeramente distinto en `<Component>` y en algunos hooks. El renderer activo se inyecta vía `<SiteProvider renderer="...">`.
- `<Page>` es el entrypoint de render por página. Internamente compone `<PageProvider>` + `<Component>` + `<NavigationProvider>` para header/footer + `<Template>` para el cuerpo.
- El binario `griddo-autotypes` no arranca un proceso largo: lee config, parsea schemas, escribe el `.d.ts` y termina. Se ejecuta en `prebuild` o equivalente.
- El paquete **no hace I/O en runtime**. Los hooks que fetchean (`useFetch`, `useReferenceFieldData`, `useList`, `useDataFilters`) usan `fetch` del navegador contra `apiUrl`/`publicApiUrl` que vienen del Provider tree.

## Actores

| Actor | Responsabilidad |
|---|---|
| **Instancia Griddo** | Declara `griddo.config.ts` (schemas), invoca `griddo-autotypes` en su pipeline de build, monta el Provider tree y renderiza páginas con `<Page>`. |
| **`@griddo/core`** (este paquete) | Provee la librería React (componentes/hooks/contextos/tipos) y el CLI de autotypes. No tiene estado propio en runtime. |
| **`@griddo/cx`** | Consume `<Page>` desde Gatsby (renderer `gatsby`) o desde el SSG futuro (`ssg`). Inyecta el `linkComponent` adecuado al `<SiteProvider>`. |
| **`@griddo/components`** | Provee la librería de componentes/módulos/templates concretos que la instancia mete por `libComponents` en `<Component>`. |
| **`@griddo/ax`** | Editor visual; consume `<Component>` con renderer `editor` o `preview`, y hooks como `useReferenceFieldData` (que solo trabaja en estos renderers). |
| **API pública / privada de Griddo** | Endpoints REST a los que llaman los hooks de fetch (`/list/v2/`, `/filters/`, `/distributor`, `/alert`). |

## Fase 1 — Build de la instancia (autotypes)

### Cuándo

- En el `prebuild` de la instancia (o equivalente). Antes del bundle de la app.
- Manualmente cuando un dev cambia un schema y quiere refrescar autocomplete.

### Cómo

```bash
griddo-autotypes
# o el legacy (CommonJS, output .js):
griddo-autotypes-legacy
```

El script:

1. Resuelve la ruta de la instancia (`packageDirectorySync` de `pkg-dir`).
2. Carga `griddo.config.ts` con `tsx` (sin compilar a JS antes).
3. Extrae los schemas de `config.schemas` (config + ui + contentTypes + forms).
4. Aplica una lista fija de **22 parsers** (uno por categoría: módulos, templates, themes, datapacks, etc.).
5. Concatena el output, lo prettifica con `prettier`, y escribe `autotypes.d.ts` en la raíz de la instancia.

### Salida

Un `autotypes.d.ts` con un default export `__AT__` que contiene tipos como `__AT__.Modules` (union de nombres de módulos), `__AT__.Templates`, `__AT__.Themes`, `__AT__.DataPacks`, etc. El propio `@griddo/core` consume este archivo internamente con `import type __AT__ from "@/autotypes"` para tipar los schemas — por eso si la instancia no lo genera, los tipos de schema de la instancia pierden autocompletado.

### Si falla

- Error en `loadConfigTs` → exit 1, log con stack.
- Error en cualquier parser → log con `${kleur.red(" ✘")} AutoTypes` y el `e`. **No exit 1** — el script atrapa y solo loguea, así un parser roto no aborta el build entero. Esto es discutible (ver `reglas.md` (doc interna de @griddo/core, no incluida en el plugin)).

## Fase 2 — Provider tree de la instancia

Antes de renderizar nada, la instancia (o `@griddo/cx`) monta los providers de `@griddo/core` en orden:

```tsx
<SiteProvider {...siteProps}>          {/* renderer, linkComponent, siteId, publicApiUrl, ... */}
  <Page                                 {/* PageComponent del paquete: PageProvider interno */}
    library={{ components, templates, formsTemplates, config }}
    content={pageData}
    apiUrl={...}
    siteMetadata={...}
    languageId={...}
    pageLanguages={...}
    header={...}
    footer={...}
  />
</SiteProvider>
```

`<Page>` internamente despliega:

```
<PageProvider>                    → expone PageContext (usePage)
  <I18nProvider translations>     → expone I18nContext (useI18n)
    <NavigationProvider>          → header
      <Component>                 → header module
    <Template>                    → cuerpo de la página
    <NavigationProvider>          → footer
      <Component>                 → footer module
```

Si la instancia hace render por módulo aislado (preview en AX), usa `<Preview isPage={false}>` que envuelve `<ModulePreview>` con su propio `<ModulePreviewProvider>`.

### Contextos globalizados (anti-duplicate)

Todos los contextos (excepto `FormContext`) se crean vía `getOrCreateGlobalContext(key, default)` que cachea el `React.Context` en `globalThis[key]`. Esto evita duplicados cuando hay múltiples versiones de `@griddo/core` cargadas en el mismo proceso (escenario del split del monorepo o de paquetes consumidores con versiones distintas). Las claves están en `CONTEXT_KEYS`: `__GRIDDO_SITE_CONTEXT__`, `__GRIDDO_PAGE_CONTEXT__`, `__GRIDDO_I18N_CONTEXT__`, `__GRIDDO_SESSION_CONTEXT__`, `__GRIDDO_NAVIGATION_CONTEXT__`, `__GRIDDO_MODULE_PREVIEW_CONTEXT__`.

## Fase 3 — Render de un módulo

`<Component component="X" libComponents={modules} {...props}>`:

1. Obtiene `renderer` del `SiteContext`.
2. Resuelve `LibComponent = getComponent(libComponents, props)` — busca `libComponents[component]`. Si no existe, `console.warn` y retorna `null`.
3. Bifurca según renderer:
   - **`editor`** — envuelve en `<SessionProvider>` + `<ComponentWrapper>` (overlay con botones copy/duplicate/delete y selección por `editorID`). Si `type === "formTemplate"`, añade `<FormProvider>`.
   - **`preview`** — envuelve en `<SessionProvider>` y renderiza `<LibComponent>` directo.
   - **`forms`** — envuelve en `<SessionProvider>` + `<FormWrapper>` (similar al editor pero sin las acciones de módulo).
   - **resto (`gatsby`, `ssg`, `sharedPage`)** — renderiza `<LibComponent {...props}>` sin envoltorio.

`<ComponentWrapper>` lee `selectEditorID`, `selectHoverEditorID`, `moduleActions` del `SiteContext`. Estas funciones las inyecta el editor; en el resto de renderers son `undefined` pero el wrapper no se monta porque solo se usa en `editor`.

## Fase 4 — Hooks de fetch (runtime de instancia)

Los hooks que llaman a la API:

| Hook | Endpoint | Cuándo dispara |
|---|---|---|
| `useFetch(url)` | el que recibas | cuando `url` cambia. Wrapper genérico. |
| `useList<T>()` | `${publicApiUrl}/list/v2/...` o `/list/fixed/` o `/list/navigations/` | al llamar el `setQuery` retornado, evalúa el query firmado y llama `useFetch`. Cachea `prevQueryRef` para evitar refetches por el cache-buster. |
| `useDataFilters<T>()` | `${publicApiUrl}/filters/<contentType>/...` | igual al anterior. |
| `useReferenceFieldData<T>(data)` | `${apiUrl}/site/<id>/distributor` (privada) | **solo en renderers `editor` y `sharedPage`**. En `gatsby`/`ssg` los datos vienen pre-renderizados. |
| `useAiSearch`, `useAiAnswers`, `useAiReferenceField` | endpoints AI | bajo demanda. |
| `useSendInterests`, `useReceiveInterests` | endpoints de tracking | bajo demanda. |

Token y siteId se leen de `localStorage` (`persist:app`, `persist:root`) en `getToken()` / `getSiteID()` — esto solo funciona en navegador. En SSR retornan `null`/`1` y los hooks que dependan de auth no disparan.

## Fase 5 — Build del propio paquete

```bash
yarn build
# rollup -c → dist/index.js (ESM, externals: react, react-dom)
#          → dist/autotypes.js (legacy CJS-shaped ESM bundle)
#          → dist/autotypes.mjs (con shebang)
```

- Plugins rollup: typescript + babel + nodeResolve + commonjs + json + postcss + replace + terser + (autotypes solo) preserve-shebang.
- `react`/`react-dom` quedan **external** — los aporta la instancia/peer.
- `prettier` queda external en el bundle de autotypes — los aporta la instalación de la instancia.
- Tests: `vitest` con env `jsdom`, root en `src/`. Mocks/fetch via `vitest-fetch-mock`.

## Contratos entre fases

| Fase | Lee de | Escribe a |
|---|---|---|
| autotypes | `<instancePath>/griddo.config.ts` | `<instancePath>/autotypes.d.ts` |
| Provider tree (instancia) | props que la app construye | `globalThis.__GRIDDO_*_CONTEXT__` (idempotente) |
| `<Page>` | `library` (FCs) + `content` (data) + `apiUrl` + `siteMetadata` | árbol de React |
| `<Component>` | `libComponents` + `renderer` (del SiteContext) | árbol de React |
| Hooks de fetch | `apiUrl`/`publicApiUrl`/`siteId` (Site) + `languageId` (Page) | red |

## Renderers y sus efectos

| Renderer | Quién lo setea | `<Component>` envoltorio | Hooks afectados |
|---|---|---|---|
| `gatsby` | `@griddo/cx` (Gatsby SSR/CSR) | sin envoltorio | — (datos pre-renderizados) |
| `editor` | `@griddo/ax` | `SessionProvider + ComponentWrapper` (+ `FormProvider` si formTemplate) | `useReferenceFieldData` activo, `useDataFilters` con cache-buster por timestamp |
| `preview` | `@griddo/ax` (preview de página) | `SessionProvider` + render directo | `useReferenceFieldData` activo, `<GriddoLink>` muestra `href` para AX |
| `forms` | `@griddo/ax` (formularios) | `SessionProvider + FormWrapper` | — |
| `ssg` | SSG futuro | sin envoltorio | — |
| `sharedPage` | feature de share preview | sin envoltorio | `useReferenceFieldData` activo (con `authMode: "PREVIEW"` y headers `x-preview-share-*`) |

## Relacionado

- [Configuración](configuracion.md) — qué providers son obligatorios y peer deps.
- [Superficie pública](superficie-publica.md) — superficie de componentes/hooks/contextos.
- [Autotypes](autotypes.md) — internals del CLI.
- [Tipos y schemas](tipos-y-schemas.md) — cómo se relacionan los tipos con el config.
- Arquitectura (doc interna de @griddo/core, no incluida en el plugin) — layers internos.
- Reglas (doc interna de @griddo/core, no incluida en el plugin) — qué NO hacer al consumir o extender.
