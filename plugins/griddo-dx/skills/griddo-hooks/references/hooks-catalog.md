# usScript

Carga dinámicamente un script externo. Esto puede ser útil para integrar un script de terceros.

## Uso básico

```tsx
type UseScriptProps = {
	src: string | null,
	options?: {
		shouldPreventLoad?: boolean;
		removeOnUnmount?: boolean;
	}
}

type ReturnValue = "idle" | "loading" | "ready" | "error"
```

---

# useAIAnswers

Realiza una búsqueda sobre todos los contenidos publicados de Griddo para obtener una respuesta conversacional. No es realmente una conversación, a día de hoy solo permite hacer una pregunta y tener una respuesta. No se puede conversar, sino en todo caso hacer nuevas preguntas. La respuesta la facilitará en *markdown*.

## Uso básico

```tsx
import { useAIAnswers } from "@griddo/core";

function Module() {
	const [{ query }, setQuery] = useAiAnswers();

	React.useEffect(() => {
		setQuery({
			query: "lorem ipsum dolor sit amet",
			templates: ["BasicTemplate", "NewsDetail"]		
		});
	}, []);

  return (
    <>
	    {query?.response}
    </>
  )
}
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| format | string | Es el formato de respuesta esperado. Por defecto es lite que es una respuesta breve y concisa. Para ... |
| lang | number | Es el id del idioma en el que se hará la búsqueda. Si no se proporciona se utilizará el de la página... |
| minSimilarity | number | Similarity mínima para obtener resultados. Por defecto es 0.3. |
| priorities | object | Es un objeto en el que vamos a asignar modificadores de prioridad a cada template. Cada resultado va... |
| query | string | Es la búsqueda que se quiere realizar. |
| site | number | Es el site sobre el que haremos la búsqueda. Si no lo indicamos, se hará la búsqueda sobre todo el e... |
| templates | array <string> | Es un array con la lista de templates que queremos tener en los resultados. Si no decimos nada, se a... |
| isError | boolean | Indica si ha habido un error en la llamada al endpoint de la API. |
| isLoading | boolean | Indica que la query está en proceso. |
| msg | object | Un objeto con un mensaje de la API en caso de haber un problema, normalmente cuando el código no es ... |
| query | string | Objeto con la respuesta de la API, según los parámetros pasados en la llamada a la función. |

### priorities

**Tipo:** object

Es un objeto en el que vamos a asignar modificadores de prioridad a cada template. Cada resultado va a tener asociado una similarity que es una puntuación de -1 a 1 de como cuánto de acertado es el resultado. De esta manera, podemos hacer que los resultados prioricen cierto tipo de contenido, pero sin reordenarlos artificialmente, es decir, que podemos dar prioridad a programas pero no van a salir todos los resultados de programas por delante de cualquier otro resultado si la diferencia de similarity es muy grande.

### site

**Tipo:** number

Es el site sobre el que haremos la búsqueda. Si no lo indicamos, se hará la búsqueda sobre todo el entorno priorizando siempre las páginas canonical en caso de contenidos duplicados.

---

# useAIReferenceField

Obtiene el contenido desde un `AIReferenceField`

## Uso básico

```tsx

function Module(props) {

	const { aiData } = props
	
	const custom = {
		...aiData,
		useStructuredData: true, // opcional
		fields: ["image"], // opcional
		area: "AreaName"// opcional
	}

	const result = useAIReferenceField(custom);

	// ...
}

```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| area | string | El nombre de un área previamente definida y en la que se han guardado datos con useSendGpxInterests |
| fields | array<string> | Si useStructuredData = true podemos especificar los campos de los datos que devolverá el hook. |
| limit | number | Establece la cantidad de resultados que desea mostrar. |
| prompt | string | Especifica indicaciones en lenguaje natural para matizar el contenido que desea mostrar. La IA utili... |
| sites | array<number> | Array de sites para la búsqueda. De manera predeterminada, la búsqueda se limita al sitio actual. |
| templates | array<string> | Selecciona uno o varios tipos de contenido para incluir en la búsqueda. |
| useStructuredData / useContentTypes | boolean | Si es true tendrá en cuenta ContentTypes |

### prompt

**Tipo:** string

Especifica indicaciones en lenguaje natural para matizar el contenido que desea mostrar. La IA utilizará esta información como guía, pero los resultados pueden variar.

---

# useAISearch

Realiza una búsqueda sobre todos los contenidos publicados de Griddo permitiendo aplicar filtros y modificadores en las respuestas.

## Uso básico

```tsx
import { useAISearch } from "@griddo/core";

