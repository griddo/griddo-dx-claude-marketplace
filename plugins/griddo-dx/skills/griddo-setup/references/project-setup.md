# Configuración del proyecto

## Requisitos

- Git
- Node v20.19.2
- yarn v1.22.22 (`npm` no está soportado)

## Clonar el repositorio

Idealmente, ya deberías poder tener acceso al Starter que proporciona Griddo para clonarlo en tu equipo.

Utiliza el siguiente comando que clonará el repo, borrará el historial del Starter e iniciará un nuevo repo git:

```bash
git clone --depth=1 git@github.com:griddo/griddo-starter.git
cd griddo-starter
rm -rf .git
git init
git add .
git commit -m "first commit"
cd ..
mv griddo-starter nombre-de-tu-proyecto
```

Ahora tendrás el repositorio Starter con solo un commit `first commit` listo para empezar.

## Instalación de dependencias

Después de clonar el repositorio instalaremos las dependencias utilizando `yarn`:

```bash
yarn install
```

## Configuración de idiomas

El repositorio viene configurado con dos idiomas, `es_ES` y `en_GB`. Es buena idea que lo dejes ya configurado antes de hacer el primer despliegue.

El archivo de schemas de idiomas se encuentra en `src/schemas/config/languages.ts`:

```tsx
import type { Schema } from "@griddo/core";

const schema: Schema.Languages = {
	en_GB: {
		name: "English",
		label: "EN",
	},
	es_ES: {
		name: "Spanish",
		label: "ES",
	},
};

export default schema;
```

## Variables de entorno

Finalizaremos este apartado con la configuración de las credenciales en el archivo `.env`. Utiliza el archivo `.env-example` como plantilla para crear tu `.env` definitivo.

### Variables genéricas

**`GRIDDO_API_URL`**

Dirección API de entorno/instancia

**`GRIDDO_PUBLIC_API_URL`**

Dirección API pública de entorno/instancia

**`GRIDDO_BOT_USER`**

Email de la cuenta bot (anteriormente `botEmail`)

**`GRIDDO_BOT_PASSWORD`**

Password de la cuenta bot (anteriormente `botPassword`)

**`REACT_APP_FROALA_KEY`**

Key para el plugin de Froala (redactar con valor real en `.env`)

**`developerkey`**

Developer key

### Variables para los renders

**`GRIDDO_RENDER_CONCURRENCY_COUNT`**

Indica cuántas páginas se consultan a la vez en la API en la fase de build. Este número incurrirá directamente en el número de conexiones a la base de datos.

Este número se podrá manipular en los entornos locales de desarrollo pero estará "fijo" en los despliegues.

⚠️ Si el render termina con error `*** API RESPONSE *** Code: 400 - Bad Request Response: {"code":400,"message":"ER_CON_COUNT_ERROR: Too many connections"}`, tendremos que bajar el número de `GRIDDO_RENDER_CONCURRENCY_COUNT`

**`GRIDDO_RENDER_BUILD_LOGS`**

Guarda parte de los logs de los renders en un archivo en `exports/sites/<domain-name>/logs/*`

**`GRIDDO_RENDER_SEARCH_FEATURE`**

Activa la subida de contenido de un render a la base de datos para utilizar en los servicios de buscadores.

**`GRIDDO_RENDER_DISABLE_LLMS_TXT`**

Por defecto Griddo genera un archivo `llms.txt` en el raíz de cada dominio de las páginas activadas para ello en el editor. Para desactivar esta generación, añade esta variable.

**`GRIDDO_RENDER_ENABLED_LLM_MD`**

Activa la generación de markdowns por cada página generada:

```bash
dominio.com/my-site/my-page/    # esto visita la página my-page
dominio.com/my-site/my-page.md  # esto visita el markdown de my-page
```

## Configuración griddo.config.ts

El archivo de configuración `griddo.config.ts` exporta los schemas y viene pre-configurado en el Starter:

```tsx
export default {
	// Schemas de configuración
	config: {
		menus,
		themes,
		languages,
		menuItems,
		moduleCategories, // opcional
		richTextConfig, // opcional
		subthemes, // opcional
	},
	// Schemas de components, módulos y templates
	ui: {
		components,
		modules,
		templates,
	},
	// Schemas de todo lo relacionado con ContentTypes
	contentTypes: {
		dataPacks,
		dataPacksCategories,
		structuredData: {
			...categoryContentTypes,
			...pageContentTypes,
			...simpleContentTypes,
		},
	},
	// (Opcional) Schemas de formularios
	forms: {
		templates,
		fields,
		categories, // opcional
		templateCategories, // opcional
	},
	// (Opcional) Schema de configuración de AutoTypes
	autotypes: {
		interfaceSuffix,
		contentTypeSuffix,
		publicApiSuffix,
	},
} satisfies Core.Config;
```

## Carpeta /static

Puedes hacer uso de la carpeta `/static` del repositorio para adjuntar imágenes, tipografías, CSS, etc. Estos archivos no serán procesados por Griddo, tan solo copiados al destino correspondiente para hacer uso de ellos.

**Recomendación:** Si se está usando la carpeta `/static` para estáticos de **Storybook**, se recomienda cambiarla a otra, por ejemplo `/storybook-static` y modificar los scripts de lanzamiento de Storybook:

```json
"start:storybook": "npm run prepare && start-storybook -p 4000 -s ./storybook-static"
```

Esto es para evitar meter en el proceso de build estáticos que son solo para Storybook.

## Exports principales

Estos son los puntos principales de salida de la instancia hacia el mundo exterior de Griddo: **Editor, Render y API**

### `/src/index.ts|js`

Aquí se exportan todos los elementos comunes para el **Editor** y el Render:

**TypeScript:**

```tsx
import { Core } from "@griddo/core";
import components from "@ui/components";
import formComponents from "@ui/forms/components"; // opcional
import formsTemplates from "@ui/forms/templates"; // opcional
import modules from "@ui/modules";
import templates from "@ui/templates";

import browser from "../builder.browser";
import ssr from "../builder.ssr";
import { SiteProvider } from "../griddo.root";

const generateAutomaticDimensions = (page: Core.Page) => ({})

const bundle = {
	components,
	modules,
	templates,
	formsTemplates, // opcional
	formComponents, // opcional
};

export {
	bundle,
	generateAutomaticDimensions,
	SiteProvider,
	browser,
	ssr,
};
```

**JavaScript:**

```jsx
import components from "@ui/components";
import formComponents from "@ui/forms/components"; // opcional
import formsTemplates from "@ui/forms/templates"; // opcional
import modules from "@ui/modules";
import templates from "@ui/templates";

import browser from "../builder.browser";
import ssr from "../builder.ssr";
import { SiteProvider } from "../griddo.root";

/** @param {import("@griddo/core").Core.Page} page */
const generateAutomaticDimensions = (page) => ({})

const bundle = {
	components,
	modules,
	templates,
	formsTemplates, // opcional
	formComponents, // opcional
};

export {
	bundle,
	generateAutomaticDimensions,
	SiteProvider,
	browser,
	ssr,
};
```

### `/griddo.config.ts`

Aquí se exportan los schemas. Probablemente no edites nunca este archivo salvo que sea requerido por alguna nueva versión de Griddo.

### `/griddo.root.tsx`

Punto principal de render donde se exporta el `<SiteProvider>` de Griddo con toda la información de CSS y los themes. Probablemente **sí edites** este archivo.

## Lanzar servicios de Griddo

### Editor

El editor de Griddo se lanza con `griddo start`. Normalmente lo añadiremos al `package.json`:

```json
{
	"scripts": {
		"start:editor": "npx env-cmd -f .env griddo start"
	}
}
```

O directamente desde terminal:

```bash
./node_modules/.bin/griddo start
```

### Renders en local

Los renders son procesos que incluyen preparación, comienzo, generación de estáticos, subida, información de fin de render, etc. Para renders locales, usa el CLI que ofrece el paquete `@griddo/cx`:

```bash
# ayuda
node --env-file=".env" ./node_modules/.bin/griddo-render --help

# lanza un render de todos los dominios
node --env-file=".env" ./node_modules/.bin/griddo-render render --root="."
```

O desde `package.json`:

