# SEO y Social Share: Etiquetas meta de página para no técnicos

## Objetivo

La intención de este documento es explicar las distintas etiquetas que hay «normalmente» en el head de una página, especialmente las orientadas a SEO y Social Share, y el scope de cada una de ellas, para que se tenga en cuenta a la hora de elaborar el UX.

## Ejemplo sobre el que vamos a trabajar

```html
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="ie=edge" />
<meta name="description" content="Todo sobre El Club de los Pijamas en DT Espacio Escénico. Descúbrelo con Hoy Madrid, la app gratuita con toda la agenda de Madrid." />
<meta name="distribution" content="global" />
<meta name="resource-type" content="document" />
<link rel="canonical" href="https://agenda.hoymadrid.app/event/el-club-de-los-pijamas/_fe4cba64cd79217f96ab802e038ab62413420d82f5066855da51c22cf9cc0aa2" />
<meta property="og:title" content="El Club de los Pijamas" />
<meta property="og:site_name" content="Hoy Madrid" />
<meta property="og:image" content="https://aaejikqiro.cloudimg.io/v7/api.hoymadrid.app/imgs/cl/v1594798817__r2jnni9woj44ungnxvw4.jpg?w=800&h=450" />
<meta property="og:description" content="Todo sobre El Club de los Pijamas en DT Espacio Escénico. Descúbrelo con Hoy Madrid, la app gratuita con toda la agenda de Madrid." />
<meta property="og:type" content="website" />
<meta property="og:url" content="https://agenda.hoymadrid.app/event/el-club-de-los-pijamas/_fe4cba64cd79217f96ab802e038ab62413420d82f5066855da51c22cf9cc0aa2" />
<meta property="og:locale" content="es_ES" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:site" content="@HoyMadridApp" />
<meta prefix="fb: http://ogp.me/ns/fb#" property="fb:app_id" content="1823465757951900" />
<meta property="fb:admins" content="10156889513108985" />
<link rel="icon" type="image/png" href="/assets/favicon.png" sizes="32x32">
<link rel="icon" type="image/png" href="/assets/favicon-192x192.png" sizes="192x192" />
<title>El Club de los Pijamas - Madrid en Hoy Madrid</title>
<script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "Event",
            "name": "El Club de los Pijamas",
            "startDate": "2020-07-17",
            "endDate": "2020-07-17",
            "eventAttendanceMode": "https://schema.org/OfflineEventAttendanceMode",
            "eventStatus": "https://schema.org/EventScheduled",
            "location": {
                "@type": "Place",
                "name": "DT Espacio Escénico",
                "address": {
                    "@type": "PostalAddress",
                    "streetAddress": "C/ Reina 9",
                    "addressLocality": "Madrid ",
                    "addressRegion": "Madrid",
                    "addressCountry": "España"
                },
                "geo": {
                    "@type": "GeoCoordinates",
                    "latitude": 40.4204234,
                    "longitude": -3.7003037
                }
            },
            "image": [
                "https://aaejikqiro.cloudimg.io/v7/api.hoymadrid.app/imgs/cl/v1594798817__r2jnni9woj44ungnxvw4.jpg?w=800&h=450"
            ],
            
            "offers": {
                "@type": "Offer",
                "url": "https://agenda.hoymadrid.app/event/2020-07-17-f1f869e4c058744adcf362d70e907cbc900b5e1c1ec1f778a6b4cec10ce693ce.html",
                "itemCondition": "Reserva ahora desde Hoy Madrid y obtén un descuento inmediato en tu entrada.",
                "availability": "https://schema.org/InStock",
                "validFrom": "2020-06-07",
                "price": "10",
                "priceCurrency": "EUR"
            },
            "description": "Por Arantxa Castilla La Mancha & Diamante Merybrown

Amigas Cheetas, pactos ocultos, pelucas prohibidas y mucho mas!

Felicidades, esta es tu invitación oficial para unirte a El Club de los Pijamas de Arantxa Castilla-La Mancha y Diamante Merybrown.  ¿Echas de menos aquellas veladas con tus amigas en las que la noche no parecía terminar? Entonces deja la timidez y la vergüenza en casa y ven a pasar con nosotras una pijamada inolvidable en la que hablaremos de chicos, peinaremos nuestras pelucas, haremos un poco de brujería y veremos nuestras películas favoritas.

Un evento único que combina lo mejor de los dos mundos. un show que te ofrece un humor irresistible, coreografías impactantes y momentos inolvidables. ¿Te lo vas a perder?

Fecha: Viernes 17 de julio
Hora: 20:00 y 22:00"
        }
        </script>
```

