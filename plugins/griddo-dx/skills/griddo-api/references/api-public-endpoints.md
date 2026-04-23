# AI Search

Para entender todos los detalles de AI Search, consulta la [**guía técnica**](../../../Gu%C3%ADas y tutoriales/AI Search 7b4661a3120f469aab6363a610bcb430.md).

## `POST` /ai/search

**Requiere la variable de entorno GRIDDO_AI_SEARCH=”on” en API Privada.**

Realiza una búsqueda sobre todos los contenidos de Griddo (solo las páginas publicadas) permitiendo aplicar filtros y modificadores en las respuestas, obteniendo una respuesta en formato json. Toda la configuración de la búsqueda se envía en el body.

Toda la información de parámetros y respuesta en [API Privada](../../API Privada/Endpoints/AI Search 19f978734bcb4e0ab2dedbf865303e5b.md).

## `POST` /ai/answers

**Requiere la variable de entorno GRIDDO_AI_ANSWERS=”on” en API Privada.**

Realiza una búsqueda sobre todos los contenidos de Griddo (solo las páginas publicadas) para obtener una respuesta conversacional. No es realmente una conversación, a día de hoy solo permite hacer una pregunta y tener una respuesta. No se puede conversar, sino en todo caso hacer nuevas preguntas. La respuesta la facilitará en markdown. Toda la configuración de la búsqueda se envía en el body.

Toda la información de parámetros y respuesta en [API Privada](../../API Privada/Endpoints/AI Search 19f978734bcb4e0ab2dedbf865303e5b.md).

## `GET` /ai/pages/related/p/:pageId/l/:languageId/s/:siteId/q/:quantity/d/:useStructuredData/f/:fields/t/:template

**Requiere la variable de entorno GRIDDO_AI_SEARCH=”on” en API Privada.**

Ofrece contenidos relacionados con la página indicada, siguiendo los parámetros indicados, utilizando la inteligencia artificial.

Los parámetros son:

- `pageId`. Requerido (si lo tenemos). El id de la página de la que queremos el contenido relacionado.
- `languageId`. Requerido. El id del idioma.
- `siteId`. Requerido. El id del site.
- `template`. Requerido. La template para la que queremos obtener resultados, por ejemplo EventDetail o ProgramDetail. Puede ser una lista separada por comas.
- `quantity`. Opcional. La cantidad de resultados. El máximo es 20. Por defecto, 20.
- `useStructuredData`. Opcional. “on” / “off”. Indica si queremos obtener los datos estructurados asociados a cada resultado (si lo tiene).  Por defecto, “off”.
- `fields`. Opcional. La lista de campos que queremos obtener depurados de los datos estructurados, separados por comas. Por defecto se mostraría todo el dato.

**AVISO: Esto depende de que la página esté publicada y haya sido vectorizada por la IA (una página pasa a estar vectorizada y ya está vectorizada para siempre aproximadamente entre 15 y 90 minutos después de su primera publicación, y siempre que estén activados los embeddings en las variables de entorno de api). Si esto aún no ha sucedido, lo que hará será mostrar contenido al azar del mismo idioma, site y template.**
---
# Alertas SNS

