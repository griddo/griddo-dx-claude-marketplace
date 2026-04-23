# Ejemplos reales de módulos Griddo

Ejemplos completos extraídos directamente de los tutoriales oficiales.

---

## 1. BasicHero (hello-world-first-module)

El módulo más simple: un título y una imagen.

### Schema: `src/schemas/modules/BasicHero.ts`

```tsx
const schema = {
	schemaType: "module",
	component: "BasicHero",
	displayName: "BasicHero",
	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
				{
					type: "ImageField",
					title: "Main Image",
					key: "image",
				}
			],
		},
	],
	default: {
		component: "BasicHero",
	},
};

export default schema;
```

### Componente: `src/ui/modules/BasicHero/index.tsx`

```tsx
import type { BasicHeroProps } from "@/autotypes";
import { GriddoImageExp } from "@griddo/core";

function BasicHero(props: BasicHeroProps) {
	const { title, image } = props;

	return (
		<div>
			<h1>{title}</h1>
			<GriddoImageExp image={image} />
		</div>
	);
}

export default BasicHero;
```

### Storybook: `src/ui/modules/BasicHero/stories.tsx`

```tsx
import type { BasicHeroProps } from "@/autotypes";
import type { Meta, Story } from "@storybook/react";

import BasicHero from ".";

export default {
	title: "Modules/BasicHero",
	component: BasicHero,
} as Meta;

const Template: Story<BasicHeroProps> = (props: BasicHeroProps) => <BasicHero {...props} />;

export const Play = Template.bind({});
Play.args = {
	title: "The title",
	image: {
		url: "https://images.your-instance.griddo.io/glasses",
		size: 1409287,
		width: 5070,
		height: 3380,
		position: "center",
		alt: "Alt text of the image",
		description: "Description of the image",
		name: "Name of the image",
		orientation: "S",
		tags: ["tag1", "tag2"],
		title: "Title of the image",
	},
};
```

---

## 2. CardCollection (hello-world-collections-render)

Módulo que contiene múltiples cards renderizadas dinámicamente.

### Schema del componente Card: `src/schemas/components/Card.ts`

```tsx
const schema = {
	schemaType: "component",
	component: "Card",
	displayName: "Card",
	fields: [
		{
			type: "TextField",
			title: "Title",
			key: "title",
		},
		{
			type: "TextArea",
			title: "Description",
			key: "description",
		},
		{
			type: "ImageField",
			title: "Image",
			key: "image",
		},
	],
};

export default schema;
```

### Componente Card: `src/ui/components/Card/index.tsx`

```tsx
import type { CardProps } from "@/autotypes";

function Card(props: CardProps) {
	const { title, description, image } = props;

	return (
		<div className="card">
			<img src={image?.url} alt={image?.alt} />
			<h4>{title}</h4>
			<p>{description}</p>
		</div>
	);
}

export default Card;
```

### Schema del módulo CardCollection: `src/schemas/modules/CardCollection.ts`

```tsx
const schema = {
	schemaType: "module",
	component: "CardCollection",
	displayName: "Card Collection",
	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
				{
					type: "ComponentArray",
					title: "Cards",
					whiteList: ["Card"],
					key: "cards",
				},
			],
		},
	],
	default: {
		component: "CardCollection",
		cards: [],
	},
};

export default schema;
```

### Componente CardCollection: `src/ui/modules/CardCollection/index.tsx`

```tsx
import type { CardCollectionProps } from "@/autotypes";
import Card from "@ui/components/Card";

function CardCollection(props: CardCollectionProps) {
	const { title, cards } = props;

	return (
		<section>
			<h2>{title}</h2>
			<div className="cards-grid">
				{cards?.map((card, idx) => (
					<Card key={idx} {...card} />
				))}
			</div>
		</section>
	);
}

export default CardCollection;
```

---

## 3. SchoolShowcase (hello-world-simple-data)

Módulo que consume datos de un content type simple (SCHOOLS) mediante ReferenceField.

### Content Type SCHOOLS: `src/schemas/content-type/simple/SCHOOLS.ts`

```tsx
export const SCHOOLS = {
	title: "Schools",
	local: true,
	translate: true,
	clone: null,
	defaultValues: null,
	fromPage: false,
	schema: {
		fields: [
			{
				key: "title",
				title: "Title",
				type: "TextField",
			},
			{
				key: "image",
				title: "Image",
				type: "ImageField",
			},
			{
				key: "link",
				type: "UrlField",
				title: "Link",
			},
		],
	},
};
```

### Schema del módulo: `src/schemas/modules/SchoolShowcase.ts`

