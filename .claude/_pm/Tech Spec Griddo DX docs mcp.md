# Griddo DX Docs MCP — Especificación técnica

**Versión:** 1.0
**Fecha:** 8 de septiembre de 2026
**Autor:** Dani Serrano
**Estado:** Listo para kickoff
**Equipo destino:** Plataforma / DX

---

## 1. Resumen ejecutivo

### Qué construimos

Un servidor MCP remoto que expone la documentación de developer de Griddo a cualquier agente de IA (Claude Code, Cursor, VS Code, Codex, Windsurf, ChatGPT) mediante búsqueda semántica. El agente pregunta, el servidor devuelve fragmentos de documentación con su URL de origen, y el modelo del cliente razona sobre ellos.

**Endpoint:** `https://dx.mcp.griddo.io/mcp`
**Transporte:** Streamable HTTP, stateless
**Acceso v1:** público sin autenticación

### Por qué

Los developers de instancia (agencias partner y equipo interno) trabajan con agentes que tienen conocimiento nulo o desactualizado de Griddo. Hoy la única vía es el plugin `griddo-dx`, que solo alcanza a Claude Code y solo transporta lo que cabe en las references de las skills. El MCP cubre el resto: cualquier herramienta, corpus completo, siempre fresco.

### Qué NO construimos

| Fuera de alcance | Por qué |
|---|---|
| Motor de respuestas / chatbot | El modelo del cliente redacta. Nosotros solo recuperamos. |
| Widget web de chat | Otro producto. Ver `AgentDoc/_specs/Tech_Spec_Griddo_DEV_KB_Agent.md`. |
| Creación de tickets en Zendesk | Otro producto. |
| Vector database gestionada | El corpus es de ~1 MB. No lo justifica. Ver §6. |
| Escritura o mutación de docs | El MCP es de solo lectura. |

### Reparto de responsabilidades con el plugin `griddo-dx`

El plugin y el MCP son complementarios y no deben solaparse:

- **Plugin = conocimiento procedural.** Cómo scaffoldear un módulo, cómo revisar un schema, qué convenciones seguir. Instrucciones que ejecutan un flujo.
- **MCP = conocimiento declarativo.** Qué props acepta `GriddoImageExp`, qué devuelve `GET /search`, cómo se configura el SSO. Hechos que se consultan.

El plugin declarará el MCP en su `.mcp.json` (§11.2), de modo que instalar el plugin conecta el servidor automáticamente.

---

## 2. Decisiones tomadas

| # | Decisión | Valor |
|---|---|---|
| D1 | Acceso v1 | Público, sin autenticación. OAuth como fase posterior. |
| D2 | Fuente de verdad | Repositorio de GitHub (monorepo de Griddo). Notion queda deprecado. |
| D3 | Alcance del corpus | Completo, con segmentación por visibilidad (ver §3). |
| D4 | Transporte | Streamable HTTP, stateless. |
| D5 | Dominio | `dx.mcp.griddo.io`. Esquema `<superficie>.mcp.griddo.io`, compartido con el MCP de AX docs (`ax.mcp.griddo.io`). |
| D6 | Retrieval | Índice propio, sin proveedor externo tipo kapa.ai. |
| D7 | Alineación de release | El pipeline de índice vive en el repo de producto y sigue su ciclo. |

### 2.1 Sobre D1 — el camino a OAuth

Añadir autenticación más adelante sobre la misma URL es viable: el servidor pasa a responder `401` con cabecera `WWW-Authenticate` apuntando a `/.well-known/oauth-protected-resource`, y los clientes que cumplen la spec MCP inician el flujo por su cuenta. Rompe a los clientes simples y obliga a reconectar a los que ya tengan credenciales guardadas.

**Requisito derivado:** el middleware de autenticación se implementa desde el día 1 en modo passthrough, con la resolución de identidad aislada en un único módulo (`src/auth/`). Activar OAuth debe ser un cambio de configuración, no una refactorización.

### 2.2 Sobre D5 — el esquema `<superficie>.mcp.griddo.io`

Griddo tendrá al menos dos MCP de documentación, uno por superficie: Author Experience y Developer Experience. Ninguno está en producción en el momento de escribir esto, así que el esquema de nombres se fija ahora para los dos.

**Estado del DNS verificado:**

| Host | Estado |
|---|---|
| `ax.griddo.io` | Resuelve (65.8.202.12) |
| `dx.griddo.io` | Resuelve (3.5.206.192) |
| `docs.griddo.io` | Resuelve — sitio de docs de AX, Astro/Starlight |
| `mcp.griddo.io`, `ax.mcp.griddo.io`, `dx.mcp.griddo.io` | Libres |

**Decisión:** `<superficie>.mcp.griddo.io`, es decir `dx.mcp.griddo.io` y `ax.mcp.griddo.io`, con `mcp.griddo.io` como nodo padre real.

Tres razones concretas, todas operativas:

1. **Un solo certificado.** Un wildcard TLS cubre una única etiqueta. `*.mcp.griddo.io` sirve para todos los MCP presentes y futuros con un único ACM. El esquema alternativo `mcp.<superficie>.griddo.io` obliga a un wildcard por superficie (`*.dx.griddo.io`, `*.ax.griddo.io`, y uno más por cada superficie que se añada).
2. **Política operada como unidad.** WAF, rate limits y CORS son idénticos entre MCP y distintos de los de un sitio de docs estático. Cuando llegue OAuth (§2.1), `mcp.griddo.io` puede alojar el authorization server que proteja todos los recursos bajo `*.mcp.griddo.io` de una vez, en lugar de duplicar la configuración por superficie.
3. **`mcp.griddo.io` como página real.** Directorio de los servidores MCP de Griddo con instrucciones de instalación (§11.1). Un activo de DX, no solo un nodo DNS.

