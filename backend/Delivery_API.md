# Delivery Drivers API Documentation

Base URL: `http://localhost:3000/api/v1`

## نظرة عامة ودور الصلاحيات

### Office Owner (صاحب المكتب)

- إنشاء سائق توصيل جديد تابع له
- عرض جميع سائقي التوصيل التابعين له
- البحث في سائقي التوصيل التابعين له
- عرض تفاصيل سائق توصيل محدد
- تعديل بيانات سائق توصيل تابع له
- حذف سائق توصيل تابع له (Soft Delete)

### ADMIN

- ✅ عرض جميع سائقي التوصيل في النظام (من جميع المكاتب)
- ✅ البحث في جميع سائقي التوصيل
- ✅ عرض تفاصيل أي سائق توصيل
- ✅ فلترة حسب المكتب (officeOwnerId)
- ✅ **إنشاء سائق توصيل جديد** وتعيينه لأي صاحب مكتب
- ✅ **تعديل بيانات أي سائق توصيل**
- ✅ **حذف أي سائق توصيل** (Soft Delete)

**ملاحظة أمنية:**

- Office Owner يمكنه فقط إدارة سائقي التوصيل التابعين له
- ✅ **ADMIN يمكنه رؤية وإدارة جميع سائقي التوصيل** (CRUD كامل)