```json
{
	"render": "env-cmd griddo-render render --root=.",
	"render": "node --env-file=.env ./node_modules/.bin/griddo-render render --root=."
}
```

### Sincronizar schemas

```bash
npm run sync-schemas
```

Actualiza los schemas en la API.

### AutoTypes

```bash
npm run autotypes
```

Genera Types de TypeScript automáticamente desde tus schemas en `autotypes.d.ts`

## SSR, Browser y Config APIs

Desde la instancia se puede acceder a las APIs de Gatsby: **browser**, **ssr** y **config**. Utilizarás los archivos `builder.ssr.js`, `builder.browser.js` y `builder.config.js` en el directorio raíz.

### Exports

Los archivos `builder.ssr.js` y `builder.browser.js` necesitan ser exportados en `src/index.js`. `builder.config.js` será leído directamente por Griddo:

```jsx
// src/index.js
import ssr from "../builder.ssr"
import browser from "../builder.browser"

export {
  ssr,
  browser
}
```

### SSR API - builder.ssr.js

Podrás establecer componentes de HTML en el `<head>` y `<body>` de manera global, es decir, en todas las páginas de todos los sites. El uso típico será añadir scripts como cookies, trackers, etc., ya sea desde CDN, inline, CSS, etc.

**Ejemplo:**

```jsx
import * as React from "react"

const cookieScript = (
  <script defer src="https://code.cookies.com/cookies-1.0.0.min.js" />
)

const cookieStyles = (
  <link rel="stylesheet" href="https://code.cookies.com/cookies-1.0.0.min.css" />
)

const bodyAttributes = { id: "a-griddo-site" }
const headComponents = [cookieScript, cookieStyles]

const onRenderBody = ({ setHeadComponents, setBodyAttributes }) => {
  setBodyAttributes(bodyAttributes)
  setHeadComponents(headComponents)
}

export default {
  onRenderBody
}
```

**Comportamiento en el editor:**

`onRenderBody` se ejecuta tanto en la generación de páginas como en el editor. Para discriminar, `onRenderBody` recibe el parámetro `pathname` que en el editor siempre será `ax-editor`:

```jsx
function onRenderBody({ setHeadComponents, setBodyAttributes, pathname }) {
  const headComponents =
    pathname === 'ax-editor'
      ? [globalCSS, reset, normalize]
      : [cookies, globalCSS, reset, normalize]

  setBodyAttributes({ id: 'griddo-starter-site' })
  setHeadComponents(headComponents)
}
```

### Browser API - builder.browser.js

Tenemos acceso a multitud de eventos cuando Gatsby está ejecutándose en el navegador, como `onRouteUpdate` para cuando el usuario cambia de página mediante el router:

```jsx
const onRouteUpdate = (props) => {
  console.log(props)
}

export default {
  onRouteUpdate,
}
```

Documentación completa en [Gatsby browser API](https://www.gatsbyjs.com/docs/reference/config-files/gatsby-browser/)

### Config API - builder.config.js

Establece la configuración de los plugins de Gatsby que vienen con Griddo. Este archivo debe estar escrito en **CommonJS**:

```jsx
const plugins = [
  "gatsby-plugin-styled-components",
  {
    resolve: `gatsby-plugin-polyfill-io`,
    options: {
      features: [
        "IntersectionObserver",
      ],
    },
  },
]

module.exports = {
  plugins,
}
```

Documentación completa en [Gatsby config](https://www.gatsbyjs.com/docs/reference/config-files/gatsby-config/)

## ESLint + Prettier

El starter de Griddo viene con una configuración de ESLint y Prettier.

### ESLint

Para más información consultar el archivo `eslint.config.js`. Está enfocado a TypeScript, con prevención de bugs, buenas prácticas, accesibilidad y estilo de código.

### Prettier

En Prettier se han dejado todas las settings por defecto, excepto el indentado que se ha establecido a "tabs":

```json
{
	"useTabs": true
}
```

## Dimensions API

El archivo `src/schemas/config/dimensions.ts` permite definir dimensiones automáticas que se aplican a todos los componentes, módulos y templates.

Consulta la documentación de [Dimensions API](../../../Bloques%20constructivos/Schemas%20de%20formularios) para más detalles.