function Module() {
	const [{ query }, setQuery] = useAiSearch();

	React.useEffect(() => {
		setQuery({
			query: "lorem ipsum dolor sit amet",
			templates: ["BasicTemplate", "NewsDetail"],
			priorities: {
				NewsDetail: 0.1,
			},			
		});
	}, []);

  return (
    <ul>
      {query.items.map((item) => (
        <li key={item}>
		      <h2>{item.title}</h2>
		      <p>{item.description}</p>
			    <img src={item.image} />
        </li>
      ))}
    </ul>
  )
}
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| fields | array <string> | Si useStructuredData es true, podemos filtrar que campos exactamente de los datos estructurados quer... |
| lang | number | Es el id del idioma en el que se hará la búsqueda. Si no se proporciona se utilizará el de la página... |
| minSimilarity | number | Similarity mínima para obtener resultados. Por defecto es 0.3. |
| priorities | object | Es un objeto en el que vamos a asignar modificadores de prioridad a cada template. Cada resultado va... |
| query | string | Es la búsqueda que se quiere realizar. |
| site | number | Es el site sobre el que haremos la búsqueda. Si no lo indicamos, se hará la búsqueda sobre todo el e... |
| templates | array <string> | Es un array con la lista de templates que queremos tener en los resultados. Si no decimos nada, se a... |
| useStructuredData | boolean | Si es true la respuesta incluye los datos estructurados de la página (si esta los tiene) en la propi... |
| isError | boolean | Indica si ha habido un error en la llamada al endpoint de la API. |
| isLoading | boolean | Indica que la query está en proceso. |
| msg | object | Un objeto con un mensaje de la API en caso de haber un problema, normalmente cuando el código no es ... |
| query | string | Objeto con la respuesta de la API, según los parámetros pasados en la llamada a la función. |

### fields

**Tipo:** array <string>

Si useStructuredData es true, podemos filtrar que campos exactamente de los datos estructurados queremos recibir en la respuesta. Por ejemplo, el dato estructurado puede tener un montón de campos, pero a lo mejor solo queremos recibir las categorías para mostrar unas píldoras.

### priorities

**Tipo:** object

Es un objeto en el que vamos a asignar modificadores de prioridad a cada template. Cada resultado va a tener asociado una similarity que es una puntuación de 0 a 1 de como cuánto de acertado es el resultado. De esta manera, podemos hacer que los resultados prioricen cierto tipo de contenido, pero sin reordenarlos artificialmente, es decir, que podemos dar prioridad a programas pero no van a salir todos los resultados de programas por delante de cualquier otro resultado si la diferencia de similarity es muy grande.

### site

**Tipo:** number

Es el site sobre el que haremos la búsqueda. Si no lo indicamos, se hará la búsqueda sobre todo el entorno priorizando siempre las páginas canonical en caso de contenidos duplicados.

### useStructuredData

**Tipo:** boolean

Si es true la respuesta incluye los datos estructurados de la página (si esta los tiene) en la propiedad structuredData de cada item de resultado de búsqueda.

---

# useContentTypeNavigation

Obtiene los elementos anteriores y siguientes del `ContentType` de un template de tipo `Detail` o de cualquier `id` de ContentType que le pasemos. Si estamos en la página TeacherDetail de un profesor, el hook devolverá el profesor anterior y siguiente según los criterios de ordenación.

## Uso básico

