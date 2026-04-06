import 'package:easy_localization/easy_localization.dart';

/// Centralized translation class
/// Usage: AppTranslation.onboardingTitle instead of 'onboarding_title_1'.tr()
class AppTranslation {
  AppTranslation._();

  // App Info
  static String get appName => 'app_name'.tr();
  static String get craftedBy => 'crafted_by'.tr();
  static String get countryEgypt => 'country_egypt'.tr();

  // Common
  static String get welcome => 'welcome'.tr();
  static String get skip => 'skip'.tr();
  static String get next => 'next'.tr();
  static String get done => 'done'.tr();
  static String get getStarted => 'get_started'.tr();
  static String get home => 'home'.tr();
  static String get settings => 'settings'.tr();
  static String get profile => 'profile'.tr();
  static String get logout => 'logout'.tr();

  // Splash
  static String get splashTitle => 'splash_title'.tr();
  static String get splashTagline => 'splash_tagline'.tr();

  // Onboarding
  static String get onboardingTitle1 => 'onboarding_title_1'.tr();
  static String get onboardingDesc1 => 'onboarding_desc_1'.tr();
  static String get onboardingTitle2 => 'onboarding_title_2'.tr();
  static String get onboardingDesc2 => 'onboarding_desc_2'.tr();
  static String get onboardingTitle3 => 'onboarding_title_3'.tr();
  static String get onboardingDesc3 => 'onboarding_desc_3'.tr();
  static String get onboardingTitle4 => 'onboarding_title_4'.tr();
  static String get onboardingDesc4 => 'onboarding_desc_4'.tr();
  static String get termsAndConditions => 'terms_and_conditions'.tr();
  static String get allowNotifications => 'allow_notifications'.tr();
  static String get notificationsEnabledSuccess => 'notifications_enabled_success'.tr();

  // Home
  static String get homeTitle => 'home_title'.tr();
  static String get homeSubtitle => 'home_subtitle'.tr();
  static String get homeCtaTitle => 'home_cta_title'.tr();
  static String get homeCtaSubtitle => 'home_cta_subtitle'.tr();
  static String get startBuilding => 'start_building'.tr();
  static String get madeWithLove => 'made_with_love'.tr();
  static String get createdBy => 'created_by'.tr();

  // Category
  static String get categories => 'categories'.tr();
  static String get addCategory => 'add_category'.tr();
  static String get categoryName => 'category_name'.tr();
  static String get pleaseEnterCategoryName => 'please_enter_category_name'.tr();
  static String get categoryAddedSuccessfully => 'category_added_successfully'.tr();
  static String get editCategory => 'edit_category'.tr();
  static String get categoryUpdatedSuccessfully => 'category_updated_successfully'.tr();
  static String get categoryDeletedSuccessfully => 'category_deleted_successfully'.tr();
  static String get areYouSureDeleteCategory => 'are_you_sure_delete_category'.tr();

