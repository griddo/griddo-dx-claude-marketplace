# Tutoriales: Tu primer módulo, datos y render

## Tu primer módulo Griddo

Aprenderemos a crear un módulo Griddo paso a paso: desde UI y schema hasta su visualización en el editor.

### 1. UI y Schema: Archivos base

#### Crear el componente React

Crea el archivo React de UI en `src/ui/modules/BasicHero/index.tsx`:

```tsx
function BasicHero() {
	return <div>BasicHero</div>;
}

export default BasicHero;
```

#### Crear el schema

Crea el schema en `src/schemas/modules/BasicHero.ts`:

```tsx
const schema = {
	schemaType: "module",
	component: "BasicHero",
	displayName: "BasicHero",
	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
			],
		},
	],
	default: {
		component: "BasicHero",
		title: "Lorem ipsum",
	},
};

export default schema;
```

#### Exponer el módulo

Edita `src/ui/modules/index.tsx`:

```tsx
const BasicHero = React.lazy(() => import("./BasicHero"));

const modules = {
	...,
	BasicHero
};

export { ..., BasicHero };
```

Edita `src/schemas/modules/index.ts`:

```tsx
import BasicHero from "./BasicHero";

export default {
	...,
	BasicHero
};
```

### 2. Schema: Definir partes editables

Vamos a definir qué partes de nuestro módulo son "editables" desde el editor de Griddo. Añadiremos un **texto** y una **imagen**.

Abre `src/schemas/modules/BasicHero.ts` y actualiza los fields:

```tsx
const schema = {
	schemaType: "module",
	component: "BasicHero",
	displayName: "BasicHero",
	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
				{
					type: "ImageField",
					title: "Main Image",
					key: "image",
				}
			],
		},
	],
	default: {
		component: "BasicHero",
	},
};

export default schema;
```

### 3. AutoTypes: Tipado automático

AutoTypes construirá automáticamente la interfaz de TypeScript de tu módulo basado en el schema.

Lanza la herramienta:

```bash
yarn autotypes
```

Se creará una interfaz en `autotypes.d.ts`:

```tsx
export interface BasicHeroProps {
	component: "BasicHero";
	title?: Fields.Text;
	image?: Fields.Image;
}
```

### 4. Implementar la UI en React

Ahora que tienes el schema y los types, actualiza el componente React.

Abre `src/ui/modules/BasicHero/index.tsx`:

```tsx
import type { BasicHeroProps } from "@/autotypes";
import { GriddoImageExp } from "@griddo/core";

function BasicHero(props: BasicHeroProps) {
	const { title, image } = props;

	return (
		<div>
			<h1>{title}</h1>
			<GriddoImageExp image={image} />
		</div>
	);
}

export default BasicHero;
```

Hemos importado:
- El type **BasicHeroProps** para tipar las props
- **GriddoImageExp** para renderizar la imagen

### 5. Asignar el módulo a un template

Indica en qué sección de qué templates está disponible tu módulo. Esto es útil para organizar el sistema de diseño.

Abre el schema del template en `src/schemas/templates/BasicTemplate.ts` y añade tu módulo al whitelist de la sección correspondiente:

```tsx
...
{
	type: "ComponentArray",
	title: "Hero Section",
	maxItems: 1,
	whiteList: ["MainHero", "BasicHero"], // <-- añade BasicHero
	key: "heroSection",
	contentType: "modules",
},
...
```

Ahora los autores podrán añadir tu módulo en la sección HeroSection cuando creen una página basada en BasicTemplate.

### 6. Storybook: Desarrollo front eficaz

Griddo Starter incluye **Storybook** para trabajar de manera más enfocada en la parte de frontend.

Crea un archivo en `src/ui/modules/BasicHero/stories.tsx`:

```tsx
import type { BasicHeroProps } from "@/autotypes";
import type { Meta, Story } from "@storybook/react";

import BasicHero from ".";

export default {
	title: "Modules/BasicHero",
	component: BasicHero,
} as Meta;

const Template: Story<BasicHeroProps> = (props: BasicHeroProps) => <BasicHero {...props} />;

export const Play = Template.bind({});
Play.args = {
	title: "The title",
	image: {
		url: "https://images.your-instance.griddo.io/glasses",
		size: 1409287,
		width: 5070,
		height: 3380,
		position: "center",
		alt: "Alt text of the image",
		description: "Description of the image",
		name: "Name of the image",
		orientation: "S",
		tags: ["tag1", "tag2"],
		title: "Title of the image",
	},
};
```

