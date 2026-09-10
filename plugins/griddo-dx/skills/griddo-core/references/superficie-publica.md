<!-- griddo-dx-sync
GENERADO desde el monorepo griddo/griddo — NO EDITAR A MANO: el siguiente sync lo sobrescribe.
fuente:   packages/griddo-core/llms-doc/superficie-publica.md
monorepo: v12.8.4 @ 8145d53a63
fecha:    2026-09-10
-->

# Superficie pública de `@griddo/core`

## TL;DR

- El barrel `src/index.ts` re-exporta **todo** lo público. Si algo no está ahí, no es API estable y los consumidores no deben importarlo por path interno.
- Componentes principales: `<Page>`, `<Component>`, `<GriddoLink>`, `<GriddoImage>`, `<GriddoImageExp>`, `<GriddoBackgroundImage>`, `<CloudinaryImage>` (deprecated), `<CloudinaryBackgroundImage>` (deprecated), `<LdJson>`, `<ModulePreview>`, `<Preview>`.
- Hooks por categoría: **contexto** (`usePage`, `useSite`, `useSession`, `useNavigation`, `useI18n`), **fetch** (`useList`, `useDataFilters`, `useReferenceFieldData`, `useFetch`), **imagen** (`useGriddoImage`, `useGriddoImageExp`, `useImage`), **AI** (`useAiSearch`, `useAiAnswers`, `useAIReferenceField`), **interests/tracking** (`useSendInterests`, `useReceiveInterests`), **theme** (`useTheme`, `useGlobalTheme`, `useThemeColors`, `useThemeFont`, `useThemePrimitives`), **misc** (`useIsClient`, `useIsFirstRender`, `useSSR`, `useScript`, `useLocaleDate`, `useLink`, `usePageRelatedContent`, `useListWithDefaultStaticPage`).
- Funciones standalone: `griddoAlertRegister`, `formatLocaleDate`. Utilidades: `getToken`, `getSiteID`, `getLangFromLocalStorage`.

## Componentes

### Render principal

| Componente | Resumen | Renderer-aware? |
|---|---|---|
| `<Page>` | Entrypoint de página: resuelve template, monta `PageProvider`+`I18nProvider`, renderiza header/footer/template. | sí (mismo árbol; los renderers afectan a `<Component>` interno). |
| `<Component>` | Componente "polimórfico": busca `libComponents[component]` y lo renderiza con envoltorios según renderer. | sí (`editor`/`preview`/`forms` añaden providers y wrappers). |
| `<ModulePreview>` | Render de un módulo aislado con su propio `<ModulePreviewProvider>`. | no (renderiza directo). |
| `<Preview>` | Discriminador `isPage`: delega en `<Page>` o `<ModulePreview>`. | n/a |

### Imagen

| Componente | Resumen | Estado |
|---|---|---|
| `<GriddoImage>` | `<picture>` con `<source>` por formato (avif/webp) + `<img>` jpeg fallback. Lee `griddoDamDefaults` del `SiteContext`. Soporta `format="svg"` y `format="gif"` (renderiza un `<img>` simple). Usa `react-aspect-ratio` para responsive. | activo |
| `<GriddoImageExp>` | Versión experimental (`Exp`) con tipos paralelos en `GriddoImageExp/types`. Coexiste con `<GriddoImage>` mientras se prueba. | experimental |
| `<GriddoBackgroundImage>` | Background image con `IntersectionObserver` para lazy-load. Aplica `--image-{idx}` como custom properties para responsive por breakpoint. | activo |
| `<CloudinaryImage>` | Variante para imágenes en Cloudinary (no DAM Griddo). | **deprecated** — desaparecerá. |
| `<CloudinaryBackgroundImage>` | Background image variant para Cloudinary. | **deprecated** — desaparecerá. |

### Links / metadatos

