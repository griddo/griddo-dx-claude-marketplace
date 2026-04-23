# Hiperpersonalización con GPX

## Qué es GPX

GPX es un sistema propietario de Griddo basado en IA que permite crear un perfil microsegmentado del usuario que podemos recuperar y usar para mostrarle páginas del propio ecosistema de Griddo relacionadas.

Ejemplos de uso:

- Poder mostrar un módulo de "Noticias que te pueden interesar" en el que salgan noticias relacionadas con los intereses del usuario.
- Poder hacer distribuidores a medida teniendo en cuenta las categorías que interesan al usuario.
- Poder hacer módulos que presenten una u otra cosa según el perfil.
- Poder asociar a un formulario una lista de temas de mayor interés para ese usuario.

## Diferencia con otras herramientas de personalización por segmentos

Tradicionalmente, cuando se ha hablado de personalización, se ha hecho utilizando segmentos.

Personalización con segmentos implica que se definen una serie de segmentos, y luego en una parte determinada de la página defines todas las opciones posibles de qué hay que presentar según el perfil. Esto es laborioso y generalista. Por un lado, sería como rellenar un módulo tantas veces como segmentos tengas, y por el otro no es una gran personalización ya que no tiene en cuenta matices.

Lo que GPX ofrece es hiperpersonalización, que implica que se crea un perfil al detalle del usuario en lugar de asociarlo a un segmento.

Ejemplo de un módulo de cursos recomendados:

- Con segmentos, al usuario se le muestra una lista de cursos predefinida según su segmento. Aparte de que hay que mantener esa lista actualizada manualmente, es una segmentación genérica porque tampoco puedes tener muchos segmentos. Por ejemplo, si el usuario está interesado en tecnología, mezclará todo lo de tecnología a pesar de que tecnología es muy amplia.
- Con GPX, al usuario se le mostraría una lista de cursos dinámica basándose en sus intereses específicos, sin tener que predefinir nada, basándose en IA. De esta manera, se tiene en cuenta no solo si le interesa la tecnología, sino si le está interesando telecomunicaciones, 5G, IoT, desarrollo…

| Por segmentos | Con GPX |
| --- | --- |
| El editor tiene que definir para cada módulo el contenido para cada segmento. Si hay muchos segmentos (más de 3) se convierte en pesadilla. | Negocio debe definir reglas para los módulos (en la mayoría de los casos, basta con un distribuidor de IA) |
| El contenido que se muestra es predefinido para una lista limitada de segmentos. | El contenido que se muestra está personalizado exactamente para ese usuario y tiene en cuenta detalles y matices de sus preferencias. |
| Permite distinguir a nivel "le gusta la tecnología", "le gusta el derecho". | Permite distinguir a nivel "le gusta la programación y el mundo del IoT, está viendo temas relacionados con el campus de Segovia y se ha informado sobre becas". |

Una ventaja importante de GPX es que, si lo deseas, también puede trabajar con segmentos. De hecho **GPX puede trabajar con segmentos e hiperpersonalización al mismo tiempo**.

## Cómo funciona

Cuando un usuario entra en una web generada con Griddo, Griddo le asigna un identificador anónimo, que se guarda en el local storage de su navegador (no es una cookie). A partir de aquí, la instancia envía señales a Griddo cada vez que el usuario realiza una interacción o entra en una página a través de la cual podemos inferir que tiene interés en determinadas cosas. Con todo ello, en Griddo se va creando un perfil consistente en una lista de intereses asociado a un identificador anónimo, al que se le agrega información relativa a la conexión como idioma del navegador o país desde el que se conecta.

## Áreas, intereses y pesos

Hay tres conceptos clave que debemos entender: áreas, intereses y pesos.

Resumiendo mucho: cada interés lo asociamos a un peso, y los intereses se agrupan en áreas.

- **Área**: Un área es una especie de cajón donde vamos a guardar intereses que tienen en común ese área. El área se identifica por un string que nos inventamos dinámicamente (no tiene que estar definido previamente en ningún sitio, aunque recomiendo generar un tipo para garantizar la consistencia). A ese área vamos a ir asociando intereses. Ejemplos de áreas: "noticias", "programas", "escuelas". Ojo que no siempre las áreas las tenemos que crear basándonos en content types, también las vamos a poder crear (y así deberíamos) basándonos en qué vamos a querer hacer con ello, enviando distintos intereses a distintas áreas y así poder recuperar los intereses que hemos guardado en un área concreta para obtener un enfoque del perfil distinto. Según vayas leyendo el documento verás ejemplos específicos de esto.
- **Interés**: Un interés es una palabra concreta (también es un string que nos inventamos dinámicamente, pero debe tener sentido para la lectura humana). Ejemplos de intereses: "informática", "derecho", "5g". Cada vez que decimos que un usuario está interesado en un tema (enviamos un interés) este interés debe estar vinculado a un área y debe tener un peso.
- **Peso**: El peso es el nivel de importancia que tiene cada interés que registramos en el sistema. Es un número que vamos a definir nosotros. Tenemos que definir la escala que queremos usar (números enteros), como por ejemplo, entre el 1 y el 10. Recomiendo tener un tipo o una guía donde quede claro qué nivel de importancia tiene cada cosa para que luego los pesos sean coherentes.

