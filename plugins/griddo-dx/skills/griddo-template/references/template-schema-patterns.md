# Patrones de Templates Griddo

Tres patrones completos: Static, Detail y List.

---

## 1. Static Template

**Patrón:** Template básico con zonas para módulos. Sin campos editables, solo secciones.

### Schema: `src/schemas/templates/BasicTemplate.ts`

```tsx
export default {
  schemaType: "template",
  displayName: "Basic Template",
  component: "BasicTemplate",
  dataPacks: null,
  type: {
    label: "Static",
    value: "static",
  },

  content: [
    {
      title: "Hero Section",
      type: "ComponentArray",
      maxItems: 1,
      whiteList: ["MainHero", "BasicHero"],
      key: "heroSection",
      contentType: "modules",
    },
    {
      title: "Main Content",
      type: "ComponentArray",
      maxItems: null,
      whiteList: ["CardCollection", "TextSection", "ImageGallery"],
      key: "mainSection",
      contentType: "modules",
    },
    {
      title: "Footer Section",
      type: "ComponentArray",
      maxItems: 1,
      whiteList: ["Footer"],
      key: "footerSection",
      contentType: "modules",
    },
  ],

  default: {
    type: "template",
    templateType: "BasicTemplate",
    heroSection: {
      component: "Section",
      name: "Hero Section",
      modules: [],
      sectionPosition: 1,
    },
    mainSection: {
      component: "Section",
      name: "Main Content",
      modules: [],
      sectionPosition: 2,
    },
    footerSection: {
      component: "Section",
      name: "Footer Section",
      modules: [],
      sectionPosition: 3,
    },
  },

  thumbnails: {
    "1x": "/thumbnails/templates/BasicTemplate/thumbnail@1x.png",
    "2x": "/thumbnails/templates/BasicTemplate/thumbnail@2x.png",
  },
};
```

### Componente: `src/ui/templates/BasicTemplate/index.tsx`

```tsx
import type { BasicTemplateProps } from "@/autotypes";
import { GriddoModule } from "@ui/modules";

function BasicTemplate(props: BasicTemplateProps) {
  const { heroSection, mainSection, footerSection } = props;

  return (
    <>
      <header>
        {heroSection?.modules?.map((module, idx) => (
          <GriddoModule key={idx} {...module} />
        ))}
      </header>

      <main>
        {mainSection?.modules?.map((module, idx) => (
          <GriddoModule key={idx} {...module} />
        ))}
      </main>

      <footer>
        {footerSection?.modules?.map((module, idx) => (
          <GriddoModule key={idx} {...module} />
        ))}
      </footer>
    </>
  );
}

export default BasicTemplate;
```

---

## 2. Detail Template

**Patrón:** Template que recibe datos estructurados (page data) y los edita mediante campos, además de secciones para módulos.

### Schema: `src/schemas/templates/NewsDetail.ts`

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
    // Campos del dato
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
      title: "Body Text",
      key: "body",
    },
    // Zona para módulos relacionados
    {
      title: "Related Content Section",
      type: "ComponentArray",
      maxItems: null,
      whiteList: ["CardCollection", "NewsShowcase"],
      key: "relatedSection",
      contentType: "modules",
    },
  ],

  default: {
    type: "template",
    templateType: "NewsDetail",
    getStaticData: true,
    title: undefined,
    image: undefined,
    body: undefined,
    relatedSection: {
      component: "Section",
      name: "Related Content",
      modules: [],
      sectionPosition: 1,
    },
  },

  thumbnails: {
    "1x": "/thumbnails/templates/NewsDetail/thumbnail@1x.png",
    "2x": "/thumbnails/templates/NewsDetail/thumbnail@2x.png",
  },
};

export default schema;
```

### Componente: `src/ui/templates/NewsDetail/index.tsx`

```tsx
import type { NewsDetailProps } from "@/autotypes";
import { GriddoImageExp, GriddoModule } from "@griddo/core";

function NewsDetail(props: NewsDetailProps) {
  const { title, image, body, relatedSection } = props;

  return (
    <>
      <article>
        <header className="news-header">
          <h1>{title}</h1>
          {image && <GriddoImageExp image={image} />}
        </header>

        <div className="news-body">
          <p>{body}</p>
        </div>
      </article>

      <section className="related-content">
        <h2>Related News</h2>
        {relatedSection?.modules?.map((module, idx) => (
          <GriddoModule key={idx} {...module} />
        ))}
      </section>
    </>
  );
}

