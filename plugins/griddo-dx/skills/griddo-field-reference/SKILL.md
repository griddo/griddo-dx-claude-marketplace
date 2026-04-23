---
name: griddo-field-reference
description: >
  Usar esta skill cuando el developer pregunte "qué field uso", "campo de formulario",
  "field type", "qué opciones de campo hay", "propiedades de TextField",
  "cómo uso ImageField", o necesite consultar la referencia de tipos de campo de Griddo.
---

# Referencia de Fields de Griddo

Esta skill te ayuda a elegir y configurar los diferentes tipos de campos disponibles en Griddo DX. Los fields son los componentes base para construir formularios, esquemas de configuración y estructuras de datos.

## Uso de esta Skill

Cuando un developer:
- Pregunta qué tipo de campo usar para un caso específico
- Necesita saber las propiedades disponibles de un field
- Quiere ver ejemplos de configuración de campos
- Busca información sobre validación o comportamiento de campos
- Pregunta cómo combinar múltiples campos

**Debes:**
1. Consultar la tabla rápida a continuación para una respuesta inmediata
2. Para detalles completos sobre propiedades, comportamiento y ejemplos avanzados, refiere al developer a `references/fields-catalog.md`
3. Si pregunta sobre patrones comunes (formulario de contacto, galería, etc.), proporciona ejemplos de `references/field-patterns.md`

## Quick Reference - 15 Fields Más Usados

| Field | Tipo | Uso Principal | Key Ejemplo |
|---|---|---|---|
| **TextField** | Texto corto | Títulos, subtítulos, etiquetas | `title`, `name`, `slug` |
| **TextArea** | Texto largo | Descripciones, resúmenes | `description`, `summary` |
| **ImageField** | Imagen con DAM | Imágenes con procesamiento | `image`, `backgroundImage` |
| **LinkField** | Link interno/externo | Enlaces combinados | `link`, `cta` |
| **Select** | Dropdown | Opciones fijas | `theme`, `variant`, `status` |
| **RadioGroup** | Radio buttons | Selección única visible | `layout`, `alignment` |
| **CheckGroup** | Checkboxes | Múltiples selecciones | `features`, `options` |
| **TagsField** | Array de strings | Tags, categorías | `tags`, `keywords` |
| **NumberField** | Números | Cantidades, índices | `itemsPerPage`, `columns` |
| **DateField** | Fecha/datetime | Eventos, publicación | `publishDate`, `eventDate` |
| **ToggleField** | Boolean | Flags simples | `active`, `featured`, `visible` |
| **ColorPicker** | Color HEX | Colores de UI | `background`, `accent` |
| **ReferenceField** | Link a ContentType | Datos estructurados | `relatedContent`, `author` |
| **ArrayField** | Array complejo | Datos estructurados repetibles | `items`, `slides`, `elements` |
| **ConditionalField** | Múltiples tipos | Campos dinámicos | `metadata`, `config` |

## Propiedades Comunes

Estos son los parámetros que pueden usarse en **casi todos los fields:**

```typescript
{
  type: "FieldType",           // Nombre del field
  key: "myField",              // Clave única en camelCase
  title: "My Field",           // Label visible en editor
  
  // Validación y comportamiento
  mandatory: false,            // ¿Es obligatorio?
  readonly: false,             // ¿Es solo lectura?
  hidden: false,               // ¿Oculto en editor?
  hideable: false,             // ¿Puede ser ocultado por editores?
  
  // Ayuda y ejemplos
  helptext: "Describir...",    // Texto de ayuda
  placeholder: "Ej: texto",    // Placeholder/ejemplo
  
  // Comportamiento avanzado
  computed: () => {},          // Función para calcular valor
  humanReadable: true,         // ¿Para traducciones IA?
  isMockup: false,             // ¿Validador lo marca como plantilla?
}
```

## Campos Específicos - Usos Comunes

### Campos de Texto
- **TextField** - Textos cortos sin formato (títulos, nombres)
- **TextArea** - Textos medianos con saltos de línea
- **RichText / WYSIWYG** - Texto enriquecido con formato HTML

### Campos de Media
- **ImageField** - Imágenes procesadas con DAM
- **FileField** - Archivos descargables
- **ColorPicker** - Colores HEX para UI

### Campos de Relaciones
- **LinkField** - Links internos o externos
- **ReferenceField** - Relaciones con otros ContentTypes
- **ComponentContainer** - Inyectar componentes dinámicamente