المسارات معرفة في [api-routes.constants.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/common/constants/api-routes.constants.ts#L59-L60).

---

## جدول محتويات ENDPOINTS

| # | العملية | Office Owner | ADMIN | Endpoint |
|---|---------|--------------|-------|----------|
| 1 | إنشاء سائق | ✅ | ✅ | `POST /users/deliveries` |
| 2 | عرض الكل | ✅ (خاصته) | ✅ (الكل) | `GET /users/deliveries` |
| 3 | البحث | ✅ (خاصته) | ✅ (الكل) | `GET /users/deliveries?search=` |
| 4 | عرض واحد | ✅ (خاصته) | ✅ (أي سائق) | `GET /users/deliveries/:id` |
| 5 | تعديل | ✅ (خاصته) | ✅ (أي سائق) | `PATCH /users/deliveries/:id` |
| 6 | حذف | ✅ (خاصته) | ✅ (أي سائق) | `DELETE /users/deliveries/:id` |

---

## 1. Create Delivery Driver (Office Owner & ADMIN)

إنشاء سائق توصيل جديد.

**Office Owner:** ينشئ سائباً تابعاً له مباشرة (officeOwnerId اختياري في payload، إذا لم يتم توفيره يستخدم معرف المستخدم الحالي).

**ADMIN:** ينشئ سائقاً ويعيّنه لأي صاحب مكتب عبر `officeOwnerId` في payload (اختياري - يمكن إنشاء سائق بدون تعيين).

- **URL:** `/users/deliveries`
- **Method:** `POST`
- **Headers:**
  - `Authorization: Bearer <token>` (Office Owner أو ADMIN)
  - `Content-Type: multipart/form-data`

### Payload (Request Body - Form Data)

| Field                 | Type   | Required | Description                              |
| --------------------- | ------ | -------- | ---------------------------------------- |
| `email`               | string | Yes      | البريد الإلكتروني (فريد)                 |
| `password`            | string | Yes      | كلمة المرور (6 أحرف على الأقل)           |
| `firstName`           | string | Yes      | الاسم الأول                              |
| `lastName`            | string | Yes      | اسم العائلة                              |
| `phone`               | string | Yes      | رقم الهاتف (فريد)                        |
| `countryId`           | number | No       | معرف الدولة                              |
| `cityId`              | number | No       | معرف المدينة                             |
| `address`             | string | No       | العنوان                                  |
| `notificationChannel` | string | No       | قناة الإشعارات (EMAIL/WHATSAPP) - افتراضي: WHATSAPP |
| `birthday`            | string | No       | تاريخ الميلاد (YYYY-MM-DD)               |
| `officeOwnerId`       | number | No       | معرف صاحب المكتب لتعيين السائق له (اختياري) - لـ ADMIN: يمكن تعيين لأي صاحب مكتب، لـ Office Owner: إذا لم يتم توفيره يستخدم معرف المستخدم الحالي |
| `image`               | file   | No       | صورة الملف الشخصي (JPG, JPEG, PNG, WebP, max 5MB). تتم معالجة الصورة تلقائياً إلى عدة أحجام (original, mobile, thumbnail) |

### Request Example (multipart/form-data)

**Office Owner Example:**

```bash
curl -X POST http://localhost:3000/api/v1/users/deliveries \
  -H "Authorization: Bearer <office_owner_token>" \
  -F "email=delivery1@example.com" \
  -F "password=strongPassword123" \
  -F "firstName=Ahmed" \
  -F "lastName=Ali" \
  -F "phone=+966501234567" \
  -F "countryId=1" \
  -F "cityId=1" \
  -F "address=Riyadh, Saudi Arabia" \
  -F "birthday=1990-05-15" \
  -F "notificationChannel=WHATSAPP" \
  -F "image=@/path/to/profile.jpg"
```

**ADMIN Example (with officeOwnerId):**

```bash
curl -X POST http://localhost:3000/api/v1/users/deliveries \
  -H "Authorization: Bearer <admin_token>" \
  -F "email=delivery_admin@example.com" \
  -F "password=strongPassword123" \
  -F "firstName=Ahmed" \
  -F "lastName=Ali" \
  -F "phone=+966509998877" \
  -F "countryId=1" \
  -F "cityId=1" \
  -F "address=Riyadh, Saudi Arabia" \
  -F "birthday=1990-05-15" \
  -F "notificationChannel=WHATSAPP" \
  -F "officeOwnerId=5" \
  -F "image=@/path/to/profile.jpg"
```

**ADMIN Example (without officeOwnerId):**

```bash
curl -X POST http://localhost:3000/api/v1/users/deliveries \
  -H "Authorization: Bearer <admin_token>" \
  -F "email=delivery_unassigned@example.com" \
  -F "password=strongPassword123" \
  -F "firstName=Ahmed" \
  -F "lastName=Ali" \
  -F "phone=+966509998888" \
  -F "countryId=1" \
  -F "cityId=1" \
  -F "address=Riyadh, Saudi Arabia" \
  -F "birthday=1990-05-15" \
  -F "notificationChannel=WHATSAPP" \
  -F "image=@/path/to/profile.jpg"
```

### Response (Success - 201 Created)

```json
{
  "statusCode": 201,
  "message": "Delivery driver created successfully",
  "data": {
    "id": 15,
    "firstName": "Ahmed",
    "lastName": "Ali",
    "email": "delivery1@example.com",
    "phone": "+966501234567",
    "role": "DELIVERY",
    "notificationChannel": "WHATSAPP",
    "countryId": 1,
    "country": {
      "id": 1,
      "name": {
        "ar": "سوريا",
        "en": "Syria"
      },
      "code": "SY",
      "callingCode": "+963",
      "currencyCode": "SYP",
      "currencySymbol": "£",
      "currencySmallestUnit": "Piastre",
      "currencyFactor": 100,
      "isActive": true
    },
    "cityId": 1,
    "city": {
      "id": 1,
      "name": {
        "ar": "دمشق",
        "en": "Damascus"
      },
      "countryId": 1
    },
    "address": "Riyadh, Saudi Arabia",
    "isOnline": true,
    "verifiedAt": "2026-02-28T06:01:16.471Z",
    "currentLat": null,
    "currentLng": null,
    "birthday": "1990-05-15",
    "createdAt": "2026-02-28T06:01:16.482Z",
    "updatedAt": "2026-02-28T06:01:16.482Z",
    "deletedAt": null,
    "officeOwner": null,
    "officeOwnerId": 5,
    "image": {
      "id": 5,
      "entityType": "USER",
      "entityId": 15,
      "url": "users/15/1772259304792_profile.webp",
      "mobileUrl": "users/15/1772259304792_profile_mobile.webp",
      "thumbnailUrl": "users/15/1772259304792_profile_thumb.webp",
      "isMain": true,
      "displayOrder": 0,
      "createdAt": "2026-02-28T06:01:16.500Z",
      "updatedAt": "2026-02-28T06:01:16.500Z"
    }
  },
  "timestamp": "2026-02-28T06:01:16.824Z",
  "path": "/api/v1/users/deliveries"
}
```

### Response (Error - 409 Conflict)

إذا كان البريد الإلكتروني أو الهاتف موجود مسبقاً:

```json
{
  "statusCode": 409,
  "message": "Email or phone already exists",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries"
}
```

### Response (Error - 422 Unprocessable Entity)

إذا كانت الصورة غير صالحة (نوع أو حجم):

```json
{
  "statusCode": 422,
  "message": "Validation failed (expected type is /(jpg|jpeg|png|webp)/)",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries"
}
```

### Response (Error - 403 Forbidden)

إذا لم يكن المستخدم OFFICE_OWNER:

```json
{
  "statusCode": 403,
  "message": "Forbidden resource",
  "error": "Forbidden",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries"
}
```

---

## 2. Get All Delivery Drivers (Office Owner - Own Drivers Only)

إرجاع قائمة سائقي التوصيل التابعين لصاحب المكتب مع دعم الفلترة والبحث والصفحات.

- **URL:** `/users/deliveries`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <office_owner_token>`

### Query Parameters

| Parameter | Type    | Description                              |
| --------- | ------- | ---------------------------------------- |
| `page`    | number  | رقم الصفحة (افتراضي: 1)                  |
| `limit`   | number  | عدد العناصر في الصفحة (افتراضي: 10)      |
| `search`  | string  | البحث بالاسم أو البريد أو الهاتف         |
| `isOnline`| boolean | الفلترة حسب حالة الاتصال                  |

### Example URL

```
GET /users/deliveries?page=1&limit=10&search=ahmed&isOnline=true
```

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": [
    {
      "id": 15,
      "firstName": "Ahmed",
      "lastName": "Ali",
      "email": "delivery1@example.com",
      "phone": "+966501234567",
      "role": "DELIVERY",
      "notificationChannel": "WHATSAPP",
      "countryId": 1,
      "country": {
        "id": 1,
        "name": {
          "ar": "سوريا",
          "en": "Syria"
        },
        "code": "SY",
        "callingCode": "+963",
        "currencyCode": "SYP",
        "currencySymbol": "£",
        "currencySmallestUnit": "Piastre",
        "currencyFactor": 100,
        "isActive": true
      },
      "cityId": 1,
      "city": {
        "id": 1,
        "name": {
          "ar": "دمشق",
          "en": "Damascus"
        },
        "countryId": 1
      },
      "address": "Riyadh, Saudi Arabia",
      "isOnline": true,
      "verifiedAt": "2026-02-28T06:01:16.471Z",
      "currentLat": null,
      "currentLng": null,
      "birthday": "1990-05-15",
      "createdAt": "2026-02-28T06:01:16.482Z",
      "updatedAt": "2026-02-28T06:01:16.482Z",
      "deletedAt": null,
      "officeOwner": null,
      "officeOwnerId": 5,
      "image": {
        "id": 5,
        "entityType": "USER",
        "entityId": 15,
        "url": "users/15/1772259304792_profile.webp",
        "mobileUrl": "users/15/1772259304792_profile_mobile.webp",
        "thumbnailUrl": "users/15/1772259304792_profile_thumb.webp",
        "isMain": true,
        "displayOrder": 0,
        "createdAt": "2026-02-28T06:01:16.500Z",
        "updatedAt": "2026-02-28T06:01:16.500Z"
      }
    }
  ],
  "pagination": {
    "total": 5,
    "page": 1,
    "limit": 10,
    "totalPages": 1,
    "hasNextPage": false,
    "hasPreviousPage": false
  },
  "timestamp": "2026-02-28T06:01:16.824Z",
  "path": "/api/v1/users/deliveries"
}
```

---

## 3. Get All Delivery Drivers (ADMIN - All Drivers)

إرجاع قائمة جميع سائقي التوصيل في النظام (ADMIN فقط).

- **URL:** `/users/deliveries`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <admin_token>`

### Query Parameters

| Parameter      | Type    | Description                              |
| -------------- | ------- | ---------------------------------------- |
| `page`         | number  | رقم الصفحة (افتراضي: 1)                  |
| `limit`        | number  | عدد العناصر في الصفحة (افتراضي: 10)      |
| `search`       | string  | البحث بالاسم                             |
| `countryId`    | number  | الفلترة حسب الدولة                       |
| `cityId`       | number  | الفلترة حسب المدينة                      |
| `isOnline`     | boolean | الفلترة حسب حالة الاتصال                  |
| `officeOwnerId`| number  | الفلترة حسب صاحب المكتب                  |

### Example URL

```
GET /users/deliveries?page=1&limit=10&officeOwnerId=5&isOnline=true
```

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": [
    {
      "id": 15,
      "email": "delivery1@example.com",
      "firstName": "Ahmed",
      "lastName": "Ali",
      "phone": "+966501234567",
      "role": "DELIVERY",
      "notificationChannel": "WHATSAPP",
      "countryId": 1,
      "cityId": 1,
      "address": "Riyadh, Saudi Arabia",
      "isOnline": true,
      "officeOwnerId": 5,
      "officeOwner": {
        "id": 5,
        "firstName": "Mohammed",
        "lastName": "Office",
        "email": "office@example.com"
      },
      "birthday": "1990-05-15",
      "verifiedAt": "2026-02-26T10:00:00.000Z",
      "createdAt": "2026-02-26T10:00:00.000Z",
      "updatedAt": "2026-02-26T10:00:00.000Z",
      "image": {
        "id": 5,
        "url": "users/15/1234567890_profile.webp",
        "mobileUrl": "users/15/1234567890_profile_mobile.webp",
        "thumbnailUrl": "users/15/1234567890_profile_thumb.webp",
        "isMain": true
      }
    }
  ],
  "pagination": {
    "total": 25,
    "page": 1,
    "limit": 10,
    "totalPages": 3,
    "hasNextPage": true,
    "hasPreviousPage": false
  },
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries"
}
```

---

## 4. Search Delivery Drivers (Office Owner)

البحث في سائقي التوصيل التابعين لصاحب المكتب بالاسم أو البريد الإلكتروني أو الهاتف.

- **URL:** `/users/deliveries`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <office_owner_token>`

### Query Parameters

| Parameter | Type   | Required | Description           |
| --------- | ------ | -------- | --------------------- |
| `search`  | string | Yes      | البحث بالاسم أو البريد الإلكتروني أو الهاتف |
| `page`    | number | No       | رقم الصفحة (افتراضي: 1) |
| `limit`   | number | No       | عدد النتائج لكل صفحة (افتراضي: 10) |
| `isOnline`| boolean | No       | فلترة حسب الحالة (online/offline) |

### Example URL

```
GET /users/deliveries?search=ahmed
```

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": [
    {
      "id": 15,
      "email": "delivery1@example.com",
      "firstName": "Ahmed",
      "lastName": "Ali",
      "phone": "+966501234567",
      "role": "DELIVERY",
      "isOnline": true,
      "image": {
        "id": 5,
        "url": "users/15/1234567890_profile.webp",
        "mobileUrl": "users/15/1234567890_profile_mobile.webp",
        "thumbnailUrl": "users/15/1234567890_profile_thumb.webp",
        "isMain": true
      }
    }
  ],
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries"
}
```

---

## 5. Search Delivery Drivers (ADMIN)

البحث في جميع سائقي التوصيل في النظام (ADMIN فقط).

- **URL:** `/users/deliveries`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <admin_token>`

### Query Parameters

| Parameter | Type   | Required | Description           |
| --------- | ------ | -------- | --------------------- |
| `search`  | string | Yes      | البحث بالاسم أو البريد الإلكتروني أو الهاتف |
| `page`    | number | No       | رقم الصفحة (افتراضي: 1) |
| `limit`   | number | No       | عدد النتائج لكل صفحة (افتراضي: 10) |
| `countryId`| number | No       | فلترة حسب الدولة |
| `cityId`   | number | No       | فلترة حسب المدينة |
| `isOnline`| boolean | No       | فلترة حسب الحالة (online/offline) |
| `officeOwnerId`| number | No       | فلترة حسب صاحب المكتب |

### Example URL

```
GET /users/deliveries?search=ahmed
```

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": [
    {
      "id": 15,
      "email": "delivery1@example.com",
      "firstName": "Ahmed",
      "lastName": "Ali",
      "phone": "+966501234567",
      "role": "DELIVERY",
      "isOnline": true,
      "officeOwnerId": 5,
      "officeOwner": {
        "id": 5,
        "firstName": "Mohammed",
        "lastName": "Office"
      },
      "image": {
        "id": 5,
        "url": "users/15/1234567890_profile.webp",
        "mobileUrl": "users/15/1234567890_profile_mobile.webp",
        "thumbnailUrl": "users/15/1234567890_profile_thumb.webp",
        "isMain": true
      }
    }
  ],
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries/search"
}
```

---

## 6. Get One Delivery Driver (Office Owner)

الحصول على تفاصيل سائق توصيل محدد تابع لصاحب المكتب.

- **URL:** `/users/deliveries/:id`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <office_owner_token>`

### URL Parameters

| Parameter | Type   | Description                    |
| --------- | ------ | ------------------------------ |
| `id`      | number | معرف سائق التوصيل (ID)         |

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": 15,
    "firstName": "Ahmed",
    "lastName": "Ali",
    "email": "delivery1@example.com",
    "phone": "+966501234567",
    "role": "DELIVERY",
    "notificationChannel": "WHATSAPP",
    "countryId": 1,
    "country": {
      "id": 1,
      "name": {
        "ar": "سوريا",
        "en": "Syria"
      },
      "code": "SY",
      "callingCode": "+963",
      "currencyCode": "SYP",
      "currencySymbol": "£",
      "currencySmallestUnit": "Piastre",
      "currencyFactor": 100,
      "isActive": true
    },
    "cityId": 1,
    "city": {
      "id": 1,
      "name": {
        "ar": "دمشق",
        "en": "Damascus"
      },
      "countryId": 1
    },
    "address": "Riyadh, Saudi Arabia",
    "isOnline": true,
    "verifiedAt": "2026-02-28T06:01:16.471Z",
    "currentLat": null,
    "currentLng": null,
    "birthday": "1990-05-15",
    "createdAt": "2026-02-28T06:01:16.482Z",
    "updatedAt": "2026-02-28T06:01:16.482Z",
    "deletedAt": null,
    "officeOwner": null,
    "officeOwnerId": 5,
    "image": {
      "id": 5,
      "entityType": "USER",
      "entityId": 15,
      "url": "users/15/1772259304792_profile.webp",
      "mobileUrl": "users/15/1772259304792_profile_mobile.webp",
      "thumbnailUrl": "users/15/1772259304792_profile_thumb.webp",
      "isMain": true,
      "displayOrder": 0,
      "createdAt": "2026-02-28T06:01:16.500Z",
      "updatedAt": "2026-02-28T06:01:16.500Z"
    }
  },
  "timestamp": "2026-02-28T06:01:16.824Z",
  "path": "/api/v1/users/deliveries/15"
}
```

### Response (Error - 404 Not Found)

إذا لم يكن السائق موجوداً أو لا يتبع لصاحب المكتب:

```json
{
  "statusCode": 404,
  "message": "Delivery driver with ID 99 not found",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries/99"
}
```

---

## 7. Get One Delivery Driver (ADMIN)

الحصول على تفاصيل أي سائق توصيل في النظام (ADMIN فقط).

- **URL:** `/users/deliveries/:id`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <admin_token>`

### URL Parameters

| Parameter | Type   | Description                    |
| --------- | ------ | ------------------------------ |
| `id`      | number | معرف سائق التوصيل (ID)         |

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": 15,
    "firstName": "Ahmed",
    "lastName": "Ali",
    "email": "delivery1@example.com",
    "phone": "+966501234567",
    "role": "DELIVERY",
    "notificationChannel": "WHATSAPP",
    "countryId": 1,
    "country": {
      "id": 1,
      "name": {
        "ar": "سوريا",
        "en": "Syria"
      },
      "code": "SY",
      "callingCode": "+963",
      "currencyCode": "SYP",
      "currencySymbol": "£",
      "currencySmallestUnit": "Piastre",
      "currencyFactor": 100,
      "isActive": true
    },
    "cityId": 1,
    "city": {
      "id": 1,
      "name": {
        "ar": "دمشق",
        "en": "Damascus"
      },
      "countryId": 1
    },
    "address": "Riyadh, Saudi Arabia",
    "isOnline": true,
    "verifiedAt": "2026-02-28T06:01:16.471Z",
    "currentLat": null,
    "currentLng": null,
    "birthday": "1990-05-15",
    "createdAt": "2026-02-28T06:01:16.482Z",
    "updatedAt": "2026-02-28T06:01:16.482Z",
    "deletedAt": null,
    "officeOwner": {
      "id": 5,
      "firstName": "Mohammed",
      "lastName": "Office",
      "email": "office@example.com"
    },
    "officeOwnerId": 5,
    "image": {
      "id": 5,
      "entityType": "USER",
      "entityId": 15,
      "url": "users/15/1772259304792_profile.webp",
      "mobileUrl": "users/15/1772259304792_profile_mobile.webp",
      "thumbnailUrl": "users/15/1772259304792_profile_thumb.webp",
      "isMain": true,
      "displayOrder": 0,
      "createdAt": "2026-02-28T06:01:16.500Z",
      "updatedAt": "2026-02-28T06:01:16.500Z"
    }
  },
  "timestamp": "2026-02-28T06:01:16.824Z",
  "path": "/api/v1/users/deliveries/15"
}
```

---

## 8. Update Delivery Driver (Office Owner & ADMIN)

تحديث بيانات سائق توصيل.

**Office Owner:** يمكنه تعديل سائقيه فقط.

**ADMIN:** يمكنه تعديل أي سائق في النظام.

- **URL:** `/users/deliveries/:id`
- **Method:** `PATCH`
- **Headers:**
  - `Authorization: Bearer <office_owner_token>`
  - `Content-Type: multipart/form-data`

### URL Parameters

| Parameter | Type   | Description                    |
| --------- | ------ | ------------------------------ |
| `id`      | number | معرف سائق التوصيل (ID)         |

### Payload (Request Body - Form Data)

| Field                 | Type    | Description                              |
| --------------------- | ------- | ---------------------------------------- |
| `firstName`           | string  | الاسم الأول الجديد                       |
| `lastName`            | string  | اسم العائلة الجديد                       |
| `phone`               | string  | رقم الهاتف الجديد                        |
| `password`            | string  | كلمة المرور الجديدة (6 أحرف على الأقل)   |
| `countryId`           | number  | معرف الدولة الجديد                       |
| `cityId`              | number  | معرف المدينة الجديد                      |
| `address`             | string  | العنوان الجديد                           |
| `notificationChannel`| string  | قناة الإشعارات الجديدة                   |
| `birthday`            | string  | تاريخ الميلاد (YYYY-MM-DD)               |
| `image`               | file    | صورة الملف الشخصي الجديدة (JPG, JPEG, PNG, WebP, max 5MB). سيتم حذف الصورة القديمة تلقائياً |

### Request Example (multipart/form-data)

```bash
curl -X PATCH http://localhost:3000/api/v1/users/deliveries/15 \
  -H "Authorization: Bearer <office_owner_token>" \
  -F "firstName=Ahmed Updated" \
  -F "lastName=Ali Updated" \
  -F "phone=+966509876543" \
  -F "image=@/path/to/new_profile.jpg"
```

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Delivery driver updated successfully",
  "data": {
    "id": 15,
    "firstName": "Ahmed Updated",
    "lastName": "Ali Updated",
    "email": "delivery1@example.com",
    "phone": "+966509876543",
    "role": "DELIVERY",
    "notificationChannel": "WHATSAPP",
    "countryId": 1,
    "country": {
      "id": 1,
      "name": {
        "ar": "سوريا",
        "en": "Syria"
      },
      "code": "SY",
      "callingCode": "+963",
      "currencyCode": "SYP",
      "currencySymbol": "£",
      "currencySmallestUnit": "Piastre",
      "currencyFactor": 100,
      "isActive": true
    },
    "cityId": 1,
    "city": {
      "id": 1,
      "name": {
        "ar": "دمشق",
        "en": "Damascus"
      },
      "countryId": 1
    },
    "address": "Riyadh, Saudi Arabia",
    "isOnline": true,
    "verifiedAt": "2026-02-28T06:01:16.471Z",
    "currentLat": null,
    "currentLng": null,
    "birthday": "1990-05-15",
    "createdAt": "2026-02-28T06:01:16.482Z",
    "updatedAt": "2026-02-28T06:05:00.000Z",
    "deletedAt": null,
    "officeOwner": null,
    "officeOwnerId": 5,
    "image": {
      "id": 6,
      "entityType": "USER",
      "entityId": 15,
      "url": "users/15/1234567891_updated.webp",
      "mobileUrl": "users/15/1234567891_updated_mobile.webp",
      "thumbnailUrl": "users/15/1234567891_updated_thumb.webp",
      "isMain": true,
      "displayOrder": 0,
      "createdAt": "2026-02-28T06:05:00.100Z",
      "updatedAt": "2026-02-28T06:05:00.100Z"
    }
  },
  "timestamp": "2026-02-28T06:05:00.200Z",
  "path": "/api/v1/users/deliveries/15"
}
```

### Response (Error - 404 Not Found)

إذا لم يكن السائق موجوداً أو لا يتبع لصاحب المكتب:

```json
{
  "statusCode": 404,
  "message": "Delivery driver with ID 99 not found",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries/99"
}
```

---

## 9. Delete Delivery Driver (Office Owner & ADMIN)

حذف سائق توصيل (حذف ناعم - يمكن استعادته لاحقاً).

**Office Owner:** يمكنه حذف سائقيه فقط.

**ADMIN:** يمكنه حذف أي سائق في النظام.

- **URL:** `/users/deliveries/:id`
- **Method:** `DELETE`
- **Headers:** `Authorization: Bearer <office_owner_token>`

### URL Parameters

| Parameter | Type   | Description                    |
| --------- | ------ | ------------------------------ |
| `id`      | number | معرف سائق التوصيل (ID)         |

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Delivery driver deleted successfully",
  "data": {},
  "timestamp": "2026-02-26T10:10:00.000Z",
  "path": "/api/v1/users/deliveries/15"
}
```

