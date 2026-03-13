# Products API Documentation

Base URL: `http://localhost:3000/api/v1`

## نظرة عامة ودور الصلاحيات

- **ADMIN:** يمتلك صلاحيات كاملة: إنشاء/تعديل/حذف المنتجات لأي مطعم، ورؤية جميع المنتجات.
- **MERCHANT (صاحب مطعم):**
  - يرى فقط المنتجات التابعة لمطاعمه.
  - يمكنه إنشاء/تعديل/حذف منتجات مطاعمه فقط.
  - لا يمكنه التعديل/الحذف أو حذف صور منتج لا يملكه.

التحقق من الملكية والتنقيح موجود في الخدمة:

- التحقق من ملكية المطعم قبل الإنشاء [ProductsService.create](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L47-L52).
- التحقق من ملكية المنتج قبل التعديل/الحذف [ProductsService.update](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L174-L177) و[remove](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L220-L224) و[deleteImage](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L262-L269).
- التقسيم حسب الدور:
  - **CUSTOMER (عميل):** يرى فقط المنتجات التي يمتلك مطعمها حالة موافقة على العمولة (`commissionConfirmed = true`).
  - تقييد عرض المنتجات للتاجر: [ProductsService.findAll](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L100-L106).

الصور تُرفع عبر `FilesInterceptor('images', 5)` في المتحكم [ProductsController](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.controller.ts#L37) وتُعالَج في الخدمة [processAndSaveImages](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L289-L319).

التصنيف (Category) يدعم:

- **MENU:** يجب أن يكون مرتبطاً بالمطعم نفسه الذي يتبع له المنتج.
- **CUISINE (عام):** يمكن ربط المنتج به حتى لو لم يكن الصنف مرتبطاً بأي مطعم.
  - منطق التحقق: [validateCategory](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L391-L404).

الأسعار:

- حقل `price` من نوع عدد صحيح (أصغر وحدة عملة). مثال: 1299 بدلاً من 12.99.

الحقول الخارجية (External Integration):

- عند `isExternal = false`: يتم تجاهل `externalProvider` و`externalId` ويُحفظان بقيم `null`.
- عند `isExternal = true`: يمكن تمريرهما واستخدامهما.
  - منطق الإنشاء/التحديث: [create](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L64-L77) و[update](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L210-L226).

المسارات معرفة في [api-routes.constants.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/common/constants/api-routes.constants.ts#L21-L27).

---

## 1. Create Product

إنشاء منتج جديد.

- **URL:** `/products`
- **Method:** `POST`
- **Headers:**
  - `Authorization: Bearer <access_token>`
  - `Content-Type: multipart/form-data`

### Payload (FormData)

| Key                | Type   | Required    | Description                                      |
| ------------------ | ------ | ----------- | ------------------------------------------------ |
| `name`             | Text   | Yes         | اسم المنتج.                                      |
| `description`      | Text   | No          | وصف المنتج.                                      |
| `shortDescription` | Text   | No          | وصف قصير.                                        |
| `price`            | Text   | Yes         | السعر كعدد صحيح (أصغر وحدة).                     |
| `personCount`      | Text   | No          | عدد الأشخاص الذين يكفيهم المنتج (معلومات للعرض). |
| `restaurantId`     | Text   | Yes         | معرف المطعم.                                     |
| `categoryId`       | Text   | No          | التصنيف: MENU مرتبط بمطعم المنتج، CUISINE عام.   |
| `discount`         | Text   | No          | قيمة الحسم.                                      |
| `discountType`     | Text   | No          | نوع الحسم: `PERCENTAGE` أو `FIXED`.              |
| `hasStock`         | Text   | No          | `true`/`false`.                                  |
| `stockQuantity`    | Text   | Conditional | مطلوب إذا `hasStock = true`.                     |
| `isAvailable`      | Text   | No          | `true`/`false`.                                  |
| `isExternal`       | Text   | No          | `true`/`false`.                                  |
| `externalProvider` | Text   | Conditional | مطلوب فقط إذا `isExternal = true`.               |
| `externalId`       | Text   | Conditional | مطلوب فقط إذا `isExternal = true`.               |
| `images`           | File[] | No          | حتى 5 صور (jpg، png، webp).                      |

### Response (Success - 201 Created)

```json
{
  "statusCode": 201,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "name": "Delicious Burger",
    "description": "Juicy beef burger with cheese",
    "images": [
      {
        "id": 10,
        "url": "http://localhost:3000/uploads/products/1/xxx.webp",
        "mobileUrl": "http://localhost:3000/uploads/products/1/xxx_mobile.webp",
        "thumbnailUrl": "http://localhost:3000/uploads/products/1/xxx_thumb.webp",
        "isMain": true,
        "displayOrder": 0
      }
    ],
    "price": 1299,
    "priceAfterDiscount": 1170,
    "restaurantId": 1,
    "categoryId": 1,
    "discount": 10,
    "discountType": "PERCENTAGE",
    "hasStock": true,
    "stockQuantity": 50,
    "isAvailable": true,
    "isExternal": false,
    "externalProvider": null,
    "externalId": null,
    "commissionRate": null,
    "commissionConfirmed": false,
    "createdAt": "2026-02-23T10:00:00.000Z",
    "updatedAt": "2026-02-23T10:00:00.000Z"
  },
  "timestamp": "2026-02-23T10:00:00.000Z",
  "path": "/api/v1/products"
}
```

### Response (Error - 403 Forbidden)

إذا كان التاجر لا يملك المطعم المرسل:

```json
{
  "message": "You do not own this restaurant",
  "error": "Forbidden",
  "statusCode": 403
}
```

### ملاحظات

- يتم ضبط `merchantId` تلقائياً من مالك المطعم.
- معالجة الصور وإنتاج نسخ mobile/thumbnail تتم في الخدمة [processAndSaveImages](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts#L289-L319).

---

## 2. Get All Products (Filter & Search)

إرجاع قائمة المنتجات مع دعم الفلاتر والبحث والصفحات.

- **URL:** `/products`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <access_token>`

### Query Parameters

| Parameter      | Description                              |
| -------------- | ---------------------------------------- |
| `page`         | رقم الصفحة (افتراضي: 1).                 |
| `limit`        | عدد العناصر في الصفحة (افتراضي: 10).     |
| `search`       | البحث بالاسم (يدعم العربية والإنجليزية). |
| `categoryId`   | الفلترة حسب التصنيف.                     |
| `restaurantId` | الفلترة حسب المطعم.                      |
| `minPrice`     | السعر الأدنى (عدد يعبر عن السعر).        |
| `maxPrice`     | السعر الأقصى (عدد يعبر عن السعر).        |
| `minRating`    | التقييم الأدنى (من 1 إلى 5).             |

### سلوك الدور

- عند الدور MERCHANT، يعرض فقط منتجات مطاعمه (`merchantId = user.id`).
- عند الدور ADMIN، يعرض جميع المنتجات.
- عند الدور CUSTOMER أو كزائر، يعرض فقط المنتجات التي `commissionConfirmed = true`.

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": [
    {
      "id": 1,
      "name": "Delicious Burger",
      "description": "Juicy beef burger with cheese",
      "price": 1299,
      "priceAfterDiscount": 1299,
      "restaurantId": 1,
      "categoryId": 1,
      "hasStock": true,
      "stockQuantity": 50,
      "isAvailable": true,
      "merchantId": 1,
      "images": [
        {
          "id": 10,
          "url": "http://localhost:3000/uploads/products/1/xxx.webp",
          "isMain": true,
          "displayOrder": 0
        }
      ],
      "createdAt": "2026-02-23T10:00:00.000Z",
      "updatedAt": "2026-02-23T10:00:00.000Z"
    }
  ],
  "pagination": {
    "total": 1,
    "page": 1,
    "limit": 10,
    "totalPages": 1,
    "hasNextPage": false,
    "hasPreviousPage": false
  },
  "timestamp": "2026-02-23T10:00:00.000Z",
  "path": "/api/v1/products?page=1&limit=10"
}
```

---

## 3. Get One Product

- **URL:** `/products/:id`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <access_token>`

### Response (Success - 200 OK)

يشمل الصور والروابط المطلقة بعد المعالجة وجميع التقييمات المرتبطة بالمنتج.

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "name": "Delicious Burger",
    "description": "Juicy beef burger with cheese",
    "images": [ ... ],
    "reviews": [
      {
        "id": 1,
        "rating": 5,
        "comment": "Amazing burger! Very juicy and tasty.",
        "entityType": "PRODUCT",
        "entityId": 1,
        "reviewerId": 10,
        "createdAt": "2026-02-24T10:30:00.000Z",
        "updatedAt": "2026-02-24T10:30:00.000Z",
        "reviewer": {
          "id": 10,
          "firstName": "John",
          "lastName": "Doe",
          "email": "john.doe@example.com",
          "phone": "+963912345678",
          "role": "CUSTOMER"
        }
      },
      {
        "id": 2,
        "rating": 4,
        "comment": "Good quality, but could be bigger.",
        "entityType": "PRODUCT",
        "entityId": 1,
        "reviewerId": 11,
        "createdAt": "2026-02-24T12:15:00.000Z",
        "updatedAt": "2026-02-24T12:15:00.000Z",
        "reviewer": {
          "id": 11,
          "firstName": "Jane",
          "lastName": "Smith",
          "email": "jane.smith@example.com",
          "phone": "+963987654321",
          "role": "CUSTOMER"
        }
      }
    ],
    "price": 1299,
    "priceAfterDiscount": 1170,
    "restaurantId": 1,
    "categoryId": 1,
    "hasStock": true,
    "stockQuantity": 50,
    "isAvailable": true,
    "commissionRate": 10,
    "commissionConfirmed": true
  },
  "timestamp": "2026-02-23T10:00:00.000Z",
  "path": "/api/v1/products/1"
}
```

---

## 4. Update Product

تحديث منتج قائم. يدعم إضافة صور جديدة وتحديث ترتيب الصور وتعيين الصورة الرئيسية.

- **URL:** `/products/:id`
- **Method:** `PATCH`
- **Headers:**
  - `Authorization: Bearer <access_token>`
  - `Content-Type: multipart/form-data`

### Payload (FormData) — جميع الحقول اختيارية

| Key                | Type   | Description                                                                         |
| ------------------ | ------ | ----------------------------------------------------------------------------------- |
| `name`             | Text   | اسم جديد.                                                                           |
| `description`      | Text   | وصف جديد.                                                                           |
| `shortDescription` | Text   | وصف قصير جديد.                                                                      |
| `personCount`      | Text   | عدد الأشخاص الذين يكفيهم المنتج (معلومات للعرض).                                    |
| `price`            | Text   | سعر جديد كعدد صحيح.                                                                 |
| `stockQuantity`    | Text   | الكمية.                                                                             |
| `isAvailable`      | Text   | `true`/`false`.                                                                     |
| `hasStock`         | Text   | `true`/`false`.                                                                     |
| `categoryId`       | Text   | نقل المنتج لتصنيف جديد (MENU يجب أن يتبع للمطعم، CUISINE مسموح).                    |
| `discount`         | Text   | قيمة الحسم.                                                                         |
| `discountType`     | Text   | `PERCENTAGE` أو `FIXED`.                                                            |
| `isExternal`       | Text   | إذا `false` يتم تصفير الحقول الخارجية، إذا `true` يمكن تمريرها.                     |
| `externalProvider` | Text   | عند `isExternal = true`.                                                            |
| `externalId`       | Text   | عند `isExternal = true`.                                                            |
| `imagesMetadata`   | Text   | نص JSON لتحديث ترتيب/الصورة الرئيسية: `[{"id":10,"isMain":true,"displayOrder":0}]`. |
| `images`           | File[] | إضافة صور جديدة تُلحق بنهاية الترتيب.                                               |

ملاحظة هامة: لا يمكن للمطعم (MERCHANT) تعديل حقلي نسبة العمولة (`commissionRate`) وحالة تأكيد العمولة (`commissionConfirmed`). يتم تعديلها من قبل الإدارة فقط عبر رابط مخصص.

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": { "id": 1, "name": "Updated", "isAvailable": true, "images": [ ... ] },
  "timestamp": "2026-02-23T10:05:00.000Z",
  "path": "/api/v1/products/1"
}
```

### Response (Error - 403 Forbidden)

إذا لم يكن التاجر مالكاً للمنتج/المطعم:

```json
{
  "message": "You do not own this product",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 5. Delete Product

- **URL:** `/products/:id`
- **Method:** `DELETE`
- **Headers:** `Authorization: Bearer <access_token>`

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {},
  "timestamp": "2026-02-23T10:06:00.000Z",
  "path": "/api/v1/products/1"
}
```

---

## 6. Set Product Commission (Admin Only)

تعيين نسبة عمولة التطبيق على المنتج وتأكيدها. هذه العملية تؤدي إلى إظهار المنتج في قوائم استعراض تطبيق العملاء.

- **URL:** `/products/:id/commission`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`
- **Roles:** `ADMIN`

### Payload (Request Body)

| Key              | Type   | Required | Description                                       |
| ---------------- | ------ | -------- | ------------------------------------------------- |
| `commissionRate` | Number | Yes      | نسبة العمولة (رقم موجب، مثلاً النسبة 10 تمثل 10%) |

### Request Example

```json
{
  "commissionRate": 15.5
}
```

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "name": "Delicious Burger",
    "commissionRate": 15.5,
    "commissionConfirmed": true
  },
  "timestamp": "2026-03-04T12:00:00.000Z",
  "path": "/api/v1/products/1/commission"
}
```

---

## 7. Delete Product Image

- **URL:** `/products/images/:imageId`
- **Method:** `DELETE`
- **Headers:** `Authorization: Bearer <access_token>`

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {},
  "timestamp": "2026-02-23T10:06:30.000Z",
  "path": "/api/v1/products/images/10"
}
```