  // Product
  static String get products => 'products'.tr();
  static String get addProduct => 'add_product'.tr();
  static String get editProduct => 'edit_product'.tr();
  static String get productName => 'product_name'.tr();
  static String get productDescription => 'product_description'.tr();
  static String get productPrice => 'product_price'.tr();
  static String get productQuantity => 'product_quantity'.tr();
  static String get productServesCount => 'product_serves_count'.tr();
  static String get productServesCountHint => 'product_serves_count_hint'.tr();
  static String get selectCategory => 'select_category'.tr();
  static String get productImages => 'product_images'.tr();
  static String get addImage => 'add_image'.tr();
  static String get removeImage => 'remove_image'.tr();
  static String get noImagesAdded => 'no_images_added'.tr();
  static String get enterImageUrl => 'enter_image_url'.tr();
  static String get add => 'add'.tr();
  static String get pleaseEnterProductName => 'please_enter_product_name'.tr();
  static String get pleaseEnterProductPrice => 'please_enter_product_price'.tr();
  static String get invalidProductPrice => 'invalid_product_price'.tr();
  static String get pleaseSelectCategory => 'please_select_category'.tr();
  static String get pleaseAddAtLeastOneImage => 'please_add_at_least_one_image'.tr();
  static String get productCreatedSuccessfully => 'product_created_successfully'.tr();
  static String get productUpdatedSuccessfully => 'product_updated_successfully'.tr();
  static String get productDeletedSuccessfully => 'product_deleted_successfully'.tr();
  static String get deleteProduct => 'delete_product'.tr();
  static String get areYouSureDeleteProduct => 'are_you_sure_delete_product'.tr();
  static String get areYouSureWantToDeleteThisProduct => 'are_you_sure_want_to_delete_this_product'.tr();
  static String get productConfirmedSuccessfully => 'product_confirmed_successfully'.tr();
  static String get confirmProduct => 'confirm_product'.tr();
  static String get options => 'options'.tr();
  static String get newPrice => 'new_price'.tr();
  static String get enterNewPrice => 'enter_new_price'.tr();
  static String get productConfirming => 'product_confirming'.tr();
  static String get delete => 'delete'.tr();
  static String get edit => 'edit'.tr();
  static String get merchantDeletedSuccessfully => 'merchant_deleted_successfully'.tr();
  static String get merchantUpdatedSuccessfully => 'merchant_updated_successfully'.tr();
  static String get merchantIsActiveLabel => 'merchant_is_active_label'.tr();
  static String get merchantDeactivateAction => 'merchant_deactivate_action'.tr();
  static String get merchantActivateAction => 'merchant_activate_action'.tr();
  static String get areYouSureDeleteMerchant => 'are_you_sure_delete_merchant'.tr();
  static String get editMerchant => 'edit_merchant'.tr();
  static String get save => 'save'.tr();
  static String get cancel => 'cancel'.tr();
  static String get confirm => 'confirm'.tr();
  static String get rating => 'rating'.tr();
  static String get noProductsFound => 'no_products_found'.tr();
  static String get searchProductsHint => 'search_products_hint'.tr();
  static String get noCategoriesFound => 'no_categories_found'.tr();
  static String get searchCategoriesHint => 'search_categories_hint'.tr();
  static String get loading => 'loading'.tr();
  static String get errorOccurred => 'error_occurred'.tr();
  static String get retry => 'retry'.tr();
  static String get noInternetConnection => 'no_internet_connection'.tr();
  static String get noDataFound => 'no_data_found'.tr();
  static String get somethingWentWrong => 'something_went_wrong'.tr();
  static String get productDetails => 'product_details'.tr();

  // Auth
  static String get login => 'login'.tr();
  static String get register => 'register'.tr();
  static String get email => 'email'.tr();
  static String get password => 'password'.tr();
  static String get enterEmail => 'enter_email'.tr();
  static String get enterPassword => 'enter_password'.tr();
  static String get loginSuccess => 'login_success'.tr();
  static String get forgotPassword => 'forgot_password'.tr();
  static String get dontHaveAccount => 'dont_have_account'.tr();
  static String get alreadyHaveAccount => 'already_have_account'.tr();
  static String get firstName => 'first_name'.tr();
  static String get lastName => 'last_name'.tr();
  static String get phone => 'phone'.tr();
  static String get enterPhone => 'enter_phone'.tr();
  static String get address => 'address'.tr();
  static String get enterAddress => 'enter_address'.tr();
  static String get pleaseEnterAddress => 'please_enter_address'.tr();
  static String get restaurantName => 'restaurant_name'.tr();
  static String get enterRestaurantName => 'enter_restaurant_name'.tr();
  static String get pleaseEnterRestaurantName => 'please_enter_restaurant_name'.tr();
  static String get selectCountry => 'select_country'.tr();
  static String get selectCity => 'select_city'.tr();
  static String get notificationChannel => 'notification_channel'.tr();
  static String get verifyAccountMethodTitle => 'verify_account_method_title'.tr();
  static String get verifyEmailOtp => 'verify_email_otp'.tr();
  static String get verifyWhatsAppOtp => 'verify_whatsapp_otp'.tr();
  static String get verifyAccount => 'verify_account'.tr();
  static String get enterOtp => 'enter_otp'.tr();
  static String get otp => 'otp'.tr();
  static String get resendOtp => 'resend_otp'.tr();
  static String get resetPassword => 'reset_password'.tr();
  static String get newPassword => 'new_password'.tr();
  static String get confirmPassword => 'confirm_password'.tr();
  static String get passwordResetSuccess => 'password_reset_success'.tr();
  static String get accountVerifiedSuccess => 'account_verified_success'.tr();
  static String get otpSentSuccess => 'otp_sent_success'.tr();
  static String get notAuthorized => 'not_authorized'.tr();
  static String get sessionExpired => 'session_expired'.tr();
  static String get pleaseEnterEmail => 'please_enter_email'.tr();
  static String get pleaseEnterPassword => 'please_enter_password'.tr();
  static String get pleaseSelectCountry => 'please_select_country'.tr();
  static String get pleaseSelectCity => 'please_select_city'.tr();
  static String get registerSuccess => 'register_success'.tr();
  static String get pleaseEnterOtp => 'please_enter_otp'.tr();
  static String get sendOtp => 'send_otp'.tr();
  static String get passwordsDoNotMatch => 'passwords_do_not_match'.tr();
  static String get profileUpdatedSuccess => 'profile_updated_success'.tr();
  static String get logoutSuccess => 'logout_success'.tr();
  static String get logoutError => 'logout_error'.tr();
  static String get areYouSureLogout => 'are_you_sure_logout'.tr();
  static String get forgotPasswordDescription => 'forgot_password_description'.tr();
  static String get pleaseSelectCountryFirst => 'please_select_country_first'.tr();
  static String get noCitiesAvailable => 'no_cities_available'.tr();

