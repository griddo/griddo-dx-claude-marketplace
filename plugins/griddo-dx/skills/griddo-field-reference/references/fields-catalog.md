# AIReferenceField

Properties

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| disabled | Boolean |  | Desactiva el campo |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String |  | Label del campo |
| type | String | ✅ | Tipo de campo. |
| whiteList | Array<string> |  | Array para restringir los templates mostrados en el AIReferenceField |

---

# ArrayFieldGroup

Campo que permite añadir grupos de fields según una plantilla definida.

Si queremos que uno de los fields actúe de título del item cuando el arrayType es "dropDown", podemos incluir el prop `isTitle: true` en dicho campo. La única condición es que el valor del campo sea una string.

## Uso básico

```typescript
{
  "title": "",
	"type": "ArrayFieldGroup",
  "key": "years",
	"name": "Year",
	"fields": [
    {
      "title": "Title",
      "type": "TextField",
      "key": "yearTitle",
			"isTitle": true,
    },
	],
	"arrayType": "dropDown",
  "divider": {
			"title": "Title",
      "text": "Description",
	}
},
```

```tsx
type ArrayFieldGroup<Fields> = Array<Fields>;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| arrayType | String | ✅ | Las dos formas de visualizar el array de items, con los campos plegados (dropdown) o visibles (inline). |
| divider | Object |  | Añade un campo https://www.notion.so/2bc662fd895d4e97ae85be45ff120fb4?pvs=21 a modo de cabecera. |
| fields | Array | ✅ | Plantilla de fields que se va a repetir en cada item. |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| name | String | ✅ | Nombre del item que se va a repetir. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type ArrayFieldGroup<Fields> = Array<Fields>;
```

## Comportamiento en el editor

Campo específico para los **datos estructurados puros** que tienen datos dentro de datos. En este caso es un grupo de ‣ 
Se trata de ArrayFields con una intro y un botón que sirve para añadir más ArrayFields (con el mismo schema)
Un ejemplo de uso es en ‣ 
(Referencia: Ejemplo Schema para poner en módulo)

---

# ArrayField

## Comportamiento en el editor

Campo específico para los **datos estructurados puros** que tienen datos dentro de datos.

Se trata de un campo que dentro contiene N campos (de cualquier tipo) + array de otros campos dentro. Estos últimos campos pueden tener también un array de campos (el meta array).

Un ejemplo de uso es en Study Plan.

Pueden ser de dos tipos:
- **Dropdown**: Los campos se pliegan y repliegan
- **Inline:** Los campos aparecen uno al lado de otro en la misma línea

El apartado '**isMockup**' no aplica en este campo.

### Tabla anexa

Este campo es lo que consideramos un **campo complejo** y requiere añadir una tabla extra (por eso tiene un icono de un diamante y no de una pieza de puzzle).

En este caso, es una en la que ponemos los campos que queremos que aparezcan dentro del Array. La tabla es como la del content Tab, porque al final son campos que van dentro del array.

Nombramos la tabla con el nombre del campo que haya en la tabla anterior (ArrayField - NOMBRE DEL CAMPO)

Para ver cómo rellenar estas tablas, consulta la documentación de patrones de schemas.

---

# AsyncCheckGroup

Listado de checkboxes que carga las opciones de una entidad de la base de datos.

## Uso básico

```typescript
{
  "key": "eventAreas",
  "title": "Areas",
  "type": "AsyncCheckGroup",
  "source": "EVENT_AREAS",
  "mandatory": true,
},
```

```tsx
type AsyncCheckGroup = Array<{
	value: number;
	name: number;
	title: string;
}>;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| allOption | Boolean |  | Añade una opción “Select all options” para marcar todos los checks |
| contentLanguages | string | Array<string> |  | Indica el idioma o idiomas desde donde va a leer los datos si existe una traducción. |
| disabled | Boolean |  | Si el select está deshabilitado. Por defecto: false. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. ** |
| source | String | ✅ | Entidad o categoría de la base de datos de donde tiene que cargar las opciones. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type AsyncCheckGroup = Array<{
	value: number;
	name: number;
	title: string;
}>;
```

---

# AsyncSelect

Lista desplegable que carga las opciones de una entidad de la base de datos.

** Si un select no es obligatorio (mandatory: false), añadirá automáticamente una opción en blanco con valor null y el texto que se indique en el placeholder.

- El field debe llevar entity o source para que funcione, pero no las dos.

## Uso básico

```typescript
{
  "title": "Main menu",
  "type": "AsyncSelect",
  "entity": "menu_containers",
  "key": "mainMenu",
  "mandatory": true
}
```

```typescript
{
  "title": "Programs",
  "type": "AsyncSelect",
  "source": "PROGRAMS",
  "key": "programs",
  "mandatory": true
}
```

```tsx
type Return = number
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| computed | Function |  | Solo válido en los templates y en ContentTypes simples. |
| contentLanguages | string | Array<string> |  | Indica el idioma o idiomas desde donde va a leer los datos si existe una traducción. |
| disabled | Boolean |  | Si el select está deshabilitado. Por defecto: false. |
| entity | String |  | Entidad de la base de datos de donde tiene que cargar las opciones. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. ** |
| placeholder | String |  | Texto que se muestra en el select sin opción seleccionada. |
| source | String |  | Tipo de dato estructurado de donde tiene que cargar las opciones. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Return = number
```

---

# CheckGroupField

## Comportamiento en el editor

Campo para seleccionar varias opciones.
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ no aplica en este campo.
### **Tabla anexa:**
Este campo es lo que consideramos un **campo complejo** y requiere añadir una tabla extra (por eso tiene un icono de un diamante y no de una pieza de puzzle). 
En este caso, es una en la que ponemos las opciones que que queremos que aparezcan en el check y, si hay una opción seleccionada por defecto, la ponemos en la columna ‘Value’. Si no queremos que tenga ninguna opción seleccionada, ponemos ‘None’
- radio groups
- aquí

