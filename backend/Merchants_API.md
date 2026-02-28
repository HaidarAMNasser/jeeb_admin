# Merchants API Documentation

Base URL: `http://localhost:3000/api/v1`

## نظرة عامة ودور الصلاحيات

- **ADMIN:** يمتلك صلاحيات كاملة لإدارة التجار (أصحاب المطاعم):
  - إنشاء تاجر جديد
  - عرض جميع التجار مع الفلترة والبحث
  - عرض تفاصيل تاجر محدد
  - تعديل بيانات التاجر
  - حذف التاجر (Soft Delete)
  
- **MERCHANT:** الدور يتم تعيينه تلقائياً عند الإنشاء، لا يحتاج لإرساله في الـ payload

**ملاحظة أمنية:** جميع endpoints الخاصة بالتجار تتطلب صلاحية **ADMIN** فقط.

المسارات معرفة في [api-routes.constants.ts](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/common/constants/api-routes.constants.ts#L56-L57).

---

## 1. Create Merchant (ADMIN only)

إنشاء تاجر جديد (صاحب مطعم). الدور MERCHANT يتم تعيينه تلقائياً.

- **URL:** `/users/merchants`
- **Method:** `POST`
- **Headers:**
  - `Authorization: Bearer <admin_token>`
  - `Content-Type: multipart/form-data`

### Payload (Request Body - Form Data)

| Field         | Type   | Required | Description                              |
| ------------- | ------ | -------- | ---------------------------------------- |
| `email`       | string | Yes      | البريد الإلكتروني (فريد)                 |
| `password`    | string | Yes      | كلمة المرور (6 أحرف على الأقل)           |
| `firstName`   | string | Yes      | الاسم الأول                              |
| `lastName`    | string | Yes      | اسم العائلة                              |
| `phone`       | string | Yes      | رقم الهاتف (فريد)                        |
| `countryId`   | number | No       | معرف الدولة                              |
| `cityId`      | number | No       | معرف المدينة                             |
| `address`     | string | No       | العنوان                                  |
| `birthday`    | string | No       | تاريخ الميلاد (YYYY-MM-DD)               |
| `image`       | file   | No       | صورة الملف الشخصي (JPG, JPEG, PNG, WebP, max 5MB). تتم معالجة الصورة تلقائياً إلى عدة أحجام (original, mobile, thumbnail) |

### Request Example (multipart/form-data)

```bash
curl -X POST http://localhost:3000/api/v1/users/merchants \
  -H "Authorization: Bearer <admin_token>" \
  -F "email=merchant@example.com" \
  -F "password=strongPassword123" \
  -F "firstName=John" \
  -F "lastName=Doe" \
  -F "phone=+963912345678" \
  -F "countryId=1" \
  -F "cityId=1" \
  -F "address=Damascus, Merchant Street 123" \
  -F "birthday=1990-05-15" \
  -F "image=@/path/to/profile.jpg"
```

### Response (Success - 201 Created)

```json
{
  "statusCode": 201,
  "message": "Merchant created successfully",
  "data": {
    "id": 10,
    "email": "merchant@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+963912345678",
    "role": "MERCHANT",
    "countryId": 1,
    "cityId": 1,
    "address": "Damascus, Merchant Street 123",
    "birthday": "1990-05-15",
    "isOnline": true,
    "verifiedAt": "2026-02-26T10:00:00.000Z",
    "createdAt": "2026-02-26T10:00:00.000Z",
    "updatedAt": "2026-02-26T10:00:00.000Z",
    "image": {
      "id": 1,
      "url": "users/10/1234567890_profile.webp",
      "mobileUrl": "users/10/1234567890_profile_mobile.webp",
      "thumbnailUrl": "users/10/1234567890_profile_thumb.webp",
      "isMain": true
    }
  },
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/merchants"
}
```

### Response (Error - 409 Conflict)

إذا كان البريد الإلكتروني أو الهاتف موجود مسبقاً:

```json
{
  "statusCode": 409,
  "message": "Email already exists",
  "data": {},
  "timestamp": "2026-02-26T06:11:29.408Z",
  "path": "/api/v1/users/merchants"
}
```

### Response (Error - 422 Unprocessable Entity)

إذا كانت الصورة غير صالحة (نوع أو حجم):

```json
{
  "statusCode": 422,
  "message": "Validation failed (expected type is /(jpg|jpeg|png|webp)/)",
  "data": {},
  "timestamp": "2026-02-26T06:11:29.408Z",
  "path": "/api/v1/users/merchants"
}
```

### Response (Error - 403 Forbidden)

إذا لم يكن المستخدم ADMIN:

```json
{
  "statusCode": 403,
  "message": "Forbidden resource",
  "error": "Forbidden",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/merchants"
}
```

---

## 2. Get All Merchants (Filter, Search & Pagination)

إرجاع قائمة التجار مع دعم الفلترة والبحث الشامل والصفحات. يتطلب صلاحية ADMIN.

**ملاحظة:** البحث تم دمجه في endpoint العرض الكل. لا يوجد endpoint منفصل للبحث.

- **URL:** `/users/merchants`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <admin_token>`

### Query Parameters

| Parameter    | Type    | Required | Description                              |
| ------------ | ------- | -------- | ---------------------------------------- |
| `page`       | number  | No       | رقم الصفحة (افتراضي: 1)                  |
| `limit`      | number  | No       | عدد العناصر في الصفحة (افتراضي: 10)      |
| `search`     | string  | No       | البحث الشامل بالاسم أو البريد أو الهاتف |
| `countryId`  | number  | No       | الفلترة حسب الدولة                       |
| `cityId`     | number  | No       | الفلترة حسب المدينة                      |
| `isActive`   | boolean | No       | الفلترة حسب حالة الاتصال (isOnline)      |

### البحث الشامل

عند استخدام `search`، يتم البحث في الحقول التالية:
- `firstName` (الاسم الأول)
- `lastName` (اسم العائلة)
- `email` (البريد الإلكتروني)
- `phone` (رقم الهاتف)

### Example URLs

```
# عرض كل التجار
GET /users/merchants

# بحث مع فلترة
GET /users/merchants?search=john&countryId=1

# صفحة محددة مع عدد عناصر
GET /users/merchants?page=1&limit=10&search=john
```

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": [
    {
      "id": 10,
      "email": "merchant@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "phone": "+963912345678",
      "role": "MERCHANT",
      "countryId": 1,
      "cityId": 1,
      "address": "Damascus, Merchant Street 123",
      "birthday": "1990-05-15",
      "isOnline": false,
      "verifiedAt": null,
      "createdAt": "2026-02-26T10:00:00.000Z",
      "updatedAt": "2026-02-26T10:00:00.000Z",
      "country": {
        "id": 1,
        "name": "Syria",
        "code": "SY"
      },
      "city": {
        "id": 1,
        "name": "Damascus"
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
  "path": "/api/v1/users/merchants"
}
```

---

## 3. Get One Merchant

الحصول على تفاصيل تاجر محدد مع المطاعم المرتبطة به.

- **URL:** `/users/merchants/:id`
- **Method:** `GET`
- **Headers:** `Authorization: Bearer <admin_token>`

### URL Parameters

| Parameter | Type   | Description           |
| --------- | ------ | --------------------- |
| `id`      | number | معرف التاجر (ID)      |

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": 10,
    "email": "merchant@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+963912345678",
    "role": "MERCHANT",
    "countryId": 1,
    "cityId": 1,
    "address": "Damascus, Merchant Street 123",
    "birthday": "1990-05-15",
    "isOnline": true,
    "verifiedAt": "2026-02-26T06:10:41.208Z",
    "createdAt": "2026-02-26T10:00:00.000Z",
    "updatedAt": "2026-02-26T10:00:00.000Z",
    "country": {
      "id": 1,
      "name": "Syria",
      "code": "SY"
    },
    "city": {
      "id": 1,
      "name": "Damascus"
    },
    "image": {
      "id": 1,
      "url": "users/10/1234567890_profile.webp",
      "mobileUrl": "users/10/1234567890_profile_mobile.webp",
      "thumbnailUrl": "users/10/1234567890_profile_thumb.webp",
      "isMain": true
    },
    "ownedRestaurants": [
      {
        "id": 1,
        "name": "Best Burger",
        "address": "123 Tasty St"
      }
    ]
  },
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/merchants/10"
}
```

### Response (Error - 404 Not Found)

```json
{
  "statusCode": 404,
  "message": "Merchant with ID 999 not found",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/merchants/999"
}
```

---

## 4. Update Merchant

تحديث بيانات تاجر موجود. جميع الحقول اختيارية.

- **URL:** `/users/merchants/:id`
- **Method:** `PATCH`
- **Headers:**
  - `Authorization: Bearer <admin_token>`
  - `Content-Type: multipart/form-data`

### URL Parameters

| Parameter | Type   | Description           |
| --------- | ------ | --------------------- |
| `id`      | number | معرف التاجر (ID)      |

### Payload (Request Body - Form Data)

| Field         | Type    | Description                              |
| ------------- | ------- | ---------------------------------------- |
| `firstName`   | string  | الاسم الأول الجديد                       |
| `lastName`    | string  | اسم العائلة الجديد                       |
| `phone`       | string  | رقم الهاتف الجديد                        |
| `password`    | string  | كلمة المرور الجديدة (6 أحرف على الأقل)   |
| `countryId`   | number  | معرف الدولة الجديد                       |
| `cityId`      | number  | معرف المدينة الجديد                      |
| `address`     | string  | العنوان الجديد                           |
| `birthday`    | string  | تاريخ الميلاد (YYYY-MM-DD)               |
| `isActive`    | boolean | حالة الاتصال (isOnline)                  |
| `image`       | file    | صورة الملف الشخصي الجديدة (JPG, JPEG, PNG, WebP, max 5MB). سيتم حذف الصورة القديمة تلقائياً ومعالجة الصورة الجديدة إلى عدة أحجام (original, mobile, thumbnail) |

### Request Example (multipart/form-data)

```bash
curl -X PATCH http://localhost:3000/api/v1/users/merchants/10 \
  -H "Authorization: Bearer <admin_token>" \
  -F "firstName=John Updated" \
  -F "lastName=Doe Updated" \
  -F "phone=+963987654321" \
  -F "image=@/path/to/new_profile.jpg"
