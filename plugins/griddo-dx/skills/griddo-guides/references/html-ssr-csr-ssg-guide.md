# HTML, SSR, CSR y SSG para no técnicos

## Objetivo

La intención de este documento es explicar las diferencias entre HTML, SSR, CSR y SSG, para que el equipo no técnico entienda las limitaciones, ventajas y desventajas de cada uno de los sistemas y lo que implica que un proyecto se base en una u otra tecnología.

## Nota aclaratoria

En distintos puntos de este documento se hace referencia a que las páginas estáticas (Vanilla HTML y SSG) tienen el contenido que tienen y eso es lo que hay. Esto es cierto pero solo parcialmente.

En realidad una página estática, mediante Vanilla Javascript (el de toda la vida, podríamos traducir —malamente— Vanilla como «a pelo»), puede acceder a datos de API o servicios externos y modificar su contenido con ello. Sin embargo, esto no suele ser «gratis» y puede tener consecuencias, generalmente sobre el SEO, el rendimiento (estamos añadiendo código) y la velocidad. En el caso de Griddo, hay una dificultad adicional y es que aunque mediante Vanilla Javascript podemos acceder a datos adicionales, al final en Griddo el renderizado de los módulos se está haciendo a través de un componente dentro de otro componente. Ese renderizado a través de componentes de React no está disponible como Vanilla Javascript, lo que obligaría a hacer una doble codificación que puede acabar derivando en incoherencias.

Al final, esto no va de lo que puede hacerse o lo que no. Prácticamente todo se puede hacer, hasta lo más loco (bueno, igual si es muy loco tampoco). Al final el tema es cuánto va a costar en tiempo y personas, así como las garantías que tenemos de que el resultado vaya a ser satisfactorio, mantenible y escalable.

## Vanilla HTML + CSS

**Ejemplo: Las webs que se hacían con Frontpage**

Son páginas estáticas de toda la vida. Las que hacías con Frontpage (o algún bestia con Word y grabando en formato HTML), o ahora con VS Code. Solo tienen HTML, vanilla Javascript y CSS. Puede que utilicen también JQuery o Bootstrap, por ejemplo. El caso es que son páginas que puedes abrir en cualquier momento, desde cualquier sitio, y te van a funcionar porque no hay nada oculto detrás.

### Desventajas:

- La página es lo que es y se muestra tal cual. Como mucho puedes hacer un responsive por CSS. Puedes insertar vanilla Javascript para acceso a datos, pero puede dar problemas en SEO (actualmente esto está cambiando).

### Ventajas:

- Rápido como un tiro, ya que son contenido estático y, cuando están bien hechas y no se abusa de librerías externas innecesarias, además son extremadamente ligeras.

## SSR = Server Side Rendering

**Ejemplo: Wordpress.**

Son páginas que se renderizan en el lado del servidor. Las páginas no existen como tales, sino que son generadas conforme son solicitadas.

### Desventajas:

- Requieren de un mayor procesamiento, por lo que cuando se escala a volúmenes de tráfico altos requieren máquinas potentes.
- Debido a lo anterior, suelen ser más lentas.

### Ventajas

- Al generarse en tiempo real cada vez que se solicitan, podemos devolver resultados diferentes a cada usuario en función de su ubicación (a través de la IP), el tipo de dispositivo, configuraciones previas a través de cookies...
- Por la misma razón, cualquier cambio en el contenido de la página es reflejado inmediatamente.

## CSR = Client Side Rendering

**Ejemplo: Una página en React.**

Son páginas que se renderizan en el lado del cliente. Al conectarte a la página te descargas un código base, que en función de la URL se descargará la información que quiere visualizar y la renderiza en el lado cliente.

Su principal ventaja/desventaja es que descargan rápido, pero hasta que no terminan de descargarse el código base no empiezan a descargar el contenido, por lo que suelen tener un loader y al final no son tan inmediatas en la primera carga de página (pero sí son mucho más rápidas en las siguientes, ya que solo tendría que descargarse los datos pero no los estilos ni la lógica).

### Desventajas

- La primera página tarda más en descargarse, porque se carga en dos partes (primero el código, y luego el contenido).

### Ventajas

- Después de descargar la primera página, el resto va muy rápido.
- Los cambios se reflejan inmediatamente.
- La vista puede cambiarse en función de la configuración del usuario (cookies, login, ip, tipo de dispositivo...)

## SSG = Static Site Generation

**Ejemplo: Las páginas generadas con Griddo.**

Son páginas estáticas que se han generado a través de una programación dinámica, tipo Gatsby que convierte páginas en React en páginas estáticas. Es decir, que en lugar de hacerse escribiendo el HTML a mano son el producto de un código.

Al final se comportan como las páginas Vanilla HTML + CSS, pero son más pesadas porque en lugar de estar hechas con lo justo y necesario, tienen un framework o librería que por mucho que depures, acaba pesando.

### Desventajas:

- Más pesadas que las páginas Vanilla.
- El contenido está renderizado en un proceso aparte, por lo que es el que es y no puede cambiarse dinámicamente (salvo temas como responsive que va por CSS, o ajustes a través de Javascript como descargar contenido bajo demanda, si bien ese contenido no aparecería inmediatamente porque se descarga aparte).
- El contenido no cambia hasta que no vuelve a generarse todo el site.

### Ventajas:

- Pueden llegar a ser complejas y muy versátiles, beneficiándose de las ventajas de la librería con la que se han hecho (uso de plantillas, sistemas de diseño, módulos, utilidades de terceros...), con mejor rendimiento que las páginas renderizadas en servidor o cliente porque el renderizado se ha hecho con anterioridad en un proceso aparte.
