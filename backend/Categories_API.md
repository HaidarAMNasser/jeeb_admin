# Categories API Documentation

Base URL: `http://localhost:3000/api/v1`

## 1. Create Category

Create a new category (MENU or CUISINE).

- **MENU**: Must be linked to a specific `restaurantId`.
- **CUISINE**: Global categories (e.g., Italian, Fast Food), usually created by Admin.

- **URL:** `/categories`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: multipart/form-data`
  - `Authorization: Bearer <access_token>`

### Payload (FormData)

| Key            | Type | Required    | Description                               |
| -------------- | ---- | ----------- | ----------------------------------------- |
| `name`         | Text | Yes         | Name of the category (e.g., "Fast Food"). |
| `description`  | Text | No          | Description of the category.              |
| `type`         | Text | Yes         | `MENU` or `CUISINE` (Default: `MENU`).    |
| `restaurantId` | Text | Conditional | Required if type is `MENU`.               |
| `isActive`     | Text | No          | `true` or `false` (Default: `true`).      |
| `displayOrder` | Text | No          | Sorting order (number).                   |
| `image`        | File | No          | Image file (jpg, jpeg, png, webp).        |

### Response (Success - 201 Created)

```json
{
  "statusCode": 201,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "name": "Fast Food",
    "description": "Burgers, fries, and more",
    "type": "MENU",
    "restaurantId": 1,
    "isActive": true,
    "displayOrder": 1,
    "createdAt": "2026-02-23T17:57:48.269Z",
    "updatedAt": "2026-02-23T17:57:48.269Z",
    "images": [
      {
        "id": 1,
        "entityType": "CATEGORY",
        "entityId": 1,
        "url": "http://localhost:3000/uploads/categories/1/image.webp",
        "mobileUrl": "http://localhost:3000/uploads/categories/1/image_mobile.webp",
        "thumbnailUrl": "http://localhost:3000/uploads/categories/1/image_thumb.webp",
        "isMain": true,
        "displayOrder": 0
      }
    ]
  }
}
```

### Response (Error - 400 Bad Request)

If `restaurantId` is missing for MENU type:

```json
{
  "statusCode": 400,
  "message": "Menu categories must be linked to a restaurant",
  "data": {},
  "timestamp": "2026-02-23T17:59:39.846Z",
  "path": "/api/v1/categories"
}
```

---

## 2. Get All Categories

Retrieve a paginated list of categories with optional filtering and searching.

- **URL:** `/categories`
- **Method:** `GET`
- **Headers:**
  - `Content-Type: application/json`

### Query Parameters

| Parameter      | Description                                  |
| -------------- | -------------------------------------------- |
| `page`         | Page number (Default: 1).                    |
| `limit`        | Items per page (Default: 10).                |
| `type`         | Filter by type (`MENU` or `CUISINE`).        |
| `restaurantId` | Filter by restaurant ID.                     |
| `search`       | Search by name (Arabic or English).          |
| `isActive`     | Filter by active status (`true` or `false`). |

**Example URL:** `/categories?page=1&limit=10&type=MENU&restaurantId=1&search=Burgers&isActive=true`

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": [
    {
      "id": 1,
      "name": "Fast Food",
      "description": "Burgers, fries, and more",
      "type": "MENU",
      "restaurantId": 1,
      "isActive": true,
      "images": [
        {
          "url": "http://localhost:3000/uploads/categories/1/image.webp",
          "isMain": true
        }
      ]
    }
  ],
  "pagination": {
    "total": 1,
    "page": 1,
    "limit": 10,
    "totalPages": 1,
    "hasNextPage": false,
    "hasPreviousPage": false
  }
}
```

---

## 3. Get One Category

Retrieve details of a specific category by ID.

- **URL:** `/categories/:id`
- **Method:** `GET`
- **Headers:**
  - `Content-Type: application/json`

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "name": "Fast Food",
    "description": "Burgers, fries, and more",
    "images": [
      {
        "id": 1,
        "url": "http://localhost:3000/uploads/categories/1/image.webp",
        "isMain": true
      }
    ],
    "type": "MENU",
    "restaurantId": 1,
    "isActive": true
  }
}
```

### Response (Error - 404 Not Found)

```json
{
  "message": "Category with ID 999 not found",
  "error": "Not Found",
  "statusCode": 404
}
```

---

## 4. Update Category

Update an existing category. Supports partial updates and image replacement.

- **URL:** `/categories/:id`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: multipart/form-data`
  - `Authorization: Bearer <access_token>`

### Payload (FormData)

All fields are optional.

| Key            | Type | Description                                                     |
| -------------- | ---- | --------------------------------------------------------------- |
| `name`         | Text | New name.                                                       |
| `description`  | Text | New description.                                                |
| `isActive`     | Text | `true` or `false`.                                              |
| `image`        | File | New image file (replaces existing images).                      |
| `restaurantId` | Text | Transfer category to another restaurant (Merchant must own it). |

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "name": "Updated Name",
    "isActive": false,
    "images": []
  }
}
```

### Response (Error - 403 Forbidden)

If trying to update a category for a restaurant you don't own:

```json
{
  "message": "You do not own the restaurant of this category",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 5. Delete Category

Delete a category and its associated images.

- **URL:** `/categories/:id`
- **Method:** `DELETE`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {}
}
```