## Sin repercusión, están porque sí

**Aplicable a nivel de SITE.**

```html
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="ie=edge" />
<meta name="distribution" content="global" />
<meta name="resource-type" content="document" />
```

Etiquetas que tienen que ir pero no tendrían que ser configurables. Se define la codificación del texto, el viewport, compatibilidades, tipo de recurso (esto tal vez se quiera adaptar luego, pero iría definido en la propia template), el tipo de distribución...

Igualmente hay una etiqueta para definir si el contenido es indexable o no, pero se creará automáticamente en función de la configuración de página.

## Favicon

**Aplicable a nivel de SITE.**

```html
<link rel="icon" type="image/png" href="/assets/favicon.png" sizes="32x32">
<link rel="icon" type="image/png" href="/assets/favicon-192x192.png" sizes="192x192" />
```

No necesita mayor explicación, son los favicons. Se pueden definir con más y menos resoluciones, que se pueden gestionar con Cloudinary directamente desde código, e incluso se pueden especificar iconos específicos para cuando se crea un acceso directo en Android o iOS, pero «normalmente» acaba siendo la misma imagen en distintos tamaños (lo de normalmente entre comillas porque si se quiere no tiene por qué ser así).

## Canonical

**Aplicable a nivel de PÁGINA.**

```html
<link rel="canonical" href="https://agenda.hoymadrid.app/event/el-club-de-los-pijamas/_fe4cba64cd79217f96ab802e038ab62413420d82f5066855da51c22cf9cc0aa2" />
```

Define, para distintas páginas con el mismo contenido, cuál es la que manda a nivel de posicionamiento. Griddo identifica automáticamente cuál es la página canonical, por lo que no debería ser editable.

## Básicas

**Aplicable a nivel de PÁGINA.**

```html
<title>El Club de los Pijamas - Madrid en Hoy Madrid</title>
<meta name="description" content="Todo sobre El Club de los Pijamas en DT Espacio Escénico. Descúbrelo con Hoy Madrid, la app gratuita con toda la agenda de Madrid." />
```

Definen el título y la descripción de la página. Es lo que usará Google. Ojo, porque Google no siempre usa el description, de hecho creo que actualmente no la usa casi nunca.

## Open Graph

**Aplicable a nivel de PÁGINA.**

```html
<meta property="og:title" content="El Club de los Pijamas" />
<meta property="og:site_name" content="Hoy Madrid" />
<meta property="og:image" content="https://aaejikqiro.cloudimg.io/v7/api.hoymadrid.app/imgs/cl/v1594798817__r2jnni9woj44ungnxvw4.jpg?w=800&h=450" />
<meta property="og:description" content="Todo sobre El Club de los Pijamas en DT Espacio Escénico. Descúbrelo con Hoy Madrid, la app gratuita con toda la agenda de Madrid." />
<meta property="og:type" content="website" />
<meta property="og:url" content="https://agenda.hoymadrid.app/event/el-club-de-los-pijamas/_fe4cba64cd79217f96ab802e038ab62413420d82f5066855da51c22cf9cc0aa2" />
<meta property="og:locale" content="es_ES" />
```

Definimos las siguientes etiquetas de Open Graph, que serían usadas por Facebook principalmente, aunque ahora Twitter también las reconoce.

- **Title** es el título de la página.
- **Site_name** sería el título del sitio (creo que podria ser directamente el nombre con el que estamos gestionando el propio site)
- **Image** es la imagen que está asociada como representativa de la página. Cuidado con esto, porque Facebook no dice nada al respecto, pero Twitter advierte que no le mola nada que se use la misma imagen para todas las páginas (aunque la última vez que lo vi no especificaba consecuencias de ignorar la advertencia).
- **Description** (de la página).
- **Type** en principio se suele usar website, se puede utilizar otros tipos que podrían ir definidos en la propia template, aunque no conozco las consecuencias de usar otros valores, ya que en teoría es solo para mostrar en enlace «bonito» en Facebook.
- **Url** no debería ser editable: es lo que es.
- **Locale** debería extraerse del propio idioma usado en esa página.

