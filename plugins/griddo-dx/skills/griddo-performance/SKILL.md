---
name: griddo-performance
description: "Optimización de rendimiento y Core Web Vitals para instancias Griddo. Usar cuando el developer menciona: rendimiento, performance, lento, optimizar, Core Web Vitals, LCP, CLS, FID, carga de imágenes, lazy loading, tipografías, yarn.lock."
---

# Optimización de Rendimiento en Griddo

Ayuda a los developers a optimizar el rendimiento de sus instancias Griddo, enfocándote en Core Web Vitals y prácticas eficientes de desarrollo.

## Cuándo usar esta skill

Utiliza esta skill cuando el developer mencione:

- Problemas de rendimiento o sitio lento
- Core Web Vitals (LCP, CLS, FID, INP)
- Optimización de imágenes con `GriddoImage` o `useGriddoImage`
- Carga de tipografías o fonts
- Tamaños de bundle o dependencias
- Tiempos de renderizado altos
- Lazy loading o code splitting
- Gestión de `yarn.lock`
- Carga de assets estáticos

## Checklist de diagnóstico

Cuando el developer describe un problema de rendimiento, sigue este orden:

1. **Bundle y dependencias**
   - Pregunta si ha analizado el bundle con `gatsby-plugin-webpack-bundle-analyser-v2`
   - Sugiere revisar imports innecesarios usando herramientas como [bundlephobia.com](https://bundlephobia.com/) o la extensión [import cost](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost)
   - Verifica que `yarn.lock` esté sincronizado con `package.json` (ejecutar `yarn install`)

2. **Datos y distribuidores**
   - Pregunta si está usando distribuidores innecesariamente o si puede usar API Pública
   - Verifica que haya límites en los esquemas
   - Revisa si `hasDistributorData: true` está añadiendo peso a la página
   - Sugiere paginación real con API Pública en lugar de "solo visual"

3. **Imágenes**
   - Verifica que use `<GriddoImage>` con `responsive` correctamente configurado
   - Pregunta por ancho, alto y ratios para evitar CLS
   - Sugiere `fetchpriority="high"` para imágenes críticas (hero)
   - Verifica que usa `lazy` loading para imágenes below the fold
   - Confirma que usa imágenes inline `<img>` en lugar de background CSS

4. **React y renderizado**
   - Pregunta si está usando `useEffect` para condicionar el render
   - Verifica que el estado tenga valores por defecto (no deixar HTML vacío)
   - Sugiere extraer `useEffect` en custom hooks si es complejo
   - Advierte que `useEffect` no se ejecuta en SSR, solo en navegador

5. **Tipografías**
   - Verifica que aloje tipografías en `/static` en lugar de CDN
   - Sugiere retardar carga de fonts no críticas usando `loadCSS`
   - Confirma que usa `woff2` en lugar de `ttf` o `woff`
   - Revisa que el charset sea mínimo (ej: "latin" sin Cyrilic/Greek)

6. **Scripts y CSS**
   - Revisa `builder.ssr.js` para scripts con `async`/`defer`
   - Verifica si CSS crítico está inlined en `/src/adapters/index.js`
   - Sugiere diferir CSS no crítico con `loadCSS`

## Soluciones rápidas por categoría

### Imágenes

- Reemplaza `<img style={{backgroundImage}}>` con `<GriddoImage>` inline
- Añade `fetchpriority="high"` a imágenes above the fold
- Especifica ancho, alto y ratio para evitar CLS
- Usa `responsive` con tamaños diferenciados (ej: 400px, 800px, 1200px)
- Activa `lazy` loading en imágenes below the fold

```jsx
<GriddoImage
  src={imageUrl}
  alt="description"
  width={1200}
  height={600}
  responsive={[
    { size: 400, width: 400 },
    { size: 800, width: 800 },
    { size: 1200, width: 1200 },
  ]}
  fetchpriority="high"
  loading="lazy"
/>
```

### Tipografías

- Aloja fonts en `/static/fonts/` con CSS en `/static/webfonts.css`
- Retarda carga con `loadCSS` en `builder.ssr.js`
- Usa `woff2` (no `ttf` o `woff`)
- Limita charset a idioma necesario (latin, cyrillic, etc.)

### Renderizado y React

- Si usas `useState` que afecta al render, asigna valor por defecto
- Envuelve `useEffect` complejo en custom hook
- No uses `useEffect` para datos precargados; usa API Pública en su lugar
- Evita `mode:list` si no es paginación estática

```tsx
// Malo: HTML estará vacío hasta rehidratación
const [count, setCount] = useState() // undefined

// Bueno: HTML tendrá contenido desde el build
const [count, setCount] = useState(0) // valor por defecto
```

### Bundle y dependencias

- Analiza bundle: `gatsby-plugin-webpack-bundle-analyser-v2`
- Elimina imports no usados en el bundle (revisa `helpers.js`, etc.)
- Reemplaza librerías pesadas: `react-markdown` (40k) → `markdown-to-jsx` (17k)
- Importa solo iconos usados de librerías de iconos
- Cuidado con SVGs mal optimizados
- Usa `React.lazy()` para code splitting en módulos pesados

```jsx
const HeavyModule = React.lazy(() => import('./HeavyModule'))
```

### Datos y API Pública

- Usa distribuidores solo si datos son críticos (first paint)
- Para datos below the fold: usa API Pública + spinners
- Limita elementos en esquemas (nunca "todos los resultados")
- Activa caché de API Pública con llamadas consistentes
- Filtra campos en API Pública (ej: solo nombre, no 20 propiedades)
- Usa paginación real, no visual

```jsx
// Malo: carga 200 elementos, muestra 6
schema: { limit: undefined }

// Bueno: carga solo 6
schema: { limit: 6 }
```

### yarn.lock

- Antes de commit: ejecuta `yarn install` para sincronizar `yarn.lock` con `package.json`
- No comitees `yarn.lock` de otra rama sin sincronizar
- Usa git-hooks con husky para automatizar

## Recursos completos

Consulta `references/performance-guide.md` en este skill para:

- Detalles completos sobre Core Web Vitals
- Configuración específica de `builder.ssr.js` y `builder.browser.js`
- Ejemplos avanzados de optimización
- Casos de uso de persistencia para importación de datos

## Workflow típico

1. Pregunta cuál es el problema específico (lento en general, métrica de CWV específica, etc.)
2. Sigue el **checklist de diagnóstico** arriba
3. Aplica las **soluciones rápidas** relevantes
4. Apunta a `references/performance-guide.md` para detalles profundos
5. Sugiere medir resultados con PageSpeed Insights o Lighthouse

---

**Nota:** Griddo genera sitios estáticos con React SSR. El rendimiento depende de decisiones en build-time (distribuidores, bundle, datos) y runtime (lazy loading, state management).
