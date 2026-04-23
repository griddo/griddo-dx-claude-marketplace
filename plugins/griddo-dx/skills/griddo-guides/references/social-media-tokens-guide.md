# Social Media Tokens

Con la finalidad de poder hacer uso del módulo SocialWall, es necesario que desde Griddo tengamos **ciertas claves del cliente.** A continuación detallamos los tipos de permisos y cómo hacerse con ellos:

*Para llevar a cabo este proceso es imprescindible es tener a mano las cuentas y contraseñas de Google, Twitter e Instagram desde las cuales crearemos las aplicaciones para conseguir los tokens.*

En caso de que las aplicaciones ya estén creadas, estos son los tokens:

- **YouTube: Api Key** de YouTube Data Api v3
- **Twitter: Bearer Token**
- **Instagram: Client ID, Client Secret** de Visualización Básica de Instagram

## YouTube

- Iniciamos sesión en [https://console.cloud.google.com/](https://console.cloud.google.com/)

Para acceder a este servicio se deberá hacer desde la cuenta de google de la que se quiera crear y gestionar la Api Key

- Seleccionamos en **CREAR PROYECTO**
- Tanto el **Nombre del proyecto** como la **Ubicación** son transparentes para nosotros, así que se pueden elegir al gusto.
- Una vez generado el proyecto accedemos a **Biblioteca de API** en el menú
- Buscamos YouTube y seleccionamos **YouTube Data Api v3** y la habilitamos
- Una vez habilitada, en la pantalla superior derecha, en el dashboard de la API, nos aparecerá la opción de **CREA CREDENCIALES**
- en **seleccionar una API** dejamos marcado **YouTube Data API v3**
- en **¿A qué datos quieres acceder?** seleccionamos **Datos públicos y Siguiente**
- En **Restricciones de API** seleccionamos **YouTube Data API v3** y **GUARDAR**
- Desde esa misma pantalla o en la pantalla credenciales podremos seleccionar **MOSTRAR CLAVE**

**¡Ya está listo! esta será la clave que necesitamos desde Griddo para poder acceder al apartado de YouTube.**

## Twitter

- Iniciamos sesión en [https://developer.twitter.com/](https://developer.twitter.com/)

Para acceder a este servicio deberá hacerse desde un ordenador donde esté iniciada la sesión de Twitter de la cuenta desde donde se quiera proporcionar el token.

- Rellenamos los datos del formulario para conseguir el **Essential access**
- Aceptamos todos los acuerdos y verificamos el email
- Introducimos App name

Es importante que guardemos estas claves en un lugar seguro ya que Twitter no volverá a mostrarlas. 

**Desde Griddo, la clave que necesitamos será el Bearer Token, la última que aparece en la lista**

En este momento tenemos el **servicio esencial y el Bearer Token**, vamos a seguir los siguientes pasos para generar el **servicio elevado** para tener el límite de acceso máximo de peticiones.

- Desde el Dashboard de nuestra cuenta, accedemos a **Products, Twitter API v2**
- En la parte superior, entramos en la pestaña de **Elevated**
- Rellenamos el formulario de **Intended use** que Twitter nos exige para poder tener permisos elevados. En la siguiente captura pongo un ejemplo de lo que nosotros hemos puesto en desarrollo. **El acceso te lo dan automáticamente.**

**¡Ya está listo! ya tenemos el Bearer Token y permisos elevados de Twitter, el cual nos permitirá hacer 2 Millones de peticiones al mes en Twitter**

## Instagram

En el caso de Instagram, desde **Griddo** hemos desarrollado un **servicio de autenticación** para que desde una cuenta maestra, todas las cuentas que quieran estar disponibles en el módulo sólo tendrán que clicar en un **link de autenticación** y aceptar la petición de permisos por parte de **Instagram**. Nosotros recogeremos esa petición y podremos **renovar automáticamente los tokens** (los cuales caducan cada 60 días).

Lo único que necesitamos es **configurar la aplicación maestra** desde la que conectaremos todas las cuentas y la que nos proporcionará las dos claves que necesitamos: el **identificador de la app**, la **Clave secreta de la app**

- Iniciamos sesión en [https://developers.facebook.com/](https://developers.facebook.com/)

Para acceder a este servicio se deberá hacer desde un ordenador donde esté iniciada la sesión de Facebook de la cuenta donde se quiera crear la aplicación.

- En el apartado **Mis Apps**, pulsamos en **Crear App**
- En el tipo de app, seleccionamos **Consumidor**

Dentro de los detalles, veremos **Nombre para mostrar**, este será el nombre que verán las cuentas cuando vayan a dar permisos mediante el link de autenticación de Griddo (en el caso de la primera captura, es testApi) es transparente para nosotros.

Ya hemos creado nuestra App, el siguiente paso es configurar la **Visualización básica de Instagram,** para eso, **primero tenemos que configurar nuestra app**

- Entramos en la pestaña de **Configuración Básica** de nuestra App, en el panel izquierdo.
- Los campos **URL de la Política de privacidad** y **Eliminación de datos de usuario** son internos para las cuentas que se vayan a asociar a esta cuenta maestra, por tanto no son relevantes, en el campo eliminación, seleccionamos **URL de instrucciones para la eliminación de datos**:
    - **URL de la Política de privacidad**: [https://rrss/socials/ig/auth/privacy](https://rrss/ig/auth/privacy) (pedir a API)
    - **Eliminación de datos de usuario:** [https://rrss/socials/ig/auth/delete_user_data](https://rrss/ig/auth/delete_user_data)  (pedir a API)

- Hacemos clic en Agregar plataforma, seleccionamos **Website**
- En **URL del sitio** ponemos url principal del sitio web, es transparente para nosotros
- **Clicamos en Guardar Cambios**

Una vez puesta la configuración básica, ya podemos poner la app en **Modo de la app Activo** desde el panel principal

Ahora ya podemos configurar la **Visualización básica de Instagram**

- Clicamos en **Configurar**
- Clicamos en **Crear nueva aplicación**
- Una vez dentro de la pantalla de **Visualización Básica**, debemos copiar el **Identificador de la app de Instagram** y la **Clave secreta de la app de Instagram, estas son las claves que necesitamos desde Griddo para crear el servicio de autenticación.**
- Justo debajo, en **Configuración del cliente de OAuth** tenemos que añadir el link que usaremos en Griddo para recoger el token que almacenaremos y renovaremos automáticamente
    - URI de redireccionamiento de OAuth válidos: **[https://rrss/socials/ig/auth/redirect](https://api/ig/oauth/redirect)**  (pedir a API)
    - URL de devolución de llamada para autorización cancelada: [**https://rrss/socials/ig/auth/cancel](https://api/ig/oauth/cancel)**  (pedir a API)
    - URL de la solicitud de eliminación de datos: [**https://rrss/socials/ig/oauth/delete](https://api/ig/oauth/delete)**  (pedir a API)

**¡Ya está listo! ya tenemos nuestra aplicación de Instagram creada y conectada a Griddo para empezar a autenticar cuentas y visualizar sus datos en SocialWall**

Una vez hayamos podido recoger lo datos y hacer las primeras pruebas, haremos entrega del link de autenticación de Instagram y ya podremos empezar a usar el SocialWall.

Cualquier duda relacionada con el proceso, no dudéis en contactarnos.
