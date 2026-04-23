# Patrones Comunes de Campos en Griddo

Esta documento contiene patrones recomendados para combinaciones de campos que resuelven problemas comunes en desarrollo con Griddo.

## 1. Formulario de Contacto

```typescript
// Patrón: TextField + Select + TextArea + UniqueCheck

const contactFormSchema = {
  configTabs: [
    {
      key: "content",
      label: "Contenido",
      
      fields: [
        {
          type: "TextField",
          key: "name",
          title: "Nombre",
          mandatory: true,
          placeholder: "Tu nombre completo",
          helptext: "Requerido para contacto"
        },
        {
          type: "TextField",
          key: "email",
          title: "Email",
          mandatory: true,
          placeholder: "tu@email.com",
          helptext: "Donde te responderemos"
        },
        {
          type: "Select",
          key: "subject",
          title: "Asunto",
          mandatory: true,
          
          options: [
            { value: "general", label: "Consulta General" },
            { value: "support", label: "Soporte Técnico" },
            { value: "sales", label: "Ventas" },
            { value: "press", label: "Prensa" }
          ]
        },
        {
          type: "TextArea",
          key: "message",
          title: "Mensaje",
          mandatory: true,
          placeholder: "Cuéntanos cómo podemos ayudarte...",
          helptext: "Mínimo 10 caracteres"
        },
        {
          type: "CheckGroup",
          key: "consent",
          title: "Consentimiento",
          
          options: [
            {
              value: "privacy",
              title: "Acepto la política de privacidad",
              name: "privacy"
            },
            {
              value: "marketing",
              title: "Deseo recibir información comercial",
              name: "marketing"
            }
          ]
        }
      ]
    }
  ]
};
```

## 2. Hero Section (Portada)

```typescript
// Patrón: TextField + TextArea + ImageField + LinkField

const heroSectionSchema = {
  configTabs: [
    {
      key: "content",
      label: "Contenido",
      
      fields: [
        {
          type: "TextField",
          key: "title",
          title: "Título Principal",
          mandatory: true,
          placeholder: "Ej: Bienvenido a Griddo",
          helptext: "Máximo 60 caracteres para mobile"
        },
        {
          type: "TextArea",
          key: "subtitle",
          title: "Subtítulo",
          placeholder: "Descripción breve del hero",
          helptext: "Aparece debajo del título"
        },
        {
          type: "ImageField",
          key: "backgroundImage",
          title: "Imagen de Fondo",
          mandatory: true,
          helptext: "Mínimo 1920x600px",
          alt: true,
          title: true
        },
        {
          type: "LinkField",
          key: "primaryCTA",
          title: "Botón Principal",
          helptext: "Link a página interna o externa"
        },
        {
          type: "LinkField",
          key: "secondaryCTA",
          title: "Botón Secundario",
          helptext: "Opcional - segundo CTA"
        }
      ]
    },
    {
      key: "styling",
      label: "Estilos",
      
      fields: [
        {
          type: "Select",
          key: "textAlign",
          title: "Alineación de Texto",
          
          options: [
            { value: "left", label: "Izquierda" },
            { value: "center", label: "Centro" },
            { value: "right", label: "Derecha" }
          ]
        },
        {
          type: "Select",
          key: "overlayOpacity",
          title: "Opacidad de Overlay",
          
          options: [
            { value: "0", label: "Sin overlay" },
            { value: "30", label: "Ligero (30%)" },
            { value: "50", label: "Medio (50%)" },
            { value: "70", label: "Fuerte (70%)" }
          ]
        },
        {
          type: "ColorPicker",
          key: "overlayColor",
          title: "Color del Overlay",
          colors: ["#000000", "#ffffff", "#ff0000"]
        }
      ]
    }
  ]
};
```

## 3. Galería de Imágenes (Grid)

