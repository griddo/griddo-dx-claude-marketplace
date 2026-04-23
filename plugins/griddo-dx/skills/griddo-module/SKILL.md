---
name: griddo-module
description: >
  Usar esta skill cuando el developer pida "crear un módulo", "nuevo módulo",
  "scaffold module", "make a module", "añadir módulo", o cuando necesite
  generar los archivos de un módulo Griddo (schema + componente React).
---

# Skill: Crear módulos Griddo

## Contexto
Los módulos Griddo son bloques reutilizables compuestos por un **schema de configuración** (que define qué campos editan desde el editor) y un **componente React** (que renderiza la interfaz).

## Proceso para generar un módulo

### 1. Preguntar al developer
Si no está claro, preguntar:
- **Nombre del módulo** (e.g., `BasicHero`, `CardCollection`, `NewsShowcase`)
- **Descripción y propósito** ¿Qué debe mostrar el módulo?
- **Campos editables** ¿Qué contenido edita el editor? (título, imagen, texto, colecciones, etc.)
- **Tabs en el editor** ¿Necesita separar la edición en tabs (content/config/style)?

### 2. Elegir el patrón
Leer el archivo `references/module-schema-patterns.md` para identificar el patrón más cercano:
- **Básico** — campos simples (TextField, ImageField)
- **Collection** — contiene múltiples componentes (ComponentArray)
- **Con datos estructurados** — consume datos via ReferenceField
- **Multi-tabs** — divide configuración en pestañas
- **Con API** — carga datos dinámicamente con hooks

### 3. Revisar esquemas existentes
Antes de generar, examinar esquemas del proyecto en `src/schemas/modules/` para:
- Seguir las convenciones locales de nombres y estructura
- Reutilizar patrones existentes
- Mantener consistencia de tipado

### 4. Generar los tres archivos

#### A. Schema (`src/schemas/modules/[Name].ts`)
- Incluir `schemaType: "module"`
- Definir `component` (nombre del componente React)
- Estructurar `configTabs` con campos editables
- Incluir siempre un `default` con valores de ejemplo
- Usar tipos de @griddo/core cuando sea posible

#### B. Componente React (`src/ui/modules/[Name]/index.tsx`)
- Importar types auto-generados desde `@/autotypes`
- Tipar las props con la interfaz generada
- Usar componentes de Griddo (@griddo/core): `GriddoImageExp`, `GriddoLink`, etc.
- Renderizar los datos del schema

#### C. Instrucciones de registro
El módulo debe exponerse en dos archivos index:

**En `src/ui/modules/index.tsx`:**
```tsx
const [Name] = React.lazy(() => import("./[Name]"));

const modules = {
  ...,
  [Name]
};

export { ..., [Name] };
```

**En `src/schemas/modules/index.ts`:**
```tsx
import [Name] from "./[Name]";

export default {
  ...,
  [Name]
};
```

### 5. Generar tipos automáticos
Después de crear schema y componente, ejecutar:
```bash
yarn autotypes
```

Esto genera types en `autotypes.d.ts` basados en el schema.

### 6. Asignar a templates (si aplica)
Si el módulo debe estar disponible en ciertos templates, editar el schema del template y agregar el módulo al `whiteList` de la sección correspondiente.

## Reglas de generación

- Siempre tipar las props del componente
- Incluir siempre un `default` en el schema con valores de ejemplo
- Preservar exactamente el código de ejemplos del documentación
- Si hay duda sobre fields disponibles, usar `references/module-examples.md`
- Para módulos complejos, documentar el flujo de datos en comentarios

## Referencias
- `references/module-schema-patterns.md` — 5 patrones con código completo
- `references/module-examples.md` — ejemplos reales extraídos de tutoriales
