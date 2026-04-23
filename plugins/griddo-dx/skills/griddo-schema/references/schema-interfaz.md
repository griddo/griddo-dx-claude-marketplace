# Componentes

Define la estructura de datos del componente para visualizar los campos de entrada en el editor y recibir los datos desde la API con las props definidas en el propio schema. Más abajo lo veremos por las distintas partes.

Ejemplo de un schema para un componente `Image` 

```tsx
import { ImageProps } from "@autoTypes"
import { Schema } from "@griddo/core"

const schema: Schema.Component<ImageProps> = {
	schemaType: "component",
  displayName: "Image",
  component: "Image",

  configTabs: [
		{
			title: "",
			fields: [
				{ type: "ImageField", title: "Image", key: "image" },
				{ type: "TextField", title: "Alt text", key: "alt" },
			]
		}
	],

	default: {
		component: "Image",
		image: null,
		alt: null,
	},
}

export default schema
```

## Metadatos

`schemaType` Es necesario para el funcionamiento interno de Griddo indicar que este es un schema de component.

`displayName` Aquí indicamos cómo se va a visualizar nuestro componente dentro del Editor de Griddo.

`component` Esencialmente este es el nombre del componente de React al que va a estar asociado este schema.

```tsx
const schema: Schema.Component<ImageProps> = {
	// ...
	schemaType: "component",
  displayName: "Image",
  component: "Image",
	// ...
}
```

## Tabs

Es un array de objetos que representan las pestañas en la edición del componente donde irán alojados los Fields. Siempre debe haber una pestaña a la que llamemos `content`

A la hora de recibir las props las pestañas son inocuas y todas las props en el componente de React llegarán juntas, en el caso de abajo será un objeto con tres keys: `{ image, alt, imageFx }`

```tsx
configTabs: [
	{
		title: "content",
		fields: [
			{ type: "ImageField", title: "Image", key: "image" },
			{ type: "TextField", title: "Alt text", key: "alt" },
		]
	},
	{
		title: "config",
		fields: [
			{ type: "Toggle", title: "Apply FX", key: "imageFx" },
		]
	}
]
```

## Default

El apartado default sirve para establecer valores por defecto en el schema en caso de que así lo queramos.

`component` Es obligatorio volver a especificar el nombre del componente al que hace referencia. En este caso `component: "Image"` lo demás sería opcional.

<aside>
💡

Dependiendo del tipo de Field utilizado, puede que en `default` nos requiera establecer un valor por defecto para el Field en cuestión de forma obligatoria.

</aside>

```tsx
import { ImageProps } from "@autoTypes"
import { Schema } from "@griddo/core"

const schema: Schema.Component<ImageProps> = {
	schemaType: "component",
  displayName: "Image",
  component: "Image",

  configTabs: [
		{
			title: "",
			fields: [
				{ type: "ImageField", title: "Image", key: "image" },
				{ type: "TextField", title: "Alt text", key: "alt" },
			]
		}
	],

	default: {
		component: "Image",
		image: null,
		alt: null,
	},
}

export default schema
```

# Frontless

Los schemas de tipo frontless son schemas que van a ser utilizados dentro de otros schemas mediante los fields `componentArray` o `componentContainer` . Pero que no tiene un componente React asociado. Podemos verlo como una manera de hacer nuestros propios **fields** componiendo distintos Fields de Griddo.

## Ejemplo

Un schema `Image` el cual construiremos utilizando dos fields de Griddo: `ImageField` y `TextField`

En realidad es exactamente igual que un schema de un componente o un módulo, pero vivirán en otra carpeta por motivos de estructura y orden.

Este schema que llamaremos `Image`, no se corresponde con un componente de la biblioteca `Image` si no que lo usaremos en el schema de un módulo mediante `ComponentContainer` o `ComponentArray` y su salida la podremos usar donde queramos, probablemente en un `<GriddoImage>` pero podría ser en cualquier otro componente o módulo en el que necesitemos la información de una imagen.

Aquí tenemos un ejemplo de un schema de tipo frontless

