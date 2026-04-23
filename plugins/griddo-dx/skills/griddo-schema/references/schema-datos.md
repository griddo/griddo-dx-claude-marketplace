# Categorías de DataPacks

Definen categorías para ser asignadas a los schemas de DataPacks.

**Archivo**

`src/schemas/data-packs/categories/GRIDDO_PACK_CATEGORY/index.ts`

**Schema de ejemplo**

```jsx
import type { Schema } from "@griddo/core";

export const GRIDDO_PACK_CATEGORY: Schema.DataPackCategory = {
	title: "Griddo datapack category",
};
```

# ContentType

Los schemas de content type definen los tipos de datos de la instancia.

## Tipologías

[Simples](ContentType/Simples%203afce2767d7b465f87186853ef4c746a.md)

[Page](ContentType/Page%201894a3c2e0ce49308f2385eda49747d5.md)

[Categorías](ContentType/Categor%C3%ADas%20464224f023c24fa8add48e6d6b588036.md)

## Extras

[ContentType que expiran](ContentType/ContentType%20que%20expiran%20f4f3830c418147f9b424e02d8fdd1698.md)

# Data packs

Los schemas de data packs definen los data packs de la instancia.

**Archivo**

`src/schemas/data-packs/packs/GRIDDO_PACK/index.ts`

**Schema de ejemplo**

```jsx
import type { Schema } from "@griddo/core";

export const GRIDDO_PACK: Schema.DataPack = {
	title: "Griddo Datapack",
	category: "GRIDDO_PACK_CATEGORY",
	description: "Datapack description",
	image: "/thumbnails/data-packs/pack1/thumbnail@1x.png",
};
```

## Elementos

### Categorías

# Categorías

Los schemas de categorías son en realidad schemas de ContentType de tipo simple con la prop `taxonomy: true` . Se utilizan para crear categorías dentro de la instancia de Griddo.

**Schema de ejemplo**

```jsx
import { Schema } from "@griddo/core";

export const GRIDDO_CATEGORY: Schema.ContentType = {
	dataPacks: ["GRIDDO_PACK"],
	title: "Griddo category",
	local: true,
	translate: true,
	taxonomy: true,
	fromPage: false,
};
```

### ContentType que expiran

# ContentType que expiran

En un dato estructurado podemos indicar que se trata de un dato estructurado que expira, entendiendo por "expirar" que llegada determinada fecha el dato deja de estar visible. Esto es compatible con datos estructurados de cualquier tipo (puros, de página, de site y globales, en cualquier combinación) pero no con las taxonomías.

En el caso de datos puros, estamos hablando de que cuando el dato expira su estado pasa a ser draft y por tanto deja de ser visible. Cuando es un dato de página, lo que sucede es que la página pasa a estado "pending-unpublishing" y, posteriormente, a offline.

En ambos casos el efecto es exactamente el mismo que si se hubieran despublicado manualmente, incluyendo que se vuelve a generar un render de los sites afectados por una expiración.

Cuando la expiración afecta a un dato global, todos los sites son renderizados de nuevo.

Para hacer esto posible, tenemos dos propiedades OPCIONALES que podemos usar en la definición de un dato estructurado (véanse los ejemplos más adelante):

- `expirationDateField`, cuyo valor sería un campo de tipo DateField del propio dato. Si ese campo tiene un valor, ese dato expirará al llegar a la fecha indicada en él. Si en el schema del dato estructurado no existe ningún field con esa key que además sea type: DateField, la sincronización de esquemas dará un error explicando exactamente qué es lo que ha fallado.
- `expirationDateOffset`, que es opcional pero solo se puede usar si existe expirationDateField. Es un offset en días y debe ser numérico (por defecto, es 0). Indica el offset en días que debe aplicarse al valor de expirationDateField. Por ejemplo, si es un evento y queremos que el dato expire al día siguiente de finalizar el evento, pondríamos expirationDateOffset: 1. Pero si es por ejemplo algo que requiere una fecha límite de inscripción y queremos que finalice 3 días antes, el expirationDateOffset sería -3 (es decir, el dato expira 3 días antes de la fecha indicada en el campo señalado en expirationDateField).

Cuando el field indicado en expirationDateField tiene un valor vacío (valor null o undefined), ese dato no expira. Por lo tanto, si quieres que todos los datos tengan una fecha de expiración, deberás hacer que la definición del field que utilices como expirationDateField sea mandatory.

El dato expirará automáticamente entre las 0:00 y las 2:00 h. del día indicado. En cualquier caso, el proceso de verificar las expiraciones se realiza cada dos horas. Si por lo que sea se publica un dato que tiene una fecha de expiración que ya venció, el dato/página se publicará PERO en menos de dos horas se verificará que está vencido y será despublicado nuevamente. El proceso ocurre en API de manera transparente, por lo que si configuramos correctamente el dato con las dos keys indicadas, simplemente funcionará sin programación ni despliegue de recursos adicionales.

Esto tiene dos usos/enfoques posibles, que vamos a explicar con ejemplos.

