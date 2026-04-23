# Ejemplos reales de content types Griddo

Ejemplos completos extraídos de los tutoriales.

---

## 1. SCHOOLS (Simple)

Content type simple para escuelas. Datos puros sin página detalle.

### Schema: `src/schemas/content-types/simple/SCHOOLS.ts`

```tsx
import { Schema } from "@griddo/core";

export const SCHOOLS: Schema.ContentType = {
	dataPacks: ["GRIDDO_PACK"],
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

### Registro: `src/schemas/content-types/simple/index.ts`

```tsx
import { SCHOOLS } from "./SCHOOLS";

export default {
	...,
	SCHOOLS,
};
```

### Cómo se usa en módulos
En un módulo como `SchoolShowcase`:
```tsx
const schema = {
	schemaType: "module",
	component: "SchoolShowcase",
	configTabs: [
		{
			title: "content",
			fields: [
				{
					type: "ReferenceField",
					title: "Schools",
					sources: [{ structuredData: "SCHOOLS" }],
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
```

**Acceso en el componente:**
```tsx
{schools?.map((school, idx) => (
	<div key={idx}>
		<h3>{school.content?.title}</h3>
		<GriddoImageExp image={school.content?.image} />
		<GriddoLink url={school.content?.link}>Visit</GriddoLink>
	</div>
))}
```

---

## 2. NEWS (Page)

Content type de página para noticias. Genera página detalle automáticamente.

### Schema: `src/schemas/content-types/page/NEWS.ts`

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
					{ label: "Data Analysis", value: "data-analysis" },
					{ label: "E-Commerce", value: "e-commerce" },
				],
			},
		],
	},
};
```

### Registro: `src/schemas/content-types/page/index.ts`

```tsx
import { NEWS } from "./NEWS";

export default {
	...,
	NEWS,
};
```

### DetailTemplate asociado
Requiere crear `src/schemas/templates/NewsDetail.ts` (ver skill griddo-template).

### Cómo se usa en módulos
El content type NEWS se usa en módulos con acceso a `item.url`:
```tsx
{news?.map((item, idx) => (
	<article key={idx}>
		<h3>{item.content?.title}</h3>
		<GriddoImageExp image={item.content?.image} />
		<GriddoLink url={item.url}>Read more</GriddoLink>
	</article>
))}
```

**Diferencia con Simple:** Tiene propiedad `item.url` que apunta a la página detalle.

---

## 3. MEMBER (Simple con búsqueda)

Content type simple con opciones avanzadas: búsqueda IA, exportable.

### Schema: `src/schemas/content-types/simple/MEMBER.ts`

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
	includedInPageSearch: true,
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
				title: "Link",
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

### Propiedades especiales explicadas

**`private: false`**
- `false` — visible en distribuidores y API pública
- `true` — no aparece en distribuidores, solo acceso directo

**`exportable: true`**
- Permite descargar los datos como CSV desde el editor

**`includedInPageSearch: true`**
- Incluir en búsqueda potenciada con IA
- Requiere `searchMapping` que mapea campos

---

## 4. REGION (Taxonomía)

Content type de categoría para clasificar otros datos.

### Schema: `src/schemas/content-types/simple/REGION.ts`

```tsx
import { Schema } from "@griddo/core";

export const REGION: Schema.ContentType = {
	dataPacks: ["GRIDDO_PACK"],
	title: "Region",
	local: true,
	translate: true,
	taxonomy: true,
	fromPage: false,
};
```

### Uso
Las taxonomías sirven para filtrar otros datos:
```tsx
// En un ReferenceField
{
	type: "ReferenceField",
	title: "Members in region",
	sources: [{ structuredData: "MEMBER" }],
	// Se pueden filtrar por REGION
}
```

---

## 5. EVENT (Page con expiración)

Content type de página con expiración automática en una fecha.

### Schema: `src/schemas/content-types/page/EVENT.ts`

```tsx
import { Schema } from "@griddo/core";

export const EVENT: Schema.ContentType = {
	dataPacks: ["EVENTS"],
	title: "Event",
	local: false,
	fromPage: true,
	translate: true,
	expirationDateField: "eventDate",
	expirationDateOffset: 1,  // Expira al día siguiente del evento
	schema: {
		templates: ["EventDetail"],
		fields: [
			{
				key: "title",
				title: "Title",
				type: "TextField",
				mandatory: true,
			},
			{
				key: "eventDate",
				title: "Event Date",
				type: "DateField",
				from: "dateTime",
				mandatory: true,
			},
			{
				key: "description",
				title: "Description",
				type: "TextArea",
			},
			{
				key: "image",
				title: "Image",
				type: "ImageField",
			},
		],
	},
};
```

### Comportamiento de expiración
- `expirationDateField: "eventDate"` — campo que contiene la fecha
- `expirationDateOffset: 1` — expira 1 día DESPUÉS de la fecha
- Si el evento es el 2026-04-15, expira en la madrugada del 2026-04-16
- Se verifica automáticamente cada 2 horas en API
- El dato pasa a draft y desaparece de la web

---

## Comparativa de tipos

| Aspecto | Simple | Page | Taxonomía |
|---------|--------|------|-----------|
| `fromPage` | `false` | `true` | `false` |
| `taxonomy` | `false` | `false` | `true` |
| Página detalle | No | Sí | No |
| `item.url` | No | Sí | No |
| Edición | Formulario | DetailTemplate | Formulario |
| Filtros | Solo campos | Campos + template | Solo clasificación |

---

## Propiedades por tipo de content type

### Simple básico
```tsx
{
  dataPacks: ["PACK"],
  title: "Display Name",
  local: true,
  translate: true,
  clone: null,
  defaultValues: null,
  fromPage: false,
  schema: { fields: [...] }
}
```

### Page
```tsx
{
  dataPacks: ["PACK"],
  title: "Display Name",
  local: true,
  translate: true,
  fromPage: true,          // true = page
  schema: {
    templates: ["TemplateName"],  // DetailTemplate
    fields: [...]
  }
}
```

### Taxonomía
```tsx
{
  dataPacks: ["PACK"],
  title: "Category Name",
  local: true,
  translate: true,
  taxonomy: true,          // true = categoría
  fromPage: false
}
```

### Simple avanzado
```tsx
{
  dataPacks: ["PACK"],
  title: "Display Name",
  local: true,
  translate: true,
  fromPage: false,
  private: false,
  exportable: true,
  includedInPageSearch: true,
  schema: {
    searchMapping: {
      title: "title",
      description: "body",
      image: "image",
      url: "link"
    },
    fields: [...]
  }
}
```

---

## Checklist al generar un content type

- [ ] Nombre en MAYÚSCULAS (SCHOOLS, NEWS, PRODUCTS)
- [ ] `dataPacks` especificado (el pack al que pertenece)
- [ ] Decidido: ¿Simple, Page o Taxonomía?
- [ ] Si Page: `fromPage: true`
- [ ] Si Taxonomía: `taxonomy: true`
- [ ] Si buscar con IA: `includedInPageSearch: true` + `searchMapping`
- [ ] Campos definidos con tipos correctos
- [ ] `mandatory: true` en campos obligatorios
- [ ] Si Page: crear DetailTemplate asociado
- [ ] Registro en archivo correspondiente (`simple/`, `page/`, etc.)
- [ ] Ejecutar `yarn sync-schemas`
