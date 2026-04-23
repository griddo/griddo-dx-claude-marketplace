---
name: griddo-template
description: >
  Usar esta skill cuando el developer pida "crear un template", "nuevo template",
  "scaffold template", "crear una plantilla", o necesite generar los archivos
  de un template Griddo (schema + componente React con zonas de módulos).
---

# Skill: Crear templates Griddo

## Contexto
Los templates son estructuras de página que definen **dónde y qué módulos** pueden colocarse. Un template determina:
- La estructura general de la página (header, hero, contenido, footer)
- Las "zonas" o secciones donde se pueden insertar módulos
- El whitelist de módulos permitidos en cada zona
- El tipo de template (Static, Detail, List)

## Tipos de templates

### Static
Templates básicos para páginas estáticas. Disponibles por defecto.

### Detail
Plantillas que generan una página detalle basada en un content type. Se asocian a datos estructurados con `mode: "detail"`.

### List
Plantillas que renderizan listados paginables. Requieren `mode: "list"` y la propiedad `itemsPerPage`.

## Proceso para generar un template

### 1. Preguntar al developer
Si no está claro:
- **Nombre del template** (e.g., `BasicTemplate`, `BlogDetail`, `EventsList`)
- **Tipo** ¿Static, Detail o List?
- **Estructura de zonas** ¿Cuántas secciones? (Hero, Content, Footer)
- **Qué módulos** se permiten en cada zona
- **¿Necesita datos?** Si es Detail/List, ¿cuál es el content type?

### 2. Elegir el patrón
Leer `references/template-schema-patterns.md` para:
- **Static Template** — zonas simples con módulos
- **Detail Template** — campos editables + zonas
- **List Template** — con paginación e itemsPerPage

### 3. Generar el schema

#### Estructura básica
```tsx
export default {
  schemaType: "template",
  displayName: "[Name]",
  component: "[Name]",
  type: {
    label: "[Display Name]",
    value: "[value]",
    mode: "static|detail|list"  // Elige uno
  },
  content: [
    // Array de secciones (ComponentArray)
  ],
  default: {
    type: "template",
    templateType: "[Name]",
    // Valores por defecto de las secciones
  },
  thumbnails: {
    "1x": "/thumbnails/templates/[Name]/thumbnail@1x.png",
    "2x": "/thumbnails/templates/[Name]/thumbnail@2x.png",
  }
}
```

#### Secciones (ComponentArray)
Cada zona es un `ComponentArray` con:
- `type: "ComponentArray"`
- `title: "Section Name"`
- `whiteList: [Lista de módulos permitidos]`
- `key: "nombreSeccion"`
- `maxItems: 1` (opcional, limita cantidad)

#### Para Detail/List
- Agregar campos editables en `content[]`
- Incluir propiedades como `itemsPerPage` para List
- En `default`, incluir `getStaticData: true` si consume datos

### 4. Generar el componente React

#### Estructura básica
```tsx
import type { [Name]Props } from "@/autotypes";
import { GriddoModule } from "@ui/modules";

function [Name](props: [Name]Props) {
  const { heroSection, contentSection, footerSection } = props;

  return (
    <>
      {heroSection.modules?.map((module, idx) => (
        <GriddoModule key={idx} {...module} />
      ))}
      <main>
        {contentSection.modules?.map((module, idx) => (
          <GriddoModule key={idx} {...module} />
        ))}
      </main>
      {footerSection.modules?.map((module, idx) => (
        <GriddoModule key={idx} {...module} />
      ))}
    </>
  );
}

export default [Name];
```

**Puntos clave:**
- Usar `GriddoModule` para renderizar módulos dinámicamente
- Cada sección tiene array `modules[]`
- Acceder a props tipadas desde autotypes
- Estructurar HTML semántica (header, main, footer, etc.)

### 5. Registrar el template

En `src/schemas/templates/index.ts`:
```tsx
import [Name] from "./[Name]";

export default {
  ...,
  [Name]
};
```

### 6. Generar tipos automáticos
```bash
yarn autotypes
```

### 7. Sincronizar con API
Si el template afecta content types (Detail/List):
```bash
yarn sync-schemas
```

## Reglas especiales

### Templates Detail
- Requieren un content type asociado con `mode: "detail"`
- Incluir campos editables para los datos (title, image, body)
- Usar `getStaticData: true` en default
- El componente recibe los datos como props

### Templates List
- Requieren `itemsPerPage` en schema
- Incluir en `default`: `itemsPerPage: [número]`
- El componente recibe props: `pageNumber`, `totalPages`, `isFirstPage`, `baseLink`
- Se generan automáticamente páginas `/2`, `/3`, etc. en build

### Multi-Page Modules
- Si el template contiene un módulo MultiPage, ese módulo genera sub-páginas
- Usar `useRenderer()` y `usePage()` hooks en el módulo para saber contexto (AX o CX)

## Referencias
- `references/template-schema-patterns.md` — patrones Static, Detail, List
- `references/template-examples.md` — ejemplos reales del código
