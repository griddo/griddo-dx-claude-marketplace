<!-- griddo-dx-sync
GENERADO desde el monorepo griddo/griddo — NO EDITAR A MANO: el siguiente sync lo sobrescribe.
fuente:   packages/griddo-core/llms-doc/tipos-y-schemas.md
monorepo: v12.8.4 @ 4a5dfbd298
fecha:    2026-09-10
-->

# Tipos y schemas

## TL;DR

- Cuatro namespaces forman el sistema de tipos: **`Schema`** (declarativo: lo que la instancia define en `griddo.config.ts`), **`Fields`** (lo que la API responde para cada tipo de campo), **`Core`** (entidades runtime: `Page`, `Site`, `Locale`, `Config`, ...), **`Theme`** (`GriddoTheme`, `GlobalTheme`, `Primitive`).
- El tipo virtual `__AT__` (autotypes) **no vive en el paquete**: se importa desde `"@/autotypes"` (path alias resuelto en la instancia) y aporta nombres concretos: `__AT__.Modules`, `__AT__.Templates`, `__AT__.Themes`, `__AT__.DataPacks`, `__AT__.PageContentTypes`, `__AT__.SimpleContentTypes`, `__AT__.SiteLanguage["locale"]`. Sin él, los tipos que usan estos genéricos caen a `string`.
- Los **schema-fields** (`UIFields`, `UITemplateFields`, `UIFormFields`, `UIFormTemplateFields`, `PageContentTypeFields`, `SimpleContentTypeFields`) son union types de los fields permitidos en cada contexto. La pieza "base" se define en `schema-fields/base.ts`; cada namespace concreto compone con `WithHelpText`, `WithHideable`, `WithHidden`, etc. (`schema-fields/props.ts`).
- `Schema` y `Fields` son **mutuamente referenciados**: `Schema.ContentTypeModule.default.data` es un `Omit<Fields.Reference<...>, "sources" | "mode">`; `Fields.Reference<T>` aparece tanto en API responses como en defaults de schema.

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
| `Core.JsConversionOptions` | Opciones para conversión HTML → JS (relacionado con `llms` en config). |
| `Core.NavigationModule`, `Core.HeaderModule`, `Core.FooterModule` | Forma de header/footer. |
| `Core.PageIntegration` | Integraciones (analytics, addons) por página. |
| Tipos de imagen | `ImageCropType`, `ImageDecoding`, `ImageFormats`, `ImageLoading`, `ImagePosition`, `ImageTransform`, `ResponsiveImageProps`, `BackgroundImageSizesProps`, `FetchPriority`. |

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
- Reglas — gotchas con `__AT__` y compatibilidad.
- Extender (doc interna de @griddo/core, no incluida en el plugin) — añadir un Field o un Schema.