| Componente | Resumen |
|---|---|
| `<GriddoLink>` | Link inteligente: usa `linkComponent` del `<SiteProvider>` para internos, `<a>` para externos. Resuelve relative-to-root via `fullPath` del `usePage`. Comportamiento especial en `editor`/`preview`. |
| `<Link>` | Versión legacy. **Deprecated** — usar `<GriddoLink>`. |
| `<LdJson>` | Inyecta `<script type="application/ld+json">` con structured data. |

### Fragmentos para `<Component>`

| Componente | Rol | Solo en renderer |
|---|---|---|
| `<ComponentWrapper>` (interno) | Overlay con botones copy/duplicate/delete + selección por `editorID`. Usa `IntersectionObserver` para hover. | `editor` |
| `<FormWrapper>` (interno) | Wrapper alternativo para formularios. | `forms` |

Estos no se exportan públicamente; los monta `<Component>` automáticamente.

## Hooks

### Hooks de contexto

| Hook | Devuelve | Lee de | Side effects |
|---|---|---|---|
| `useSite()` | `Site` | `SiteContext` | — |
| `usePage()` | `PageContextProps` (con `locale` e `ISOLocale` computados) | `PageContext` | `console.warn` si falta `<PageProvider>`. |
| `useSession()` | `[state, setState]` | `SessionContext` | — |
| `useNavigation()` | `{ isNavigation: true } \| null` | `NavigationContext` | — |
| `useI18n({ locale? })` | `{ getTranslation, getNestedTranslation }` | `I18nContext`, `Site.siteLangs`, `Page.languageId` | `console.warn` si falta provider/lang. |
| `useForm()` | `{ isForm: true } \| null` | `FormContext` | — |
| `useModulePreview()` | `{ languageId? }` | `ModulePreviewContext` | — |

### Hooks de fetch

| Hook | Endpoint | Cuándo dispara |
|---|---|---|
| `useFetch<T>(url, options?)` | el url que recibas | cambio de `url`. Wrapper genérico con `isLoading`/`isError`/`data`/`msg`/`isFirstFetch`. |
| `useList<T>()` | `${publicApiUrl}/list/v2/...` (auto), `/list/fixed/` (manual), `/list/navigations/` (navigation) | al llamar `setQuery({ data })`. Gateado por `prevQueryRef` para no refetch por cache-buster. Si `contentType` está vacío (`mode=manual` con `fixed=[]`), retorna `{ items: [], totalItems: 0 }` sin red. |
| `useDataFilters<T>()` | `${publicApiUrl}/filters/<contentType>/...` | igual al anterior. |
| `useListWithDefaultStaticPage<T>(...)` | `useList` + computa `totalPages` y maneja la primera página estática | usado en templates con paginación SSG. |
| `useReferenceFieldData<T>(data)` | `${apiUrl}/site/<id>/distributor` (privada) | **solo en renderers `editor` y `sharedPage`**. En `gatsby`/`ssg` los datos vienen pre-renderizados. |
| `useReferenceField<T>(data)` | alias de `useReferenceFieldData` | — |
| `useDistributorData<T>(data)` | alias de `useReferenceFieldData` | — |
| `useAiSearch()` / `useAISearch()` | endpoint AI search | `setQuery({ ... })`. |
| `useAiAnswers()` / `useAIAnswers()` | endpoint AI answers | `setQuery({ ... })`. |
| `useAIReferenceField()` | endpoint AI reference | bajo demanda. |
| `useSendInterests()` | endpoint tracking | bajo demanda. |
| `useReceiveInterests()` | endpoint tracking | bajo demanda. |
| `usePageRelatedContent()` | endpoint related content | bajo demanda. |

### Auth y headers de fetch

`getOptions(body, { lang, authMode })` (`hooks/utils.ts`) define el contrato:

- `Content-Type: application/json`.
- Si `lang != null`, `lang: <id>`.
- `authMode: "JWT"` (default) → añade `Authorization: bearer <token>` leyendo `localStorage["persist:app"]`.
- `authMode: "PREVIEW"` → añade `x-preview-share-page-id` y `x-preview-share-entity` desde `sessionStorage` (para feature de share).