Lanza Storybook:

```bash
yarn storybook
```

Navega a **Modules → BasicHero → Play** para ver tu módulo renderizado.

### 7. Editor de Griddo: La prueba final

Para ver tu módulo en el editor de Griddo:

```bash
yarn start:editor
```

- Ve a un Site
- Crea una nueva página de tipo "Static → BasicTemplate"
- En la sección "Hero Section" añade un módulo
- Selecciona **BasicHero** (aparecerá sin thumbnail)
- Edita su contenido (texto e imagen) directamente desde el editor

¡Tu módulo está listo para usar!

---

## Dato Simple: Tutorial completo

Aprenderemos a crear un dato simple (SCHOOLS), un módulo para mostrarlo, y renderizarlo desde un componente.

### Paso 1: Crear un dato simple SCHOOL

Los datos simples solo necesitan un **schema**, ya que no requieren crear la parte de la interfaz de usuario.

El dato `SCHOOLS` tendrá los siguientes fields:

- `title (TextField)`
- `image (ImageField)`
- `url (UrlField)`

#### Crear el schema

Crea un nuevo archivo en `src/schemas/content-type/simple/SCHOOLS.ts`:

```tsx
export const SCHOOLS = {
	title: "Schools",
	local: true,
	translate: true,
	clone: null,
	defaultValues: null,
	fromPage: false,
	schema: {
		fields: [
			{
				key: "title",
				title: "Title",
				type: "TextField",
			},
			{
				key: "image",
				title: "Image",
				type: "ImageField",
			},
			{
				key: "link",
				type: "UrlField",
				title: "Link",
			},
		],
	},
};
```

#### Exponer el schema

Edita `src/schemas/content-types/simple/index.ts`:

```tsx
import { SCHOOLS } from "./SCHOOLS";

export default {
	...,
	SCHOOLS,
};
```

#### Sincronizar con la API

Ejecuta en la raíz del repositorio:

```bash
yarn sync-schemas
```

A partir de ahora, podrás añadir todas las **SCHOOLS** que necesites en cualquier sitio desde el editor de Griddo.

### Paso 2: Crear un módulo SchoolShowcase

Vamos a crear un módulo que muestre datos SCHOOL. Este módulo usará un `ReferenceField` para permitir al editor seleccionar y filtrar SCHOOLS.

#### Crear el componente React

Crea el archivo en `src/ui/modules/SchoolShowcase/index.tsx`:

```tsx
function SchoolShowcase() {
	return <div>SchoolShowCase</div>
}

export default SchoolShowcase;
```

#### Crear el schema

Crea el schema en `src/schemas/modules/SchoolShowcase.ts`:

```tsx
const schema = {
	schemaType: "module",
	component: "SchoolShowcase",
	displayName: "SchoolShowcase",

	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
				{
					type: "ReferenceField",
					title: "Schools",
					sources: [{ structuredData: "SCHOOLS" }],
					selectionType: ["auto", "manual"],
					key: "data",
				},
			],
		},
	],

	default: {
		component: "SchoolShowcase",
		getStaticData: true,
		data: {
			sources: [{ structuredData: "SCHOOLS" }],
			mode: "auto",
		},
	},
};

export default schema;
```

**Nota:** 
- `ReferenceField` crea una entrada en el editor donde el usuario puede elegir una fuente de datos y aplicar filtros
- `getStaticData: true` inyecta los datos en el HTML de manera estática (sin llamadas a API al navegar)

#### Exponer el módulo

Recuerda importar y exportar el schema y UI en sus index correspondientes.

### Paso 3: Visualizar el dato desde SchoolShowcase

Ahora implementaremos el componente para consumir y renderizar la lista de `SCHOOLS`.

#### Implementar el componente

Abre `src/ui/modules/SchoolShowcase/index.tsx`:

```tsx
import type { SchoolShowcaseProps } from "@/autotypes";
import { GriddoImageExp, GriddoLink, useReferenceField } from "@griddo/core";

function SchoolShowcase(props: SchoolShowcaseProps) {
	const { title, data, queriedItems } = props;

	const schoolsFromEditor = useReferenceField(data);
	const schoolsFromRender = queriedItems;
	const schools = schoolsFromRender || schoolsFromEditor;

	return (
		<section>
			<h2>{title}</h2>
			{schools?.map((school, idx) => (
				<div key={idx}>
					<h3>{school.content?.title}</h3>
					<GriddoImageExp image={school.content?.image} />
					<GriddoLink url={school.content?.link}>Visit school</GriddoLink>
				</div>
			))}
		</section>
	);
}

export default SchoolShowcase;
```

#### Flujo de datos

Entender dónde provienen los datos es clave:

1. **Editor de Griddo:** Los datos vienen del hook `useReferenceField(data)`
   - `data` contiene la configuración del campo guardada por el autor
   - El hook ejecuta la consulta y devuelve un array

2. **Render final:** Los datos vienen de la prop `queriedItems`
   - Se inyectan automáticamente durante el render
   - Ya están resueltos y listos para usar

3. **Unificación:** Priotizamos `queriedItems` si existe; de lo contrario usamos el resultado del hook

#### Propiedades importantes

**`data` (ReferenceField)**

Contiene la configuración final guardada por el autor:

```javascript
{
	mode: "auto",
	order: "recent-DESC",
	quantity: 6,
	sources: [{structuredData: "SCHOOLS", globalOperator: "OR"}],
	fullRelations: true
}
```

**`queriedItems`**

Contiene el dato `SCHOOLS` ya consultado e inyectado en el HTML. Solo disponible durante el render.

**Acceso al contenido**

Toda la información que deriva del schema del dato está anidada bajo la propiedad `content`:

```tsx
school.content?.title    // acceso al título
school.content?.image    // acceso a la imagen
school.content?.link     // acceso al link
```

---

## Dato de página: Tutorial completo

Aprenderemos a crear un dato de página (página detalle), su módulo de visualización, y renderizarlo.

### ¿Qué es un dato de página?

Un dato de página es un contenido que se crea a través de un **template detalle** (detail template). Este template actúa como un formulario donde los editores introducen información que se mapea contra el schema del dato.

### Paso 1: Crear un template para datos (DetailTemplate)

El template definirá los campos que los editores usarán para crear nuevas instancias del dato.

#### Crear el schema del template

Crea un nuevo archivo en `src/schemas/templates/NewsDetail.ts`:

```tsx
export const schema = {
	schemaType: "template",
	component: "NewsDetail",
	displayName: "News Detail",
	type: {
		label: "News Detail",
		value: "newsTemplate",
		mode: "detail", // Debe ser "detail" para templates de datos
	},

	content: [
		{
			type: "TextField",
			title: "Title",
			key: "title",
		},
		{
			type: "ImageField",
			title: "Image",
			key: "image",
		},
		{
			type: "TextArea",
			title: "Body Text",
			key: "body",
		},		
	],

	default: {
		type: "template",
		templateType: "DetailTemplate",
		title: undefined,
		image: undefined,
		body: undefined,
	}
};

export default schema;
```

**Nota:** La diferencia clave es que `type.mode` debe ser `"detail"` para templates de datos.

#### Exponer el schema

Edita `src/schemas/templates/index.ts`:

```tsx
import NewsDetail from "./NewsDetail";

export default {
	...,
	NewsDetail,
};
```

#### Sincronizar con la API

```bash
yarn sync-schemas
```

Ahora los editores pueden crear páginas detalle (instancias de datos NEWS) desde el editor de Griddo.

### Paso 2: Crear un módulo NewsShowcase

Crea un módulo que muestre los datos NEWS usando un `ReferenceField`.

#### Crear el componente React

Crea el archivo en `src/ui/modules/NewsShowcase/index.tsx`:

```tsx
function NewsShowcase() {
	return <div>NewsShowcase</div>
}

export default NewsShowcase;
```

#### Crear el schema

Crea el schema en `src/schemas/modules/NewsShowcase.ts`:

```tsx
const schema = {
	schemaType: "module",
	component: "NewsShowcase",
	displayName: "NewsShowcase",

	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
				{
					type: "ReferenceField",
					title: "News Items",
					sources: [{ structuredData: "NEWS" }],
					selectionType: ["auto", "manual"],
					key: "data",
				},
			],
		},
	],

	default: {
		component: "NewsShowcase",
		getStaticData: true,
		data: {
			sources: [{ structuredData: "NEWS" }],
			mode: "auto",
		},
	},
};

export default schema;
```