Por ejemplo, cuando un usuario entra en una noticia, podemos enviar intereses al área "noticias" por las categorías de las noticias, y al área "escuelas" por la escuela a la que pertenece. Y las categorías de las noticias les daremos más que a las escuelas, porque son más específicas.

Siempre habrá un área "total" donde están todos los intereses agrupados.

## La importancia de definir las áreas correctamente

La primera tentación es definir las áreas por content types, pero en realidad no es muy conveniente hacerlo así.

Cuando defines las áreas, tienes que pensar en qué quieres hacer con los intereses, y crear un área distinta para cada uso o usos particulares que quieras dar, porque según el uso que queramos hacer puede haber intereses que nos vienen bien e intereses que no, y no queremos ruido. Por eso los organizamos en áreas.

Un ejemplo ya lo hemos dicho. Para saber qué campus puede estar interesando más al usuario, creamos un área campus y a ese área estamos enviando solo el nombre de campus cada vez que el usuario vea algo relacionado con un campus. De esta manera, cuando pidamos los intereses del área campus, solo vamos a obtener una lista de los campus ordenador de más relevante a menos relevante. Si en lugar de hacerlo así tuviéramos un área de cursos y ahí enviamos todos los intereses, incluyendo los campus, al pedir los intereses de ese área genérica estaríamos recibiendo muchas otras cosas, aparte de los campus, y puede que incluso no haya campus en esa lista porque habría otros intereses mezclados.

Otro ejemplo es que para conseguir eventos relacionados solo nos interesan ciertos tipos de interés, pero no todos. Nos puede interesar filtrar los que son categorías, por ejemplo, para luego pedir eventos de esas categorías utilizando un distribuidor convencional y filtrando por categorías.

El proceso debería ser siempre primero ver qué necesidad queremos cubrir, luego ver si ya tenemos un área que la cubre, y si no la tenemos… crearla.

Ten en cuenta que cuando envías intereses a GPX, puedes enviar el mismo interés a distintas áreas y además con distinto peso en cada área.

## La importancia de asignar pesos correctamente

El principal peligro de los pesos es que no estén correctamente ponderados entre ellos. A la hora de decidir qué peso le vas a asociar a un interés debes tener en cuenta:

- Cuánto de relevante es este interés para hacer el perfilado. No es igual de relevante saber qué temática de formación le interesa más, que saber qué escuela está visitando más. Ten en cuenta que a lo mejor las dos cosas son igual de relevantes pero según el uso, para eso están las áreas y la posibilidad de enviar el mismo interés a varias áreas con distinto peso para cada área.
- Cuántas veces se va a repetir este interés en un uso normal de la web.

Esto último es especialmente delicado.

Como ya hemos dicho, cada vez que envías a GPX un interés, se suman los pesos de los intereses de ese usuario. Si dices que a un usuario le ha interesado A cinco veces, y que le ha interesado B una vez, GPX entiende que le interesa A cinco veces más que B. Las señales de intereses que envías se suman. Enviarlas sin planificación puede darle demasiado peso a algo que en realidad no es tan relevante.

Imagínate que cada vez que se visita un programa estamos enviando al mismo área y con el mismo peso el nombre de la escuela, la temática y la modalidad. Si el usuario va a ver muchos programas de la misma escuela, de repente la escuela tiene mucha más relevancia que la propia temática de los cursos que le interesan. En este caso, previendo que muchos programas van a tener la misma escuela, deberíamos asignar un peso menor a la escuela, o meter la escuela en un área diferente.

Esto requiere trabajar y planificar bien las áreas y los pesos que les damos a cada acción.

## La importancia de planificar

Antes de empezar a trabajar con GPX, es muy importante tener esto en cuenta:

- Todo el equipo debe entender qué hace GPX… y también lo que no hace; al menos deben haber entendido este documento.
- El cliente debe tener unas expectativas realistas con respecto a lo que hace GPX.
- El cliente debe tener una estrategia clara de lo que quiere hacer con GPX y haberlo consensuado con todo el equipo de la instancia. En base a esa estrategia, será cómo el equipo de instancia debe definir las áreas, qué intereses hay y cómo va a usar sus ids, qué interacciones se interpretan como un interés, y la política de pesos.

