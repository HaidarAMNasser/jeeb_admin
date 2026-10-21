# توثيق حذف حساب التاجر (Soft Delete)

## نظرة عامة

حذف حساب التاجر متاح للتاجر نفسه أو للأدمن. الحساب يُحذف حذفاً منطقياً (Soft Delete)، بينما تُحذف طلبات `PENDING` نهائياً، وتُخفى المنتجات والعروض.

---

## من ينفذ العملية

| المنفذ | الصلاحية المطلوبة | المسار | المعرّف |
|---|---|---|---|
| التاجر نفسه | Access Token بدور `MERCHANT` | `DELETE /api/v1/auth/profile` | يُؤخذ من التوكن |
| الأدمن | Access Token بدور `ADMIN` | `DELETE /api/v1/users/merchants/:id` | `userId` الخاص بالتاجر |

بدائل إدارية تعطي نفس النتيجة:

- `DELETE /api/v1/users/:id`
- `DELETE /api/v1/merchants/user/:userId`

> `:id` في مسار حذف التاجر هو `userId` وليس معرّف ملف المتجر. المسار الموصى به للأدمن هو `DELETE /api/v1/users/merchants/:id`.

---

## الطلب

### الحذف الذاتي

لا يوجد Body.

```http
DELETE /api/v1/auth/profile HTTP/1.1
Host: api.example.com
Authorization: Bearer <MERCHANT_ACCESS_TOKEN>
Accept: application/json
```

### الحذف بواسطة الأدمن

لا يوجد Body.

```http
DELETE /api/v1/users/merchants/42 HTTP/1.1
Host: api.example.com
Authorization: Bearer <ADMIN_ACCESS_TOKEN>
Accept: application/json
```

---

## الاستجابة الناجحة

جميع الاستجابات تعيد الشكل التالي:

```json
{
  "statusCode": 200,
  "message": "Account deleted successfully",
  "data": {},
  "timestamp": "2026-10-20T18:30:00.000Z",
  "path": "/api/v1/auth/profile"
}
```

الحذف بواسطة الأدمن:

```json
{
  "statusCode": 200,
  "message": "Merchant deleted successfully",
  "data": {},
  "timestamp": "2026-10-20T18:30:00.000Z",
  "path": "/api/v1/users/merchants/42"
}
```

> عند استخدام `DELETE /api/v1/users/:id` تكون الرسالة `User deleted successfully` مع نفس الشكل.

---

## Workflow

1. يرسل التاجر أو الأدمن الطلب مع Access Token صالح.
2. يتحقق النظام من الصلاحية: التاجر لنفسه، أو الأدمن لحساب التاجر.
3. يتحقق النظام من وجود المستخدم وأن دوره `MERCHANT` وغير محذوف مسبقاً.
4. يبدأ Transaction واحدة لتنفيذ كل الخطوات التالية.
5. تُحذف طلبات `PENDING` الخاصة بالتاجر نهائياً، مع الفواتير وعمليات الدفع وتعيينات التوصيل والمراجعات المرتبطة بها.
6. تُحذف المنتجات والعروض حذفاً منطقياً (تصبح مخفية).
7. يُغلق ملف المتجر، وتُحذف جلسات/توكنات التحديث، ويُعطّل الحساب ويُمسح Firebase Token.
8. يُحذف حساب المستخدم حذفاً منطقياً.
9. تُثبّت العملية (Commit) وتُعاد استجابة النجاح.
10. على التطبيق حذف التوكن المحلي والتوجه لشاشة تسجيل الدخول.

### الاستعادة عند إعادة التسجيل

1. يعيد التاجر التسجيل بنفس البريد أو الهاتف وبدور `MERCHANT`.
2. يُستعاد حساب المستخدم وملف المتجر.
3. تُستعاد المنتجات والعروض التي حُذفت مع الحساب فقط.
4. المنتجات التي حذفها التاجر يدوياً قبل حذف الحساب تبقى محذوفة.
5. يبقى الحساب غير مفعّل حتى يقوم الأدمن بتفعيله.

---

## ماذا يحدث للبيانات

| البيانات | النتيجة |
|---|---|
| طلبات `PENDING` | حذف نهائي مع ملحقاتها |
| الطلبات الأخرى | تبقى كما هي |
| المنتجات والعروض | Soft Delete (مخفية) وتُستعاد عند إعادة تسجيل التاجر |
| الصور | تبقى |
| المراجعات | تبقى، عدا مراجعات الطلبات المحذوفة |
| جلسات/توكنات التحديث | تُحذف |
| Firebase Token | يُمسح |
| ملف المتجر | يبقى لكن يُغلق |
| حساب المستخدم | Soft Delete + تعطيل |

---

## حالات الخطأ

| الحالة | الكود | الرسالة |
|---|---|---|
| `:id` غير رقمي | `400` | `Validation failed (numeric string is expected)` |
| توكن مفقود أو منتهي أو ملغى | `401` | `Unauthorized` أو `Token revoked` |
| المستخدم ليس أدمن في مسار الأدمن | `403` | `Forbidden resource` |
| التاجر غير موجود أو محذوف مسبقاً | `404` | `Merchant not found` |
| محاولة حذف الحساب مرة أخرى | `404` | `Merchant not found` أو `User not found` |
| خطأ غير متوقع أثناء العملية | `500` | `Internal server error` |

### مثال 401

```json
{
  "statusCode": 401,
  "message": "Unauthorized",
  "data": {},
  "timestamp": "2026-10-20T18:30:00.000Z",
  "path": "/api/v1/auth/profile"
}
```

### مثال 403

```json
{
  "statusCode": 403,
  "message": "Forbidden resource",
  "data": {},
  "timestamp": "2026-10-20T18:30:00.000Z",
  "path": "/api/v1/users/merchants/42"
}
```

### مثال 404

```json
{
  "statusCode": 404,
  "message": "Merchant not found",
  "data": {},
  "timestamp": "2026-10-20T18:30:00.000Z",
  "path": "/api/v1/users/merchants/42"
}
```

---

## ملاحظات

- حذف التوكنات يُبطل جلسة المستخدم فوراً؛ أي طلب لاحق بالتوكن القديم يعيد `401` مع الرسالة `Token revoked`.
- على التطبيق حذف التوكن المحلي والتوجه لشاشة تسجيل الدخول.
- الحذف الثاني لنفس الحساب يعيد `404` لأن الحساب أصبح محذوفاً منطقياً.
- استعادة الحساب لا تُفعّله تلقائياً؛ تحتاج تفعيلاً من الأدمن.
