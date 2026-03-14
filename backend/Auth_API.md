# Authentication API Documentation

Base URL: `http://localhost:3000/api/v1`

## 1. Register User (Customer/Delivery)

Create a new account for a customer or delivery driver.

- **URL:** `/auth/register`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: multipart/form-data`

### Payload (Request Body - Form Data)

| Field                 | Type   | Required | Description                                 |
| --------------------- | ------ | -------- | ------------------------------------------- |
| `email`               | string | Yes      | البريد الإلكتروني                           |
| `password`            | string | Yes      | كلمة المرور (6 أحرف على الأقل)              |
| `firstName`           | string | Yes      | الاسم الأول                                 |
| `lastName`            | string | Yes      | اسم العائلة                                 |
| `phone`               | string | Yes      | رقم الهاتف                                  |
| `countryId`           | number | No       | معرف الدولة                                 |
| `cityId`              | number | No       | معرف المدينة                                |
| `address`             | string | No       | العنوان                                     |
| `notificationChannel` | string | No       | قناة الإشعارات (EMAIL أو WHATSAPP)          |
| `birthday`            | string | No       | تاريخ الميلاد (YYYY-MM-DD)                  |
| `role`                | string | No       | الدور (CUSTOMER أو MERCHANT)                |
| `image`               | file   | No       | صورة الملف الشخصي (JPG, PNG, WebP, max 5MB) |

### Request Example (multipart/form-data)

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -F "email=user@example.com" \
  -F "password=strongPassword123" \
  -F "firstName=John" \
  -F "lastName=Doe" \
  -F "phone=+963912345678" \
  -F "role=CUSTOMER" \
  -F "image=@/path/to/profile.jpg"
```

### Response (Success - 201 Created)

```json
{
  "message": "User registered successfully. Please verify your account using the OTP sent to your email.",
  "userId": 1
}
```

### Response (Error - 400 Bad Request)

If the email already exists:

```json
{
  "message": "User already exists",
  "error": "Bad Request",
  "statusCode": 400
}
```

---

## 2. Login

Authenticate a user and receive an access token.

- **URL:** `/auth/login`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`

### Payload (Request Body)

```json
{
  "email": "user@example.com",
  "password": "strongPassword123"
}
```

### Response (Success - 200 OK)

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+963912345678",
    "role": "CUSTOMER",
    "isVerified": true,
    "createdAt": "2023-10-27T10:00:00.000Z",
    "updatedAt": "2023-10-27T10:00:00.000Z",
    "verifiedAt": "2023-10-27T10:05:00.000Z",
    "country": {
      "id": 1,
      "name": "Syria",
      "code": "SY",
      "currency": "SYP"
    },
    "city": {
      "id": 1,
      "name": "Damascus"
    },
    "address": "Al-Hamra Street, Building 5",
    "notificationChannel": "EMAIL",
    "isOnline": false,
    "location": null,
    "restaurantName": null,
    "officeOwnerId": null,
    "image": {
      "id": 1,
      "url": "users/1/1234567890_profile.webp",
      "mobileUrl": "users/1/1234567890_profile_mobile.webp",
      "thumbnailUrl": "users/1/1234567890_profile_thumb.webp",
      "isMain": true
    }
  }
}
```

### Response (Error - 401 Unauthorized)

If credentials are invalid:

```json
{
  "message": "Invalid credentials",
  "error": "Unauthorized",
  "statusCode": 401
}
```

If account is not verified:

```json
{
  "message": "Account not verified. Please verify your account first.",
  "error": "Unauthorized",
  "statusCode": 401
}
```

---

## 3. Verify Account

Verify a newly registered account using the OTP sent via Email or WhatsApp.

- **URL:** `/auth/verify`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`

### Payload (Request Body)

```json
{
  "email": "user@example.com",
  "otp": "123456"
}
```

### Response (Success - 200 OK)

```json
{
  "message": "Account verified successfully. You can now login."
}
```

If account is already verified (also returns 200):

```json
{
  "message": "Account already verified"
}
```

### Response (Error - 404 Not Found)

If user does not exist:

```json
{
  "message": "User not found",
  "error": "Not Found",
  "statusCode": 404
}
```

### Response (Error - 400 Bad Request)

If OTP is invalid or expired:

```json
{
  "message": "Invalid or expired OTP",
  "error": "Bad Request",
  "statusCode": 400
}
```

---

## 4. Resend OTP

Request a new OTP if the previous one was not received.

- **URL:** `/auth/resend-otp`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`

### Payload (Request Body)

```json
{
  "email": "user@example.com"
}
```

### Response (Success - 200 OK)

```json
{
  "message": "OTP resent successfully to your email."
}
```

If account is already verified:

```json
{
  "message": "Account already verified"
}
```

