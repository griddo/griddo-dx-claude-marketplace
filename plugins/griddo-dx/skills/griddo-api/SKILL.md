---
name: griddo-api
description: >
  Usar esta skill cuando el developer pregunte sobre la API de Griddo, endpoints,
  "GET /search", "POST /pages", "API Pública", "API Privada", "cómo consulto datos",
  "endpoint de formularios", "autenticación API", o necesite la referencia de
  endpoints de la API REST de Griddo.
---

# API de Griddo

## Overview

La API de Griddo está dividida en dos categorías principales:

### API Pública
Utilizada principalmente por el frontend y generadores de sitios estáticos (SSG). Proporciona acceso a contenido publicado y datos disponibles públicamente.

### API Privada
Utilizada por el backoffice (AX) y sistemas internos. Proporciona acceso completo a todas las funcionalidades de administración, configuración y gestión de contenido.

---

## Índice de Endpoints de API Pública

| Endpoint | Método | Ruta |
|----------|--------|------|
| AI Search | N/A | Ver referencia |
| Alertas SNS | N/A | Ver referencia |
| Alertas | N/A | Ver referencia |
| Calendar | N/A | Ver referencia |
| CRM Integrations | N/A | Ver referencia |
| Variables de entorno de API Pública | N/A | Ver referencia |
| Feeds | N/A | Ver referencia |
| Files | N/A | Ver referencia |
| Filtros | N/A | Ver referencia |
| Formularios | N/A | Ver referencia |
| GeoIP | N/A | Ver referencia |
| GPX | N/A | Ver referencia |
| Listados | N/A | Ver referencia |
| Page | N/A | Ver referencia |
| Pass (external API middleware) | N/A | Ver referencia |
| Search | N/A | Ver referencia |
| Como arrancar la API Pública en Local | N/A | Ver referencia |
| Socials | N/A | Ver referencia |
| Youtube | N/A | Ver referencia |

---

## Índice de Endpoints de API Privada - CRUD

### Endpoints de gestión de contenido y estructura

| Endpoint | Método | Ruta |
|----------|--------|------|
| Data Pack | N/A | Ver referencia |
| Files | N/A | Ver referencia |
| Folders | N/A | Ver referencia |
| Images | N/A | Ver referencia |
| Login | N/A | Ver referencia |
| Menus | N/A | Ver referencia |
| Navigations | N/A | Ver referencia |
| Pages | N/A | Ver referencia |
| Redirects | N/A | Ver referencia |
| Schemas | N/A | Ver referencia |
| Sites | N/A | Ver referencia |
| Structured Data | N/A | Ver referencia |
| User | N/A | Ver referencia |

---

## Índice de Endpoints de API Privada - Integraciones

### Endpoints de integraciones y conexiones externas

| Endpoint | Método | Ruta |
|----------|--------|------|
| AI Search | N/A | Ver referencia |
| Analytics | N/A | Ver referencia |
| Feeds | N/A | Ver referencia |
| Form Builder | N/A | Ver referencia |
| GPX | N/A | Ver referencia |
| Integrations (addons) | N/A | Ver referencia |
| Inteligencia Artificial | N/A | Ver referencia |
| Search | N/A | Ver referencia |
| Socials | N/A | Ver referencia |

---

## Índice de Endpoints de API Privada - Configuración

### Endpoints de configuración, infraestructura y settings

| Endpoint | Método | Ruta |
|----------|--------|------|
| Caché | N/A | Ver referencia |
| Debug | N/A | Ver referencia |
| Domains | N/A | Ver referencia |
| Endpoints para QA | N/A | Ver referencia |
| API Privada Environment Variables | N/A | Ver referencia |
| Error Reporting | N/A | Ver referencia |
| Glosarios para traducciones | N/A | Ver referencia |
| Health Status | N/A | Ver referencia |
| Docker en API | N/A | Ver referencia |
| Languages | N/A | Ver referencia |
| Live Status | N/A | Ver referencia |
| Logs | N/A | Ver referencia |
| Metrics | N/A | Ver referencia |
| Persistencia | N/A | Ver referencia |
| Roles | N/A | Ver referencia |
| Settings | N/A | Ver referencia |

---

## Índice de Endpoints de API Privada - Características

### Descripciones de características especiales y comportamientos

| Endpoint | Método | Ruta |
|----------|--------|------|
| Actualización automática de páginas relacionadas | N/A | Ver referencia |
| Typos | N/A | Ver referencia |
| Agrupación de categoría en subcategorías | N/A | Ver referencia |
| AX: Gestionar la configuración de templates en edición de páginas | N/A | Ver referencia |
| AX: Páginas Draft | N/A | Ver referencia |
| Categorías para instancia | N/A | Ver referencia |
| Cálculo de URLs de páginas | N/A | Ver referencia |
| Content Type privados en API | N/A | Ver referencia |
| CX Propiedad changedPages | N/A | Ver referencia |
| Información API Privada | N/A | Ver referencia |
| Distribuidores | N/A | Ver referencia |
| Gestión del render en API | N/A | Ver referencia |
| Griddo File Drive | N/A | Ver referencia |
| Headers Obligatorios para Peticiones a la API | N/A | Ver referencia |
| Optimizaciones de la base de datos | N/A | Ver referencia |
| Orden script Addons con Analytics y Datalayer | N/A | Ver referencia |
| Páginas globales: AX | N/A | Ver referencia |
| Proceso en CX para renderizado de sites | N/A | Ver referencia |
| Programación de Publicación de Páginas. 61956 | N/A | Ver referencia |
| Asignar roles a un usuario | N/A | Ver referencia |
| Comprobar permisos fuera del endpoint | N/A | Ver referencia |
| Listado de sites | N/A | Ver referencia |
| Middleware para comprobar permisos | N/A | Ver referencia |
| Roles y Permisos en la BDD | N/A | Ver referencia |
| Roles y Permisos | N/A | Ver referencia |
| Documentación Front | N/A | Ver referencia |
| Single Sign On (SSO) | N/A | Ver referencia |

---

## Instrucciones de Uso

Para obtener la documentación completa de un endpoint específico:

- **Si el developer pregunta por un endpoint público**: lee el archivo correspondiente de la carpeta `references/api-public-endpoints.md`
- **Si pregunta por un endpoint privado de CRUD**: lee el archivo correspondiente de `references/api-private-crud.md`
- **Si pregunta por un endpoint privado de Integraciones**: lee el archivo correspondiente de `references/api-private-integrations.md`
- **Si pregunta por un endpoint privado de Configuración**: lee el archivo correspondiente de `references/api-private-config.md`
- **Si pregunta por características especiales**: lee el archivo correspondiente de `references/api-private-features.md`

### Documentación por Categoría

1. **API Pública**: Consulta `api-public-endpoints.md` para endpoints disponibles públicamente
2. **CRUD Privada**: Consulta `api-private-crud.md` para operaciones de creación, lectura, actualización y eliminación
3. **Integraciones Privada**: Consulta `api-private-integrations.md` para conexiones con servicios externos
4. **Configuración Privada**: Consulta `api-private-config.md` para settings y configuración del sistema
5. **Características Privada**: Consulta `api-private-features.md` para descripciones de características especiales

