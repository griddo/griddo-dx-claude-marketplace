---
name: griddo-hooks
description: >
  Usar esta skill cuando el developer pregunte sobre hooks de Griddo, "useGriddoImage",
  "usePage", "useSite", "useList", "cómo cargo datos", "hook para imágenes",
  "hook para navegación", o necesite consultar la referencia de React hooks de @griddo/core.
---

# Referencia de Hooks de Griddo

Esta skill te ayuda a encontrar y usar los React hooks disponibles en Griddo DX. Los hooks son funciones reutilizables para acceder a datos del sitio, procesar imágenes, cargar listas paginadas, internacionalización y más.

## Uso de esta Skill

Cuando un developer:
- Pregunta cómo cargar datos de una lista o ContentType
- Necesita procesar imágenes con srcSet y múltiples formatos
- Busca el hook para acceso al usuario/sesión
- Quiere traducir contenido o formatear fechas
- Pregunta sobre SSR, renderización, o contexto del sitio

**Debes:**
1. Consultar el Quick Reference a continuación para recomendación inmediata
2. Para documentación exhaustiva, ejemplos avanzados y parámetros detallados, refiere a `references/hooks-catalog.md`
3. Proporciona el código de importación exacto desde `@griddo/core`

## Quick Reference - Hooks Más Importantes

| Hook | Categoría | Propósito | Cuándo Usar |
|---|---|---|---|
| **useGriddoImage** | Media | Procesa imágenes con srcSet y formatos | Cualquier `<img>` o `<picture>` |
| **useGriddoImageExp** | Media | Versión mejorada de useGriddoImage | Mejor control y formatos modernos |
| **usePage** | Contexto | Datos de la página actual | En templates de páginas |
| **useSite** | Contexto | Datos globales del sitio | Navegación, header, footer |
| **useList** | Datos | Cargar ContentTypes paginados | Listados, búsqueda, filtros |
| **useI18n** | i18n | Traducciones estáticas | Textos multiidioma |
| **useLocaleDate** | i18n | Formatea fechas por idioma | Mostrar fechas localizadas |
| **useSession** | Sesión | Estado global y sesión usuario | Datos de usuario, preferencias |
| **useContentType** | Datos | Array de items de un ContentType | Cargar estructura de datos |
| **useFetch** | API | Fetch genérico a endpoints | APIs públicas externas |
| **useFormValues** | Formularios | Captura valores de formularios | Procesamiento de formularios |
| **useReferenceField** | Datos | Datos de ReferenceField | Resolver referencias de datos |
| **usePageRelatedContent** | IA | Contenido relacionado con IA | Artículos/productos similares |
| **useSSR** | Meta | Detecta si es SSR o cliente | Renderización condicional |
| **useIsClient** | Meta | ¿Estamos en cliente? | Evitar errores de hidratación |

## Hooks por Categoría

### Procesamiento de Imágenes

#### useGriddoImage
Genera URLs procesadas de imágenes con srcSet, sizes, y múltiples formatos.

```typescript
import { useGriddoImage } from '@griddo/core';

const MyComponent = ({ image }) => {
  const { url, srcSet, sizes } = useGriddoImage(image);
  
  return (
    <img 
      src={url}
      srcSet={srcSet}
      sizes={sizes}
      alt="Descripción"
    />
  );
};
```

**Características:**
- srcSet automático para responsive
- WebP y formatos modernos
- Compresión y calidad configurable
- Crop y resizing automático
- Loading lazy por defecto

#### useGriddoImageExp
Versión mejorada con más opciones.

```typescript
import { useGriddoImageExp } from '@griddo/core';

const MyComponent = ({ image }) => {
  const images = useGriddoImageExp(image, {
    sizes: ['100vw', '(min-width: 768px) 50vw'],
    formats: ['webp', 'jpg'],
    quality: 80,
    crop: 'cover'
  });
  
  return <picture>
    {images.webp && <source srcSet={images.webp.srcSet} type="image/webp" />}
    <img src={images.jpg.url} alt="..." />
  </picture>;
};
```

