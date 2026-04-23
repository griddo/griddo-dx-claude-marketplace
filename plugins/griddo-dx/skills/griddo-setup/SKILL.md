---
name: griddo-setup
description: "Guía de configuración y setup de proyectos Griddo. Usar cuando el developer necesita: configurar un proyecto nuevo, entender la estructura del proyecto, variables de entorno, griddo.config, clonar el Starter, primeros pasos con Griddo."
---

# Skill: griddo-setup

## Cuándo usar esta skill

Usa esta skill cuando el developer necesita:

- Clonar y configurar un proyecto Griddo nuevo desde el Starter
- Entender la estructura del repositorio y archivos de configuración
- Configurar variables de entorno (.env)
- Comprender qué es `griddo.config.ts` y cómo modificarlo
- Establecer idiomas, temas y menús
- Lanzar el editor, renders o servicios de sincronización
- Configurar hooks SSR, Browser y Config APIs
- Entender los puntos de entrada del proyecto (`src/index.ts`, `/griddo.root.tsx`)
- Primeros pasos con módulos, templates y datos en Griddo

## Pasos que debe seguir Claude

### 1. Diagnosticar la necesidad del developer

Primero, entiende qué necesita el developer:
- ¿Es un proyecto completamente nuevo o uno existente?
- ¿Necesita help clonando el Starter o está configurando un repo ya clonado?
- ¿Qué parte de la configuración necesita: variables de entorno, idiomas, themes, o módulos?

### 2. Leer los archivos relevantes

Consulta los referencias según la necesidad:
- Para **configuración inicial**: `references/project-setup.md`
- Para **primeros módulos y datos**: `references/getting-started-tutorials.md`

### 3. Guiar paso a paso

Proporciona instrucciones claras y en orden:

1. **Clone y requisitos**: Verifica Node v20.19.2 y yarn v1.22.22
2. **Instalación**: `yarn install`
3. **Configuración de idiomas**: Edita `src/schemas/config/languages.ts`
4. **Variables de entorno**: Copia `.env-example` a `.env`, configura credenciales y URLs
5. **griddo.config.ts**: Revisa los schemas exportados (config, ui, contentTypes, forms, autotypes)
6. **Archivos de entrada**: Explica `src/index.ts`, `griddo.root.tsx`, y los builders (ssr, browser, config)

### 4. Proporcionar ejemplos de código

Cuando muestres código:
- Mantén **exacto** el formato del código fuente
- Indica si es TypeScript o JavaScript
- Explica qué hace cada parte del código
- Señala qué partes son opcionales (ej: `forms`, `autotypes`)

### 5. Recordar contextos de ejecución

Explica cuándo se usan ciertos servicios:
- `yarn start:editor` → Para trabajar en el editor visual
- `yarn render` → Para generar páginas estáticas en local
- `yarn sync-schemas` → Para sincronizar schemas con la API
- `yarn autotypes` → Para generar types de TypeScript automáticamente
- `yarn storybook` → Para desarrollo frontend aislado

### 6. Vincular a tutoriales

Si el developer quiere crear su primer módulo, dato simple, o configuración de datos, apunta a los tutoriales compilados en `references/getting-started-tutorials.md`.

## Referencia rápida de archivos críticos

| Archivo | Propósito | Editable |
|---------|----------|----------|
| `.env` | Variables de entorno y credenciales | Sí |
| `griddo.config.ts` | Exporta todos los schemas (config, ui, contentTypes) | Raro |
| `src/index.ts` | Exporta bundle, SiteProvider, builders para Editor y Render | Sí |
| `src/schemas/config/languages.ts` | Define idiomas soportados | Sí |
| `griddo.root.tsx` | Punto principal de render con SiteProvider y themes | Sí |
| `builder.ssr.js` | Hooks de SSR (inyecta componentes en head/body) | Sí |
| `builder.browser.js` | Hooks de Browser (eventos del navegador) | Sí |
| `builder.config.js` | Configuración de plugins de Gatsby | Sí |
| `/static` | Archivos estáticos (imágenes, tipografías, CSS) | N/A |

## Detalles de configuración clave

### Variables de entorno esenciales

```
GRIDDO_API_URL              # URL del API interno
GRIDDO_PUBLIC_API_URL       # URL del API público
GRIDDO_BOT_USER             # Email de la cuenta bot
GRIDDO_BOT_PASSWORD         # Contraseña del bot
REACT_APP_FROALA_KEY        # Key del editor de texto Froala
developerkey                # Developer key
```

### Variables de render (opcionales pero importantes)

```
GRIDDO_RENDER_CONCURRENCY_COUNT     # Número de conexiones simultáneas a DB
GRIDDO_RENDER_BUILD_LOGS            # Habilita logs de render
GRIDDO_RENDER_SEARCH_FEATURE        # Indexa contenido para búsqueda
GRIDDO_RENDER_DISABLE_LLMS_TXT      # Desactiva generación de llms.txt
GRIDDO_RENDER_ENABLED_LLM_MD        # Activa generación de .md por página
```

### Estructura de griddo.config.ts

```
config      → Esquemas de configuración (menus, themes, languages, etc.)
ui          → Componentes, módulos y templates
contentTypes → ContentTypes, dataPacks, structuredData
forms       → (Opcional) Templates y fields de formularios
autotypes   → (Opcional) Configuración de generación automática de types
```

## Referencias disponibles

Consulta estos archivos para guías detalladas:

- **`references/project-setup.md`** — Configuración completa del proyecto, requisitos, instalación, variables de entorno, griddo.config, archivos de entrada, servicios, ESLint + Prettier, Dimensions API
- **`references/getting-started-tutorials.md`** — Tutoriales paso a paso: primer módulo, datos simples, datos de página, colecciones + render, SSR, y contenido para LLMs

## Notas importantes

- **No uses `npm`**, solo `yarn`
- **Node v20.19.2** es la versión soportada
- El Starter viene pre-configurado, no edites `griddo.config.ts` a menos que Griddo lo pida
- Los schemas siempre deben sincronizarse con `yarn sync-schemas` después de cambios
- El editor y render son servicios separados; entiende cuándo usar cada uno
- Storybook es excelente para desarrollo frontend sin el editor de Griddo
- Los módulos siempre necesitan schema, UI (React) y exportación en los index
- Usa AutoTypes (`yarn autotypes`) para tipar automáticamente tus módulos desde el schema
