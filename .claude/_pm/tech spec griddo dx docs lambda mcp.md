# Griddo DX Docs MCP — Especificación técnica (edición Lambda)

**Versión:** 2.0
**Fecha:** 8 de septiembre de 2026
**Autor:** Dani Serrano (con Claude Code)
**Estado:** Propuesta, sustituye a `Tech Spec Griddo DX docs mcp.md` (v1.0)
**Endpoint:** `https://dx.mcp.griddo.io/mcp`

Esta edición reescribe la v1.0 incorporando lo aprendido al llevar a producción el MCP de
Author Experience (`https://ax.mcp.griddo.io/mcp`, repo `griddo-ax-docs`, 2026-09-08). Lo que
la v1.0 acertó se conserva: contrato de dos tools, eval set con puerta de recall, visibilidad
por documento, coexistencia con AX. Lo que cambia es la infraestructura (Lambda en vez de App
Runner, con módulo Terraform ya probado), el buscador (léxico primero, denso solo si el eval
lo exige), la fuente del corpus (parametrizada, no fijada al monorepo) y una lista larga de
detalles de protocolo y operación que solo se descubren desplegando.

---

## 0. La decisión que no hace falta tomar todavía

No está decidido si la documentación de developer vivirá en este repo (las `references` del
plugin `griddo-dx`) o en el monorepo de Griddo. **Esta spec no depende de esa decisión.**

La frontera entre "corpus" y "servidor" es un único artefacto, el índice JSON, que un pipeline
de CI construye y deja en un bucket. El servidor solo sabe leer ese artefacto por una URL. Así:

| Pieza | Depende del repo del corpus | Dónde vive |
|---|---|---|
| Servidor MCP (Lambda), infraestructura, CI de despliegue, tests de protocolo | No | Este repo (`server/`, `terraform/`) |
| Página de instalación, `.mcp.json` del plugin, registro | No | Este repo (plugin) |
| Constructor del índice (`build-index`), linter de frontmatter, eval set | **Sí, solo en dónde se ejecuta** | El repo que tenga el corpus |
| Contrato del índice (formato v2, §6) | No: es el contrato entre ambos | Este documento |

Las dos variantes se describen en §5.5. La recomendación por defecto es **empezar con el
corpus en este repo**, que es donde está hoy y donde se mantiene, y mover la carpeta de
contenido y el workflow de índice al monorepo cuando exista, sin tocar el servidor.

---

## 1. Resumen ejecutivo

### Qué construimos

Un servidor MCP remoto, público y de solo lectura, que expone la documentación de developer
de Griddo a cualquier agente (Claude Code, Claude, Cursor, VS Code, Codex, Windsurf, ChatGPT).
Dos tools: buscar fragmentos con su URL y leer un documento completo. Corre en una Lambda sin
dependencias detrás de CloudFront, con el mismo módulo de infraestructura que AX.

### Por qué

Los developers de instancia (agencias partner y equipo interno) trabajan con agentes que no
conocen Griddo o lo conocen mal. El plugin `griddo-dx` solo alcanza a Claude Code y a Cowork.
El MCP cubre el resto de clientes con el corpus completo y siempre fresco.

### Qué NO construimos

| Fuera de alcance | Por qué |
|---|---|
| Chatbot o motor de respuestas | El modelo del cliente redacta; nosotros recuperamos |
| Base de datos vectorial | El corpus es 1 MB; cabe en memoria |
| Embeddings en v1 | Se añaden solo si el eval set falla en inglés (§7.4) |
| Escritura | Ninguna tool muta nada |
| Autenticación en v1 | El corpus público no la necesita; la pasarela a OAuth se diseña desde el día 1 (§10.5) |
| WAF | La concurrencia reservada acota el coste; el WAF cuesta más que el servicio |

### Reparto con el plugin `griddo-dx`

- **Plugin = conocimiento procedimental.** Cómo scaffoldear un módulo, cómo revisar un schema.
- **MCP = conocimiento declarativo.** Qué props acepta `GriddoImageExp`, qué devuelve un endpoint.
- El plugin declara el MCP en su `.mcp.json`: instalar el plugin conecta el servidor (§11.2).
- Las `references` de las skills son hoy el corpus. En cuanto el MCP esté vivo, las skills dejan
  de duplicarlas y pasan a instruir al agente para consultarlo (§5.4).

---

## 2. Decisiones

| # | Decisión | Valor |
|---|---|---|
| D1 | Acceso v1 | Público sin auth. OAuth en v1.2 sobre la misma URL. |
| D2 | Hosting | **Lambda + Function URL + CloudFront**, módulo Terraform de `griddo-ax-docs`. No App Runner. |
| D3 | Protocolo | Implementación propia sin dependencias, dual (handshake legacy + revisión 2026-07-28), reutilizada de AX. Sin SDK. |
| D4 | Retrieval v1 | BM25 sobre chunks con expansión por prefijo, prefijo común e idf por grupo, más glosario ES↔EN. Denso solo si el eval lo exige. |
| D5 | Dominio | `dx.mcp.griddo.io`, esquema `<superficie>.mcp.griddo.io`, distribución CloudFront propia. |
| D6 | Índice | Un artefacto JSON por nivel de visibilidad, en un bucket **privado**; la Lambda lo lee con su rol IAM. |
| D7 | Corpus | Parametrizado (§0). Por defecto, este repo. |
| D8 | Idioma de metadatos | Nombres, descripciones e `instructions` de las tools en **inglés**; contenido en el idioma del corpus (español). |
| D9 | Frontera con AX | Nombres de servidor y tools disjuntos y descripciones con frontera explícita en los dos servidores (§8.4). |

### 2.1 Por qué Lambda y no App Runner

App Runner mantiene una instancia encendida: entre 15 y 50 dólares al mes según uso, más WAF.
La Lambda de AX cuesta céntimos, arranca en frío en menos de medio segundo porque no lleva
dependencias, y su módulo Terraform ya existe, está aplicado y resuelve dos problemas que
costaron horas:

- **OAC no sirve para MCP.** CloudFront exige que el cliente envíe `x-amz-content-sha256` en
  cada `POST` a una Function URL con OAC. Los clientes MCP no lo hacen. El módulo usa Function
  URL con `authorization_type = NONE` y una cabecera secreta de origen que CloudFront inyecta y
  la Lambda valida en tiempo constante.
- **Dos permisos, no uno.** Las Function URL creadas desde octubre de 2025 exigen
  `lambda:InvokeFunctionUrl` y además `lambda:InvokeFunction` con la condición
  `lambda:InvokedViaFunctionUrl`. Con uno solo, 403 `AccessDeniedException` antes de ejecutar
  nada, incluso con peticiones firmadas. El argumento `invoked_via_function_url` requiere el
  provider `aws` 6.x.

