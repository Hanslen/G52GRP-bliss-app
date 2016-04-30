JSON API Documentation
======================

#### Current Base URL: [https://private-93c65-uongrp.apiary-mock.com/api/v1](https://private-93c65-uongrp.apiary-mock.com/api/v1)

*__Note:__ This is a mock server and responses are currently static until a backend is created to populate it from a database.*

### Listing Menus (`/menus`)
Provides a list of menus, sub-menus, and article IDs.

| **attribute** | **type**        | **description**            |
|:--------------|:----------------|:---------------------------|
| `menus`       | `Array`         | Contains an array of menus |
| `id`          | `Integer`       | ID of the menu             |
| `name`        | `String`        | Name of menu to display    |
| `articleIDs`  | `Integer Array` | IDs of articles in a menu  |
| `subMenus`    | `Array`         | Submenus of a menu         |

### Listing an Individual Article (`/articles/{id}`)
Gives the details of an individual article.

##### Parameters
`id` - ID of the article in the form of an `Integer`. For example, `100`.

| **attribute**    | **type**  | **description**                                    |
|:-----------------|:----------|:---------------------------------------------------|
| `id`             | `Integer` | ID of the articleIDs                               |
| `lastUpdated`    | `Date`    | When the article was last updated                  |
| `title`          | `String`  | Title of the article                               |
| `headerImageUrl` | `String`  | URL to the article's header image                  |
| `body`           | `String`  | The contents of the article, this may contain HTML |

### Listing all Articles (`/articles`)
Provides a `JSON Array` of all articles avaliable on the server.

| **attribute** | **type** | **description**                                                                                 |
|:--------------|:---------|:------------------------------------------------------------------------------------------------|
| `articles`    | `Array`  | Array of all articles avaliable. The article objects follow the same format as individual ones. |

### Listing Everything (`/all`)
Uses a similar format to the Menus endpoint, however, instead of listing `articleIDs`, this is replaced with an array named `articles` and contains the actual articles information, following the same format as individual ones.