---

# CheckGroup

Agrupación de Check Fields.

## Uso básico

```typescript
{
  "title": "Meta robots advanced",
  "type": "CheckGroup",
  "key": "metasAdvanced",
  "options": [
    {
      "value": "noimageindex",
      "title": "No image index",
      "name": "noimage"
    },
    {
      "value": "nosnippet",
      "title": "No snippet",
      "name": "nosnippet"
    },
    {
      "value": "noodp",
      "title": "No ODP",
      "name": "noodp"
    },
    {
      "value": "noarchive",
      "title": "No archive",
      "name": "noarchive"
    }
  ]
}
```

```tsx
type CheckGroup<Values> = Array<Values>;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| options | Array | ✅ | Array de checks que se quieren mostrar |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type CheckGroup<Values> = Array<Values>;
```

---

# ColorPicker

Texfield que permite desplegar un modal para elegir un color.

## Uso básico

```typescript
{
  "title": "Background",
  "type": "ColorPicker",
  "key": "background",
  "colors": ["#d9e3f0","#f47373","#697689","#37d67a","#2ccce4","#555555","#dce775","#ff8a65","#ba68c8"],
}
```

```typescript
{
  "title": "Background",
  "type": "ColorPicker",
  "key": "background",
  "isThemePalette": true,
  "colors": [
			{ "theme": "default-theme",
				"options": [
						{name: "chart1", hex: "#d9e3f0"},
						{name: "chart2", hex: "#697689"},
						{name: "chart3", hex: "#37d67a"}
				],
			},
			{ "theme": "griddo-alt-theme",
				"options": [
						{name: "chart1", hex: "#ffffff"},
						{name: "chart2", hex: "#dddddd"},
						{name: "chart3", hex: "#000000"}
				],
			},
	],		
}
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| colors | Array |  | Si isThemePalette = false, colors será un array de códigos hexadecimales de los colores que aparecerán elegibles por defecto. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| isThemePalette | Boolean |  | Si es true (sólo se usan colores fijos) se guarda el valor name (que será común a todas las opciones de los themes) o el hexadecimal introducido en el input, que será variable y exclusivo de ese componente . Los colors deberán del esquema deben declararse como un array de objetos. |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Comportamiento en el editor

Campo para seleccionar un color dentro de los que hay aceptados en el Sistema de Diseño. También tiene un campo para poner cualquier color Hexadecimal si no está entre los admitidos en el DS y lo necesitan.
(Referencia: Ejemplo Schema para poner en módulo)
El apartado ‘**isMockup**’ no aplica en este campo.

---

# ComponentArray

Campo para añadir múltiples componentes a un módulo.

**Whitelist con componentes**

## Uso básico

```typescript
{
  "title": "Cards",
  "type": "ComponentArray",
	"key": "elements",
	"contentType": "components",
  "maxItems": null,
  "whiteList": [
    "BasicCard",
    "BasicBoxedCard",
    "BasicIconCard",
    "ImageCard",
    "IconCard",
    "IconCenteredCard",
    "LogoCard"
  ]
}
```

```jsx
[
  {component: "BasicCard", ...},
  {component: "IconCard", ...}
]
```

```tsx
type ComponentArray<ComponentProps> = Array<ComponentProps>
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| contentType | String | ✅ | Indica si el componentArray va a contener módulos o componentes. |
| elementUniqueSelection | Boolean |  | Obliga a que todos los elementos del Array sean del mismo tipo. Por defecto: false. Si se habilita esta opción el schema debería incluir un VisualUniqueSelection para elegir el tipo. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| maxItems | Number |  | Número máximo de componentes que se pueden añadir. |
| reference | String |  | key de un VisualUniqueSelection  al que se quiere afectar con  la prop elementUniqueSelection . Es obligado indicarlo si se usa la prop elementUniqueSelection |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |
| whiteList | Array | ✅ | Array de strings con los nombres de los componentes que se pueden añadir. |

## Detalles

## API response Type

```tsx
type ComponentArray<ComponentProps> = Array<ComponentProps>
```

## Comportamiento en el editor

Campo para añadir y listar varios componentes en un módulo. Se usa, sobre todo, en módulos Collections y en los Schemas de templates (ver más abajo)
(Referencia: Ejemplo Schema para poner en módulo)
### Cuando el schema es para un template
Los templates llevan este campo para el **Main content** y el **Related Content.** 
Es un **Array (Modules)**
En estos casos, se puede definir un whitelist para que salgan, o bien todos los módulos, o una selección específica:
- Por component type: CypherCard, AccordionElement - especificamos cuales son
- Por component type + tag:
    - modules tagged as HERO
    - modules tagged as CONTENT
    - ALL MODULES
    - ...

---

# ComponentContainer

Campo para añadir un único componente a un módulo.

**Ejemplo**

## Uso básico

```typescript
{
  "title": "Additional content",
  "type": "ComponentContainer",
	"key": "componentContainer",
  "whiteList": [
    "BasicContent",
    "CardCollection"
  ]
}
```

```json
default: {
	componentContainer: {
		BasicContent: { component: "BasicContent" },
		CardCollection: { component: "CardCollection" },
	},
},
```

