# Data Pack

Nota: Los esquemas de categorías de paquetes de datos, así como los esquemas de paquetes de datos, y sus relaciones con módulos y templates, es accesible directamente desde DX.

## `GET` /data_pack_categories

Devuelve la lista de categorías de data packs.

```json
[
    {
        "id": "ARTICLES_EVENTS",
        "name": "Articles & Events"
    },
    {
        "id": "PROGRAMS",
        "name": "Programs"
    },
    {
        "id": "PEOPLE",
        "name": "People"
    },
    {
        "id": "PROJECTS",
        "name": "Projects"
    },
    {
        "id": "FINANTIAL",
        "name": "Finantial"
    },
    {
        "id": "OFFICES",
        "name": "Offices"
    }
]
```javascript

## `GET` /data_pack

<aside>
💡 **Params:**
?category (lista de ids, separados por comas, para filtrado)
?query (palabras clave, para filtrado)

</aside>

Devuelve la información de los data packs

```json
{
    "totalItems": 4,
    "page": 1,
    "items": [
        {
            "id": "NEWS",
            "title": "News",
            "category": {
                "id": "ARTICLES_EVENTS",
                "label": "Articles & Events"
            },
            "description": "A description is needed for this data pack.",
            "image": "",
            "templates": [
                {
                    "id": "NewsDetail",
                    "title": "News Detail",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ],
            "modules": [
                {
                    "id": "NewsCard",
                    "title": "News Card",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                },
                {
                    "id": "NewsDistributor",
                    "title": "News Distributor",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ],
            "categories": [
                {
                    "id": "NEWS_AREAS",
                    "title": "News Areas",
                    "dataPacks": [
                        "NEWS"
                    ]
                },
                {
                    "id": "SCHOOLS",
                    "title": "Schools",
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ]
        },
        {
            "id": "EVENTS",
            "title": "Events",
            "category": {
                "id": "ARTICLES_EVENTS",
                "label": "Articles & Events"
            },
            "description": "A description is needed for this data pack.",
            "image": "",
            "templates": [
                {
                    "id": "EventList",
                    "title": "Event List",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/EventList",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/EventList@2x"
                    },
                    "dataPacks": [
                        "EVENTS"
                    ]
                }
            ],
            "modules": [
                {
                    "id": "EventCard",
                    "title": "Event Card",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/EventCard",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/EventCard@2x"
                    },
                    "dataPacks": [
                        "EVENTS"
                    ]
                },
                {
                    "id": "EventsDistributor",
                    "title": "Events Distributor",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/EventsDistributor",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/EventsDistributor@2x"
                    },
                    "dataPacks": [
                        "EVENTS"
                    ]
                }
            ],
            "categories": [
                {
                    "id": "EVENT_AREAS",
                    "title": "Event Areas",
                    "dataPacks": [
                        "EVENTS"
                    ]
                },
                {
                    "id": "EVENT_FORMATS",
                    "title": "Event Formats",
                    "dataPacks": [
                        "EVENTS"
                    ]
                },
                {
                    "id": "EVENT_LOCATIONS",
                    "title": "Event Locations",
                    "dataPacks": [
                        "EVENTS"
                    ]
                }
            ]
        },
        {
            "id": "PUBLICATIONS",
            "title": "Publications",
            "category": {
                "id": "ARTICLES_EVENTS",
                "label": "Articles & Events"
            },
            "description": "A description is needed for this data pack.",
            "image": "",
            "templates": [],
            "modules": [
                {
                    "id": "PublicationCard",
                    "title": "Publication Card",
                    "dataPacks": [
                        "PUBLICATIONS"
                    ]
                },
                {
                    "id": "PublicationDistributor",
                    "title": "Publication Distributor",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/PublicationDistributor",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/PublicationDistributor@2x"
                    },
                    "dataPacks": [
                        "PUBLICATIONS"
                    ]
                }
            ],
            "categories": []
        },
        {
            "id": "ARTICLES",
            "title": "Articles",
            "category": {
                "id": "ARTICLES_EVENTS",
                "label": "Articles & Events"
            },
            "description": "A description is needed for this data pack.",
            "image": "",
            "templates": [],
            "modules": [
                {
                    "id": "ArticlesDistributor",
                    "title": "Articles Distributor",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/ArticlesDistributor",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/ArticlesDistributor@2x"
                    },
                    "dataPacks": [
                        "ARTICLES"
                    ]
                }
            ],
            "categories": []
        }
    ]
}
```javascript

## `GET` /data_pack/:id

Devuelve la información del data pack con el id pasado por parámetro

```json
{
    "id": "NEWS",
    "title": "News",
    "category": {
        "id": "ARTICLES_EVENTS",
        "label": "Articles & Events"
    },
    "description": "A description is needed for this data pack.",
    "image": "",
    "templates": [
        {
            "id": "NewsDetail",
            "title": "News Detail",
            "thumbnails": {
                "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail",
                "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail@2x"
            },
            "dataPacks": [
                "NEWS"
            ]
        }
    ],
    "modules": [
        {
            "id": "NewsCard",
            "title": "News Card",
            "thumbnails": {
                "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard",
                "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard@2x"
            },
            "dataPacks": [
                "NEWS"
            ]
        },
        {
            "id": "NewsDistributor",
            "title": "News Distributor",
            "category": "articlesAndEvents",
            "thumbnails": {
                "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor",
                "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor@2x"
            },
            "dataPacks": [
                "NEWS"
            ]
        }
    ],
    "categories": [
        {
            "id": "NEWS_AREAS",
            "title": "News Areas",
            "dataPacks": [
                "NEWS"
            ]
        },
        {
            "id": "SCHOOLS",
            "title": "Schools",
            "dataPacks": [
                "NEWS"
            ]
        }
    ]
}
```javascript

## `GET` /site/:site/data_pack/:id

Devuelve la información del data pack con el id pasado por parámetro de un site concreto. A diferencia del endpoint `/data_pack/:id`, además añade información de si está activado o desactivado para el site indicado, y la configuración específica para ese site.

```json
{
    "id": "NEWS",
    "title": "News",
    "category": {
        "id": "ARTICLES_EVENTS",
        "label": "Articles & Events"
    },
    "description": "A description is needed for this data pack.",
    "image": "",
    "templates": [
        {
            "id": "NewsDetail",
            "title": "News Detail",
            "thumbnails": {
                "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail",
                "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail@2x"
            },
            "dataPacks": [
                "NEWS"
            ]
        }
    ],
    "modules": [
        {
            "id": "NewsCard",
            "title": "News Card",
            "thumbnails": {
                "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard",
                "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard@2x"
            },
            "dataPacks": [
                "NEWS"
            ]
        },
        {
            "id": "NewsDistributor",
            "title": "News Distributor",
            "thumbnails": {
                "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor",
                "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor@2x"
            },
            "dataPacks": [
                "NEWS"
            ]
        }
    ],
    "categories": [
        {
            "id": "NEWS_AREAS",
            "title": "News Areas",
            "dataPacks": [
                "NEWS"
            ]
        },
        {
            "id": "SCHOOLS",
            "title": "Schools",
            "dataPacks": [
                "NEWS"
            ]
        }
    ],
		"activated": true,
    "config": null
}
```javascript

## `GET` /site/:site/data_pack

<aside>
💡 **Params:**
?category (lista de ids, separados por comas, para filtrado)
?query (palabras clave, para filtrado)
?status (activated || deactivated || all)

</aside>

Devuelve la información de los data pack de un site concreto, incluyendo en cada item información de si está activado o desactivado para el site indicado, y la configuración específica para ese site.

El status se refiere a:

- `activated`: paquetes de datos que están asociados a ese site (por defecto).
- `deactivated`: paquetes de datos que NO están asociados a ese site.
- `all`: Todos los paquetes de datos, tanto asociados como no asociados al site. Equivale a llamar al endpoint `/data_pack`.

```json
{
    "totalItems": 1,
    "page": 1,
    "items": [
        {
            "id": "NEWS",
            "title": "News",
            "category": {
                "id": "ARTICLES_EVENTS",
                "label": "Articles & Events"
            },
            "description": "A description is needed for this data pack.",
            "image": "",
            "templates": [
                {
                    "id": "NewsDetail",
                    "title": "News Detail",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ],
            "modules": [
                {
                    "id": "NewsCard",
                    "title": "News Card",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                },
                {
                    "id": "NewsDistributor",
                    "title": "News Distributor",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ],
            "categories": [
                {
                    "id": "NEWS_AREAS",
                    "title": "News Areas",
                    "dataPacks": [
                        "NEWS"
                    ]
                },
                {
                    "id": "SCHOOLS",
                    "title": "Schools",
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ],
            "activated": false,
            "config": null
        }
    ]
}
```javascript

## `GET` /site/:site/templates

Devuelve un array con los templates de un site concreto en función de los templates públicos y los data packs activados.

```json
[
    {
        "id": "Error404",
        "title": "Error 404",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Error404",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Error404@2x"
        },
        "dataPacks": null
    },
    {
        "id": "BasicTemplate",
        "title": "Basic Template",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicTemplate-new",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicTemplate@2x-new"
        },
        "dataPacks": null
    },
    {
        "id": "NewsDetail",
        "title": "News Detail",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail@2x"
        },
        "dataPacks": [
            "NEWS"
        ]
    },
    {
        "id": "SitemapTemplate",
        "title": "Sitemap",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Sitemap",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Sitemap@2x"
        },
        "dataPacks": null
    }
]
```javascript

## `GET` /site/:site/modules

Devuelve un array con los módulos activados en un site concreto, en función de los módulos públicos y los módulos activados en data packs.

```json
[
    {
        "id": "ListCollapsed",
        "title": "List Collapsed",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/ListCollapsed",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/ListCollapsed@2x"
        },
        "dataPacks": null
    },
    {
        "id": "BluePanel",
        "title": "Blue Panel",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BluePanel",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BluePanel@2x"
        },
        "dataPacks": null
    },
    {
        "id": "SocialCard",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/SocialCard",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/SocialCard@2x"
        },
        "dataPacks": null
    },
    {
        "id": "HeroClaim",
        "title": "Hero Claim",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/HeroClaim",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/HeroClaim@2x"
        },
        "dataPacks": null
    },
    {
        "id": "DownloadCollection",
        "title": "Download Collection",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/DownloadCollection",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/DownloadCollection@2x"
        },
        "dataPacks": null
    },
    {
        "id": "DownloadDocument",
        "title": "Download Document",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/DownloadDocument",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/DownloadDocument@2x"
        },
        "dataPacks": null
    },
    {
        "id": "Intro",
        "title": "Intro Text",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Intro.png",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Intro@2x.png"
        },
        "dataPacks": null
    },
    {
        "id": "Accordion",
        "title": "Accordion",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Accordion",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Accordion@2x"
        },
        "dataPacks": null
    },
    {
        "id": "AccordionElement",
        "title": "Accordion Element",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/AccordionElement",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/AccordionElement@2x"
        },
        "dataPacks": null
    },
    {
        "id": "HorizontalTabElement",
        "title": "Horizontal Tab Element",
        "dataPacks": null
    },
    {
        "id": "VerticalTabElement",
        "title": "Vertical Tab Element",
        "dataPacks": null
    },
    {
        "id": "AddressCard",
        "title": "Address Card",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/AddressCard",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/AddressCard@2x"
        },
        "dataPacks": null
    },
    {
        "id": "AddressCollection",
        "title": "Address Collection",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/AddressCollection",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/AddressCollection@2x"
        },
        "dataPacks": null
    },
    {
        "id": "Advantage",
        "title": "Advantage",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Advantage",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/Advantage@2x"
        },
        "dataPacks": null
    },
    {
        "id": "BasicBoxedCard",
        "title": "Basic Boxed Card",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicBoxedCard",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicBoxedCard@2x"
        },
        "dataPacks": null
    },
    {
        "id": "BasicCard",
        "title": "Basic Card",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicCard",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicCard@2x"
        },
        "dataPacks": null
    },
    {
        "id": "BasicContent",
        "title": "Basic Content",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicContent",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicContent@2x"
        },
        "dataPacks": null
    },
    {
        "id": "BasicIconCard",
        "title": "Basic Icon Card",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicIconCard",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/BasicIconCard@2x"
        },
        "dataPacks": null
    },
    {
        "id": "CardCollection",
        "title": "Card Collection",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/CardCollection",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/CardCollection@2x"
        },
        "dataPacks": null
    },
    {
        "id": "CenteredPanel",
        "title": "Centered Panel",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/CenteredPanel",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/CenteredPanel@2x"
        },
        "dataPacks": null
    },
    {
        "id": "CypherCard",
        "title": "Cypher Card",
        "thumbnails": {
            "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/CypherCard",
            "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/CypherCard@2x"
        },
        "dataPacks": null
    }
]
```javascript

## `GET` /site/:site/structureddata

Devuelve un array con los datos estructurados de un site concreto en función de los data packs activados en ese site.

```json
[
    {
        "id": "NEWS_AREAS",
        "title": "News Areas",
        "dataPacks": [
            "NEWS"
        ],
        "local": true,
        "taxonomy": true,
        "fromPage": false,
        "translate": true,
        "schema": null,
        "clone": null,
    },
    {
        "id": "NEWS",
        "title": "News",
        "dataPacks": [
            "NEWS"
        ],
        "local": true,
        "taxonomy": false,
        "fromPage": true,
        "translate": false,
        "schema": {
            "templates": [
                "NewsDetail"
            ],
            "fields": [
                {
                    "key": "title",
                    "title": "Title",
                    "from": "title",
                    "type": "TextField"
                },
                {
                    "key": "abstract",
                    "title": "Abstract",
                    "from": "abstract",
                    "type": "TextField"
                },
                {
                    "key": "image",
                    "title": "Image",
                    "from": "image",
                    "type": "TextField"
                },
                {
                    "key": "categories",
                    "title": "Categories",
                    "from": "categories",
                    "type": "AsyncCheckGroup",
                    "source": "NEWS_AREAS"
                },
                {
                    "key": "schools",
                    "title": "Schools",
                    "from": "schools",
                    "type": "AsyncCheckGroup",
                    "source": "SCHOOLS"
                },
                {
                    "key": "lead",
                    "title": "Lead",
                    "from": "lead",
                    "type": "TextField"
                },
                {
                    "key": "longAbstract",
                    "title": "longAbstract",
                    "from": "longAbstract",
                    "type": "TextField"
                },
                {
                    "key": "content",
                    "title": "Content",
                    "from": "content",
                    "type": "TextField"
                },
                {
                    "key": "date",
                    "title": "Date",
                    "from": "date",
                    "type": "TextField"
                }
            ],
            "searchFrom": [
                "lead",
                "longAbstract",
                "content"
            ]
        },
        "clone": null,
        "defaults": null
    },
    {
        "id": "SCHOOLS",
        "title": "Schools",
        "dataPacks": [
            "NEWS"
        ],
        "local": false,
        "taxonomy": true,
        "fromPage": false,
        "translate": true,
        "schema": null,
        "clone": null,
        "defaults": null
    },
    {
        "id": "VIDEOS",
        "title": "Videos",
        "dataPacks": null,
        "local": true,
        "taxonomy": false,
        "fromPage": false,
        "translate": true,
        "schema": {
            "fields": [
                {
                    "key": "title",
                    "title": "Title",
                    "type": "TextField",
                    "mandatory": true
                },
                {
                    "key": "url",
                    "title": "Url Video",
                    "type": "TextField",
                    "mandatory": true
                },
                {
                    "key": "image",
                    "title": "Image",
                    "type": "ImageField",
                    "mandatory": true
                }
            ]
        },
        "clone": null
    }
]
```javascript

## `POST` /site/:site/data_pack/:id

Añade al site indicado el paquete de datos cuyo id (pueden ser varios, separados por comas) se indica. Devuelve el total de paquetes de datos asociados a ese site.

```json
{
    "totalItems": 1,
    "page": 1,
    "items": [
        {
            "id": "NEWS",
            "title": "News",
            "category": {
                "id": "ARTICLES_EVENTS",
                "label": "Articles & Events"
            },
            "description": "A description is needed for this data pack.",
            "image": "",
            "templates": [
                {
                    "id": "NewsDetail",
                    "title": "News Detail",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDetail@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ],
            "modules": [
                {
                    "id": "NewsCard",
                    "title": "News Card",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsCard@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                },
                {
                    "id": "NewsDistributor",
                    "title": "News Distributor",
                    "category": "articlesAndEvents",
                    "thumbnails": {
                        "1x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor",
                        "2x": "https://res.cloudinary.com/thesaurus-cms/image/upload/thumbnails/NewsDistributor@2x"
                    },
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ],
            "categories": [
                {
                    "id": "NEWS_AREAS",
                    "title": "News Areas",
                    "dataPacks": [
                        "NEWS"
                    ]
                },
                {
                    "id": "SCHOOLS",
                    "title": "Schools",
                    "dataPacks": [
                        "NEWS"
                    ]
                }
            ],
            "activated": false,
            "config": null
        }
    ]
}
```javascript

## `DELETE` /site/:site/data_pack/:id

<aside>
💡 **Params:**
?force ("1", "on" o "true" si queremos forzar el eliminado).

</aside>

Elimina del site indicado el paquete de datos señalado en la url.

Si no se indica el parámetro `?force={1 || on || true}` y el dataPack está en uso, devuelve un código de error 409.
El uso correcto es hacer la petición; si se recibe un código 200 es que todo fue ok, pero si se recibe un 409 hay que mostrar un aviso al usuario de que el paquete está en uso. Si el usuario confirma que quiere desactivarlo igualmente, se repite la petición con el `force=1`.

## `PUT` /site/:site/data_pack/:id

Añade al config de un data pack de un site concreto, un objeto de este tipo:

```json
{
    "defaultParent": 5,
    "modifiableOnPage": false,
    "indexDefault": true,
    "defaultTemplate": "templates",
		"import": [
			{
				"structuredData": "NEWS",
				"categories": [],
			}
		],
		"templates": {}
}
```javascript

Es importante que incluya solo elementos del tipo del ejemplo, si se añadiera alguna propiedad distinta, fallaría. Si hace falta añadir alguna, es bastante fácil de hacer (es añadir la propiedad en un array que tenemos en api).

La propiedad import es para indicar qué datos estructurados (deben ser globales y de página) vamos a importar a este site con esta configuración. Es un array de objetos (normalmente de un único elemento, pero pueden ser más, por ejemplo imagínate que unos cursos se dividen en dato MASTER y dato WEBINAR), donde decimos todos los datos estructurados a importar y por qué categorías filtrarlos. Si categories es un array vacío o null, se importarán todas las categorías.

## `GET` /site/:site/template/:template/config

<aside>
💡 Headers**:**
lang

</aside>

Devuelve la configuración de paquetes de datos aplicable a esa template, site e idioma.

```json
{
    "defaultParent": 636,
    "modifiableOnPage": true,
    "indexDefault": true
}
```
---

# Files

## `POST` /files

**🔑 Requiere autenticación.**

🚨 **Permisos**: mediaGallery.addImages

---

Endpoint para subir un fichero al S3. Requiere pasar el archivo con la key `file` en formato multipart/form.

- AÑADIDO PARA GRIDDO FILE DRIVE

Ahora además del `file` se le puede mandar el site y el folder en el que se crea el archivo. Para ello el endpoint estará esperando los siguientes valores: 

`site` : Id del site o ‘global’. Por defecto ‘global’

`folder`: Id del folder en el que se haye. Por defecto 0, lo cual es el root

Respuesta:

```json
{
    "id": 20,
    "site": null,
    "fileName": "pdf-test-uno.pdf",
    "url": "your-instance.griddo.io/pdf-test-uno.pdf",
    "sizeBytes": 20597,
    "documentTitle": "",
    "alternativeText": "",
    "uploadDate": "2023-10-04T08:26:19.000Z",
    "fieldType": "file",
    "contentInUse": [
        {
            "contentId": 6806,
            "contentType": "structuredData"
        }
    ],
    "fileType": "pdf",
    "tags": [
        "cebolla"
    ],
    "folder": null
}
```javascript

# Pasar información de archivos en las páginas

Al guardar una página, en el objeto de tipo `fieldType="file"`, puedes estar pasando un fichero interno o un fichero externo. En el caso de ser un fichero externo será un componente URLField.

- Fichero interno: Fichero que hemos gestionado su upload (con el POST /files) y está en nuestra galería de ficheros. Se distingue porque tiene id. Al recibir la info de un fichero interno, lo que hacemos es:
    1. Actualizar la info de ese archivo con el alternativeText y documentTitle que se nos facilita.
    2. Guardar la referencia de que ese es el fichero con el id indicado.

Ejemplo de fichero interno:

```json
{
    "component": "File",
    "file": {
        "alternativeText": "",
        "documentTitle": "",
        "fieldType": "file",
        "id": 3
    },
    "documentTitle": "",
    "alternativeText": ""
}                 
```javascript

IMPORTANTE: Si es externo no puede llevar id. Si es interno, la url va a ser ignorada. Por tanto, si el usuario cambia de fichero interno a externo o viceversa, hay que tener cuidado de eliminar o no el id de las propiedades.

# Recibir información de archivos en las páginas

Al hacer un get de una página, todos los objetos de archivo lo vamos a recibir de esta manera:

- Si es un fichero interno: El mismo objeto que nos está devolviendo el POST /files.

---

## `PUT` /files/:fileId

Funciona de manera similar a las imágenes. Una vez subida un file a la base de datos podremos editar con este endpoint el título, la descripción alternativa y añadirle tags a un file concreto que le pases en el `fileId`. Para ello estará esperando el siguiente body

```json
Endpoint. PUT/file/1
Body. 
{
    "title": "Segunda prueba file drive title",
    "alt": "Segunda prueba file drive alternative Text",
    "tags": ["primera", "prueba"]
}
```javascript

## `PUT` /files/:fileId/folder/:folderId

Mueve un file concreto, marcado por su id, a una carpeta concreta, marcada por su folderId.

## `PUT` /files/bulk/folder/:folderId

```json
{
	"ids": [34, 44, 1]
}
```javascript

Mueve un conjunto de files marcado por su ids, a una carpeta concreta, marcada por su folderId.

## `POST` /folder

Crea una nueva carpeta. Para ello espera un body de esta manera

```json
{
    "folderName": "carpeta11",
    "parentId": 3,
    "site": 51
}
```javascript

- `folderName` El nombre que le quieras poner a la carpeta.
- `parentId` Opcional. El id del parent folder. Si estableces un id, esta nueva carpeta se creará dentro de la carpeta correspondiente. En caso contrario se tratará como si esta carpeta estuviera en el root del arbol de carpetas.
- `site` Obligatorio. Acepta ids de site o “global”. Con esta propiedad sabemos si la carpeta será creada en site o en global.

## `PUT` /folder/:folderId

Para editar la información de una carpeta concreta. El body que estará esperando será el siguiente:

```json
{
    "parentId": 5,
    "folderName": "carpeta5"
}
```javascript

- `folderName` El nombre por el que quieres editar la carpeta
- `parentId` Opcional. El id del parent folder. Si cambias el id por uno diferente del que tenía, este folder se moverá al nuevo folder junto con todos los files y childrens que estuvieran dentro.

## `GET` /files/:fileId

Te devuelve la información de un file en concreto definido por su id. 

```json
{
    "id": 1,
    "site": 86,
    "url": "your-instance.griddo.io/2021f0049.pdf",
    "sizeBytes": 47290,
    "documentTitle": "Segunda prueba file drive title",
    "alternativeText": "Segunda prueba file drive alternative Text",
    "uploadDate": "2021-05-13T11:39:58.000Z",
    "fieldType": "file",
    "fileType": "pdf",
    "contentInUse": [
        {
            "contentId": 6806,
            "contentType": "structuredData"
        }
    ],
    "tags": [
        "primera",
        "prueba"
    ],
    "folder": {
        "folderId": 1,
        "folderName": "carpeta1",
        "folderParentId": 0
    }
}
```javascript

Entre los añadidos nuevos encontraremos las siguiente propiedades:

- `fileType` El tipo de archivo (pdf, word, excel…)
- `tags` El array de tags que le hayas añadido a ese file
- `folder` Un objeto con toda la información del folder en el que esté.
- `site` El site al que pertenece.
- `contentInUse` Será un array de objetos con información de dónde se está usando este archivo concreto. Cada objeto tendrá las propiedades *contentId* y el *contentType* que serán el tipo de contenido en donde se está usando ‘structuredData’ para datos estructurados simples o ‘page’ para páginas y su id correspondiente.

## `GET` /site/:site/files

Listado de files en un site. Por `site` acepta tanto “global” como el id de un site. Devuelve un array de objetos con los files que estén en ese site concreto.

```json
Endpoint. GET /site/86/files

[
    {
        "id": 1,
        "site": 86,
        "url": "your-instance.griddo.io/2021f0049.pdf",
        "sizeBytes": 47290,
        "documentTitle": "Segunda prueba file drive title",
        "alternativeText": "Segunda prueba file drive alternative Text",
        "uploadDate": "2021-05-13T11:39:58.000Z",
        "fieldType": "file",
        "fileType": "pdf",
        "tags": [
            "primera",
            "prueba"
        ],
        "folder": {
            "folderId": 1,
            "folderName": "carpeta1",
            "folderParentId": 0
        }
    }, {...}, ...
]
```javascript

## `GET` /site/:site/folders/

```bash
query
	folder,
	search,
	filterType
	order,
	filterUsage
```javascript

Con esta llamada recibirás la información de los `files` y los `folders` de un site en concreto que definamos en `:site` Acepta ids numéricos y también la string “global” para los datos globales.

Queries

- `folder` el id del folder. Al especificarlo, viajaremos por las carpetas, de manera que tendrás la información dentro de ese folder que especifiques en el site concreto. Si no especificas nada, por defecto te generará la info del `root` .
- `search` Término o términos por los que buscar en site en concreto. Puedes pasar una string o varias strings separadas por comas, ej `?search=guide,student` Si además de esto también estableces los parámetros `filterType` y `order` los ordenará siguiendo los resultados que devuelve el search.
- `filterType` El tipo de archivo por el que quieras filtrar los resultados, como pdf, word, xslx… Se pueden añadir varios tipos separados por comas (ej `?filterType=pdf,zip,docx`) o poner `all`  para que te devuelva todo. Si no se especifica por defecto te devolverá todos los elementos.
- `order` Ordena los elementos de acuerdo a los siguientes parámetros
    - name-ASC || name-DESC
    - date-ASC || date-DESC
    - size-ASC || size-DESC
    
    Salvo size, name y date ordenará tanto los files como las carpetas
    
