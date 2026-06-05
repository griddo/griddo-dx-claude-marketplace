# Caché

`POST` /cache/public-api/invalidate (disponible a patir de la v11.10.51)

Hay que pasar el authorization por header, con el valor de la developerKey.

Invalida la caché CDN de la distribución de la API Pública (PAPI). Por defecto invalida todos los paths (/*). Opcionalmente se pueden especificar paths concretos a invalidar.

Request body (opcional):

```json
{
	"paths": ["/*"]
}
```javascript

**Tipos usados de TS:**

- Request: `InvalidateCachePublicAPIDtoSchema`
- Response: `InvalidateCacheResult`
    - Ejemplo de respuesta:

```json
{
   "invalidationId": "I3EXAMPLE1234",
   "status": "InProgress"
}
```javascript

| Propiedad | Descripción |
| --- | --- |
| invalidationId | Identificador único de la invalidación asignado por el proveedor CDN |
| status | Estado de la invalidación (e.g. InProgress, Completed) |
---

# Debug

## `POST` /debug/reset-render

Resetea el estado del rendering.

## `GET` /debug/add-all-data-packs

Activa todos los data packs en todos los sites. **OJO: Eliminar este endpoint cuando los paquetes de datos estén implementados en AX!!!!!!**

## `~~GET` /debug/check-tables~~ (DEPRECADO!!)

~~Revisa todas las tablas, creando las tablas que faltan y modificando los campos e índices necesarios para que concuerde con la versión que está live. Ideal para actualizar la base de datos en caliente sin desconectar la api cuando se requieren ajustes en la BBDD. La instancia lo usaría subiendo la nueva versión, y justo después ejecutando este endpoint. Ojo, solo cuando los checks de la nueva versión de la api requiere ajustes en la bbdd y esos ajustes son exclusivamente mediante los esquemas en api.~~
---

# Domains

## `GET` /select/domains

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Lista de dominios en formato select. El valor visualizado es la url del dominio.

```json
[
    {
        "value": 1,
        "label": "//ie.edu"
    }
]
```javascript

## `GET` /domains

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Lista de dominios.

```json
[
    {
        "id": 1,
        "slug": "/ie.edu",
        "url": "//ie.edu"
    }
]
```javascript

## `POST` /domains

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Crea un dominio. El slug es opcional, si no se indica se crea con un slugify de url.

```json
{
    "url": "//ie.edu/",
		"slug": "ie-web"
}
```javascript

## `PUT` /domains/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Como el POST.

## `DELETE` /domains/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Elimina el dominio indicado.

## `GET`/domains/robots

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Este endpoint te devuelve un array de objetos con las propiedades

- `id`, es el id del dominio en cuestión.
- `path`, que es el path del dominio en el servidor.
- `fullUrl`: el dominio junto al domain slug.
- `content`, el contenido de robots.txt.

```json
[
    {
        "id": 1,
        "path": "/pre-griddo",
        "fullUrl": "//cx.dev.griddo.io/pre-griddo",
        "content": "User-agent: * \r\n Disallow: *"
    },
    {
        "id": 2,
        "path": "/pro-griddo",
        "fullUrl": "//cx.dev.griddo.io/pro-griddo",
        "content": "robotsTest21"
    }
]
```javascript

## `GET`/domains/robots/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Te devuelve el path del dominio del servidor, el fullUrl y el robot.txt de un dominio en concreto.

```json
{
    "path": "/pre-griddo",
    "fullUrl": "//cx.dev.griddo.io/pre-griddo",
    "content": "User-agent: * \r\n Disallow: *"
}
```javascript

## `PUT`/domains/:id/robots

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Actualiza el robot.txt de un dominio en concreto. 

La propiedad que espera en el body con el nuevo robot.txt es `content`.

```json
{
		"content": "SegundaPruebaRobots"
}
```javascript

## `PUT`/domains/robots/bulk

**🔑 Requiere autenticación.**

🚨 **Permisos**: seoAnalytics.manageAnalyticsGlobalSettings

Para actualizar una serie de robots en diferentes dominios. En el body de la petición se espera un array de objetos con el id de cada dominio a actualizar y el contenido de los robots como se ve a continuación:

```json
{
		"robots": [
								{
									"id": 1,
									"content": "robots: Test 1"
								},
								{
									"id": 2,
									"content": "robots: Test 2"
								}
							]
}
```
---

# Endpoints para QA

## `DELETE` /site/hard/:site

**🔑 Requiere autenticación.**

<aside>
💡 **Params:**
? :site (id del site a borrar)
**Body:**
developerKey

</aside>

En la API usamos el borrado lógico cuando eliminamos un site marcando su propiedad `deleted` como true. Esto hace que los sites de pruebas no se borren de la base de datos, poblándola de contenidos vacíos.

Con este endpoint se borra tanto el site como todas las páginas, datos estructurados, headers, footers, imágenes, files, etc. que estuvieran asociados a ese site.

**Ejemplo de petición**

```javascript
DELETE /site/hard/85321

body: {
	"developerKey": "developerKeyDelEntorno"
}
```javascript

La `developerKey` es una clave de developers única para cada entorno que añade una capa de seguridad extra a este endpoint. Para saber cuál es la clave de tu entorno hay que preguntar en Infra.

## `DELETE` /site/hard/bulk

**🔑 Requiere autenticación.**

<aside>
💡 **Body:**
developerKey (string)
sites (number[])

</aside>

Similar al endpoint anterior pero que borra un listado de ids de sites en modo bulk

**Ejemplo de petición**

```javascript
DELETE /site/hard/bulk

body: {
    "developerKey": "aa361740-8bc2-11eb-91b9-024fedaea5b4",
    "sites": [85304, 85305, 85310]
}
```javascript

## `DELETE` /user/hard/:user

**🔑 Requiere autenticación.**

<aside>
💡 **Params:**
? :user (id del user a borrar)
**Body:**
developerKey

</aside>

Similar al endpoint de sites pero con usuarios.

Con este endpoint se borra tanto el user como su presencia en sites y los roles que pudiera tener.

**Ejemplo de petición**

```javascript
DELETE /user/hard/13278

body: {
	"developerKey": "developerKeyDelEntorno"
}
```javascript

La `developerKey` es una clave de developers única para cada entorno que añade una capa de seguridad extra a este endpoint. Para saber cuál es la clave de tu entorno hay que preguntar en Infra.

## `DELETE` /user/hard/bulk

**🔑 Requiere autenticación.**

<aside>
💡 **Body:**
developerKey (string)
users (number[])

</aside>

Similar al endpoint anterior pero que borra un listado de ids de users en modo bulk

**Ejemplo de petición**

```javascript
DELETE /user/hard/bulk

body: {
    "developerKey": "aa361740-8bc2-11eb-91b9-024fedaea5b4",
    "users": [137, 2011, 5449]
}
```javascript

```jsx
router.delete('/structured_data_content/simple/hard/bulk', isAuth, StructuredData.deleteSimpleStructuredDataContentHardBulk);
router.delete('/structured_data_content/simple/hard/:structured_data_content', isAuth, StructuredData.deleteSimpleStructuredDataContentHard);
```javascript

## `DELETE`/structured_data_content/simple/hard/:structured_data_content

**🔑 Requiere autenticación.**

<aside>
💡 **Params:**
? :structured_data_content (id del simple structured data a borrar)
**Body:**
developerKey

</aside>

Similar al endpoint de sites pero con structured data simple.

Con este endpoint se borra tanto el dato estructurado como su presencia en sites.

**Ejemplo de petición**

```javascript
DELETE /structured_data_content/simple/hard/10827

body: {
	"developerKey": "developerKeyDelEntorno"
}
```javascript

La `developerKey` es una clave de developers única para cada entorno que añade una capa de seguridad extra a este endpoint. Para saber cuál es la clave de tu entorno hay que preguntar en Infra.

## `DELETE` /structured_data_content/simple/hard/bulk

**🔑 Requiere autenticación.**

<aside>
💡 **Body:**
developerKey (string)
structuredDataIds (number[])

</aside>

Similar al endpoint anterior pero que borra un listado de ids de users en modo bulk

**Ejemplo de petición**

```javascript
DELETE /structured_data_content/simple/hard/bulk

body: {
    "developerKey": "aa361740-8bc2-11eb-91b9-024fedaea5b4",
    "structuredDataIds": [6631,7552,7560]
}
```javascript

## `DELETE` /categories/delete/hard

**🔑 Requiere autenticación.**

<aside>
💡 **Body:**
developerKey (string)
items ({categories: number[], groups: number[]})

</aside>

Borra un listado de categorias y grupos de la base de datos

**Ejemplo de petición**

```javascript
DELETE /categories/delete/hard

body: {
    "developerKey": "aa361740-8bc2-11eb-91b9-024fedaea5b4",
    "items": {
        "categories": [37299, 4729, 566],
        "groups": [305,23,562]
    }
}
```
---

# API Privada Environment Variables


## Entorno Develop ( env dev)

# Entorno Develop (.env.dev)

<aside>
💡 Añadir las variables de entorno utilizando `export`

</aside>

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

#admin user
export adminUserEmail="admin@example.com"
export adminUserPassword="[REDACTED]"

#bot - comentado para que no se sobreescriba
export botEmail="user@example.comio"
export botPassword="[REDACTED]"

#developerKey
export developerKey="[REDACTED]"

#jwt
export jwtKey="[REDACTED]"
export jwtRefreshKey="[REDACTED]"

#s3 (Desde local no se pueden subir archivos)
export filesS3Bucket=""
export filesS3Region=""
export filesS3URL=""
export filesS3AccessKey=""
export filesS3AccessSecretKey=""

#mails
#mailFrom es opcional. Si no hay smtpFrom el remitente es Griddo
#OJO: Si se usa mailFrom con sendGrid, el remitente debe estar registrado en sendGrid
#OJO: Con smtp es obligatorio usar mailFrom, y debe estar autorizado en el servidor smtp
export mailFrom="Secuoyas <user@example.com>"

#sendgrid
export sendGridApi="[REDACTED]"

# #dam
export DAM="your-instance.griddo.io"
export DAM_KEY="[REDACTED]"

#bbdd
# Griddo Dev
# -----------------------------
export sqlUser="griddo"
export sqlDB="griddodb"
export sqlServer="dev-griddo-v2-apiserverstack-1xg1v-auroradbyour-db-cluster.rds.amazonaws.com"
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

## Entorno Staging( env qa)

# Entorno Staging(.env.qa)

```bash
#global
export PORT="3001"
export maxHoursToRenderSite=6
export AX="your-instance.griddo.io"
export includeSiteSlugInUrl=0
export debugMode=1
export checks=0
export localEnv=1

#admin user
export adminUserEmail="admin@example.com"
export adminUserPassword="[REDACTED]"

#bot - comentado para que no se sobreescriba
export botEmail="user@example.comio"
export botPassword="[REDACTED]"

#developerKey
export developerKey="[REDACTED]"

#s3
export filesS3Bucket=""
export filesS3Region=""
export filesS3URL=""
export filesS3AccessKey=""
export filesS3AccessSecretKey=""

#dam
export DAM="your-instance.griddo.io"
export DAM_KEY="[REDACTED]"

#bbdd
export sqlUser="griddo"
export sqlDB="griddodb"
export sqlServer="staginggriddo-v2-apiserverstack-af-auroradbcluster-0ov5rtffp0gj.cluster-cxsgpthevdst.eu-central-1.rds.amazonaws.com"
export sqlPWD="[REDACTED]"

#hubspot
export hubspotKey="[REDACTED]"
export userIdGenerator="md5"

#mailservice
export mailhost="smtp.gmail.com"
export mailport="587"
export mailuser="eldemo"
export mailpass="[REDACTED]"

#jwt
export jwtKey="[REDACTED]"
export jwtRefreshKey="[REDACTED]"

#sendgrid
export sendGridApi="[REDACTED]"
#openAI
export GRIDDO_openAIApiKey="[REDACTED]"

#deepL
export GRIDDO_deepLApiKey="[REDACTED]"
export GRIDDO_deepLDomain="api.deepl.com"
```javascript

## Logger

# Logger

# Sistema de Logging con Pino

Esta carpeta contiene la documentación del sistema de logging centralizado basado en [Pino](https://getpino.io/).

## Visión General

El sistema de logging proporciona una capa de abstracción sobre Pino que permite:

- **Logging estructurado** con contexto automático por request
- **Configuración desde infraestructura** mediante variables de entorno
- **Múltiples destinos**: consola (pretty print), archivo, y Grafana Loki
- **Correlación de requests** con `reqId` único y `clientName`
- **Patrón Adapter** para facilitar el cambio de implementación

> **Importante:** Utiliza siempre el `LoggerService.getInstance()` para obtener la instancia del logger. No instancies
`PinoLoggerAdapter` directamente.
> 

## Variables de Entorno

Todas las variables de entorno usan el prefijo `GRIDDO_API_LOG_*`:

| Variable | Valores | Default | Descripción |
| --- | --- | --- | --- |
| `GRIDDO_API_LOG_LEVEL` | `trace`, `debug`, `log`, `info`, `warn`, `error`, `fatal`, `silent` | `info` | Nivel mínimo de log general. Con `silent` se desactiva completamente. |
| `GRIDDO_API_LOG_HTTP_LEVEL` | `trace`, `debug`, `log`, `info`, `warn`, `error`, `fatal`, `silent` | `warn` | Nivel de log para peticiones HTTP (pino-http). Independiente del nivel general. Default `warn`. |
| `GRIDDO_API_LOG_PRETTY` | `true`, `false` | `true` | Activa formato legible con colores (pino-pretty). En producción usar `false`. |
| `GRIDDO_API_LOG_FILE` | ruta absoluta | — | Si se define, los logs se vuelcan también a este archivo. |
| `GRIDDO_API_LOG_LOKI_HOST` | URL | — | URL de Grafana Loki. Si se define, activa el transport a Loki. |
| `GRIDDO_API_LOG_LOKI_LABELS` | JSON string | `{"app":"griddo-api"}` | Labels por defecto para enviar a Loki. |
| `GRIDDO_API_LOG_LOKI_USER` | string | — | Usuario HTTP Basic para autenticación con Loki. |
| `GRIDDO_API_LOG_LOKI_TOKEN` | string | — | Token/password para autenticación Basic con Loki. |

## Uso Básico

### Importar el logger

```tsx
import { logger } from "@infrastructure/services/logger";
```javascript

### Niveles de log

```tsx
logger.trace({ detail: "very verbose info" }, "Mensaje de trace");
logger.debug({ userId: 123 }, "Usuario autenticado");
logger.log({ attempt: 5 }, "Retry attempt exceeded"); // Nivel especial entre debug e info
logger.info({ action: "created", id: 456 }, "Recurso creado");
logger.warn({ retries: 3 }, "Reintentando operación");
logger.error({ err: error }, "Error en operación");
logger.fatal({ err: error }, "Error crítico, servicio no disponible");
```javascript

### Jerarquía de niveles (de menor a mayor severidad)

```javascript
trace (10) → debug (20) → log (25) → info (30) → warn (40) → error (50) → fatal (60)
```javascript

**Nivel `log`**: Es un nivel personalizado entre `debug` e `info`, diseñado para **casos excepcionales** que son más importantes que la información de depuración pero no alcanzan el nivel de evento de negocio general.

> **Nota**: Pino muestra los niveles personalizados con la etiqueta `USERLVL` en lugar de `log` cuando se usa `pino-pretty`. Esto es comportamiento esperado de Pino.
> 

### Formato recomendado

Pino sigue el patrón: **objeto de contexto primero, mensaje después**.

```tsx
// ✅ Correcto - objeto con contexto estructurado
logger.error(
	{ err: error, userId: 123, action: "create" },
	"Error creating user",
);

// ❌ Evitar - solo mensaje sin contexto
logger.error("Error creating user");

// ❌ Evitar - mensaje antes que el objeto (no sigue convención de pino)
logger.error("Error creating user", { err: error });
```javascript

### Child loggers con contexto adicional

```tsx
const log = logger.child({ service: "PaymentService", userId: 123 });
log.info({ amount: 100 }, "Payment processed");
// Log automático incluye: service, userId, amount, etc.
```javascript

## Middleware HTTP

El sistema incluye un middleware de Express que loguea automáticamente todas las requests y responses:

- Método, URL, status code
- Tiempo de respuesta
- **IP del cliente real** (detrás de proxy/load balancer)
- User-Agent
- `x-client-name` header
- `reqId` único (generado automáticamente)

### Detección de IP real tras proxy/load balancer

El middleware detecta automáticamente la IP real del cliente leyendo los siguientes headers en orden de prioridad:

1. **`X-Forwarded-For`** - Estándar más común (formato: `client, proxy1, proxy2`)
2. **`X-Real-IP`** - Usado por Nginx
3. **`CF-Connecting-IP`** - Cloudflare
4. **`True-Client-IP`** - Akamai y otros CDN
5. **`remoteAddress`** - Fallback a conexión directa (sin proxy)

> **Nota:** Si tu load balancer o proxy no configura estos headers correctamente, se mostrará la IP del proxy o `unknown`.
> 

### Uso en handlers Express

```tsx
// El middleware añade `req.log` como child logger con contexto de request
export async function someHandler(req: Request, res: Response) {
	// Usar req.log para logs con contexto de request automático
	req.log.info({ action: "getData" }, "Fetching data");

	// O usar el logger global (sin contexto de request)
	logger.info({ handler: "someHandler" }, "Handler called");
}
```javascript

## Componentes Principales

### `LoggerInterface`

Interfaz de dominio que define el contrato del logger. Permite cambiar la implementación sin afectar el código de
negocio.

### `LoggerServiceFactory`

Fábrica que proporciona instancias del logger según el adaptador especificado.

```tsx
import { LoggerServiceFactory } from "@infrastructure/services/logger/LoggerServiceFactory";
import { LoggerAdapters } from "@infrastructure/adapters/logger/LoggerAdapters";

const logger = LoggerServiceFactory.getAdapter(LoggerAdapters.PINO);
```javascript

### `LoggerService`

Singleton que gestiona la instancia única del logger.

```tsx
import { LoggerService } from "@infrastructure/services/logger";

// Obtener instancia (la primera vez la crea, luego la reutiliza)
const logger = LoggerService.getInstance();

// Inyectar mock (útil en tests)
LoggerService.setInstance(mockLogger);

// Resetear instancia (entre tests)
LoggerService.resetInstance();
```javascript

### `PinoLoggerAdapter`

Implementación concreta que adapta la librería Pino a la interfaz `LoggerInterface`.

### `PinoTransports`

Construye dinámicamente los transports de Pino según las variables de entorno configuradas.

### `createHttpLogger`

Factory que crea el middleware `pino-http` configurado para Express.

## Destinos de Log

### Consola (siempre activa)

- **Development**: Salida con colores y formato legible (pino-pretty)
- **Producción**: Salida en JSON (una línea por log)

### Archivo (opcional)

Si se define `GRIDDO_API_LOG_FILE`, los logs se escriben también en el archivo especificado.

### Grafana Loki (opcional)

Si se define `GRIDDO_API_LOG_LOKI_HOST`, los logs se envían a Grafana Loki con:

- Batching automático para mejor rendimiento
- Labels configurables vía `GRIDDO_API_LOG_LOKI_LABELS`
- Autenticación Basic Auth configurada

## Correlación de Requests

Cada request HTTP loguea automáticamente con un `reqId` único que permite:

- Agrupar todos los logs generados durante una request
- Rastrear problemas a través de microservicios
- Filtrar logs por `clientName` (SDK, AX, QA, etc.)

El `reqId` se genera automáticamente a partir de:

1. Header `x-request-id` si existe
2. `x-client-name` + fragmento de UUID
3. UUID completo si no hay nada

## Directrices

### Cuándo usar cada nivel

- **trace**: Información extremadamente detallada (solo desarrollo/debugging)
- **debug**: Información de diagnóstico (valores de variables, flujo de ejecución)
- **info**: Eventos normales de negocio (inicio/fin de operación, cambios de estado)
- **warn**: Situaciones inesperadas pero recuperables (retries, fallbacks, valores por defecto)
- **error**: Errores que no interrumpen el flujo principal pero requieren atención
- **fatal**: Errores críticos que requieren intervención inmediata

### Errores

Siempre incluir el error en el objeto de contexto:

```tsx
try {
	await someOperation();
} catch (error) {
	logger.error(
		{ err: error, operation: "someOperation" },
		"Operation failed",
	);
	// o usando shortcut:
	logger.error({ err, operation: "someOperation" }, "Operation failed");
}
```javascript

### Información sensible

Nunca loguear:

- Contraseñas
- Tokens de autenticación completos
- Datos personales sensibles (sin necesidad)
- Información de tarjetas de pago

Si es necesario loguear un ID o referencia, usar solo una porción:

```tsx
logger.info({ token: token.slice(0, 8) + "..." }, "User authenticated");
```javascript

## Testing

### En tests unitarios

```tsx
import { LoggerService } from "@infrastructure/services/logger";
import vi from "vitest";

describe("MyService", () => {
	beforeEach(() => {
		// Inyectar mock
		const mockLogger = {
			info: vi.fn(),
			error: vi.fn(),
			// ... otros métodos
		};
		LoggerService.setInstance(mockLogger as any);
	});

	afterEach(() => {
		LoggerService.resetInstance();
	});

	it("should log something", () => {
		myService.doSomething();

		// Verificar log
		const logger = LoggerService.getInstance() as any;
		expect(logger.info).toHaveBeenCalledWith(
			{ action: "doSomething" },
			expect.any(String),
		);
	});
});
```javascript

## Troubleshooting

### Los logs no aparecen

1. Verificar que `GRIDDO_API_LOG_LEVEL` no sea `silent`
2. En producción, verificar que `GRIDDO_API_LOG_PRETTY=false` (solo development tiene colores)
3. Si usas Loki, verificar la conectividad con `GRIDDO_API_LOG_LOKI_HOST`

### Logs duplicados

Si ves logs duplicados, verificar que:

- No estás llamando a `console.log` además del logger
- No estás usando múltiples instancias del logger
- El middleware HTTP no está registrado múltiples veces

### Performance

- **pino-pretty** es síncrono y lento. No usar en producción.
- Los transports a archivo y Loki son asíncronos y no bloquean.
- El middleware HTTP añade ~1ms por request.

## Referencias

- [Pino Documentation](https://getpino.io/)
- [pino-http](https://github.com/pinojs/pino-http)
- [pino-loki](https://github.com/pinojs/pino-loki)
- [pino-pretty](https://github.com/pinojs/pino-pretty)
---

# Error Reporting
---

# Glosarios para traducciones

A la hora de hacer traducciones, es posible indicar glosarios para forzar que una palabra se traduzca siempre de una manera determinada. Por ejemplo, si es una universidad muy moderna y queremos que facultad lo traduzca siempre como facultitity, o incluso para traducir palabras que nos hemos inventado.

Los glosarios de momento se gestionan solo desde la api.

¡OJO! La licencia de DeepL solo permite gestionar un máximo de 100 glosarios por licencia. Actualmente todas las instancias van con la misma licencia de deepL, así que tenemos 100 glosarios para el total de instancias. Es altamente recomendable no tener glosarios en dev ni staging ni local (o borrarlos después de crearlos). Sin embargo, si migras el id de un glosario de pro a dev, sigue contando como un único glosario.

## `GET` /translations/glossaries

Con este endpoint obtenemos todos los glosarios que estamos gestionando en la instancia.

## `POST` /translations/glossaries

Con este endpoint se añade un glosario. En el body hay que indicar:

```json
{
    "sourceLanguage": "ES",
    "targetLanguage": "EN",
    "content": "facultad\tfacultitititititity\nHola\tHi"
}
```javascript

Donde sourceLanguage es el ISO del idioma de origen, targetLanguage es el ISO del idioma de destino, y content es el contenido del glosario, en el que cada entrada es una línea (separadas por \n) y en cada entrada tenemos la palabra en el idioma de origen y la palabra en el idioma de destino, separadas por tabulador \t).

## `DELETE` /translations/glossaries/:id

Con este endpoint borramos el glosario del id indicado. Ojo porque se borra tanto de la bbdd como de DeepL, por lo que si estamos en dev con una copia de base de datos de pro, y el id que borramos es un id que se está usando en producción, estaríamos borrando el id en producción.
---

# Health Status

## `GET` /ping

Devuelve una respuesta de ok con código de status 200, para que se pueda chequear que el servicio de api está funcionando correctamente. No chequea BBDD ni API legacy, que deberán tener otras validaciones aparte por cuanto la reacción a un fallo en los health status deberá ser distinta en cada caso.
---

# Docker en API
---

# Languages

## `GET` /select/languages

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToLanguages

Devuelve toda la lista de idiomas disponible en el sistema.

```json
[
    {
        "value": 2,
        "label": "Spanish"
    },
    {
        "value": 4,
        "label": "English"
    }
]
```javascript

## `GET` /select/site/:site/languages

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToLanguages

Devuelve la lista de idiomas disponible para el site indicado. Si el site no existe devuelve la lista de todos los idiomas disponibles.

```json
[
    {
        "value": 2,
        "label": "Spanish"
    },
    {
        "value": 4,
        "label": "English"
    }
]
```javascript

## `GET` /languages

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToLanguages

Devuelve la lista de idiomas disponibles para todo el sistema.

```json
{
    "totalItems": 4,
    "items": [
        {
            "id": 1,
            "locale": "en-US",
            "language": "US English",
            "label": "EN",
            "isDefault": false
        },
        {
            "id": 2,
            "locale": "es-ES",
            "language": "Spanish",
            "label": "ES",
            "isDefault": false
        },
        {
            "id": 3,
            "locale": "en-AU",
            "language": "Australian English",
            "label": "EN",
            "isDefault": false
        },
        {
            "id": 4,
            "locale": "en-UK",
            "language": "English
            "label": "EN",
            "isDefault": true
        }
    ]
}
```javascript

## `GET` /site/:site/languages

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToLanguages

Devuelve la lista de idiomas disponible para el site especificado.

```json
{
    "totalItems": 4,
    "items": [
        {
            "id": 4,
            "locale": "en_GB",
            "language": "English",
            "path": "/en",
            "domain": {
                "id": 1,
                "url": "https://your-instance.griddo.io",
                "slug": "/your-instance.griddo.io"
            },
            "label": "EN",
            "isDefault": true,
            "home": "https://your-instance.griddo.io/en"
        },
        {
            "id": 3,
            "locale": "de_DE",
            "language": "German",
            "path": "/ge",
            "domain": {
                "id": 1,
                "url": "https://your-instance.griddo.io",
                "slug": "/your-instance.griddo.io"
            },
            "label": "DE",
            "isDefault": false,
            "home": "https://your-instance.griddo.io/ge"
        },
        {
            "id": 1,
            "locale": "it_IT",
            "language": "Italian",
            "path": "/it",
            "domain": {
                "id": 1,
                "url": "https://your-instance.griddo.io",
                "slug": "/your-instance.griddo.io"
            },
            "label": "IT",
            "isDefault": false,
            "home": "https://your-instance.griddo.io/it"
        },
        {
            "id": 2,
            "locale": "es_ES",
            "language": "Spanish",
            "path": "/es",
            "domain": {
                "id": 1,
                "url": "https://your-instance.griddo.io",
                "slug": "/your-instance.griddo.io"
            },
            "label": "ES",
            "isDefault": false,
            "home": "https://your-instance.griddo.io/es"
        }
    ]
}
```javascript

## `POST` /site/:site/languages

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.createLanguages

Añade o modifica un idioma a la configuración del site especificado. Si esa combinación de site e idioma no existe, la crea. Si existe, la actualiza.

Creará el headerSection, footerSection y los menuContainers para ese site e idioma.

Se puede utilizar también como **PUT**, tiene el mismo efecto y resultado.

**Body de la petición:**

```json
{
    "language": 3,
		"domain": 1,
    "path": "/testing",
    "isDefault": true,
		"domain": {
				"id": 1,
				"url": "//ie.edu",
				"slug": "/ie.edu"
		}
}
```javascript

## `DELETE` /site/:site/languages/:language

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.deleteLanguages

Elimina el language indicado del site indicado.

También eliminará el headerSection, footerSection y los menuContainers para ese site e idioma.
---

# Live Status

## `GET` /live-status

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.manageSiteSettings

Devuelve la lista de Live Status disponible.

```json
[
    {
        "id": 1,
        "title": "Not published",
        "status": "offline"
    },
    {
        "id": 2,
        "title": "Publishing",
        "status": "upload-pending"
    },
    {
        "id": 3,
        "title": "Live",
        "status": "active"
    },
    {
        "id": 4,
        "title": "Unpublishing",
        "status": "offline-pending"
    },
    {
        "id": 5,
        "title": "Live & modified",
        "status": "modified"
    },
    {
        "id": 6,
        "title": "Publication scheduled",
        "status": "scheduled"
    }
]
```
---

# Logs

## `GET` /logs

🚨 **Permisos**: superadmin

Devuelve los logs de la tabla `log`. Podemos acotar por fecha pasando los parámetros `from` y/o `until`

`/logs?from=2020-10-13&until=2020-10-14`

```json
{
     "id": 51,
     "log": "STRUCTURED DATA: NEWS",
     "date": "2020-10-13T09:19:29.000Z"
}
```javascript

## `POST` /logs/form

Crea una entrada en el log de formularios. Recibe estos parámetros en el body:

```json
{
	"to": "correo al que iba dirigido el formulario",
	"content": {}
}
```javascript

## `GET` /logs/form

Permite recibir los logs de formularios.

<aside>
💡 **Params:**
?page
?items

</aside>

## `POST` /logs/alert

Permite guardar un log de una alerta en la BBDD.

Recibe estos parámetros en el body:

```json
{
    "level": "i",
    "area": "forms",
    "description":"formulario mal",
    "fullData":{"to":"casa","from":"work"}
}
```javascript

Donde:

- `level` es I, W, E (Info, Warning, Error)
- `area` es el área general (por ejemplo “formularios”, “performance”)
- `description` es una descripción del error (”Fallo al enviar el formulario).
- `fullData` es la información relativa que se quiera añadir, puede ser string u objeto.

## `GET` /logs/alert

Permite recibir los logs de alertas.

<aside>
💡 **Params:**
?page
?items
?level
?area

</aside>

Donde level es uno o varios niveles (I, E, W) separados por comas.

## `GET` /logs/activity-timeline

Este endpoint está restringido al rol de superadmin, y recupera una lista paginada de registros de actividad.

**Tipos usados de TS:**

- **Request**: `LogActivityPaginationRequest`
- **Response**: `PaginationResponse<LogActivityDTO>`

Puede recibir estos parámetros por query string:

<aside>
💡 **Params:**
?pagination
?page
?itemsPerPage
?order
?search
?date
?sites
?contentTypes
?eventTypes
?users

</aside>

Donde:

- **`pagination`**: `true | false`
    - Indica si la respuesta debe paginarse. **Por defecto:** `true`.
- `page` : número entero positivo
    - Número de página que se desea recuperar. **Por defecto:** `1`.
- `itemsPerPage` : número entero positivo
    - Cantidad de elementos por página. **Por defecto:** `50`.
- `order` :  `ASC | DESC`
    - Orden de los resultados. **Por defecto:** `DESC` (descendente).
- `search` :  *cadena de texto*
    - Texto por el que se filtrarán los resultados.
- `date` :  cadena de texto con un rango de fechas:
    - Formato: `YYYY/DD/MM-YYYY/DD/MM`.
    - **Ejemplo:** `2025/01/01-2025/12/31`.
- `sites` : Cadena de texto que admite una **lista de números enteros positivos** y/o la palabra **`global`**, separados por comas.
    - Ejemplos:
        - `"1,2,3"`
        - `"global"`
        - `"1,2,global,5"`
- `contentTypes` : Cadena de texto que admite una **lista de content types** separados por comas.
    - **Valores permitidos**: Cualquier template o structured data que tengamos en los schemas
    - **Ejemplos**:
        - `"BasicTemplate,NEWS"`
        - `"PEOPLE,NEWS"`
- `eventTypes` : Cadena de texto que admite una **lista de números enteros positivos**, separados por comas. Cada número corresponde al **ID de un evento**.
    - Los IDs disponibles se pueden obtener a través del endpoint:
        - GET /logs/activity-events-type
    - **Ejemplos**:
        - `"1,2,3"`
        - `"10,25"`
- `users` : Cadena de texto que admite una **lista de números enteros positivos o la palabra bot**, separados por comas. Cada número corresponde al **ID de un usuario.**
    - **Ejemplos**:
        - `"1,2,3"`
        - `"10,25, bot"`

## `GET` /logs/activity-grouped-user

Este endpoint está restringido al rol de superadmin, y recupera una lista paginada de registros de actividad agrupada por usuario.

**Tipos usados de TS:**

- **Request**: `LogActivityPaginationRequest`
- **Response**: `PaginationResponse<LogActivityGroupedUserDTO<LogActivityGroupedUserDTO>>`

Puede recibir estos parámetros por query string:

<aside>
💡 **Params:**
?pagination
?page
?itemsPerPage
?order
?search
?date
?sites
?contentTypes
?eventTypes
?users

</aside>

Donde:

- **`pagination`**: `true | false`
    - Indica si la respuesta debe paginarse. **Por defecto:** `true`.
- `page` : número entero positivo
    - Número de página que se desea recuperar. **Por defecto:** `1`.
- `itemsPerPage` : número entero positivo
    - Cantidad de elementos por página. **Por defecto:** `50`.
- `order` :  `ASC | DESC`
    - Orden de los resultados. **Por defecto:** `DESC` (descendente).
- `search` :  *cadena de texto*
    - Texto por el que se filtrarán los resultados.
- `date` :  cadena de texto con un rango de fechas:
    - Formato: `YYYY/DD/MM-YYYY/DD/MM`.
    - **Ejemplo:** `2025/01/01-2025/12/31`.
- `sites` : Cadena de texto que admite una **lista de números enteros positivos** y/o la palabra **`global`**, separados por comas.
    - Ejemplos:
        - `"1,2,3"`
        - `"global"`
        - `"1,2,global,5"`
- `contentTypes` : Cadena de texto que admite una **lista de content types** separados por comas.
    - **Valores permitidos**: Cualquier template o structured data que tengamos en los schemas.
    - **Ejemplos**:
        - `"BasicTemplate,NEWS"`
        - `"PEOPLE,NEWS"`
- `eventTypes` : Cadena de texto que admite una **lista de números enteros positivos**, separados por comas. Cada número corresponde al **ID de un evento**.
    - Los IDs disponibles se pueden obtener a través del endpoint:
        - GET /logs/activity-events-type
    - **Ejemplos**:
        - `"1,2,3"`
        - `"10,25"`
- `users` : Cadena de texto que admite una **lista de números enteros positivos o la palabra bot**, separados por comas. Cada número corresponde al **ID de un usuario.**
    - **Ejemplos**:
        - `"1,2,3"`
        - `"10,25,bot"`

## `GET` /logs/activity-grouped-day

Este endpoint está restringido al rol de superadmin, y recupera una lista paginada de registros de actividad agrupada por días.

**Tipos usados de TS:**

- **Request**: `LogActivityPaginationRequest`
- **Response**: `PaginationResponse<LogActivityGroupedDayDTO>`

Puede recibir estos parámetros por query string:

<aside>
💡 **Params:**
?pagination
?page
?itemsPerPage
?order
?search
?date
?sites
?contentTypes
?eventTypes
?users

</aside>

Donde:

- **`pagination`**: `true | false`
    - Indica si la respuesta debe paginarse. **Por defecto:** `true`.
- `page` : número entero positivo
    - Número de página que se desea recuperar. **Por defecto:** `1`.
- `itemsPerPage` : número entero positivo
    - Cantidad de elementos por página. **Por defecto:** `50`.
- `order` :  `ASC | DESC`
    - Orden de los resultados. **Por defecto:** `DESC` (descendente).
- `search` :  *cadena de texto*
    - Texto por el que se filtrarán los resultados.
- `date` :  cadena de texto con un rango de fechas:
    - Formato: `YYYY/DD/MM-YYYY/DD/MM`.
    - **Ejemplo:** `2025/01/01-2025/12/31`.
- `sites` : Cadena de texto que admite una **lista de números enteros positivos** y/o la palabra **`global`**, separados por comas.
    - Ejemplos:
        - `"1,2,3"`
        - `"global"`
        - `"1,2,global,5"`
- `contentTypes` : Cadena de texto que admite una **lista de content types** separados por comas.
    - **Valores permitidos**: Cualquier template o structured data que tengamos en los schemas.
    - **Ejemplos**:
        - `"BasicTemplate,NEWS"`
        - `"PEOPLE,NEWS"`
- `eventTypes` : Cadena de texto que admite una **lista de números enteros positivos**, separados por comas. Cada número corresponde al **ID de un evento**.
    - Los IDs disponibles se pueden obtener a través del endpoint:
        - GET /logs/activity-events-type
    - **Ejemplos**:
        - `"1,2,3"`
        - `"10,25"`
- `users` : Cadena de texto que admite una **lista de números enteros positivos o la palabra bot**, separados por comas. Cada número corresponde al **ID de un usuario.**
    - **Ejemplos**:
        - `"1,2,3"`
        - `"10,25,bot"`

## `POST` /logs/activity-timeline/export

Este endpoint está restringido al rol de superadmin, y descarga una lista paginada de registros de actividad en uno o varios formatos.

**Tipos usados de TS:**

- **Request**: `LogActivityExportRequest`
- **Response**: `ExportResponse`

Puede recibir estos parámetros por body:

```javascript
{
    "format": ["csv", "xml"],
    "dateRange": "2025/07/21-2025/07/22",
    "startHour": "11:00am",
    "maxEvents": 1
}
```javascript

Donde:

- **`format`**: `Array<string>`
    
    Lista de formatos de exportación.
    
    **Valores permitidos:** `json`, `xml`, `csv`.
    
    **Debe contener al menos un valor.**
    
    **Ejemplo:** `["csv", "xml"]`.
    
- **`dateRange`**: `string`
    
    Rango de fechas en formato `YYYY/DD/MM-YYYY/DD/MM`.
    
    **Ejemplo:** `"2025/07/21-2025/07/22"`.
    
- **`startTime`** (opcional): `string | null`
    
    Hora de inicio del rango de datos en formato 12h (`hh:mmam` / `hh:mmpm`) o 24h (`HH:mm`).
    
    **Ejemplo:** `"11:00am"`.
    
- **`maxEvents`** (opcional): `number | null`
    
    Número máximo de eventos a exportar.
    
    **Debe ser un número entero positivo.**
    
    **Por defecto:** `null` (sin límite).
    
    **Ejemplo:** `1`.
    

## `POST` /logs/activity-grouped-user/export

Este endpoint está restringido al rol de superadmin, y descarga una lista paginada de registros de actividad en uno o varios formatos.

**Tipos usados de TS:**

- **Request**: `LogActivityExportRequest`
- **Response**: `ExportResponse`

Puede recibir estos parámetros por body:

```javascript
{
    "format": ["csv", "xml"],
    "dateRange": "2025/07/21-2025/07/22",
    "startHour": "11:00am",
    "maxEvents": 1
}
```javascript

Donde:

- **`format`**: `Array<string>`
    
    Lista de formatos de exportación.
    
    **Valores permitidos:** `json`, `xml`, `csv`.
    
    **Debe contener al menos un valor.**
    
    **Ejemplo:** `["csv", "xml"]`.
    
- **`dateRange`**: `string`
    
    Rango de fechas en formato `YYYY/DD/MM-YYYY/DD/MM`.
    
    **Ejemplo:** `"2025/07/21-2025/07/22"`.
    
- **`startTime`** (opcional): `string | null`
    
    Hora de inicio del rango de datos en formato 12h (`hh:mmam` / `hh:mmpm`) o 24h (`HH:mm`).
    
    **Ejemplo:** `"11:00am"`.
    
- **`maxEvents`** (opcional): `number | null`
    
    Número máximo de eventos a exportar.
    
    **Debe ser un número entero positivo.**
    
    **Por defecto:** `null` (sin límite).
    
    **Ejemplo:** `1`.
    

## `POST` /logs/activity-grouped-day/export

Este endpoint está restringido al rol de superadmin, y descarga una lista paginada de registros de actividad en uno o varios formatos.

**Tipos usados de TS:**

- **Request**: `LogActivityExportRequest`
- **Response**: `ExportResponse`

Puede recibir estos parámetros por body:

```javascript
{
    "format": ["csv", "xml"],
    "dateRange": "2025/07/21-2025/07/22",
    "startHour": "11:00am",
    "maxEvents": 1
}
```javascript

Donde:

- **`format`**: `Array<string>`
    
    Lista de formatos de exportación.
    
    **Valores permitidos:** `json`, `xml`, `csv`.
    
    **Debe contener al menos un valor.**
    
    **Ejemplo:** `["csv", "xml"]`.
    
- **`dateRange`**: `string`
    
    Rango de fechas en formato `YYYY/DD/MM-YYYY/DD/MM`.
    
    **Ejemplo:** `"2025/07/21-2025/07/22"`.
    
- **`startTime`** (opcional): `string | null`
    
    Hora de inicio del rango de datos en formato 12h (`hh:mmam` / `hh:mmpm`) o 24h (`HH:mm`).
    
    **Ejemplo:** `"11:00am"`.
    
- **`maxEvents`** (opcional): `number | null`
    
    Número máximo de eventos a exportar.
    
    **Debe ser un número entero positivo.**
    
    **Por defecto:** `null` (sin límite).
    
    **Ejemplo:** `1`.
    

## `GET` /logs/activity-events-type

Este endpoint está restringido al rol de superadmin, y recupera una lista de todos los tipos de eventos disponibles,

**Tipos usados de TS:**

- **Response**: `LogActivityEventDTO[]`
---

# Metrics

## `GET` /metrics

Nos devuelve un snapshot del estado actual del proceso, incluyendo métricas de memoria, event loop, recursos activos y tiempos de respuesta de los endpoints.
****Campos principales

- **`timestamp`** → Fecha y hora en que se recogieron las métricas.
- **`pid`** → Identificador del proceso en el sistema operativo.
- **`uptimeSec`** → Tiempo de vida del proceso en segundos.

### `heap` (memoria del proceso)

- **`usedMiB`** → Memoria actualmente usada (en MB).
- **`totalMiB`** → Memoria total asignada al heap.
- **`usedAfterGcMiB`** → Memoria usada tras la última recolección de basura.
- **`usagePercent`** → Porcentaje de uso de memoria heap respecto al total.

### `eventLoopLatencyMs` (latencia del event loop)

- **`p50`** → Percentil 50 (mediana) de la latencia del event loop.
- **`p95`** → Percentil 95 de la latencia.
- **`p99`** → Percentil 99 de la latencia.
- **`mean`** → Latencia promedio del event loop.

> Valores altos pueden indicar sobrecarga o bloqueos en el servidor.
> 

### `active` (recursos activos)

- **`handles`** → Número de handles abiertos (sockets, timers, conexiones, etc.).
- **`requests`** → Número de solicitudes en curso.

### `http` (rendimiento por endpoint)

Cada clave corresponde a una ruta de la API. Para cada ruta se reporta:

- **`mean`** → Tiempo medio de respuesta en milisegundos.
- **`p95`** → Tiempo de respuesta en el percentil 95.

> Esto permite identificar endpoints lentos o problemáticos (ej: /login_griddo con latencias elevadas).
> 

### Campos de la respuesta

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `timestamp` | string (ISO8601) | Fecha y hora en que se recogieron las métricas. |
| `pid` | number | Identificador del proceso en el sistema operativo. |
| `uptimeSec` | number | Tiempo de vida del proceso en segundos desde que se inició. |

### `heap` (memoria del proceso)

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `usedMiB` | number | Memoria actualmente usada (en MB). |
| `totalMiB` | number | Memoria total asignada al heap. |
| `usedAfterGcMiB` | number | Memoria usada tras la última recolección de basura. |
| `usagePercent` | number | Porcentaje de uso de memoria heap respecto al total. |

### `eventLoopLatencyMs` (latencia del event loop)

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `p50` | number | Percentil 50 (mediana) de la latencia del event loop en milisegundos. |
| `p95` | number | Percentil 95 de la latencia. |
| `p99` | number | Percentil 99 de la latencia. |
| `mean` | number | Latencia promedio del event loop. |

### `active` (recursos activos)

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `handles` | number | Número de handles abiertos (sockets, timers, conexiones, etc.). |
| `requests` | number | Número de solicitudes en curso. |

### `http` (rendimiento por endpoint)

Cada clave corresponde a una ruta de la API. Para cada ruta se reporta:

| Campo | Tipo | Descripción |
| --- | --- | --- |
| `mean` | number | Tiempo promedio de respuesta del endpoint en milisegundos. |
| `p95` | number | Tiempo de respuesta en el percentil 95 (el 95% de las peticiones responden en ≤ este valor). |

### Ejemplo de respuesta

```json
{
    "timestamp": "2025-09-15T13:29:41.098Z",
    "pid": 266852,
    "uptimeSec": 1382,
    "heap": {
        "usedMiB": 110.95,
        "totalMiB": 141.23,
        "usedAfterGcMiB": 109.27,
        "usagePercent": 78.56
    },
    "eventLoopLatencyMs": {
        "p50": 20.14,
        "p95": 20.53,
        "p99": 22.43,
        "mean": 20.24
    },
    "active": {
        "handles": 11,
        "requests": 0
    },
    "http": {
        "/ping": {
            "mean": 1.24,
            "p95": 3.81
        },
        "/login_griddo": {
            "mean": 421.79,
            "p95": 421.79
        },
        "/user/me": {
            "mean": 0.68,
            "p95": 0.7
        }
    }
}

```
---

# Persistencia

Los endpoints de persistencia están orientados a su uso desde scripts y bots que necesitan almacenar estados.

Por ejemplo, si estamos importando un blog, y queremos traernos las imágenes de ese blog pero si una imagen se usa en varios posts traérnosla solo una vez (o al volver a procesar un post queremos que las imágenes sean las mismas y no repetirlas), podemos tener un objeto JSON en el que vamos guardando las equivalencias imagenOriginal → imagenGriddo, y solo tenemos que traernos esa información al inicio del proceso y guardarla al final del mismo.

También lo podemos utilizar para ir almacenando cualquier otra información que nos interese que persista, como por ejemplo el id del último elemento importado por si es un tema de importación que puede interrumpirse y no queremos tener que volver a empezar desde el principio cada vez.

## `GET` /persistence

Te devuelve un array con la lista de claves de persistencia.

## `GET` /persistence/:key

Te devuelve el valor de esa key. La respuesta es exactamente el mismo valor que se le haya enviado con el último POST.

## `POST` /persistence/:key

Actualiza esa key asignándole como valor el objeto JSON que le pasemos en el body.

## `DELETE` /persistence/:key

Elimina esa key y su valor.
---

# Roles

## `GET` /roles

🚨 **Permisos**: usersRoles.manageUsersRoles

Este endpoint te devolverá el listado de roles guardados en la base de datos.

```json
[
    {
        "id": 1,
        "name": "Administrator",
        "hex": "#C7ECF8",
        "description": "You can manage all of your site's settings, users and roles. You can create and publish all pages of your site."
    },
    {
        "id": 2,
        "name": "Constructor",
        "hex": "#B5FBFF",
        "description": "You can edit your website, add pages, modules, modify URLs, menus, colours and themes, html tags. You don't manage users, or manage the site configuration."
    },
    {
        "id": 3,
        "name": "Editor",
        "hex": "#E2EE9F",
        "description": "You have permission to view, add and edit site content, such as pages and blocks."
    },
    {
        "id": 4,
        "name": "SEO Validator",
        "hex": "#FFD7C0",
        "description": "You can manage SEO tags."
    },
    {
        "id": 5,
        "name": "Viewer",
        "hex": "#BCCBFF",
        "description": "You can view the content, but you cannot edit it."
    }
]
```javascript

## `GET` /site/:site/roles

🚨 **Permisos**: usersRoles.manageUsersRoles

<aside>
💡 **Params:**
?order

</aside>

Este endpoint te devuelve un array de objetos con la información de los roles asociados a un site concreto.

Si queremos la información de global, deberemos usar en lugar de un id de site, el string global de la siguiente manera `/site/global/roles` En esta consulta, la propiedad users desaparecerá, pero el order por name continua funcionando correctamente.

En las propiedades que devuelve además del id y el name de cada role, un array de ids con todos los usuarios que tienen ese rol en este site y si está activo o inactivo.

Además con la query order puedes ordenar los resultados

- `order=name-ASC || name-DESC` Ordena por el nombre del rol de manera ascendente o descendente
- `order=users-ASC || users-DESC` Ordena por el número de usuarios adscritos a cada rol.
- `order=permissions-ASC || permissions-DESC` Ordena por el número de permisos adscritos a cada rol.

⚠️ **Si veis que no está la opción de ordenar por creación es porque está pensada para el momento en el que los usuarios puedan crear sus roles. Está funcionalidad aún no está disponible.**

```json
[
	{
        "id": 1,
        "name": "Administrator",
        "hex": "#C7ECF8",
        "description": "You can manage all of your site's settings, users and roles. You can create and publish all pages of your site.",
        "permissions": {
            "totalPermissions": "86/95",
            "sitePermissions": [
                {
                    "name": "Access to sites",
                    "key": "general.accessToSites"
                },
                (....)
            ],
            "globalPermissions": [
                {
                    "name": "Create Global Master Contents",
                    "key": "global.content.createGlobalMasterContents"
                },
                (...)
            ]
        },
				"editable": false,
        "active": true,
        "users": []
    },
    {
        "id": 2,
        "name": "Constructor",
        "hex": "#B5FBFF",
        "description": "You can edit your website, add pages, modules, modify URLs, menus, colours and themes, html tags. You don't manage users, or manage the site configuration.",
        "permissions": {
            "totalPermissions": "86/95",
            "sitePermissions": [
                {
                    "name": "Access to sites",
                    "key": "general.accessToSites"
                },
                (....)
            ],
            "globalPermissions": [
                {
                    "name": "Create Global Master Contents",
                    "key": "global.content.createGlobalMasterContents"
                },
                (...)
            ]
        },
				"editable": true,
        "active": true,
        "users": [
            138
        ]
    },
    {
        "id": 3,
        "name": "Editor",
        "hex": "#E2EE9F",
        "description": "You have permission to view, add and edit site content, such as pages and blocks.",
        "permissions": {
            "totalPermissions": "86/95",
            "sitePermissions": [
                {
                    "name": "Access to sites",
                    "key": "general.accessToSites"
                },
                (....)
            ],
            "globalPermissions": [
                {
                    "name": "Create Global Master Contents",
                    "key": "global.content.createGlobalMasterContents"
                },
                (...)
            ]
        },
				"editable": true,
        "active": false,
        "users": [
            138,
            140,
            170
        ]
    },
		(...)
]
```javascript

## **`GET`** /user/:user/permissions/site/:siteId

🚨 **Permisos**: usersRoles.manageUsersRoles

Este endpoint nos devuelve un array de objetos únicamente con los permisos asociados a ese usuario en concreto en un site determinado.

```json
{
	"userId": "1",
	"siteId": "80",
	"permissions": [
		"categories.accessToSiteCategories",
		"categories.createSiteTaxonomies",
		"categories.deleteSiteTaxonomies",
		"categories.editSiteTaxonomies",
		"content.accessToPages",
		"content.addModulesToPage",
		"content.createDraft",
		...
	]
}
```javascript

## **`GET`** /user/:user/roles

🚨 **Permisos**: usersRoles.manageUsersRoles

Este endpoint nos devuelve un array de objetos únicamente con los roles asociados a ese usuario en concreto.

```json
[
    {
        "siteId": "85",
        "roles": [
            2,
            3,
            1
        ]
    },
    {
        "siteId": "86",
        "roles": [
            4
        ]
    }
]
```javascript

## `PUT` /role/:role/site/:site/activate

🚨 **Permisos**: usersRoles.editRoles

Con este endpoint podremos activar o desactivar un rol en un site concreto. Necesitaremos pasar también en el body el estado de la siguiente manera:

```json
{
    "active": true
}
```javascript

- Poniendo ‘global’ como siteId bloqueará y desbloqueará en global. Cuando esto ocurra, si bloquea un rol en global, luego no se podrá activar desde ningún site. Cuando se vuelva a activar, se podrá activar o desactivar en site.

## `POST` /site/:site/role/activate/bulk

🚨 **Permisos**: usersRoles.editRoles

Hace lo mismo que el endpoint anterior, pero en este caso de manera bulk. Será necesario pasar el id del site como parámetro y luego en el body pasar el listado de roles de la siguiente manera:

```json
{
    "active": true,
    "roles": [2, 3]
}
```javascript

---

También hay nuevas funcionalidades en los listados de usuarios y en la creación de usuarios. Para ver las novedades pinchad en los siguientes links:

- [Añadir roles al crear un nuevo usuario.](User 95a2e849b8d2459096fb85fbc7076bd6.md)
- [Editar roles al editar usuario.](User 95a2e849b8d2459096fb85fbc7076bd6.md)
- [Get user.](User 95a2e849b8d2459096fb85fbc7076bd6.md)
- [Get users.](User 95a2e849b8d2459096fb85fbc7076bd6.md)
---

# Settings

## Parámetros de configuración gestionados por usuarios:

- `skipReviewOnPublish`: (true/false, por defecto false). No haría las validaciones de datos al publicar una página.
- `blockRenders`: (true/false por defecto false). Si está activada, no se harán renders en CX.
- `useMetaTitle`: (true/false, por defecto false). Fuerza que las páginas contengan la etiqueta meta title.
- `useMetaKeywords`: (true/false, por defecto false). Fuerza que las páginas contengan la etiqueta meta keywords. NOTA: Opcionalmente, si UX lo requiere, AX podría no mostrar el campo metaKeywords si esta setting está a false, aunque hay clientes que quieren poder etiquetar páginas pero no usar la meta keywords (UE). Otra opción sería crear una setting showMetaKeywords para indicar si queremos que se muestre en AX.
- `showBasicMetaRobots`: (true/false, por defecto true). Fuerza que salga la etiqueta meta robots cuando contiene la configuración básica y por tanto sería innecesaria.
- `avoidCanonicalsOnSitemaps`: (true/false, por defecto false). Omite en los sitemaps las páginas que tengan canonical definido en sus metas.
- `avoidHrefLangXDefault`: (true/false, por defecto false). Omite la etiqueta hreflang para x-default, apuntando a la versión en el idioma por defecto del site. Por tanto, esta etiqueta solo funciona cuando está desactivada esta opción y tienen que salir los hreflangs, es decir, cuando no estén omitidos por otras configuraciones, haya más de una versión de idioma para la misma página, y una de ellas se corresponda con el idioma por defecto.
- `avoidHrefLangsOnCanonicals`: (true/false, por defecto false). No incluye las etiquetas hreflang en las páginas que tienen canonical.
- `avoidSelfReferenceCanonicals`: (true/false, por defecto false). Hace que las páginas no puedan tener canonical a sí mismas (omite la etiqueta canonical en el render si se da el caso).
- `avoidDebugMetas`: (true/false, por defecto false). Hace que las páginas no incluyan una etiqueta meta en la que se muestran las versiones de components y Griddo con las que se ha generado la página, así como la fecha y hora exactas en que esto sucedió.
- `forceMenuLinksLanguage`: (true/false, por defecto false). Si está activada, cambia los enlaces de los menús por la versión correspondiente al idioma de la página en el que se muestra.
- `autoSummary`: (true/false, por defecto false). Si está activada, permite la generación de meta description y meta keywords de manera automática usando inteligencia artificial.
- `autoTranslation`: (true/false, por defecto false). Si está activada, permite las traducciones automáticas usando DeepL.
- `translationFormality`: (less/more, por defecto more). Indica el grado de formalidad a usar en las traducciones en los idiomas que tengan ese tipo de formalismos. Por ejemplo, en español “more” hablaría de usted y “less” hablaría de tú.
- `appointmentCalendar`: Identificador del calendario de Google a usar para reservar citas.
- `appointmentConfirmationEmailTemplate`: Template de correo electrónico a usar para el correo electrónico de confirmación cuando se ha reservado una cita. Más información en la documentación del endpoint Calendar de API Pública.
- `SSOActivated` Booleano. Indica si AX debe mostrar o no la pantalla de registro del Single Sign On. Para ello además de esta setting la API debe de tener las variables de entorno para que todo el SSO funcione.
- `SSOWelcomeText`: Texto para mostrar en la pantalla de login del SSO. Por defecto tendrá el texto `'To start using Griddo, login with your autentication platform'`
- `SSOEmailPropertyName` setting para poder especificar de que propiedad del token JWT QUE NOS DEVUELVE EL ADFS/SSO tenemos que extraer el email del usuario.
- `allowedUsersToCRUD` // `templatesIdsToCRUD` : Ambas propiedades han de ir juntas. Con ellas se limitará la publicación, edición y borrado de terminados contentTypes a un número cerrado de usuarios. Cada una de estas keys serán un array stringificado con los usuarios y las contentTypes a limitar, ejemplo:
    - `allowedUsersToCRUD: "[”user@example.com”, “user@example.com”]"`
    - `templatesIdsToCRUD: "[”ProgramDetail”]"`
    
    Esto nace de una necesidad **TEMPORAL** de la instancia de Comillas. Lo borraremos cuando la gestión de roles por página y content type esté implementada.
    
- `useForms` (true/false, por defecto false). Con esta setting se activarán los formularios en el entorno.
- `renderDryRunOnDomainsUrl` Listado de dominios separados por coma (,). Para los dominios incluidos en esta setting, CX ejecutará el flujo completo de render en modo simulación (dry-run), generando y enviando la información al API pero sin persistir ni publicar las páginas realmente.
    - **Disponible a partir de la versión** `11.10.49`
- `previewShareExpirationDays`  Número de días (por defecto 15), que permanece activo un enlace de previsualización compartida antes de expirar. Se aplica por defecto al generar nuevos enlaces para compartir páginas fuera de Griddo.
    - **Disponible a partir de futuras versiones**
    

## Parámetros que se configuran a nivel de instancia y se supone que el usuario no lo toca

- `globalLogoBig`
- `globalLogoMini`
- `welcomeText1`
- `welcomeText2` —> Importante, este setting se puede usar para definir el title de AX, de manera que si trabajas con varios entornos a la vez te resulte más fácil identificarlos sin tener que fijarte en la url.

## `GET` /settings

**🔑 No requiere autenticación.**

Devuelve los settings para el sistema (que se almacenan y gestionan en la tabla `settings`). Omite los que son de uso interno (por ejemplo, solo son necesarios para CX o API Pública), especificados en el array noPublicSettings del modelo de settings.

```json
{
    "globalLogoBig": "your-instance.griddo.io/logothesaurusextenden-2x-jrexex_6",
    "globalLogoMini": "your-instance.griddo.io/logothesaurusreduced-2x-cltah3_1",
    "skipReviewOnPublish": true,
    "useMetaTitle": true,
    "welcomeText1": "Welcome back to",
    "welcomeText2": "Griddo",
    "cloudinaryName": "thesaurus-cms",
    "schemasVersion": "1.69.0",
    "schemasTimestamp": "2022-07-15T13:20:23.000Z",
    "apiVersion": "1.69.1",
		"blockRenders": false
}
```javascript

## `GET` /settings/full

**🔑 Rquiere autenticación.**

Devuelve los settings para el sistema (que se almacenan y gestionan en la tabla `settings`). Incluye todos los settings, como por ejemplo `appointmentCalendar`  y `appointmentConfirmationEmailTemplate`.

## `POST` /settings

**🔑 Requiere autenticación.**

🚨 **Permisos**: superadmin

Actualiza o añade settings a la tabla correspondiente 

```json
{
    "globalLogoBig": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1595852323/thesaurus-dbtest/logoextended2x-5f1ec622d44d7.png",
    "globalLogoMini": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1595852337/thesaurus-dbtest/logoreduced2x-5f1ec6315a453.png",
    "welcomeText1": "Welcome back to",
    "welcomeText2": "IE THESAURUS"
    "welcomeText3": "Disfruta!"
}
```