### 2.2 Por qué protocolo propio y no el SDK

El MCP de AX implementa el protocolo en 27 KB sin dependencias, con 103 tests de protocolo y
probado con Claude Code 2.1 (que ya negocia la revisión 2026-07-28), curl y el smoke test. Este
servidor tiene el mismo perfil: solo tools, sin resources ni prompts, sin sesiones. Reutilizar
esa capa da: arranque en frío mínimo, cero dependencias que auditar, y una sola implementación
que mantener para los dos MCP de documentación. Si algún día hacen falta resources o prompts,
ese es el momento de pasar al SDK, no antes.

**Forma de reutilización:** extraer `mcp/lambda/{http,handler,format}.mjs` de `griddo-ax-docs`
a un paquete `@griddo/mcp-lambda-core` (repo propio en la organización, publicado en GitHub
Packages) y que ambos repos dependan de él. Si el paquete retrasa el arranque, copiar los
ficheros anotando el commit de origen y extraer en la Fase 4.

---

## 3. Visibilidad del contenido (bloqueante, y con una contradicción que resolver)

El corpus actual incluye la **API Privada** (`griddo-api/references/api-private-*.md`, 632 KB)
y guías de arquitectura interna. La v1.0 propone protegerlos tras OAuth. Pero el repo
`griddo/griddo-dx-claude-marketplace` **es público en GitHub y ya contiene esos ficheros**.
Protegerlos en el MCP mientras siguen clonables no protege nada.

Hay que elegir antes de la Fase 1 (decisión O2):

| Opción | Consecuencia |
|---|---|
| **A. La API Privada es pública de facto** | Todo el corpus actual es `public`. Se simplifica: un solo índice, sin OAuth en el horizonte cercano. `internal` queda para lo que aún no está en el repo. |
| **B. El repo pasa a privado** | El marketplace se instala con credenciales de GitHub (Claude Code lo admite). El MCP nace con OAuth para el índice `partner`, o publica solo `public` hasta que llegue. Más trabajo, más control. |

En ambos casos se mantiene el mecanismo: cada documento declara `visibility` en frontmatter,
el default cuando falta es `internal`, el linter falla si falta, y un test de CI comprueba que
`index-public.json` no contiene ningún documento `partner` o `internal`. Es barato y evita el
accidente aunque hoy la distinción sea nominal.

---

## 4. Arquitectura

```
┌──────────────────────────────────────────────────────────────────────────┐
│ CORPUS (este repo o el monorepo, §5.5)                                   │
│   docs/**/*.md con frontmatter (visibility, source_url, type, tags)      │
│   glosario ES↔EN · eval/queries.jsonl                                    │
└───────────────┬──────────────────────────────────────────────────────────┘
                │ push a main (paths: docs/**)  →  workflow build-index
                ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ BUILD (GitHub Actions, rol OIDC "index" con s3:PutObject)                │
│   lint frontmatter → chunking por H2 → tf/df por chunk → index-*.json    │
│   check-index (formato, visibilidad, URLs, tamaño) → eval recall@5       │
│   aws s3 cp → s3://griddo-dx-docs-index/{public,partner}/index.json      │
└───────────────┬──────────────────────────────────────────────────────────┘
                │ la Lambda relee el índice cada 5 min (ETag)               
                ▼
┌──────────────────────────────────────────────────────────────────────────┐
│ SERVE                                                                    │
│   CloudFront dx.mcp.griddo.io (cert ACM, A/AAAA, CORS, noindex)          │
│     └─ default behavior → Function URL + header X-Origin-Verify          │
│   Lambda griddo-dx-docs-mcp (nodejs24.x, arm64, 512 MB, 10 s, conc. 10) │
│     ├─ /mcp → protocolo dual (initialize legacy · _meta 2026-07-28)      │
│     ├─ GET / → 302 a la página de instalación · resto → 404 JSON         │
│     ├─ tools: search_griddo_dev_docs · get_griddo_dev_doc                │
│     └─ índice en memoria, leído de S3 con el rol IAM (sin secretos)      │
└───────────────┬──────────────────────────────────────────────────────────┘
                │ una línea JSON por POST → CloudWatch (métricas, dashboard)
                ▼
  Claude Code · Claude · Cursor · VS Code · Codex · Windsurf · ChatGPT
```

**Principio rector, heredado de la v1.0 y confirmado en AX:** el servidor es una carcasa fina.
Todo el valor está en el índice y en el pipeline que lo mantiene fresco. Publicar contenido
nunca redespliega la Lambda.

### Diferencias con el MCP de AX

| | AX | DX |
|---|---|---|
| Unidad del índice | Página completa | **Chunk por H2** con breadcrumb; el documento completo se conserva para `get` |
| Origen del índice | Público en el sitio de docs (`/mcp-index.json`) | **Bucket privado**, lectura con rol IAM (`s3://`) |
| Idiomas del corpus | es + en | Solo es; consultas en en → glosario |
| Visibilidad | No aplica | `public` / `partner` / `internal` |
| Tools | 3 (con `list`) | 2 en v1 (`list` en v1.1) |

---

## 5. Corpus y pipeline

### 5.1 Estado real del corpus (medido el 2026-09-08)

- 10 skills, 35 ficheros de `references`, **1,04 MB** de Markdown en español.
- Ficheros muy desiguales: `api-private-crud.md` 240 KB y 195 H2; `thumbnails-editor.md` 4 KB sin H2.
- Sin frontmatter en las `references`.
- **87 enlaces relativos** de la exportación de Notion, rotos (`../../../Guías y tutoriales/AI Search 7b46….md`).
- Marcadores `[REDACTED]` de credenciales retiradas (50 apariciones): el índice debe servirlos tal cual, pero el linter debe avisar si aparecen fuera de bloques de código.

### 5.2 Esquema de frontmatter

| Campo | Tipo | Obligatorio | Notas |
|---|---|---|---|
| `title` | string | Sí | |
| `section` | string | Sí | Ruta jerárquica: `building-blocks/hooks`, `api/private` |
| `type` | enum | Sí | `reference` · `guide` · `tutorial` · `concept` |
| `visibility` | enum | Sí | `public` · `partner` · `internal`. Falta → `internal` |
| `source_url` | string | Sí | URL pública resoluble (§5.3) |
| `tags` | string[] | No | Boost léxico (peso de campo ×2) |
| `deprecated` | boolean | No | Penalización ×0,7 en el ranking |
| `searchable` | boolean | No | `false` = entra en `get`, no en `search` (para páginas de orientación o instalación) |

