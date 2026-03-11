# Favorites API Documentation

Base URL: `http://localhost:3000/api/v1`

## نظرة عامة

- المفضّلة متاحة فقط للمستخدم من نوع CUSTOMER.
- الأنواع المدعومة: مطاعم ومنتجات.
- كل العمليات محمية بالمصادقة.

## 1. Toggle Favorites (Bulk)

- **URL:** `/favorites/toggle`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Payload (Request Body)

أرسل أي قائمة مما يلي (كل قائمة اختيارية):

```json
{
  "restaurants": [1, 2, 3],
  "products": [10, 11]
}
```

- إذا تم تمرير معرف داخل مفتاح `restaurants` يعامل كـ مطعم.
- إذا تم تمرير معرف داخل مفتاح `products` يعامل كـ منتج.

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "restaurants": [
      {
        "id": 1,
        "name": "Best Burger",
        "ownerName": "John Doe",
        "address": "123 Tasty St",
        "city": "دمشق"
      }
    ],
    "products": [
      {
        "id": 10,
        "name": "Delicious Burger",
        "price": 1299,
        "category": "وجبات سريعة"
      }
    ]
  },
  "timestamp": "2026-02-24T10:00:00.000Z",
  "path": "/api/v1/favorites/toggle"
}
```

### Response (Error - 403 Forbidden)

إذا لم يكن الدور CUSTOMER:

```json
{
  "message": "Favorites is only available for customers",
  "error": "Forbidden",
  "statusCode": 403
}
```

### Response (Error - 404 Not Found)

إذا لم يُعثر على المعرف في النوع المحدد:

```json
{
  "message": "Entity with ID 999 not found",
  "error": "Not Found",
  "statusCode": 404
}
```

---

## 2. Get All Favorites (Paginated)

- **URL:** `/favorites`
- **Method:** `GET`
- **Headers:**
  - `Authorization: Bearer <access_token>`

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": [
    {
      "restaurants": [
        {
          "id": 1,
          "name": "Best Burger",
          "ownerName": "John Doe",
          "address": "123 Tasty St",
          "city": "دمشق"
        }
      ],
      "products": [
        {
          "id": 10,
          "name": "Delicious Burger",
          "price": 1299,
          "category": "وجبات سريعة"
        }
      ]
    }
  ],
  "pagination": {
    "total": 2,
    "page": 1,
    "limit": 10,
    "totalPages": 1,
    "hasNextPage": false,
    "hasPreviousPage": false
  },
  "timestamp": "2026-02-24T10:00:00.000Z",
  "path": "/api/v1/favorites"
}
```

### Response (Error - 403 Forbidden)

إذا لم يكن الدور CUSTOMER.

---

## ملاحظات تقنية

- المتحكم: [FavoritesController](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/favorites/favorites.controller.ts)
- الخدمة: [FavoritesService](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/favorites/favorites.service.ts)
- DTO: [ToggleFavoriteDto](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/favorites/dto/toggle-favorite.dto.ts)