```tsx
import { Fields, Schema } from "@griddo/core";

const schema: Schema.UI = {
	schemaType: "component",
	component: "Image",
	displayName: "The Image",

	configTabs: [
		{
			title: "content",
			fields: [
				{
					title: "Image",
					type: "ImageField",
					key: "imageField",
					helptext: "The image file.",
				},

				{
					title: "Alternative Text",
					type: "TextField",
					key: "alt",
					helptext: "Set the alternative text for the image.",
				},
			],
		},
	],

	default: {
		component: "Image",
		imageField: undefined,
		alt: null,
	},

};
```

Y aquí un posible uso en un módulo.

```tsx
import { Schema } from "@griddo/core";

const schema: Schema.UI = {
	schemaType: "component",
	component: "ImageCard",
	displayName: "ImageCard",

	configTabs: [
		{
			title: "content",
			fields: [
				**{
					title: "Image",
					type: "ComponentContainer",
					whiteList: ["Image"],
					key: "image",
					helptext: "The image of the card",
				},**
			],
		},
	],

	default: {
		component: "BasicCard",
		**image: { component: "Image" },**
	},
};

export default schema;
```

# Modulos

[Modulo estándar](Modulos/Modulo%20est%C3%A1ndar%20a539f02d3929408b90cd3d85db9088ea.md)

[Headers y Footers](Modulos/Headers%20y%20Footers%20cc2d68c3745a42aaa42badda0e66a8ee.md)

[Distribuidores](Modulos/Distribuidores%2086182a8bd86d48668ffb3355b2b028f2.md)

[MultiPage](Modulos/MultiPage%20e317306781824c379e868b9e2bb6ba69.md)

# Templates

Cómo escribir schemas de templates en Griddo.

## Tipos de templates

Existen varios tipos de templates: Static, Detail y List

[Templates listados](Templates/Templates%20listados%200aaf0d4d00b84e8ab1c82bde07005f6b.md)

### Propiedades comunes obligatorias

```jsx
// Propiedades comunes a todos los schemas

export default {
  schemaType: "template",
  displayName: "",
  component: "",
  type: { label: "", value: "" },

  // Array con los fields de Griddo.
  content: [
  ]

  // Después de definir el type y el templateType...
  // aquí van valores por defecto de los campos descritos anteriormente
  // en content.
  default: {
    type: "template",
    templateType: "",
  }

  // Urls de las imágenes (@1x y @2x) usadas como thumbnails dentro de Griddo
  thumbnails: {
    "1x": "http://www.cdn.com/template-lowres.png",
    "2x": "http://www.cdn.com/template-hires.png",
  },
}
```

### Propiedades comunes opcionales

**Dimensions**

Las dimensiones es un conjunto de datos clave-valor que van vinculados a una página y se utilizan para ser enviadas al dataLayer (Analytics) cuando se carga la página. Si bien las propiedades de dataLayer / Analytics se gestionan desde AX, hay una serie de propiedades que son intrínsecas a una template y que además se rellenan de manera automática con datos de la propia página. A diferencia de las dimensiones gestionadas desde AX, que se editan desde AX, las dimensiones específicas de una template se envían siempre al cargar una página hecha con esa template utilizando los valores indicados en otras propiedades de la template.

Para ello hay que añadir un array `dimensions` en la raíz del schema del template el cual contendrá tantas dimensiones como sean necesarias con tres claves obligatorias por cada dimensión.

**Ejemplo**

```jsx
export default {

  // ...

  dimensions: [
    {
      key: 'dateCreated',
      title: 'Date Created',
      from: 'date',
    },
  ]

  // ...
```

### Static

Son las templates más básicas. Cuando te crees un sitio, estas serán las que vengan por defecto, como por ejemplo la Basic Template.

### Detail

Las templates Detail serán las que podremos obtener a través de la activación de los data packs. Como su propio nombre indica, sirven para hacer una página-detalle o lo que es lo mismo una página centrada en un elemento como puede ser la ficha de un empleado, una noticia destacada o evento a realizar.

Por lo general, las templates Detail se crean como páginas globales.

## Estructura

