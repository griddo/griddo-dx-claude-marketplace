# Modal

El elemento Modal permite renderizar cualquier Módulo o Componente de React en primer plano mediante una modal.

```jsx
import Modal from "@elements/Modal"
```

La única propiedad obligatoria del Modal es **`open`** y **`setOpen`** que será el disparador que activa el Modal cuando es `true` y que devolverá como `false` cuando se cierre.

Todo lo que haya entre la apertura **`<Modal>`** y su cierre **`</Modal>`** se renderizará en primer plano.

```jsx
import React, { useState } from "react"
import { Button, Text } from "@sqymagma/elements"
import Modal from "@elements/Modal"

export default MyComponent() {
  const [open, setOpen] = useState(false)
  return (
    <>
      <Modal open={open} setOpen={setOpen}>
          <Text>Hi, I'm a Modal</Text>
      </Modal>
      <Button onClick={() => setOpen(true)}>
          Click Me!
      </Button>
    </>
  )
}
```

Por defecto el Modal renderiza a su hijo en tiempo de ejecución, lo que ayuda mucho a la performance del site. Sin embargo, hay ocasiones que podemos querer mostrar algo que tenga una carga lenta o un módulo pesado. En ese caso, con la prop **`preLoad`** podremos precargar el contenido del modal para que la muestra sea inmediata.

Si mientras estás desarrollando notas que la carga del contenido del Modal es lenta, prueba con **`preLoad`**

Por defecto la Modal aparece con un background blanco y una sombra, si queremos desactivarla, basta con añadir la prop **`transparent`** 

Por defecto la Modal va a intentar abarcar (casi) todo el ancho de la pantalla, pero podemos forzar a que ocupe sólo lo necesario con **`fitContent`** 

Si por otro lado necesitamos un tamaño específico también tenemos la prop **`maxWidth`** disponible con el formato de queries `{default, s, m, l, xl, xxl}`

```jsx
import React, { useState } from "react"
import { Button, Text, Video } from "@sqymagma/elements"
import Modal from "@elements/Modal"

export default MyComponent({url}) {
  const [open, setOpen] = useState(false)
  return (
    <>
      <Modal 
				open={open} 
				setOpen={setOpen} 
				preload 
				transparent
				fitContent
				>
          <Text color="white">Hi, I'm a Modal</Text>
					<Video src={url}/>
      </Modal>
      <Button onClick={() => setOpen(true)}>
          Click Me!
      </Button>
    </>
  )
}
```

## Reference

| **`prop`** | **`type`** | **`default`** |
| --- | --- | --- |
| open, setOpen | useState | false |
| preLoad | bool | false |
| transparent | bool | false |
| fitContent | bool | false |
| maxWidth | query | {
default: "100%",
s: "95%",
m: "90%",
l: "85%",
xl: "80%",
xxl: "75%",
xxxl: "70%",
} |
| bg | HEX | #f6f6f7 |
| boxShadow | CSS | 0 0 40px rgba(0, 0, 0, 0.5) |