### 5.3 `source_url`: tres destinos posibles, por orden de preferencia

1. **Sitio Starlight `dx.griddo.io`** con el mismo patrón que `docs.griddo.io`: anclas estables
   por H2, slugs derivados del path, espejo `.md` por página. Hoy `dx.griddo.io` es un bucket S3
   de 2021 solo por HTTP: hay que construirlo (decisión O3). Si se hace, el índice puede
   validarse contra su `sitemap-0.xml` como en AX.
2. **GitHub**, mientras no exista el sitio: `https://github.com/griddo/griddo-dx-claude-marketplace/blob/main/<path>#<ancla>`.
   Funciona porque el repo es público (si deja de serlo, deja de funcionar).
3. **Sin URL** no se publica: el linter lo impide.

El constructor genera `source_url` a partir de `section` + slug del fichero + ancla del H2.
No hay tabla de mapeo aparte.

### 5.4 Normalización previa (Fase 1, una jornada)

- Añadir frontmatter a los 35 ficheros. Un script preclasifica `visibility` por carpeta
  (`api-private-*` → `partner`, el resto → `public`) y una persona revisa.
- Reparar o eliminar los 87 enlaces de Notion. Los que apunten a documentos del corpus se
  reescriben a `source_url`; el resto se convierten en texto plano.
- Partir los ficheros gigantes por tema (`api-private-crud.md` en uno por entidad). El
  chunking lo haría igual, pero `get_griddo_dev_doc` devolvería 240 KB.
- Mover las `references` a una carpeta `docs/` que es el corpus, y dejar en cada `SKILL.md`
  la capa procedimental con enlaces a `docs/`. Una sola copia del contenido; el plugin sigue
  funcionando sin el MCP porque `docs/` se distribuye con él.

### 5.5 Las dos variantes de ubicación del corpus

| | **A. Corpus en este repo (por defecto)** | **B. Corpus en el monorepo** |
|---|---|---|
| `docs/**` | `plugins/griddo-dx/docs/` | `monorepo-griddo/docs/` |
| Workflow `build-index.yml` | Aquí, `paths: ['plugins/griddo-dx/docs/**']` | Allí, `paths: ['docs/**']` |
| Rol OIDC de índice | Trust acotado a este repo y `refs/heads/main` | Trust acotado al monorepo |
| `scripts/build-index.mjs`, `check-index.mjs`, linter, eval | Aquí | Se mueven allí (o se publican como paquete y el monorepo los consume) |
| Servidor, Terraform, deploy de la Lambda, página, `.mcp.json`, registro | Aquí | **Aquí, sin cambios** |
| Cómo se migra de A a B | `git mv` de `docs/` y del workflow, nuevo trust en el rol de índice | Un PR en cada repo |

El contrato entre ambos es el formato del índice (§6). Mientras se respete, el servidor no
sabe ni le importa de dónde salió el artefacto.

### 5.6 Chunking

1. Cortar por H2. Un H2 = un chunk candidato. Los H1 dan el título del documento.
2. Nunca partir un bloque de código ni una tabla. Si exceden el objetivo, el chunk crece.
3. Prefijar cada chunk con su breadcrumb: `# Building blocks > Hooks\n## useGriddoImage`.
4. Objetivo 300–800 tokens. Por debajo de 150 se fusiona con el hermano siguiente; por encima
   de 1.200 se subdivide por H3.
5. Sin solape. El breadcrumb da el contexto.
6. Cada chunk conserva su ancla (slug del H2, con el mismo algoritmo que el sitio) para
   componer `source_url#ancla`.

Volumen esperado: 1.500–2.500 chunks.

### 5.7 Workflow `build-index.yml`

```yaml
name: build-docs-index
on:
  push:
    branches: [main]
    paths: ['plugins/griddo-dx/docs/**', 'scripts/index/**', 'eval/**']   # variante A
  workflow_dispatch:
permissions: { contents: read, id-token: write }
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 24, cache: npm }
      - run: npm ci
      - run: npm run docs:lint          # frontmatter, visibility, source_url, enlaces, REDACTED fuera de código
      - run: npm run docs:build-index   # dist/index/{public,partner}/index.json
      - run: npm run docs:check-index   # formato v2, 0 fugas, URLs, tamaño < 10 MB
      - run: npm run docs:eval          # recall@5 ≥ umbrales de §12; falla el job si no
      - uses: aws-actions/configure-aws-credentials@v4
        with: { role-to-assume: ${{ vars.AWS_DX_INDEX_ROLE_ARN }}, aws-region: eu-south-2 }
      - run: aws s3 cp dist/index/public/index.json  s3://griddo-dx-docs-index/public/index.json
      - run: aws s3 cp dist/index/partner/index.json s3://griddo-dx-docs-index/partner/index.json
      - run: aws s3 cp dist/index/ s3://griddo-dx-docs-index/by-commit/${{ github.sha }}/ --recursive
```

El rol de índice solo puede `s3:PutObject` en ese bucket. No toca la Lambda: la función relee
el objeto por ETag en menos de 5 minutos (§9.3). **Cero despliegues por edición de contenido**,
la propiedad que gobierna el diseño en AX y aquí.

---

## 6. Formato del índice (v2, contrato entre corpus y servidor)

```jsonc
{
  "version": 2,
  "generatedAt": "2026-09-08T12:00:00.000Z",
  "corpus": { "repo": "griddo/griddo-dx-claude-marketplace", "commit": "a3f21bc" },
  "visibility": "public",                     // nivel máximo incluido en este artefacto
  "site": "https://dx.griddo.io",             // o la base de GitHub (§5.3)
  "sections": [ { "id": "building-blocks", "label": "Building blocks" }, … ],
  "glossary": { "module": ["modulo"], "template": ["plantilla"], … },   // ES↔EN (§7.3)
  "stats": { "docCount": 48, "chunkCount": 1900, "avgdl": 210.4, "df": { "imagen": 120 } },
  "docs": [
    {
      "id": "building-blocks/hooks/use-griddo-image",
      "url": "https://dx.griddo.io/building-blocks/hooks/use-griddo-image/",
      "section": "building-blocks/hooks",
      "type": "reference",
      "visibility": "public",
      "deprecated": false,
      "searchable": true,
      "title": "useGriddoImage",
      "tags": ["hook", "image"],
      "body": "…markdown completo con URLs absolutas…",
      "chunks": ["building-blocks/hooks/use-griddo-image#uso-basico", …]
    }
  ],
  "chunks": [
    {
      "id": "building-blocks/hooks/use-griddo-image#uso-basico",
      "doc": "building-blocks/hooks/use-griddo-image",
      "breadcrumb": "Building blocks > Hooks",
      "heading": "Uso básico",
      "url": "https://dx.griddo.io/building-blocks/hooks/use-griddo-image/#uso-basico",
      "content": "# Building blocks > Hooks\n## useGriddoImage — Uso básico\n\n…",
      "dl": 214,
      "tf": { "imagen": 9, "srcset": 4, "usegriddoimage": 6 }
    }
  ]
}
```