- `filterUsage` Solo acepta dos valores `used`  que te devolverá los archivos que están siendo usados y `unused` que devolverá los que no están siendo usados. Si no lo estableces te mandará todos sin distinguir entre usados y no usados.

**AÑADIDO CONTENT IN USE**

A esta respuesta se añadirá la propiedad contentInUse, la cual será un objeto con las propiedades `pages` , `simpleStructuredData` y `globalPages` las cuales serán arrays de objetos.

En el caso de pages traerá los sites y dentro de esos sites las páginas donde se esté usando esa file concreta. Tendrá por tanto el siguiente formato:

```json
"contentInUse": {
                    "pages": [
                        {
                            "siteId": 89,
                            "siteName": "Alvaro Testeando",
                            "pages": [
                                {
                                    "id": 1692,
                                    "title": "Tercera Página de Contenidosd",
                                    "published": "2022-12-02T11:00:29.000Z",
                                    "modified": "2024-02-13T10:54:03.000Z"
                                },
                                {
                                    "id": 16851,
                                    "title": "Nuevo comienzo para Felizonia",
                                    "published": "2023-07-05T07:29:02.000Z",
                                    "modified": "2024-01-31T14:42:09.000Z"
                                }
                            ]
                        }
                    ],
                    "structuredData": [],
                    "globalPages": [],
                },
```javascript

En el caso de `simpleStructuredData`  en el caso de que ese file se esté usando en un dato estructurado simple, devolverá un array con el siguiente formato:

```json
"contentInUse": {
                    "pages": [],
                    "globalPages": [],
                    "simpleStructuredData": [
                        {
                            "id": 51418,
                            "title": "A study with PDF"
                        }
                    ]
                },
```javascript

En el caso de `globalPages` nos mostrará las páginas globales en donde se están utilizando este archivo en concreto, devolverá un array con este formato:

```tsx
"contentInUse": {
                    "pages": [],
                    "globalPages": [
                        {
                            "id": 17095,
                            "title": "Alvaro Test",
                            "published": "2023-07-05T07:29:02.000Z",
                            "structuredDataId": "EVENTS"
                        }
                    ],
                    "simpleStructuredData": []
                },
```javascript

La respuesta completa será la siguiente:

```json
Endpoint. GET /site/89/folders?folder=7

Respuesta
{
    "files": {
        "totalItems": 2,
        "items": [
            {
                "id": 502,
                "site": 89,
                "fileName": "sobao.pdf",
                "url": "your-instance.griddo.io/sobao.pdf",
                "sizeBytes": 74070,
                "title": "",
                "alt": "",
                "uploadDate": "2024-01-31T11:12:20.000Z",
                "fieldType": "file",
                "contentInUse": {
                    "pages": [
                        {
                            "siteId": 89,
                            "siteName": "Alvaro Testeando",
                            "pages": [
                                {
                                    "id": 1692,
                                    "title": "Tercera Página de Contenidosd",
                                    "published": "2022-12-02T11:00:29.000Z",
                                    "modified": "2024-02-13T10:54:03.000Z"
                                },
                                {
                                    "id": 16851,
                                    "title": "Nuevo comienzo para Felizonia",
                                    "published": "2023-07-05T07:29:02.000Z",
                                    "modified": "2024-01-31T14:42:09.000Z"
                                }
                            ]
                        }
                    ],
                    "globalPages": [
                        {
                            "id": 17095,
                            "title": "Alvaro Test",
                            "published": "2023-07-05T07:29:02.000Z",
                            "structuredDataId": "EVENTS"
                        }
                    ],
                    "simpleStructuredData": []
                },
                "fileType": "pdf",
                "tags": [],
                "folder": null
            },
            {
                "id": 383,
                "site": 89,
                "fileName": "resultados-semestre(2).pdf",
                "url": "your-instance.griddo.io/resultados-semestre(2).pdf",
                "sizeBytes": 20597,
                "title": "",
                "alt": "",
                "uploadDate": "2024-01-22T16:24:02.000Z",
                "fieldType": "file",
                "contentInUse": {
                    "pages": [
                        {
                            "siteId": 89,
                            "siteName": "Alvaro Testeando",
                            "pages": [
                                {
                                    "id": 1684,
                                    "title": "Home Page Principal",
                                    "published": "2022-12-02T08:19:27.000Z",
                                    "modified": "2024-02-01T11:56:49.000Z"
                                }
                            ]
                        }
                    ],
                    "structuredData": [
                        {
                            "id": 51418,
                            "title": "A study with PDF"
                        }
                    ]
                },
                "fileType": "pdf",
                "tags": [],
                "folder": null
            }
        ]
    },
    "folders": [
        {
            "id": 211,
            "folderName": "Piña",
            "parentId": 0,
            "site": 89
        }
    ]
}
```javascript

Te devolverá un objeto con dos objetos `files` y `folders`

- Files: Representa los files que están en el root. Será un objeto que te traiga el `totalItems` con el total de files que hay en el root un array de objetos llamado `items`con la información breve de cada uno.
- Folders: El listado de carpetas dentro de esa carpeta y en ese site.

## `GET` /site/:site/folders/tree

Con este endpoint recibirás el listado de carpetas en formato árbol con su nombre y su id y sus carpetas anidadas.

```json
[
    {
        "id": 7,
        "name": "capeta7",
        "childrens": [
            {
                "id": 3,
                "name": "carpeta5",
                "childrens": [
										{
												"id": 2,
				                "name": "carpeta2",
				                "childrens": []
										}
								]
            },
            {
                "id": 8,
                "name": "capeta8",
                "childrens": []
            }
        ]
    }
]
```javascript

## `GET` /folder/:folderId

Te devuelve la información de un folder en concreto y también la información de sus childrens

```json
Endpoint. GET /folder/:folderId
Respuesta
{
    "id": 7,
    "name": "capeta7",
    "files": {
        "totalItems": 1,
        "items": [
            {
                "id": 6,
                "fileName": "la-despensa-molar(1).pdf",
                "sizeBytes": "1288773",
                "uploadDate": "2021-05-13 18:39:34",
                "fileType": "pdf"
            }
        ]
    },
    "childrens": [
        {
            "id": 3,
            "name": "carpeta5",
            "files": {
                "totalItems": 0,
                "items": []
            },
            "childrens": [
                {
                    "id": 4,
                    "name": "carpeta4",
                    "files": {
                        "totalItems": 0,
                        "items": []
                    },
                    "childrens": []
                },
                {
                    "id": 6,
                    "name": "carpeta6",
                    "files": {
                        "totalItems": 0,
                        "items": []
                    },
                    "childrens": []
                }
            ]
        },
        {
            "id": 8,
            "name": "capeta8",
            "files": {
                "totalItems": 1,
                "items": [
                    {
                        "id": 3,
                        "fileName": "p1-amazingmarteu2(1).xlsx",
                        "sizeBytes": "650795",
                        "uploadDate": "2021-05-13 18:33:04",
                        "fileType": "xlsx"
                    }
                ]
            },
            "childrens": []
        }
    ]
}
```javascript

## `DELETE` /folders/:folderId

Borra una carpeta concreta.

**ATENCIÓN!!** Además de borrarse una carpeta concreta se borrarán todos sus contenidos, es decir todos los archivos y carpetas anidadas en ella.

## `DELETE` /files/:fileId

Borra un file concreto. No se puede revertir.

## `DELETE` /files/bulk

```json
{
	"ids": [12, 3, 44]
}
```javascript

Borra unas files concretas marcadas por sus ids. No se puede revertir.

## `PUT` /files/:fileId/replace

```bash
query
	keepUrl('on' || 'off')
```javascript

Con este endpoint cambiaremos un file concreto que estableceremos en el fileId por otro que mandaremos.

Por tanto este endpoint también espera que le llegue el nuevo file por el que se cambiará el ya presente.

Junto a ello también se le puede añadir una query `keepUrl` para establecer si queremos que se mantenga el mismo url o no. En caso de que no, se actualizará en todas las páginas y datos estructurados en el que se esté usando.

## `POST` /files/download/:files

```bash
query
	zip('on' || 'off')
```javascript

Con este endpoint te descargas un archivo de los que estén almacenados en el s3 a través de su id o varios archivos separando sus ids por comas. Para esta descarga hay dos opciones:

- Si lo que quieres es un solo archivo, puedes decidir descargarlo tal cual o en un zip añadiendo la query `zip=on` . Ejemplo, **`POST`/files/download/69?zip=on**
- Si quieres varios archivos, necesariamente tendrás que convertirlos en un zip, por lo que es obligatorio añadir el `zip=on` Ejemplo, **`POST`/files/download/69,67,102?zip=on**
---

# Folders

## `POST` /folders

 Endpoint para crear una nueva carpeta, acepta los siguientes parámetros en el body:

**Body**

- `type` : El tipo de folder que quieres crear, de momento acepta solo `"*images*" **| **"*files*"` (La opción de files aún no está activada).
- `folderName`: (string) El título que le damos a la carpeta.
- `site` : (number | null) El id del site donde quieres crear la carpeta o null si quieres crearla en global.
- `parentId` : (number | null) El id de la carpeta en donde quieras crear la carpeta o null, si la quieres crear en el root.

Como respuesta retorna la carpeta ya creada.

## `PUT` /folders/:id

Para editar los datos de una carpeta

**Params**

- `id`  (number) El id de la carpeta que quieres editar

**Body**

- `folderName` El nombre por el que quieres editar la carpeta
- `parentId` Opcional. El id del parent folder. Si cambias el id por uno diferente del que tenía, este folder se moverá al nuevo folder junto con todos los files y childrens que estuvieran dentro.

## `DELETE` /folders/:id/type/:type

Endpoint para borrar una carpeta concreta de un tipo concreto.

Ahora mismo solo soporta `type: “images”` pero a medida de que se añadan más localizaciones donde se vayan a añadir carpetas se irán añadiendo los types
---

# Images

## `GET` /images

**🔑 Requiere autenticación.**

<aside>
💡 **Params:**
?page
?itemsPerPage
?pagination (true/false)
?thumbWidth (ancho de la imagen thumbnail; 215 por defecto)
?thumbHeight (alto de la imagen thumbnail; 161 por defecto)

?order=(date-DESC || date-ASC || title-DESC || title-ASC || size-ASC || size-DESC || name-ASC || name-DESC); por defecto date-DESC.

?orientation=(landscape || portrait || square || all); por defecto all.
?query (búsqueda a realizar por title, name o tags).

?format=(all || bitmap || vectorial)

</aside>

Devuelve un array con todas las imágenes disponibles.

Puedes filtrar por el formato de la imágen, con vectorial te devolverá los .svg, con bitmap los que el original no sea svg y con all todas las imágenes (por defecto ‘all’).

```json
{
    "totalItems": 48,
    "items": [
        {
            "id": 84,
            "name": "BS avatar.svg",
            "title": "",
            "description": "",
            "alt": "",
            "tags": "",
            "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1603895477/thesaurus-dev/bs-avatar-5f9980b4ea567.svg",
            "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill,g_auto/v1603895477/thesaurus-dev/bs-avatar-5f9980b4ea567.svg",
            "publicId": "thesaurus-dev/bs-avatar-5f9980b4ea567",
            "published": "2020-10-28T14:31:17Z",
            "size": 1217,
            "width": 48,
            "height": 48,
						"orientation": "S",
						"site": "global"
        },
        {
            "id": 82,
            "name": "imgStandard.jpg",
            "title": null,
            "description": null,
            "alt": null,
            "tags": null,
            "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1603877646/thesaurus-dev/imgStandard_f7e8784d-dd24-4277-86ad-a09330ca20f0.jpg",
            "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill,g_auto/v1603877646/thesaurus-dev/imgStandard_f7e8784d-dd24-4277-86ad-a09330ca20f0.jpg",
            "publicId": "thesaurus-dev/imgStandard_f7e8784d-dd24-4277-86ad-a09330ca20f0",
            "published": "2020-10-28T09:34:06Z",
            "size": 31234,
            "width": 740,
            "height": 480,
						"orientation": "L",
						"site": "global"
        },
        {
            "id": 81,
            "name": "imgStandard.jpg",
            "title": null,
            "description": null,
            "alt": null,
            "tags": null,
            "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1603875615/thesaurus-dev/imgStandard_0eece270-b394-4e2d-94ab-21d1bcbcd6ca.jpg",
            "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill,g_auto/v1603875615/thesaurus-dev/imgStandard_0eece270-b394-4e2d-94ab-21d1bcbcd6ca.jpg",
            "publicId": "thesaurus-dev/imgStandard_0eece270-b394-4e2d-94ab-21d1bcbcd6ca",
            "published": "2020-10-28T09:00:15Z",
            "size": 31234,
            "width": 740,
            "height": 480,
						"orientation": "L",
						"site": "global"
        },
        {
            "id": 80,
            "name": "imgStandard.jpg",
            "title": null,
            "description": null,
            "alt": null,
            "tags": null,
            "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1603875596/thesaurus-dev/imgStandard_c8d59fb8-cb19-4f57-a21d-27211fac5611.jpg",
            "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill,g_auto/v1603875596/thesaurus-dev/imgStandard_c8d59fb8-cb19-4f57-a21d-27211fac5611.jpg",
            "publicId": "thesaurus-dev/imgStandard_c8d59fb8-cb19-4f57-a21d-27211fac5611",
            "published": "2020-10-28T08:59:56Z",
            "size": 31234,
            "width": 740,
            "height": 480,
						"orientation": "L",
						"site": "global"
        },
        {
            "id": 79,
            "name": "imgStandard.jpg",
            "title": null,
            "description": null,
            "alt": null,
            "tags": null,
            "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1603875583/thesaurus-dev/imgStandard_081fcefc-f1b2-4270-965f-a4c93fb42f8c.jpg",
            "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill,g_auto/v1603875583/thesaurus-dev/imgStandard_081fcefc-f1b2-4270-965f-a4c93fb42f8c.jpg",
            "publicId": "thesaurus-dev/imgStandard_081fcefc-f1b2-4270-965f-a4c93fb42f8c",
            "published": "2020-10-28T08:59:43Z",
            "size": 31234,
            "width": 740,
            "height": 480,
						"orientation": "L",
						"site": "global"
        }
   ]
}
```javascript

## `GET` /image/:imageId

**🔑 Requiere autenticación.**

<aside>
💡 **Params:**
?thumbWidth (ancho de la imagen thumbnail; 215 por defecto)
?thumbHeight (alto de la imagen thumbnail; 161 por defecto)

</aside>

Devuelve un objeto con la información de la imagen solicitada.

Desde el añadido de la galería de imágenes, esta ruta también devolverá la propiedad relatedPages que será un array de objetos con las propiedades siteId, siteName, pageId y pageTitle de cada página en dónde se esté usando esa imagen.

```json
{
    "id": 84,
    "name": "BS avatar.svg",
    "title": "",
    "description": "",
    "alt": "",
    "tags": "",
    "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1603895477/thesaurus-dev/bs-avatar-5f9980b4ea567.svg",
    "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill,g_auto/v1603895477/thesaurus-dev/bs-avatar-5f9980b4ea567.svg",
    "publicId": "thesaurus-dev/bs-avatar-5f9980b4ea567",
    "published": "2020-10-28T14:31:17Z",
    "size": 1217,
    "width": 48,
    "height": 48,
		"orientation": "S",
    "site": "global",
		"position": "center",
		"relatedPages": [
        {
            "pageId": 2422,
            "siteId": 86,
            "pageTitle": "Página de Prueba",
            "siteName": "Site de Test"
        }
		]
}
```javascript

## `POST` /images

**🔑 Requiere autenticación.**

🚨 **Permisos**: mediaGallery.addImages, mediaGallery.addGlobalImages

Guarda en el DAM y en la base de datos una imagen remitida desde AX, quedando disponible para otros usos en la galería y en Froala.

Recibe un archivo con el name `file` de un formulario multipart. 

AÑADIDO MODAL DE IMAGENES: Ahora en el body recibirá la propiedad `site` con el id del site al que pertenezca la imagen en caso de que sea una imagen de site, o `'global'` en el caso de que sea una imagen global.

La propiedad `tags` puede ser o bien un array con las tags separadas por comas o null.

También podrá recibir la propiedad `setAsGlobal` como booleano que indicará si queremos crear una copia de una imagen de site para hacerla global.

Devuelve un objeto con la info de la imagen ya subida al DAM con este formato:

```json
{
    "id": 84,
    "name": "BS avatar.svg",
    "title": "",
    "description": "",
    "alt": "",
    "tags": "",
    "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1603895477/thesaurus-dev/bs-avatar-5f9980b4ea567.svg",
    "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill,g_auto/v1603895477/thesaurus-dev/bs-avatar-5f9980b4ea567.svg",
    "publicId": "thesaurus-dev/bs-avatar-5f9980b4ea567",
    "published": "2020-10-28T14:31:17Z",
    "size": 1217,
    "width": 48,
    "height": 48
}
```javascript

## `PUT` /image/:imageId

**🔑 Requiere autenticación.**

🚨 **Permisos**: mediaGallery.editImages, mediaGallery.editGlobalImages

Actualiza en la base de datos los datos de la imagen pasada.

```json
{
    "title": "título",
    "description": "descripción",
    "alt": "texto alternativo",
    "tags": "",
		"position": "center",
}
```javascript

## `GET` /images/wysiwyg

**🔑 Requiere autenticación.**

<aside>
💡 **Params:**
?thumbWidth (ancho de la imagen thumbnail; 215 por defecto)
?thumbHeight (alto de la imagen thumbnail; 161 por defecto)

</aside>

Devuelve un array en el formato que requiere Froala con todas las imágenes disponibles.

```json
[
    {
        "name": "Screenshot 2020-09-10 at 12.35.04.png",
        "title": "",
        "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1599734114/thesaurus-dbtest/screenshot-2020-09-10-at-123504-5f5a015fa9ab2.png",
        "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill/v1599734114/thesaurus-dbtest/screenshot-2020-09-10-at-123504-5f5a015fa9ab2.png",
        "alt": "",
        "description": "",
        "tag": "",
        "publicId": "thesaurus-dbtest/screenshot-2020-09-10-at-123504-5f5a015fa9ab2"
    },
    {
        "name": "Screen Shot 2020-09-15 at 12.04.50.png",
        "title": "",
        "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1600164309/thesaurus-dev/screen-shot-2020-09-15-at-120450-5f6091d3dd933.png",
        "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill/v1600164309/thesaurus-dev/screen-shot-2020-09-15-at-120450-5f6091d3dd933.png",
        "alt": "",
        "description": "",
        "tag": "",
        "publicId": "thesaurus-dev/screen-shot-2020-09-15-at-120450-5f6091d3dd933"
    },
    {
        "name": "ie-scholarships-kistefos.jpg",
        "title": "",
        "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1600241317/thesaurus-dev/ie-scholarships-kistefos-5f61bea3cbd4b.jpg",
        "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill/v1600241317/thesaurus-dev/ie-scholarships-kistefos-5f61bea3cbd4b.jpg",
        "alt": "",
        "description": "",
        "tag": "",
        "publicId": "thesaurus-dev/ie-scholarships-kistefos-5f61bea3cbd4b"
    },
    {
        "name": "unnamed.jpg",
        "title": "",
        "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1600254491/thesaurus-dev/unnamed-5f61f21a9c8e7.jpg",
        "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill/v1600254491/thesaurus-dev/unnamed-5f61f21a9c8e7.jpg",
        "alt": "",
        "description": "",
        "tag": "",
        "publicId": "thesaurus-dev/unnamed-5f61f21a9c8e7"
    },
    {
        "name": "wp2324446.jpg",
        "title": "",
        "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1600254616/thesaurus-dev/wp2324446-5f61f2970c46c.jpg",
        "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill/v1600254616/thesaurus-dev/wp2324446-5f61f2970c46c.jpg",
        "alt": "",
        "description": "",
        "tag": "",
        "publicId": "thesaurus-dev/wp2324446-5f61f2970c46c"
    }
]
```javascript

## `POST` /images/wysiwyg

**🔑 Requiere autenticación.**

🚨 **Permisos**: mediaGallery.addImages, mediaGallery.addGlobalImages

Guarda en Cloudinary y en la base de datos una imagen remitida desde Froala, quedando disponible para otros usos en la galería y en Froala.

Recibe un archivo con el name `file` de un formulario multipart. 

Devuelve la url de la imagen ya subida a Cloudinary con este formato:

```json
{
	"link": "https://........"
}
```javascript

## `DELETE` /image/:imageId

**🔑 Requiere autenticación.**

🚨 **Permisos**: mediaGallery.deleteImages, mediaGallery.deleteGlobalImages

Marca como borrada una imagen en BDD

## `GET` /site/:site/images

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites

Devuelve las imágenes asociadas a un site concreto.

```jsx
{
    "totalItems": 5,
    "items": [
        {
            "id": 991,
            "name": "anchoa2.jpeg",
            "title": "",
            "description": "",
            "alt": "",
            "tags": [],
            "url": "your-instance.griddo.io/anchoa2_58",
            "thumb": "your-instance.griddo.io/w/215/h/161/anchoa2_58",
            "publicId": "thesaurus-dev/anchoa2_c8a1c03a-edc2-4483-a2fb-f62d121760f4",
            "damId": "anchoa2_58",
            "published": "2022-06-27T11:41:46.239Z",
            "size": 22193,
            "width": 624,
            "height": 368,
            "orientation": "L",
            "site": 86,
						"position": "center",
        },
(....)
	]
}
```javascript

## `GET` /images/:image/inuse

Con este endpoint sabremos donde está siendo usada una imagen a través de su id.

Puede ser utilizada tanto en una página, como en un dato estructurado de tipo simple o en las settings de un site. Por ello la respuesta será la siguiente.

```json
{
    "structuredData": [
        {
            "id": 6922,
            "title": "Camon Pípol!",
            "published": "2023-11-29T15:38:18.000Z",
            "modified": "2023-11-29T15:38:18.000Z"
        }
    ],
    "pages": [
        {
            "id": 3359,
            "title": "Peter Parker",
            "siteId": null,
            "siteName": null,
            "published": "2022-01-19T10:20:04.000Z",
            "modified": "2023-11-21T16:27:00.000Z"
        },
        {
            "id": 3360,
            "title": "Peter Parker",
            "siteId": 84,
            "siteName": "QA Mai",
            "published": "2022-01-19T10:21:34.000Z",
            "modified": "2023-11-21T16:27:01.000Z"
        },
        {
            "id": 3613,
            "title": "Peter Parker",
            "siteId": 113,
            "siteName": "Fer Site",
            "published": "2022-02-28T15:13:42.000Z",
            "modified": "2023-11-21T16:27:01.000Z"
        }
    ],
    "siteInfo": [
        {
            "id": 3037,
            "name": "Site de Prueba image in use",
            "published": "2023-11-29T14:10:09.000Z",
            "modified": "2023-11-29T14:21:04.000Z"
        }
    ]
}
```javascript

En caso de que no esté siendo utilizada en ningún sitio la respuesta será esta:

```json
{
    "structuredData": [],
    "pages": [],
    "siteInfo": []
}
```javascript

## `PUT` /image/:id/replace

Con este endpoint podemos reemplazar una imagen existente por otra nueva. El funcionamiento es el mismo que cuando subimos una imagen, solo que en este caso en lugar de crear una nueva, reemplaza la que estamos estableciendo en el `/:id/` 

Además de pasarle el `file` hay que pasarle el site y el setAsGlobal como en el `post`/images

## `POST` /thumbnail/contentId/:contentId/contentType/:contentType

Con este endpoint podremos subir una imagen de un thumbnail y adjuntarlo a un contenido. Para ello necesitaremos especificar lo siguiente:

Params

- `contentId`: id numérico del contenido al que corresponde el thumbnail.
- `contentType`: Tipo de contenido. Ahora mismo solo acepta `form` y `navigation`

Body

- `file` : La imagen de la captura de pantalla que quieres subir como thumbnail. La manera de subirla se hará de la misma forma que cualquier imagen.

---

## `GET` /images/site/:site/folder

Para recuperar las imágenes y los folders de un site concreto.

**Params**

---

- `site`: (number | “global”) Puede ser o el id del site o la string “global” para las imágenes globales.

**Query**

---

- `thumbWidth`: (number **| *undefined*) Ancho de la imagen thumbnail; 215 por defecto.
- `thumbHeight`: (number **| *undefined*) Alto de la imagen thumbnail; 161 por defecto.
- `folder`: (number | *undefined*) Id del folder en el que quieras consultar las imágenes y folders.
- `search`: (string **| *undefined*) Términos a buscar separados por coma. Los buscará sobre el título, el name de la imagen o los tags.
- `order`: (date-DESC || date-ASC || title-DESC || title-ASC || size-ASC || size-DESC || name-ASC || name-DESC); por defecto date-DESC
- `orientation`: (landscape || portrait || square || all); por defecto all.
- `format`: (all || bitmap || vectorial)
- `usage`: *(*'*used*' **| **'*unused*') Filtra los resultados por aquellos que están o no están siendo usados;
- `pagination` (boolean) Encargado de marcar si quieres los resultado paginados o no. Por defecto será `false` Junto con pagination hay que definir también:
    - `page` (number) El número de página en el que estás. Por defecto 1
    - `itemsPerPage` (number) Cuanto items quieres mostrar por página. Por defecto 50

**Ejemplo de respuesta**