## Cómo se usa (hooks)

GPX provee varios hooks para que puedas usar en tu código.

Es MUY IMPORTANTE tener en cuenta que, dado que GPX se basa en un seguimiento de la actividad del usuario a nivel de navegador, todos los hooks facilitados solo pueden ser usados a nivel de navegador del usuario, y no en la creación de la página estática a nivel de servidor. Esto significa que cualquier template o módulo que hagas que use estos hooks, forzosamente deberá usarlos dentro de un useEffect o similar. Si ejecutas los hooks en el renderizado del componente obtendrás resultados bastante desconcertantes y mensajes de error.

### Registrar los intereses

Lo primero es determinar qué eventos son susceptibles de considerarse un interés. Esto lo veremos más adelante. Supongamos que el usuario entra a ver una noticia. Podríamos hacer que en la template de noticias medir que cuando el usuario entra enviamos como intereses en el área noticias todas las categorías de noticias. Esto lo haríamos con el hook useSendInterests (leer la documentación).

Cada vez que volvemos a enviar los intereses, estamos sumándoles peso a la hora de valorar el perfil global del usuario (si enviamos que le interesó derecho 1 vez y le interesó tecnología 2 veces, ambas con el mismo peso, el sistema entiende que le interesa tecnología el doble que derecho).

Ojo porque no solo podemos enviar intereses al cargar la página. También lo podemos hacer con un timeout de 5 segundos para optimizar SEO, o incluso tener otro timeout adicional para volver a enviar los intereses 60 segundos después (para indicar que tiene el doble de interés), o volver a enviar esos intereses más un interés especial en el área "contentType" con el valor de "vídeo" (por ejemplo) si hace clic en un vídeo contenido en esa noticia. Puedes decidir que las meta keywords de la página son intereses, o puedes crear un campo específico en el eschema de la página. Lo importante en este punto es tener imaginación y planificar. Más adelante se explican ejemplos de estrategias para registrar los intereses.

### Utilizar los intereses: distribuidores con IA

Cuando enviamos los intereses con useSendInterest, vamos creando un perfil de intereses del usuario. El uso más sencillo que podemos hacer de esto es un distribuidor con IA. Griddo ya facilita para el desarrollador de instancia un AIReferenceField, junto al hook useAIReferenceField.

Prácticamente funciona como un distribuidor (de hecho generalmente se usará en AX como AI Distributor), solo que en lugar de que el usuario elija qué datos quiere mostrar (templates), lo que hace es indicar que sean datos relacionados con los propios intereses del usuario.

Este distribuidor tiene una propiedad que es muy distinta a la del distribuidor convencional, que es "prompt". El prompt es una indicación en lenguaje natural que se le puede dar a la IA para que se sume a todo lo indicado para hacer un matiz. Por ejemplo: "Destaca los masters". No es una indicación que se vaya a considerar al 100%, solo va a condicionar parcialmente los resultados.

Ten en cuenta que a la hora de buscar los datos que devuelve el distribuidor, no se tiene en cuenta toda la lista de intereses, sino los intereses que hemos guardado en un área específica. Por eso es importante planificar las áreas en las que vamos a guardar los intereses, porque según para el uso que queramos hacer podemos querer tener guardados intereses distintos del mismo usuario.

### Utilizar los intereses: obtener el perfil y tener libertad total

A veces podemos querer hacer cosas especiales. Para ello necesitamos obtener el perfil del usuario y analizarlo nosotros mismos para tomar nuestras propias decisiones. Para esto está el hook useReceiveInterests, el cual nos va a dar una lista de intereses del usuario dentro del área especificada.

Por ejemplo, digamos que quiero hacer un módulo que invite a descubrir lo interesante que es hacer vida en uno de los 3 campos que tiene la universidad. Para ello:

1. Habría creado un área campus en la que voy guardando como interés el nombre del campus cada vez que entro en un programa o evento que tiene un campus asignado. De esta manera, al pedir la información del área campus, obtengo qué campus está interesando más al usuario.
2. Habría creado en el esquema del módulo un field para que el usuario indique qué imagen y textos quiere mostrar el usuario según el campus que más le estuviera interesando, así como qué campus debe sugerir por defecto si todavía no sabemos qué campus le interesa más.

