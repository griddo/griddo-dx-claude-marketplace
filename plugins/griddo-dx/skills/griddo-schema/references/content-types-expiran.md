# Content Types que expiran

En un ContentType podemos indicar una fecha en la que llegada la misma deja de estar visible. Esto es compatible con ContentTypes de tipo: simples y página ya sean locales o globales.

En el caso de ContentType simples, estamos hablando de que cuando expira su estado pasa a ser **draft** y por tanto deja de ser visible. Cuando es de tipo página, lo que sucede es que la página pasa a estado **pending-unpublishing** y, posteriormente, a **offline**.

En ambos casos el efecto es exactamente el mismo que si se hubieran **despublicado** manualmente. Los posibles sites afectados por esa despublicación se volverán a renderizar. Cuando la expiración afecta a un ContentType global, todos los sites son renderizados de nuevo.

## ¿Cómo se configura?

Tenemos dos propiedades opcionales que podemos usar en los schemas de los ContentTypes:

- `expirationDateField`, cuyo valor sería un `DateField` del propio ContentType. Si ese campo tiene un valor, expirará al llegar a la fecha indicada en él. Si en el schema del ContentType no existe ningún `field` con esa `key` que además sea `type: DateField`, la sincronización de esquemas dará un error explicando exactamente qué es lo que ha fallado.
- `expirationDateOffset`, solo se puede usar si existe `expirationDateField`. Es un offset en días y debe ser numérico (por defecto, es 0). Indica el offset en días que debe aplicarse al valor de expirationDateField. Por ejemplo, si es un evento y queremos que expire al día siguiente de finalizar el evento, pondríamos expirationDateOffset: 1. Pero si es por ejemplo algo que requiere una fecha límite de inscripción y queremos que finalice 3 días antes, el expirationDateOffset sería -3 (es decir, el ContentType expira 3 días antes de la fecha indicada en el campo señalado en expirationDateField).

Cuando el field indicado en expirationDateField tiene un valor vacío (valor `null` o `undefined`), ese ContentType no expira. Por lo tanto, si quieres que todos los ContentType tengan una fecha de expiración, deberás hacer que la definición del field que utilices como `expirationDateField` sea `mandatory`.

El ContentType expirará automáticamente entre las 0:00 y las 2:00 h. del día indicado. En cualquier caso, el proceso de verificar las expiraciones se realiza cada dos horas. Si por lo que sea se publica un ContentType que tiene una fecha de expiración que ya venció, el ContentType se publicará pero en menos de dos horas se verificará que está vencido y será despublicado nuevamente. El proceso ocurre en API de manera transparente, por lo que si configuramos correctamente el ContentType con las dos keys indicadas, simplemente funcionará sin programación ni despliegue de recursos adicionales.

Esto tiene dos usos posibles, que vamos a explicar con ejemplos.

### **EJEMPLO 1**

**El propio ContentType ya tiene una fecha, y la fecha de expiración del ContentType es relativa a esta.**
Por ejemplo, en un ContentType de tipo *evento*, quiero que el expire al día siguiente de su celebración (ojo: al día siguiente, porque si se celebra el día 3, yo quiero que se pueda ver todo el día 3 y que desaparezca en la madrugada del día 4).

```json
EVENTS: {
    title: "Events",
    dataPacks: ["EVENTS"],
    local: false,
    taxonomy: false,
    fromPage: true,
    translate: true,
    expirationDateField: "when",
    expirationDateOffset: 1,
    schema: {
      templates: ["EventDetail"],
      fields: [
        {
          key: "title",
          title: "Title",
          type: "TextField",
          from: "title",
        },
        {
          key: "when",
          title: "Event date and time",
          type: "DateField",
          from: "dateTime",
          indexable: true,
        },
        {
          key: "eventHour",
          title: "Event Hour",
          type: "TextField",
          from: "eventHour",
        },
      ],
      searchFrom: [""],
    },
    clone: null,
    defaultValues: null,
  },
}
```

### **EJEMPLO 2:**

**El editor especificará exactamente en qué fecha quiere que el ContentType expire.**
Por ejemplo, en un campo del tipo *oferta*, queremos indicar una fecha en la que esa oferta deje de existir. Esa fecha no es relativa a nada que ya exista el ContentType, simplemente es la fecha en la que queremos que deje de estar disponible. Aquí no usamos `expirationDateOffset` porque expirará exactamente en la fecha que nos hayan dicho.

```json
OFFERS: {
    title: "Offers",
    dataPacks: ["DISCOUNTS"],
    local: true,
    taxonomy: false,
    fromPage: false,
    translate: false,
    expirationDateField: "validUntil",
    schema: {
      fields: [
        {
          key: "title",
          title: "Title",
          type: "TextField",
        },
        {
          key: "validUntil",
          title: "This offer is valid until this date",
          type: "DateField",
        },
      ],
      searchFrom: [],
    },
    clone: null,
    defaultValues: null,
}
```