```

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Merchant updated successfully",
  "data": {
    "id": 10,
    "email": "merchant@example.com",
    "firstName": "John Updated",
    "lastName": "Doe Updated",
    "phone": "+963987654321",
    "role": "MERCHANT",
    "countryId": 2,
    "cityId": 3,
    "address": "New Address Street",
    "birthday": "1990-05-15",
    "isOnline": true,
    "verifiedAt": "2026-02-26T06:10:41.208Z",
    "createdAt": "2026-02-26T10:00:00.000Z",
    "updatedAt": "2026-02-26T10:05:00.000Z",
    "image": {
      "id": 2,
      "url": "users/10/1234567891_updated.webp",
      "mobileUrl": "users/10/1234567891_updated_mobile.webp",
      "thumbnailUrl": "users/10/1234567891_updated_thumb.webp",
      "isMain": true
    }
  },
  "timestamp": "2026-02-26T10:05:00.000Z",
  "path": "/api/v1/users/merchants/10"
}
```

### Response (Error - 403 Forbidden)

إذا كان التاجر يملك مطاعم مرتبطة ولا يمكن حذفه:

```json
{
  "message": "Cannot update merchant with invalid data",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 5. Delete Merchant (Soft Delete)

حذف تاجر (حذف ناعم - يمكن استعادته لاحقاً). لا يمكن حذف تاجر يملك مطاعم.

- **URL:** `/users/merchants/:id`
- **Method:** `DELETE`
- **Headers:** `Authorization: Bearer <admin_token>`

### URL Parameters

| Parameter | Type   | Description           |
| --------- | ------ | --------------------- |
| `id`      | number | معرف التاجر (ID)      |

### Response (Success - 200 OK)

```json
{
  "statusCode": 200,
  "message": "Merchant deleted successfully",
  "data": {},
  "timestamp": "2026-02-26T10:10:00.000Z",
  "path": "/api/v1/users/merchants/10"
}
```

### Response (Error - 403 Forbidden)

```json
{
  "statusCode": 403,
  "message": "Cannot delete merchant with associated restaurants. Please transfer or delete restaurants first.",
  "data": {},
  "timestamp": "2026-02-26T10:00:00.000Z",
  "path": "/api/v1/users/merchants/10"
}
```

---

## تفاصيل تقنية إضافية

- **المتحكم:** [MerchantController](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/controllers/merchant.controller.ts)
  - جميع endpoints محمية بـ `AuthGuard` و `RolesGuard` و `@Roles(UserRole.ADMIN)`
  - الإنشاء: `POST /users/merchants`
  - العرض (الكل مع البحث): `GET /users/merchants?search=` - البحث مدمج في نفس endpoint
  - العرض (واحد): `GET /users/merchants/:id`
  - التعديل: `PATCH /users/merchants/:id`
  - الحذف: `DELETE /users/merchants/:id`

- **الخدمة:** [MerchantService](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/services/merchant.service.ts)
  - التحقق من وجود البريد/الهاتف: قبل الإنشاء
  - تشفير كلمة المرور: bcrypt
  - التحقق من الملكية: التأكد من عدم وجود مطاعم مرتبطة قبل الحذف
  - البحث الشامل: يبحث في firstName, lastName, email, phone
  - الفلترة والـ Pagination: دعم كامل لل paginated results

- **DTOs:**
  - [CreateMerchantDto](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/dto/create-merchant.dto.ts)
  - [UpdateMerchantDto](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/dto/update-merchant.dto.ts)
  - [FilterMerchantDto](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/src/modules/auth/dto/filter-merchant.dto.ts)

- **ملف Postman:** [Delivery Jeeb - Merchants Module](file:///c:/Users/RYZEN/Desktop/Jeeb_BackEnd/delivery-jeeb/DOCS/ApprovedPostman/Delivery Jeeb - Merchants Module.postman_collection.json)

---

## ملاحظات أمان

1. **الدور يتم تعيينه تلقائياً:** لا يمكن للـ ADMIN إنشاء مستخدم بدور آخر من خلال هذه endpoints
2. **التحقق من البريد والهاتف:** يجب أن يكونا فريدين في النظام
3. **تشفير كلمة المرور:** جميع كلمات المرور تُخزن مشفرة باستخدام bcrypt
4. **الحذف الناعم:** عند حذف تاجر، يتم soft delete (يمكن استعادته لاحقاً)
5. **التحقق من المطاعم:** لا يمكن حذف تاجر يملك مطاعم - يجب نقل المطاعم أولاً
