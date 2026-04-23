# Patrones de Tablas en Schemas

## Introducción

A continuación se describen los patrones estándar para documentar schemas en Griddo. Estos patrones se utilizan para estructurar la información de campos según el tipo de datos y su comportamiento en el editor.

## Tablas Básicas

### Schema - Content Tab

Tabla para todos los campos que contiene el componente/módulo/template que aparece en la **Content tab**.

Estructura típica:
- Nombre del campo
- Tipo de campo
- Requerido (Yes/No)
- Descripción

### Schema - Config Tab

Tabla para todos los campos que contiene el componente/módulo/template que aparece en la **Config tab**.

Estructura típica:
- Nombre del campo
- Tipo de campo
- Requerido (Yes/No)
- Valor por defecto
- Descripción

## Campos con Opciones Expandidas

### RadioGroup

Tabla para cuando usamos el campo **RadioGroup** que permite seleccionar **una entre varias opciones.**

Estructura:
- Nombre de la opción
- Valor
- Descripción

Se debe definir:
- Las opciones disponibles (*options*)
- La opción seleccionada por defecto (*value*)

### CheckGroup

Tabla para cuando usamos el campo **CheckGroup** que permite seleccionar **varias opciones.**

Estructura:
- Nombre de la opción
- Valor
- Descripción

Se debe definir:
- Las opciones disponibles (*options*)
- La opción seleccionada por defecto (*value*), o 'None' si no hay valor por defecto

### SelectorField

Tabla para cuando usamos el campo **SelectorField** (dropdown selector).

Estructura:
- Nombre de la opción
- Valor
- Descripción

Se debe definir:
- Las opciones que aparecen en el dropdown (*options*)
- La opción seleccionada por defecto (*value*)

## Campos Condicionales

### ConditionalFieldGroup

Tabla para cuando usamos **ConditionalFieldGroup**. Se trata de un conjunto de radio buttons para mostrar u ocultar **diferentes campos según el valor elegido.**

Estructura:
- En cada pestaña de la tabla se especifican los campos que aparecen según la opción seleccionada
- Puede haber tantos campos como sean necesarios en cada condición

Ejemplo: En un módulo con opciones de tipo "Video", "Imagen" o "Texto", cada opción muestra campos diferentes.

## Campos Que Cargan Datos

### ReferenceField

Tabla para cuando usamos **ReferenceField** para **cargar datos estructurados**, tanto de página como simples.

Se usa mayormente en:
- Distribuidores
- Listados
- Cargas de contenido relacionado

Estructura:
- Tipo de referencia
- Contenido tipo
- Opciones de visualización
- Filtros aplicables

## Campos de Contenido Estructurado

### ArrayField

Tabla para cuando usamos el **ArrayField**.

Estructura:
- Se trata de un campo que dentro contiene N campos (de cualquier tipo)
- Puede contener un array de otros campos dentro (meta-array)
- Los últimos campos pueden tener también un array de campos

Estructura de tabla:
- Nombre del campo
- Tipo de campo
- Descripción
- Incluso si es requerido

Nota: Se debe acompañar con otra tabla que especifique los campos que aparecen dentro del array.

### ComponentArray

Tabla para cuando usamos el campo **ComponentArray**. El campo sirve para añadir y **listar varios componentes** dentro de un componente/módulo.

Estructura:
- Componente/Módulo (nombre)
- Descripción
- Valor por defecto
- Mínimo de elementos
- Máximo de elementos

Se debe indicar:
- Qué componentes o módulos van a aparecer listados
- Si incluyen algún valor por defecto
- Mínimo y máximo de elementos (si aplica)

### ComponentContainer

Tabla para cuando usamos el campo **ComponentContainer** para añadir un **único componente** a un módulo cuando hay varias opciones a elegir.

Ejemplo: En un módulo "Basic Content", puedes poner distintos componentes (imagen, vídeo, etc.)

Estructura:
- Componente/Módulo (nombre)
- Descripción
- Valor por defecto
- Requerido

Se debe acompañar con otra tabla en la que se indican:
- Los componentes que se pueden incluir
- Sus enlaces de documentación
- Valores por defecto si los hay

## Campos de Selección Visual

### Visual Unique Selection

Tablas para cuando usamos el campo **Visual Unique Selection**. Se usan sobre todo en la **pestaña Config** del componente/módulo.

#### Layout

Tabla para los **layouts** que tiene el módulo.

Nota: Si el módulo no tiene layout, esta tabla no se necesita. Los componentes no suelen tener layouts, salvo algunas excepciones.

Estructura:
- Nombre del layout
- Descripción visual
- Thumbnail/Icono
- Columnas a mostrar por fila

#### Style (Theme)

Tabla para los **themes** que definimos para el módulo.

Estructura:
- Nombre del tema
- Descripción
- Color/Visual de referencia

Nota: Si no queremos que pueda editarse, se elimina esta tabla.

#### Decoration

Tabla para la **decoración** que tiene el módulo.

Estructura:
- Tipo de decoración
- Descripción
- Visual de referencia

Nota: Si no queremos que tenga decoración, se elimina esta tabla.

**Columnas (columns)**

El número de columnas indicado controla cuántos thumbnails aparecen por fila:
- Columns: 2 - Dos thumbnails por fila
- Columns: 3 - Tres thumbnails por fila
- Columns: 8 - Ocho thumbnails por fila

## Campos Especializados

### FieldsGroup

Se trata de un **separador de campos** para agrupar la información y que sea más fácil de entender por el usuario.

Permite:
- Plegar y desplegar campos
- Ocultar campos que no han sido editados
- Organizar visualmente la información

### Categories

Tabla para especificar las **categorías** con las que se relaciona un tipo de contenido.

Nota: Esto solo se usa en los ***content types***.

Estructura:
- Nombre de la categoría
- Descripción
- Si es obligatoria

## Buenas Prácticas

1. **Consistencia**: Usa los mismos nombres de columna en todas las tablas del mismo tipo
2. **Claridad**: Describe siempre el propósito de cada campo
3. **Valores por defecto**: Especifica valores por defecto cuando corresponda
4. **Validación**: Indica si los campos son obligatorios
5. **Restricciones**: Documenta mínimos, máximos y cualquier otra restricción
6. **Ejemplos**: Proporciona ejemplos cuando la documentación lo permita

## Referencias Relacionadas

- [ArrayField](/building-blocks/fields/array-field.md)
- [ComponentArray](/building-blocks/fields/component-array.md)
- [ComponentContainer](/building-blocks/fields/component-container.md)
- [ConditionalFieldGroup](/building-blocks/fields/conditional-field-group.md)
- [ReferenceField](/building-blocks/fields/reference-field.md)
- [Visual Unique Selection](/building-blocks/fields/visual-unique-selection.md)