### Campos de Datos
- **Select** - Dropdown con opciones fijas
- **AsyncSelect** - Dropdown con opciones cargadas dinámicamente
- **RadioGroup** - Radio buttons (selección única)
- **CheckGroup** - Checkboxes (múltiples)
- **TagsField** - Lista de tags editables

### Campos Estruturados
- **ArrayField** - Array de campos complejos
- **ArrayFieldGroup** - Agrupación para arrays
- **FieldGroup** - Agrupación de campos normales
- **ConditionalField** - Campos que aparecen según condiciones

## Propiedades por Tipo de Field

### ImageField
```typescript
{
  type: "ImageField",
  key: "image",
  title: "Image",
  
  // Específicas de imagen
  alt: false,              // ¿Requiere alt?
  title: false,            // ¿Requiere título?
  crop: "cover",           // Modo crop: "cover", "contain", etc.
  formats: ["webp"],       // Formatos procesados
  quality: 75,             // Calidad de compresión
}
```

### Select
```typescript
{
  type: "Select",
  key: "theme",
  title: "Theme",
  
  options: [
    { value: "dark", label: "Dark Mode" },
    { value: "light", label: "Light Mode" }
  ],
  
  mandatory: false,        // Si no es obligatorio, añade opción vacía
}
```

### ReferenceField
```typescript
{
  type: "ReferenceField",
  key: "author",
  title: "Author",
  
  sources: [
    { structuredData: "PERSONAS" }
  ],
  
  selectionType: ["auto", "manual"],  // Cómo seleccionar
  limit: 1,                           // Máximo número de referencias
}
```

### ArrayField
```typescript
{
  type: "ArrayField",
  key: "items",
  title: "Items",
  
  fields: [
    { type: "TextField", key: "title" },
    { type: "ImageField", key: "image" }
  ],
  
  display: "dropdown",     // "dropdown" o "inline"
}
```

## Patrones de Campos Comunes

### Formulario de Contacto
```typescript
fields: [
  { type: "TextField", key: "name", title: "Nombre", mandatory: true },
  { type: "TextField", key: "email", title: "Email", mandatory: true },
  { type: "Select", key: "subject", title: "Asunto", 
    options: [
      { value: "info", label: "Información" },
      { value: "support", label: "Soporte" }
    ]
  },
  { type: "TextArea", key: "message", title: "Mensaje", mandatory: true },
  { type: "UniqueCheck", key: "subscribe", title: "Suscribirse" }
]
```

### Hero Section
```typescript
fields: [
  { type: "TextField", key: "title", title: "Título", mandatory: true },
  { type: "TextArea", key: "subtitle", title: "Subtítulo" },
  { type: "ImageField", key: "image", title: "Imagen de fondo" },
  { type: "LinkField", key: "cta", title: "Call to Action" }
]
```

### Galería de Imágenes
```typescript
fields: [
  {
    type: "ArrayFieldGroup",
    key: "gallery",
    title: "Galería",
    
    fields: [
      { type: "ImageField", key: "image", title: "Imagen" },
      { type: "TextField", key: "caption", title: "Pie de foto" }
    ]
  }
]
```

### Selector Condicional
```typescript
fields: [
  { type: "Select", key: "type", title: "Tipo", 
    options: [
      { value: "text", label: "Texto" },
      { value: "image", label: "Imagen" }
    ]
  },
  {
    type: "ConditionalField",
    key: "content",
    
    conditions: [
      {
        when: { key: "type", equals: "text" },
        then: { type: "RichText", key: "textContent" }
      },
      {
        when: { key: "type", equals: "image" },
        then: { type: "ImageField", key: "imageContent" }
      }
    ]
  }
]
```

## Notas Importantes

- **Propiedades dinámicas** - Algunos fields soportan `computed` para calcular valores dinámicamente
- **Validaciones personalizadas** - Usa `AsyncCheckGroup` para validaciones servidor
- **Traducción de contenido** - Marca campos con `humanReadable: true` para traducción automática con IA
- **Comportamiento en editor** - Los fields opcionales muestran opción vacía automáticamente

---

## Para Referencia Completa

Lee `references/fields-catalog.md` para la documentación exhaustiva de todas las propiedades, ejemplos avanzados y casos de uso de cada field.

Lee `references/field-patterns.md` para patrones comunes y combinaciones de campos recomendadas.
