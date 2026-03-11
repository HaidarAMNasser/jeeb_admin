# Orders API Documentation

Base URL: `http://localhost:3000/api/v1`

## الجدول المحتويات

1. [نظرة عامة على حالات الطلب](#1-نظرة-عامة-على-حالات-الطلب)
   - [المراحل التفصيلية لكل حالة](#المراحل-التفصيلية-لكل-حالة)
     - [PENDING (في الانتظار)](#1️⃣-pending-في-الانتظار)
     - [CONFIRMED (تم التأكيد)](#2️⃣-confirmed-تم-التأكيد)
     - [PREPARING (قيد التحضير)](#3️⃣-preparing-قيد-التحضير)
     - [READY_FOR_PICKUP (جاهز للاستلام)](#4️⃣-ready_for_pickup-جاهز-للاستلام)
     - [ASSIGNED (تم التعيين)](#5️⃣-assigned-تم-التعيين)
     - [PICKED_UP (تم الاستلام)](#6️⃣-picked_up-تم-الاستلام)
     - [ON_THE_WAY (في الطريق)](#7️⃣-on_the_way-في-الطريق)
     - [DELIVERED (تم التسليم)](#8️⃣-delivered-تم-التسليم)
     - [CANCELLED (ملغى)](#9️⃣-cancelled-ملغى)
     - [REJECTED (مرفوض)](#🔟-rejected-مرفوض)
   - [ملخص مسارات تدفق الطلب](#ملخص-مسارات-تدفق-الطلب)
2. [الصلاحيات حسب الدور](#2-الصلاحيات-حسب-الدور)
3. [إنشاء طلب جديد](#3-إنشاء-طلب-جديد)
4. [استرجاع جميع الطلبات](#4-استرجاع-جميع-الطلبات)
5. [استرجاع طلب واحد](#5-استرجاع-طلب-واحد)
6. [تحديث حالة الطلب](#6-تحديث-حالة-الطلب)
7. [تأكيد الطلب](#7-تأكيد-الطلب)
8. [إلغاء الطلب](#8-إلغاء-الطلب)
9. [رفض الطلب](#9-رفض-الطلب)
10. [إرسال إشعارات التوصيل](#10-إرسال-إشعارات-التوصيل)
11. [قبول التوصيل](#11-قبول-التوصيل)
12. [رفض التوصيل](#12-رفض-التوصيل)
13. [كائنات البيانات (Entities)](#13-كائنات-البيانات-entities)

---

## 1. نظرة عامة على حالات الطلب

يمر الطلب عبر المراحل التالية:

```
PENDING → CONFIRMED → PREPARING → READY_FOR_PICKUP → ASSIGNED → PICKED_UP → ON_THE_WAY → DELIVERED
                 ↓                                              ↓                    ↓
           REJECTED (terminal)                           CANCELLED (terminal)    (terminal)
```

### حالات الطلب (OrderStatus)

| الحالة             | الوصف                          | English                                         |
| ------------------ | ------------------------------ | ----------------------------------------------- |
| `PENDING`          | الطلب وصل ولم يقبله التاجر بعد | Order received, waiting for merchant acceptance |
| `CONFIRMED`        | التاجر قبل الطلب               | Merchant confirmed the order                    |
| `PREPARING`        | التاجر بدأ التحضير             | Merchant started preparing                      |
| `READY_FOR_PICKUP` | جاهز للاستلام                  | Ready for pickup by driver                      |
| `ASSIGNED`         | تم تعيين سائق                  | Driver assigned                                 |
| `PICKED_UP`        | السائق استلم الطلب             | Driver picked up the order                      |
| `ON_THE_WAY`       | السائق في الطريق               | Driver on the way                               |
| `DELIVERED`        | تم التوصيل                     | Delivered                                       |
| `CANCELLED`        | ملغى من العميل أو النظام       | Cancelled by customer or system                 |
| `REJECTED`         | مرفوض من المطعم                | Rejected by restaurant                          |

### الصلاحيات وتصفية البيانات (Role-based Filtering)

يتم عرض البيانات بناءً على هوية المستخدم المرتبطة بالـ Token:

| الدور (Role) | الفلترة المطبقة (Filtering Logic)                                         | الوصف                                                       |
| :----------- | :------------------------------------------------------------------------ | :---------------------------------------------------------- |
| **ADMIN**    | لا توجد فلترة                                                             | يمكن للمدير رؤية جميع الطلبات في النظام.                    |
| **MERCHANT** | `ownerId = currentUserId`                                                 | يرى التاجر فقط الطلبات التي تنتمي لمتاجره.                  |
| **DELIVERY** | `status = 'READY_FOR_PICKUP'` <br> OR `applied/assigned to currentUserId` | يرى السائق الطلبات الجاهزة للاستلام أو التي استلمها بالفعل. |
| **CUSTOMER** | `customerId = currentUserId`                                              | يرى العميل طلباته الشخصية فقط.                              |

---

### انتقالات الحالات المسموحة

| من حالة          | إلى حالة                       |
| ---------------- | ------------------------------ |
| PENDING          | CONFIRMED, REJECTED, CANCELLED |
| CONFIRMED        | PREPARING, CANCELLED           |
| PREPARING        | READY_FOR_PICKUP, CANCELLED    |
| READY_FOR_PICKUP | ASSIGNED, CANCELLED            |
| ASSIGNED         | PICKED_UP, CANCELLED           |
| PICKED_UP        | ON_THE_WAY, DELIVERED          |
| ON_THE_WAY       | DELIVERED                      |
| DELIVERED        | (نهاية - لا انتقالات)          |
| CANCELLED        | (نهاية - لا انتقالات)          |
| REJECTED         | (نهاية - لا انتقالات)          |

### المراحل التفصيلية لكل حالة

#### 1️⃣ PENDING (في الانتظار) {#pending}

**الوصف:** الطلب الجديد وصل إلى النظام بانتظار قبول التاجر

**من يمكنه الوصول:**

- العميل (CUSTOMER): يمكنه عرض الطلب أو إلغاؤه
- التاجر (MERCHANT): يمكنه عرض الطلب أو تأكيده أو رفضه
- المدير (ADMIN): يمكنه عرض وتعديل أي طلب

**مثال Response عند استرجاع الطلب:**

```json
{
  "id": 123,
  "status": "PENDING",
  "deliveryDeadline": "2024-01-15T14:30:00.000Z",
  "items": [
    {
      "productName": "شاورما دجاج",
      "quantity": 2,
      "unitPrice": 7500,
      "totalPrice": 15000
    }
  ],
  "totalAmount": 19000,
  "createdAt": "2024-01-15T13:45:00.000Z"
}
```

**الإجراءات المتاحة:**

- تأكيد الطلب (MERCHANT/ADMIN) → CONFIRMED
- رفض الطلب (MERCHANT/ADMIN) → REJECTED
- إلغاء الطلب (CUSTOMER/MERCHANT/ADMIN) → CANCELLED

---

#### 2️⃣ CONFIRMED (تم التأكيد) {#confirmed}

**الوصف:** التاجر أكد الطلب وبدء التحضير

**من يمكنه الوصول:**

- التاجر (MERCHANT): يمكنه تحضير الطلب أو إلغاؤه
- المدير (ADMIN): يمكنه أي إجراء

**Request - تغيير إلى PREPARING:**

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/preparing \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "تم بدء تحضير الطلب"}'
```

**Response:**

```json
{
  "id": 123,
  "status": "PREPARING",
  "updatedAt": "2024-01-15T13:50:00.000Z",
  "items": [...],
  "totalAmount": 19000
}
```

**الإجراءات المتاحة:**

- بدء التحضير (MERCHANT/ADMIN) → PREPARING
- إلغاء الطلب (MERCHANT/ADMIN) → CANCELLED

---

#### 3️⃣ PREPARING (قيد التحضير) {#preparing}

**الوصف:** التاجر يحضر الطلب

**من يمكنه الوصول:**

- التاجر (MERCHANT): يمكنه إكمال التحضير أو إلغاؤه
- المدير (ADMIN): يمكنه أي إجراء

**Request - تغيير إلى READY_FOR_PICKUP:**

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/ready-for-pickup \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "الطلب جاهز للاستلام"}'
```

**Response:**

```json
{
  "id": 123,
  "status": "READY_FOR_PICKUP",
  "updatedAt": "2024-01-15T14:00:00.000Z",
  "items": [...],
  "totalAmount": 19000
}
```

**ملاحظة:** عند الوصول لهذه الحالة، يتم إرسال إشعارات تلقائية للسائقين المتاحين

**الإجراءات المتاحة:**

- تحديد جاهز للاستلام (MERCHANT/ADMIN) → READY_FOR_PICKUP
- إلغاء الطلب (MERCHANT/ADMIN) → CANCELLED

---

#### 4️⃣ READY_FOR_PICKUP (جاهز للاستلام) {#ready-for-pickup}

**الوصف:** الطلب جاهز لاستلامه من قبل سائق التوصيل

**من يمكنه الوصول:**

- السائقين المتاحين (DELIVERY): يمكنهم عرض وطلب قبول التوصيل
- صاحب المطعم (MERCHANT): يمكنه العرض والإلغاء
- المدير (ADMIN): يمكنه أي إجراء

**Request - إرسال إشعارات التوصيل (إذا لم تكن مُرسلة تلقائياً):**

```bash
curl -X POST http://localhost:3000/api/v1/orders/123/send-delivery-notifications \
  -H "Authorization: Bearer <access_token>"
```

**Response:**

```json
{
  "message": "Delivery notifications sent successfully"
}
```

**Request - قبول التوصيل (من السائق):**

```bash
curl -X POST http://localhost:3000/api/v1/orders/123/accept-delivery \
  -H "Authorization: Bearer <access_token>"
```

**Response:**

```json
{
  "id": 1,
  "orderId": 123,
  "deliveryId": 5,
  "status": "ACCEPTED",
  "assignedAt": "2024-01-15T14:05:00.000Z",
  "acceptedAt": "2024-01-15T14:05:00.000Z"
}
```

**ملاحظة:** عند قبول التحويل، تتغير حالة الطلب إلى ASSIGNED تلقائياً

**الإجراءات المتاحة:**

- تعيين سائق (نظام/مسؤول) → ASSIGNED
- إلغاء الطلب (MERCHANT/ADMIN) → CANCELLED

---

#### 5️⃣ ASSIGNED (تم التعيين) {#assigned}

**الوصف:** تم تعيين سائق للطلب

**من يمكنه الوصول:**

- السائق المكلف (DELIVERY): يمكنه استلام الطلب أو رفضه
- المدير (ADMIN): يمكنه أي إجراء

**Request - تغيير إلى PICKED_UP (من السائق):**

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/picked-up \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "تم استلام الطلب من المطعم"}'
```

**Response:**

```json
{
  "id": 123,
  "status": "PICKED_UP",
  "deliveryAssignment": {
    "id": 1,
    "deliveryId": 5,
    "pickedAt": "2024-01-15T14:10:00.000Z",
    "status": "PICKED_UP"
  },
  "updatedAt": "2024-01-15T14:10:00.000Z"
}
```

**الإجراءات المتاحة:**

- استلام الطلب (DELIVERY/ADMIN) → PICKED_UP
- إلغاء الطلب (ADMIN) → CANCELLED

---

#### 6️⃣ PICKED_UP (تم الاستلام) {#picked-up}

**الوصف:** السائق استلم الطلب من المطعم وهو في طريقه

**من يمكنه الوصول:**

- السائق المكلف (DELIVERY): يمكنه تحديث حالة التوصيل
- المدير (ADMIN): يمكنه أي إجراء

**Request - تغيير إلى ON_THE_WAY (من السائق):**

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/on-the-way \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "في الطريق إلى العميل"}'
```

**Response:**

```json
{
  "id": 123,
  "status": "ON_THE_WAY",
  "deliveryAssignment": {
    "id": 1,
    "deliveryId": 5,
    "status": "ON_THE_WAY"
  },
  "updatedAt": "2024-01-15T14:20:00.000Z"
}
```

**أو يمكن القفز مباشرة إلى DELIVERED:**

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/delivered \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "تم التسليم بنجاح"}'
```

**Response:**

```json
{
  "id": 123,
  "status": "DELIVERED",
  "finalLocation": {
    "lat": 33.5138,
    "lng": 36.2765
  },
  "deliveryAssignment": {
    "id": 1,
    "deliveryId": 5,
    "deliveredAt": "2024-01-15T14:30:00.000Z",
    "status": "DELIVERED"
  },
  "updatedAt": "2024-01-15T14:30:00.000Z"
}
```

**الإجراءات المتاحة:**

- في الطريق (DELIVERY/ADMIN) → ON_THE_WAY
- تم التسليم (DELIVERY/ADMIN) → DELIVERED

---

#### 7️⃣ ON_THE_WAY (في الطريق) {#on-the-way}

**الوصف:** السائق في الطريق إلى عنوان العميل

**من يمكنه الوصول:**

- السائق المكلف (DELIVERY): يمكنه تأكيد التسليم
- المدير (ADMIN): يمكنه أي إجراء

**Request - تغيير إلى DELIVERED (من السائق):**

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/delivered \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "تم التسليم للعميل"}'
```

**Response:**

```json
{
  "id": 123,
  "status": "DELIVERED",
  "finalLocation": {
    "lat": 33.5138,
    "lng": 36.2765
  },
  "deliveryAssignment": {
    "id": 1,
    "deliveryId": 5,
    "deliveredAt": "2024-01-15T14:35:00.000Z",
    "status": "DELIVERED"
  },
  "updatedAt": "2024-01-15T14:35:00.000Z"
}
```

**ملاحظة مهمة:** عند الوصول لهذه الحالة:

- يتم تعيين `finalLocation` من `deliveryCoordinates`
- هذه حالة نهائية (terminal state)
- لا يمكن العودة منها لحالة أخرى

---

#### 8️⃣ DELIVERED (تم التسليم) {#delivered}

**الوصف:** تم توصيل الطلب بنجاح للعميل - هذه هي الحالة النهائية (terminal state) للطلب الناجح

**من يمكنه الوصول:**

- السائق المكلف (DELIVERY): يمكنه تحديث حالة الطلب إلى DELIVERED
- المدير (ADMIN): يمكنه أي إجراء

**الحالات السابقة المسموحة:**

- PICKED_UP (يمكن القفز مباشرة)
- ON_THE_WAY

---

### Request لتغيير الحالة إلى DELIVERED

**من PICKED_UP (القفز مباشرة):**

- **URL:** `/orders/:id/delivered`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

**URL Parameters:**

| المعامل | النوع  | مطلوب | الوصف     |
| ------- | ------ | ----- | --------- |
| `id`    | number | نعم   | رقم الطلب |

**Payload (Request Body):**

| الحقل               | النوع  | مطلوب   | الوصف                  |
| ------------------- | ------ | ------- | ---------------------- |
| `reason`            | string | لا      | سبب التسليم            |
| `finalLocation`     | object | **نعم** | الموقع النهائي للتسليم |
| `finalLocation.lat` | number | نعم     | خط العرض               |
| `finalLocation.lng` | number | نعم     | خط الطول               |

```json
{
  "reason": "تم التسليم بنجاح للعميل",
  "finalLocation": {
    "lat": 33.5138,
    "lng": 36.2765
  }
}
```

**ملاحظة:** إذا لم يتم إرسال `finalLocation` في الـ Payload، سيتم استخدام `deliveryCoordinates` كاحتياطي

---

### curl Example

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/delivered \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "reason": "تم التسليم بنجاح للعميل",
    "finalLocation": {
      "lat": 33.5138,
      "lng": 36.2765
    }
  }'
```

---

### Response (Success - 200 OK)

```json
{
  "id": 123,
  "customerId": 1,
  "ownerId": 1,
  "paymentMethod": "CASH",
  "status": "DELIVERED",
  "deliveryDeadline": "2024-01-15T14:30:00.000Z",
  "deliveryCoordinates": {
    "latitude": 33.5138,
    "longitude": 36.2765,
    "address": "Al-Hamra Street, Building 5",
    "landmark": "Next to the park",
    "specialInstructions": "Call upon arrival"
  },
  "finalLocation": {
    "lat": 33.5138,
    "lng": 36.2765
  },
  "items": [
    {
      "id": 1,
      "productId": 10,
      "productName": "شاورما دجاج",
      "quantity": 2,
      "originalUnitPrice": 7000,
      "unitPrice": 7500,
      "totalPrice": 15000
    },
    {
      "id": 2,
      "productId": 15,
      "productName": "عصير برتقال",
      "quantity": 1,
      "originalUnitPrice": 2500,
      "unitPrice": 2500,
      "totalPrice": 2500
    }
  ],
  "couponCode": "WELCOME20",
  "priceBeforeDiscount": 20000,
  "discountAmount": 3000,
  "priceAfterProductDiscount": 17500,
  "tipAmount": 500,
  "platformCommission": 1450,
  "ownerRevenue": 13050,
  "deliveryFee": 1500,
  "totalAmount": 19000,
  "currencyCode": "SYP",
  "deliveryAssignment": {
    "id": 1,
    "orderId": 123,
    "deliveryId": 5,
    "assignedAt": "2024-01-15T14:05:00.000Z",
    "acceptedAt": "2024-01-15T14:05:00.000Z",
    "pickedAt": "2024-01-15T14:10:00.000Z",
    "deliveredAt": "2024-01-15T14:35:00.000Z",
    "groupIndex": 0,
    "notifiedAt": "2024-01-15T14:00:00.000Z",
    "status": "DELIVERED"
  },
  "createdAt": "2024-01-15T13:45:00.000Z",
  "updatedAt": "2024-01-15T14:35:00.000Z"
}
```

---

### 🗺️ آلية تعيين finalLocation

عند تغيير حالة الطلب إلى `DELIVERED`، يمكن تعيين `finalLocation` بطريقتين:

**الأولوية الأولى: من الـ Payload (إذا تم إرساله)**

```typescript
// إذا أرسل السائق finalLocation في الـ Payload
if (context.finalLocation) {
  order.finalLocation = context.finalLocation;
}
```

**الاحتياطي: من deliveryCoordinates (إذا لم يُرسل في الـ Payload)**

```typescript
// otherwise use deliveryCoordinates as fallback
else if (order.deliveryCoordinates) {
  order.finalLocation = {
    lat: order.deliveryCoordinates.latitude,
    lng: order.deliveryCoordinates.longitude,
  };
}
```

**الجدول الزمني للتعيين:**

| الخطوة | الإجراء                                                  |
| ------ | -------------------------------------------------------- |
| 1      | العميل يُنشئ الطلب مع `deliveryCoordinates`              |
| 2      | يتم تخزين `deliveryCoordinates` في قاعدة البيانات        |
| 3      | السائق يُسلّم الطلب ويرسل `finalLocation` في الـ Payload |
| 4      | النظام يُعيّن `finalLocation`                            |

---

### 📊 مقارنة deliveryCoordinates vs finalLocation

| الحقل                 | المصدر                      | الوصف                  |
| --------------------- | --------------------------- | ---------------------- |
| `deliveryCoordinates` | من العميل (عند إنشاء الطلب) | الموقع المطلوب للتسليم |
| `finalLocation`       | من السائق (عند التسليم)     | الموقع الفعلي للتسليم  |

**لماذا قد يختلفان؟**

- قد يصل السائق إلى موقع مختلف قليلاً عن الموقع المطلوب
- قد يختار العميل موقعاً مختلفاً عند وصول السائق

---

### Response (Error - 400 Bad Request)

إذا كان الانتقال غير صالح (مثلاً من PENDING):

```json
{
  "message": "Cannot transition from \"PENDING\" to \"DELIVERED\". Allowed transitions: CONFIRMED, REJECTED, CANCELLED",
  "error": "Bad Request",
  "statusCode": 400
}
```

---

### Response (Error - 403 Forbidden)

إذا لم يكن لدى المستخدم صلاحية:

```json
{
  "message": "Role \"MERCHANT\" cannot change status to \"DELIVERED\"",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

### Response (Error - 404 Not Found)

إذا كان الطلب غير موجود:

```json
{
  "message": "Order with ID 123 not found",
  "error": "Not Found",
  "statusCode": 404
}
```

---

### Response (Error - 400 Bad Request - تم التسليم مسبقاً)

```json
{
  "message": "Order already delivered",
  "error": "Bad Request",
  "statusCode": 400
}
```

---

### 💡 ملاحظات مهمة

1. **finalLocation**: يُرسَل في الـ Payload ويجب تحديده عند التسليم
2. **إذا لم يُرسل**: يتم استخدام `deliveryCoordinates` كاحتياطي
3. **هذه حالة نهائية**: لا يمكن الانتقال منها إلى أي حالة أخرى
4. **deliveryAssignment.deliveredAt**: يتم تعيينه أيضاً مع وقت التسليم الفعلي
5. **الصلاحيات**: فقط السائق المكلف أو ADMIN يمكنهم تنفيذ هذا الإجراء

---

### 📊 مقارنة deliveryCoordinates vs finalLocation

| الحقل                 | الوصف                          | متى يُعين                      |
| --------------------- | ------------------------------ | ------------------------------ |
| `deliveryCoordinates` | موقع التسليم المطلوب من العميل | عند إنشاء الطلب                |
| `finalLocation`       | الموقع الفعلي للتسليم          | عند تغيير الحالة إلى DELIVERED |

---

#### 9️⃣ CANCELLED (ملغى) {#cancelled}

**الوصف:** تم إلغاء الطلب

**الحالات التي يمكن الإلغاء منها:**

- PENDING (أي مستخدم بصلاحية)
- CONFIRMED (MERCHANT/ADMIN)
- PREPARING (MERCHANT/ADMIN)
- READY_FOR_PICKUP (MERCHANT/ADMIN)
- ASSIGNED (ADMIN فقط)

**Request - إلغاء الطلب (من العميل):**

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/cancel \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "تغيير في الخطط"}'
```

**Response:**

```json
{
  "id": 123,
  "status": "CANCELLED",
  "updatedAt": "2024-01-15T13:55:00.000Z"
}
```

**ملاحظة:** عند الإلغاء، يتم إعادة المخزون المستهلك للمنتجات

---

#### 🔟 REJECTED (مرفوض) {#rejected}

**الوصف:** رفض المطعم الطلب

**الحالة:** يمكن الرفض فقط من PENDING

**Request - رفض الطلب (من صاحب المطعم):**

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/reject \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "المنتج غير متوفر حالياً"}'
```

**Response:**

```json
{
  "id": 123,
  "status": "REJECTED",
  "updatedAt": "2024-01-15T13:50:00.000Z"
}
```

**ملاحظة:** عند الرفض، يتم إعادة المخزون المستهلك للمنتجات

---

### ملخص مسارات تدفق الطلب

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         مسار الطلب الناجح                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   CUSTOMER                    MERCHANT                   DELIVERY           │
│     │                           │                           │                │
│     │──── POST /orders ───────►│                           │                │
│     │◄──── 201 Created ────────│                           │                │
│     │     (PENDING)            │                           │                │
│     │                           │                           │                │
│     │                           │──── PATCH /confirm ─────►│                │
│     │                           │◄──── 200 OK ─────────────│                │
│     │                           │     (CONFIRMED)          │                │
│     │                           │                           │                │
│     │                           │──── PATCH /preparing ───►│                │
│     │                           │◄──── 200 OK ─────────────│                │
│     │                           │     (PREPARING)          │                │
│     │                           │                           │                │
│     │                           │──── PATCH /ready───────►│                │
│     │                           │◄──── 200 OK ─────────────│                │
│     │                           │  (READY_FOR_PICKUP)      │                │
│     │                           │                           │                │
│     │                           │    (إشعارات تلقائية)     │                │
│     │                           │                           │                │
│     │                           │                     ◄───┤──── POST /accept
│     │                           │                     ────►│ 200 OK         │
│     │                           │                     (ASSIGNED)            │
│     │                           │                           │                │
│     │                           │                           │──── PATCH /picked-up
│     │                           │                           │◄──── 200 OK    │
│     │                           │                           │  (PICKED_UP)  │
│     │                           │                           │                │
│     │                           │                           │──── PATCH /on-the-way
│     │                           │                           │◄──── 200 OK    │
│     │                           │                           │(ON_THE_WAY)   │
│     │                           │                           │                │
│     │                           │                           │──── PATCH /delivered
│     │                           │                           │◄──── 200 OK    │
│     │                           │                           │ (DELIVERED)   │
│     │                           │                           │                │
│     ▼                           ▼                           ▼                │
│  (DELIVERED)                (DELIVERED)                 (DELIVERED)        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                       مسار إلغاء الطلب                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   CUSTOMER                         MERCHANT                                  │
│     │                                │                                       │
│     │──── PATCH /cancel ────────────►│                                       │
│     │◄──── 200 OK ───────────────────│                                       │
│     │     (CANCELLED)                │                                       │
│     │                                │                                       │
│     │         (RESTORE STOCK)        │                                       │
│     │                                │                                       │
└─────────────────────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                       مسار رفض الطلب                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                         MERCHANT                                            │
│                           │                                                 │
│     PENDING ─────────────►│──── PATCH /reject ────► REJECTED               │
│                           │     (RESTORE STOCK)                             │
│                           │                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. الصلاحيات حسب الدور

### أدوار المستخدمين (UserRole)

| الدور          | الوصف           |
| -------------- | --------------- |
| `CUSTOMER`     | العميل          |
| `MERCHANT`     | صاحب المطعم     |
| `DELIVERY`     | سائق التوصيل    |
| `ADMIN`        | مدير النظام     |
| `OFFICE_OWNER` | صاحب مكتب توصيل |
| `SUPPORT`      | الدعم الفني     |

### صلاحيات تعديل حالة الطلب حسب الدور

| الدور          | الحالات المسموح بتعديلها                         |
| -------------- | ------------------------------------------------ |
| `CUSTOMER`     | CANCELLED (فقط للطلبات PENDING)                  |
| `MERCHANT`     | CONFIRMED, PREPARING, READY_FOR_PICKUP, REJECTED |
| `DELIVERY`     | PICKED_UP, ON_THE_WAY, DELIVERED                 |
| `ADMIN`        | جميع الحالات                                     |
| `OFFICE_OWNER` | لا يوجد صلاحيات                                  |
| `SUPPORT`      | لا يوجد صلاحيات                                  |

### صلاحيات عرض الطلبات

| الدور      | الوصول                      |
| ---------- | --------------------------- |
| `ADMIN`    | يرى جميع الطلبات            |
| `MERCHANT` | يرى فقط طلبات مطاعمه الخاصة |
| `CUSTOMER` | يرى فقط طلباته الشخصية      |
| `DELIVERY` | يرى فقط الطلبات المكلفة له  |

---

## 3. إنشاء طلب جديد

إنشاء طلب جديد مع التحقق من المخزون وحساب الأسعار.

- **URL:** `/orders`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Payload (Request Body)

| الحقل                                     | النوع  | مطلوب | الوصف                                                 |
| ----------------------------------------- | ------ | ----- | ----------------------------------------------------- |
| `restaurantId`                            | number | نعم   | معرف المطعم                                           |
| `items`                                   | array  | نعم   | قائمة المنتجات (يجب أن يحتوي على عنصر واحد على الأقل) |
| `items[].productId`                       | number | نعم   | معرف المنتج                                           |
| `items[].quantity`                        | number | نعم   | الكمية (يجب أن تكون ≥ 1)                              |
| `deliveryCoordinates`                     | object | نعم   | إحداثيات التوصيل                                      |
| `deliveryCoordinates.latitude`            | number | نعم   | خط العرض                                              |
| `deliveryCoordinates.longitude`           | number | نعم   | خط الطول                                              |
| `deliveryCoordinates.address`             | string | لا    | العنوان التفصيلي                                      |
| `deliveryCoordinates.landmark`            | string | لا    | علامة مميزة                                           |
| `deliveryCoordinates.specialInstructions` | string | لا    | تعليمات خاصة                                          |
| `couponCode`                              | string | لا    | كود الخصم                                             |
| `deliveryFee`                             | number | لا    | رسوم التوصيل                                          |
| `tipAmount`                               | number | لا    | مبلغ البقشيش                                          |
| `cityId`                                  | number | لا    | معرف المدينة                                          |
| `paymentMethod`                           | string | نعم   | طريقة الدفع (CASH, WALLET, ONLINE)                    |

### Request Example

```json
{
  "restaurantId": 1,
  "items": [
    {
      "productId": 10,
      "quantity": 2
    },
    {
      "productId": 15,
      "quantity": 1
    }
  ],
  "deliveryCoordinates": {
    "latitude": 33.5138,
    "longitude": 36.2765,
    "address": "Al-Hamra Street, Building 5",
    "landmark": "Next to the park",
    "specialInstructions": "Call upon arrival"
  },
  "couponCode": "WELCOME20",
  "deliveryFee": 1500,
  "tipAmount": 500,
  "cityId": 1,
  "paymentMethod": "CASH"
}
```

### Response (Success - 201 Created)

```json
{
  "order": {
    "id": 123,
    "customerId": 1,
    "customer": {
      "id": 1,
      "firstName": "أحمد",
      "lastName": "محمد",
      "phone": "+963912345678",
      "email": "ahmed@example.com"
    },
    "restaurantId": 1,
    "restaurant": {
      "id": 1,
      "name": "مطعم المشويات الذهبية"
    },
    "paymentMethod": "CASH",
    "status": "PENDING",
    "deliveryDeadline": "2024-01-15T14:30:00.000Z",
    "deliveryCoordinates": {
      "latitude": 33.5138,
      "longitude": 36.2765,
      "address": "Al-Hamra Street, Building 5"
    },
    "finalLocation": null,
    "items": [
      {
        "id": 1,
        "productId": 10,
        "productName": "شاورما دجاج",
        "quantity": 2,
        "unitPrice": 7500,
        "totalPrice": 15000
      },
      {
        "id": 2,
        "productId": 15,
        "productName": "عصير برتقال",
        "quantity": 1,
        "unitPrice": 2500,
        "totalPrice": 2500
      }
    ],
    "couponCode": "WELCOME20",
    "priceBeforeDiscount": 20000,
    "discountAmount": 3000,
    "priceAfterProductDiscount": 17500,
    "tipAmount": 500,
    "platformCommission": 1450,
    "restaurantRevenue": 13050,
    "deliveryFee": 1500,
    "totalAmount": 19000,
    "currencyCode": "SYP",
    "createdAt": "2024-01-15T13:45:00.000Z",
    "updatedAt": "2024-01-15T13:45:00.000Z"
  }
}
```

### Response (Error - 400 Bad Request)

إذا كان المنتج غير متوفر:

```json
{
  "message": "المنتج غير متوفر: شاورما دجاج",
  "error": "Bad Request",
  "statusCode": 400
}
```

إذا كان المخزون غير كافٍ:

```json
{
  "message": "المخزون غير كافٍ \"شاورما دجاج\". المتوفر: 5، المطلوب: 10",
  "error": "Bad Request",
  "statusCode": 400
}
```

إذا كان المطعم غير نشط:

```json
{
  "message": "المطعم غير متاح حالياً",
  "error": "Bad Request",
  "statusCode": 400
}
```

---

## 4. استرجاع جميع الطلبات

استرجاع قائمة الطلبات مع دعم الفلترة والترقيم.

- **URL:** `/orders`
- **Method:** `GET`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Query Parameters

| المعامل  | النوع  | مطلوب | الوصف                                       |
| -------- | ------ | ----- | ------------------------------------------- |
| `page`   | number | لا    | رقم الصفحة (الافتراضي: 1)                   |
| `limit`  | number | لا    | عدد العناصر في الصفحة (الافتراضي: 10)       |
| `search` | string | لا    | البحث برقم الطلب أو اسم العميل              |
| `status` | string | لا    | فلترة حسب الحالة (PENDING, CONFIRMED, etc.) |

### Request Example

```bash
curl -X GET "http://localhost:3000/api/v1/orders?page=1&limit=10&status=PENDING" \
  -H "Authorization: Bearer <access_token>"
```

### Response (Success - 200 OK)

```json
{
  "data": [
    {
      "id": 123,
      "customerId": 1,
      "customer": {
        "id": 1,
        "firstName": "أحمد",
        "lastName": "محمد",
        "phone": "+963912345678"
      },
      "restaurantId": 1,
      "restaurant": {
        "id": 1,
        "name": "مطعم المشويات الذهبية"
      },
      "paymentMethod": "CASH",
      "status": "PENDING",
      "deliveryDeadline": "2024-01-15T14:30:00.000Z",
      "deliveryCoordinates": {
        "latitude": 33.5138,
        "longitude": 36.2765,
        "address": "Al-Hamra Street"
      },
      "finalLocation": null,
      "items": [
        {
          "id": 1,
          "productId": 10,
          "productName": "شاورما دجاج",
          "quantity": 2,
          "unitPrice": 7500,
          "totalPrice": 15000
        }
      ],
      "couponCode": "WELCOME20",
      "priceBeforeDiscount": 20000,
      "discountAmount": 3000,
      "priceAfterProductDiscount": 17500,
      "tipAmount": 500,
      "platformCommission": 1450,
      "restaurantRevenue": 13050,
      "deliveryFee": 1500,
      "totalAmount": 19000,
      "currencyCode": "SYP",
      "createdAt": "2024-01-15T13:45:00.000Z",
      "updatedAt": "2024-01-15T13:45:00.000Z"
    }
  ],
  "total": 1,
  "page": 1,
  "limit": 10
}
```

### Response (Error - 401 Unauthorized)

```json
{
  "message": "Unauthorized",
  "statusCode": 401
}
```

---

## 5. استرجاع طلب واحد

استرجاع تفاصيل طلب محدد بواسطة رقم الطلب.

- **URL:** `/orders/:id`
- **Method:** `GET`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### URL Parameters

| المعامل | النوع  | الوصف     |
| ------- | ------ | --------- |
| `id`    | number | رقم الطلب |

### Request Example

```bash
curl -X GET http://localhost:3000/api/v1/orders/123 \
  -H "Authorization: Bearer <access_token>"
```

### Response (Success - 200 OK)

```json
{
  "id": 123,
  "customerId": 1,
  "customer": {
    "id": 1,
    "email": "ahmed@example.com",
    "firstName": "أحمد",
    "lastName": "محمد",
    "phone": "+963912345678",
    "role": "CUSTOMER"
  },
  "restaurantId": 1,
  "restaurant": {
    "id": 1,
    "name": "مطعم المشويات الذهبية",
    "ownerId": 5
  },
  "paymentMethod": "CASH",
  "status": "PREPARING",
  "deliveryDeadline": "2024-01-15T14:30:00.000Z",
  "deliveryCoordinates": {
    "latitude": 33.5138,
    "longitude": 36.2765,
    "address": "Al-Hamra Street, Building 5",
    "landmark": "Next to the park",
    "specialInstructions": "Call upon arrival"
  },
  "finalLocation": null,
  "items": [
    {
      "id": 1,
      "productId": 10,
      "productName": "شاورما دجاج",
      "quantity": 2,
      "originalUnitPrice": 7000,
      "unitPrice": 7500,
      "totalPrice": 15000
    }
  ],
  "couponCode": "WELCOME20",
  "priceBeforeDiscount": 20000,
  "discountAmount": 3000,
  "priceAfterProductDiscount": 17500,
  "tipAmount": 500,
  "platformCommission": 1450,
  "ownerRevenue": 13050,
  "deliveryFee": 1500,
  "totalAmount": 19000,
  "currencyCode": "SYP",
  "createdAt": "2024-01-15T13:45:00.000Z",
  "updatedAt": "2024-01-15T13:50:00.000Z"
}
```

### Response (Error - 404 Not Found)

```json
{
  "message": "Order with ID 123 not found",
  "error": "Not Found",
  "statusCode": 404
}
```

### Response (Error - 403 Forbidden)

```json
{
  "message": "Access denied: insufficient permissions for this order",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 6. تحديث حالة الطلب

تحديث حالة طلب ديناميكياً مع التحقق من الصحة والإشعارات.

- **URL:** `/orders/:id/:status`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### URL Parameters

| المعامل  | النوع  | مطلوب | الوصف                                                                                                                   |
| -------- | ------ | ----- | ----------------------------------------------------------------------------------------------------------------------- |
| `id`     | number | نعم   | رقم الطلب                                                                                                               |
| `status` | string | نعم   | الحالة الجديدة (pending, confirmed, preparing, ready-for-pickup, picked-up, on-the-way, delivered, cancelled, rejected) |

### Request Body (Optional)

| الحقل    | النوع  | الوصف            |
| -------- | ------ | ---------------- |
| `reason` | string | سبب تغيير الحالة |

### Request Example

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/preparing \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "تم بدء تحضير الطلب"}'
```

### Response (Success - 200 OK)

```json
{
  "id": 123,
  "customerId": 1,
  "restaurantId": 1,
  "paymentMethod": "CASH",
  "status": "PREPARING",
  "deliveryDeadline": "2024-01-15T14:30:00.000Z",
  "deliveryCoordinates": {
    "latitude": 33.5138,
    "longitude": 36.2765,
    "address": "Al-Hamra Street"
  },
  "finalLocation": null,
  "items": [...],
  "couponCode": "WELCOME20",
  "priceBeforeDiscount": 20000,
  "discountAmount": 3000,
  "priceAfterProductDiscount": 17500,
  "tipAmount": 500,
  "platformCommission": 1450,
  "ownerRevenue": 13050,
  "deliveryFee": 1500,
  "totalAmount": 19000,
  "currencyCode": "SYP",
  "createdAt": "2024-01-15T13:45:00.000Z",
  "updatedAt": "2024-01-15T13:50:00.000Z"
}
```

### Response (Error - 400 Bad Request)

إذا كان الانتقال بين الحالات غير صالح:

```json
{
  "message": "Cannot transition from \"PENDING\" to \"DELIVERED\". Allowed transitions: CONFIRMED, REJECTED, CANCELLED",
  "error": "Bad Request",
  "statusCode": 400
}
```

### Response (Error - 403 Forbidden)

إذا لم يكن لدى المستخدم صلاحية:

```json
{
  "message": "Role \"CUSTOMER\" cannot change status to \"PREPARING\"",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 7. تأكيد الطلب

تأكيد الطلب من قبل المطعم.

- **URL:** `/orders/:id/confirm`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Request Example

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/confirm \
  -H "Authorization: Bearer <access_token>"
```

### Response (Success - 200 OK)

```json
{
  "id": 123,
  "status": "CONFIRMED",
  ...
}
```

---

## 8. إلغاء الطلب

إلغاء الطلب من قبل العميل أو المطعم.

- **URL:** `/orders/:id/cancel`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Request Body (Optional)

| الحقل    | النوع  | الوصف       |
| -------- | ------ | ----------- |
| `reason` | string | سبب الإلغاء |

### Request Example

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/cancel \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "تغيير في الخطط"}'
```

### Response (Success - 200 OK)

```json
{
  "id": 123,
  "status": "CANCELLED",
  ...
}
```

### ملاحظات

- إذا كان المنتج يحتوي على مخزون، يتم إعادة المخزون المُستهلك عند الإلغاء
- العملاء يمكنهم إلغاء الطلبات فقط إذا كانت الحالة `PENDING`
- المالكون والتجار يمكنهم إلغاء الطلبات في أي حالة (ما لم تكن `DELIVERED` أو `CANCELLED` أو `REJECTED`)

---

## 9. رفض الطلب

رفض الطلب من قبل المطعم.

- **URL:** `/orders/:id/reject`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Request Body (Optional)

| الحقل    | النوع  | الوصف     |
| -------- | ------ | --------- |
| `reason` | string | سبب الرفض |

### Request Example

```bash
curl -X PATCH http://localhost:3000/api/v1/orders/123/reject \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "المنتج غير متوفر حالياً"}'
```

### Response (Success - 200 OK)

```json
{
  "id": 123,
  "status": "REJECTED",
  ...
}
```

### ملاحظات

- يتم إعادة المخزون المُستهلك عند الرفض
- يمكن رفض الطلبات فقط إذا كانت الحالة `PENDING`

---

## 10. إرسال إشعارات التوصيل

إرسال إشعارات للسائقين المتاحين när الطلب يصبح جاهز للاستلام.

- **URL:** `/orders/:id/send-delivery-notifications`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Request Example

```bash
curl -X POST http://localhost:3000/api/v1/orders/123/send-delivery-notifications \
  -H "Authorization: Bearer <access_token>"
```

### Response (Success - 200 OK)

```json
{
  "message": "Delivery notifications sent successfully"
}
```

### ملاحظات

- يتم إرسال الإشعارات تلقائياً عند تغيير الحالة إلى `READY_FOR_PICKUP`
- يتم اختيار أقرب 3 سائقين متاحين بناءً على الإحداثيات
- إذا لم يكن هناك سائقين متاحين، يتم جدولة إعادة المحاولة

---

## 11. قبول التوصيل

قبول السائق لطلب التوصيل.

- **URL:** `/orders/:id/accept-delivery`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Request Example

```bash
curl -X POST http://localhost:3000/api/v1/orders/123/accept-delivery \
  -H "Authorization: Bearer <access_token>"
```

### Response (Success - 200 OK)

```json
{
  "id": 1,
  "orderId": 123,
  "deliveryId": 5,
  "status": "ACCEPTED",
  "assignedAt": "2024-01-15T13:50:00.000Z",
  "acceptedAt": "2024-01-15T13:50:00.000Z"
}
```

### Response (Error - 400 Bad Request)

```json
{
  "message": "Delivery already assigned",
  "error": "Bad Request",
  "statusCode": 400
}
```

### Response (Error - 403 Forbidden)

```json
{
  "message": "Only delivery drivers can accept assignments",
  "error": "Forbidden",
  "statusCode": 403
}
```

---

## 12. رفض التوصيل

رفض السائق لطلب التوصيل.

- **URL:** `/orders/:id/reject-delivery`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Request Body (Optional)

| الحقل    | النوع  | الوصف     |
| -------- | ------ | --------- |
| `reason` | string | سبب الرفض |

### Request Example

```bash
curl -X POST http://localhost:3000/api/v1/orders/123/reject-delivery \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -d '{"reason": "بعيد جداً عن موقعي"}'
```

### Response (Success - 200 OK)

```json
{
  "message": "Delivery rejected successfully"
}
```

---

## 13. كائنات البيانات (Entities)

### Order (الطلب)

```typescript
{
  id: number;                    // رقم الطلب
  customerId: number;            // رقم العميل
  customer: User;                // بيانات العميل
  restaurantId: number;          // رقم المطعم
  restaurant: Restaurant;        // بيانات المطعم
  totalAmount: number;           // المبلغ الإجمالي (بأصغر وحدة)
  deliveryFee: number;           // رسوم التوصيل
  discountAmount: number;         // مبلغ الخصم
  couponCode: string | null;     // كود الكوبون
  tipAmount: number;             // مبلغ البقشيش
  platformCommission: number;    // عمولة المنصة
  restaurantRevenue: number;     // إيراد المطعم
  currencyCode: string;          // رمز العملة
  paymentMethod: PaymentMethod;  // طريقة الدفع
  status: OrderStatus;           // حالة الطلب
  deliveryDeadline: Date;        // الموعد النهائي للتوصيل
  deliveryCoordinates: {        // إحداثيات التوصيل
    latitude: number;
    longitude: number;
    address?: string;
    landmark?: string;
    specialInstructions?: string;
  };
  finalLocation: { lat: number; lng: number } | null; // الموقع النهائي (يُملأ عند التسليم)
  items: OrderItem[];            // عناصر الطلب
  deliveryAssignment: DeliveryAssignment | null; // تعيين التوصيل
  createdAt: Date;               // تاريخ الإنشاء
  updatedAt: Date;               // تاريخ التحديث

  // حقول محسوبة (تُرجع في الاستجابة فقط)
  priceBeforeDiscount: number;          // السعر قبل الخصم
  priceAfterProductDiscount: number;    // السعر بعد خصم المنتجات
}
```

### OrderItem (عنصر الطلب)

```typescript
{
  id: number; // رقم العنصر
  orderId: number; // رقم الطلب
  productId: number | null; // رقم المنتج
  productName: string; // اسم المنتج
  quantity: number; // الكمية
  originalUnitPrice: number; // السعر الأصلي للمنتج
  unitPrice: number; // سعر الوحدة (بعد أي تعديلات)
  totalPrice: number; // السعر الإجمالي للعنصر
}
```

### DeliveryAssignment (تعيين التوصيل)

```typescript
{
  id: number; // رقم التعيين
  orderId: number; // رقم الطلب
  order: Order; // بيانات الطلب
  deliveryId: number; // رقم السائق
  delivery: User; // بيانات السائق
  assignedAt: Date; // وقت التعيين
  acceptedAt: Date | null; // وقت القبول
  pickedAt: Date | null; // وقت الاستلام
  deliveredAt: Date | null; // وقت التسليم
  groupIndex: number; // مجموعة الإشعارات
  notifiedAt: Date | null; // وقت الإشعار
  status: DeliveryStatus; // حالة التوصيل
}
```

### PaymentMethod (طرق الدفع)

| القيمة   | الوصف               |
| -------- | ------------------- |
| `CASH`   | نقداً عند الاستلام  |
| `WALLET` | المحفظة الإلكترونية |
| `ONLINE` | دفع إلكتروني        |

### PaymentProvider (مزودو الدفع الإلكتروني)

| القيمة                | الوصف           |
| --------------------- | --------------- |
| `STRIPE`              | Stripe          |
| `PAYPAL`              | PayPal          |
| `MTN_CASH`            | MTN Cash        |
| `SYRIATEL_CASH`       | Syriatel Cash   |
| `USDT`                | USDT            |
| `LOCAL_BANK_TRANSFER` | تحويل بنكي محلي |
| `UNKNOWN`             | غير معروف       |

### DeliveryStatus (حالات التوصيل)

| القيمة       | الوصف       |
| ------------ | ----------- |
| `ASSIGNED`   | تم التعيين  |
| `ACCEPTED`   | تم القبول   |
| `PICKED_UP`  | تم الاستلام |
| `ON_THE_WAY` | في الطريق   |
| `DELIVERED`  | تم التسليم  |
| `CANCELLED`  | ملغى        |
| `FAILED`     | فشل         |

---

## ملاحظات مهمة

1. **الوحدات المالية**: جميع المبالغ المالية تُخزن وتُرجع بأصغر وحدة عملة (مثل: هللات أو cents). 比如: 1500 = 15.00 SAR

2. **المخزون**: عند إنشاء طلب، يتم خصم الكمية من المخزون تلقائياً. عند إلغاء أو رفض الطلب، يتم إعادة الكمية إلى المخزون.

3. **منحنيات التسعير**:
   - `priceBeforeDiscount`: مجموع الأسعار الأصلية لجميع العناصر
   - `priceAfterProductDiscount`: السعر بعد خصومات المنتجات (لكن قبل الكوبون)
   - `totalAmount`: السعر النهائي شاملاً رسوم التوصيل والبقشيش والضرائب

4. **الإشعارات**: يتم إرسال إشعارات للسائقين تلقائياً عند تحوّل الطلب إلى حالة `READY_FOR_PICKUP`

5. **finalLocation**: هذا الحقل يُملأ فقط عند تغيير حالة الطلب إلى `DELIVERED`، ويحمل قيمة `deliveryCoordinates`

---

(End of file - total 782 lines)
