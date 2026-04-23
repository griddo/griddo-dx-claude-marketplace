# Hook useList() y TypeScript

Cuando necesitamos obtener content-types en el cliente (navegador) utilizaremos el hook useList. Aquí vamos a ver la relación entre el hook y TypeScript.

Los detalles del funcionamiento del hook lo podéis ver en la documentación: useList pero a modo de ejemplo el uso básico sería el siguiente código simplificado que iremos desglosando poco a poco.

```tsx
import type { ModuleProps, DATAContentTypeListProps } from "@autoTypes";
import { useList } from "@griddo/core";
import * as React from "react";

const Module = (props: ModuleProps) => {
	const { data } = props;
	const [{ query }, setQuery] = useList<DATAContentTypeListProps>();

	React.useEffect(() => {
		setQuery({ data });
	}, []);

	return (
		<ul>
			{query?.items?.map((item, index) => (
				<li>{item.title}</li>
			))}
		</ul>
	);
};
```

## Types para `useList`

Como vemos, al hook le podemos pasar el type del dato que ya ha generado AutoTypes™️ por nosotros para que así tengamos la respuesta completamente tipada. El type para usar con los listados tiene la partícula `List` en el nombre del type. Es decir si tenemos un dato `DATA`, tendremos un type par los listados: `DATAContentTypeListProps` 

```tsx
import type { ModuleProps, DATAContentTypeListProps } from "@autoTypes";
...

const Module = (props: ModuleProps) => {
	const [{ query }, setQuery] = useList<**DATAContentTypeListProps**>();
	...
};
```

A su vez el type acepta un genérico que indica con qué nivel de relaciones vamos a querer consultar el dato, según hayamos pasado a `setQuery`:  `"off" | "full" | "simple"` 

De esta manera podremos acceder por ejemplo añadiendo `<"simple">` al `id` o `label` de unas categorías que estén en el dato DATA, sino solo obtendríamos su `id`

```tsx
import type { ModuleProps, DATAContentTypeListProps } from "@autoTypes";
...

const Module = (props: ModuleProps) => {
	const [{ query }, setQuery] = useList<**DATAContentTypeListProps<"**simple**">**>();
	
	React.useEffect(() => {
		setQuery({ data, relations: "simple" });
	}, []);
	
  return (
		<ul>
			{query?.items?.map((item, index) => (
				<li key={index}>
					{item.categories?.map((cat) => cat.label)}
				</li>
			))}
		</ul>
	);
};
```
