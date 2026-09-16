<!-- griddo-dx-sync
GENERADO desde el monorepo griddo/griddo — NO EDITAR A MANO: el siguiente sync lo sobrescribe.
fuente:   packages/griddo-core/llms-doc/tipos-y-schemas.md
monorepo: v12.9.0 @ a070ba7a0d
fecha:    2026-09-16
-->

# Tipos y schemas

## TL;DR

- Cuatro namespaces forman el sistema de tipos: **`Schema`** (declarativo: lo que la instancia define en `griddo.config.ts`), **`Fields`** (lo que la API responde para cada tipo de campo), **`Core`** (entidades runtime: `Page`, `Site`, `Locale`, `Config`, ...), **`Theme`** (`GriddoTheme`, `GlobalTheme`, `Primitive`).
- El tipo virtual `__AT__` (autotypes) **no vive en el paquete**: se importa desde `"@/autotypes"` (path alias resuelto en la instancia) y aporta nombres concretos: `__AT__.Modules`, `__AT__.Templates`, `__AT__.Themes`, `__AT__.DataPacks`, `__AT__.PageContentTypes`, `__AT__.SimpleContentTypes`, `__AT__.SiteLanguage["locale"]`. Sin él, los tipos que usan estos genéricos caen a `string`.
- Los **schema-fields** (`UIFields`, `UITemplateFields`, `UIFormFields`, `UIFormTemplateFields`, `PageContentTypeFields`, `SimpleContentTypeFields`) son union types de los fields permitidos en cada contexto. La pieza "base" se define en `schema-fields/base.ts`; cada namespace concreto compone con `WithHelpText`, `WithHideable`, `WithHidden`, etc. (`schema-fields/props.ts`).
- `Schema` y `Fields` son **mutuamente referenciados**: `Schema.ContentTypeModule.default.data` es un `Omit<Fields.Reference<...>, "sources" | "mode">`; `Fields.Reference<T>` aparece tanto en API responses como en defaults de schema.
- La **superficie para asistentes de IA** (`schemas.config.llms`) agrupa por artefacto lo que la instancia decide del Markdown por página y del `llms.txt`. Esos ficheros los escribe el render, cada uno con su interruptor de entorno, así que la configuración sola no los enciende.

## Los cuatro namespaces

### `Core` — entidades runtime

`src/types/core/`. Lo que circula por el árbol de React.

Tipos clave:

| Tipo | Para |
|---|---|
| `Core.Renderers` | `"gatsby" \| "editor" \| "preview" \| "forms" \| "ssg" \| "sharedPage"`. |
| `Core.Page<ContentType?>` | El objeto Page que pasa por `<Page>` y por el `PageContext`. Incluye `id`, `title`, `template`, `header`, `footer`, `metaTitle`, `pageLanguages`, `theme`, etc. |
| `Core.Site` | Lo que pasa al `<SiteProvider>` y devuelve `useSite`: `apiUrl`, `publicApiUrl`, `siteId`, `renderer`, `linkComponent`, `siteLangs`, `translations`, `griddoDamDefaults`, ... |
| `Core.Config` | Tipo del `griddo.config.ts` que la instancia exporta. Anida `schemas.config`, `schemas.ui`, `schemas.contentTypes`, `schemas.forms`, `autotypes` (opcional). Este es el input del binario `griddo-autotypes`. |
| `Core.Locale` / `Core.ISOLocale` | Locales soportados (de `constants/locales`). `ISOLocale` reemplaza `_` por `-` (`"es_ES"` → `"es-ES"`). |
| `Core.TimeZone` | De `constants/timezone`. |
| `Core.LocaleTranslations` | `Partial<Record<Locale, Record<string, unknown>>>`. |
| `Core.LlmsConfig` | Lo que la instancia pone en `schemas.config.llms`. Agrupa por artefacto: `markdown`, `index` y `discoveryLinks`. Ver abajo. |
| `Core.LlmsMarkdownConfig` | El `markdown` de la fila anterior: `images`, `includeNav`, `linkToMarkdown`, `absoluteLinks`, `frontMatter`, `converter`. |
| `Core.LlmsIndexConfig` | El `index` de esa fila: `header` y `footer` del `llms.txt`. |
| `Core.LlmsImages` | Los tres valores de `markdown.images`: `"skip"`, `"keep"`, `"dedupe"`. |
| `Core.DeprecatedLlmsConfig` | La forma plana anterior. Griddo la sigue leyendo y avisa de cada clave que encuentra. |
| `Core.JsConversionOptions` | Opciones del conversor HTML → Markdown: `skipImages`, `stripTags`, `preprocessing`, `extractMetadata`, `debug`. |
| `Core.JsPreprocessingOptions` | El `preprocessing` de la fila anterior: `enabled`, `removeNavigation`, `removeForms`. |
| `Core.NavigationModule`, `Core.HeaderModule`, `Core.FooterModule` | Forma de header/footer. |
| `Core.PageIntegration` | Integraciones (analytics, addons) por página. |
| Tipos de imagen | `ImageCropType`, `ImageDecoding`, `ImageFormats`, `ImageLoading`, `ImagePosition`, `ImageTransform`, `ResponsiveImageProps`, `BackgroundImageSizesProps`, `FetchPriority`. |