```tsx
import { useContentTypeNavigation } from "@griddo/core"
import { ModuleProps } from '...'
import { NEWSContentTypeProps } from '...'

function Module (props: ModuleProps) {
	// cx
	const { queriedData, data } = props
	// ax
	const navData = useContentTypeNavigation<TEACHERContentTypeProps>(data)
	// cx || ax
  const { previous, next } = queriedItems || navData

	// render
	return (
    <ul>
			<li>{previous.content.title}</li>
		  <li>Current Data</li>
			<li>{next.content.title}</li>
    </ul>
  )
}
```

---

# useContentType

Devuelve un array de items de un ContentType tanto en el editor como en el proceso de build.

## Uso básico

```tsx
useContentType () => Fields.QueriedData<ContentType> | undefined
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| data | Fields.ReferenceField<ContentType> | La prop del ReferenceField, normalmente data |
| queriedData | Fields.QueriedData<ContentType> | La prop del queriedData, normalmente queriedData |

---

# useDataFilters

Devuelve un objeto con información de los filtros para usar con un dato estructurado.

## Uso básico

```jsx
import * as React from 'react'
import { useList } from "@griddo/core"
import { ContentTypePropsType } from "@autoTypes"

function Module(props) {
	const { data } = props

	const [{ query, isLoading, isError, msg }, setQuery] =
		useDataFilters<ContentTypePropsType>();

  React.useEffect(() => {
  	setQuery({ data });
	}, [])

	if (isError) {
	  return <div>error</div>
	}

	if (isLoading) {
	  return <div>loading ...</div>
	}

  return (
   ...
  )

}
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| isError | boolean | Booleano que indica si la query ha fallado |
| isLoading | boolean | Boolean que indica que la query está en proceso |
| msg | object | Un mensaje de la API si ha habido un error |
| query | array <object> | Los datos obtenidos de la query a la API |
| setQuery | function | Función donde pasamos los parámetros de la query y que cambia el estado: query, isLoading y isError |
| apiUrl | string | Una dirección de api pública de Griddo. El hook la obtiene automáticamente del contexto. |
| cached | any | Un valor que hace que se guarde ese resultado. Si se consulta de nuevo el resultado con ese mismo va... |
| data | object | Lo que devuelta el reference field |
| lang | number | El id del idioma. El hook lo obtiene automáticamente del contexto de la página. Si se indica el valo... |
| order | string | Filtrar por title-asc, title-desc, date-asc, date-desc o cualquier field marcado como indexable. |
| site | number | El id del site desde donde queremos obtener el listado del dato estructurado. El hook lo obtiene aut... |

### lang

**Tipo:** number

El id del idioma. El hook lo obtiene automáticamente del contexto de la página. Si se indica el valor 0 devolverá el resultado para todos los idiomas disponibles.

---

# useFetch

Obtiene datos dede un endpoint público.

---

# useFormValues

Obtiene fácilmente valores de un formulario `<form>`. Muy útil para usarlo junto a `useDataFilters` en los filtros de listados.

## Uso básico

```tsx
const formRef = React.useRef(null)
const [inputValues, updateInputValues] = useFormValues({ formRef })
//     ^ estado     ^ función
```

---

# useGriddoImageExp

Genera un set de urls procesadas con srcSet, sizes, etc. incluyendo los distintos formatos soportados.

## Uso básico

```jsx
import { useGriddoImageExp } from '@griddo/core'

const { src, webp: { srcSet } } = useGriddoImage({
  url: 'https://images.dev.griddo.io/starter',
})

<img src={src} srcSet={srcSet} sizes="100vw" />
```

---

# useGriddoImage

Genera un set de urls procesadas con srcSet, sizes, etc. incluyendo los distintos formatos soportados.

## Uso básico

```jsx
import { useGriddoImage } from '@griddo/core'

const { sizes, webp: { srcSet } } = useGriddoImage({
  url: 'https://images.dev.griddo.io/starter',
  responsive: [
    { breakpoint: null, width: '100px', height: '50px' },
    { breakpoint: '400px', width: '400px', height: '200px' }
  ]
})

<img srcSet={srcSet} sizes={sizes} />
```

---

# useI18n

Obtiene traducciones estáticas del proveedor de traducciones.