### Response (Error - 404 Not Found)

إذا لم يكن السائق موجوداً أو لا يتبع لصاحب المكتب:

```json
{
  "statusCode": 404,
  "message": "Delivery driver with ID 99 not found",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/deliveries/99"
}
```

---

## تفاصيل تقنية إضافية

### المتحكمات

- **OfficeOwnersController** ([office-owners.controller.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/controllers/office-owners.controller.ts))
  - جميع endpoints محمية بـ `AuthGuard` و `RolesGuard` و `@Roles(UserRole.OFFICE_OWNER)`
  - صاحب المكتب يمكنه فقط إدارة سائقي التوصيل التابعين له
  - الإنشاء: `POST /users/deliveries`
  - العرض (الكل): `GET /users/deliveries`
  - البحث: `GET /users/deliveries?search=`
  - العرض (واحد): `GET /users/deliveries/:id`
  - التعديل: `PATCH /users/deliveries/:id`
  - الحذف: `DELETE /users/deliveries/:id`

- **UsersAdminController** ([users-admin.controller.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/controllers/users-admin.controller.ts))
  - جميع endpoints محمية بـ `AuthGuard` و `RolesGuard` و `@Roles(UserRole.ADMIN)`
  - ADMIN يمكنه رؤية جميع سائقي التوصيل
  - العرض (الكل): `GET /users/deliveries`
  - البحث: `GET /users/deliveries?search=`
  - العرض (واحد): `GET /users/deliveries/:id`