Otro uso sería que por ejemplo cuando enviamos los datos del usuario al CRM queremos poder decirle al CRM, como un campo más del formulario, qué cosas le interesan más a este usuario, para que quien reciba el formulario sepa qué cosas le interesan al usuario. Para eso podemos sacar la lista de intereses del usuario utilizando este hook y formatearla como texto.

### Contenido relacionado (usePageRelatedContent)

Aunque no es exactamente GPX, sí tiene que ver con personalización. Muchas veces nos encontramos con situaciones en las que por ejemplo estamos mostrando noticias y queremos mostrar noticias relacionadas. Hasta ahora esto lo estábamos gestionando mostrando las más recientes, o las más recientes de la misma temática, o las que el editor indique manualmente.

Con el hook usePageRelatedContent puedes simplemente indicar que quieres que se muestren noticias relacionadas con el contenido de la página desde la que llamas al hook. Esto va a buscar páginas relacionadas del tipo que indiques, y lo mejor de todo es que las va a relacionar no por las temáticas que tenga la página, sino por el contenido real tanto de la página para la que buscas contenido relacionado como de las páginas que encuentre.

Esto es buenísimo para el SEO, ya que permite:

- Repartir mucho más los enlaces creando una estructura de enlaces internos más compleja y diversa.
- Hacer que esos enlaces sean muy relevantes para el contenido, de manera que los buscadores los valoran más.

A diferencia del resto de hooks de GPX, este sí se puede usar en la creacion de la página estática sin necesitar un useEffect. Sin embargo, tendrá un efecto extraño si no se usa a nivel de navegador: este hook necesita que la página esté ya publicada y haya sido procesada por la IA para ofrecer resultados correctos; por lo tanto, al crear una página que usa ese hook a nivel de servidor, se creará con una información incorrecta porque la página aún no existe, y solo se mostrará la información correcta si la página vuelve a renderizarse. Salvo que tengas un flujo bien diseñado para forzar que la página vuelve a ser renderizada después de su creación, lo recomendable es que uses este hook en el lado de navegador.

## Los ids de los intereses

Cuando enviamos un interés, podemos asociarle un id. Por explicarlo brevemente, el id sería "la manera de poder asociar programáticamente ese interés con una fuente de datos". Por ejemplo,  puedo tener el interés "Programación" y el id puedo decidir que va a ser el id de la categoría programación (para que luego cuando vea que el interés del usuario es "programación", poder llamar a un distribuidor y traerme noticias o cursos relacionados con el id de programación). Este sería el uso más común, pero la herramienta es mucho más flexible, ya que permite que el id que asociamos a un interés ni siquiera tenga que corresponderse con algo de Griddo.

Hay muchas estrategias para usar esto. Doy varios ejemplos:

- Si tengo un área "knowledgeCategories" en la que voy metiendo las temáticas de interés de los cursos que le interesan al usuario, puedo hacer que el id sea el propio id de la categoría. Meto solo el id de la categoría porque ya sé que todos los intereses que voy a meter en ese área se corresponden con ids de esa categoría.
- Si tengo un área "coursesCategories", puedo hacer que el id de cada interés sea el id de esa categoría en Griddo, sabiendo que solo voy a meter como intereses cosas que se correspondan con categorías aplicables a cursos. De esta manera, cuando quiero mostrar "Cursos que te pueden interesar", puedo sacar por ejemplo las 5 "coursesCategories" que más han interesado al usuario, y mostrar un listado con filtros para poder elegir cualquiera de esos 5 intereses y que me saque un listado de cursos de cada uno de esos intereses. Ojo, porque en este caso se pueden mezclar como intereses por ejemplo modalidades y áreas de interés, y a lo mejor para este uso nos interesa tener las modalidades separadas en un área aparte, tener "coursesCategories" y "coursesModalities" (o como se traduzca eso) y permitir que el usuario seleccione entre ellas y usarlo nosotros para hacer peticiones a la api pública de listados y mostrar distintos listados.
- Si tengo un área en el que mezclo varias cosas que pueden tener un id, puedo decidir que el id esté codificado, tipo "tematicaCursos:5", "tematicaVideos:23", "salesforceId:22" (nota: cuando trabajas con ids de categorías de Griddo, los ids son únicos aunque pertenezcan a distintos temas). De esta manera, tienes identificado ese interés no solo por la palabra, sino también por la manera de encontrarlo internamente. Así, si me llega un interés con el id "salesforceId:22" sé que es algo que puedo referenciar en salesforce con el id 22; si me llega con el id "categorias:5" sé que es una categoría interna de Griddo con el id 5. La manera de codificar/identificar estos casos es de libre definición por parte de la instancia.

Para usar esto bien, es muy importante haber planificado primero muy bien las áreas.

