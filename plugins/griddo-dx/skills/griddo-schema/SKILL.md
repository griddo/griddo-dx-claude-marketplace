---
name: griddo-schema
description: >
  Usar esta skill cuando el developer pregunte sobre schemas de Griddo, "configTabs",
  "schemaType", "cómo defino los campos", "schema de módulo", "schema de template",
  "schema de configuración", "schema de interfaz", o necesite entender el sistema de schemas.
---

# Referencia de Schemas de Griddo

Esta skill te ayuda a entender y crear schemas en Griddo. Los schemas definen la estructura de datos, la interfaz del editor, la configuración y los formularios. Son el corazón del sistema de contenido.

## Uso de esta Skill

Cuando un developer:
- Pregunta cómo definir campos de un módulo
- Necesita saber qué es un "schema de configuración"
- Quiere crear un template con propiedades dinámicas
- Busca cómo definir content types o formularios
- Pregunta sobre categorías, idiomas, o configuración

**Debes:**
1. Identificar qué **tipo de schema** necesita
2. Proporcionar estructura y ejemplos básicos
3. Refiere a los documentos específicos en `references/` para detalles completos
4. Incluye links a field-reference skill si necesita saber sobre campos específicos

## Los 4 Tipos de Schemas en Griddo

Griddo usa 4 categorías de schemas distintos, cada uno con propósito diferente:

### 1. Schemas de Configuración (Config Schemas)
**Qué son:** Configuración global del proyecto (idiomas, DAM, categorías).

**Dónde viven:** `src/schemas/config/`

**Archivos típicos:**
- `languages.ts` - Idiomas del sitio
- `dam.ts` - Configuración de imágenes
- `module-categories.ts` - Categorías de módulos

**Ejemplo - Idiomas:**
```typescript
import type { Schema } from "@griddo/core";

export const languages: Schema.Languages = [
  {
    code: 'es',
    label: 'Español',
    default: true,
    locale: 'es-ES'
  },
  {
    code: 'en',
    label: 'English',
    locale: 'en-US'
  }
];
```

**Ejemplo - DAM (Configuración de Imágenes):**
```typescript
export const damDefaults: Schema.DamDefaults = {
  quality: 75,
  crop: "cover",
  loading: "lazy",
  decoding: "async",
  formats: ["webp"],
};
```

---

### 2. Schemas de Interfaz (Interface Schemas)
**Qué son:** Definen cómo se ve la interfaz del editor (qué campos, en qué pestañas, cómo se organizan).

**Dónde viven:** `src/schemas/interface/`

**Ejemplos típicos:**
- Módulos (HeroModule, CardCollection, etc.)
- Templates de página
- Componentes editables

**Estructura Básica:**
```typescript
import { Schema } from "@griddo/core";

export const HeroModuleInterfaceSchema = {
  name: "HeroModule",
  category: "spacers",  // Categoría del editor
  icon: "hero",
  label: "Hero Section",
  
  configTabs: [
    {
      key: "content",
      label: "Contenido",
      
      fields: [
        {
          type: "TextField",
          key: "title",
          title: "Título",
          mandatory: true
        },
        {
          type: "TextArea",
          key: "subtitle",
          title: "Subtítulo"
        },
        {
          type: "ImageField",
          key: "backgroundImage",
          title: "Imagen"
        }
      ]
    },
    {
      key: "styling",
      label: "Estilos",
      
      fields: [
        {
          type: "Select",
          key: "theme",
          title: "Tema",
          options: [
            { value: "light", label: "Claro" },
            { value: "dark", label: "Oscuro" }
          ]
        }
      ]
    }
  ]
} satisfies Schema.InterfaceSchema;
```

**Partes Principales:**
- `name` - Identificador único
- `category` - Grupo en el editor
- `icon` - Ícono del editor
- `label` - Nombre visible
- `configTabs` - Organización de campos
- `defaults` - Valores por defecto

---

### 3. Schemas de Datos (Data Schemas / Content Types)
**Qué son:** Definen la **estructura de datos** para contenidos reutilizables (artículos, productos, personas).

**Dónde viven:** `src/schemas/data/` o `src/contentTypes/`

**Propósito:** Estos contenidos se **guardan en base de datos** y se cargan con `useList()` o `useContentType()`.

**Ejemplo - ContentType de Artículo:**
```typescript
import { Schema } from "@griddo/core";

export const ArticleContentType = {
  name: "articulos",
  label: "Artículos",
  slugKey: "slug",
  
  fields: [
    {
      type: "TextField",
      key: "title",
      title: "Título",
      mandatory: true
    },
    {
      type: "TextArea",
      key: "description",
      title: "Descripción"
    },
    {
      type: "RichText",
      key: "content",
      title: "Contenido",
      mandatory: true
    },
    {
      type: "ImageField",
      key: "featuredImage",
      title: "Imagen destacada"
    },
    {
      type: "DateField",
      key: "publishDate",
      title: "Fecha de Publicación",
      mandatory: true
    },
    {
      type: "TagsField",
      key: "tags",
      title: "Tags"
    }
  ]
} satisfies Schema.DataSchema;
```

**Diferencia Clave:**
- **Interface Schema** → Cómo se VE en el editor
- **Data Schema** → Cómo se ESTRUCTURA en BD

---

### 4. Schemas de Formularios (Form Schemas)
**Qué son:** Definen formularios para el frontend (formularios de contacto, suscripción, etc.).

**Dónde viven:** `src/schemas/forms/` o inline en módulos

**Propósito:** Capturar entrada de usuario y enviarla a un servicio.