1. Crear un topic SNS (cuidado con los permisos) y las suscripciones necesarias.
2. Asignar a la máquina en la que se va a ejecutar **API Pública** un rol con permisos `SNS:Publish`. 
3. Opcional (no necesario para nada): Si se quiere hacer que funcione en local (no habría necesidad para ello) la máquina debe tener credenciales CLI en `~/.aws/credentials` y activarse el perfil correspondiente con `export AWS_PROFILE={{perfil}}`. Pero eso ya se explicó en [Permisos de AWS](https://www.notion.so/cde33db8a4e340d4af5966c7f8703c0a?pvs=21). Esas credenciales CLI deberían tener permisos para publicar SNS (igual que hacemos en la máquina con rol, pero asociándolo a las políticas del usuario).
4. En **API Pública**, crear las variables de entorno:
    1. `snsTopicArn` con el arn del topic SNS.
    2. `snsRegion` con la región.
    
    ```bash
    export snsTopicArn='arn:aws:sns:us-east-1:181318525625:TestGriddoAPI'
    export snsRegion='us-east-1'
    ```javascript
    
5. Probar con el endpoint `{{apiPublica}}/ping/sns`

## Controlar que las alertas SNS están funcionando

Se puede hacer un `/ping/sns` cada x tiempo. Si la respuesta es 200 OK es que está funcionando correctamente.

Obviamente, cada vez que se hace un ping, se envía la alerta a todas las suscripciones activas a ese Topic y puede ser bastante molesto, porque queremos hacer la comprobación a nivel de infra y tomar medidas con lo que suceda también en infra, pero no estar enviando una alerta cada vez que el ping es ok (cuando el ping es error, es porque la alerta no sale y por tanto no se recibe ningún aviso). Se pueden hacer truquis como por ejemplo filtrar para no enviar el mensaje a slack (si estuviera configurado en la suscripción, o cualquier otro medio) si el texto del mensaje incluye el hashtag `#ItsJustAPingSoIgnoreThis`

## En caso de error

Si al probar con el ping obtenemos un error tipo "SignatureDoesNotMatch: Credential should be scoped to a valid region.” o “Error: connect EHOSTDOWN 169.254.169.254:80” es bastante probable que sea porque lo estamos ejecutando en local y no están cargadas las credenciales. Revisar el punto 3.

El resto de errores es bastante explícito en su mensaje de error, tipo “El usuario no tiene permisos para enviar SNS” y similares.
---
# Alertas

Griddo dispone de un sistema para emitir alertas. Estas alertas consisten en dos acciones:

- **Log en la BBDD de Griddo** (tabla `log_alerts`). Este log se guarda a nivel interno, no hay ningún mecanismo para poder visualizarlo en pantalla (de momento) pero al menos la información se guarda.
- **Emisión de SNS**. Se envía también una alerta a través del sistema SNS de AWS, conforme esté configurada. Ver apartado [Alertas SNS](../Alertas SNS eadd394d60cc43e48e292d73e5b67bee.md) para su configuración.

Este sistema es independiente al de las integraciones de CRM nativas de Griddo (formulario por correo, Nubika y Dynamics), las cuales automáticamente lanzan una alerta cuando hay un error en el CRM.

Estas alertas se pueden usar para lanzar un aviso:

- Desde el front, cuando ocurre determinada circunstancia (una api de terceros no responde o da un error, por ejemplo la de Youtube cuando saca error de quota o la de UCMA cuando fallan las peticiones a su CRM interno que no está integrado de forma nativa en Griddo).
- Desde un despliegue.
- Desde unos tests.

Desde API Pública, solo exponemos un único endpoint que es para emitir la alerta en sí.

## `POST` /alert

Emite una alerta.

Recibe esto en el body:

```json
{
    "level": "E",
    "area": "Forms",
    "description": "Error desde API RGPD",
    "fullData": {
        "code": 400,
        "message": "Duplicated"
    },
		"instantNotification": true
}
```javascript

Donde:

- `level` es el nivel de alerta. Puede ser (E)rror, (W)arning o (I)nfo. Obligatoria.
- `area` es un string con el area genérica relativa a la alerta (para luego poder agrupar en consultas). Podría ser por ejemplo “Formularios”, “Tests”, “API Google”. Obligatoria.
- `description` es un mensaje más detallado del error. Opcional (siempre que al menos hayas puesto algo en fullData), pero lo correcto sería poner algo.
- `fullData` es un string o un dato (si es un string se guardará como objeto igualmente) en el que metes todo el detalle del error que te parezca conveniente. Por ejemplo, si la alerta es que una API ha rechazado una petición, puedes poner todo lo que enviaste a la api y lo que la api te respondió. Opcional (siempre que hayas puesto algo en description).
- `instantNotification` indica si queremos enviar una notificación SNS inmediata. Si está a false, se guarda solo en el log de la BBDD. Si está a true, además se envía la notificación SNS. Opcional. El valor por defecto será true si el nivel de la alerta (level) es E (Error) y false en el resto de casos. Con esta propiedad podemos forzar la alerta SNS aunque la alerta sea Warning, o no enviarla aunque la alerta sea Error. En cualquier caso, para evitar malentendidos, lo ideal es especificarla siempre.

**Respuesta:**

- Si todo va ok, recibes un código 200.
    
    ```json
    {
        "code": 200,
        "message": "ok"
    }
    ```javascript
    
- Si algo va mal, recibes un código 400 y una respuesta como esta:
    
    ```json
    {
        "code": 400,
        "message": "ERRORS FOUND: [\"**SAVE ON DDBB**: connect ECONNREFUSED ::1:3001\",\"**SNS**: AuthorizationError\"]"
    }
    ```javascript
    

 

**Otras consideraciones:**

- Hay que tener en cuenta que, al realizar dos acciones en paralelo (guardar el log en BBDD y emitir alerta SNS) si alguna de las dos cosas falla la otra se intentará hacer igualmente (por eso el mensaje de error contiene un error stringificado, mostrando todos los errores sucedidos).
- No es necesario esperar la respuesta (salvo que necesites confirmar que todo ha sido ok), con hacer la llamada tienes suficiente.
- Recuerda que las alertas SNS deben estar configuradas en la instancia.
- Se puede utilizar desde las instancias llamando a la función [griddoAlertRegister](../../../Bloques constructivos/Funciones/griddoAlertRegister 9ed63ecfecd04293b198c5ffb8a36e4f.md) que exporta Core.
- Se puede utilizar desde SDK / Debugger a través de la función [sendAlert](../../../Herramientas/Griddo SDK/Griddo SDK 1 0/M%C3%A9todos disponibles/Alertas e2e7bff20d6b4d7faa158af47f843b15.md).
---
# Calendar

## Apuntes sobre el uso de la funcionalidad de Griddo Calendar

Esta nueva funcionalidad de Griddo Calendar usa el API externo de Google Calendar para poder ver los huecos libres de un calendario concreto y para reservar una reunión. 

Para poder utilizar esta nueva funcionalidad, has de cumplir estos pasos:

1. A nivel de infra hay que especificar las siguientes variables de entorno. En caso de que no estén especificadas, la conexión fallará.
    - `calendarClientId`: El Client ID de la aplicación OAuth 2.0 configurada en Google Cloud Console para acceder a la API de Google Calendar.
    - `calendarClientSecret`: El Client Secret asociado a la aplicación OAuth 2.0 de Google Cloud Console.
    - `calendarRefreshToken`: El Refresh Token obtenido durante el flujo de autenticación OAuth 2.0. Se utiliza para generar automáticamente nuevos tokens de acceso sin necesidad de que el usuario vuelva a autenticarse.
2. A nivel de instancia hay que especificar las siguientes propiedades en la tabla de `settings`: 
    1. `appointmentCalendar` : El calendario sobre el cual se quieren comprobar los huecos libres y crear una reunión. Por ejemplo `user@example.com`
    2. `appointmentConfirmationEmailTemplate` : La template de html que queramos especificar en el mail que se enviará al solicitante.

Para poder establecer estas propiedades hay que usar el endpoint `POST`/settings de API Privada y pasar un body similar a este:

```json
{
    "appointmentCalendar": "user@example.com",
    "appointmentConfirmationEmailTemplate": "<!DOCTYPE html><html lang='es..."
}
```javascript

## `GET` /calendar/freeslots/days/:days/start/:start/end/:end

## `GET` /calendar/freeslots/days/5/start/2023-09-06/end/2023-09-10

Devuelve la información de los huecos libres en un calendario de Google Calendar en intervalos de una hora en los próximos 15 días laborables comenzando en la semana en la que se haga la llamada. El calendario que se usará para comprobar los huecos será el especificado en las settings bajo el nombre de `appointmentCalendar`  

Este endpoint acepta los siguientes parámetros opcionales.

- `days`: Opcional, number. Número de días que quieras que te devuelva la respuesta. Por defecto son 15, pero puedes especificar un número concreto.
- `start & end`: Opcional. Para especificar más concretamente de qué día a qué día quieres que te devuelvan los días. Debes especificar los dos juntos y si los especificas junto al parámetro anterior `days` prevalecerá los días que establezcas en `start` y `end` . El formato es importante y será AAAA-MM-DD

## **`POST`** /calendar/reservation

<aside>
💡 **Body**
date,
hour,
summary,
requestorName,
requestorMail

</aside>

Publica un evento en el calendario que esté especificado en los settings bajo el nombre de `appointmentCalendar` y acto seguido manda un correo al que esté especificado como `requestorMail`

Ejemplo de una petición

```javascript
{
    "date": "2023-09-12",
    "hour": "18:00:00",
    "summary": "Prueba Calendario",
    "description": "Prueba Calendario descripción",
    "requestorName": "Alvaro",
    "requestorMail": "user@example.com"
}
```javascript

- `date`: El día en el que quieres agendar la reunión. El formato es importante y debe ser AAAA-MM-DD
- `hour`: La hora a la que empieza la reunión, la duración será de 1h. El formato es importante y debe ser HH:MM:SS
- `summary`: El título del meeting. Luego aparecerá en el evento de Google Calendar.
- `description` : La descripción del evento. Luego aparecerá en el evento de Google Calendar.
- `requestorName` : El nombre de quien solicita una reunión.
- `requestorMail`: El mail de quien solicita una reunión.

**APUNTE ACERCA DEL ENVIO DEL MAIL**

Después de agendar un evento en el Google Calendar, se enviará un mail al `requestorMail` especificado en el body. La template de html de este mail se obtendrá de la variable de settings `appointmentConfirmationEmailTemplate` . Podremos usar una serie de variables fijas en el cuerpo de este mail si las ponemos entre llaves, ejemplo `{{variables}}`  a saber las siguientes variables:

- `{{name}}` Será el nombre del requestorName.
- `{{mail}}` Será el mail que aparece en requestorMail.
- `{{date}}` Será la fecha que llega en el body, solo que en lugar de estar en este formato AAAA-MM-DD, lo transformaremos en el formato `lunes, 11 de Septiembre de 2023`
- `{{hour}}` Será la hora que nos llega por body.
---
# CRM Integrations

Griddo supports multiple CRM integrations through the API Pública. This document consolidates all CRM endpoint documentation.


## Cognito

# Cognito

## `GET` /crm/cognito/token

Devuelve el token del usuario que ha hecho login con Cognito. Ejemplo:

```jsx
{
  "cognitoToken": "xxxxxxxxxxxxx"
}
```javascript

Considera que el token está en la cookie que empieza por `CognitoIdentityServiceProvider` y termina por `.accessToken`

**Notas para infra:**

El token lo extrae de las cookies recibidas, teniendo en cuenta que las cookies de Cognito pueden ser solo de servidor (por lo tanto no pueden ser accedidas directamente por el front) y por tanto este endpoint debe responder en el mismo dominio en el que está el token.

Es decir, que desde infra se requiere hacer un mapeo tipo:

`alumni.centrogarrigues.com/api/crm/cognito/token` —> `public-api.centrogarrigues.com/crm/cognito/token`

Para que desde el front puedan hacer una llamada de servidor dentro del mismo dominio.

## Google Sheets

# Google Sheets

# Configuración a nivel de infra

Variables de entorno requeridas:

```jsx
GOOGLE_SERVICE_ACCOUNT_EMAIL,
GOOGLE_PRIVATE_KEY,
GOOGLE_SHEET_ID
```javascript

Donde las dos primeras se refieren a claves que se crean en Google Cloud Console.

Procedimiento en Google Cloud Console:

1. Crear proyecto si no existe.
2. En APIS y Servicios > Credenciales, crear una cuenta de servicio (solo la cuenta, sin roles ni nada). Ese correo creado sería GOOGLE_SERVICE_ACCOUNT_EMAIL.
3. A esa cuenta de servicio, agregarle una clave. Al crearla nos descargamos un json, y en él viene la private_key que es la GOOGLE_PRIVATE_KEY.
4. En Google Sheets API, la habilitamos.

Procedimiento en la hoja de Google:

1. Sacar el GOOGLE_SHEET_ID de la url: `https://docs.google.com/spreadsheets/d/**1uNAf1yfelOSvI9VNJ21I4ryEaBy9kBHUm8-VIQllEw8**/edit?gid=0#gid=0`
2. Compartir con la dirección que nos haya generado de GOOGLE_SERVICE_ACCOUNT_MAIL

# Endpoint

## `POST` /crm/gsheets/:hoja

Donde hoja sería el número de hoja empezando por 0. Si solo hay una hoja, sería la 0. La segunda hoja, sería la 1. Y así.

Recibe un objeto en body, y lo que va a hacer es meter esa data como una fila nueva en esa hoja de Google Spreadsheets. La primera fila serán los headers y si no existe los generará, utilizando las keys del objeto como nombre de cada columna.

El objeto debe ser plano, es decir, que creará una columna en la hoja por cada key del objeto que se envíe en el body. Por tanto, el objeto debe ser exclusivamente un objeto sin propiedades anidades, como clave/valor, donde la clave se corresponderá con el header (usará la columna existente con ese mismo nombre o la creará si no existe) y el valor tiene que ser de tipo numérico o string.

## MS Dynamics

# MS Dynamics (Comillas)

## Variables de entorno

Requiere tener estas variables de entorno en la API Pública:

```json
export dynamicsClientId=""
export dynamicsClientSecret=""
export dynamicsResource=""
export dynamicsAuthId=""
export dynamicsAllowedGetPaths="gad_events"
export dynamicsAllowedPostPaths="com_informationrequests,leads,contacts"
export dynamicsAllowedPatchPaths="leads,contacts"
```javascript

Donde:

- dynamicsAuthId es el id que se indica como parte del path en la autenticación de usuario. La autenticación se hace contra la url `https://login.microsoftonline.com/**{{dynamicsAuthId}}**/oauth2/token`
- dynamicsAllowedGetPaths son los paths válidos para operaciones de get, separados por comas.
- dynamicsAllowedPostPaths son los paths válidos para operaciones de post, separados por comas.

Los allowedPaths son necesarios para ofrecer una seguridad de que esto no se va a utilizar para operaciones indebidas.

## `GET` /crm/dynamics/:path/?xml=:xml

Permite recuperar datos del CRM.

El path debe estar en `dynamicsAllowedGetPaths`.

El parámetro xml es la petición con un encodeURI. Por ejemplo:

```json
<fetch mapping='logical'>
   <entity name='account'>
      <attribute name='accountid'/>
      <attribute name='name'/>
      <attribute name='accountnumber'/>      
</entity>
</fetch>
```javascript

Ejemplo de petición:

`/crm/dynamics/gad_events/?xml=%3Cfetch version=%221.0%22 output-format=%22xml-platform%22 mapping=%22logical%22 distinct=%22false%22 no-lock=%22false%22%3E%3Centity name=%22gad_event%22%3E%3Cattribute name=%22entityimage_url%22 /%3E%3Cattribute name=%22gad_name%22 /%3E%3Cattribute name=%22com_urlevento%22 /%3E%3Cattribute name=%22gad_urleventregistration%22 /%3E%3Cattribute name=%22gad_eventtype%22 /%3E%3Cattribute name=%22gad_eventdate%22 /%3E%3Cattribute name=%22com_eventosasistencia%22 /%3E%3Cattribute name=%22gad_campaignrelid%22 /%3E%3Cattribute name=%22com_cdigoevento%22 /%3E%3Cattribute name=%22gad_venueid%22 /%3E%3Cattribute name=%22gad_eventid%22 /%3E%3Cattribute name=%22com_cerrado%22 /%3E%3Cattribute name=%22com_cursoacadmico%22 /%3E%3Cattribute name=%22statecode%22 /%3E%3Cattribute name=%22com_plazas%22 /%3E%3Corder attribute=%22gad_name%22 descending=%22false%22 /%3E%3Cfilter type=%22and%22%3E%3Ccondition attribute=%22statecode%22 operator=%22eq%22 value=%220%22 /%3E%3Ccondition attribute=%22gad_eventtype%22 operator=%22in%22%3E%3Cvalue%3E810460000%3C/value%3E%3Cvalue%3E181410000%3C/value%3E%3Cvalue%3E810460002%3C/value%3E%3Cvalue%3E810460007%3C/value%3E%3Cvalue%3E181410001%3C/value%3E%3Cvalue%3E810460005%3C/value%3E%3Cvalue%3E181410004%3C/value%3E%3Cvalue%3E181410003%3C/value%3E%3Cvalue%3E181410005%3C/value%3E%3C/condition%3E%3Ccondition attribute=%22com_cursoacadmico%22 operator=%22eq%22 value=%22181410008%22 /%3E%3C/filter%3E%3C/entity%3E%3C/fetch%3E`

## `POST` /crm/dynamics/:path

Permite enviar datos al CRM.

El path debe estar en `dynamicsAllowedPostPaths`.

En el body hay que indicar los datos que queremos enviar, en formato JSON.

Por ejemplo:

```json
{
    "com_subject":"Información Solicitada",
    "com_name":"Descarga Folleto",
    "com_datetimerequest":"2023-06-27T10:39:11.817Z",
    "com_firstname":"TEST USER",
    "com_lastname":"TEST USER",
    "com_telephone1": "666778899",
    "com_emailaddress1":"user@example.com",
    "com_codigopostal":"28001",
    "com_programofinterest":"TEST USER",
    "com_requestchannel":181410002
}
```javascript

## `PATCH` /crm/dynamics/:path/:id

Permite enviar datos al CRM.

El path debe estar en `dynamicsAllowedPatchPaths`.

En el body hay que indicar los datos que queremos enviar, en formato JSON.

El id es el id del dato que vamos a editar.

## `POST` /crm/dynamics/relation/:dataName/:dataId/:relationName/:relatedName/:relatedId

Crea una relación entre dos entidades.

Por ejemplo, en Comillas la llamada: /crm/dynamics/relation/leads/9cfcb02c-ac69-ed11-9561-000d3aaa0e50/com_Lead_com_ConvocatoriasEventos_com_Convoca/com_convocatoriaseventoses/46223757-56c7-ed11-b597-6045bdf4468c genera el equivalente a haber llamado a:

[https://upcomillas.crm4.dynamics.com/api/data/v9.2/leads(9cfcb02c-ac69-ed11-9561-000d3aaa0e50)/com_Lead_com_ConvocatoriasEventos_com_Convoca/$ref](https://upcomillas.crm4.dynamics.com/api/data/v9.2/leads(9cfcb02c-ac69-ed11-9561-000d3aaa0e50)/com_Lead_com_ConvocatoriasEventos_com_Convoca/$ref) con el body {"@odata.id": "[https://upcomillas.crm4.dynamics.com/api/data/v9.2/com_convocatoriaseventoses(46223757-56c7-ed11-b597-6045bdf4468c)](https://upcomillas.crm4.dynamics.com/api/data/v9.2/com_convocatoriaseventoses(46223757-56c7-ed11-b597-6045bdf4468c))"}

## Marketing Cloud

# Marketing Cloud

## Variables de entorno

```bash
export marketingCloudClientId="*****"
export marketingCloudClientSecret="****"
export marketingCloudAccountId="****"
export marketingCloudSubdomain="mcz576vjfc-*****-lyy0"
```javascript

## `POST/GET/PUT` /crm/marketingcloud/:path

Internamente hace la conexión para obtener el token y luego hace la petición al endpoint de Marketing Cloud indicado en el path, usando el token generado y pasando lo que haya recibido en el body. Si se produce un error generará la alerta correspondiente en el sistema.

**Ejemplo: Usar el endpoint de messaging de Marketing Cloud.** 

Petición: POST /crm/marketingcloud/messaging/v1/email/messages

Body:

```bash
{
    "definitionKey": "TheMKTGame_TS",
    "recipients": [
        {
            "contactKey": "THEMKTGAMESFMC",
            "to": "soporteseidorthemarketinggame@gmail.com",
            "attributes": {
                "AnoEscolarParticipante1": "12º ano/3º ano",
                "AnoEscolarParticipante2": "11º ano/2º ano",
                "AnoEscolarParticipante3": "10º ano/1º ano",
                "EmailParticipante1": "alberto@mailinator.com",
                "EmailParticipante2": "barbara@mailinator.com",
                "EmailParticipante3": "carlos@mailinator.com",
                "EscolaParticipante1": "A escola",
                "EscolaParticipante2": "Balcon",
                "EscolaParticipante3": "Colegio",
                "ID_Equipa": "Equipotres7",
                "NomeDaEquipa": "Equipotres7",
                "NomeParticipante1": "Alberto Álvarez",
                "NomeParticipante2": "Bárbara Benítez",
                "NomeParticipante3": "Carlos Cartes",
                "PaisParticipante1": "Angola",
                "PaisParticipante2": "Bélgica",
                "PaisParticipante3": "Canadá",
                "RGPD": true,
                "TelemovelParticipante1": "00351213111111",
                "TelemovelParticipante2": "00351213222222",
                "TelemovelParticipante3": "00351213333333"
            }
        }
    ]
}
```javascript

## Melissa

# Melissa

## `GET` /crm/melissa/:phone

Comprueba si existe el número de teléfono indicado. El número de teléfono debe llevar prefijo internacional y empezar por dos 0, ej: 00639123456

Devuelve 200 ok si todo está ok, o 400 si ha fallado la petición.

**⚠️ IMPORTANTE**: La variable de entorno melissaKey debe estar correctamente configurada en API Pública. Si no está correctamente configurada, el endpoint dará un error y al mismo tiempo enviará una alerta. Si falla el sistema de Melissa, devolverá ok (para no bloquear la recepción de leads) y al mismo tiempo enviará una alerta.

## Nubika

# Nubika (Garrigues)

## Variables de entorno

Requiere tener estas variables de entorno en la API Pública:

```bash
#crm
# OJO ¡Este código de Melissa es de Garrigues!
export melissaKey="[REDACTED]"
export nubikaEndpoint="https://cloud.sfmc....."
export nubikaClientId="[REDACTED]"
export nubikaClientSecret="[REDACTED]"
```javascript

## `POST` /crm/nbk?melissa=xxxxxxx

Envía un formulario a la api de Nubika.

Lo que hace es reenviar el body de la petición a Nubika, utilizando el endpoint, clientId y clientSecret indicados en las variables de entorno, y devolver la misma respuesta.

El parámetro Melissa es opcional. [Consideraciones sobre Melissa (importante)](Consideraciones sobre Melissa (importante) a7de1b0f0d614ae1b2204c5825439d54.md) 

**Respuesta si falla Melissa:**

```json
{
    "code": 400,
    "message": "MELISSA_FAIL"
}
```javascript

**Respuesta en el resto de casos de error (el mensaje puede ser distinto en función del error que se haya producido):**

```json
{
    "code": 400,
    "message": "Invalid data."
}
```javascript

**Respuesta en caso positivo:**

```json
{
	"success": true,
	"message": (id_de_la_petición)
}
```javascript

## Consideraciones sobre Melissa

# Consideraciones sobre Melissa (importante)

Melissa está integrado en algunas peticiones al CRM. Generalmente esta integración se realiza añadiendo a la query de la petición al CRM una variable melissa cuyo valor sea el teléfono a chequear.

Este teléfono tiene que incluir el prefijo. Para que no de problemas, lo ideal es que:

1. El teléfono no tenga caracteres especiales.
2. El teléfono incluya el prefijo de país (imprescindible)
3. El prefijo de país tenga 3 dígitos, rellenando con ceros a la izquierda si es necesario. 

Por ejemplo, mi teléfono es de España (34) y es el 639029692. Para que el check funcione bien con Melissa, tendré que facilitar ?melissa=034639029692.

### A tener en cuenta también:

- Cuando no se indica el parámetro melissa a la query no se hace ningún check de Melissa.
- Cuando no se encuentra la variable de entorno de Melissa, se obtiene un error.
- En el check de Melissa, se obtiene el OK siempre que Melissa no haya dicho explícitamente que ese teléfono sea malo. Más desarrollado, Melissa puede dar diferentes respuestas, y en todas se dará una respuesta OK excepto cuando la respuesta sea PExx:
    - GExx = Hay un problema con la licencia o no le quedan créditos. No se va a rechazar un registro porque alguien no renovó la licencia o los créditos de Melissa.
    - SExx = Fallo interno dentro de Melissa. No se van a rechazar registros porque Melissa no esté funcionando y tenga un problema interno que no tiene nada que ver con el cliente.
    - PSxx = Teléfono ok o en estudio posterior. Aquí directamente el teléfono se está dando por bueno.
    - PExx = Teléfono malo. Este es el único caso en el que consideramos que el teléfono es malo.
- Con independencia de qué haya puesto el usuario en el formulario, si el prefijo se intuye del país o se pone específicamente, etc., lo que se va a chequear no es lo que viene en el formulario, sino única y exclusivamente lo que viene en la query con el parámetro melissa. Ej: `public-api.griddo.centrogarrigues.com/crm/nbk?melissa=034639029692`

### Otras consideraciones

El cliente puede tener distintos requisitos sobre qué hacer con los números de teléfono. Ha de ser el front quien se encargue de hacer esas validaciones (que el teléfono exista por ejemplo) y haga lo que tenga que hacer a la hora de facilitar el parámetro melissa en la petición.

Por ejemplo:

- El cliente no quiere validar con Melissa los teléfonos argentinos. En ese caso, cuando el país sea Argentina, no enviaremos el parámetro Melissa a la petición. Si no enviamos el parámetro, la validación no se hace.
- El cliente quiere que los teléfonos de Marruecos vayan sin 0 delante. En ese caso, en el parámetro Melissa pasaremos la versión del teléfono que cumpla esa regla, con independencia de lo que vaya en el formulario (el check de Melissa nunca se hace sobre el contenido del formulario, sino sobre lo que pasemos en el parámetro Melissa).
- El cliente no quiere que se envíen teléfonos sin la cantidad de dígitos correcta ni formularios sin teléfono. En el front chequeamos todo esto y no enviamos la petición si no se cumple.
---
# Variables de entorno de API Pública

# Notas

`PRIVATE_API_URL` debe incluir el puerto.

Lo normal es que el puerto al que se conecte a la API Privada sea el mismo puerto en el que se está ejecutando, pero esto impediría trabajar con ambas API en local (chocarían los puertos).

# .env.dev (ejemplo)

```bash
#global
export PORT='3000'
export PRIVATE_API_URL='http://localhost:3001'

# Si lo quieres usar con la API live
# export PRIVATE_API_URL='your-instance.griddo.io'
export gridLogo = "your-logo-url"

#entorno
#Si entorno es dev (1/true/on) se muestran logs en respuesta
export GRIDDO_isDev=1

#bot
#DEV Griddo
export botEmail='admin@example.com'
export botPassword="[REDACTED]"

#Staging Griddo
# export botEmail='admin@example.com'
# export botPassword="[REDACTED]"

#jwt
export jwtKey="304e3caa9ce93446083324b642a1784b@lic43"

#caché
export cacheControlList="public, max-age=7200, s-maxage=7200, stale-if-error=3600, stale-while-revalidate=3600"
#export cacheControlList="no-store" #Para no cachear nada, ideal entornos develop

#s3
export filesS3Bucket=""
export filesS3URL=""
export filesS3AccessKey=""
export filesS3AccessSecretKey=""
export filesS3Folder=""

#mails

#mailFrom es opcional. Si no hay smtpFrom el remitente es Griddo
#OJO: Si se usa mailFrom con sendGrid, el remitente debe estar registrado en sendGrid
#OJO: Con smtp es obligatorio usar mailFrom, y debe estar autorizado en el servidor smtp
export mailFrom="Secuoyas <user@example.com>"

#sendgrid
export sendGridApi="[REDACTED]"

#googleCalendarAPI
export calendarClientId="93975334972-6cls3tsltco2in00e61ig4nomacrt92n.apps.googleusercontent.com"
export calendarClientSecret="[REDACTED]"
export calendarRefreshToken="[REDACTED]"
```
---
# Feeds

## `GET` /feed/:slug/:format

Devuelve un array con el feed que se corresponde con ese slug el cual ha sido configurado a través de AX (aún no disponible esa opción) o API Privada ([Feeds](../../API Privada/Endpoints/Feeds 06961a447cf34c159f740570a9a3364a.md) ).

La respuesta incluirá las cabeceras de caché correspondientes según lo configurado en el propio feed, y en el formato indicado, que puede ser “json” o “rss”. Por defecto la respuesta será json.

Ejemplo:

```json
[
    {
        "structuredData": "STORIES",
        "id": 6383,
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
        "relatedSite": 88,
        "relatedPage": 5623,
        "content": {
            "who": "Íñigo Montoya",
            "position": "Vengador"
        },
        "modified": "2023-04-14T12:04:29.000Z",
        "published": "2023-04-14T12:04:29.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6386,
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
        "relatedSite": 88,
        "relatedPage": 5626,
        "content": {
            "who": "Íñigo Montoya",
            "position": "Vengador"
        },
        "modified": "2023-04-14T12:04:29.000Z",
        "published": "2023-04-14T12:04:29.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6117,
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
        "relatedSite": 88,
        "relatedPage": 4526,
        "content": {
            "who": "Íñigo Montoya",
            "position": "Vengador"
        },
        "modified": "2022-11-14T13:08:41.000Z",
        "published": "2022-11-14T13:08:41.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6115,
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
        "relatedSite": 88,
        "relatedPage": 4519,
        "content": {
            "who": "Novak Djokovic",
            "position": "Tennis player"
        },
        "modified": "2022-11-10T10:13:33.000Z",
        "published": "2022-11-10T10:13:33.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6007,
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
        "relatedSite": 88,
        "relatedPage": 4278,
        "content": {
            "who": "Íñigo Montoya",
            "position": "Vengador"
        },
        "modified": "2022-08-24T08:20:37.000Z",
        "published": "2022-08-24T08:20:37.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6756,
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
        "relatedSite": 88,
        "relatedPage": 8304,
        "content": {
            "who": "Name",
            "position": "Position"
        },
        "modified": "2023-07-28T09:14:48.000Z",
        "published": "2023-07-28T09:14:48.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6082,
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
        "relatedSite": 88,
        "relatedPage": 4484,
        "content": {
            "who": "Professor Type 2",
            "position": "Position"
        },
        "modified": "2022-11-08T11:09:24.000Z",
        "published": "2022-11-08T11:09:24.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6758,
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
        "relatedSite": 88,
        "relatedPage": 8306,
        "content": {
            "who": "Professor Type 2 and 3",
            "position": "Position"
        },
        "modified": "2023-07-28T09:14:48.000Z",
        "published": "2023-07-28T09:14:48.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6453,
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
        "relatedSite": 88,
        "relatedPage": 6806,
        "content": {
            "who": "Name",
            "position": "Position"
        },
        "modified": "2023-08-03T09:28:00.000Z",
        "published": "2023-04-26T11:08:34.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6775,
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
        "relatedSite": 88,
        "relatedPage": 8325,
        "content": {
            "who": "Name",
            "position": "Position"
        },
        "modified": "2023-08-03T09:28:40.000Z",
        "published": "2023-08-03T09:28:40.000Z"
    },
    {
        "structuredData": "STORIES",
        "id": 6757,
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
        "relatedSite": 88,
        "relatedPage": 8305,
        "content": {
            "who": "Student Type 3",
            "position": "Position"
        },
        "modified": "2023-07-28T09:14:48.000Z",
        "published": "2023-07-28T09:14:48.000Z"
    }
]
```
---
# Files

## `POST` /files

Sube a un S3 el fichero indicado en el body (un único archivo, en base64, completo).

**Ejemplo de la petición:**

```json
{
    "content": "data:application/pdf;base64,JVBERi0xLjYNJeLjz9MNCjM3IDAgb2JqIDw8L0xpbmVhcml6ZWQgMS9MIDIwNTk3L08gNDAvRSAxNDExNS9OIDEvVCAxOTc5NS9IIFsgMTAwNSAyMTVdPj4NZW5kb2JqDSAgICAgICAgICAgICAgICAgDQp4cmVmDQozNyAzNA0KMDAwMDAwMDAxNiAwMDAwMCBuDQowMDAwMDAxMzg2IDAwMDAwIG4NCjAwMDAwMDE1MjIgMDAwMDAgbg0KMDAwMDAwMTc4NyAwMDAwMCBuDQowMDAwMDAyMjUwIDAwMDAwIG4NCjAwMDAwMDIyNzQgMDAwMDAgbg0KMDAwMDAwMjQyMyAwMDAwMCBuDQowMDAwMDAyODQ0IDAwMDAwIG4NCjAwMDAwMDI4ODggMDAwMDAgbg0KMDAwMDAwMjkzMiAwMDAwMCBuDQowMDAwMDA0MTEzIDAwMDAwIG4NCjAwMDAwMDQxNDcgMDAwMDAgbg0KMDAwMDAwNDIxMSAwMDAwMCBuDQowMDAwMDA2ODgwIDAwMDAwIG4NCjAwMDAwMDcwMjMgMDAwMDAgbg0KMDAwMDAwNzE3MiAwMDAwMCBuDQowMDAwMDA3MzEyIDAwMDAwIG4NCjAwMDAwMDc0NTUgMDAwMDAgbg0KMDAwMDAwODE3NiAwMDAwMCBuDQowMDAwMDA4NTY2IDAwMDAwIG4NCjAwMDAwMDkwNjYgMDAwMDAgbg0KMDAwMDAxMjUxOCAwMDAwMCBuDQowMDAwMDEyNjY3IDAwMDAwIG4NCjAwMDAwMTI4MDMgMDAwMDAgbg0KMDAwMDAxMjkzOSAwMDAwMCBuDQowMDAwMDEzMDcyIDAwMDAwIG4NCjAwMDAwMTMyMDggMDAwMDAgbg0KMDAwMDAxMzM0NCAwMDAwMCBuDQowMDAwMDEzNDgwIDAwMDAwIG4NCjAwMDAwMTM2MzIgMDAwMDAgbg0KMDAwMDAxMzgxOCAwMDAwMCBuDQowMDAwMDE0MDM5IDAwMDAwIG4NCjAwMDAwMDEyMjAgMDAwMDAgbg0KMDAwMDAwMTAwNSAwMDAwMCBuDQp0cmFpbGVyDQo8PC9TaXplIDcxL1ByZXYgMTk3ODQvWFJlZlN0bSAxMjIwL1Jvb3QgMzkgMCBSL0VuY3J5cHQgMzggMCBSL0luZm8gNiAwIFIvSURbPEMyMUYyMUVBNDRDMUUyRUQyNTgxNDM1RkE1QTJEQ0NFPjwxNTM0OTEwNkQ5ODVEQTQ0OTkxMDk5RjlDMENCRjAwND5dPj4NCnN0YXJ0eHJlZg0KMA0KJSVFT0YNCiAgICAgICAgICAgICAgIA0KNzAgMCBvYmo8PC9MZW5ndGggMTIzL0MgMTI4L0ZpbHRlci9GbGF0ZURlY29kZS9JIDE1MS9MIDExMi9TIDQwPj5zdHJlYW0NCjA+v2UNc4Zmn6u4IiQguoMZnwg0NH0ymtRAWZUZqNfHLCiMQS0kyMfdiuvi04hlG2GJLNJzPFccsqvk0nZ7AHI4uCBvKj3L7sGXnAk1tHgOFgzOJjqRioIZMmIdwW51On/CmLK6+gsvbo3ivOa3aWeWo5GxxRL0DzNdRQ0KZW5kc3RyZWFtDWVuZG9iag02OSAwIG9iajw8L0xlbmd0aCAyMC9GaWx0ZXIvRmxhdGVEZWNvZGUvV1sxIDEgMV0vSW5kZXhbNyAzMF0vRGVjb2RlUGFybXM8PC9Db2x1bW5zIDMvUHJlZGljdG9yIDEyPj4vU2l6ZSAzNy9UeXBlL1hSZWY+PnN0cmVhbQ0KeNpiYmJkYGJgYKQ3BggwABbZAF0NCmVuZHN0cmVhbQ1lbmRvYmoNMzggMCBvYmo8PC9MZW5ndGggMTI4L0ZpbHRlci9TdGFuZGFyZC9PKJ6imv11rrw5sF4j3R+ObJ1lZ2RcbuwZDDZAs8jdl58OFSkvUCAtMTM0MC9SIDMvVSjj41C/LnKptSQ/7nBNpOwWAAAAAAAAAAAAAAAAAAAAACkvViAyPj4NZW5kb2JqDTM5IDAgb2JqPDwvTWFya0luZm88PC9MZXR0ZXJzcGFjZUZsYWdzIDAvTWFya2VkIHRydWU+Pi9NZXRhZGF0YSA1IDAgUi9QaWVjZUluZm88PC9NYXJrZWRQREY8PC9MYXN0TW9kaWZpZWQoCM1RrvFnz1Fb5exxrGnDVyk+Pj4+L1BhZ2VzIDQgMCBSL1BhZ2VMYXlvdXQvT25lQ29sdW1uL1N0cnVjdFRyZWVSb290IDcgMCBSL1R5cGUvQ2F0YWxvZy9MYW5nKAm5TsuSKS9MYXN0TW9kaWZpZWQoCM1RrvFnz1Fb5exxrGnDVykvUGFnZUxhYmVscyAyIDAgUj4+DWVuZG9iag00MCAwIG9iajw8L0Nyb3BCb3hbMCAwIDYxMiA3OTJdL0Fubm90cyA0MSAwIFIvUGFyZW50IDQgMCBSL1N0cnVjdFBhcmVudHMgMC9Db250ZW50cyA0NiAwIFIvUm90YXRlIDAvTWVkaWFCb3hbMCAwIDYxMiA3OTJdL1Jlc291cmNlczw8L1hPYmplY3Q8PC9JbTEwIDUwIDAgUi9JbTExIDUxIDAgUi9JbTEyIDUyIDAgUi9JbTEzIDUzIDAgUi9JbTE0IDU1IDAgUi9JbTAgNTcgMCBSL0ltMSA1OCAwIFIvSW0yIDU5IDAgUi9JbTMgNjAgMCBSL0ltNCA2MSAwIFIvSW01IDYyIDAgUi9JbTYgNjMgMCBSL0ltNyA2NCAwIFIvSW04IDY1IDAgUi9JbTkgNjYgMCBSPj4vQ29sb3JTcGFjZTw8L0NTMCA0NCAwIFIvQ1MxIDQ3IDAgUi9DUzIgNDUgMCBSPj4vRm9udDw8L1RUMCA0MyAwIFI+Pi9Qcm9jU2V0Wy9QREYvVGV4dC9JbWFnZUMvSW1hZ2VJXS9FeHRHU3RhdGU8PC9HUzAgNjggMCBSPj4+Pi9UeXBlL1BhZ2U+Pg1lbmRvYmoNNDEgMCBvYmpbNDIgMCBSXQ1lbmRvYmoNNDIgMCBvYmo8PC9SZWN0WzIyMC42OCA0NjcuODggMzg5LjQ2MSA0ODMuODUyXS9TdWJ0eXBlL0xpbmsvQlM8PC9TL1MvVyAwL1R5cGUvQm9yZGVyPj4vQSA0OCAwIFIvSC9JL1N0cnVjdFBhcmVudCAxL0JvcmRlclswIDAgMF0vVHlwZS9Bbm5vdD4+DWVuZG9iag00MyAwIG9iajw8L1N1YnR5cGUvVHJ1ZVR5cGUvRm9udERlc2NyaXB0b3IgNjcgMCBSL0xhc3RDaGFyIDEyMS9XaWR0aHNbMjc4IDI3OCAwIDAgMCAwIDAgMCAzMzMgMzMzIDAgMCAyNzggMCAyNzggMjc4IDU1NiA1NTYgNTU2IDU1NiAwIDAgNTU2IDU1NiAwIDAgMjc4IDAgMCAwIDAgMCAwIDY2NyA2NjcgNzIyIDcyMiA2NjcgNjExIDAgMCAwIDAgMCAwIDAgMCAwIDY2NyAwIDAgMCA2MTEgMCAwIDk0NCAwIDY2NyAwIDAgMCAwIDAgMCAwIDU1NiA1NTYgNTAwIDU1NiA1NTYgMjc4IDU1NiA1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aWdodCAzL1R5cGUvWE9iamVjdD4+c3RyZWFtDQo3R633u5PILuNh2uqR/GEFIj0vDQplbmRzdHJlYW0NZW5kb2JqDTU5IDAgb2JqPDwvU3VidHlwZS9JbWFnZS9MZW5ndGggNy9CaXRzUGVyQ29tcG9uZW50IDgvQ29sb3JTcGFjZSA0NyAwIFIvV2lkdGggMS9IZWlnaHQgMi9UeXBlL1hPYmplY3Q+PnN0cmVhbQ0K14/pGKyXxA0KZW5kc3RyZWFtDWVuZG9iag02MCAwIG9iajw8L1N1YnR5cGUvSW1hZ2UvTGVuZ3RoIDcvQml0c1BlckNvbXBvbmVudCA4L0NvbG9yU3BhY2UgNDcgMCBSL1dpZHRoIDIvSGVpZ2h0IDEvVHlwZS9YT2JqZWN0Pj5zdHJlYW0NCrN3Ds5BHkkNCmVuZHN0cmVhbQ1lbmRvYmoNNjEgMCBvYmo8PC9TdWJ0eXBlL0ltYWdlL0xlbmd0aCA0L0JpdHNQZXJDb21wb25lbnQgOC9Db2xvclNwYWNlIDQ3IDAgUi9XaWR0aCAxL0hlaWdodCAxL1R5cGUvWE9iamVjdD4+c3RyZWFtDQrx8DB4DQplbmRzdHJlYW0NZW5kb2JqDTYyIDAgb2JqPDwvU3VidHlwZS9JbWFnZS9MZW5ndGggNy9CaXRzUGVyQ29tcG9uZW50IDgvQ29sb3JTcGFjZSA0NyAwIFIvV2lkdGggMi9IZWlnaHQgMS9UeXBlL1hPYmplY3Q+PnN0cmVhbQ0K9/8xai1TaA0KZW5kc3RyZWFtDWVuZG9iag02MyAwIG9iajw8L1N1YnR5cGUvSW1hZ2UvTGVuZ3RoIDcvQml0c1BlckNvbXBvbmVudCA4L0NvbG9yU3BhY2UgNDcgMCBSL1dpZHRoIDIvSGVpZ2h0IDEvVHlwZS9YT2JqZWN0Pj5zdHJlYW0NCiN83Skmd7gNCmVuZHN0cmVhbQ1lbmRvYmoNNjQgMCBvYmo8PC9TdWJ0eXBlL0ltYWdlL0xlbmd0aCA3L0JpdHNQZXJDb21wb25lbnQgOC9Db2xvclNwYWNlIDQ3IDAgUi9XaWR0aCAyL0hlaWdodCAxL1R5cGUvWE9iamVjdD4+c3RyZWFtDQpDpbHuCaveDQplbmRzdHJlYW0NZW5kb2JqDTY1IDAgb2JqPDwvU3VidHlwZS9J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MDAwMDAwIDY1NTM1IGYNCjAwMDAwMTQxMTUgMDAwMDAgbg0KMDAwMDAxNDk2NSAwMDAwMCBuDQowMDAwMDE0OTk4IDAwMDAwIG4NCjAwMDAwMTUwMjEgMDAwMDAgbg0KMDAwMDAxNTA3MiAwMDAwMCBuDQowMDAwMDE5NDg0IDAwMDAwIG4NCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCnRyYWlsZXINCjw8L1NpemUgMzcvRW5jcnlwdCAzOCAwIFI+Pg0Kc3RhcnR4cmVmDQoxMTYNCiUlRU9GDQo="
}
```javascript

**Ejemplo de la respuesta:**

```json
{
    "url": "http://dam-sandbox.s3-website.eu-west-3.amazonaws.com/test-file-upload/30990ff7-c750-40a4-8247-b8c6e5d1a982.pdf"
}
```javascript

## Configuración en infra

Para que esto funcione, en infra de la api pública necesitamos tener creadas estas variables de entorno:

```json
export filesS3Bucket="dam-sandbox"
export filesS3URL="http://dam-sandbox.s3-website.eu-west-3.amazonaws.com/"
export filesS3Folder="test-file-upload"
```javascript

Siendo:

- `files3Bucket` el nombre del bucket en el que guardar los archivos. La instancia en la que se ejecuta api pública debe tener acceso a ese bucket.
- `filesS3URL` el domino al que responde ese bucket o por el que se accederá a esos ficheros. Si esos ficheros tienen que estar protegidos por un SSO o cualquier otro sistema, se pueden proteger usando el propio DNS del dominio.
- `filesS3Folder` la carpeta en la que se guardarán los archivos dentro de ese S3. Es opcional.

Además, es necesario que la máquina que ejecuta la api pública tenga asignado un rol con permisos de acceso al bucket S3 referido en la configuración.
---
# Filtros

## `GET` /filters/:structuredData/site/:site/lang/:lang/related/:related/allLanguages/:allLanguages/order/:order/groupingCategories/:groupingCategories
`GET` /filters/:structuredData/site/:site/lang/:lang/cached/:cache

Devuelve la información de todos los datos estructurados que se relacionan con el dato estructurado indicado en el site e idioma especificados, para poder establecer cuáles son los filtros que se pueden mostrar al usuario. Solo tiene en cuenta los datos reales que están disponibles, que no sean borrador ni estén eliminados, y que estén siendo usados por al menos un dato existente. Por ejemplo, si un Pathway está en la base de datos pero no está siendo usado por ningún programa, al ver los filtros de programas ese Pathway no aparecerá.

Podemos especificar tanto uno como varios datos estructurados si los separamos por comas y podemos especificar tanto un id numérico(`GET/filters/4538,5955,5958/site/86/lang/4/`) como el id del dato en concreto(`GET/filters/NEWS,PROGRAMS/site/86/lang/4/`)

- `related` Opcional. Id o lista de ids de categorías por las que queremos filtrar las categorías que nos devuelve el endpoint. Hay que especificar por qué ids queremos filtrar cada uno de los datos estructurados que pasemos en listado. Ejemplo, Si en list mandamos `…list/STORIES,NEWS/…` en ese caso en los filtros deberíamos especificarlo de la siguiente manera `.../STORIES:4420,4418;NEWS:6268/...`
**Es necesario respetar el formato:** Nombre del dato seguido de dos puntos, luego los ids por lo que queremos filtrar separados por coma. Una vez hayas terminado de especificar los ids usaremos punto y coma para seleccionar el otro dato estructurado y repetiremos el formato. Si solo quisieras especificar los filtros para un dato estructurado sería simplemente `.../STORIES:4420,4418/...`

 **

Pongamos que en el site 5 tenemos tres noticias en inglés con categorías asociadas

```json
noticia 1: se relaciona con categorías derecho(id 12), legal(id 31)
noticia 2: se relaciona con categorías tech(id 11), legal(id 31)
noticia 3: se relaciona con categorias actualidad(id 65), corporativo(id 73)
```javascript

Si queremos todos los filtros, pero solo los de las noticias que estén relacionadas con la categoría legal tan solo tendremos que añadir el related en la llamada de la siguiente manera:

`GET /filters/NEWS/site/5/lang/1/related/NEWS:31` Esto nos devolverá "derecho, tech, legal". No nos devolvería actualidad, porque no hay ninguna noticia de la categoría actualidad que esté en el área legal, ni tampoco nos devolvería "corporativo" por la misma razón.

Si le pasas varios ids separados por comas la relación que hará entre los ids será la de un **AND,** es decir devolverá las categorías asociadas a los datos estructurados que tengan todas las categorías que le pides.

- `filterOperator` y `globalOperator`: opcionales. Por defecto `OR` para **filterOperator** y `AND`  para **globalOperator**. Son los operadores lógicos (or/and) a aplicar sobre los ids que hemos establecido en el parámetro **related.** Su funcionamiento es similar al de los listados con la excepción de que en lugar de devolver los datos estructurados devolverá las categorías asociadas a esos datos estructurados.
    
    El filterOperator es el filtro que se aplica para las categorías del mismo grupo y el globalOperator se aplica entre los grupos de categorías. Por ejemplo, si queremos un distribuidor de noticas, y en el filtro indicamos dos escuelas (ESCUELA_1, ESCUELA_2) y dos áreas (AREA_1, AREA_2), filterOperator se aplicará a los filtros de escuelas y a los de áreas, y globalOperator se aplicará a la relación entre escuelas y áreas. Es decir, sería un (ESCUELA_1 ${filterOperator} ESCUELA_2) ${globalOperator} (AREA_1 ${globalOperator} AREA_2). Si filterOperator es or y globalOperator es and (que son los valores por defecto), nos quedaría: (ESCUELA_1 or ESCUELA_2) and (AREA_1 or AREA_2). Mientras no se indiquen explícitamente en los default de la template ni se puedan gestionar desde AX se estarán usando esos valores por defecto.
    
- `allLanguages` : Puede ser `on` || `off`, por defecto `off`. Su funcionamiento es el mismo que en los listados. Devolverá todas las categorías del dato que indiquemos en cualquier idioma y en caso de que una categoría tenga traducción, devolverá la categoría que esté en el idioma que pasemos por `lang`.  Si no especificamos el `allLanguages` devolverá solo las categorías en el idioma que llegue en `lang`.
- `order`. Opcional. Le indica el orden. Puede ser `date-desc` (por defecto), `date-asc`, `title-asc`, `title-desc`, o cualquier campo custom (que en el esquema haya sido marcado con indexable) añadiéndole el -asc o -desc.
- `groupingCategories` Opcional. Acepta los valores ‘on’ y ‘off’, por defecto ‘off’. Cuando es on las categories se ordenan según el orden establecido por defecto por el cliente. Si se usa en conjunto con el order mantendrán el orden por grupos, pero se ordenarán por el criterio establecido
    - Con `order: date` Los grupos se mantendrán en su sitio pues no tienen date de creación establecido, pero las categorías si que se ordenarán
    - Con `order: title` Ordenará alfabéticamente tanto los grupos como las categorías
    - Con `order: custom` Ordenará solo las categorías por que los grupos no se pueden definir en schemas

**Importante**: Si lang es 0, nos devolverá los datos en todos los idiomas disponibles.

```json
{
    "SCHOOLS": {
        "label": "Schools",
        "items": [
            {
                "id": 4160,
                "label": "Sch Glo",
								"language": 2
            },
            {
                "id": 2905,
                "label": "Law",
								"language": 2
            }
        ]
    },
    "UNIT": {
        "label": "Unit",
        "items": [
            {
                "id": 4220,
                "label": "Bachelor",
								"language": 2
            },
            {
                "id": 4254,
                "label": "Exponential Learning",
								"language": 2
            }
        ]
    },
    "PATHWAYS": {
        "label": "Pathways",
        "items": [
            {
                "id": 3181,
                "label": "Technology & Data",
								"language": 2
            }
        ]
    },
    "FORMAT": {
        "label": "Format",
        "items": [
            {
                "id": 4212,
                "label": "Full Time",
								"language": 2
            }
        ]
    }
}
```
---
# Formularios

## `POST` /form

**🔑 Requiere autenticación.**

Este endpoint envía los datos de un formulario vía mail. 

En realidad es hacer una petición a este endpoint pasándole en el body de la petición un objeto con los datos del formulario (los campos dan igual). Por ejemplo:

```bash
{
	"to": "user@example.com",
  "subject": "Envío de formulario desde la web",
	"name": "Test",
	"message": "Hello",
	"attachments": [
]
}
```javascript

El campo `to` es obligatorio, ya que es la dirección a la que se enviará el mail.

El campo `subject` es opcional pero altamente recomendado, porque será el asunto del correo que se envía.

Se puede añadir una propiedad `attachments` con los ficheros adjuntos que se quieran incluir. Se trata de un array de objetos, un objeto por archivo a adjuntar, y con el content en base64. Ejemplo:

```html
{
    "to": "user@example.com",
    "subject": "Prueba mail",
    "nombre": "User",
    "ciudad": "Madrid",
		"comments": "Hola quiero comprarlo todo.",
    "attachments": [
        {
            "content": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAAAwCAMAAADtsU7hAAAAk1BMVEUAAAA5xeM7w9w8wdwZ6Z4Y55sY550Y6p48wto8w9sZ6p4X558Y6J08w90Y55cY558Z6Z8Z6Js7wt0Z6J0Y554Z6J5Av90Z6Z47xNw7wt08w907xN0a6p8Y6Jw6v9ww0MgY6Z42ydQ8w909wtwZ6p41yc8k3bIZ6Z81ytMk3LMq1708w90Z6Z4u0cU2ydQf46kq1r1oVx+YAAAAK3RSTlMAH6CA30Bgv2BA7xCAvyAgnzDfcKCQEM/vcJDfn1Aw79/Pr1CwgO/fv79gC+q1ZQAAAsVJREFUWMPtltl6mzAQRgeMgFhgFu9O7Gbthurk/Z+uwGgYNHbjtM2nK58r+D+Y44GRDHycfdRRgSRsOoI/5PD/xKZDXcVX8eeL9axDexYzV/FV/JdiNS/Lcl4BQDB5zPP80EZJy48wzx/Tvmqad7BAz5dlme1ZLEphLhSZcpdoZJAo3m6ajpt+3b4eG2QCABNHoBK65QvlotQDicX1MRC6zYhXFKG4PSFSIc74ll+YUymRW8WdYZIZhkVkmONI3PZLhNwxe6WYS0mxXpsxEZqTcdaMxG+Ol8TslWIuJcXYL5PQFnxefGSvKy7MeXF8JkeFZN6m9ulkaqYWKLain/1xHcATuGJqIFGzKo5ILEuRmPOyvX6Bh1MAhQcVjuRYnPbHWyBYPMX6dkKsmEoZW4rFFeY4zRXerGBpW0eykXiLz1yKSbAGRJHYlsqo1CCeY78wXg9LOw8zQArxTs+KY2oAeaBclBrEC/sgEN2fPePVERAfEWfuF0HoiKdACDEQ33Cu8WdqQA4f73hP+Xebi1JaiCkHg+LF8PN5oF7eF+9Nxx0/UsxFqZjEYoxi+47j8V4S3KLsfbE2Y8Mzid1SNO0wLBzK7YToKV7elblBbw3viyHBSl0PVWJI7JRStL6B8xjznlk/Km/Hlk29aZCXS2JlkGkSOTtXRvl6OuQg82Ft6a+NSw2XxFCe3zJ1dJqDyPl1HKQ3uCzW61Mxb0snYig4533yVngPcFkMxfpU3JujEzGNlPSmrvcxgEtiJBtKOV8gxcK4OVAuvwN2TcemrjfH+mFHmstiKOLkvh2XpQpFvkym5j7JNOYw5BnmCpCcbxOsgo6VOAfiX3N3p92llhvwxbZxuU3BD6tGsgM/TBrJFvwQSvFmBX6YeG6ZWT2lFlzVIXgn8CuWO+cEPCHFvnYRKa7BI6n4Q/YGi3OvXnjKkdDX+/0Nd8chRZAA+WIAAAAASUVORK5CYII=",
            "contentType": "image/png",
            "filename": "imagen.png"
        },
        {
            "content": "data:image/png;base64,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",
            "contentType": "image/png",
            "filename": "imagen 2.png"
        }
    ]
}
```javascript

Se adjunta un html de ejemplo para ver cómo es necesario tratar los datos al enviarlos a la API.

La parte del script muestra cómo hay que enviar el resto de campos:

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Demo for Griddo API</title>
</head>
<script>
    var api = 'http://localhost:3001';
    function sendForm(form) {
        form.preventDefault();
        var data = {
						to: 'user@example.com',
						subject: 'Envío desde el formulario web",
				};
        for (var i = 0; i < form.target.length; i++) {
            const { name, value } = form.target[i];
            if (name) data[name] = value;
        };
        fetch(api + '/send-form', {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            method: 'POST',
            body: JSON.stringify(data)
        });
    }
</script>

<body>
    <form onsubmit="sendForm(event)">
        Name:<input name="name" />
        Message:<input name="message" type="textarea">
        <input type="submit" />
    </form>
</body>

</html>
```javascript

Ejemplo en React para pasar a base64 un fichero desde un formulario web.

```html
import React from 'react';
import './App.css';

function App() {
  const onFileChange = async (e) => {
    const fileInfo = await getFileInfo(e?.target?.files[0]);
    if (!fileInfo) return;
    // Verificar la respuesta - Eliminar el console.log.
    console.log(fileInfo);
    console.log(fileInfo.content)
    // Puedes controlar que si el contentType no es el de una imagen aceptada tipo png o jpg se genere un error.
    // Guardar en el objeto para enviar a la API el contenido de fileInfo
  };

  const getFileInfo = async (file) => {
    try {
      if (!file) return null;
      const {
        name,
        type: contentType,
      } = file;
      return {
        filename: name,
        contentType,
        content: await toBase64(file)
      };
    } catch {
      return null;
    }
  };

  const toBase64 = (file) => new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function () {
      resolve(reader.result)
    };
    reader.onerror = function (error) {
      console.log('Error: ', error);
    };
  });

  return (
    <div className="App">
      <form>
        <input type="file" onChange={onFileChange} />
      </form>
    </div>
  );
};

