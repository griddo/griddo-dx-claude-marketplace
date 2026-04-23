# Ejemplos reales de templates Griddo

Ejemplos completos extraídos de los tutoriales.

---

## 1. BasicTemplate (Static)

Template estático básico con hero, contenido y footer.

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
      title: "Template Section",
      type: "ComponentArray",
      maxItems: null,
      whiteList: [],
      key: "templateSection",
    },
  ],

  default: {
    type: "template",
    templateType: "BasicTemplate",
    templateSection: {
      component: "Section",
      name: "Template Section",
      modules: [],
      sectionPosition: 1,
    },
  },

  thumbnails: {
    "1x": "<%GRIDDO_COMPONENT_NAME%>",
    "2x": "<%GRIDDO_COMPONENT_NAME%>@2x",
  },
};
```

### Componente: `src/ui/templates/BasicTemplate/index.tsx`

```tsx
import type { BasicTemplateProps } from "@/autotypes";
import { GriddoModule } from "@ui/modules";

function BasicTemplate(props: BasicTemplateProps) {
  const { templateSection } = props;

  return (
    <section>
      {templateSection?.modules?.map((module, idx) => (
        <GriddoModule key={idx} {...module} />
      ))}
    </section>
  );
}

export default BasicTemplate;
```

---

## 2. NewsDetail (Detail Template)

Template detalle para noticias. Permite editar título, imagen y cuerpo. Include zona para módulos relacionados.

### Content Type NEWS: `src/schemas/content-types/page/NEWS.ts`

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

### Schema del template: `src/schemas/templates/NewsDetail.ts`

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

### Componente: `src/ui/templates/NewsDetail/index.tsx`

```tsx
import type { NewsDetailProps } from "@/autotypes";
import { GriddoImageExp } from "@griddo/core";

function NewsDetail(props: NewsDetailProps) {
  const { title, image, body } = props;

  return (
    <article>
      <header>
        <h1>{title}</h1>
        <GriddoImageExp image={image} />
      </header>
      <div>
        <p>{body}</p>
      </div>
    </article>
  );
}

export default NewsDetail;
```

---

## 3. NewsShowcaseWithDetail (Detail Template + Módulos)

Template detalle que permite editar datos Y agregar módulos en una sección "related".

### Schema: `src/schemas/templates/NewsDetailFull.ts`

```tsx
export const schema = {
  schemaType: "template",
  component: "NewsDetailFull",
  displayName: "News Detail Full",
  type: {
    label: "News Detail",
    value: "newsDetailFull",
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
    {
      title: "Related Content",
      type: "ComponentArray",
      maxItems: null,
      whiteList: ["NewsShowcase", "CardCollection"],
      key: "relatedSection",
    },
  ],

  default: {
    type: "template",
    templateType: "NewsDetailFull",
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
    "1x": "/thumbnails/templates/NewsDetailFull/thumbnail@1x.png",
    "2x": "/thumbnails/templates/NewsDetailFull/thumbnail@2x.png",
  },
};

export default schema;
```

### Componente: `src/ui/templates/NewsDetailFull/index.tsx`

```tsx
import type { NewsDetailFullProps } from "@/autotypes";
import { GriddoImageExp, GriddoModule } from "@griddo/core";

function NewsDetailFull(props: NewsDetailFullProps) {
  const { title, image, body, relatedSection } = props;

  return (
    <>
      <article>
        <header className="news-header">
          <h1>{title}</h1>
          {image && <GriddoImageExp image={image} />}
        </header>
        <div className="news-content">
          <p>{body}</p>
        </div>
      </article>

      <section className="related">
        <h2>Related News</h2>
        {relatedSection?.modules?.map((module, idx) => (
          <GriddoModule key={idx} {...module} />
        ))}
      </section>
    </>
  );
}

export default NewsDetailFull;
```

---

## 4. MultiPageNews (Detail Template + MultiPage Module)

Template detalle que contiene un módulo MultiPage para generar sub-páginas dentro de la noticia.

### Schema: `src/schemas/templates/NewsMultiPage.ts`

```tsx
export const schema = {
  schemaType: "template",
  component: "NewsMultiPage",
  displayName: "News Multi Page",
  type: {
    label: "News Multi Page",
    value: "newsMultiPage",
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
      title: "Content Sections (Multi-Page)",
      type: "ComponentArray",
      maxItems: 1,
      whiteList: ["NewsMultiPageModule"],
      key: "contentSections",
    },
  ],

  default: {
    type: "template",
    templateType: "NewsMultiPage",
    getStaticData: true,
    title: undefined,
    image: undefined,
    contentSections: {
      component: "Section",
      modules: [],
    },
  },

  thumbnails: {
    "1x": "/thumbnails/templates/NewsMultiPage/thumbnail@1x.png",
    "2x": "/thumbnails/templates/NewsMultiPage/thumbnail@2x.png",
  },
};

export default schema;
```

### Componente: `src/ui/templates/NewsMultiPage/index.tsx`

```tsx
import type { NewsMultiPageProps } from "@/autotypes";
import { GriddoImageExp, GriddoModule } from "@griddo/core";

function NewsMultiPage(props: NewsMultiPageProps) {
  const { title, image, contentSections } = props;

  return (
    <>
      <article>
        <header className="news-header">
          <h1>{title}</h1>
          {image && <GriddoImageExp image={image} />}
        </header>

        {contentSections?.modules?.map((module, idx) => (
          <GriddoModule key={idx} {...module} />
        ))}
      </article>
    </>
  );
}

export default NewsMultiPage;
```

**Nota:** El módulo `NewsMultiPageModule` dentro contiene `hasGriddoMultiPage: true` y genera sub-páginas automáticamente.

---

## Checklist al generar un template

- [ ] Schema incluye `schemaType: "template"`
- [ ] Propiedad `type` tiene `label`, `value`, y `mode` (static/detail/list)
- [ ] Array `content` define secciones o campos
- [ ] Si DetailTemplate: campos editables definidos en `content`
- [ ] Si ListTemplate: incluir `itemsPerPage` en schema
- [ ] Componente React importa types desde `@/autotypes`
- [ ] Usar `GriddoModule` para renderizar módulos dinámicamente
- [ ] `default` incluye valores iniciales para todas las props
- [ ] Si Detail/List: `getStaticData: true` en default
- [ ] Registro en `src/schemas/templates/index.ts`
- [ ] Ejecutar `yarn autotypes`
- [ ] Si Detail/List: ejecutar `yarn sync-schemas`
- [ ] Thumbnails en formato @1x y @2x