### Contexto del Sitio

#### usePage
Accede a todos los datos de la página actual.

```typescript
import { usePage } from '@griddo/core';

const MyComponent = () => {
  const page = usePage();
  
  return (
    <div>
      <h1>{page.title}</h1>
      <p>{page.description}</p>
      {/* page.metadata, page.content, etc. */}
    </div>
  );
};
```

**Retorna:**
- `title` - Título de la página
- `description` - Meta description
- `content` - Campos de contenido
- `metadata` - Metadatos personalizados
- `slug` - URL amigable
- `locale` - Idioma actual

#### useSite
Accede a datos globales del sitio.

```typescript
import { useSite } from '@griddo/core';

const Header = () => {
  const site = useSite();
  
  return (
    <header>
      <logo>{site.name}</logo>
      <nav>{site.navigation}</nav>
    </header>
  );
};
```

**Retorna:**
- `name` - Nombre del sitio
- `description` - Descripción global
- `logo` - Logo del sitio
- `navigation` - Navegación global
- `socialLinks` - Enlaces sociales

### Carga de Datos

#### useList
Carga ContentTypes con paginación y filtros.

```typescript
import { useList } from '@griddo/core';

const ArticlesList = () => {
  const {
    data,        // Array de items
    isLoading,   // ¿Cargando?
    error,       // ¿Error?
    page,        // Página actual
    totalPages,  // Total de páginas
    next,        // Siguiente página
    prev         // Página anterior
  } = useList({
    contentTypes: ['articulos'],
    page: 1,
    limit: 10,
    filters: {
      category: 'tech',
      published: true
    }
  });
  
  return (
    <div>
      {data.map(item => <ArticleCard key={item.id} item={item} />)}
      <Pagination current={page} total={totalPages} />
    </div>
  );
};
```

#### useContentType
Carga estructura de un ContentType en editor.

```typescript
import { useContentType } from '@griddo/core';

const ContentTypeViewer = ({ contentTypeName }) => {
  const items = useContentType(contentTypeName);
  
  return <pre>{JSON.stringify(items, null, 2)}</pre>;
};
```

#### useReferenceField
Resuelve datos de un ReferenceField.

```typescript
import { useReferenceField } from '@griddo/core';

const ArticleWithAuthor = ({ article }) => {
  const author = useReferenceField(article.authorRef);
  
  return (
    <article>
      <h2>{article.title}</h2>
      <p>Por: {author?.name}</p>
    </article>
  );
};
```

### Internacionalización

#### useI18n
Accede a traducciones estáticas.

```typescript
import { useI18n } from '@griddo/core';

const Button = () => {
  const i18n = useI18n();
  
  return <button>{i18n.t('common.submit')}</button>;
};
```

#### useLocaleDate
Formatea fechas según idioma.

```typescript
import { useLocaleDate } from '@griddo/core';

const EventDate = ({ date }) => {
  const formatDate = useLocaleDate();
  
  return (
    <time>{formatDate(date, { 
      year: 'numeric', 
      month: 'long' 
    })}</time>
  );
};
```

### Sesión y Usuario

#### useSession
Accede y modifica estado global de sesión.

```typescript
import { useSession } from '@griddo/core';

const UserProfile = () => {
  const { session, setSession } = useSession();
  
  return (
    <div>
      <p>Usuario: {session?.user?.name}</p>
      <button onClick={() => setSession({ theme: 'dark' })}>
        Cambiar tema
      </button>
    </div>
  );
};
```

### Formularios

#### useFormValues
Captura valores de formularios.

```typescript
import { useFormValues } from '@griddo/core';

const ContactForm = () => {
  const formRef = useRef();
  const values = useFormValues(formRef);
  
  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Enviando:', values);
  };
  
  return (
    <form ref={formRef} onSubmit={handleSubmit}>
      <input name="email" type="email" required />
      <input name="message" type="text" required />
      <button type="submit">Enviar</button>
    </form>
  );
};
```

