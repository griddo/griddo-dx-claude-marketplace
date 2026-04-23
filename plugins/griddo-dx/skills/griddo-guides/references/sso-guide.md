# Cómo implementar el SSO en tu instancia

## Implementación de SSO en Griddo

El **Single Sign-On (SSO)** permite que los usuarios del cliente accedan a Griddo sin necesidad de ingresar un usuario y contraseña. Si el usuario ya está autenticado en su sistema (usando ADFS, por ejemplo), podrá entrar a Griddo directamente. 

Este proceso de implementación requiere colaboración entre Griddo y el equipo del cliente.

## Datos necesarios del cliente

Para activar el SSO en una instancia de Griddo, necesitamos que el cliente nos proporcione los siguientes datos:

- **`Client Id`**: Este identificador único permite que el sistema de autenticación del cliente (ADFS) reconozca a Griddo ypermita las interacciones con los servicios de autenticación y autorización. Suele ser una cadena de números y letras separados por guiones.
- **`Client Secret`**: Un valor secreto que, junto con el `Client Id`, se usa para autenticar de manera segura a Griddo ante el sistema de autenticación del cliente.
- **`OpenId URL`**: Esta URL contiene metadatos que permiten a Griddo interactuar con el servicio de autenticación del cliente. A través de ella, Griddo obtendrá información sobre los endpoints de autorización, tokens, claves públicas para verificar firmas, y otra configuración necesaria. Esta URL suele terminar en `/.well-known/openid-configuration`. Ejemplo:`https://sts.enrique.griddo.es/adfs/.well-known/openid-configuration`
- **`User Info URL`** (Opcional): URL desde la que Griddo puede obtener información detallada del usuario autenticado, como nombre o correo electrónico. Si no se proporciona, Griddo puede seguir otro flujo alternativo dentro de la API.

## Implementación en Infraestructura

Una vez tengamos los datos anteriores, se los enviaremos al equipo de infra (Enrique) para que los configuren en las variables de entorno de la API en el entorno correspondiente. Además de los datos anteriores, debemos incluir estas dos variables adicionales:

- **`SSO_ACTIVATED`**: Booleano que indica si la instancia usará o no el SSO. Si está en `false`, se mantendrá el flujo de autenticación habitual; si está en `true`, se activará el flujo de SSO.
- **`SSO_REDIRECT_URL`**: URL que redirige al usuario de vuelta a Griddo tras la autenticación. Esta URL debe estar compuesta por la URL de la API seguida de `/login_griddo`. Ejemplo:`https://api.dev.griddo.io/login_griddo`

Una vez configurado, las variables de entorno quedarían de la siguiente manera:

```bash
export SSO_ACTIVATED=1
export SSO_REDIRECT_URL='https://api.your-instance.griddo.io/login_griddo'
export SSO_CLIENT_ID='your-client-id-here'
export SSO_CLIENT_SECRET='[REDACTED]'
export SSO_OPENID_URL='https://your-sts-server.example.com/adfs/.well-known/openid-configuration'
export SSO_USERINFO_URL='https://your-sts-server.example.com/adfs/userinfo'

```

## Implementación en la instancia

Con la variable de entorno `SSO_ACTIVATED`, la API detecta que la instancia usará SSO. Además, para activarlo en la interfaz (AX), se deberá gestionar a través de las configuraciones (settings) de la instancia añadiendo lo siguiente:

```bash
SSOActivated: 1
```

## Pruebas de implementación

Para verificar que todo funciona correctamente, seguiremos el flujo de autenticación con SSO.

### Antes de activar el SSO

1. El cliente debe crear un usuario en su ADFS. Algo así como developer@example.com un user al que tengamos acceso.
2. El correo de ese usuario de secuoyas ya debe estar registrado en Griddo con autenticación tradicional.

### Activación del SSO

1. Activar el SSO siguiendo los pasos anteriores.
2. Realizar pruebas con el usuario creado por el cliente para verificar que la conexión funciona correctamente.
3. Durante las pruebas, el SSO estará activado, lo que puede impedir que otros usuarios accedan de manera habitual. Es recomendable coordinar un día o una franja horaria para realizar estas pruebas, activando y desactivando el SSO según sea necesario, para no afectar el trabajo diario del cliente.