```tsx
type ComponentContainer<ComponentProps> = ComponentProps;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |
| whiteList | Array | ✅ | Array de strings con los nombres de los componentes que se pueden añadir. |

## Detalles

## API response Type

```tsx
type ComponentContainer<ComponentProps> = ComponentProps;
```

## Comportamiento en el editor

Campo para añadir un único componente a un módulo cuando hay varias opciones a elegir. Por ejemplo, en un Basic Content puedes poner distintos componentes (imagen, vídeo,...) así que usamos este campo para poner dentro los componentes que se necesiten.
(Referencia: Ejemplo Schema para poner en módulo)
En este caso, acompañamos la tabla superior con otra en la que indicamos los componentes que entran (y los enlazamos con su propio enlace a notion).
(Referencia: Component container)

---

# ConditionalFieldGroup

## Comportamiento en el editor

Conjunto de radio buttons para mostrar u ocultar **diferentes campos según el valor elegido.**
Muestra unos campos u otros en relación a un radiogroup. Cuando se selecciona otra opción, cambian los campos mostrados. Para el usuario será simplemente un radio button que muestra unas u otras opciones.
Ejemplo: ‣ 
- Ejemplo Schema para poner en módulo
En este caso, acompañamos la tabla superior con otra en la que indicamos las condiciones hay. **Ejemplo del [CTA Card](https://www.notion.so/9c5093ae658e4b27b2f295752c34113c?pvs=21):**
- Type of element: Icon 
- Type of element: Profile

---

# ConditionalField

Conjunto de radio buttons para mostrar u ocultar diferenes campos según el valor elegido.

Los campos dentro de `fields` tienen que llevar la key `condition` con uno de los valores de options para mostrar el campo cuando el valor del radio button coincida con la condición.

## Uso básico

```json
{
  title: "File Type",
  type: "ConditionalField",
  key: "fileType",
  mandatory: true,
  options: [
    {
      value: true,
      title: "Url",
      name: "url",
    },
    {
      value: false,
      title: "Upload File",
      name: "upload",
    },
  ],
  fields: [
    {
      title: "Document Link",
      type: "UrlField",
      key: "documentLink",
      helptext: "Add link to a pdf or any document type",
      placeholder: "Placeholder text",
      condition: true,
    },
    {
      title: "Upload Document",
      type: "ComponentContainer",
      whiteList: ["File"],
      key: "documentFile",
      condition: false,
    },
  ],
},
```

```tsx
type Return = unknown // dependiendo de lo que se ponga en las opciones
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| fields | Array | ✅ | Array de fields |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| options | Array | ✅ | Array de opciones (radio buttons) |
| title | String | ✅ | Label del campo |
| type | String | ✅ | Tipo de campo. |

## Detalles

## Return type

```tsx
type Return = unknown // dependiendo de lo que se ponga en las opciones
```

---

# DateField

Campo para fechas. La fecha se puede escribir o elegir en un calendario.

## Uso básico

```typescript
{
	"key": "dateTime",
	"title": "Event date and time",
	"type": "DateField",
},
```

```tsx
type Date = string
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| selectsRange | Boolean |  | Habilita la selección de un rango de fechas. Por defecto: false. |
| title | String | ✅ | Label del campo |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Date = string
```

## Comportamiento en el editor

Campo para seleccionar una fecha en el **calendario**.
(Referencia: Ejemplo Schema para poner en módulo)
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘fecha actual’ marcamos esta opción como NO, porque es posible que el usuario no cambie el número, así que no queremos que el validador pase sobre él.

---

# FieldGroup

No es un field en sí mismo, es una agrupación de fields con un título y la opción de ocultarlos o mostrarlos todos juntos.

## Uso básico

```typescript
{
  "title": "Social Share",
  "type": "FieldGroup",
  "key": "socialshare",
  "fields": [
    {
      "title": "Title",
      "type": "TextField",
      "key": "rsTitle"
    },
    {
      "title": "Description",
      "type": "TextField",
      "key": "rsDescription"
    },
    {
      "title": "Image",
      "type": "ImageField",
      "key": "rsImage"
    }
  ]
}
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| fields | Array | ✅ | Array de fields que pertenecen al grupo. |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

---

# FieldsDivider

Campo para añadir un componete "divider" entre campos.

## Uso básico

```typescript
{
  "key": "divider",
  "type": "FieldsDivider",
  "data": {
			"title": "The title",
      "text": "The description",
	}
},
```

```tsx
type FieldsDivider = string
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| data | Object | ✅ | Objeto con los campos title y text (strings). |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type FieldsDivider = string
```

---

# FieldsGroup

## Comportamiento en el editor

Se trata de un **separador de campos** para agrupar la información y que sea más fácil de entender por el usuario.
No se puede añadir módulos, para eso está el campo Array. Lo que si se puede hacer es plegar los campos y desplegarlos, para ocultar a la vista los campos que no ya hayamos editado o los que no vamos a tocar por el momento.
- Ejemplo Schema para poner en módulo

---

# FileField

Campo que permite subir ficheros. 

Aunque puede funcionar de forma independiente, en la mayoría de los casos será mejor utilizar el componente File, el cual ya lleva el FileField incluído y además añade los campos title y alt.

## Uso básico

```typescript
{
  "title": "Document",
  "type": "FileField",
  "key": "document",
}
```

```tsx
export type File = {
	/** file id */
	id?: number;
	/** site id */
	site?: number | null;
	/** URL for the document */
	url?: string;
	/** Size for the document file in bytes */
	sizeBytes?: number;
	/** Upload date */
	uploadDate?: string;
	/** Document's name */
	fileName?: string;
	/** Document's title */
	title?: string | null;
	/** Document's alt text */
	alt?: string | null;
	/** Field type */
	fieldType?: "file";
	/** Where is this file being used. */
	contentInUse?: {
		pages: Array<{
			siteId: number;
			siteName: string;
			pages: Array<{
				id: number;
				title: string;
				published: string;
				modified: string;
			}>;
		}>;
		structuredData: Array<{
			id: number;
			title: string;
		}>;
	};
	/** File type */
	fileType?: "pdf" | "doc" | "docx" | "xls" | "xlsx" | "zip";
	/** File tags */
	tags?: Array<string>;
	/** File or folder */
	folder?: {
		folderId: number;
		folderName: string;
	} | null;
};kr
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| allowedFormats | Array |  | Array de strings con las extensiones de los tipos de archivos permitidos. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API Response Type