```tsx
const schema = {
	schemaType: "module",
	component: "SchoolShowcase",
	displayName: "SchoolShowcase",

	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
				{
					type: "ReferenceField",
					title: "Schools",
					sources: [{ structuredData: "SCHOOLS" }],
					selectionType: ["auto", "manual"],
					key: "data",
				},
			],
		},
	],

	default: {
		component: "SchoolShowcase",
		getStaticData: true,
		data: {
			sources: [{ structuredData: "SCHOOLS" }],
			mode: "auto",
		},
	},
};

export default schema;
```

### Componente: `src/ui/modules/SchoolShowcase/index.tsx`

```tsx
import type { SchoolShowcaseProps } from "@/autotypes";
import { GriddoImageExp, GriddoLink, useReferenceField } from "@griddo/core";

function SchoolShowcase(props: SchoolShowcaseProps) {
	const { title, data, queriedItems } = props;

	const schoolsFromEditor = useReferenceField(data);
	const schoolsFromRender = queriedItems;
	const schools = schoolsFromRender || schoolsFromEditor;

	return (
		<section>
			<h2>{title}</h2>
			{schools?.map((school, idx) => (
				<div key={idx}>
					<h3>{school.content?.title}</h3>
					<GriddoImageExp image={school.content?.image} />
					<GriddoLink url={school.content?.link}>Visit school</GriddoLink>
				</div>
			))}
		</section>
	);
}

export default SchoolShowcase;
```

---

## 4. NewsShowcase (hello-world-page-data)

Módulo que consume datos de página (NEWS) mediante ReferenceField y accede a `item.url` para links de detalle.

### Detail Template para NEWS: `src/schemas/templates/NewsDetail.ts`

```tsx
export const schema = {
	schemaType: "template",
	component: "NewsDetail",
	displayName: "News Detail",
	type: {
		label: "News Detail",
		value: "newsTemplate",
		mode: "detail",
	},

	content: [
		{
			type: "TextField",
			title: "Title",
			key: "title",
		},
		{
			type: "ImageField",
			title: "Image",
			key: "image",
		},
		{
			type: "TextArea",
			title: "Body Text",
			key: "body",
		},		
	],

	default: {
		type: "template",
		templateType: "DetailTemplate",
		title: undefined,
		image: undefined,
		body: undefined,
	}
};

export default schema;
```

### Schema del módulo: `src/schemas/modules/NewsShowcase.ts`

```tsx
const schema = {
	schemaType: "module",
	component: "NewsShowcase",
	displayName: "NewsShowcase",

	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "TextField",
					title: "Title",
					key: "title",
				},
				{
					type: "ReferenceField",
					title: "News Items",
					sources: [{ structuredData: "NEWS" }],
					selectionType: ["auto", "manual"],
					key: "data",
				},
			],
		},
	],

	default: {
		component: "NewsShowcase",
		getStaticData: true,
		data: {
			sources: [{ structuredData: "NEWS" }],
			mode: "auto",
		},
	},
};

export default schema;
```

### Componente: `src/ui/modules/NewsShowcase/index.tsx`

```tsx
import type { NewsShowcaseProps } from "@/autotypes";
import { GriddoImageExp, GriddoLink, useReferenceField } from "@griddo/core";

function NewsShowcase(props: NewsShowcaseProps) {
	const { title, data, queriedItems } = props;

	const newsFromEditor = useReferenceField(data);
	const newsFromRender = queriedItems;
	const news = newsFromRender || newsFromEditor;

	return (
		<section>
			<h2>{title}</h2>
			{news?.map((item, idx) => (
				<article key={idx}>
					<h3>{item.content?.title}</h3>
					<GriddoImageExp image={item.content?.image} />
					<p>{item.content?.body}</p>
					<GriddoLink url={item.url}>Read more</GriddoLink>
				</article>
			))}
		</section>
	);
}

export default NewsShowcase;
```

**Diferencia importante:** Datos de página incluyen `item.url` que apunta a la página detalle del dato.

---

## Checklist al generar un módulo

- [ ] Schema incluye `schemaType: "module"`
- [ ] Componente React importado desde `@/autotypes`
- [ ] Props del componente tipadas completamente
- [ ] Schema incluye `default` con valores de ejemplo
- [ ] Componentes Griddo usados: `GriddoImageExp`, `GriddoLink`, etc.
- [ ] Si ReferenceField, incluir `getStaticData: true` en default
- [ ] Si ReferenceField, usar `useReferenceField()` en el componente
- [ ] Registro en `src/ui/modules/index.tsx` y `src/schemas/modules/index.ts`
- [ ] Ejecutar `yarn autotypes` después de crear
- [ ] Si necesita estar en template, agregar al `whiteList` de sección
