# Categories API Documentation

Base URL: `http://localhost:3000/api/v1`

## نظرة عامة والصلاحيات

- **جميع عمليات الكتابة (Create, Update, Delete)** محصورة فقط بدور **المدير (ADMIN)**.
- التصنيفات في النظام الحالي عامة ولا ترتبط بمطعم محدد (تمت إزالة `restaurantId` و `type`).
- الحقول النصية مثل الاسم والوصف تدعم تعدد اللغات (يتم حفظها في قاعدة البيانات كـ JSON ولكن تُمرر من خلال الـ API كنص عادي ويتم التعامل معها تلقائياً كقيمة عربية بشكل افتراضي).
- البحث عبر التصنيفات يدعم البحث باللغتين العربية والإنجليزية.

---

## 1. Create Category (Admin Only)

إنشاء تصنيف جديد.

- **URL:** `/categories`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: multipart/form-data`
  - `Authorization: Bearer <access_token>`

### Payload (FormData)

| Key            | Type | Required | Description                                  |
| -------------- | ---- | -------- | -------------------------------------------- |
| `name`         | Text | Yes      | اسم التصنيف (يُحفظ تلقائياً باللغة العربية). |
| `description`  | Text | No       | وصف التصنيف.                                 |
| `isActive`     | Text | No       | `true` أو `false` (الافتراضي: `true`).       |
| `displayOrder` | Text | No       | ترتيب العرض (رقم، الافتراضي: `0`).           |
| `image`        | File | No       | ملف الصورة (jpg, jpeg, png, webp).           |

### Response (Success - 201 Created)

```json
{
  "statusCode": 201,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "name": "Fast Food",
    "description": "Burgers, fries, and more",
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

### Response (Error - 403 Forbidden)

إذا حاول مستخدم ليس مديراً (مثل التاجر أو العميل) إضافة تصنيف:

```json
{
  "message": "Only Admins can create categories",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 2. Get All Categories

إرجاع قائمة التصنيفات مع دعم الفلترة والبحث والصفحات. يتم ترتيبها تصاعدياً حسب `displayOrder` ثم تنازلياً حسب `createdAt`.

- **URL:** `/categories`
- **Method:** `GET`
- **Headers:**
  - `Content-Type: application/json`

### Query Parameters

| Parameter  | Description                                    |
| ---------- | ---------------------------------------------- |
| `page`     | رقم الصفحة (الافتراضي: 1).                     |
| `limit`    | عدد العناصر في الصفحة (الافتراضي: 10).         |
| `search`   | البحث باسم التصنيف (يدعم العربية والإنجليزية). |
| `isActive` | الفلترة حسب حالة التفعيل (`true` أو `false`).  |

**Example URL:** `/categories?page=1&limit=10&search=Burgers&isActive=true`

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
      "isActive": true,
      "displayOrder": 1,
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

عرض تفاصيل تصنيف واحد عبر معرّفه.

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
    "isActive": true,
    "displayOrder": 1,
    "images": [
      {
        "id": 1,
        "url": "http://localhost:3000/uploads/categories/1/image.webp",
        "isMain": true
      }
    ]
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

## 4. Update Category (Admin Only)

تحديث تفاصيل التصنيف. يدعم التعديل الجزئي وتغيير الصورة التابعة له (سيتم حذف الصور القديمة إذا تم رفع صورة جديدة).

- **URL:** `/categories/:id`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: multipart/form-data`
  - `Authorization: Bearer <access_token>`

### Payload (FormData)

جميع الحقول اختيارية.

| Key            | Type | Description                               |
| -------------- | ---- | ----------------------------------------- |
| `name`         | Text | الاسم الجديد.                             |
| `description`  | Text | الوصف الجديد.                             |
| `isActive`     | Text | `true` أو `false`.                        |
| `displayOrder` | Text | ترتيب عرض جديد.                           |
| `image`        | File | ملف الصورة الجديد (يستبدل الصور الحالية). |

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "name": "Updated Name",
    "isActive": false,
    "displayOrder": 2,
    "images": []
  }
}
```

### Response (Error - 403 Forbidden)

إذا لم يكن المستخدم مديراً:

```json
{
  "message": "Only Admins can update categories",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 5. Delete Category (Admin Only)

حذف تصنيف بالكامل مع الصور المرتبطة به.

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