- `tf` va ponderado por campo al construir: título del documento ×6, breadcrumb y heading ×3,
  `tags` ×2, contenido ×1. `df`, `avgdl` y `chunkCount` son globales (un solo idioma).
- `df` y `tf` con claves ordenadas: JSON determinista, diffs legibles.
- Guardarraíl: el build falla por encima de **10 MB**. Se esperan 3–4 MB.
- Lectura defensiva en el servidor: `Object.hasOwn` en todo acceso a `tf`/`df` por clave de
  usuario. En AX, la consulta «constructor» devolvía cero resultados por leer
  `Object.prototype.constructor`.

---

## 7. Recuperación

### 7.1 Tokenizador (compartido, un solo fichero)

Minúsculas → NFD → quitar diacríticos conservando la `ñ` → partir por `[^\p{L}\p{N}\p{M}]` →
descartar tokens de menos de 2 caracteres → stopwords es/en (lista corta, sin palabras de
dominio: `estado`, `pagina`, `modulo` no son stopwords). Mismo fichero al indexar y al
consultar; el bundle de la Lambda lo incrusta. Nunca se construye una RegExp con texto del
usuario.

### 7.2 Ranking BM25 sobre chunks

`k1 = 1.2`, `b = 0.75`. Cada término de la consulta forma un **grupo**: el término exacto
(peso 1) más sus variantes del diccionario (peso 0,6, máximo 25, por df descendente):

- **Expansión por prefijo:** término de ≥ 4 caracteres y variante que empieza por él
  (`public` → `publicar`, `publicacion`).
- **Prefijo común:** término de ≥ 6 caracteres y variante con prefijo común ≥ max(5, len − 2)
  (`imagenes` ↔ `imagen`; `publico` ↔ `publicacion`). Cubre la morfología cuando la consulta
  es la forma larga.
- **Idf de grupo:** se calcula sobre los chunks que contienen el término o cualquier variante y
  se aplica al grupo entero. Evita que una variante rara infle un chunk por casualidad.

Desempate: `dl` menor, después orden del corpus. Penalización ×0,7 a `deprecated`. Filtro
opcional por `section`. Los chunks de documentos `searchable: false` se excluyen.

Este ranking cumplió los criterios de AX (consultas en español e inglés contra un corpus
bilingüe) sin dependencias.

### 7.3 La brecha de idioma y el glosario

El corpus es español; muchas consultas llegan en inglés. Dos hechos juegan a favor:

- Los identificadores son neutros al idioma y son lo que más buscan los developers:
  `useGriddoImage`, `configTabs`, `ComponentArray`, `POST /pages`. BM25 los clava.
- El vocabulario conceptual de Griddo es finito: módulo, plantilla, campo, esquema, contenido,
  página, imagen, publicar, sitio, instancia, componente, hook…

Se añade un **glosario ES↔EN** curado (`docs/glossary.json`, 100–200 entradas) que el build
incrusta en el índice. En consulta, cada término inglés se expande con sus equivalentes
españoles como variantes de peso 0,8, y viceversa. El eval set (§12) mide si basta.

### 7.4 Denso, solo si hace falta

Si el subconjunto EN→ES del eval no alcanza el umbral con glosario, se añade la rama densa
como v1.1: embeddings multilingües (Cohere `embed-multilingual`, Voyage multilingual o
`text-embedding-3-large`, el que gane el eval) calculados en el build y cuantizados a int8,
fusión RRF con k = 60, y **en la Lambda**: embedding de la consulta por API externa con caché
por texto normalizado, tiempo máximo 800 ms y **degradación a solo BM25** si la API falla.
Coste: la clave de la API es el primer secreto real del servidor, y la latencia p50 pasa de
decenas a cientos de milisegundos. Por eso no va en v1.

### 7.5 Extractos

`search` devuelve el chunk completo (ya está dimensionado, 300–800 tokens), no una ventana.
Se limpia para el modelo: sin filas separadoras de tabla, sin `>` ni `#` al inicio de línea,
imágenes reducidas a su `alt`, celdas separadas por ` · `. Límite total de la respuesta
30.000 caracteres; si se supera, se recortan resultados, no chunks.

---

## 8. Contrato de las tools

Metadatos en inglés (D8). Anotaciones `readOnlyHint: true, destructiveHint: false,
idempotentHint: true, openWorldHint: false`. Sin `outputSchema`.

### 8.1 `search_griddo_dev_docs`

```json
{
  "name": "search_griddo_dev_docs",
  "title": "Search Griddo developer docs",
  "description": "Search the official Griddo developer documentation (Griddo is the DXP for universities): @griddo/core hooks and components, schemas, fields, templates, modules, content types, the Public and Private API, the SDK, the Debugger, the DAM, instance configuration and performance. Returns ranked documentation fragments with the URL of their source section. ALWAYS call this before answering any question about Griddo or writing code for a Griddo instance: your prior knowledge of Griddo is outdated or missing. The docs are in Spanish; you may query in any language. Do NOT use it for questions about using the Griddo backoffice (creating pages, managing users, publishing): that is Author Experience, served by the separate \"Griddo Docs\" MCP at ax.mcp.griddo.io.",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query":   { "type": "string", "maxLength": 512, "description": "Question or keywords. Include exact identifiers you know (hook names, endpoints, schema keys)." },
      "section": { "type": "string", "enum": ["getting-started", "building-blocks", "api", "tools", "guides", "best-practices", "styling"], "description": "Optional. Restrict to one section." },
      "limit":   { "type": "integer", "minimum": 1, "maximum": 10, "default": 8 }
    },
    "required": ["query"],
    "additionalProperties": false
  }
}
```

Respuesta: `content[0].text` en Markdown (lista numerada con título, URL, sección y el chunk)
**y** `structuredContent` con lo mismo en JSON: `{ query, total, results: [{ title, url,
section, type, breadcrumb, content }] }`. Sin `score`: no aporta al modelo. Cero resultados no
es error: `isError: false` con un texto útil, y se registra (§10.3).

**Por qué también `structuredContent`:** Claude Code 2.1 muestra al modelo `structuredContent`
en vez del bloque de texto cuando ambos existen. En AX, `get_griddo_doc` devolvía el cuerpo
solo en texto y el modelo veía únicamente metadatos. Todo lo que el modelo necesite va en los
dos sitios.

