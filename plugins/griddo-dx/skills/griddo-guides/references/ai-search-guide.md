# AI Search

Griddo proporciona una serie de funcionalidades orientadas a realizar búsquedas potenciadas por AI. Sus principales ventajas son:

- Búsqueda semántica y no por palabra exacta. Puedes encontrar resultados aunque no contengan ninguna de las palabras que se están buscando.
- Mucha mayor precisión, resultados nivel Google.
- Más velocidad de respuesta para resultados estructurados (sin afectar a la base de datos).
- Varios formatos: resultados estructurados (buscador tradicional) y conversacionales.
- Posibilidad de filtrar por tipos de contenido.
- Posibilidad de filtrar por site.
- Posibilidad de potenciar ciertos resultados con modificadores.
- Entrenamiento dinámico con actualizaciones en menos de una hora.
- Muy facil de integrar en instancia (al final de este documento hay un ejemplo en html con vanilla javascript que desarrolla toda la funcionalidad).

## Los embeddings

Todas las búsquedas basadas en IA tienen como base los embeddings. Los embeddings son representaciones numéricas de datos que transforman información compleja, como palabras o frases, en vectores en un espacio de alta dimensionalidad. Este proceso permite que los datos puedan ser entendidos y manipulados por algoritmos de aprendizaje automático y redes neuronales.

**Los embeddings requieren la variable de entorno GRIDDO_AI_EMBEDDINGS="on" en API Privada.**

**Las búsquedas solo funcionan si está activado el buscador de Griddo en CX.** Es un proceso que, después de renderizar las páginas en CX, en diferido y segundo plano guarda y actualiza su información preprocesada en la base e datos de Griddo. Este proceso, al igual que las variables de entorno, se configura desde infra.

## Proceso para activar AI Search en tu instancia

**NOTA IMPORTANTE: ¡¡¡Asegúrate de que en negocio te han aprobado activar estas opciones en tu instancia!!! Además, cada instancia debe tener sus propias api keys de Open AI.**

1. **CX**: En infra te tienen que activar el buscador de Griddo **en CX**. Eso se hace con la variable de entorno `GRIDDO_SEARCH_FEATURE`.
2. **API Privada**: En el entorno debe estar configurada la variable de entorno `GRIDDO_openAIApiKey` **en API Privada** que **deberá ser la correspondiente al cliente (no usar una api key genérica)**, o ser proporcionada por el cliente **(¡consultar con negocio!).**
3. En infra te tienen que activar las variables de entorno:
    1. **CX y API Privada**: `GRIDDO_AI_EMBEDDINGS`="on" en todos los casos. Debe activarse tanto **en API Privada** para que genere los embeddings como **en CX** para que al terminar el escaneo de páginas se vectorice la información.
    2. **API Privada**: `GRIDDO_AI_SEARCH`="on" **en API Privada** para usar las búsquedas estructuradas.
    3. **API Privada**: `GRIDDO_AI_ANSWERS`="on" **en API Privada** para usar las búsquedas conversacionales.
4. Una vez se haya hecho el primer render completo con todas estas opciones activadas, espera aproximadamente 1 hora por cada 3000 páginas de contenido de la instancia, y ya podrás usar los endpoints de búsqueda potenciada por IA. Sí, la primera vez hay que tener bastante paciencia. Pero merece la pena.

## Cómo funciona internamente

1. Cuando se renderiza una nueva página, queda pendiente de asignarle sus embeddings. Si lo que se renderiza es una página que ya existía y tenía embeddings, si ha habido cambios en esa página, momentáneamente seguirá usando los embeddings anteriores hasta que se generen los nuevos.
2. Al terminar de analizarse todas las páginas después del render, se asignarán / corregirán los renders (porque al terminar ese proceso de análisis se llamará al endpoint de api privada POST /ai/embeddings).
3. Cuando haces una búsqueda, se crean los embeddings de esa query. A continuación, se comparan esos embeddings con los de todas las páginas que cumplan los filtros, y se le asignará un similarity, que es un valor del 0 al 1 que representa cuánto tienen en común la query con la página. Ese valor de similarity puede ser alterado para cumplir ciertos criterios de ordenación a través de la propiedad priority de los endpoints de búsqueda.
4. Si la búsqueda es estructurada, los resultados se organizarán por similarity. Este tipo de búsqueda es muy económico, ya que solo pagamos por la generación de los embeddings de la query, que es algo muy barato (un millón de queries de 5 palabras cada una, en torno a 14 centavos de dólar).
5. Si la búsqueda es contextual, se seleccionarán los 3 resultados que tengan mayor similarity y se usarán en un prompt para conseguir una respuesta en markdown a través de una llamada a la api de openai. Esto es bastante más caro, tipo un centavo de dólar por cada sola query.

**¡Recuerda que siempre debes tener autorización desde negocio para activar estas opciones que suponen un coste! Los precios indicados son estimaciones basadas en extrapolaciones.**

## Los endpoints

- **Si vas a desarrollar para una instancia:**
La implementación debe hacerse a través de la **API Pública**. Siempre. En la documentación de API Pública está explicado la manera de implementar tanto las búsquedas estructuradas como las conversacionales. Y tienes una demo en vanilla javascript justo en el apartado siguiente de esta página.
- **Si estás desarrollando para Griddo producto:**
Los endpoints de API Pública tienen su meollo en la **API Privada**, donde también sucede el tema de la generación de embeddings. Pero la parte de API Privada está más reservada para su uso por parte de desarrolladores de Griddo. La API Privada, aparte de gestionar toda la parte relacionada con las propias búsquedas, también gestiona la parte de los embeddings pregenerados de las páginas.

## Ejemplos de implementación

Para ver ejemplos de cómo se puede utilizar todo esto en tu instancia, mira el repo de demostración: 

[https://github.com/Secuoyas-Experience/griddo-ai-search-demo](https://github.com/Secuoyas-Experience/griddo-ai-search-demo)

Se trata de un repo desarrollado en vanilla javascript con el que se puede ver lo facil que es una implementación del buscador. ¡Echale un ojo! Ver el código de ejemplo, además de la propia documentación de la API Pública, es bastante clarificador.