#### `schemas.config.llms` — la superficie para asistentes de IA

El render escribe una versión en Markdown de cada página publicada, para que los asistentes de IA la lean en lugar del HTML, y un `llms.txt` por dominio que las indexa. La instancia ajusta las dos cosas desde `schemas.config.llms`, y quién los escribe es el render.

**La configuración se agrupa por artefacto**, así que la ruta de la clave dice qué fichero cambia:

```ts
llms: {
  markdown: { images: "dedupe", includeNav: true },
  index: { header: "## Sobre esta escuela\n\nTexto propio." },
  discoveryLinks: false,
}
```

##### Cómo se enciende

La configuración por sí sola no crea los ficheros. Cada uno tiene su interruptor de entorno, los pone la infra del render —no la instancia, y este paquete no los lee— y son opuestos entre sí:

| Variable | Por defecto | Qué hace |
|---|---|---|
| `GRIDDO_RENDER_ENABLED_LLM_MD` | `0` | Con `1`, el render escribe el Markdown de cada página. Sin ella no hay espejo, y lo que diga `llms.markdown` no cambia nada. |
| `GRIDDO_RENDER_DISABLE_LLMS_TXT` | `0` | Con `1`, el render deja de escribir el `llms.txt`. Este fichero sale salvo que se desactive. |

El orden para una instancia que arranca de cero:

1. Pedir a la infra del render `GRIDDO_RENDER_ENABLED_LLM_MD=1`. El `llms.txt` ya sale sin pedir nada.
2. Escribir en `schemas.config.llms` solo lo que se aparte de los valores por defecto. Sin configuración el render ya escribe los dos ficheros.
3. Pedir a infra que el CDN responda el Markdown con `X-Robots-Tag: noindex`. El render no aprovisiona el CDN ni puede consultar lo que responde.
4. Solo entonces, `discoveryLinks: true`. Mientras el anuncio esté activo sin esa cabecera, el render avisa en cada pasada: ver [El anuncio en el HTML](#el-anuncio-en-el-html).

##### `llms.markdown` — el Markdown por página

| Clave | Por defecto | Qué hace |
|---|---|---|
| `images` | `"skip"` | Qué hace con las imágenes. `"skip"` las omite, y con ellas su texto alternativo. `"keep"` las convierte todas. `"dedupe"` las convierte y colapsa la que un módulo pinta dos veces —una para escritorio y otra para móvil, alternadas por CSS— en una sola. |
| `includeNav` | `false` | Escribe al principio del fichero una sección `## Navigation` con los enlaces que la limpieza descartó. |
| `linkToMarkdown` | `true` | Apunta los enlaces internos al Markdown de la página destino. A `false`, siguen llevando a la página. |
| `absoluteLinks` | `true` | Escribe esos enlaces con su dominio delante. A `false`, quedan como ruta de raíz, igual que los escribió el CMS. |
| `frontMatter` | `true` | Abre el fichero con una cabecera YAML de metadatos. A `false`, el Markdown empieza por el contenido. |
| `converter` | ver abajo | Opciones crudas del conversor HTML → Markdown. Sustituyen a las que pasa Griddo, no se suman. La excepción es `preprocessing`, que se fusiona clave a clave. |

`llms.markdown.converter` acepta `stripTags`, `preprocessing`, `extractMetadata` y `debug`. Los valores que pone Griddo si la instancia no dice nada:

| Clave | Por defecto | Qué hace |
|---|---|---|
| `stripTags` | botones, formularios, gráficos vectoriales y contenedores embebidos | Quita esas etiquetas y conserva el texto de dentro. La lista se sustituye entera, no se amplía. |
| `preprocessing` | `{ enabled: true }` | Descarta la cabecera y la navegación con su contenido. Es la única clave que se **fusiona** con la de Griddo en vez de sustituirla: escribir `{ removeForms: true }` conserva el `enabled: true`. Antes lo apagaba, y el Markdown volvía a abrir con el menú sin que nadie lo hubiera pedido. |

Dos opciones del conversor no están aquí, y el tipo de `converter` no las admite:

- `skipImages`, porque esa decisión es de `images`.
- `codeBlockStyle`, porque de ella depende poder reconocer el código del Markdown para no reescribir los enlaces de un ejemplo. Griddo pide la valla de tildes (`~~~`); con el valor por defecto del conversor, que indenta con cuatro espacios, el código es indistinguible del tercer nivel de una lista.

Las dos se imponen **después** de lo que ponga la instancia, así que escribirlas en `converter` no hace nada.

Y `extractMetadata` no hace nada mientras `frontMatter` esté activo, porque el documento lleva una sola cabecera y gana la de Griddo.

##### `llms.index` — el `llms.txt` del dominio

| Clave | Por defecto | Qué hace |
|---|---|---|
| `header` | — | Markdown propio, entre la cabecera generada y los enlaces del `llms.txt`. |
| `footer` | — | Markdown propio, detrás de los enlaces del `llms.txt`. |

Hay un camino antiguo, un `static/llms.md` con marcas, que sigue funcionando y está desaconsejado. Ver [El texto propio del `llms.txt`](#el-texto-propio-del-llmstxt).

##### `llms.discoveryLinks`

| Clave | Por defecto | Qué hace |
|---|---|---|
| `discoveryLinks` | `false` | La página anuncia en su `<head>` su Markdown (`rel="alternate"`) y el `llms.txt` que la cubre (`rel="describedby"`). Cada enlace aparece solo si el render escribe ese fichero. |

Está apagado por defecto. El por qué, y qué hace falta para encenderlo, está en [El anuncio en el HTML](#el-anuncio-en-el-html).

##### La forma plana anterior (obsoleta)

Antes todas las claves vivían en un solo nivel, mezcladas con las del conversor. Griddo las sigue leyendo, y el render avisa de cada una que encuentra con la ruta que la sustituye. Una versión futura las retira.

| Clave obsoleta | Usa |
|---|---|
| `skipImages`, `dedupeImages` | `markdown.images` |
| `includeNav` | `markdown.includeNav` |
| `linkToMarkdown` | `markdown.linkToMarkdown` |
| `absoluteLinks` | `markdown.absoluteLinks` |
| `frontMatter` | `markdown.frontMatter` |
| `stripTags`, `preprocessing`, `extractMetadata`, `debug` | `markdown.converter.*` |
| `header`, `footer` | `index.header`, `index.footer` |

Si la instancia escribe las dos formas, gana la agrupada.

##### Los enlaces del Markdown

Un enlace a otra página llevaba al HTML, que es justo el formato que este fichero evita. Con los valores por defecto pasa a la dirección absoluta del Markdown de esa página:

```
[Ver el máster](/es/masters/gestion/)   ->   [Ver el máster](https://dominio.com/es/masters/gestion/index.md)
```

Los dos interruptores son independientes, así que hay cuatro formas posibles. Con los dos a `false` el enlace no se toca, ni siquiera su barra final.

No se reescribe lo que no lleva a una página del sitio: la imagen, el ancla, el dominio ajeno, el `mailto:` y la ruta con extensión. Un PDF no tiene versión Markdown.

##### La cabecera de metadatos

```yaml
---
title: "Máster en Gestión"
description: "Un programa de dos años."
url: "https://dominio.com/es/masters/gestion/"
locale: "es-ES"
site: "Escuela"
image: "https://dominio.com/foto.jpg"
rendered: "2026-09-08T17:15:21.338Z"
translations:
  en-GB: "https://dominio.com/en/masters/management/"
---
```

Todo sale del `<head>` de la propia página. El campo que la página no declara no se escribe, y sin ningún campo no hay cabecera.

Dos avisos:

- `rendered` es la fecha del render, no la de la última edición del contenido. Cambia en cada render aunque la página no se haya tocado.
- Mientras esta cabecera esté activa, `extractMetadata` se apaga en el conversor. Es la única opción de conversión que la instancia no impone, y evita que el fichero acabe con dos cabeceras. Para quedarse con la del conversor hay que poner `frontMatter: false`.

##### El anuncio en el HTML

Cada página escribe en su `<head>` las dos relaciones que recomienda llmstxt.org:

```html
<link rel="alternate" type="text/markdown" href="https://dominio.com/es/masters/gestion/index.md">
<link rel="describedby" type="text/plain" href="https://dominio.com/llms.txt">
```

Apuntan en sentidos opuestos, y por eso van juntas. La primera baja al Markdown de esa página. La segunda sube al índice del dominio, y desde ahí el asistente ve el resto de páginas.

El `llms.txt` es uno por dominio y vive en su raíz, así que cubre todas las páginas. No hay uno por sitio.

Viene apagado, y conviene encenderlo solo cuando el CDN responda el Markdown con `X-Robots-Tag: noindex`. Anunciar el espejo invita a un buscador a indexarlo, y ese fichero repite el contenido del HTML. Nada impide encenderlo antes —el render no puede consultar lo que responde el CDN—, pero avisa en el log de cada render mientras el anuncio del espejo esté activo.

Apagarlo no esconde el espejo, eso sí: los enlaces del `llms.txt` ya llevan a él siempre que el render lo escriba. Este interruptor cierra una de las dos puertas, así que el `noindex` es lo que de verdad zanja el contenido duplicado.

Cada relación calla por separado cuando el render no escribe ese fichero, porque el enlace llevaría a un 404. Ojo con los dos interruptores de entorno, que son opuestos: el Markdown se genera solo si se activa (`GRIDDO_RENDER_ENABLED_LLM_MD`), y el `llms.txt` se genera salvo que se desactive (`GRIDDO_RENDER_DISABLE_LLMS_TXT`).

##### El texto propio del `llms.txt`

El `llms.txt` es el índice del dominio. La instancia le añade texto suyo con dos claves:

```ts
llms: {
	index: {
		header: "Somos una universidad privada con tres campus.",
		footer: "¿Dudas? Escribe a [admisiones@dominio.com](mailto:admisiones@dominio.com).",
	},
}
```

El orden es fijo: la cabecera que genera Griddo, el `header`, los enlaces y el `footer`.

Esto sustituye al camino antiguo, un `static/llms.md` con las marcas `{{ LLMS_HEADER }}` y `{{ LLMS_PAGE_LINKS }}`. Ese fichero se sigue leyendo mientras la configuración no diga nada, y el render avisa en el log.

Conviene migrar por una razón concreta: `static/` es una carpeta que el SSG sirve desde la raíz, así que ese template **se publica**. Cualquiera puede pedir `https://dominio.com/llms.md` y leerlo con sus marcas a la vista. La configuración no se publica.

Ojo al sacar las imágenes del `skip`: el Markdown hereda el `alt` y el `title` que traiga cada una. Si el contenido tiene textos alternativos genéricos o nombres de fichero, eso es lo que leerá el asistente.

### `Fields` — respuestas de API

`src/types/api-response-fields/`. Lo que la API REST devuelve para cada tipo de campo.

Tipos clave (no exhaustivo):

| Tipo | Equivalente API |
|---|---|
| `Fields.Text` / `Fields.TextArea` / `Fields.Wysiwyg` | strings. |
| `Fields.Date` / `Fields.Time` | strings con formato. |
| `Fields.Number` | `number \| null \| ""`. |
| `Fields.Toggle` / `Fields.UniqueCheck` | boolean. |
| `Fields.Image` | objeto con `url`, `alt`, `width`, `height`, `position`, `damId`, `publicId`, ... |
| `Fields.File` | objeto con `url`, `fileName`, `fileType`, `tags`, `folder`, `contentInUse`, ... |
| `Fields.Url` | `{ href?, linkToURL?, linkTo?, newTab?, noFollow?, ... }`. Lo consume `<GriddoLink>` y el `useLink` **deprecated**. |
| `Fields.Heading<HeadingTagsType?>` | `{ content?, tag? }` (`h1`-`h6`). |
| `Fields.Reference<ContentType>` | El "data" de un `ReferenceField`. Lo consume `useReferenceFieldData`, `useList`, `useDataFilters`. Tiene `mode`, `sources`, `fixed`, `quantity`, `order`, `fullRelations`, `allLanguages`, `preferenceLanguage`, `referenceId`, `lang`, `site`, `related`. |
| `Fields.QueriedData<ContentType>` | `Array<QueriedDataItem<ContentType>>` — lo que retorna `useReferenceFieldData`. |
| `Fields.QueriedDataItem<ContentType>` | Discrimina por `__contentTypeKind`: `PageContentType<...>` o `SimpleContentType<...>`. |
| `Fields.MultiCheckSelect<Relations, FromList, RelatedContentType, FromDistributor>` | Generic de 4 ejes que cubre las variantes según el contexto donde se consume. |
| `Fields.AsyncSelect<...>`, `Fields.AsyncCheckGroup<...>` | Variantes async. |
| `Fields.Menu<IM>`, `Fields.MenuElement<IM>` | Menú con items genéricos `link`/`group`. |
| `Fields.AIReference` | `{ prompt, templates, sites, language, limit, ... }`. |

### `Schema` — declaraciones de la instancia

`src/types/schemas/`. Lo que la instancia escribe en `griddo.config.ts`.

Tipos clave:

| Tipo | Para |
|---|---|
| `Schema.Component<ComponentProps>` | UI Component. `schemaType: "component"`, `default: { component, ...props }`. |
| `Schema.Module<ModuleProps>` | UI Module. `schemaType: "module"`. |
| `Schema.MultiPageComponent` / `Schema.MultiPageModule` | Variantes con `hasGriddoMultiPage: true` y `elements` mandatorio. |
| `Schema.ContentTypeModule<...>` | Module con `data: Reference<...>` y discriminación legacy `hasDistributorData` vs nuevo `getStaticData`. |
| `Schema.Template<TemplateProps>` | `schemaType: "template"`, `type.mode: "list" \| "detail" \| ...`, `content: UITemplateFields[]`, `config: UITemplateFields[]`. |
| `Schema.ListTemplate<TemplateProps>` | Variante con `mode: "list"`, `itemsPerPage`, `activePage`. |
| `Schema.PaginatedDataTemplate<TemplateProps>` | Variante `mode: "paginated-data"`. |
| `Schema.FormTemplate` / `Schema.FormComponent` / `Schema.FormField` | Schema para formularios. |
| `Schema.PageContentType` | ContentType con `fromPage: true`, `taxonomy: false`, `schema: { templates, fields }`. |
| `Schema.SimpleContentType<ContentType>` | ContentType simple. Discriminado por `includedInPageSearch` para activar `searchMapping`. |
| `Schema.CategoryContentType` | Taxonomía. |
| `Schema.DataPack` / `Schema.DataPackCategory` | Datapacks (presets de páginas). |
| `Schema.Languages` / `Schema.LanguageEntry` | Catálogo de idiomas. |
| `Schema.Menu` / `Schema.MenuItem` / `Schema.MenuEntry` / `Schema.MenuFields` | Schema de menús (excluye `ComponentArray`/`ComponentContainer`/`ReferenceField`). |
| `Schema.Themes` / `Schema.ThemeEntry` / `Schema.ThemeElements` | Catálogo de themes con `include`/`exclude` de elementos. |
| `Schema.ModuleCategories` | Categorías para agrupar módulos en el editor. |
| `Schema.RichTextConfig` | Config del editor de rich text. |
| `Schema.AutoTypesConfig` | Sufijos para customizar el output de `griddo-autotypes`. |
| `Schema.FormCategories`, `Schema.FormTemplateCategories` | Categorías para formularios. |
| `Schema.HeaderFooter` (`Schema.Header`, `Schema.Footer`) | Componente especial de header/footer. |
| `Schema.Translations` | (legacy) ahora vive en `Site.translations`/`<I18nProvider>`. |
| `Schema.DamDefaults` | Defaults globales para imágenes DAM. |
| `Schema.Socials` | (deprecated). |

Bases compartidas en `schemas/base.ts`:

- `BaseUI` — `schemaType`, `singleInstance`, `component`, `category` (`__AT__.ModuleCategories`), `displayName`, `sectionList` (`__AT__.SectionList`), `thumbnails`.
- `BaseContentType` — `title`, `local`, `taxonomy`, `fromPage`, `editable`, `translate`, `clone`, `defaultValues`.

### `Theme` — design tokens

`src/types/theme/`. Estructura del archivo de tema declarado por la instancia.

| Tipo | Para |
|---|---|
| `Theme.GriddoTheme` | `{ global: GlobalTheme, themes: Array<Theme> }`. Es el input de los hooks `useTheme*`. |
| `Theme.GlobalTheme` | Tema global (variables `:root`). Tiene `customMedia` opcional. |
| `Theme.Theme` | Tema de site con `subthemes` opcionales. |
| `Theme.BaseTheme` | Discriminado por `preferColorScheme: true` (con `primitives.{common,light,dark}`) o `false` (array plano). |
| `Theme.Primitive` | `{ id, name, description?, values: [{ name?, cssVar, value }] }`. |
| `Theme.Primitives` | `Array<Primitive> \| { common?, light, dark }`. |

## Schema-fields — fields tipados por contexto

`src/types/schema-fields/`. Cada archivo construye union types de fields disponibles en su contexto:

| Archivo | Namespace exportado | Para |
|---|---|---|
| `base.ts` | (interno) | `BaseTextField`, `BaseImageField`, `BaseReferenceField`, ... — los tipos "puros" sin props comunes. |
| `props.ts` | (interno) | `WithHelpText`, `WithHideable`, `WithHidden`, `WithPlaceHolder`, `WithReadonly`, `WithValidators`, `WithWhiteList`, `WithSiteLanguage`, `WithComputed`, `WithRelations_AutoTypes`, `WithDataSources`, ... y tipos auxiliares (`Option`, `ThemeColors`, `ThumbnailOption`). |
| `ui-fields.ts` | `UIFields` | Fields para `Schema.Component` y `Schema.Module`. |
| `ui-template-fields.ts` | `UITemplateFields` | Fields para `Schema.Template`. Igual que UIFields pero con `WithComputed`. |
| `ui-form-fields.ts` | `UIFormFields` | Fields para `Schema.FormField`. |
| `ui-form-template-fields.ts` | `UIFormTemplateFields` | Fields para `Schema.FormTemplate`. Incluye `FormFieldArray` y `FormCategorySelect`. |
| `page-content-type-fields.ts` | `PageContentTypeFields` | Fields para `Schema.PageContentType.schema.fields`. |
| `simple-content-type-fields.ts` | `SimpleContentTypeFields` | Fields para `Schema.SimpleContentType.schema.fields`. |

Cada field es la composición `BaseXxxField & WithA & WithB & ...`. Por ejemplo:

```ts
type Select = BaseSelect & WithHelpText & WithHideable & WithPlaceHolder & WithHidden;
type AsyncSelect = BaseAsyncSelect & WithHelpText & WithHideable & WithPlaceHolder & WithHidden & WithSiteLanguage;
```

Esto permite reutilizar las decoraciones (`WithHelpText`, `WithHideable`, ...) entre contextos sin duplicarlas, y documentarlas en `props.ts` con JSDoc una sola vez.

## El "puente" `__AT__` (autotypes)

`@/autotypes` es un path alias que resuelve a `<instancePath>/autotypes.d.ts` (la instancia lo declara en su `tsconfig.json`). El paquete `@griddo/core` lo usa con `import type __AT__ from "@/autotypes"` en:

- `types/api-response-fields/index.ts` — `FormContainer<T>.template.templateType: __AT__.FormTemplates`.
- `types/schema-fields/props.ts` — `WithSource.source` discrimina entre `__AT__.PageContentTypes`/`__AT__.SimpleContentTypes`/`__AT__.TaxonomyContentTypes`. `WithWhiteList.whiteList: Array<__AT__.Modules | __AT__.Components>`. `WithTemplatesWhiteList`, `WithFormTemplatesWhiteList`, `WithFormFieldsWhiteList`, `ThemeVisualUniqueSelection`, `ThemeColors`, `ThemeFixedColors`.
- `types/schemas/base.ts` — `BaseUI.category: __AT__.ModuleCategories`, `BaseUI.sectionList: __AT__.SectionList`, `BaseUI.thumbnails: ... | Record<__AT__.Themes, Thumbnails>`.
- `types/schemas/UI.ts` — `FormField.thumbnails: ... | Record<__AT__.Themes, Thumbnails>`. `default.template.templateType: __AT__.FormTemplates`.
- `types/schemas/Themes.ts` — `ThemeEntry.value: __AT__.Themes`, `ThemeElements.datapacks: Array<__AT__.Datapacks>`, etc.

Si la instancia no genera `autotypes.d.ts`, TypeScript reporta el `@ts-expect-error` de los archivos del paquete y los tipos genéricos pierden información (caen a `string` o `any`).

## Helpers de tipo (utilities)

`src/types/utilities.ts`:

| Helper | Para |
|---|---|
| `NonEmptyArray<T>` | Tuple `[T, ...Array<T>]` — útil cuando un schema requiere al menos un elemento. |
| `DistributiveOmit<T, K>` | Omit que se distribuye sobre uniones. |
| `PartiallyRequired<T, K>` | Hace required ciertos opcionales. |
| `KeysOfUnion<T>` | Keys de cualquier miembro de una unión. |
| `ContentTypeNameOfUnion<T>` | Extrae `__contentTypeName` de una unión. |
| `Replace<S, From, To>` | Replace literal en string types. |

`src/types/global.ts`:

| Helper | Para |
|---|---|
| `Hideable<T>` | `T \| null` — para schemas que pueden ocultarse. |
| `Pretty<T>` | Identidad que fuerza al hover de TS a expandir el tipo. |
| `PickRename<T, K, R>` | Pick + rename de una key. |
| `HTMLHeadingTag` | `"h1" \| ... \| "h6"`. |
| `SetQueryProps<ContentType>` | Tipo del `setQuery` de `useList`/`useDataFilters`. |
| `ListApiQueryResponseProps`, `FiltersDataApiQueryResponseProps` | Forms de respuestas API. |
| `Category`, `CategoryGroup`, `FilterDataItem`, `FilterDataGroup`, `FilterItemFromFilterEndPoint`, `RawFilterItemFromFilterEndPoint` | Tipos para filtros. |

## Constantes

`src/types/constants/`:

| Archivo | Contiene |
|---|---|
| `locales.ts` | Array `as const` de locales soportados (`"es_ES"`, `"en_US"`, ...). Es la fuente de `Core.Locale`. |
| `timezone.ts` | Array `as const` de timezones. Es la fuente de `Core.TimeZone`. |

## Cómo se usan en la instancia

Ejemplo simplificado de un schema de módulo:

```ts
// instance/src/modules/Hero/schema.ts
import type { Schema, UIFields } from "@griddo/core";

const schema: Schema.Module<HeroProps> = {
  schemaType: "module",
  component: "Hero",
  displayName: "Hero",
  category: "Heroes",          // ← __AT__.ModuleCategories (de griddo-autotypes)
  configTabs: [{
    title: "Content",
    fields: [
      {
        type: "TextField",
        key: "title",
        title: "Title",
        helptext: "...",        // ← WithHelpText
      } satisfies UIFields,
    ],
  }],
  default: { component: "Hero", title: "Hello" },
};
```

Cuando la API devuelve datos para ese módulo, vienen tipados como:

```ts
// CX render (gatsby renderer):
const props: HeroProps = {
  component: "Hero",
  title: "Hello",       // ← Fields.Text
  // ...
};
```

## Relacionado

- [Flujo](flujo.md) — cuándo se cargan los tipos (build vs runtime).
- [Autotypes](autotypes.md) — cómo se genera `__AT__`.
- [Superficie pública](superficie-publica.md) — qué namespaces están expuestos.
- Invariantes (doc interna de @griddo/core, no incluida en el plugin) — contratos por componente, hook y función.
- Extender (doc interna de @griddo/core, no incluida en el plugin) — añadir un Field o un Schema.