```typescript
// Patrón: ArrayFieldGroup + ImageField + Campos de metadatos

const gallerySchema = {
  configTabs: [
    {
      key: "gallery",
      label: "Galería",
      
      fields: [
        {
          type: "TextField",
          key: "title",
          title: "Título de la Galería",
          mandatory: true
        },
        {
          type: "Select",
          key: "layout",
          title: "Distribución",
          
          options: [
            { value: "2cols", label: "2 columnas" },
            { value: "3cols", label: "3 columnas" },
            { value: "4cols", label: "4 columnas" },
            { value: "masonry", label: "Masonry" }
          ]
        },
        {
          type: "ArrayFieldGroup",
          key: "items",
          title: "Imágenes",
          
          fields: [
            {
              type: "ImageField",
              key: "image",
              title: "Imagen",
              mandatory: true,
              alt: true,
              title: true
            },
            {
              type: "TextField",
              key: "caption",
              title: "Pie de Foto",
              placeholder: "Descripción breve"
            },
            {
              type: "LinkField",
              key: "link",
              title: "Link (Opcional)",
              helptext: "Si se hace clic en imagen"
            }
          ]
        }
      ]
    }
  ]
};
```

## 4. Selector Condicional Dinámico

```typescript
// Patrón: Select + ConditionalField para campos dinámicos

const conditionalSchema = {
  configTabs: [
    {
      key: "content",
      label: "Contenido",
      
      fields: [
        {
          type: "Select",
          key: "contentType",
          title: "Tipo de Contenido",
          mandatory: true,
          
          options: [
            { value: "text", label: "Texto Enriquecido" },
            { value: "image", label: "Imagen" },
            { value: "video", label: "Video" },
            { value: "quote", label: "Cita" }
          ]
        },
        {
          type: "ConditionalField",
          key: "content",
          
          conditions: [
            {
              when: { key: "contentType", equals: "text" },
              then: {
                type: "RichText",
                key: "richtext",
                title: "Contenido"
              }
            },
            {
              when: { key: "contentType", equals: "image" },
              then: {
                type: "FieldGroup",
                key: "imageContent",
                title: "Contenido de Imagen",
                
                fields: [
                  {
                    type: "ImageField",
                    key: "image",
                    title: "Imagen",
                    mandatory: true
                  },
                  {
                    type: "TextField",
                    key: "caption",
                    title: "Pie de Foto"
                  }
                ]
              }
            },
            {
              when: { key: "contentType", equals: "video" },
              then: {
                type: "UrlField",
                key: "videoUrl",
                title: "URL del Video",
                placeholder: "https://youtube.com/..."
              }
            },
            {
              when: { key: "contentType", equals: "quote" },
              then: {
                type: "FieldGroup",
                key: "quoteContent",
                title: "Cita",
                
                fields: [
                  {
                    type: "TextArea",
                    key: "quote",
                    title: "Texto de la Cita",
                    mandatory: true
                  },
                  {
                    type: "TextField",
                    key: "author",
                    title: "Autor"
                  }
                ]
              }
            }
          ]
        }
      ]
    }
  ]
};
```

## 5. Lista de Enlaces con Descripción

```typescript
// Patrón: ArrayFieldGroup + LinkField + Campos de metadatos

const linkListSchema = {
  configTabs: [
    {
      key: "links",
      label: "Enlaces",
      
      fields: [
        {
          type: "TextField",
          key: "title",
          title: "Título de la Sección",
          mandatory: true
        },
        {
          type: "ArrayFieldGroup",
          key: "items",
          title: "Enlaces",
          
          fields: [
            {
              type: "TextField",
              key: "title",
              title: "Texto del Enlace",
              mandatory: true
            },
            {
              type: "LinkField",
              key: "link",
              title: "URL",
              mandatory: true,
              helptext: "Página interna o URL externa"
            },
            {
              type: "TextArea",
              key: "description",
              title: "Descripción",
              placeholder: "Breve descripción de dónde lleva"
            },
            {
              type: "ImageField",
              key: "icon",
              title: "Ícono (Opcional)"
            },
            {
              type: "ToggleField",
              key: "openInNewTab",
              title: "Abrir en nueva pestaña"
            }
          ]
        }
      ]
    }
  ]
};
```

