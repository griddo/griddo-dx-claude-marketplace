# Datos estructurados de Google

Esta documentación es una guía para aprender a trabajar con datos estructurados (Schemas.org) de Google desde DX.

## Preparación

Creamos un fichero javascript para las funciones que vamos a necesitar. Aquí un ejemplo:

```jsx
import { LdJson } from '@griddo/core';

const BasicLdJson = () => AddLdJson({ data: basicLdJsonContent });

const basicLdJsonContent = [
    {
        "@context": "http://schema.org/",
        "@type": "EducationalOrganization",
        "name": "Centro de Estudios Garrigues",
        "address": {
            "@type": "PostalAddress",
            "streetAddress": "Paseo de Recoletos, 35",
            "addressLocality": "Madrid",
            "addressRegion": "Madrid",
            "addressCountry": "Spain",
            "postalCode": "28004"
        },
        "contactPoint": {
            "@type": "ContactPoint",
            "contactType": "Admissions",
            "telephone": "+915 14 53 30"
        },
        "brand": "Centro de Estudios Garrigues"
    },
    {
        "@context": "http://schema.org",
        "@type": "WebSite",
        "name": "Centro de Estudios Garrigues",
        "alternateName": "Centro Garrigues",
        "url": "https://www.centrogarrigues.com/"

    },
];

export = {
	LdJson,
	BasicLdJson,
};
```

Lo que nos importa de aquí (y que tenemos que exportar) es:

- `<LdJson data={content} />`. Es un componente que nos permite enviar un dato estructurado al header. Creamos el objeto que queremos enviar (puede ser un objeto o un array de objetos) y se lo pasamos a la función.
- `<BasicLdJson />`. Es un componente que nos permite enviar un dato estructurado de uso común en todas o casi todas las templates (en este caso, ejemplo real de Centro Garrigues, son dos datos estructurados distintos en un array). Esto es un ejemplo de lo que se comentaba antes de que LdJson admite tanto un objeto individual como un array de objetos, porque aquí le estamos pasando un array. No hace nada que no haga ya LdJson, pero simplifica importaciones rutinarias. Incluso podemos crear varios genéricos para esquemas con datos que se repiten constantemente.

Esto es flexible y se puede adaptar a las necesidades de cada cliente, puedes utilizar estas funciones u otras que se ajusten mejor a cada caso particular. Lo importante realmente es el componente LdJson que es la que nos permite enviar un dato estructurado de Google al header del documento.

## Integración

Por ejemplo, supongamos que queremos meter el dato estructurado de cursos en la template ProgramDetail.

Primero creamos el objeto del dato estructurado, utilizando el esquema que Google facilita para ese dato estructurado concreto (rellenándolo con la información del curso específico, que la sacamos de nuestro propio dato estructurado):

```jsx
const googleStructuredData = {
    "@context": "http://schema.org",
    "@type": "Event",
    "url": "https://www.centrogarrigues.com/master/executive/derecho-digital-y-tecnologia",
    "name": "Máster executive en derecho digital y tecnología",
    "organizer": {
    "@type": "Thing", 
    "name": "Centro de Estudios Garrigues", 
    "url": "https://www.centrogarrigues.com/"
    },
    "performer": {
    "@type": "Thing", 
    "name": "Centro de Estudios Garrigues"
    },
    "eventAttendanceMode": "offline",
        "description": "El programa Máster Executive en Derecho Digital y Tecnología proporciona una formación rigurosa y actualizada que permitirá a sus participantes integrar su dominio de los materiales legales con un extenso repertorio de conocimientos y habilidades en las áreas de los negocios y las tecnologías digitales. \nEl programa se estructura en tres grandes áreas: Derecho, Empresa Digital y Tecnología que son y serán muy relevantes para el ejercicio de la profesión de abogado asociándola a valores como la innovación y el compromiso con la sociedad de nuestro tiempo. ",
    "startDate": "2021-10-01",
    "image": "https://www.centrogarrigues.com/sites/default/files/headers/executive-digital.jpg",
    "location":
        {
        "@type": "Place",
        
        "name": "Centro de Estudios Garrigues",
        "address": "Paseo de Recoletos, 35, 28004 Madrid"
        }
};
```

Además, como en este caso concreto nos obligan a añadir unos datos estructurados básicos en todas las templates, añadimos el componente para añadir esos datos básicos que quiere tener el cliente en todas las páginas (BasicLdJson), más luego aparte el componente para añadir un objeto específico para ese tipo de página (LdJson).

```html
<BasicLdJson/>
<LdJson data={googleStructuredData}/>
```

Fíjate que puedes hacer LdJson todas las veces que quieras. Se pueden tener varios scripts ld+json en la misma página sin problema.

## Probar

Se prueba aquí: [https://search.google.com/test/rich-results?hl=ES](https://search.google.com/test/rich-results?hl=ES)