Alternativas descartadas:

| Opción | Por qué no |
|---|---|
| `mcp.dx.griddo.io` / `mcp.ax.griddo.io` | Se autodocumenta mejor respecto al sitio de docs y es el precedente de Astro (`mcp.docs.astro.build`), pero pierde las tres ventajas de arriba. El precedente de Astro pesa poco: tienen un único servidor MCP y nunca se enfrentaron a esta decisión. |
| `dx.docs.griddo.io/mcp` (path bajo el sitio de docs) | Introduce un tercer eje de nombres cuando `dx.griddo.io` ya existe, y obliga al CloudFront del sitio estático a enrutar `/mcp` a un origen dinámico. |
| `support.griddo.io/mcp` | El subdominio no resuelve y el nombre no dice nada de lo que sirve. |

**Alcance del árbol `*.mcp.griddo.io`.** Griddo ya opera MCP internos (Atlas, logs de web). Se reserva `*.mcp.griddo.io` para servidores públicos y de partner. Los internos quedan fuera del árbol, para no compartir certificado ni política de WAF entre superficies con perfiles de riesgo distintos.

**Dependencia:** el MCP de AX debe adoptar `ax.mcp.griddo.io` antes de salir a producción. Es una coordinación previa al kickoff, no un cambio en este servidor. Ver O6 en §15.

El endpoint **no** necesita compartir ubicación con el repositorio. El repo es la fuente de contenido; el endpoint es un servicio; los une el pipeline de CI.

---

## 3. Visibilidad del contenido (bloqueante)

El corpus incluye 66 documentos de API Privada y documentación de arquitectura interna. Publicarlos en un endpoint abierto expone la superficie completa de la API interna de Griddo a cualquiera con la URL.

### Solución: un pipeline, dos índices

Cada documento declara su visibilidad en frontmatter:

```yaml
---
title: "GriddoImageExp"
section: "building-blocks/components"
type: "reference"
visibility: "public"     # public | partner | internal
tags: ["component", "image", "performance"]
complexity: "intermediate"
source_url: "https://dx.griddo.io/building-blocks/components/griddo-image-exp/"
---
```

| Valor | Contenido | Índice | Endpoint |
|---|---|---|---|
| `public` | Building blocks, hooks, componentes, guías, buenas prácticas, API Pública, getting started, styling | `index-public` | `dx.mcp.griddo.io/mcp` (sin auth) |
| `partner` | API Privada, herramientas (SDK, Debugger, DAM) | `index-partner` | `dx.mcp.griddo.io/mcp` **tras activar OAuth** |
| `internal` | API 2.0 (arquitectura hexagonal, buses, DTO), infraestructura | Ninguno en v1 | — |

El mismo `build-index` genera ambos artefactos. El endpoint público carga solo `index-public`. Cuando OAuth entre (fase 5), el mismo endpoint sirve `index-partner` a usuarios autenticados y `index-public` al resto.

**Regla dura:** el default de `visibility` cuando falta el campo es `internal`. Un documento sin clasificar nunca se publica por accidente. El linter de CI falla si un `.md` no declara `visibility`.

### Acción previa al desarrollo

Alguien de producto/plataforma debe clasificar los 228 documentos. Es la tarea de ruta crítica de la Fase 1 y no la puede hacer el equipo de desarrollo solo. Estimación: media jornada con un script que preclasifique por carpeta y revisión humana de los casos de API Privada.

---