```tsx
{
    "folders": [
        {
            "id": 1,
            "title": "folder 1",
            "parentId": null,
            "site": 1
        },
        {
            "id": 4,
            "title": "folder 4",
            "parentId": null,
            "site": 1
        }
    ],
    "images": [
        {
            "id": 8,
            "alt": "A red cartoon character with wide eyes and an open mouth, set against a dramatic fiery background.",
            "description": "A red cartoon character with wide eyes and an open mouth, set against a dramatic fiery background.",
            "height": 168,
            "name": "elmohell.jpeg",
            "published": "2025-05-23T11:11:31.971Z",
            "site": 1,
            "size": 5352,
            "tags": [
                "cartoon",
                "character",
                "red",
                "fire",
                "dramatic"
            ],
            "title": "elmohell_2",
            "width": 300,
            "folderId": null,
            "damId": "elmohell_2",
            "orientation": "L",
            "publicId": null,
            "url": "your-instance.griddo.io/elmohell_2",
            "thumb": "your-instance.griddo.io/w/215/h/161/elmohell_2"
        },
        {
            "id": 7,
            "alt": "",
            "description": "",
            "height": 223,
            "name": "vengadores.svg",
            "published": "2025-05-23T10:49:38.057Z",
            "site": 1,
            "size": 2539,
            "tags": [
                "tortilla"
            ],
            "title": "vengadores",
            "width": 191,
            "folderId": null,
            "damId": "vengadores_1",
            "orientation": "P",
            "publicId": null,
            "url": "your-instance.griddo.io/vengadores_1",
            "thumb": "your-instance.griddo.io/w/215/h/161/vengadores_1"
        }
    ]
}
```javascript

## `GET` /images/site/:site/folder/tree

Endpoint para recuperar el árbol de carpetas de un site en concreto.

**Params**

- `site`: (number **| **'*global*')

Ejemplo de respuesta

```tsx
[
    {
        "id": 1,
        "name": "folder 1",
        "children": [
            {
                "id": 3,
                "name": "folder 3",
                "children": []
            },
            {
                "id": 5,
                "name": "verde",
                "children": []
            }
        ]
    },
    {
        "id": 4,
        "name": "folder 4",
        "children": []
    }
]
```javascript

## `GET` /image/:id/inuse/

Endpoint para recuperar en dónde se está usando una imagen.

**Params**

- id (number) id numérico de la imagen de la que queremos saber dónde se está usando

Ejemplo de respuesta

```tsx
{
    "sites": [
        {
            "id": 4,
            "title": "HISCO MK I",
            "pages": [
                {
                    "id": 1,
                    "title": "Pag 4",
                    "structuredData": null,
                    "date": "2025-05-21T10:39:38.000Z"
                },
                {
                    "id": 2,
                    "title": "Pag 3",
                    "structuredData": null,
                    "date": "2025-05-21T10:41:15.000Z"
                }
            ]
        }
    ],
    "globalPages": [],
    "simpleData": [
        {
            "id": 4,
            "title": "QA Local No Translate Simple Data",
            "structuredData": {
                "title": "QA Local No Translate Simple Data",
                "id": "QA_LOCAL_NO_TRANSLATE_SIMPLE_DATA"
            },
            "date": "2025-06-10T13:55:15.000Z"
        }
    ]
}
```javascript

## `PUT` /image/:imageId/folder/:folderId

Endpoint para añadir una imagen a una carpeta concreta

**Params**

- `imageId` : Id de la imagen que quieres mover
- `folderId` : Id del folder al que quieres mover a imagen. Acepta `"root"`  si quieres mover la imagen al root o el id del folder.

## `PUT` /image/bulk/folder/:folderId

Endpoint para añadir varias imágenes a una carpeta concreta.

**Params**

- `folderId` : Id del folder al que quieres mover a imagen. Acepta `"root"`  si quieres mover la imagen al root o el id del folder.

**Body**

- `ids` : Array de ids de imágenes que quieres mover

## `POST` /image/downloads/:imagesId

Descargamos la imagen pasándole el id por parámetros

**Params**

---

- `imagesId`: Puedes descargar bien una única imagen especificada por su imageId o varias separadas por comas. Ej, `POST`/image/downloads/1,2,3

**Query**

---

- `zip`: (’on’ **| ‘off’) Para especificar si quieres descargar las imágenes en ZIP. Si son varias imágenes es obligatorio hacer zip de las imágenes.

## `PUT` /image/:id/replace

Con este endpoint podemos reemplazar una imagen existente por otra nueva. El funcionamiento es el mismo que cuando subimos una imagen, solo que en este caso en lugar de crear una nueva, reemplaza la que estamos estableciendo en el `/:id/` 

**Params**

- `id`: Imagen que queremos reemplazar

**Body**

- `site` : Id del site en el que está la imagen.
- `setAsGlobal` : Opcional. Para marcar la nueva imagen que subes como global.
- `file` : La nueva imagen

## `DELETE` /image/bulk

Con este endpoint se borran en bulk una serie de imágenes

**Body**

- `ids` : Array con los ids de páginas que quieres borrar.
---

# Login

## `POST` /login_check

**🔑 No requiere autenticación.**

Inicia sesión y devuelve token.

Pasamos en el body el email del usuario y la contraseña:

```json
{
	"email": "user@example.com",
	"password": "Admin2020"
}
```javascript

Y obtenemos el token:

```json
{
    "message": "Authenticated sucesfully",
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6OCwidXNlcm5hbWUiOiJlbGRlbW8iLCJlbWFpbCI6ImVsZGVtb0BnbWFpbC5jb20iLCJjaGVjayI6dHJ1ZSwiand0aWQiOiJkZWY0OGQxYi1hOTBkLTRkNjAtYmZhOS03NzBmYmY4ZmU1NWEifQ.Ixo9nJ-reuZ4FviV9eC_nDd2la5wMEy9l8ZJ17aBwVk"
}
```
---

# Menus

## `GET` /site/:site/menus

🚨 **Permisos**: navigation.manageSiteMenu

<aside>
💡 **Headers**
lang

</aside>

Devuelve un array con la info de los menús de un site. También devuelve el objeto imagen en caso de que haya una imagen asociada a ese elemento.

```json
[
    {
        "id": 439,
        "site": 86,
        "language": 4,
        "name": "TopMenu",
        "title": "Top Menu",
        "component": "MenuContainer",
        "type": null,
        "layout": null,
        "elements": [
            {
                "id": 1297,
                "label": "Top Menu 1",
                "image": null,
                "url": null,
                "component": "Menu",
                "auxText": "Aux Text Top Menu 1",
                "config": {
                    "type": "link",
                    "headerStyle": "",
                    "footerStyle": ""
                },
                "children": []
            },
        ]
    },
    {
        "id": 440,
        "site": 86,
        "language": 4,
        "name": "MainMenu",
        "title": "Main Menu",
        "component": "MenuContainer",
        "type": null,
        "layout": null,
        "elements": [
            {
                "id": 1308,
                "label": "Main Menu 1",
                "image": null,
                "url": null,
                "component": "Menu",
                "auxText": "Aux Text Main Menu 1",
                "config": {
                    "type": "link",
                    "headerStyle": "",
                    "footerStyle": ""
                },
                "children": []
            },
        ]
    },
    {
        "id": 441,
        "site": 86,
        "language": 4,
        "name": "FooterMenu",
        "title": "Footer Menu",
        "component": "MenuContainer",
        "type": null,
        "layout": null,
        "elements": [
            {
                "id": 1376,
                "label": "Footer Menu 1",
                "image": {
                    "id": 848,
                    "name": "sobaos-pasiegos.jpg",
                    "title": "",
                    "description": "",
                    "alt": "",
                    "tags": [],
                    "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1647938206/thesaurus-dev/sobaos-pasiegos_3623f6d9-7420-42d9-8963-b8c0e09f855d.jpg",
                    "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_215,h_161,c_fill,g_auto/v1647938206/thesaurus-dev/sobaos-pasiegos_3623f6d9-7420-42d9-8963-b8c0e09f855d.jpg",
                    "publicId": "thesaurus-dev/sobaos-pasiegos_3623f6d9-7420-42d9-8963-b8c0e09f855d",
                    "published": "2022-03-22T08:36:46Z",
                    "size": 259984,
                    "width": 1200,
                    "height": 800,
                    "orientation": "L",
                    "site": "global"
                },
                "url": null,
                "component": "Menu",
                "auxText": "Aux Text Footer Menu 1",
                "config": {
                    "type": "link",
                    "headerStyle": "",
                    "footerStyle": ""
                },
                "children": []
            },
        ]
    }
]
```javascript

## `GET` /select/site/:site/menu_containers

🚨 **Permisos**: navigation.manageSiteMenu

<aside>
💡 **Headers**
lang

</aside>

Devuelve un array listo para usar en selects con todos los menús disponibles para el site indicado en la url y el idioma indicado en headers.

```json
[
    {
        "value": 61,
        "label": "Top Menu"
    },
    {
        "value": 62,
        "label": "Main Menu"
    },
    {
        "value": 63,
        "label": "Footer Menu"
    }
]
```javascript

## `PUT` /menu_container/:id

🚨 **Permisos**: navigation.manageSiteMenu

Actualiza el menú con el id indicado en la url. También espera la propiedad image que puede ser o bien todo el objeto image o bien el id de la imagen en cuestión.

Ejemplo de petición:

```json
{
    "id": 441,
    "site": 86,
    "language": 4,
    "name": "FooterMenu",
    "title": "Footer Menu",
    "component": "MenuContainer",
    "type": null,
    "layout": null,
    "elements": [
        {
            "label": "Footer Menu 1",
            "url": null,
            "image": {
                "id": 848,
                "name": "sobaos-pasiegos.jpg",
                "title": "",
                "description": "",
                "alt": "",
                "tags": [],
                "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1647938206/thesaurus-dev/sobaos-pasiegos_3623f6d9-7420-42d9-8963-b8c0e09f855d.jpg",
                "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_192,h_144,c_fill,g_auto/v1647938206/thesaurus-dev/sobaos-pasiegos_3623f6d9-7420-42d9-8963-b8c0e09f855d.jpg",
                "publicId": "thesaurus-dev/sobaos-pasiegos_3623f6d9-7420-42d9-8963-b8c0e09f855d",
                "published": "2022-03-22T08:36:46Z",
                "size": 259984,
                "width": 1200,
                "height": 800,
                "orientation": "L",
                "site": "global"
            },
            "auxText": "Aux Text Footer Menu 1",
            "component": "Menu",
            "config": {
                "type": "link",
                "headerStyle": "",
                "footerStyle": ""
            },
            "children": [],
            "id": 1376
        },
        {
            "id": 1377,
            "label": "Footer Menu 2",
            "image": 678,
            "url": null,
            "component": "Menu",
            "auxText": "Aux Text Footer Menu 2",
            "config": {
                "type": "link",
                "headerStyle": "",
                "footerStyle": ""
            },
            "children": [],
            "parentEditorID": 0
        }
    ]
}
```javascript

Ejemplo de respuesta:

```json
{
    "id": 582,
    "site": 152,
    "language": 4,
    "name": "FooterMenu",
    "component": "MenuContainer",
    "type": null,
    "layout": "2",
    "elements": [
        {
            "id": 1297,
            "label": "Menú padre",
						"config": null,
            "url": {
                "href": null,
                "linkTo": 794,
								"anchor": "texto-ancla",
                "linkToURL": "https://your-instance.griddo.io/fer-test/new-page#texto-ancla"
            },
            "component": "Menu",
            "children": [
                {
                    "id": 1298,
                    "label": "Menú hijo",
										"config": null,
                    "url": {
                        "href": null,
                        "linkTo": 795
                    },
                    "component": "Menu",
                    "children": [
                        {
                            "id": 1299,
                            "label": "Menú nieto",
														"config": null,
                            "url": {
                                "href": null,
                                "linkTo": 795
                            },
                            "component": "Menu",
														"auxText": "Texto auxiliar",
                            "children": []
                        },
                        {
                            "id": 1300,
                            "label": "Menú nieto 2",
														"config": {
															"propiedad": "valor"
														},
                            "url": {
                                "href": null,
                                "linkTo": 795
                            },
                            "component": "Menu",
														"auxText": "Texto auxiliar",
                            "children": []
                        }
                    ]
                },
                {
                    "id": 1301,
                    "label": "Menú hijo 2",
										"config": null,
                    "url": {
                        "href": null,
                        "linkTo": 795
                    },
                    "component": "Menu",
                    "children": [],
										"auxText": "Texto auxiliar",
                }
            ],
						"auxText": "Texto auxiliar",
        }
    ]
}
```
---

# Navigations

## `GET` /site/:site/navigations/headers

🚨 **Permisos**: navigation.manageSiteMenu

<aside>
💡 **Headers:**
lang (opcional)

</aside>

Devuelve todos los headers para ese site e idioma (recordar que el idioma es opcional).

AÑADIDO PARA GENERAR HEADERS ‘ON THE FLY’: Ahora se devolverá el objeto thumbnail con el objeto imagen del header en concreto o `null` si no tuviera ninguno.

```json
{
    "totalItems": 2,
    "page": 1,
    "items": [
        {
            "component": "Header",
            "type": "header",
            "title": "Header new",
            "note01": {
                "title": "",
                "text": "To configure social links go to settings/general/social. To activate search feature go to settings/actionables"
            },
            "showTopNavigation": true,
            "showSocialMedia": false,
            "showSearchFeature": false,
            "logo": {
                "id": 145,
                "name": "perezoser.png",
                "title": "",
                "description": "",
                "alt": "",
                "tags": "",
                "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1610470611/thesaurus-dev/perezoser_59a18e1b-42c7-478b-9594-cb7ea57077b7.png",
                "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_128,h_96,c_fill,g_auto/v1610470611/thesaurus-dev/perezoser_59a18e1b-42c7-478b-9594-cb7ea57077b7.png",
                "publicId": "thesaurus-dev/perezoser_59a18e1b-42c7-478b-9594-cb7ea57077b7",
                "published": "2021-01-12T16:56:51Z",
                "size": 622799,
                "width": 954,
                "height": 613
            },
            "logoWhite": {
                "id": 137,
                "name": "sloth1.jpg",
                "title": "",
                "description": "",
                "alt": "",
                "tags": "",
                "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1608564989/thesaurus-dev/sloth1_80ca2329-2791-401a-b501-d0bacb555acd.jpg",
                "thumb": "https://res.cloudinary.com/thesaurus-cms/image/upload/w_128,h_96,c_fill,g_auto/v1608564989/thesaurus-dev/sloth1_80ca2329-2791-401a-b501-d0bacb555acd.jpg",
                "publicId": "thesaurus-dev/sloth1_80ca2329-2791-401a-b501-d0bacb555acd",
                "published": "2020-12-21T15:36:29Z",
                "size": 99373,
                "width": 1200,
                "height": 675
            },
						"thumbnail": {
						        "id": 859,
						        "name": ".jpeg",
						        "title": "Una anchoa?",
						        "description": "Con pan",
						        "alt": "Sí",
						        "tags": [],
						        "url": "your-instance.griddo.io/anchoa2_13",
						        "thumb": "your-instance.griddo.io/w/215/h/161/anchoa2_13",
						        "publicId": "thesaurus-dev/anchoa2_2f642e72-af42-4de5-b0e1-3a1bba868d23",
						        "damId": "anchoa2_13",
						        "published": "2022-05-10T07:42:06.177Z",
						        "size": 22193,
						        "width": 624,
						        "height": 368,
						        "orientation": "L",
						        "site": "global"
						},
            "primaryLink": {
                "component": "Link",
                "text": "Link",
                "url": {
                    "url": "",
                    "linkTo": null,
                    "newTab": true,
                    "noFollow": false,
                    "size": null,
                    "icon": null,
                    "linkContainer": null
                },
                "style": "primary"
            },
            "secondaryLink": {
                "component": "Link",
                "text": "Link",
                "url": {
                    "url": "",
                    "linkTo": null,
                    "newTab": true,
                    "noFollow": false,
                    "size": null,
                    "icon": null,
                    "linkContainer": null
                },
                "style": "primary"
            },
            "setAsDefault": true,
            "mainMenu": {
                "id": 376,
                "site": 87,
                "language": 2,
                "name": "RecursiveMenu",
                "component": "MenuContainer",
                "type": null,
                "layout": null,
                "elements": [
                    {
                        "id": 1376,
                        "label": "item 1",
                        "url": null,
                        "component": "Menu",
                        "auxText": "",
                        "children": []
                    }
                ]
            },
            "topMenu": {
                "id": 377,
                "site": 87,
                "language": 2,
                "name": "MainMenu",
                "component": "MenuContainer",
                "type": null,
                "layout": null,
                "elements": [
                    {
                        "id": 1473,
                        "label": "m1",
                        "url": null,
                        "component": "Menu",
                        "auxText": "",
                        "children": [
                            {
                                "id": 1474,
                                "label": "m2",
                                "url": null,
                                "component": "Menu",
                                "auxText": "",
                                "children": [
                                    {
                                        "id": 1475,
                                        "label": "m3",
                                        "url": null,
                                        "component": "Menu",
                                        "auxText": "",
                                        "children": []
                                    }
                                ]
                            }
                        ]
                    },
                    {
                        "id": 1476,
                        "label": "m4",
                        "url": null,
                        "component": "Menu",
                        "auxText": "",
                        "children": [
                            {
                                "id": 1477,
                                "label": "m5",
                                "url": null,
                                "component": "Menu",
                                "auxText": "aux",
                                "children": [
                                    {
                                        "id": 1478,
                                        "label": "m6",
                                        "url": null,
                                        "component": "Menu",
                                        "auxText": "",
                                        "children": []
                                    }
                                ]
                            }
                        ]
                    }
                ]
            },
            "sticky": true,
            "notificationBanner": false,
            "school": "UST",
            "navigationLanguages": [
                {
                    "navigationId": 174,
                    "languageId": "2",
                    "locale": "es_ES",
                    "language": "Spanish"
                }
            ],
            "deleted": false,
            "entity": "79070e65-8005-4eb2-a816-d26d9f8d3674",
            "id": 174,
            "site": 87,
            "language": 2
        },
        {
            "component": "Header",
            "type": "header",
            "title": "ES - New header",
            "note01": {
                "title": "",
                "text": "To configure social links go to settings/general/social. To activate search feature go to settings/actionables"
            },
            "showTopNavigation": false,
            "showSocialMedia": false,
            "showSearchFeature": false,
            "logo": null,
            "logoWhite": null,
            "primaryLink": {
                "component": "Link"
            },
            "secondaryLink": {
                "component": "Link"
            },
            "setAsDefault": false,
            "mainMenu": "",
            "topMenu": "",
            "sticky": true,
            "notificationBanner": false,
            "school": "",
            "id": 167,
            "navigationLanguages": [
                {
                    "navigationId": 167,
                    "languageId": "2",
                    "locale": "es_ES",
                    "language": "Spanish"
                },
                {
                    "navigationId": 168,
                    "languageId": "8",
                    "locale": "eu_ES",
                    "language": "Basque"
                }
            ],
            "site": 87,
            "language": 2,
            "entity": "4844f651-c834-448e-a788-547a86d48e81",
            "deleted": false
        }
    ]
}
```javascript

## `GET` /site/:site/navigations/footers

🚨 **Permisos**: navigation.manageSiteMenu

<aside>
💡 **Headers:**
lang (opcional)

</aside>

Devuelve todos los footers para ese site e idioma (recordar que el idioma es opcional).

AÑADIDO PARA GENERAR FOOTERS ‘ON THE FLY’: Ahora se devolverá el objeto thumbnail con el objeto imagen del footer en concreto o `null` si no tuviera ninguno.

## `GET` /site/:site/navigations/headers/default

🚨 **Permisos**: navigation.manageSiteMenu

<aside>
💡 **Headers:**
lang

</aside>

Devuelve el header por defecto para ese site e idioma. Error 404 si no hay ninguno marcado como default.

```json
{
    "component": "Header",
    "title": "New Header",
    "setAsDefault": true,
    "mainMenu": {
        "id": 493,
        "site": 124,
        "language": 4,
        "name": "RecursiveMenu",
        "component": "MenuContainer",
        "type": null,
        "layout": null,
        "elements": []
    },
    "school": "",
    "topMenu": null,
    "type": "header",
    "id": 36,
    "site": 1,
    "language": 1,
		"navigationLanguages": [
        {
            "navigationId": 174,
            "languageId": "2",
            "locale": "es_ES",
            "language": "Spanish"
        }
    ],
    "entity": "ea370787-c02c-4915-b1f8-073e51bc1d33",
		"deleted": false
}
```javascript

## `GET` /site/:site/navigations/footers/default

🚨 **Permisos**: navigation.manageSiteMenu

<aside>
💡 **Headers:**
lang

</aside>

Devuelve el footer por defecto para ese site e idioma. Error 404 si no hay ninguno marcado como default.

## `GET` /navigations/headers

🚨 **Permisos**: navigation.accessNavigationSettings

Devuelve todos los headers de todos los sites.

## `GET` /navigations/footers

🚨 **Permisos**: navigation.accessNavigationSettings

Devuelve todos los footers de todos los sites.

## `GET` /navigations/:id

🚨 **Permisos**: navigation.accessNavigationSettings

<aside>
💡

**Params:**
?skipDelete

</aside>

Donde:

- skipDelete: `true | false`
    - Indica si debe incluir los registros eliminados logicamente. **Por defecto:** `true`.

Devuelve el header/footer con ese id.

```json
{
    "component": "Header",
    "title": "New Header",
    "setAsDefault": false,
    "mainMenu": {
        "id": 493,
        "site": 124,
        "language": 4,
        "name": "RecursiveMenu",
        "component": "MenuContainer",
        "type": null,
        "layout": null
    },
    "school": "",
    "topMenu": null,
    "type": "header",
    "id": 36,
    "site": 1,
    "language": 1,
    "entity": "ea370787-c02c-4915-b1f8-073e51bc1d33",
    "navigationLanguages": [
        {
            "navigationId": 36,
            "languageId": "1",
            "locale": "it_IT",
            "language": "Italian"
        }
    ],
    "deleted": false
}
```javascript

## `POST` /navigations

🚨 **Permisos**: globalData.editAllGlobalData

Crea un nuevo header/footer. El entity es opcional (si no lo recibe, lo crea API con v4). El type definido en el propio módulo determina qué tipo de navigation es.

IMPLEMENTACIÓN DE THUMBNAILS DE HEADERS Y FOOTERS

Debido a la necesidad de implementar la funcionalidad de tener thumbnails personalizados de headers y footers ahora cuando se hace un POST, API está esperando dos propiedades_

- file: El form-data con la imagen de ese navigation en concreto
- navigation: Un objeto stringificado con toda la información de ese navigation.

Si no llega el archivo file con la imagen saltará un error

```json
{
    "file": form-data,
    "navigation": '{"component":"Header","type":"header","title":"Main header","note01":{"title":"","text":"To configure social links go to settings/general/social. To activate search feature go to settings/actionables"},"showTopNavigation":true,"topNavigationContent":["showSocialMedia","showSearchFeature"],"school":"GRIDDO_BIG","primaryLink":{"component":"Link","parentEditorID":0},"secondaryLink":{"component":"Link","parentEditorID":0},"setAsDefault":true,"topMenu":null,"mainMenu":null,"sticky":false,"navigationBannerIcon":null,"navigationBanner":false,"navigationBannerText":"lorem ipsum","navigationBannerLink":{"component":"Link","parentEditorID":0},"navigationBannerBGColor":"#50ABFF","parentEditorID":null,"id":66,"isDefault":true,"navigationLanguages":[{"navigationId":66,"languageId":4,"locale":"en_GB","language":"English"}],"dumb":"a","site":85,"language":4,"entity":"963f3354-89df-4970-ad3a-a800601a00ff","thumbnail":null,"deleted":false}'
}
```javascript

## `PUT` /navigations/:id

🚨 **Permisos**: globalData.editAllGlobalData

Modifica un header/footer. A diferencia de post, el put ignora las variables site, language y entity, ya que son propiedades que no se pueden cambiar una vez creado.

IMPLEMENTACIÓN DE THUMBNAILS DE HEADERS Y FOOTERS

Debido a la necesidad de implementar la funcionalidad de tener thumbnails personalizados de headers y footers ahora cuando se hace un POST, API está esperando dos propiedades_

- file: El form-data con la imagen de ese navigation en concreto
- navigation: Un objeto stringificado con toda la información de ese navigation.

En caso de que no llegue el archivo file, se quedará con la última thumbnail que exista en la base de datos, en caso contrario se actualizará.

```json
{
    "site": 1,
    "language": 1,
    "component": "Header",
    "title": "New Header",
    "setAsDefault": true,
    "mainMenu": 493,
    "school": "",
    "topMenu": null,
    "type": "header",
		"deleted": false,
		"thumbnail": 854
}
```javascript

## `PUT` /navigations/:id/default

🚨 **Permisos**: globalData.editAllGlobalData

Marca un header/footer como default para su site e idioma.

## `GET` /navigations/:id/languages

🚨 **Permisos**: globalData.editAllGlobalData

Devuelve la lista de idiomas disponibles para ese elemento de navigation.no

```json
{
    "totalItems": 2,
    "items": [
        {
            "navigationId": 34,
            "languageId": 1,
            "locale": "it_IT",
            "language": "Italian",
            "icon": null
        },
        {
            "navigationId": 81,
            "languageId": 2,
            "locale": "es_ES",
            "language": "Spanish",
            "icon": null
        }
    ]
}
```javascript

## `DELETE` /navigations/:id

🚨 **Permisos**: globalData.deleteAllGlobalData

Elimina un header/footer.

## `DELETE` /navigations/bulk

🚨 **Permisos**: globalData.deleteAllGlobalData

Elimina los header/footer cuyos id's pasamos en el body.

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

Si hubiese algún error a la hora de eliminar alguno de los elementos, los devolverá en un array especificando el id y el error que se ha producido

```json
{
    "code": 400,
    "message": [
        {
            "id": 81,
            "error": "Can't remove a navigation set as default."
        }
    ]
}
```javascript

## `PUT` /navigations/:id/restore

🚨 **Permisos**: globalData.editAllGlobalData

Recupera un header/footer eliminado.

## `PUT` /navigations/restore/bulk

🚨 **Permisos**: globalData.editAllGlobalData

Recupera los header/footer eliminados cuyos id's pasamos en el body.

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

