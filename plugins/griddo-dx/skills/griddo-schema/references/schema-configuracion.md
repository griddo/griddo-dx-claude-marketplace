# Categorías de módulos

Schema para la definición de categoría de módulos dentro de la instancia. Esto permite ordenar visualmente los módulos dentro de la interfaz del editor.

Una vez definidas las categorías podemos utilizarlas en los [Schemas de interfaz](../Schemas%20de%20interfaz%20c2051c1e50344700a81a9aa8afc2a74d.md) mediante la key `category` 

**Archivo**

`src/schemas/config/module-categories.ts`

**Ejemplo**

```tsx
import { Schema } from "@griddo/core";

export const moduleCategories = [
  {
    label: 'Spacers',
    value: 'spacers',
    featured: true,
  },
  {
    label: 'Basic',
    value: 'basic',
  },
  {
    label: 'Distributors',
    value: 'distributors',
  },
] as const satisfies Schema.ModuleCategories;
```

# Griddo DAM

Schema de configuración para los valores por defecto que utilizará [<GriddoImage> (deprecado)](../../Componentes/GriddoImage%20(deprecado)%20bb084960e72e4b04830a73160ad0e029.md) y [<GriddoImageExp>](../../Componentes/GriddoImageExp%20fdb4ea84ac044b1884f242ac854d9c1d.md) 

**Archivo**

`src/schemas/config/dam.ts`

**Ejemplo**

```tsx
import type { Schema } from "@griddo/core";

export const damDefaults: Schema.DamDefaults = {
	quality: 75,
	crop: "cover",
	loading: "lazy",
	decoding: "async",
	formats: ["webp"],
};

```

# Idiomas

Es necesario definir los idiomas del proyecto en el repositorio. Esto se consigue exportando un schema en el objeto `schema` de la configuración en `griddo.config.ts` como podemos ver más abajo en el ejemplo. Puedes consultar más sobre exportaciones de Griddo en [*Exports principal*es](../../../Empieza%20aqu%C3%AD/Configura%20tu%20nuevo%20proyecto/Exports%20principales%20362271d8330c460197ff1c511a5c464b.md) 

**Archivo**

`src/schemas/config/languages.ts`

Esta configuración de idiomas también se usará para las traducciones estáticas utilizando el hook [useI18n](../../Hooks/useI18n%20f51d1bf617fc4a079c0bb2134cf69dc4.md) de Griddo y la gestión de las fechas con [useLocaleDate](../../Hooks/useLocaleDate%20ab823db9197b40ef92bb543db8aa8eb4.md).

```tsx
import type { Schema } from "@griddo/core";

export const languages: Schema.Languages = {
	en_GB: {
		name: "English",
		label: "EN",
	},
	es_ES: {
		name: "Spanish",
		label: "ES",
	},
} as const;

```

## Nota sobre cambio en los esquemas de idiomas

Si a la lista se añade un idioma, se añade a todo el entorno automáticamente al exportar el esquema.

Si se elimina un idioma, ese idioma se eliminará **si no tiene contenidos asociados**. 

Si lo que queremos es modificar las propiedades `name` o `label`, es tan sencillo como cambiarlo en el esquema. Sin embargo, cuando se quiere cambiar la key del locale (`es_ES` por ejemplo), es más complicado porque hay que dejar claro que es una corrección sobre un idioma distinto y no un idioma nuevo. En ese caso, lo que hay que hacer es utilizar la propiedad `alias`, para decir que un idioma que estás definiendo es una corrección de otro. Por ejemplo, si tenemos `es_ES` y queremos que sea `es`, sería así:

```tsx
const schema: Schema.Languages = {
	en_GB: {
		name: "English",
		label: "EN",
	},
	es: {
		name: "Spanish",
		label: "ES",
    **alias: ["es_ES"]**
	},
};
```

Si hay errores, se hace una referencia recursiva o el array es incorrecto, API dará un error bastante detallado informando de dónde está el problema.

¡**Cuidado**! Es importante que los esquemas del equipo estén coordinados. Si haces el cambio en un repositorio, pero hay miembros del equipo que siguen trabajando con el esquema anterior, tú cambiarás en este caso es `es_ES` por `es`, pero al sincronizarse los esquemas desde una rama que no está actualizada se producirá un error.

