# Offers API Documentation

Base URL: `http://localhost:3000/api/v1`

---

## 1. Create Offer

Create a new offer.

- **URL:** `/offers`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`
- **Roles:** `MERCHANT`, `ADMIN`

### Payload (Request Body)

| Field           | Type          | Required | Description                                                 |
| --------------- | ------------- | -------- | ----------------------------------------------------------- |
| `name`          | string        | Yes      | اسم العرض                                                   |
| `description`   | string        | No       | وصف العرض                                                   |
| `discountType`  | string (Enum) | Yes      | نوع الخصم (`PERCENTAGE` أو `FIXED`)                         |
| `discountValue` | number        | Yes      | قيمة الخصم (أكبر أو تساوي 0)                                |
| `startDate`     | date string   | No       | تاريخ بدء العرض (YYYY-MM-DDTHH:mm:ss.sssZ)                  |
| `endDate`       | date string   | No       | تاريخ انتهاء العرض (YYYY-MM-DDTHH:mm:ss.sssZ)               |
| `isActive`      | boolean       | No       | حالة تفعيل العرض                                            |
| `productIds`    | array[number] | Yes      | مصفوفة تحتوي على معرّفات المنتجات المشمولة بالعرض (1 الأقل) |

### Request Example

```json
{
  "name": "عرض الصيف الخاص",
  "description": "خصم كبير على المنتجات المختارة",
  "discountType": "PERCENTAGE",
  "discountValue": 25,
  "startDate": "2024-06-01T00:00:00.000Z",
  "endDate": "2024-06-30T23:59:59.000Z",
  "isActive": true,
  "productIds": [1, 2, 3]
}
```

### Response (Success - 201 Created)

```json
{
  "message": "Operation successful",
  "data": {
    "name": "عرض الصيف الخاص",
    "description": "خصم كبير على المنتجات المختارة",
    "discountType": "PERCENTAGE",
    "discountValue": 25,
    "startDate": "2024-06-01T00:00:00.000Z",
    "endDate": "2024-06-30T23:59:59.000Z",
    "isActive": true,
    "merchantId": 2,
    "id": 1,
    "createdAt": "2024-01-01T10:00:00.000Z",
    "updatedAt": "2024-01-01T10:00:00.000Z",
    "products": [
      {
        "id": 1,
        "name": "وجبة برغر",
        "price": 5000,
        "offerPrice": 3750
        // ... other product fields
      }
    ]
  },
  "timestamp": "2024-01-01T10:00:00.000Z",
  "path": "/api/v1/offers"
}
```

### Response (Error - 403 Forbidden)

If a Merchant tries to attach products they do not own:

```json
{
  "message": "You do not own products with IDs [3]",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 2. Get All Offers

Retrieve a paginated list of offers.

- **URL:** `/offers`
- **Method:** `GET`
- **Headers:**
  - `Authorization: Bearer <access_token>`

### Query Parameters

| Parameter    | Type    | Required | Description                                                    |
| ------------ | ------- | -------- | -------------------------------------------------------------- |
| `page`       | number  | No       | رقم الصفحة (الافتراضي: 1)                                      |
| `limit`      | number  | No       | عدد العناصر في الصفحة (الافتراضي: 10)                          |
| `search`     | string  | No       | البحث في اسم العرض (يدعم العربية والإنجليزية)                  |
| `isActive`   | boolean | No       | الفلترة حسب حالة العرض (`true` أو `false`)                     |
| `merchantId` | number  | No       | الفلترة حسب رقم التاجر (المدير يستخدمها لفلترة عروض تاجر محدد) |

**ملاحظات الاسترجاع:**

- يتم حساب السعر المخفض لكل منتج داخل العرض وإرجاعه في حقل `offerPrice`.
- **العملاء (CUSTOMER)**: لن تظهر لهم سوى العروض المفعّلة (`isActive=true`)، وسيتم استثناء العرض بالكامل إذا كان يحتوي على منتج واحد على الأقل لم يتم الموافقة المعمولة الخاصة به من قبل المدير (`commissionConfirmed=false`).
- **التجار (MERCHANT)**: ستعود لهم العروض الخاصة بهم فقط.

### Request Example

```bash
curl -X GET "http://localhost:3000/api/v1/offers?page=1&limit=10&isActive=true" \
  -H "Authorization: Bearer <access_token>"
```

### Response (Success - 200 OK)

```json
{
  "message": "Operation successful",
  "data": [
    {
      "id": 1,
      "name": "عرض الصيف الخاص",
      "description": "خصم كبير على المنتجات المختارة",
      "discountType": "PERCENTAGE",
      "discountValue": 25,
      "startDate": "2024-06-01T00:00:00.000Z",
      "endDate": "2024-06-30T23:59:59.000Z",
      "isActive": true,
      "merchantId": 2,
      "createdAt": "2024-01-01T10:00:00.000Z",
      "updatedAt": "2024-01-01T10:00:00.000Z",
      "products": [
        {
          "id": 1,
          "name": "وجبة برغر",
          "price": 5000,
          "offerPrice": 3750
        }
      ],
      "merchant": {
        "id": 2,
        "restaurantName": "مطعم البرغر اللذيذ"
      }
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
  "timestamp": "2024-01-01T10:00:00.000Z",
  "path": "/api/v1/offers?page=1&limit=10&isActive=true"
}
```

---

## 3. Get Offer by ID

Retrieve a specific offer by integer ID.

- **URL:** `/offers/:id`
- **Method:** `GET`
- **Headers:**
  - `Authorization: Bearer <access_token>`

### Response (Success - 200 OK)

Returns the Offer object (similar to the data object in Get All Offers).

### Response (Error - 404 Not Found)

```json
{
  "message": "Offer with ID 999 not found",
  "error": "Not Found",
  "statusCode": 404
}
```

---

## 4. Update Offer

Update details of an existing offer.

- **URL:** `/offers/:id`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`
- **Roles:** `MERCHANT` (Only for their own offers), `ADMIN`

### Payload (Request Body)

All fields in the `Create Offer` payload are optional here.

### Request Example

```bash
curl -X PATCH http://localhost:3000/api/v1/offers/1 \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"isActive": false, "discountValue": 30}'
```

### Response (Success - 200 OK)

Returns the updated Offer object.

### Response (Error - 403 Forbidden)

If a Merchant tries to update an offer they do not own.

```json
{
  "message": "You do not own this offer",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 5. Delete Offer

Delete a specific offer by ID.

- **URL:** `/offers/:id`
- **Method:** `DELETE`
- **Headers:**
  - `Authorization: Bearer <access_token>`
- **Roles:** `MERCHANT` (Only for their own offers), `ADMIN`

### Response (Success - 200 OK)

```json
{
  "message": "Operation successful",
  "data": {},
  "timestamp": "2024-01-01T10:00:00.000Z",
  "path": "/api/v1/offers/1"
}
```