**Ejemplo - Formulario de Contacto:**
```typescript
import { Schema } from "@griddo/core";

export const ContactFormSchema = {
  name: "contactForm",
  label: "Formulario de Contacto",
  
  fields: [
    {
      type: "TextField",
      key: "name",
      title: "Nombre",
      mandatory: true,
      placeholder: "Tu nombre"
    },
    {
      type: "TextField",
      key: "email",
      title: "Email",
      mandatory: true,
      placeholder: "tu@email.com"
    },
    {
      type: "TextArea",
      key: "message",
      title: "Mensaje",
      mandatory: true,
      placeholder: "Tu mensaje..."
    },
    {
      type: "CheckGroup",
      key: "consent",
      title: "Consentimiento",
      
      options: [
        {
          value: "privacy",
          title: "Acepto política de privacidad"
        }
      ]
    }
  ],
  
  submitLabel: "Enviar"
} satisfies Schema.FormSchema;
```

---

## Estructura Común: configTabs

La mayoría de schemas usan `configTabs` para organizar campos en pestañas:

```typescript
configTabs: [
  {
    key: "content",           // Identificador
    label: "Contenido",       // Texto visible
    icon: "edit",             // Ícono (opcional)
    
    fields: [
      // Array de fields
      { type: "TextField", key: "title", title: "Título" },
      // ... más fields
    ]
  },
  {
    key: "styling",
    label: "Estilos",
    
    fields: [
      // Más fields
    ]
  }
]
```

**Ventajas:**
- Mejor organización visual
- UX limpia en editor
- Escalable a muchos campos

---

## Propiedades Dinámicas (Computed)

Algunos schemas soportan propiedades **computed** que se calculan dinámicamente:

```typescript
fields: [
  {
    type: "TextField",
    key: "firstName",
    title: "Nombre"
  },
  {
    type: "TextField",
    key: "lastName",
    title: "Apellido"
  },
  {
    type: "TextField",
    key: "fullName",
    title: "Nombre Completo",
    readonly: true,
    
    // Se calcula automáticamente
    computed: (values) => {
      return `${values.firstName} ${values.lastName}`;
    }
  }
]
```

---

## Características Avanzadas

### 1. Contenidos que Expiran
Algunos content types tienen fecha de expiración:

```typescript
export const EventContentType = {
  name: "eventos",
  
  expiryField: "endDate",  // Campo que marca expiración
  expiryBehavior: "hide",  // "hide" o "archive"
  
  fields: [
    { type: "TextField", key: "name", title: "Evento" },
    { type: "DateField", key: "endDate", title: "Fecha final" }
  ]
};
```

### 2. Tematización (Theming)
Los schemas pueden soportar tematización:

```typescript
export const ThemedModule = {
  name: "CardSection",
  
  themes: {
    light: {
      colors: { bg: "#fff", text: "#000" }
    },
    dark: {
      colors: { bg: "#1a1a1a", text: "#fff" }
    }
  },
  
  fields: [
    // Fields que respetan el tema
  ]
};
```

### 3. Thumbnails para Editor
Mostrar preview en el editor:

```typescript
export const GalleryModule = {
  name: "Gallery",
  
  thumbnail: {
    field: "items",      // Array field
    imageField: "image", // Campo de imagen dentro del array
    limit: 4             // Mostrar 4 previews
  },
  
  fields: [
    // ...
  ]
};
```

---

## Flujo de Datos

```
Schemas Config (idiomas, DAM)
           ↓
    Proyecto configurado
           ↓
    ┌─────────────────────────────────┐
    │  Interface Schema (Módulos)     │
    │  → Editor de Griddo             │
    │  → Qué campos hay               │
    └─────────────────────────────────┘
           ↓ (Editor guarda)
    ┌─────────────────────────────────┐
    │  Data Schema (BD)               │
    │  → Estructura de datos          │
    │  → Base de datos                │
    └─────────────────────────────────┘
           ↓ (Frontend carga)
    ┌─────────────────────────────────┐
    │  useList(), usePage(), etc.     │
    │  → Mostrar contenido            │
    └─────────────────────────────────┘
```

---

## Mejores Prácticas

1. **Separa Interface de Data** - No mezcles ambos tipos
2. **Usa configTabs para organizar** - Máximo 8 campos por pestaña
3. **Proporciona defaults** - Siempre initializa valores
4. **Computed solo para derivados** - No para cálculos complejos
5. **Validates en formularios** - Mandatory y validaciones básicas
6. **Agrupa campos relacionados** - FieldGroup o ArrayFieldGroup
7. **Usa multiidioma si aplica** - Languages schema requerida
8. **Documenta con helptext** - Ayuda a editores

---

## Archivos de Referencia

Lee los siguientes para detalles específicos:

- **`schema-configuracion.md`** - Idiomas, DAM, categorías
- **`schema-interfaz.md`** - Módulos, templates, componentes
- **`schema-datos.md`** - ContentTypes, datos estructurados
- **`schema-formularios.md`** - Formularios para frontend
- **`propiedades-dinamicas.md`** - Computed properties
- **`content-types-expiran.md`** - Expiración de contenidos
- **`schema-table-patterns.md`** - Patrones comunes
- **`temificar-schemas.md`** - Tematización
- **`thumbnails-editor.md`** - Previews en editor

---

## Links Útiles

- **Fields Reference:** Usa la skill `griddo-field-reference` para ver tipos de campos disponibles
- **Hooks Reference:** Usa la skill `griddo-hooks` para cargar y acceder a los datos de schemas

