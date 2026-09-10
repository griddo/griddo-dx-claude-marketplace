<!-- griddo-dx-sync
GENERADO desde el monorepo griddo/griddo — NO EDITAR A MANO: el siguiente sync lo sobrescribe.
fuente:   packages/griddo-core/llms-doc/configuracion.md
monorepo: v12.8.4 @ 4a5dfbd298
fecha:    2026-09-10
-->

# Configuración

## TL;DR

- `@griddo/core` requiere **React 18** como peer dep (también `react-dom`, `@types/react`, `@types/react-dom`). Node ≥ 24.12 para el binario de autotypes y los tests.
- El consumidor **debe** montar como mínimo `<SiteProvider>` antes de usar cualquier hook o componente del paquete. Sin él, los hooks loguean warnings y muchos retornan `undefined`/valores vacíos.
- `<Page>` ya monta su propio `<PageProvider>` + `<I18nProvider>`. Si renderizas a nivel de módulo (preview, AX), debes montar tú esos providers o usar `<ModulePreview>`/`<Preview>`.
- El `renderer` del `<SiteProvider>` cambia comportamiento de varios componentes y hooks. Valores válidos: `gatsby`, `editor`, `preview`, `forms`, `ssg`, `sharedPage`. Default: ninguno (los componentes asumen `gatsby`-like, sin envoltorio).
- El binario `griddo-autotypes` es **opcional** desde el punto de vista del runtime, pero **obligatorio** para que el sistema de tipos genéricos de schemas funcione (referencias `__AT__.Modules`, `__AT__.Themes`, etc.).

## Peer dependencies

```json
{
  "peerDependencies": {
    "@types/react": ">=18 <19",
    "@types/react-dom": ">=18 <19",
    "react": ">=18 <19",
    "react-dom": ">=18 <19"
  },
  "engines": { "node": ">=24.12" }
}
```

`react` y `react-dom` quedan **externals** en el bundle. Si la instancia tiene una versión distinta de React, hay riesgo de duplicar el módulo y de romper los `useContext` (cada copia crea contextos separados). El uso de `getOrCreateGlobalContext` en `@griddo/core` mitiga el caso de duplicar `@griddo/core` pero **no** mitiga duplicar React.

## Provider tree

### Mínimo viable

```tsx
import { SiteProvider, Page } from "@griddo/core";

<SiteProvider
  renderer="gatsby"
  publicApiUrl="https://api.example.com/public"
  apiUrl="https://api.example.com"
  siteId={42}
  linkComponent={GatsbyLink}
  navigate={navigate}
  siteLangs={[...]}                       // requerido por useI18n
  translations={{ es_ES: { hola: "Hola" }, ... }}  // recomendado para useI18n
  griddoDamDefaults={{ quality: 75, ... }} // recomendado para GriddoImage
>
  <Page library={...} content={...} {...} />
</SiteProvider>
```

### Si renderizas un módulo aislado (no una Page completa)

```tsx
<SiteProvider {...}>
  <PageProvider languageId={1} apiUrl={...}>
    <I18nProvider translations={...}>
      <Component libComponents={modules} component="Hero" {...heroProps} />
    </I18nProvider>
  </PageProvider>
</SiteProvider>
```

O atajo equivalente:

```tsx
<SiteProvider {...}>
  <ModulePreview library={{ components }} component="Hero" content={heroProps} />
</SiteProvider>
```

### Providers opcionales

| Provider | Para qué | Cuándo montar |
|---|---|---|
| `SessionProvider` | Estado mutable compartido entre módulos en el editor (`useSession`). | Solo si renderer es `editor`/`preview`/`forms` y un módulo necesita compartir estado. `<Component>` lo monta automáticamente en esos renderers. |
| `NavigationProvider` | Marca el árbol como navegación (header/footer) — `useNavigation` retorna `{ isNavigation: true }`. | `<Page>` lo monta para `header` y `footer`. Si haces tu propio header/footer, lo aporta él. |
| `ModulePreviewProvider` | Inyecta `languageId` para previews aislados. | `<ModulePreview>` lo monta automáticamente. |
| `FormProvider` | Marca un árbol como formulario — `useForm` retorna `{ isForm: true }`. | `<Component>` lo monta en renderer `editor` cuando `type === "formTemplate"`. |

## Variables del `<SiteProvider>`

El tipo `SiteContextProps` extiende `Site`. Lo más relevante:

| Prop | Tipo | Quién lo setea | Para qué |
|---|---|---|---|
| `renderer` | `"gatsby" \| "editor" \| "preview" \| "forms" \| "ssg" \| "sharedPage"` | El consumidor (cx, ax, ssg) | Bifurca comportamiento en `<Component>`, `<GriddoLink>`, `useReferenceFieldData`. |
| `linkComponent` | `(props: GriddoLinkProps & { to?: string }) => JSX.Element` | El consumidor (Gatsby `<Link>`, custom router, ...) | `<GriddoLink>` lo usa para links internos. Default: un `<a>` con `data-griddo="link"`. |
| `navigate` | `() => null` por defecto | El consumidor | Helper opcional usado por algún módulo para navegación programática. Default no-op. |
| `publicApiUrl` | `string` | El consumidor | Endpoint público para `useList`, `useDataFilters`. |
| `apiUrl` | `string` | El consumidor | Endpoint privado (auth con JWT) para `useReferenceFieldData`. |
| `siteId` | `number` | El consumidor | Default para queries cuando el `data` no lo trae. |
| `siteLangs` | `Array<SiteLanguage>` | El consumidor | Necesario para `useI18n` (resuelve locale ↔ languageId). |
| `translations` | `LocaleTranslations` | El consumidor | Pasa al `<I18nProvider>` interno; lo lee `useI18n`. |
| `griddoDamDefaults` | `GriddoDamDefaults` | El consumidor | Defaults globales para `<GriddoImage>` (quality, crop, formats, ...). |
| `cloudinaryDefaults` | `CloudinaryDefaults` | El consumidor | Defaults globales para `<CloudinaryImage>` (deprecated). |
| `selectEditorID`, `selectHoverEditorID`, `moduleActions` | Funciones | Solo AX (renderer `editor`) | Las usa `<ComponentWrapper>` para selección y acciones (copy/duplicate/delete) sobre módulos. |