  // Merchant
  static String get merchants => 'merchants'.tr();
  static String get merchantDetails => 'merchant_details'.tr();
  static String get noMerchantsFound => 'no_merchants_found'.tr();
  static String get searchMerchants => 'search_merchants'.tr();
  static String get searchMerchantsHint => 'search_merchants_hint'.tr();
  static String get merchantUserId => 'merchant_user_id'.tr();
  static String get merchantRole => 'merchant_role'.tr();
  static String get merchantBirthday => 'merchant_birthday'.tr();
  static String get merchantVerifiedAt => 'merchant_verified_at'.tr();
  static String get merchantCreatedAt => 'merchant_created_at'.tr();
  static String get merchantUpdatedAt => 'merchant_updated_at'.tr();
  static String get merchantOnlineStatus => 'merchant_online_status'.tr();
  static String get merchantOnlineYes => 'merchant_online_yes'.tr();
  static String get merchantOnlineNo => 'merchant_online_no'.tr();
  static String get merchantPhoneHiddenLabel => 'merchant_phone_hidden_label'.tr();
  static String get merchantValueYes => 'merchant_value_yes'.tr();
  static String get merchantValueNo => 'merchant_value_no'.tr();
  static String get detailsShowMore => 'details_show_more'.tr();
  static String get detailsShowLess => 'details_show_less'.tr();
  static String get deliveryUserId => 'delivery_user_id'.tr();
  static String get deliveryOfficeOwnerId => 'delivery_office_owner_id'.tr();
  static String get deliveryAccountActive => 'delivery_account_active'.tr();
  static String get deliveryConfirmedStatus => 'delivery_confirmed_status'.tr();
  static String get deliveryCountryId => 'delivery_country_id'.tr();
  static String get deliveryCityId => 'delivery_city_id'.tr();
  static String get copiedToClipboard => 'copied_to_clipboard'.tr();
  static String get copyRestaurantName => 'copy_restaurant_name'.tr();
  static String get owner => 'owner'.tr();
  static String get hidePhoneNumberOption => 'hide_phone_number_option'.tr();
  static String get showPhoneNumber => 'show_phone_number'.tr();
  static String get location => 'location'.tr();
  static String get useMyLocation => 'use_my_location'.tr();
  static String get pleaseSelectLocation => 'please_select_location'.tr();
  static String get locationSetFormat => 'location_set_format'.tr();
  static String get pleaseSelectCountryOrLocation =>
      'please_select_country_or_location'.tr();
  static String get locationPermissionDenied => 'location_permission_denied'.tr();
  static String get locationUnavailable => 'location_unavailable'.tr();
  static String get chooseLocationOnMap => 'choose_location_on_map'.tr();
  static String get updateLocation => 'update_location'.tr();
  static String get currentLocation => 'current_location'.tr();
  static String get noLocationSet => 'no_location_set'.tr();
  static String get accountStatus => 'account_status'.tr();
  static String get restaurantOpenNow => 'restaurant_open_now'.tr();
  static String get accountActive => 'account_active'.tr();
  static String get accountInactive => 'account_inactive'.tr();
  static String get activateAccount => 'activate_account'.tr();
  static String get deactivateAccount => 'deactivate_account'.tr();