```tsx
export type File = {
	/** file id */
	id?: number;
	/** site id */
	site?: number | null;
	/** URL for the document */
	url?: string;
	/** Size for the document file in bytes */
	sizeBytes?: number;
	/** Upload date */
	uploadDate?: string;
	/** Document's name */
	fileName?: string;
	/** Document's title */
	title?: string | null;
	/** Document's alt text */
	alt?: string | null;
	/** Field type */
	fieldType?: "file";
	/** Where is this file being used. */
	contentInUse?: {
		pages: Array<{
			siteId: number;
			siteName: string;
			pages: Array<{
				id: number;
				title: string;
				published: string;
				modified: string;
			}>;
		}>;
		structuredData: Array<{
			id: number;
			title: string;
		}>;
	};
	/** File type */
	fileType?: "pdf" | "doc" | "docx" | "xls" | "xlsx" | "zip";
	/** File tags */
	tags?: Array<string>;
	/** File or folder */
	folder?: {
		folderId: number;
		folderName: string;
	} | null;
};kr
```

## Comportamiento en el editor

Campo que permite subir ficheros. 
(Referencia: Ejemplo Schema para poner en módulo)

---

# FormCategorySelect

Campo para renderizar múltiples MultiCheckSelect con las categorías de formularios disponibles en un template de formulario. Solo puedo haber uno por template.

## Uso básico

```typescript
{
  "key": "formCategories",
  "title": "Select Categories",
  "type": "FormCategorySelect",
  "filled": true,
}
```

```tsx
type Return = {
  [key: string]: Array<{value: number; name: number; title: string}>
}
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| categories | Array |  | Array de ids de categorías de formulario (strings). Funciona como whiteList de estas categorías. Por defecto muestra todas. |
| filled | Boolean |  | Si filled = true el campo tendrá un fondo blanco. Por defecto: false |
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## Return type

```tsx
type Return = {
  [key: string]: Array<{value: number; name: number; title: string}>
}
```

---

# FormContainer

Campo para añadir un formulario a un template de página o a un módulo.

💡

Thumbnails
Los thumbnails para el modal de selección de formulario se generan automáticamente seleccionando el HTML (React) del template del formulario.
También se puede indicar a Griddo de manera más explícita mediante un id `griddoFormThumb` el elemento HTML sobre el que hacer la captura. Ojo, ese id debería ir en el nivel más interior de anidamiento posible. Si tienes un div que actúa como contenedor en el que pones todos los elementos centrados, y dentro tienes el div en el que se mostraría realmente el contenido del formulario, el id debería ir en ese segundo div interior.

## Uso básico

```typescript
{
  "title": "Form",
  "type": "FormContainer",
	"key": "form",
}
```

```tsx
type FormContainer<FormPageProps> = FormPageProps;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| formCategories | Array |  | Array de “codes” de categorías para prefiltrar el modal de elección de formularios. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type FormContainer<FormPageProps> = FormPageProps;
```

---

# FormFieldArray

Campo para añadir múltiples componentes a un **template de formulario**.
Solo puedo haber uno en el template.

**Whitelist con componentes**

## Uso básico

```typescript
{
  "title": "Fields",
  "type": "FormFieldArray",
	"key": "fields",
}
```

```jsx
[
  {component: "InputField", ...},
  {component: "EmailField", ...}
]
```

```tsx
type FormFieldArray<ComponentProps> = Array<ComponentProps>
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |
| whiteList | Array | ✅ | Array de strings con los nombres de los componentes que se pueden añadir. |

## Detalles

## API response Type

```tsx
type FormFieldArray<ComponentProps> = Array<ComponentProps>
```

---

# Heading field

## Comportamiento en el editor

Field para **títulos a los que asignar un Heading** para SEO
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘Lorem ipsum’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiarlo por el texto real.
- Si has puesto ‘Sabías que…’ marcamos esta opción como NO, porque es muy posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.

---

# ImageField

Campo básico para subir una imagen. 

