# Temificar schemas

Es posible añadir distintos thumbnails y opciones según el theme seleccionado del site a varios de los fields disponibles en Griddo: `VisualUniqueSelection`, `ColorPicker` y a los thumbnails de `componentes` , `módulos`, `templates` y `dataPacks` . 

<aside>
👀 Las páginas globales al no tener theme, lo tomarán el que se establezca por defecto en el archivo de configuración de themes. Ver ‣

</aside>

## Thumbnails

```jsx
thumbnails: {
	themeOne: {
    1x: "/img/default-theme/thumbnail@1x.png",
    2x: "/img/default-theme/thumbnail@2x.png",
  },
  themeTwo: {
    1x: "/img/alt-theme/thumbnail@1x.png",
    2x: "/img/alt-theme/thumbnail@2x.png",
  },
}
```

## VisualUniqueSelection

```jsx
{
  title: "Style",
  key: "theme",
  type: "VisualUniqueSelection",
  options: [
    {
      theme: "griddo-default",
      options: [
        { value: "defaultAlt", img: "/img/default-theme/style01.png" },
        { value: "default", img: "/img/default-theme/style02.png" }
      ]
    },
    {
      theme: "griddo-alternative",
      options: [
        { value: "defaultAlt", img: "/img/alt-theme/style01.png" },
        { value: "default", img: "/img/alt-theme/style02.png" }
      ]
    }
  ]
}
```

## ColorPicker

```jsx
{
  title: "Background",
  type: "ColorPicker",
  key: "background",
  colors: [
    {
      theme: "griddo-default",
      options: ["#d9e3f0", "#f47373", "#697689"]
    },
    {
      theme: "griddo-alternative",
      options: ["#ffffff", "#dddddd", "#cccccc"]
    }
  ]
}
```

## Theme por defecto

Indicar el theme por defecto. Si no se indica ninguno se tomará el primero del array como el theme por defecto.

```jsx
[
  {
    label: "Griddo Default",
    value: "default-theme",
    "default": true, // theme por defecto
  }
]
```