## `GET` /navigations/:id/header/site/:site/pages

Este endpoint devuelve la información de las páginas en donde se está usando un header o headers concretos y qué otros headers hay disponibles en el site y en el idioma que llegue en headers.

Para ello se toman los siguientes datos

- `id`: Puede ser un id o una serie de ids separados por comas.
- `lang`: el id del idioma que llega por headers de la petición.
- `site`: el id del site en el que están los headers.

De esta manera la petición quedaría así

`GET/navigations/153,84/header/site/86/pages`

Y la respuesta sería la siguiente:

```json
{
    "availableNavigationsInSite": [
        {
            "id": 173,
            "isDefault": false
        },
        {
            "id": 317,
            "isDefault": false
        },
        {
            "id": 154,
            "isDefault": true
        }
    ],
    "items": {
        "totalItems": 3,
        "pagesInUse": [
            {
                "pageId": 3840,
                "pageTitle": "¿Debes desconfiar de la gente que dice Sobado?",
                "pathString": "/debes-desconfiar-de-la-gente-que-dice-sobado/",
                "navigationId": 84
            },
            {
                "pageId": 3858,
                "pageTitle": "La ruta montañesa de los mejores sobados",
                "pathString": "/la-ruta-montanesa-de-los-mejores-sobados/",
                "navigationId": 84
            },
            {
                "pageId": 4950,
                "pageTitle": "StaticOriginDuplicated",
                "pathString": "/staticoriginduplicated/",
                "navigationId": 153
            }
        ]
    }
}
```javascript

## `GET` /navigations/:id/footer/site/:site/pages

Exactamente igual que el endpoint de `GET/navigations/:id/header/site/:site/pages` pero para usar con los footers

## `POST` /navigation/bulk

Con este endpoint cambiaremos un header o un footer concreto en varias páginas. El body que esperamos es el siguiente:

```json
{
    "navigationId": 84, //id del navigation a cambiar
    "pageIds": [ //array de páginas que queremos cambiar
        3347,
        4455
    ],
    "type": "header" | "footer", //tipo de navigation, solo puede ser 'header' o 'footer'
}
```javascript

## `PUT` /navigations/page/bulk

Actualiza una serie de headers o footers en páginas concretas en formato bulk, para ello estará esperando que le llegue en el body un array de objeto con la información de cada navigation con el siguiente formato:

```json
{
    "navigations": [
        {
            "navigationId":84,
            "type": "header",
            "pageId": 3840
        },
				{
            "navigationId":153,
            "type": "footer",
            "pageId": 2311
        },
				{
						// Si el navigationId llega como null se entiende que es el por defecto
            "navigationId": null,
            "type": "footer",
            "pageId": 2311
        }
    ]
}
```javascript

## `GET` /navigations/?:extra

🚨 **Permisos**: **`navigation.manageSiteMenu`** 

Recupera un listado de navigations filtrados por id

Puede recibir estos parámetros por query string:

<aside>
💡 **Params:**
?ids
?skipdelete

</aside>
---

# Pages

Nota: En todos los endpoints de listado de páginas en los que se puede indicar el site, se puede usar "global" como id de site. Por ejemplo: `GET /site/global/pages`

## `GET` /pages

<aside>
💡 **Headers:**
lang (default: default del sistema)

**Params:**
?page
?itemsPerPage
?pagination (true/false)
?deleted (true/false; default: false)
?showPaths (true/false; default: false)
?liveStatus
?categories
?query
?type
?translated
?order
?filterModule
?filterTemplate
?filterStructuredData
?filterDataPack
?filterSites
?format
?filterPages
?ignoreLang

</aside>

Devuelve la lista de páginas de todo el ecosistema.