## 4. Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│  FUENTE (GitHub)                                                │
│                                                                 │
│  monorepo-griddo/docs/**/*.md    ← fuente de verdad             │
│  griddo-marketplace/plugins/griddo-dx/**  ← references plugin   │
└────────────────────────┬────────────────────────────────────────┘
                         │ push a main
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│  BUILD (GitHub Actions)                                         │
│                                                                 │
│  1. Lint de frontmatter (visibility obligatorio)                │
│  2. Chunking por H2, sin partir bloques de código               │
│  3. Embeddings multilingües (API externa, batch)                │
│  4. Emite index-public.json + index-partner.json                │
│  5. Sube a S3 (versionado por commit SHA)                       │
└────────────────────────┬────────────────────────────────────────┘
                         │ dispara redeploy
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│  SERVE (AWS App Runner)                                         │
│                                                                 │
│  Node 22 + @modelcontextprotocol/sdk                            │
│  StreamableHTTPServerTransport (stateless)                      │
│  Índice cargado en memoria al arrancar                          │
│  BM25 + denso → RRF → top-k                                     │
└────────────────────────┬────────────────────────────────────────┘
                         │ HTTPS
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│  CLIENTES                                                       │
│  Claude Code · Cursor · VS Code · Codex · Windsurf · ChatGPT    │
└─────────────────────────────────────────────────────────────────┘
                         │
                         ▼
              CloudWatch: log de queries, tasa de cero-resultados
```

### Principio rector

**El servidor MCP es una carcasa fina.** El repo de Astro son ~4 archivos y 20 commits. Todo el trabajo real está en el índice y en el pipeline que lo mantiene fresco. Cualquier complejidad que se acumule en la capa MCP es probablemente un error de diseño.

---

## 5. Fuente de contenido y pipeline

### 5.1 Ubicación en el monorepo

```
monorepo-griddo/
└── docs/
    ├── getting-started/
    ├── building-blocks/
    │   ├── fields/
    │   ├── hooks/
    │   ├── components/
    │   ├── schemas/
    │   └── functions/
    ├── api/
    │   ├── public/
    │   ├── private/
    │   └── v2/
    ├── tools/
    ├── guides/
    ├── best-practices/
    └── styling/
```

Migración desde `AgentDoc/01-consolidated/` (228 documentos ya limpios de artefactos de Notion). El trabajo pendiente es añadir frontmatter y `source_url`, no reescribir contenido.

### 5.2 Esquema de frontmatter

| Campo | Tipo | Obligatorio | Notas |
|---|---|---|---|
| `title` | string | Sí | Título del documento |
| `section` | string | Sí | Ruta jerárquica, p. ej. `building-blocks/hooks` |
| `type` | enum | Sí | `reference` \| `guide` \| `tutorial` \| `concept` |
| `visibility` | enum | Sí | `public` \| `partner` \| `internal` |
| `tags` | string[] | No | Para filtrado y boost léxico |
| `complexity` | enum | No | `beginner` \| `intermediate` \| `advanced` |
| `source_url` | string | Sí | URL pública resoluble (§5.4) |
| `deprecated` | boolean | No | Si `true`, se indexa con penalización de ranking |

### 5.3 Chunking

Reglas, en orden de prioridad:

1. **Cortar por encabezado H2.** Un H2 = un chunk candidato.
2. **Nunca partir un bloque de código.** Si un fence excede el tamaño objetivo, el chunk crece.
3. **Prefijar cada chunk con su breadcrumb.** Formato tomado de Astro, que funciona bien:
   ```
   # Building blocks > Hooks
   ## useGriddoImage

   <contenido>
   ```
   El breadcrumb da contexto al embedding y al modelo que recibe el chunk aislado.
4. **Objetivo 300–800 tokens.** Si un H2 se queda por debajo de 150, fusionar con el siguiente hermano. Si excede 1.200, subdividir por H3.
5. **Sin solape.** El breadcrumb ya aporta el contexto que el solape intentaría dar.
6. **Las tablas de props no se parten.** Un chunk de referencia debe contener la tabla completa.

Volumen esperado: ~1.500–2.500 chunks para los 228 documentos.

### 5.4 `source_url`

Para un MCP público, las URLs que devolvemos deben resolver: el agente las cita y el developer las abre.

**Destino:** `https://dx.griddo.io/<section>/<slug>/#<ancla>`. El subdominio ya resuelve y es la superficie natural de la doc de developer, en paralelo a `docs.griddo.io` para Author Experience.

Requisitos que debe cumplir el sitio para que el MCP funcione bien:

- **Anclas estables por H2.** El chunking corta por H2 (§5.3) y cada chunk cita su ancla. Si las anclas cambian entre builds, las citas se rompen.
- **Slugs derivados del path del fichero en el monorepo**, para que `build-index` pueda generar `source_url` sin una tabla de mapeo aparte.
- **Sin muro de autenticación** en el contenido marcado `visibility: public`.

Si el sitio se construye con Starlight, los tres salen de serie, más `llms.txt` vía `@astrojs/starlight-llms-txt` (§11.4).

**Fallback si el sitio no está listo a tiempo:** apuntar al fichero en GitHub. Solo válido con repo público, y degrada la experiencia. No bloquea el desarrollo del MCP, sí la calidad de lo que ve el developer.

### 5.5 Sincronización

GitHub Action en el monorepo:

```yaml
name: build-docs-index
on:
  push:
    branches: [main]
    paths: ['docs/**']
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 22 }
      - run: npm ci
      - run: npm run docs:lint        # falla si falta visibility o source_url
      - run: npm run docs:build-index # emite index-public.json e index-partner.json
        env:
          EMBEDDINGS_API_KEY: ${{ secrets.EMBEDDINGS_API_KEY }}
      - run: aws s3 cp dist/index/ s3://griddo-dx-docs-index/${{ github.sha }}/ --recursive
      - run: aws s3 cp dist/index/ s3://griddo-dx-docs-index/latest/ --recursive
      - run: aws apprunner start-deployment --service-arn ${{ secrets.MCP_SERVICE_ARN }}
```

**Optimización de coste:** cachear embeddings por hash de contenido del chunk. Solo se reembeben los chunks que cambian. Un build típico tocará 5–20 chunks, no 2.000.

---

## 6. Índice y recuperación

### 6.1 Por qué índice propio

| | Índice propio | kapa.ai / Inkeep |
|---|---|---|
| Latencia p50 | <100 ms | ~3.000 ms |
| Coste recurrente | ~0 € (hosting ya existente) | $450–500+/mes |
| Coste de embeddings | ~1 € una vez, céntimos por actualización | Incluido |
| Control de visibilidad | Total (§3) | Limitado a source groups |
| Ops | Un artefacto JSON en S3 | Cero |

Con 228 documentos y ~1 MB de texto, el índice completo cabe en memoria. Una vector database es infraestructura sin trabajo que hacer.

### 6.2 Recuperación híbrida

```
query
  ├─→ BM25 sobre chunks (in-process)          → ranking léxico
  └─→ embedding de query → similitud coseno   → ranking semántico
                                                      │
                          Reciprocal Rank Fusion (k=60)
                                                      │
                                            top-k chunks
```

**Por qué híbrido y no solo denso:** los developers buscan identificadores exactos (`useGriddoImage`, `configTabs`, `POST /pages`). BM25 los clava; los embeddings los difuminan. Y al revés para preguntas conceptuales. RRF combina ambos rankings sin necesidad de tunear pesos.

**Parámetros iniciales** (a validar con el eval set de §12):

| Parámetro | Valor |
|---|---|
| `top_k` devuelto | 8 |
| `max_chars` total | 30.000 |
| RRF `k` | 60 |
| Candidatos por rama antes de fusión | 30 |
| Penalización a `deprecated: true` | ×0.7 sobre el score fusionado |

### 6.3 Embeddings multilingües — requisito duro

La documentación está en español. Los agentes preguntan en inglés con mucha frecuencia (`"how do I create a module in Griddo"` contra un corpus que dice "crear un módulo"). Un modelo monolingüe inglés falla aquí de forma silenciosa: devuelve resultados plausibles pero equivocados.

**Requisito:** modelo de embeddings con rendimiento cross-lingual ES↔EN demostrado, ~1024 dimensiones.

Candidatos a evaluar (verificar versiones vigentes en el momento del desarrollo, este espacio se mueve rápido):
- Cohere `embed-multilingual-v3` — el más explícitamente multilingüe
- Voyage `voyage-multilingual-2` — ya contemplado en el spec anterior del equipo
- OpenAI `text-embedding-3-large` — multilingüe aceptable, integración trivial
- BGE-M3 — open weights, si se quiere evitar dependencia externa

**Criterio de elección:** el eval set (§12) debe incluir un 40% de queries en inglés sobre contenido en español. Se elige el modelo que gane ahí, no el que tenga mejor benchmark general.

### 6.4 Formato del artefacto de índice

```jsonc
{
  "version": "2026-09-08T10:23:00Z",
  "commit": "a3f21bc",
  "model": "embed-multilingual-v3",
  "dimensions": 1024,
  "chunks": [
    {
      "id": "building-blocks/hooks/use-griddo-image#uso-basico",
      "doc_path": "building-blocks/hooks/use-griddo-image",
      "title": "useGriddoImage|Uso básico",
      "breadcrumb": "Building blocks > Hooks",
      "section": "building-blocks/hooks",
      "type": "reference",
      "visibility": "public",
      "tags": ["hook", "image"],
      "source_url": "https://dx.griddo.io/building-blocks/hooks/use-griddo-image/#uso-basico",
      "content": "...",
      "embedding": [/* int8 cuantizado */]
    }
  ]
}
```

Cuantizar los embeddings a int8 reduce el artefacto ~4× con pérdida de recall despreciable a esta escala. 2.000 chunks × 1024 dims × 1 byte ≈ 2 MB.

---

## 7. Contrato de las tools

Astro expone **una sola tool** y funciona. Nosotros exponemos **dos** en v1: la búsqueda, y la recuperación de documento completo cuando el agente necesita la página entera en vez de fragmentos.

### 7.1 `search_griddo_dev_docs`

```typescript
{
  name: "search_griddo_dev_docs",
  description:
    "Busca en la documentación oficial de desarrollo de Griddo (el DXP para " +
    "universidades). Devuelve fragmentos relevantes de documentación con su URL " +
    "de origen. Úsala SIEMPRE antes de responder cualquier pregunta sobre Griddo: " +
    "hooks de @griddo/core, componentes, schemas, fields, templates, módulos, " +
    "content types, la API Pública o Privada, el SDK, el Debugger, el DAM, " +
    "configuración de instancias o rendimiento. Tu conocimiento previo de Griddo " +
    "está desactualizado o es inexistente; esta herramienta es la fuente autorizada. " +
    "La documentación está en español; puedes consultar en cualquier idioma. " +
    "No uses esta herramienta para preguntas sobre el uso del backoffice de Griddo " +
    "(crear páginas, gestionar usuarios, publicar contenido): eso es Author " +
    "Experience y tiene su propia documentación en el MCP \"Griddo Docs\".",
  inputSchema: {
    type: "object",
    properties: {
      query: {
        type: "string",
        description:
          "La pregunta o los términos a buscar. Sé específico e incluye los " +
          "identificadores exactos que conozcas (nombres de hooks, endpoints, " +
          "propiedades de schema)."
      },
      section: {
        type: "string",
        enum: [
          "getting-started", "building-blocks", "api",
          "tools", "guides", "best-practices", "styling"
        ],
        description: "Opcional. Restringe la búsqueda a una sección concreta."
      }
    },
    required: ["query"]
  }
}
```

**Respuesta:**

```json
{
  "results": [
    {
      "title": "useGriddoImage|Uso básico",
      "content": "# Building blocks > Hooks\n## useGriddoImage\n\n...",
      "source_url": "https://dx.griddo.io/building-blocks/hooks/use-griddo-image/#uso-basico",
      "section": "building-blocks/hooks",
      "type": "reference"
    }
  ]
}
```

Sin campo de score: no aporta nada al modelo y invita a razonamientos espurios sobre confianza. El orden ya comunica la relevancia.

### 7.2 `get_griddo_dev_doc`

```typescript
{
  name: "get_griddo_dev_doc",
  description:
    "Recupera el contenido completo de un documento de la documentación de Griddo " +
    "por su ruta. Úsala cuando search_griddo_dev_docs haya devuelto un fragmento y " +
    "necesites la página entera: la tabla completa de propiedades de un componente, " +
    "todos los parámetros de un endpoint, o una guía de principio a fin.",
  inputSchema: {
    type: "object",
    properties: {
      path: {
        type: "string",
        description:
          "Ruta del documento, tal como aparece en el campo source_url de un " +
          "resultado de búsqueda. Ejemplo: 'building-blocks/hooks/use-griddo-image'."
      }
    },
    required: ["path"]
  }
}
```

Trunca a 40.000 caracteres con aviso explícito si el documento excede ese tamaño.

### 7.3 Diferidas a v1.1

| Tool | Qué haría | Por qué no en v1 |
|---|---|---|
| `list_griddo_dev_docs` | Devuelve el mapa de secciones y documentos | Útil para orientar al agente, pero añade una tool que compite por atención. Medir antes si hace falta. |
| `report_griddo_dev_docs_gap` | El agente reporta huecos de documentación cuando no encuentra respuesta | Truco que kapa incorporó y es valioso, pero el log de cero-resultados (§10) ya da el 80% de la señal sin exponer una tool de escritura en un endpoint público. |

### 7.4 Instrucciones de servidor

El servidor devuelve `instructions` en la respuesta de inicialización:

```
Griddo es un DXP (Digital Experience Platform) para universidades. Los developers
construyen "instancias" sobre él usando @griddo/core: hooks, componentes, schemas,
templates y módulos en React/TypeScript.