## Variables del `<PageProvider>`

`PageProviderProps` (extiende `PageProps`). Las relevantes para hooks/componentes del paquete:

| Prop | Lo lee | Por qué |
|---|---|---|
| `apiUrl` | `useReferenceFieldData`, `useList` (override) | Endpoint privado por página. |
| `languageId` | `useI18n`, `useReferenceFieldData`, `useList`, `useDataFilters` | ID de idioma de la página. |
| `pageLanguages` | `usePage` (computa `pageLanguagesWithLivePages` y `locale`/`ISOLocale`) | Versiones por idioma. |
| `componentSchemas` | `<ComponentWrapper>` | Para mostrar `displayName` y `schemaType` en el editor. |
| `fullPath`, `fullUrl` | `<GriddoLink>` (resuelve relative-to-root), `<Link>` **deprecated** (parseAnchor) | Resolución de rutas internas. |

## Renderers

| Renderer | Quién lo setea | Efecto observable |
|---|---|---|
| `gatsby` | `@griddo/cx` | Sin envoltorios. Comportamiento "publicación final". |
| `editor` | `@griddo/ax` | `<Component>` envuelto en `<SessionProvider>` + `<ComponentWrapper>`; `<GriddoLink>` siempre abre en `_blank`; `useReferenceFieldData` activo. |
| `preview` | `@griddo/ax` (preview de página) | `<Component>` envuelto en `<SessionProvider>`; `<GriddoLink>` añade `href` para preview; `useReferenceFieldData` activo. |
| `forms` | `@griddo/ax` (formularios) | `<Component>` envuelto en `<SessionProvider>` + `<FormWrapper>`. |
| `ssg` | SSG futuro | Sin envoltorios. Equivalente a `gatsby` desde la óptica del paquete. |
| `sharedPage` | Feature de "compartir página" | `useReferenceFieldData` se activa con `authMode: "PREVIEW"` (lee `previewPageId`/`previewEntity` de `sessionStorage`). |

Si `renderer` no se setea, `<Component>` cae al branch final ("CX") y renderiza sin envoltorios. **No es error, pero conviene declararlo siempre** para evitar comportamiento ambiguo.

## Variables de entorno

`@griddo/core` no lee env vars en runtime. El binario `griddo-autotypes` tampoco — lee `griddo.config.ts` directamente.

`process.env.NODE_ENV` se reemplaza a `"production"` en el bundle de Rollup (es lo que usa React internamente).

## Configuración del binario `griddo-autotypes`

### Ejecución

```bash
griddo-autotypes
```

Se ejecuta en el `cwd` que coincide con la raíz del paquete instancia (resuelto por `pkg-dir`). Si el paquete no es resoluble como tal, falla.

### Inputs

- `griddo.config.ts` en la raíz de la instancia.
- El `default export` debe ser un `Core.Config` (o el módulo entero si no usas `default`).

### Outputs

- `autotypes.d.ts` en la raíz de la instancia, prettificado.

### Configuración interna en `griddo.config.ts`

Dentro de `config.autotypes` (`AutoTypesConfig`):

```ts
{
  interfaceSuffix: string;     // sufijo para interfaces, por defecto en código
  contentTypeSuffix: string;   // sufijo para content types
  publicApiSuffix: string;     // sufijo para tipos de la API pública
}
```

Estos sufijos los usan los parsers para nombrar interfaces. Cambiarlos modifica el shape del `autotypes.d.ts` generado y rompe compatibilidad si la instancia o sus tipos los referencian directamente.

## Bundles publicados

| Path | Formato | Para |
|---|---|---|
| `dist/index.js` | ESM | Lib React (componentes/hooks/contextos/tipos). |
| `dist/index.d.ts` | TS declarations | Tipos para consumidores. |
| `dist/autotypes.js` | ESM (legacy bin `griddo-autotypes-legacy`) | Compat hacia atrás. |
| `dist/autotypes.mjs` | ESM con shebang (bin `griddo-autotypes`) | El bin actual. |

`package.json`:

```jsonc
{
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "exports": {
    ".": { "types": "./dist/index.d.ts", "import": "./dist/index.js", "require": "./dist/index.js" }
  },
  "bin": {
    "griddo-autotypes": "dist/autotypes.mjs",
    "griddo-autotypes-legacy": "dist/autotypes.js"
  }
}
```

## Relacionado

- [Flujo](flujo.md) — cuándo y cómo se monta cada provider.
- [Superficie pública](superficie-publica.md) — qué hace cada componente/hook si el provider falta.
- [Autotypes](autotypes.md) — detalle del binario.
- Reglas — gotchas sobre providers y duplicación de React.