### الخدمات

- **OfficeOwnersService** ([office-owners.service.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/services/office-owners.service.ts))
  - التحقق من الملكية: التأكد من أن السائق يتبع لصاحب المكتب
  - الفلترة والبحث: دعم كامل لل paginated results
  - معالجة الصور: رفع، تحديث، وحذف الصور

- **UsersAdminService** ([users-admin.service.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/services/users-admin.service.ts))
  - عرض جميع سائقي التوصيل في النظام
  - دعم الفلترة حسب officeOwnerId

### DTOs

- **CreateDeliveryByOfficeDto** ([create-delivery-by-office.dto.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/dto/create-delivery-by-office.dto.ts))
- **UpdateDeliveryByOfficeDto** ([update-delivery-by-office.dto.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/dto/update-delivery-by-office.dto.ts))
- **CreateDeliveryDto** ([create-delivery.dto.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/users/dto/create-delivery.dto.ts))
- **DeliveryFilterDto** ([delivery-filter.dto.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/users/dto/delivery-filter.dto.ts))

- **ملف Postman:** [Delivery Jeeb - Delivery Module](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/DOCS/ApprovedPostman/Delivery Jeeb - Delivery Module.postman_collection.json)

---

## ملاحظات أمان

1. **الدور يتم تعيينه تلقائياً:** عند إنشاء سائق توصيل، يتم تعيين الدور DELIVERY تلقائياً
2. **التحقق من البريد والهاتف:** يجب أن يكونا فريدين في النظام
3. **تشفير كلمة المرور:** جميع كلمات المرور تُخزن مشفرة باستخدام bcrypt
4. **الحذف الناعم:** عند حذف سائق، يتم soft delete (يمكن استعادته لاحقاً)
5. **التحقق من الملكية:** Office Owner يمكنه فقط إدارة سائقي التوصيل التابعين له
6. **معالجة الصور:** عند التحديث، يتم حذف الصورة القديمة تلقائياً ورفع الصورة الجديدة
