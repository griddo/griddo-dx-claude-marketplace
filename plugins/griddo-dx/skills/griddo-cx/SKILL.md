---
name: griddo-cx
description: >
  Cómo se construye y se publica una instancia Griddo, y por qué a veces no se reconstruye.
  Usar cuando el developer pregunte "por qué no se ve mi cambio", "no se ha reconstruido el sitio",
  "qué es IDLE", "modo de render", "FROM_SCRATCH", "INCREMENTAL", "por qué el build es completo",
  "dónde pongo un plugin de Gatsby", "gatsby-config", "no encuentra mis componentes",
  "revienta al importar @griddo/cx", "qué se publica exactamente", o cuando un build falle por
  configuración de la instancia y no por su código.
---

# griddo-cx: build y publicación de tu instancia

`@griddo/cx` es el paquete que convierte tu instancia en un sitio estático. Esta skill cubre **lo que un
developer de instancia puede diagnosticar y arreglar**: por qué un dominio no se reconstruye, qué parte del
proyecto Gatsby es tuya y qué parte no, y las dos cosas de tu configuración que rompen el build antes de
llegar a tu código.

No cubre operar el render (encadenar comandos, montar el entorno, publicar el bundle): eso lo hace Griddo,
no la instancia.

## Tabla de referencias

| Referencia | Resumen |
|---|---|
| `references/build-y-publicacion.md` | El ciclo de build, los modos de render y sus reglas, qué aporta la instancia frente a lo que aporta CX, y los dos fallos de configuración que revientan el import |

## Cómo usar esta skill

1. **«No se ve mi cambio»** → antes de mirar el código, decide de qué tipo de cambio hablamos:
   - Cambio de **código** → el render es completo (`FROM_SCRATCH`) por diseño. Si aun así no aparece,
     el problema está en el build o después de él.
   - Cambio de **contenido sin publicar** → probablemente el dominio salió `IDLE` y no se construyó nada.
   - **Construido pero no en vivo** → CX no publica; el paso de subida e invalidación de CDN es posterior.
     No es tu código.
2. **Un build que falla sin tocar tus componentes** → mira el `tsconfig.json` de la instancia: si no está o
   no declara `compilerOptions.paths`, el paquete revienta **al importarse**, antes de compilar nada.
3. **«¿Dónde añado un plugin de Gatsby?»** → el proyecto Gatsby vive dentro de `@griddo/cx`, no en tu repo.
   Para tocar el `<head>` o el `<body>`, usa `builder.ssr.js` de tu instancia y consulta
   `griddo-performance`.
4. **Al abrir una incidencia de render**, pide la **razón** del modo, no solo el modo: distingue «no había
   nada que hacer» de «el render anterior murió a media», que se parecen desde fuera.

## Notas importantes

- El modo de render se decide al empezar el ciclo y queda congelado: los cambios a mitad no se recogen
  hasta el ciclo siguiente.
- Prosa en español, código en inglés, como el resto del plugin.