¡**Más cuidado**! Si cambias el locale de un idioma, es bastante probable que también tengas que cambiar referencias que pudieras tener en el repo de la instancia, sobre todo en lo referente a traducciones.

¡**Más cuidado aún**! Cuando se cambian los esquemas de idiomas, es necesario volver a hacer el build de AX, porque si no se produce incoherencia entre lo que tiene API y lo que tiene AX.

# Menu items

Este *schema* representa los *fields* extras que queramos que aparecerán por cada elemento de menú en el editor de Griddo tanto par la opción **Link** como para **Grouping Element.**

<aside>
👀 Si no deseamos ningún campo adicional en **Link**, **Grouping Element**, o **ambos**, debemos crear el *schema* con *keys* vacías, como se muestra en un ejemplo [más abajo](Menu%20items%20e0c68c85f4c8440282c6234d0d56b60e.md).

</aside>

**Archivo**

`src/schemas/config/menu-items.ts`

## Exportar los nuevos schemas.

Debemos exportar el nuevo schema en el archivo `griddo.config.js|ts` que está en la raíz de del proyecto como `menu-items` dentro del objeto `schemas` como se muestra a continuación.

```jsx
// .........
// .........
// .........

const schemas = {
	all: { ...objects, ...components, ...modules },
	modules,
	templates,
	dataPacks,
	dataPacksCategories,
	structuredData: {
		...simpleContentType,
		...pageContentType,
		...categories,
	},
	languages,
	menus,
	menuItems, // <------ nuevo schema
};

export { schemas, themes, moduleCategories };
```

## **TypeScript**

### Schema

Para typar el schema de menu items Griddo exporta su propio type que se debe utilizar.

```bash
import { Schema } from "@griddo/core"
const schema: Schema.MenuItem = {
//                   ^
```

### Griddo + Instancia

[AutoTypes™️](../../../Herramientas/AutoTypes%E2%84%A2%EF%B8%8F%20e7420867dd2e489c8da34a493b763cd8.md)  generará uno los types necesarios para los Menús que incluye tanto los fields que vienen con Griddo como los que se hayan añadido en el schema de [Menu items](Menu%20items%20e0c68c85f4c8440282c6234d0d56b60e.md)

### LinkMenuElement y GroupMenuElement