En realidad, salvo imagen, todas las demás etiquetas se pueden inferir de la propia configuración de página, site e idioma... salvo que por alguna razón se quiera utilizar diferentes títulos y descripciones en Facebook.

## Facebook

**Aplicable a nivel de SITE.**

```html
<meta prefix="fb: http://ogp.me/ns/fb#" property="fb:app_id" content="1823465757951900" />
<meta property="fb:admins" content="10156889513108985" />
```

Facebook utiliza las etiquetas de Open Graph indicadas en el apartado anterior (que son a nivel de página), más estas otras (que son a nivel de site):

- **fb:app_id** es el identificador de la app del sitio en Facebook, que generalmente a su vez está asociado a la página en Facebook del sitio. Es a nivel de site, y tampoco es que sea muy necesario si no se van a usar determinados módulos de Facebook. Por ejemplo, en esta página se especifica porque la página permite comentar los posts del blog utilizando el componente de Facebook.
- **fb:admins** es uno o varios identificadores separados por comas, que indican qué perfiles de Facebook pueden administrar esa cuenta. En este caso concreto, el usuario con ese id es el único que puede por ejemplo moderar los comentarios que se pongan en esa página utilizando Facebook.

Pueden parecer innecesarias (en muchos casos lo son), pero a Facebook no le gusta que una página con Open Graph no los indique (el validador de Open Graph de Facebook saca un error si no indicas como mínimo el app_id). Soy consciente de que es la segunda vez que digo que algo «no le gusta» a una red social y lo ambiguo que esto resulta, pero es así: las redes son totalmente opacas, te avisan de cosas que les gustan y cosas que no, pero muchas veces no dejan claras las consecuencias, y lo mismo no hay consecuencias que de repente sí las hay a nivel de visibilidad que de la noche a la mañana deciden que está deprecated y que eso ya es indiferente o que incluso mejor lo quites.

## Twitter

**Aplicable a nivel de SITE.**

```html
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:site" content="@HoyMadridApp" />
```

Twitter requiere estas dos etiquetas:

- **card** indica el formato que tendrá la card. En el ejemplo es imagen grande y texto debajo, pero existe la opción de imagen pequeña y texto a la derecha.
- **site** indica la cuenta de Twitter del site o la que se va a referenciar como propietaria del contenido.

**Aplicable a nivel de PÁGINA.**

En este ejemplo no están, pero se puede especificar un título y una descripción aparte e independiente solo para su uso en Twitter. Si no se especifica, como es el caso, utilizará los datos de Open Graph indicados antes.

## Datos estructurados de Google

**Aplicable a nivel de PÁGINA.**

```json
<script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "Event",
            "name": "El Club de los Pijamas",
            "startDate": "2020-07-17",
            "endDate": "2020-07-17",
            "eventAttendanceMode": "https://schema.org/OfflineEventAttendanceMode",
            "eventStatus": "https://schema.org/EventScheduled",
            "location": {
                "@type": "Place",
                "name": "DT Espacio Escénico",
                "address": {
                    "@type": "PostalAddress",
                    "streetAddress": "C/ Reina 9",
                    "addressLocality": "Madrid ",
                    "addressRegion": "Madrid",
                    "addressCountry": "España"
                },
                "geo": {
                    "@type": "GeoCoordinates",
                    "latitude": 40.4204234,
                    "longitude": -3.7003037
                }
            },
            "image": [
                "https://aaejikqiro.cloudimg.io/v7/api.hoymadrid.app/imgs/cl/v1594798817__r2jnni9woj44ungnxvw4.jpg?w=800&h=450"
            ],
            
            "offers": {
                "@type": "Offer",
                "url": "https://agenda.hoymadrid.app/event/2020-07-17-f1f869e4c058744adcf362d70e907cbc900b5e1c1ec1f778a6b4cec10ce693ce.html",
                "itemCondition": "Reserva ahora desde Hoy Madrid y obtén un descuento inmediato en tu entrada.",
                "availability": "https://schema.org/InStock",
                "validFrom": "2020-06-07",
                "price": "10",
                "priceCurrency": "EUR"
            },
            "description": "Por Arantxa Castilla La Mancha & Diamante Merybrown

Amigas Cheetas, pactos ocultos, pelucas prohibidas y mucho mas!

Felicidades, esta es tu invitación oficial para unirte a El Club de los Pijamas de Arantxa Castilla-La Mancha y Diamante Merybrown.  ¿Echas de menos aquellas veladas con tus amigas en las que la noche no parecía terminar? Entonces deja la timidez y la vergüenza en casa y ven a pasar con nosotras una pijamada inolvidable en la que hablaremos de chicos, peinaremos nuestras pelucas, haremos un poco de brujería y veremos nuestras películas favoritas.

Un evento único que combina lo mejor de los dos mundos. un show que te ofrece un humor irresistible, coreografías impactantes y momentos inolvidables. ¿Te lo vas a perder?

Fecha: Viernes 17 de julio
Hora: 20:00 y 22:00"
        }
</script>
```