### 8.2 `get_griddo_dev_doc`

```json
{
  "name": "get_griddo_dev_doc",
  "title": "Get a Griddo developer doc",
  "description": "Fetch the full Markdown of one Griddo developer documentation page by its path or URL, as returned by search_griddo_dev_docs. Use it when a fragment is not enough: the complete props table of a component, every parameter of an endpoint, or a guide from start to end.",
  "inputSchema": {
    "type": "object",
    "properties": {
      "path": { "type": "string", "maxLength": 512, "description": "Document path, e.g. 'building-blocks/hooks/use-griddo-image'. A leading slash, a trailing slash, a '#anchor' or the full URL are all accepted." }
    },
    "required": ["path"],
    "additionalProperties": false
  }
}
```

Normalización tolerante (con o sin barras, con URL absoluta del sitio o de GitHub, con ancla:
si trae ancla, se devuelve solo esa sección). No encontrado → `isError: true` con las tres
rutas más cercanas por distancia de edición. Documento de más de 40.000 caracteres →
truncado con aviso y sugerencia de pedir una ancla. `structuredContent` incluye `markdown`
(el mismo texto), `url`, `section`, `type`, `deprecated`.

### 8.3 Validación de argumentos

Errores de validación (propiedad desconocida, `query` vacía o de más de 512 puntos de código,
`limit` fuera de 1–10, `section` fuera del enum) → **tool error** (`isError: true`) con un
mensaje que nombra el campo, para que el modelo se corrija. Herramienta desconocida o
`arguments` que no es objeto → JSON-RPC `-32602`. Longitudes en puntos de código, no en
unidades UTF-16: el `maxLength` publicado es JSON Schema.

### 8.4 Coexistencia con AX (renombrado de AX hecho el 2026-09-08)

| Capa | AX | DX |
|---|---|---|
| Nombre de servidor | `griddo-ax-docs` (title «Griddo Docs») | `griddo-dx-docs` (title «Griddo DX Docs») |
| Tool de búsqueda | `search_griddo_editor_docs` | `search_griddo_dev_docs` |
| Tool de documento | `get_griddo_editor_doc` | `get_griddo_dev_doc` |
| Frontera en la descripción | "Not for developer questions… use Griddo DX Docs" | "Not for backoffice usage… use Griddo Docs" |