  // Delivery
  static String get deliveryMen => 'delivery_men'.tr();
  static String get deliveryManDetails => 'delivery_man_details'.tr();
  static String get addDeliveryMan => 'add_delivery_man'.tr();
  static String get deliveryPickLocation => 'delivery_pick_location'.tr();
  static String get deliveryOpenMap => 'delivery_open_map'.tr();
  static String get deliveryLocationRequired => 'delivery_location_required'.tr();
  static String get deliveryBirthdayInvalid => 'delivery_birthday_invalid'.tr();
  static String get deliveryBirthday => 'delivery_birthday'.tr();
  static String get deliveryBirthdayHint => 'delivery_birthday_hint'.tr();
  static String get deliveryLocationSet => 'delivery_location_set'.tr();
  static String get editDeliveryMan => 'edit_delivery_man'.tr();
  static String get confirmDelivery => 'confirm_delivery'.tr();
  static String get noDeliveryMenFound => 'no_delivery_men_found'.tr();
  static String get vehicleType => 'vehicle_type'.tr();
  static String get status => 'status'.tr();
  static String get online => 'online'.tr();
  static String get offline => 'offline'.tr();
  static String get confirmed => 'confirmed'.tr();
  static String get notConfirmed => 'not_confirmed'.tr();
  static String get searchDeliveryMen => 'search_delivery_men'.tr();
  static String get searchDeliveryMenHint => 'search_delivery_men_hint'.tr();
  static String get deliveryManCreatedSuccessfully => 'delivery_man_created_successfully'.tr();
  static String get deliveryManUpdatedSuccessfully => 'delivery_man_updated_successfully'.tr();
  static String get deliveryManDeletedSuccessfully => 'delivery_man_deleted_successfully'.tr();
  static String get deliveryManConfirmedSuccessfully => 'delivery_man_confirmed_successfully'.tr();
  static String get areYouSureDeleteDeliveryMan => 'are_you_sure_delete_delivery_man'.tr();
  static String get enterFirstName => 'enter_first_name'.tr();
  static String get enterLastName => 'enter_last_name'.tr();
  static String get pleaseEnterFirstName => 'please_enter_first_name'.tr();
  static String get pleaseEnterLastName => 'please_enter_last_name'.tr();
  static String get pleaseEnterPhone => 'please_enter_phone'.tr();
  static String get passwordMustBeAtLeast6Characters => 'password_must_be_at_least_6_characters'.tr();
  static String get selectLanguage => 'select_language'.tr();
  static String get changeLanguage => 'change_language'.tr();
  static String get close => 'close'.tr();
  static String get languageChangedSuccessfully => 'language_changed_successfully'.tr();