Consulta estas herramientas antes de responder cualquier pregunta sobre Griddo o de
escribir código para una instancia Griddo. Tu conocimiento previo de la plataforma
está desactualizado.

Cita siempre el source_url de los fragmentos que uses. Si la búsqueda no devuelve
nada relevante, dilo abiertamente en lugar de inferir la respuesta a partir de
patrones de otros frameworks: las convenciones de Griddo son específicas y una
suposición razonable suele ser incorrecta.

Este servidor cubre exclusivamente Developer Experience. Las preguntas sobre el uso
del backoffice de Griddo (Author Experience) tienen su propio servidor MCP.
```

---

### 7.5 Coexistencia con el MCP de AX docs

Griddo expondrá dos MCP de documentación sobre audiencias distintas, bajo el mismo árbol `*.mcp.griddo.io` (§2.2):

| | AX docs | DX docs (este documento) |
|---|---|---|
| Endpoint | `ax.mcp.griddo.io/mcp` | `dx.mcp.griddo.io/mcp` |
| Audiencia | Usuarios autores del backoffice | Developers de instancia |
| Contenido | Uso del editor, roles, publicación | `@griddo/core`, schemas, APIs, SDK |

**El riesgo real no es el hostname, es la colisión de nombres.** Un developer de agencia tendrá los dos conectados a la vez. Si ambos servidores presentan tools con nombres y descripciones parecidas, el modelo elegirá el equivocado y responderá una pregunta de desarrollo con documentación del editor, sin señal de error. Es un fallo silencioso y difícil de diagnosticar desde el lado del usuario.

Separación en cuatro capas:

| Capa | AX | DX |
|---|---|---|
| Nombre de servidor | `griddo-ax-docs` | `griddo-dx-docs` |
| Tool de búsqueda | `search_griddo_editor_docs` | `search_griddo_dev_docs` |
| Tool de documento | `get_griddo_editor_doc` | `get_griddo_dev_doc` |
| Namespace en el registry | `io.griddo/ax-docs` | `io.griddo/dx-docs` |

Además, **cada descripción de tool debe declarar explícitamente su frontera**, incluyendo a quién no sirve. Es lo que impide que el modelo elija por proximidad semántica. La descripción de §7.1 termina con:

```
No uses esta herramienta para preguntas sobre el uso del backoffice de Griddo
(crear páginas, gestionar usuarios, publicar contenido): eso es Author Experience
y tiene su propia documentación en el MCP "Griddo Docs" (ax.mcp.griddo.io).
```

La descripción del MCP de AX debe llevar la frontera simétrica. **Requiere coordinación con quien mantiene el MCP de AX**, y es un cambio en ese servidor, no en este.

**Verificación:** el eval set (§12) incluye 5 queries fronterizas (del tipo "cómo publico una página en Griddo", ambigua entre las dos superficies) para comprobar que el reparto funciona con ambos servidores conectados a la vez.

---

## 8. Implementación del servidor

### 8.1 Stack

| Componente | Elección | Motivo |
|---|---|---|
| Runtime | Node 22 LTS | Alineado con el stack TypeScript del equipo |
| SDK | `@modelcontextprotocol/sdk` (última estable) | Oficial |
| Transporte | `StreamableHTTPServerTransport` en modo stateless | D4 |
| HTTP | Node `http` nativo o Hono | Sin necesidad de framework pesado |
| BM25 | `orama` o implementación propia (~150 líneas) | El corpus cabe en memoria |
| Contenedor | Distroless Node | Superficie mínima |

Spec MCP de referencia: revisión `2026-07-28`.

### 8.2 Esqueleto

```typescript
// src/server.ts
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { z } from "zod";
import { loadIndex, search, getDoc } from "./index/index.js";