- Con `deleted=false` muestra solo las páginas visibles. Con deleted=true solo las eliminadas.
- Con `showPaths=true` incluye path y breadcrumb en la petición. Utilizar solo cuando sea necesario, ya que tiene más proceso y tarda más cuando está activado.
- `liveStatus` es un string separado por comas con los status de los liveStatus que se quieren recibir, a modo de filtro (por ejemplo: active,modified). Los status, no los ids. Si no se indica, se seleccionan todos.
- `categories` es un string separado por comas con los ids de todas las categorías que queramos utilizar para filtrar los resultados. Si no se indica, no se aplica el filtro.
- `query` es una o varias palabras clave por las que filtrar los resultados (a buscar en el título). En el título no tienen por qué estar juntas, es decir, que si en query buscas "home esta" te encontrará "Esta es la home".
- `order` es un valor en el formato `${field}-${ASC || DESC}`. Como field acepta `title`, `slug` y `modified`. Por ejemplo, para mostrar por título en orden descendiente: `title-desc`. Por defecto muestra los más recientes, priorizando en primer lugar la home. Si no se indica la segunda parte (por ejemplo, solo `title`) por defecto será ascendiente para title y slug, y descendiente para modified.
- `type` admite los valores `all` (por defecto), `unique` y `structuredData`. Con unique muestra solo las páginas que no están relacionadas con datos estructurados, lo que en el diseño se llama "páginas únicas". Con structuredData mostramos solo las páginas que están vinculadas a un dato estructurado de página.
- `translated` admite los valores `all` (por defecto) y `no`. Con no, muestra solo las páginas que no tengan ninguna traducción.
- Cuando el item está asociado a un dato estructurado de página el cual contiene algún campo que está como `showList` (y por tanto debe mostrarse en el listado), en cada item tendremos una propiedad structuredDataContent con los valores correspondientes a esos campos extra a mostrar en el listado.
- `filterModule` filtra los resultados a solo los que contengan el módulo indicado (por ejemplo, CardCollection. Se pueden indicar varios valores separados por comas sin espacios.
- `filterTemplate` filtra los resultados a solo los que utilicen la template indicada. Se pueden indicar varios valores separados por comas sin espacios.
- `filterStructuredData` filtra los resultados a solo los que utilicen el dato estructurado indicado. Se pueden indicar varios valores separados por comas sin espacios.
- `filterDataPack` filtra los resultados a solo los que estén relacionados al data pack indicado. Se pueden indicar varios valores separados por comas sin espacios.
- `filterSites` filtra los resultados a solo las páginas que estén disponibles en los sites cuyo id se indica. Se pueden indicar varios sites (id) separados por comas sin espacios.
- `filterPages` filtra los resultados a solo las páginas cuyo id se indica. Se pueden indicar varias páginas (id) separadas por comas sin espacios.
- `excludeSite` filtra para eliminar de los resultados las páginas que estén (`deleted=false`) en el site indicado.
- `format`. Con el valor “list” omite el contenido de las páginas, por lo que la respuesta es más rápida y más ligera.
- `ignoreLang` (true || false por defecto false)Con esta query ignorarás el idioma que llega por headers, útil para usar en combinación con `filterPages`.
- AÑADIDO PARA DATOS GLOBALES DE PÁyGINA. En la lista de elementos me incluye para cada página las propiedades `origin` (que será EDITOR o GLOBAL en función de si es una página creada desde el editor o una página global importada al site), `editable` (booleano que indica si la página puede editarse), `manuallyImported` (booleano que si está a true nos indica que es una página global que se ha importado manualmente a ese site y por tanto podemos desvincularla), `canBeUnpublished` (booleano que indica si podemos despublicar la página), `availableSites` (array de objetos {id, name} que nos dice los sites en los que está disponible esta misma página), `originalGlobalPage` (para indicar el id de la página original en el caso de que sea una copia local de una página global). Estas propiedades (excepto originalGlobalPage) aparecen en todas las páginas, con sus valores correctos, incluso cuando solo son relevantes para trabajar con datos globales de página (por ejemplo, una página "normal" siempre tendrá editable=true).
- AÑADIDO PARA EDITOR MONOUSUARIO: En el campo `editing` nos viene null si nadie está editando la página, o un objeto con los datos del usuario que la está editando (id, name, username, email). Sabemos que un usuario está editando una página porque AX estaría haciendo las llamadas al endpoint de ping.
- AÑADIDO PARA LAS PÁGINAS DRAFT: En la respuesta ahora estarán presentes tres nuevas propiedades: `haveDraftPage` el id de la página draft o null (por defecto null), `draftFromPage` id de la página live, por defecto null y `liveChanged` booleano que indica si la página live a la que se corresponde ese borrador ha sido modificado.

```json
{
    "totalItems": 3,
    "page": "1",
    "items": [
        {
            "id": 17,
            "site": 1,
            "title": "New Page",
            "slug": "/",
            "languageSlug": "/en",
            "language": 4,
						"original_language": 4,
            "canBeTranslated": true,
            "author": 2,
            "canonicalURL": "",
            "parent": null,
            "component": "Page",
            "deleted": false,
            "follow": true,
            "isIndexed": false,
            "liveStatus": {
                "id": 1,
                "title": "Not published",
                "status": "offline"
            },
            "locale": null,
            "metaDescription": "",
            "metaTitle": "",
            "metasAdvanced": "",
						"metaKeywords": [
                "keyword1",
                "keyword2",
                "keyword3"
            ],
            "socialTitle": "",
            "socialDescription": "",
            "socialImage": {
                "id": 1,
                "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1599734114/thesaurus-dbtest/screenshot-2020-09-10-at-123504-5f5a015fa9ab2.png"
            },
						"header": null,
						"footer": null,
            "template": {
                "type": "template",
                "templateType": "BasicTemplate",
                "heroSection": {
                    "component": "Section",
                    "name": "Hero Section",
                    "modules": [],
                    "sectionPosition": 1,
                    "editorID": 2
                },
                "mainContent": {
                    "component": "Section",
                    "name": "Main Content",
                    "modules": [],
                    "sectionPosition": 2,
                    "editorID": 3
                },
                "editorID": 1
            },
            "url": null,
            "workflowStatus": null,
            "modified": "2020-09-13T09:55:12.000Z",
            "published": "2020-09-13T09:55:12.000Z",
            "pageLanguages": [
                {
                    "languageId": 4,
                    "pageId": 17,
                    "locale": "en-GB",
                    "path": "/en/",
										"isLive": true
                }
            ],
						"structuredData": "NEWS"
        },
        {
            "id": 3,
            "site": 1,
            "title": "Página 1",
            "slug": "pagina-1",
            "languageSlug": "/en",
            "language": 4,
            "author": 2,
            "canonicalURL": "",
            "parent": 7,
            "component": "Page",
            "deleted": false,
            "follow": true,
            "isIndexed": false,
            "liveStatus": {
                "id": 1,
                "title": "Not published",
                "status": "offline"
            },
            "locale": null,
            "metaDescription": "",
            "metaTitle": "",
            "metasAdvanced": "",
            "socialTitle": "",
            "socialDescription": "",
            "socialImage": null,
						"header": null,
						"footer": null,
            "template": {
                "type": "template",
                "templateType": "BasicTemplate",
                "heroSection": {
                    "component": "Section",
                    "name": "Hero Section",
                    "modules": [],
                    "sectionPosition": 1,
                    "editorID": 2
                },
                "mainContent": {
                    "component": "Section",
                    "name": "Main Content",
                    "modules": [],
                    "sectionPosition": 2,
                    "editorID": 3
                },
                "editorID": 1
            },
            "url": null,
            "workflowStatus": null,
            "modified": "2020-09-13T07:47:25.000Z",
            "published": "2020-09-10T08:51:52.000Z",
            "pageLanguages": [
                {
                    "languageId": 4,
                    "pageId": 3,
                    "locale": "en-GB",
                    "path": "/en/test-clara-1/pagina-1"
                }
            ],
						"structuredData": null
        },
        {
            "id": 6,
            "site": 1,
            "title": "Página 2",
            "slug": "test",
            "languageSlug": "/en",
            "language": 4,
            "author": 2,
            "canonicalURL": "",
            "parent": 3,
            "component": "Page",
            "deleted": false,
            "follow": true,
            "isIndexed": false,
            "liveStatus": {
                "id": 1,
                "title": "Not published",
                "status": "offline"
            },
            "locale": null,
            "metaDescription": "",
            "metaTitle": "",
            "metasAdvanced": "",
            "socialTitle": "",
            "socialDescription": "",
            "socialImage": null,
						"header": null,
						"footer": null,
            "template": {
                "type": "template",
                "templateType": "BasicTemplate",
                "heroSection": {
                    "component": "Section",
                    "name": "Hero Section",
                    "modules": [],
                    "sectionPosition": 1,
                    "editorID": 2
                },
                "mainContent": {
                    "component": "Section",
                    "name": "Main Content",
                    "modules": [],
                    "sectionPosition": 2,
                    "editorID": 3
                },
                "editorID": 1
            },
            "url": null,
            "workflowStatus": null,
            "modified": "2020-09-10T11:28:55.000Z",
            "published": "2020-09-10T09:47:28.000Z",
						"noTranslate": false,
            "pageLanguages": [
                {
                    "languageId": 4,
                    "pageId": 6,
                    "locale": "en-GB",
                    "path": "/en/test-clara-1/pagina-1/test"
                }
            ],
						"structuredData": null,
				    "templateConfig": {
				        "defaultParent": 636,
				        "modifiableOnPage": true,
				        "indexDefault": true
				    }
        }
    ]
}
```javascript

## `GET` /pages/all/id

<aside>
💡 **query:** 
?template

</aside>

Devuelve un array con los ids de todas las páginas de la base de datos indiferentemente de si están eliminadas, publicadas, despublicadas, etc.

Añadiendo el `?template=templateId` a la consulta filtrará los ids por esa template.

## `GET` /site/:site/pages

Como [/pages](Pages eef7a0d621e848bb8ed18742ae7afa6a.md) pero limitado al site indicado.

IMPORTANTE: Site puede ser "global": /site/global/pages

## `GET` /site/:site/pages/light

Como el de [/pages](Pages eef7a0d621e848bb8ed18742ae7afa6a.md), aceptando los mismos parámetros, pero limitando los resultados a solo a los campos mínimos para hacer una consulta más ligera a la base de datos y con menor tráfico de datos, dando por tanto más del doble de velocidad que con el endpoint de pages normal. Se usa para filtrados en cajas de búsqueda rápidas, tipo seleccionar una página interna.

Ejemplo: `/site/124/pages/light?query=nie`

```json
{
    "totalItems": 4,
    "page": 1,
    "items": [
        {
            "id": 736,
            "title": "Nieta de inglés",
            "published": "2021-01-28T11:48:52.000Z",
            "modified": "2021-02-04T17:00:28.000Z",
            "templateId": "BasicTemplate"
        },
        {
            "id": 797,
            "title": "New Page",
            "published": "2021-02-03T17:01:52.000Z",
            "modified": "2021-02-03T17:01:52.000Z",
            "templateId": "NewsDetail"
        },
        {
            "id": 688,
            "title": "Inglés",
            "published": "2021-01-21T08:12:09.000Z",
            "modified": "2021-02-03T08:46:15.000Z",
            "templateId": "BasicTemplate"
        },
        {
            "id": 691,
            "title": "Hija de inglés",
            "published": "2021-01-21T11:44:54.000Z",
            "modified": "2021-01-28T11:47:42.000Z",
            "templateId": "BasicTemplate"
        }
    ]
}
```javascript

## `GET`

Como [`/page`](../../API Privada 36dff28f484e42e3a26e60f73d58dc06.md), pero limitando el resultado al dato estructurado indicado. Pueden indicarse varios datos estructurados separados por comas sin espacios.

## `GET` /site/:site/pages/structured-data/:structuredData

Como [`/page`](../../API Privada 36dff28f484e42e3a26e60f73d58dc06.md), pero limitando el resultado al site y tipo de dato estructurado indicado. Pueden indicarse varios datos estructurados separados por comas sin espacios.

## `GET` /select/site/:site/pages

<aside>
💡 **Headers:**
lang (default: default del sistema)

**Params:**
?query
?excludeDetailPages (false por defecto)

</aside>

Devuelve en format select la lista de páginas que no están eliminadas para el site indicado en la url y el idioma indicado en headers. En query se puede indicar palabras clave para filtrar la búsqueda. Los resultados se muestran por orden alfabético de título.

Si está `excludeDetailPages=true` se excluyen las páginas que tengan una template de tipo detalle.

```json
[
    {
        "value": 3,
        "label": "New Page"
    }
]
```javascript

## `GET` /select/site/:site/pages/:excludePage

Igual que el select anterior, pero excluyendo la página indicada.

## `GET` /page/:page/languages

Devuelve la lista de idiomas disponibles para esa página.

```json
{
    "totalItems": 1,
    "items": [
        {
            "pageId": 2,
            "languageId": 4,
            "locale": "en-GB",
            "language": "English",
            "icon": null
        },
        {
            "pageId": 4,
            "languageId": 2,
            "locale": "es-ES",
            "language": "Spanish",
            "icon": null
        },
    ]
}
```javascript

## `GET` /page/:page/breadcrumb

Devuelve el path y breadcrumb de la página indicada.

```json
{
    "path": "/test-1/la-la-land/",
    "breadcrumb": [
				{
						"linkTo": 25,
						"label": "test 1"
				},
				{
						"linkTo": 12,
						"label": "La la land"
				}
    ]
}
```javascript

## `GET` /page/:page

<aside>
💡 **Params:**
?fullPathBreadcrumb (default: false)

</aside>

Devuelve la información de la página indicada.

Se le puede añadir el parámetro fullPathBreadcrumb (con valor "1", "on" o "true"). En ese caso, en cada elemento del breadcrumb añadirá una propiedad fullPath con la ruta absoluta completa de ese elemento.

En las propiedades header y footer está recibiendo los ids de los respectivos [Navigations](Navigations 89f4a5b3cb9a41a8a8f75bc7205e217b.md). En el caso de que se trate del header o footer por defecto, recibirá null.

AÑADIDO PARA DATOS GLOBALES DE PÁGINA. En la lista de elementos me incluye para cada página las propiedades `origin` (que será EDITOR o GLOBAL en función de si es una página creada desde el editor o una página global importada al site), `editable` (booleano que indica si la página puede editarse), `manuallyImported` (booleano que si está a true nos indica que es una página global que se ha importado manualmente a ese site y por tanto podemos desvincularla), `canBeUnpublished` (booleano que indica si podemos despublicar la página), `availableSites` (array de objetos {id, name} que nos dice los sites en los que está disponible esta misma página), `originalGlobalPage` (para indicar el id de la página original en el caso de que sea una copia local de una página global). Estas propiedades (excepto originalGlobalPage) aparecen en todas las páginas, con sus valores correctos, incluso cuando solo son relevantes para trabajar con datos globales de página (por ejemplo, una página "normal" siempre tendrá editable=true).

AÑADIDO PARA EDITOR MONOUSUARIO: En el campo `editing` nos viene null si nadie está editando la página, o un objeto con los datos del usuario que la está editando (id, name, username, email). Sabemos que un usuario está editando una página porque AX estaría haciendo las llamadas al endpoint de ping.

AÑADIDO PARA DIMENSIONES: En la respuesta nos llegará un objeto `dimensions` con dos propiedades `dimensionConfig` que será un objeto con las configuraciones que se guarden en AX para las páginas y `dimensionValues` que será un array de objetos con las dimensiones con asociadas a esta página.

AÑADIDO PARA LA PROGRAMACIÓN DE PUBLICACIÓN DE PAGINAS
Se devolverá la propiedad `publicationScheduled` con la hora y el día en el que se quiere publicar la página o `null`. Se devolverá en el siguiente formato de"AAAA-MM-DDTHH:MM:SSZ",

```json
{
    "id": 9,
    "site": 1,
    "title": "New Page-TEST",
    "slug": "new-page-test",
    "languageSlug": "/en",
    "language": 4,
    "author": 2,
    "canonicalURL": "",
    "parent": 8,
    "component": "Page",
    "deleted": false,
    "follow": true,
    "isIndexed": false,
    "liveStatus": {
        "id": 1,
        "title": "Not published",
        "status": "offline"
    },
    "locale": null,
    "metaDescription": "",
    "metaTitle": "",
    "metasAdvanced": "",
    "metaKeywords": [
         "keyword1",
         "keyword2",
         "keyword3"
    ],
    "socialTitle": "",
    "socialDescription": "",
    "socialImage": null,
		"header": null,
		"footer": null,
    "template": {
        "type": "template",
        "templateType": "BasicTemplate",
        "heroSection": {
            "component": "Section",
            "name": "Hero Section",
            "modules": [],
            "sectionPosition": 1,
            "editorID": 2
        },
        "mainContent": {
            "component": "Section",
            "name": "Main Content",
            "modules": [],
            "sectionPosition": 2,
            "editorID": 3
        },
        "editorID": 1
    },
    "url": null,
    "workflowStatus": null,
    "modified": null,
    "published": "2020-09-10T11:34:21.000Z",
    "pageLanguages": [
        {
            "languageId": 4,
            "pageId": 9,
            "locale": "en-GB",
            "path": "/en/test-clara-1/test-clara-2/new-page-test",
						"isLive": true
						"fullPath": {
			        "site": "/cli",
			        "domain": "ie.edu",
			        "language": "/es/clic",
			        "page": "/prueba-carlos",
			        "compose": "/es/clic/prueba-carlos"
				    },
				    "fullUrl": "//ie.edu/es/clic/prueba-carlos"
        }
    ],
    "breadcrumb": [
        {
            "linkTo": 7,
            "label": "Test clara 1",
            "path": "/test-clara-1/"
        },
        {
            "linkTo": 8,
            "label": "test clara 2",
            "path": "/test-clara-1/test-clara-2/"
        }
    ],
    "path": "/test-clara-1/test-clara-2/",
		"structuredData": "NEWS",
		"hash": "1234-1234-1234-1234",
		"fullPath": {
        "site": "/cli",
        "domain": "ie.edu",
				"domainUrl": "https://ie.edu",
        "language": "/es/clic",
        "page": "/prueba-carlos",
        "compose": "/es/clic/prueba-carlos"
    },
    "fullUrl": "//ie.edu/clic/es/prueba-carlos",
    "templateConfig": {
        "defaultParent": [
            {
                "languageId": 4,
                "pageId": 636,
                "title": "About",
                "locale": "en_GB",
                "path": "/qa-mai/prueba3",
                "url": "https://your-instance.griddo.io/qa-mai/prueba3",
                "prueba": "ptt"
            }
        ],
        "modifiableOnPage": true,
        "indexDefault": true
    },
		"dimensions": {
	      "dimensionConfig": {
            "contentSelect": "uno",
            "groupSelect": "dos"
        },
        "dimensionValues": [
            {
                "dimensionsName": "dimension2",
                "dimensionValues": "value4"
            },
            {
                "dimensionsName": "ElCambioEstaAqui",
                "dimensionValues": "value5"
            },
            {
                "dimensionsName": "estoEsParaCarmelizar",
                "dimensionValues": "bola"
            }
        ]
    },
}
```javascript

## `GET` /page/:id/preview

Devuelve la información completa de la página con el id indicado, con independencia de su estado. **Si esa página tiene un draft, lo que devuelve es la información de la página draft.**

## `POST` /page/:page

Crea una nueva página. Todos los datos para la creación de la página a considerar serán los facilitados en el propio body. El id del autor se extrae a través del token de autenticación.

Si se facilita la propiedad structuredData, se creará un dato estructurado asociado a esa página utilizando el esquema del tipo de dato estructurado indicado en dicha propiedad.

El header y el footer son los id de los respectivos [Navigations](Navigations 89f4a5b3cb9a41a8a8f75bc7205e217b.md). Si se trata del header o footer por defecto, sus valores serían null.

AÑADIDO PARA DIMENSIONES. Dimensiones se mandará con el nombre `dimensions` que será un objeto. En el podremos añadir las características que queramos, salvo por `values`, que será un objeto **obligatorio** en el que las keys son las dimensiones y las values son las variables asociadas. Para verlo de manera más práctica consultar el ejemplo de abajo.

AÑADIDO PARA LA PROGRAMACIÓN DE PUBLICACIÓN DE PAGINAS
Para programar una publicación a la hora de hacer el post o put de page hay que mandar la propiedad `publicationScheduled` con la hora y el día en el que se quiere publicar la página. Debe estar en el siguiente formato de"AAAA-MM-DDTHH:MM:SSZ",

Devuelve el equivalente a hacer un GET a la nueva página creada.

```json
{
    "site": 1,
    "title": "New Page Edited",
    "slug": "",
    "parent": null,
    "language": 4,
		"original_language": 4,
    "canBeTranslated": true,
    "canonicalURL": "",
    "component": "Page",
    "deleted": true,
    "follow": true,
    "isIndexed": false,
    "liveStatus": 1,
    "locale": null,
    "metaDescription": "",
    "metaTitle": "",
    "metasAdvanced": "",
    "metaKeywords": [
         "keyword1",
         "keyword2",
         "keyword3"
    ],
    "socialTitle": "",
    "socialDescription": "",
    "socialImage": null,
		"header": null,
		"footer": null,
    "template": {
        "type": "template",
        "templateType": "BasicTemplate",
        "heroSection": {
            "component": "Section",
            "name": "Hero Section",
            "modules": [],
            "sectionPosition": 1,
            "editorID": 2
        },
        "mainContent": {
            "component": "Section",
            "name": "Main Content",
            "modules": [],
            "sectionPosition": 2,
            "editorID": 3
        },
        "editorID": 1
    },
    "url": null,
    "workflowStatus": null,
    "structuredData": "BASIC_PAGE",
		"noTranslate": false,
		"publicationScheduled": "2024-07-12T10:27:11.508Z",
		"dimensions": {
        "contentSelect": "uno",
        "groupSelect": "dos",
        "values": {
            "dimension1": "value2",
            "dimension2": "value4"
        }
}
```javascript

## `PUT` /page/:page

<aside>
💡 **Query:**
?publishDraft=1

</aside>

Funciona como POST, pero para hacer la edición de la página indicada.

El idioma de una página no puede cambiarse, por lo que cualquier información sobre idioma recibida en un PUT será ignorada.

AÑADIDO PARA LAS PÁGINAS DRAFT: Si recibimos la propiedad `draftFromPage` en el body y en la query recibimos `?publishDraft=1` significa que la página es un borrador y lo queremos publicar como página definitiva. Acto seguido la página se actualizará y el borrador se eliminará completamente.

AÑADIDO PARA LA PROGRAMACIÓN DE PUBLICACIÓN DE PAGINAS
Para programar una publicación a la hora de hacer el post o put de page hay que mandar la propiedad `publicationScheduled` con la hora y el día en el que se quiere publicar la página. Debe estar en el siguiente formato de"AAAA-MM-DDTHH:MM:SSZ",

## `DELETE` /page/bulk

Elimina las páginas indicadas pasadas en un array en el body.

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

Si hubiera errores, devolverá un array con el id de los elementos afectados y el problema.

```json
{
    "code": 400,
    "message": [
        {
            "id": 315
            "error": "Can't remove a page that is associated to a menu."
        },
				{
            "id": 320
            "error": "Page with children can't be deleted."
        }
    ]
}
```javascript

## `DELETE` /page/bulk/undo

Como el delete bulk anterior, pero para deshacer la operación.

## `DELETE` /page/:page

Elimina la página indicada, así como el dato estructurado que pudiera tener asociado (borrado lógico) y todas las relaciones que tiene ese dato estructurado (borrado físico, llegado el caso se puede reconstruir con la información del propio dato).

Además, si borras una página, también borraras el draft que tenga asociado si lo hubiera.

## `DELETE` /page/:page/undo

Anula el borrado de una página. Al hacerlo reconstruye todos sus índices, datos estructurados, índices, clonado de páginas globales... Puede dar un error, especialmente si el path de la página a restaurar ya existe.

## `POST` /page/:page/duplicate

Crea una copia de la página cuyo id se indica por parámetro, en estado "no publicada", con el usuario conectado como autor, con el mismo parent que la página original y con el titulo y slug indicados en el body de la petición.

Como respuesta devuelve un objeto página (igual que cuando se hace un post), un código 404 si el id de página no existe, o un error 500 (generalmente si el slug ya está en uso o no se ha indicado título).

Ejemplo petición:

```json
{
    "title": "Copia de la 112",
    "slug": "/112-copy"
}
```javascript

## `POST` /page/:id/duplicate/:site

Duplica una página en un site concreto. Para ello indicaremos el `id` tanto de la página como del site en el que queremos copiar.

Algunas valoraciones:

- Solo se puede duplicar una template que no esté asociada a dato estructurado.
- El parent aparece vacío pero la página copiada mantiene el slug que tiene. Si ya existiera, le añade un (...)-1, (...)-2
- La página se copia con el estado ‘Offline’.
- Solo se copia la página en el idioma de esa página, no todas las versiones y necesita que ese site tenga el idioma de la página activado, si no saltará un error.
- Si contiene un distribuidor de un dato estructurado de site y el distribuidor es manual y el dato es de site, se eliminan esas referencias.

## `POST` /page/check

Este endpoint sirve para:

- Comprobar que los distribuidores tengan disponible contenido publicado y si enlaza manualmente con algún elemento, este debe estar publicado.
- Todo link o enlace interno debe enlazar con contenido publicado.

Para ello recibe en el body lo mismo que si se hiciera un `POST` de página y devuelve un array de objetos con los fallos que pudiera haber en los distribuidores y links en esa página.

Si es un fallo en distribuidores será un error `"error": "ERR019”` y si es de links `"error": "ERR038"` . La respuesta se ve de la siguiente manera:

```json
[
    {
        "error": "ERR038",
        "editorID": 8,
        "link": {
            "id": 3536,
            "title": "Un pequeño ejemplo de Caos"
        }
    },
    {
        "error": "ERR019",
        "editorID": 11,
        "failedStructuredData": [
            4462,
            4657
        ]
    },
    {
        "error": "ERR019",
        "editorID": 13,
        "failedStructuredData": [
            4462
        ]
    },
    {
        "error": "ERR019",
        "editorID": 15
    }
]
```javascript

## `PUT` /pages/status/:status

Cambia el estado de todas las páginas que recibe en la propiedad ids del body (es un array) al estado indicado en la url. También ajusta el estado de publicación del dato estructurado de página asociado cuando es de aplicación. Ejemplo: `/pages/status/active` o `/pages/status/offline`.

No obstante, no se podrá cambiar el live_status de una página cuyo id esté en un draft_from_page, o lo que es lo mismo, el id de una página que tenga borrador.

Body de la petición:

```json
{
    "ids": [68]
}
```javascript

## `GET` /pages/check/status

Recibe un objeto con una propiedad ids que es un array de ids de página. Devuelve el status de todas esas páginas. En la respuesta, exists significa que la página existe. Published significa que la página está publicada o pendiente de renderizado (y por tanto estará como publicada en el próximo render).

Body de la petición:

```json
{
    "ids": [9999,12, 13, 14, 37]
}
```javascript

Ejemplo de la respuesta:

```json
[
    {
        "pageId": 12,
        "exists": true,
        "published": false,
        "liveStatus": {
            "id": 1,
            "title": "Offline",
            "status": "offline"
        }
    },
    {
        "pageId": 13,
        "exists": true,
        "published": false,
        "liveStatus": {
            "id": 1,
            "title": "Offline",
            "status": "offline"
        }
    },
    {
        "pageId": 14,
        "exists": true,
        "published": true,
        "liveStatus": {
            "id": 3,
            "title": "Live",
            "status": "active"
        }
    },
    {
        "pageId": 37,
        "exists": true,
        "published": true,
        "liveStatus": {
            "id": 2,
            "title": "Publication pending",
            "status": "upload-pending"
        }
    },
    {
        "pageId": 9999,
        "exists": false,
        "published": false,
        "liveStatus": null
    }
]
```javascript

## `POST` /site/:site/pages/global/imports/:page

Importa al site indicado la página global con el id señalado. El id de página puede ser el de la página global o el de cualquiera de las copias en cualquier site.

## `POST` /site/:site/pages/global/imports/bulk

Importa al site indicado las páginas globales indicadas en el body.

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

Si hubiera errores, devolverá un array con el id de los elementos afectados y el problema.

```json
{
    "code": 400,
    "message": [
        {
            "id": -25,
            "error": "Page to import should be indicated."
        }
    ]
}
```javascript

## `DELETE` /site/:site/pages/global/imports/:page

Elimina la importación manual de la página global indica en el site señalado. Sin embargo, esto no tiene por qué suponer que la página desaparece del site. Si la página global indicada señala a ese site como canonicalSite en cualquiera de sus versiones de idiomas, no se podrá eliminar del site (puesto que es el site canonical). Si la página global se está importando a través de una regla automática en el data pack config, la página seguirá estando mientras se cumpla la regla (si se quiere quitar igualmente, habrá que cambiarle el estado de publicación a la página en el site).

## `DELETE` /site/:site/pages/global/imports/bulk

Elimina la importación manual del site indicado de las páginas globales indicadas en el body.

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

Si hubiera errores, devolverá un array con el id de los elementos afectados y el problema.

```json
{
    "code": 400,
    "message": [
        {
            "id": -25,
            "error": "Page to remove should be indicated."
        }
    ]
}
```javascript

## `POST` /page/:id/ping

Hace una petición post que recoge el id de una página y manda un ping a la base de datos para identificar si un usuario está editando esa página en concreto y, por tanto, saber si podemos editarla o por el contrario esperar a que el otro usuario termine de editarla.

Si nadie está editando la página, devolverá un status 200 y actualizará los campos editing y editing_id en la tabla page en la base de datos.

Si la está editando el mismo usuario cuando hace ping, devolverá status 200 y se actualizará el editing_ping de la tabla page.

Si otro usuario intenta editar una página en la que está trabajando otro usuario, devolverá un mensaje de error 400.

```bash
{
    "code": 400,
    "message": "User Paco is currently working on this page. You can preview the page but you cannot make changes to it until paco left the page."
}
```javascript

## `POST` /ai/summary/page

Esta funcionalidad utiliza [Inteligencia Artificial](Inteligencia Artificial 67c35e14478a43d4840826c9d898ae6d.md) (ver notas para requisitos adicionales).

Recibe en el body el contenido de una página, exactamente igual que si estuviéramos guardando una página. **No hace falta que la página esté creada ni que exista, y no genera cambios en la BBDD.**

Devuelve un objeto JSON con el resumen y keywords, utilizando como base los campos de tipo texto de esa página que en sus respectivos esquemas figuren como `humanReadable`.

Tanto el resumen como las keywords se obtienen en el idioma indicado en el propio objeto página (la propiedad language).

```json
{
    "summary": "El Ministerio de Industria ha asignado 9,6 millones de euros a un proyecto piloto que otorgará ayudas a empresas de hasta 250 trabajadores que reduzcan la jornada laboral a cuatro días durante dos años.",
    "keywords": [
        "jornada laboral",
        "ayudas a empresas",
        "Ministerio de Industria",
        "reducción de jornada",
        "proyecto piloto"
    ]
}
```javascript

## `POST` /translations/page/:targetLanguageId

Esta funcionalidad utiliza [Inteligencia Artificial](Inteligencia Artificial 67c35e14478a43d4840826c9d898ae6d.md) (ver notas para requisitos adicionales).

Recibe en el body el contenido de una página, exactamente igual que si estuviéramos guardando una página. **No hace falta que la página esté creada ni que exista, y no genera cambios en la BBDD.**

Devuelve el mismo esquema de página, pero traducido. La traducción la hace desde el idioma indicado en el propio esquema de página, al idioma que se corresponde con el id indicado en :targetLanguageId. En la respuesta, la propiedad language ya estaría actualizada al nuevo idioma.

Va a traducir solo los campos de tipo texto de esa página que en sus respectivos esquemas figuren como `humanReadable`

## `POST` /translations/structured_data_content/:targetLanguageId

Esta funcionalidad utiliza [Inteligencia Artificial](Inteligencia Artificial 67c35e14478a43d4840826c9d898ae6d.md) (ver notas para requisitos adicionales).

Recibe en el body el contenido de un dato estructurado o de una categoría, exactamente igual que si estuviéramos guardando una página. **No hace falta que el dato estructurado o la categoría esté creada ni que exista, y no genera cambios en la BBDD.**

Devuelve el mismo esquema de dato estructurado o categoría, pero traducido. La traducción la hace desde el idioma indicado en el propio esquema de página, al idioma que se corresponde con el id indicado en `:targetLanguageId`. En la respuesta, la propiedad language ya estaría actualizada al nuevo idioma.

Va a traducir solo los campos de tipo texto de esa página que en sus respectivos esquemas figuren como `humanReadable`

## **`PUT`** **/pages/update**

Cambia el hash a todas las páginas de todos los sites. No recibe nada en el body y necesitas permiso superadmin para poder ejecutar este endpoint.

## **`GET`** **/pages/clean-corrupted**

Hay que pasar el authorization por header, con el valor de la developerKey.

Realiza una comprobación de todas aquellas páginas globales que hayan sido eliminadas y de las copias de sitio que puedan haber quedado publicadas. Si encuentra alguna página corrupta, la marca como eliminada y, al mismo tiempo, verifica si tiene algún dato estructurado asociado para marcarlo también como eliminado.
También busca datos estructurados huérfanos y los elimina completamente de la base de datos. Esto solo pasa si el dato estructurado tiene asociada una página que por lo que sea fue eliminada de la base de datos.

**Tipos usados de TS:**

- **Response**: `CleanCorruptedPagesResponse`
    - Ejemplo de respuesta:
    
    ```json
    {
    	"deletedPages": 143,
    	"deletedStructuredData": 142,
    	"duplicatePagesDelete": 2,
      "unpublishingSitePages": 1,
    	"liveStatusStructuredDataUpdate": 44225,
    	"unpublishedStructuredDataUpdate": 6070,
    	"orphanStructureDataDelete": 26,
    	"globalPagesWithMismatchedLiveStatus": 15
    }
    ```javascript
    
    | Propiedad | Descripción |
    | --- | --- |
    | `deletedPages` | Páginas corruptas eliminadas lógicamente. Detectadas por `findCorruptedPagesIds()` |
    | `deletedStructuredData` | Datos estructurados vinculados a las páginas corruptas eliminadas |
    | `duplicatePagesDelete` | Páginas duplicadas eliminadas físicamente. Detectadas por `findDuplicatePages()` |
    | `orphanStructureDataDelete` | Datos estructurados huérfanos (sin página asociada) eliminados físicamente. Detectados por `getOrphanIds()` |
    | `unpublishingSitePages` | Páginas con estado de sitio desincronizado que fueron despublicadas. Detectadas por `findUnSynchronizedPagesIds()` |
    | `globalPagesWithMismatchedLiveStatus` | Páginas globales con estado de publicación inconsistente eliminadas. Detectadas por `findGlobalPagesWithMismatchedLiveStatus()` |
    | `liveStatusStructuredDataUpdate` | Datos estructurados actualizados para sincronizar con páginas en estado "publicado" |
    | `unpublishedStructuredDataUpdate` | Datos estructurados actualizados para sincronizar con páginas en estado "no publicado" |
---

# Redirects

## `GET` /redirects

🚨 **Permisos**: seoAnalytics.editSeoGlobalPages

<aside>
💡 **Params:**
?page
?itemsPerPage
?pagination (true/false)
?sites
?query
?filterBy
?format

</aside>

Te devuelve el listado de **Redirecciones**. Un array de objetos con las propiedades `from` que es la url antigua y `to` que es un objeto con el `id` de la página a la que quieres redirigir, el `externalUrl` en caso de no haber id y el `url`.

También devuelve el id de cada redirección y el objeto `site`, que se compone de las propiedades `siteId`, `siteName` y `siteUrl`. También devuelve el full domain y la fecha en la que fue creado con la propiedad `date`.

Puedes seleccionar sites concretos del listado usando la query sites seguido de los ids de site de la siguiente manera: `?sites=86,87,88` Si solo pones uno, te devolverá los resultados de ese site en concreto. Si 

Si quieres filtrar por los resultados que contengan una palabra concreta dentro del url del `from` o del `to` o de ambos, puedes usar el `?query` como por ejemplo en `?query=programs` para que te devuelva todos los redirects que contengan la palabra programs en el `from` o el `to`. Si además añadimos el `filterBy` a la petición, se filtrarán los resultados por aquellos que contengan la palabra exclusivamente en el campo `from` o el campo `to`. El `?filterBy` solo funciona junto a `?query`.

También usando `page`, `itemsPerPage` y `pagination` puedes paginar los resultados.

Con `format`, puedes indicar en qué formato quieres recibir la respuesta. Valores aceptados: “json” (por defecto) / “csv” / “xml”.

```json
[
        {
            "id": 354,
            "domain": "//cx.dev.griddo.io/pre-griddo",
            "date": "2022-03-09T11:18:29.000Z",
            "site": {
                "siteId": 86,
                "siteName": "Alvaro Trasteandoo",
                "siteUrl": "/en-ingles"
            },
            "from": "//cx.dev.griddo.io/pre-griddo/en-ingles/don-quijote-de-la-mancha/",
            "to": {
                "pageId": 3377,
                "url": "//cx.dev.griddo.io/pre-griddo/sergio-site/don-quijote-de-la-mancha/"
            }
        },
        {
            "id": 306,
            "domain": "//cx.dev.griddo.io/pre-griddo",
            "date": "2022-03-09T11:18:29.000Z",
            "site": {
                "siteId": 86,
                "siteName": "Alvaro Trasteandoo",
                "siteUrl": "/en-ingles"
            },
            "from": "//cx.dev.griddo.io/pre-griddo/en-ingles/compra-tus-entradas-al-museo-del-sobao/again/el-museo-del-sobao-reabre-sus-puertas/",
            "to": {
                "pageId": null,
                "url": "/nueva/redirección/test"
            }
        },
  ]
```javascript

## `POST` /redirect

🚨 **Permisos**: seoAnalytics.editSeoGlobalPages

Crea un nuevo redirect en la base de datos.

En el body de la petición se esperan las propiedades: 

`from` que es la url antigua. 

`to` que es el url de la página a la que quieres redirigir o su id.

En caso de existir esa redirección te avisará, pero si necesitas sobrescribirla, puedes añadir la query `?force=1` y la sobreescribirá.

Ejemplo de petición:

```json
{
	"from": "//cx.dev.griddo.io/pre-griddo/sergio-site/",
	"to": "/nueva/test/world"
}
```javascript

## `PUT` /redirect/:id

🚨 **Permisos**: seoAnalytics.editSeoGlobalPages

Igual que el post pero actualizándo un redirect concreto a través de su `id`.

## `POST` /redirect/bulk/check

🚨 **Permisos**: seoAnalytics.editSeoGlobalPages

Acepta en el body la propiedad `redirects` que es un array de objetos con cada uno de los redirects.

Ejemplo de body en la petición:

```json
"redirects": [
        {
            "from": "your-instance.griddo.io/pre-griddo/en-ingles/compra-tus-entradas-al-museo-del-sobao/el-museo-del-sobao-reabre-sus-puertas/",
            "to": "world"
        },
        {
            "from": "your-instance.griddo.io/pre-griddo/gonzalo-h/yesvak-djokovisku/",
            "to": 3336
        },
        {
            "from": "/griddo/test",
            "to": "/test/gridddo"
        }
    ]
```javascript

El from será cada una de las urls y el to será o bien una `url` o el `id` de la página a la que queramos redirigir.

La respuesta de esta petición será un listado con el total de la redireciones indicándo cuántos ya existían en la BBDD, cuántos son un error (no se encuentra a qué site pertenece), y cuántos se pueden hacer sin problemas.

```json
{
    "totalRedirects": 3,
    "items": {
        "error": [
            {
                "from": "/griddo/test",
                "to": "/test/gridddo"
            }
        ],
        "existing": [
            {
                "from": "your-instance.griddo.io/pre-griddo/en-ingles/compra-tus-entradas-al-museo-del-sobao/el-museo-del-sobao-reabre-sus-puertas/",
                "to": "world"
            },
            {
                "from": "your-instance.griddo.io/pre-griddo/gonzalo-h/yesvak-djokovisku/",
                "to": 3336
            }
        ],
        "ok": []
    }
}
```javascript

## `POST` /redirects/bulk/

🚨 **Permisos**: seoAnalytics.editSeoGlobalPages

Igual que el anterior, solo que lo que hace es que realiza todos ajustes de creación y actualización e ignora los que da error. Finalmente, devuelve el listado con las acciones.

## `DELETE` /redirect/:id

🚨 **Permisos**: seoAnalytics.editSeoGlobalPages

Borra una redirección en concreto a través de su id.

## `DELETE` /redirects/bulk

🚨 **Permisos**: seoAnalytics.editSeoGlobalPages

Borra una serie de redirects a través del body, en el cual acepta la propiedad `ids` que es un array con los ids que queramos borrar.
---

# Schemas

**API (y Griddo en general) no puede funcionar si no hay como mínimo un esquema básico. Por esta razón, API no permite usar NINGÚN endpoint hasta que no hay al menos un esquema válido cargado en la BBDD. Mientras no exista ese esquema, solo podrá utilizarse el endpoint `PUT /schemas`. La respuesta de API deja clara esta circunstancia.**

Estos endpoints sirven para manejar los esquemas que antes se importaban desde Components, de manera que API no tiene esa dependencia.

Hay que tener en cuenta la peculiaridad de que requieren una key facilitada en el header como `authorization` que, a diferencia del resto de endpoints en los que pasamos un token, contiene una "developer key" que es exclusiva para estas operaciones "especiales" que no son para todos los usuarios.

La "developer key" se define en las variables de entorno como `developerKey`, y la introducida en el header authorization debe ser exactamente igual.

## Nota sobre actualización de esquemas

Cuando se hace una petición de actualizar los esquemas, suceden varias cosas:

1. Se actualiza el esquema en la BBDD, y se guarda como pendiente de completar.
2. La API reajusta la BBDD a la nueva configuración de los esquemas.
3. Al completarse, marca el proceso como realizado y notifica al resto de instancias.

Para notificar al resto de instancias, es necesario que:

- Estén declaras las variables de entorno:
    - pingIP (con el valor private o public, en principio estamos usando "private"), para decir con qué tipo de ip vamos a identificar al resto de instancias.
    - pingPORT (con el valor 8080 en nuestro caso) para definir a través de qué puerto van a comunicarse las instancias entre ellas..
- Las reglas de seguridad deben permitir que las instancias de API tengan visibilidad entre ellas.

## Nota sobre cambio en los esquemas de idiomas

Documentación movida a Dev instancias: [Nota sobre cambio en los esquemas de idiomas](../../../Bloques constructivos/Schemas/Schemas de configuraci%C3%B3n/Idiomas 89765fb8eebe408495980644bc1bd14f.md) 

## `GET` /schemas/version

Endpoint abierto. No requiere autenticación.

Devuelve la versión de schemas que se está usando.

```json
{
    "version": "npm:@thesaurus/components@16.0.3"
}
```javascript

## POST /schemas/refresh (¡No usar!)

Tenemos que pasarle el authorization por header, con el valor de la developerKey.

Lo que hace es recoger el schema más actual que haya en la base de datos y cargarlo en memoria.

Este endpoint es solo para uso interno de API: En un entorno de múltiples instancias, cuando una instancia de API recibe un cambio en los esquemas y los registra en la base de datos, notifica al resto de instancias utilizando este endpoint para que ellas también se actualicen al nuevo esquema. Puede parecer un poco raro, pero es más efectivo y rápido que reiniciar todas las instancias (el proceso se ejecuta en menos de un segundo, porque son notificaciones por la propia intranet de la infra; reiniciar la API puede llevar varios minutos).

## `PUT` /schemas

Tenemos que pasarle el authorization por header, con el valor de la developerKey.

Todos los valores se pasan por el body, con este esquema:

```json
{
     version,
     modules,
     templates,
     structuredData,
     dataPacks,
     dataPacksCategories,
     languages,
}
```javascript

Los valores de estas propiedades son exactamente los mismos que está exportando components (excepto version, que es un string con el número de versión o lo que se quiera poner).

Un ejemplo de estos esquemas puede verse en: [https://bitbucket.org/secuoyas/griddo-api/src/45f2ffa74cfb260a3eb6a8f9f82ae835254da51c/test/schemas.json?at=release/develop](https://bitbucket.org/secuoyas/griddo-api/src/45f2ffa74cfb260a3eb6a8f9f82ae835254da51c/test/schemas.json?at=release/develop)  

**Si se produce un error** y por tanto no se actualizan los esquemas sigue funcionando con los esquemas que ya tuviera cargados y aquí no pasa nada.

**Si los esquemas son correctos**, se actualizan en la propia instancia de API, se lanza un proceso que migra los datos y corrige la BBDD según lo indicado en los nuevos esquemas (si fuera necesario) y notifica al resto de instancias de API para que pasen a usar los nuevos esquemas (la manera en que se notifica al resto de instancia se configura en infra a través de variables de entorno que están indicadas y documentadas en el repo de API, en el `env.template`).

## `GET` /schemas/check

Recibe en el body de la petición los mismos esquemas que `PUT /schemas` ([ver](Schemas 2d7d21ecc3524de098b972cae1dd11cf.md)) PERO no guarda la nueva configuración. Simplemente devuelve un código 200 (ok) si los esquemas están correctos (chequeando con respecto a las reglas de integridad que hay en API, no se verifica todo lo que pudiera estar mal, solo lo que en API tenemos identificado que provocaría corrupción de datos), o un mensaje de error si encuentra algo "malo" en los esquemas.

Esto permite hacer un chequeo de la integridad de los esquemas y no iniciar un deploy si ya de entrada vemos que hay un error de integridad.

También nos permite ver qué está mal en el esquema, ya que señala (a veces con bastante nivel de detalle, ver último [ejemplo real de respuesta error](Schemas 2d7d21ecc3524de098b972cae1dd11cf.md)) lo que no le gusta (entendiendo como "no le gusta" incoherencias que producirían corrupción en los datos).

NOTA: Con tiempo y colaboración de todos, podemos hacer que las reglas que se validan en el check sean más completas y útiles para el desarrollo de DX (al margen de hacer un editor visual de esquemas). En el código de API estos checks se hacen en `models/schemas/schemasCheck.js → validateSchemas()`.

Ejemplos (reales) de respuesta error:

```json
{
    "code": 400,
    "message": "Schemas version should be indicated."
}
```javascript

```json
{
    "code": 400,
    "message": "El dato estructurado STORIES tiene asociado un template que no existe."
}
```javascript

```json
{
    "code": 400,
    "message": "El dato estructurado STORIES es global pero se está asociando con el dato estructurado 'STORY_PROFILE' que es local. Un dato estructurado global solo puede depender de otros datos globales."
}
```javascript

Ejemplo respuesta ok:

```json
{
    "code": 200,
    "message": "ok"
}
```javascript

## `GET` /schemas/select/all

Este endpoint está restringido al rol de superadmin, y devuelve una lista de tipo select con el id y title de los schemas template, content types y categories

**Tipos usados de TS:**

- **Response**: `SchemaSelect[]`

## `GET` /schemas/select/templates

Este endpoint está restringido al rol de superadmin, y devuelve una lista de tipo select con el id y title de los schemas template

**Tipos usados de TS:**

- **Response**: `SchemaSelect[]`

## `GET` /schemas/select/content-type/all

Este endpoint está restringido al rol de superadmin, y devuelve una lista de tipo select con el id y title de los schemas content type

**Tipos usados de TS:**

- **Response**: `SchemaSelect[]`

## `GET` /schemas/select/content-type/page

Este endpoint está restringido al rol de superadmin, y devuelve una lista de tipo select con el id y title de los schemas content type filtrado por los de tipo página

**Tipos usados de TS:**

- **Response**: `SchemaSelect[]`

## `GET` /schemas/select/content-type/simple

Este endpoint está restringido al rol de superadmin, y devuelve una lista de tipo select con el id y title de los schemas content type filtrado por los de tipo simple

**Tipos usados de TS:**

- **Response**: `SchemaSelect[]`

## `GET` /schemas/select/content-type/category

Este endpoint está restringido al rol de superadmin, y devuelve una lista de tipo select con el id y title de los schemas category

**Tipos usados de TS:**

- **Response**: `SchemaSelect[]`

## `GET` /schemas

Este endpoint devuelve el último schema cargado en base de datos 

**Tipos usados de TS:**

- **Response**: `SchemaRootConfig`
---

# Sites

## `GET` /sites

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites

<aside>
💡 **Params:**
?language
Añadidos con las mejoras en sites
?order
?liveStatus(online/offline)
?page
?itemsPerPage
?pagination (true/false),
?filterByLanguage(number)

</aside>

Obtiene la información de los sites. Con la query ?language devuelve solo los sites que contengan ese idioma.

**AÑADIDOS CON LAS MEJORAS EN SITES**

A partir de ahora en la respuesta de este endpoint llegarán dos propiedades. `recentSites` que será un array con los sites ordenados por los que haya visitado el user autentificado más recientemente y otro `allSites` que será un array con todos los sites más la propiedad `lastAccess` que será la última vez que el usuario autentificado visitó ese site.

Las nuevas queries que puedes consultar son:

- **order**. A partir de ahora podremos ordenar el listado de sites `allSites` por `name-asc` o `name-desc,` por `lastAccess-asc` o `lastAccess-desc` y por  `dateCreated-asc` o `dateCreated-desc`.
- **liveStatus**: Ahora podremos filtrar los sites por los publicados y no publicados.
- **query**: Se ha implementado la funcionalidad de buscador. Pasa una string en esta `query` y se buscará en el name del site.
- **page**, **itemsPerPage**, **pagination**. Opciones para la paginación.
- `filterByLanguage=number` Si le pasas un id de idioma te filtrará por los sites que tengan ese idioma activado

## `GET` /sites/all

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites

Obtiene la información de los sites. Es como el anterior, PERO incluye también los eliminados.

## `GET` /site/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites

Obtiene la información de un site.

```json
{
    "id": 87,
    "name": "Sprint 32 QA",
    "theme": "cli-theme",
    "author": {
        "id": 2,
        "email": "user@example.com",
        "roles": "ROLE_SUPERADMIN"
    },
    "published": "2020-12-09T13:02:43.000Z",
    "modified": "2021-01-28T17:17:19.000Z",
    "deleted": false,
    "headers": [
        {
            "id": 77,
            "hash": "84d3b330-4b09-4951-9985-2ae427b4c866",
            "type": "header",
            "isDefault": 0,
            "language": 2,
            "component": "Header",
            "title": "Header renamed",
            "note01": {
                "title": "",
                "text": "To configure social links go to settings/general/social. To activate search feature go to settings/actionables"
            },
            "showTopNavigation": false,
            "showSocialMedia": false,
            "showSearchFeature": false,
            "logo": null,
            "logoWhite": null,
            "primaryLink": {
                "component": "Link",
                "editorID": 1
            },
            "secondaryLink": {
                "component": "Link",
                "editorID": 2
            },
            "setAsDefault": true,
            "mainMenu": "",
            "topMenu": "",
            "sticky": true,
            "notificationBanner": false,
            "school": "",
            "editorID": 0
        },
        {
            "id": 78,
            "hash": "5a361289-c0c5-4082-9127-d8efffd4aedc",
            "type": "header",
            "isDefault": 0,
            "language": 2,
            "component": "Header",
            "title": "Header name",
            "note01": {
                "title": "",
                "text": "To configure social links go to settings/general/social. To activate search feature go to settings/actionables"
            },
            "showTopNavigation": false,
            "showSocialMedia": false,
            "showSearchFeature": false,
            "logo": null,
            "logoWhite": null,
            "primaryLink": {
                "component": "Link",
                "editorID": 1
            },
            "secondaryLink": {
                "component": "Link",
                "editorID": 2
            },
            "setAsDefault": true,
            "mainMenu": "",
            "topMenu": "",
            "sticky": true,
            "notificationBanner": false,
            "school": "",
            "editorID": 0
        },
        {
            "id": 79,
            "hash": "e39db3b4-890d-46aa-a4f1-6be2fa6dead3",
            "type": "header",
            "isDefault": 0,
            "language": 2,
            "component": "Header",
            "title": "Header name",
            "note01": {
                "title": "",
                "text": "To configure social links go to settings/general/social. To activate search feature go to settings/actionables"
            },
            "showTopNavigation": false,
            "showSocialMedia": false,
            "showSearchFeature": false,
            "logo": null,
            "logoWhite": null,
            "primaryLink": {
                "component": "Link",
                "editorID": 1
            },
            "secondaryLink": {
                "component": "Link",
                "editorID": 2
            },
            "setAsDefault": true,
            "mainMenu": "",
            "topMenu": "",
            "sticky": true,
            "notificationBanner": false,
            "school": "",
            "editorID": 0
        },
        {
            "id": 80,
            "hash": "a2e77d44-032f-4185-9911-cbfdd8da103c",
            "type": "header",
            "isDefault": 1,
            "language": 8,
            "component": "Header",
            "title": "eu-header",
            "note01": {
                "title": "",
                "text": "To configure social links go to settings/general/social. To activate search feature go to settings/actionables"
            },
            "showTopNavigation": false,
            "showSocialMedia": false,
            "showSearchFeature": false,
            "logo": null,
            "logoWhite": null,
            "primaryLink": {
                "component": "Link",
                "editorID": 1
            },
            "secondaryLink": {
                "component": "Link",
                "editorID": 2
            },
            "setAsDefault": false,
            "mainMenu": "",
            "topMenu": "",
            "sticky": true,
            "notificationBanner": false,
            "school": "",
            "editorID": 0
        },
        {
            "id": 82,
            "hash": "0b3f17d1-8207-4ddd-9bed-9b1b146c69fa",
            "type": "header",
            "isDefault": 1,
            "language": 2,
            "component": "Header",
            "title": "Header name",
            "note01": {
                "title": "",
                "text": "To configure social links go to settings/general/social. To activate search feature go to settings/actionables"
            },
            "showTopNavigation": false,
            "showSocialMedia": false,
            "showSearchFeature": false,
            "logo": null,
            "logoWhite": null,
            "primaryLink": {
                "component": "Link",
                "editorID": 1,
                "text": "Link",
                "url": {
                    "url": "",
                    "linkTo": 597,
                    "newTab": true,
                    "noFollow": false,
                    "size": null,
                    "icon": null,
                    "linkContainer": null,
                    "href": null,
                    "linkToURL": "https://your-instance.griddo.io/deutso/news2"
                },
                "style": "primary"
            },
            "secondaryLink": {
                "component": "Link",
                "editorID": 2
            },
            "setAsDefault": true,
            "mainMenu": "",
            "topMenu": "",
            "sticky": true,
            "notificationBanner": false,
            "school": "",
            "editorID": 0
        }
    ],
    "footers": [
        {
            "id": 40,
            "hash": "9ea642b1-1f2f-4cea-a2dd-a8683961d15d",
            "type": "footer",
            "isDefault": 0,
            "language": 2,
            "component": "Footer",
            "title": "Footer pruebas",
            "setAsDefault": false,
            "legalMenu": null,
            "school": ""
        },
        {
            "id": 76,
            "hash": "12c15b5e-532b-4258-9252-fcb99bc1f36e",
            "type": "footer",
            "isDefault": 1,
            "language": 2,
            "component": "Footer",
            "name": "nuevo default",
            "showWebLinks": true,
            "title": "footer renamed",
            "addButton": {
                "component": "Link",
                "editorID": 1
            },
            "copyrightText": null,
            "logo": null,
            "setAsDefault": false,
            "footerMenu": "",
            "legalMenu": null,
            "school": null,
            "theme": "accent",
            "editorID": 0
        }
    ],
    "thumbnail": null,
    "timezone": "Pacific/Honolulu",
    "favicon": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1603895477/thesaurus-dev/bs-avatar-5f9980b4ea567.svg",
    "hash": null,
    "bigAvatar": null,
    "smallAvatar": null,
    "socials": {
        "facebook": "https://facebook.com/ie"
    },
    "rendering": false,
    "slug": "/sprint-32-qa",
    "isPublished": false,
    "renderingHours": 0,
    "shouldBeUpdated": false,
    "updated": true,
    "home": "https://your-instance.griddo.io/sprint-32-qa/deutso",
    "scriptCode": "test de Script Code"
}
```javascript

## `GET` /site/:id/all

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.accessToSites

Obtiene la información de un site. Incluso si el site está eliminado.

## `POST` /site

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.createSite

Damos de alta un nuevo site. Se puede añadir un parámetro slug totalmente opcional (lo normal es prescindir de ello, se crea automáticamente slugificando el nombre del site; si el slug ya existiera, iría añadiendo el sufijo -1, -2, -3...).

```json
{
    "name": "Test",
    "defaultLanguage": 4
		"domain": 1,
		"path": "/"
}
```javascript

## `DELETE` /site/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.deleteSite

Borra un site (marca el flag deleted a true)

## `DELETE` /site/bulk

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.deleteSite

Borra un conjunto de sites (marca el flag deleted a true). Requiere el parámetro `sites` por `body`

```json
{
    "sites": [1,2,3,4]
}
```javascript

## `PUT` /site/:id/settings

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.manageSiteSettings

Configuración de site

```json
{
    "name": "Test",
		"timezone": "Europe/Madrid",
		"theme": "playground-theme",
		"favicon": "http://imagen.jpg",
    "smallAvatar": "http://imagen.jpg",
    "bigAvatar": "http://imagen.jpg",
		"thumbnail": "http://imagen.jpg"
}
```javascript

## `GET` /site/:site/socials

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.manageSocialMedia

Devuelve la configuración de redes sociales de un site.

```json
{
    "facebook": "https://facebook.com/ie"
}
```javascript

## `GET` /site/:site/images

🚨 **Permisos**: seoAnalytics.editSeoGlobalPages

Devuelve las imágenes asociadas a una site en concreto. Si en `:site` en vez del id, buscas por `global` te devolverá el listado de imágenes globales.

## `PUT` /site/:site/socials

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.manageSocialMedia

Guarda la configuración de redes sociales de un site.

```json
{
    "facebook": "https://facebook.com/ie"
}
```javascript

## `POST` /site/:siteId/publish

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.publishSite

Marca un site como publicado.

## `POST` /site/publish/bulk

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.publishSite

Marca un conjunto de sites como publicado. Requiere pasar por `body`:

```json
{
    "sites": [1,2,3,4]
}
```javascript

## `POST` /site/:siteId/unpublish

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.unpublishSite

Marca un site como despublicado.

## `POST` /site/unpublish/bulk

**🔑 Requiere autenticación.**

🚨 **Permisos**: general.unpublishSite

Marca un conjunto de sites como despublicado. Requiere pasar por `body`:

```json
{
    "sites": [1,2,3,4]
}
```javascript

## `GET` /site/:site/sitemap

🚨 **Permisos**: 

<aside>
💡 **Headers:**
lang

</aside>

Devuelve la información necesaria para generar el archivo sitemap.txt/sitemap.xml para el site e idioma indicados. En items devuelve todas las páginas a tener en cuenta para el sitemap. En url devuelve el domain y path (rutas físicas) en donde debería guardarse ese sitemap (como sitemap.txt o sitemap.xml, en función del formato elegido), si bien se puede guardar donde se quiera.

```json
{
    "totalItems": 3,
    "page": 1,
    "items": [
        {
            "loc": "https://your-instance.griddo.io/diego-test/ingles",
            "lastmod": "2021-01-22",
            "priority": 1
        },
        {
            "loc": "https://your-instance.griddo.io/diego-test/ingles/hija-de-ingles",
            "lastmod": "2021-01-28",
            "priority": 0.9
        },
        {
            "loc": "https://your-instance.griddo.io/diego-test/ingles/hija-de-ingles/nieta-de-ingles",
            "lastmod": "2021-01-28",
            "priority": 0.8
        }
    ],
    "url": {
        "path": "/diego-test",
        "domain": "/your-instance.griddo.io"
    }
}
```javascript

## `GET` /sites/build/launch

🚨 **Permisos**: 

No requiere autenticación. Devuelve true si hay sites pendientes de actualizar y por tanto se debe lanzar el disparador de Gatsby, o false si está todo actualizado y no hay que disparar a nada ni a nadie.

Si el resultado es false, hay una propiedad más en la respuesta `reason` donde se explica la razón por la que no debe hacerse el render.

```json
{
    "render": true
}
```javascript

## **`GET` /site/:siteId/build/start**

🚨 **Permisos**: superadmin

Avisa a la API de que se inicia un proceso de build, tal y como se indica en la [documentación](../Descripciones funcionalidades/Proceso en CX para renderizado de sites 8bb7a51f7b7a499d90b048a6bc9e8bee.md).

Cuando se hace esta llamada, se responde con una serie de parámetros referentes al build

```json
{
    "siteHash": "80fd2040-5df1-4552-bedc-5edf00117d6d",
    "publishIds": [
        1728,
        1727,
        2329,
        125299,
        132724,
    ],
    "unpublishHashes": [
	    "121a283c-0611-4d89-8b0a-b73ed14e28b1"
    ]
}
```javascript

- `siteHash`: El hash del site que se está renderizando.
- `publishIds`: Array de numbers con los ids de las páginas de ese site que cumplan las siguientes condiciones:
    - Que pertenezcan al site que se está renderizando.
    - Que no sean un borrador.
    - Que su estado sea publicado o pendiente de publicación.
    - Que su idioma sea cualquiera de los idiomas del site. (Es decir si el site está en inglés y español, devolverá todas las páginas en inglés y español).
    - Que la propiedad del site `is_published` sea igual a **true.** Un site tendrá esta propiedad como true si su estado es published o pending publishing.
- `unpublishHashes`: Esto devolverá un array de strings que son los hashes de las páginas que cumplan las siguientes condiciones:
    - Que pertenezcan al site que está renderizando.
    - Que no sean un borrador.
    - Cuyo estado sea `offline-pending`, es decir que la acabemos de despublicar pero aún no se ha despublicado.

## `POST` /site/:siteId/build/end

🚨 **Permisos**: superadmin

Avisa a la API de que se finaliza un proceso de build, tal y como se indica en la [documentación](../Descripciones funcionalidades/Proceso en CX para renderizado de sites 8bb7a51f7b7a499d90b048a6bc9e8bee.md).

Este endpoint espera que le llegue en el body los siguientes elementos:

```json
{
    "hash": "445cfb74-bdb9-4b19-896b-514a566cac66",
    "publishHashes": [],
    "unpublishHashes": []
}
```javascript

- `hash`: Es el hash del site a renderizar y que se extrae del endpoint anterior **`GET`/site/:siteId/build/start,** concretamente el siteHash.
- `publishHashes`: En el build start le llega a CX el array publishIds que no es más que un array de ids de página. En CX se van a renderizar cada una de ellas y por cada una de ellas renderizada sin errores, va a hacer un push con el hash de esa página en `publishHashes` y es lo que nos llega aquí.
- `unpublishHashes` Es el array de unplubishHashes que nos ha llegado también en el build start.

## `GET` /sites/build/redirects

🚨 **Permisos**: 

No requiere autenticación. Devuelve un array de objetos con todos los redirects a hacer. En from la ruta del fichero, y en to la url nueva.

Infra debe crear el fichero indicado en from, como archivo vacío, y a continuación subirlo al s3 con la etiqueta metadata de redireccionamiento, pero SOLO si el fichero no existe en la carpeta, ya que si se ha generado el fichero en el proceso de Gatsby significa que esa dirección existía, se convirtió en otra distinta, pero ahora contiene otra página que prevalece sobre el redirect.

```json
[
    {
        "from": "/pre-ie-edu/d-test/cool-page",
        "to": "//cx.dev.griddo.io/pre-ie-edu/d-test/cool-page-nueva/"
    }
]
```javascript

## `GET` /select/sites/template/:template

🚨 **Permisos**: general.accessToSites

Devuelve un listado en formato select con la lista de sites publicados que tengan activados un paquete de datos que contenga esta template.

```json
[
    {
        "value": 31,
        "label": "Demo"
    },
    {
        "value": 41,
        "label": "Prueba Menu"
    }
]
```javascript

## `GET` /select/sites

🚨 **Permisos**: general.accessToSites

Devuelve un listado en formato select con la lista de sites publicados.

```json
[
    {
        "value": 31,
        "label": "Demo"
    },
    {
        "value": 41,
        "label": "Prueba Menu"
    }
]
```javascript

## `POST` /site-activity/:siteId

🚨 **Permisos**: general.accessToSites

Actualiza el último acceso a un site del usuario actual.

## `POST` /sync-content

🚨 **Permisos**: superadmin

Este endpoint solo está disponible internamente para el SDK y se encarga de que, cuando ha terminado un trabajo en el que se hayan editado páginas en bloque, calcule qué opción es menos costosa: renderizar todo el sitio por completo o ejecutar la función de ***Actualización automática de páginas relacionadas*** para cada una de las páginas actualizadas.
---

# Structured Data

## Ejemplo de definición de un dato estructurado

```json
"NEWS": {
            "title": "News",
						"dataPacks": [ "NEWS" ],
            "local": false,
            "taxonomy": false,
            "fromPage": true,
            "translate": true,
						"editable": true,
						"clone": null,
						"defaultValues": null,
            "schema": {
								"templates": [ "NewsDetail" ],
                "fields": [
                    {
								      "key": "title",
								      "title": "Title",
								      "from": "title",
								      "type": "TextField",
								      "showList": "false"
								    },
								    {
								      "key": "abstract",
								      "title": "Abstract",
								      "from": "abstract",
								      "type": "TextField",
								      "showList": false
								    },
								    {
								      "key": "image",
								      "title": "Image",
								      "from": "image",
								      "type": "ImageField",
								      "showList": false
								    },
								    {
								      "key": "categories",
								      "title": "Categories",
								      "from": "categories",
								      "type": "AsyncCheckGroup",
								      "source": "NEWS_AREAS",
								      "indexable": true,
								      "showList": true
								    },
								    {
								      "key": "lead",
								      "title": "Lead",
								      "from": "lead",
								      "type": "TextField",
								      "showList": false
								    },
								    {
								      "key": "longAbstract",
								      "title": "longAbstract",
								      "from": "longAbstract",
								      "type": "TextField",
								      "showList": false
								    },
								    {
								      "key": "content",
								      "title": "Content",
								      "from": "content",
								      "type": "TextField",
								      "showList": false
								    },
								    {
								      "key": "date",
								      "title": "Date",
								      "from": "date",
								      "type": "TextField",
								      "showList": false
								    }
                ],
								"searchFrom": [ "lead", "longAbstract", "content" ]
            }
```javascript

**Explicación:**

- `title`: el nombre “visible”.
- `local`: si es local o global.
- `taxonomy`: si es una taxonomía o un dato complejo. La diferencia es que una taxonomía no tiene que definir fields ni esquema, porque solo tiene título y slug.
- `fromPage`: si el contenido del dato se rellena manualmente o se extrae de una página.
- `translate`: si el contenido es traducible o es el mismo para todos los idiomas.
- `editable`: si el contenido, una vez creado, es editable o no.
- `schema`:
    - `fields`:
        - `key`: la key por la que reconocemos internamente el campo.
        - `title`: el nombre “visible” de ese campo.
        - `mandatory`: si es obligatorio o no.
        - `type`: el tipo del dato (obligatorio cuando no es fromPage, recomendable siempre que sea posible).
        - `from`: si es un dato de página, la propiedad de la template de página de la que debe extraer el valor de ese campo.
        - `showList`: Por defecto es false. Si en los listados ese campo debe incluirse como un dato más. OJO: lo normal es que si es showList también debe ser indexable.
        - `indexable`: Por defecto es false. Si ese campo se va a utilizar como índice (para poder ordenar por ese campo, etc.)
        - `searchable`: solo para el campo con key “title”. Si está a false, ese título no será utilizado en búsquedas.
    - `searchFrom`: array con la lista de keys cuyo contenido se podrá utilizar para hacer una búsqueda.

Sobre los campos, estas keys hay que tenerlas en cuenta:

- **`title`** es **obligatorio, siempre**. Si tiene searchable=false, NO se utilizará para búsquedas (por defecto se entiende que es true). Es lo que se usa por ejemplo para los listados de datos estructurados.
- **`abstract`** es recomendado, ya que se utiliza para listados y búsquedas.
- **`image`** es el que se usará como imagen en dichos listados y búsquedas, si aplica.

## `GET` /select/categories/:structuredData

🚨 **Permisos**: globalData.readGlobalData

Devuelve todas las categorías que forman parte de un tipo de datos estructurados.

```json
[
    {
        "value": "NEWS_AREAS",
        "label": "News Areas"
    }
]
```javascript

## `GET` /structured_data

🚨 **Permisos**: globalData.readGlobalData

Devuelve todos los tipos de datos estructurados globales.

```json
{
    "totalItems": 2,
		"schemasVersion": "2.0.0",
    "schemasTimestamp": "2021-09-23T12:26:30.000Z",
    "items": [
        {
            "id": "CATEGORIES",
            "title": "Categories",
            "local": false,
            "taxonomy": true,
            "fromPage": false,
            "translate": true,
						"editable": true,
            "schema": {
                "fields": [
                    {
                        "key": "title",
                        "name": "Category Name",
                        "mandatory": true,
                        "type": "TextField",
                    },
                    {
                        "key": "department",
                        "name": "Department",
                        "mandatory": true,
                        "type": "TextField"
                    },
                    {
                        "key": "school",
                        "name": "School",
                        "mandatory": true,
                        "type": "TextField",
												"showList": false
                    }
                ]
            },
            "clone": {}
        },
        {
            "id": "INTERNATIONAL_OFFICES",
            "title": "International Offices",
            "local": false,
            "taxonomy": false,
            "fromPage": false,
            "translate": false,
						"editable": true,
            "schema": {
                "templates": [],
                "fields": [
                    {
                        "key": "title",
                        "name": "City",
                        "type": "TextField",
                        "mandatory": true
                    },
                    {
                        "key": "address",
                        "name": "Address",
                        "type": "TextField",
                        "mandatory": true
                    },
                    {
                        "key": "phone",
                        "name": "Phone",
                        "type": "TextField",
                        "mandatory": true
                    },
                    {
                        "key": "email",
                        "name": "E-mail",
                        "type": "TextField",
                        "mandatory": true
                    },
                    {
                        "key": "latitude",
                        "name": "Location: Latitude",
                        "type": "TextField",
                        "mandatory": true
                    },
                    {
                        "key": "longitude",
                        "name": "Location: Longitude",
                        "type": "TextField",
                        "mandatory": true
                    }
                ]
            },
            "clone": {}
        }
    ]
}
```javascript

## `GET` /structured_data/titles/:items

🚨 **Permisos**: globalData.readGlobalData

Devuelve los títulos de todos los datos estructurados indicados en :items (separados por comas si son más de uno). Por ejemplo `/structured_data/titles/NEWS,EVENTS`.

```json
[
    {
        "id": "EVENTS",
        "title": "Events"
    },
    {
        "id": "NEWS",
        "title": "News"
    }
]
```javascript

## `GET` /site/:site/structured_data

🚨 **Permisos**: globalData.readGlobalData

Devuelve todos los tipos de datos estructurados válidos para un site (no incluye los globales).

```json
{
    "totalItems": 1,
    "items": [
        {
            "id": "PROGRAMS",
            "title": "Programs",
            "local": true,
            "taxonomy": false,
            "fromPage": false,
            "translate": true,
						"editable": true,
            "schema": {
                "fields": [
                    {
                        "key": "title",
                        "name": "Program Name",
                        "mandatory": true,
                        "type": "TextField"
                    },
                    {
                        "key": "department",
                        "name": "Department",
                        "mandatory": true,
                        "type": "TextField"
                    },
                    {
                        "key": "school",
                        "name": "School",
                        "mandatory": true,
                        "type": "TextField"
                    }
                ]
            },
            "clone": {}
        }
    ]
}
```javascript

## `GET` /structured_data_contents

🚨 **Permisos**: globalData.readGlobalData

<aside>
💡 **Headers:**
lang

**Params:**
?page
?itemsPerPage
?pagination (true/false)
?deleted (true/false; default: false)
?includeDraft (true/false; default: false)
?includePendingPublishing (true/false; default: true)
?query (string para filtrar la búsqueda sobre los title)
?order (recent/alpha; default: recent)
?filterFromPage (true/false)
?related (id de otros datos estructurados separados por comas para filtrar los que estén relacionados con este; por ejemplo el id de máster para mostrar todos los másters)
?filterOperator (and/or, por defecto ‘or’)
?globalOperator (and/or, por defecto ‘and’)
?exclude (id o lista de ids separados por comas de los datos que se quieran excluir de la consulta).
?liveStatus
?translated
?allLanguages
?preferenceLanguage

</aside>

Muestra el contenido de todos los datos estructurados globales.

`order` puede ser recent, alpha, o cualquier campo que esté definido en el schema del dato estructurado como `indexable: true` (sólo se puede ordenar por custom fields que hayan sido definidos como indexables en los esquemas). Como en los listados de página, se le puede indicar la dirección del orden añadiendo -ASC o -DESC. Ejemplo: `startDate-DESC`. Recent y alpha también aceptan -ASC y -DESC como sufijo.

`filterFromPage` muestra solo los que son de página.

Si se indica `lang`, mostrará solo los que estén en ese idioma. Si no se indica, mostrará todos los disponibles dando prioridad a los que están en el idioma por defecto del site y si no al idioma por defecto global.

`filterOperator` y `globalOperator` son los operadores lógicos (or/and) a aplicar sobre los filtros indicados (related). FilterOperator se aplica solo a los del mismo grupo, y globalOperator se aplica entre distintos grupos. Por ejemplo, si queremos un distribuidor de noticas, y en el filtro indicamos dos escuelas (ESCUELA_1, ESCUELA_2) y dos áreas (AREA_1, AREA_2), filterOperator se aplicará a los filtros de escuelas y a los de áreas, y globalOperator se aplicará a la relación entre escuelas y áreas. Es decir, sería un (ESCUELA_1 ${filterOperator} ESCUELA_2) ${globalOperator} (AREA_1 ${globalOperator} AREA_2). Si filterOperator es or y globalOperator es and (que son los valores por defecto), nos quedaría: (ESCUELA_1 or ESCUELA_2) and (AREA_1 or AREA_2). Mientras no se indiquen explícitamente en los default de la template ni se puedan gestionar desde AX se estarán usando esos valores por defecto.

`allLanguages` opcional. Por defecto, false. Si está a true, devuelve resultados en cualquier idioma, priorizando (1) el idioma indicado en headers y (2) el idioma principal del site. Por ejemplo cuando es un listado de programas en el que se tienen que mostrar todos los idiomas pero hay programas que están solo en inglés.

```json
{
		"page": 1,
    "totalItems": 2,
		"schemasVersion": "2.0.0",
    "schemasTimestamp": "2021-09-23T12:26:30.000Z",
    "items": [
        {
            "id": 82,
            "structuredData": "PROJECTS",
						 "relatedSite": null,
            "relatedPage": {
                "pageId": 869,
                "url": "//cx.dev.griddo.io/pre-ie-edu/test-gonzalo-h/lil-bub/",
                "origin": "EDITOR",
                "availableSites": [
                    {
                        "id": 42,
                        "name": "QA Gonzalo H"
                    }
                ],
                "editable": true,
                "manuallyImported": false
            },
            "content": {
                "title": "New project",
                "department": "",
                "school": ""
            },
            "entity": "5f3cf8b57dd930.77822368",
            "draft": false,
            "published": "2020-08-19T08:02:29.000Z",
            "modified": null,
            "deleted": false,
            "language": 4,
						"dataLanguages": [
                {
                    "site": null,
                    "language": 2,
                    "id": 82
                },
                {
                    "site": null,
                    "language": 4,
                    "id": 108
                }
            ]
        },
        {
            "id": 84,
            "structuredData": "PROGRAMS",
            "relatedSite": null,
            "relatedPage": null,
            "content": {
                "title": "prueba 1",
                "department": "asda",
                "school": "asd"
            },
            "entity": "5f3e52d40d73d8.33387053",
            "draft": false,
            "published": "2020-08-20T08:39:16.000Z",
            "modified": null,
            "deleted": false,
            "language": 4,
						"dataLanguages": [
                {
                    "site": null,
                    "language": 2,
                    "id": 84
                },
                {
                    "site": null,
                    "language": 4,
                    "id": 108
                }
            ]
        }
    ]
}
```javascript

## `GET` /site/:site/structured_data_contents

🚨 **Permisos**: globalData.readGlobalData

<aside>
💡 **Headers:**
lang

**Params:**
?page
?itemsPerPage
?pagination
?deleted (true/false; default: false)
?includeDraft (true/false; default: false)
?includePendingPublishing (true/false; default: true)
?query (string para filtrar la búsqueda sobre los title)
?order (recent/alpha; default: recent)
?related (id de otros datos estructurados separados por comas para filtrar los que estén relacionados con este; por ejemplo el id de máster para mostrar todos los másters)

</aside>

Muestra el contenido de todos los datos estructurados del site indicado.

Si se indica `lang`, mostrará solo los que estén en ese idioma. Si no se indica, mostrará todos los disponibles dando prioridad a los que están en el idioma por defecto del site y si no al idioma por defecto global.

```json
{
		"page": 1,
    "totalItems": 1,
		"schemasVersion": "2.0.0",
    "schemasTimestamp": "2021-09-23T12:26:30.000Z",
    "items": [
        {
            "id": 104,
            "structuredData": "SITE_CATEGORIES",
            "relatedSite": 1,
            "relatedPage": null,
            "content": {
                "title": "aa",
                "code": "aa"
            },
            "entity": "5f450770350824.92505450",
            "draft": false,
            "published": "2020-08-25T10:43:28.000Z",
            "modified": null,
            "deleted": false,
            "language": 4,
						"dataLanguages": [
                {
                    "site": 1,
                    "language": 2,
                    "id": 104
                },
                {
                    "site": 1,
                    "language": 4,
                    "id": 156
                }
            ]
        }
    ]
}
```javascript

## `GET` /structured_data_contents/:structuredData

🚨 **Permisos**: globalData.readGlobalData

<aside>
💡 **Headers:**
lang

**Params:** 
?page
?itemsPerPage
?pagination
?deleted (true/false; default: false)
?includeDraft (true/false; default: false)
?includePendingPublishing (true/false; default: true)
?search (string para filtrar la búsqueda sobre los title)
?order (date/title; default: date)
?related (id de otros datos estructurados separados por comas para filtrar los que estén relacionados con este; por ejemplo el id de máster para mostrar todos los másters) 
?translated (admite los valores `all` por defecto y `no` que mostrará las páginas que no tengan traducción.
?liveStatus (admite `offline` y `active`, dependiendo del estado que te interese, por defecto `all`)
?relatedFields (true/false; default: false, si se indica los valores de datos estructurados relacionados se muestran como objetos con id y label en lugar de solo los id)

</aside>

Devuelve los datos estructurados del tipo especificado (para un tipo de dato estructurado global).

Si se indica `lang`, mostrará solo los que estén en ese idioma. Si no se indica, mostrará todos los disponibles dando prioridad a los que están en el idioma por defecto del site y si no al idioma por defecto global.

Se puede ordenar tanto por `title` como por `date` de manera ascendente o descendente. Para ello deberás añadir en el param `?order` el campo que quieras ordenar seguido de guión y las keywords `asc` y `desc`.

*?order=title-asc || ?order=title-desc || ?order=date-asc || ?order=date-desc*

```json
{
    "totalItems": 2,
    "items": [
        {
            "id": 84,
            "structuredData": "PROGRAMS",
            "relatedSite": null,
            "relatedPage": null,
            "content": {
                "title": "prueba 1",
                "department": "asda",
                "school": "asd"
            },
            "entity": "5f3e52d40d73d8.33387053",
            "draft": false,
            "published": "2020-08-20T08:39:16.000Z",
            "modified": null,
            "deleted": false,
            "language": 4,
						"dataLanguages": [
                {
                    "site": null,
                    "language": 2,
                    "id": 84
                },
                {
                    "site": null,
                    "language": 4,
                    "id": 108
                }
            ]
        },
        {
            "id": 85,
            "structuredData": "PROGRAMS",
            "relatedSite": null,
            "relatedPage": null,
            "content": {
                "title": "sara pro",
                "department": "ss",
                "school": "ss"
            },
            "entity": "5f3e571844ab79.21999198",
            "draft": false,
            "published": "2020-08-20T08:57:28.000Z",
            "modified": null,
            "deleted": false,
            "language": 4,
						"dataLanguages": [
                {
                    "site": null,
                    "language": 2,
                    "data": 85
                },
                {
                    "site": null,
                    "language": 4,
                    "id": 123
                }
            ]
        }
    ]
}
```javascript

## `GET` /site/:site/structured_data_contents/:structuredData

🚨 **Permisos**: globalData.readGlobalData

<aside>
💡 **Headers:**
lang

**Params:**
?page
?itemsPerPage
?pagination
?deleted (true/false; default: false)
?includeDraft (true/false; default: false)
?includePendingPublishing (true/false; default: true)
?query (string para filtrar la búsqueda sobre los title)
?order (recent/alpha; default: recent)
?related (id de otros datos estructurados separados por comas para filtrar los que estén relacionados con este; por ejemplo el id de máster para mostrar todos los másters)
?relatedFields (true/false; default: false, si se indica los valores de datos estructurados relacionados se muestran como objetos con id y label en lugar de solo los id)
?excluded (id o ids de los datos que quieras excluir de la búsqueda)
?search (Busca entre los resultados los datos estructurados que cuenten con las palabras que especifiques aquí en el título o en el abstract)

</aside>

Devuelve todos los datos estructurados del tipo especificado para el site indicado (para un tipo de dato estructurado de site).

Se pueden indicar varios datos estructurados separados por comas. En ese caso hay que tener cuidado de que todos o ninguno sean de página. No se pueden mezclar datos de página y puros en la misma consulta, el resultado será como mínimo extraño.

Si se indica `lang`, mostrará solo los que estén en ese idioma. Si no se indica, mostrará todos los disponibles dando prioridad a los que están en el idioma por defecto del site y si no al idioma por defecto global.

```json
{
    "totalItems": 1,
    "items": [
        {
            "id": 104,
            "structuredData": "SITE_CATEGORIES",
            "relatedSite": 1,
            "relatedPage": null,
            "content": {
                "title": "aa",
                "code": "aa"
            },
            "entity": "5f450770350824.92505450",
            "draft": false,
            "published": "2020-08-25T10:43:28.000Z",
            "modified": null,
            "deleted": false,
            "language": 4,
						"dataLanguages": [
                {
                    "site": 1,
                    "language": 2,
                    "data": 104
                },
                {
                    "site": 1,
                    "language": 4,
                    "id": 108
                }
            ]
        }
    ]
}
```javascript

## `GET` /site/:site/structured_data_contents/:structuredData/checkgroup

🚨 **Permisos**: globalData.readGlobalData

<aside>
💡 **Headers:**
lang
**Params:**
?allLanguages,
?order
?languagesIds

</aside>

Devuelve todos los datos estructurados del tipo indicado, para ese site e idioma, en formato check-group. También devuelve el array `dataLanguages` que es un array de objetos con las versiones que tiene en cada idioma ese dato estructurado concreto. 

- `allLanguages` opcional. Por defecto, false. Si está a true, devuelve resultados en cualquier idioma, priorizando (1) el idioma indicado en headers y (2) el idioma principal del site. Por ejemplo cuando es un listado de programas en el que se tienen que mostrar todos los idiomas pero hay programas que están solo en inglés.
- `order` Se puede ordenar tanto por `title` como por `date` de manera ascendente o descendente. Para ello deberás añadir en el param `?order` el campo que quieras ordenar seguido de guión y las keywords `asc` y `desc`.
- `languagesIds` Listado de ids de idioma en el que quieras que te devuelvan los resultados. En el caso de que haya traducciones se devolverá el item en el idioma que llegue por el header.

*?order=title-asc || ?order=title-desc || ?order=date-asc || ?order=date-desc*

```json
[
    {
        "value": 6468,
        "name": 6468,
        "title": "Durmstrang esp",
        "dataLanguages": [ // Este dato estructurado tiene traducción en inglés y español
            {
                "id": 6468,
                "site": null,
                "page": null,
                "language": 2
            },
            {
                "id": 6266,
                "site": null,
                "page": null,
                "language": 4
            }
        ]
    },
    {
        "value": 6495,
        "name": 6495,
        "title": "escuela esp",
        "dataLanguages": [ // Este dato estructurado está solo en español
            {
                "id": 6495,
                "site": null,
                "page": null,
                "language": 2
            }
        ]
    }
]
```javascript

## `GET` /structured_data_content/:id

🚨 **Permisos**: globalData.readGlobalData

<aside>
💡 **Headers:**
lang (default: default del site; si no lo hay, default del sistema)

**Params:**
?relatedFields (true/false; default: false, si se indica los valores de datos estructurados relacionados se muestran como objetos con id y label en lugar de solo los id)

</aside>

Devuelve la información del dato estructurado indicado, en el idioma especificado.

```json
{
    "id": 107,
    "structuredData": "INTERNATIONAL_OFFICES",
    "relatedSite": 1,
    "relatedPage": null,
    "content": {
        "title": "OTRA PRUEBAasda",
        "address": "asad",
        "phone": "sadasd",
        "email": "sdsfsdf",
        "latitude": "2323,3",
        "longitude": "323,33"
    },
    "entity": "test",
    "draft": false,
    "published": "2020-08-26T07:23:28.000Z",
    "modified": null,
    "deleted": false,
    "language": 4,
		"dataLanguages": [
                {
                    "site": null,
                    "languag": 2,
                    "id": 107
                },
****                {
                    "site": null,
                    "language": 4,
                    "id": 108
                }
            ]
}
```javascript

## `GET` /site/:site/structured_data_content/:id

🚨 **Permisos**: globalData.readGlobalData

Como [/structured_data_content/:id](Structured Data 40ba51a1c45941c38ce81d7f105cfb36.md), pero indicando el site. Recomendable cuando estamos trabajando con datos globales de página.

## `GET` /structured_data_content/bulk/:ids

🚨 **Permisos**: globalData.readGlobalData

Como [/structured_data_content/:id](Structured Data 40ba51a1c45941c38ce81d7f105cfb36.md), pero indicando varios ids separados por comas.

## `GET` site/:site/structured_data_content/bulk/:ids

🚨 **Permisos**: globalData.readGlobalData

Como [/structured_data_content/:id](Structured Data 40ba51a1c45941c38ce81d7f105cfb36.md), pero indicando varios ids separados por comas y segmentado a un site concreto.

## `POST` /structured_data_content

🚨 **Permisos**: globalData.createDraft

Crea un dato estructurado.

Precaución: para evitar duplicidades accidentales y desajustes, si se detecta que se está haciendo un post para una combinación de tipo_de_dato_estructurado+entity+site+language se considerará como un put de ese elemento ya existente.

**Body de la petición:**

```json
{
	"structuredData": "PROGRAMS",
	"relatedSite": 1, // Cuando es de site
	"relatedPage": 5, // Cuando es de página
	"entity": "a1231-234-cb543-cad4", // Si no existe se crea
	"content": {
			"title": "Titulo del dato", // Obligatorio
			"image": {} // Id de imagen o Objeto Imagen (extrae el id del objeto)
			"abstract": "Un resumen para búsquedas o listados", // Sería el resumen a usar en listados
			"otracosa": "xxxxx",
			"category": [25], // Las relaciones entre datos estructurados van siempre en array.
		},
	"draft": false, // Por defecto, false
	"language": 2 // Por defecto, el default del site (si hay relatedSite) o el global.
	"publicationScheduled": "2024-07-12T10:27:11.508Z", // La fecha en la que el dato será publicado o null
}
```javascript

Devuelve la información realmente almacenada del dato indicado (incluyendo el id y el entity en caso que tuviera que haber sido creado):

```json
{
    "id": 116,
    "structuredData": "PROGRAMS",
    "relatedSite": 1,
    "relatedPage": 5,
    "content": {
    		"title": "Titulo del dato",
				"image": {
           "id": 1,
           "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1599734114/thesaurus-dbtest/screenshot-2020-09-10-at-123504-5f5a015fa9ab2.png",
					 "alt": "Texto alternativo",
					 "width": 1920,
					 "height": 1080
        },
				"abstract": "Un resumen para búsquedas o listados",
				"otracosa": "xxxxx",
				"category": [25],
    },
    "entity": "e2f99e29-b9ac-4a6e-9c1b-a22a82c0c112",
    "draft": false,
    "published": "2020-08-31T13:35:52.000Z",
    "modified": null,
    "deleted": false,
    "language": 2
}
```javascript

## `PUT` /structured_data_content/:id

🚨 **Permisos**: globalData.editAllGlobalData

Funciona como el `POST`, solo que aplicado al dato estructurado referenciado en el id.

## `PUT` /structured_data_content/:id/:{draft|undraft}

🚨 **Permisos**: globalData.editAllGlobalData

Publica o despublica (según la opción elegida en el endpoint) el dato estructurado referenciado en el id.

## `PUT` /structured_data_content/:{draft|undraft}/bulk

🚨 **Permisos**: globalData.editAllGlobalData

Publica o despublica (según la opción elegida en el endpoint) los datos estructurados cuyos id's pasamos en el body

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

## `DELETE` /structured_data_content/:id

🚨 **Permisos**: globalData.deleteAllGlobalData

Elimina el dato estructurado con el id indicado.

## `DELETE` /structured_data_content/bulk

🚨 **Permisos**: globalData.deleteAllGlobalData

Elimina los datos estructurados indicados pasados en un array en el body.

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

Si hubiera algún problema, devolverá un array con el id del elemento que ha fallado y el mensaje de error

```json
{
    "code": 400,
    "message": [
        {
            "id": 210
            "error": "Structured Data not found."
        }
    ]
}
```javascript

## `POST` /site/:site/distributor

🚨 **Permisos**: globalData.createAllGlobalData

⚠️ **CAMBIOS OPERADORES LÓGICOS** ⚠️

Con el nuevo cambio de esquema de los distribuidores a raíz de la funcionalidad de operadores lógicos, se ha cambiado la manera en los que vamos a recibir los datos en el body en el modo automático. 

En lugar de como lo estábamos recibiendo hasta ahora, el nuevo esquema será así:

**Body de la petición (modo automático):**

```json
{
    "mode": "auto",
    "order": "newsDate-DESC",
    "quantity": 6,
    "sources": [
        {
            "structuredData": "EVENTS",
            "filters": [
                {
                    "id": 2686,
                    "label": "Bachelor",
                    "source": "EVENTS"
                }
            ],
            "globalOperator": "AND",
            "filterOperator": "ANY"
        }
    ],
    "fullRelations": false
}
```javascript

Los cambios a tener en cuenta serán:

- Ahora los los operadores y filtros son por content type y no globales.
- El `filterOperator` es `all || any` y ya no es `and || or` como antes

Las demás propiedades siguen funcionando como hasta ahora.

- `source` es obligatorio = Structured Data de origen. Es un array, pueden ser varios orígenes de datos.
- `filter`: opcional, id de otros structured data con los que estaría relacionado y dato estructurado al que se aplica ese filtro.
- `order`: opcional. Recent / Alpha / customfield-(ASC|DESC), por defecto recent, siendo customfield un campo del esquema del dato estructurado con indexable:true. Por ejemplo: startDate-DESC. Recent y alpha aceptan -ASC y -DESC como sufijo.
- `quantity`: opcional. Cantidad de elementos a devolver.
- `allLanguages`: opcional. Por defecto, false. Si está a true, devuelve resultados en cualquier idioma, priorizando (1) el idioma indicado en headers y (2) el idioma principal del site. Por ejemplo cuando es un listado de programas en el que se tienen que mostrar todos los idiomas pero hay programas que están solo en inglés.
- `fullRelations`: opcional. Por defecto, false. Si está a true, devuelve todas las relaciones mapeadas con sus valores completos (en false solo devuelve id y label, en true devuelve id y content).
- `mapRelations`: opcional. Por defecto es true. Si está a false, no hace un mapeado de las relaciones y devolverá solo los ids.
- `filterOperator` (all || any) y `globalOperator` (and || or): opcionales. Por defecto 'any' para filterOperator y ‘and’ para globalOperator. Son los operadores lógicos (or/and) a aplicar sobre los filtros indicados. FilterOperator se aplica solo a los del mismo grupo, y globalOperator se aplica entre distintos grupos. Por ejemplo, si queremos un distribuidor de noticias, y en el filtro indicamos dos escuelas (ESCUELA_1, ESCUELA_2) y dos áreas (AREA_1, AREA_2), filterOperator se aplicará a los filtros de escuelas y a los de áreas, y globalOperator se aplicará a la relación entre escuelas y áreas. Es decir, sería un (ESCUELA_1 ${filterOperator} ESCUELA_2) ${globalOperator} (AREA_1 ${filterOperator} AREA_2). Si filterOperator es or y globalOperator es and (que son los valores por defecto), nos quedaría: (ESCUELA_1 or ESCUELA_2) and (AREA_1 or AREA_2). Mientras no se indiquen explícitamente en los default de la template ni se puedan gestionar desde AX se estarán usando esos valores por defecto.
- `preferenceLanguage` : opcional. Por defecto, false pero solo funcionará si la propiedad `allLanguages` también está activada. Los resultados se ordenarán de tal manera que primero aparecerán los items en el idioma de la página y luego el resto. Además si se establece `order`, los resultados vendrán ordenados por el parámetro que le hayamos pasado. Ej. si se ordena por nombre, tendríamos primero los del idioma de la página ordenados alfabéticamente, y luego los del resto de idiomas ordenados también alfabéticamente

---

⚠️ **DEPRECATED** ⚠️

Recibido un esquema de distributor en el body, devuelve un array con el contenido neto resultante, ajustado al site indicado en la url y el idioma indicado en el header.

Cuando se trata de la edición de una página global, site será "global". Ej: /site/global/distributor.

<aside>
💡 **Headers:**
lang (default: default del site; si no lo hay, default del sistema)

</aside>

**Body de la petición (modo automático):**

```json
{
	mode: 'auto',
	source: ['NEWS'],
	filter: [{id: 9, source: 'NEWS'}],
	order: 'recent',
	quantity: 5,
	allLanguages: true,
  fullRelations: true,
	filterOperator: 'or',
	globalOperator: 'and',
	preferenceLanguage: true
}
```javascript

- `source` es obligatorio = Structured Data de origen. Es un array, pueden ser varios orígenes de datos.
- `filter`: opcional, id de otros structured data con los que estaría relacionado y dato estructurado al que se aplica ese filtro.
- `order`: opcional. Recent / Alpha / customfield-(ASC|DESC), por defecto recent, siendo customfield un campo del esquema del dato estructurado con indexable:true. Por ejemplo: startDate-DESC. Recent y alpha aceptan -ASC y -DESC como sufijo.
- `quantity`: opcional. Cantidad de elementos a devolver.
- `allLanguages`: opcional. Por defecto, false. Si está a true, devuelve resultados en cualquier idioma, priorizando (1) el idioma indicado en headers y (2) el idioma principal del site. Por ejemplo cuando es un listado de programas en el que se tienen que mostrar todos los idiomas pero hay programas que están solo en inglés.
- `fullRelations`: opcional. Por defecto, false. Si está a true, devuelve todas las relaciones mapeadas con sus valores completos (en false solo devuelve id y label, en true devuelve id y content).
- `filterOperator` y `globalOperator`: opcionales. Por defecto 'or' para filterOperator y ‘and’ para globalOperator. Son los operadores lógicos (or/and) a aplicar sobre los filtros indicados. FilterOperator se aplica solo a los del mismo grupo, y globalOperator se aplica entre distintos grupos. Por ejemplo, si queremos un distribuidor de noticias, y en el filtro indicamos dos escuelas (ESCUELA_1, ESCUELA_2) y dos áreas (AREA_1, AREA_2), filterOperator se aplicará a los filtros de escuelas y a los de áreas, y globalOperator se aplicará a la relación entre escuelas y áreas. Es decir, sería un (ESCUELA_1 ${filterOperator} ESCUELA_2) ${globalOperator} (AREA_1 ${filterOperator} AREA_2). Si filterOperator es or y globalOperator es and (que son los valores por defecto), nos quedaría: (ESCUELA_1 or ESCUELA_2) and (AREA_1 or AREA_2). Mientras no se indiquen explícitamente en los default de la template ni se puedan gestionar desde AX se estarán usando esos valores por defecto.
- `preferenceLanguage` : opcional. Por defecto, false pero solo funcionará si la propiedad `allLanguages` también está activada. Los resultados se ordenarán de tal manera que primero aparecerán los items en el idioma de la página y luego el resto. Además si se establece `order`, los resultados vendrán ordenados por el parámetro que le hayamos pasado. Ej. si se ordena por nombre, tendríamos primero los del idioma de la página ordenados alfabéticamente, y luego los del resto de idiomas ordenados también alfabéticamente.

**Body de la petición (modo manual)**

```json
{
	mode: 'manual',
	fixed: [190, 189]
}

// Fixed: Id de los datos estructurados a devolver.
```javascript

**Respuesta:**

```json

[
    {
        "structuredData": "BASIC_PAGE",
        "id": 56,
        "relatedPage": {
            "pageId": 33,
            "url": "/es/"
        },
        "content": {
            "title": "New Page Edited",
            "abstract": "",
						"image": {
		           "id": 1,
		           "url": "https://res.cloudinary.com/thesaurus-cms/image/upload/v1599734114/thesaurus-dbtest/screenshot-2020-09-10-at-123504-5f5a015fa9ab2.png",
							 "alt": "Texto alternativo",
							 "width": 1920,
							 "height": 1080
            }
        }
    },
    {
        "structuredData": "BASIC_PAGE",
        "id": 26,
        "relatedPage": {
            "pageId": 18,
            "url": "/es/new-page"
        },
        "content": {
            "title": "New Page Edited Again",
            "abstract": "Esto es un resumen de la página chulo.",
            "image": null
        }
    }
]
```javascript

**Body de la petición (modo navigation: recibir anterior y posterior)**

```jsx
{
    "mode": "navigation",
    "order": "newsDate-ASC",
    "referenceId": 466,
    "quantity": 3,
    "fullRelations": false
}	

// ReferenceId es el id del dato estructurado del que queremos conseguir el anterior y el posterior
// quantity es opcional, por defecto es 1
// fullRelations es opcional, por defecto es false
```javascript

**Ejemplo de respuesta modo navigation:**

```json
{
    "previous": [
        {
            "structuredData": "NEWS",
            "id": 24533,
            "language": 1,
            "dataLanguages": [],
            "relatedSite": 12,
            "relatedPage": {
                "pageId": 28145,
                "url": "https://www.ie.edu/school-politics-economics-global-affairs/students-living-coronavirus-outbreak/",
                "origin": "GLOBAL",
                "availableSites": [
                    {
                        "id": 5,
                        "name": "ie edu"
                    },
                    {
                        "id": 12,
                        "name": "School of Politics, Economics and Global Affairs"
                    }
                ],
                "editable": false,
                "manuallyImported": true,
                "originalPageId": 2363,
                "originalStructuredDataId": 4392
            },
            "content": {
                "units": null,
                "schools": [
                    {
                        "id": 3027,
                        "content": {
                            "title": "School of Global Public Affairs",
                            "code": "school-of-global-public-affairs",
                            "school": "SPEGA"
                        }
                    }
                ],
                "pathways": null,
                "programs": null,
                "subjectAreas": null,
                "stageTargets": null,
                "centers": null,
                "topics": null,
                "title": "How our students are living the coronavirus outbreak",
                "abstract": "Read about Ana Valverde's, a Bachelor in Law and International Relations student, story on her experience on coronavirus outbreak.",
                "image": {
                    "id": 4938,
                    "name": "students-living-coronavirus-outbreak.jpg",
                    "title": "",
                    "description": "",
                    "alt": "",
                    "tags": [],
                    "url": "https://images.thesaurus.ie.edu/students-living-coronavirus-outbreak",
                    "thumb": "https://images.thesaurus.ie.edu/w/215/h/161/students-living-coronavirus-outbreak",
                    "publicId": "thesaurus/students-living-coronavirus-outbreak_b4367289-222a-43d3-8821-2e05857f0304",
                    "damId": "students-living-coronavirus-outbreak",
                    "published": "2022-04-06T11:18:52Z",
                    "size": 144933,
                    "width": 1092,
                    "height": 678,
                    "orientation": "L",
                    "site": "global"
                },
                "lead": null,
                "longAbstract": "<p></p>\n",
                "content": "<p><em><strong>Ana Valverde - </strong>A fourth-year Bachelor in Law and International Relations student. Here I’m going to describe my experience of adapting to the circumstances posed by COVID-19 outbreak has been. </em></p><p>&nbsp;</p><p>IE started offering online classes from the time when the very first cases in Madrid were detected.  That was already three weeks ago. By that time, we could decide between going to class on campus, and attending classes online. Just a few days later the Government announced that all universities would be closed. From that moment on, all the classes have been online. I feel so lucky to have been able to transition to online teaching from day one, without any issue. Everything was ready to go, as if IE knew this was going to happen. This is so, because IE has always believed in investing in online education to be able to reach every single student wherever they may be in the world.</p><p>I have contacted a few students to compare how they perceive online classes:</p><p><em>“At the beginning it was very difficult to focus, but now I actually pay more attention than I do in normal classes, as they have become the only “appointments” that I have throughout the day.”</em>- Laura Escobar, student of Bachelor in Business Administration and International Relations.</p><p><em>“I think online classes work better than expected. It is true that it represents a challenge to all of us, but with good will and engagement, it is still possible to follow the courses!</em>” –Blanca Úrculo, student of Bachelor in Law and International Relations.</p><p><em> “Classes online are the best-worst alternative to teaching in times of Coronavirus. It’s the best alternative in the sense that it keeps us busy but at the same time, keeping up with math courses online is a challenge...” </em>–María Balasch , student of Bachelor in Business Administration and International Relations.</p><p><em>“Above all, I think that we must be united and patient in front of this situation. We should be proud to have at least the possibility of being able to continue our courses and that this situation does not affect our educational path even if, like all things, this system has its drawbacks”- </em>Jade Ruiz, student of Law and International Relations.</p><p>For <strong>professors</strong>, it was harder at the beginning since some of them aren’t used to technological tools. But thanks to the IT staff they rapidly got the hang of it:</p><blockquote><p>“<em>Online classes have been one of the few advantages of the current situation. It has allowed us to fully immerse ourselves in the teaching experience of the future and has demonstrated -once again- that IE is a visionary institution and world leader in the field of education</em>.”- Luis Leis, Professor of Tax Law.</p></blockquote><p>Having classes online is helping me keep motivated and entertained while in quarantine. Group meetings are now virtual, presentations are given online, and assignments are uploaded on campus or sent to the professors by email. Nothing has changed.  My life is almost as busy as it used to be two weeks ago: working from home in the mornings and online classes in the afternoon.</p><p>Furthermore, this situation is giving me the opportunity to forcibly <strong>improve my IT skills</strong>. For instance, some professors have asked us to send them the group presentations we would have had in class, via online in the format of a video. In order to fulfill that task I have had to learn how to make a proper video: join all of my classmates’ parts, add the audios, etc. I am sure these skills will be very helpful for my future work life.</p><p><img src=\"https://res.cloudinary.com/ieuniversity/image/upload/v1649244094/thesaurus/57028-board-games_detail-1005x670_44a53d09-6bd7-4046-92c9-a3945f8410f9.jpg\" style=\"width: 300px;\" class=\"fr-fic fr-dii fr-fil\" />At the same time, quarantine is allowing me to spend more time with my <strong>family</strong> and take back old traditions like watching movies after lunch in the weekends, playing board games, and reading in the leaving room.</p><p>I have to say I am benefitting a lot from these times. Instead of complaining we should adapt to the new times and circumstances and take out the positive things that they may bring along. As Albert Einstein once said: <strong><em>“In the middle of difficulty lies opportunity”.</em></strong></p>",
                "newsDate": "2020/03/23"
            },
            "modified": "2022-11-20T19:20:33.000Z",
            "published": "2022-11-20T19:20:33.000Z"
        }
    ],
    "next": [
        {
            "structuredData": "NEWS",
            "id": 24459,
            "language": 1,
            "dataLanguages": [],
            "relatedSite": 12,
            "relatedPage": {
                "pageId": 28071,
                "url": "https://www.ie.edu/school-politics-economics-global-affairs/oscar-jonsson-new-academic-director-center-governance-change/",
                "origin": "GLOBAL",
                "availableSites": [
                    {
                        "id": 5,
                        "name": "ie edu"
                    },
                    {
                        "id": 12,
                        "name": "School of Politics, Economics and Global Affairs"
                    }
                ],
                "editable": false,
                "manuallyImported": true,
                "originalPageId": 2467,
                "originalStructuredDataId": 4493
            },
            "content": {
                "units": null,
                "schools": [
                    {
                        "id": 3027,
                        "content": {
                            "title": "School of Global Public Affairs",
                            "code": "school-of-global-public-affairs",
                            "school": "SPEGA"
                        }
                    }
                ],
                "pathways": null,
                "programs": null,
                "subjectAreas": null,
                "stageTargets": null,
                "centers": null,
                "topics": null,
                "title": "Oscar A. Jonsson, New Academic Director of the Center for the Governance of Change",
                "abstract": "Jonsson has an extensive experience in emerging technologies’ impact on strategic affairs and geopolitics and has advised governments, armed forces’ leadership and financial institutions.",
                "image": {
                    "id": 4919,
                    "name": "oscar-jonsson-new-academic-director-center-governance-change.jpg",
                    "title": "",
                    "description": "",
                    "alt": "",
                    "tags": [],
                    "url": "https://images.thesaurus.ie.edu/oscar-jonsson-new-academic-director-center-governance-change",
                    "thumb": "https://images.thesaurus.ie.edu/w/215/h/161/oscar-jonsson-new-academic-director-center-governance-change",
                    "publicId": "thesaurus/oscar-jonsson-new-academic-director-center-governance-change_bbe09967-d7c1-4bb8-bc39-80ade6c604dd",
                    "damId": "oscar-jonsson-new-academic-director-center-governance-change",
                    "published": "2022-04-06T11:18:52Z",
                    "size": 145557,
                    "width": 1005,
                    "height": 523,
                    "orientation": "L",
                    "site": "global"
                },
                "lead": null,
                "longAbstract": "<p>IE University has announced the appointment of Oscar A. Jonsson as the new Academic Director of the Center for the Governance of Change (CGC). He will continue to develop the center as a top applied research institution in the field of emerging technologies and their political, economic, and societal implications.<br><br>Jonsson has earlier been Director of the Stockholm Free World Forum, a visiting researcher at UC Berkeley and a subject-matter expert at the Swedish Armed Forces Headquarters. He holds a PhD from the Department of War Studies at King’s College London.</p>\n",
                "content": "<p><strong><big>Jonsson has an extensive experience in emerging technologies’ impact on strategic affairs and geopolitics and has advised governments, armed forces’ leadership and financial institutions.</big></strong></p><p>IE University has announced the appointment of Oscar A. Jonsson as the new Academic Director of the <a href=\"https://mupro.ie.edu/cgc/\" target=\"_blank\">Center for the Governance of Change (CGC)</a>. He will continue to develop the center as a top applied research institution in the field of emerging technologies and their political, economic, and societal implications.</p><p>Jonsson has earlier been Director of the Stockholm Free World Forum, a visiting researcher at UC Berkeley and a subject-matter expert at the Swedish Armed Forces Headquarters. He holds a PhD from the Department of War Studies at King’s College London.</p><p>His research focuses on the impact of emerging technologies on modern statecraft and conflict, and in particular Russian modern warfare. He is the author of <a href=\"http://press.georgetown.edu/book/georgetown/russian-understanding-war\" target=\"_blank\">The Russian Understanding of War</a> (Georgetown University Press), which is on the Commander of US Special Forces’ reading list for 2020, and finalist for the Association of American Publisher’s award for Scholarly and Professional Excellence in Social Sciences 2020. His PhD-thesis received the Munich Security Conference’s John McCain Dissertation award.</p><blockquote><p>“Understanding what the future may look like in the intersection between technology, geo-power and society in a global environment is ever more important, as the current COVID19 shows.”<p><small>Susana Malcorra </small></p></blockquote></p><p>“Understanding what the future may look like in the intersection between technology, geo-power and society in a global environment is ever more important, as the current COVID19 shows. The work of the CGC in fields such as the future of health, impact of digitalization or artificial intelligence, offers us an incredible platform to analyze and anticipate global trend,” said Susana Malcorra, Dean of IE School of Global and Public Affairs.</p><p>“With his knowledge and expertise in strategic affairs and geopolitical risks, Oscar A. Jonsson brings a new dimension to the Center. I warmly welcome him and am looking forward to working with him,” she added.</p><p>“The current pandemic and economic crisis is just underlining the importance of the work of the Center for the Governance of Change,” highlights Jonsson in this video, in which he anticipates the next projects and opportunities of this educational institution based at IE University.</p><p>\n  <span class=\"fr-video fr-deletable fr-fvc fr-dvb fr-draggable\" contenteditable=\"false\" draggable=\"true\">\n    <iframe width=\"640\" height=\"360\" src=\"https://player.vimeo.com/video/410944192\" frameborder=\"0\" allowfullscreen=\"\" class=\"fr-draggable\"></iframe>\n  </span>\n  <br>\n</p>\n",
                "newsDate": "2020/04/27"
            },
            "modified": "2022-11-20T19:17:31.000Z",
            "published": "2022-11-20T19:17:31.000Z"
        }
    ]
}
```javascript

## `PUT` /structured_data_content/:id/restore

🚨 **Permisos**: globalData.editAllGlobalData

Recupera un dato estructurado eliminado.

## `PUT` /structured_data_content/restore/bulk

🚨 **Permisos**: globalData.editAllGlobalData

Recupera los datos estructurados eliminados cuyos id's pasamos en el body.

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

## `GET` /site/:site/structured_data/filters/:structuredData

🚨 **Permisos**: globalData.readGlobalData

<aside>
💡 **Headers:**
lang

</aside>

Devuelve la información de todos los datos estructurados que se relacionan con el dato estructurado indicado en el site e idioma especificados, para poder establecer cuáles son los filtros que se pueden mostrar al usuario. Solo tiene en cuenta los datos reales que están disponibles, que no sean borrador ni estén eliminados, y que estén siendo usados por al menos un dato existente. Por ejemplo, si un Pathway está en la base de datos pero no está siendo usado por ningún programa, al ver los filtros de programas ese Pathway no aparecerá.

**Importante**: Si lang es 0, nos devolverá los datos en todos los idiomas disponibles.

```json
{
    "SCHOOLS": {
        "label": "Schools",
        "items": [
            {
                "id": 4160,
                "label": "Sch Glo"
            },
            {
                "id": 2905,
                "label": "Law"
            }
        ]
    },
    "UNIT": {
        "label": "Unit",
        "items": [
            {
                "id": 4220,
                "label": "Bachelor"
            },
            {
                "id": 4254,
                "label": "Exponential Learning"
            }
        ]
    },
    "PATHWAYS": {
        "label": "Pathways",
        "items": [
            {
                "id": 3181,
                "label": "Technology & Data"
            }
        ]
    },
    "FORMAT": {
        "label": "Format",
        "items": [
            {
                "id": 4212,
                "label": "Full Time"
            }
        ]
    }
}
```javascript

## `PUT` /categories/order

Con este endpoint cambiarás el orden de una categoría. Para ello está esperando determinadas propiedades que le lleguen en el body.

```json
{
    "contentId": 2691, (number)
    "type": "category", (string 'category' | 'group')
    "parentGroup": 0, (number)
    "position": 3, (number)
    "structuredData": "EVENT_FORMATS" (string)
}
```javascript

- `contentId`: El id númerico del elemento que queremos mover. El motivo de definirlo como contentId es porque se pueden mover tanto categories como groups.
- `type`: El tipo del elemento que queremos mover y que corresponde al `contentId`  Puede ser “category” o “group”.
- `parentGroup`: El id del grupo dentro del cual queremos meter esta categoría. Si es 0 se entenderá que lo queremos establecer en el root.
- `position`: La posición del elemento con respecto al grupo donde está o en el root.
- `structuredData`: El id en formato string del dato.

## `PUT` /categories/order/bulk

Similar al anterior pero en bulk. En el body le llegarán varios elementos en formato array.

```json
[
 {
    "contentId": 2691, (number)
    "type": "category", (string 'category' | 'group')
    "parentGroup": 0, (number)
    "position": 2, (number)
    "structuredData": "EVENT_FORMATS" (string)
  },
  {
    "contentId": 2334, (number)
    "type": "category", (string 'category' | 'group')
    "parentGroup": 0, (number)
    "position": 3, (number)
    "structuredData": "EVENT_FORMATS" (string)
  }
]
```javascript

El motivo de este endpoint es porque al mover una categoría, habrá que reordenar el position de las otras categorías.

## `POST` /categories/group

Crearemos un nuevo grupo que se situará en el último puesto de la lista, tal y como se indica en el diseño.

Los elementos que estará esperando en el body serán

```tsx
{
    "title": "Nuevo Grupo",
    "structuredData": "EVENT_FORMATS",
    "language": 4,
    "selectable": false,
    "entity": null
}
```javascript

- `title`: El título del grupo
- `structuredData`: El dato estructurado al que hace referencia el grupo.
- `language`: id del idioma
- `selectable`: booleano para definir si el grupo es seleccionable o no.
- `entity`: En la creación será siempre null.

## `PUT` /categories/group/:group

Con este endpoint editaremos el grupo y también lo traduciremos. Para ello, el body tendrá el mismo formato que en el post pero lo que haremos será pasarle el mismo entity del grupo que queremos traducir y el id del idioma al que lo queremos traducir

```tsx
{
    "title": "Nuevo Grupo ES",
    "structuredData": "EVENT_FORMATS",
    "language": 2,
    "selectable": false,
    "entity": "a33071f7-ed48-49a8-8589-3dd6110c51c0"
}
```javascript

## **`GET` /categories/group/:groupId**

Devuelve la información de un grupo concreto. Cuando se hace un post, se devuelve la info del grupo recién creado.

## `POST`/structured_data_content/:structuredData/site/:site/export

Exporta el contenido de datos estructurados, tanto de página como simples.

Se pueden exportar dependiendo del site, si es global o de site, el idioma y el tipo de dato marcado por su id.

Además esperará un body con los siguientes datos:

- `ids`: array de ids de págína o de datos estructurados relacionados con el structuredData que hayamos establecido en la url a exportar. Si esta propiedad no se manda, en lugar de exportar esos ids se exportarán todos los datos del site en cuestión.
- `format`: array de strings con los formatos a descargar el contenido. Solo son válidos ‘json’, ‘xml’, ‘csv’.

### Ejemplo de petición

```json
POST /structured_data_content/QA_LOCAL_SIMPLE_DATA/site/3263/export

Headers
lang: 1

Body
{
    "ids": [4514,4403,3992],
    "format": ["json", "csv"]
}
```
---

# User

## `GET` /user/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: usersRoles.manageUsersRoles

Obtenemos los datos de un usuario. Si como usuario se facilita "me", (`/user/me`) se obtiene la información del usuario que está conectado. El valor que puede devolver en status es invited o active.

AÑADIDO PARA LOS PERMISOS POR SITE: A partir de ahora en la respuesta se añadirá una propiedad sites que podrá ser bien un array de ids, ej `"sites": [1, 2, 3]` que será la lista de sites para los que ese usuario tiene permisos o bien `"sites": ["all"]` si tiene permisos en todos los sites.

También ahora se incluirá una propiedad `roles` que será un array de objetos con cada site y los roles asociados que tenga ese usuario.

```json
{
    "id": 12,
    "username": "test",
    "name": "Test User",
    "email": "user@example.com",
    "image": null,
    "company": "",
    "description": "",
    "dateCreated": "2021-04-28T13:33:23.000Z",
    "failed": 0,
    "enabled": true,
		"status": "invited",
		"roles": [
        {
            "siteId": 85,
            "roles": [ 2, 3, 1 ]
        },
        {
            "siteId": "all",
            "roles": [ 4 ]
        }
    ],
		"sites": [
        "all"
    ]
}
```javascript

## `GET` /users

**🔑 Requiere autenticación.**

🚨 **Permisos**: usersRoles.manageUsersRoles

<aside>
💡 **Params:**
?query
?order
?filterSites
?filterRoles

</aside>

Obtenemos los datos de todos los usuarios.

- `query` es una o varias palabras clave por las que filtrar los resultados (a buscar en el nombre). En el nombre no tienen por qué estar juntas, es decir, que si en query buscas "us test" te encontrará "Test user".
- `order` es un valor en el formato `${field}-${ASC || DESC}`. Como field acepta `name` y `dateCreated`. Por ejemplo, para mostrar por nombre en orden descendiente: `name-desc`. Si no se indica la segunda parte (por ejemplo, solo `name`) por defecto será ascendiente para `name` y descendiente para `dateCreated`.
- `filterSites` Con esto podrás filtrar los usuarios dependiendo de los sites a los que tengan permisos. Para ello basta con poner los ids separados por comas o `all` si quieres filtrar por todos.
- `filterRoles` Con esto podrás filtrar por aquellos usuarios que tengan un rol concreto. Para ello deberas poner los ids de roles separados por comas. **Ejemplos**  `filterRoles=1,2,3` o `filterRoles=1`

AÑADIDO PARA LOS PERMISOS POR SITE:  De la misma manera que con **`GET/`user/:id**, se añadirá a la respuesta la propiedad "sites" que será un array de ids de sites a los que cada usuario tiene permisos o bien un array con un solo "all" si un determinado usuario tiene permisos para todos los sitios.

También ahora se incluirá una propiedad `roles` que será un array de objetos con cada site y los roles asociados que tenga ese usuario.

```json
[
    {
        "id": 2,
        "username": "admin",
        "name": "Admin",
        "email": "user@example.com",
        "image": null,
		    "company": "",
		    "description": "",
		    "dateCreated": "2021-04-28T13:33:23.000Z",
		    "failed": 0,
		    "enabled": true,
				"status": "active",
				"roles": [],
				"sites": [
					  "all"
		    ]
    },
    {
        "id": 6,
        "username": "eldemo",
        "name": "Test",
        "email": "user@example.com",
        "image": null,
		    "company": "",
		    "description": "",
		    "dateCreated": "2021-04-28T13:33:23.000Z",
		    "failed": 0,
		    "enabled": true,
				"status": "invited",
				"roles": [
						"siteId": 86,
            "roles": [ 4 ]
				],
				"sites": [
            81,
            85,
            86
        ]
    },
]
```javascript

## `GET` /site/:site/users/

🚨 **Permisos**: usersRoles.manageUsersRoles

Funciona similar a la ruta GET/ users pero limitado a los usuarios que tengan permisos para ese site en concreto. En lugar de site también podemos especificar global.

## `POST` /user

**🔑 Requiere autenticación.**

🚨 **Permisos**: usersRoles.createUsers

Damos de alta un usuario. Se envía un correo electrónico que remite al usuario a la URL `${AX}/set-password/${userId}/${token}`. En esa URL es donde AX solicita al usuario la contraseña que va a querer el usuario, enviando la petición. a `POST [/user/{userID}/password/init](User 95a2e849b8d2459096fb85fbc7076bd6.md)`

AÑADIDO PARA LOS PERMISOS DE SITE: Al crear un usuario, recibiremos en el body una propiedad "sites" que puede ser null, un array de ids de site que nos indica para qué site/sites va a tener permiso o "all", si va a tener permisos para todos.

AÑADIDO PARA LA GESTIÓN DE ROLES: Ahora también se esperará una propiedad `roles` que será un array de objetos con los roles que se le asocien en el site que se especifique. Se puede pasar el id del site para que tenga un rol determinado en un site concreto u `“all”` que será que tiene unos roles específicos en todos los sites. Si queremos añadir roles globales, en el siteId pasaremos `“global”` seguido del array de roles ids que quieras que ese usuario tenga para los datos globales.
¿QUÉ OCURRE SI UN USUARIO ES SUPERADMIN? Se está esperando una propiedad más que es `isSuperAdmin: boolean` que identificará que un usuario es o no superadmin.

```json
{
   "email": "correo@mail.com",
   "name": "nombre",
   "sites": [ "all" ],
	 "roles": [
        {
            "siteId": "all",
            "roles": [1, 2, 3]
        },
        {
            "siteId": 86,
            "roles": [ 4 ]
        },
				{
						"siteId": "global",
            "roles": [ 1 ]
				}
    ]
}
```javascript

## `PUT` /user/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: usersRoles.editUsers

Modificamos los datos de un usuario. El único campo que no puede cambiar un usuario es su `email` (si se diera el caso, se ignora el nuevo email), los `sites` y los `roles`.

AÑADIDO PARA LOS PERMISOS POR SITE: Al editar un usuario podemos cambiar la lista de sites para los que tiene permisos si añadimos en el body la propiedad "sites" que será un array con los ids de sites o 'all' si ese usuario tiene todos los permisos.

AÑADIDO PARA LA GESTIÓN DE ROLES: Ahora también se esperará una propiedad `roles` que será un array de objetos con los roles que se le asocien en el site que se especifique. 

La manera en la que funciona es, si llega un site nuevo o un roleId nuevo dentro del array, se creará esta nueva entrada, si hay cambios en el número de roles se actualizará y si no llega un role de los que ya teníamos en la bbdd se eliminará.

¿QUÉ OCURRE SI UN USUARIO ES SUPERADMIN? Se está esperando una propiedad más que es `isSuperAdmin: boolean` que identificará que un usuario es o no superadmin.

Un usuario no se puede cambiar los roles a sí mismo.

```json
{
		"username": "nombreusuario",
		"email": "correo@mail.com", // el email solo lo puede cambiar un admin
		"name": "nombre",
		"image": null,
		"company": "",
		"description": "",
		"isSuperAdmin": true,
		"roles": [
        {
            "siteId": "all",
            "roles": [1, 2, 3]
        },
        {
            "siteId": 86,
            "roles": [ 4 ]
        }
    ]
		"sites": [ "all" ] || [ 81, 85, 86 ]
}
```javascript

## `PUT` /site/:id/restrict

🚨 **Permisos**: addUsersToSite

Restringimos el acceso a un site que pasamos como `:id` a un conjunto de usuarios cuyos ids pasamos en el query en forma de array. 

Ejemplo de petición en el body

```jsx
{
   "users": [44, 95, 16]
}
```javascript

De esta manera los usuarios 44, 95 y 16, dejarán de tener acceso al site que hayamos pasado por params. En caso de que alguno de ellos tuviera permiso para todos los sites (`’all’`). Esto se cambiaría por todos los sites excepto aquel que hemos indicado.

## `DELETE` /user/:id

🚨 **Permisos**: usersRoles.deleteUsers

**🔑 Requiere autenticación.**

Eliminamos a un usuario

## `DELETE` /user/bulk

🚨 **Permisos**: usersRoles.deleteUsers

**🔑 Requiere autenticación.**

Elimina los usuarios indicados pasados en un array en el body.

```json
{
	"ids": [1, 2, 3, ...]
}
```javascript

Si hubiera errores, devolverá un array con el id de los elementos afectados y el problema

```json
{
    "code": 400,
    "message": [
        {
            "id": 315
            "error": "Can't remove user."
        }
    ]
}
```javascript

## `POST` /user/:id/password/init

🚨 **Permisos**: usersRoles.editUsers

**🔑 No requiere autenticación.**

Para dar de alta una nueva contraseña tras haber creado el usuario. Devuelve el auth token como si hubieras hecho login. Solo funciona si el usuario no tiene establecida una contraseña.

Ejemplo de petición:

```json
{
   "token": "token generado en la llamada anterior",
   "password": "nueva contraseña",
   "retypedPassword": "repetir contraseña"
}
```javascript

Ejemplo de respuesta:

```json
{
    "message": "Authenticated sucesfully",
    "token": "xxxx"
}
```javascript

## `PUT` /user/:id/resend

**🔑 Requiere autenticación.**

🚨 **Permisos**: usersRoles.manageUsersRoles

Envía al usuario el correo de invitación. Solo funciona si el usuario existe, no está desactivado, y está en estado "Invited" (es decir, no ha activado su contraseña: si la hubiera activado debería hacer un reset).

Devuelve ok si todo es correcto, o un mensaje de error si no se cumplen las condiciones arriba indicadas.

## `PUT` /user/:id/password/change

**🔑 Requiere autenticación.**

🚨 **Permisos**: usersRoles.editUsers

Permite modificar la contraseña de un usuario desde el perfil de usuario.

```json
{
	 "currentPassword": "contraseñaActual"
   "password": "nuevacontraseña",
   "retypedPassword": "nuevacontraseña"
}
```javascript

## `POST` /user/:id/password/reset

**🔑 No requiere autenticación.**

🚨 **Permisos**: usersRoles.editUsers

`:id` puede ser usuario o correo electrónico.

Genera un nuevo token para esta cuenta de usuario, y envía un correo electrónico con un enlace que remite a `${AX}/new-password/${id}/${token}`, donde el usuario podrá introducir la nueva contraseña y esta se modificaría utilizando el endpoint `/user/:id/password/new`

## `POST` /user/:id/password/new

**🔑 No requiere autenticación.**

🚨 **Permisos**: usersRoles.editUsers

Actualiza la contraseña con los nuevos datos que pasaremos por el body, después de haber hecho un reset. El ejecutarse correctamente, el número de fallos se resetea.

```json
{
   "token": "token generado en la llamada anterior",
   "password": "nueva contraseña",
   "retypedPassword": "repetir contraseña"
}
```javascript

## `DELETE` /user/:id/site/:id

**🔑 Requiere autenticación.**

🚨 **Permisos**: usersRoles.manageUsersRoles

El endpoint elimina el rol asignado al usuario en un sitio específico, impidiendo que continúe teniendo acceso.