  // Order
  static String get orders => 'orders'.tr();
  static String get orderDetails => 'order_details'.tr();
  static String get noOrdersFound => 'no_orders_found'.tr();
  static String get searchOrders => 'search_orders'.tr();
  static String get searchOrdersHint => 'search_orders_hint'.tr();
  static String get orderCompletedSuccessfully => 'order_completed_successfully'.tr();
  static String get orderConfirmedSuccessfully => 'order_confirmed_successfully'.tr();
  static String get orderStatusUpdatedSuccess => 'order_status_updated_success'.tr();
  static String get merchantPostConfirmEducationTitle =>
      'merchant_post_confirm_education_title'.tr();
  static String get merchantPostConfirmEducationBody =>
      'merchant_post_confirm_education_body'.tr();
  static String get merchantDontShowEducationAgain =>
      'merchant_dont_show_education_again'.tr();
  static String get merchantGotIt => 'merchant_got_it'.tr();
  static String get merchantPreparingWaitDriverTitle =>
      'merchant_preparing_wait_driver_title'.tr();
  static String get merchantPreparingWaitDriverBody =>
      'merchant_preparing_wait_driver_body'.tr();
  static String get merchantSetPreparing => 'merchant_set_preparing'.tr();
  static String get merchantSetReadyPickup => 'merchant_set_ready_pickup'.tr();
  static String get merchantOrdersTabPending => 'merchant_orders_tab_pending'.tr();
  static String get merchantOrdersTabConfirmed => 'merchant_orders_tab_confirmed'.tr();
  static String get merchantOrdersTabOthers => 'merchant_orders_tab_others'.tr();
  static String get ordersFilterTitle => 'orders_filter_title'.tr();
  static String get ordersFilterFollowTab => 'orders_filter_follow_tab'.tr();
  static String get ordersFilterNoStatusOverride =>
      'orders_filter_no_status_override'.tr();
  static String get ordersFilterApply => 'orders_filter_apply'.tr();
  static String get ordersFilterTooltip => 'orders_filter_tooltip'.tr();
  static String get ordersResetFilters => 'orders_reset_filters'.tr();
  static String get orderStatusPreparing => 'order_status_preparing'.tr();
  static String get orderStatusReadyForPickup =>
      'order_status_ready_for_pickup'.tr();
  static String get orderStatusAssigned => 'order_status_assigned'.tr();
  static String get orderStatusPickedUp => 'order_status_picked_up'.tr();
  static String get orderStatusCancelled => 'order_status_cancelled'.tr();
  static String get orderStatusRejected => 'order_status_rejected'.tr();
  static String get mealPreparationMinutes => 'meal_preparation_minutes'.tr();
  static String get deliveryTimeMinutes => 'delivery_time_minutes'.tr();
  static String get confirmOrderAction => 'confirm_order_action'.tr();
  static String get merchantConfirmOrderIntro => 'merchant_confirm_order_intro'.tr();
  static String get merchantConfirmMealPrepHint =>
      'merchant_confirm_meal_prep_hint'.tr();
  static String get merchantConfirmMealPrepRequired =>
      'merchant_confirm_meal_prep_required'.tr();
  static String get merchantSearchingSheetTagline =>
      'merchant_searching_sheet_tagline'.tr();
  static String get orderCancelledSuccessfully => 'order_cancelled_successfully'.tr();
  static String get order => 'order'.tr();
  static String get orderRestaurantSection => 'order_restaurant_section'.tr();
  static String get orderRestaurantPlaceholder => 'order_restaurant_placeholder'.tr();
  static String get orderListCustomerMissing => 'order_list_customer_missing'.tr();
  static String get orderTotalLabel => 'order_total_label'.tr();
  static String get orderMerchantIdLabel => 'order_merchant_id_label'.tr();
  static String get customer => 'customer'.tr();
  static String get orderSummary => 'order_summary'.tr();
  static String get productsCount => 'products_count'.tr();
  static String get people => 'people'.tr();
  static String get latitude => 'latitude'.tr();
  static String get longitude => 'longitude'.tr();
  static String get landmark => 'landmark'.tr();
  static String get specialInstructions => 'special_instructions'.tr();
  static String get numberOfPeople => 'number_of_people'.tr();
  static String get deliveryMan => 'delivery_man'.tr();
  static String get areYouSureCompleteOrder => 'are_you_sure_complete_order'.tr();
  static String get areYouSureCancelOrder => 'are_you_sure_cancel_order'.tr();
  static String get completeOrder => 'complete_order'.tr();
  static String get cancelOrder => 'cancel_order'.tr();