const index = await loadIndex(process.env.INDEX_URL!);

function createServer() {
  const server = new McpServer(
    { name: "griddo-dx-docs", version: "1.0.0" },
    { instructions: SERVER_INSTRUCTIONS }
  );

  server.tool(
    "search_griddo_dev_docs",
    SEARCH_DESCRIPTION,
    { query: z.string(), section: z.enum(SECTIONS).optional() },
    async ({ query, section }) => {
      const results = await search(index, query, { section, topK: 8, maxChars: 30_000 });
      return { content: [{ type: "text", text: JSON.stringify({ results }) }] };
    }
  );

  server.tool(
    "get_griddo_dev_doc",
    GET_DOC_DESCRIPTION,
    { path: z.string() },
    async ({ path }) => {
      const doc = getDoc(index, path);
      if (!doc) {
        return {
          content: [{ type: "text", text: `No existe el documento '${path}'. Usa search_griddo_dev_docs para localizar la ruta correcta.` }],
          isError: true
        };
      }
      return { content: [{ type: "text", text: doc.content }] };
    }
  );

  return server;
}

// Stateless: una instancia de servidor y transporte por petición.
// Sin sesiones que mantener, escala horizontalmente sin estado compartido.
async function handleMcpRequest(req, res) {
  const server = createServer();
  const transport = new StreamableHTTPServerTransport({ sessionIdGenerator: undefined });
  res.on("close", () => { transport.close(); server.close(); });
  await server.connect(transport);
  await transport.handleRequest(req, res, req.body);
}
```

### 8.3 Endpoints

| Ruta | Método | Función |
|---|---|---|
| `/mcp` | POST | Endpoint MCP |
| `/mcp` | GET | 405 (stateless, sin stream de servidor) |
| `/health` | GET | `{ ok: true, indexVersion, chunkCount }` — para el health check de App Runner |
| `/` | GET | Landing HTML con instrucciones de instalación (§11.1) |

### 8.4 Estructura del repo

```
griddo-dx-docs-mcp/
├── src/
│   ├── server.ts           # bootstrap MCP + HTTP
│   ├── tools/
│   │   ├── search.ts
│   │   └── get-doc.ts
│   ├── index/
│   │   ├── load.ts         # carga y cachea el artefacto desde S3
│   │   ├── bm25.ts
│   │   ├── dense.ts
│   │   └── fusion.ts       # RRF
│   ├── auth/               # passthrough en v1, OAuth en v1.2
│   └── telemetry.ts
├── scripts/
│   ├── build-index.ts      # ejecutado por CI en el monorepo
│   └── eval.ts             # corre el eval set, reporta recall@k
├── eval/
│   └── queries.jsonl       # 50 preguntas reales con docs esperados
├── public/
│   └── index.html          # landing
├── Dockerfile
└── package.json
```

Repositorio propio, público. El código no tiene secretos y ser público facilita que las agencias partner lo inspeccionen y que aparezca en el MCP Registry. Alineación con el ciclo del producto (D7) vía el workflow del monorepo, que dispara el redeploy.

---

## 9. Infraestructura

| Recurso | Configuración |
|---|---|
| Cómputo | AWS App Runner, 1 vCPU / 2 GB, autoscaling 1–5 instancias |
| Dominio | `dx.mcp.griddo.io` → App Runner custom domain |
| Certificado | ACM, validación DNS por Route 53 |
| Almacén de índice | S3 `griddo-dx-docs-index`, versionado por commit SHA |
| Registry de imagen | ECR |
| Logs | CloudWatch Logs, retención 90 días |
| WAF | AWS WAF con rate-based rule (§10.1) |

**Alternativa más barata:** Lambda + Function URL con el índice empaquetado en la imagen. Elimina el coste de instancia siempre encendida a cambio de arranques en frío de 1–3 s. Recomendable si el tráfico resulta esporádico; App Runner si se quiere latencia predecible desde el minuto uno. Empezar con App Runner y medir.

**Carga del índice:** al arrancar, desde `s3://griddo-dx-docs-index/latest/index-public.json`. Refresco cada 15 minutos comparando el ETag, para captar actualizaciones sin esperar al redeploy.