export default NewsDetail;
```

**Nota:** Los campos (`title`, `image`, `body`) se editan directamente en el editor. Los módulos en `relatedSection` se agregan como en Static.

---

## 3. List Template (Paginado)

**Patrón:** Template que renderiza un listado paginable de items, con generación automática de páginas `/2`, `/3`, etc.

### Schema: `src/schemas/templates/SchoolsList.ts`

```tsx
export default {
  schemaType: "template",
  displayName: "Schools List",
  component: "SchoolsList",
  type: {
    label: "Schools",
    value: "schools",
    mode: "list",
  },

  content: [
    {
      type: "TextField",
      title: "Page Title",
      key: "pageTitle",
    },
    {
      title: "Items per Page",
      type: "NumberField",
      key: "itemsPerPage",
      default: 10,
      mandatory: true,
    },
    {
      type: "ReferenceField",
      title: "Schools to Display",
      sources: [{ structuredData: "SCHOOLS" }],
      selectionType: ["auto", "manual"],
      key: "data",
    },
  ],

  default: {
    type: "template",
    templateType: "SchoolsList",
    getStaticData: true,
    pageTitle: "Schools",
    itemsPerPage: 10,
    data: {
      sources: [{ structuredData: "SCHOOLS" }],
      mode: "auto",
    },
  },

  thumbnails: {
    "1x": "/thumbnails/templates/SchoolsList/thumbnail@1x.png",
    "2x": "/thumbnails/templates/SchoolsList/thumbnail@2x.png",
  },
};
```

### Componente: `src/ui/templates/SchoolsList/index.tsx`

```tsx
import type { SchoolsListProps } from "@/autotypes";
import { GriddoImageExp, GriddoLink, useReferenceField } from "@griddo/core";

function SchoolsList(props: SchoolsListProps) {
  const {
    pageTitle,
    data,
    queriedItems,
    pageNumber,
    totalPages,
    isFirstPage,
    baseLink,
  } = props;

  const schoolsFromEditor = useReferenceField(data);
  const schoolsFromRender = queriedItems;
  const schools = schoolsFromRender || schoolsFromEditor;

  return (
    <>
      <h1>{pageTitle}</h1>

      <div className="schools-list">
        {schools?.map((school, idx) => (
          <div key={idx} className="school-item">
            <h3>{school.content?.title}</h3>
            <GriddoImageExp image={school.content?.image} />
            <GriddoLink url={school.content?.link}>Visit</GriddoLink>
          </div>
        ))}
      </div>

      {/* Paginador */}
      <nav className="pagination">
        {!isFirstPage && (
          <GriddoLink url={baseLink}>
            Previous
          </GriddoLink>
        )}

        <span>
          Page {pageNumber} of {totalPages}
        </span>

        {pageNumber < totalPages && (
          <GriddoLink url={`${baseLink}${pageNumber + 1}`}>
            Next
          </GriddoLink>
        )}
      </nav>
    </>
  );
}

export default SchoolsList;
```

**Notas sobre paginación:**
- `pageNumber` = número actual (1 en primera página)
- `totalPages` = total calculado como `items / itemsPerPage`
- `isFirstPage` = true en página 1
- `baseLink` = base URL (incluye `/`)
- **IMPORTANTE:** La página 1 NO tiene slug de paginación. Las demás tienen `/2`, `/3`, etc.

---

## 4. Comparativa de patrones

| Aspecto | Static | Detail | List |
|---------|--------|--------|------|
| `mode` | `"static"` | `"detail"` | `"list"` |
| Campos editables | No | Sí | Sí |
| Zonas de módulos | Sí | Sí | Sí |
| Content type | Ninguno | Data tipo `page` | Data cualquiera |
| Paginación | No | No | Sí |
| Props especiales | `heroSection`, etc. | Datos + módulos | `pageNumber`, `totalPages`, `baseLink` |
| Generación de páginas | Una | Una | Múltiples (`/1`, `/2`, `/3`) |

---

## Estructura de `default` por tipo

### Static
```tsx
default: {
  type: "template",
  templateType: "BasicTemplate",
  heroSection: { component: "Section", modules: [] },
  // ...más secciones
}
```

### Detail
```tsx
default: {
  type: "template",
  templateType: "NewsDetail",
  getStaticData: true,
  title: undefined,
  image: undefined,
  body: undefined,
  relatedSection: { component: "Section", modules: [] },
}
```

### List
```tsx
default: {
  type: "template",
  templateType: "SchoolsList",
  getStaticData: true,
  pageTitle: "Schools",
  itemsPerPage: 10,
  data: {
    sources: [{ structuredData: "SCHOOLS" }],
    mode: "auto",
  },
}
```