## 6. Combinación de Datos Estructurados

```typescript
// Patrón: ReferenceField + Campos computados

const structuredDataSchema = {
  configTabs: [
    {
      key: "data",
      label: "Datos",
      
      fields: [
        {
          type: "TextField",
          key: "title",
          title: "Título"
        },
        {
          type: "ReferenceField",
          key: "relatedItems",
          title: "Elementos Relacionados",
          
          sources: [
            { structuredData: "ARTICULOS" },
            { structuredData: "PRODUCTOS" }
          ],
          
          selectionType: ["auto", "manual"],
          limit: 5
        },
        {
          type: "TextField",
          key: "itemCount",
          title: "Total de Elementos",
          readonly: true,
          
          computed: (values) => {
            return values.relatedItems?.length || 0;
          }
        }
      ]
    }
  ]
};
```

## 7. Formulario con Validaciones

```typescript
// Patrón: Campos con validaciones personalizadas

const validatedFormSchema = {
  configTabs: [
    {
      key: "form",
      label: "Formulario",
      
      fields: [
        {
          type: "TextField",
          key: "username",
          title: "Nombre de Usuario",
          mandatory: true,
          
          helptext: "Solo letras y números, 3-20 caracteres"
        },
        {
          type: "TextField",
          key: "email",
          title: "Email",
          mandatory: true,
          
          // Validación básica de email
          helptext: "Formato: user@example.com"
        },
        {
          type: "TextField",
          key: "password",
          title: "Contraseña",
          mandatory: true,
          
          helptext: "Mínimo 8 caracteres, incluir mayúscula, número"
        },
        {
          type: "UniqueCheck",
          key: "acceptTerms",
          title: "Acepto los términos y condiciones",
          mandatory: true
        }
      ]
    }
  ]
};
```

## 8. Configuración con Pestañas Múltiples

```typescript
// Patrón: Múltiples configTabs para organizar campos

const complexConfigSchema = {
  configTabs: [
    {
      key: "general",
      label: "General",
      icon: "settings",
      
      fields: [
        { type: "TextField", key: "name", title: "Nombre" },
        { type: "TextArea", key: "description", title: "Descripción" }
      ]
    },
    {
      key: "media",
      label: "Media",
      icon: "image",
      
      fields: [
        { type: "ImageField", key: "featured", title: "Imagen destacada" },
        { type: "FileField", key: "document", title: "Documento adjunto" }
      ]
    },
    {
      key: "seo",
      label: "SEO",
      icon: "search",
      
      fields: [
        { type: "TextField", key: "metaTitle", title: "Meta Title" },
        { type: "TextArea", key: "metaDescription", title: "Meta Description" }
      ]
    },
    {
      key: "visibility",
      label: "Visibilidad",
      icon: "eye",
      
      fields: [
        { type: "ToggleField", key: "published", title: "Publicado" },
        { type: "DateField", key: "publishDate", title: "Fecha de Publicación" }
      ]
    }
  ]
};
```

## Mejores Prácticas

1. **Usa TextArea en lugar de TextField para textos largos** - TextField es solo para texto corto
2. **ImageField siempre debe tener alt=true en imágenes principales** - Accesibilidad
3. **ReferenceField permite múltiples fuentes** - Muy flexible para datos relacionados
4. **ConditionalField es poderoso pero cuidado con complejidad** - No anides demasiado
5. **ArrayFieldGroup > FieldGroup para datos repetibles** - Mejor UX en editor
6. **Usa computed con cuidado** - Solo para valores derivados simples
7. **Agrupa campos en configTabs si hay más de 8** - Mejor UX
8. **Siempre proporciona helptext para campos complejos** - Mejora experiencia de editor