---

## 10. Seguridad y límites

### 10.1 Rate limiting

Endpoint público sin autenticación. El limitado por IP es débil pero suficiente contra abuso trivial:

| Regla | Límite |
|---|---|
| Por IP | 100 peticiones / 5 min (AWS WAF rate-based) |
| Global | 50 req/s antes de aplicar throttling |
| Longitud de query | 500 caracteres máx., rechazo con error explícito |
| Tamaño de body | 64 KB máx. |

### 10.2 Superficie

- Solo lectura. Ninguna tool muta estado.
- Sin ejecución de código, sin plantillas, sin evaluación de expresiones sobre la query.
- El índice se sirve desde memoria; no hay backend consultable desde la query.
- La query se usa exclusivamente como texto de búsqueda: no se interpola en ninguna consulta ni en el prompt de ningún modelo.
- CORS: `Access-Control-Allow-Origin: *` en `/mcp` (necesario para clientes web como ChatGPT).

### 10.3 Privacidad

Las queries de los developers pueden contener fragmentos de código de clientes. Se registra la query en claro para el análisis de huecos de documentación (§10.4). Consecuencias:

- Retención 90 días, después borrado automático.
- Sin almacenamiento de IP junto a la query en el log de análisis (van a logs separados).
- Documentar la política en la landing del endpoint.

### 10.4 Observabilidad

Por cada llamada a `search_griddo_dev_docs` se registra:

```json
{
  "ts": "2026-09-08T10:23:00Z",
  "tool": "search_griddo_dev_docs",
  "query": "how do I paginate useList",
  "section": null,
  "results_returned": 8,
  "top_score": 0.81,
  "zero_results": false,
  "client_name": "claude-code",
  "latency_ms": 47
}
```

**Este log es el activo más valioso del proyecto.** Un informe semanal automático de las queries con `zero_results: true` o `top_score` bajo alimenta directamente el backlog de documentación. Es la única forma sistemática de saber qué le falta a la doc.

Métricas en CloudWatch: p50/p95 de latencia, tasa de cero-resultados, llamadas por día, clientes distintos.

---

## 11. Distribución

Astro dedica más esfuerzo a la distribución que a la implementación. Es la parte que decide si el servidor se usa.

### 11.1 Página de instalación

Dos superficies:

- **`mcp.griddo.io`** — directorio de los servidores MCP de Griddo. Una tabla con qué sirve cada uno, a quién, y el bloque de instalación. Es la página a la que se enlaza desde fuera y la que evita que un developer conecte el MCP equivocado.
- **`dx.griddo.io/build-with-ai/`** — página específica de este servidor dentro de la doc de developer, con config copy-paste por herramienta.

Cobertura mínima de clientes:

| Cliente | Método |
|---|---|
| Claude Code | `claude mcp add --transport http griddo-dx-docs https://dx.mcp.griddo.io/mcp` |
| Claude.ai / Desktop | Custom connector con la URL |
| Cursor | Deeplink `cursor://anysphere.cursor-deeplink/mcp/install?...` |
| VS Code | Deeplink `vscode:mcp/install?...` |
| Codex CLI | Bloque `[mcp_servers.griddo-dx-docs]` en `~/.codex/config.toml` |
| Windsurf, Zed, Warp, Raycast | JSON de configuración |
| Fallback genérico | `npx -y mcp-remote https://dx.mcp.griddo.io/mcp` para clientes sin streamable HTTP |

Config genérica:

```json
{
  "mcpServers": {
    "griddo-dx-docs": {
      "type": "http",
      "url": "https://dx.mcp.griddo.io/mcp"
    }
  }
}
```

Nota de implementación: en configuraciones JSON de Claude Code, `type` acepta tanto `http` como `streamable-http`. Una entrada con `url` y sin `type` se interpreta como stdio y falla.

### 11.2 Integración con el plugin `griddo-dx`

Añadir `.mcp.json` en la raíz del plugin, en el repo del marketplace:

```json
{
  "mcpServers": {
    "griddo-dx-docs": {
      "type": "http",
      "url": "https://dx.mcp.griddo.io/mcp"
    }
  }
}
```

Instalar el plugin conecta el MCP automáticamente. Requiere bump de versión del plugin en el marketplace.

Consecuencia sobre el diseño del plugin: las skills deben dejar de duplicar contenido de referencia que ahora vive en el MCP, y pasar a instruir al agente para que lo consulte. Es una revisión posterior, no bloqueante para el lanzamiento del MCP.

### 11.3 MCP Registry

Publicar en el registry oficial con `server.json`:

```json
{
  "$schema": "https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json",
  "name": "io.griddo/dx-docs",
  "title": "Griddo DX Docs",
  "description": "Documentación oficial de desarrollo de Griddo, el DXP para universidades.",
  "version": "1.0.0",
  "remotes": [
    { "type": "streamable-http", "url": "https://dx.mcp.griddo.io/mcp" }
  ]
}
```

Namespace verificado por DNS sobre `griddo.io`. Publicación con `mcp-publisher login dns` + `mcp-publisher publish`.

### 11.4 `llms.txt`

Complemento barato para las herramientas que aún no hablan MCP. Si `docs.griddo.io` es Starlight, `@astrojs/starlight-llms-txt` lo genera automáticamente. Medio día.

Sirve además `/llms-full.txt` y una versión `.md` de cada página (`dx.griddo.io/x/y.md`), que es lo que consumen los agentes con solo herramienta de fetch.

---

## 12. Calidad y criterios de aceptación

### 12.1 Eval set

**Sin esto no sabemos si el servidor funciona.** 50 preguntas reales, extraídas de:

- Tickets de soporte de agencias partner
- Preguntas frecuentes del equipo interno
- Los casos de uso que ya cubren las 10 skills del plugin `griddo-dx`

Formato `eval/queries.jsonl`:

```jsonl
{"query": "cómo pagino los resultados de useList", "expected_docs": ["building-blocks/hooks/use-list"], "lang": "es"}
{"query": "how do I add a custom field to a module schema", "expected_docs": ["building-blocks/schemas/schemas-de-datos"], "lang": "en"}
```

**Composición obligatoria:**
- 40% de queries en inglés sobre contenido en español (§6.3)
- 30% con identificador exacto (`useGriddoImage`, `configTabs`)
- 30% conceptuales sin terminología exacta

### 12.2 Criterios de aceptación

| Métrica | Umbral | Cómo se mide |
|---|---|---|
| Recall@5 | ≥ 0.85 | `npm run eval` sobre las 50 queries |
| Recall@5 en subconjunto EN→ES | ≥ 0.80 | Mismo script, filtrado por `lang: en` |
| Latencia p95 | < 500 ms | Carga sintética, 50 req/s |
| Disponibilidad | ≥ 99.5% | CloudWatch, ventana de 30 días |
| Frescura del índice | < 30 min desde merge a main | Timestamp en `/health` |
| Fuga de contenido | 0 documentos `partner`/`internal` en `index-public` | Test automatizado en CI |

El eval corre en CI en cada PR del repo del MCP. Una regresión de recall bloquea el merge.

---

## 13. Plan de ejecución

| Fase | Entregable | Criterio de salida | Duración |
|---|---|---|---|
| **0. Spike** | MCP "hello world" con resultados fijos, desplegado en `dx.mcp.griddo.io`, conectado desde Claude Code y Cursor | Ambos clientes listan las tools y reciben respuesta | 1 día |
| **1. Corpus** | 228 docs migrados al monorepo con frontmatter completo y `visibility` clasificado. Linter en CI. | `npm run docs:lint` pasa en verde | 4–5 días |
| **2. Índice** | `build-index` funcional, embeddings elegidos, artefacto en S3, eval set de 50 queries construido | Recall@5 ≥ 0.85 con el modelo elegido | 5 días |
| **3. Tools** | `search_griddo_dev_docs` y `get_griddo_dev_doc` en producción sobre el índice real | Criterios de §12.2 cumplidos | 3 días |
| **4. Producción** | WAF, rate limiting, telemetría, sync automático, informe semanal de huecos | Health check verde 72 h, primer informe generado | 3 días |
| **5. Distribución** | Página de instalación, `.mcp.json` en el plugin, MCP Registry, `llms.txt` | 5 developers conectados y usándolo | 3 días |