---

## تفاصيل تقنية إضافية

- **المتحكم:** [ProductsController](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.controller.ts)
  - إنشاء: `POST /products` مع `FilesInterceptor('images', 5)`.
  - عرض: `GET /products` ويمرر هوية المستخدم والدور للخدمة.
  - عرض واحد: `GET /products/:id`.
  - تعديل: `PATCH /products/:id` مع رفع صور جديدة.
  - تعيين العمولة: `PATCH /products/:id/commission` متاح للإدارة فقط.
  - حذف: `DELETE /products/:id`.
  - حذف صورة: `DELETE /products/images/:imageId`.

- **الخدمة:** [ProductsService](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/products/products.service.ts)
  - التحقق من الملكية: `checkRestaurantOwnership`, `checkProductOwnership`.
  - منطق الصور: `processAndSaveImages`, `updateImagesMetadata` (تعيين الصورة الرئيسية وإعادة ترتيب الصور).
  - منطق التصنيف: `validateCategory` يدعم MENU وCUISINE.
  - تقييد قائمة المنتجات للتاجر: `findAll` يفلتر `merchantId = user.id`.

- **الكائن (Entity):** [Product](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/database/entities/product.entity.ts)
  - نصوص محلية `name`, `description`, `shortDescription` مخزّنة كـ JSONB باستخدام محوّل.
  - صور منتج تُحمّل يدوياً عبر الخدمة (علاقة متعددة الأشكال مع جدول الصور).
  - **تقييمات المنتج:** تُحمّل يدوياً عبر الخدمة وتُضاف كـ `reviews` property.
  - حقول التكامل الخارجي: `isExternal`, `externalProvider`, `externalId`, `externalMetadata`.
