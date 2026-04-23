# Categorías

## Ejemplo

```tsx
import { Schema } from "@griddo/core";

// categorías para formularios
const formCategories: Schema.FormCategories = [
	{ label: "Form category 1", value: "formCat1", featured: true },
	{ label: "Form category 2", value: "formCat2" },
	{ label: "Form category 3", value: "formCat3" },
];

// categorías para templates
const formtemplateCategories: Schema.FormTemplateCategories = [
	{ label: "Form template category 1", value: "formTemplateCat1" },
	{ label: "Form template category 2", value: "formTemplateCat2" },
];

export { formCategories, formtemplateCategories };
```

# Componentes

Schemas para los componentes de formularios que estarán disponibles en un `FormFieldArray` y que servirán para la creación de un formulario desde un template. El schema es similar a un módulo y podemos añadir los fields que queramos sin limitación. La única diferencia con el schema de un módulo es el `schemaType`

## Ejemplo

```tsx
import { EmailFieldProps } from "@autoTypes";
import { Schema } from "@griddo/core";

const schema: Schema.FormField<EmailFieldProps> = {
	schemaType: "formComponent", // Nuevo schemaType
	component: "EmailField",
	displayName: "EmailField",

	configTabs: [
		{
			title: "Content",
			fields: [
				{
					title: "Label",
					key: "label",
					type: "TextField",
				},
				{
					title: "Placeholder",
					key: "placeholder",
					type: "TextField",
				},
				{
					title: "Show Icon?",
					key: "hasIcon",
					type: "ToggleField",
				},
			],
		},
	],

	default: {
		component: "EmailField",
		label: "",
		placeholder: "",
		hasIcon: false,
	},
};

export default schema;
```

# Templates

Schemas para los templates de los formularios que aparecerán en la creación de un formulario. 

El schema se parece a un template normal de Griddo: **BasicTemplate**, etc.

En el se indican en `content` y `config` los fields que queramos. 

La diferencia con un template es que aquí vamos a querer añadir un [FormFieldArray](../../Fields/FormFieldArray%201aee2540c9e280a49f6fee1ba0e4fe89.md) que será desde donde se podrán añadir los “fields” `(formComponents)` de los formularios indicados en un `whiteList`

Si en el `default` del `FormFieldArray` se añaden componentes por defecto, se les puede añadir la propiedad `fixed: true` para que sean obligatorios y no se puedan eliminar en el editor de formularios.

También se puede añadir un [FormCategorySelect](../../Fields/FormCategorySelect%2019ee2540c9e280ffa505f4133ae80a28.md)  para poder asignar las `formCategories` definidas en [Categorías](Categor%C3%ADas%20176e2540c9e280af8a6cc918b2c3c5b9.md)  a los formularios creados con este template.

De forma opcional los templates también pueden tener una `formTemplateCategory` asignada con la prop `category`. Al igual que las `formCategories`, estas también se definen en [Categorías](Categor%C3%ADas%20176e2540c9e280af8a6cc918b2c3c5b9.md).

Si, dentro de `content` o `config`, un field contiene la propiedad `overwrite: true`, cuando se añada el formulario a una página, el contenido de este field se podrá **sobreescribir** desde la propia página.

<aside>
💡

Thumbnails
Los thumbnails para el modal de selección de formularios en el [FormContainer](../../Fields/FormContainer%201aee2540c9e2801f949ef33dda0b88e7.md) se generan automáticamente seleccionando el HTML (React) del template del formulario.
También se puede indicar a Griddo de manera más explícita mediante un id `griddoFormThumb` el elemento HTML sobre el que hacer la captura.

</aside>

## Ejemplo

```tsx
import { ApplyFormProps } from "@/autotypes";
import { Schema } from "@griddo/core";

const schema: Schema.FormTemplate<ApplyFormProps> = {
	****schemaType: "formTemplate", // Nuevo schemaType
	displayName: "Apply Form",
	component: "ApplyForm",
	category: "formTemplateCat1" // categoría de template (opcional)

	content: [
		{
			type: "ImageField",
			title: "Image",
			key: "image",
			overwrite: true,
		},
		{
			type: "TextField",
			title: "Random text",
			key: "randomText",
			overwrite: true,
		},
		{
			type: "FormFieldArray",  // Nuevo field
			title: "Form fields",
			key: "formFields",
			whiteList: ["EmailField", "InputTextField"], // FormComponents
		},
		{
			type: "FormCategorySelect", // Nuevo field
			title: "Select Categories",
			key: "formCategories",
			filled: true,
		},
	],

	config: [],

	default: {
		type: "formTemplate",
		templateType: "ApplyForm",
		formFields: [
			{ component: "InputField", fixed: true } // componente obligatorio
			{ component: "EmailField" }
		],
	},

	thumbnails: {
		"1x": "/thumbnails/forms/apply-form.png",
		"2x": "/thumbnails/forms/apply-form.png",
	},
};

export default schema;
```