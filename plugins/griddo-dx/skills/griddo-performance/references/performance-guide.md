# Guía Completa de Optimización de Rendimiento en Griddo

## Core Web Vitals

Optimiza las Core Web Vitals (CWV) de tu instancia Griddo. Esta guía cubre técnicas para mejorar el rendimiento.

### Reducir el bundle

- Analiza el bundle con el plugin de Gatsby `gatsby-plugin-webpack-bundle-analyser-v2`
- Elimina todos los `imports` que no sean necesarios en el bundle final. Es muy fácil estar importando por ejemplo una función de un archivo `helpers.js` y que este tenga a su vez `imports` innecesarios para la web (un json, schemas, etc..) y que acabarán en el bundle final.
- Monitoriza los paquetes que instales. Por ejemplo `react-markdown` cuesta **40k** vs `markdown-to-jsx` que cuesta **17K**. Sin con el último tenemos suficiente estaremos ahorrando **23K** de javascript al bundle. Es recomendable utilizar alguna extensión de tu editor de código como [import cost](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost) para VSCode o herramientas online como [bundlephobia.com](https://bundlephobia.com/)
- Si se usa la biblioteca de iconos del starter. Incluid solo los iconos que se usen en el site. Es fácil meter la biblioteca de 500 iconos por defecto, acabando con muchísimos K's innecesarios en el bundle.
- Ojo con los **svgs**, depende de cómo estén construidos pueden pesar muchísimo.

### Scripts y CSS en el `builder.ssr.js`

En el archivo `builder.ssr.js` podemos añadir componentes `<scripts>`, `<links>`, etc.. para que se inyecten en el build de todas las páginas.

#### Scripts

Siempre que se pueda añade `async` y/o `defer` en los scripts inline para evitar el bloqueo con la carga. Si es posible, añade el código de los scripts en el propio repo (inline) en lugar de usar un link a un CDN.

#### CSS (usando loadCSS)

Este apartado lo podemos utilizar para cargar de manera diferida **CSS** que no necesitemos descargar de manera inmediata. Por ejemplo tipografías auto-alojadas podemos retrasar su carga para que no bloqueen el proceso principal.

Los archivos de css, tipografías, etc.. deberán estar alojados en la carpeta `/static` del repositorio.

Para retrasar la carga de CSS no crítico utiliza el script `loadCSS`. En el starter ya se está usando para cargar las `webfonts.css`.

#### CSS Inline y Google CWV

También tiene sentido añadir css que utilizamos en todas las páginas como los típicos `reset.css`, `normalize.css` etc. Siendo mejor para el usuario porque esos archivos se cachearan, las CWV dan un warning comunicando que metamos los links de manera inline para evitar consultas.

Para meterlos de manera inline solo tenemos que importar los css en el archivo `/src/adapters/index.js`.

### Tipografías

- Preferible `woff2` para las tipografías sobre `ttf` o `woff`.
- Aloja las tipografías en la propia instancia en lugar de usar un CDN (google fonts, etc.). Esto reduce las conexiones y el tiempo de bloqueo.
- Utiliza el set más pequeño que puedas de caracteres. Si tu página está en "latin-language" no uses caracteres "Cyrilic" o "Greek".

### Imágenes

#### Formato adecuado

`<CloudinaryImage>` y `<GriddoImage>` se encargan de ello. Ojo con el format avif que puede llegar a ser un 50% más pesado de procesar por la CPU.

#### Tamaños para `srcSet`

Cuando establezcamos los tamaños de imagen con la propiedad `responsive` del componente **GriddoImage** debemos tener en cuenta que será el navegador, y no nosotros, quien seleccione uno de los tamaños.

El navegador no siempre va a seleccionar la imagen que esperamos. La diferencia entre tamaños influye mucho en esta decisión. Si el navegador tiene dos imágenes para elegir de **400px** y **600px**, es posible que elija la de **600px** aunque esté en la situación de elegir la de **400px**.

#### Inline vs Background

Siempre que se pueda usar **imágenes inline `<img>`** en lugar de **background en CSS**. Ganaremos features nativas:

- Formatos modernos con fallbacks
- loading (lazy, eager, etc..)
- decoding
- fetchPriority
- size/srcset

Las imágenes `<img>` el navegador las descubre "instantáneamente" mientras que las de background se descubren cuando el CSS se ha descargado, resultando en un **First Contentful Paint FCP** más rápido. Para utilizarlas de "background" se puede acudir a `object-fit: cover`.

#### Configuración genérica

- Tamaños adecuados y responsive.
- Compresión de la imagen (quality)
- Lazy loading imágenes below the fold.
- `auto` o `eager` loading en imágenes importantes (Heros, etc..)

#### Ratios

- Siempre que se pueda especifica el ancho y el alto de la imagen para evitar CLS
- En imágenes responsive establece un ratio común para todos los tamaños para guardar espacio mientras las imágenes se cargan

#### Prioridad de carga para mejorar el LCP

Usa `fetchpriority="high"` en un `<GriddoImage>` o en un `<img>` para priorizar la descarga sobre otros recursos.

Usa `fetchpriority="low"` para hacer lo contrario, esto puede ser útil para dejar más espacio a las prioridades altas.

**Nota:** `fetchpriority` funciona en `<img>, <script>, <link>` e `<iframe>` aunque es experimental y solo en **Google Chrome** y **Edge**.

### Carga de assets

En ciertas ocasiones nos puede venir bien cargar imágenes de forma estática cuando son imágenes que van en el propio componente y no son de usuario del editor.

Si tenemos en la carpeta del repo `/static/my-image.png` podremos poner:

```jsx
<img src='/my-image' />
```

Un caso de uso puede ser tener un set de iconos svg con banderas de todo el mundo que vamos a usar en un `<select>`.

### React lazy

Importar los componentes y módulos utilizando React.lazy en lugar del import normal para dividir el bundle en archivos que se cargan solo cuando se necesitan:

```jsx
const Module = React.lazy(() => import('./Module'))
```

### Recursos

- [Snippets para las CWV](https://webperf-snippets.nucliweb.net/)
- [Fetch Priority](https://addyosmani.com/blog/fetch-priority/)

---

## Optimiza el rendimiento de tu instancia

Es muy importante optimizar la instancia para obtener buenos valores en términos de rendimiento y eficiencia, ya que repercuten tanto en la experiencia de usuario como en la propia experiencia nuestra al desarrollar y en el posicionamiento.

En este doc vamos a revisar algunos errores comunes y cómo solucionarlos. Algunos de ellos ni siquiera son errores, simplemente son formas que específicamente en Griddo no son las más eficientes pero tienen una alternativa que sí lo es.

### Elige cuidadosamente la hora a que lanzas tus procesos de importación

Soluciona:
- Tiempos de renderizado

Si puedes hacer que los scripts de importación se ejecuten cuando el proceso de render está desactivado (por la noche), la importación será más rápida (porque no compartes recursos con otros procesos) y no estaréis forzando renders en cadena (que empiece un render cuando aún estáis metiendo cambios, lo cual provoca que según termine el render tendrá que empezar otro).

De esta manera, cuando se ejecute el primer render por la mañana, ese único render actualizará todas las páginas con lo que hayas importado durante la noche.

Ese primer render será más lento porque tiene que rehacer todos los distribuidores. Pero si esos datos solo se tocan desde el proceso de importación, una vez se haya hecho el primer render, ya todos los demás renders serán más rápidos (a partir de la release 10.6.14).

### Siempre que puedas, usa API Pública

Soluciona:
- Tiempos de renderizado
- CWV

Usar distribuidores para que la página tenga directamente toda la información desde el principio es muy cómodo, pero no siempre es lo más conveniente. Estos distribuidores van a hacer que se tarde más en renderizar la página pero también van a generar páginas más pesadas que van a repercutir en peores tiempos de render.

La mayoría de las veces no vas a necesitar tener los datos precargados. Especialmente usa la api pública para obtener los datos cuando:

- Los datos que te quieres traer no son necesarios para presentar la información básica de la página en primera pantalla sin scroll.
- Los datos que te quieres traer tienen mucho peso (más de 10kb, por ejemplo).

Por ejemplo, si a mitad de página se va a presentar un módulo de "Noticias recientes", no necesitas para nada tener cargadas esas noticias en la página, te las puedes traer cuando ya se ha cargado la página con la api pública.

Como regla general, salvo que imperativamente los datos del distribuidor deban existir desde el momento 0 en la página (que es casi nunca, porque raro es que tenga que ser en el segundo 0 y no valga el segundo 0.2) usa api pública.

Para comprobar que no estás cargando los datos en la página y que vienen desde la api pública, en el inspector de red examina qué información recibes en el page-data.json de esa página. Si ves que te está rellenando la información del distribuidor en el page-data.json, seguramente sea porque tienes activado hasDistributorData: true, en cuyo caso el proceso de renderizado añadirá la propiedad queriedItems con todos los datos. Tener ese hasDistributorData en true hace que en el proceso de renderizado se haga una consulta a la api para traerse los datos y todos esos datos vayan en la página, aumentando su peso y tiempo de renderizado; algo que no necesitas si te estás trayendo los datos de api pública y paginados.

Recomendación 1: usa spinners o cualquier estado de "Loading" para mostrar que hay una información que se está trayendo y que se actualizará esa sección de la página cuando te terminen de llegar los datos.

Recomendación 2: sopesa tener un módulo de React que reciba como parámetros el hook que se trae los datos (o incluso el data del distribuidor) y el módulo que los dibuja, y que ese modulo se encargue de dibujar el spinner mientras no tenga datos y cuando tenga datos mostrar el módulo que los dibuja pasándole los datos.

Recomendación 3: no lo he testeado en real, pero es posible que si esa información que te traes de api pública te esperas 3 segundos a traértela (no siempre se puede, pero a lo mejor en algún caso sí se puede porque va muy abajo en la página, por ejemplo), también mejores los CWV. Aunque no lo he verificado. Es solo una sospecha.

### Limita siempre la cantidad de datos que te traes

Soluciona:
- Tiempos de renderizado
- CWV

En todos los distribuidores que uses, pon siempre un límite de elementos.

No tiene sentido que si un modulo va a dibujar un máximo de 6 elementos se le puedan seleccionar 200. Ni mucho menos estar cargando en la página esos 200 elementos, con todo lo que supone para el peso de la página y los tiempos de renderizado.

Es un despiste muy común no dejar configurado en los esquemas un límite en los resultados. Intenta que no te pase porque ha habido casos de tiempos de renderizado disparatados por culpa de esto, ya que el editor a la mínima selecciona "todos los resultados".

Incluso cuando la cantidad de elementos es potencialmente ilimitada, ponle igualmente un límite razonable. Si la cantidad de elementos debe poder ser todos los elementos, salvo que esa cantidad de elementos esté muy limitada y estés seguro de que siempre va a estar limitada, haz que esos datos vengan de api pública, con campos limitados, y sobre todo paginados.

### Usa la caché de API Pública y campos limitados

Soluciona:
- Tiempos de renderizado
- CWV

La api pública usa un sistema de caché. Esto hace que si dos usuarios hacen la misma llamada al mismo endpoint de api pública, en realidad solo se ejecute contra el servidor la primera y las siguientes estén cacheadas durante un pequeño tiempo. Para que funcione la caché, la llamada a la api pública debe ser consistente, es decir, exactamente igual y en el mismo orden de parámetros (si usas el hook de Core, el orden de elementos siempre será el mismo).

Recuerda que algunas peticiones a la api pública te permiten obtener solo los campos que necesites. Es decir, si tienes un dato estructurado que cada elemento tiene 20 propiedades y pesa en total unos 10k por dato, a lo mejor solo necesitas una de las propiedades que pesa solo unos bytes, por lo que la respuesta será mucho más rápida si solo te traes lo que necesites.

### Usa paginación real

Soluciona:
- Tiempos de renderizado
- CWV

La paginación existe desde los principios de los tiempos para evitar listados demasiado pesados. No tiene sentido usar paginación "solo visual", es decir, solo se ve la primera página de resultados, pero en realidad te has descargado desde el principio todos los datos.

Aparte de que los datos tienen que venir de api pública (como mucho te das el lujo de traerte los datos de la primera página de resultados), tienes que ir pidiendo a la api pública solo los datos que necesites y solo para la página que vas a añadir.

Si algo va paginado, nunca nos descargamos todos los datos del tirón, como mucho nos traemos los datos de esa página, y siempre que podamos los datos nos los traemos de api pública.

### No uses mode:list si no lo vas a usar de verdad

Soluciona:
- Tiempos de renderizado

Si tienes una template de tipo listado con mode:list, se creará una réplica de esa página para cada una de las páginas de resultados (news/2, news/3, news/4…). Si al final vas a utilizar paginación real con api pública, todo esto te sobraría. Simplemente con no usar el mode:list vas a evitar en el proceso de renderizado que se creen un montón de páginas que ni siquiera vas a usar. Si tienes por ejemplo 5.000 noticias y tienes una template de listado con mode:list y un paginado de 10 noticias por página, te podrías ahorrar la creación de 500 páginas. Eso es tiempo que ahorras en el renderizado pero también en la subida de páginas, y pueden ser minutos de mejora.

Mode:list es solo para hacer un paginado estático sin filtros. Hoy en día casi ningún cliente requiere de esto. No lo hagas si no lo necesitas específicamente (e incluso si lo necesitas, plantéate si no se puede hacer de otra manera con api pública).

Nota: si encima la template de listado tiene un distribuidor extra, el ahorro en tiempo de transferencia y renderizado solo por usar paginado con api pública y quitar el mode:list puede ser brutal.

### Usa datos estructurados limpios

Soluciona:
- Tiempos de renderizado
- CWV
- Carga del sistema

Un dato estructurado debe servir para tener la información que necesitamos como dato en otros procesos y para ello es básico que solo contenga la información que necesitamos y esté bien organizado. Si hacemos que el dato contenga secciones enteras de la página, vamos a tener varios problemas porque vamos a manejar datos muy pesados que van a hacer páginas muy pesadas y difíciles para implementar tanto relaciones especiales como el uso de campos limitados.

Si necesitas acceder a un dato que está dentro de un modulo que está dentro de un contenedor que está dentro de una sección, es preferible que te crees en el dato estructurado una propiedad específica para ese dato en concreto, y que su valor se obtenga a través de un computed.

No te traigas la sección entera al dato. No solo vas a tener el dato mucho más limpio, es que vas a poder filtrar más cómodamente y ver mejor los datos que manejas y será mucho más rápido tanto en carga de sistema como en tiempos de renderizado y peso de la página.

### Gestiona correctamente las relaciones en los datos

Soluciona:
- Tiempos de respuesta
- Tiempos de renderizado
- CWV

Siempre que puedas, establece las propiedades susceptibles de ser filtros como relaciones con otros datos estructurados o categorías. De esta manera podrás usar todas las herramientas de api pública relacionadas con filtros.

A veces el cliente cambia de criterio y eso supone aplicar como filtro cosas que antes no lo eran. Aunque duela, invertir tiempo en replantear los esquemas para que esos filtros sean relaciones entre datos al final va a suponer mejores tiempos y mejor performance.

### Cuidado al importar datos externos

Soluciona:
- Información basura
- Información duplicada
- Carga del sistema

Cuando importas datos externos, ten mucho cuidado con cómo gestionas el proceso. En concreto, asegúrate de no importar información duplicada, borrar la información que ha expirado, y en las cosas que hayas mapeado mantener la consistencia de lo que has hecho.

Ten especial cuidado con las imágenes, si una imagen xxx.jpg la has subido ya al sistema y la nueva url en el dam es xxx_25.jpg, cada vez que te encuentres la imagen xxx.jpg la tienes que mapear siempre a xxx_25.jpg y no estar subiendo xxx_26, xxx_27, xxx_28…

Recuerda que para mantener esa consistencia tienes unos endpoints de persistencia que te va a permitir "recordar" qué cosas hiciste en el pasado. Por ejemplo, cada vez que mapeas una imagen te permite recordar qué nombre le corresponde a esa url de imagen original dentro de nuestro dam, y así si ves que la imagen ya la has procesado asignarle directamente el nombre de nuestro dam directamente en lugar de subir una imagen nueva.

La ventaja del endpoint de persistencia es que antes esto lo hacíais con ficheros json que generábais localmente, pero esos ficheros desaparecían si se cambiaba de máquina y no era coherente, con estos endpoints sí vais a mantener la coherencia dentro de cada entorno con independencia de dónde se ejecute realmente.

---

## Estado con React y Render

### Uso del `useState` y `useEffect`

Cuando Griddo hace un build intenta generar un HTML lo más completo posible. En una situación ideal el archivo HTML de la página contendrá el 100% de la estructura HTML, contenido y css necesario.

Sin embargo si utilizamos el estado en un módulo cabe la posibilidad que Griddo no genere nada del componente en cuestión en el momento del build y espere a la ejecución en local (runtime) para hidratar el contenido, leer el estado y ya generar la parte que resta del HTML. Esto puede impactar el CLS y FPC entre otros.

Resumiendo: Si el estado afecta a lo que se renderiza y no tiene un valor por defecto, el HTML estará vacío.

### Más sobre useEffect en Griddo

**TL; DR; I**

Si el comportamiento que estás manejando con un **useEffect** se comparte por más de un módulo, haz un **custom hook** y encapsúlalo, si no, también. El componente en será más sencillo de leer, entender y utilizar.

**TL; DR; II**

**useEffect** no funciona en el proceso de construcción de páginas de Griddo, solo en el navegador. Si el **useEffect** está condicionando el render de un componente, el HTML saldrá vacío y no quieres eso.

### useEffect, tú antes molabas

Y lo sigue haciendo. Pero es muy fácil apoyarse rápidamente en él y casi sin darnos cuenta acabar escribiendo demasiada lógica dentro. Además suele ir de la mano con **useState**, acabando todo en una mixtura difícil de entender. Así que antes de que se te vayan los dedos y te pongas a escribir tu magnífico **useEffect**, levántate, muévete y piensa en ello.

### No lo uses

Por aquí iremos rápido.

No, no siempre es necesarios utilizarlo, así que si vas de cabeza a por él, haz una pausa y de nuevo piensa si puedes evitarlo.

### Escóndelo

Lo he adelantado antes, pero diré más. Si el useEffect no va a compartirse con otros componentes y está escrito para un módulo en concreto, también deberías convertirlo en un custom hook. En ese caso puedes dejarlo en el mismo archivo del componente, indicando así de forma implícita que ese hook es solo para ese módulo.

#### Ejemplo

Esto:

```tsx
function Module({ data }) {
	const [dataWithLinks, setDataWithLinks] = React.useState()
  const [helperState, setHelperState] = React.useState()

	// Probablemente ese use effect sea muuuucho más largo y además no esté solo.
	React.useEffect(() => {
		// ...
		setHelperState({...})
		if(deps) {
			// ...
			const dataWithLinksInfo = someFunc(Data, helperState)
			setDataWithLinks(dataWithLinksInfo)
		}
	}, [deps])

	return <div>{dataWithLinks}</div>
}
```

Se convierte en esto:

```tsx
import { useDataWithLinks } from "@hooks"

function Module({ data }) {
	const dataWithLinks = useDataWithLinks(data)

	return <div>{dataWithLinks}</div>
}
```

Como se aprecia no se trata de eliminar código ni optimizarlo en sí, es más, probablemente tengas que escribir más para adaptar un poco el custom hook. La intención que perseguimos es mejorar la legibilidad y uso del componente encapsulando y sacando fuera la lógica dejando el componente lo más "**presentational"** posible.

### useEffect en Griddo

Griddo construye las páginas en un entorno node utilizando **SSR** (Server Side Rendering). Y aquí viene un dato importante: **useEffect no se ejecuta en el SSR** (esto también es válido para **componentDidMount**, **componentDidUpdate** y **componentWillUnmount**)

useEffect se ejecuta, como mínimo después del primer render. En un entorno SSR **el primer render** ocurre cuando el componente **ya se ha convertido a HTML**, con lo que ya es tarde. Así que tendrá que esperar a la *rehidratación* en el navegador.

### useEffect + useState

Algo bastante común es utilizar useEffect para modificar el estado con useState. Como ya sabemos que useEffect no se ejecuta en el build-time, no lo hará tampoco el estado.

### ¿Cómo afecta a Griddo?

Si tu useEffect está condicionando el render de un componente, como ya sabes, en el proceso de build este no se va a ejecutar y por lo tanto no habrá *efecto* sobre el render y muy probablemente el HTML estático que representa al componente quedará "vacío". Tendrá que esperar a ejecutarse en el navegador en el proceso de *rehidratación* para que se visualice correctamente.

Esto que en una primera instancia "es correcto", (finalmente el contenido aparece en el navegador) en realidad no lo es. Estamos perdiendo la oportunidad de dejar en el proceso de build el HTML del componente ya renderizado, postergándolo al momento de la *rehidratación* y experimentando con ello:

- **Movimientos y parpadeos**. Afecta a la experiencia de usuario y las Core Web Vitals en la métrica [Cumulative Layout Shift (CLS)](https://web.dev/cls/)
- **Rendimiento pobre en general**. La parte que estaba vacía y necesita renderizarse lo tiene que hacer ahora con javascript sí o sí. Afectando a UX y CWV a varias métricas.
- **Contenido vacío**. Por mucha literatura que exista argumentando lo contrario, **lo más seguro hoy en día** para que los robots lean el contenido es que ya esté en el HTML.

---

## Carga optimizada de tipografías

Optimiza cómo cargas las tipografías en tu instancia Griddo para mejorar el rendimiento.

### Retrasa la carga del CSS para web-fonts auto-alojadas

Lo más probable es que las web-fonts no sean críticas para la visualización de la página de cara a las Core Web Vitals. Por lo tanto podemos retrasar su carga sacando la carga del CSS del hilo principal.

#### Paso 1: Alojar en /static

Aloja el CSS y sus archivos de fuentes en la carpeta `/static` de manera que todo estará accesible accediendo al path root:

```
/static
 |-webfonts.css
 |-fonts
   |-font.woff2
```

#### Paso 2: Usar builder.ssr.js

En el archivo `builder.ssr.js` escribe una etiqueta `<link>` para acceder al CSS:

```tsx
const griddoWebfonts = (
	<link
		rel="preload"
		href="/webfonts.css"
		as="style"
		// This id is required in order to use it later in the `builder.browser.js`
		id="griddo-webfonts"
		crossOrigin
		// This onload only works on Griddo Editor (AX)
		// The code to trigger the onload for the build phase (CX) is the builder.browser.js
		onLoad="this.onload=null;this.rel='stylesheet'"
	/>
);
```

Necesitamos también añadir este código a `builder.browser.js` para que haga el cambio en el `onLoad` cuando visitemos la página:

```tsx
const onClientEntry = () => {
	const griddoWebfonts = document.getElementById("griddo-webfonts");

	if (griddoWebfonts) {
		griddoWebfonts.setAttribute("rel", "stylesheet");
	}
};

export default {
	onClientEntry,
};
```

### Tipografías en el Editor vs. Web publicada

El editor de Griddo (AX) solo soporta `onRenderBody` para incluir elementos en el `<head>` y en el `<body>`. Por lo tanto, con `onRenderBody` nos vale para todo lo que se quiera incluir para el editor.

Si por ejemplo se añade la carga de las tipografías en `onPreRenderHTML` que tiene casi la misma funcionalidad pero se ejecuta en otro ciclo dentro del render de Gatsby, las tipografías no se verán en el editor, porque no soporta este ciclo.

#### Solución: usar onRenderBody con pathname

Mantén la carga de tipografías en `onPreRenderHTML` para la web pública y añade también la carga en `onRenderBody` usando el pathname de AX. Solo se cargará en AX, Gatsby lo ignorará y usará el que tiene en `onPreRenderHTML`:

```jsx
// onRenderBody hook
function onRenderBody({ setHeadComponents, setBodyAttributes, pathname }) {
	const othersComponents = [component1, component2, componentn];

	// Set different scripts for Griddo Builder and Griddo Editor.
	const headComponents =
		pathname === "ax-editor"
			? [...othersComponents, griddoWebfonts] 
			: [...othersComponents];

	setHeadComponents(headComponents);
}
```

El parámetro `pathname` permite discriminar:
- En el editor: siempre será `"ax-editor"`
- En el render: será la ruta de la página

### Recomendaciones generales

- Preferible `woff2` para las tipografías sobre `ttf` o `woff`
- Aloja las tipografías en la propia instancia en lugar de usar un CDN (Google Fonts, etc.) para reducir las conexiones y el tiempo de bloqueo
- Utiliza el set más pequeño que puedas de caracteres. Si tu página está en "latin-language" no uses caracteres "Cyrilic" o "Greek"

---

## Buenas prácticas con yarn.lock

En algunas instancias, hemos notado un problema recurrente relacionado con el manejo del archivo `yarn.lock`. Este archivo asegura que todos los desarrolladores utilicen las mismas versiones de dependencias, lo cual es crucial para mantener estabilidad y consistencia.

### El problema

Concretamente el problema es que se está haciendo un commit con un `yarn.lock` que no representa la realidad del `package.json` de esa rama. Probablemente porque venga de otra rama, donde la realidad de las dependencias sea otra, que aunque muy parecida, no es exactamente la misma.

### ¿Cómo evitarlo?

**Antes de hacer commit**

Antes de hacer commit debemos asegurarnos de que el archivo `yarn.lock` está sincronizado con los cambios en `package.json`. Ejecuta `yarn install` para actualizar y regenerar un `yarn.lock` actualizado.

Si se ha generado cambios en el `yarn.lock` commitealos normalmente.

### Automatizarlo

(WIP). usar git-hook con husky como pasa en el resto de instancias (a no ser que lo hayan eliminado)
