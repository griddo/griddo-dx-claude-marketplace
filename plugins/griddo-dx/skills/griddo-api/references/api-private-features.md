# Actualización automática de páginas relacionadas

## Descripción general

El siguiente proceso describe cómo el sistema gestiona las **dependencias entre páginas** cuando se realizan operaciones de creación, actualización o eliminación de páginas que utilizan **campos de referencia** (*reference fields*).

El objetivo es mantener sincronizadas las páginas relacionadas, garantizando que los cambios en una página se reflejen en las demás que dependen de ella.

![image.png](Actualizaci%C3%B3n autom%C3%A1tica de p%C3%A1ginas relacionadas/image.png)

## **Flujo general del proceso**

### 1. Inicio de la acción sobre una página

Un usuario o servicio puede realizar operaciones sobre una página mediante diferentes orígenes:

- **AX**
- **SDK**
- **Lambda**

Estas acciones son gestionadas por la **API**, que expone los siguientes endpoints principales:

- `postPage`
- `deletePage`
- `setPageStatus`
- `restorePage`

### 2. Verificación del tipo de contenido

Cuando la API recibe una operación sobre una página, primero verifica si **la página corresponde a un CONTENT TYPE de página**.

- Si **NO** lo es → el flujo termina, sin ejecutar acciones adicionales.
- Si **SÍ** lo es → continúa el proceso de gestión de dependencias.

---

### 3. Registro de referencias: `REGISTER_DISTRIBUTOR_STRUCTURED_DATA`

Una vez confirmada que la página es un *content type*, se ejecuta la función **`REGISTER_DISTRIBUTOR_STRUCTURED_DATA`**, encargada de:

- Registrar en la tabla **`distributor_pages`** todos los *reference fields* utilizados por la página actual.
- Mantener actualizada la relación entre páginas y sus referencias, para que el sistema sepa qué páginas dependen de cuáles.

> Esta tabla es esencial para identificar, de forma rápida y sencilla, en qué páginas debe actuar la función de actualización de dependencias.
> 

---

### 4. Actualización de dependencias: `DEPENDENT_PAGES_UPDATER`

Una vez actualizada la información de referencias, se ejecuta **`DEPENDENT_PAGES_UPDATER`**, cuya función es:

1. Buscar en la tabla **`distributor_pages`** todas las páginas que:
    - Usen *reference fields* del mismo tipo que la página modificada.
    - No estén eliminadas.
    - Tengan un `live_status_id` activo (valores posibles: *live* o *pending to publish*).
2. Recorrer todas esas páginas y verificar si la página actual está incluida en sus *reference fields*.
3. Si la referencia existe, **marcar la página dependiente para republicación**, asegurando que refleje los cambios realizados.

## **Objetivo final**

Este proceso garantiza la **consistencia de los datos y la sincronización automática** entre las páginas relacionadas mediante campos de referencia.

De esta forma, cualquier cambio en una página fuente se propaga correctamente a las páginas dependientes, manteniendo la coherencia del sistema.
---

# Typos

Aquí están todos los typos de la nueva funcionalidad de Agrupación de Categorías.

### Respuesta de `GET`/structured_data_contents/:structuredData

```tsx
interface StructuredDataContentsInfo {
  totalItems: number;
  schemasVersion: string;
  schemasTimestamp: string;
  items: Group | Category[] | []
}
```javascript

```tsx
interface Group {
	id: number,
	type: "group",
	structuredData: string,
	parentGroup: number,
	position: number,
	selectable: boolean,
	content: {title: string},
	language: number,
	children: Group | Category[] | []
}
```javascript

```tsx
interface Category {
		contentId: number;
		type: "category";
		structuredData: string;
		parentGroup: number;
		position: number;
		id: number;
		relatedSite: number | null;
		relatedPage: number | null;
		content: {title: string, code: string};
		entity: string | null;
		draft: boolean;
		published: string;
		modified: string;
		deleted: boolean;
		pendingPublishing: boolean;
		language: number;
		originalLanguage: number;
		canBeTranslated: boolean;
		dataLanguages: {id: number, language:number, site: null | number, page: null | number}[] | []
```javascript

### Body de la petición en `PUT` /categories/order y `PUT` /categories/order/bulk

```tsx
// PUT/categories/order
interface BodyCategoriesOrder {
    contentId: number;
    type: 'category' | 'group';
    parentGroup: number;
    position: number;
    structuredData: string;
}

// PUT/categories/order/bulk
interface BodyCategoriesOrderBulk {
    data: Array<BodyCategoriesOrder>
}
```javascript

### Body Groups

```tsx
interface BodyGroup {
    title: string;
    structuredData: string;
    language: number;
    selectable: boolean;
    entity: string | null;
}
```
---

# Agrupación de categoría en subcategorías

https://www.figma.com/file/JlRtJWQgT4ZZ9PDDchkmyz/05---Site-Content-type?type=design&node-id=507-18514&mode=design&t=euYRbGqHArtmcA7U-0

Nueva funcionalidad de crear agrupadores de categorías en subcategorías para ayudar al usuario a encontrar el filtro que busca. El orden que establezca el usuario será el que luego se muestre en los distintos agrupadores.

<aside>
⚠️ **Cambios realizados en la última version #56037**

Todas las referencias que se hacían a `contentId` lo hemos cambiado a `id` tanto en grupos como en categorías.

En los endpoint de recuperación de datos con el `groupingCategories=on` se añade la prop `relatedSite` con el site en el que está el grupo o null si es un grupo global.

Ahora con solo un endpoint se organizan todas las categorías por lo que se ha borrado la versión bulk **`PUT` /categories/order/bulk**. La razón es porque este endpoint dependía completamente del anterior que ya está deprecado.

**Se ha implementado la gestión de grupos y categorías por site.** En determinados endpoints explicados en este documentos ahora será necesario especificar el site (id para site, null para global)

El endpoint de checkgroup devuelve las propiedades `selectable` y `type` en los grupos.

Nuevo endpoint **`GET` /categories/group/:groupId** que devuelva la info de un grupo recién creado. Cuando hago el post se devuelve la info.

Solucionado el bug que hacía que cuando traduzco una categoría, sin el groupingCategories parece que lo devuelve bien, pero cuando usaba el grouping no me lo estaba devolviendo correctamente.

Solucionado el bug del delete bulk de grupos que daba el siguiente error `group: 2, error: "Cannot read properties of undefined (reading 'parent')"` cuando intentabas borrar un grupo y su traducción.

</aside>

# Creación de una nueva categoría

**No hay cambios.** 
Para crear una nueva categoría se hará como hasta ahora usando el endpoint [`POST`/structured_data_content](../Endpoints/Structured Data 40ba51a1c45941c38ce81d7f105cfb36.md) sin necesidad de añadir nada. 
La nueva categoría se creará al final de la lista, tal y como se especifica en el figma.

# Listado de categorías

![Captura de pantalla 2024-03-14 a las 15.48.44.png](Agrupaci%C3%B3n de categor%C3%ADa en subcategor%C3%ADas/Captura_de_pantalla_2024-03-14_a_las_15.48.44.png)

La llamada sigue siendo la misma que antes [`GET`/structured_data_contents/:structuredData](../Endpoints/Structured Data 40ba51a1c45941c38ce81d7f105cfb36.md)

Pero hemos añadido una nueva query que se encargará de ordenar los resultados. Si a esta petición añadimos **`?groupingCategories=(on || off)`** ordenará las categorías por el orden que haya establecido el usuario. El motivo de que sea con una query es para evitar que esta funcionalidad sea un Breaking Change para el resto de instancias.

Si añadimos el groupingCategories la respuesta de la API será la siguiente:

[Typos](Agrupaci%C3%B3n de categor%C3%ADa en subcategor%C3%ADas/Typos d44b01b29ce041a0a1b4f7a452d29edc.md)

Un array de objetos con los grupos y categorías. Bajo el código está la explicación

```json
{
    "totalItems": 3,
    "schemasVersion": "10.3.14",
    "schemasTimestamp": "2024-03-14T14:13:58.000Z",
    "items": [
        {
            "id": 3,
            "type": "group",
            "structuredData": "EVENT_FORMATS",
            "parentGroup": 0,
            "position": 1,
            "entity": "896e98c1-af96-4fe1-a7ac-dd1f984a05e6",
            "selectable": true,
            "content": {
                "title": "miTercerGrupo"
            },
            "language": 4,
            "dataLanguages": [
                {
                    "id": 3,
                    "language": 4
                },
                {
                    "id": 19,
                    "language": 2
                }
            ],
            "children": [
                {
                    "id": 2691,
                    "type": "category",
                    "structuredData": "EVENT_FORMATS",
                    "parentGroup": 3,
                    "position": 1,
                    "id": 2691,
                    "relatedSite": null,
                    "relatedPage": null,
                    "content": {
                        "title": "Live",
                        "code": "live"
                    },
                    "entity": "69898cb0-dc41-487d-b626-c4014f74b41d",
                    "draft": false,
                    "published": "2022-02-09T11:46:07.000Z",
                    "modified": "2022-02-09T11:46:07.000Z",
                    "deleted": false,
                    "pendingPublishing": false,
                    "language": 4,
                    "originalLanguage": 4,
                    "canBeTranslated": false,
                    "dataLanguages": [
                        {
                            "id": 2691,
                            "site": null,
                            "page": null,
                            "language": 4
                        }
                    ]
                },
                {
                    "id": 5,
                    "type": "group",
                    "structuredData": "EVENT_FORMATS",
                    "parentGroup": 3,
                    "position": 2,
                    "entity": "896e98c1-af96-4fe1-a7ac-dd1f984a05e6",
                    "selectable": true,
                    "content": {
                        "title": "Grupo en Eventos"
                    },
                    "language": 4,
                    "dataLanguages": [
				                {
				                    "id": 5,
				                    "language": 4
				                }
                    ],
                    "children": []
                },
                {
                    "id": 3895,
                    "type": "category",
                    "structuredData": "EVENT_FORMATS",
                    "parentGroup": 3,
                    "position": 3,
                    "id": 3895,
                    "relatedSite": null,
                    "relatedPage": null,
                    "content": {
                        "title": "english Event",
                        "code": "english-event"
                    },
                    "entity": "6599e6d4-1f6e-45d9-ab59-656c720ed5c7",
                    "draft": false,
                    "published": "2023-04-25T08:33:12.000Z",
                    "modified": "2023-04-25T08:33:12.000Z",
                    "deleted": false,
                    "pendingPublishing": false,
                    "language": 4,
                    "originalLanguage": 4,
                    "canBeTranslated": false,
                    "dataLanguages": [
                        {
                            "id": 3896,
                            "site": null,
                            "page": null,
                            "language": 2
                        },
                        {
                            "id": 3895,
                            "site": null,
                            "page": null,
                            "language": 4
                        }
                    ]
                }
            ]
        },
        {
            "id": 60660,
            "type": "category",
            "structuredData": "EVENT_FORMATS",
            "parentGroup": 0,
            "position": 2,
            "id": 60660,
            "relatedSite": null,
            "relatedPage": null,
            "content": {
                "title": "Sol",
                "code": "sol",
                "order": "sol"
            },
            "entity": "68e6c6fa-0710-42d3-add9-f70e05b0d60c",
            "draft": false,
            "published": "2024-03-13T16:11:48.000Z",
            "modified": "2024-03-13T16:11:48.000Z",
            "deleted": false,
            "pendingPublishing": false,
            "language": 4,
            "originalLanguage": 4,
            "canBeTranslated": false,
            "dataLanguages": [
                {
                    "id": 60660,
                    "site": null,
                    "page": null,
                    "language": 4
                }
            ]
        }
    ]
}
```javascript