```jsx
export default {
  schemaType: 'template',
  displayName: 'Basic Template',
  component: 'BasicTemplate',
  dataPacks: null,
  type: {
    label: 'Static',
    value: 'static',
  },

  content: [
    {
      title: 'Template Section',
      type: 'ComponentArray',
      maxItems: null,
      whiteList: [],
      key: 'templateSection',
    },
  ],

  default: {
    type: 'template',
    templateType: 'BasicTemplate',
    templateSection: {
      component: 'Section',
      name: 'Template Section',
      modules: [],
      sectionPosition: 1,
    },
  },

  thumbnails: {
    '1x': '<%GRIDDO_COMPONENT_NAME%>',
    '2x': '<%GRIDDO_COMPONENT_NAME%>@2x',
  },
}
```

## Special

La 404 y SiteMap

## Elementos

### Distribuidores

# Distribuidores

# Ejemplo

```tsx
import { Schema } from "@griddo/core";

const schema: Schema.ContentTypeModule = {
	schemaType: "module",
	component: "ReferenceFieldModule",
	displayName: "Distributor",
	category: "distributors",
	dataPacks: ["GRIDDO_PACK"],

	configTabs: [
		{
			title: "content",
			fields: [
				{
					title: "Members",
					type: "ReferenceField",
					source: ["MEMBER"],
					selectionType: ["auto", "manual"],
					key: "data",
				},
			],
		},
	],

	default: {
		component: "ReferenceFieldModule",
		hasDistributorData: true,
		data: {
			source: ["MEMBER"],
			mode: "auto",
			order: "alpha",
			quantity: 2,
			/* ---------- */
			/* opcionales */
			/* ---------- */
			// order: 'alpha-ASC',
			// filter: ['string'],
			// fullRelations: true,
			// quantity: 2
		},
	},

	thumbnails: {
		"1x": "/thumbnails/modules/ReferenceFieldModule/thumbnail@1x.png",
		"2x": "/thumbnails/modules/ReferenceFieldModule/thumbnail@2x.png",
	},
};

export default schema;
```

### Headers y Footers

# Headers y Footers

En Griddo tenemos dos clases de módulos especiales que serán utilizados dentro del apartado Navegación: **Headers** y **Footers**

## Cómo se configura

Para que un módulo esté disponible como **Header** o **Footer** debe contener en su schema una propiedad `type` que tendrá como valor `header` o `footer` dependiendo qué es lo que queramos. Desde ese momento los tendremos disponibles en en apartado ***Navigation > Navigation Modules*** del editor.

## Múltiples headers y footers

Griddo acepta múltiples **headers** y **footers**. Es decir, es posible indicar la key `type: footer|header` en varios módulos a la vez. Añadiendo además `defaultNavigation: true` en el que queramos que se muestre por defecto.

<aside>
👀 No es necesario especificar los thumbnails en el esquema, ya que ahora Griddo los genera automáticamente para cada header/footer al crearlos o modificarlos.

</aside>

**Ejemplo**

```jsx
{
	schemaType: "module",
  displayName: "My Header",
  component: "MyHeader",
  **type: "header",
  defaultNavigation: true,**
  category: "header",
  configTabs: [...],
	default: {...},
	styles: {...},
}
```

### Modulo estándar

# Modulo estándar

Define la estructura de un módulo.

# Ejemplo

```tsx
import { Schema } from "@griddo/core";

const schema: Schema.Module = {
	schemaType: "module",
	component: "BasicModule",
	displayName: "BasicModule",

	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "HeadingField",
					title: "Title",
					default: { content: "Lorem ipsum", tag: "h2" },
					key: "title",
					placeholder: "Type your title",
					advanced: true,
					helptext: "Write plain text and select the heading type",
					hideable: true,
					isMockup: false,
					mandatory: true,
					options: [
						{ label: "h1", value: "h1" },
						{ label: "h2", value: "h2" },
						{ label: "h3", value: "h3" },
					],
				},

				{
					type: "RadioGroup",
					key: "subtheme",
					title: "Subtheme",
					options: [
						{ name: "light", title: "light", value: "light" },
						{ name: "dark", title: "dark", value: "dark" },
					],
				},
			],
		},
	],

	default: {
		component: "BasicModule",
		title: {
			content: "Lorem",
			tag: "h2",
		},
		subtheme: "light",
	},

	thumbnails: {
		"1x": "/thumbnails/modules/BasicModule/thumbnail@1x.png",
		"2x": "/thumbnails/modules/BasicModule/thumbnail@2x.png",
	},
};

export default schema;
```

