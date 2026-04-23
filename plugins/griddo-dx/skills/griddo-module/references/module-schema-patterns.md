# Patrones de Módulos Griddo

Estos son 5 patrones completos y reales, basados en la documentación oficial. Cada patrón incluye schema + componente React.

---

## 1. Módulo básico (Hero)

**Patrón:** Un solo tab "content" con campos simples (TextField + ImageField).

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

---

## 2. Módulo con collection (Cards)

**Patrón:** ComponentArray que contiene múltiples componentes Card reutilizables.

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

### Schema del módulo Collection: `src/schemas/modules/CardCollection.ts`

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

### Componente Collection: `src/ui/modules/CardCollection/index.tsx`

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

## 3. Módulo con datos estructurados (ReferenceField)

**Patrón:** Consume datos de un content type (SCHOOLS, NEWS) mediante ReferenceField y hook useReferenceField.

### Schema: `src/schemas/modules/SchoolShowcase.ts`

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

**Nota sobre el flujo de datos:**
- `data` = configuración guardada en editor (ReferenceField)
- `useReferenceField(data)` = ejecuta la consulta en el editor
- `queriedItems` = datos inyectados durante render, ya resueltos
- Siempre acceder a datos vía `school.content?.field`

---

## 4. Módulo con múltiples tabs

**Patrón:** Dividir edición en tabs: "content" + "config" + "style".

### Schema: `src/schemas/modules/AdvancedHero.ts`

```tsx
const schema = {
	schemaType: "module",
	component: "AdvancedHero",
	displayName: "Advanced Hero",
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
				},
				{
					type: "TextArea",
					title: "Description",
					key: "description",
				},
			],
		},
		{
			title: "config",
			fields: [
				{
					type: "TextField",
					title: "Button Text",
					key: "buttonText",
				},
				{
					type: "UrlField",
					title: "Button Link",
					key: "buttonUrl",
				},
			],
		},
		{
			title: "style",
			fields: [
				{
					type: "RadioGroup",
					title: "Layout",
					key: "layout",
					options: [
						{ name: "left", title: "Image Left", value: "left" },
						{ name: "right", title: "Image Right", value: "right" },
					],
				},
				{
					type: "Select",
					title: "Background Color",
					key: "bgColor",
					options: [
						{ label: "White", value: "white" },
						{ label: "Light Gray", value: "light-gray" },
						{ label: "Dark", value: "dark" },
					],
				},
			],
		},
	],
	default: {
		component: "AdvancedHero",
		title: "",
		image: null,
		description: "",
		buttonText: "Learn more",
		buttonUrl: "",
		layout: "left",
		bgColor: "white",
	},
};

export default schema;
```

### Componente: `src/ui/modules/AdvancedHero/index.tsx`

```tsx
import type { AdvancedHeroProps } from "@/autotypes";
import { GriddoImageExp, GriddoLink } from "@griddo/core";

function AdvancedHero(props: AdvancedHeroProps) {
	const { title, image, description, buttonText, buttonUrl, layout, bgColor } = props;

	const isImageLeft = layout === "left";

	return (
		<section style={{ backgroundColor: bgColor }} className={`hero-${layout}`}>
			<div className={`hero-container ${isImageLeft ? "image-left" : "image-right"}`}>
				{image && <GriddoImageExp image={image} />}
				<div className="hero-content">
					<h1>{title}</h1>
					<p>{description}</p>
					{buttonUrl && (
						<GriddoLink url={buttonUrl} className="btn">
							{buttonText}
						</GriddoLink>
					)}
				</div>
			</div>
		</section>
	);
}

export default AdvancedHero;
```

**Nota:** Aunque los tabs organizan la edición en el editor, todas las props llegan juntas al componente React.

---

## 5. Módulo con datos de API (useList)

**Patrón:** Carga datos dinámicamente desde una API usando hooks Griddo.

### Schema: `src/schemas/modules/DynamicList.ts`

```tsx
const schema = {
	schemaType: "module",
	component: "DynamicList",
	displayName: "Dynamic List",
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
					type: "TextField",
					title: "Data Source",
					key: "source",
					helptext: "Content type to fetch (e.g., SCHOOLS, NEWS)",
				},
				{
					type: "NumberField",
					title: "Items to Display",
					key: "limit",
					default: 5,
				},
			],
		},
	],
	default: {
		component: "DynamicList",
		title: "Items",
		source: "SCHOOLS",
		limit: 5,
	},
};

export default schema;
```

### Componente: `src/ui/modules/DynamicList/index.tsx`

```tsx
import type { DynamicListProps } from "@/autotypes";
import { useList } from "@griddo/core";

function DynamicList(props: DynamicListProps) {
	const { title, source, limit } = props;

	const { items, isLoading, error } = useList({
		contentType: source,
		quantity: limit,
	});

	if (isLoading) return <div>Loading...</div>;
	if (error) return <div>Error loading items</div>;

	return (
		<section>
			<h2>{title}</h2>
			<ul>
				{items?.map((item, idx) => (
					<li key={idx}>
						<h3>{item.content?.title}</h3>
						<p>{item.content?.description}</p>
					</li>
				))}
			</ul>
		</section>
	);
}

export default DynamicList;
```

**Nota:** `useList` es un hook Griddo que ejecuta llamadas API dinámicamente. Solo disponible en contexto de cliente.

---

## Tabla comparativa de patrones

| Patrón | Schema Type | Campos | Componentes | Hook |
|--------|-------------|--------|-------------|------|
| Básico | `module` | TextField, ImageField | ReactComponents | Ninguno |
| Collection | `module` + `component` | ComponentArray | Múltiples | Ninguno |
| ReferenceField | `module` | ReferenceField | Datos externos | `useReferenceField` |
| Multi-tabs | `module` | Varios tabs | ReactComponent | Ninguno |
| Con API | `module` | Campos simples | ReactComponent | `useList` |