Como podemos ver en la respuesta tendremos por un lado los grupos y por otro las categorías. Algunas de las nuevas propiedades serán:

- `type`: Identifica el elemento. Solo puede ser o `category` o `group` .
- `parentGroup`: el id del grupo en el que está ese elemento. El 0 marcará el root.
- `position`: La posición que ocupa ese elemento dentro del grupo o del root. Será la propiedad por la que se ordene.
- `children`: Esta propiedad solo la tendrán los **grupos**. Será un array donde estarán todos los elementos dentro del grupo.
- `selectable`: Será solo un elemento de los **grupos**. Marcará si el grupo es selectable, por lo que cuando se busque se buscará por todas las categorías dentro del grupo o no.

## Otros endpoints que devuelven el listado ordenado

Hay otro endpoint que también devuelve el listado ordenado.

`GET/site/global/structured_data_contents/:structuredDataId/checkgroup?groupingCategories=on`

![Captura de pantalla 2024-03-20 a las 9.49.40.png](Agrupaci%C3%B3n de categor%C3%ADa en subcategor%C3%ADas/Captura_de_pantalla_2024-03-20_a_las_9.49.40.png)

Con esta llamada se recogen los datos de categorías en este punto de un multicheck select group.

# Mover categorías y grupos

Para ello usaremos dos nuevos endpoints diseñados para ello.

[Typos](Agrupaci%C3%B3n de categor%C3%ADa en subcategor%C3%ADas/Typos 505aa7e4131b4b458fa9b6e74972e6d8.md)

## `PUT` /categories/order

Con este endpoint cambiarás el orden de una categoría. Para ello está esperando determinadas propiedades que le lleguen en el body.

```json
{
    "contentId": 2691, (number)
    "type": "category", (string 'category' | 'group')
    "parentGroup": 0, (number)
    "position": 3, (number)
    "structuredData": "EVENT_FORMATS" (string)
    "relatedSite": 1772, (number | null)
    "language": 1 (number)
}
```javascript

- `contentId`: El id númerico del elemento que queremos mover. El motivo de definirlo como contentId es porque se pueden mover tanto categories como groups.
- `type`: El tipo del elemento que queremos mover y que corresponde al `contentId`  Puede ser “category” o “group”.
- `parentGroup`: El id del grupo dentro del cual queremos meter esta categoría. Si es 0 se entenderá que lo queremos establecer en el root.
- `position`: La posición del elemento con respecto al grupo donde está o en el root.
- `structuredData`: El id en formato string del dato.
- `relatedSite`: El id del site o null si es global.
- `language`: El id del idioma.

# Recuperar, crear y editar un grupo

[Typos](Agrupaci%C3%B3n de categor%C3%ADa en subcategor%C3%ADas/Typos fb2e5fa4ae5b4ca19ddb2a6a333927db.md)

Para crear un grupo usaremos el siguiente endpoint

## **`GET` /categories/group/:groupId**

Devuelve la información de un grupo concreto. Cuando se hace un post, se devuelve la info del grupo recién creado.

## `POST` /categories/group

Crearemos un nuevo grupo que se situará en el último puesto de la lista, tal y como se indica en el diseño.

Los elementos que estará esperando en el body serán

```tsx
{
    "title": "Grupo 1", (string)
    "structuredData": "QA_LOCAL_CATEGORIES", (string)
    "language": 1, (number)
    "relatedSite": 1772, (number | null)
    "selectable": false, (boolean)
    "entity": null
}
```javascript

- `title`: El título del grupo
- `structuredData`: El dato estructurado al que hace referencia el grupo.
- `language`: id del idioma
- `selectable`: booleano para definir si el grupo es seleccionable o no.
- `entity`: En la creación será siempre null.
- `relatedSite` : El id del site en el que crearemos el grupo o null si queremos crearlo global,

## `PUT` /categories/group/:group

Con este endpoint editaremos el grupo y también lo traduciremos. 

Para traducirlo, el body tendrá el mismo formato que en el post pero lo que haremos será pasarle el mismo entity del grupo que queremos traducir y el id del idioma al que lo queremos traducir

```tsx
{
    "title": "Nuevo Grupo ES", (string)
    "structuredData": "EVENT_FORMATS", (string)
    "language": 2, (number)
    "selectable": false, (boolean)
    "entity": "a33071f7-ed48-49a8-8589-3dd6110c51c0" (string)
    "relatedSite": 1772, (number | null)
}
```javascript

# Eliminar un grupo

Para eliminar un grupo usaremos un endpoint creado para tal fin. Según diseño hay dos opciones:

- Borrar solo el grupo y mantener los children
- Borrar el grupo y los children

## `DELETE` /categories/:structuredData/site/:site/group/:group

Params

- `structuredData`: El dato estructurado al que corresponde el grupo que queremos eliminar
- `site`: El site en el que está
- `group`: El id del grupo a eliminar

Query

- `deleteChildren` (on | off) Con on borraremos el parent y todos los children que pudiera tener. Con off sólo borrará el parent y los children ocuparán el lugar que le correspondía a su padre.

Desde API nos encargamos de gestionar la `position` para que ocupe el lugar que le corresponde al hueco que dejen los elementos eliminados.

## `DELETE` /categories/:structuredData/site/:site/group/bulk

Mismo que el anterior pero en su vertiente bulk. En el body le pasaremos un array de ids.

```bash
{
	"groups": [157, 9066, 9344]
}
```
---

# AX: Gestionar la configuración de templates en edición de páginas

# Al crear una página:

Verificar la configuración específica de esa template para ese site, ya que puede tener definido un parentDefault o que incluso no sea editable. En el objeto que se recibe, el parentDefault está mapeado para devolverte la versión para cada idioma, por lo que deberías seleccionar el id que aplique al idioma en que estés creando la página.

[`/site/:site/template/:template/config`](../Endpoints/Data Pack a6fd984ee82144958373572e4ec258bc.md)

# Al editar una página:

Recordar que la respuesta de GET `/page/:id` te devuelve un objeto `templateConfig` que es igual que el que se recibe con el endpoint anterior.
---

# AX: Páginas Draft

La idea detrás de esta tarea es que a partir de ahora se pueda crear un borrador (en adelante draft) de una página y poder editar tanto la versión publicada como su draft. 

Una vez hayamos terminado de editar, podremos bien eliminar el draft o publicarlo como versión definitiva de la página original. Para ello desde API se han creado los cambios necesarios tanto en la BBDD como en los endpoints para que se puedan implementar estas funcionalidades.

# Get Pages

Ahora en las rutas asociadas a las funciones `getPage()` y `getPages()` la API devuelve en la respuesta estas tres nuevas propiedades:

- **`draftFromPage`**: Indica el valor presente en el campo `draft_from_page` de esa página en la BBDD. Por lo tanto, esta propiedad indica que la página es un draft de la página cuyo id esté en esta propiedad. **Por defecto es null.**
- **`haveDraftPage`**: Indica que esta página cuenta con un draft pues este campo es el id de la página que es draft o null si no se da el caso. **Por defecto es null**.
- **`liveChanged`**: booleano que indica si la página live a la que se corresponde ese borrador ha sido modificado.

# Crear un draft

Un draft no es más que una página más, pero que está asociada como borrador de otra.

Crear un draft significa hacer un POST de page, sin id de página (porque estás creando una nueva página, aunque sea borrador de otra), con la propiedad draftFromPage con el valor del id de la página original (de la que esta nueva página es borrador).

Para el PUT, simplemente hay que conservar el valor que tenga draftFromPage tal cual lo recibes en el GET de page, que será null si es la página live, o un id si es un draft.

# POST/PUT Pages

API está esperando que le llegue en el body de la request la propiedad `draftFromPage` (que recordemos que debe ser el id de la página de la que queremos hacer un draft, o null si es una página live).

A la hora de guardar un draft, API tiene en cuenta que si existe otra página con un id diferente en el caso del `PUT` o cualquier otra página en el caso de `POST` que tengan el mismo `draft_from_page`, devolverá un error pues no puede haber más de un draft por página.

También es importante destacar que si una página es live y tiene un draft no se permite la modificación de su `live_status` a otra cosa que no sea `LIVE` o `PENDING_PUBLISHING`

# Publicar un draft como página live

Para publicar un borrador como página live, necesitamos recibir la propiedad **`draftFromPage` en el body** y además una query param **`?publishDraft=1`**. Esto nos indicará que la página es un draft y lo que queremos es publicarlo como página definitiva.

Esta acción debe ejecutarse desde un borrador pues en caso de no haber un `draftFromPage`, la API devolverá un error. Una vez publicada el borrador se eliminará y el `live_status` de esta página pasa a ser el de `Pending Publishing`.

# /pages/status/:status

Otro punto importante es que si una página tiene borrador no podrá cambiar el estado de publicación. Desde API se ignora automáticamente la petición y no muestra error, por lo que este error se debe mostrar en AX.

# Eliminar un Draft

Además de eliminarse cuando un draft es publicado como página definitiva, siempre que eliminemos una página se eliminará automática y definitivamente el draft que estuviera asociado a ella (si lo hubiese).

Aparte, una página draft se puede eliminar igual que cualquier otra página.
---

# Categorías para instancia

Con esta nueva funcionalidad se podrá ordenar las categorías desde la pestaña de global y crear grupos que almacenen categorías.

## Principales funcionalidades

- Posibilidad de crear agrupadores de categorías en subcategorías para ayudar al usuario final a encontrar el filtro que busca en un listado.
- Para ordenar el listado de categorías puedes hacerlo mediante Drag & Drop. Además, las categorías se pueden mover entre los distintos grupos pero no puedes meter una categoría dentro de otra categoría
    - Si movemos el grupo agrupador, éste se moverá junto a su contenido y se colocará en el orden que indiquemos.
- Por defecto, el orden que se establezca en este listado será el que vea el usuario final en el selector de los filtros del listado X.
    - Sin embargo, a través de las llamadas  la instancia puede decidir si quiere respetar ese orden o prefiere que aparezcan en orden alfabético. Se hace por filtro, según el dato en el que vaya

# PASOS PREVIOS A INSTALARSE LA RELEASE

<aside>
⚠️ **IMPORTANTE!** Antes de instalarse la release, desde infra hay que ejecutar el script `Griddo Data Verifier` que se encargará de aplicar el orden a las categorías ya presentes en el entorno concreto de la instancia.

</aside>

La información de cómo arrancarlo está en el readme pero también lo pongo por aquí:

1. Descargarse el repositorio de Github 👉 [https://github.com/griddo/griddo-data-verifier](https://github.com/griddo/griddo-data-verifier)
2. Una vez descargado deberéis crearos un file `.env` en donde pondréis la info de la conexión a la bbdd. Estos datos están en los canales de builds de Slack en la sección del Canvas.
    
    ![Untitled](Categor%C3%ADas para instancia/Untitled.png)
    
3. Ejecutamos el script tal y como se especifica en el README del repo.

Una vez ejecutado este script, se podrá instalar la *release*. Desde los listados de categorías no veréis cambios sustanciales, tan solo que ahora tendréis la oportunidad de ordenar las categorías y crear grupos como se muestra en la guía de usuario.

<aside>
⚠️ **Cualquier problema en este punto consultad con Álvaro.**
Si os da error de conexión es probable que desde Infra haya que autentificar al usuario para poder conectarse a la bbdd.

</aside>

Los cambios en esta parte pertenecen a AX y API Privada por lo que a nivel de instancia no es necesario hacer nada.

# Cambios en API Pública y Hooks

Los cambios que repercuten en instancia son aquellos referidos al uso de API Pública a través de los hooks y que procederemos a explicar.

Los hooks que se verán afectados son `useList` y `useDataFilters`, pero para que esta release no se convierta en un **Breaking Change** el orden de las nuevas categorías se realizará a través de una nueva propiedad que deberemos pasar en ambos hooks: `groupingCategories`.

Veamoslo en acción:

# `useDataFilters`

Con este hook es con el que extraemos los datos de las categorías presentes en un site y language concreto. Con esto extraemos los valores que van en desplegables como el que vemos a continuación.

![Captura de pantalla 2024-06-04 a las 17.22.29.png](Categor%C3%ADas para instancia/Captura_de_pantalla_2024-06-04_a_las_17.22.29.png)

Por ello ahora este hook aceptará la nueva propiedad `groupingCategories` que se adaptará a la funcionalidad del [endpoint](../../API P%C3%BAblica/Endpoints/Filtros adf53588784c420dac407dc0d6b40b6b.md) de filtros que se llama de la API Pública.

Recordemos que cuando se consulta este endpoint `/filters/:structuredData` la respuesta no son las categorías que hay en ese site, sino las categorías que están asociadas a alguno de los datos estructurados del site en el idioma en el que esté la página. De esta manera al usuario final siempre le aparecerán filtros que al pulsar tengan contenido.

El `groupingCategories` por tanto se adapta a esta funcionalidad y, si aún habiendo 20 categorías, en un site solo se usan 4, esas 4 se mostrarán siguiendo el orden por defecto que se haya establecido en los listados. 

Si se usa en conjunto con el `order` que ya existía mantendrán el orden por grupos, pero se ordenarán por el criterio establecido

- Con `order: date` Los grupos se mantendrán en su sitio pues no tienen date de creación establecido, pero las categorías si que se ordenarán
- Con `order: title` Ordenará alfabéticamente tanto los grupos como las categorías
- Con `order: custom` Ordenará solo las categorías por que los grupos no se pueden definir en schemas

Veámoslo con ejemplos

## COMO ESTÁ LLEGANDO AHORA

Ahora mismo está llegando un objeto en el cual los keys son ids de datos estructurados y el value son las categorías que están siendo usadas por datos estructurados del site.

```json
{
    "QA_OTHER_GLOBAL_CATEGORIES": {
        "label": "QA Other Global categories",
        "items": [
            {
                "id": 4350,
                "label": "Categoría other ReferenceField 2",
                "language": 1,
                "published": "2024-05-21T08:50:56.000Z"
            },
            {
                "id": 3968,
                "label": "Alvaro Categoría EN",
                "language": 1,
                "published": "2024-04-03T15:30:39.000Z"
            }
        ]
    },
    "QA_GLOBAL_CATEGORIES": {
        "label": "QA Global categories",
        "items": [
            {
                "id": 4152,
                "label": "Categoría Global Alvaro 1",
                "language": 1,
                "published": "2024-04-29T07:31:33.000Z"
            },
            {
                "id": 3263,
                "label": "013 seo category",
                "language": 1,
                "published": "2024-04-01T09:15:35.000Z"
            },
            {
                "id": 2574,
                "label": "Remote Format",
                "language": 1,
                "published": "2024-03-22T11:48:58.000Z"
            }
        ]
    }
}
```javascript

## **CÓMO LLEGARÁN LOS RESULTADOS CON GROUPING CATEGORIES**

Con el `groupingCategories` se ordenarán por defecto tal y como se haya establecido en el listado de categorías, pero solamente traerá las que tengan relación con alguno de los datos presentes en el site y en el idioma de la página.

Además traerá más propiedades para ayudarnos a gestionar las peticiones:

- Grupos. Cuando llegue un grupo tendrá las siguientes propiedades:
    - `selectable` (booleano) Indica si el grupo es selectable o no
    - `type` Indica el tipo, en este caso ‘group’
    - `children` Especifica los elementos dentro del grupo, pueden ser bien categorías o más grupos.
- Categorías.
    - `type`: Además del resto de propiedades que ya venían, se añade type que indica el tipo, en este caso ‘category’
    

```tsx
//Types
interface Category {
   id: number;
   label: string;
   language: number;
   published: string;
   type: 'category';
}
 
interface Group {
   id: number;
   label: string;
   language: number;
   selectable: boolean;
   type: 'group';
   children: Children;
}
 
type Children = Array<Category | Group> | [];
 
interface Response {
   label: string;
   items: Array<Category | Group> | [];
}
```javascript

```json
{
    "QA_GLOBAL_CATEGORIES": {
        "label": "QA Global categories",
        "items": [
            {
                "id": 30,
                "label": "New group 2",
                "type": "group",
                "selectable": true,
                "language": 1,
                "children": [
                    {
                        "id": 3263,
                        "label": "013 seo category",
                        "language": 1,
                        "published": "2024-04-01T09:15:35.000Z",
                        "type": "category"
                    },
                    {
                        "id": 37,
                        "label": "Grupo Global QA_GLOBAL_CATEGORIES",
                        "type": "group",
                        "selectable": false,
                        "language": 1,
                        "children": [
                            {
                                "id": 2574,
                                "label": "Remote Format",
                                "language": 1,
                                "published": "2024-03-22T11:48:58.000Z",
                                "type": "category"
                            }
                        ]
                    }
                ]
            },
            {
                "id": 4152,
                "label": "Categoría Global Alvaro 1",
                "language": 1,
                "published": "2024-04-29T07:31:33.000Z",
                "type": "category"
            }
        ]
    }
}
```
---

# Cálculo de URLs de páginas

En la tabla pages metemos:

```json
pathString (string en formato slug1/slug2/slug3/slugEstaPagina)
pathId (string en formato id1/id2/id3/idEstaPagina)

Y añadimos el índice pathId !!!!!!
```javascript

~~Lo metemos en createTables.~~

~~Valor por defecto sería para pathString sería null y para pathId sería null.~~

Importante!!!!! De paso mirar para que createTables sea capaz de verificar si falta algún índice y lo pueda crear de una.

**En dbChecks:**

~~Creamos una copia de getBreadcrumb por getHardBreadcrumb (en el mismo archivo breadcrumbs.js). Esta será la función que usaremos para sacar el path por nuestros medios a través de dbChecks.~~

~~Utilizaremos getHardBreadcrum para poner valor a todas las páginas que tengan pathString como null.~~

**Cada vez que se modifica o crea una página:**

- Si no tiene parent, el pathId es id y el pathString es slug. Si no, lo que tenga su parent más sí misma.
- Si es una edición y cambia el pathId o el pathString (puede cambiar solo uno de los dos, y en ese caso también se tiene que hacer), lo que hacemos es actualizar el pathString y el pathId en plan:
    - Se actualizó la ruta de la página parent 5.
    - El path de la página 5 era "noticias/extraordinarias" (oldPathString) y ahora es "noticias/extra" (newPathString).
    - El pathId era "3/5" (3 era noticias, y 5 era "extraordinarias"), sería oldPathId. En ese caso cambia el slug pero no ha cambiado un parent, así que newPathId sigue siendo "3/5".
    - Lo que hago es buscar todas las páginas en la tabla path, que pathId like '${oldPathId}%', y esas serán las páginas en las que tengo que cambiar el pathString y el pathId, por el número de elementos que tenga oldPathString y oldPathId. Es decir, que pathString nuevo sería: ``${newPathString}${currentPathString.slice(oldPathString.length())}``
    
- Se se elimina una página, borramos su entrada en el path.

<aside>
💡 EJEMPLO DE CAMBIAR TODOS LOS PATHS

TENGO:

pathString news/extra
pathId 3/4

AHORA extra cuelga de supernews, que es una página distinta.

pathString supernews/extra
pathId 8/4

LO QUE HAGO:

Buscar en la BBDD todo lo que pathId empiece por 3/4.
En todas ellas, cambio 3/4 por 8/4 y news/extra por supernews/extra.

Y lo puedo hacer todo en una única consulta porque sé la extensión de las cadenas y puedo usar SUBSTRING.

</aside>

**Para sacar la ruta:**

- Se saca el path del parent, se le añade el propio id del parent, y se buscan los slugs de todas las páginas que tengan un id incluido en ese path.

**Para implementar:**

- ~~Solucionar el poder ordenar por url. Básicamente en lugar de ordenar por slug ordenar por pathString.~~
- ~~Solucionar que el cálculo de paths sea más rápido y eficiente. En breadcrumb.js hacer una función getBreadcrumb que sustituya a la anterior, que lo que haga sea tirar de la propia información de pathId.~~
---

# Content Type privados en API

A partir de ahora puede haber content types privados en Griddo los cuales tendrán en los schemas la propiedad `private: true`

Podemos ver un ejemplo de cómo quedaría el esquema en el siguiente código.

```json
{
		dataPacks: ["DEV_PACK"],
		title: "DEV Local Simple Private Data",
		local: true,
		translate: true,
		clone: null,
		defaultValues: null,
		fromPage: false,
    private: true,
		schema: {
			fields: [
				{
					key: "title",
					title: "Title",
					type: "TextField",
				},
			],
		},
	};
```javascript

# Flujo en API

1. Cuando arrancamos la API y se hace la comprobación de schemas creamos una nueva propiedad dentro de la variable global `CONFIG` llamada `privateContentTypes` que será un array con los ids de los structured data content privados en esa instancia concreta. 
    
    Para acceder a este array dentro de la API bastará con consultar la siguiente ruta: `CONFIG.schemas.computed.privateContentTypes`
    
2. **Distribuidores.** El endpoint de distribuidores está limitado para que no devuelva datos de tipo privado. De tal manera, ni la API Privada ni la API Pública devolverá datos privados y por tanto no serán accesibles por el usuario final.
3. **Listados de Datos Estructurados:**
    1. **API Privada**: Hemos añadido una nueva query `excludePrivate` que puede ser `on || off` Con ella podremos decidir si queremos limitar en las respuestas la aparición de datos privados. Por defecto será `off` para que desde AX se puedan ver y descargar estos datos.
        
        Los endpoints que aceptan esta nueva query son los siguientes
        
        - `GET` /structured_data
        - `GET` /site/:site/structured_data
        - `GET` /site/:site/structured_data_content/bulk/:ids
        - `GET` /structured_data_content/bulk/:ids
    2. **API Pública:** Para generar los listados en API Pública llamamos al endpoint de distribuidores que como está limitado, no devolverá datos privados.
        
        Otro endpoint de API Pública que puede devolver datos privados es de los listados manuales si se introduce un id de datos privado. Por ello en este endpoint nos aprovechamos de la query  `excludePrivate` para que no ocurra.
---

# CX Propiedad changedPages

Con la Optimización 1, el principal foco fue en poder localizar desde API qué paginas habían cambiado y devolverlas en la información de site para poder gestionar luego en CX. Para ello cambiaremos el hash de las páginas que han sido editadas.

Nueva gestión de la propiedad `hash` en páginas. Salvo en el CRUD de páginas, ahora cuando se haga cualquier acción que lance el update de un site, se actualizarán todos los hashes de las páginas del site a excepción de las borradas, las despublicadas o las pendientes de despublicar. Un página con un hash nuevo pasará a la propiedad `changedPages` que veremos a continuación.

En la respuesta del endpoint **`GET/sites`** llegará una nueva propiedad `changedPages` que será un array de ids de páginas con las páginas que hayan sido editadas o que cumplan los siguientes requisitos:

- Que su estado sea `pending publishing` , es decir, que haya sido editada, guardada y se haya pulsado Publish Changes. Esto también funcionará con las páginas recién creadas.
- Se excluirán de este array todas las páginas que estén en los estados `published` , `pending offline` y `offline`
---

# Información API Privada

## API Privada

El endpoint principal para devolver la información de distribuidores en API Privada es el siguiente `POST /site/:site/distributor` del cual tenemos la [**información aquí**](../../Endpoints/Structured Data 40ba51a1c45941c38ce81d7f105cfb36.md), pero resumiré.

En el **endpoint** definimos el site del que queremos retornar los datos estructurados o bien ‘global’ para retornar los datos globales. 

- `/site/86/distributor` Te devolverá los datos estructurados que estén importados en el site teniendo en cuenta los siguientes requisitos:
    - En el **site especificado**, en este caso el 86.
    - En el **idioma** que le hayamos pasado por headers, en este caso el 4, inglés.
    - Que estén **publicados** o **pendientes de publicar** (Si están en el site, pero están despublicados no aparecerán).
    
    ![Captura de Pantalla 2023-05-24 a las 12.26.39.png](Informaci%C3%B3n API Privada/Captura_de_Pantalla_2023-05-24_a_las_12.26.39.png)
    

- `/site/global/distributor`  Te devolverá los datos estructurados globales publicados o pendientes de publicar dependiendo del idioma.

La manera en la que podremos alterar el tipo de datos que devuelve este endpoint será con las propiedades que estableceremos en el `body` de la petición.

### Automático

```jsx
// Ejemplo de body automático
{
	mode: 'auto',
	source: ['NEWS'],
	filter: [{id: 9, source: 'NEWS'}],
	order: 'recent',
	quantity: 5,
	allLanguages: true,
  fullRelations: true,
	filterOperator: 'or',
	globalOperator: 'and',
	preferenceLanguage: true
}
```javascript

**PROPIEDADES OBLIGATORIAS**

- `mode` Con esto marcas si quieres que el distribuidor actúe de manera automática o manual.
- `source` Structured Data de origen. Es un array, pueden ser varios orígenes de datos.

**PROPIEDADES OPCIONALES**

- `filter`: Array de objetos con el id de otro dato estructurado con el que estaría relacionado y el tipo de dato estructurado al que se aplica ese filtro. También se puede pasar un array de ids.
- `order`: Hay tres opciones para ordenadar:
    - **recent (asc-desc)**: Ordena por publicación. Por defecto recent. Aceptan -ASC y -DESC como sufijo.
    - **alpha (asc-desc)**: Ordena por título. Aceptan -ASC y -DESC como sufijo.
    - **customfield**: Tiene que ser un campo del esquema del dato estructurado con `indexable:true`. Por ejemplo: startDate-DESC. Recent y alpha.
- `quantity`: Cantidad de elementos a devolver.
- `allLanguages`: Por defecto, false. Si está a true, devuelve resultados en cualquier idioma, priorizando (1) el idioma indicado en headers y (2) el idioma principal del site. Por ejemplo cuando es un listado de programas en el que se tienen que mostrar todos los idiomas pero hay programas que están solo en inglés.
    
    Si hubiera una página traducida en los dos idiomas, devolvería el que esté en el idioma que llega por headers, es decir, en el idioma de la página.
    
- `fullRelations`: Por defecto, false. Si está a true, devuelve todas las relaciones mapeadas con sus valores completos (en false solo devuelve id y label, en true devuelve id y content).
- `filterOperator` y `globalOperator`: opcionales. Por defecto 'or' para filterOperator y ‘and’ para globalOperator. Son los operadores lógicos (or/and) a aplicar sobre los filtros indicados. FilterOperator se aplica solo a los del mismo grupo, y globalOperator se aplica entre distintos grupos. Por ejemplo, si queremos un distribuidor de noticias, y en el filtro indicamos dos escuelas (ESCUELA_1, ESCUELA_2) y dos áreas (AREA_1, AREA_2), filterOperator se aplicará a los filtros de escuelas y a los de áreas, y globalOperator se aplicará a la relación entre escuelas y áreas. Es decir, sería un (ESCUELA_1 ${filterOperator} ESCUELA_2) ${globalOperator} (AREA_1 ${filterOperator} AREA_2). Si filterOperator es or y globalOperator es and (que son los valores por defecto), nos quedaría: (ESCUELA_1 or ESCUELA_2) and (AREA_1 or AREA_2). Mientras no se indiquen explícitamente en los default de la template ni se puedan gestionar desde AX se estarán usando esos valores por defecto.
- `preferenceLanguage` : Por defecto, false pero solo funcionará si la propiedad `allLanguages` también está activada. Los resultados se ordenarán de tal manera que primero aparecerán los items en el idioma de la página y luego el resto. Además si se establece `order`, los resultados vendrán ordenados por el parámetro que le hayamos pasado. Ej. si se ordena por nombre, tendríamos primero los del idioma de la página ordenados alfabéticamente, y luego los del resto de idiomas ordenados también alfabéticamente
---

# Distribuidores

> 🚧 WORK IN PROGRESS . . . Aquí iré volcando la información que voy recopilando sobre distribuidores en API Privada y sus referencias a API Pública
> 

[Información API Privada](Distribuidores/Informaci%C3%B3n API Privada 437080d5d782419b990f9ff7e1647e30.md)
---

# Gestión del render en API

Cuando se produce alguna acción dentro de Griddo por el cuál sea necesario renderizar un site o una página, ej, hacer cambios en la descripción de una página, cambiar el dataLayer de un site o añadir una imagen a general, tendremos que indicar que ese site se debe publicar en el próximo render.

Esto lo gestionamos creando un nuevo hash para cada site cambiado o página y se gestiona desde la función `updateSite()`

```javascript
updateSite()
Parámetros:
	siteId,
  force = false,
  updateAllPagesHashes = true,
  isSitePublished = true,
```javascript

<aside>
👉🏽

Los endpoints que no están hechos (**Languages**, **Menus**, **Navigations** y **Sites**) no tienen apenas impacto en los tiempos de render porque suceden muy poco y su efecto no es tan grave.

</aside>

## Imagenes (Ya está hecho)

`PUT` /image/:imageId

Cuando se cambie algo en las propiedades de una imagen cambiaremos el hash de todos los sites y páginas en donde se esté usando esa imagen.

## Add-ons (Ya está hecho)

`POST` /integration/site/:site/
`PUT` /integration/:id/site/:site/

Los add ons se definen por site y desde la pestaña de settings podemos establecer sobre qué paginas se gestionen. Hay las siguientes opciones:

- **all**: Se aplica a todas las páginas, por lo que se cambiará el hash a todas las páginas.
- **page-specific**: Se aplica en determinadas páginas. Se cambiará el hash de esas páginas solamente.
- **page-manual**: Puedes seleccionarlas desde la página. Se cambiará el hash cuando apliquemos este add on en una página en concreto.
- **custom**: Puedes crear un addon custom en una página, por lo que al crearlo también se cambiará el hash de esa página

Independientemente de la opción, el site en el que estén los addons guardados también se reenderizará.

## Languages

`POST` /site/:site/languages

Este es el endpoint que añade un idioma a un site. Por ello cuando se llame a este endpoint se cambiará solo el hash del site y el de las páginas.

- Posible mejora: Cuando se cambia de idioma, las páginas globales que tengan traducción se actualizan automáticamente en el site?? En ese caso podríamos cambiarle el hash solo a estas páginas y no a todas las del site.

`DELETE` /site/:site/languages/:language

Este endpoint sirve para quitar el idioma de un site. Ahora mismo se cambia el hash al site y a todas las páginas pero el proceso debería ser cambiar el hash al site y a las páginas que vayan a ser eliminadas.

- Comprobar si las páginas cuando se borran tienen borrado lógico o definitivo y si al borrarlas llegan a CX como borradas. Si esto es así tan solo habría que no cambiar el hash a las páginas.

## Menus

`PUT` /menu_container/:id

Actualiza el menú con el id indicado en la url. También espera la propiedad image que puede ser o bien todo el objeto image o bien el id de la imagen en cuestión.

Actualmente cuando hay cambios en el menu se está actualizando el menu y todas las páginas del site.

- Habría que comprobar qué páginas están usando ese menu y actualizar solo esas páginas.

`deleteMenuContainer()` Esta función se llama en varios puntos de los menus y lleva intrínseco en el proceso un `updateMenu()` 

NOTA: Los menús se usan en muchos sitios, especialmente en los navigations.

## Navigations

`POST` /navigations

Crea un nuevo header/footer. 

Cuando esto sucede se cambia el hash del site y de todas las páginas

- Comprobar si al crear un navigation solo se tendría que cambiar el hash del site y no de las páginas pues aún no se ha asociado este header o footer a ninguna página

NOTA: Al ser un navigation nuevo no hay que cambiar nada, ni el hash del site tampoco, SALVO que se cree como “default” (en cuyo caso se cambiará el hash de todas las páginas que tengan el default).

`PUT` /navigations/:id/default

Para seleccionar un header o footer como el default. Ahora mismo se cambia el hash al site y a todas las páginas.

- Comprobar si pones un header/footer por defecto los que ya tienen un header o footer asignado lo pierden. En caso de que no sea así, tan solo tendremos que cambiar el hash a las páginas que no tengan header/footer.

NOTA: Cambiar el hash de todas las páginas que tengan ese navigation, o las que tengan el navigation default si el que se modifica tiene default.

## Pages (Ya está hecho)

`POST` /page `PUT` /page/:id

El primero crea una página y el segundo la edita. Cuando haces cualquiera de estas acciones, se cambia el hash del site y de la página en cuestión.

`DELETE` /page/:id

Cuando borramos una página, en teoría estamos actualizando el hash del site de la página y todas las páginas del site. PROBLEMA! Si el site es global, cambiará el hash a todas las páginas de la instancia.

- Si borramos un página de un site, actualizar el hash de esa página y de ese site.
- Si borramos una página global, actualizar el hash de los sites publicados donde se estuviera utilizando esa página y de las páginas.

`PUT` /pages/status/:status

Cambia el estado de todas las páginas que recibe en la propiedad ids del body (es un array) al estado indicado en la url.

Optimizado para que solo se actualicen los hash de las páginas que estén en un site pendiente de publicar o publicado y las mismas páginas cambien su estado a pending publishing o pending unpublishing.

## Sites

`DELETE` /site/:id & `DELETE` /site/bulk

Cuando borramos un site se está actualizando el hash del site y de todas las páginas del site. Si es en bulk, el hash de todos los sites a borrar y sus páginas.

`POST` /site `PUT`/site/:id

Cuando creamos o editamos un site se cambia el hash del site y de todas sus páginas

NOTA: Esto en principio es correcto. Además sucede con muy poca frecuencia.
---

# Griddo File Drive

En esta página describiremos las implementaciones del **Griddo File Drive** en API y cómo usarlo

## Funcionalidades

- Existe tanto galería Global como de site. Desde site puedes ver los archivos en global y en el site, pero no en los otros sites.
- Ha de tener permisos
- Se tiene que poder ver en qué página de qué site se está usando cada elemento
- Cuenta con opciones bulk de eliminado y subida
- Creación y gestión de carpetas.
- Tags en los elementos
- Crear opción de reemplazado del archivo en todos los sitios donde estuviera ese archivo asociado.
- Contiene buscador.
---

# Headers Obligatorios para Peticiones a la API

## Contexto

Actualmente, las peticiones desde los distintos artefactos que consumen la API no incluyen información suficiente para identificar de forma precisa desde qué artefacto se originan ni con qué versión.

Para mejorar la trazabilidad, monitorización y diagnóstico de comportamientos o errores específicos, se ha establecido un conjunto de headers estándar que **deben incluirse en todas las peticiones salientes** hacia la API.

---

## Headers Obligatorios

Todas las peticiones a la API deben incluir los siguientes headers HTTP:

### 1. `user-agent` (opcional)

Identificador complementario del cliente que realiza la petición.

**Formato:** `{application-id}-v{version}`

**Ejemplos:**

`user-agent: griddo-sdk-v1.1.2
user-agent: griddo-ax-v2.3.0
user-agent: griddo-app-android-v1.5.4` 

> NOTA: solo debe proporcionarse cuando las peticiones se realicen desde scripts que usen la versión v1 del SDK, funciones lambda, scripts ejecutados por cron o cualquier petición realizada a la API fuera de un navegador.
> 

---

### 2. `x-application-id`

Identificador único del artefacto desde donde se originan las peticiones.

**Valores sugeridos:**

- `griddo-sdk`
- `griddo-ax`
- `griddo-cx`
- `griddo-qa`
- `griddo-app-android`
- `griddo-app-ios`
- `lambda-comillas-aggregator`
- `ue-api-alumnis`

**Ejemplo:**

`x-application-id: griddo-sdk`

---

### 3. `x-client-version`

Versión del artefacto que realiza la petición.

**Formato:** Semantic Versioning (`major.minor.patch`)

**Obtención recomendada:**

- En proyectos JS/TS, lo ideal es obtenerlo automáticamente del campo `version` en `package.json`  siempre que ese se actualice.
- Para otros lenguajes/plataformas, usar el sistema de versionado del proyecto

**Ejemplos:**

`x-client-version: 1.1.2
x-client-version: 2.0.0
x-client-version: 0.8.15`

---

### 4. `x-client-name`

Nombre del tipo de artefacto que realiza la petición.

**Valores permitidos:**

- `SDK`
- `AX`
- `CX`
- `QA`
- `APP`
- `LAMBDA`
- `PUBLIC_API`

**Ejemplo:**

`x-client-name: SDK`

---

## Ejemplo Completo de Petición

http

`POST /api/v1/users HTTP/1.1
Host: api.griddo.com
Content-Type: application/json
Authorization: Bearer eyJhbGc...
user-agent: griddo-sdk-v1.1.2
x-application-id: griddo-sdk
x-client-version: 1.1.2
x-client-name: SDK

{
  "email": "user@example.com",
  "name": "John Doe"
}`

---

## Implementación

### JavaScript/TypeScript (Axios)

typescript

`import axios from 'axios';
import { version } from './package.json';

const apiClient = axios.create({
  baseURL: 'your-instance.griddo.com',
  headers: {
    'user-agent': `griddo-sdk-v${version}`,
    'x-application-id': 'griddo-sdk',
    'x-client-version': version,
    'x-client-name': 'SDK'
  }
});`

### JavaScript/TypeScript (Fetch)

typescript

`import { version } from './package.json';

const headers = {
  'Content-Type': 'application/json',
  'user-agent': `griddo-sdk-v${version}`,
  'x-application-id': 'griddo-sdk',
  'x-client-version': version,
  'x-client-name': 'SDK'
};

fetch('your-instance.griddo.com/api/v1/users', {
  method: 'POST',
  headers,
  body: JSON.stringify({ email: 'user@example.com' })
});`

### PHP (Laravel HTTP Client)

php

`use Illuminate\Support\Facades\Http;

$version = config('app.version'); *// O desde composer.json*

Http::withHeaders([
    'user-agent' => "griddo-ax-v{$version}",
    'x-application-id' => 'griddo-ax',
    'x-client-version' => $version,
    'x-client-name' => 'AX',
])->post('your-instance.griddo.com/api/v1/users', [
    'email' => 'user@example.com'
]);`

### Go

go

`package main

import (
    "net/http"
)

const (
    applicationID = "lambda-comillas-aggregator"
    clientName    = "LAMBDA"
    version       = "1.0.0"
)

func makeRequest() {
    req, _ := http.NewRequest("POST", "your-instance.griddo.com/api/v1/users", nil)
    
    req.Header.Set("user-agent", applicationID + "-v" + version)
    req.Header.Set("x-application-id", applicationID)
    req.Header.Set("x-client-version", version)
    req.Header.Set("x-client-name", clientName)
    
    client := &http.Client{}
    client.Do(req)
}`

---

## Beneficios

La inclusión de estos headers permite:

1. **Trazabilidad mejorada**: Identificar exactamente desde qué cliente y versión se origina cada petición
2. **Diagnóstico preciso**: Detectar y solucionar bugs específicos de versiones o artefactos concretos que no estén deprecados o sean legacy
3. **Análisis de uso**: Generar métricas detalladas sobre qué clientes y versiones consumen la API
4. **Monitorización proactiva**: Detectar comportamientos anómalos por cliente o versión
5. **Deprecación controlada**: Planificar la retirada de versiones antiguas con datos reales de uso

---

## Validación en API

La API puede validar y registrar estos headers en cada petición. Como consumidor de la API, ten en cuenta que:

- La presencia de los headers obligatorios puede ser verificada por la API.
- Estos headers pueden registrarse en logs estructurados para análisis posterior.
- Es posible que, tras un período de transición, la API rechace peticiones que no los incluyan.

---

## Preguntas Frecuentes

**¿Qué pasa si mi artefacto no está en la lista de `x-application-id`?**

Si tu artefacto no aparece en la lista, realiza una solicitud por el canal oficial para que pueda ser revisado y, en caso de ser válido, incluido lo antes posible.

**¿Cómo obtengo la versión automáticamente en mi proyecto?**

En JS/TS usa `import { version } from './package.json'`. En otros lenguajes, implementa un sistema similar con tu gestor de versiones.

**¿Estos headers son obligatorios para todas las peticiones?**

No, no todos son obligatorios.
Los tres headers obligatorios son:

- `x-application-id`
- `x-client-version`
- `x-client-name`

El header `user-agent` solo debe proporcionarse cuando las peticiones se realicen desde scripts que usen la versión v1 del SDK, funciones lambda, scripts ejecutados por cron o cualquier petición realizada a la API fuera de un navegador.
---

# Optimizaciones de la base de datos

# 62724. Configuración dinámica de las conexiones a la base de datos

Antes de esta tarea teníamos establecido que el número de conexiones sean 10. A partir de ahora podremos controlarlo desde Infra con una variable de entorno y en caso de no estar definida será de 50.

## Localización

`packages/griddo-api/common/database.ts`

Aquí creamos la clase `DB` que es a través de la que creamos las conexiones

En las conexiones las extraemos de la variable de entorno `connectionsNum` y si no está definida, por defecto será 50. El mismo número es el que se usa para la propiedad `maxIdle`

```tsx
      this.connection = mysql.createPool({
          host,
          port: port ? Number(port) : undefined,
          database: enterDatabase ? rightDatabase(database) : null,
          user,
          password,
          charset: 'UTF8MB4_BIN',
          waitForConnections: true,
          connectionLimit: connectionsNum ? Number(connectionsNum) : 50,
          maxIdle: connectionsNum ? Number(connectionsNum) : 50, // max idle connections, the default value is the same as `connectionLimit`
          idleTimeout: 60000, // idle connections timeout, in milliseconds, the default value 60000
          queueLimit: 0,
      });
```
---

# Orden script Addons con Analytics y Datalayer

[https://www.figma.com/file/Qxnb68MgdbmWQVJw0pLXow/10---Integraciones-Terceros?type=design&node-id=2155-75122&mode=design&t=57oXQj0pTfRbeVSC-0](https://www.figma.com/file/Qxnb68MgdbmWQVJw0pLXow/10---Integraciones-Terceros?type=design&node-id=2155-75122&mode=design&t=57oXQj0pTfRbeVSC-0)

Hasta ahora en la sección de **Add Ons** en settings solo se podían ordenar los add ons pero ahora también se podrán ordenar los `Analytics GTM` y los `Analytics Datalayer`

Para ello se introducen una serie de cambios en algunos de los endpoints que traen información tanto para AX como para CX.

La lógica que se empleará desde la API es aprovecharnos de todo lo que se hizo para gestionar la ordenación de Add ons tratando estas dos propiedades como placeholders de Add Ons.

Para ello:

## `GET` /site/:site/integrations

Este endpoint devuelve la información de los Add ons de un site y es el que se usa para hacer los listados que luego se ordenan. La respuesta que da es la siguiente

```json
{
    "totalItems": 5,
    "page": 1,
    "items": [ {...}, {...}, {...} ...]
}
```javascript

Ahora el array `items` traerá la información de los Analytics.

```json
// Ejemplo del item Analytics GTM
// Analytics Datalayer tendrá el mismo formato cambiando el value de los campos
// correspondientes
{
    "id": 285,
    "name": "Analytics GTM",
    "type": "analytics",
    "editable": false,
    "description": "This row is dedicated to reordering GTM with other add-ons. For any changes please visit the Analytics section",
    "site": 1772,
    "contentHead": null,
    "contentBody": null,
    "contentBodyPosition": null,
    "contentPresence": {
       "presenceType": null,
       "relatedPages": []
    },
    "active": true,
    "scriptOrder": 14,
    "correlativeScriptOrder": 1
}, ...
```javascript

- `name` Como es una propiedad no editable por el usuario, el name será siempre el mismo “Analytics GTM” y “Analytics Datalayer”.
- `type` **Nueva propiedad**. Señala el tipo del item.
    - `analytics` Es la que corresponde al item Analytics GTM
    - `datalayer` Es la que corresponde al item Analytics Datalayer
    - `addon` Corresponde al resto, las integraciones como han sido hasta ahora.
    
    Esta propiedad type se usa en CX para saber por qué item poder filtrar
    
- `editable` **Nueva propiedad**. Booleano que indica qué items se pueden editar. Ahora mismo solo se podrán editar los de `type: “addons”`

El resto de las propiedades con contentHead, contentBody, contentPresence, etc. Llegará todo a null. El único campo que aparece con información es la “description” con el texto que está especificado en el figma

## `GET` /page/:pageId

En la información de la página, en la propiedad `integration` llegarán los Addons ordenados junto con los Analytics. Esto es así porque lo necesita CX pues es de esta propiedad de donde saca la información para luego crear la página final. La duda es si en AX deberían de aparecer solo los Add ons.

La propiedad integrations quedará por tanto así:

```json
"integrations": [
        {
            "id": 285,
            "name": "Analytics GTM",
            "type": "analytics",
            "editable": false,
            "description": "This row is dedicated to reordering GTM with other add-ons. For any changes please visit the Analytics section",
            "site": 1772,
            "contentHead": null,
            "contentBody": null,
            "contentBodyPosition": null,
            "contentPresence": {
                "presenceType": null,
                "relatedPages": null
            },
            "active": true,
            "scriptOrder": 14
        },
        {
            "id": 274,
            "name": "Add on 2",
            "type": "addon",
            "editable": true,
            "description": "Descripción de Add on 2",
            "site": 1772,
            "contentHead": "console.log(2)",
            "contentBody": "",
            "contentBodyPosition": "start",
            "contentPresence": {
                "presenceType": "all",
                "relatedPages": null
            },
            "active": true,
            "scriptOrder": 16
        },
        {
            "id": 273,
            "name": "Add on 1",
            "type": "addon",
            "editable": true,
            "description": "La description 1",
            "site": 1772,
            "contentHead": "console.log('Hello')",
            "contentBody": "",
            "contentBodyPosition": "start",
            "contentPresence": {
                "presenceType": "all",
                "relatedPages": null
            },
            "active": true,
            "scriptOrder": 17
        },
        {
            "id": 286,
            "name": "Analytics Datalayer",
            "type": "datalayer",
            "editable": false,
            "description": "This row is dedicated to reordering Datalayer with other add-ons. For any changes please visit the Analytics section",
            "site": 1772,
            "contentHead": null,
            "contentBody": null,
            "contentBodyPosition": null,
            "contentPresence": {
                "presenceType": null,
                "relatedPages": null
            },
            "active": true,
            "scriptOrder": 18
        },
        {
            "id": 275,
            "name": "Add on 3",
            "type": "addon",
            "editable": true,
            "description": "Description del Add on 3",
            "site": 1772,
            "contentHead": "console.log(3)",
            "contentBody": "",
            "contentBodyPosition": "start",
            "contentPresence": {
                "presenceType": "all",
                "relatedPages": null
            },
            "active": true,
            "scriptOrder": 19
        }
    ]
```
---

# Páginas globales: AX

Se ha hecho un esfuerzo por hacer que la API ofrezca todas las funcionalidades necesarias para poder desarrollar en AX las tareas que requiere datos globales de página. También por irlas testeando.

Sin embargo, debido al tamaño de la tarea y la limitación a la hora de hacer pruebas (falseando datos en la BBDD, haciendo las peticiones a través de postman y manipulando esquemas de DX), es posible que se haya quedado algo en el aire. En ese caso.... ¡pregunta!

# ¿Por dónde empezar?

- En DX deberían cambiar un dato estructurado de página a global (`local=false`).
- Nota: Recuerda que cuando se cambia un esquema en DX, también hay que actualizar API con la versión correspondiente de components.
- Lo ideal sería empezar tocando la configuración de data pack config, que ahora incorporaría una propiedad `import` la cual consiste en un array (por lo general, de un único elemento) de objetos. En ese objeto, `structuredData` será un dato estructurado con las propiedades `local=false` y `fromPage=true` (en adelante, dato global de página). Y categories puede ser null, array vacío (en estos casos importaría todas páginas de ese dato estructurado), o array con una lista de ids en cuyo caso importará solo las páginas de ese dato estructurado que se correspondan con esas categorías). Categories funciona en modo "OR", es decir, la coincidencia con cualquier categoría da positivo.

```json

[
   {
      structuredData: "",
      categories: []
   }
]
```javascript

¿Por qué empezar con esto? Porque es la base para que empiecen a funcionar las importaciones, porque soluciona un problema que se da al editar determinados data packs con la nueva api, y porque una vez hecho es inocuo.

Bonus Track: El objeto de configuración de data pack también incluye, además de esta propiedad import, las propiedades defaultHeader y defaultFooter. Se pueden utilizar o no. Si no se utilizan, el importador entiende que defaultHeader y defaultFooter son null, y por tanto se usarán los que haya por defecto para el site.

# ¿Cómo sé si un dato estructurado es una página global?

Porque en su definición:

- `fromPage=true`
- `local=false`

# ¿Cómo se graba una página global?

Las diferencias entre las páginas "normales" y las globales son estas:

- Las props `header`, `footer`, `site` y `parent` = null. No deberían estar disponibles en el editor. En cualquier caso, API las va a poner a null al grabar.
- Hay que incluir la propiedad `canonicalSite`, que es el id del site en el que esa página va como canónica. Es obligatorio.
- Cuando se graba una página, se da una respuesta inmediata pero la api en segundo plano se encarga de sincronizar las copias en todos los sites que corresponda adaptándolas a los headers, footers y parents en sus correspondientes idiomas.

# Consideraciones en el editor

- Si la info de la página (tanto en el detalle de página como en el listado) tenemos `editable=false`, la página no se puede editar. Esto sucederá principalmente cuando se quiera editar la versión en un site de una página global. Las páginas globales no se editan en un site, sino en el modo global para sincronizar con todos los sites aplicables. Si por alguna razón se activa el editor para una página que tiene editable=false, al grabar va a dar un error.
- Al editar una página global (`site=null`) todos los módulos y todos los idiomas están activos en el editor.
- Recibirás un `breadcrum` falso (solo contiene enlace a la home) ya que el breadcrumb depende del site y estás editando en global. Por la misma razón, la prop `path` será un string vacío, y `fullPath` será null.

# ¿Cuál es la url de preview de una página global?

Si estás en un listado global (no en un site), la url de preview será la que corresponda a su site canonical. Desde AX no tienes complicación, porque lo sigues recibiendo en la prop `fullUrl`.

# ¿Cómo sé si una página puede ser despublicada?

Hasta ahora cualquier página podía ser despublicada. Ahora va a haber páginas que te llegará info indicando que no puede ser despublicada. Será con la propiedad `canBeUnpublished`. También en listados.

# ¿Cómo sé si una página ha sido importada y por tanto la puedo "desimportar"?

La página te lo indica en la propiedad `manuallyImported`. También en listados.

# ¿Cómo sé en cuántos sites está disponible una página global?

La página te lo indica en la propiedad `availableSites`. También en listados. Es un array de objetos, un objeto por cada site con `{id, name}`.

# ¿Qué pasa con el borrado de páginas?

No se puede borrar una página que `editable=false`. Esa página está ahí porque se ha importado manualmente (y se puede "desimportar) o porque está en una regla de importación automática (que se puede ajustar). Como mucho, se puede despublicar del site siempre que no sea la canónica.

# Consideraciones en duplicado de páginas

No se puede duplicar una página que `editable=false`.

# ¿Cómo puedo hacer filtros en listados de página?

Ahora los listados de página permiten usar el parámetro categories, en formato de ids separados por comas. Esto hará que el listado solo contenga las páginas que encajan en alguna de esas categorías.

Sabes qué columnas tienes que mostrar en el listado porque en la definición del dato estructurado asociado, en `schema.fields`, son los campos que tienen `showList=true`. Nota: ahora mismo ningún campo tiene esa propiedad, por lo que habría que ajustarlo en CX.

En la tarea está puesto solo para datos globales de página, pero yo lo haría para datos de página (globales o no), ya que me temo que se definió así por hacer la tarea menos compleja pero en realidad solo nos afecta a nivel de código en una condicional. Si acaso, preguntar a Maite o Sara.

Más info: [https://www.notion.so/thesaurus/Pages-52f480e9c9fc4dc985d576131047a114#d234008581fc4a38b147138a9562a9d6](../Endpoints/Pages eef7a0d621e848bb8ed18742ae7afa6a.md)

# Otros endpoints

- Saber qué sites tienen activado un paquete de datos que contiene una template específica: [https://www.notion.so/thesaurus/Sites-7731d305294f40c4a96298bf22bcf0d9#616250e8ed574b56bef0c1774617d55e](../Endpoints/Sites d7bb0b7cb8d24894a5337e1139fc3d09.md)
---

# Proceso en CX para renderizado de sites

1. Mira la lista de sites en **`/sites`**.
2. Va a procesar solo los que `shouldBeUpdated===true`. OJO: Porque por información tenemos campos para saber si el site está actualizado o se está renderizando o cuántas horas lleva renderizando, pero **lo que decide si el site se renderiza o no es exclusivamente `shouldBeUpdated`**, ya que hay otros factores como por ejemplo si el site está publicado, o si está programado para publicarse entero en un momento dado. NOTA: Si el proceso lleva demasiadas horas renderizando el site (propiedad `renderingHours` del site) tenemos una variable de entorno en la api llamada maxHoursToRenderSite que por defecto está en 4, que fuerza desde la propia api un timeout pasado ese tiempo. Si se quiere forzar ese timeout desde api, habría que hacer una llamada a **`/site/:site/build/end`** con estos valores en el body: `siteHash=null`, `publishHashes=[]` y `unpublishHashes=[]`.
3. **Llama a `GET` `/site/:site/build/start`. Se queda con los valores recibidos: `siteHash`, `publishIds` y `unpublishHashes`.
NOTA:** También recibiremos la propiedad `redirects` que indica todas las redirecciones que habría que crear.
4. NOTA: De estos tres valores recibidos, `siteHash` y `unpublishHashes` simplemente se van a guardar para utilizar en la llamada de finalización del paso 7.
5. Inicializa un array vacío `publishHashes`.
6. Va a renderizar cada una de las páginas cuyo id está en `publishIds`. Por cada una de ellas renderizada sin errores, va a hacer un push con el hash de esa página en `publishHashes`.
7. **Cuando termina el proceso, llama a `POST` `/site/:site/build/end` enviando en el body:**
    1. El `siteHash` que recibió en el paso 3.
    2. El `publishHashes` que inició en el paso 5 y generó en el 6.
    3. El `unpublishHashes` que recibió en el paso 3.
---

# Programación de Publicación de Páginas. 61956

Como Editor quiero poder programar la publicación de una página para automatizar su despliegue. Para ello se han hecho una serie de cambios para poder gestionar esta funcionalidad.

[**https://www.figma.com/file/IDtQSyH4bEIUFnzPgFjiGo/03---Editor?type=design&node-id=15834%3A141444&mode=design&t=ZA4m0FXCOonGuEcL-1**](https://www.figma.com/file/IDtQSyH4bEIUFnzPgFjiGo/03---Editor?type=design&node-id=15834%3A141444&mode=design&t=ZA4m0FXCOonGuEcL-1) 

# Cambios en AX

Los cambios se aplican en los endpoints **`POST`**/page y en **`PUT`**/page/:id.

1. En el body de la llamada llegará una nueva propiedad `publicationScheduled` que podrá ser `null` o una string con la fecha en la que esa página será publicada.
2. El objeto `livestatus` deberá contener el id del status `Scheduled` que se devuelve en la llamada **`GET`/live-status** y es el cual será el siguiente:

```json
"liveStatus": {
    "id": 5,
    "title": "Scheduled",
    "status": "scheduled"
}
```javascript

### Tipos de páginas

- Páginas de tipo Basic: Se actualizará la tabla `page` en la columna `publication_scheduled`
- Página con dato estructurado: Se actualizará tanto la tabla `page` como la tabla `structured_data_content` con la fecha marcada en la página en la columna `publication_scheduled`
- Datos simples: Se actualizará la tabla `structured_data_content` en la columna `publication_scheduled`

Esta propiedad nueva además se devuelve en `GET`/page/:id. Si es `null` se entenderá que no tiene fecha programada de publicación y se tratará como una página más.

# Qué sucede en la API con el cron

La API en determinados momentos ejecuta un cron con varias operaciones, las que nos ocupan ahora son las relacionadas con la publicación de páginas programadas. Para ello se ejecutan dos crones.

1. Cada 30 minutos, se guarda en la variable global CONFIG la propiedad `scheduledPages` la cual es un array de objetos con dos propiedades: los ids de páginas a publicar y la hora a la que han de publicarse. Cada 30 minutos se vuelve a ejecutar para consultar si hay nuevas páginas.
2. Cada minuto se comprueba si hay páginas que publicar y en caso de haberlo las publica.

Con la publicación la propiedad `publication_scheduled`  pasará a ser null y el proceso vuelve a empezar.

## APUNTES

- No se puede programar una página global desde site
- Una vez que una página esté publicada no se puede programar, habrá que despublicarla y poner una fecha de programación
-
---

# Asignar roles a un usuario

En el momento actual, 27 de Agosto de 2025, un usuario puede ser `SuperAdmin` o `Member`, y en caso de ser member, puede ser uno de los 5 Roles existentes en Griddo, `Administrator`, `Constructor`, `SEO Validator`, `Editor` o `Viewer`.

Toda la gestión de asignar roles se hace desde una única función `*assignUserRoles` .* Esta función se llama en los siguientes puntos

- `*createUser`* El cual se llama en el endpoint **`POST`/user.**  Aplica los roles a un usuario recién creado.
- `*updateUser`* El cual se llama en el endpoint **`PUT`/user/:id.** Sirve para editar un usuario y como en la información del usuario vienen la información con los roles, también se editarán.

## Información del usuario

En el **`GET`/user/:id** nos llegará las propiedades del usuario y las dos propiedades que nos interesan en roles son: 

- `isSuperAdmin`: Booleano
- `roles`

```tsx
// Typo de roles
const Role = {
	siteId: number | "global" | "all";
	roles: number[]
}

const roles: Role[];
```javascript

## `assignUserRoles`

Esta función controla todas las casuísticas posibles a la hora de asignar roles a usuarios.

*Datos a tener en cuenta*

- En Griddo no se lanza error o no se prohibe que se pueda crear un usuario member y que no se le adjunten roles. De modo que puede que en los params lleguen como `roles: []` y `isSuperAdmin: false` Tenemos que tener controlada este caso y darle el roles por defecto que es Viewer en todos los sites.
- Solo un SuperAdmin puede crear o eliminar SuperAdmins.

*Acciones que no dependen del userId*

- **Si el usuario es un bot**, marcado por el `params.bot = true` se le asigna automáticamente el rol de superadmin y no continúa el proceso.
- **Si es un usuario nuevo (**`params.isNewUser = true`**) sin roles asignados y no es superadmin** se le asigna por defecto el rol Viewer.

*Acciones que dependen del userId*

- Si es un usuario que tiene roles guardados en la bbdd pero en los params no le llega ningún rol, será porque al editarle le han quitado todos los roles y por ello obtiene el rol por defecto y se borran todos los roles que hubiera tenido antes.
- **Determinamos los sites (siteId) y el member type**:
    - `incomingSitesArr`: sitios de los roles nuevos. Los que llegan por params porque
    - `presentSiteArr`: sitios de los roles actuales.
    - `siteRolesToDelete`: sitios que ya tenía pero no están en los nuevos roles.
    - `getUserMemberType`: Para averiguar si el usuario es SuperAdmin o member
- La línea `if (isCurrentUserSuperAdmin && isSuperAdmin) return;` es debido a que a partir de esta línea las acciones que se suceden solo pueden llevarse a cabo sobre usuarios members.
- Como roles es un array de objetos, el bucle del final se encarga de ir por cada objeto y realizar acciones de actualizar, añadir o eliminar roles y sites según corresponda. Lo que hace es:
    - Si no tiene roles, gestiona roles vacíos (`manageEmptyRoles`).
    - Si es `all` y no es superadmin → asigna roles a *all*.
    - Si es `global`, no es superadmin y no estaba previamente → inserta rol *global*.
    - Si el sitio es nuevo y no es superadmin → inserta el nuevo rol en ese `siteId`.
    - Si el sitio ya existía:
        - Calcula qué roles hay que **insertar** (los nuevos que no estaban antes).
        - Calcula qué roles hay que **eliminar** (los que estaban antes y ya no están).
        - Inserta y/o elimina según corresponda.
    - **Al final**, si hay sitios sobrantes (`siteRolesToDelete`), elimina sus roles.
---

# Comprobar permisos fuera del endpoint

En ocasiones necesitaremos comprobar los permisos de un usuario dentro del modelo. Un buen ejemplo es el endpoint **`PUT`/pages/status/:status**

El permiso que estamos controlando es el `content.publishUnpublishPages`  pero dentro del modelo necesitamos distinguir si el usuario está publicando o está despublicando una página. De modo que en el modelo, en `setPageStatus()`, estamos comprobando qué acción está usando el usuario para mostrar un error correspondiente.

Los pasos siempre son los mismos

```tsx
// Averiguamos qué permisos tiene el usuario que hace la acción
// y si es SuperAdmin a través de estas dos funciones.
const userPermissions = await getUserPermissions(db, userId);
const isUserSuperAdmin = await checkUserIsSuperAdmin(db, userId);

// Luego comprobamos. Si es superadmin sigue adelante, si no 
// se hace la comprobación

	if (
		!isUserSuperAdmin &&
		status === 'upload-pending' &&
		!userPermissions.includes('content.publishUnpublishPages')
	) {
		throw new Error("You don't have permission to publish pages");
	}

	if (
		!isUserSuperAdmin &&
		status === 'offline' &&
		!userPermissions.includes('content.publishUnpublishPages')
	) {
		throw new Error("You don't have permission to unpublish pages");
	}
```javascript

Esto está en algunas partes de la aplicación donde hay que hacer una comprobación más exhaustiva de los roles.
---

# Listado de sites

Si un usuario tiene permisos y roles en un site, cuando acceda al listado solo le deberían aparecer los sites a los que pueda acceder. Eso lo controlamos desde API en el endpoint:

```tsx
router.get('/sites', isAuth, Sites.getSites);
```javascript

Básicamente lo que hacemos es una vez se han hecho las llamadas a la base de datos y se ha recuperado toda la información, filtramos por los sites que
---

# Middleware para comprobar permisos

Cada endpoint en API está limitado por permisos y para gestionarlo usamos el middleware `checkUserHasPermission`  el cual está en la ruta `/models/roles/permissions.ts/`  

El formato para usarlo es el siguiente:

```tsx
// Endpoint de GET Pages
router.get(
	'/site/:site/pages/:extra?', // ENDPOINT
	isAuth,                      // Middleware de Autenticación
	checkUserHasPermission({     // Middleware de permisos
		permissions: ['content.accessToPages'], // Array de keys de permisos para hacer la llamada a este endpoint.
		siteId: 'params.site',     // Para saber cuál es el id del site y de esta manera saber si hay que llamar a permisos globales o de site.
	}),
	Pages.getPages,
);
```javascript

Con esto comprobamos que el usuario que hace esta llamada tiene un rol en cuya lista de permisos debe existir el permiso `content.accessToPages` 

## Datos a tener en cuenta

### **Presencia del site**

Habrá endpoints en los que necesitemos saber cual es el id del site para usarlo como indicador de si las acciones del usuario son en site o en global mientras que en otros no será necesario.

En endpoints como el que acabamos de ver será sencillo encontrar el id del site ya que está en el params, pero en otros será más complicado. Ejemplo, `GET/image/:imageId` . 

Por esta razón en el middleware `checkUserHasPermission` buscamos el id del site con la función `giveMeTheSiteId` , la cual recibe un objeto con todas las opciones disponibles y dependiendo de estas opciones:

- Si no hay nada, devuelve `'global'`.
- Si explícitamente se pasa `'global'`, también devuelve `'global'`.
- Si se pasa un `siteId` válido, lo devuelve.
- Si no hay `siteId`, pero hay otros IDs (ej: `pageId`, `imageId`, `formId`, etc.), llama a funciones auxiliares (`getPageSite`, `getImageSite`, etc.) para consultar en la base de datos cuál es el `siteId` relacionado.
- Devuelve una lista de `siteId` encontrados.

### currentUserId

Usado para la comprobación del endpoint GET PUT /user/:id, donde podemos pasarle en lugar de un id un `user/me` y sacar los datos del usuario que esté conectado.

### Determinar si es un site global

```jsx
const isGlobalSite =
	bulkSiteId === 'global' ||
	siteIdsArr === 'global' ||
	(!bulkSiteId &&
		!pageId &&
		!navigationId &&
		!imageId &&
		!roleId &&
		!userId);

```javascript

Un site se considera **global** si:

- El `bulkSiteId` es `'global'`, o
- El `siteIdsArr` resultó ser `'global'`, o
- No vino ningún identificador (no siteId, no pageId, no navigationId, etc.).

### Query

```tsx
const sql = /* SQL */ `
    SELECT
        count(*) count,
        (SELECT member_type from user where id=${userId}) as memberType
    FROM
        user_site_role usr
        LEFT JOIN role_permission_relation rpr ON usr.role_id = rpr.role_id
        LEFT JOIN permission p ON rpr.permission_id = p.id
    WHERE
        usr.user_id = ${userId}
        AND usr.site_id ${sqlSiteId}
        AND p.key IN (${permissions.map((p) => `'${p}'`).join(',')})
`;
```javascript

Este query hace lo siguiente:

1. Cuenta cuántos permisos válidos tiene el usuario en ese `siteId` (o global).
2. También obtiene el `member_type` del usuario (ej: si es `superadmin`).
3. Las tablas que se consultan:
    - `user_site_role` (relación usuario ↔ sitio ↔ rol).
    - `role_permission_relation` (qué permisos tiene cada rol).
    - `permission` (los permisos en sí).

Y en la parte final te devuelve true solo si es superadmin o tiene al menos un permiso válido en el sitio de la lista que le pasamos
---

# Roles y Permisos en la BDD

Los datos de roles y permisos se guardan en 6 tablas de la base de datos:

- `permission` Listado de todos los permisos de Griddo. La columna `key` es un nombre en clave que se usa entre AX y API en determinadas operaciones.
- `role` Listado con todos los roles de Griddo. La columna `visible` sirve para mostrarlos en AX y la columna `editable` sirve para saber si el usuario los puede activar o desactivar. En caso de que un rol no se pueda desactivar (SuperAdmin, Admin y Viewer siempre deben estar activos) esta prop será 0 y se traducirá en que en AX aparecerán bloqueados.
    
    ![Captura de pantalla 2025-08-26 a las 16.15.56.png](Roles y Permisos en la BDD/Captura_de_pantalla_2025-08-26_a_las_16.15.56.png)
    
- `role_activation_relation` Sirve para tener el registro de qué rol está activado en qué site. Siempre han de estar el estado de los roles globales, de hecho al arrancar uno de los seeders iniciales es precisamente guardar en esta tabla que todos los roles comienzan como activos en global.
El motivo es porque por defecto los sites toman el estado de cada rol de global, si en site desactivas alguno, en esta tabla se guardará la relación de que en el site N el rol X está activado pero para los otros 4 tomará el estado de lo que hay en global.
- `role_permission_relation` En esta tabla se guarda qué permisos (especificados por id de la tabla de permisos) están asociados a qué roles (especificados por su id en la tabla de roles). Los datos de estas relaciones se extraen de `/default/roles.json` ya que en cada rol hay una propiedad `permissions` con el listado de los permisos asociados a ese rol.
- `user` Lo único que usamos de esta tabla para roles y permisos es la columna `member_type` en la cual guardamos si un usurio es de tipo `superadmin` o `member`
- `user_site_role` Guarda la relación de que permiso tiene cada usuario en cada site.
    - `user_id` Es el id del usuario.
    - `site_id` Puede ser el id del site, el string `all` si tiene permisos para todos los sites o `null` si son los permisos globales.
    - `role_id` El id del rol que tiene ese usuario en ese site concreto.

Cada usuario puede tener varios roles en sites diferentes de modo que puede haber varias rows en las que el usuario es el mismo. Por ejemplo, 

```tsx
// El ejemplo siguiente significa que el usuario 7 
// tiene el rol 6 en global y en todos los sites
# id, user_id, site_id, role_id
'3', '7', NULL, '6'
'4', '7', 'all', '6'

// El ejemplo siguiente significa que el usuario 4 
// tiene el rol 5 en los sites 5, 50, 7 y 39
# id, user_id, site_id, role_id
'26', '4', '5', '5'
'27', '4', '50', '5'
'28', '4', '7', '5'
'29', '4', '39', '5'

```
---

# Roles y Permisos

*A 10 de Julio 2025*

En Griddo la gestión de permisos se hace a través de los roles de los usuarios. Es decir, si un usuario quiere crear una página debería tener un rol (Admin, SEO ,Viewer, etc.) que tenga el permiso de crear páginas. Lo que se le adjunta al usuario no es el permiso, sino un rol que tiene diferentes permisos

[Roles y Permisos en la BDD](Roles y Permisos/Roles y Permisos en la BDD 25be2540c9e2801686a2f6296d9c2902.md)

[Middleware para comprobar permisos](Roles y Permisos/Middleware para comprobar permisos 25be2540c9e2807b8da5fa88b3b245cf.md)

[Comprobar permisos fuera del endpoint](Roles y Permisos/Comprobar permisos fuera del endpoint 25be2540c9e280d093e4f9693b26c647.md)

[Asignar roles a un usuario](Roles y Permisos/Asignar roles a un usuario 25ce2540c9e280509d54d95eb4a2434d.md)

[Listado de sites](Roles y Permisos/Listado de sites 25ce2540c9e280d89b1ec30a7035bc87.md)
---

# Documentación Front

Para el acceso a Griddo en su mayor parte se usará el mismo endpoint de acceso.

## `POST` /login_check

Si te conectas a un entorno que tiene definido el login con SSO, este endpoint te redireccionará al flujo del SSO.

Por el `body` estará esperando la propiedad `petitionId` que es un identificador usado para extraer el token de acceso de la base de datos.

- Si no le llega un `petitionId` o ese `petitionId` no tiene un token asignado, este endpoint devolverá una url a la que habrá que redirigir al usario para que se registre. La respuesta será por tanto algo así:

```bash
"your-instance.griddo.es/adfs/oauth2/authorize/?client_id=3bb011d9-ded3-46b9-8eea-41cf2ad6a35b&scope=openid email profile unique_name&response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Flogin_griddo&redirectUri=http%3A%2F%2Flocalhost%3A3000%2Flogin_griddo"
```javascript

- Si le llega un `petitionId` correcto en su lugar, este endpoint te devolverá un token de Griddo y la autenticación funcionará igual que antes.

```bash
{
"message": "Authenticated sucesfully",
"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTA0MSwidXNlcm5hbWUiOiJhbHZhcm9zYW5jaGV6bGFtYWRyaWQiLCJlbWFpbCI6ImFsdmFyby5zYW5jaGV6QHNlY3VveWFzLmNvbSIsImNoZWNrIjp0cnVlLCJpYXQiOjE3MjUyODM4ODZ9.oe8J7ttypdp1qnU9IE5X7f7WxwFyOEUagokfvfSpAf8"
}
```javascript

## ¿Cómo adquirimos este `petitionId`?

Esto está relacionado con el flujo de redirección. 

En el primer acceso a Griddo el usuario no tendrá `token` y por lo tanto no tendrá `petitionId` . Una vez se haya llamado al **`POST`/login_check** y el usuario haya ingresado su user y password en su plataforma, automáticamente se llamará internamente al endpoint **`GET`/login_griddo.**

Este endpoint se encargará de comprobar que el usuario exista en Griddo, recuperar el token del servicio de la plataforma y guardarlo en la bbdd asociado a un `petitionId` . Si todo ha salido correcto, se redirigirá a AX y en la url tendrás la información de este petitionId.

```bash
your-instance.griddo.io/login?petitionId=32972f0f-8e3e-43ec-a7a8-fd44dd7e83a4
```javascript

Una vez tengas el `petitionId`  vuelve a llamar al endpoint **`POST`/login_check** pasándole este petitionId y ya podrás acceder a **Griddo.**
---

# Single Sign On (SSO)

# Información

- Figma: [**https://www.figma.com/design/i3aNvOdLMsFwpUAB3aALtP/14---Login?node-id=1958%3A73000&t=o5MIwYqHSEMgWucq-1**](https://www.figma.com/design/i3aNvOdLMsFwpUAB3aALtP/14---Login?node-id=1958%3A73000&t=o5MIwYqHSEMgWucq-1)
- Rama de la épica: `epic/57366`
- Rama de la parte de API: `epic/57366-api`

<aside>
⚠️ La razón porque la rama es la de la épica es porque luego desde QA se testean en Docker y necesitan que todo esté en la misma rama

</aside>

- Librería que utilizamos para la gestión del SSO: `openid-client`
    
    [Documentación del npm](https://www.npmjs.com/package/openid-client)
    
    [Documentación github](https://github.com/panva/node-openid-client/blob/main/docs/README.md)
    

# Documentación para AX

[Documentación Front](Single Sign On (SSO)/Documentaci%C3%B3n Front dc0a730f0aa148ec8d0e7fc04150abe5.md)

# Variables de Entorno

Para que funcione correctamente la implementación del SSO son necesarias las siguientes variables de entorno

```bash
# SSO Options
export SSO_ACTIVATED=1
export SSO_REDIRECT_URL='http://localhost:3000/login_griddo'
export SSO_CLIENT_ID='8399cb49-fd15-48ba-a30b-40dd331d91fe'
export SSO_CLIENT_SECRET='[REDACTED]'
export SSO_OPENID_URL='your-instance.griddo.es/adfs/.well-known/openid-configuration'
export SSO_USERINFO_URL='your-instance.griddo.es/adfs/userinfo'
```javascript

# Como arrancar la API en local para probar

Vete a la rama `epic/57366-api` y añade las variables de entorno del paso anterior.

Puedes seguir esta guía para arrancar la API de `develop` en local

[https://www.notion.so/griddoio/C-mo-arrancar-API-en-local-d2e89d5bf8f141599675bcb5e1b43cb5](../C%C3%B3mo arrancar API en local d2e89d5bf8f141599675bcb5e1b43cb5.md)

Luego sigue el flujo que se especifica a continuación. He dejado console.logs con datos importantes como la url de autenticación que se crea para poder probarlo todo.

# Flujo de Autenticación en API

Cuando el usuario llama al endpoint **`POST` /login_check** si la variable de entorno `SSO_ACTIVATED` está activada, el flujo de autenticación se gestiona con el SSO.

### `getSSOLogin()`

Comprobamos a través de la cookie si el usuario está autenticado en la aplicación a través de la cookie. Si no lo está o no hay cookie, le redirigiremos al proveedor del ADFS para que se conecte a través de la función `redirectToProvider()`

### `redirectToProvider()`

Aquí creamos una url de autenticación a través del método `client.authorizationUrl()` de la librería `openid-client`.

Como parámetros le pasamos el `scope` y la url de redirección, la `redirectUri.` En el scope especificaremos los campos que queremos que nos devuelvan. La url redirigirá al usuario al ADFS para que introduzca sus datos y al conectarse se llamará al endpoint `GET` /login_griddo

### `GET /login_griddo`

Cuando el usuario introduzca sus datos en el ADFS le redirigirá a este endpoint que a su vez llama a la función `handleGriddoSSO()`  

En esta función a través de los métodos `callbackParams` y `callback` de la librería `openid-client` crearemos el token que necesitamos para comprobar si el usuario existe en Griddo a través de la función `authenticateUserInGriddo()` 

### `authenticateUserInGriddo()`

En esta función podemos usar o el método `client.userinfo()` o la función `getUserInfo()` para recuperar a través del token generado en el paso anterior  la información del mail que pedimos en el `redirectToProvider` cuando creamos el scope de la url.

Si ninguno de estos dos procesos funciona, en último lugar decodificaremos el `acess_token` para tratar de extraer el email de usario.

Una vez extraído comprobaremos que el usuario existe en Griddo y en caso de existir permitiremos el acceso. En caso de no existir devolveremos el mensaje de error especificado en el diseño.