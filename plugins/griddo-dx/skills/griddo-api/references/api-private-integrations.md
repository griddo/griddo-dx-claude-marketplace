# AI Search

Para entender todos los detalles de AI Search, consulta la [**guía técnica**](../../../Gu%C3%ADas y tutoriales/AI Search 7b4661a3120f469aab6363a610bcb430.md).

## `POST` /ai/search

**Requiere la variable de entorno `GRIDDO_AI_SEARCH="on"` en API Privada.**

Realiza una búsqueda sobre todos los contenidos de Griddo (solo las páginas publicadas) permitiendo aplicar filtros y modificadores en las respuestas, obteniendo una respuesta en formato json. Toda la configuración de la búsqueda se envía en el body.

Ejemplo de body:

```jsx
{
    "query": "másteres filosofía",
    "lang": 2,
    "site": 7,
    "templates": [
        "NewsDetail",
        "ProgramDetail"
    ],
    "priorities": {
        "ProgramDetail": 0.2,
        "NewsDetail": -0.1
    },
    "minSimilarity": 0.6,
    "page": 1,
    "itemsPerPage": 10,
    "useStructuredData": true,
    "fields": ["title","categories"]
}
```javascript

Explicación:

- `query`: OBLIGATORIO. Es la búsqueda que se quiere realizar.
- `lang`: OBLIGATORIO. Es el id del idioma en el que se hará la búsqueda.
- `site`: Opcional. Es el site sobre el que haremos la búsqueda. Si no indicamos site, se hará la búsqueda sobre todo el entorno priorizando siempre las páginas canonical en caso de contenidos duplicados.
- `templates`: Opcional. Es un array con la lista de templates que queremos tener en los resultados. Si no decimos nada, se aplicará la búsqueda a todos los resultados. Tiene que ser un array o no indicarse.
- `priorities`: Opcional. Es un objeto en el que vamos a asignar modificadores de prioridad a cada content type. Cada resultado va a tener asociado una “similarity” que es una puntuación de como cuánto de acertado es el resultado, y es un número del 0 al 1 (con muchos decimales). En este ejemplo, estamos dándole dos décimas más de prioridad (que es bastante) a los resultados de programas, y quitándole una décima de prioridad a los resultados de noticias. De esta manera, podemos hacer que los resultados prioricen cierto tipo de contenido, pero sin reordenarlos artificialmente, es decir, que podemos dar prioridad a programas pero no van a salir todos los resultados de programas por delante de cualquier otro resultado si la diferencia de similarity es muy grande.
- `minSimilarity`: Opcional. Similarity mínima para obtener resultados. En este ejemplo no obtendríamos ningún resultado de similarity inferior a 0.6 (que es un valor alto). Por defecto es 0.3.
- `useStructuredData`: Opcional. Indica si queremos que nos devuelva además los datos estructurados de la página si es que esta página tiene datos estructurados. Por defecto es false. Si la activamos, siempre recibiremos un objeto en la propiedad structuredData de cada página de resultado de búsqueda, aunque sea un objeto vacío.
- `fields`: Opcional. Indica los campos del dato estructurado que quieres recibir, descartando los demás y por tanto haciendo que la respuesta sea más ligera.

Ejemplo de respuesta:

```jsx
{
    "page": 1,
    "itemsPerPage": 10,
    "totalItems": 48,
    "items": [
        {
            "title": "Máster Universitario en Filosofía: Condición Humana y Trascendencia",
            "url": "https://www.comillas.edu/postgrados/master-universitario-en-filosofia-condicion-humana-y-trascendencia/",
            "image": null,
            "description": "Aborda lo humano de un modo radical, con sus luces y sus sombras",
            "template": "ProgramDetail",
            "similarity": 0.7715391586271207
        },
        {
            "title": "Grado en Filosofía",
            "url": "https://www.comillas.edu/grados/grado-en-filosofia/",
            "image": null,
            "description": "El Grado en Filosofía ofrece una formación sólida que estructura el pensamiento y dota de competencias para el análisis crítico de la realidad y para el desarrollo integral de las personas.",
            "template": "ProgramDetail",
            "similarity": 0.7411845667632244
        },
        {
            "title": "Máster Universitario en Psicopedagogía",
            "url": "https://www.comillas.edu/postgrados/master-universitario-en-psicopedagogia/",
            "image": null,
            "description": "La nueva realidad educativa y social necesita profesionales de la orientación educativa y psicopedagógica con formación especializada y competencias personales que les permitan convertirse en agentes de cambio educativo y transformación social, capaces de",
            "template": "ProgramDetail",
            "similarity": 0.7109278307997611
        },
        {
            "title": "Grado en Filosofía, Política y Economía",
            "url": "https://www.comillas.edu/grados/grado-en-filosofia-politica-y-economia-interuniversitario-deusto-comillas-y-la-salle/",
            "image": null,
            "description": "El Grado en Filosofía, Política y Economía ofrece una formación básica en las tres disciplinas e incluye aproximaciones de contenidos complementarios del ámbito del Derecho, la Sociología y las Relaciones Internacionales.",
            "template": "ProgramDetail",
            "similarity": 0.7044502277989309
        },
        {
            "title": "Doble Grado en Filosofía y Filosofía, Política y Economía. Interuniversitario Comillas, Deusto y La Salle",
            "url": "https://www.comillas.edu/grados/doble-grado-en-filosofia-y-filosofia-politica-y-economia-interuniversitario-comillas-deusto-y-la-salle/",
            "image": null,
            "description": "La combinación de ambos grados permite desarrollar una perspectiva multidisciplinar",
            "template": "ProgramDetail",
            "similarity": 0.6974243953407852
        },
        {
            "title": "El amor a la verdad o la filosofía en la vida diaria",
            "url": "https://www.comillas.edu/noticias/el-amor-a-la-verdad-o-la-filosofia-en-la-vida-diaria/",
            "image": null,
            "description": "",
            "template": "NewsDetail",
            "similarity": 0.6844701969709641
        },
        {
            "title": "Máster Universitario en Profesor de Educación Secundaria Obligatoria y Bachillerato",
            "url": "https://www.comillas.edu/postgrados/master-universitario-en-profesor-de-educacion-secundaria-obligatoria-y-bachillerato1/",
            "image": null,
            "description": "Habilita para trabajar como profesor de ESO, bachillerato y formación profesional",
            "template": "ProgramDetail",
            "similarity": 0.6820007068324825
        },
        {
            "title": "Máster Universitario en Profesor de Educación Secundaria Obligatoria y Bachillerato + Máster Universitario en Psicopedagogía",
            "url": "https://www.comillas.edu/postgrados/master-universitario-en-profesor-de-educacion-secundaria-obligatoria-y-bachillerato-master-universitario-en-psicopedagogia/",
            "image": null,
            "description": "Este programa combinado busca la sinergia entre dos procesos formativos altamente convergentes",
            "template": "ProgramDetail",
            "similarity": 0.6790269981984693
        },
        {
            "title": "Bachiller Eclesiástico en Filosofía",
            "url": "https://www.comillas.edu/grados/bachiller-eclesiastico-en-filosofia/",
            "image": null,
            "description": "Los estudios de Filosofía han despertado en los últimos años un interés creciente como formación sólida que estructura el pensamiento y dota de competencias para el análisis crítico de la realidad y para el desarrollo integral de las personas.",
            "template": "ProgramDetail",
            "similarity": 0.662625311969238
        },
        {
            "title": "Bachiller en Teología a distancia (Grado en Teología)",
            "url": "https://www.comillas.edu/grados/grado-bachiller-en-teologia-a-distancia/",
            "image": null,
            "description": "El Bachiller en Teología posee la capacidad y orientación suficiente en las principales áreas de la Teología, para poder continuar de manera satisfactoria materias especializadas de nivel superior inmediato.",
            "template": "ProgramDetail",
            "similarity": 0.6587271838052586
        }
    ]
}
```javascript

## `POST` /ai/answers

**Requiere la variable de entorno GRIDDO_AI_ANSWERS=”on” en API Privada.**

Realiza una búsqueda sobre todos los contenidos de Griddo (solo las páginas publicadas) para obtener una respuesta conversacional. No es realmente una conversación, a día de hoy solo permite hacer una pregunta y tener una respuesta. No se puede conversar, sino en todo caso hacer nuevas preguntas. La respuesta la facilitará en markdown. Toda la configuración de la búsqueda se envía en el body.

Ejemplo de body:

```jsx
{
    "query": "qué tal son los cursos de filosofía",
    "lang": 2,
    "templates": [
        "NewsDetail",
        "ProgramDetail"
    ],
    "format": "lite",
    "priorities": {
        "ProgramDetail": 0.2,
        "NewsDetail": -0.1
    },
    "minSimilarity": 0.6,
}
```javascript

Explicación:

