# Griddo DX Plugin

Plugin especializado en desarrollo de instancias Griddo — scaffolding de módulos, templates, content types, referencia completa de fields, hooks, API y schemas.

## ¿Qué hace este plugin?

El plugin Griddo DX te acompaña en cada etapa del desarrollo de una instancia Griddo:

- **Scaffolding**: genera código TypeScript/TSX listo para usar (módulos, templates, content types)
- **Referencia técnica**: consulta fields, hooks, API endpoints, patrones de schemas
- **Validación**: revisa que tus schemas cumplan convenciones y mejores prácticas
- **Guías**: tutoriales sobre configuración, performance, integraciones (SSO, SEO, AI Search, etc.)
- **Debugging**: ayuda a resolver errores de tipado, compilación, configuración

## Skills disponibles

| Skill | Descripción | Uso |
|-------|-------------|-----|
| `griddo-module` | Genera un módulo Griddo completo (schema + componente) | Crear módulo nuevo o modificar existente |
| `griddo-template` | Genera un template Griddo completo | Crear template nuevo |
| `griddo-content-type` | Define tipos de contenido y datos estructurados (JSON-LD, etc.) | Crear content type, microdatos |
| `griddo-field-reference` | Referencia de todos los field types y sus propiedades | ¿Qué field usar? Propiedades de un field |
| `griddo-hooks` | Referencia de hooks de @griddo/core | Cómo usar useGriddoImage, usePage, etc. |
| `griddo-api` | Endpoints REST de la API Griddo | Consultar endpoints, ejemplos |
| `griddo-schema` | Patrones avanzados de schemas | Validación, estructura, ComponentArray, etc. |
| `griddo-setup` | Configuración de proyectos nuevos, tutoriales | Clonar starter, .env, yarn scripts |
| `griddo-performance` | Optimización de rendimiento | Lazy-loading, code-splitting, imágenes |
| `griddo-guides` | Guías de integraciones complejas | SSO, GPX, AI Search, SEO, analytics |

## Agentes disponibles

| Agente | Descripción | Cuándo usar |
|--------|------------|-----------|
| `schema-reviewer` | Revisa y valida schemas contra convenciones de Griddo | "¿Está bien mi schema?", errores de compilación |

## Cómo instalar

### Requisito: Claude Code o Cowork

Este plugin funciona dentro de **Claude Code** o **Cowork**, que son interfaces de Claude especializadas en desarrollo.

### En Claude Code
1. Abre Claude Code en tu navegador
2. Ve a Settings → Plugins
3. Busca "Griddo DX"
4. Haz clic en "Install"
5. Confirma que tienes acceso a un proyecto Griddo en tu máquina

### En Cowork
1. Abre Cowork
2. Ve a la pestaña "Plugins"
3. Busca "Griddo DX"
4. Haz clic en "Install plugin"
5. Monta el directorio de tu instancia Griddo cuando se te pida

## Requisitos

- **Claude Code** o **Cowork** instalado
- Acceso a un proyecto/instancia Griddo en tu máquina (directorio de desarrollo)
- Node.js v20.19.2 y yarn v1.22.22
- Conocimientos básicos de TypeScript, React y CSS

## Estructura del plugin

```
griddo-dx/
├── CLAUDE.md               # Guía completa de contexto (siempre cargada)
├── .claude-plugin/
│   └── plugin.json         # Manifiesto del plugin
├── agents/
│   └── schema-reviewer.md  # Agente de validación de schemas
├── skills/                 # (Skills se definen en otros archivos)
└── README.md               # Este archivo
```

## Primeros pasos

### 1. Crear un módulo nuevo

```
user: "Crea un módulo Hero con título e imagen"
assistant: Usa la skill griddo-module
```

### 2. Entender qué field usar

```
user: "¿Qué field uso para un selector de opciones?"
assistant: Usa la skill griddo-field-reference
```

### 3. Revisar si tu schema está bien

```
user: "¿Está bien este schema?"
assistant: Usa el agente schema-reviewer
```

### 4. Usar un hook en tu componente

```
user: "Cómo uso useGriddoImage?"
assistant: Usa la skill griddo-hooks
```

## Notas importantes

- Todo código generado es **TypeScript/TSX** (no JavaScript)
- Todos los nombres siguen **PascalCase** (módulos, templates) y **camelCase** (fields)
- Los schemas siempre incluyen **`default`** con valores de ejemplo
- Los componentes siempre están **tipados** con props desde autotypes
- Sigue las convenciones del proyecto — el plugin las detecta automáticamente

## Soporte y documentación

Este plugin se alimenta de:
- Documentación oficial de Griddo
- Patrones y convenciones del Starter base
- Esquemas de instancias existentes

Para dudas profundas:
- Consulta [Griddo Docs](https://docs.griddo.io) (interno)
- Revisa ejemplos en el Starter base
- Abre una issue en el repositorio de Griddo

## Versión

**Griddo DX v0.1.0** — Previsualización

Desarrollado por Griddo para developers de instancias.
