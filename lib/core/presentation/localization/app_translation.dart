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

  // Product
  static String get products => 'products'.tr();
  static String get addProduct => 'add_product'.tr();
  static String get editProduct => 'edit_product'.tr();
  static String get productName => 'product_name'.tr();
  static String get productDescription => 'product_description'.tr();
  static String get productPrice => 'product_price'.tr();
  static String get productQuantity => 'product_quantity'.tr();
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
  static String get delete => 'delete'.tr();
  static String get edit => 'edit'.tr();
  static String get save => 'save'.tr();
  static String get cancel => 'cancel'.tr();
  static String get rating => 'rating'.tr();
  static String get noProductsFound => 'no_products_found'.tr();
  static String get noCategoriesFound => 'no_categories_found'.tr();
  static String get loading => 'loading'.tr();
  static String get errorOccurred => 'error_occurred'.tr();
}