- `query`: OBLIGATORIO. Es la búsqueda que se quiere realizar.
- `lang`: OBLIGATORIO. Es el id del idioma en el que se hará la búsqueda.
- `site`: Opcional. Es el site sobre el que haremos la búsqueda. Si no indicamos site, se hará la búsqueda sobre todo el entorno priorizando siempre las páginas canonical en caso de contenidos duplicados.
- `format`: Opcional. Es el formato de respuesta esperado. Por defecto es “lite” que es una respuesta breve y concisa. Para respuestas más largas, podemos usar “extended”.
- `templates`: Opcional. Es un array con la lista de templates que queremos tener en los resultados. Si no decimos nada, se aplicará la búsqueda a todos los resultados. Tiene que ser un array o no indicarse.
- `priorities`: Opcional. Es un objeto en el que vamos a asignar modificadores de prioridad a cada content type. Cada resultado va a tener asociado una “similarity” que es una puntuación de como cuánto de acertado es el resultado, y es un número del 0 al 1 (con muchos decimales). En este ejemplo, estamos dándole dos décimas más de prioridad (que es bastante) a los resultados de programas, y quitándole una décima de prioridad a los resultados de noticias. De esta manera, podemos hacer que los resultados prioricen cierto tipo de contenido, pero sin reordenarlos artificialmente, es decir, que podemos dar prioridad a programas pero no van a salir todos los resultados de programas por delante de cualquier otro resultado si la diferencia de similarity es muy grande.
- `minSimilarity`: Opcional. Similarity mínima para obtener resultados. En este ejemplo no obtendríamos ningún resultado de similarity inferior a 0.6 (que es un valor alto). Por defecto es 0.3.

Ejemplo de respuesta de error:

```jsx
{
    "status": "noResponse",
    "response": "",
    "error": "No relevant info found"
}
```javascript

Ejemplo de respuesta exitosa:

```jsx
{
    "status": "ok",
    "response": "**Los cursos de filosofía ofrecen una formación sólida que estructura el pensamiento y dota de competencias para el análisis crítico de la realidad, así como el desarrollo integral de las personas.** En el (Grado en Filosofía)[https://www.comillas.edu/grados/grado-en-filosofia/] de la Universidad Pontificia Comillas, se incluye el conocimiento de la pluralidad del hecho religioso e introduce la dimensión espiritual, ofreciendo un ambiente de atención individual para un diálogo abierto y profundo sobre problemas y perspectivas diversas.",
    "error": ""
}
```javascript

## `POST`/ai/embeddings

**Este proceso debe ser lanzado exclusivamente por CX cuando ha terminado el proceso de los POST /search.**

**Requiere la variable de entorno `GRIDDO_AI_EMBEDDINGS="on"`**

Lanza el proceso de generación y actualización de embeddings. Los embeddings son representaciones numéricas de datos que transforman información compleja, como palabras o frases, en vectores en un espacio de alta dimensionalidad. Este proceso permite que los datos puedan ser entendidos y manipulados por algoritmos de aprendizaje automático y redes neuronales.

La llamada a este endpoint comienza la generación de embeddings, que sucederá en segundo plano, y asignará los vectores correspondientes a las páginas que hayan sido modificadas o hayan aparecido nuevas.

## `POST`/ai/embeddings/reset

**Este proceso debe ser lanzado exclusivamente cuando es indicado desde desarrollo de producto (cuando cambia el algoritmo de generación de embeddings).**

**Requiere la variable de entorno `GRIDDO_AI_EMBEDDINGS="on"`**

Este endpoint resetea todos los embeddings, haciendo que se vuelvan a generar todos. Esto solo hay que hacerlo cuando ha cambiado el proceso de generación de embeddings, para forzar que los embeddings ya calculados de las páginas se correspondan con los embeddings que se generarán para los macheos.

## `GET` /ai/embeddings/status

Nos devuelve el estado actual del proceso de embeddings.

- `Total` es el total de páginas en search.
- `Embeddings` es el total de páginas que tienen generados embeddings (estén actualizados o no).
- `Updated` es el total de páginas que tienen embeddings actualizados.
- `Loaded` es el total de páginas que están cargadas en memoria y serán usadas para las búsquedas.

```jsx
{
    "total": 11261,
    "embeddings": 11261,
    "updated": 11261,
    "loaded": 11261
}
```javascript

## `PUT` /ai/embeddings

Fuerza la carga de embeddings en memoria. Es un proceso que se hace automático cada hora, pero a veces tenemos prisa por forzarlo. No lleva parámetros ni body ni nada.

Respuesta:

```jsx
{
    "result": "Embeddings loaded.",
    "total": 11261,
    "embeddings": 11261,
    "updated": 11261,
    "loaded": 11261
}
```javascript

## `POST` /ai/pages/related

**Requiere la variable de entorno `GRIDDO_AI_SEARCH="on"` en API Privada.**

Devuelve contenido relacionado con la página que le indiquemos.

Ejemplo de body:

```json
{
			pageId: 142,
			quantity: 10,
			template: null,
			useStructuredData: true,
			fields: ["abstract", "categories"]
}
```javascript

Donde:

- `pageId`. El id de la página de la que queremos el contenido relacionado.
- `languageId`. El idioma en el que devolver resultados.
- `siteId`. El site para el que devolver resultados.
- `quantity`. Opcional. La cantidad de resultados. El máximo es 20. Por defecto, 20.
- `useStructuredData`. Opcional. Booleano. Indica si queremos obtener los datos estructurados asociados a cada resultado (si lo tiene).  Por defecto, false.
- `fields`. Opcional. Array con la lista de campos que queremos obtener depurados de los datos estructurados, separados por comas. Por defecto se mostraría todo el dato.
- `template`. Requerido. La template para la que queremos obtener resultados, por ejemplo EventDetail o ProgramDetail. Puede ser un array.

## `GET` /ai/search/content-types

Devuelve un array con la lista de content-types que se pueden seleccionar para segmentar una búsqueda.

```json
[
    {
        "id": "BasicTemplate",
        "name": "Basic"
    },
    {
        "id": "QA_GlobalDetail",
        "name": "QA Global Detail"
    },
    {
        "id": "QA_GLOBAL_SIMPLE_DATA",
        "name": "QA Global Simple Data"
    },
    {
        "id": "QA_OtherGlobalDetail",
        "name": "QA Other Global Detail"
    }
]
```
---

# Analytics

## `GET` /site/:siteId/metrics/code

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites

---

Devuelve el script de Analytics para ese site en concreto. Si ese site no tiene un script asociado, en su lugar devolverá el script que esté en global.

También si en lugar de introducir un id de site introducimos `global`, nos devolverá el script global.

## `GET` /site/:siteId/metrics

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites

---

Devuelve un objeto con toda la información de analytics para un site concreto, con el `scriptCode` de ese site en concreto, las `dimensions` y los `groups`.  Si introducimos un id de un site que no tiene `scriptCode`, devolveremos el script del site global.

En caso del `"siteScriptCodeExists"` nos dirá si ese site cuenta con scriptCode asociado a él o por si el contrario usa el de global.

Si en lugar de un id de site ponemos `global` nos devolverá los analytics para el site global.

Tanto las `values` en la propiedad `dimensions`, como las `dimensions` y `templates` en la propiedad `groups` pueden ser null.

```json
{
	"scriptCode": "Ejemplo de Script",
	"siteScriptCodeExists": (false || true)
	"dimensions": [
			{
            "name": "dimension1",
            "values": ";valor1;valor2;"
       },
			 {
            "name": "nueva dimension",
            "values": ";valor1;valor2;valor3;"
       }
  ],
	"groups": [
			{
            "name": "dimension actualizada",
            "dimensions": ";valor1;",
            "templates": null
        },
  ]

```javascript

## `POST` /site/:(siteId o "global")/metrics/code

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Crea un nuevo script de Analytics bien en un site concreto o bien como global. Recibe un objeto compuesto por el código del script con el key `scriptCode`. El scriptCode puede ser null.

Body de la petición

```json
{
	"scriptCode": "Ejemplo de script"
}
```javascript

## `PUT` /site/:(siteId o "global")/metrics/code

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Similar al post, solo que en lugar de crear un nuevo script actualiza aquél que pasemos como id o el global. Si no hay registro de ese siteId, lo creará por defecto. El scriptCode que actualicemos puede ser null.

El body de la petición es el mismo que en el POST.

## `DELETE` /site/:(siteId o "global")/metrics/code

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings

---

Con este endpoint borraremos el scriptCode que esté establecido en un site o en la sección global.

## `POST` /metrics/dimensions

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Crea una nueva dimension en la base de datos. Recibe un objeto compuesto por el nombre de la dimensión y los values.

El `name` ha de ir sin espacios. Es necesario mandar los `values` como un string separado por puntos y comas como podemos ver a continuación:

```json
{
	"name": "nuevaDimension",
	"values": ";valor1;valor2;valor3;"
}
```javascript

Las values también pueden ser null si fuera necesario.

## `POST` /metrics/dimensions/site/:(siteId o "global")/bulk

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Publica una serie de dimensiones que le pasemos por el body en forma de array con el nombre `dimensions`. 

Este endpoint realizará tres acciones dependiendo de cada una de las dimensions que le pasemos.

- En caso de que la dimension llegue sin `id` se publicará
- Si llega con `id` y este tiene cambios, lo actualizará
- Si en la lista que enviemos falta alguna dimension que esté presente en el listado de analytics la eliminará.

Ejemplo de petición:

```json
{
    "dimensions": [
        {
            "id": 15,
            "name": "dimensionBulk21",
            "values": ";valor1;valor2;valor3;"
        },
        {
            "id": 27,
            "name": "TestdeDimension1",
            "values": ";valor1;valor2;valor3;"
        },
        {
            "name": "nuevadimension3",
            "values": ";esta;dimension;es;nueva;"
        }
    ]
}
```javascript

## `PUT` /metrics/dimensions/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Con esta ruta actualizamos una dimension en concreto a través de su id. El body de la petición será igual que en el `POST`, con los values separados por puntos y comas. Las values también pueden ser null si fuera necesario.

## `DELETE` /metrics/dimensions/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Borra la dimensión que especifiquemos. También borra cualquier referencia que pueda haber de esa dimension en los `groups` como veremos a continuación.

## `POST` /metrics/groups

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Crea un nuevo grupo de analytics, compuesto por el `name` del grupo, las `dimensions` y las `templates` correspondientes. Estas dos últimas han de ir separadas por puntos y comas y si es necesario también pueden ser null.

El body de la petición deberá enviarse de la siguiente manera:

```json
{
	"name": "Schools",
	"dimensions": ";dimension1;dimension2;dimension3;",
	"templates": "template1;template2"
}
```javascript

## `POST` /metrics/groups/site/:(siteId o "global")/bulk

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Publica una serie de groups que le pasemos por body en forma de array con el nombre `groups`.

El funcionamiento es similar al del bulk de dimensiones de manera que:  

- En caso de que el group llegue sin `id` se publicará
- Si llega con `id` y este tiene cambios, lo actualizará
- Si en la lista que enviemos falta algún grupo que esté presente en el listado de analytics lo eliminará.

Ejemplo de petición:

```json
{
    "groups": [
        {
            "name": "EstaDebeSerNueva2",
            "dimensions": ";dimension;",
            "templates": ";NewsDetail;"
        },
        {
            "id": 26,
            "name": "dimensionTest",
            "dimensions": ";platano;naranja;pistacho;",
            "templates": ";null;"
        },
        {
            "id": 27,
            "name": "NEW",
            "dimensions": ";hello;",
            "templates": ";NewsDetail;NewsList;"
        }
    ]
}
```javascript

## `PUT` /metrics/groups/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

Actualiza un grupo concreto a través de su id. El body de la petición es el mismo que el POST y de la misma manera, podemos cambiar las `templates` o las `dimensions` por null.

## `DELETE` /metrics/groups/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites, general.manageSiteSettings, seoAnalytics.manageAnalyticsInPages, seoAnalytics.manageAnalyticsGlobalSetting, seoAnalytics.manageAnalyticsSiteSettings 

---

 Elimina el grupo concreto.
---

# Feeds

## `POST`/feeds

Crea un feed. En el body indicaremos todos los parámetros del feed:

```jsx
{
    "name": "News",
    "slug": "news",
    "siteId": "global",
    "languageId": 4,
    "data": {
        "mode": "auto",
        "order": "alpha-ASC",
        "quantity": 0,
        "source": [
            "NEWS"
        ],
        "filter": [],
        "fullRelations": true,
        "allLanguages": false,
        "preferenceLanguage": false,
        "filterOperator": "OR",
        "globalOperator": "AND"
    },
    "fields": {
        "STORIES": [
            "who",
            "position"
        ]
    },
    "rss": {
        "channel":{
            "title": "RSS news demo",
						"description": "Description for this RSS feed.",
            "link": "your-instance.griddo.io",
            "image": "https://images.unsplash.com/photo-1560114928-40f1f1eb26a0"
        },
        "items": {
            "title": "content.title",
            "description": "content.abstract",
            "link": "relatedPage.url",
            "category": "content.categories"
        }
    },
    "expirationMinutes": 240,
    "staleMinutes": 60
}
```javascript

Donde:

- `name` es el nombre descriptivo del feed
- `slug` es la parte de la url con la que nos referiremos al feed, que será `{{apiPública}}/feed/{{slug}}`
- `siteId` es el id del site al que se referirá la consulta. Puede ser “global” para datos globales (aunque en el caso de datos globales también se puede indicar cualquier site y funcionaría precisamente porque al ser global también está accesible en ese site).
- `languageId`
- `data` es un objeto distributor, con todas las propiedades de [`POST` /site/:site/distributor](Structured Data 40ba51a1c45941c38ce81d7f105cfb36.md) (incluyendo mapRelations, fullRelations, allLanguages, preferenceLanguage…).
- `rss` es la definición de cómo componer una respuesta RSS, y solo es necesario si vamos a querer obtener respuestas en formato RSS. Se pueden usar “potencialmente” todas las propiedades simples (no anidadas) definidas en RSS 2.0 ([https://www.rssboard.org/rss-specification](https://www.rssboard.org/rss-specification)). Ver el ejemplo en el código que hay más arriba. Para que funcione correctamente, es necesaria la variable de entorno `GRIDDO_PUBLIC_API_URL` cuyo valor debe ser la url de la api pública, incluyendo el https://. Tiene esta estructura mínima:
    - `channel`: es la definición del canal. Consta de las siguientes propiedades:
        - `title`. Obligatorio. Título del canal RSS.
        - `link`. Obligatorio. URL de la página.
        - `description`. Opcional. Recomendado para superar la validación de RSS.
        - `image`. Opcional. URL del logotipo o imagen del RSS.
        - `pubDate`. NO RECOMENDADO. Es mejor no usar esto, solo es para usos muy específicos y especiales. Si no se indica, se usará la fecha de última modificación del elemento más reciente.
    - `items`: es la definición de cada elemento del RSS, y es una especie de mapeo apuntando al equivalente dentro del árbol de datos que obtenemos cuando pedimos el feed en formato json. Por favor, que alguien me ayude a explicar esto mejor, mientras tanto si ves que esto no se entiende preguntas a Diego y que te lo explique él. Por ejemplo, si yo digo `“title”: “content.title”` estoy diciendo que el valor de la propiedad title va a ser lo que contiene el dato dentro de content.title. Las propiedades más habituales son:
        - `title`. Obligatorio.
        - `link`. Obligatorio. Generalmente va a ser relatedPage.url.
        - `description`. Altamente recomendado.
        - `category`. Opcional. Esta es un poco lío (para variar y complicar más la cosa). Si mapeas a una propiedad de tipo string, se usará como categoría esa propiedad. Si es de tipo objeto, intentará usar la propiedad title o label. Si estás mapeando a un array, si es un array de strings usará esos string, pero si es un array de objetos, intentará usar la propiedad title o label de cada objeto. En resumen, si apuntas a un campo AsyncCheckGroup o TextField, funcionará de maravilla.
        - `pubDate`. NO RECOMENDADO. Es mejor no usar esto, solo es para usos muy específicos y especiales. Si no se indica, se usará la fecha de última modificación del elemento (que sería lo correcto).
- `fields` es un objeto en el que para cada tipo de dato que nos estamos trayendo en data le indicamos qué campos queremos que extraiga. Por ejemplo, le estamos diciendo que los STORIES nos los convierta y aunque tienen más info solo queremos visibilizar los indicados. Si no se indica un fields o en el fields no está un tipo de dato concreto, se devolverán todos los campos de ese dato tal cual.
- `expirationMinutes` es la cantidad de minutos para las que se considera que el contenido es válido a efectos de caché. Si se indica 0, el contenido no se cachea (expira inmediatamente).
- `staleMinutes` es la cantidad de minutos para las que se aplica stale (es decir, aunque el contenido haya caducado, si está dentro del stale, se sigue accediendo al contenido en caché mientras en segundo plano se actualiza para la siguiente petición). Si se indica 0, no existirá el stale.

## `PUT` /feeds/:id

Como el post, pero para actualizar un feed.

## `GET` /feeds/

Devuelve un listado de feeds.

Ejemplo:

```jsx
[
    {
        "id": 7,
        "name": "Stories",
        "slug": "stories",
        "siteId": 88,
        "siteName": "Diego Test",
        "languageId": 4
    }
]
```javascript

## `GET` /feeds/:id

Devuelve la info completa del feed indicado.

```jsx
{
    "id": 7,
    "name": "Stories",
    "slug": "stories",
    "siteId": "global",
    "languageId": 4,
    "data": {
        "mode": "auto",
        "order": "alpha-ASC",
        "quantity": 0,
        "source": [
            "STORIES"
        ],
        "filter": [],
        "fullRelations": true,
        "allLanguages": false,
        "preferenceLanguage": false,
        "filterOperator": "OR",
        "globalOperator": "AND"
    },
    "fields": {
        "STORIES": [
            "who",
            "position"
        ]
    },
    "expirationMinutes": 240,
    "staleMinutes": 60
}
```javascript

## `GET` /feeds/:slug/data/:format

Devuelve el feed con el slug indicado. Ojo que aquí la referencia es por el slug. Hay que tener en cuenta que este endpoint está más bien orientado a su uso por API Pública, ya que lo normal es hacer las peticiones desde la API Pública que además será la que se encargará de cachear correctamente la respuesta. El formato puede ser json (por defecto) o rss.

Ejemplo:

```jsx
{
    "name": "Stories",
    "expirationMinutes": 240,
    "staleMinutes": 60,
    "data": [
        {
            "structuredData": "STORIES",
            "id": 5966,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 5966,
                    "site": null,
                    "page": 4164,
                    "language": 4
                },
                {
                    "id": 6384,
                    "site": 84,
                    "page": 5624,
                    "language": 4
                },
                {
                    "id": 6382,
                    "site": 85,
                    "page": 5622,
                    "language": 4
                },
                {
                    "id": 6383,
                    "site": 88,
                    "page": 5623,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4164,
            "content": {
                "who": "Íñigo Montoya",
                "position": "Vengador"
            },
            "modified": "2022-06-24T07:02:37.000Z",
            "published": "2022-06-24T07:02:37.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 5967,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 5967,
                    "site": null,
                    "page": 4165,
                    "language": 4
                },
                {
                    "id": 6387,
                    "site": 84,
                    "page": 5627,
                    "language": 4
                },
                {
                    "id": 6385,
                    "site": 85,
                    "page": 5625,
                    "language": 4
                },
                {
                    "id": 6386,
                    "site": 88,
                    "page": 5626,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4165,
            "content": {
                "who": "Íñigo Montoya",
                "position": "Vengador"
            },
            "modified": "2022-06-24T07:02:50.000Z",
            "published": "2022-06-24T07:02:50.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 5969,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 5969,
                    "site": null,
                    "page": 4167,
                    "language": 4
                },
                {
                    "id": 6147,
                    "site": 82,
                    "page": 4603,
                    "language": 4
                },
                {
                    "id": 6118,
                    "site": 84,
                    "page": 4527,
                    "language": 4
                },
                {
                    "id": 6116,
                    "site": 85,
                    "page": 4525,
                    "language": 4
                },
                {
                    "id": 6117,
                    "site": 88,
                    "page": 4526,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4167,
            "content": {
                "who": "Íñigo Montoya",
                "position": "Vengador"
            },
            "modified": "2022-11-08T12:23:27.000Z",
            "published": "2022-06-24T07:03:19.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 5968,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 5968,
                    "site": null,
                    "page": 4166,
                    "language": 4
                },
                {
                    "id": 6153,
                    "site": 82,
                    "page": 4609,
                    "language": 4
                },
                {
                    "id": 6114,
                    "site": 85,
                    "page": 4518,
                    "language": 4
                },
                {
                    "id": 6115,
                    "site": 88,
                    "page": 4519,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4166,
            "content": {
                "who": "Novak Djokovic",
                "position": "Tennis player"
            },
            "modified": "2022-06-24T07:03:01.000Z",
            "published": "2022-06-24T07:03:01.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6317,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6317,
                    "site": null,
                    "page": 4999,
                    "language": 4
                },
                {
                    "id": 6318,
                    "site": 80,
                    "page": 5000,
                    "language": 4
                },
                {
                    "id": 6319,
                    "site": 289,
                    "page": 5001,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4999,
            "content": {
                "who": "Name",
                "position": "Position"
            },
            "modified": "2023-03-13T12:00:45.000Z",
            "published": "2023-03-13T12:00:45.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 4393,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 4393,
                    "site": null,
                    "page": 3337,
                    "language": 4
                },
                {
                    "id": 6154,
                    "site": 82,
                    "page": 4610,
                    "language": 4
                },
                {
                    "id": 4408,
                    "site": 84,
                    "page": 3353,
                    "language": 4
                },
                {
                    "id": 5975,
                    "site": 86,
                    "page": 4172,
                    "language": 4
                },
                {
                    "id": 6007,
                    "site": 88,
                    "page": 4278,
                    "language": 4
                },
                {
                    "id": 4498,
                    "site": 108,
                    "page": 3488,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 3337,
            "content": {
                "who": "Íñigo Montoya",
                "position": "Vengador"
            },
            "modified": "2022-02-08T17:04:03.000Z",
            "published": "2022-01-18T14:47:19.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6008,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6008,
                    "site": null,
                    "page": 4279,
                    "language": 4
                },
                {
                    "id": 6756,
                    "site": 88,
                    "page": 8304,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4279,
            "content": {
                "who": "Name",
                "position": "Position"
            },
            "modified": "2022-08-24T08:22:51.000Z",
            "published": "2022-08-24T08:21:57.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6083,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6083,
                    "site": null,
                    "page": 4485,
                    "language": 4
                },
                {
                    "id": 6084,
                    "site": 80,
                    "page": 4486,
                    "language": 4
                },
                {
                    "id": 6148,
                    "site": 82,
                    "page": 4604,
                    "language": 4
                },
                {
                    "id": 6316,
                    "site": 289,
                    "page": 4998,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4485,
            "content": {
                "who": "Name",
                "position": "Position"
            },
            "modified": "2022-11-08T11:18:33.000Z",
            "published": "2022-11-08T11:10:48.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 5965,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 5965,
                    "site": null,
                    "page": 4163,
                    "language": 4
                },
                {
                    "id": 6381,
                    "site": 80,
                    "page": 5621,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4163,
            "content": {
                "who": "Name",
                "position": "Position"
            },
            "modified": "2022-06-24T07:02:20.000Z",
            "published": "2022-06-24T07:02:20.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6014,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6014,
                    "site": null,
                    "page": 4285,
                    "language": 4
                },
                {
                    "id": 6149,
                    "site": 82,
                    "page": 4605,
                    "language": 4
                },
                {
                    "id": 6081,
                    "site": 85,
                    "page": 4483,
                    "language": 4
                },
                {
                    "id": 6082,
                    "site": 88,
                    "page": 4484,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4285,
            "content": {
                "who": "Professor Type 2",
                "position": "Position"
            },
            "modified": "2022-11-08T11:03:20.000Z",
            "published": "2022-08-24T08:23:42.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6017,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6017,
                    "site": null,
                    "page": 4288,
                    "language": 4
                },
                {
                    "id": 6758,
                    "site": 88,
                    "page": 8306,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4288,
            "content": {
                "who": "Professor Type 2 and 3",
                "position": "Position"
            },
            "modified": "2022-08-24T08:26:17.000Z",
            "published": "2022-08-24T08:24:16.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6451,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6451,
                    "site": null,
                    "page": 6804,
                    "language": 4
                },
                {
                    "id": 6452,
                    "site": 85,
                    "page": 6805,
                    "language": 4
                },
                {
                    "id": 6453,
                    "site": 88,
                    "page": 6806,
                    "language": 4
                },
                {
                    "id": 6454,
                    "site": 112,
                    "page": 6807,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 6804,
            "content": {
                "who": "Name",
                "position": "Position"
            },
            "modified": "2023-08-03T09:27:59.000Z",
            "published": "2023-04-26T11:08:34.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6773,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6773,
                    "site": null,
                    "page": 8323,
                    "language": 4
                },
                {
                    "id": 6774,
                    "site": 85,
                    "page": 8324,
                    "language": 4
                },
                {
                    "id": 6775,
                    "site": 88,
                    "page": 8325,
                    "language": 4
                },
                {
                    "id": 6776,
                    "site": 112,
                    "page": 8326,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 8323,
            "content": {
                "who": "Name",
                "position": "Position"
            },
            "modified": "2023-08-03T09:28:39.000Z",
            "published": "2023-08-03T09:28:39.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6011,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6011,
                    "site": null,
                    "page": 4282,
                    "language": 4
                },
                {
                    "id": 6757,
                    "site": 88,
                    "page": 8305,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 4282,
            "content": {
                "who": "Student Type 3",
                "position": "Position"
            },
            "modified": "2022-08-24T08:26:49.000Z",
            "published": "2022-08-24T08:23:08.000Z"
        },
        {
            "structuredData": "STORIES",
            "id": 6690,
            "language": 4,
            "dataLanguages": [
                {
                    "id": 6690,
                    "site": null,
                    "page": 8260,
                    "language": 4
                },
                {
                    "id": 6691,
                    "site": 83,
                    "page": 8261,
                    "language": 4
                }
            ],
            "relatedSite": null,
            "relatedPage": 8260,
            "content": {
                "who": "Name",
                "position": "Position"
            },
            "modified": "2023-06-26T11:37:50.000Z",
            "published": "2023-06-26T11:37:50.000Z"
        }
    ]
}
```
---

# Form Builder


## Form

# Form

## `POST` /form

**🔑 Requiere autenticación.**

🛂 **Types: Params `PostFormParams` Response `Promise<FormContent>`**

Publica un form y devuelve la información del nuevo formulario.

```json
Body
{
    "component": "FormPage",
    "language": 1,
    "tags": ["Hello", "World"],
    "template": {},
    "title": "Form3",
    "site": 4,
    "message": "Mensaje de test"
}
```javascript

## `PUT` /form/:formId

**🔑 Requiere autenticación.**

🛂 **Types: Params `PostFormParams` Response `Promise<FormContent>`**

Con este endpoint editamos un formulario y la respuesta es el formulario recién editado

```json
Body
{
    "title": "Titulo 1.1",
    "tags": ["Hello"],
    "message": "Le message",
    "template": {"hello": "world"}
}
```javascript

## `PUT` /form/:formId/state/:state

**🔑 Requiere autenticación.**

🛂 **Types: Params `StateParams` Response `void`**

Con este endpoint cambiaremos el estado de publicación de un form. State solo acepta los valores `active` e `inactive`.

Si intentas desactivar un formulario que esté siendo usado, la API devolverá el siguiente error

```json
{
    "code": 400,
    "message": "This form is currently used on multiple pages. Please remove it from those pages before unpublishing",
    "content": {
        "page": [
            2
        ],
        "header": [
            7
        ]
    }
}
```javascript

## `PUT`/form/bulk/state/:state

**🔑 Requiere autenticación.**

Con este endpoint publicaremos o despublicaremos una serie de formularios a través de sus ids.

```json
body {
	"formsIds": [1, 2, 3, 4]
}
```javascript

Si alguno de ellos está siendo usado devolveremos el siguiente mensaje de error:

```json
{
    "code": 400,
    "message": "Some forms are currently used on pages. Please remove it from those pages before unpublishing.",
    "content": {
        "1": [
            {
                "page": [
                    2
                ],
                "header": [
                    7
                ]
            }
        ],
        "2": [
            {
                "page": [
                    3
                ]
            }
        ]
    }
}
```javascript

La propiedad `content` cada key será el id del formulario y la value, los lugares donde se está usando.

## `GET` /form/:formId

**🔑 Requiere autenticación.**

🛂 **Types: Response `Promise<FormContent>`**

Devuelve la información de un formulario.

```json
RESPUESTA

{
    "id": 1,
    "title": "Titulo 1.1",
    "site": null,
    "language": 1,
    "component": "FormPage",
    "entity": "5cec0d31-b37f-449c-8d0b-797edf908a03",
    "tags": [
        "Hello"
    ],
    "template": {
        "hello": "world"
    },
    "message": "Le message",
    "created": "2024-11-14T12:44:27.000Z",
    "modified": "2024-11-14T16:27:48.000Z",
    "state": false,
    "thumbnail": null
}
```javascript

## `GET`/site/:site/forms

**🔑 Requiere autenticación.**

🛂 **Types: Params `GetFormsParams` Response `Promise<ListForm>`**

Con este endpoint recuperaremos el listado de formularios diferenciando entre global o site. Si quieres recuperar la información de los formularios globales en lugar del id numérico del site, deberás poner `'global'` en los parámetros.

Además de ello podrás añadir varios filtros para buscar mejor dentro de un listado. A saber:

- `query`: La frase que especifiques en la query la buscará en los títulos de cada forms o por las tagas.
- `order`: Para ordenar los resultados. Hay dos opciones:
    - `title-ASC, title-DESC` : Ordena en sentido alfabético por el título en orden ascendente o descendente.
    - `modified-ASC, modified-DESC` : Ordena por la fecha de modificación en orden ascendente o descendente.
- `state` : Filtra por el estado de publicación de los formularios y acepta `active` e `inactive`.
- `translated` : Filtra por traducciones
    - `all` (por defecto) Devolverá todo sin filtrar.
    - `only` Devolverá solo los formularios que tengan traducción.
    - `no` Devolverá solo los formularios que no estén traducidos.
- `type` : Filtra por los formularios adscritos a una categoría especificando el id de categoría
- `pagination` Los resultados vendrán paginados por defecto en grupos de 50 formularios pero puedes definir los resultados como tú quieras:
    - `pagination`  Por defecto true. Puedes activarla o desactivarla como quieras.
    - `page` La página que quieras mostrar dentro de la paginación
    - `itemsPerPage` Cuantos items quieres mostrar por página. Por defecto 50.

La respuesta será un objeto con cuatro propiedades:

- `totalItems`: Número total de formularios. Esta propiedad no cambia al emplear filtros.
- `active`: Número total de formularios activos. Esta propiedad no cambia al emplear filtros.
- `inactive` : Número total de formularios inactivos. Esta propiedad no cambia al emplear filtros.
- `items`: El listado de formularios.

```json
{
    "totalItems": 3,
    "active": 2,
    "inactive": 1,
    "items": [
        {
            "id": 1,
            "title": "Titulo 1.1",
            "site": null,
            "language": 1,
            "component": "FormPage",
            "entity": "5cec0d31-b37f-449c-8d0b-797edf908a03",
            "tags": [
                "Hello"
            ],
            "template": {
                "hello": "world"
            },
            "message": "Le message",
            "created": "2024-11-14T12:44:27.000Z",
            "modified": "2024-11-14T16:27:48.000Z",
            "state": true,
            "thumbnail": null
        }, {...}, {...}
    ]
}
```javascript

## `DELETE` /form/:formId

**🔑 Requiere autenticación.**

Elimina de manera lógica un formulario a través de su id.

Si ese formulario está siendo usado en alguna parte devolveremos el siguente mensaje de error.

```json
{
    "code": 400,
    "message": "This form is currently used on multiple pages. Please remove it from those pages before deleting",
    "content": {
        "page": [
            2
        ],
        "header": [
            7
        ]
    }
}
```javascript

## `DELETE` /form/bulk

**🔑 Requiere autenticación.**

Elimina de manera lógica un grupo de formularios especificados en el body como `formIds`

```json
body: {
	"formIds": [1, 2, 3, 4]
}
```javascript

Si alguno de estos ids está siendo usado en alguna parte de Griddo el mensaje de error que devolveremos será el siguiente

```json
body { "formIds": [1, 2] }

Response {
    "code": 400,
    "message": "Some forms are currently used on pages. Please remove it from those pages before deleting it.",
    "content": {
        "1": [
            {
                "page": [
                    2
                ],
                "header": [
                    7
                ]
            }
        ],
        "2": [
            {
                "page": [
                    3
                ]
            }
        ]
    }
}
```javascript

La propiedad `content` cada key será el id del formulario y la value, los lugares donde se está usando.

## `POST` /form/:formId/duplicate

**🔑 Requiere autenticación.**

Duplica un formulario, indicado por su id, en el mismo sitio donde esté, ya sea dentro de un site o en la sección global.

Por body habrá que pasarle el nuevo title que le quieras dar a esta copia. La respuesta será el nuevo formulario creado.

```json
{
    "title": "Nuevo Formulario"
}

```javascript

## `POST` /form/:formId/duplicate/site/:siteId

**🔑 Requiere autenticación.**

Duplica un formulario, indicado por su id, en otro site también indicado por su id.

## `POST` /thumbnail/contentId/:contentId/contentType/:contentType

La descripción de este endpoint está en la parte correspondiente de [Images](../Images eae07cbcbeae44ffbec46e99616b7de0.md)

## `POST`/translations/form/:targetLanguage

Con este endpoint traduciremos un formulario con inteligencia artificial. Se traducirán los campos que en los schemas estén establecidos con la propiedad `humanReadable` de la misma manera que se está haciendo en las páginas y en los datos estructurados simples.

Como parámetro acepta `targetLanguage` que será el id del idioma al que queremos traducir el formulario.

En el body se aceptará el objeto del formulario que queremos traducir.

Devolverá el formulario traducido al idioma solicitado.

## Form Categories

# Form Categories

## `POST` /form/category

**🔑 Requiere autenticación.**

🛂 **Types: Params `PostFormCategoryParams` Response `Promise<CategoryFormatted>`**

Crea una categoría de formularios en un site concreto o en global.

```json
"body": {
    "categoryType": "PRUEBA",
    "content": {
        "title": "Quinta categoría de formularios",
        "code": "quinta-categoría-de-formularios"
    },
    "relatedSite": null | number
}
```javascript

Por defecto se crearán al final del listado y al crear devolverá la nueva categoría creada.

## `PUT`/form/category/:categoryId

**🔑 Requiere autenticación.**

🛂 **Types: Params `PutFormCategoryParams` Response `Promise<CategoryFormatted>`**

Edita el contenido de un categoría concreta especificada por su id.

<aside>
⚠️

Params
- categoryId: Id númerico de la categoría que quieres editar.
Body
- Content. Consistirá en un objeto { title: string; code: string };

</aside>

Al guardar en la respuesta te llegará la categoría editada.

## `GET`/site/:siteId/form/categories/:categoryType

**🔑 Requiere autenticación.**

🛂 **Types: Response `Promise<FormCategories>`**

Con este endpoint recuperaremos el listado de categorías de un site concreto y de un tipo concreto.

- **siteId**: `"global"` o el id numérico
- **categoryType**: El string con el tipo de categorías de formulario que quieres recuperar.
- Buscador: Si añadimos `?query=...` se filtrará el listado por las categorías que tengan ese término en su título en el idioma y site especificados

En la respuesta encontraremos dos propiedades, el `totalItems` con la cantidad total de categorías existentes y `items` que será un array con las categorías ordenadas por su position.

```json
{
    "totalItems": 3,
    "items": [
        {
            "id": 3,
            "title": "Tercera categoría de formularios",
            "relatedSiteId": null,
            "categoryType": "PRUEBA",
            "content": {
                "title": "Tercera categoría de formularios",
                "code": "tercera-categoría-de-formularios"
            },
            "position": 4
        },
        {
            "id": 1,
            "title": "Primera categoría de formularios",
            "relatedSiteId": null,
            "categoryType": "PRUEBA",
            "content": {
                "title": "Primera categoría de formularios",
                "code": "primera-categoría-de-formularios"
            },
            "position": 5
        },
        {
            "id": 2,
            "title": "Segunda categoría de formularios",
            "relatedSiteId": null,
            "categoryType": "PRUEBA",
            "content": {
                "title": "Segunda categoría de formularios",
                "code": "segunda-categoría-de-formularios"
            },
            "position": 6
        }
    ]
}
```javascript

## `GET`/site/:siteId/form/categories/:categoryType/checkgroup

Igual que el anterior pero devolverá los resultados en el formato checkgroup.

```json
[
    {
        "value": 6,
        "name": 6,
        "title": "Quinta categoría de formularios"
    }
]
```javascript

## `DELETE`/form/category/:categoryId

**🔑 Requiere autenticación.**

Elimina una categoría del listado a partir de su id. Las borraremos de manera lógica, `deleted=1`

## `DELETE`/form/category/bulk

**🔑 Requiere autenticación.**

Borra un conjunto de categorías de modo bulk. Para ello en el body deberemos especificar los ids de las categorías que queramos borrar.

```json
Body
{
    "categoryIds": [6, 4, 1]
}
```javascript

## `PUT`/form/category/order

**🔑 Requiere autenticación.**

🛂 **Types: Params `PutFormCategoriesOrderParams`** 

Endpoint para cambiar el orden de una categoria. Para ello esperará en el body las sigueintes propiedades

```json
{
    "id": 2,
    "categoryType": "PRUEBA",
    "position": 6,
    "relatedSite": null
}
```javascript

- `id` : El id de la categoría que quieres mover
- `categoryType`: El tipo de categoría al que corresponde.
- `position` : La posición nueva que va a ocupar.
- `relatedSite`: null para global y el id para el site.

**Apunte acerca de la ordenación.** He seguido la metodología que estamos usando en las categorías normales y en los addons, es decir a la hora de especificar la posición su `position` debe ser la siguiente a la categoría donde la quieres poner.

Es decir. Pongamos que tienes 

```json
Categoría A -> position 1
Categoría B -> position 2
Categoría C -> position 3
```javascript

Ahora quiero crear la `Categoría D`  pero la quiero poner entre la `Categoría B` y la `Categoría C`. Por lo tanto cojo la `position` de Categoría B que tiene position 2 y la pongo debajo, de modo que el body me quedaría de la siguiente:

```json
{
    "id": id de la Categoría D,
    "categoryType": "PRUEBA",
    "position": 3, (como lo quiero debajo de la position 2 tendrá la position 3)
    "relatedSite": null
}
```javascript

Una vez guardado el resto de categorías se reordenará quedando de la siguiente manera

```json
Categoría A -> position 1
Categoría B -> position 2
Categoría D -> position 3
Categoría C -> position 4
```javascript
---

# GPX

## `POST` /gpx/collect

Con este endpoint se recoge la información de los intereses de un usuario determinado mientras navega por Griddo y se guardan en la base de datos bajo un id en formato `uuid`.

Recibe en el body un objeto con la siguiente estructura:

```jsx
{
    "id": string",
    "navigator": { 
	    "language": string,
	    "userAgent": string,
    },
    "interests": [
        {
            "area": string,
            "interest": object,
            "weight": number
        },
        {
            "area": string,
            "interest": string,
            "weight": number
        }
    ]
}

```javascript

### Explicación de los parámetros:

- **`id`** (OBLIGATORIO):
    
    Identificador único del perfil. Si este `id` no existe, se creará un nuevo registro interno.
    
    Este id será un string de tipo uuid
    
- **`navigator`** (OBLIGATORIO):
    
    En este objeto pasaremos dos propiedades, donde ambas serán de tipo string:
    
    - language: obtenido desde window.navigator.language
    - userAgent: window.navigator.userAgent
- **`interests`** (OBLIGATORIO):
    
    Array de objetos que definen los intereses del usuario. Cada objeto debe incluir:
    
    - **`area`**: Área temática del interés.
    - **`interest`**: Un Object donde especifica el interés concreto y un id si es necesario.
        - **`id`**: Campo de texto o número opcional
        - **`label`:** Campo de texto obligatorio donde se especifica el interest
    - **`weight`**: Valor numérico que indica la importancia de dicho interés

Ejemplo de respuesta exitosa:

```jsx
{
    "code": 200,
    "message": "ok"
}
```javascript

Ejemplo de respuesta fallida:

```jsx
{
    "code": 400,
    "message": "Not a valid user id."
}
```javascript

## `POST` /gpx/pages

Este endpoint actúa como un distribuidor de páginas, delegando la búsqueda al método `getPages` del modelo AI, utilizando los mismos parámetros que éste.

Su funcionamiento es similar al de [`POST` /ai/search](AI Search 19f978734bcb4e0ab2dedbf865303e5b.md)

### Estructura del Body

```jsx
{
    "id": string,
    "prompt": string,
    "templates": string[],
    "sites": number[],
    "language": number,
    "useStructuredData": boolean,
    "fields":  string[],
    "limit": number,
    "area": string,
    "pageId": string 
}
```javascript

### Explicación de los parámetros:

- **`id`**:
    
    Identificador del perfil público de gpx. Puede ser de tipo string o number y se utiliza para identificar el usuario en la búsqueda.
    
    Este id será un string de tipo uuid.
    
    Si no se envía este parámetro, la respuesta estará compuesta de datos aleatorios.
    
- **`prompt`** (OPCIONAL):
    
    Texto que se utiliza como prompt de búsqueda. Se emplea para generar la consulta en caso de no disponer de datos específicos en el `calculatedStatus`.
    
- **`templates`** (OBLIGATORIO):
    
    Array que contiene la lista de templates a los que se dirigirá la búsqueda. Permite filtrar los resultados por tipos de contenido.
    
- **`sites`** (OPCIONAL):
    
    Array de ids de los sites a los que se dirija la búsqueda.
    
- **`language`** (OBLIGATORIO):
    
    Identificador numérico del idioma en el que se realizará la búsqueda.
    
- **`useStructuredData`** (OPCIONAL):
    
    Valor booleano que indica si se deben incluir datos estructurados en la respuesta.
    
- **`fields`** (OPCIONAL):
    
    Array que especifica los campos de los datos estructurados a devolver, en caso de que `useStructuredData` esté activado.
    
- **`limit`** (OBLIGATORIO):
    
    Número total de resultados a devolver. Este parámetro se traduce internamente a `itemsPerPage` y se asume que la página es siempre 1.
    
- **`area`** (OBLIGATORIO):
    
    Cadena que indica el área para la cual se consulta el `calculatedStatus`. Se utiliza para filtrar y contextualizar la búsqueda.
    
- **`pageId`** (OPCIONAL):
    
    Identificador de la página en la que se está realizando la consulta. Si se envía, se utiliza para activar la búsqueda basada en el embedding de la página (mediante `useQueryPageEmbedding`).
    

### Ejemplo de Request

```javascript
{
    "id": "12345",
    "prompt": "Buscar artículos sobre innovación tecnológica",
    "templates": ["ArticleDetail", "NewsDetail"],
    "sites": [1, 15],
    "language": 2,
    "useStructuredData": true,
    "fields": ["title", "summary"],
    "limit": 10,
    "area": "technology",
    "pageId": 1
}
```javascript

### Ejemplo de Respuesta

```jsx
{
    "page": 1,
    "itemsPerPage": 10,
    "totalItems": 25,
    "items": [
        {
            "title": "Innovación tecnológica: últimas tendencias",
            "url": "https://ejemplo.com/articulos/innovacion-tecnologica",
            "image": "https://ejemplo.com/images/tech.jpg",
            "description": "Resumen sobre las últimas tendencias en innovación.",
            "template": "ArticleDetail",
            "similarity": 0.87
        }
        // Más resultados...
    ]
}

```javascript

## `GET` /gpx/profile/:area/:id

Recupera el `calculatedStatus` de un perfil basado en el `id` proporcionado, devolviendo únicamente las áreas solicitadas.

### Parámetros de la URL

- **`:areas`** (OBLIGATORIO):
    
    Lista separada por comas que indica las áreas específicas que se desean recuperar del `calculatedStatus`.
    
    *Ejemplo:* `education,technology`
    
- **`:id`** (OBLIGATORIO):
    
    Identificador único del perfil a consultar.
    
    Este id será un string de tipo uuid
    

Ejemplo de respuesta exitosa:

```jsx
{
    "music": [
        {
            "interest": "pop",
            "weight": 62.37,
            "updated_at": "2025-02-24T14:41:56.000Z"
        }
    ]
}
```javascript

Ejemplo de respuesta fallida:

```jsx
{
    "code": 400,
    "message": "Not a valid user id."
}
```
---

# Integrations (addons)

# Flujo Settings

## `POST`/integration/site/:site/

Con este endpoint crearemos una nueva integración en un site concreto. El cuerpo de la petición será el siguiente:

```json
{
    "name": "Cookies",
    "description": "This is the integration for Cookies",
    "contentHead": null,
    "contentBody": "<script>console.log('Hello')</script>",
    "contentBodyPosition": "start",
    "contentPresence": {
			"presenceType": "page-specific",
      "relatedPages": [3347, 3348]
		},
    "active": false,
    "scriptOrder": 43,
		"correlativeScriptOrder": 1,
    "variables": [
        {
            "variableName": "Greeting",
            "variableKey": "greets",
            "defaultValue": "Hola",
            "multilanguage": [
								{
									"languageId": 4,
									"value": "Hi"
								}
						]
        }
    ]
}
```javascript

- `name`: Es el nombre que le vas a dar a la integración
- `description`: Es la descripción
- `contentHead` y `contentBody`: Dependiendo de en qué lugar quieras poner tu script.
- `contentBodyPosition`: En caso de que el script vaya en el body, puedes establecer en qué posición quieres establecerlo. Solo podrá haber tres opciones: `’start’, ‘end’ o null`
- `contentPresence`: Puedes seleccionar dónde quieres que esta integración esté activa. Para ello se le pasa un objeto con las opciones.
    - `presenceType`: Indica el tipo de presencia que puede haber. `all`, si quieres que esté presente en todas las páginas, `page-manual` si queremos especificarlo en página, `page-specific` si queremos especificarlo en páginas concretas.
    - `relatedPages`: Dependiendo si escogemos page-specific como tipo deberemos especificar los ids de página en este array. Si no será null o []??
- `active`: (booleano) Sirve para indicar si una integración está activa.
- `variables`: Es posible adjuntar variables para cambiar la función de una integración en una página concreta. Aquí podremos establecer los valores por defecto. Le pasaremos un array de variables con los values: `variableName`, `variableKey`, `defaultValue`. En el caso de tener `multilanguage`  será un array de objetos con el `languageId` del idioma en el que sea ese valor y el `value` para este nuevo idioma.

## `PUT`/integration/:id/site/:site/

Edita una integración concreta asociada a un site. Este será el body de la petición:

```json
{
    "name": "Chatbot",
    "description": "This is the integration for cookies",
    "contentHead": null,
    "contentBody": "<script>console.log('Hello')</script>",
    "contentBodyPosition": "start",
    "contentPresence": {
			"presenceType": "all",
      "relatedPages": null
		},
    "active": false,
    "scriptOrder": 43,
    "variables": [
            {
                "id": 4,
                "variableName": "Nuevo1",
                "variableKey": "color",
                "defaultValue": "#FFFFF",
                "multilanguage": null
            },
            {
                "id": 8,
                "variableName": "Nuevo3",
                "variableKey": "color",
                "defaultValue": "#FFFFF",
                "multilanguage": null
            }
        ]
}
```javascript

En lo referente a las variables:

- **Si una variable llega en el array con su id**, este endpoint editará los valores que le pasemos entendiendo que es un put. Ejemplo

```json
//Editaremos los valores de la variable 4 y la variable 8, si no queremos 
//editar tendremos que mandar los mismos valores que ya tenía
"variables": [
            {
                "id": 4,
                "variableName": "Nuevo1",
                "variableKey": "color",
                "defaultValue": "#FFFFF",
                "multilanguage": null
            },
						{
                "id": 8,
                "variableName": "Nuevo3",
                "variableKey": "color",
                "defaultValue": "#FFFFF",
                "multilanguage": null
            }
        ]
```javascript

- **Si una variable que estaba presente en la integración no llega en el array variables**, este endpoint entenderá que lo que queremos es eliminarla.

```json
//Tomemos el ejemplo de antes. Como no pasamos en la nueva petición
//la variable 4, la borrará de la base de datos.
"variables": [
						{
                "id": 8,
                "variableName": "Nuevo3",
                "variableKey": "color",
                "defaultValue": "#FFFFF",
                "multilanguage": null
            }  
 ]
```javascript

- **Si llega una variable nueva**, **es decir sin id**, este endpoint creará una nueva variable asociada a esa integración.

```json
//Ya que hemos eliminado la anterior variable, si pasamos en el listado una
//variable sin id, identificaremos que es nueva y por tanto la crearemos de cero.
"variables": [
						{
                "id": 8,
                "variableName": "Nuevo3",
                "variableKey": "color",
                "defaultValue": "#FFFFF",
                "multilanguage": null
            },
						{
                "variableName": "NuevaVariable",
                "variableKey": "color",
                "defaultValue": "#FFFFF",
                "multilanguage": null
            }    
 ]
```javascript

La misma funcionalidad se aplica al `multilanguage` . En este caso `multilanguage` será también un array de objetos.

```json
"multilanguage": [
						//Así editaremos el value del multilanguage 40
             {
               "id": 40,
               "languageId": 4,
               "value": "Variable template English"
              },
						//Así crearemos un nuevo multilanguage
              {
                "languageId": 2,
                "value": "Hola"
               },
						//Si quitamos de la lista este que tiene id 46, lo eliminaremos.
               //{
                 //"id": 46,
                 //"languageId": 4,
                 //"value": "Variable template English"
               //}
]
```javascript

## `POST`/integration/:integration/duplicate/:site

Con este endpoint duplicaremos una integración concreta en un site determinado. Basta con pasarle los ids de la integración y del site por params.

Se copiará con los valores por defecto, tanto de la integración como de las variables. Como no se conoce si el site tiene otro idioma, las variables se copiarán sin `multilanguage`.

## `PUT`/integration/:id/state/:state

Con este endpoint cambiaremos el estado de una integración. Podremos cambiar :state por `enable` o `disable`.

## **`PUT`/integration/state/:state/bulk**

Con este endpoint podremos activar o desactivar un conjunto de Integraciones identificadas por su id. Tan solo tendremos que especificar en el `state` si queremos `enable` o `disable` y pasar un array de ids en el body.

```json
{
    "ids": [75, 76, 77]
}
```javascript

## `GET`/site/:site/integrations

<aside>
💡 **Params:**
?page
?itemsPerPage
?pagination (true/false)
?order
?filterApplication
?filterState
?filterCode

</aside>

Este endpoint te devuelve la información de las integraciones relativas a un site concreto.

Con order podremos ordenarlas por el name en sentido ascendente o descendente como `name-asc`, `name-desc`, `scriptOrder-asc`, `scriptOrder-desc`. Por defecto se ordena por orden de prioridad ascendente.

- También filtra por las integraciones que estén presentes en todas las páginas del site usando la query `filterApplication=allpages`, por páginas concretas `filterApplication=somepages` o a aquellas páginas que no están asociadas a ninguna página con `filterAplicacion=none` . Se pueden encadenar varios filtros separados por una coma.
- También en `filterState` podemos filtrar por las que estén activos(`enable`) o inactivos(`disable`).
- `filterCode` : Con esto filtraremos por dónde hayamos especificado el código de los addons. Aceptará estos cuatro parámetros `head`, `body`, `headBody` y `all`.

También los resultados vienen paginados y se pueden manipular los resultados con page, itemsPerPage and pagination. 

```json
{
    "totalItems": 2,
    "page": 1,
    "items": [
        {
            "id": 53,
            "name": "PRUEBA FINAL",
            "description": "Descripción prueba final",
            "site": 86,
            "contentHead": null,
            "contentBody": "<script>console.log('Hello')</script>",
            "contentBodyPosition": "start",
            "contentPresence": {
                "presenceType": "page-specific",
                "relatedPages": [
                    {
                        "id": 3355,
                        "title": "Homes cx"
                    },
                    {
                        "id": 4222,
                        "title": "Prueba"
                    }
                ]
            },
            "active": false,
            "scriptOrder": 43,
						"correlativeScriptOrder": 1,
            "variables": [
                {
                    "id": 74,
                    "variableName": "Greeting",
                    "variableKey": "greets",
                    "defaultValue": "Hola",
                    "multilanguage": [
                        {
                            "id": 40,
                            "languageId": 4,
                            "value": "Variable template English"
                        },
                        {
                            "id": 41,
                            "languageId": 2,
                            "value": "Hola"
                        },
                        {
                            "id": 46,
                            "languageId": 4,
                            "value": "Variable template English"
                        },
                        {
                            "id": 47,
                            "languageId": 2,
                            "value": "Variable template Español"
                        }
                    ]
                },
                {
                    "id": 75,
                    "variableName": "Greeting",
                    "variableKey": "greets",
                    "defaultValue": "Hola",
                    "multilanguage": [
                        {
                            "id": 42,
                            "languageId": 2,
                            "value": "Hola"
                        }
                    ]
                }
            ]
        },
        {
            "id": 29,
            "name": "Customer Support",
            "description": "This is the integration for Customer Support",
            "site": 86,
            "contentHead": "<script>console.log('Hello')</script>",
            "contentBody": null,
            "contentBodyPosition": "start",
            "contentPresence": {
                "presenceType": "all",
                "relatedPages": null
            },
            "active": true,
						"scriptOrder": 45,
						"correlativeScriptOrder": 2,
						"variables": null
        },
    ]
}
```javascript

## `GET`/site/:site/integration/:integration

Devuelve la información de una integración en concreto, referente a un site concreto.

## `DELETE`/integration/:id

Borra una integración concreta. Realiza un borrado lógico.

## `DELETE`/integration/:id/undo

Anula el borrado de una página en concreto. Sirve para los Toast

## **`DELETE`/integration/bulk**

Borra una serie de ids que hayamos establecido en el body de la siguiente manera

```json
{
	"ids": [12, 34, 55]
}
```javascript

## `DELETE`/integration/bulk/undo

Revertirá el eliminado de una serie de ids de integraciones. De la misma manera que delete bulk necesitaremos pasar en el body un array de ids de integraciones

```json
{
	"ids": [12, 34, 55]
}
```javascript

## `PUT` /integration/:id/order/:newOrder

Modifica el scriptOrder de la integración con id para que sea el que se le indica.
---

# Inteligencia Artificial

## OpenAI

Para utilizar OpenAI, necesitamos la variable de entorno:

- `GRIDDO_openAIApiKey` cuyo valor debe ser la api key de OpenAI.

## DeepL

Para utilizar DeepL necesitamos las variables de entorno:

- `GRIDDO_deepLApiKey` cuyo valor debe ser la api key de DeepL.
- `GRIDDO_deepLDomain` cuyo valor debe ser el dominio de DeepL (es un dominio diferente según si usamos una cuenta gratuita con límite de 500.000 caracteres / mes o una de pago, para el gratuito es `api-free.deepl.com` y para el de pago es `api.deepl.com`).

## Settings

Es necesario que las settings de autoSummary y autoTranslation estén activadas en las settings, ya que activan la creación de metas en página y las traducciones respectivamente. Se puede actualizar las settings mediante llamada a API Privada usando postman, o directamente en la BBDD (tabla settings). Están [documentadas en el endpoint de settings](Settings d7c52f9c44204dd9b5f2d2de2f12c8ee.md).

Para el autoetiquetado de imágenes, hay que activar una configuración distinta que se produce en el DAM y está comentada al final de este documento.

**Recuerda: cuando se cambian las settings, AX no reconocerá los cambios hasta que cierres la sesión y vuelvas a hacer login en AX.**

## humanReadable

Para que funcionen correctamente las funciones relacionadas con LLM (Large Language Models), antes hay que modificar los esquemas de módulos y páginas para incluir la propiedad `humanReadable: true` a todos los fields de tipo texto que queramos señalar como contenedores de información destinada a lectura humana. Esta propiedad solo es válida para los fields de tipo texto (si la pones en un campo que no sea de tipo texto, será ignorada), y si no se indica se considera como `false`.

Ejemplos: 

- `salesforceCode` sería un humanReadable: false, ya que es un contenido que no queremos traducir ni utilizar como contexto al hacer un resumen (podría generar resultados incorrectos o malinterpretaciones).
- `abstract` sería un humanReadable: true, porque es un contenido destinado a lectura humana que queremos poder traducir y usar como contexto del contenido real de la página.

Ejemplo de esquema:

```json
import { CLOUDINARY_BASE_UPLOAD_URL as CLOUDINARY_URL } from "@constants/cloudinary";

export default {
  schemaType: "component",
  displayName: "Basic Card",
  component: "BasicCard",
  dataPacks: null,
  configTabs: [
    {
      title: "content",
      fields: [
        {
          title: "Date",
          type: "DateField",
          hideable: true,
          key: "date",
          selectsRange: true,
        },
        {
          title: "Title",
          type: "HeadingField",
          key: "title",
          advanced: true,
          hideable: true,
          **humanReadable: true,**
          default: { tag: "h2", content: "Title" },
          options: [
            { value: "h1", label: "H1" },
            { value: "h2", label: "H2" },
            { value: "h3", label: "H3" },
            { value: "h4", label: "H4" },
            { value: "span", label: "span" },
          ],
        },
        {
          title: "Subtitle",
          type: "RichText",
          key: "subtitle",
          hideable: true,
          humanReadable: true,
        },
        {
          title: "Description",
          type: "RichText",
          html: true,
          key: "description",
          hideable: true,
          humanReadable: true,
        },
        {
          title: "Auxiliar Info",
          type: "TextField",
          key: "auxInfo",
          hideable: true,
          humanReadable: true,
        },
        {
          title: "Link",
          type: "ComponentContainer",
          whiteList: ["Link"],
          key: "link",
          hideable: true,
        },
        {
          title: "Secondary Link",
          type: "ComponentContainer",
          whiteList: ["Link"],
          key: "link2",
          hideable: true,
        },
        {
          title: "Media",
          type: "ComponentContainer",
          whiteList: ["LinkableImage", "Video"],
          key: "media",
          hideable: true,
          helptext: "Recommended minimum image size: 467x303",
        },
      ],
    },
  ],
  default: {
    component: "BasicCard",
    date: "",
    title: {
      content: "Title",
      tag: "h4",
    },
    subtitle: "Lorem ipsum",
    description:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi dignissim ut nibh eget porttitor. Nunc eleifend mollis arcu. ",
    auxInfo: "Auxiliar Information",
    link: {
      schema: "Link",
    },
    link2: {
      component: "Link",
    },
    media: {
      image: {
        component: "LinkableImage",
      },
      video: {
        component: "Video",
      },
    },
  },
  thumbnails: {
    "1x": `${CLOUDINARY_URL}/thumbnails/BasicCard`,
    "2x": `${CLOUDINARY_URL}/thumbnails/BasicCard@2x`,
  },
};
```javascript

## Funciones con inteligencia artificial

- `POST [/ai/summary/page](Pages eef7a0d621e848bb8ed18742ae7afa6a.md)`
🔑 Requiere **OpenAI** y **humanReadable**.
Analiza un esquema de página y devuelve el summary y keywords.
- `POS[T /translations/page/:targetLanguageId](Pages eef7a0d621e848bb8ed18742ae7afa6a.md)`
🔑 Requiere **DeepL** y **humanReadable**.
Analiza un esquema de página y devuelve el mismo esquema pero traducido al idioma target.
- [`POST /translations/structured_data_content/:targetLanguage`](Pages eef7a0d621e848bb8ed18742ae7afa6a.md)
    
    🔑 Requiere **DeepL** y **humanReadable**.
    Analiza un esquema de dato estructurado y devuelve el mismo esquema pero traducido al idioma target.
    

## Otras funcionalidades de inteligencia artificial

- En el DAM, que autoetiquete directamente las fotos requiere tener desplegada una infra con [unos permisos específicos](../../../Herramientas/DAM (Digital Asset Management)/Administradores de sistemas Infra de DAM/Permisos necesarios ec400901e9f646ecb27fa19fd9d124e3.md) y unas [variables de entorno](../../../Herramientas/DAM (Digital Asset Management)/Administradores de sistemas Infra de DAM/Variables de entorno 25d0cb76389041c58bd44251b5f0a226.md) (autotag, rekognitionRegion, rekognitionConfidence).

## Instancias con IA activa

| **Instancia** | **Claves 
(traducción y SEO description)** | **Auto-etiquetado** |
| --- | --- | --- |
| UCMA | DEV + PRE | DEV + PRE |
| IPAM | DEV + PRE | Inactivo |
| IADE | DEV + PRE | Inactivo |
| EEG | DEV + PRE | Inactivo |
| CEG | DEV + PRE | Inactivo |
| IE | DEV + PRE | DEV + PRE |
| COMILLAS | DEV + PRE + PRO | DEV + PRE + PRO |
| CUNEF | Inactivo | Inactivo |
| GRIDDO | DEV + PRE + PRO | DEV + PRE + PRO |
| SQY | DEV + PRE + PRO | DEV + PRE + PRO |
---

# Search

## `GET` /search

<aside>
💡 **Query**:
  searchQuery,
  page,
  languageId,
  siteId,
  template

</aside>
---

# Socials

## `GET`/socials/:social

🚨 **Permisos**: general.manageSocialMedia

<aside>
💡 **Params**:
    social
**Query:**
    ?id = el id de un social determinado
    ?account = el nombre de la cuenta

</aside>

Te devuelve un array de objetos con la información guardada en Base de Datos de cada una de las Socials

Puedes filtrar por `social` De momento solo se pueden usar ‘twitter’, ‘instagram’, ‘youtube’ o, si quieres que te devuelva todo, basta con poner `all` .

También puedes filtrar por el nombre de la cuenta estableciendo la query `account` o también por el `id` concreto de una red social.

## `POST`/socials/:social

🚨 **Permisos**: general.manageTokensSocialMedia

Sube a la base de datos la información relativa a una red social. En la petición del body deberemos especificar los siguientes campos:

```json
{
    "account": "Events",
    "token": "8P45Y9HT5EP89HT482937G42P973G432P84H28P4234B",
    "expiration_date": "2022-01-18 15:42:34"
}
```javascript

Y en los params, debemos especificar a que red social pertenecen estos campos usando `social` De momento solo están disponibles youtube, instagram y twitter.

## `PUT`/socials/:social/id/:id

🚨 **Permisos**: general.manageTokensSocialMedia

Actualiza en la base de datos la información relativa a una red social. En la petición del body deberemos especificar los siguientes campos:

```json
{
    "account": "Events",
    "token": "8P45Y9HT5EP89HT482937G42P973G432P84H28P4234B",
    "expiration_date": "2022-01-18 15:42:34"
}
```javascript

Y en los params, debemos especificar a que red social pertenecen estos campos usando `social` De momento solo están disponibles youtube, instagram y twitter.