`POST` siempre. No hay GETs en estos hooks.

### Hooks de imagen

| Hook | Devuelve | Para |
|---|---|---|
| `useGriddoImage(props)` | `{ src, sizes, srcSet, srcSetURL, jpeg, webp, avif, png, gif, svg, ... }` | Genera el conjunto de URLs DAM con sus parámetros. Lo usa `<GriddoImage>` internamente. |
| `useGriddoImageExp(props)` | similar | Versión experimental. |
| `useImage(props)` | `{ src, srcSet, sizes }` | Versión Cloudinary (deprecated junto a `<CloudinaryImage>`). |

### Hooks de tema

Trabajan sobre `Theme.GriddoTheme` (`{ global, themes[] }`):

| Hook | Para |
|---|---|
| `useTheme(themeFile, { theme?, global? })` | Retorna el theme seleccionado o todos. |
| `useGlobalTheme(themeFile)` | Atajo para `theme.global`. |
| `useThemeColors(themeFile, props)` | Filtra primitives que sean colores válidos (`CSS.supports('color', value)`). |
| `useThemeFont(themeFile, props)` | Idem para fuentes. |
| `useThemePrimitives(themeFile, props)` | Filtra por `primitive: string \| Array<string>`. |

Los hooks **no leen del DOM ni del CSS computado**; trabajan sobre la estructura `GriddoTheme` que pasa el consumidor. Útil para herramientas de docs / diseño.

### Hooks misc

| Hook | Para |
|---|---|
| `useIsClient()` | `true` tras hidratar (vs. SSR). |
| `useIsFirstRender()` | `true` solo en el primer render del componente. |
| `useSSR()` | Detecta si estamos en server-side. |
| `useScript(src, options?)` | Inyecta `<script>` dinámico con tracking de `loaded`/`error`. |
| `useLocaleDate(...)` | Wrapper de `formatLocaleDate` con locale del page. |
| `useLink()` | Atajo a `linkComponent` del `SiteContext` (legacy, lo usa `<Link>`). |
| `useContentType()` | Hook helper para obtener el content type relacionado de la página. |
| `useContentTypeNavigation()` | Variante para nav (next/previous). |

## Funciones

| Función | Para | Side effects |
|---|---|---|
| `griddoAlertRegister({ publicApiUrl, level, area?, description, fullData?, instantNotification? })` | Registrar alerta en el endpoint `/alert`. `level: "E" \| "W" \| "I"`. `instantNotification` por defecto `true` si `level === "E"`, `false` en otros casos (por convención del consumidor — el código no aplica el default automáticamente, lo recibe del caller). | `fetch` POST a `${publicApiUrl}/alert`. Errores van a `console.error`, no se relanzan. |
| `formatLocaleDate(inputDate, locale, options?)` | Formatea fecha YY/MM/DD → `{ date, dateTime }` con `Intl.DateTimeFormat`. | — (puro). Retorna `{ date: "Invalid Date", dateTime: "Invalid Date" }` si la fecha no parsea, y `{ date: inputDate, dateTime: "" }` si el locale no soporta `dateStyle`. |

## Utilidades

| Función | Para | Lee de |
|---|---|---|
| `getToken()` | Header `Authorization` para auth JWT. Retorna `null` fuera del navegador o si no hay localStorage. | `localStorage["persist:app"].token`. |
| `getSiteID()` | Site ID actual cuando el editor lo expone. Default: `1`. | `localStorage["persist:root"].sites.currentSiteInfo.id`. |
| `getLangFromLocalStorage()` | Language ID del editor. | `localStorage["langID"]`. |
| `concatParams({ baseUrl, params })` (interno, no exportada) | Construye `baseUrl/key/value/key/value/...` filtrando params vacíos. | — (puro). |
| `cleanPathSlashes(url)` (interno) | Quita slashes duplicados. | — (puro). |
| `isLocalStorageAvailable()` (interno) | Test de si `localStorage` se puede usar (hay navegadores donde está deshabilitado). | — |