Puede funcionar de forma independiente pero también está incluido en los componentes [Image](https://www.notion.so/95cd5a6c1a914ec29401108a3882bda2?pvs=21) y [LinkableImage](https://www.notion.so/d4da787bd5b5490698a00c0115bc960b?pvs=21), los cuales añaden campos extra como title, alt, velo o link de la imagen.

## Uso básico

```typescript
{
  "title": "Image",
  "type": "ImageField",
  "key": "image"
}
```

```tsx
type Return = {
  /** Image id */
  id: number
  /** Original image name */
  name: string
  /** Image name from the gallery */
  title: string
  /** Image description from the gallery */
  description: string
  /** Alternative text for the image */
  alt: string
  /** Image tags from the gallery */
  tags: Array<string>
  /** Griddo DAM image url */
  url: string
  /** Griddo DAM image url thumbnail */
  thumb: string
  /** Cloudinary `public-id`
   * @deprecated
   * Cloudinary will be deprecated in the future
   * */
  publicId: string
  /** Griddo DAM image id
   * @deprecated
   * This id is internal and should not be used
   */
  damId: string
  /** Image publication date */
  published: string
  /** Original image size in bytes */
  size: number
  /** Original image width in pixels */
  width: number
  /** Original image height in pixels */
  height: number
  /** Original image orientation
   * P: Portrait
   * L: Landscape
   * S: Square
   */
  orientation: 'P' | 'L' | 'S'
  /** Site to which image belongs */
  site: number
}
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| cropPreview | Boolean |  | Si true le hace crop al preview, si false escala el preview. Por defecto: false |
| fullWidth | Boolean |  | Establece el ancho del field al máximo de ancho. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Return = {
  /** Image id */
  id: number
  /** Original image name */
  name: string
  /** Image name from the gallery */
  title: string
  /** Image description from the gallery */
  description: string
  /** Alternative text for the image */
  alt: string
  /** Image tags from the gallery */
  tags: Array<string>
  /** Griddo DAM image url */
  url: string
  /** Griddo DAM image url thumbnail */
  thumb: string
  /** Cloudinary `public-id`
   * @deprecated
   * Cloudinary will be deprecated in the future
   * */
  publicId: string
  /** Griddo DAM image id
   * @deprecated
   * This id is internal and should not be used
   */
  damId: string
  /** Image publication date */
  published: string
  /** Original image size in bytes */
  size: number
  /** Original image width in pixels */
  width: number
  /** Original image height in pixels */
  height: number
  /** Original image orientation
   * P: Portrait
   * L: Landscape
   * S: Square
   */
  orientation: 'P' | 'L' | 'S'
  /** Site to which image belongs */
  site: number
}
```

## Comportamiento en el editor

Campo básico para subir una imagen. 
(Referencia: Ejemplo Schema para poner en módulo)

---

# LinkField

Field que combina **TextField + ConditionalField** (UrlField o ComponentContainer).

**Ejemplo**

## Uso básico

```json
{
	type: "LinkField",
	key: "link",
  whiteList: ["BasicContent", "CardCollection"],
}
```

```jsx
link: {
	text: "Linkazo",
  linkType: "url",
  url: {
	  url: "",
    linkTo: null,
    newTab: false,
    noFollow: false,
    size: null,
    icon: null,
    linkContainer: null,
	},
  modal: {
	  basicContent: {
		  component: "BasicContent",
	  },
	  cardCollection: {
			component: "CardCollection",
	  },
  },
},
```

```tsx
type Return =
    | {
        text: string
        linkType: 'url'
        url: {
            href: string
            linkToURL: string
            newTab: boolean
            noFollow: boolean
            subSlug: string
        }
    }
    | {
        text: string
        linkType: 'modal'
        modal: {
            [key: string]: Record<string, unknown>
        }

    }
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| type | String | ✅ | Tipo de campo. |
| whiteList | Array | ✅ | Array de strings con los nombres de los componentes que se pueden añadir. |

## Detalles

## API response Type

```tsx
type Return =
    | {
        text: string
        linkType: 'url'
        url: {
            href: string
            linkToURL: string
            newTab: boolean
            noFollow: boolean
            subSlug: string
        }
    }
    | {
        text: string
        linkType: 'modal'
        modal: {
            [key: string]: Record<string, unknown>
        }

    }
```

## Comportamiento en el editor

Field que combina **TextField + ConditionalField** (UrlField o ComponentContainer) para poner en el componente Link. El comportamiento de cada campo es el suyo propio.
El component container mostrará un whitelist con las **modales disponibles en el DS.**
(Referencia: Ejemplo Schema para poner en módulo)
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘link’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiar el número.
- Si has puesto ‘saber más’ marcamos esta opción como NO, porque es posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.

---

# MultiCheckSelectGroup

Campo para renderizar múltiples MultiCheckSelect.

## Uso básico

```typescript
{
  "key": "categories",
  "title": "Select Categories",
  "type": "MultiCheckSelectGroup",
  "note": "Go to the Category section (Global or Site) to create as many as you need.",
  "elements": [
    {
      "key": "eventAreas",
      "placeholder": "Areas",
      "source": "EVENT_AREAS",
      "mandatory": true,
    },
    {
      "key": "eventLocation",
      "placeholder": "Location",
      "source": "EVENT_LOCATIONS",
      "mandatory": true,
    },
    {
      "key": "eventFormat",
      "placeholder": "Format",
      "source": "EVENT_FORMATS",
      "mandatory": true,
    },
    {
      "key": "programType",
      "placeholder": "Program Type",
      "source": "PROGRAM_TYPES",
      "mandatory": true,
    },
    {
      "key": "eventRegion",
      "placeholder": "Region",
      "source": "EVENT_REGION",
      "mandatory": true,
    },
  ],
  "mandatory": true,
  "filled": true,
}
```

```tsx
type Return = {
  [key: string]: Array<{value: number; name: number; title: string}>
}
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| computed | Function |  | Solo válido en los templates y en ContentTypes simples. |
| elements | Array | ✅ | Array con los datos de los diferentes https://www.notion.so/dc84a327a881450abecb06a4d787eacc?pvs=21 |
| filled | Boolean |  | Si filled = true el campo tendrá un fondo blanco. Por defecto: false |
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| note | String |  | https://www.notion.so/b1d465923c394d5a8ebcd24fd3642f94?pvs=21 con texto de ayuda que aparece debajo de la label |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## Return type

```tsx
type Return = {
  [key: string]: Array<{value: number; name: number; title: string}>
}
```

---

# MultiCheckSelect

Campo que permite renderizar un AsyncCheckGroup dentro de una lista desplegable.

## Uso básico

```typescript
{
  "title": "Localización",
  "type": "MultiCheckSelect",
  "key": "location",
	"source": "EVENT_LOCATIONS",
  "placeholder": "Select location"
}
```

```tsx
// UI Schema
type MultiCheckSelect = Array<{
  value: number;
  name: number;
  title: string;
}>

// ContentType Schema
type MultiCheckSelect = Array<{
	id?: number;
	label?: string;
}>
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| allOption | Boolean |  | Añade una opción “Select all options” para marcar todos los checks |
| contentLanguages | string | Array<string> |  | Indica el idioma o idiomas desde donde va a leer los datos si existe una traducción. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| placeholder | String | ✅ | Texto del Select |
| source | String | ✅ | Entidad de la base de datos de donde tiene que cargar las opciones. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API return Type

```tsx
// UI Schema
type MultiCheckSelect = Array<{
  value: number;
  name: number;
  title: string;
}>

// ContentType Schema
type MultiCheckSelect = Array<{
	id?: number;
	label?: string;
}>
```

## Comportamiento en el editor

Field para la **selección de las categorías** que asociamos a un Detail template. Muy similar al selector que hay dentro del Reference Field. **Ejemplo**: ‣ 
Se compone de Select fields + CheckGroup Field dentro de cada select Field. Tiene la opción de añadir una nota informativa si se necesita.
(Referencia: Ejemplo Schema para poner en módulo)
En el ejemplo de la tabla, especificamos que las categorías se vean en una tabla que se puede ver en: ‣

---

# NoteField

Campo para añadir un texto destacado.

## Uso básico

```typescript
{
  "title": "Title",
  "key": "note01",
  "type": "NoteField",
},

**default:**

"note01": {
  "title": "",
  "text": "",
},
```

```tsx
type Note = string
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| title | String | ✅ | Campo obligatorio pero que no se mostrará |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Note = string
```

## Comportamiento en el editor

Sirve para hacer algún tipo de nota aclaratoria. Por ejemplo, si algo no se edita aquí sino que lo toma de otra parte del sistema, se recomienda utilizarlo.
(Referencia: Ejemplo Schema para poner en módulo)

---

# NumberField

Campo para números. Incluye botones para incrementar o decrementar el valor del campo.

## Uso básico

```typescript
{
	"title": "Items/page",
	"type": "NumberField",
	"key": "itemsPerPage",
	"mandatory": true,
},
```

```tsx
type Number = "" | number | null
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| max | Number |  | Valor máximo |
| min | Number |  | Valor mínimo |
| title | String | ✅ | Label del campo |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Number = "" | number | null
```

## Comportamiento en el editor

Campo para seleccionar un **número.**
(Referencia: Ejemplo Schema para poner en módulo)
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘0’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiar el número.
- Si has puesto ‘3’ marcamos esta opción como NO, porque es posible que el usuario no cambie el número, así que no queremos que el validador pase sobre él.

---

# RadioGroupField

## Comportamiento en el editor

Campo para seleccionar **una** entre varias opciones.
- Ejemplo Schema para poner en módulo

---

# RadioGroup

Agrupación de Radio Fields.

## Uso básico

```typescript
{
  "title": "Meta robots follow",
  "type": "RadioGroup",
  "key": "follow",
  "options": [
    {
      "value": true,
      "title": "Follow",
      "name": "follow"
    },
    {
      "value": false,
      "title": "No follow",
      "name": "nofollow"
    }
  ]
}
```

```tsx
type RadioGroup<Values> = Values;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| options | Array | ✅ | Array de radios que se quieren mostrar |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type RadioGroup<Values> = Values;
```

---

# ReferenceField

Campo que carga Datos Estructurados de la base de datos.

En la sección `default` la prop `data` es opcional. Si no se añade nada por defecto se configurará todo desde el propio editor.

## Uso básico

```tsx
// Field
{
  type: "ReferenceField",
  sources: [
		{ structuredData: "VIDEOS" }
	],
  key: "data",
  title: "Videos",
  selectionType: ["auto", "manual"],
}
```

```tsx
// Default
default: {
	// La prop `data` en los defaults es opcional al igual que los filtros y operadores.
	data: {
		sources: [
			{ structuredData: "NEWS", fields: ["title", "image"] }
		]
	}
}
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| fields | Array<string> |  | Solo en el default de los schemas: Propiedades del dato que se incluirán en la petición cuando el dato es manual. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| maxItems | Number |  | Número máximo de ítems en modo manual. |
| selectionType | Array |  | Tipos de selección: manual, automática o ambas. |
| sources | Array | ✅ | Array con los tipos de datos estructurados que tiene que cargar el campo |
| title | String |  | Label del campo |
| type | String | ✅ | Tipo de campo. |

---

# Reference

## Comportamiento en el editor

Campo para **cargar Datos Estructurados** de la base de datos, tanto de página como puros en un módulo. Se suele utilizar en **módulos distribuidores.** Básicamente sirve hacer referencia de X datos en un módulo.
En general puede haber dos tipos de relaciones: las **automáticas** (query con filtros, ordenación y límite) y **manual** con selección y ordenación. Se especifica en el Schema.
- Ejemplo Schema para poner en módulo

---

# RichText

⚠️ **Este field está DEPRECADO**. 
En su lugar se puede utilizar el field **WYSYWYG** con la opción `full: false`.
Para sustituir un campo por otro y que el cambio sea totalmente transparente, el RichText debería tener la opción de **html activada**.

TextArea con editor simple que exporta a markdown o html.

Utiliza las librerías de draft.js y react-draft-wysiwyg.js

## Uso básico

```typescript
{
  "title": "Subtitle",
  "type": "RichText",
  "key": "subtitle"
}
```

```tsx
type RichText = string;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| html | Boolean |  | Si html: true exporta a html en vez de a markdown. Por defecto: false. |
| humanReadable | Boolean |  | Indica que el campo puede ser tratado en funcionalidades como traducciones automáticas con IA, etc.. |
| key | String |  | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| placeholder | String |  | Texto de ejemplo de contenido. |
| title | String |  | Label del campo que aparecerá en el formulario. |
| type | String |  | Tipo de campo. |

## Detalles

## API response Type

```tsx
type RichText = string;
```

---

# Scrollable unique selection

## Comportamiento en el editor

Es como el campo **Visual Unique Selection** pero con scroll horizontal y tamaños más grandes. Se usa, sobre todo, en el panel Config de los módulos.
- Card Collection
Los **thumbnails** tmb hay que generarlos para que desarrollo lo ponga.
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ no aplica en este campo.
### **Tabla anexa:**
Este campo es lo que consideramos un **campo complejo** y requiere añadir una tabla extra (por eso tiene un icono de un diamante y no de una pieza de puzzle). 
- Visual unique selection
- Cards
- aquí.

---

# Select

Lista desplegable.

** Si un select no es obligatorio (mandatory: false), añadirá automáticamente una opción en blanco con valor null y el texto que se indique en el placeholder.

## Uso básico

```typescript
{
  "title": "School",
  "type": "Select",
  "key": "school",
  "options": [
    {
      "value": "BUS",
      "label": "Business School"
    },
    {
      "value": "LAW",
      "label": "Law School"
    },
    {
      "value": "ARQ",
      "label": "School of Architecture and Design"
    },
    {
      "value": "GPA",
      "label": "School of Global and public Affairs"
    },
    {
      "value": "HST",
      "label": "School of Human Sciences and Technology"
    },
    {
      "value": "XL",
      "label": "Exponential Learning"
    }
  ]
}
```

```tsx
type Select<Values> = Values;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| disabled | Boolean |  | Si el select está deshabilitado. Por defecto: false. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. ** |
| options | Array | ✅ | Array de opciones del select |
| placeholder | String |  | Texto que se muestra en el select sin opción seleccionada. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Select<Values> = Values;
```

---

# SelectorField

## Comportamiento en el editor

Campo para **seleccionar opciones** en el desplegable.
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘Lorem ipsum’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiarlo por el texto real.
- Si has puesto ‘Sabías que…’ marcamos esta opción como NO, porque es muy posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.
### **Tabla anexa:**
Este campo es lo que consideramos un **campo complejo** y requiere añadir una tabla extra (por eso tiene un icono de un diamante y no de una pieza de puzzle). 
En este caso, es una tabla muy sencilla en la que ponemos las opciones que que queremos que aparezcan en el desplegable del selector.
- Selector field
- aquí

---

# SliderField

Campo para renderizar un slider. Devuelve un número.

## Uso básico

```typescript
{
  "title": "Veil percentage",
  "type": "SliderField",
  "key": "veil",
}
```

```tsx
type Slider = number
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| max | Number |  | Valor máximo del slider. Por defecto: 100 |
| min | Number |  | Valor mínimo del slider. Por defecto: 1 |
| prefix | String |  | String a mostrar por delante del valor en el tooltip del slider. |
| step | Number |  | Incremento con cada paso del slider. Por defecto: 1 |
| suffix | String |  | String a mostrar por detrás del valor en el tooltip del slider. |
| title | String | ✅ | String para la label del campo. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Slider = number
```

## Comportamiento en el editor

Campo para seleccionar un porcentaje a través de un slider. 
Se usa, sobre todo, para los velos de las imágenes.
(Referencia: Ejemplo Schema para poner en módulo)

---

# TagsField

Campo para insertar tags

## Uso básico

```typescript
{
  "title": "Tags",
  "type": "TagsField",
  "key": "tags"
}
```

```tsx
type Text = Array<string>
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String |  | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String |  | Label del campo que aparecerá en el formulario. |
| type | String |  | Tipo de campo. |

## Detalles

## API response type

```tsx
type Text = Array<string>
```

---

# Template field

## Comportamiento en el editor

Breve descripción del Field
(Inserta una imagen Field)
[](https://www.notion.so)
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘Lorem ipsum’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiarlo por el texto real.
- Si has puesto ‘Sabías que…’ marcamos esta opción como NO, porque es muy posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.

---

# TextArea

## Uso básico

```typescript
{
  "title": "Subtitle",
  "type": "TextArea",
  "key": "subtitle"
}
```

```tsx
type TextArea = string;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| humanReadable | Boolean |  | Indica que el campo puede ser tratado en funcionalidades como traducciones automáticas con IA, etc.. |
| key | String |  | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| placeholder | String |  | Texto de ejemplo de contenido. |
| title | String |  | Label del campo que aparecerá en el formulario. |
| type | String |  | Tipo de campo. |

## Detalles

## API response Type

```tsx
type TextArea = string;
```

## Comportamiento en el editor

Field para poner **textos básicos largos,** sin necesidad de enriquecer el texto
(Referencia: Ejemplo Schema para poner en módulo)
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘Lorem ipsum’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiarlo por el texto real.
- Si has puesto ‘Sabías que…’ marcamos esta opción como NO, porque es muy posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.
** Si queremos que los compis de desarrollo ponga como texto mockup un párrafo de lorem ipsum en lugar de sólo ‘Lorem ipsum’ basta con poner ‘Lorem ipsum paragraph’

---

# TextField

## Uso básico

```typescript
{
  "title": "Title",
  "type": "TextField",
  "key": "title"
}
```

```tsx
type Text = string
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| computed | Function |  | Solo válido en los templates y en ContentTypes simples. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| humanReadable | Boolean |  | Indica que el campo puede ser tratado en funcionalidades como traducciones automáticas con IA, etc.. |
| key | String |  | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| placeholder | String |  | Texto de ejemplo de contenido. |
| readonly | Boolean |  | Si el campo es de solo lectura. |
| slugTo | String |  | Si se indica una key, el value de este field aparecerá en el campo de texto que tenga esa key en formato de slug. |
| title | String |  | Label del campo que aparecerá en el formulario. |
| type | String |  | Tipo de campo. |

## Detalles

## API response type

```tsx
type Text = string
```

## Comportamiento en el editor

Field para poner **textos básicos cortos,** sin necesidad de enriquecer el texto.
(Referencia: Ejemplo Schema para poner en módulo)
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘Lorem ipsum’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiarlo por el texto real.
- Si has puesto ‘Sabías que…’ marcamos esta opción como NO, porque es muy posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.

---

# TimeField

## Comportamiento en el editor

Field para seleccionar una **hora**. Sólo deja introducir caracteres numéricos.
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘hora actual’ marcamos esta opción como NO, porque es posible que el usuario no cambie el número, así que no queremos que el validador pase sobre él.

---

# ToggleField

Un botón toggle.

## Uso básico

```typescript
{
  "title": "Title",
  "type": "ToggleField",
	"key": "toggle",
}
```

```tsx
type Toggle = boolean
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| auxText | String |  | Texto que se incluye a la derecha del propio Toggle |
| background | Boolean |  | Añade un fondo al field |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| title | String |  | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## Return type

```tsx
type Toggle = boolean
```

---

# UniqueCheck

Un único check field.

## Uso básico

```typescript
{
  "type": "UniqueCheck",
  "key": "nofollow",
  "options": [
    {
      "title": "No follow",
    }
  ]
}
```

```tsx
type UniqueCheck = boolean;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| options | Array | ✅ | Array con un único objeto con el texto (label) del check. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type UniqueCheck = boolean;
```

## Comportamiento en el editor

Campo para activar/desactivar una opción
(Referencia: Ejemplo Schema para poner en módulo)

---

# UrlField

TextField para enlazar páginas o urls externas. Despliega 2 checkbox para nofollow y abrir en una nueva pestaña.

## Uso básico

```typescript
{
  "title": "Link image to URL",
  "type": "UrlField",
  "advanced": true,
  "key": "url"
}
```

```tsx
type Url = {
  href: string
  linkToURL: string
  newTab: boolean
  noFollow: boolean
  subSlug: string
  title: string
}
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| advanced | Boolean | ✅ | Habilita poder mostrar los checks. Por defecto: false. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| key | String | ✅ | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| placeholder | String |  | Texto que se muestra en el select sin opción seleccionada. |
| title | String | ✅ | Label del campo que aparecerá en el formulario. |
| type | String | ✅ | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Url = {
  href: string
  linkToURL: string
  newTab: boolean
  noFollow: boolean
  subSlug: string
  title: string
}
```

## Comportamiento en el editor

TextField para **enlazar páginas o urls externas.** Despliega 2 checkbox para nofollow y abrir en una nueva pestaña.
(Referencia: Ejemplo Schema para poner en módulo)
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘link’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiar el número.
- Si has puesto ‘https://…’ marcamos esta opción como NO, porque es posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.

---

# Visual unique selection

## Comportamiento en el editor

Campo para **seleccionar opciones visualmente.**
Se usa, sobre todo, en el panel Config de los módulos y componentes. 
**Ejemplo**: Layout, Theme,...
Los **thumbnails** tmb hay que generarlos para que desarrollo lo ponga.
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ no aplica en este campo.
### **Tabla anexa:**
Este campo es lo que consideramos un **campo complejo** y requiere añadir una tabla extra (por eso tiene un icono de un diamante y no de una pieza de puzzle). 
En este caso, es una tabla en la que ponemos las opciones que queremos que aparezcan en el campo con su representación visual y la opción que queremos que tenga por defecto.
- Style
El **número de columnas** indicado al lado del nombre es para definir cuántos thumbnails queremos que aparezcan por fila.
- aquí.

---

# Wysiwyg Full

## Comportamiento en el editor

Field para poner **textos largos,** con **todas las opciones** disponibles, incluido añadir imágenes.
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘Lorem ipsum’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiarlo por el texto real.
- Si has puesto ‘Sabías que…’ marcamos esta opción como NO, porque es muy posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.
** Si queremos que los compis de desarrollo ponga como texto mockup un párrafo de lorem ipsum en lugar de sólo ‘Lorem ipsum’ basta con poner ‘Lorem ipsum paragraph’. Podemos especificar unos caracteres mínimos y máximos (siempre consensuado con el cliente)

---

# Wysiwyg Mini

## Comportamiento en el editor

Field para poner **textos largos,** con opción a **enriquecer el texto** con opciones básicas: negritas, cursivas, bullets, links y estilos de textos. Es de los más usados.
**No pueden meter imágenes.
Es una versión reducida del Wysiwig con la opción full: false**
- Ejemplo Schema para poner en módulo
El apartado ‘**isMockup**’ hace referencia a si es un contenido que el validador de Griddo tenga que pasar y omitir. Es decir, que si no lo has cambiado, te salga una alerta cuando el usuario pasa el validador.
**Ejemplo**: 
- Si has puesto ‘Lorem ipsum’, marcamos esta opción como YES, porque queremos que nos avise si se nos ha olvidado cambiarlo por el texto real.
- Si has puesto ‘Sabías que…’ marcamos esta opción como NO, porque es muy posible que el usuario no cambie el texto, así que no queremos que el validador pase sobre él.
** Si queremos que los compis de desarrollo ponga como texto mockup un párrafo de lorem ipsum en lugar de sólo ‘Lorem ipsum’ basta con poner ‘Lorem ipsum paragraph’. Podemos especificar unos caracteres mínimos y máximos (siempre consensuado con el cliente)

---

# Wysiwyg

TextArea con el editor Froala.

Se pueden añadir botones para añadir clases y también sobreescribir idiomas en la configuración de los schemas.

## Uso básico

```typescript
{
  "title": "Subtitle",
  "type": "Wysiwyg",
  "key": "subtitle"
}
```

```tsx
type Wysiwyg = string;
```

## Propiedades

| Propiedad | Tipo | Required | Descripción |
|---|---|---|---|
| full | Boolean |  | Opción para mostrar la versión completa del toolbar con todos los botones. Por defecto: true. |
| helptext | String |  | Texto de ayuda que aparece debajo del campo. |
| hidden | Boolean |  | Oculta el campo en el editor de Griddo |
| hideable | Boolean |  | Si el campo puede ser ocultado por los editores. Por defecto: false |
| humanReadable | Boolean |  | Indica que el campo puede ser tratado en funcionalidades como traducciones automáticas con IA, etc.. |
| key | String |  | Nombre interno del campo para API. Camelcase. |
| mandatory | Boolean |  | Si el campo es obligatorio. Por defecto: false. |
| placeholder | String |  | Texto de ejemplo de contenido. |
| title | String |  | Label del campo que aparecerá en el formulario. |
| type | String |  | Tipo de campo. |

## Detalles

## API response Type

```tsx
type Wysiwyg = string;
```