**EJEMPLO 1: El propio dato ya tiene una fecha, y la fecha de expiración del dato es relativa a esta.**
Por ejemplo, en un dato de tipo EVENTO, quiero que el dato expire al día siguiente de su celebración (ojo: al día siguiente, porque si se celebra el día 3, yo quiero que se pueda ver todo el día 3 y que desaparezca en la madrugada del día 4).

```json
EVENTS: {
    title: "Events",
    dataPacks: ["EVENTS"],
    local: false,
    taxonomy: false,
    fromPage: true,
    translate: true,
    expirationDateField: "when",
    expirationDateOffset: 1,
    schema: {
      templates: ["EventDetail"],
      fields: [
        {
          key: "title",
          title: "Title",
          type: "TextField",
          from: "title",
        },
        {
          key: "when",
          title: "Event date and time",
          type: "DateField",
          from: "dateTime",
          indexable: true,
        },
        {
          key: "eventHour",
          title: "Event Hour",
          type: "TextField",
          from: "eventHour",
        },
      ],
      searchFrom: [""],
    },
    clone: null,
    defaultValues: null,
  },
}
```

**EJEMPLO 2: El editor especificará exactamente en qué fecha quiere que el dato expire.**
Por ejemplo, en un campo del tipo OFERTA, queremos indicar una fecha en la que esa oferta deje de existir. Esa fecha no es relativa a nada que ya exista el dato, simplemente es la fecha en la que queremos que deje de estar disponible. Aquí no usamos expirationDateOffset porque expirará exactamente en la fecha que nos hayan dicho.

```json
OFFERS: {
    title: "Offers",
    dataPacks: ["DISCOUNTS"],
    local: true,
    taxonomy: false,
    fromPage: false,
    translate: false,
    expirationDateField: "validUntil",
    schema: {
      fields: [
        {
          key: "title",
          title: "Title",
          type: "TextField",
        },
        {
          key: "validUntil",
          title: "This offer is valid until this date",
          type: "DateField",
        },
      ],
      searchFrom: [],
    },
    clone: null,
    defaultValues: null,
}
```

### Page

# Page

Los schemas de páginas están entre los de UI y los simples. Son schemas que guardarán un dato (como hacen los simples) pero se utilizará un schema de tipo template (UI) para introducir esos datos. Es decir, en este caso si hay un componente de React asociado, más concretamente un template de tipo detalle. (Ver templates de tipo detalle). Al igual que con los datos simples, es posible referenciar este dato en otros schemas. (ver **ReferenceField**)

```tsx
import { Schema } from "@griddo/core";

export const NEWS: Schema.ContentType = {
	dataPacks: ["GRIDDO_PACK"],
	title: "News",
	local: true,
	fromPage: true,
	translate: true,
	taxonomy: false,
	schema: {
		templates: ["NewsDetail"],
		fields: [
			{
				type: "TextField",
				title: "Abstract",
				from: "abstract",
				key: "abstract",
			},
			{
				title: "News Type",
				type: "Select",
				from: "newsType",
				key: "newsType",
				options: [
					{ label: "Design System", value: "design-system" },
					{ label: "Data Analisys", value: "data-analisys" },
					{ label: "E-Commerce", value: "e-commerce" },
				],
			},
		],
	},
};
```

### Simples

# Simples

Los schemas de datos simple definen unos formularios para introducir datos desde el editor, no tienen asociado un componente de React como parte visual. Tan solo son datos que serán creados en el sistema para su posterior consumo en otros componentes o módulos mediante referencias a ellos mediante `useReferenceFieldData` o `useList`

## Propiedades exclusivas

`exportable`

Si es `true` indica que el ContentType se podrá exportar y descargar desde el editor.

`private`

Si es `true` indica que el ContentType es privado. Estos no se mostrarán en ningún distribuidor ni en ninguna llamada de API Pública.

`includedInPageSearch`

Un booleano que si está a `true` añadirá los datos de este ContentType al buscador por Inteligencia Artificial.

No obstante, para que funcione debemos añadir también el objeto `searchMapping` dentro del `schema`. Este objeto admitirá cuatro elementos: 

- `title` (Obligatorio): Su valor será el key del field que funcione a modo de título.
- `url` (Obligatorio): Su valor será el key del field que funcione a modo de url.
- `image` (Opcional): Su valor será el key del field que funcione a modo de imagen.
- `description` (Opcional): Su value será el key del field que funcione a modo de descripción o abstract.

**Ejemplo de un ContentType simple**

```tsx
import { Schema } from "@griddo/core";

export const MEMBER: Schema.ContentType = {
	dataPacks: ["GRIDDO_PACK"],
	title: "Member",
	local: true,
	translate: true,
	clone: null,
	defaultValues: null,
	fromPage: false,
	private: false,
	exportable: true,
	****includedInPageSearch: true
	schema: {
	  searchMapping: {
			title: "title",
			description: "body",
			image: "image",
			url: "link",
		},
		fields: [
			{
				key: "title",
				title: "Title",
				type: "TextField",
				mandatory: true,
			},
			{
				key: "body",
				title: "Body text",
				type: "TextField",
				mandatory: true,
			},
			{
				key: "link",
				type: "UrlField",
				title: "link",
			},
			{
				key: "image",
				title: "Image",
				type: "ImageField",
				mandatory: true,
			},
		],
	},
};
```