## Uso básico

```jsx
const { getNestedTranslation: t } = useI18n()

<p>{t("module.basicContent.accept")}</p>
```

---

# useIsClient

Este React Hook puede ser útil en un entorno SSR para esperar hasta estar en un navegador para ejecutar algunas funciones.

## Uso básico

```tsx
type ReturnType = boolean
```

---

# useIsFirstRender

Devuelve `true` la primera vez que se renderiza un componente, `false` las demás veces.

## Uso básico

```tsx
type ReturnType = boolean
```

---

# useListWithDefaultStaticPage (WIP)

Obtiene un listado de un Content Type desde la API pública con posibilidad de renderizar de forma estática una página.

## Uso básico

```tsx
import { POSTContentTypeProps } from "@autoTypes";
import { useListWithDefaultStaticPage } from "@griddo/core";
import * as React from "react";

type ListTemplateProps = AutoTypes.ListTemplateProps

const ListTemplate = (props: ListTemplateProps) => {
	const { data, queriedData } = props;

  // Llamamos al hook con un patrón parecido al de useState:
	// Retorna un array con el estado y la función para modificarlo y como
	// argumento del propio hook le podemos pasar un estado por defecto, en
	// nuestro caso parámetros por defecto para la función setQuery.
	const [{ query }, setQuery] =
		useListWithDefaultStaticPage<POSTContentTypeProps>({
			queriedData,
			page: 1,
			items: 10,
		});

	React.useEffect(() => {
		setQuery({
			data,
			page: 1,
			items: 10,
		});
	}, []);

	return (
		<main role="main">
			<h1>Query</h1>
			<pre>{JSON.stringify(query, null, 2)}</pre>
		</main>
	);
};

export default ListTemplate;
```

---

# useList

Hace una petición a la API pública uno o varios *ContentTypes* y devuelve un listado de ellos.

## Uso básico

```tsx
const [{ query, isLoading, isError, msg }, *setQuery*] = useList()
//     ^ estado                            ^ función anónima llamada aquí setQuery por convención
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| apiUrl | string | Una dirección de api pública de Griddo. El hook la obtiene automáticamente del contexto. |
| data | object | Lo que devuelta el reference field |
| fields | Array<string> | Un array de nombres de campos que queremos recibir en la respuesta |
| filterIds | Array<number>, array<{id label source}> | Un array de ids: |
| includePendings | boolean |  |
| items | number | Los elementos por página del listado |
| lang | number | El id del idioma de la página. El hook lo obtiene automáticamente del contexto. |
| order | string | Modo de ordenación |
| page | number | La página (de la paginación) que queremos obtener |
| relations | "full", "off", "simple", boolean | Indica si queremos obtener un listado con todas las opciones disponibles de relaciones, para por eje... |
| search | string | Cadena de texto para la búsqueda en la query. |
| site | number | El id del site desde donde queremos obtener el listado del dato estructurado. El hook lo obtiene aut... |

### relations

**Tipo:** "full", "off", "simple", boolean

Indica si queremos obtener un listado con todas las opciones disponibles de relaciones, para por ejemplo hacer filtros de búsqueda. Los valores pueden ser tres, off, simple o full

### site

**Tipo:** number

El id del site desde donde queremos obtener el listado del dato estructurado. El hook lo obtiene automáticamente del contexto. Si el dato es global site puede ser undefined para obtenerlo directamente sin utilizar los que estén como canonical en un site cuando sean datos de tipo página.

---

# useLocaleDate

Formatea la fecha proveniente de un `DateField` de acuerdo al idioma de la página, utilizando el `Locale` (es-ES, en-US, etc.) especificado en el schema de [Idiomas](path-to-doc)  Podemos ajustar el formato mediante el parámetro `options`, basado en [Intl.DateTimeFormatOptions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/DateTimeFormat).

## Uso básico

```tsx
function Card({ dateFromField }: CardProps) {
	const { date, datetime } = useLocaleDate(
		dateFromField,
		{ dateFormat: "long" }
	)
	
	return (
		<time datetime={datetime}>
			{date}
		</time>
	)
}
```

---

# usePageRelatedContent

Devuelve contenido relacionado de una página utilizando la IA.

## Uso básico

```jsx
import * as React from 'react'
import { useList } from "@griddo/core"