## Estrategias para recolectar intereses

Esto es solo una pequeña lista de ideas de cosas que podemos hacer para recolectar intereses. La lista sería infinita, y la clave es siempre tener imaginación.

- Utilizar las categorías de la propia página para asociarlas a su content type.
- Utilizar las keywords de la página como intereses. Recuerda que además las keywords de la página se pueden generar automáticamente con IA. Puede ser conveniente no mezclarlo con otros intereses y tenerlo en un área aparte.
- Repetir señales cuando el usuario empieza a rellenar un formulario, y también cuando lo envía, para hacer que los intereses relacionados con ese formulario tengan más peso que el de una página en la que solo entró pero no tuvo intención de pedir información. Recuerda que cada vez que envías una señal, los pesos se suman.
- Tener un área para guardar los programas que más le interesan al usuario y así poder recordárselos. En este caso por ejemplo el interés sería label: nombre del programa; id: el id del programa (que luego llamando a la api puedo sacar su url, foto, etc), o el id puede ser idPrograma/imagenPrograma/urlPrograma para no tener que llamar a ninguna api.
- Enviar señales condicionadas a acciones como clicks y formularios, pero también a tiempo de permanencia en la página, scroll, llegar al final de la página…

## Creación de segmentos

A veces nos interesa mucho más (sobre todo en usuarios que ya se han adaptado a otras herramientas) trabajar con segmentos en lugar de con perfiles detallados.

Por ejemplo, puede interesarnos saber si el usuario pertenece al segmento "becas" o segmento "tecnología", y con eso tener un módulo con 5 configuraciones distintas según el segmento.

GPX permite trabajar con segmentos sin renunciar a la hiperpersonalización.

Para hacerlo hay muchas aproximaciones, pero la más simple que se me ocurre ahora mismo sería la técnica de los tests de la Super Pop, que consiste en que cada pregunta tiene varias respuestas cada una de las cuales da peso a un perfil distinto, y el perfil con más peso es el ganador:

- Crear un área "segmentos".
- Defino unos segmentos, que serían tratados como intereses dentro del área segmentos. Por ejemplo "becas" y "tecnología". Cuidado que hay que definirlo muy bien teniendo en cuenta luego qué usos queremos dar a los segmentos. A efectos de esta explicación, cuando hable de un segmento me refiero a un interés dentro del área "segmentos".
- Cuando envío intereses, si un interés encaja en un segmento, le doy peso a ese segmento concreto dentro del área "segmentos".
- Cuando obtengo los intereses del área "segmentos", el interés que tenga más peso será el segmento en el que encaja el usuario.

Se puede usar la misma técnica para por ejemplo tener una idea del rango de edad del usuario o incluso su sexo, creando áreas específicas y enviando pesos cuando tienes por ejemplo información a través de un formulario.

## Consideraciones

### Degradación de los pesos

Los pesos se degradan con el tiempo. Es decir, cada vez que enviamos un interés a GPX, ese interés suma peso. Pero según va pasando el tiempo, ese peso va siendo menor. Esto es así porque algo que nos interesó hace meses a lo mejor ahora no nos interesa.

### Temas legales

No soy abogado. No tengo claras las repercusiones legales. Solo sé que:

- GPX guarda datos anónimos (salvo que te dediques a enviar datos personales a GPX, pero tú sabrás lo que haces en tu instancia).
- GPX no usa cookies, pero sí local storage.
- GPX solo registra la actividad del usuario, y toma conclusiones con respecto a esa actividad.
- GPX sí permitirá vincular un id de usuario o de crm o un correo o lo que se quiera al perfil anónimo (momento en el cual dejaría de ser anónimo). De momento no lo permite, pero cuando lo permita, será algo que la propia instancia decide si lo hace o no.
- Toda la operativa de GPX se realiza dentro de la misma infraestructura, por lo que lo que  maneja es first-party data. No se envían datos de perfiles de usuario al exterior (salvo que la instancia específicamente lo haga, por ejemplo enviando la lista de intereses junto a los formularios, en cuyo caso el propio cliente debe considerar cómo afecta a sus condiciones legales ese uso específico que libremente ha decidido).

### Cómo hacer pruebas

Cuando hacemos pruebas, es normal que saturemos GPX con un perfil bastante absurdo. Muchos reloads de página, una navegación totalmente artificial… De vez en cuando nos interesa resetear el perfil de GPX.

Lo que podemos hacer es cancelar nuestro perfil para obligar a que se cree uno nuevo. Para ello, vamos a inspeccionar en el navegador, vamos a almacenamiento → local storage → nuestro dominio y eliminamos la variable que contenga GPX.