El renombrado de AX está hecho (PR #11 de `griddo-ax-docs`, 2026-09-08), con la frontera
simétrica en sus descripciones e `instructions`. El eval set incluye 5 consultas fronterizas
(«cómo publico una página en Griddo») con los dos servidores conectados a la vez.

### 8.5 `instructions` del servidor (inglés, ≤ 600 caracteres)

Qué es Griddo y qué construyen los developers (`@griddo/core`, hooks, componentes, schemas,
plantillas, módulos), consultar siempre antes de responder o escribir código, citar
`source_url`, decir abiertamente cuando no hay resultado en vez de inferir de otros
frameworks, y que este servidor cubre solo Developer Experience.

### 8.6 Diferidas a v1.1

`list_griddo_dev_docs` (mapa de secciones; en AX se implementó y el cliente real no la usó en
las pruebas) y `report_griddo_dev_docs_gap` (el log de cero resultados ya da la señal sin
exponer una tool de escritura).

---

## 9. Servidor

### 9.1 Estructura (variante A; en la B, `docs/`, `scripts/index/` y `eval/` se van al monorepo)

```
griddo-dx-marketplace/
├── plugins/griddo-dx/
│   ├── .mcp.json                     # conecta el MCP al instalar el plugin (§11.2)
│   ├── docs/**/*.md                  # CORPUS (antes skills/*/references)
│   ├── docs/glossary.json
│   └── skills/*/SKILL.md             # capa procedimental, enlaza a docs/
├── scripts/index/
│   ├── lint.mjs                      # frontmatter, visibility, source_url, enlaces, REDACTED
│   ├── build-index.mjs               # chunking + tf/df → dist/index/{public,partner}/index.json
│   ├── check-index.mjs               # formato v2, 0 fugas, URLs resolubles, tamaño
│   └── eval.mjs                      # recall@5 sobre eval/queries.jsonl
├── eval/queries.jsonl                # 50 consultas con documentos esperados
├── server/
│   ├── lib/mcp-tokenize.mjs · mcp-stopwords.mjs · mcp-search.mjs   # compartidos con build
│   ├── lambda/http.mjs · handler.mjs · format.mjs · build.mjs · local.mjs
│   ├── lambda/tools.mjs              # las dos tools de §8
│   └── test/protocol.test.mjs · search.test.mjs · smoke.mjs · fixtures/mini-index.json
├── terraform/                        # módulo de griddo-ax-docs parametrizado (§9.4)
└── .github/workflows/build-index.yml · deploy-mcp.yml · release.yml
```

### 9.2 Comportamiento HTTP (idéntico a AX, probado)

- `OPTIONS` → 204 con CORS. Cabeceras comunes en toda respuesta: `Access-Control-Allow-Origin: *`,
  `X-Robots-Tag: noindex`, `Cache-Control: no-store`.
- Cabecera `X-Origin-Verify` obligatoria salvo en `OPTIONS`; comparación en tiempo constante; 403 si falta.
- `/mcp` (y `/mcp/`): `POST` → protocolo; otros verbos → 405 con `Allow: POST, OPTIONS` y un
  JSON legible que enlaza la página de instalación.
- `GET|HEAD /` → 302 a la página de instalación. Cualquier otra ruta o verbo → 404 JSON con el
  endpoint correcto. CloudFront manda todo el host a la Lambda; ella enruta.
- Cuerpo > 64 KB → 400 `-32600`. JSON inválido → 400 `-32700`. Lote (array) → 400 `-32600`.
  Notificación (sin `id`) → 202 vacío. Respuesta de cliente → 202.
- **Era legacy** (`initialize`): se acepta y devuelve cualquiera de `2025-03-26`, `2025-06-18`,
  `2025-11-25`, `2026-07-28`; otra cosa → `2025-06-18`. `MCP-Protocol-Version` no soportado →
  400. Nunca se emite `Mcp-Session-Id`. Método desconocido → 200 con `-32601`.
- **Era moderna** (`params._meta["io.modelcontextprotocol/protocolVersion"]`): solo `2026-07-28`
  (si no, 400 `-32022` con `supported`); cabecera `MCP-Protocol-Version` igual al `_meta`
  (si no, 400 `-32020`); `clientCapabilities` obligatorio (400 `-32602`); `Mcp-Method` igual
  al método y `Mcp-Name` igual a `params.name` en `tools/call`, con decodificación del
  centinela `=?base64?…?=`; `server/discover` con `supportedVersions`, `capabilities`,
  `instructions`, `ttlMs`, `cacheScope`; todo resultado con `resultType: "complete"` y
  `_meta["io.modelcontextprotocol/serverInfo"]`; método desconocido → **404** con `-32601`.
- Enmarcado: si `Accept` incluye `text/event-stream` con calidad > 0 → un único evento SSE
  (`event: message` + `data:`); si no, JSON. Errores 4xx/5xx siempre JSON.
- Índice no cargable y sin copia → 500 `-32603`, nunca un resultado vacío.

### 9.3 Índice en memoria

```
cache = { index, etag, loadedAt, inflight }
por invocación: si no hay índice → cargar; si han pasado > MCP_INDEX_TTL_SECONDS (300) →
  revalidar (S3 GetObject con If-None-Match; 304 → renovar loadedAt; 200 → sustituir);
  si la revalidación falla → seguir sirviendo la copia y registrar un aviso.
```

`MCP_INDEX_URL` admite `s3://bucket/key` (rol IAM, cliente S3 del runtime marcado como
externo en esbuild), `https://` y `file://` (local y tests). Arranque en frío: una lectura de
3–4 MB y un `JSON.parse`; presupuesto ≤ 700 ms.

### 9.4 Infraestructura (Terraform, módulo de AX parametrizado)

| Recurso | Valor |
|---|---|
| Lambda `griddo-dx-docs-mcp` | `nodejs24.x`, `arm64`, 512 MB, 10 s, concurrencia reservada 10, `handler = index.handler` |
| Function URL | `authorization_type = NONE`, `invoke_mode = BUFFERED` |
| Permisos de la URL | `lambda:InvokeFunctionUrl` (`function_url_auth_type = NONE`) **y** `lambda:InvokeFunction` (`invoked_via_function_url = true`) |
| Rol de la Lambda | `AWSLambdaBasicExecutionRole` + `s3:GetObject` sobre `griddo-dx-docs-index/public/*` (y `partner/*` en v1.2) |
| Secreto de origen | `random_password` (48), inyectado por CloudFront como `custom_header X-Origin-Verify` y en la env de la Lambda |
| CloudFront | Distribución propia: alias `dx.mcp.griddo.io`, `http2and3`, origen la Function URL (https-only, TLS 1.2), `Managed-CachingDisabled`, `Managed-AllViewerExceptHostHeader`, política de cabeceras CORS + `X-Robots-Tag: noindex`, `compress = false` (sin efecto con caché desactivada) |
| Certificado | ACM en us-east-1 para `dx.mcp.griddo.io`, validación DNS en la zona `griddo.io` (cuenta 253490783612) |
| DNS | A y AAAA alias a la distribución |
| Bucket del índice | `griddo-dx-docs-index`, privado, versionado, cifrado; prefijos `public/`, `partner/`, `by-commit/` |
| Rol OIDC "código" | `lambda:UpdateFunctionCode`, `GetFunction`, `GetFunctionConfiguration` sobre la función; trust acotado a **`refs/heads/main` de este repo** |
| Rol OIDC "índice" | `s3:PutObject` sobre el bucket; trust acotado al repo del corpus y `main` |
| Logs | Grupo creado por Terraform antes que la función, retención 30 días (90 si se quiere el histórico de consultas) |
| Métricas | Filtros JSON: `ToolCalls` con dimensión `tool` **acotada a los nombres reales**, `ZeroResultSearches`, `Errors`, `Handshakes`; dos consultas guardadas de Logs Insights; dashboard |
| Etiquetas | `Project = griddo-dx-docs-mcp` en todo lo etiquetable (Cost Explorer) |
| Provider | `aws ~> 6.0`, `random`, `archive`; lock file versionado |
| Ciclo de vida | `ignore_changes = [filename, source_code_hash]`: Terraform crea la función con el bundle local; después el código lo despliega solo CI |

**Requisitos operativos aprendidos:**

- `terraform plan/apply` siempre desde `terraform/` y siempre con el bundle construido
  (`npm run mcp:build`), porque `archive_file` lo lee en el plan.
- La rotación del secreto de origen actualiza primero la Lambda y después CloudFront; durante
  la propagación, todo el tráfico recibe 403. Hacerla en franja de poco uso.
- Las métricas personalizadas no llevan etiquetas y cuestan ~0,30 $/métrica-mes: no salen en
  la vista filtrada de Cost Explorer.

### 9.5 CI/CD (dos workflows con filtro de rutas)

- **`build-index.yml`** (§5.7): contenido → índice → S3. Rol de índice. Nunca toca la Lambda.
- **`deploy-mcp.yml`**: `paths: ['server/**', 'terraform/mcp*.tf', '.github/workflows/deploy-mcp.yml']`
  + `workflow_dispatch`, `if: github.ref == 'refs/heads/main'`, concurrencia en grupo.
  Pasos: `npm ci` → `npm run mcp:build` (esbuild, target `node24`, sin externals salvo
  `@aws-sdk/*`, falla si > 200 KB) → tests de protocolo (herméticos, con fixture) → zip →
  OIDC → `aws lambda update-function-code` **sin `--publish`** y con `--query` para que la
  salida no imprima las variables de entorno → `aws lambda wait function-updated` → smoke test
  contra `https://dx.mcp.griddo.io/mcp` con tres reintentos.
- Terraform se aplica a mano (`plan` guardado y `apply` del plan), como en AX.

### 9.6 Desarrollo local

`node server/lambda/local.mjs` (primer plano, `127.0.0.1:8788`, índice `file://dist/index/public/index.json`).
Prueba con cliente real sin tocar la configuración del usuario:

```sh
claude -p 'Usa search_griddo_dev_docs y get_griddo_dev_doc: ¿cómo pagino useList? Cita la URL.' \
  --mcp-config '{"mcpServers":{"dx-local":{"type":"http","url":"http://127.0.0.1:8788/mcp"}}}' \
  --strict-mcp-config --allowedTools "mcp__dx-local__search_griddo_dev_docs,mcp__dx-local__get_griddo_dev_doc"
```

Es la prueba que destapó el problema de `structuredContent` en AX; forma parte de los
criterios de aceptación.

---

## 10. Seguridad, privacidad y observabilidad

### 10.1 Superficie

Público, anónimo, solo lectura. La query solo se tokeniza. Sin RegExp construidas con texto
del usuario. Sin secretos en la función salvo el de origen. Concurrencia reservada 10 como
techo de coste y de daño. La Function URL es invocable directamente por quien la conozca,
pero sin la cabecera secreta la función responde 403 en la primera línea; el output de
Terraform que la contiene es `sensitive`.

### 10.2 CORS

`Access-Control-Allow-Origin: *`, métodos `GET, HEAD, OPTIONS, POST`, cabeceras `content-type,
accept, authorization, mcp-protocol-version, mcp-session-id, mcp-method, mcp-name, last-event-id`,
`max-age 86400`, tanto en la Lambda (para local) como en la política de CloudFront con
`origin_override`.

### 10.3 Registro (una línea JSON por `POST`, por `process.stdout.write`, no `console.log`)

```json
{ "t": "…", "method": "tools/call", "tool": "search_griddo_dev_docs", "section": null,
  "query": "how do I paginate useList", "results": 8, "top": "building-blocks/hooks/use-list#paginacion",
  "ms": 12, "cold": false, "proto": "2026-07-28", "era": "modern",
  "client": "claude-code/2.1.263", "ua": "…", "status": 200, "code": null, "level": "info" }
```

`console.log` antepone marca de tiempo y `requestId` en el runtime de Lambda y rompe los
filtros de métrica JSON. `query` truncada a 200 caracteres, desactivable con
`MCP_LOG_QUERIES=0`. Sin IPs. `tool` solo toma valores de la lista de tools (los nombres
desconocidos van a `null`): una dimensión alimentada por el cliente crea métricas ilimitadas y
CloudWatch desactiva el filtro.

### 10.4 Privacidad

Las consultas de developers pueden llevar fragmentos de código de clientes. Retención acotada
(30 o 90 días, decisión O5), sin IP en la misma línea, política publicada en la página de
instalación. Informe mensual de consultas sin resultado convertido en tareas de documentación:
es la mitad del valor del proyecto.

### 10.5 Camino a OAuth (v1.2)

Middleware de identidad aislado en `server/lambda/auth.mjs`, `passthrough` en v1. Activarlo:
responder 401 con `WWW-Authenticate` apuntando a `/.well-known/oauth-protected-resource`,
servir `index-partner.json` a identidades válidas y `index-public.json` al resto. El bucket
privado con dos prefijos y el rol con permiso por prefijo ya están pensados para eso.

---

## 11. Distribución

### 11.1 Páginas

- **Página de instalación** con la URL copiable y un bloque por cliente: Claude (conector
  personalizado), Claude Code (`claude mcp add --transport http griddo-dx-docs https://dx.mcp.griddo.io/mcp`),
  ChatGPT (modo desarrollador), VS Code (`.vscode/mcp.json` con `"type": "http"`), Cursor
  (`.cursor/mcp.json` y deep link con la config en base64), Codex (`~/.codex/config.toml`),
  Windsurf y genérico. Destino de `MCP_INSTALL_URL` y del 302 de `/`. Vive en
  `dx.griddo.io/build-with-ai/` si el sitio existe; hasta entonces, en el README del plugin.
- **`mcp.griddo.io`** como directorio de los MCP de Griddo: deseable, no bloqueante. Una
  página estática más en cualquiera de los dos sitios de docs, enlazada desde ambos.

### 11.2 Integración con el plugin `griddo-dx`

```json
{ "mcpServers": { "griddo-dx-docs": { "type": "http", "url": "https://dx.mcp.griddo.io/mcp" } } }
```

En `plugins/griddo-dx/.mcp.json`. Instalar el plugin conecta el servidor. Notas:

- Los tools llegan al modelo con prefijo de plugin (`mcp__plugin_griddo-dx_griddo-dx-docs__…`),
  así que las descripciones importan más que el nombre corto.
- Cowork no arranca servidores **stdio** declarados por plugins (comprobado en el repo de
  conectores). Verificar que sí conecta los `http` antes de prometerlo en la página; si no,
  la ruta para Cowork es el conector personalizado.
- El `/release` existente hace el bump del plugin y del marketplace.

### 11.3 MCP Registry

`server.json` con `name: "io.griddo/dx-docs"` y `remotes: [{ type: "streamable-http", url }]`;
`mcp-publisher login dns` exige un TXT en `griddo.io`, que se añade en Terraform en la zona de
la cuenta de DNS. Publicar después de la Fase 3, cuando el eval esté verde.

### 11.4 Directorio de conectores de Claude

Envío manual por un administrador de la organización (Team o Enterprise), después de resolver
O4 (nombres de tools disjuntos con AX): el directorio es donde la colisión haría más daño.

### 11.5 `llms.txt`

Solo si existe el sitio `dx.griddo.io`. En AX se decidió no publicarlo por posicionamiento
frente a la web de marketing; en un sitio de developer esa razón no aplica.

---

## 12. Calidad y criterios de aceptación

### 12.1 Eval set (`eval/queries.jsonl`, 50 consultas)

40 % en inglés sobre contenido en español, 30 % con identificador exacto, 30 % conceptuales,
5 fronterizas con AX. Fuentes: tickets de agencias, preguntas del equipo, casos de las 10
skills. Corre en CI en cada cambio del corpus o del buscador; una regresión bloquea el merge.

| Métrica | Umbral |
|---|---|
| Recall@5 global | ≥ 0,85 |
| Recall@5 en el subconjunto EN→ES | ≥ 0,80 (si no se alcanza con glosario → §7.4) |
| Fuga: documentos `partner`/`internal` en `index-public` | 0 (test automático) |
| Latencia p95 en producción | < 500 ms (carga sintética) |
| Frescura | < 5 min desde el `s3 cp` (TTL 300 s) |

### 12.2 Criterios verificables por comando (`$URL` = local o producción)

1. `initialize` con `2025-06-18` devuelve la misma versión y `serverInfo.name = "griddo-dx-docs"`.
2. `initialize` con `2026-07-28` devuelve `2026-07-28`; `server/discover` con `_meta` y cabeceras devuelve `supportedVersions`.
3. `tools/list` devuelve exactamente `search_griddo_dev_docs` y `get_griddo_dev_doc`.
4. `search {"query":"how do I paginate useList"}` → primer resultado en `building-blocks/hooks/use-list`.
5. `search {"query":"useGriddoImage srcset"}` → primer resultado en el documento del hook.
6. `search {"query":"cómo creo un módulo"}` y `{"query":"how to create a module"}` → mismo documento en el top 3.
7. `get_griddo_dev_doc` con ruta, con URL y con ancla devuelven el documento (o la sección) con URLs absolutas; ruta desconocida → `isError: true` con sugerencias.
8. `search {"query":"constructor"}` devuelve resultados finitos (sin `NaN`), y `{"query":"xyzzy"}` → `isError: false` con texto útil y línea de log con `results: 0`.
9. `GET $URL` → 405 con `Allow`; `GET /` → 302 a la página de instalación; `GET /foo` → 404.
10. Petición con `Mcp-Session-Id` se atiende igual; con `text/event-stream;q=0` responde JSON.
11. `index-public.json` no contiene ningún `visibility` distinto de `public` (test de CI).
12. Editar un documento, fusionar, y en menos de 5 minutos `get_griddo_dev_doc` devuelve el texto nuevo **sin desplegar la Lambda**.
13. `claude -p` con `--mcp-config` (§9.6) responde citando una URL del corpus y confirma que recibió el Markdown completo.
14. Coste del primer mes en Cost Explorer, filtrado por etiqueta, inferior a 1 €.

---

## 13. Plan

| Fase | Entregable | Salida | Duración |
|---|---|---|---|
| 0. Infra | Módulo Terraform de AX parametrizado y aplicado para `dx.mcp.griddo.io`; Lambda con la capa de protocolo y un índice de prueba; `deploy-mcp.yml` en verde; criterios 1–3 y 9–10 | Endpoint vivo | 1 día |
| 1. Corpus | Frontmatter y `visibility` en los 35 ficheros, enlaces reparados, ficheros gigantes partidos, `docs/` como corpus, linter | `npm run docs:lint` verde | 1–2 días |
| 2. Índice y buscador | `build-index`, formato v2, tokenizador y BM25 con glosario, `check-index`, eval set de 50 y umbrales | Recall ≥ umbrales, o decisión O6 sobre denso | 3 días |
| 3. Tools | Las dos tools sobre el índice real, tests de búsqueda y de protocolo, prueba con cliente real, `build-index.yml` publicando a S3 | Criterios 4–8, 11–13 | 2 días |
| 4. Operación | Métricas, dashboard, consultas guardadas, informe mensual, extracción del núcleo a `@griddo/mcp-lambda-core` si no se hizo en la 0 | Criterio 14 tras el primer mes | 1 día |
| 5. Distribución | `.mcp.json` en el plugin y release, página de instalación, `server.json` en el registry, renombrado en AX (O4), envío al directorio de Claude | 5 developers conectados | 2 días |

**Total: unas dos semanas** para una persona, frente a las cuatro de la v1.0. La diferencia
es el módulo de infraestructura y la capa de protocolo ya construidos.

Post-v1: `list_griddo_dev_docs` y ajuste del ranking con datos reales (v1.1); OAuth y el
índice `partner` (v1.2); versionado del corpus por release de Griddo (v1.3).

---

## 14. Riesgos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| El corpus se desincroniza del producto | Alto: el MCP pierde su ventaja | Docs en el mismo PR que el código, sea cual sea el repo (§0) |
| Recall pobre EN→ES | Alto y silencioso | Glosario + eval con 40 % en inglés; denso en v1.1 si hace falta |
| API Privada expuesta sin querer | Alto | Decisión O2 antes de la Fase 1; default `internal`; test de fuga en CI |
| `source_url` sin sitio | Medio | Fallback a GitHub mientras el repo sea público; decisión O3 |
| El agente elige el MCP de AX para preguntas de desarrollo | Alto y silencioso | Nombres disjuntos, fronteras en las descripciones, 5 consultas fronterizas en el eval |
| El agente no llama a la tool | Alto | Descripciones e `instructions` trabajadas; métrica de llamadas por cliente |
| Duplicación plugin/MCP | Medio | `docs/` como única copia; skills procedimentales |
| Primer smoke de CI antes de que exista el índice en S3 | Bajo | Publicar el índice antes del primer deploy o relanzar el workflow |

---

## 15. Decisiones abiertas

| # | Decisión | Quién | Bloquea | Recomendación |
|---|---|---|---|---|
| O1 | Repo del corpus: este o el monorepo (§0, §5.5) | Dani + Plataforma | Nada del servidor; solo dónde corre `build-index` | Empezar aquí; migrar después |
| O2 | API Privada pública de facto o repo privado (§3) | Producto + Plataforma | Fase 1 | Decidir explícitamente; la spec funciona con ambas |
| O3 | Sitio `dx.griddo.io` (Starlight) o URLs de GitHub (§5.3) | Dani + docs | Calidad de las citas, no el desarrollo | Starlight clonando el patrón de `docs.griddo.io` |
| O4 | ~~Renombrar tools y servidor de AX (§8.4)~~ | Dani | — | **Hecho el 2026-09-08** |
| O5 | Retención de logs con texto de consulta: 30 o 90 días | Dani | Fase 4 | 90 si se quiere el histórico de huecos |
| O6 | Rama densa (§7.4) | Desarrollo, por resultado del eval | v1.1 | Solo si el eval EN→ES no llega a 0,80 |
| O7 | Página `mcp.griddo.io` y su hosting | Dani | Nada | Página estática en el sitio de docs de DX |

---

## Anexo A — Lo que se hereda de `griddo-ax-docs` (rutas de referencia)

- `terraform/mcp.tf`, `terraform/cloudfront-dns.tf`: el módulo de infraestructura (Lambda,
  Function URL con los dos permisos, secreto de origen, CloudFront, ACM, DNS, roles OIDC,
  métricas, dashboard). Parametrizar host, nombre de función, origen del índice y URL de instalación.
- `mcp/lambda/http.mjs`, `handler.mjs`, `format.mjs`: protocolo dual, enrutado, validación,
  caché del índice, logger. Cambian solo `tools.mjs` y el formato de los textos.
- `src/lib/mcp-tokenize.js`, `mcp-stopwords.js`, `mcp-search.js`: tokenizador y ranking.
  Generalizar de documentos a chunks y añadir el glosario.
- `scripts/check-mcp-index.mjs`, `mcp/test/*`: validación del índice, tests herméticos con
  fixture, tests sobre el índice real, smoke test.
- `mcp/README.md` y `AGENTS.md` §5: guía de desarrollo y decisiones D1–D8 de AX, incluidas las
  que esta spec hereda.

## Anexo B — Referencias externas

- MCP, revisión 2026-07-28: transporte Streamable HTTP, versionado y `server/discover`
  (<https://modelcontextprotocol.io/specification/2026-07-28/>). Revisión 2025-06-18 para el handshake legacy.
- AWS: control de acceso de Function URLs (dos permisos desde octubre de 2025)
  (<https://docs.aws.amazon.com/lambda/latest/dg/urls-auth.html>); OAC hacia Lambda y el hash
  del cuerpo en `POST` (<https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-lambda.html>).
- Servidor de referencia comprobado: `https://mcp.docs.astro.build/mcp`.
- Spec v1.0 de este proyecto: `Tech Spec Griddo DX docs mcp.md` (mismo directorio), para el
  contexto estratégico, la migración desde Notion y las decisiones D2 y D7 originales.