**Total: ~4 semanas** para un desarrollador backend TypeScript a dedicación completa. No se requiere perfil de ML.

La Fase 1 tiene dependencia externa (clasificación de visibilidad, §3) que puede correr en paralelo a la Fase 0.

### Post-v1

| Versión | Contenido |
|---|---|
| v1.1 | `list_griddo_dev_docs`, `report_griddo_dev_docs_gap`, refinado de ranking con datos reales |
| v1.2 | OAuth 2.1 con DCR, índice `partner` accesible a agencias autenticadas |
| v1.3 | Versionado del corpus por release de Griddo (`?version=` en las tools) |

---

## 14. Riesgos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| La doc del monorepo se desincroniza del producto | Alto — el MCP pierde su única ventaja sobre el modelo base | Docs en el mismo PR que el código. Regla de review en el monorepo. |
| Recall pobre en queries EN→ES | Alto — fallo silencioso, el agente responde mal con confianza | Eval set con 40% de queries en inglés como puerta de calidad |
| Fuga de contenido `partner` al índice público | Alto — exposición de API interna | Default `internal`, test automatizado en CI, revisión humana de la clasificación |
| El agente no llama a la tool | Alto — el servidor existe pero nadie lo usa | Descripciones de tool trabajadas (§7), instrucciones de servidor (§7.4), medición de llamadas por cliente |
| Colisión con el MCP de AX docs | Alto — el agente responde preguntas de desarrollo con doc del backoffice, sin señal de error | Nombres de servidor y tools disjuntos, fronteras explícitas en las descripciones, 5 queries fronterizas en el eval (§7.5) |
| Duplicación con el plugin | Medio — mantenimiento doble, respuestas inconsistentes | Reparto explícito procedural/declarativo (§1), revisión de skills tras el lanzamiento |
| `source_url` sin sitio publicado | Medio — bloquea Fase 1 | Decisión O1 antes del kickoff |
| Coste de embeddings en rebuilds | Bajo | Cache por hash de chunk |

---

## 15. Decisiones abiertas

| # | Decisión | Quién | Bloquea |
|---|---|---|---|
| O1 | Confirmar que `dx.griddo.io` será el sitio público de la doc de developer y que cumple los requisitos de §5.4 (anclas estables, slugs derivados del path) | Dani + equipo de docs | Fase 1 |
| O6 | El MCP de AX adopta `ax.mcp.griddo.io` y los nombres de tool disjuntos de §7.5, antes de salir a producción | Dani + responsable del MCP de AX | Previo al kickoff |
| O7 | Confirmar que los MCP internos (Atlas, logs) quedan fuera del árbol `*.mcp.griddo.io` | Plataforma | Fase 4 |
| O2 | Clasificación `visibility` de los 228 documentos, en particular API Privada | Producto + Plataforma | Fase 1 |
| O3 | Modelo de embeddings, decidido por resultado del eval | Desarrollo | Fase 2 |
| O4 | App Runner vs Lambda, según patrón de tráfico esperado | Plataforma | Fase 4 |
| O5 | Repo del MCP público o privado | Dani | Fase 0 |

---

## Anexo A — Referencias

- [Astro Docs MCP Server (repo)](https://github.com/withastro/docs-mcp) — la implementación que replicamos
- [Building Astro sites with AI tools](https://docs.astro.build/en/guides/build-with-ai/) — su página de distribución, plantilla para §11.1
- [MCP — Transports](https://modelcontextprotocol.io/specification/2026-07-28/basic/transports)
- [Claude Code — MCP](https://code.claude.com/docs/en/mcp)
- [Claude Code — Plugins reference](https://code.claude.com/docs/en/plugins-reference)
- [kapa.ai — Hosted MCP server](https://docs.kapa.ai/retrieval/hosted-mcp-server) — referencia de diseño de tools y parámetros

## Anexo B — Documentos relacionados

Este documento vive en `Griddo-DXDocs-MCP/`, separado de `AgentDoc/`, porque son dos superficies de interacción distintas: `AgentDoc/` cubre el plugin y los agentes; `Griddo-DXDocs-MCP/` cubre el servidor MCP. Las rutas siguientes son relativas a la raíz del workspace.

- `AgentDoc/_specs/griddo-dx-chatbot-brief.md` — preparación del corpus (consolidación desde Notion, Progressive Disclosure, criterios de chunking). Sigue vigente y es el input directo de la Fase 1 (§13).
- `AgentDoc/_specs/Tech_Spec_Griddo_DEV_KB_Agent.md` — **superado por este documento** en lo relativo a retrieval e infraestructura. Su stack (FastAPI + MongoDB Atlas + Voyage + Zendesk) está sobredimensionado para un corpus de 1 MB. Sigue siendo válido como spec del chatbot web con deflección de tickets, que es un producto distinto.
- `AgentDoc/01-consolidated/` — los 228 documentos que constituyen el corpus, ya limpios de artefactos de Notion. Origen de la migración descrita en §5.1.
- `AgentDoc/griddo-dx/` — plugin publicado en el marketplace. Reparto de responsabilidades con el MCP en §1; integración vía `.mcp.json` en §11.2.
- `Griddo-DX-Vision.md` — contexto estratégico.
