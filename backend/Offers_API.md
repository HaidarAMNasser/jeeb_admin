{
	"info": {
		"_postman_id": "4b6a1aff-0914-401c-a59c-075a2d1ab566",
		"name": "Jeeb_Offers_Collection",
		"description": "Collection for Offers API - Create, Read, Update, Delete offers for merchants",
		"schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
		"_exporter_id": "46725728",
		"_collection_link": "https://assemhabib.postman.co/workspace/My-Workspace~e8ecb1f6-b28c-414e-8872-ce787ba90138/collection/46725728-4b6a1aff-0914-401c-a59c-075a2d1ab566?action=share&source=collection_link&creator=46725728"
	},
	"item": [
		{
			"name": "Auth",
			"item": [
				{
					"name": "Login (Merchant)",
					"event": [
						{
							"listen": "test",
							"script": {
								"exec": [
									"var jsonData = pm.response.json();",
									"if (jsonData.data && jsonData.data.access_token) {",
									"    pm.environment.set(\"token\", jsonData.data.access_token);",
									"    pm.collectionVariables.set(\"token\", jsonData.data.access_token);",
									"    console.log(\"Token updated\");",
									"}"
								],
								"type": "text/javascript",
								"packages": {}
							}
						}
					],
					"request": {
						"method": "POST",
						"header": [],
						"body": {
							"mode": "raw",
							"raw": "{\n    \"email\": \"merchant4@example.com\",\n    \"password\": \"password\"\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseUrl}}/auth/login",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"auth",
								"login"
							]
						}
					},
					"response": [
						{
							"name": "Success",
							"originalRequest": {
								"method": "POST",
								"header": [],
								"body": {
									"mode": "raw",
									"raw": "{\n    \"email\": \"merchant@example.com\",\n    \"password\": \"password123\"\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseUrl}}/auth/login",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"auth",
										"login"
									]
								}
							},
							"status": "OK",
							"code": 200,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 200,\n    \"message\": \"Operation successful\",\n    \"data\": {\n        \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...\",\n        \"user\": {\n            \"id\": 2,\n            \"email\": \"merchant@example.com\",\n            \"firstName\": \"Merchant\",\n            \"lastName\": \"User\",\n            \"phone\": \"+963912345678\",\n            \"role\": \"MERCHANT\",\n            \"isVerified\": true,\n            \"countryId\": 1,\n            \"country\": {\n                \"id\": 1,\n                \"name\": {\n                    \"ar\": \"سوريا\",\n                    \"en\": \"Syria\"\n                },\n                \"code\": \"SY\",\n                \"callingCode\": \"+963\",\n                \"currencyCode\": \"SYP\",\n                \"currencySymbol\": \"£\",\n                \"currencySmallestUnit\": \"Piastre\",\n                \"currencyFactor\": 100,\n                \"isActive\": true\n            },\n            \"cityId\": 1,\n            \"city\": {\n                \"id\": 1,\n                \"name\": {\n                    \"ar\": \"دمشق\",\n                    \"en\": \"Damascus\"\n                },\n                \"countryId\": 1\n            },\n            \"address\": \"Damascus, Street 1\",\n            \"isOnline\": false,\n            \"verifiedAt\": \"2026-02-21T14:24:35.612Z\",\n            \"currentLat\": null,\n            \"currentLng\": null,\n            \"createdAt\": \"2026-02-21T14:17:13.299Z\",\n            \"updatedAt\": \"2026-02-21T22:07:21.076Z\"\n        }\n    },\n    \"timestamp\": \"2026-03-08T10:00:00.000Z\",\n    \"path\": \"/api/v1/auth/login\"\n}"
						},
						{
							"name": "Error - Invalid Credentials",
							"originalRequest": {
								"method": "POST",
								"header": [],
								"body": {
									"mode": "raw",
									"raw": "{\n    \"email\": \"wrong@example.com\",\n    \"password\": \"wrongpassword\"\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseUrl}}/auth/login",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"auth",
										"login"
									]
								}
							},
							"status": "Unauthorized",
							"code": 401,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 401,\n    \"message\": \"Invalid credentials\",\n    \"data\": null,\n    \"timestamp\": \"2026-03-08T10:00:00.000Z\",\n    \"path\": \"/api/v1/auth/login\"\n}"
						}
					]
				}
			]
		},
		{
			"name": "Offers",
			"item": [
				{
					"name": "Create Offer",
					"request": {
						"method": "POST",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							},
							{
								"key": "Content-Type",
								"value": "application/json",
								"type": "text"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\n    \"name\": \"عرض الصيف الخاص\",\n    \"description\": \"خصم كبير على المنتجات المختارة\",\n    \"discountType\": \"PERCENTAGE\",\n    \"discountValue\": 25,\n    \"startDate\": \"2026-03-01T00:00:00.000Z\",\n    \"endDate\": \"2026-03-30T23:59:59.000Z\",\n    \"isActive\": true,\n    \"productIds\": [9]\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseUrl}}/offers",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"offers"
							]
						}
					},
					"response": [
						{
							"name": "Error - Unauthorized",
							"originalRequest": {
								"method": "POST",
								"header": [],
								"body": {
									"mode": "raw",
									"raw": "{\n    \"name\": \"عرض الصيف\",\n    \"discountType\": \"PERCENTAGE\",\n    \"discountValue\": 25,\n    \"productIds\": [1]\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseUrl}}/offers",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers"
									]
								}
							},
							"status": "Unauthorized",
							"code": 401,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 401,\n    \"message\": \"Unauthorized\",\n    \"data\": null,\n    \"timestamp\": \"2026-03-08T10:00:00.000Z\",\n    \"path\": \"/api/v1/offers\"\n}"
						},
						{
							"name": "Error - Forbidden (Not Merchant/Admin)",
							"originalRequest": {
								"method": "POST",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{customer_token}}",
										"type": "text"
									}
								],
								"body": {
									"mode": "raw",
									"raw": "{\n    \"name\": \"عرض الصيف\",\n    \"discountType\": \"PERCENTAGE\",\n    \"discountValue\": 25,\n    \"productIds\": [1]\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseUrl}}/offers",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers"
									]
								}
							},
							"status": "Forbidden",
							"code": 403,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 403,\n    \"message\": \"You don't have permission to access this resource\",\n    \"data\": null,\n    \"timestamp\": \"2026-03-08T10:00:00.000Z\",\n    \"path\": \"/api/v1/offers\"\n}"
						},
						{
							"name": "Error - Products Not Owned",
							"originalRequest": {
								"method": "POST",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"body": {
									"mode": "raw",
									"raw": "{\n    \"name\": \"عرض الصيف\",\n    \"discountType\": \"PERCENTAGE\",\n    \"discountValue\": 25,\n    \"productIds\": [999]\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseUrl}}/offers",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers"
									]
								}
							},
							"status": "Forbidden",
							"code": 403,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 403,\n    \"message\": \"You do not own products with IDs [999]\",\n    \"data\": null,\n    \"timestamp\": \"2026-03-08T10:00:00.000Z\",\n    \"path\": \"/api/v1/offers\"\n}"
						},
						{
							"name": "Success",
							"originalRequest": {
								"method": "POST",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									},
									{
										"key": "Content-Type",
										"value": "application/json",
										"type": "text"
									}
								],
								"body": {
									"mode": "raw",
									"raw": "{\n    \"name\": \"عرض الصيف الخاص\",\n    \"description\": \"خصم كبير على المنتجات المختارة\",\n    \"discountType\": \"PERCENTAGE\",\n    \"discountValue\": 25,\n    \"startDate\": \"2026-03-01T00:00:00.000Z\",\n    \"endDate\": \"2026-03-30T23:59:59.000Z\",\n    \"isActive\": true,\n    \"productIds\": [9]\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseUrl}}/offers",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers"
									]
								}
							},
							"status": "Created",
							"code": 201,
							"_postman_previewlanguage": null,
							"header": [
								{
									"key": "Server",
									"value": "nginx"
								},
								{
									"key": "Date",
									"value": "Tue, 10 Mar 2026 21:36:25 GMT"
								},
								{
									"key": "Content-Type",
									"value": "application/json; charset=utf-8"
								},
								{
									"key": "Content-Length",
									"value": "3586"
								},
								{
									"key": "Connection",
									"value": "keep-alive"
								},
								{
									"key": "X-RateLimit-Limit-short",
									"value": "100"
								},
								{
									"key": "X-RateLimit-Remaining-short",
									"value": "99"
								},
								{
									"key": "X-RateLimit-Reset-short",
									"value": "60"
								},
								{
									"key": "X-RateLimit-Limit-medium",
									"value": "500"
								},
								{
									"key": "X-RateLimit-Remaining-medium",
									"value": "498"
								},
								{
									"key": "X-RateLimit-Reset-medium",
									"value": "283"
								},
								{
									"key": "X-RateLimit-Limit-long",
									"value": "2000"
								},
								{
									"key": "X-RateLimit-Remaining-long",
									"value": "1998"
								},
								{
									"key": "X-RateLimit-Reset-long",
									"value": "3283"
								},
								{
									"key": "ETag",
									"value": "W/\"e02-LNu+FtRpzJMN0fpQpvSRLWIVAm0\""
								},
								{
									"key": "X-Frame-Options",
									"value": "SAMEORIGIN"
								},
								{
									"key": "X-Content-Type-Options",
									"value": "nosniff"
								},
								{
									"key": "X-XSS-Protection",
									"value": "1; mode=block"
								},
								{
									"key": "Referrer-Policy",
									"value": "strict-origin-when-cross-origin"
								},
								{
									"key": "Permissions-Policy",
									"value": "geolocation=(), microphone=(), camera=()"
								}
							],
							"cookie": [],
							"body": "{\n    \"statusCode\": 201,\n    \"message\": \"Operation successful\",\n    \"data\": {\n        \"id\": 2,\n        \"name\": \"عرض الصيف الخاص\",\n        \"description\": \"خصم كبير على المنتجات المختارة\",\n        \"discountType\": \"PERCENTAGE\",\n        \"discountValue\": 25,\n        \"startDate\": \"2026-03-01T00:00:00.000Z\",\n        \"endDate\": \"2026-03-30T23:59:59.000Z\",\n        \"isActive\": true,\n        \"merchantId\": 27,\n        \"merchant\": {\n            \"currentLat\": null,\n            \"currentLng\": null,\n            \"id\": 27,\n            \"firstName\": \"Updated Name\",\n            \"lastName\": \"Doe\",\n            \"email\": \"merchant4@example.com\",\n            \"phone\": \"+9639123455\",\n            \"role\": \"MERCHANT\",\n            \"notificationChannel\": \"WHATSAPP\",\n            \"countryId\": 1,\n            \"cityId\": 1,\n            \"address\": \"Damascus, Merchant Street 123\",\n            \"isOnline\": true,\n            \"verifiedAt\": \"2026-03-10T10:39:17.846Z\",\n            \"location\": {\n                \"lat\": 33.5138,\n                \"lng\": 36.2765\n            },\n            \"birthday\": \"1990-05-15\",\n            \"createdAt\": \"2026-03-10T10:39:17.846Z\",\n            \"updatedAt\": \"2026-03-10T13:55:59.554Z\",\n            \"deletedAt\": null,\n            \"officeOwnerId\": null,\n            \"imageId\": 27\n        },\n        \"products\": [\n            {\n                \"id\": 9,\n                \"merchantId\": 27,\n                \"categoryId\": 2,\n                \"name\": \"Delicious Burger\",\n                \"shortDescription\": \"Beef burger\",\n                \"description\": \"Juicy beef burger with cheese\",\n                \"price\": 1299,\n                \"discount\": 10,\n                \"discountType\": \"PERCENTAGE\",\n                \"isAvailable\": true,\n                \"hasStock\": true,\n                \"stockQuantity\": 50,\n                \"isExternal\": false,\n                \"externalProvider\": null,\n                \"externalId\": null,\n                \"externalMetadata\": null,\n                \"commissionRate\": 2,\n                \"commissionConfirmed\": true,\n                \"images\": [\n                    {\n                        \"id\": 29,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_thumb.webp\",\n                        \"isMain\": true,\n                        \"displayOrder\": 0,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 30,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 1,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 31,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 2,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 32,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 3,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 33,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 4,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    }\n                ],\n                \"createdAt\": \"2026-03-10T13:42:22.193Z\",\n                \"updatedAt\": \"2026-03-10T13:52:45.057Z\",\n                \"priceAfterDiscount\": 1170,\n                \"offerPrice\": 975\n            }\n        ],\n        \"createdAt\": \"2026-03-10T21:36:25.760Z\",\n        \"updatedAt\": \"2026-03-10T21:36:25.760Z\"\n    },\n    \"timestamp\": \"2026-03-10T21:36:25.768Z\",\n    \"path\": \"/api/v1/offers\"\n}"
						}
					]
				},
				{
					"name": "Get All Offers",
					"request": {
						"method": "GET",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"url": {
							"raw": "{{baseUrl}}/offers?page=1&limit=10",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"offers"
							],
							"query": [
								{
									"key": "page",
									"value": "1"
								},
								{
									"key": "limit",
									"value": "10"
								}
							]
						}
					},
					"response": [
						{
							"name": "Success (Customer - Active Only)",
							"originalRequest": {
								"method": "GET",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{customer_token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "{{baseUrl}}/offers",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers"
									]
								}
							},
							"status": "OK",
							"code": 200,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 200,\n    \"message\": \"Operation successful\",\n    \"data\": [\n        {\n            \"id\": 1,\n            \"name\": \"عرض الصيف الخاص\",\n            \"description\": \"خصم كبير على المنتجات المختارة\",\n            \"discountType\": \"PERCENTAGE\",\n            \"discountValue\": 25,\n            \"startDate\": \"2026-06-01T00:00:00.000Z\",\n            \"endDate\": \"2026-06-30T23:59:59.000Z\",\n            \"isActive\": true,\n            \"merchantId\": 2,\n            \"createdAt\": \"2026-03-08T10:00:00.000Z\",\n            \"updatedAt\": \"2026-03-08T10:00:00.000Z\",\n            \"products\": [\n                {\n                    \"id\": 1,\n                    \"name\": \"وجبة برغر\",\n                    \"price\": 5000,\n                    \"offerPrice\": 3750\n                }\n            ],\n            \"merchant\": {\n                \"id\": 2,\n                \"restaurantName\": \"مطعم البرغر اللذيذ\"\n            }\n        }\n    ],\n    \"pagination\": {\n        \"total\": 1,\n        \"page\": 1,\n        \"limit\": 10,\n        \"totalPages\": 1,\n        \"hasNextPage\": false,\n        \"hasPreviousPage\": false\n    },\n    \"timestamp\": \"2026-03-08T10:00:00.000Z\",\n    \"path\": \"/api/v1/offers\"\n}"
						},
						{
							"name": "Success",
							"originalRequest": {
								"method": "GET",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "{{baseUrl}}/offers?page=1&limit=10&isActive=true&search=صيف&merchantId=27",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers"
									],
									"query": [
										{
											"key": "page",
											"value": "1"
										},
										{
											"key": "limit",
											"value": "10"
										},
										{
											"key": "isActive",
											"value": "true"
										},
										{
											"key": "search",
											"value": "صيف"
										},
										{
											"key": "merchantId",
											"value": "27"
										}
									]
								}
							},
							"status": "OK",
							"code": 200,
							"_postman_previewlanguage": null,
							"header": [
								{
									"key": "Server",
									"value": "nginx"
								},
								{
									"key": "Date",
									"value": "Tue, 10 Mar 2026 21:33:41 GMT"
								},
								{
									"key": "Content-Type",
									"value": "application/json; charset=utf-8"
								},
								{
									"key": "Content-Length",
									"value": "3762"
								},
								{
									"key": "Connection",
									"value": "keep-alive"
								},
								{
									"key": "X-RateLimit-Limit-short",
									"value": "100"
								},
								{
									"key": "X-RateLimit-Remaining-short",
									"value": "98"
								},
								{
									"key": "X-RateLimit-Reset-short",
									"value": "60"
								},
								{
									"key": "X-RateLimit-Limit-medium",
									"value": "500"
								},
								{
									"key": "X-RateLimit-Remaining-medium",
									"value": "493"
								},
								{
									"key": "X-RateLimit-Reset-medium",
									"value": "463"
								},
								{
									"key": "X-RateLimit-Limit-long",
									"value": "2000"
								},
								{
									"key": "X-RateLimit-Remaining-long",
									"value": "1993"
								},
								{
									"key": "X-RateLimit-Reset-long",
									"value": "3463"
								},
								{
									"key": "ETag",
									"value": "W/\"eb2-B88kdKFbxq0YDFmFcdypE5/8UiM\""
								},
								{
									"key": "X-Frame-Options",
									"value": "SAMEORIGIN"
								},
								{
									"key": "X-Content-Type-Options",
									"value": "nosniff"
								},
								{
									"key": "X-XSS-Protection",
									"value": "1; mode=block"
								},
								{
									"key": "Referrer-Policy",
									"value": "strict-origin-when-cross-origin"
								},
								{
									"key": "Permissions-Policy",
									"value": "geolocation=(), microphone=(), camera=()"
								}
							],
							"cookie": [],
							"body": "{\n    \"statusCode\": 200,\n    \"message\": \"Operation successful\",\n    \"data\": [\n        {\n            \"id\": 1,\n            \"name\": \"عرض الصيف الخاص\",\n            \"description\": \"خصم كبير على المنتجات المختارة\",\n            \"discountType\": \"PERCENTAGE\",\n            \"discountValue\": 25,\n            \"startDate\": \"2026-03-01T00:00:00.000Z\",\n            \"endDate\": \"2026-03-30T23:59:59.000Z\",\n            \"isActive\": true,\n            \"merchantId\": 27,\n            \"merchant\": {\n                \"currentLat\": null,\n                \"currentLng\": null,\n                \"id\": 27,\n                \"firstName\": \"Updated Name\",\n                \"lastName\": \"Doe\",\n                \"email\": \"merchant4@example.com\",\n                \"phone\": \"+9639123455\",\n                \"role\": \"MERCHANT\",\n                \"notificationChannel\": \"WHATSAPP\",\n                \"countryId\": 1,\n                \"cityId\": 1,\n                \"address\": \"Damascus, Merchant Street 123\",\n                \"isOnline\": true,\n                \"verifiedAt\": \"2026-03-10T10:39:17.846Z\",\n                \"location\": {\n                    \"lat\": 33.5138,\n                    \"lng\": 36.2765\n                },\n                \"birthday\": \"1990-05-15\",\n                \"createdAt\": \"2026-03-10T10:39:17.846Z\",\n                \"updatedAt\": \"2026-03-10T13:55:59.554Z\",\n                \"deletedAt\": null,\n                \"officeOwnerId\": null,\n                \"imageId\": 27\n            },\n            \"products\": [\n                {\n                    \"id\": 9,\n                    \"merchantId\": 27,\n                    \"categoryId\": 2,\n                    \"name\": \"Delicious Burger\",\n                    \"shortDescription\": \"Beef burger\",\n                    \"description\": \"Juicy beef burger with cheese\",\n                    \"price\": 1299,\n                    \"discount\": 10,\n                    \"discountType\": \"PERCENTAGE\",\n                    \"isAvailable\": true,\n                    \"hasStock\": true,\n                    \"stockQuantity\": 50,\n                    \"isExternal\": false,\n                    \"externalProvider\": null,\n                    \"externalId\": null,\n                    \"externalMetadata\": null,\n                    \"commissionRate\": 2,\n                    \"commissionConfirmed\": true,\n                    \"images\": [\n                        {\n                            \"id\": 29,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_thumb.webp\",\n                            \"isMain\": true,\n                            \"displayOrder\": 0,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        },\n                        {\n                            \"id\": 30,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_thumb.webp\",\n                            \"isMain\": false,\n                            \"displayOrder\": 1,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        },\n                        {\n                            \"id\": 31,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_thumb.webp\",\n                            \"isMain\": false,\n                            \"displayOrder\": 2,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        },\n                        {\n                            \"id\": 32,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_thumb.webp\",\n                            \"isMain\": false,\n                            \"displayOrder\": 3,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        },\n                        {\n                            \"id\": 33,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_thumb.webp\",\n                            \"isMain\": false,\n                            \"displayOrder\": 4,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        }\n                    ],\n                    \"createdAt\": \"2026-03-10T13:42:22.193Z\",\n                    \"updatedAt\": \"2026-03-10T13:52:45.057Z\",\n                    \"priceAfterDiscount\": 1170,\n                    \"offerPrice\": 975\n                }\n            ],\n            \"createdAt\": \"2026-03-10T21:31:08.400Z\",\n            \"updatedAt\": \"2026-03-10T21:31:08.400Z\"\n        }\n    ],\n    \"pagination\": {\n        \"total\": 1,\n        \"page\": 1,\n        \"limit\": 10,\n        \"totalPages\": 1,\n        \"hasNextPage\": false,\n        \"hasPreviousPage\": false\n    },\n    \"timestamp\": \"2026-03-10T21:33:41.647Z\",\n    \"path\": \"/api/v1/offers?page=1&limit=10&isActive=true&search=%D8%B5%D9%8A%D9%81&merchantId=27\"\n}"
						},
						{
							"name": "Success Without Filters",
							"originalRequest": {
								"method": "GET",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "{{baseUrl}}/offers?page=1&limit=10",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers"
									],
									"query": [
										{
											"key": "page",
											"value": "1"
										},
										{
											"key": "limit",
											"value": "10"
										}
									]
								}
							},
							"status": "OK",
							"code": 200,
							"_postman_previewlanguage": null,
							"header": [
								{
									"key": "Server",
									"value": "nginx"
								},
								{
									"key": "Date",
									"value": "Tue, 10 Mar 2026 21:34:26 GMT"
								},
								{
									"key": "Content-Type",
									"value": "application/json; charset=utf-8"
								},
								{
									"key": "Content-Length",
									"value": "3708"
								},
								{
									"key": "Connection",
									"value": "keep-alive"
								},
								{
									"key": "X-RateLimit-Limit-short",
									"value": "100"
								},
								{
									"key": "X-RateLimit-Remaining-short",
									"value": "95"
								},
								{
									"key": "X-RateLimit-Reset-short",
									"value": "15"
								},
								{
									"key": "X-RateLimit-Limit-medium",
									"value": "500"
								},
								{
									"key": "X-RateLimit-Remaining-medium",
									"value": "490"
								},
								{
									"key": "X-RateLimit-Reset-medium",
									"value": "418"
								},
								{
									"key": "X-RateLimit-Limit-long",
									"value": "2000"
								},
								{
									"key": "X-RateLimit-Remaining-long",
									"value": "1990"
								},
								{
									"key": "X-RateLimit-Reset-long",
									"value": "3418"
								},
								{
									"key": "ETag",
									"value": "W/\"e7c-pF8khngHMmyySmeE5QJUB60F/58\""
								},
								{
									"key": "X-Frame-Options",
									"value": "SAMEORIGIN"
								},
								{
									"key": "X-Content-Type-Options",
									"value": "nosniff"
								},
								{
									"key": "X-XSS-Protection",
									"value": "1; mode=block"
								},
								{
									"key": "Referrer-Policy",
									"value": "strict-origin-when-cross-origin"
								},
								{
									"key": "Permissions-Policy",
									"value": "geolocation=(), microphone=(), camera=()"
								}
							],
							"cookie": [],
							"body": "{\n    \"statusCode\": 200,\n    \"message\": \"Operation successful\",\n    \"data\": [\n        {\n            \"id\": 1,\n            \"name\": \"عرض الصيف الخاص\",\n            \"description\": \"خصم كبير على المنتجات المختارة\",\n            \"discountType\": \"PERCENTAGE\",\n            \"discountValue\": 25,\n            \"startDate\": \"2026-03-01T00:00:00.000Z\",\n            \"endDate\": \"2026-03-30T23:59:59.000Z\",\n            \"isActive\": true,\n            \"merchantId\": 27,\n            \"merchant\": {\n                \"currentLat\": null,\n                \"currentLng\": null,\n                \"id\": 27,\n                \"firstName\": \"Updated Name\",\n                \"lastName\": \"Doe\",\n                \"email\": \"merchant4@example.com\",\n                \"phone\": \"+9639123455\",\n                \"role\": \"MERCHANT\",\n                \"notificationChannel\": \"WHATSAPP\",\n                \"countryId\": 1,\n                \"cityId\": 1,\n                \"address\": \"Damascus, Merchant Street 123\",\n                \"isOnline\": true,\n                \"verifiedAt\": \"2026-03-10T10:39:17.846Z\",\n                \"location\": {\n                    \"lat\": 33.5138,\n                    \"lng\": 36.2765\n                },\n                \"birthday\": \"1990-05-15\",\n                \"createdAt\": \"2026-03-10T10:39:17.846Z\",\n                \"updatedAt\": \"2026-03-10T13:55:59.554Z\",\n                \"deletedAt\": null,\n                \"officeOwnerId\": null,\n                \"imageId\": 27\n            },\n            \"products\": [\n                {\n                    \"id\": 9,\n                    \"merchantId\": 27,\n                    \"categoryId\": 2,\n                    \"name\": \"Delicious Burger\",\n                    \"shortDescription\": \"Beef burger\",\n                    \"description\": \"Juicy beef burger with cheese\",\n                    \"price\": 1299,\n                    \"discount\": 10,\n                    \"discountType\": \"PERCENTAGE\",\n                    \"isAvailable\": true,\n                    \"hasStock\": true,\n                    \"stockQuantity\": 50,\n                    \"isExternal\": false,\n                    \"externalProvider\": null,\n                    \"externalId\": null,\n                    \"externalMetadata\": null,\n                    \"commissionRate\": 2,\n                    \"commissionConfirmed\": true,\n                    \"images\": [\n                        {\n                            \"id\": 29,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_thumb.webp\",\n                            \"isMain\": true,\n                            \"displayOrder\": 0,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        },\n                        {\n                            \"id\": 30,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_thumb.webp\",\n                            \"isMain\": false,\n                            \"displayOrder\": 1,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        },\n                        {\n                            \"id\": 31,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_thumb.webp\",\n                            \"isMain\": false,\n                            \"displayOrder\": 2,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        },\n                        {\n                            \"id\": 32,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_thumb.webp\",\n                            \"isMain\": false,\n                            \"displayOrder\": 3,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        },\n                        {\n                            \"id\": 33,\n                            \"entityType\": \"PRODUCT\",\n                            \"entityId\": 9,\n                            \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2.webp\",\n                            \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_mobile.webp\",\n                            \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_thumb.webp\",\n                            \"isMain\": false,\n                            \"displayOrder\": 4,\n                            \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                            \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                        }\n                    ],\n                    \"createdAt\": \"2026-03-10T13:42:22.193Z\",\n                    \"updatedAt\": \"2026-03-10T13:52:45.057Z\",\n                    \"priceAfterDiscount\": 1170,\n                    \"offerPrice\": 975\n                }\n            ],\n            \"createdAt\": \"2026-03-10T21:31:08.400Z\",\n            \"updatedAt\": \"2026-03-10T21:31:08.400Z\"\n        }\n    ],\n    \"pagination\": {\n        \"total\": 1,\n        \"page\": 1,\n        \"limit\": 10,\n        \"totalPages\": 1,\n        \"hasNextPage\": false,\n        \"hasPreviousPage\": false\n    },\n    \"timestamp\": \"2026-03-10T21:34:26.863Z\",\n    \"path\": \"/api/v1/offers?page=1&limit=10\"\n}"
						}
					]
				},
				{
					"name": "Get Offer by ID",
					"request": {
						"method": "GET",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"url": {
							"raw": "{{baseUrl}}/offers/1",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"offers",
								"1"
							]
						}
					},
					"response": [
						{
							"name": "Error - Not Found",
							"originalRequest": {
								"method": "GET",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "{{baseUrl}}/offers/999",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers",
										"999"
									]
								}
							},
							"status": "Not Found",
							"code": 404,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 404,\n    \"message\": \"Offer with ID 999 not found\",\n    \"data\": null,\n    \"timestamp\": \"2026-03-08T10:00:00.000Z\",\n    \"path\": \"/api/v1/offers/999\"\n}"
						},
						{
							"name": "Success",
							"originalRequest": {
								"method": "GET",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "{{baseUrl}}/offers/1",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers",
										"1"
									]
								}
							},
							"status": "OK",
							"code": 200,
							"_postman_previewlanguage": null,
							"header": [
								{
									"key": "Server",
									"value": "nginx"
								},
								{
									"key": "Date",
									"value": "Tue, 10 Mar 2026 21:34:57 GMT"
								},
								{
									"key": "Content-Type",
									"value": "application/json; charset=utf-8"
								},
								{
									"key": "Content-Length",
									"value": "3588"
								},
								{
									"key": "Connection",
									"value": "keep-alive"
								},
								{
									"key": "X-RateLimit-Limit-short",
									"value": "100"
								},
								{
									"key": "X-RateLimit-Remaining-short",
									"value": "99"
								},
								{
									"key": "X-RateLimit-Reset-short",
									"value": "60"
								},
								{
									"key": "X-RateLimit-Limit-medium",
									"value": "500"
								},
								{
									"key": "X-RateLimit-Remaining-medium",
									"value": "499"
								},
								{
									"key": "X-RateLimit-Reset-medium",
									"value": "600"
								},
								{
									"key": "X-RateLimit-Limit-long",
									"value": "2000"
								},
								{
									"key": "X-RateLimit-Remaining-long",
									"value": "1999"
								},
								{
									"key": "X-RateLimit-Reset-long",
									"value": "3600"
								},
								{
									"key": "ETag",
									"value": "W/\"e04-1eEHdg1jlcPeuF3GjlzHYqwXM7A\""
								},
								{
									"key": "X-Frame-Options",
									"value": "SAMEORIGIN"
								},
								{
									"key": "X-Content-Type-Options",
									"value": "nosniff"
								},
								{
									"key": "X-XSS-Protection",
									"value": "1; mode=block"
								},
								{
									"key": "Referrer-Policy",
									"value": "strict-origin-when-cross-origin"
								},
								{
									"key": "Permissions-Policy",
									"value": "geolocation=(), microphone=(), camera=()"
								}
							],
							"cookie": [],
							"body": "{\n    \"statusCode\": 200,\n    \"message\": \"Operation successful\",\n    \"data\": {\n        \"id\": 1,\n        \"name\": \"عرض الصيف الخاص\",\n        \"description\": \"خصم كبير على المنتجات المختارة\",\n        \"discountType\": \"PERCENTAGE\",\n        \"discountValue\": 25,\n        \"startDate\": \"2026-03-01T00:00:00.000Z\",\n        \"endDate\": \"2026-03-30T23:59:59.000Z\",\n        \"isActive\": true,\n        \"merchantId\": 27,\n        \"merchant\": {\n            \"currentLat\": null,\n            \"currentLng\": null,\n            \"id\": 27,\n            \"firstName\": \"Updated Name\",\n            \"lastName\": \"Doe\",\n            \"email\": \"merchant4@example.com\",\n            \"phone\": \"+9639123455\",\n            \"role\": \"MERCHANT\",\n            \"notificationChannel\": \"WHATSAPP\",\n            \"countryId\": 1,\n            \"cityId\": 1,\n            \"address\": \"Damascus, Merchant Street 123\",\n            \"isOnline\": true,\n            \"verifiedAt\": \"2026-03-10T10:39:17.846Z\",\n            \"location\": {\n                \"lat\": 33.5138,\n                \"lng\": 36.2765\n            },\n            \"birthday\": \"1990-05-15\",\n            \"createdAt\": \"2026-03-10T10:39:17.846Z\",\n            \"updatedAt\": \"2026-03-10T13:55:59.554Z\",\n            \"deletedAt\": null,\n            \"officeOwnerId\": null,\n            \"imageId\": 27\n        },\n        \"products\": [\n            {\n                \"id\": 9,\n                \"merchantId\": 27,\n                \"categoryId\": 2,\n                \"name\": \"Delicious Burger\",\n                \"shortDescription\": \"Beef burger\",\n                \"description\": \"Juicy beef burger with cheese\",\n                \"price\": 1299,\n                \"discount\": 10,\n                \"discountType\": \"PERCENTAGE\",\n                \"isAvailable\": true,\n                \"hasStock\": true,\n                \"stockQuantity\": 50,\n                \"isExternal\": false,\n                \"externalProvider\": null,\n                \"externalId\": null,\n                \"externalMetadata\": null,\n                \"commissionRate\": 2,\n                \"commissionConfirmed\": true,\n                \"images\": [\n                    {\n                        \"id\": 29,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_thumb.webp\",\n                        \"isMain\": true,\n                        \"displayOrder\": 0,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 30,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 1,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 31,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 2,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 32,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 3,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 33,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 4,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    }\n                ],\n                \"createdAt\": \"2026-03-10T13:42:22.193Z\",\n                \"updatedAt\": \"2026-03-10T13:52:45.057Z\",\n                \"priceAfterDiscount\": 1170,\n                \"offerPrice\": 975\n            }\n        ],\n        \"createdAt\": \"2026-03-10T21:31:08.400Z\",\n        \"updatedAt\": \"2026-03-10T21:31:08.400Z\"\n    },\n    \"timestamp\": \"2026-03-10T21:34:57.015Z\",\n    \"path\": \"/api/v1/offers/1\"\n}"
						}
					]
				},
				{
					"name": "Update Offer",
					"request": {
						"method": "PATCH",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							},
							{
								"key": "Content-Type",
								"value": "application/json",
								"type": "text"
							}
						],
						"body": {
							"mode": "raw",
							"raw": "{\n    \"isActive\": false,\n    \"discountValue\": 30,\n    \"discountType\": \"FIXED\"\n}",
							"options": {
								"raw": {
									"language": "json"
								}
							}
						},
						"url": {
							"raw": "{{baseUrl}}/offers/1",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"offers",
								"1"
							]
						}
					},
					"response": [
						{
							"name": "Error - Forbidden (Not Owner)",
							"originalRequest": {
								"method": "PATCH",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{other_merchant_token}}",
										"type": "text"
									}
								],
								"body": {
									"mode": "raw",
									"raw": "{\n    \"isActive\": false\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseUrl}}/offers/1",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers",
										"1"
									]
								}
							},
							"status": "Forbidden",
							"code": 403,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 403,\n    \"message\": \"You do not own this offer\",\n    \"data\": null,\n    \"timestamp\": \"2026-03-08T10:00:00.000Z\",\n    \"path\": \"/api/v1/offers/1\"\n}"
						},
						{
							"name": "Successed",
							"originalRequest": {
								"method": "PATCH",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									},
									{
										"key": "Content-Type",
										"value": "application/json",
										"type": "text"
									}
								],
								"body": {
									"mode": "raw",
									"raw": "{\n    \"isActive\": false,\n    \"discountValue\": 30,\n    \"discountType\": \"FIXED\"\n}",
									"options": {
										"raw": {
											"language": "json"
										}
									}
								},
								"url": {
									"raw": "{{baseUrl}}/offers/1",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers",
										"1"
									]
								}
							},
							"status": "OK",
							"code": 200,
							"_postman_previewlanguage": null,
							"header": [
								{
									"key": "Server",
									"value": "nginx"
								},
								{
									"key": "Date",
									"value": "Tue, 10 Mar 2026 21:35:26 GMT"
								},
								{
									"key": "Content-Type",
									"value": "application/json; charset=utf-8"
								},
								{
									"key": "Content-Length",
									"value": "3585"
								},
								{
									"key": "Connection",
									"value": "keep-alive"
								},
								{
									"key": "X-RateLimit-Limit-short",
									"value": "100"
								},
								{
									"key": "X-RateLimit-Remaining-short",
									"value": "99"
								},
								{
									"key": "X-RateLimit-Reset-short",
									"value": "60"
								},
								{
									"key": "X-RateLimit-Limit-medium",
									"value": "500"
								},
								{
									"key": "X-RateLimit-Remaining-medium",
									"value": "499"
								},
								{
									"key": "X-RateLimit-Reset-medium",
									"value": "600"
								},
								{
									"key": "X-RateLimit-Limit-long",
									"value": "2000"
								},
								{
									"key": "X-RateLimit-Remaining-long",
									"value": "1999"
								},
								{
									"key": "X-RateLimit-Reset-long",
									"value": "3600"
								},
								{
									"key": "ETag",
									"value": "W/\"e01-urE/yh94pH1j4nIzv74pM72U8EM\""
								},
								{
									"key": "X-Frame-Options",
									"value": "SAMEORIGIN"
								},
								{
									"key": "X-Content-Type-Options",
									"value": "nosniff"
								},
								{
									"key": "X-XSS-Protection",
									"value": "1; mode=block"
								},
								{
									"key": "Referrer-Policy",
									"value": "strict-origin-when-cross-origin"
								},
								{
									"key": "Permissions-Policy",
									"value": "geolocation=(), microphone=(), camera=()"
								}
							],
							"cookie": [],
							"body": "{\n    \"statusCode\": 200,\n    \"message\": \"Operation successful\",\n    \"data\": {\n        \"id\": 1,\n        \"name\": \"عرض الصيف الخاص\",\n        \"description\": \"خصم كبير على المنتجات المختارة\",\n        \"discountType\": \"FIXED\",\n        \"discountValue\": 30,\n        \"startDate\": \"2026-03-01T00:00:00.000Z\",\n        \"endDate\": \"2026-03-30T23:59:59.000Z\",\n        \"isActive\": false,\n        \"merchantId\": 27,\n        \"merchant\": {\n            \"currentLat\": null,\n            \"currentLng\": null,\n            \"id\": 27,\n            \"firstName\": \"Updated Name\",\n            \"lastName\": \"Doe\",\n            \"email\": \"merchant4@example.com\",\n            \"phone\": \"+9639123455\",\n            \"role\": \"MERCHANT\",\n            \"notificationChannel\": \"WHATSAPP\",\n            \"countryId\": 1,\n            \"cityId\": 1,\n            \"address\": \"Damascus, Merchant Street 123\",\n            \"isOnline\": true,\n            \"verifiedAt\": \"2026-03-10T10:39:17.846Z\",\n            \"location\": {\n                \"lat\": 33.5138,\n                \"lng\": 36.2765\n            },\n            \"birthday\": \"1990-05-15\",\n            \"createdAt\": \"2026-03-10T10:39:17.846Z\",\n            \"updatedAt\": \"2026-03-10T13:55:59.554Z\",\n            \"deletedAt\": null,\n            \"officeOwnerId\": null,\n            \"imageId\": 27\n        },\n        \"products\": [\n            {\n                \"id\": 9,\n                \"merchantId\": 27,\n                \"categoryId\": 2,\n                \"name\": \"Delicious Burger\",\n                \"shortDescription\": \"Beef burger\",\n                \"description\": \"Juicy beef burger with cheese\",\n                \"price\": 1299,\n                \"discount\": 10,\n                \"discountType\": \"PERCENTAGE\",\n                \"isAvailable\": true,\n                \"hasStock\": true,\n                \"stockQuantity\": 50,\n                \"isExternal\": false,\n                \"externalProvider\": null,\n                \"externalId\": null,\n                \"externalMetadata\": null,\n                \"commissionRate\": 2,\n                \"commissionConfirmed\": true,\n                \"images\": [\n                    {\n                        \"id\": 29,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142197_images2_thumb.webp\",\n                        \"isMain\": true,\n                        \"displayOrder\": 0,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 30,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142477_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 1,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 31,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142717_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 2,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 32,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150142936_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 3,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    },\n                    {\n                        \"id\": 33,\n                        \"entityType\": \"PRODUCT\",\n                        \"entityId\": 9,\n                        \"url\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2.webp\",\n                        \"mobileUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_mobile.webp\",\n                        \"thumbnailUrl\": \"https://api.jeeb2.com/uploads/products/9/1773150143148_images2_thumb.webp\",\n                        \"isMain\": false,\n                        \"displayOrder\": 4,\n                        \"createdAt\": \"2026-03-10T13:42:23.366Z\",\n                        \"updatedAt\": \"2026-03-10T13:42:23.366Z\"\n                    }\n                ],\n                \"createdAt\": \"2026-03-10T13:42:22.193Z\",\n                \"updatedAt\": \"2026-03-10T13:52:45.057Z\",\n                \"priceAfterDiscount\": 1170,\n                \"offerPrice\": 1269\n            }\n        ],\n        \"createdAt\": \"2026-03-10T21:31:08.400Z\",\n        \"updatedAt\": \"2026-03-10T21:35:26.939Z\"\n    },\n    \"timestamp\": \"2026-03-10T21:35:26.949Z\",\n    \"path\": \"/api/v1/offers/1\"\n}"
						}
					]
				},
				{
					"name": "Delete Offer",
					"request": {
						"method": "DELETE",
						"header": [
							{
								"key": "Authorization",
								"value": "Bearer {{token}}",
								"type": "text"
							}
						],
						"url": {
							"raw": "{{baseUrl}}/offers/1",
							"host": [
								"{{baseUrl}}"
							],
							"path": [
								"offers",
								"1"
							]
						}
					},
					"response": [
						{
							"name": "Success",
							"originalRequest": {
								"method": "DELETE",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "{{baseUrl}}/offers/1",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers",
										"1"
									]
								}
							},
							"status": "OK",
							"code": 200,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 200,\n    \"message\": \"Operation successful\",\n    \"data\": {},\n    \"timestamp\": \"2026-03-08T12:00:00.000Z\",\n    \"path\": \"/api/v1/offers/1\"\n}"
						},
						{
							"name": "Error - Not Found (Already Deleted)",
							"originalRequest": {
								"method": "DELETE",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "{{baseUrl}}/offers/1",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers",
										"1"
									]
								}
							},
							"status": "Not Found",
							"code": 404,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 404,\n    \"message\": \"Offer with ID 1 not found\",\n    \"data\": null,\n    \"timestamp\": \"2026-03-08T12:00:00.000Z\",\n    \"path\": \"/api/v1/offers/1\"\n}"
						},
						{
							"name": "Error - Forbidden (Not Owner)",
							"originalRequest": {
								"method": "DELETE",
								"header": [
									{
										"key": "Authorization",
										"value": "Bearer {{other_merchant_token}}",
										"type": "text"
									}
								],
								"url": {
									"raw": "{{baseUrl}}/offers/2",
									"host": [
										"{{baseUrl}}"
									],
									"path": [
										"offers",
										"2"
									]
								}
							},
							"status": "Forbidden",
							"code": 403,
							"_postman_previewlanguage": "json",
							"header": [],
							"cookie": [],
							"body": "{\n    \"statusCode\": 403,\n    \"message\": \"You do not own this offer\",\n    \"data\": null,\n    \"timestamp\": \"2026-03-08T12:00:00.000Z\",\n    \"path\": \"/api/v1/offers/2\"\n}"
						}
					]
				}
			]
		}
	],
	"variable": [
		{
			"key": "baseUrl",
			"value": "http://localhost:3000/api/v1",
			"type": "string"
		},
		{
			"key": "token",
			"value": "",
			"type": "string"
		}
	]
}