### ¿Qué es un dato estructurado?

Un dato estructurado es un dato que se descompone en distintas unidades de información que siguen una estructura. Por ejemplo, el dato estructurado «Persona» se podría corresponde con un equema de Nombre, Apellido y Fecha de nacimiento. Es un concepto técnico que se usa desde tiempos ancestrales. Por ejemplo, una base de datos SQL es un conjunto de datos estructurados y relaciones entre ellos.

En Griddo definimos distintos datos estructurados en función de las necesidades de cada cliente, e igualmente permitimos que estén relacionados entre ellos. Cuando se trata de datos estructurados puros, definimos exactamente el esquema que queremos y el usuario tiene un formulario para añadirlos. Cuando son datos estructurados desde página, también definimos un esquema, pero en este caso habrá partes del dato que extraemos de la propia información de la página (por ejemplo, el título) y partes que no se podrá extraer y habrá que pedir explícitamente al crear la página (por ejemplo, la ubicación en coordenadas de un evento).

### ¿Qué es un dato estructurado de Google?

En realidad los datos estructurados de Google son una forma de representar y transmitir datos estructurados. A nivel de MKT y diseño se confunde datos estructurados con datos estructurados de Google porque con lo que trabajan es con Google y no con la gestión de datos.

### ¿En qué formas se puede definir un dato estructurado de Google?

Se puede definir embebido en el texto (no recomendable, confuso y caótico), en plan insertar desperdigadas distintas etiquetas para aclarar dentro del texto qué parte se corresponde a qué unidad de información, o se puede utilizar un esquema JSON+LD como el indicado en el ejemplo (que es la forma más correcta).

En el esquema vemos que se está definiendo el tipo de dato "Event" y una serie de información que compone el dato estructurado de ese evento.

### ¿Cualquier página puede tener un esquema de dato estructurado de Google?

No.

Los esquemas de datos estructurados de Google son diferentes según el tipo de dato que se quiere transmitir. No todas las páginas encajan en un tipo de dato que esté definido. Por ejemplo, están definidos esquemas para eventos, personas, lugares, empresas, recetas, libros, películas... Cada una de esas definiciones tiene un esquema diferente con información diferente, ya que un evento se define a través de información (dónde, cuándo...) diferente a la que define un libro (isbn, tipo de cubierta, tamaño, páginas...). Pero por ejemplo no existe un esquema para animales (creo que no). No podemos inventarnos esquemas, porque los esquemas tienen que estar estandarizados, ya que su funcionalidad es que una máquina pueda ver nuestra página y entender la información que contiene porque está definida en un esquema que está estandarizado, es público y conoce.

Los esquemas disponibles para datos estructurados de Google están definidos en Schema.org

Nota al margen: Google no reconoce todos los esquemas de Schema.org, solo algunos.

### ¿Cómo gestionamos en Griddo los datos estructurados de Google?

En esencia, los datos estructurados de Google de una página salen de los datos estructurados que hemos generado para esa página. 

Como se ha dicho al principio, los datos estructurados de página se componen de información que extraemos de la propia página (como por ejemplo el título), pero también de información que podemos tener que preguntar explícitamente al usuario al crear la página porque la necesitamos para poder componer posteriormente ese dato estructurado de Google pero no está en la página o no lo está de una manera que podamos procesarla correctamente.