export default App;
```javascript

La configuración del servidor de correo hay que añadirla en el archivo .env

```html
#mails

#mailFrom es opcional. Si no hay smtpFrom el remitente es Griddo
#OJO: Si se usa mailFrom con sendGrid, el remitente debe estar registrado en sendGrid
#OJO: Con smtp es obligatorio usar mailFrom, y debe estar autorizado en el servidor smtp
#export mailFrom="Centro  <user@example.com>"

#sendgrid
export sendGridApi="[REDACTED]"

#smtp (OJO, solo funciona el envío por SMTP si no existe la variable de entorno sendGridApi)
export smtpServer="smtp.office365.com"
export smtpPort=587
export smtpUsername="user@example.com"
export smtpPassword="[REDACTED]"
export smtpSecure="false" #Debe estar desactivado para STARTTLS (0/1, off/on, true/false)
```
---
# GeoIP

## GET /geoip/country

Devuelve el código ISO del país y la ip de la conexión del usuario.

Si no se ubica el país, devuelve XX.

Si la conexión es con TOR y el CDN es CloudFlare, devuelve T1.

```json
{
	"country": "ES",
	"ip": "188.26.219.148"
}
```javascript

OJO: La ip puede ser ip4 o ip6 dependiendo de la configuración de la infra. El mismo código en la misma conexión devuelve ip6 cuando el CDN es CloudFlare e ip4 cuando es CloudFront.
---
# GPX

## `POST`/collect

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

Para una mayor información de lo que hace cada propiedad consultar el [endpoint de API Privada](../../API Privada/Endpoints/GPX 1a4e2540c9e280f68c7dc2b7ca7f1855.md) al que llama este.

## `GET` /profile/areas/:areas/id/:id

Recupera el `calculatedStatus` de un perfil basado en el `id` proporcionado, devolviendo únicamente las áreas solicitadas.

### Parámetros de la URL

- **`:areas`** (OBLIGATORIO):
    
    Lista separada por comas que indica las áreas específicas que se desean recuperar del `calculatedStatus`.
    
    *Ejemplo:* `education,technology`
    
- **`:id`** (OBLIGATORIO):
    
    Identificador único del perfil a consultar.
    
    Este id será un string de tipo uuid
    

Más información en la documentación del [endpoint de API Privada](../../API Privada/Endpoints/GPX 1a4e2540c9e280f68c7dc2b7ca7f1855.md)

## `POST`/pages

Este endpoint actúa como un distribuidor de páginas, delegando la búsqueda al método `getPages` del modelo AI, utilizando los mismos parámetros que éste.

Más información en la documentación del [endpoint de API Privada](../../API Privada/Endpoints/GPX 1a4e2540c9e280f68c7dc2b7ca7f1855.md)
---
# Listados

## Nota importante de qué datos devuelve la API Pública

La API pública siempre devolverá los datos que estén completamente publicados y aquellos pendientes de publicar que ya hayan sido publicados anteriormente.

Por lo tanto, si creamos un dato y lo publicamos por primera vez, el endpoint de listados no lo incluirá en la respuesta hasta que esté completamente publicado.

No obstante, si un dato ya publicado sufre un cambio en el título y por ello pasa a estar pendiente de publicar, sí será devuelto, ya que ha estado publicado previamente.

Si despublicamos este dato, el endpoint no lo incluirá en la respuesta. Tampoco lo incluirá si lo volvemos a publicar, ya que habrá perdido el estado anterior y tendremos que esperar hasta que se publique completamente.

## **Nota importante de caché**

Para que los resultados puedan ser cacheados a distintos niveles (la gestión la realiza la propia API) y garantizar el mejor tiempo de respuesta al mismo tiempo que se limita la cantidad de recursos que se consumen, es importante que cuando se realicen distintas peticiones en todas ellas se intente utilizar el mismo orden tanto en los parámetros como en sus valores.

## La caché y AX

Las llamadas a la API pública y a los listados se cachea conforme a lo indicado en este documento, pero hay una excepción. Cuando se esté utilizando el hook de listados y el módulo se esté mostrando en AX, automáticamente el hook anulará la caché. De esta manera, los listados en la edición de páginas siempre estarán al día.

## Caché, entornos de trabajo y producción

Es posible que en algunos casos queramos trabajar sin caché. Por ejemplo, puede que haya algo que tenga que estar total y absolutamente actualizado en todo momento porque es estratégico. Para hacer esto, hay que añadir un parámetro más que sería:

`/cached/${new Date().valueOf()}`

De esta manera, podemos distinguir cuándo la petición se hace desde el editor y saltarnos la caché (añadimos ese parámetro), o bien cuándo se está haciendo desde una página en producción y sí queremos tener los beneficios de la caché (ignoramos el parámetro). Incluso podemos jugar con ese parámetro, y si queremos una caché de solo 1 hora, poner

`cached/${parseInt(new Date().valueOf()/(1000*60*60))}`

Fíjate que estamos dividiendo el valueOf entre (1000 * 60 * 60), que es 1000 milésimas de segundo, por 60 segundos, por 60 minutos = una hora en milésimas de segundo. Si queremos una caché de 10 minutos, sería:

`cached/${parseInt(new Date().valueOf()/(1000*60*10))}`

En mi opinión, por muy al día que quieras tener algo, si lo puedes cachear aunque sea un par de minutos siempre vas a ganar en rendimiento (especialmente en páginas de alta demanda). Es más, en el caso de Griddo, yo nunca pondría una caché inferior a 10 minutos. Pero al final quien manda es el cliente, y a veces hay casos muy específicos donde todo cambia... por eso la gracia está en que la herramienta te dé toda la flexibilidad que puedas necesitar incluso para casos que ahora mismo ni nos planteamos.

En cualquier caso, la caché máxima sería la indicada en la variable de entorno `cacheControlList` que se gestiona desde infra. Es decir, entre lo indicado en la variable de entorno y lo que indiquemos en la url, **siempre prevalece la menor de las cachés**.

Lo normal sería trabajar con estos valores para cacheControlList (confirmar con infra):

- Entorno develop: `"no-store"`
- Entorno QA: a determinar según necesidades del cliente.
- Entorno producción: `"public, max-age=7200, s-maxage=7200, stale-if-error=3600, stale-while-revalidate=3600"`

## `GET` /list/fixed/:fixed/site/:site/lang/:lang/get/:get/filter/:filter/page/:page/items/:items/relations/:relations/

Devuelve una lista de datos estructurados, cuyos ids se indican, en la versión correspondiente siempre que sea posible para ese site e idioma. Si no existe versión de ese dato para ese site e idioma, siempre que sea posible, se elegirá la versión global y, en el caso de páginas globales, la versión del site canonical.

Lo de las versiones significa que un dato estructurado (puro o de página) puede estar en distintos sites (caso de páginas globales o páginas copiadas entre sites) y en distintos idiomas (caso de las páginas que son traducción de otra). Lo que hacemos es que si le estás diciendo que el site es 1 y el idioma es 1, y el id que indicas en fixed se corresponde con el site 1 pero en el idioma 2, va a dar preferencia a devolverte no el dato exacto que has pedido (site 1, idioma 2) sino el que mejor se ajusta al contexto de site e idioma que le indicas (en este caso, la copia que pudiera haber de esa página en el site 1, idioma 1).

- `fixed`. La lista de ids, separadas por comas.
- `site`.
- `lang`.
- `get`. Opcional, como en el endpoint anterior.
- `relations`. Opcional. Por defecto “off”. Acepta tres valores: `off`, `simple`  y `full`
    
    Esta propiedad devuelve la información de los datos estructurados relacionados con cada item del listado. Por ejemplo estas relaciones pueden ser categorías o otros datos estructurados que se hayan marcado en schemas 
    
    - `off`. Devolverá simplemente un array de ids separados por comas de cada dato relaccionado.
    - `simple`. Devolverá un objeto con dos propiedades. `id` que será un id numérico y `label` que será el título del dato.
    - `full`. Devolverá también un objeto con dos propiedades. `id` que será un id numérico y `content` que será el objeto content completo del dato relacionado.
- `filter`. Opcional. Listado de ids, separados por coma, por los que queremos filtrar los ids que pasemos en `fixed`. Por ejemplo, supongamos que pasamos los ids `8405,8403,8406` que son ids de teachers y queremos filtrar por aquellos que tengan el id `8773` de schools. De esta manera, la consulta sólo nos devolverá la información del `8406` que es el único que lo tiene en el content.
- `page`. Opcional. La página a mostrar. Por defecto es 1.
- `items`. Opcional. Elementos a mostrar por página. Por defecto son los que están marcados en api privada.
- `search`. Opcional. Busca en la respuesta por las palabras que puedan estar o en el `title` o en el `abstract` del dato estructurado.

```bash
# Devuelve un listado de los datos estructurados con id 1, 2 y 3.
<api-url>/list/fixed/1,2,3/site/1/lang/4
# Devuelve el listado con los datos que le llegan el fixed filtrados por el 
# dato que le llega en filter. En este caso el 8406.
/list/fixed/8404,8405,8403,8406/site/29/lang/1/get/title/page/2/items/2/filter/8773
```javascript

## `GET` /list/navigations/reference/:referenceId/site/:site/lang/:lang/order/:order/relations/:relations/items/:items

Devuelve los elementos anteriores y posteriores al dato estructurado indicado como referencia. Devuelve un objeto con las keys previous y next, siendo ambas un array de datos estructurados. Si se produce un error, con la intención de provocar el menor daño posible, devolverá arrays vacíos, además de una key adicional error indicando el error producido.

- `reference`. Es el id del dato estructurado que vamos a usar como referencia. Ojo, es el id del dato estructurado, no el de una página. En una página, el id de su dato estructurado lo tenemos en `structuredData.id`
- `site`.
- `lang`.
- `order`. Le indica el orden. Puede ser `date-desc` (por defecto), `date-asc`, `alpha-asc`, `alpha-desc`, o cualquier campo custom (que en el esquema haya sido marcado con indexable) añadiéndole el -asc o -desc. En este endpoint es obligatorio, ya que marca el sentido de quién será anterior y posterior.
- `relations`. Opcional. Por defecto “off”. Cuando se señala como on (“/relations/on”) se reciben las relaciones mapeadas (en lugar de solo el id, un objeto con id y label).
- `items`. Opcional. Cuántos elementos vamos a recibir. Por defecto es 1. Hay que tener en cuenta que recibiremos el número indicado de elementos tanto en la key de previous como en la de next.

**Ejemplo de respuesta:**

```json
{
    "previous": [
        {
            "structuredData": "NEWS",
            "id": 24533,
            "language": 1,
            "dataLanguages": [],
            "relatedSite": 12,
            "relatedPage": {
                "pageId": 28145,
                "url": "https://www.ie.edu/school-politics-economics-global-affairs/students-living-coronavirus-outbreak/",
                "origin": "GLOBAL",
                "availableSites": [
                    {
                        "id": 5,
                        "name": "ie edu"
                    },
                    {
                        "id": 12,
                        "name": "School of Politics, Economics and Global Affairs"
                    }
                ],
                "editable": false,
                "manuallyImported": true,
                "originalPageId": 2363,
                "originalStructuredDataId": 4392
            },
            "content": {
                "units": null,
                "schools": [
                    {
                        "id": 3027,
                        "content": {
                            "title": "School of Global Public Affairs",
                            "code": "school-of-global-public-affairs",
                            "school": "SPEGA"
                        }
                    }
                ],
                "pathways": null,
                "programs": null,
                "subjectAreas": null,
                "stageTargets": null,
                "centers": null,
                "topics": null,
                "title": "How our students are living the coronavirus outbreak",
                "abstract": "Read about Ana Valverde's, a Bachelor in Law and International Relations student, story on her experience on coronavirus outbreak.",
                "image": {
                    "id": 4938,
                    "name": "students-living-coronavirus-outbreak.jpg",
                    "title": "",
                    "description": "",
                    "alt": "",
                    "tags": [],
                    "url": "https://images.thesaurus.ie.edu/students-living-coronavirus-outbreak",
                    "thumb": "https://images.thesaurus.ie.edu/w/215/h/161/students-living-coronavirus-outbreak",
                    "publicId": "thesaurus/students-living-coronavirus-outbreak_b4367289-222a-43d3-8821-2e05857f0304",
                    "damId": "students-living-coronavirus-outbreak",
                    "published": "2022-04-06T11:18:52Z",
                    "size": 144933,
                    "width": 1092,
                    "height": 678,
                    "orientation": "L",
                    "site": "global"
                },
                "lead": null,
                "longAbstract": "<p></p>\n",
                "content": "<p><em><strong>Ana Valverde - </strong>A fourth-year Bachelor in Law and International Relations student. Here I’m going to describe my experience of adapting to the circumstances posed by COVID-19 outbreak has been. </em></p><p>&nbsp;</p><p>IE started offering online classes from the time when the very first cases in Madrid were detected.  That was already three weeks ago. By that time, we could decide between going to class on campus, and attending classes online. Just a few days later the Government announced that all universities would be closed. From that moment on, all the classes have been online. I feel so lucky to have been able to transition to online teaching from day one, without any issue. Everything was ready to go, as if IE knew this was going to happen. This is so, because IE has always believed in investing in online education to be able to reach every single student wherever they may be in the world.</p><p>I have contacted a few students to compare how they perceive online classes:</p><p><em>“At the beginning it was very difficult to focus, but now I actually pay more attention than I do in normal classes, as they have become the only “appointments” that I have throughout the day.”</em>- Laura Escobar, student of Bachelor in Business Administration and International Relations.</p><p><em>“I think online classes work better than expected. It is true that it represents a challenge to all of us, but with good will and engagement, it is still possible to follow the courses!</em>” –Blanca Úrculo, student of Bachelor in Law and International Relations.</p><p><em> “Classes online are the best-worst alternative to teaching in times of Coronavirus. It’s the best alternative in the sense that it keeps us busy but at the same time, keeping up with math courses online is a challenge...” </em>–María Balasch , student of Bachelor in Business Administration and International Relations.</p><p><em>“Above all, I think that we must be united and patient in front of this situation. We should be proud to have at least the possibility of being able to continue our courses and that this situation does not affect our educational path even if, like all things, this system has its drawbacks”- </em>Jade Ruiz, student of Law and International Relations.</p><p>For <strong>professors</strong>, it was harder at the beginning since some of them aren’t used to technological tools. But thanks to the IT staff they rapidly got the hang of it:</p><blockquote><p>“<em>Online classes have been one of the few advantages of the current situation. It has allowed us to fully immerse ourselves in the teaching experience of the future and has demonstrated -once again- that IE is a visionary institution and world leader in the field of education</em>.”- Luis Leis, Professor of Tax Law.</p></blockquote><p>Having classes online is helping me keep motivated and entertained while in quarantine. Group meetings are now virtual, presentations are given online, and assignments are uploaded on campus or sent to the professors by email. Nothing has changed.  My life is almost as busy as it used to be two weeks ago: working from home in the mornings and online classes in the afternoon.</p><p>Furthermore, this situation is giving me the opportunity to forcibly <strong>improve my IT skills</strong>. For instance, some professors have asked us to send them the group presentations we would have had in class, via online in the format of a video. In order to fulfill that task I have had to learn how to make a proper video: join all of my classmates’ parts, add the audios, etc. I am sure these skills will be very helpful for my future work life.</p><p><img src=\"https://res.cloudinary.com/ieuniversity/image/upload/v1649244094/thesaurus/57028-board-games_detail-1005x670_44a53d09-6bd7-4046-92c9-a3945f8410f9.jpg\" style=\"width: 300px;\" class=\"fr-fic fr-dii fr-fil\" />At the same time, quarantine is allowing me to spend more time with my <strong>family</strong> and take back old traditions like watching movies after lunch in the weekends, playing board games, and reading in the leaving room.</p><p>I have to say I am benefitting a lot from these times. Instead of complaining we should adapt to the new times and circumstances and take out the positive things that they may bring along. As Albert Einstein once said: <strong><em>“In the middle of difficulty lies opportunity”.</em></strong></p>",
                "newsDate": "2020/03/23"
            },
            "modified": "2022-11-20T19:20:33.000Z",
            "published": "2022-11-20T19:20:33.000Z"
        }
    ],
    "next": [
        {
            "structuredData": "NEWS",
            "id": 24459,
            "language": 1,
            "dataLanguages": [],
            "relatedSite": 12,
            "relatedPage": {
                "pageId": 28071,
                "url": "https://www.ie.edu/school-politics-economics-global-affairs/oscar-jonsson-new-academic-director-center-governance-change/",
                "origin": "GLOBAL",
                "availableSites": [
                    {
                        "id": 5,
                        "name": "ie edu"
                    },
                    {
                        "id": 12,
                        "name": "School of Politics, Economics and Global Affairs"
                    }
                ],
                "editable": false,
                "manuallyImported": true,
                "originalPageId": 2467,
                "originalStructuredDataId": 4493
            },
            "content": {
                "units": null,
                "schools": [
                    {
                        "id": 3027,
                        "content": {
                            "title": "School of Global Public Affairs",
                            "code": "school-of-global-public-affairs",
                            "school": "SPEGA"
                        }
                    }
                ],
                "pathways": null,
                "programs": null,
                "subjectAreas": null,
                "stageTargets": null,
                "centers": null,
                "topics": null,
                "title": "Oscar A. Jonsson, New Academic Director of the Center for the Governance of Change",
                "abstract": "Jonsson has an extensive experience in emerging technologies’ impact on strategic affairs and geopolitics and has advised governments, armed forces’ leadership and financial institutions.",
                "image": {
                    "id": 4919,
                    "name": "oscar-jonsson-new-academic-director-center-governance-change.jpg",
                    "title": "",
                    "description": "",
                    "alt": "",
                    "tags": [],
                    "url": "https://images.thesaurus.ie.edu/oscar-jonsson-new-academic-director-center-governance-change",
                    "thumb": "https://images.thesaurus.ie.edu/w/215/h/161/oscar-jonsson-new-academic-director-center-governance-change",
                    "publicId": "thesaurus/oscar-jonsson-new-academic-director-center-governance-change_bbe09967-d7c1-4bb8-bc39-80ade6c604dd",
                    "damId": "oscar-jonsson-new-academic-director-center-governance-change",
                    "published": "2022-04-06T11:18:52Z",
                    "size": 145557,
                    "width": 1005,
                    "height": 523,
                    "orientation": "L",
                    "site": "global"
                },
                "lead": null,
                "longAbstract": "<p>IE University has announced the appointment of Oscar A. Jonsson as the new Academic Director of the Center for the Governance of Change (CGC). He will continue to develop the center as a top applied research institution in the field of emerging technologies and their political, economic, and societal implications.<br><br>Jonsson has earlier been Director of the Stockholm Free World Forum, a visiting researcher at UC Berkeley and a subject-matter expert at the Swedish Armed Forces Headquarters. He holds a PhD from the Department of War Studies at King’s College London.</p>\n",
                "content": "<p><strong><big>Jonsson has an extensive experience in emerging technologies’ impact on strategic affairs and geopolitics and has advised governments, armed forces’ leadership and financial institutions.</big></strong></p><p>IE University has announced the appointment of Oscar A. Jonsson as the new Academic Director of the <a href=\"https://mupro.ie.edu/cgc/\" target=\"_blank\">Center for the Governance of Change (CGC)</a>. He will continue to develop the center as a top applied research institution in the field of emerging technologies and their political, economic, and societal implications.</p><p>Jonsson has earlier been Director of the Stockholm Free World Forum, a visiting researcher at UC Berkeley and a subject-matter expert at the Swedish Armed Forces Headquarters. He holds a PhD from the Department of War Studies at King’s College London.</p><p>His research focuses on the impact of emerging technologies on modern statecraft and conflict, and in particular Russian modern warfare. He is the author of <a href=\"http://press.georgetown.edu/book/georgetown/russian-understanding-war\" target=\"_blank\">The Russian Understanding of War</a> (Georgetown University Press), which is on the Commander of US Special Forces’ reading list for 2020, and finalist for the Association of American Publisher’s award for Scholarly and Professional Excellence in Social Sciences 2020. His PhD-thesis received the Munich Security Conference’s John McCain Dissertation award.</p><blockquote><p>“Understanding what the future may look like in the intersection between technology, geo-power and society in a global environment is ever more important, as the current COVID19 shows.”<p><small>Susana Malcorra </small></p></blockquote></p><p>“Understanding what the future may look like in the intersection between technology, geo-power and society in a global environment is ever more important, as the current COVID19 shows. The work of the CGC in fields such as the future of health, impact of digitalization or artificial intelligence, offers us an incredible platform to analyze and anticipate global trend,” said Susana Malcorra, Dean of IE School of Global and Public Affairs.</p><p>“With his knowledge and expertise in strategic affairs and geopolitical risks, Oscar A. Jonsson brings a new dimension to the Center. I warmly welcome him and am looking forward to working with him,” she added.</p><p>“The current pandemic and economic crisis is just underlining the importance of the work of the Center for the Governance of Change,” highlights Jonsson in this video, in which he anticipates the next projects and opportunities of this educational institution based at IE University.</p><p>\n  <span class=\"fr-video fr-deletable fr-fvc fr-dvb fr-draggable\" contenteditable=\"false\" draggable=\"true\">\n    <iframe width=\"640\" height=\"360\" src=\"https://player.vimeo.com/video/410944192\" frameborder=\"0\" allowfullscreen=\"\" class=\"fr-draggable\"></iframe>\n  </span>\n  <br>\n</p>\n",
                "newsDate": "2020/04/27"
            },
            "modified": "2022-11-20T19:17:31.000Z",
            "published": "2022-11-20T19:17:31.000Z"
        }
    ]
}
```javascript

## `GET` /list/v2/:structuredData[]/site/:site/lang/:lang/page/:page/items/:itemsPerPage/maxItems/:maxItems/order/:order/get/:fields/relations/:relations/search/:search/exclude/:exclude/includePending/:includePending/allLanguages/:allLanguages/preferenceLanguage/:preferenceLanguage/groupingCategories/:groupingCategories

Los parámetros van en formato clave valor. Cuando no se quiere indicar uno de los parámetros opcionales, simplemente no lo ponemos. Por ejemplo, podemos para página podemos poner `page/1` o simplemente omitir la parte de `page/:page`.

Nuevo endpoint de listados de API Pública adaptado a los nuevos esquemas de distribuidores.

Con este endpoint podremos usar el filter, filterOperator y globalOperator del otro endpoint pero aplicado individualmente a cada dato estructurado. Para hacerlo se deberá seguir un formato concreto en el parámetro `/:structuredData`

Si queremos el listado de NEWS filtrando por los datos 45 y 46, con el globalOperator a OR y el filterOperator en AND lo haremos de la siguiente manera:
`.../NEWS[filters=45,46;globalOperator=or;filterOperator=and]/...`

Prestad atención al formato! Primero el dato NEWS luego entre corchetes [] los valores que queramos añadir separados por punto y coma. En caso de que no queramos pasar ningún filter bastará con no incluirlo.

Si queremos añadir más datos, seguiremos la misma estructura separándolos por comas, de la siguiente manera

`…/NEWS[filters=45,46;globalOperator=and;filterOperator=or],BLOG[filters=98;globalOperator=or;filterOperator=or]/...`

- `list`. Obligatorio. Dato estructurado por el que vamos a hacer el listado. Por ejemplo, `list/NEWS`. Pueden ser varios separados por comas. OJO porque en este caso hay que tener cuidado con el tipo de los datos: o todos son de página, o ninguno lo es. No se me ocurre ningún caso en el que en un mismo listado se quieran mezclar resultados de página con resultados que no lo son.
- `site`. Obligatorio. El id del site.
- `lang`. Obligatorio. El idioma a utilizar.
- `page`. Opcional. La página a mostrar. Por defecto es 1.
- `items`. Opcional. Elementos a mostrar por página. Por defecto son los que están marcados en api privada.
- `maxItems`. Opcional. Sirve para limitar la cantidad de resultados a manejar sobreescribiendo la cantidad real de resultados. Si se establece un maxItems de 100, todos los resultados trabajaran como si hubiera un total de 100 resultados, aunque en realidad en la base de datos hubiera miles. Para poder usar maxItems es obligatorio el uso de `page` e `items`. Solicitar una página cuyos resultados estuvieran por encima de maxItems, por ejemplo, page=10 e items=10 (resultados 90 a 100) para un maxItems de 50 generará un error.
- `filter`. Opcional. Ids por los que filtraremos el listado. Hay que especificar por qué ids queremos filtrar cada uno de los datos estructurados que pasemos en listado. Ejemplo, Si en list mandamos `…list/STORIES,NEWS/…` en ese caso en los filtros deberíamos especificarlo de la siguiente manera `.../STORIES:4420,4418;NEWS:6268/...`
**Es necesario respetar el formato:** Nombre del dato seguido de dos puntos, luego los ids por lo que queremos filtrar separados por coma. Una vez hayas terminado de especificar los ids usaremos punto y coma para seleccionar el otro dato estructurado y repetiremos el formato. Si solo quisieras especificar los filtros para un dato estructurado sería simplemente `.../STORIES:4420,4418/...`

⚠️ **DEPRECATED**. *Aún funciona por mantener la retrocompatibilidad.* La lista de ids por los que se filtrará el listado, separados por comas. Por ejemplo: `filter/5,8,10` . Por ejemplo, si tenemos una taxonomía que tiene "grados" y "masters" con los ids 3 y 4 respectivamente, si solo queremos los “grados” pondríamos filter/3. Sólo se ofrecerán en el listado elementos que estén relacionados con la lista de ids separados por comas indicados. Si no se indica, no se realiza filtro. También se puede utilizar cualquier string para no aplicar filtros, como por ejemplo `filter/null`

- `order`. Opcional. Le indica el orden. Puede ser `date-desc` (por defecto), `date-asc`, `alpha-asc`, `alpha-desc`, o cualquier campo custom (que en el esquema haya sido marcado con indexable) añadiéndole el -asc o -desc.
- `get`. Opcional, pero altamente recomendado. La lista de fields del dato estructurado que queremos recibir en el listado. Por ejemplo, `get/title,image,abstract,url`. Esto hace que se reciba solo la información que queremos recibir, lo cual es mucho más efectivo a nivel de velocidad y eficiencia. Hay que tener en cuenta que cuando se trata de un listado de un dato estructurado de página, se añade la propiedad url. Si no se indica, recibimos el dato estructurado entero. A TENER EN CUENTA que entre los datos que tiene el propio dato estructurado, te va a añadir `id` con el id del dato (que se usa por ejemplo para los filter) y si es de página te va a añadir `url`.
- `relations`. Opcional. Por defecto “off”. Acepta tres valores: `off`, `simple`  y `full`
    
    Esta propiedad devuelve la información de los datos estructurados relacionados con cada item del listado. Por ejemplo estas relaciones pueden ser categorías o otros datos estructurados que se hayan marcado en schemas 
    
    - `off`. Devolverá simplemente un array de ids separados por comas de cada dato relaccionado.
    - `simple`. Devolverá un objeto con dos propiedades. `id` que será un id numérico y `label` que será el título del dato.
    - `full`. Devolverá también un objeto con dos propiedades. `id` que será un id numérico y `content` que será el objeto content completo del dato relacionado.
- `search`. Opcional. Busca en la respuesta por las palabras que puedan estar o en el title o en el abstract del dato estructurado.
- `exclude`. Opcional. Excluye del resultado los datos estructurados cuyos ids especifiques aquí separados por comas.
- `includePending`. Opcional. “on” / “off”. Por defecto “off”. Cuando está “on” incluye los datos que se corresponden a páginas que están pendientes de publicar. Útil por ejemplo para desplegables de formularios en los que no se va a enlazar a la página (sería imprudente enlazarla si está pendiente de publicación, no sabemos si hay una página previa en esa misma dirección ni si está actualizada) pero sí queremos usar ese dato como referencia para una opción/select de formulario, filtro….
- `filterOperator` y `globalOperator`: opcionales. Por defecto 'any' para filterOperator y ‘and’ para globalOperator. Son los operadores lógicos (or/and) a aplicar sobre los filtros indicados. FilterOperator se aplica solo a los del mismo grupo, y globalOperator se aplica entre distintos grupos. Por ejemplo, si queremos un distribuidor de noticas, y en el filtro indicamos dos escuelas (ESCUELA_1, ESCUELA_2) y dos áreas (AREA_1, AREA_2), filterOperator se aplicará a los filtros de escuelas y a los de áreas, y globalOperator se aplicará a la relación entre escuelas y áreas. Es decir, sería un (ESCUELA_1 ${filterOperator} ESCUELA_2) ${globalOperator} (AREA_1 ${globalOperator} AREA_2). Si filterOperator es or y globalOperator es and (que son los valores por defecto), nos quedaría: (ESCUELA_1 or ESCUELA_2) and (AREA_1 or AREA_2). Mientras no se indiquen explícitamente en los default de la template ni se puedan gestionar desde AX se estarán usando esos valores por defecto.
    - ⚠️ **Cambios en Operadores Lógicos, aún no está en funcionamiento**. En el caso del globalOperator se seguirá usándo `and || or` y en el caso del filterOperator `all || any`.
- `allLanguages`: opcional. “on” / “off”. Por defecto “off”. Cuando está desactivado (o no se usa) va a mostrar solo resultados en el idioma indicado en `lang`. Pero si está activado, va a mostrar todos los resultados disponibles con independencia del idioma. Eso sí: si un resultado está disponible en varios idiomas, se mostrará una única versión en un único idioma, dando prioridad al idioma que se le haya indicado en `lang`, si no encuentra una versión en ese idioma sería en el idioma por defecto del site indicado en `site`, si no hay versión en ese idioma sería en el idioma indicado como por defecto en todo el entorno, y si no en cualquier idioma. Es decir, si un mismo dato está disponible en inglés y español, lo mostrará una única vez, que será prioritariamente la que coincida con el idioma que le estamos indicando en lang. OJO: Cuando trabajamos con más de dos idiomas podemos tener problemas si hay un dato que no está disponible en el orden de prioridades indicado (no está disponible ni en el idioma que le pasamos en el lang, ni en el idioma por defecto del site, ni en el idioma por defecto del entorno), ya que no sabría qué versión elegiri y mostraría el dato en cualquier idioma al azar.
- `preferenceLanguage` : opcional. Por defecto, false pero solo funcionará si la propiedad `allLanguages` también está activada. Los resultados se ordenarán de tal manera que primero aparecerán los items en el idioma de la página y luego el resto. Además si se establece `order`, los resultados vendrán ordenados por el parámetro que le hayamos pasado. Ej. si se ordena por nombre, tendríamos primero los del idioma de la página ordenados alfabéticamente, y luego los del resto de idiomas ordenados también alfabéticamente
- `groupingCategories` Acepta los parámetros ‘on’ y ‘off’ (por defecto ‘off’).  Solamente se puede usar con los datos estructurados que estén marcados en la instancia como categorías. En caso de que el tipo de dato no sea una categoría devolverá un error.
    
    Con on ordenará las categorías en el orden que haya estipulado el cliente y con off seguirá como hasta ahora.
    
- `relations`. Opcional. Por defecto “off”. Acepta tres valores: `off`, `simple`  y `full`
    
    Esta propiedad devuelve la información de los datos estructurados relacionados con cada item del listado. Por ejemplo estas relaciones pueden ser categorías o otros datos estructurados que se hayan marcado en schemas 
    
    - `off`. Devolverá simplemente un array de ids separados por comas de cada dato relaccionado.
    - `simple`. Devolverá un objeto con dos propiedades. `id` que será un id numérico y `label` que será el título del dato.
    - `full`. Devolverá también un objeto con dos propiedades. `id` que será un id numérico y `content` que será el objeto content completo del dato relacionado.

# DEPRECATED

## `GET` /list/:structuredData/site/:site/lang/:lang/page/:page/items/:itemsPerPage/maxItems/:maxItems/filter/:filter/order/:order/get/:fields/relations/:relations/search/:search/exclude/:exclude/includePending/:includePending/filterOperator/:filterOperator/globalOperator/:globalOperator/allLanguages/:allLanguages/preferenceLanguage/:preferenceLanguage
---
# Page

## `GET` /page/:id/preview/:entity

Devuelve la información completa de la página con el id indicado y coincida con ese entity, con independencia de su estado. **Si esa página tiene un draft, lo que devuelve es la información de la página draft.**

Puede devolver un 400 si la página no existe o no coincide el id con el entity.

Lo que devuelve es lo mismo que el endpoint de API privada [/page/:id](https://www.notion.so/52f480e9c9fc4dc985d576131047a114?pvs=21) y además le añade estas propiedades:

- headerContent
- footerContent

Se ha optado por facilitar el contenido de los navigations aplicables a esa página en concreto en dos propiedades aparte para facilitar el trabajo de desarrollo del preview respetando las mismas propiedades y formato en la información de página.

- siteInfo: Un objeto con información del site al que pertenece, concretamente el `siteId`, `name`, `theme`, `siteLanguages` (que es a su vez otro objeto con información de los idiomas del site), `socials`
- cloudinaryName
---
# Pass (external API middleware)

Esto es un poco raro, a ver cómo lo explico bien. Es importante leer la explicación completa, y si vas a usar envío de formularios, fíjate en la nota final de este documento.

Desde el front de la instancia podemos necesitar contactar con una api externa, como por ejemplo recoger lo del GRPD, enviar datos a un CRM...  Hasta aquí todo normal.

PERO a veces sucede que no podemos contactar directamente desde el front. Por ejemplo (casos reales de UCMA, pero puede haber otros):

- En la llamada necesitamos pasar una key que es privada.
- La API a la que llamamos no tiene CORS y da error cuando es llamada desde navegador.

Aquí tenemos un problema, porque al final tenemos que usar una api intermedia que haga de middleware, aunque tenemos clara la petición que tenemos que hacer y no vamos a hacer desarrollo a medida para cada cliente.

Es por esto que existen las rutas Pass. Son una especie de middleware.

**Las ventajas:**

- Desde el front puedes usar todos los pass que quieras, en dominios distintos y con condiciones distintas.
- Los pass pueden ser distintos por entorno y eso se gestiona desde infra; en la instancia solo manejas un código.

**Cómo funciona:**

- En primer lugar le damos un nombre a nuestro pass. Por ejemplo: “rgpd” (va a ser siempre en minúsculas). Es lo que llamaremos la passKey.
- En infra, hay que definir cada pass. Esto se hace con variables de entorno:
    - EXTERNAL_passKey_url
    Es la url que se usará como prefijo para hacer las llamadas (lo del prefijo se explica luego)
    EJEMPLO: `EXTERNAL_rgpd_url=”https://legal.ucma.com/api”`
    - EXTERNAL_passKey_headers
    Son los headers que vamos a añadir a la petición, separados por punto y coma, en plan clave=valor. ¡OJO! No es necesario especificar el content type, ya que la petición se pasa con el mismo content type con el que es llamada.
    EJEMPLO: `EXTERNAL_rgpd_headers=”api_key=43;access=on”`