### APIs Externas

#### useFetch
Fetch genérico para endpoints públicos.

```typescript
import { useFetch } from '@griddo/core';

const ExternalData = () => {
  const { data, isLoading, error } = useFetch(
    'https://api.ejemplo.com/data'
  );
  
  if (isLoading) return <p>Cargando...</p>;
  if (error) return <p>Error: {error.message}</p>;
  
  return <pre>{JSON.stringify(data, null, 2)}</pre>;
};
```

### IA y Búsqueda

#### usePageRelatedContent
Busca contenido relacionado usando IA.

```typescript
import { usePageRelatedContent } from '@griddo/core';

const RelatedArticles = ({ currentArticle }) => {
  const related = usePageRelatedContent(currentArticle.id, {
    limit: 3,
    contentTypes: ['articulos']
  });
  
  return (
    <section>
      <h3>Artículos Relacionados</h3>
      {related.map(item => <ArticleCard key={item.id} item={item} />)}
    </section>
  );
};
```

#### useAISearch
Búsqueda con IA sobre contenidos.

```typescript
import { useAISearch } from '@griddo/core';

const SearchResults = ({ query }) => {
  const { results, isLoading } = useAISearch(query, {
    limit: 10
  });
  
  return (
    <div>
      {results.map(result => (
        <SearchResult key={result.id} result={result} />
      ))}
    </div>
  );
};
```

### Control de Renderización

#### useSSR
Detecta si estamos en SSR o cliente.

```typescript
import { useSSR } from '@griddo/core';

const CounterComponent = () => {
  const isSSR = useSSR();
  
  // Solo en cliente: usar localStorage
  if (!isSSR) {
    const [count, setCount] = useState(0);
    return <div>{count}</div>;
  }
  
  return null;
};
```

#### useIsClient
Más simple que useSSR para esperar al cliente.

```typescript
import { useIsClient } from '@griddo/core';

const ClientOnly = () => {
  const isClient = useIsClient();
  
  if (!isClient) return null;
  
  return <Component />;
};
```

## Patrones Comunes

### Cargar Datos y Mostrar Listado
```typescript
const { data, isLoading, error } = useList({
  contentTypes: ['productos'],
  page: currentPage,
  limit: 20,
  filters: { category: selectedCategory }
});

if (isLoading) return <Skeleton />;
if (error) return <ErrorMessage error={error} />;

return data.map(item => <ProductCard key={item.id} item={item} />);
```

### Procesar Imágenes Responsive
```typescript
const { url, srcSet, sizes } = useGriddoImage(pageImage);

return (
  <img 
    src={url}
    srcSet={srcSet}
    sizes="(min-width: 1200px) 1200px, 100vw"
    alt={pageImage.alt}
  />
);
```

### Multiidioma
```typescript
const i18n = useI18n();
const formatDate = useLocaleDate();

return (
  <div>
    <h1>{i18n.t('home.title')}</h1>
    <p>{formatDate(new Date())}</p>
  </div>
);
```

### Renderización Solo en Cliente
```typescript
const isClient = useIsClient();

return isClient ? (
  <InteractiveComponent />
) : null;
```

## Errores Comunes

1. **Olvidar verificar loading/error** - Siempre chequea `isLoading` y `error`
2. **useList en SSR con cliente diferente** - Usa `useIsClient` para sincronizar
3. **No proporcionar srcSet en imágenes** - Siempre usa `useGriddoImage`
4. **Olvidar alt en imágenes** - Accesibilidad requerida
5. **Nestear useSession sin necesidad** - Usa `usePage` o `useSite` si es más simple

---

## Para Referencia Completa

Lee `references/hooks-catalog.md` para documentación exhaustiva de todos los hooks, parámetros opcionales, ejemplos avanzados y casos de uso.