# TypeScript

## Genéricos

`Schema.Module` acepta un type genérico que podemos utilizar para tipar la key `default` de esta manera obtenemos auto completado y type checking en la key default dependiendo del propio schema.

```tsx
// Schema file for the HeroModule
const HeroModuleSchema = Schema.Module<HeroModuleProps> = {
	default: {
		// ... obtenemos TypeScript features
	}
}
```

### MultiPage

# MultiPage

MultiPage es la capacidad de un **módulo** para generar varias páginas independientes, cada una con sus propiedades SEO.

## Creación

El módulo MultiPage siempre va a estar definido por un módulo principal y unos componentes anidados ( `ComponentArray` ). Esos elementos definirán las páginas.

### Schema del módulo principal

Hay que añadir la key `hasGriddoMultiPage: true` en los valores por defecto del **schema**. Además, necesitamos que exista un array de elementos `ComponentArray` cuyo **key** será obligatoriamente `elements`. Estos elementos acabarán siendo cada una de las páginas y contendrán, al menos, la información de página relativa al SEO (lo veremos más adelante)

**Ejemplo (código reducido)**

```jsx
// Schema de un módulo MultiPage
export default {
  displayName: "Multi Page Module",
  component: "MultiPageModule",
  configTabs: [
    {
      title: "content",
      fields: [
        {
          title: "Multi Page Element (page)",
          **type: "ComponentArray",**
          **key: "elements",**
          whiteList: ["MultiPageElement"],
        },
      ],
    }
  ],
  default: {
    component: "MultiPageModule",
    **hasGriddoMultiPage: true,**
    elements: [
      { component: "MultiPageElement", sectionSlug: "/" },
      { component: "MultiPageElement", sectionSlug: "tab-02" },
      { component: "MultiPageElement", sectionSlug: "tab-03" }
    ],
  }
}
```

### Schema de los componentes `elements`

También necesitamos incluir **cuatro keys obligatorias:** `sectionSlug`, `metaTitle`, `metaDescription`, y `title` idealmente en la pestaña **Seo.**

**Ejemplo (código reducido)**

```jsx
export default {
  displayName: "Multi Page Element",
  component: "MultiPageElement",
  configTabs: [
    {
      title: "content",
      fields: [...],
    },

    {
      title: "Seo",
      fields: [
        **{
          title: "Page title",
          key: "title",
          type: "TextField",
        },**
        **{
          title: "Section Slug",
          key: "sectionSlug",
          type: "TextField",
        },
        {
          title: "Meta title",
          key: "metaTitle",
          type: "TextField",
        },
        {
          title: "Meta description",
          key: "metaDescription",
          type: "TextField",
        },**
      ],
    },
  ],

  default: {
    component: "MultiPageElement",
    **title: "Tab title"**,
    **sectionSlug: "tab-01",
    metaTitle: "The meta title",
    metaDescription: "The meta description",**
  },
}
```

### Módulo react

En los modulos MultiPage tendremos que controlar el comportamiento en dos entornos diferentes: **AX** y **CX**.

Pongamos el caso de unas pestañas, las cuales queremos que apunten a distintas paginas. En AX vamos a querer que al hacer click en cada una de las pestañas, no navegue a las paginas, sino que muestre el contenido de las mismas, pero sin navegar. En definitiva necesitaremos un control de estados. Por otro lado en CX queremos que se dirija a la pagina correspondiente. 

<aside>
⚠️ TODO: Hook en Griddo para esa gestión AX/CX ???

</aside>

**El hook `useRenderer` y las props `activeSectionSlug` y `activeSectionBase`**

`useRenderer` nos permite saber donde (AX o CX) esta siendo renderizado el modulo y actuar en consecuencia. Por otro lado tenemos las props `activeSectionSlug` que tiene el valor del slug de la página que el usuario haya establecido en el apartado SEO del element ,y `activeSectionBase` que nos dice a qué página pertenece ese slug. Esto lo veremos más claramente en los ejemplos de código.

En este ejemplo de código se puede ver que la prop `active` del componente `<Tab>` se establece en AX usando `idx` y el estado `tabIndex` . En CX se hace comparando la prop `activeSectionSlug` y el `sectionSlug` de la propia pestaña.

