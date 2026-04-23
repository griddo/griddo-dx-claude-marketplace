# Thumbnails para el editor

En ciertos schemas es posible añadir imágenes que se usarán en la interfaz de Griddo, para identificar componentes, módulos, templates, etc.

Los thumbnails pueden ser tanto urls a imágenes externas o locales que apuntarán al directorio `/static` de nuestro repositorio.

<aside>
⚠️ Se ha deprecado el uso de imágenes importadas directamente con `import` (webpack)

</aside>

**Ejemplo usando imágenes alojadas en el propio repositorio**

```tsx

const schema: Schema.Module = {
  schemaType: 'module',
  displayName: 'Card',
  component: 'Card',
  configTabs: [],
  default: { component: 'Card' },
  thumbnails: {
    **'1x': "/thumbnails/modules/Card/thumbnail@1x.png",
    '2x': "/thumbnails/modules/Card/thumbnail@2x.png",**
  },
}
```