`getToken`, `getSiteID`, `getLangFromLocalStorage` se exportan públicamente para que `@griddo/cx` y `@griddo/ax` usen el mismo formato de auth.

## Tipos exportados (no exhaustivo)

Re-exports principales del barrel:

- **Namespaces**: `Schema`, `Fields`, `Core`, `Theme`, `UIFields`, `UIFormFields`, `UITemplateFields`, `PageContentTypeFields`, `SimpleContentTypeFields`.
- **Componente props**: `ComponentProps`, `PageProps`, `PreviewProps`, `ModulePreviewProps`, `GriddoImageProps`, `GriddoImageGif`, `GriddoImageJpgWebpAvif`, `GriddoImageSvg`, `GriddoImageCommonProps`, `GriddoImagePropsExperimental` (+ los `*Experimental`), `GriddoLinkProps`, `CloudinaryImageProps`, `CloudinaryResponsiveImageProps`, `CloudinaryImageCrop`, `CloudinaryImageFormat`.
- **Hook props/return**: `UseDataFiltersReturn`, `UseDataFiltersState`, `UseDataFiltersSetQueryProps`, `UseDataFilterSetUrlAction`, `UseListSetQueryProps`, `UseListSetUrlAction`, `UseI18nProps`, `UseImageProps`, `UseGriddoImageProps`, `UseGriddoImageReturn` (+ los `*Experimental`).
- **Image config**: `ImageConfig`, `ImageChunk`, `GenerateImageChunkProps` (+ los `*Experimental`).
- **Context types**: `PageContext`, `SiteContext`, `SessionContext`, `SiteProviderProps`.
- **Globals**: `Hideable`, `HTMLHeadingTag`, `Pretty`, `PickRename`, `SetQueryProps`, `ListApiQueryResponseProps`, `FiltersDataApiQueryResponseProps`, `LinkGetProps`, `WindowLocation`, `HLocation`, `NonEmptyArray`.
- **Funciones / valores**: `getComponent`, `griddoAlertRegister`, `formatLocaleDate`, `getToken`, `getSiteID`, `getLangFromLocalStorage`.

## Lo que NO se exporta

- `<ComponentWrapper>`, `<FormWrapper>` — internos a `<Component>`.
- `useFetch` — exportado en `hooks/index.ts` pero **no** en `src/index.ts` (uso interno).
- Helpers de `hooks/utils.ts` (`getOptions`, `parseSources`, `parseRelations`, ...) — uso interno.
- Helpers de `utils/images.ts` (`getGriddoDamURIWithParams`, `getDamIdFromDamUrl`, ...) — uso interno.
- Mocks de `src/test/__mocks__/`.
- Todo lo de `bin-tools/` y `node/`.

## Convenciones de la API

- **Componentes en PascalCase**, hooks en `camelCase` con prefijo `use`, funciones standalone en `camelCase`.
- **Hooks no lanzan**. Si falta el provider o un dato, loguean `console.warn` y retornan un valor degradado.
- **Funciones de fetch (`griddoAlertRegister`)** capturan el error con `console.error` y no relanzan.
- **Aliases**: existen (`useReferenceField`, `useDistributorData`, `useAIAnswers`, `useAISearch`) — son re-exports del mismo hook con nombres legacy/alternativos. No introducir alias nuevos sin un motivo claro.

## Relacionado

- [Flujo](flujo.md) — cuándo se usan los hooks/componentes.
- [Configuración](configuracion.md) — providers que cada hook requiere.
- [Tipos y schemas](tipos-y-schemas.md) — los tipos públicos en detalle.
- Invariantes (doc interna de @griddo/core, no incluida en el plugin) — contratos por hook/componente.
- Reglas (doc interna de @griddo/core, no incluida en el plugin) — qué NO hacer al añadir API.
