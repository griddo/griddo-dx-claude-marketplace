<!-- griddo-dx-sync
GENERADO desde el monorepo griddo/griddo — NO EDITAR A MANO: el siguiente sync lo sobrescribe.
fuente:   packages/griddo-core/llms-doc/autotypes.md
monorepo: v12.8.4 @ 5cd13c2665
fecha:    2026-09-10
-->

# Autotypes — el CLI

## TL;DR

- Binario Node ejecutable: `griddo-autotypes` (`dist/autotypes.mjs`) y su variante legacy `griddo-autotypes-legacy` (`dist/autotypes.js`).
- Lee `<instancePath>/griddo.config.ts`, parsea sus schemas con **22 parsers** (uno por categoría: módulos, templates, content types, themes, ...) y escribe `<instancePath>/autotypes.d.ts`.
- El output define el tipo virtual `__AT__` que el resto de `@griddo/core` consume con `import type __AT__ from "@/autotypes"` para inyectar nombres concretos en tipos genéricos (`__AT__.Modules`, `__AT__.Themes`, etc.).
- **No tiene exit code distinto de 0 en errores de parser** — captura cualquier excepción, la loguea con `${kleur.red(" ✘")} AutoTypes` y termina sin fallar el build. Los errores de carga de config (anteriores al loop de parsers) sí salen con exit 1.
- Sin estado mutable global, sin retries, sin caché.

## Entrypoint

`src/bin-tools/autotypes/index.ts`. Es una IIFE async:

```ts
(async () => {
  try {
    const instancePath = resolveInstancePath();
    const configFile = path.join(instancePath, "griddo.config.ts");
    let config: Core.Config;
    try {
      const loadedConfig = await loadConfigTs(configFile);
      config = (loadedConfig?.default ?? loadedConfig) as Core.Config;
    } catch (err) {
      console.error("Failed to load griddo.config.ts:", err);
      process.exit(1);
    }
    // ... resto: extracción de schemas, parseSchemas, prettify, fs.writeFileSync
  } catch (e) {
    console.log(`${kleur.red(" ✘")} AutoTypes`);
    console.log(e);
  }
})();
```

### Resolución de paths

`resolveInstancePath()` (en `misc/utils.ts`) usa `packageDirectorySync` de `pkg-dir` para encontrar la raíz del paquete instancia (el primer `package.json` ascendente desde el `cwd`). Si no encuentra, lanza.

### Carga de `griddo.config.ts`

`loadConfigTs(configFile)` spawnea **`tsx`** (de `dependencies` regular del paquete) para evaluar el TS sin compilarlo a JS. Acepta tanto:

- `export default config;` → retorna `{ default: config, ... }` y el caller hace `loadedConfig.default`.
- `export = config;` o `module.exports = config;` (tras esbuild/tsc en otros formatos) → retorna directamente `config`.

El caller hace `'default' in loadedConfig ? loadedConfig.default : loadedConfig` para soportar ambas formas.

## Modelo del parser

`src/bin-tools/autotypes/parser/index.ts`:

```ts
interface Parser {
  parse(schema: unknown, config: Core.Config): string;
}

class AutoTypes {
  private parser?: Parser;
  setParser(parser: Parser) { this.parser = parser; }
  parse(schema: unknown, config: Core.Config) {
    return this.parser?.parse(schema, config) || "";
  }
}

function parseSchemas(schemaParserMap: Array<{
  schema: unknown;
  parser: new () => Parser;
  config: Core.Config;
}>) {
  const AutoTypesParser = new AutoTypes();
  return schemaParserMap.map((entry) => {
    AutoTypesParser.setParser(new entry.parser());
    return AutoTypesParser.parse(entry.schema, entry.config);
  });
}
```

Strategy pattern: una clase `AutoTypes` con un parser intercambiable. `parseSchemas` itera sobre el array de pares `(schema, parser)`, instancia el parser, lo setea, y llama `parse`. Output: array de strings TS, uno por entrada.

## Lista de parsers

`src/bin-tools/autotypes/parsers-list/`. **22 parsers** organizados por categoría:

| Parser | Schema input | Output (declaraciones) |
|---|---|---|
| `MenuItemsParser` | `config.schemas.config.menuItems` | Tipos para items de menú. |
| `LanguagesParser` | `config.schemas.config.languages` | `__AT__.SiteLanguage`, `__AT__.Locale`. |
| `UIAndDataPropsParser` | `uiSchemas` (merge de components+modules+templates+structuredData+forms) | Props derivadas de los schemas UI. |
| `SubthemesParser` | `config.schemas.config.subthemes` | `__AT__.Subthemes`. |
| `PageContentTypeParser` | `pageContentTypes` (extraídos del `structuredData`) | Tipo por cada page content type. |
| `SimpleContentTypeParser` | `simpleContentTypes` | Tipo por cada simple content type. |
| `TaxonomyParser` | `categoryContentTypes` | Tipo por cada taxonomía. |
| `ComponentsNameParser` | `config.schemas.ui.components` | `__AT__.Components` (union de nombres). |
| `ModulesNameParser` | `config.schemas.ui.modules` | `__AT__.Modules`. |
| `FormTemplatesParser` | `config.schemas.forms.templates` | `__AT__.FormTemplates`. |
| `FormFieldsParser` | `config.schemas.forms.fields` | `__AT__.FormFields`. |
| `FormCategoryNamesParser` | `config.schemas.forms.categories` | `__AT__.FormCategories`. |
| `TemplatesNameParser` | `config.schemas.ui.templates` | `__AT__.Templates`. |
| `DataTemplatesNameParser` | `config.schemas.ui.templates` | Subset de templates con data. |
| `TemplateSectionListParser` | `config.schemas.ui.templates` | `__AT__.SectionList`. |
| `ModuleCateogiresParser` | `config.schemas.config.moduleCategories` | `__AT__.ModuleCategories`. |
| `DataPacksParser` | `config.schemas.contentTypes.dataPacks` | `__AT__.Datapacks`. |
| `DataPacksCategoryParser` | `config.schemas.contentTypes.dataPacksCategories` | `__AT__.DatapackCategories`. |
| `TaxonomyPropsParser` | `categoryContentTypes` | Props (al estilo de UIAndDataPropsParser). |
| `SimpleDataPropsParser` | `simpleContentTypes` | Props. |
| `PageDataPropsParser` | `pageContentTypes` | Props. |
| `ThemesParser` | `config.schemas.config.themes` | `__AT__.Themes`. |

El orden importa: algunos parsers asumen que otros ya han ejecutado (por ejemplo, `UIAndDataPropsParser` espera que las refs a content types ya existan en el output o que el TS resuelva bien las cross-refs cuando todo se concatena).

## El `extractMergedSchemas` truco

`config.schemas.contentTypes.structuredData` mezcla los tres tipos de content type (page, simple, category). Para parserlos por separado, `misc/utils.ts::extractMergedSchemas` los desglosa en tres records distintos:

```ts
const { categoryContentTypes, pageContentTypes, simpleContentTypes } =
  extractMergedSchemas(config.schemas.contentTypes.structuredData);
```

Discriminación basada en flags del schema:

- `taxonomy: true` → `categoryContentTypes`.
- `fromPage: true` → `pageContentTypes`.
- `fromPage: false` → `simpleContentTypes`.

## El `uiSchemas` merge

`UIAndDataPropsParser` recibe un objeto que combina components + modules + templates + structuredData + forms.templates + forms.fields:

```ts
const uiSchemas = {
  ...components,
  ...modules,
  ...templates,
  ...structuredData,
  ...(forms?.templates || {}),
  ...(forms?.fields || {}),
} as Record<string, SchemaType>;
```

Esto unifica el namespace de schemas UI para emitir props derivadas en una sola pasada. Si dos schemas tienen el mismo `key`, el último gana (no hay validación). Los conflictos son problema de la instancia, no del CLI.

## Salida

```ts
const outputContent = await prettify(`
  ${head}
  ${autotypes.join("\n")}
`);

const outputFile = path.join(instancePath, "autotypes.d.ts");
fs.writeFileSync(outputFile, outputContent);

console.log(`${kleur.green(" ✔")} AutoTypes`);
```

- `head` es un comentario de cabecera ASCII (`misc/ascii.ts`) con marca de generado.
- `prettify` corre prettier (`prettier` en deps regular).
- Output overwriting: borra y re-escribe el `.d.ts`.