function Module() {

  const [{ query, isLoading, isError, msg }, *setQuery*] = usePageRelatedContent()
  //     ^ estado                            ^ función anónima llamada aquí setQuery por convención
  
  React.useEffect(() => {
  	setQuery();
	}, [])

  return (
    <ul>
      {query.items.map(({ title, description, image})) => (
        <li key={data}>
          <h1>{title}</h1>
          <p>{description}</p>
          <img src={image} />
        </li>
      ))}
    </ul>
  )

}
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| fields | Array<string> | Un array de nombres de campos que queremos recibir en la respuesta |
| quantity | number | La cantidad de resultados. El máximo es 20. |
| template |  | La template para la que queremos obtener resultados, por ejemplo EventDetail o ProgramDetail. Si no ... |
| useStructuredData | boolean | Indica si queremos obtener los datos estructurados asociados a cada resultado en caso de tenerlos. |
| isError | boolean | Si es tue indica si ha habido un error en la llamada al endpoint de la API. |
| isLoading | boolean | Si es true indica que la query está en proceso. |
| msg |  | Un objeto con un mensaje de la API en caso de haber un problema. |
| query | string | Objeto con la respuesta de la API, según los parámetros pasados en la llamada a la función. |

### template

**Tipo:** 

La template para la que queremos obtener resultados, por ejemplo EventDetail o ProgramDetail. Si no decimos nada, se interpretará la misma template de la página actual.

---

# usePage

Devuelve valores del contexto de la página, por ejemplo

## Uso básico

```jsx
 const { title, breadcrumb } = usePage()
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| ISOLocale |  | Un código locale para el idioma en formato ISO, por ejemplo es-ES |
| componentList | array | Lista de módulos y componentes que existen en la página |
| dimensions |  | Objeto con las dimensiones manuales y automáticas de la página. |
| follow | boolean | Devuelve true si la página está marcada como follow y false si está como no-follow. |
| footerTheme |  | Theme asignado para el Footer mediante las opciones de configuración |
| headerTheme |  | Theme asignado para el Header mediante las opciones de configuración |
| isHome | boolean | Devuelve true si la página está establecida como página home |
| locale |  | Un código locale para el idioma, por ejemplo es_ES |
| metaKeywords | Record<string Array<string>> | Array de las keywords de la página |
| modified | string | Fecha de modificación de la página en formato ISO |
| published | string | Fecha de publicación de la página en format ISO |
| sectionModules | Record<string Array<string>> | Un objeto con la lista de módulos de la página por cada sección. |
| sectionModules | object | Un objeto que representa las secciones de la página y contiene un array con los nombres de los módul... |
| structuredDataContent | object | Objeto con el dato estructurado de la página si es un template de dato estructurado de página |
| theme |  | Theme asignado para la página mediante las opciones de configuración |

---

# useReceiveInterests

Obtiene intereses desde la API que han sido guardados con [useSendInterests](path-to-doc)

## Uso básico

```tsx
const [{ query, isLoading, isError, msg }, *setQuery*] = useReceiveInterests()
//     ^ estado                            ^ función anónima llamada aquí setQuery por convención
```

---

# useReferenceField

Obtiene el contenido de un dato desde un `ReferenceField`

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| allLanguages | boolean |  |
| fixed | array<number> |  |
| fullRelations | boolean |  |
| lang | number | Por defecto el idioma “actual” aunque se puede especificar uno en concreto. El uso habitual será des... |
| mode | string | auto, manual o navigation |
| order | string | Modo de ordenación |
| page | number | La página (de la paginación) que queremos obtener |
| preferenceLanguage | boolean | Los resultados se ordenarán de tal manera que primero aparecerán los items en el idioma de la página... |
| quantity | number | 0 significa todos |
| referenceID | number |  |
| site | number | Por defecto el site “actual” aunque se puede especificar uno en concreto. El uso habitual será desde... |
| source | array<content-type> |  |

---

# useSendInterests

Envía intereses a la API para ser guardados y posteriormente consultados mediante [useReceiveInterests](path-to-doc)

## Uso básico

```tsx
const [{ isLoading, isError, msg }, *setQuery*] = useSendInterests()
//     ^ estado                     ^ función anónima llamada aquí setQuery por convención
```

---

# useSession

Permite acceder (leer y escribir) al estado global del site. Este contexto de sesión es especialmente útil en CX, ya que persiste incluso al navegar entre páginas.

## Uso básico

```tsx
setState({ hideNavigationBanner: true })