- En la instancia DX, hacemos una petición a `{{apiPública}}/pass/passKey/{{restoDeLaUrl}}?{{queryOpcional}}` con el body y headers que haya que poner.
EJEMPLO: GET `{{apiPública}}/pass/rgpd/items/?today=1`
¿Qué hace esto?
    - API recibe la petición. Ve que quieres usar el pass rgpd (que está configurado en infra). Ve que en la configuración tenemos:
        - EXTERNAL_rgpd_url=”https://legal.ucma.com/api”
        - EXTERNAL_rgpd_headers=”api_key=43;access=on”
    - Va a hacer una petición a la API externa. La hace por el mismo método (en este caso GET), con los mismos headers, query y resto de la url, pero:
        - La url de la petición será sustituyendo {{apiPublica}/pass/rgpd por la EXTERNAL_rgpd_url.
        - Los headers indicados en EXTERNAL_rgpd_headers se añaden.
        - O sea, que se acabaría haciendo una petición a [https://legal.ucma.com/api/items/?today=1](https://legal.ucma.com/api/items/?today=1) añadiendo los headers api_key=43 y access=on.
    - Nos va a devolver un error si se produce un error (y generará un aviso por SNS) o literalmente la respuesta que originara la api final.

## Envío de alertas

Si no queremos que el PASS envíe una alerta SNS cuando se genera un error, podemos añadir a la url de la petición: `?griddo_alert_on_fail=off`

## Nota importante para envío de formularios

Cuando utilizas esta funcionalidad para enviar datos de formularios, es importante poder conservar un log de los formularios que gestionamos por si se produce una pérdida de datos en el destinatario de los mismos (que lamentablemente sucede más de lo que debiera).

El endpoint pass no guarda ningún log, porque se puede utilizar para un montón de cosas distintas (por ejemplo, recibir textos legales) y no podemos guardar log de todo.

Sin embargo, puedes utilizar passform en lugar de pass. **Funciona exactamente igual…. pero guardando el log**. Por ejemplo, en lugar de `{{apiPublica}/**pass**/request` utilizarías `{{apiPublica}/**passform**/request`
---
# Search

## `GET`/search

<aside>
💡 **Query:**
?searchQuery: El string que se quiere buscar (requerido).
&page(number): Para paginación, el número de página que quieres encontrar
&languageId(number): Filtro por el id del idioma que estás utilizando en la página
&template(array): Filtra por los template IDs que quieres mostrar
&siteId: Filtra por el id del site que le indiques
&itemsPerPage:  Número de items que quieres recibir en cada consulta

</aside>

Este endpoint te devuelve resultados de la búsqueda que pasas a través de `searchQuery`, en modo paginado.

Ejemplo de la petición

```json
/search?searchQuery=Eventos
```javascript

Ejemplo de la respuesta:

```jsx
{
    "totalItems": 53,
    "page": "1",
    "items": [
        {
            "title": "El museo del Sobao reabre sus puerta trasera con un camión",
            "url": null,
            "template": "NEWS",
            "image": null,
            "description": "",
            "site": "Museo del Sobao",
            "priority": 20
        },
	]
}
```
---
# Como arrancar la API Pública en Local

Para arrancar la API Pública en local es necesario también tener ejecutada la API Privada bien en local o bien lanzarla contra la API de un entorno. Aquí están los pasos para poder levantar ambas APIs en local.

## 1. Usar estas variables de entorno en el fichera de API Pública del monorepo

Esto será para conectarte al entorno de dev de Griddo. Si fuera necesario conectarse a otro entorno, en la parte del bot tendríamos que poner el usuario y contraseña de ese entorno y ejecutar la API Privada de ese entorno en local

```bash
#global
export PORT='3000'
export PRIVATE_API_URL='http://localhost:3001'

#entorno
#Si entorno es dev (1/true/on) se muestran logs en respuesta
export GRIDDO_isDev=1

#bot
export botEmail="admin@example.com"
export botPassword="[REDACTED]"

#jwt
export jwtKey="304e3caa9ce93446083324b642a1784b@lic43"

#caché
export cacheControlList="public, max-age=7200, s-maxage=7200, stale-if-error=3600, stale-while-revalidate=3600"
#export cacheControlList="no-store" #Para no cachear nada, ideal entornos develop

#mails

#mailFrom es opcional. Si no hay smtpFrom el remitente es Griddo
#OJO: Si se usa mailFrom con sendGrid, el remitente debe estar registrado en sendGrid
#OJO: Con smtp es obligatorio usar mailFrom, y debe estar autorizado en el servidor smtp
export mailFrom="Secuoyas <user@example.com>"

#sendgrid
export sendGridApi="[REDACTED]"

#smtp (OJO, solo funciona el envío por SMTP si no existe la variable de entorno sendGridApi)
export smtpServer="smtp.office365.com"
export smtpPort=587
export smtpUsername="user@example.com"
export smtpPassword="[REDACTED]"

#Debe estar desactivado para STARTTLS (0/1, off/on, true/false)
export smtpSecure="false"

#crm -- ¡OJO! Esta es la configuración de Garrigues
export melissaKey="[REDACTED]"
export nubikaEndpoint="https://cloud.sfmc.centrogarrigues.com/APIintermedia"
export nubikaClientId="[REDACTED]"
export nubikaClientSecret="[REDACTED]"
```javascript

## 2. Desplazarnos a la carpeta de API Privada y ejecutarla

Para ello deberemos abrir una terminal nueva desplazarnos a la carpeta `griddo-api`  y ejecutar el comando

```bash
yarn run dev:griddo
```javascript

Asegurarnos también de que tenemos la API Privada con un fichero de variables de entorno con nombre `.env.dev` y con estas variables

```bash
#global
export PORT="3001"
export maxHoursToRenderSite=1
export AX="your-instance.griddo.io"
export includeSiteSlugInUrl=0
export debugMode=1
export checks=0
export localEnv=1
export NODE_OPTIONS=""
#export pingIP="internal"
#export pingPORT=80 

#admin user
export adminUserEmail="admin@example.com"
export adminUserPassword="L3z^6!4656Lr"

# #bot - comentado para que no se sobreescriba
# export botEmail="user@example.com"
# export botPassword="[REDACTED]"

#developerKey
developerKey="c51002d0-a1dc-11eb-9b62-0ea7ce0b2044"

#jwt
export jwtKey="304e3caa9ce93446083324b642a1784b@lic43"
export jwtRefreshKey="hs94lpp012mnn9409350pagc50gh431s@345ps"

#s3
export API_filesS3Bucket=""
export API_filesS3URL="files.dev.griddo.comillas.edu"
export API_filesS3AccessKey=""
export API_filesS3AccessSecretKey=""

#mails
#mailFrom es opcional. Si no hay smtpFrom el remitente es Griddo
#OJO: Si se usa mailFrom con sendGrid, el remitente debe estar registrado en sendGrid
#OJO: Con smtp es obligatorio usar mailFrom, y debe estar autorizado en el servidor smtp
export mailFrom="Secuoyas <user@example.com>"

#sendgrid
export sendGridApi="[REDACTED]"

#smtp (OJO, solo funciona el envío por SMTP si no existe la variable de entorno sendGridApi)
export smtpServer="smtp.office365.com"
export smtpPort=587
export smtpUsername="user@example.com"
export smtpPassword="[REDACTED]"
export smtpSecure="false" #Debe estar desactivado para STARTTLS (0/1, off/on, true/false)

# #dam
export DAM="your-instance.griddo.io"
export DAM_KEY="[REDACTED]"

# #cloudinary ---> ESTO TIENE QUE DESAPARECER CUANDO NOS QUITEMOS CLOUDINARY
# export CLOUDINARY_NAME=thesaurus-cms
# export CLOUDINARY_KEY=886534817922424
# export CLOUDINARY_SECRET=ITv4QncjKA0gwYS3O5b6nDVbHi4
# export CLOUDINARY_FOLDER=thesaurus-dev

#bbdd
export sqlUser="griddo"
export sqlDB="griddodb"
export sqlServer="dev-griddo-v2-apiserverstack-1xg1v-auroradbcluster-rhowlcweijei.cluster-chiib43l60rn.eu-west-3.rds.amazonaws.com"
export sqlPWD="[REDACTED]"

#openAI
export GRIDDO_openAIApiKey="[REDACTED]"

#deepL
export GRIDDO_deepLApiKey="[REDACTED]"
export GRIDDO_deepLDomain="api.deepl.com"

#sitemaps
# Establece el order de los elementos del sitemap. Por defecto,
# es "priority", pero también podemos ordenar por
# el último cambio realizado con "lastmod"
export sitemapOrder="priority"

# Devuelve true o false dependiendo si queremos mostrar en los sitemaps
# la propiedad 'priority' o no. Por defecto es false.
export sitemapPriority=0
```javascript

## 3. Una vez con la API Privada ejecutada en local, levantar la Pública

Una vez tengas una terminal con API Privada ejecutada, desplázate a la carpeta `griddo-api-public` y arranca con el siguiente comando

```bash
yarn run dev
```javascript

**Recordatorio!** La api pública necesita la versión de node 16 para ejecutarse. Si tienes nvm instalado, puedes cambiar tu versión de node con el siguiente comando 

```bash
nvm use 16.19.0
```javascript

Y a partir de ahí podrás comenzar a hacer las consultas desde el [`http://localhost:3000](http://localhost:3000/)/…`
---
# Socials

<aside>
🚨 **ATENCIÓN!** Este endpoint solamente es para uso de la instancia Thessaurus. En el futuro podrá ser utilizado por cualquiera de las instancias de Griddo.

</aside>

## `POST`/rrss/socials/:socials

<aside>
💡 **Params:**
:socials (de momento sólo se aceptan `twitter`, `youtube`, `instagram`)
**Query:**
?order(date-ASC || date-DESC) Ordena los resultados por fecha.
**Body:**
numPosts, (Número de posts que quieres que te devuelva)
accountName (Nombre de la cuenta, es necesario que sea una verificada)

</aside>

Este endpoint te devuelve la información de los posts de la red social que pases por params.

Ejemplo de la petición

```json
{
    "numPosts": 10,
    "accountName": "IEBusinessSchool"
}
```javascript

Estos dos valores son **obligatorios**. Si quieres ordenar los resultados que te devuelva, bastará con añadir la query de ?order=date y dependiendo de si quieres los resultados en ascendente o descendente, añadirás el -DESC.
---
# Youtube

Para poder trabajar con Youtube, es necesaria la variable de entorno `youtubeApiKey` en la infra de API Pública. Será la api key facilitada por el cliente.

## `GET` /youtube/playlist/:playlist/:quantity

Recupera la lista de vídeos de la playlist con el id indicado, tantos elementos como se indiquen.

Ejemplo de respuesta:

```json
{
    "kind": "youtube#playlistItemListResponse",
    "etag": "1pdXN5ZOOoXT3TDsPKySydeGtkM",
    "nextPageToken": "EAAaBlBUOkNBSQ",
    "items": [
        {
            "kind": "youtube#playlistItem",
            "etag": "1hUDgJIK6U2pEDfnbX1lQYcKgqo",
            "id": "UExRb0lvTWt4WFJKbmxQYkpuRXF6V19jaFdmcG1JM0FicS4xMkVGQjNCMUM1N0RFNEUx",
            "snippet": {
                "publishedAt": "2022-04-26T15:04:11Z",
                "channelId": "UCOfVY-ssI7Oi-luM3axRIEQ",
                "title": "The history of our Segovia Campus: From Roman ruins to IE University",
                "description": "Welcome to the Convent of Santa Cruz la Real, a place where you’ll study, relax and make friends during your time at IE University. First built in 1218, the site has been home to a monastery, a prison, an orphanage, a hospice, and most recently, the IE University Segovia Campus. Our campus is located in the ancient city of Segovia, a UNESCO World Heritage site that’s famous for its Roman aqueduct, winding streets and fairytale castle. What’s more, it’s just a 25-minute high-speed train ride from the bustling city of Madrid, where you’ll find the IE Tower and much more. \n\nLearn more: https://www.ie.edu/university/about/segovia-campus-santa-cruz-la-real/",
                "thumbnails": {
                    "default": {
                        "url": "https://i.ytimg.com/vi/ljRMzdtyPOk/default.jpg",
                        "width": 120,
                        "height": 90
                    },
                    "medium": {
                        "url": "https://i.ytimg.com/vi/ljRMzdtyPOk/mqdefault.jpg",
                        "width": 320,
                        "height": 180
                    },
                    "high": {
                        "url": "https://i.ytimg.com/vi/ljRMzdtyPOk/hqdefault.jpg",
                        "width": 480,
                        "height": 360
                    },
                    "standard": {
                        "url": "https://i.ytimg.com/vi/ljRMzdtyPOk/sddefault.jpg",
                        "width": 640,
                        "height": 480
                    },
                    "maxres": {
                        "url": "https://i.ytimg.com/vi/ljRMzdtyPOk/maxresdefault.jpg",
                        "width": 1280,
                        "height": 720
                    }
                },
                "channelTitle": "IE University",
                "playlistId": "PLQoIoMkxXRJnlPbJnEqzW_chWfpmI3Abq",
                "position": 0,
                "resourceId": {
                    "kind": "youtube#video",
                    "videoId": "ljRMzdtyPOk"
                },
                "videoOwnerChannelTitle": "IE University",
                "videoOwnerChannelId": "UCOfVY-ssI7Oi-luM3axRIEQ"
            },
            "contentDetails": {
                "videoId": "ljRMzdtyPOk",
                "videoPublishedAt": "2022-03-23T10:30:53Z"
            }
        },
        {
            "kind": "youtube#playlistItem",
            "etag": "4gA4YTCkYPd0k2ZQPh5w0504zA8",
            "id": "UExRb0lvTWt4WFJKbmxQYkpuRXF6V19jaFdmcG1JM0FicS4wOTA3OTZBNzVEMTUzOTMy",
            "snippet": {
                "publishedAt": "2022-04-26T15:04:11Z",
                "channelId": "UCOfVY-ssI7Oi-luM3axRIEQ",
                "title": "The history of our Segovia Campus Trailer",
                "description": "",
                "thumbnails": {
                    "default": {
                        "url": "https://i.ytimg.com/vi/s93aZwXmKD4/default.jpg",
                        "width": 120,
                        "height": 90
                    },
                    "medium": {
                        "url": "https://i.ytimg.com/vi/s93aZwXmKD4/mqdefault.jpg",
                        "width": 320,
                        "height": 180
                    },
                    "high": {
                        "url": "https://i.ytimg.com/vi/s93aZwXmKD4/hqdefault.jpg",
                        "width": 480,
                        "height": 360
                    },
                    "standard": {
                        "url": "https://i.ytimg.com/vi/s93aZwXmKD4/sddefault.jpg",
                        "width": 640,
                        "height": 480
                    },
                    "maxres": {
                        "url": "https://i.ytimg.com/vi/s93aZwXmKD4/maxresdefault.jpg",
                        "width": 1280,
                        "height": 720
                    }
                },
                "channelTitle": "IE University",
                "playlistId": "PLQoIoMkxXRJnlPbJnEqzW_chWfpmI3Abq",
                "position": 1,
                "resourceId": {
                    "kind": "youtube#video",
                    "videoId": "s93aZwXmKD4"
                },
                "videoOwnerChannelTitle": "IE University",
                "videoOwnerChannelId": "UCOfVY-ssI7Oi-luM3axRIEQ"
            },
            "contentDetails": {
                "videoId": "s93aZwXmKD4",
                "videoPublishedAt": "2022-04-26T15:23:02Z"
            }
        }
    ],
    "pageInfo": {
        "totalResults": 15,
        "resultsPerPage": 2
    }
}
```