  // Order live tracking (Firebase RTDB + map)
  static String get trackOrderLive => 'track_order_live'.tr();
  static String get orderStepPlaced => 'order_step_placed'.tr();
  static String get orderStepConfirmed => 'order_step_confirmed'.tr();
  static String get orderStepSearching => 'order_step_searching'.tr();
  static String get orderStepReady => 'order_step_ready'.tr();
  static String get orderStepWithDriver => 'order_step_with_driver'.tr();
  static String get orderStepOnTheWay => 'order_step_on_the_way'.tr();
  static String get orderStepDelivered => 'order_step_delivered'.tr();
  static String get orderDeliveryMapBadge => 'order_delivery_map_badge'.tr();
  static String get orderStatusLabelOnTheWay => 'order_status_label_on_the_way'.tr();
  static String get orderStatusViewDetails => 'order_status_view_details'.tr();
  static String get orderStatusProblemBanner => 'order_status_problem_banner'.tr();

  // Offer
  static String get offers => 'offers'.tr();
  static String get offerName => 'offer_name'.tr();
  static String get pleaseEnterOfferName => 'please_enter_offer_name'.tr();
  static String get addOffer => 'add_offer'.tr();
  static String get editOffer => 'edit_offer'.tr();
  static String get offerDetails => 'offer_details'.tr();
  static String get noOffersFound => 'no_offers_found'.tr();
  static String get searchOffersHint => 'search_offers_hint'.tr();
  static String get offerDescription => 'offer_description'.tr();
  static String get pleaseEnterOfferDescription => 'please_enter_offer_description'.tr();
  static String get offerShortDescription => 'offer_short_description'.tr();
  static String get offerLongDescription => 'offer_long_description'.tr();
  static String get selectProducts => 'select_products'.tr();
  static String get offerStartDate => 'offer_start_date'.tr();
  static String get offerEndDate => 'offer_end_date'.tr();
  static String get offerDiscountType => 'offer_discount_type'.tr();
  static String get offerDiscountValue => 'offer_discount_value'.tr();
  static String get offerDiscountPercentage => 'offer_discount_percentage'.tr();
  static String get offerDiscountValueType => 'offer_discount_value_type'.tr();
  static String get offerProductsCount => 'offer_products_count'.tr();
  static String get offerDiscount => 'offer_discount'.tr();
  static String get offerTotalBeforeDiscount => 'offer_total_before_discount'.tr();
  static String get offerTotalAfterDiscount => 'offer_total_after_discount'.tr();
  static String get pleaseEnterOfferShortDescription => 'please_enter_offer_short_description'.tr();
  static String get pleaseSelectAtLeastOneProduct => 'please_select_at_least_one_product'.tr();
  static String get offerQuantityHint => 'offer_quantity_hint'.tr();
  static String get pleaseEnterValidOfferProductQuantity =>
      'please_enter_valid_offer_product_quantity'.tr();
  static String get pleaseSelectDiscountType => 'please_select_discount_type'.tr();
  static String get pleaseEnterOfferDiscountValue => 'please_enter_offer_discount_value'.tr();
  static String get invalidOfferDiscountValue => 'invalid_offer_discount_value'.tr();
  static String get offerCreatedSuccessfully => 'offer_created_successfully'.tr();
  static String get offerUpdatedSuccessfully => 'offer_updated_successfully'.tr();
  static String get offerDeletedSuccessfully => 'offer_deleted_successfully'.tr();
  static String get areYouSureDeleteOffer => 'are_you_sure_delete_offer'.tr();
  static String get selectDate => 'select_date'.tr();
  static String get showAll => 'show_all'.tr();
  static String get backToLogin => 'back_to_login'.tr();

  // Settings (admin)
  static String get supportPhone => 'support_phone'.tr();
  static String get enterSupportPhone => 'enter_support_phone'.tr();
  static String get whatsappNumber => 'whatsapp_number'.tr();
  static String get enterWhatsappNumber => 'enter_whatsapp_number'.tr();
  static String get defaultCommissionRate => 'default_commission_rate'.tr();
  static String get deliveryTipPerKilometer => 'delivery_tip_per_kilometer'.tr();
  static String get enterDeliveryTipPerKilometer =>
      'enter_delivery_tip_per_kilometer'.tr();
  static String get enterCommissionRate => 'enter_commission_rate'.tr();
  static String get pleaseEnterValidCommissionRate => 'please_enter_valid_commission_rate'.tr();
  static String get settingsUpdatedSuccessfully => 'settings_updated_successfully'.tr();
}