### Response (Error - 404 Not Found)

If user does not exist:

```json
{
  "message": "User not found",
  "error": "Not Found",
  "statusCode": 404
}
```

---

## 5. Forgot Password

Initiate password reset process by sending an OTP.

- **URL:** `/auth/forgot-password`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`

### Payload (Request Body)

```json
{
  "email": "user@example.com"
}
```

### Response (Success - 200 OK)

```json
{
  "message": "OTP sent successfully to your email."
}
```

### Response (Error - 404 Not Found)

If user does not exist:

```json
{
  "message": "User not found",
  "error": "Not Found",
  "statusCode": 404
}
```

---

## 6. Reset Password

Set a new password using the OTP received.

- **URL:** `/auth/reset-password`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`

### Payload (Request Body)

```json
{
  "email": "user@example.com",
  "otp": "123456",
  "password": "newStrongPassword123"
}
```

### Response (Success - 200 OK)

```json
{
  "message": "Password reset successfully. You can now login."
}
```

### Response (Error - 400 Bad Request)

If OTP is invalid or expired:

```json
{
  "message": "Invalid or expired OTP",
  "error": "Bad Request",
  "statusCode": 400
}
```

### Response (Error - 404 Not Found)

If user does not exist:

```json
{
  "message": "User not found",
  "error": "Not Found",
  "statusCode": 404
}
```

---

## 7. Get Profile

Retrieve the currently authenticated user's profile.

- **URL:** `/auth/profile`
- **Method:** `GET`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Response (Success - 200 OK)

```json
{
  "id": 1,
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+963912345678",
  "role": "CUSTOMER",
  "isVerified": true,
  "createdAt": "2023-10-27T10:00:00.000Z",
  "updatedAt": "2023-10-27T10:00:00.000Z",
  "verifiedAt": "2023-10-27T10:05:00.000Z",
  "birthday": "1990-01-15",
  "country": {
    "id": 1,
    "name": "Syria",
    "code": "SY",
    "currency": "SYP"
  },
  "city": {
    "id": 1,
    "name": "Damascus"
  },
  "address": "Al-Hamra Street, Building 5",
  "notificationChannel": "EMAIL",
  "isOnline": false,
  "location": null,
  "restaurantName": null,
  "officeOwnerId": null,
  "image": {
    "id": 1,
    "url": "users/1/1234567890_profile.webp",
    "mobileUrl": "users/1/1234567890_profile_mobile.webp",
    "thumbnailUrl": "users/1/1234567890_profile_thumb.webp",
    "isMain": true
  }
}
```

### Response (Error - 401 Unauthorized)

If token is missing or invalid:

```json
{
  "message": "Unauthorized",
  "statusCode": 401
}
```

---

## 8. Update Profile

Update user profile details.

- **URL:** `/auth/profile`
- **Method:** `PATCH`
- **Headers:**
  - `Content-Type: multipart/form-data`
  - `Authorization: Bearer <access_token>`

### Payload (Request Body - Form Data)

All fields are optional.

| Field                 | Type   | Description                                  |
| --------------------- | ------ | -------------------------------------------- |
| `firstName`           | string | الاسم الأول الجديد                           |
| `lastName`            | string | اسم العائلة الجديد                           |
| `phone`               | string | رقم الهاتف الجديد                            |
| `countryId`           | number | معرف الدولة الجديد                           |
| `cityId`              | number | معرف المدينة الجديد                          |
| `address`             | string | العنوان الجديد                               |
| `notificationChannel` | string | قناة الإشعارات الجديدة                       |
| `birthday`            | string | تاريخ الميلاد (YYYY-MM-DD)                   |
| `image`               | file   | صورة الملف الشخصي الجديدة (سيتم حذف القديمة) |

### Request Example (multipart/form-data)

```bash
curl -X PATCH http://localhost:3000/api/v1/auth/profile \
  -H "Authorization: Bearer <access_token>" \
  -F "firstName=Updated Name" \
  -F "lastName=Updated Last Name" \
  -F "image=@/path/to/new_profile.jpg"
```

### Response (Success - 200 OK)

Returns the updated user object (similar to Get Profile).

```json
{
  "id": 1,
  "email": "user@example.com",
  "firstName": "John Updated",
  ...
}
```

### Response (Error - 401 Unauthorized)

If token is missing or invalid.

---

## 9. Logout

Invalidate the current access token.

- **URL:** `/auth/logout`
- **Method:** `POST`
- **Headers:**
  - `Content-Type: application/json`
  - `Authorization: Bearer <access_token>`

### Response (Success - 200 OK)

```json
{
  "message": "Logged out successfully"
}
```

### Response (Error - 401 Unauthorized)

If token is missing or invalid.
