# Propiedades dinámicas en los schemas: computed prop

La versión de **Griddo `10.3.19`** permite a algunos fields establecer su valor automáticamente mediante una función utilizando la prop `computed` que se evaluará automáticamente en cada refresco, render, etc.

A tener en cuenta:

- Solo se pueden utilizar en fields de **templates** y **datos simples**, no en **módulos** o **componentes**.
- El callback recibe como primer argumento la página si está en un template o el dato si está en un dato simple y como segundo argumento un `computedOptions` con la siguiente estructura:

```tsx
{
	operation: "save" | "refresh";
	apiUrl: string;
	publicApiUrl: string;
}
```

- El callback de `computed` deberá devolver algo del mismo type que e field. Si `computed` es de un **TextField** deberá devolver un string, si es de un **NumberField**, un número, etc.
- En **Templates** el callback de `computed` ****recibe el objeto página. Hay type-checking y auto-completado por defecto.
- En **datos simples** el callback de ****`computed` ****recibe el contenido del dato. Si se quiere auto-completado habrá que pasarle el Type del dato como genérico en el propio schema (ver ejemplo más abajo)

## Computed en datos simples

Veámoslo con un (silly) ejemplo en un **TextField** en un Dato Simple

Con este código estaremos estableciendo el valor del **TextField** con el título del dato pasándolo a mayúsculas.

```tsx
export const SIMPLE_DATA: Schema.SimpleContentType<SIMPLE_DATAContentTypeProps> = {
...
schema: {
	fields: [	
		{
			type: "TextField",
			key: "computedField",
			title: "Computed Field",
			// Como es un TextField, computed siempre debe devolver un string
			computed: (simpleData, options) => simpleData.title?.toUpperCase()
		}
	]
}
...
}
```

## Computed en templates

En este ejemplo establecemos el valor del **NumberField** con un número que es el número de caracteres del título del dato.

```tsx
const schema: Schema.Template<BasicTemplateProps> = {
	...
	content: [
		{
			type: "NumberField",
			key: "computedField",
			title: "Computed Field",
			// Como es un NumberField, computed siempre debe devolver un número
			computed: (page, options) => page.title.length
		},
	],
	...
};

export default schema;

```