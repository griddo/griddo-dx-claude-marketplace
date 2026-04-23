---
name: griddo-guides
description: "Guías de integración y funcionalidades avanzadas de Griddo. Usar cuando el developer menciona: SSO, autenticación, GPX, hiperpersonalización, AI Search, búsqueda inteligente, SEO, social share, Open Graph, social media tokens, datos estructurados de Google, schema.org, helpers, GriddoImageExp, GriddoLink, HTML/SSR/CSR/SSG, useList, TypeScript, modal."
---

# griddo-guides: Índice de Guías de Integración

Cuando el developer mencione cualquiera de estos temas, consulta la guía correspondiente de la tabla de abajo. Estas guías cubren integraciones, configuraciones avanzadas y patrones de desarrollo comunes en instancias de Griddo.

## Tabla de Rutas: Tema → Referencia

| Tema | Descripción | Archivo de Referencia |
|------|-------------|----------------------|
| **SSO / Autenticación / Single Sign-On** | Cómo implementar SSO en una instancia Griddo, configurar variables de entorno (SSO_ACTIVATED, SSO_CLIENT_ID, etc.) y hacer pruebas de flujo de autenticación | `sso-guide.md` |
| **GPX / Hiperpersonalización** | Sistema propietario de IA para microsegmentación de usuarios; cómo definir áreas, intereses y pesos; estrategias de recolección de intereses; uso de hooks (useSendInterests, useReceiveInterests, usePageRelatedContent) | `gpx-guide.md` |
| **AI Search / Búsqueda inteligente** | Búsquedas potenciadas por IA con embeddings; cómo activar en instancia; búsquedas estructuradas y conversacionales; costes de API | `ai-search-guide.md` |
| **SEO / Social Share / Meta tags / Open Graph / Twitter** | Etiquetas meta de página, Open Graph, Twitter cards, datos canónicos, favicon, metadatos básicos | `seo-social-share-guide.md` |
| **Social Media Tokens / YouTube / Twitter / Instagram** | Cómo obtener y configurar API keys de YouTube, Bearer Token de Twitter, Client ID/Secret de Instagram para SocialWall | `social-media-tokens-guide.md` |
| **Datos Estructurados de Google / Schema.org / JSON-LD** | Cómo crear y usar el componente LdJson para enviar esquemas a Google; integración en templates; testing con Google Rich Results | `google-structured-data-guide.md` |
| **Helpers / GriddoImageExp / GriddoLink** | Componentes helper: GriddoImageExp para imágenes responsive con art-direction; GriddoLink para enlaces internos | `helpers-guide.md` |
| **HTML / SSR / CSR / SSG / Rendering** | Explicación de modos de renderizado: Vanilla HTML, Server-Side Rendering, Client-Side Rendering, Static Site Generation; ventajas y desventajas | `html-ssr-csr-ssg-guide.md` |
| **useList / TypeScript / Hooks** | Hook useList para obtener content-types en cliente; relación con types generados por AutoTypes™️; relaciones (off/simple/full) | `uselist-typescript-guide.md` |
| **Modal / Componente Modal** | Componente Modal para renderizar módulos en primer plano; props (open, setOpen, preLoad, transparent, fitContent, maxWidth) | `modal-guide.md` |

## Cuándo usar esta skill

Usa esta skill cuando el developer mencione cualquiera de los siguientes términos o contextos:

- **Autenticación**: SSO, ADFS, single sign-on, integración de identidad
- **Personalización**: GPX, hiperpersonalización, segmentos, perfiles de usuario, intereses del usuario
- **Búsqueda**: AI Search, búsqueda semántica, embeddings, búsqueda inteligente
- **SEO y redes sociales**: meta tags, Open Graph, Twitter cards, social share, Facebook, canonicales
- **Tokens y APIs**: social media tokens, YouTube API, Twitter API, Instagram API
- **Datos estructurados**: schema.org, JSON-LD, datos estructurados de Google, Google Rich Results
- **Componentes y helpers**: GriddoImageExp, GriddoLink, image optimization, links internos
- **Rendering y arquitectura**: HTML estático, SSR, CSR, SSG, Vanilla HTML
- **Hooks y development**: useList, TypeScript, generación de tipos, AutoTypes, client-side data fetching
- **Componentes UI**: Modal, componentes de interfaz

## Cómo usar estas guías

1. **Identifica el tema**: Detecta qué concepto o funcionalidad necesita el developer consultando la tabla de arriba.
2. **Lee la referencia correspondiente**: Abre el archivo `.md` indicado en la columna "Archivo de Referencia".
3. **Sigue los ejemplos y patrones**: Cada guía contiene ejemplos de código, explicaciones detalladas y best practices.
4. **Proporciona contexto específico**: Adapta los ejemplos al contexto de la instancia o proyecto del developer.
5. **Complementa con otros skills**: Si el developer necesita más contexto sobre tipos de datos, componentes o la arquitectura general, sugiere revisar otros skills como `griddo-components` o `griddo-datamodel`.

## Notas importantes

- Todas las guías están en **español**, excepto el código que permanece en **English**.
- Algunos temas están interrelacionados (ej. GPX y useList, SEO y datos estructurados). Si es necesario, sugiere leer múltiples guías.
- Los ejemplos de código incluyen imports, propiedades completas y casos de uso reales.
- Para configuraciones de variables de entorno (GRIDDO_AI_EMBEDDINGS, SSO_ACTIVATED, etc.), recuerda mencionar que el equipo de infra debe realizar esos cambios.