## Estado de errores

| Origen | Acción | Exit code |
|---|---|---|
| `resolveInstancePath` falla (no hay package.json arriba) | Lanza dentro del try externo → log "✘ AutoTypes" + log del error | 0 (sigue ejecutando si hay más, pero acaba) |
| `loadConfigTs(configFile)` falla | `console.error("Failed to load griddo.config.ts:", err)` + `process.exit(1)` | **1** |
| Parser de schemas lanza | Sale del `try` interno y entra al catch externo → log "✘ AutoTypes" | 0 |
| `prettify` falla | Igual: catch externo → log | 0 |
| `fs.writeFileSync` falla | Igual: catch externo | 0 |

### Implicación

Si un parser tiene un bug y rompe en una instancia concreta, **el build de la instancia no falla por culpa de autotypes** — solo aparece el log "✘ AutoTypes" y el `autotypes.d.ts` se queda como estaba (o no se crea). El consumidor verá errores de TS más adelante cuando algo referencie un tipo `__AT__.X` inexistente.

Esta política prioriza no bloquear builds por bugs en autotypes, pero **dificulta detectar errores en CI**. Si quieres que el build falle, encaja `griddo-autotypes && tsc` en serie (el `tsc` posterior fallará si los tipos quedaron inconsistentes).

## Variantes legacy / actual

| Bin | Output del rollup | Diferencia |
|---|---|---|
| `griddo-autotypes` | `dist/autotypes.mjs` (con shebang vía `rollup-plugin-preserve-shebang`) | Recomendado. ESM puro. |
| `griddo-autotypes-legacy` | `dist/autotypes.js` | Mismo bundle, sin shebang explícito. Mantenido para compat. |

## Tipos del CLI

`bin-tools/autotypes/misc/types.ts` define los **enums** de fields y de tipos de schema que conoce el CLI:

- `SchemaFieldTypes` — los nombres válidos de fields que un schema puede declarar (`TextField`, `ImageField`, `ReferenceField`, ...).
- `FieldReturnTypes` — el namespace `Fields.X` correspondiente para cada uno (mapping en `misc/utils.ts::returnType`).
- `SchemaType` — union de todos los schema types que el CLI sabe parsear.
- `KindSchema` — `"object" \| "component" \| "module" \| "template" \| "simpleContentType" \| "pageContentType" \| "formTemplate"`.
- `MainAutotypesProps` — el "context object" que recibirían los parsers en una versión más estructurada (no usado uniformemente todavía).

Si añades un nuevo tipo de field, **debes** registrarlo en ambos enums y en el switch de `returnType` (ver `extender.md` (doc interna de @griddo/core, no incluida en el plugin)).

## Limitaciones conocidas

- **Path alias `@/autotypes`**. La instancia debe configurar este alias en `tsconfig.json` (`"paths": { "@/autotypes": ["./autotypes.d.ts"] }`). Si no, los `import type __AT__` del paquete fallan en su `tsc`. La instancia tiene que repetir esta config — no se inyecta desde el paquete.
- **No hay watch mode**. Cada cambio de `griddo.config.ts` requiere re-ejecutar `griddo-autotypes`. La instancia puede orquestarlo con un script de su pipeline (`chokidar`/`tsx watch`).
- **No detecta cambios incrementales**. Reescribe el `.d.ts` entero cada ejecución.
- **No valida `griddo.config.ts`**. Si la config no cumple `Core.Config`, el CLI peta dentro de un parser (capturado, log "✘") y deja un `.d.ts` parcial o vacío.
- **Sin tests propios** (a fecha de escritura). Los parsers no tienen tests unitarios en `__tests__/`. Cualquier refactor mayor del CLI debe contemplar añadirlos.

## Relacionado

- [Tipos y schemas](tipos-y-schemas.md) — qué tipos consume `__AT__`.
- [Flujo](flujo.md) — cuándo se ejecuta el CLI.
- [Configuración](configuracion.md) — sufijos configurables (`AutoTypesConfig`).
- Arquitectura (doc interna de @griddo/core, no incluida en el plugin) — boundary CLI vs lib React.
- Extender (doc interna de @griddo/core, no incluida en el plugin) — añadir un parser nuevo.
- Reglas — gotchas (path alias, exit codes).
