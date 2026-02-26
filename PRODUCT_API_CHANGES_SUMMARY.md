# Product API Changes Summary

This document lists all the differences found between the Flutter code and the backend API, and the changes made to align with the backend.

## Summary of Changes

### 1. API Endpoints Changed
**Before:**
- `GET apiAdmin/Product/all`
- `GET apiAdmin/Product/{id}`
- `POST apiAdmin/Product/create`
- `PUT apiAdmin/Product/{id}`
- `DELETE apiAdmin/Product/{id}`

**After:**
- `GET /products` (with query parameters)
- `GET /products/{id}`
- `POST /products`
- `PATCH /products/{id}` (changed from PUT)
- `DELETE /products/{id}`
- `DELETE /products/images/{imageId}` (new endpoint)

### 2. HTTP Method Changed
- **Update Product**: Changed from `PUT` to `PATCH` to match backend

### 3. Request Format Changed
**Before:**
- Create/Update used JSON format with `@Field` annotations
- Images sent as `List<String>` (URLs)

**After:**
- Create/Update use `multipart/form-data` with file uploads
- Images sent as actual files via `FormData`
- All fields sent as form fields (text values)

### 4. Product Model Structure - Major Changes

#### Removed Fields:
- `quantity` (replaced with `hasStock` and `stockQuantity`)
- `rating` (not in backend API)
- `categoryName` (optional now, may not be in response)

#### Added Fields:
- `shortDescription` (String?)
- `priceAfterDiscount` (int?)
- `restaurantId` (String?) - **Required for creation**
- `discount` (int?)
- `discountType` (String?) - 'PERCENTAGE' or 'FIXED'
- `hasStock` (bool?)
- `stockQuantity` (int?) - Required if `hasStock = true`
- `isAvailable` (bool?)
- `isExternal` (bool?)
- `externalProvider` (String?) - Required if `isExternal = true`
- `externalId` (String?) - Required if `isExternal = true`
- `merchantId` (String?)
- `createdAt` (DateTime?)
- `updatedAt` (DateTime?)

#### Changed Fields:
- `price`: Changed from `double` to `int` (smallest currency unit, e.g., 1299 for 12.99)
- `categoryId`: Changed from required to optional
- `images`: Changed from `List<String>` to `List<ProductImageModel>` (complex objects)

### 5. Product Image Structure - New Model

**Before:**
```dart
List<String> images // Just URLs
```

**After:**
```dart
List<ProductImageModel> images
// Where ProductImageModel contains:
// - id (int)
// - url (String)
// - mobileUrl (String?)
// - thumbnailUrl (String?)
// - isMain (bool)
// - displayOrder (int)
```

### 6. Query Parameters for Get Products

**Before:**
- No query parameters

**After:**
- `page` (int?) - Page number (default: 1)
- `limit` (int?) - Items per page (default: 10)
- `search` (String?) - Search by name
- `categoryId` (String?) - Filter by category
- `restaurantId` (String?) - Filter by restaurant

### 7. Response Structure Changes

**Backend Response Format:**
```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": { ... },
  "pagination": { ... }, // For list endpoints
  "timestamp": "...",
  "path": "..."
}
```

**Key Changes:**
- Status code is `statusCode` (not `status`)
- List responses include `pagination` object
- Product data structure matches backend exactly

### 8. Create Product Payload Changes

**Before:**
```dart
{
  name: String,
  description: String?,
  price: double,
  category_id: String,
  quantity: int?,
  images: List<String>
}
```

**After (FormData):**
```
name: Text (required)
description: Text (optional)
shortDescription: Text (optional)
price: Text (required) - as integer string
restaurantId: Text (required)
categoryId: Text (optional)
discount: Text (optional)
discountType: Text (optional) - 'PERCENTAGE' or 'FIXED'
hasStock: Text (optional) - 'true'/'false'
stockQuantity: Text (conditional) - required if hasStock = true
isAvailable: Text (optional) - 'true'/'false'
isExternal: Text (optional) - 'true'/'false'
externalProvider: Text (conditional) - required if isExternal = true
externalId: Text (conditional) - required if isExternal = true
images: File[] (optional) - up to 5 images (jpg, png, webp)
```

### 9. Update Product Payload Changes

**Before:**
- Same as create, all fields required

**After:**
- All fields are optional
- Can send `imagesMetadata` as JSON string to update image order/main image:
  ```json
  [{"id":10,"isMain":true,"displayOrder":0}]
  ```
- Can add new images via `images` File[] array

### 10. New Endpoint: Delete Product Image

**New Endpoint:**
- `DELETE /products/images/{imageId}`

### 11. Files Created

1. `lib/features/product/list_product/data/models/product_image_model.dart`
2. `lib/features/product/list_product/domain/entities/product_image_entity.dart`

### 12. Files Modified

1. `lib/core/infrastructure/api/api_service.dart`
2. `lib/core/infrastructure/api/api_service_impl.dart`
3. `lib/features/product/list_product/data/models/product_model.dart`
4. `lib/features/product/list_product/domain/entities/product_entity.dart`
5. `lib/features/product/list_product/data/mappers/product_mapper.dart`
6. `lib/features/product/list_product/data/data_sources/list_product_data_source.dart`
7. `lib/features/product/list_product/data/repositories/list_product_repository.dart`
8. `lib/features/product/create_product/data/data_sources/create_product_data_source.dart`
9. `lib/features/product/create_product/data/repositories/create_product_repository.dart`
10. `lib/features/product/update_product/data/data_sources/update_product_data_source.dart`
11. `lib/features/product/update_product/data/repositories/update_product_repository.dart`
12. `lib/features/product/delete_product/data/data_sources/delete_product_data_source.dart`

## Important Notes

1. **Price Format**: All prices must be converted to smallest currency unit (multiply by 100 for dollars/cents)
2. **FormData**: Create and Update operations now require FormData with file uploads
3. **Restaurant ID**: Required for product creation
4. **Stock Management**: Use `hasStock` and `stockQuantity` instead of `quantity`
5. **Image Handling**: Images are now complex objects with multiple URLs (full, mobile, thumbnail)
6. **Pagination**: List endpoints return pagination metadata
7. **Status Codes**: Check `statusCode` field (201 for create, 200 for others)

## Next Steps Required

The following UI/presentation layer files will need updates to work with the new structure:

1. **Create Product Form**: 
   - Update to use FormData
   - Add restaurantId field (required)
   - Add new fields (shortDescription, discount, discountType, hasStock, stockQuantity, isAvailable, isExternal, etc.)
   - Handle file uploads instead of image URLs
   - Convert price to integer (smallest currency unit)

2. **Update Product Form**:
   - Same as create, but all fields optional
   - Handle image metadata updates
   - Support adding new images while keeping existing ones

3. **Product List**:
   - Add pagination support
   - Add search/filter functionality
   - Update to display new image structure

4. **Product Details**:
   - Update to display all new fields
   - Handle new image structure (show mobile/thumbnail URLs)
   - Add delete image functionality

5. **BLoC Events/States**:
   - Update to handle FormData
   - Update to handle new field types
   - Update to handle pagination