// read the state
const stateValue = state.hideNavigationBanner
```

---

# useSite

Devuelve valores del contexto del `site`

## Uso básico

```tsx
export interface Site {
	linkComponent: (props: GriddoLinkProps & { to?: string }) => JSX.Element;
	location?: { state: Record<string, unknown> };
	apiUrl?: string;
	bigAvatar?: string | null;
	cloudinaryCloudName?: string;
	cloudinaryDefaults?: CloudinaryDefaults;
	defaultLanguage?: SiteLanguage;
	domain?: number;
	favicon?: string | null;
	griddoDamDefaults?: GriddoDamDefaults;
	modified?: string;
	name?: string;
	path?: string;
	publicApiUrl?: string;
	home?: string;
	isPublished?: boolean;
	renderer?: Renderers;
	siteId?: number;
	siteLangs?: Array<{
		id: number;
		locale: Locale;
		language: number;
		path: string;
		label: string;
		isDefault: boolean;
		home: string;
		domain: { id: number; url: string; slug: string };
	}>;
	// TODO: Investigar estructura de siteMetadata
	siteMetadata?: {
		title: string;
	};
	smallAvatar?: string | null;
	slug?: string;
	socials?: Record<string, string>;
	theme?: string;
	thumbnail?: string;
	timezone?: TimeZone;
	translations?: LocaleTranslations;
}
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| apiUrl | string | La url de la API privada |
| publicApiUrl | string | La url de la API pública |
| renderer |  | Devuelve gatsby , editor o preview según donde se esté visualizando el componente. |
| siteId | number | El id del site. Será undefined cuando la página que se estré mostrando sea una página global |

---

# useSSR

Permite saber si el componente se está montando en el proceso de build o en el navegador.

## Uso básico

```tsx
type ReturnType = {
    isBrowser: false | HTMLElement;
    isServer: boolean;
}
```

---

# useUA (User Agent)

Obtiene información del usuario que está visitando la página: navegador, sistema operativo, idioma, dispositivo, etc.

## Uso básico

```tsx
import { **useUA** } from "@griddo/core";

function Module() {
	const	{ device }  = useUA()
	
  return <div>{JSON.stringify(device)}</div>
}
```

## Parámetros / Métodos

| Nombre | Tipo | Descripción |
|---|---|---|
| browser | object | Objeto con el nombre, la versión y el idioma del navegador: { name: string, version: string, languag... |
| country | string | Cadena que con formato ISOxxx con el idioma: en_US , etc.. |
| cpu | object | Objeto con la información de la CPU: { architecture: string } |
| device | object | Objeto con la información del dispositivo{ model: string, type: string, vendor: string} |
| engine | object | Objeto con el nombre y la versión del engine: { name: string, version: string } |
| os | object | Objeto con el nombre y la versión del sistema operativo: { name: string, version: string } |
| ua | string | Cadena que representa el useragent , por ejemplo: Mozilla/5.0 (iPhone; U; CPU iPhone OS 5_1_1 like M... |
| userIP | string | IP pública del usuario |

### ua

**Tipo:** string

Cadena que representa el useragent , por ejemplo: Mozilla/5.0 (iPhone; U; CPU iPhone OS 5_1_1 like Mac OS X; en) AppleWebKit/534.46.0 (KHTML, like Gecko) CriOS/19.0.1084.60 Mobile/9B206 Safari/7534.48.3`