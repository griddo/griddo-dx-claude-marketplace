---
name: griddo-content-type
description: >
  Usar esta skill cuando el developer pida "crear un content type", "nuevo tipo de dato",
  "crear dato estructurado", "structured data", "crear un schema de datos",
  o necesite definir un tipo de contenido para datos estructurados en Griddo.
---

# Skill: Crear content types Griddo

## Contexto
Los content types definen **qué datos estructura** la instancia Griddo. Son esquemas que permiten:
- Crear y editar datos estructurados en el editor
- Reutilizar esos datos en módulos vía ReferenceField
- Generar catálogos de información consistente

## Tres tipos de content types

### 1. Simple
Datos puros sin asociación a página. Ejemplos: SCHOOLS, MEMBERS, PRODUCTS.
- No tienen URL propia
- Se editan desde un formulario genérico
- Se consumen en módulos via ReferenceField

### 2. Page
Datos que generan una página detalle. Ejemplos: NEWS, EVENTS.
- Se crean via DetailTemplate
- Tienen URL propia (página detalle)
- Se reutilizan en módulos con acceso a `item.url`

### 3. Category (Taxonomía)
Datos que clasifican otros datos. Ejemplos: REGIONS, TOPICS.
- Son content type Simple con `taxonomy: true`
- Sirven para filtrar otros datos

## Proceso para generar un content type

### 1. Preguntar al developer
Si no está claro:
- **Nombre del tipo** (e.g., `SCHOOLS`, `NEWS`, `PRODUCTS`) — usa MAYÚSCULAS
- **¿Simple o Page?** ¿Tiene página detalle o solo datos reutilizables?
- **Campos editables** ¿Qué información almacena? (título, descripción, imagen, etc.)
- **¿Traducible?** ¿Se edita en múltiples idiomas?
- **¿Local?** ¿Específico de cada site o compartido entre sites?
- **¿Taxonomía?** ¿Sirve para clasificar otros datos?

### 2. Elegir el patrón
Leer `references/content-type-examples.md`:
- **Simple básico** — SCHOOLS (title, image, link)
- **Simple con más campos** — PRODUCTS (title, description, price, image)
- **Page** — NEWS, EVENTS (requieren DetailTemplate)

### 3. Generar el schema

#### Estructura Basic para Simple
```tsx
import { Schema } from "@griddo/core";

export const [NAME]: Schema.ContentType = {
  dataPacks: ["PACK_NAME"],  // DataPack al que pertenece
  title: "Display Name",     // Nombre legible
  local: true,               // true = por site, false = global
  translate: true,           // true = multiidioma
  taxonomy: false,           // false = no es categoría
  clone: null,               // null generalmente
  defaultValues: null,       // null generalmente
  fromPage: false,           // false = simple, true = page
  schema: {
    fields: [
      {
        key: "title",
        title: "Title",
        type: "TextField",
        mandatory: true,
      },
      {
        key: "image",
        title: "Image",
        type: "ImageField",
      },
      // ...más campos
    ],
  },
};
```

#### Para Page
```tsx
export const [NAME]: Schema.ContentType = {
  dataPacks: ["PACK_NAME"],
  title: "Display Name",
  local: true,
  fromPage: true,           // true = page
  translate: true,
  schema: {
    templates: ["TemplateDetail"],  // Templates asociados
    fields: [
      // Campos del dato
    ],
  },
};
```

#### Para Taxonomía
```tsx
export const [NAME]: Schema.ContentType = {
  dataPacks: ["PACK_NAME"],
  title: "Category Name",
  local: true,
  translate: true,
  taxonomy: true,           // true = es categoría
  fromPage: false,
};
```

### 4. Agregar campos

Tipos de campos disponibles:
- `TextField` — texto corto
- `TextArea` — texto largo
- `ImageField` — imagen
- `UrlField` — enlace
- `DateField` — fecha
- `NumberField` — número
- `Select` — desplegable con opciones
- `ToggleField` — sí/no
- `RichText` / `WysiwygField` — HTML editado

**Ejemplo de campo:**
```tsx
{
  key: "title",
  title: "Title",
  type: "TextField",
  mandatory: true,          // Obligatorio
  from: "title",            // Mapeo en API
}
```

### 5. Registrar el content type

En el archivo correspondiente:

**Para Simple:** `src/schemas/content-types/simple/index.ts`
```tsx
import { [NAME] } from "./[NAME]";

export default {
  ...,
  [NAME],
};
```

**Para Page:** `src/schemas/content-types/page/index.ts`
```tsx
import { [NAME] } from "./[NAME]";

export default {
  ...,
  [NAME],
};
```

### 6. Sincronizar con API
```bash
yarn sync-schemas
```

Esto:
- Crea el formulario en el editor
- Habilita creación de datos
- Genera endpoints de API

### 7. Si es Page: crear DetailTemplate
Si `fromPage: true`, se necesita un template detalle. Usar la skill `griddo-template` para crearlo.

## Propiedades especiales

### `local: true | false`
- `true` — cada site edita sus propios datos
- `false` — datos compartidos entre todos los sites

### `translate: true | false`
- `true` — se edita en todos los idiomas configurados
- `false` — un solo idioma

### `fromPage: true | false`
- `true` — genera página detalle (necesita DetailTemplate)
- `false` — solo datos reutilizables

### `taxonomy: true`
- Convierte el content type en categoría (solo para clasificación)
- No se puede combinar con `fromPage: true`

### Optional: `expirationDateField`
```tsx
expirationDateField: "endDate",
expirationDateOffset: 1,  // días de offset
```
Permite que datos expiren automáticamente en una fecha.

### Optional: `searchMapping` (Simple con búsqueda)
```tsx
searchMapping: {
  title: "title",
  description: "body",
  image: "image",
  url: "link",
}
```
Si incluir en búsqueda de IA. Requiere `includedInPageSearch: true`.

## Reglas de generación

- Siempre usar MAYÚSCULAS para el nombre del tipo (SCHOOLS, NEWS, PRODUCTS)
- Incluir `dataPacks` que especifica a qué pack pertenece
- Si `fromPage: true`, crear DetailTemplate asociado
- Si es taxonomía, solo campos básicos (sin `fromPage`)
- Preservar exactamente el código de ejemplos
- Ejecutar `yarn sync-schemas` después de crear

## Referencias
- `references/content-type-examples.md` — ejemplos reales: SCHOOLS, NEWS, MEMBER