Griddo proporciona varios types con los que trabajar en los menús. Esto es útil cuando queramos diferenciar en el código los items de menú de tipo **Link** o **Group**. Para ello podemos hacer [type assertion](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#type-assertions) utilizando la *prop* `config.type` de los elementos de menú para saber si lo que nos está llegando es un elemento **Link** o un **Grouping Element** y hacer el assertion correspondiente. ****Griddo proporciona dos types para el assertion: `LinkMenuElement` y `GroupMenuElement`. 

**Ejemplo**

```tsx
import { LinkMenuElement, GroupMenuElement } from "@autoTypes";

const Header = (props: HeaderProps) => {
	const { menu } = props;

	return menu?.elements?.map((menuElement) => {

		if (menuElement.config?.type === "link") {
			return menuElement as LinkMenuElement;
      //     ^ menuElement.anyPropFromGriddoOrInstanceLink
		}

		if (menuElement.config?.type === "group") {
			return menuElement as GroupMenuElement;
      //     ^ menuElement.anyPropFromGriddoOrInstanceGroup
		}

		// ...
	})
}
```

## Schemas de ejemplo

**Schema con fields**

```tsx
import type { Schema } from "@griddo/core";

export const menuItems: Schema.MenuItem = {
	link: {
		fields: [
			{
				type: "TextField",
				title: "Auxiliar text",
				key: "auxText",
			},
			{
				type: "ImageField",
				title: "Image",
				key: "image",
			},
			{
				type: "ToggleField",
				title: "Check it if the link has a special behavior.",
				key: "special",
			},
		],
	},

	group: {
		fields: [
			{
				type: "TextField",
				title: "Auxiliar text",
				key: "auxText",
			},
			{
				type: "ImageField",
				title: "Image",
				key: "image",
			},
			{
				type: "ToggleField",
				title: "Check it if the link has a special behavior.",
				key: "special",
			},
		],
	},
};
```

**Schema vacío.**

```tsx
import type { Schema } from "@griddo/core";

export const menuItems: Schema.MenuItem = {
	link: { fields:[] },
	group: { fields: [] },
};
```

# Menus

El schema para los menús representará los tipos de menús disponibles en la instancia de Griddo de cara a utilizarlos tanto en los módulos de tipo **header** como **footer**.

Archivo

`src/schemas/config/menus.ts`

**Schema de ejemplo**

```jsx
import type { Schema } from "@griddo/core";

export const menus: Schema.Menu = [
	{
		key: "mainNav",
		display: "Main navigation",
	},

	{
		key: "footerNav",
		display: "Footer navigation",
	},
] as const;

```

# Socials

Este *schema* representa los campos que saldrán en la opción Social de los sites.

**Archivo**

`src/schemas/config/socials.ts`

**Schema**

```tsx
import type { Schema } from "@griddo/core";

const schema: Schema.Socials = ["instagram", "x", "tik-tok"];

export default schema;
```

## Exportar los nuevos schemas.

Debemos exportar el nuevo schema en el archivo `griddo.config.js|ts` que está en la raíz de del proyecto como `socials` dentro del objeto `schemas` como se muestra a continuación.

```jsx
// .........
// .........
// .........

export default {
	schemas: {
		config: {
			menus,
			themes,
			subthemes,
			languages,
			menuItems,
			moduleCategories,
			richTextConfig,
			socials, // <-----------------
		},
		...
		...
}
```

# Temas

Esquema para la definición de temas de la instancia. En Griddo, es posible generar múltiples temas que pueden ser aplicados a cada sitio o página. Para que estén disponibles en el editor y puedan ser aplicados a los diferentes sitios, se debe exportar un esquema de temas en el archivo `griddo.config.ts`.

**Archivo**

`src/schemas/config/themes.ts`

**Ejemplo**

```jsx
export const themes = [
	{
		default: true,
		label: "Crystal theme",
		value: "crystal-theme",
	},

	{
		label: "Golden theme",
		value: "golden-theme",
	},
] as const;

export const subthemes = ["light", "dark"] as const;
```

## Incluir y excluir elementos del sistema en los `Themes`

Desde la versión `10.4.33` es posible indicar desde el schema de un Theme qué elementos del sistema de diseño estarán incluidos en el mismo. Esto nos permite mejorar la experiencia de uso a la hora de introducir contenido en un site.

> Los *elementos* del sistema en este caso son **DataPacks**, **Templates** y **Modules**.
> 

## Configurar el set de `elements`

Para indicar qué elementos de la totalidad del sistema queremos en un Theme debemos indicarlo en el schema del propio Theme, el que exportamos normalmente en `src/schemas/config/theme.ts`. Añadiremos la propiedad `elements` y dentro añadiremos `exclude` o `include` (solo uno de ellos) para especificar los elementos que queremos.

```tsx
// Este Theme incluirá todo el sistema de diseño excepto "Las noticias"
const themes: Schema.Themes = [
	{
		label: "Newsless theme",
		value: "newsless-theme",
		elements: {
			exclude: {
				datapacks: ["NEWS"],
				modules: ["NewsDistributor", "HeroNews"],
				templates: ["NewsDetail", "NewsList"],
			},
		},
	},
];
```

## Preguntas y respuestas.

**¿Tengo que modificar ahora los themes para que incluyan todo?**

No tienes que modificar nada si no tienes esta necesidad de hacer un subconjunto de elementos para un theme.

**¿Qué ocurre con el BasicTemplate?**

BasicTemplate es un template obligatorio en las instancias de Griddo y no podrá ser “excluido” desde esta nueva funcionalidad. Por lo tanto podrá ser añadido en todos los sites, si bien su `whiteList` si se verá afectado por los módulos que incluyamos o excluyamos desde el Theme.

# Traducciones estáticas

Schema para añadir los valores de las traducciones estáticas que se utilizaran teniendo en cuenta los idiomas junto con [useI18n](../../Hooks/useI18n%20f51d1bf617fc4a079c0bb2134cf69dc4.md) 

**Archivo**

`src/schemas/i18/index.ts`

**Ejemplo**

```jsx
import { Schema } from "@griddo/core";

const schema: Schema.Translations = {
	en_GB: {
		skipToContent: "Skip to content",
		readMore: "Read more",
	},
	es_ES: {
		skipToContent: "Saltar al contenido",
		readMore: "Leer más",
	},
};
```

# Wysiwyg Field

Este *schema* representa una configuración opcional para la barra de herramientas de los *fields* de tipo **Wysiwyg**, con la que podemos añadir clases de CSS para aplicarlas al contenido del field y sobreescribir los idiomas que aparecen en el dropdown del botón para añadir etiquetas de idioma al texto.

**Archivo**

`src/schemas/config/rich-text.ts`

**Ejemplo**

```tsx
import { Schema } from "@griddo/core";

const schema: Schema.RichTextConfig = {
  paragraphStyles: [
    { label: "Class 1", className: "class1" },
    { label: "Class 2", className: "class2" },
  ],
	tableStyles: [
    { label: "Table class 1", className: "table-class1" },
    { label: "Table class 2", className: "table-class2" },
  ],
  tableCellStyles: [
    { label: "Table cell 1", className: "table-cell-class1" },
    { label: "Table cell 2", className: "table-cell-class2" },
  ],
  editorLangs: [
		{ name: "English", iso: "en-EN" },
		// con la prop featured, el idioma aparecerá en la parte superior del dropdown
		{ name: "Spanish", iso: "es-ES", featured: true },
		{ name: "German", iso: "de-DE" },
	],
};

export default schema;
```

Se debe exportar en `/griddo.config.ts`

```tsx
**import richTextConfig from "./src/schemas/config/rich-text";**

const schemas = {
	all: { ...frontlessComponents, ...components, ...modules },
	modules,
	templates,
	dataPacks,
	dataPacksCategories,
	structuredData: {
		...simpleContentType,
		...pageContentType,
		...categories,
	},
	languages,
	menus,
	menuItems,
  **richTextConfig // <------**
};

export { schemas, themes, moduleCategories, autotypes };
```

## Uso

Probablemente después de configurar las clases, que serán globales, las escribas en cualquier sitio dispuesto para ello en el repositorio. Posteriormente el css debe ser importado en `griddo.root.tsx` como se hace con todo el css global.

Este es un ejemplo del archivo `griddo.root.tsx` del starter donde podemos importar el CSS global.

```tsx
import { griddoDamDefaults, translations } from "@config";
import {
	SiteProvider as GriddoSiteProvider,
	SiteProviderProps as GriddoSiteProviderProps,
} from "@griddo/core";
import { Subthemes, Themes } from "@themes-setup";
import * as React from "react";

// Custom CSS
import "./src/css/custom/forms.css";
import "./src/css/custom/global.css";
import "./src/css/custom/normalize.css";
import "./src/css/custom/text-styles.css";
import "./src/css/custom/utilities.css";
**import "./src/css/custom/rich-text-classes.css"; // <-----------**

// Grisso CSS
import "./src/css/.grisso/grisso.css";

// Themes CSS
import "./src/css/.themes/global-theme.css";
import "./src/css/.themes/cunef-theme.css";
import "./src/css/.themes/second-theme.css";

interface SiteProviderProps extends GriddoSiteProviderProps {
	theme: Themes;
	subtheme: Subthemes;
}

/**
 * This component is a wrapper to the Griddo <SiteProvider>. Must be exported and used to wrap the app/web.
 * This is a great place to add contexts like theme providers etc.
 */
function SiteProvider(props: SiteProviderProps) {
	const { children, subtheme, ...rest } = props;
	const isEditor = rest.renderer === "editor" || rest.renderer === "preview";

	return (
		<GriddoSiteProvider
			griddoDamDefaults={griddoDamDefaults}
			translations={translations}
			{...rest}
		>
			<div
				id="___griddo"
				// Set the site theme
				data-theme={rest.theme}
				// Set the default subtheme
				data-subtheme={subtheme || "default"}
				// Allows scroll in the Griddo editor preview area
				style={isEditor ? { height: "100%" } : {}}
			>
				<React.Suspense fallback={null}>{children}</React.Suspense>
			</div>
		</GriddoSiteProvider>
	);
}

export { SiteProvider };
```