```jsx
function MultiPageModule({ elements }) {
  const { isEditor: isAX } = useRenderer()
  const { activeSectionSlug, activeSectionBase } = usePage()
  const [tabIndex, setTabIndex] = React.useState(0)

  return elements.map((el, idx) => (
		<div onClick={() => setTabIndex(idx)} key={idx}>
		  <Tab
        title={el.title}
				// en AX no hey href
        // en CX hay href y es = base + slug
        href={isAX ? null : `${activeSectionBase}${el.sectionSlug}`}
        // en AX el activo se controla usando useState
        // en CX el activo se controla con base + slug
        active={
          isAX ? tabIndex === idx : activeSectionSlug === el.sectionSlug
        }
	  	/>
		</div>
	)
}
```

## Comportamiento de las páginas

Las páginas podrán tener el `sectionSlug` que queramos, pero una de ellas será el raíz, que indicaremos dejando vacío el campo o poniendo `/` , este element será el que estará activo cuando se visite la página raíz.

## Apuntes extra desde el punto de vista de CX

Esto está escrito desde el punto de vista de lo que CX necesita para poder generar las multipáginas.

El componente debe tener:

```json
{
hasGriddoMultipage: true,
elements: [
   {
      sectionSlug,
      title,
      metaTitle,
      metaDescription
   }
]
```

- Elements es por cada subpágina. Cada objeto representa una subpágina. La configuración de title, metaTitle y metaDescription, así como sectionSlug, es para cada subpágina. Nota mental: hemos hecho que sea “elements”, pero así sin el estrés de cuando se desarrolló a toda prisa, de repente me parece que tenía que haberse llamado “sections”. Cambiarlo es facil.
- Si alguna de estas propiedades (title, metaTitle, metaDescription) no se encuentra, se dejará por defecto la que tuviera la página contenedora en sí. Si el usuario no pone sectionSlug, se entenderá que es “/”.
- sectionSlug puede ser “/”, lo normal es que haya siempre al menos un “/”, pero no puede haber más de uno ni un slug duplicado. API reformatea siempre el sectionSlug para que sea formato “/loquesea” (con el slash delante, solo un slash). El sectionSlug también se reformatea al guardar la página con ese mismo formato.

### Templates listados

# Templates listados

Podemos configurar un template en modo `list` lo que a parte de mostrar datos podrán ser paginados y en el proceso de build-render se generarán las páginas necesarias con los slugs `/2` , `/3` etc..

## Configuración

Para configurar un template de listado y que pagine tiene que existir en el template de forma obligatoria aparte de `mode: list` y el `hasDistributorData: true` la prop **`itemsPerPage`** que podrá ser establecida a mano en el template o mediante un field para ser configurada en el editor.

**Ejemplo de un template listado con paginación (código reducido)**

```tsx
// Defaults from modules
export default {
  ...

  **type: { label: "Events", value: "events", mode: "list" },**

  content: [
    ...
    {
      **title: "Items/page",
      type: "NumberField",
      key: "itemsPerPage",
      default: 10,
      mandatory: true,**
    },
    ...
  ],

  default: {
    ...
    **itemsPerPage: 10,
    ...**
  },

}
```

## ¿Qué voy a recibir en el template como props relativas al listado?

Recibirás, aparte de las props normales del schema estas, que podrás usar por ejemplo para construir un paginador.

- `isFirstPage` si es la primera página, normalmente será true en la página original del listado.
- `pageNumber` el número de la página que además será el slug de paginación, por ejemplo si `pageNumber = 2`, la página será `www.dominio.com/pagina-listado/**2`**
- `totalPages` el número total de páginas, que es los items totales del dato / `itemsPerPage`
- `baseLink` link de la(s) página(s) y que querrás concatenar con `pageNumber` etc.. para configurar una url final `${baseLink}${pageNumber}`

NOTA: La página 1, tendrá como `pageNumber=1` pero en realidad la página uno no tiene slug de paginación. Ojo con esto al construir un paginador.

[www.dominio.com/pagina-listado](http://www.dominio.com/pagina-listado) ← BIEN

[www.dominio.com/pagina-listado/1](http://www.dominio.com/pagina-listado/1) ← MAL