#### Exponer el módulo

Recuerda importar y exportar el schema y UI en sus index correspondientes.

### Paso 3: Visualizar el dato desde NewsShowcase

Implementa el componente para consumir y renderizar la lista de noticias NEWS.

#### Implementar el componente

Abre `src/ui/modules/NewsShowcase/index.tsx`:

```tsx
import type { NewsShowcaseProps } from "@/autotypes";
import { GriddoImageExp, GriddoLink, useReferenceField } from "@griddo/core";

function NewsShowcase(props: NewsShowcaseProps) {
	const { title, data, queriedItems } = props;

	const newsFromEditor = useReferenceField(data);
	const newsFromRender = queriedItems;
	const news = newsFromRender || newsFromEditor;

	return (
		<section>
			<h2>{title}</h2>
			{news?.map((item, idx) => (
				<article key={idx}>
					<h3>{item.content?.title}</h3>
					<GriddoImageExp image={item.content?.image} />
					<p>{item.content?.body}</p>
					<GriddoLink url={item.url}>Read more</GriddoLink>
				</article>
			))}
		</section>
	);
}

export default NewsShowcase;
```

#### Diferencias con datos simples

Aunque la implementación es muy similar a un dato simple, hay una diferencia importante:

Los datos de página incluyen una propiedad `url` que apunta a la página detalle del dato. Esto permite crear links a la página de detalle de cada noticia.

```tsx
<GriddoLink url={item.url}>Read more</GriddoLink>
```

---

## Módulos Collection, Headers/Footers y Render

Aprenderemos a crear módulos tipo Collection (con Cards), Headers y Footers, y a configurar el SSR y contenido optimizado para LLMs.

### Módulo tipo Collection

Los módulos Collection son módulos que contienen múltiples componentes Card reutilizables dentro de ellos.

#### Crear el componente Card

Crea el archivo en `src/ui/components/Card/index.tsx`:

```tsx
import type { CardProps } from "@/autotypes";

function Card(props: CardProps) {
	const { title, description, image } = props;

	return (
		<div className="card">
			<img src={image?.url} alt={image?.alt} />
			<h4>{title}</h4>
			<p>{description}</p>
		</div>
	);
}

export default Card;
```

#### Crear el schema de Card

Crea el schema en `src/schemas/components/Card.ts`:

```tsx
const schema = {
	schemaType: "component",
	component: "Card",
	displayName: "Card",
	fields: [
		{
			type: "TextField",
			title: "Title",
			key: "title",
		},
		{
			type: "TextArea",
			title: "Description",
			key: "description",
		},
		{
			type: "ImageField",
			title: "Image",
			key: "image",
		},
	],
};

export default schema;
```

#### Crear el módulo Collection que contiene Cards

Crea el archivo en `src/ui/modules/CardCollection/index.tsx`:

```tsx
import type { CardCollectionProps } from "@/autotypes";
import Card from "@ui/components/Card";

function CardCollection(props: CardCollectionProps) {
	const { title, cards } = props;

	return (
		<section>
			<h2>{title}</h2>
			<div className="cards-grid">
				{cards?.map((card, idx) => (
					<Card key={idx} {...card} />
				))}
			</div>
		</section>
	);
}

export default CardCollection;
```

#### Crear el schema del módulo Collection

Crea el schema en `src/schemas/modules/CardCollection.ts`:

```tsx
const schema = {
	schemaType: "module",
	component: "CardCollection",
	displayName: "Card Collection",
	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
				{
					type: "ComponentArray",
					title: "Cards",
					whiteList: ["Card"],
					key: "cards",
				},
			],
		},
	],
	default: {
		component: "CardCollection",
		cards: [],
	},
};

export default schema;
```

#### Asignar a un template

Añade el módulo al whitelist de una sección en el template deseado.

### Headers y Footers

Los Headers y Footers son módulos especiales que se renderizaban globalmente en todas las páginas.

#### Crear un Header

Crea el archivo en `src/ui/modules/Header/index.tsx`:

```tsx
import type { HeaderProps } from "@/autotypes";
import { GriddoLink } from "@griddo/core";

function Header(props: HeaderProps) {
	const { logo, menu, cta } = props;

	return (
		<header>
			<img src={logo?.url} alt="logo" />
			<nav>
				{menu?.map((item, idx) => (
					<GriddoLink key={idx} url={item.url}>
						{item.label}
					</GriddoLink>
				))}
			</nav>
			<button>{cta}</button>
		</header>
	);
}

export default Header;
```

#### Configurar Headers y Footers globales

En el template global o en la configuración de sitio, puedes asignar un módulo Header y Footer que aparezcan en todas las páginas.

### Render y Generación de contenido

#### Configuración SSR

Griddo permite modificar el comportamiento de las páginas generadas durante el proceso de render (SSR) mediante el archivo `builder.ssr.js` ubicado en el directorio raíz.

##### Hook `onRenderBody`

Esta función se invoca después de que el Render procese cada página y permite especificar componentes en el `<head>` y `<body>`:

```jsx
function onRenderBody({ setHeadComponents, setBodyAttributes, pathname }) {
  const commonHeadComponents = [];

  // Set different scripts for Griddo Builder and Griddo Editor
  const headComponents =
	  pathname === "ax-editor"
		  ? [...commonHeadComponents, grissoDevMode, griddoWebfonts]
  		: [...commonHeadComponents, griddoWebfonts];

  setHeadComponents(headComponents);
  setBodyAttributes({ id: "griddo-site" });
}

export default { onRenderBody }
```

**Parámetro `pathname`:**
- En el editor: siempre será `"ax-editor"`
- En render: será la ruta de la página

Esto permite inyectar diferentes scripts según el contexto.

#### Generación de contenido optimizado para LLMs

Cuando se activa, el proceso de render genera automáticamente versiones del contenido del sitio optimizadas para LLMs.

##### ¿Qué se genera?

**`llms.txt`** en la raíz del dominio. Contiene un índice de todas las páginas publicadas:

```markdown
llms.txt for the domain domain-name
Generated: 2026-01-27 11:29:07

- [Page title](page-url) meta-description
- [Page title](page-url) meta-description
```

**Archivos Markdown (`.md`)** junto a cada página cuando se activa la opción correspondiente. Son versiones limpias sin navegación, scripts ni estilos.

##### Activación

Controla estas funcionalidades mediante variables de entorno:

| Variable | Por defecto | Efecto |
|----------|-------------|--------|
| `GRIDDO_RENDER_DISABLE_LLMS_TXT` | `false` | Poner a `true` para deshabilitar `llms.txt` |
| `GRIDDO_RENDER_ENABLED_LLM_MD` | `false` | Poner a `true` para habilitar `.md` por página |

Cuando `GRIDDO_RENDER_ENABLED_LLM_MD` está activo, los enlaces en `llms.txt` apuntarán a `.md` en lugar de HTML.

##### Personalizar `llms.txt`

Crea un archivo `/static/llms.md` como plantilla personalizada:

```markdown
{{ LLMS_HEADER }}

> Custom instance text

{{ LLMS_PAGE_LINKS }}

**Other text as footer content**
```

Placeholders disponibles:
- `{{ LLMS_HEADER }}` - cabecera autogenerada (dominio + timestamp)
- `{{ LLMS_PAGE_LINKS }}` - listado de páginas

Resultado:

```markdown
llms.txt for the domain domain-name
Generated: 2026-01-27 11:29:07

> Custom instance text

- [Page title](page-url) meta-description
- [Page title](page-url) meta-description

**Other text as footer content**
```

##### Personalizar conversión a Markdown

Ajusta la salida Markdown desde la config de Griddo bajo `config.schemas.config`. Por ejemplo, para incluir imágenes:

```tsx
// griddo.config.ts
export default defineConfig({
  config: {
    schemas: {
      config: {
        skipImages: false,
      }
    }
  }
})
```

### Griddo SDK

El Griddo SDK proporciona utilidades y hooks para trabajar con datos y contextos en tus módulos y componentes:

- `useReferenceField()` - accede a datos referenciados en campos ReferenceField
- `useContentSearch()` - ejecuta búsquedas de contenido
- `GriddoImageExp` - componente optimizado para imágenes
- `GriddoLink` - componente para links internos y externos
