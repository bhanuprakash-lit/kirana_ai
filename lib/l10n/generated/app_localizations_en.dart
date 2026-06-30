// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get languageChooseTitle => 'Choose your language';

  @override
  String get languageChooseSubtitle =>
      'You can change this anytime in Settings.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonServerError =>
      'Could not connect to the server. Please try again.';

  @override
  String get commonSomethingWrong => 'Something went wrong. Please try again.';

  @override
  String get authErrEnterPhone => 'Enter your phone number';

  @override
  String get authErrEnter6Otp => 'Enter the 6-digit OTP';

  @override
  String get authErrSessionExpired => 'Session expired. Tap Resend.';

  @override
  String get authErrInvalidPhone =>
      'Invalid phone number. Include country code (e.g. +91...).';

  @override
  String get authErrTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get authErrWrongOtp => 'Wrong OTP. Please check and try again.';

  @override
  String get authErrOtpExpired => 'OTP expired. Tap Resend to get a new code.';

  @override
  String get authErrVerificationFailed => 'Verification failed. Try again.';

  @override
  String get welcomeSlide1Title => 'Welcome to\nOutlet AI';

  @override
  String get welcomeSlide1Subtitle =>
      'Your smart business partner for managing your kirana store — built for South India.';

  @override
  String get welcomeSlide2Title => 'Smart Inventory\nManagement';

  @override
  String get welcomeSlide2Subtitle =>
      'Track stock levels, get low-stock alerts, and never run out of your bestselling products.';

  @override
  String get welcomeSlide3Title => 'Grow Your\nBusiness';

  @override
  String get welcomeSlide3Subtitle =>
      'Get AI-powered insights, sales analytics, and personalised tips for your store.';

  @override
  String get welcomeGetStarted => 'Get Started';

  @override
  String get welcomeHaveAccount => 'Already have an account? ';

  @override
  String get welcomeSignIn => 'Sign In';

  @override
  String get loginWelcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to your Outlet AI account.';

  @override
  String get loginTabPhone => 'Phone OTP';

  @override
  String get loginTabUsername => 'Username';

  @override
  String get loginPhoneLabel => 'Phone number';

  @override
  String get loginSendOtp => 'Send OTP';

  @override
  String get loginOtpHelp => 'We\'ll send a one-time password to this number';

  @override
  String loginOtpSentTo(String phone) {
    return 'OTP sent to $phone';
  }

  @override
  String get loginOtp6Label => '6-digit OTP';

  @override
  String get loginVerifyOtp => 'Verify OTP';

  @override
  String get loginResendOtp => 'Resend OTP';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginUsernameHint => 'e.g. mykiranastore';

  @override
  String get loginUsernameRequired => 'Username is required';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Your password';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginCreateOne => 'Create one';

  @override
  String get loginIncorrect =>
      'Incorrect username or password. Please try again.';

  @override
  String loginFailed(String message) {
    return 'Login failed: $message';
  }

  @override
  String onboardingStepCount(int step) {
    return '$step/4';
  }

  @override
  String get accountVerifyPhoneTitle => 'Verify your\nphone number';

  @override
  String get accountVerifyPhoneSubtitle =>
      'We\'ll send a one-time password to confirm your number.';

  @override
  String get accountPhoneLabel => 'Phone number';

  @override
  String get accountSendOtp => 'Send OTP';

  @override
  String get accountEnterOtpTitle => 'Enter OTP';

  @override
  String get accountEnterOtpSubtitle => '6-digit code sent to your phone.';

  @override
  String accountOtpSentTo(String phone) {
    return 'OTP sent to +91 $phone';
  }

  @override
  String get accountOtp6Label => '6-digit OTP';

  @override
  String get accountVerify => 'Verify';

  @override
  String get accountResendOtp => 'Resend OTP';

  @override
  String accountPhoneVerified(String phone) {
    return 'Phone verified: $phone';
  }

  @override
  String get accountChooseUsernameTitle => 'Choose a\nstore username';

  @override
  String get accountChooseUsernameSubtitle =>
      'Your username is unique to your store and used to log in.';

  @override
  String get accountUsernameLabel => 'Username';

  @override
  String get accountUsernameHint => 'e.g. lohiyastore123';

  @override
  String get accountUsernameTaken => 'Username already taken';

  @override
  String get accountUsernameRules =>
      'Letters, numbers, underscores only • min 3 chars';

  @override
  String get accountErrChooseUsername =>
      'Choose a unique username for your store';

  @override
  String get accountErrUsernameMin3 => 'Username must be at least 3 characters';

  @override
  String get accountErrUsernameChars =>
      'Only letters, numbers, and underscores allowed';

  @override
  String get accountErrUsernameTakenTry =>
      'That username is taken. Try another.';

  @override
  String get businessTitle => 'Tell us about\nyour store';

  @override
  String get businessSubtitle => 'Help us personalise your experience.';

  @override
  String get businessOwnerLabel => 'Owner\'s full name';

  @override
  String get businessOwnerHint => 'e.g. Ramesh Kumar';

  @override
  String get businessOwnerRequired => 'Name is required';

  @override
  String get businessStoreLabel => 'Store name';

  @override
  String get businessStoreHint => 'e.g. Sri Lakshmi Stores';

  @override
  String get businessStoreRequired => 'Store name is required';

  @override
  String get businessEmailLabel => 'Email address';

  @override
  String get businessEmailHint => 'you@example.com';

  @override
  String get businessEmailRequired => 'Email is required';

  @override
  String get businessEmailInvalid => 'Enter a valid email address';

  @override
  String get businessTypeLabel => 'Business type';

  @override
  String get businessTypeHint => 'Select your store type';

  @override
  String get businessTypeRequired => 'Please select your business type';

  @override
  String get businessFootfallLabel => 'Estimated daily customers';

  @override
  String get businessFootfallHint => 'e.g. 40';

  @override
  String get businessFootfallSuffix => 'customers/day';

  @override
  String get businessFootfallInvalid => 'Enter a valid number';

  @override
  String get businessBudgetLabel => 'Monthly sales target (optional)';

  @override
  String get businessBudgetHint => 'e.g. 150000';

  @override
  String get businessBudgetHelper =>
      'Used to track daily progress. You can change it later.';

  @override
  String get businessBudgetInvalid => 'Enter a valid amount';

  @override
  String get businessTypeKirana => 'Kirana / General Stores';

  @override
  String get businessTypeGeneral => 'General Store';

  @override
  String get businessTypeProvision => 'Provision Store';

  @override
  String get businessTypeFruitsVeg => 'Fruits & Vegetables';

  @override
  String get businessTypeStationery => 'Stationery & Books';

  @override
  String get businessTypeSupermarket => 'Supermarket';

  @override
  String get businessTypeMiniSupermarket => 'Mini Supermarket';

  @override
  String get businessTypeMonoBrand => 'Mono Brand Store';

  @override
  String get businessTypeBoutique => 'Boutique';

  @override
  String get businessTypeSalon => 'Salon & Parlour';

  @override
  String get businessTypeFancyGift => 'Fancy & Gift Store';

  @override
  String get businessTypeSportsFitness => 'Sports & Fitness';

  @override
  String get businessTypeFootwear => 'Footwear Shop';

  @override
  String get businessTypeOptical => 'Optical Store';

  @override
  String get businessTypeBakery => 'Bakery & Sweet Shop';

  @override
  String get businessTypeApparel => 'Apparel & Clothing';

  @override
  String get businessTypeElectronics => 'Mobile & Electronics';

  @override
  String get businessTypeOthers => 'Others';

  @override
  String get locationTitle => 'Where is your\nstore located?';

  @override
  String get locationSubtitle =>
      'We use this to show local insights and enable delivery zones.';

  @override
  String get locationDetecting => 'Detecting location…';

  @override
  String get locationDetect => 'Detect My Location';

  @override
  String get locationOrManual => 'or enter manually';

  @override
  String get locationAddressLabel => 'Store address';

  @override
  String get locationAddressHint => 'Street, area, landmark…';

  @override
  String get locationCityLabel => 'City / District';

  @override
  String get locationCityHint => 'e.g. Hyderabad';

  @override
  String get locationGettingCoords => 'Getting coordinates…';

  @override
  String get locationDetected => 'Location detected';

  @override
  String get locationErrAddress => 'Please detect or enter your store address.';

  @override
  String get locationErrCity => 'Please enter your city or district.';

  @override
  String get locationPermDenied =>
      'Location permission denied. Please enter address manually.';

  @override
  String get locationDetectFailed =>
      'Could not detect location. Please enter address manually.';

  @override
  String get consentTitle => 'Almost there!\nReview & agree';

  @override
  String get consentSubtitle =>
      'Please read and accept the following to complete your setup.';

  @override
  String get consentTermsTitle => 'Terms & Conditions';

  @override
  String get consentTermsSummary =>
      'By using Outlet AI, you agree to use the service for legitimate business purposes only. LohiyaAI reserves the right to suspend accounts that violate these terms. Your data is used solely to provide and improve the service.';

  @override
  String get consentPrivacyTitle => 'Privacy Policy';

  @override
  String get consentPrivacySummary =>
      'We collect your store details, location, and transaction data to personalise your experience. We never sell your personal data to third parties. All data is encrypted and stored securely on our cloud infrastructure.';

  @override
  String get consentTermsCheckPrefix => 'I have read and agree to the ';

  @override
  String get consentPrivacyCheckPrefix => 'I agree to the ';

  @override
  String get consentAcceptBoth => 'Please accept both agreements to continue.';

  @override
  String get consentCompleteSetup => 'Complete Setup';

  @override
  String get regErrPhoneExists =>
      'This phone number is already registered. Please sign in instead.';

  @override
  String get regErrUsernameTaken =>
      'This username is already taken. Please choose another.';

  @override
  String get regErrInvalidDetails =>
      'Invalid details. Please check your entries and try again.';

  @override
  String regErrFailed(String message) {
    return 'Registration failed: $message';
  }

  @override
  String get dashNavHome => 'Home';

  @override
  String get dashNavKhata => 'Khata';

  @override
  String get dashNavBilling => 'Billing';

  @override
  String get dashTrialWelcome => 'Welcome to Outlet AI';

  @override
  String get dashTrialChoosePlan =>
      'Choose a plan to trial free. Our team will activate it shortly.';

  @override
  String get dashTrialSelectPlan => 'SELECT YOUR TRIAL PLAN';

  @override
  String get dashTrialRequestPro => 'Request Pro Trial';

  @override
  String get dashTrialRequestBasic => 'Request Basic Trial';

  @override
  String get dashTrialSignInDifferent => 'Sign in to a different account';

  @override
  String get dashPlanBadgeAllFeatures => 'ALL FEATURES';

  @override
  String get dashPlanBasicName => 'Basic Plan';

  @override
  String get dashPlanProName => 'Pro Plan';

  @override
  String get dashFeatPos => 'POS & Sales Management';

  @override
  String get dashFeatInventoryTracking => 'Inventory Tracking';

  @override
  String get dashFeatFinanceUdhaar => 'Finance & Udhaar';

  @override
  String get dashFeatKpiInsights => 'KPI Insights (3 per category)';

  @override
  String get dashFeatAiReco => 'AI Recommendations';

  @override
  String get dashFeatEverythingBasic => 'Everything in Basic';

  @override
  String get dashFeatAllKpi => 'All KPI Categories (unlimited)';

  @override
  String get dashFeatVendorProcurement => 'Vendor & Procurement Management';

  @override
  String get dashFeatCashflowSupport => 'Cashflow Support (up to ₹10L)';

  @override
  String get dashFeatCustomerGrowth => 'Customer Growth Engine';

  @override
  String get dashPendingTitle => 'Trial Request Received!';

  @override
  String get dashPendingBody =>
      'Your trial activation is being reviewed by our team. You\'ll receive a notification on your device as soon as it\'s approved — usually within a few hours.';

  @override
  String get dashPendingNotifNote =>
      'Make sure notifications are enabled so you don\'t miss the activation alert.';

  @override
  String get dashPendingCheckStatus => 'Check Status';

  @override
  String get dashUpgradeTitle => 'Free Trial Ended';

  @override
  String get dashUpgradeBody =>
      'Your free trial has ended. Choose a plan to continue using Outlet AI and keep growing your store.';

  @override
  String get dashUpgradeBasic => 'Basic';

  @override
  String get dashUpgradePro => 'Pro';

  @override
  String get dashUpgradeBadgeBest => 'BEST';

  @override
  String dashUpgradeJustPerDay(String price) {
    return 'just $price';
  }

  @override
  String get dashUpgradeAlreadySubscribed => 'Already subscribed? Refresh';

  @override
  String get dashFeatPosInventory => 'POS & Inventory';

  @override
  String get dashFeatFinanceKpis => 'Finance & KPIs';

  @override
  String get dashFeatVendorManagement => 'Vendor Management';

  @override
  String get dashFeatCashflowReferrals => 'Cashflow + Referrals';

  @override
  String get dashNewSale => 'New Sale';

  @override
  String get dashGreetingMorning => 'Good morning';

  @override
  String get dashGreetingAfternoon => 'Good afternoon';

  @override
  String get dashGreetingEvening => 'Good evening';

  @override
  String dashGreetingWithName(String greeting, String name) {
    return '$greeting, \n$name';
  }

  @override
  String get dashMorningBriefing => 'MORNING BRIEFING';

  @override
  String dashBriefingBody(int risk, int reorder) {
    return 'You have $risk SKUs at critical risk and $reorder items to reorder today. Tap to fix.';
  }

  @override
  String get dashIntelligence => 'Intelligence';

  @override
  String get dashMetricStockoutLabel => 'Stockout Risk';

  @override
  String get dashMetricStockoutSub => 'SKUs critical';

  @override
  String get dashMetricReorderLabel => 'Reorder Now';

  @override
  String get dashMetricReorderSub => 'SKUs low stock';

  @override
  String get dashMetricFastLabel => 'Fast Moving';

  @override
  String get dashMetricFastSub => 'Top sellers';

  @override
  String get dashMetricProfitLabel => 'Profit Picks';

  @override
  String get dashMetricProfitSub => 'Opportunities';

  @override
  String get dashMetricCustomerLabel => 'Customer Dues';

  @override
  String get dashMetricCustomerSub => 'Pending khata';

  @override
  String get dashMetricSalesLabel => 'Items Sold';

  @override
  String get dashMetricSalesSub => 'Today so far';

  @override
  String get dashTodaysPerformance => 'Today\'s Performance';

  @override
  String get dashPosNotAvailable => 'POS data not available';

  @override
  String get dashStatRevenue => 'Revenue';

  @override
  String get dashStatOrders => 'Bills';

  @override
  String get dashStatAvgOrder => 'Avg bill';

  @override
  String get dashStoreOverview => 'Store Overview';

  @override
  String get dashStoreSkus => 'SKUs';

  @override
  String get dashStoreFootfall => 'Daily footfall';

  @override
  String get dashStoreDailyBudget => 'Daily stock cost';

  @override
  String dashKpiPeriod(int days) {
    return 'Last $days days';
  }

  @override
  String get dashCouldNotLoad => 'Could not load data';

  @override
  String get dashRetry => 'Retry';

  @override
  String get dashAlerts => 'ALERTS';

  @override
  String get dashSeeAll => 'See all';

  @override
  String get dashStoreKpis => 'Store KPIs';

  @override
  String dashKpiCoverageTooltip(String pct) {
    return 'Based on $pct% of sales — some items have no cost data';
  }

  @override
  String get dashDetailStockout => 'Stockout Risk';

  @override
  String get dashDetailReorder => 'Reorder Required';

  @override
  String get dashDetailFastMoving => 'Fast Moving Items';

  @override
  String get dashDetailProfit => 'High Profit Items';

  @override
  String get dashDetailDefault => 'Intelligence Detail';

  @override
  String get dashSearchProducts => 'Search products...';

  @override
  String get dashSortBy => 'Sort by:';

  @override
  String get dashSortProfit => 'Profit';

  @override
  String get dashSortDemand => 'Demand';

  @override
  String get dashSortRisk => 'Risk';

  @override
  String dashStockLabel(String qty) {
    return 'Stock: $qty';
  }

  @override
  String get dashStockRunway => 'Stock runway';

  @override
  String get dashOutOfStock => 'OUT OF STOCK';

  @override
  String dashDaysLeft(String days) {
    return '~$days days left';
  }

  @override
  String get dashStatStockoutRisk => 'Stockout risk';

  @override
  String get dashStatReorderQty => 'Reorder qty';

  @override
  String dashUnitsValue(String qty) {
    return '$qty units';
  }

  @override
  String dashWeeklyProfitImpact(String amount) {
    return '₹$amount estimated weekly profit impact';
  }

  @override
  String dashCreatePurchaseOrder(String qty) {
    return 'Create Purchase Order · $qty units';
  }

  @override
  String get dashNoItemsFound => 'No items found';

  @override
  String dashNoResultsFor(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get dashClearSearch => 'Clear search';

  @override
  String get dashConnectionError => 'Connection Error';

  @override
  String get posCommonCancel => 'Cancel';

  @override
  String get posCommonClear => 'Clear';

  @override
  String get posCommonRefresh => 'Refresh';

  @override
  String get posCommonAddToCart => 'Add to Cart';

  @override
  String get posCameraPermissionRequired =>
      'Camera permission is required to scan barcodes.';

  @override
  String get posCommonSettings => 'Settings';

  @override
  String posEnterQtyTitle(String unit) {
    return 'Enter $unit';
  }

  @override
  String get posQtyFallback => 'Qty';

  @override
  String get posSelectVariant => 'Select variant';

  @override
  String posInclGst(String amount) {
    return 'Incl. GST $amount';
  }

  @override
  String get posOutOfStock => 'Out of stock';

  @override
  String posVariantStockLine(String stock) {
    return '$stock in stock';
  }

  @override
  String posPriceLabel(String price) {
    return 'Price: $price';
  }

  @override
  String get posWeightMeasurement => 'Weight / Measurement';

  @override
  String get posUnknownBarcodeTitle => 'Unknown Barcode';

  @override
  String posUnknownBarcodeBody(String barcode) {
    return 'Barcode \"$barcode\" is not in your inventory. What would you like to do?';
  }

  @override
  String get posAddAsNew => 'Add as New';

  @override
  String get posLinkToExisting => 'Link to Existing Item';

  @override
  String posErrLoadingInventory(String error) {
    return 'Error loading inventory: $error';
  }

  @override
  String posLinkBarcodeTitle(String barcode) {
    return 'Link Barcode \"$barcode\"';
  }

  @override
  String get posNoUnbarcodedItems => 'No items found without barcodes.';

  @override
  String posCategoryLabel(String category) {
    return 'Category: $category';
  }

  @override
  String get posCategoryGeneral => 'General';

  @override
  String posLinkedToItem(String barcode, String name) {
    return 'Linked $barcode to $name';
  }

  @override
  String get posScanReferralQr => 'Scan Referral QR';

  @override
  String posCampaignOutOfStock(String name) {
    return 'All items in \"$name\" are out of stock';
  }

  @override
  String posCampaignItemsAdded(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return '$count $_temp0 from \"$name\" added';
  }

  @override
  String posAddedSkipped(int added, int skipped) {
    return '$added added · $skipped skipped (out of stock)';
  }

  @override
  String posBasketAddedAtPrice(String name, String price) {
    return 'Bundle \"$name\" added at ₹$price';
  }

  @override
  String posItemsRegularPrice(int count) {
    return '$count items added at regular price (bundle needs all items in stock)';
  }

  @override
  String posBasketItemsAdded(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return '$count $_temp0 from \"$name\" added';
  }

  @override
  String posItemsAddedToCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return '$count $_temp0 added to cart';
  }

  @override
  String get posSelectCustomer => 'Select Customer';

  @override
  String get posNew => 'New';

  @override
  String get posSearchNameOrPhone => 'Search by name or phone...';

  @override
  String get posNoCustomersFound => 'No customers found.';

  @override
  String get posAddNewCustomer => 'Add New Customer';

  @override
  String get posSelectFromContacts => 'Select from Contacts';

  @override
  String get posCustomerName => 'Customer Name';

  @override
  String get posPhoneNumber => 'Phone Number';

  @override
  String get posSaveAndSelect => 'Save & Select';

  @override
  String get posSearchProducts => 'Search products…';

  @override
  String get posReferralScan => 'Referral Scan';

  @override
  String get posOrderHistory => 'Order History';

  @override
  String get posRefreshingProducts => 'Refreshing products...';

  @override
  String posRefreshFailed(String error) {
    return 'Refresh failed: $error';
  }

  @override
  String posProductsRefreshed(int count) {
    return 'Products refreshed ($count items)';
  }

  @override
  String posItemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return '$count $_temp0 in cart';
  }

  @override
  String get posClearCartTitle => 'Clear Cart?';

  @override
  String get posClearCartBody => 'All items will be removed from the cart.';

  @override
  String get posFrequentlyBought => 'FREQUENTLY BOUGHT TOGETHER';

  @override
  String get posNoProductsFound => 'No products found';

  @override
  String posStockColon(String stock) {
    return 'Stock: $stock';
  }

  @override
  String get posOffline => 'POS Offline';

  @override
  String get posCouldNotConnect => 'Could not connect to POS.';

  @override
  String get posBundlesAndDeals => 'Bundles & Deals';

  @override
  String get posRefreshAi => 'Refresh AI';

  @override
  String posItemsInBundle(int count) {
    return '$count items in bundle';
  }

  @override
  String get posBundlePrice => 'bundle price';

  @override
  String get posItemFallback => 'Item';

  @override
  String posValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String posStockUnitPrice(String stock, String unit, String price) {
    return 'Stock: $stock $unit  ·  ₹$price';
  }

  @override
  String get posNotInStock => 'Not in stock';

  @override
  String get posBundlePriceLabel => 'Bundle Price';

  @override
  String get posAddAvailableToCart => 'Add Available Items to Cart';

  @override
  String posVoiceCount(int remaining, int total) {
    return 'Voice ($remaining/$total)';
  }

  @override
  String get posVoiceOrder => 'Voice Order';

  @override
  String posHandwriteCount(int remaining, int total) {
    return 'Handwrite ($remaining/$total)';
  }

  @override
  String get posHandwrite => 'Handwrite';

  @override
  String get posCartEmpty => 'Cart is empty';

  @override
  String get posCartEmptyHint =>
      'Search for a product or scan a barcode to start a sale.';

  @override
  String get posAddCustomer => 'Add Customer';

  @override
  String posItemCount(String count) {
    return '$count items';
  }

  @override
  String posPlaceOrderAmount(String amount) {
    return 'Place Order · $amount';
  }

  @override
  String get posPosInventory => 'POS / Inventory';

  @override
  String get posOnline => 'POS Online';

  @override
  String get posTabSales => 'Sales';

  @override
  String get posTabStock => 'Stock';

  @override
  String get posTabPurchase => 'Purchase';

  @override
  String get posPurchaseSuppliers => 'Purchase & Suppliers';

  @override
  String get posPurchaseSuppliersDesc =>
      'Create purchase orders, manage your suppliers, and track what you owe them — all in one place.';

  @override
  String get posPaywallPurchaseDesc =>
      'Manage purchase orders and suppliers. Track payments to distributors. Available on the Pro plan.';

  @override
  String get posPrinterSetup => 'Printer Setup';

  @override
  String get posReconnect => 'Reconnect';

  @override
  String get posForgetPrinter => 'Forget this printer';

  @override
  String get posPairedDevices => 'PAIRED BLUETOOTH DEVICES';

  @override
  String get posNoPairedDevices => 'No paired devices found';

  @override
  String get posPairDeviceHint =>
      'Pair your thermal printer in Android\nBluetooth settings first, then refresh.';

  @override
  String get posProOnly => 'PRO ONLY';

  @override
  String get posUpgradeToProDay => 'Upgrade to Pro  ₹500/mo · just ₹17/day';

  @override
  String get posReceiptSent => 'Receipt sent to printer';

  @override
  String get posPrintFailedCheck => 'Print failed — check printer';

  @override
  String get posOrderPlaced => 'Order Placed!';

  @override
  String posOrderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String get posPrintReceipt => 'Print Receipt';

  @override
  String get posNewSale => 'New Sale';

  @override
  String get posViewOrderDetails => 'View Order Details';

  @override
  String get posSelectCustomerForUdhaar =>
      'Please select a customer for Udhaar sale';

  @override
  String get posConfirmOrder => 'Confirm Order';

  @override
  String get posOrderConfirmed => 'Order confirmed!';

  @override
  String get posSubtotal => 'Subtotal';

  @override
  String posReferralDiscount(String pct, String referrer) {
    return 'Referral Discount ($pct%)$referrer';
  }

  @override
  String get posGrandTotal => 'Grand Total';

  @override
  String get posPaymentMethod => 'Payment Method';

  @override
  String get posPayCash => 'Cash';

  @override
  String get posPayUdhaar => 'Udhaar';

  @override
  String get posUdhaarDueDate => 'Repayment due';

  @override
  String get posUdhaarDueDateHint => 'When will the customer repay?';

  @override
  String posBundlePercentOff(int pct) {
    return '$pct% OFF';
  }

  @override
  String posBundleYouSave(String amount) {
    return 'You save $amount';
  }

  @override
  String get posBundleRegularPrice =>
      'Added at regular price (bundle needs all items in stock)';

  @override
  String get posPayUpi => 'UPI';

  @override
  String get posComingSoon => 'Coming soon';

  @override
  String get posSelectCustomerRequired =>
      'Select customer (required for Udhaar)';

  @override
  String get posSelectCustomerForUdhaarTitle => 'Select Customer for Udhaar';

  @override
  String get posSearchNameOrPhoneHint => 'Search by name or phone…';

  @override
  String get posPrintAutomatically => 'Print receipt automatically';

  @override
  String get posWillPrintAfter => 'Will print after order is placed';

  @override
  String posPrinterStatus(String status) {
    return 'Printer: $status';
  }

  @override
  String get posAutoPrintDisabled =>
      'Disabled — print manually from order details';

  @override
  String get posHowMuchUdhaar => 'How much goes on Udhaar?';

  @override
  String get posCashNow => 'Cash now';

  @override
  String get posOnUdhaar => 'On Udhaar';

  @override
  String get posPrintFailedCheckConnection =>
      'Print failed — check printer connection';

  @override
  String get posTodaysOrders => 'Today\'s Orders';

  @override
  String posTransactionsSoFar(int count) {
    return '$count transactions so far';
  }

  @override
  String get posViewAll => 'View All';

  @override
  String get posNoOrdersToday => 'No orders today yet';

  @override
  String get posSalesAppearHere => 'Sales transactions will appear here';

  @override
  String posOrderMeta(String time, String payment, String status) {
    return '$time · $payment · $status';
  }

  @override
  String get posPrint => 'Print';

  @override
  String get posScanBarcode => 'Scan Barcode';

  @override
  String get posAlignBarcode => 'Align barcode within the frame';

  @override
  String get posLookingUp => 'Looking up…';

  @override
  String posAlreadyInList(String name) {
    return '$name already in list';
  }

  @override
  String posItemQty(String name, int qty) {
    return '$name ×$qty';
  }

  @override
  String posItemAdded(String name) {
    return '$name added';
  }

  @override
  String get posNotFoundTapAdd => 'Not found — tap to add manually';

  @override
  String posItemsScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return '$count $_temp0 scanned';
  }

  @override
  String get posScanItems => 'Scan items';

  @override
  String get posClearAll => 'Clear all';

  @override
  String posLookingUpItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return 'Looking up $count $_temp0…';
  }

  @override
  String posAddItemsToCart(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return 'Add $count $_temp0 to Cart  ·  ₹$total';
  }

  @override
  String get posPointCamera => 'Point camera at a barcode';

  @override
  String get posItemsAppearHere => 'Items appear here as you scan';

  @override
  String get posTransactionHistory => 'Transaction History';

  @override
  String get posFilters => 'Filters:';

  @override
  String get posClearAllFilters => 'Clear All';

  @override
  String get posNoTransactions => 'No transactions found';

  @override
  String get posTryAdjustFilters => 'Try adjusting your filters';

  @override
  String get posResetFilters => 'Reset Filters';

  @override
  String get posFilterTransactions => 'Filter Transactions';

  @override
  String get posPaymentStatus => 'Payment Status';

  @override
  String get posFilterAll => 'All';

  @override
  String get posStatusCompleted => 'Completed';

  @override
  String get posStatusPending => 'Pending';

  @override
  String get posDateRange => 'Date Range';

  @override
  String get posSelectDateRange => 'Select Date Range';

  @override
  String get posApplyFilters => 'Apply Filters';

  @override
  String get posOrderDetails => 'Order Details';

  @override
  String get posPaymentLabel => 'Payment';

  @override
  String get posTotalAmount => 'Total Amount';

  @override
  String posCustomerNumber(String id) {
    return 'Customer #$id';
  }

  @override
  String get posItemsSummary => 'Items Summary';

  @override
  String posProductNumber(String id) {
    return 'Product #$id';
  }

  @override
  String get posUnitFallback => 'unit';

  @override
  String posPrintReceiptStatus(String status) {
    return 'Print Receipt ($status)';
  }

  @override
  String get posReturnExchange => 'Return / Exchange';

  @override
  String get posSplitPayment => 'SPLIT PAYMENT';

  @override
  String get posCashPaidNow => 'Cash paid now';

  @override
  String get posOnUdhaarCredit => 'On Udhaar (credit)';

  @override
  String get posUdhaarRecordedNote =>
      'Udhaar portion recorded as credit — check Udhaar tab for balance';

  @override
  String get posUdhaarSale => 'Udhaar Sale';

  @override
  String get posTotalPaid => 'Total Paid';

  @override
  String get posRecordedAsCredit => 'Recorded as credit — check Udhaar tab';

  @override
  String get posBoughtAsBasket => 'Bought as a basket';

  @override
  String get posBasketValue => 'Basket value';

  @override
  String get posCustomerSaved => 'Customer saved';

  @override
  String get invSearchItemsOrCategories => 'Search items or categories...';

  @override
  String get invShowLess => 'Show Less';

  @override
  String invViewMore(int count) {
    return '+$count more';
  }

  @override
  String get invAll => 'All';

  @override
  String get invUncategorised => 'Uncategorised';

  @override
  String get invNoMatchesFound => 'No matches found';

  @override
  String invNearExpiryBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items expiring soon — tap to mark down or clear',
      one: '1 item expiring soon — tap to mark down or clear',
    );
    return '$_temp0';
  }

  @override
  String invMissingPriceBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products priced ₹0 — tap to set prices',
      one: '1 product priced ₹0 — tap to set prices',
    );
    return '$_temp0';
  }

  @override
  String get invFlagFast => 'Fast';

  @override
  String get invFlagReorder => 'Reorder';

  @override
  String get invFlagLowStock => 'Low stock';

  @override
  String get invFlagDead => 'Dead';

  @override
  String get invFlagProfit => 'Profit';

  @override
  String invStockLabel(String stock) {
    return 'Stock: $stock';
  }

  @override
  String get invUnitFallback => 'unit';

  @override
  String get invSyncFailedTapRetry => 'Sync failed — tap to retry';

  @override
  String get invSyncingToServer => 'Syncing to server...';

  @override
  String get invNoInventoryYet => 'No inventory yet';

  @override
  String get invNoInventoryHint =>
      'Tap + to add your first product.\nCreate a category first, then add items.';

  @override
  String get invAddFirstProduct => 'Add First Product';

  @override
  String get invCouldNotLoadInventory => 'Could not load inventory';

  @override
  String get invRetry => 'Retry';

  @override
  String get invSelectCategoryError => 'Please select a category';

  @override
  String invVariantPriceRequired(int number) {
    return 'Variant $number: selling price is required';
  }

  @override
  String get invProductSavedSyncing => 'Product saved — syncing in background';

  @override
  String invVariantsSavedSyncing(int count) {
    return '$count variants saved — syncing in background';
  }

  @override
  String get invAddProduct => 'Add Product';

  @override
  String get invAddFromCatalog => 'Add from Catalog';

  @override
  String get invNewProduct => 'New Product';

  @override
  String get invSave => 'Save';

  @override
  String get invSearchProductName => 'Search product name...';

  @override
  String get invLoadMoreResults => 'Load more results';

  @override
  String get invNoMoreSearchResults => 'No more search results';

  @override
  String get invSearchProductCatalog => 'Search the product catalog';

  @override
  String get invSearchCatalogHint =>
      'Type a name or scan a barcode.\nIf not found, add manually.';

  @override
  String get invAddManually => 'Add manually';

  @override
  String get invAddManuallySub =>
      'Product not in catalog? Enter details yourself.';

  @override
  String get invProductAdded => 'Product added!';

  @override
  String invVariantsAdded(int count) {
    return '$count variants added!';
  }

  @override
  String get invLooseItem => 'Loose item';

  @override
  String get invLooseItemSub => 'Sold by weight (e.g. Maida, Pulse)';

  @override
  String get invBasicDetails => 'Basic Details';

  @override
  String get invProductNameLabel => 'Product name *';

  @override
  String get invRequired => 'Required';

  @override
  String get invBrandOptional => 'Brand (optional)';

  @override
  String get invSelectCategoryStar => 'Select category *';

  @override
  String get invOther => 'Other';

  @override
  String get invPerishableItem => 'Perishable item';

  @override
  String get invPerishableItemSub => 'Has an expiry date';

  @override
  String get invSizePriceStock => 'Size, Price & Stock';

  @override
  String invVariantsCount(int count) {
    return 'Variants ($count)';
  }

  @override
  String get invAddVariant => 'Add Variant';

  @override
  String get invManageVariants => 'Manage Variants';

  @override
  String get invVariants => 'Variants';

  @override
  String get invEditVariant => 'Edit Variant';

  @override
  String get invSaveVariant => 'Save Variant';

  @override
  String get invNoVariantsYet =>
      'No variants yet. Add sizes, colours or models.';

  @override
  String get invStockPerVariantNote =>
      'Stock is tracked per variant. Use Manage Variants below.';

  @override
  String get invDefaultVariant => 'Default';

  @override
  String invVariantAxisRequired(String label) {
    return 'Please choose $label';
  }

  @override
  String get invSaveProduct => 'Save Product';

  @override
  String invSaveVariants(int count) {
    return 'Save $count Variants';
  }

  @override
  String get invProduct => 'Product';

  @override
  String invVariantNumber(int number) {
    return 'Variant $number';
  }

  @override
  String get invUnit => 'Unit';

  @override
  String get invBaseUnit => 'Base unit';

  @override
  String get invPackSize => 'Pack size';

  @override
  String get invPackSizeHint => 'e.g. 250';

  @override
  String get invBarcode => 'Barcode';

  @override
  String get invFromCatalog => 'From catalog';

  @override
  String get invOptional => 'optional';

  @override
  String invPricePerUnit(String unit) {
    return 'Price / $unit *';
  }

  @override
  String get invSellingPriceStar => 'Selling price *';

  @override
  String get invInvalid => 'Invalid';

  @override
  String get invMrp => 'MRP';

  @override
  String get invCostPrice => 'Cost price (what you pay)';

  @override
  String get invCostPriceHint => 'optional — improves profit accuracy';

  @override
  String invOpeningStockUnit(String unit) {
    return 'Opening stock ($unit) *';
  }

  @override
  String get invOpeningStockUnits => 'Opening stock (units) *';

  @override
  String get invExpiryDate => 'Expiry date';

  @override
  String get invExpiryDateHint => 'YYYY-MM-DD';

  @override
  String get invRequiredForPerishables => 'Required for perishables';

  @override
  String get invLinkedFromCatalog => 'Linked from catalog';

  @override
  String get invSelectCategory => 'Select Category';

  @override
  String get invSearchCategories => 'Search categories...';

  @override
  String get invNoCategoriesFound => 'No categories found';

  @override
  String get invEditProduct => 'Edit Product';

  @override
  String invProductUpdated(String name) {
    return '$name updated!';
  }

  @override
  String get invProductUpdatedSuccess => 'Product updated successfully!';

  @override
  String get invSellingUnit => 'Selling unit';

  @override
  String get invPricing => 'Pricing';

  @override
  String invPricePerSelected(String unit) {
    return 'Price per $unit *';
  }

  @override
  String get invMrpOptional => 'MRP (optional)';

  @override
  String get invStock => 'Stock';

  @override
  String get invGstRate => 'GST %';

  @override
  String get invHsnCode => 'HSN code';

  @override
  String get invWarranty => 'Warranty';

  @override
  String get invWarrantyCovered => 'Covered under warranty';

  @override
  String get invWarrantyCoveredSub =>
      'Set how long — counted from the purchase date';

  @override
  String get invWarrantyPeriod => 'Warranty period';

  @override
  String invStockInUnit(String unit) {
    return 'Stock (in $unit) *';
  }

  @override
  String get invStockQuantityStar => 'Stock quantity *';

  @override
  String get invPerishableBatchNote =>
      'For perishable batch details, use \"Receive Batch\" from inventory.';

  @override
  String get invSaveChanges => 'Save Changes';

  @override
  String get invCategoryNameRequired => 'Category name is required';

  @override
  String get invCreateCategoryFailed =>
      'Failed to create category. Please try again.';

  @override
  String get invNewCategory => 'New Category';

  @override
  String get invNewCategorySub => 'Add a category to organise your products.';

  @override
  String get invCategoryCreated => 'Category created!';

  @override
  String get invCategoryNameLabel => 'Category name';

  @override
  String get invCategoryNameHint => 'e.g. Staples, Dairy, Snacks…';

  @override
  String get invCreateCategory => 'Create Category';

  @override
  String get invCardOutOfStock => 'Out of stock';

  @override
  String invCardStockLow(String qty) {
    return '$qty — low';
  }

  @override
  String invCardStockInStock(String qty) {
    return '$qty in stock';
  }

  @override
  String get invCardFast => 'Fast';

  @override
  String get invCardSlow => 'Slow';

  @override
  String get invCardExpired => 'Expired';

  @override
  String invCardDays(String days) {
    return '${days}d';
  }

  @override
  String get invCardBarcode => 'Barcode';

  @override
  String get invCardSoldToday => 'Sold today';

  @override
  String get invCardReorder => 'Reorder';

  @override
  String invCardReorderUnits(String qty) {
    return '$qty units';
  }

  @override
  String get invCard7dRisk => '7d risk';

  @override
  String get invExpiringSoon => 'Expiring Soon';

  @override
  String get invNext => 'Next';

  @override
  String invDaysWindow(int days) {
    return '$days days';
  }

  @override
  String get invExpired => 'Expired';

  @override
  String get invExpiresToday => 'Expires today';

  @override
  String get invExpiresTomorrow => 'Expires tomorrow';

  @override
  String invExpiresInDays(int days) {
    return 'Expires in $days days';
  }

  @override
  String invQtyInStock(String qty, String unit) {
    return '$qty $unit in stock';
  }

  @override
  String get invAtRisk => 'At risk';

  @override
  String get invMarkedDown => 'Marked down';

  @override
  String get invPrice => 'Price';

  @override
  String get invChangeMarkdown => 'Change markdown';

  @override
  String get invMarkDown => 'Mark down';

  @override
  String get invRecordWaste => 'Record waste';

  @override
  String invMarkDownTitle(String name) {
    return 'Mark down $name';
  }

  @override
  String get invClearanceDiscount => 'Clearance discount to sell before expiry';

  @override
  String invPctSuggested(String pct) {
    return '$pct% (suggested)';
  }

  @override
  String invPct(String pct) {
    return '$pct%';
  }

  @override
  String get invCustom => 'Custom';

  @override
  String get invApplyMarkdown => 'Apply markdown';

  @override
  String get invMarkdownApplied => 'Markdown applied';

  @override
  String get invMarkdownFailed => 'Could not apply markdown';

  @override
  String invWriteOff(String name) {
    return 'Write off $name';
  }

  @override
  String get invWriteOffSub =>
      'Removes spoiled units from stock and records the loss.';

  @override
  String invOfQtyInStock(int qty) {
    return 'of $qty in stock';
  }

  @override
  String invUnitsWrittenOff(int units) {
    return '$units units written off';
  }

  @override
  String get invWasteFailed => 'Could not record waste';

  @override
  String get invNothingExpiring => 'Nothing expiring soon';

  @override
  String get invNothingExpiringSub =>
      'Perishable batches nearing expiry will show up here.';

  @override
  String get invCouldNotLoadExpiry => 'Could not load expiry data';

  @override
  String get invMissingPrices => 'Missing Prices';

  @override
  String get invCouldNotLoadPrices => 'Could not load prices';

  @override
  String invStockCurrentlyZero(String qty, String unit) {
    return '$qty $unit in stock · currently ₹0';
  }

  @override
  String invSuggestedPrice(String price, String source) {
    return 'Suggested ₹$price ($source)';
  }

  @override
  String get invSellingPrice => 'Selling price';

  @override
  String get invSet => 'Set';

  @override
  String get invEnterValidPrice => 'Enter a valid price';

  @override
  String invProductPriced(String name, String price) {
    return '$name priced ₹$price';
  }

  @override
  String get invCouldNotSetPrice => 'Could not set price';

  @override
  String get invEveryProductPriced => 'Every product is priced';

  @override
  String get invEveryProductPricedSub =>
      'Nothing is selling at ₹0. Good going!';

  @override
  String get finFinance => 'Finance';

  @override
  String get finErrorLoadingStats => 'Error loading stats';

  @override
  String get finTabCashflow => 'Cashflow';

  @override
  String get finTabCustomerUdhaar => 'Customer\nUdhaar';

  @override
  String get finTabSupplierUdhaar => 'Supplier Udhaar';

  @override
  String get finMonthlySales => 'Monthly Sales';

  @override
  String get finMonthlySkus => 'Monthly SKUs';

  @override
  String get finAvailableInFuture => 'Will be available in future updates';

  @override
  String get finFailedLoadUdhaar => 'Failed to load udhaar data';

  @override
  String get finCheckConnection =>
      'Please check your connection and try again.';

  @override
  String get finRetry => 'Retry';

  @override
  String get finCustomerDues => 'Customer Dues';

  @override
  String get finNewUdhaar => 'New Udhaar';

  @override
  String get finAddNewUdhaar => 'Add New Udhaar';

  @override
  String get finContacts => 'Contacts';

  @override
  String get finSelectExistingCustomer => 'Select existing customer';

  @override
  String get finOrEnterManually => 'or enter manually';

  @override
  String get finUdhaarRecorded => 'Udhaar recorded!';

  @override
  String get finCustomerName => 'Customer Name';

  @override
  String get finPhoneNumber => 'Phone Number';

  @override
  String get finAmount => 'Amount';

  @override
  String get finSaveUdhaar => 'Save Udhaar';

  @override
  String get finEnterValidNamePhoneAmount =>
      'Enter valid name, phone and amount';

  @override
  String get finSelectCustomer => 'Select Customer';

  @override
  String get finSearchByNameOrPhone => 'Search by name or phone...';

  @override
  String get finNoCustomersFound => 'No customers found';

  @override
  String get finTotalPending => 'Total Pending';

  @override
  String get finRecovered => 'Recovered';

  @override
  String get finCustomers => 'Customers';

  @override
  String finHighRiskDues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count high-risk due$_temp0 — chase these first';
  }

  @override
  String get finSmartRemindersSubtitle =>
      'Smart Reminders — recovery-ranked dues';

  @override
  String finTakenDaysAgo(String date, int days) {
    return 'Taken: $date ($days days ago)';
  }

  @override
  String get finWhatsappReminderSent => 'WhatsApp reminder sent!';

  @override
  String finFailedSendReminder(String error) {
    return 'Failed to send reminder: $error';
  }

  @override
  String get finSendWhatsappReminder => 'Send WhatsApp Reminder';

  @override
  String get finRemind => 'Remind';

  @override
  String get finRemindedToday => 'Reminded today';

  @override
  String get finRecover => 'Recover';

  @override
  String get finHistory => 'History';

  @override
  String get finSettled => 'Settled';

  @override
  String get finRecordPayment => 'Record payment';

  @override
  String get finPaymentOldestFirstNote => 'Applied to oldest dues first';

  @override
  String get finTaken => 'Taken';

  @override
  String get finPaid => 'Paid';

  @override
  String get finBalanceShort => 'Balance';

  @override
  String finOpenDuesSummary(int count, int days) {
    return '$count open · oldest ${days}d';
  }

  @override
  String finSettledSectionTitle(int count) {
    return 'Settled ($count)';
  }

  @override
  String finRecoverUdhaarFrom(String name) {
    return 'Recover Udhaar from $name';
  }

  @override
  String get finRecoveryRecorded => 'Recovery recorded!';

  @override
  String finBalanceLabel(String value) {
    return 'Balance: ₹$value';
  }

  @override
  String get finConfirmRecovery => 'Confirm Recovery';

  @override
  String get finEnterValidAmount => 'Please enter a valid amount';

  @override
  String finAmountExceedsBalance(String value) {
    return 'Amount cannot exceed balance ₹$value';
  }

  @override
  String get finNoPendingUdhaars => 'No pending udhaars';

  @override
  String get finRecoveryHistory => 'Recovery History';

  @override
  String get finNoRecoveriesYet => 'No recoveries recorded yet.';

  @override
  String finRecoveryNumber(int number) {
    return 'Recovery #$number';
  }

  @override
  String finErrorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get finOverdue => 'Overdue';

  @override
  String get finDueToday => 'Due Today';

  @override
  String get finNext7Days => 'Next 7 Days';

  @override
  String get finNoPendingPayments7Days =>
      'No pending payments in the next 7 days';

  @override
  String get finPaidLast7Days => 'Paid Last 7 Days';

  @override
  String get finNoPaymentsRecorded7Days =>
      'No payments recorded in the last 7 days';

  @override
  String get finSuppliers => 'Suppliers';

  @override
  String get finAddEditSuppliersHint =>
      'Add or edit suppliers in the Purchase tab';

  @override
  String get finNoSuppliersYet => 'No suppliers yet.';

  @override
  String get finTotalOutstanding => 'Total Outstanding';

  @override
  String get finToday => 'Today';

  @override
  String get finPaid7d => 'Paid (7d)';

  @override
  String get finStockPurchase => 'Stock Purchase';

  @override
  String finOverdueSince(String date) {
    return 'Overdue since $date';
  }

  @override
  String finDueOn(String day) {
    return 'Due $day';
  }

  @override
  String get finDueTodayLabel => 'Due today';

  @override
  String get finToPay => 'to pay';

  @override
  String get finDetails => 'Details';

  @override
  String get finMarkPaid => 'Mark Paid';

  @override
  String finPurchaseOn(String date) {
    return 'Purchase on $date';
  }

  @override
  String get finNoItemsFound => 'No items found.';

  @override
  String get finTotalBill => 'Total Bill';

  @override
  String get finTomorrow => 'Tomorrow';

  @override
  String get finWeekdayMon => 'Mon';

  @override
  String get finWeekdayTue => 'Tue';

  @override
  String get finWeekdayWed => 'Wed';

  @override
  String get finWeekdayThu => 'Thu';

  @override
  String get finWeekdayFri => 'Fri';

  @override
  String get finWeekdaySat => 'Sat';

  @override
  String get finWeekdaySun => 'Sun';

  @override
  String get finFailedLoadCashflow => 'Failed to load cashflow data';

  @override
  String get finIncome => 'Income';

  @override
  String get finTodaysSales => 'Today\'s Sales';

  @override
  String get finCreditExposureUdhaar => 'Credit Exposure (Udhaar)';

  @override
  String get finOutstanding => 'Outstanding';

  @override
  String get finCustomersWithPendingDues => 'Customers with pending dues';

  @override
  String finCustomersCount(int count) {
    return '$count customers';
  }

  @override
  String get finCreditVsSalesRatio => 'Credit vs Sales Ratio';

  @override
  String finPercentOnCredit(String value) {
    return '$value% on credit';
  }

  @override
  String finOfMonthly(String value) {
    return 'of $value monthly';
  }

  @override
  String get finCreditHealthy => 'Healthy — credit exposure is low';

  @override
  String get finCreditModerate => 'Moderate — consider collecting dues';

  @override
  String get finCreditHigh => 'High — many sales are on credit';

  @override
  String get finConsentTitle => 'Record customer consent';

  @override
  String get finConsentSubtitle => 'Voice confirmation of this udhaar';

  @override
  String get finConsentScriptIntro => 'ASK THE CUSTOMER TO SAY:';

  @override
  String finConsentScript(String total, String udhaar, String date) {
    return 'I agree — total $total, udhaar $udhaar, I will repay by $date.';
  }

  @override
  String get finConsentTapToRecord => 'Tap the mic and let the customer speak';

  @override
  String get finConsentRecording => 'Recording';

  @override
  String get finConsentSaved => 'Consent saved — uploading in background';

  @override
  String get finConsentSkip => 'Skip';

  @override
  String get finConsentSectionTitle => 'Voice consent';

  @override
  String get finConsentStatusPending => 'Uploaded · analysis pending';

  @override
  String get finConsentStatusAnalyzed => 'Verified';

  @override
  String finConsentMatchScore(String pct) {
    return 'Voice match: $pct%';
  }

  @override
  String get finConsentNone => 'No voice consent recorded';

  @override
  String get finDueDate => 'Repayment due date';

  @override
  String get finDueDateHint => 'When will the customer repay?';

  @override
  String finDueBy(String date) {
    return 'Due by $date';
  }

  @override
  String finClearingDues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dues',
      one: '1 due',
    );
    return 'Clearing $_temp0…';
  }

  @override
  String finDuesCleared(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dues cleared',
      one: '1 due cleared',
    );
    return '$_temp0';
  }

  @override
  String finClearingDuesProgress(int cleared, int total) {
    return 'Clearing dues: $cleared/$total';
  }

  @override
  String finDuesClearFailed(int cleared, int total) {
    return 'Couldn\'t clear all dues ($cleared/$total)';
  }

  @override
  String get finSmartReminders => 'Smart Reminders';

  @override
  String get finCouldNotLoadReminders => 'Could not load reminders';

  @override
  String finDaysPending(int days) {
    return '$days days pending';
  }

  @override
  String finRiskBadge(String band) {
    return '$band RISK';
  }

  @override
  String finLikelyToRecover(int percent) {
    return '~$percent% likely to recover';
  }

  @override
  String get finSendReminder => 'Send reminder';

  @override
  String finReminderSentTo(String name) {
    return 'Reminder sent to $name';
  }

  @override
  String get finCouldNotSendReminder => 'Could not send reminder';

  @override
  String get finNoOpenUdhaar => 'No open udhaar';

  @override
  String get finAllCreditSettled => 'All credit is settled. Nice and clean!';

  @override
  String get procAddSupplierFirstToCreatePo =>
      'Add a supplier first to create a purchase order';

  @override
  String procErrorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get procSuppliers => 'Suppliers';

  @override
  String get procNoSuppliersYet => 'No suppliers added yet.';

  @override
  String get procRecentPurchases => 'Recent Purchases';

  @override
  String get procAddAtLeastOneSupplier =>
      'If you want to add a purchase, add at least 1 supplier.';

  @override
  String get procNoPurchaseOrdersYet => 'No purchase orders yet.';

  @override
  String get procScanInvoice => 'Scan Invoice';

  @override
  String get procAdd => 'Add';

  @override
  String get procSuggestedReorders => 'Suggested Reorders';

  @override
  String get procRunningLowLast30Days =>
      'Running low based on the last 30 days of sales';

  @override
  String get procAddNewSupplier => 'Add New Supplier';

  @override
  String get procContacts => 'Contacts';

  @override
  String get procSupplierName => 'Supplier Name';

  @override
  String get procPhoneNumber => 'Phone Number';

  @override
  String get procCategoryHint => 'Category (e.g. Dairy, FMCG)';

  @override
  String get procEnterValidPhone => 'Enter a valid phone number';

  @override
  String get procSaveSupplier => 'Save Supplier';

  @override
  String get procEditSupplier => 'Edit Supplier';

  @override
  String get procSaveChanges => 'Save Changes';

  @override
  String get procNewPurchaseOrder => 'New Purchase Order';

  @override
  String get procRecordItemsFromDistributor =>
      'Record items purchased from a distributor.';

  @override
  String get procOrderDetails => 'Order Details';

  @override
  String get procDistributor => 'Distributor';

  @override
  String get procPaymentDueDate => 'Payment Due Date';

  @override
  String get procSelectDate => 'Select Date';

  @override
  String procItemsCount(int count) {
    return 'Items ($count)';
  }

  @override
  String get procAddItem => 'Add Item';

  @override
  String get procNoItemsAddedYet => 'No items added yet';

  @override
  String get procNotes => 'Notes';

  @override
  String get procNotesHint => 'Bill number, delivery notes, etc.';

  @override
  String get procTotalAmount => 'Total Amount';

  @override
  String get procSaveOrder => 'Save Order';

  @override
  String get procSearchProduct => 'Search product...';

  @override
  String procAddProduct(String name) {
    return 'Add $name';
  }

  @override
  String get procQuantity => 'Quantity';

  @override
  String get procCostPricePerUnit => 'Cost Price per unit';

  @override
  String get procCancel => 'Cancel';

  @override
  String procDaysCover(String days) {
    return '${days}d cover';
  }

  @override
  String procOrderQty(String qty) {
    return 'Order $qty';
  }

  @override
  String procStockLine(String stock, String perDay, String cover) {
    return 'Stock $stock · ~$perDay/day · $cover';
  }

  @override
  String get procCreatePurchaseOrder => 'Create purchase order';

  @override
  String get procEditSupplierTooltip => 'Edit supplier';

  @override
  String get procMarkAsReceived => 'Mark as Received';

  @override
  String get procPleaseSelectSupplierFirst => 'Please select a supplier first';

  @override
  String get procFromScannedInvoice => 'From scanned invoice';

  @override
  String procPoCreatedWithUnmatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Purchase order created! ($count item$_temp0 not matched)';
  }

  @override
  String get procPoCreatedFromInvoice => 'Purchase order created from invoice!';

  @override
  String get procCameraGalleryPdf => 'Camera · Gallery · PDF';

  @override
  String get procScansLabel => 'scans';

  @override
  String get procScanAgain => 'Scan again';

  @override
  String get procInvoiceScanProFeature => 'Invoice Scan is a Pro feature.';

  @override
  String get procUpgradeToPro => 'Upgrade to Pro';

  @override
  String get procDailyLimitReached =>
      'Daily limit reached. Top up credits to continue.';

  @override
  String get procBuyCredits => 'Buy Credits';

  @override
  String get procCreatingPurchaseOrder => 'Creating purchase order…';

  @override
  String get procPurchaseOrderCreated => 'Purchase order created!';

  @override
  String get procTryAgain => 'Try Again';

  @override
  String get procCaptureOrUploadInvoice =>
      'Capture or upload a supplier invoice';

  @override
  String get procUpgradeOrTopUp => 'Upgrade to Pro or top up credits';

  @override
  String get procKiranaAiReadsInvoice =>
      'Outlet AI reads items, totals & supplier details';

  @override
  String get procCamera => 'Camera';

  @override
  String get procGallery => 'Gallery';

  @override
  String get procUploadPdfImageFile => 'Upload PDF / Image File';

  @override
  String get procKiranaAiReadingInvoice => 'Outlet AI is reading your invoice…';

  @override
  String get procExtractingItems => 'Extracting items, quantities and totals';

  @override
  String get procGrandTotal => 'Grand Total';

  @override
  String get procSupplierUpper => 'SUPPLIER';

  @override
  String procItemsUpperCount(int count) {
    return 'ITEMS ($count)';
  }

  @override
  String procMatchedCount(int count) {
    return '$count matched';
  }

  @override
  String procUnmatchedItemsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count unmatched item$_temp0 will not be added as line items, but the full invoice total will be recorded.';
  }

  @override
  String get procSelectSupplierToContinue => 'Select a supplier to continue';

  @override
  String get procCreatePurchaseOrderTitle => 'Create Purchase Order';

  @override
  String procConfidencePercent(int pct) {
    return '$pct% confidence';
  }

  @override
  String get procTotalsMatch => '✓ Totals match';

  @override
  String get procTotalMismatch => '⚠ Total mismatch';

  @override
  String get procUnverified => 'Unverified';

  @override
  String get procPick => 'Pick';

  @override
  String procNoMatchTapToSelect(String vendor) {
    return 'No match for \"$vendor\" — tap to select';
  }

  @override
  String get procSelectSupplier => 'Select supplier';

  @override
  String get procSelectSupplierTitle => 'Select Supplier';

  @override
  String get procNoSuppliersAddInPurchaseTab =>
      'No suppliers yet. Add suppliers in the Purchase tab.';

  @override
  String get procLinkToInventory => 'Link to Inventory';

  @override
  String get procSearchProducts => 'Search products…';

  @override
  String get procNoProductsFound => 'No products found';

  @override
  String procPriceStockLabel(String price, String stock) {
    return '$price · Stock: $stock';
  }

  @override
  String get procMicPermissionDenied =>
      'Microphone permission denied. Please enable it in Settings.';

  @override
  String get procMicNotAccessible => 'Microphone not accessible.';

  @override
  String procAddedToCartFromVoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count item$_temp0 added to cart from voice order';
  }

  @override
  String get procVoiceOrder => 'Voice Order';

  @override
  String get procSpeakAnyIndianLanguage => 'Speak in any Indian language';

  @override
  String get procVoiceOrderProFeature =>
      'Voice Order is a Pro feature. Upgrade to access.';

  @override
  String get procUpgrade => 'Upgrade';

  @override
  String get procNoVoiceOrdersLeft =>
      'No voice orders left today. Get more credits.';

  @override
  String get procGetCredits => 'Get Credits';

  @override
  String get procVoiceLabel => 'voice';

  @override
  String get procTapMicToStart => 'Tap mic to start recording';

  @override
  String get procTapToStopAndProcess => 'Tap to stop & process';

  @override
  String get procKiranaAiProcessing => 'Outlet AI is processing…';

  @override
  String get procHeard => 'Heard';

  @override
  String get procNoItemsDetectedTryAgain =>
      'No items detected. Please try again.';

  @override
  String get procRecordAgain => 'Record Again';

  @override
  String procAddToCartCount(int count) {
    return 'Add $count to Cart';
  }

  @override
  String get procAutoDetectsLanguages =>
      'Auto-detects: Telugu · Hindi · Urdu · Tamil · Kannada · Malayalam · English';

  @override
  String get procInStock => 'In stock';

  @override
  String get procLowStock => 'Low stock';

  @override
  String get procNotFound => 'Not found';

  @override
  String get procPickFromInventory => 'Pick from Inventory';

  @override
  String procAddedToCartFromHandwriting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count item$_temp0 added to cart from handwriting';
  }

  @override
  String get procCanvasNotReady => 'Canvas not ready';

  @override
  String get procFailedToCaptureCanvas => 'Failed to capture canvas';

  @override
  String get procHandwriteOrder => 'Handwrite Order';

  @override
  String get procWriteItemsAnyScript => 'Write items in any script';

  @override
  String get procDrawsLabel => 'draws';

  @override
  String get procUndoLastStroke => 'Undo last stroke';

  @override
  String get procClear => 'Clear';

  @override
  String get procHandwriteOrderProFeature =>
      'Handwrite Order is a Pro feature.';

  @override
  String get procAutoDetectAfter5s => 'Auto-detect after 5s';

  @override
  String get procWriteItemsHere => 'Write items here';

  @override
  String get procUpgradeOrTopUpToWrite => 'Upgrade or top up to write';

  @override
  String get procHandwriteExample => 'e.g. Rice 5kg, Sugar 2kg';

  @override
  String get procDetecting => 'Detecting…';

  @override
  String get procDetectItems => 'Detect Items';

  @override
  String get procRead => 'Read';

  @override
  String get procNoItemsDetectedWriteClearly =>
      'No items detected. Try writing more clearly.';

  @override
  String get procWriteAgain => 'Write Again';

  @override
  String get procAnyScriptLanguages =>
      'Any script: English · తెలుగు · हिंदी · Tamil · ಕನ್ನಡ · മലയാളം';

  @override
  String procProductNumber(String id) {
    return 'Product #$id';
  }

  @override
  String get procReturnExchange => 'Return / Exchange';

  @override
  String procOrderPickItemsToReturn(String id) {
    return 'Order #$id · pick items to return';
  }

  @override
  String get procRecordReturn => 'Record return';

  @override
  String procBoughtQty(String qty) {
    return 'bought $qty ';
  }

  @override
  String get procBackToShelf => 'Back to shelf';

  @override
  String get procResaleable => 'Resaleable';

  @override
  String get procDamagedToVendor => 'Damaged → vendor';

  @override
  String procReturnRecordedShelf(int count) {
    return 'Return recorded — $count back to shelf';
  }

  @override
  String procReturnToVendorSuffix(int count) {
    return ', $count to vendor';
  }

  @override
  String get procCouldNotRecordReturn => 'Could not record return';

  @override
  String get subYourInsights => 'Your Insights';

  @override
  String get subError => 'Error';

  @override
  String get subManageKpis => 'Manage KPIs';

  @override
  String get subManageSubscriptions => 'Manage subscriptions';

  @override
  String get subDone => 'Done';

  @override
  String subKpisSelected(int n) {
    return '$n KPIs selected';
  }

  @override
  String get subSelectAll => 'Select All';

  @override
  String get subClear => 'Clear';

  @override
  String get subUnselect => 'Unselect';

  @override
  String subProKpiName(String name) {
    return 'Pro KPI: $name';
  }

  @override
  String get subConfirmSelections => 'Confirm Selections';

  @override
  String get subNoActiveKpis => 'No active KPIs';

  @override
  String get subManageToSeeInsights =>
      'Manage your subscriptions to see insights';

  @override
  String get subFailedLoadInsights => 'Failed to load live insights';

  @override
  String get subManageInventory => 'Manage Inventory';

  @override
  String get subSendReminders => 'Send Reminders';

  @override
  String get subReminderMessage =>
      'Hi, this is a reminder regarding your business with us. Please check your latest updates.';

  @override
  String get subNewSale => 'New Sale';

  @override
  String get subAiSummary => 'AI Summary';

  @override
  String subPoweredBy(String agent) {
    return 'Powered by $agent';
  }

  @override
  String get subTarget => 'Target';

  @override
  String get subBaseline => 'Baseline';

  @override
  String get subLiveDataBreakdown => 'Live Data Breakdown';

  @override
  String get subMlInsights => 'MI Insights';

  @override
  String get subNoDynamicInsights =>
      'No dynamic insights available for this KPI.';

  @override
  String subPctVsLastPeriod(String pct) {
    return '$pct% vs last period';
  }

  @override
  String get subCurrent => 'current';

  @override
  String get subWhyThisValue => 'Why this value?';

  @override
  String get subSomethingWentWrong => 'Oops! Something went wrong';

  @override
  String get subRetry => 'Retry';

  @override
  String get subSubscriptionAndPlans => 'Subscription & Plans';

  @override
  String subErrorWithDetail(String detail) {
    return 'Error: $detail';
  }

  @override
  String get subCancelSubscriptionTitle => 'Cancel Subscription?';

  @override
  String get subCancelSubscriptionBody =>
      'Your subscription will be cancelled immediately. You can re-subscribe at any time.';

  @override
  String get subKeepPlan => 'Keep Plan';

  @override
  String get subCancelSubscription => 'Cancel Subscription';

  @override
  String get subSubscriptionCancelled => 'Subscription cancelled.';

  @override
  String subCancelFailed(String detail) {
    return 'Cancel failed: $detail';
  }

  @override
  String get subChooseYourPlan => 'CHOOSE YOUR PLAN';

  @override
  String get subFeaturePosSales => 'POS & Sales Management';

  @override
  String get subFeatureInventoryTracking => 'Inventory Tracking';

  @override
  String get subFeatureFinanceUdhaar => 'Finance & Udhaar';

  @override
  String get subFeatureKpiInsights => 'KPI Insights (3 per category)';

  @override
  String get subFeatureCustomerRelations => 'Customer Relations';

  @override
  String get subFeatureAiRecommendations => 'AI Recommendations';

  @override
  String get subFeatureAllKpiCategories => 'All KPI Categories (unlimited)';

  @override
  String get subFeatureVendorProcurement => 'Vendor & Procurement Management';

  @override
  String get subFeatureCashflowSupport => 'Cashflow Support (up to ₹10L)';

  @override
  String get subFeatureCustomerGrowth => 'Customer Growth Engine';

  @override
  String get subPerMonth => '/month';

  @override
  String get subRestorePurchases => 'Restore Purchases';

  @override
  String get subNeedHelp => 'Need help?';

  @override
  String get subReachWhatsApp =>
      'Reach us on WhatsApp for plan queries or billing support.';

  @override
  String get subWhatsAppSupport => 'WhatsApp Support';

  @override
  String get subWhatsAppHelpMessage =>
      'Hi! I need help with my Outlet AI subscription.';

  @override
  String subCurrentPlanLabel(String plan) {
    return 'Current: $plan';
  }

  @override
  String get subTimeRemaining => 'Time remaining: ';

  @override
  String get subBest => 'BEST';

  @override
  String subJustPerDay(String price) {
    return 'just $price/day';
  }

  @override
  String get subTrialPlanNotice =>
      'You\'re on a free trial of this plan. Upgrade to keep access after trial ends.';

  @override
  String get subCurrentPlan => 'Current Plan';

  @override
  String subUpgradeToKeepAccess(String name) {
    return 'Upgrade to Keep $name Access';
  }

  @override
  String subPayAndActivate(String name) {
    return 'Pay & Activate $name';
  }

  @override
  String get subPaywallFeatureEverythingBasic => 'Everything in Basic';

  @override
  String get subPaywallFeaturePriorityAi => 'Priority AI recommendations';

  @override
  String get subProFeature => 'PRO FEATURE';

  @override
  String get subProPlanIncludes => 'Pro Plan includes:';

  @override
  String get subNotNow => 'Not Now';

  @override
  String get subUpgradeToProPrice => 'Upgrade to Pro  ₹500/mo · just ₹17/day';

  @override
  String get subInvoicePack => 'Invoice Pack';

  @override
  String get subVoicePack => 'Voice Pack';

  @override
  String get subHandwritingPack => 'Handwriting Pack';

  @override
  String get subInvoicePackDesc => 'Process 10 more supplier bills';

  @override
  String get subVoicePackDesc => 'Add 10 more audio/voice orders';

  @override
  String get subHandwritingPackDesc => 'Scan 10 more handwritten notes';

  @override
  String get subPrice => 'Price';

  @override
  String get subCreditsRollOverDaily =>
      'Credits do not expire — they roll over each day.';

  @override
  String get subCancel => 'Cancel';

  @override
  String subPayAmount(int amount) {
    return 'Pay ₹$amount';
  }

  @override
  String subCreditsAdded(int count, String name) {
    return '$count $name credits added!';
  }

  @override
  String get subTopUpCredits => 'Top Up Your Credits';

  @override
  String get subCreditsNeverExpire =>
      'Credits never expire — they roll over to tomorrow!';

  @override
  String subCreditsCount(int count) {
    return '$count credits';
  }

  @override
  String get subBuy => 'Buy';

  @override
  String get subTrialExpiredMessage =>
      'Your free trial has expired. Upgrade to continue.';

  @override
  String get subTrialLastDayMessage =>
      'Last day of your free trial! Upgrade now.';

  @override
  String subTrialDaysLeftMessage(int n) {
    return '$n days left in your trial. Upgrade to Basic or Pro.';
  }

  @override
  String get subTrialExpiringSoon => 'Trial Expiring Soon';

  @override
  String get subTrialExpiredTitle => 'Trial Expired';

  @override
  String get mktMyBaskets => 'My Baskets';

  @override
  String get mktCouldNotLoadBaskets => 'Could not load baskets';

  @override
  String get mktPullDownToRetry => 'Pull down to retry';

  @override
  String get mktRetry => 'Retry';

  @override
  String get mktNewBasket => 'New Basket';

  @override
  String get mktNoBasketsYet => 'No baskets yet';

  @override
  String get mktBasketsEmptySubtitle =>
      'Create combo deals and bundle offers.\nAlert all your customers via WhatsApp.';

  @override
  String get mktCreateFirstBasket => 'Create First Basket';

  @override
  String get mktDeleteBasketTitle => 'Delete Basket?';

  @override
  String mktDeleteBasketConfirm(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get mktCancel => 'Cancel';

  @override
  String get mktBasketDeleted => 'Basket deleted';

  @override
  String get mktCouldNotDeleteBasket =>
      'Could not delete basket. Please try again.';

  @override
  String get mktDelete => 'Delete';

  @override
  String get mktSendWhatsAppAlertTitle => 'Send WhatsApp Alert?';

  @override
  String mktSendWhatsAppAlertConfirm(String name) {
    return 'Send basket deal for \"$name\" to all your customers via WhatsApp?';
  }

  @override
  String get mktSend => 'Send';

  @override
  String mktWhatsAppAlertSent(int sent, int total) {
    return 'WhatsApp alert sent to $sent of $total customers!';
  }

  @override
  String get mktNoCustomersWithPhone =>
      'No customers with phone numbers found.';

  @override
  String mktWhatsAppNotActiveYet(int total) {
    return 'WhatsApp not active yet. Alert will auto-send to $total customers once enabled.';
  }

  @override
  String mktAlertFailed(String error) {
    return 'Failed: $error';
  }

  @override
  String get mktExpired => 'Expired';

  @override
  String get mktItem => 'Item';

  @override
  String mktFromDate(String date) {
    return 'From $date';
  }

  @override
  String mktToDate(String date) {
    return 'To $date';
  }

  @override
  String get mktAlertCustomers => 'Alert Customers';

  @override
  String get mktNoProductsInInventory =>
      'No products in inventory. Please sync POS first.';

  @override
  String get mktAllProductsAdded => 'All products already added to this basket';

  @override
  String get mktBasketNameRequired => 'Basket name is required';

  @override
  String get mktAddAtLeastOneProduct =>
      'Add at least one product from inventory';

  @override
  String get mktSave => 'Save';

  @override
  String get mktBasketNameLabel => 'Basket Name *';

  @override
  String get mktBasketNameHint => 'e.g. Breakfast Bundle';

  @override
  String get mktDescriptionOptional => 'Description (optional)';

  @override
  String get mktDescriptionHint => 'e.g. Milk + Bread + Eggs';

  @override
  String get mktBundlePriceOptional => 'Bundle Price (optional)';

  @override
  String get mktValidity => 'VALIDITY';

  @override
  String get mktFromDateLabel => 'From date';

  @override
  String get mktToDateLabel => 'To date';

  @override
  String get mktProducts => 'PRODUCTS';

  @override
  String get mktAddProduct => 'Add Product';

  @override
  String get mktTapToPickProducts => 'Tap to pick products from your inventory';

  @override
  String mktPricePerUnit(String price) {
    return '₹$price / unit';
  }

  @override
  String get mktQty => 'Qty';

  @override
  String get mktCreateBasket => 'Create Basket';

  @override
  String get mktSelectProduct => 'Select Product';

  @override
  String get mktSearchProducts => 'Search products...';

  @override
  String get mktNoProductsFound => 'No products found';

  @override
  String get mktAdd => 'Add';

  @override
  String get mktEstTotal => 'est. total';

  @override
  String get mktAddAll => 'Add All';

  @override
  String get mktNotInStock => 'Not in stock';

  @override
  String mktCampaignItemStock(String qty, String unit, String price) {
    return 'Stock: $qty $unit  ·  ₹$price';
  }

  @override
  String get mktEstimatedTotal => 'Estimated Total';

  @override
  String get mktNoItemsInStock => 'No items in stock';

  @override
  String mktAddAvailableItemsToCart(int count) {
    return 'Add $count Available Items to Cart';
  }

  @override
  String get mktAreaAssociations => 'Area Associations';

  @override
  String get mktMyAreas => 'My Areas';

  @override
  String get mktCustomerHeatmap => 'Customer Heatmap';

  @override
  String mktErrorWithMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get mktNoAreasAddedYet => 'No areas added yet';

  @override
  String get mktAreasEmptySubtitle =>
      'Add nearby apartments, hostels, schools or offices to get targeted campaign suggestions.';

  @override
  String get mktAddFirstArea => 'Add First Area';

  @override
  String get mktRemoveAreaTitle => 'Remove Area?';

  @override
  String mktRemoveAreaConfirm(String name) {
    return 'Remove \"$name\" from your associations?';
  }

  @override
  String get mktRemove => 'Remove';

  @override
  String mktHouseholdsCount(int count) {
    return '~$count households';
  }

  @override
  String get mktNoHeatmapDataYet => 'No heatmap data yet';

  @override
  String get mktHeatmapEmptySubtitle =>
      'Add areas and tag customers to those areas. Revenue data will appear here over time.';

  @override
  String get mktLast90DaysByRevenue => 'Last 90 days · by revenue';

  @override
  String get mktCustomers => 'customers';

  @override
  String get mktOrders => 'orders';

  @override
  String get mktAvgOrder => 'avg order';

  @override
  String get mktNoOrdersYetTagCustomers =>
      'No orders yet — tag customers to this area to track';

  @override
  String get mktAddNearbyArea => 'Add Nearby Area';

  @override
  String get mktAreaType => 'Area Type';

  @override
  String get mktAreaNameLabel => 'Name (e.g. Prestige Apartments)';

  @override
  String get mktEstimatedHouseholdsOptional =>
      'Estimated households (optional)';

  @override
  String get mktNotesOptional => 'Notes (optional)';

  @override
  String get mktAddArea => 'Add Area';

  @override
  String get mktCustomerGrowth => 'Customer Growth';

  @override
  String get mktNewCampaign => 'New Campaign';

  @override
  String get mktNoCampaignsYet => 'No Campaigns Yet';

  @override
  String get mktReferralEmptySubtitle =>
      'Create a referral campaign to let your existing customers bring in new ones — and reward them for it.';

  @override
  String get mktCreateFirstCampaign => 'Create First Campaign';

  @override
  String get mktReferralHowItWorks =>
      'Customers share their QR with friends. New visitors scan it in POS to get a discount — and the referrer earns milestone rewards.';

  @override
  String mktCampaignSummary(String discount, String reward, int n) {
    return '$discount% off for new customers  •  $reward% reward every $n refs';
  }

  @override
  String get mktQrCodes => 'QR Codes';

  @override
  String get mktReferrals => 'Referrals';

  @override
  String get mktMaxPerPerson => 'Max/person';

  @override
  String get mktGenerateQr => 'Generate QR';

  @override
  String mktGenerateQrTitle(String name) {
    return 'Generate QR · $name';
  }

  @override
  String get mktSearchCustomer => 'Search customer…';

  @override
  String get mktNoCustomersFound => 'No customers found';

  @override
  String get mktNoPhoneForCustomer => 'No phone number for this customer';

  @override
  String mktReferralWhatsAppMessage(
    String name,
    String code,
    String discount,
    int n,
  ) {
    return 'Hi $name! 🎁\n\nYou\'re invited to share our store with your friends!\n\nYour referral code: $code\n\nWhen your friend visits our store and shows this code, they get $discount% off — and you earn rewards for every $n friends you bring! 🙌\n\n— via LohiyaAI Kirana';
  }

  @override
  String get mktWhatsAppNotInstalled => 'WhatsApp not installed on this device';

  @override
  String get mktReferralQrCode => 'Referral QR Code';

  @override
  String mktPercentOffForNewCustomers(String discount) {
    return '$discount% off for new customers';
  }

  @override
  String mktMilestoneRewardLabel(String reward, int n) {
    return 'Milestone reward: $reward% every $n referrals';
  }

  @override
  String get mktReferralCodeCopied => 'Referral code copied';

  @override
  String get mktSendViaWhatsApp => 'Send via WhatsApp';

  @override
  String get mktQrScreenshotHint =>
      'Or show this QR screen directly to the customer for them to screenshot.';

  @override
  String get mktInvalidQrCode => 'Invalid QR code';

  @override
  String get mktCampaignNoLongerActive =>
      'This referral campaign is no longer active';

  @override
  String get mktCouldNotLoadReferralInfo => 'Could not load referral info';

  @override
  String get mktEnterValidPhone => 'Enter a valid 10-digit phone number';

  @override
  String get mktClose => 'Close';

  @override
  String mktReferralFrom(String name) {
    return 'Referral from $name';
  }

  @override
  String mktCampaignDiscountForNewCustomer(String campaign, String discount) {
    return '$campaign  •  $discount% discount for new customer';
  }

  @override
  String get mktNewCustomerDetails => 'New Customer Details';

  @override
  String get mktNewCustomerPhoneHelper =>
      'Enter the new customer\'s phone. The discount will be applied when you place the order.';

  @override
  String get mktPhoneNumber => 'Phone Number';

  @override
  String get mktCustomerNameOptional => 'Customer Name (optional)';

  @override
  String get mktCustomerNameHint => 'e.g. Gnyan Kumar';

  @override
  String mktApplyReferralDiscount(String discount) {
    return 'Apply $discount% Referral Discount';
  }

  @override
  String get mktCampaignNameRequired => 'Campaign name is required';

  @override
  String get mktEnterValidDiscount => 'Enter a valid discount % (1–100)';

  @override
  String get mktMilestoneCountMin => 'Milestone count must be at least 1';

  @override
  String get mktEnterValidReward => 'Enter a valid reward % (1–100)';

  @override
  String get mktMaxReferralsMin => 'Max referrals must be at least 1';

  @override
  String get mktFailedToCreateCampaign =>
      'Failed to create campaign. Please try again.';

  @override
  String get mktNewReferralCampaign => 'New Referral Campaign';

  @override
  String get mktCampaignName => 'Campaign Name';

  @override
  String get mktCampaignNameHint => 'e.g. Summer Referral Drive';

  @override
  String get mktNewCustomerDiscountPct => 'New Customer Discount %';

  @override
  String get mktMilestoneRewardPct => 'Milestone Reward %';

  @override
  String get mktRewardEveryNReferrals => 'Reward Every N Referrals';

  @override
  String get mktRewardEveryNHelper =>
      'Referrer earns a milestone reward every N new customers they bring';

  @override
  String get mktMaxReferralsPerCustomer => 'Max Referrals per Customer';

  @override
  String get mktMaxReferralsHelper =>
      'Stop rewarding a customer after this many successful referrals';

  @override
  String get mktCreateCampaign => 'Create Campaign';

  @override
  String get profProfile => 'Profile';

  @override
  String profErrorLoadingProfile(String error) {
    return 'Error loading profile: $error';
  }

  @override
  String get profNoUserData => 'No user data found.';

  @override
  String get profCashflowSupport => 'Cashflow Support';

  @override
  String get profCashflowSupportDesc =>
      'Apply for ₹50K – ₹10L business finance with tailored repayment plans.';

  @override
  String get profCashflowBannerSubtitle =>
      'Apply for ₹50K – ₹10L business finance';

  @override
  String get profSectionCustomers => 'Customers';

  @override
  String get profSectionAnalytics => 'Analytics';

  @override
  String get profSectionStoreAccount => 'Store & Account';

  @override
  String get profSectionPlanSupport => 'Plan & Support';

  @override
  String get profSectionAdmin => 'Admin';

  @override
  String get profCustomerGrowth => 'Customer Growth';

  @override
  String get profCustomerGrowthDesc =>
      'Build a referral engine — let your happy customers bring in new ones automatically.';

  @override
  String get profCustomerRelations => 'Customer Relations';

  @override
  String get profAreaAssociations => 'Area Associations';

  @override
  String get profKpiSubscriptions => 'KPI Subscriptions';

  @override
  String get profTransactionHistory => 'Transaction History';

  @override
  String get profMyBaskets => 'My Baskets';

  @override
  String get profLoyalty => 'Loyalty & Offers';

  @override
  String get profServices => 'Services & Appointments';

  @override
  String get profStoreComparison => 'Store Comparison';

  @override
  String get profStaff => 'Staff';

  @override
  String get profEstimatesReturns => 'Estimates & Returns';

  @override
  String get profStockRacks => 'Stock Racks';

  @override
  String get profJobCards => 'Job Cards';

  @override
  String get profWarranty => 'Warranty & Serials';

  @override
  String get profGstReport => 'GST Report';

  @override
  String get profLanguage => 'Language';

  @override
  String get profStoreSettings => 'Store Settings';

  @override
  String get profSwitchStore => 'Switch / add store';

  @override
  String get profConfiguration => 'Configuration';

  @override
  String get profPasswordSecurity => 'Password & Security';

  @override
  String get profSubscriptionPlans => 'Subscription & Plans';

  @override
  String get profHelpSupport => 'Help & Support';

  @override
  String get profUserActivity => 'User Activity';

  @override
  String get profSignOut => 'Sign Out';

  @override
  String get profTrialExpired => 'Trial Expired';

  @override
  String get profAwaitingActivation => 'Awaiting Activation';

  @override
  String get profProTrial => 'Pro Trial';

  @override
  String get profBasicTrial => 'Basic Trial';

  @override
  String profTrialDaysLeft(String tier, int days) {
    return '$tier · ${days}d left';
  }

  @override
  String profTrialActive(String tier) {
    return '$tier Active';
  }

  @override
  String get profBasicPlan => 'Basic Plan';

  @override
  String get profProPlan => 'Pro Plan';

  @override
  String get profSyncContacts => 'Sync Contacts';

  @override
  String get profRefreshList => 'Refresh List';

  @override
  String get profAddCustomer => 'Add Customer';

  @override
  String get profSearchByNameOrPhone => 'Search by name or phone...';

  @override
  String get profRetry => 'Retry';

  @override
  String profNoSegmentCustomers(String segment) {
    return 'No $segment customers';
  }

  @override
  String get profNoCustomersFound => 'No customers found.';

  @override
  String get profSegRegular => 'Regular';

  @override
  String get profSegOccasional => 'Occasional';

  @override
  String get profSegImpulse => 'Impulse';

  @override
  String get profSegBulk => 'Bulk';

  @override
  String get profSegCredit => 'Credit';

  @override
  String get profSegInactive => 'Inactive';

  @override
  String get profSyncContactsTitle => 'Sync Contacts?';

  @override
  String get profSyncContactsBody =>
      'This will import your phone contacts into your customer list. Regular customers will be matched by phone number.';

  @override
  String get profCancel => 'Cancel';

  @override
  String get profSyncNow => 'Sync Now';

  @override
  String profSyncedContacts(int count) {
    return 'Synced $count contacts successfully!';
  }

  @override
  String profSyncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get profSendWhatsappReengagement => 'Send WhatsApp Re-engagement';

  @override
  String profWhatsappReengagementMessage(String name) {
    return 'Hi $name! We miss you at our store. It\'s been a while since your last visit, and we have fresh stock and great deals waiting for you. Come visit us soon — your favourite items are ready! See you soon!';
  }

  @override
  String get profAddNewCustomer => 'Add New Customer';

  @override
  String get profEditCustomer => 'Edit Customer';

  @override
  String get profFullName => 'Full Name';

  @override
  String get profPhoneNumber => 'Phone Number';

  @override
  String get profEmailAddressOptional => 'Email Address (Optional)';

  @override
  String get profHouseholdSize => 'Household Size';

  @override
  String get profBirthdayOptional => 'Birthday (optional)';

  @override
  String get profAnniversaryOptional => 'Anniversary (optional)';

  @override
  String get profSaveCustomer => 'Save Customer';

  @override
  String get profFillNameAndPhone => 'Please fill name and phone';

  @override
  String get profEnterValidPhone => 'Enter a valid phone number (digits only)';

  @override
  String get profCustomerSaved => 'Customer saved successfully';

  @override
  String get profLoading => 'Loading...';

  @override
  String get profCustomerDetails => 'Customer Details';

  @override
  String get profStatBalance => 'Balance';

  @override
  String get profStatSpent => 'Spent';

  @override
  String get profStatOrders => 'Orders';

  @override
  String get profCustomerInfo => 'Customer Info';

  @override
  String profMembersCount(int count) {
    return '$count members';
  }

  @override
  String get profJoinedOn => 'Joined On';

  @override
  String get profUnknown => 'Unknown';

  @override
  String get profPurchaseHistory => 'Purchase History';

  @override
  String get profNoOrdersForCustomer => 'No orders found for this customer.';

  @override
  String profErrorLoadingOrders(String error) {
    return 'Error loading orders: $error';
  }

  @override
  String get profDeleteCustomerTitle => 'Delete Customer?';

  @override
  String profDeleteCustomerBody(String name) {
    return 'Are you sure you want to delete $name? This action cannot be undone.';
  }

  @override
  String get profDelete => 'Delete';

  @override
  String profFailedToUpdateArea(String error) {
    return 'Failed to update area: $error';
  }

  @override
  String get profAreaAssociation => 'Area / Association';

  @override
  String get profUnableToLoadAreas => 'Unable to load areas';

  @override
  String get profNoAreasTapToAdd => 'No areas — tap to add one';

  @override
  String get profNone => 'None';

  @override
  String profOrderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String get profSave => 'SAVE';

  @override
  String profError(String error) {
    return 'Error: $error';
  }

  @override
  String get profBasicInformation => 'Basic Information';

  @override
  String get profStoreName => 'Store Name';

  @override
  String get profStoreType => 'Store Type (e.g. Kirana, Supermarket)';

  @override
  String get profBusinessIntelligence => 'Business Intelligence';

  @override
  String get profFootfallAutoComputed =>
      'Average footfall is automatically computed based on your sales.';

  @override
  String get profProvideInitialValues =>
      'Provide initial values to help our AI optimize your business.';

  @override
  String get profAvgDailyFootfall => 'Avg Daily Footfall';

  @override
  String get profAiAutoUpdating => 'AI Auto-Updating';

  @override
  String get profMonthlyStockBudget => 'Monthly Stock Budget';

  @override
  String get profDailyExpenseBuffer => 'Daily Expense Buffer';

  @override
  String get profLocationDetails => 'Location Details';

  @override
  String get profCityArea => 'City / Area';

  @override
  String get profStateRegion => 'State / Region';

  @override
  String get profCity => 'City';

  @override
  String get profBusinessVertical => 'Business vertical';

  @override
  String get profRequired => 'Required';

  @override
  String get profSettingsSaved => 'Settings saved successfully!';

  @override
  String profFailedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get supSplashTagline => 'Smart business, smarter you';

  @override
  String get supBlockedAppTitle => 'App Temporarily Unavailable';

  @override
  String get supBlockedStoreTitle => 'Store Temporarily Unavailable';

  @override
  String get supBlockedBody =>
      'We are working to resolve this as soon as possible. If you need immediate help, tap the button below.';

  @override
  String get supBlockedContactUs => 'Contact Us';

  @override
  String get supBlockedEmailSubjectApp => 'App Access Issue — Outlet AI';

  @override
  String get supBlockedEmailSubjectStore => 'Store Access Issue — Outlet AI';

  @override
  String supBlockedEmailBody(String reason) {
    return 'Hello LohiyaAI Team,\n\nI am unable to access the Outlet AI app.\n\nDisplayed reason: $reason\n\nPlease help me restore access.\n\n— Kirana Owner';
  }

  @override
  String get supBlockedEmailFallback =>
      'Please email support@lohiyaai.com directly.';

  @override
  String get supSupportTitle => 'Help & Support';

  @override
  String get supSupportHeading => 'How can we help you?';

  @override
  String get supSupportSubheading => 'Get instant answers to your questions';

  @override
  String get supOptionFaqTitle => 'Frequently Asked Questions';

  @override
  String get supOptionFaqSubtitle => 'Common questions and answers';

  @override
  String get supOptionReportTitle => 'Report an Issue';

  @override
  String get supOptionReportSubtitle => 'Encountered a bug? let us know';

  @override
  String get supOptionChatTitle => 'Chat with us';

  @override
  String get supOptionChatSubtitle => 'Connect with our support team';

  @override
  String get supOptionEmailTitle => 'Email Support';

  @override
  String get supOptionEmailSubtitle => 'Send us an email directly';

  @override
  String get supChatComingSoon => 'Chat support coming soon!';

  @override
  String get supEmailUnableToOpen => 'Unable to open email app.';

  @override
  String get supEmailError => 'Something went wrong while opening email app.';

  @override
  String get supFaqTitle => 'FAQs';

  @override
  String get supFaqQ1 => 'How do I add a new product?';

  @override
  String get supFaqA1 =>
      'You can add products from the POS tab by clicking the + button, or from the Inventory tab. You can also scan a barcode to automatically fetch details if available.';

  @override
  String get supFaqQ2 => 'How does the Stockout Risk prediction work?';

  @override
  String get supFaqA2 =>
      'Our AI analyzes your past sales velocity and current stock levels. If it predicts you will run out of an item within the next 3-7 days, it flags it as a Stockout Risk.';

  @override
  String get supFaqQ3 => 'How do I manage customer credit (Khata)?';

  @override
  String get supFaqA3 =>
      'When placing an order, select a customer and choose \"Credit\" as the payment method. You can view all pending dues in the Finance -> Udhaar tab or Customer Relations section.';

  @override
  String get supFaqQ4 => 'Can I sync my phone contacts?';

  @override
  String get supFaqA4 =>
      'Yes! Go to Profile -> Customer Relations and click the Sync icon. This will import your regular shoppers into the app for easy credit tracking.';

  @override
  String get supFaqQ5 => 'What are KPI Subscriptions?';

  @override
  String get supFaqA5 =>
      'KPIs are key business metrics like Revenue, Margin, and Footfall. You can choose which metrics to monitor from the Profile -> Subscription section.';

  @override
  String get supFaqQ6 => 'How do I generate a daily sales report?';

  @override
  String get supFaqA6 =>
      'You can view today\'s performance on the Dashboard. For detailed past reports, visit the Transaction History section in your Profile.';

  @override
  String get supReportTitle => 'Report an Issue';

  @override
  String get supReportHeading => 'Describe the problem';

  @override
  String get supReportSubheading =>
      'Our team will review your report and fix it as soon as possible.';

  @override
  String get supReportCategoryLabel => 'ISSUE CATEGORY';

  @override
  String get supReportSummaryLabel => 'SHORT SUMMARY';

  @override
  String get supReportSummaryHint => 'e.g. App crashes when scanning barcode';

  @override
  String get supReportDescriptionLabel => 'DETAILED DESCRIPTION';

  @override
  String get supReportDescriptionHint =>
      'Provide details on how to reproduce the issue...';

  @override
  String get supReportSubmit => 'Submit Report';

  @override
  String get supReportFillFields => 'Please fill in all fields';

  @override
  String get supReportSubmittedTitle => 'Report Submitted';

  @override
  String get supReportSubmittedBody =>
      'Thank you for your feedback. Our team will look into it immediately.';

  @override
  String get supOk => 'OK';

  @override
  String supReportSubmitFailed(String error) {
    return 'Failed to submit report: $error';
  }

  @override
  String get supCategoryAppBug => 'App Bug';

  @override
  String get supCategoryPricing => 'Pricing Issue';

  @override
  String get supCategoryInventory => 'Inventory Mismatch';

  @override
  String get supCategoryAiFeedback => 'AI Recommendation Feedback';

  @override
  String get supCategoryPosError => 'POS Error';

  @override
  String get supCategoryFeatureRequest => 'Feature Request';

  @override
  String get supCategoryOther => 'Other';

  @override
  String get shrSavingChanges => 'Saving changes...';

  @override
  String get shrRetry => 'Retry';

  @override
  String get shrSavedSuccessfully => 'Saved successfully!';

  @override
  String get shrBusinessAlerts => 'Business Alerts';

  @override
  String get shrAllCaughtUp => 'All caught up!';

  @override
  String get shrNoUrgentAlerts => 'No urgent alerts at the moment.';

  @override
  String get shrAlertOutOfStock => 'Out of Stock';

  @override
  String get shrAlertLowStock => 'Low Stock';

  @override
  String get shrAlertExpiringSoon => 'Expiring Soon';

  @override
  String get shrAlertOverdueUdhaar => 'Long Overdue Udhaar';

  @override
  String get shrAlertOverduePayment => 'Overdue Payment';

  @override
  String get shrAlertUpcomingPayment => 'Upcoming Payment';

  @override
  String shrMsgOutOfStock(String name) {
    return '$name is completely out of stock.';
  }

  @override
  String shrMsgLowStock(String name, String stock) {
    return '$name is running low ($stock).';
  }

  @override
  String shrMsgExpiringSoon(String name, int days) {
    return '$name expires in $days days.';
  }

  @override
  String shrMsgOverdueUdhaar(String name, String amount, int days) {
    return '$name has pending ₹$amount for $days days.';
  }

  @override
  String shrMsgPaymentOverdue(String amount, String supplier) {
    return '₹$amount to $supplier is overdue.';
  }

  @override
  String shrMsgPaymentDue(String amount, String supplier, int days) {
    return '₹$amount to $supplier due in $days days.';
  }

  @override
  String psetErrorWith(String error) {
    return 'Error: $error';
  }

  @override
  String get psetCancel => 'Cancel';

  @override
  String get psetReset => 'Reset';

  @override
  String get psetUserActivity => 'User Activity';

  @override
  String get psetNoUsersFound => 'No users found';

  @override
  String get psetNoStore => 'No store';

  @override
  String get psetNever => 'Never';

  @override
  String get psetActiveToday => 'Active today';

  @override
  String get psetInactive => 'Inactive';

  @override
  String get psetLastSeen => 'Last seen';

  @override
  String get psetOpensToday => 'Opens today';

  @override
  String get psetTimeInApp => 'Time in app';

  @override
  String get psetSalesToday => 'Sales today';

  @override
  String get psetJustNow => 'Just now';

  @override
  String psetMinsAgo(int m) {
    return '${m}m ago';
  }

  @override
  String psetHoursAgo(int h) {
    return '${h}h ago';
  }

  @override
  String psetDaysAgo(int d) {
    return '${d}d ago';
  }

  @override
  String get psetPasswordSecurity => 'Password & Security';

  @override
  String psetCouldNotLoadStatus(String error) {
    return 'Could not load status: $error';
  }

  @override
  String get psetEnterNewPassword => 'Enter a new password';

  @override
  String get psetPasswordMin6 => 'Password must be at least 6 characters';

  @override
  String get psetPasswordsNoMatch => 'Passwords do not match';

  @override
  String get psetEnterCurrentPassword => 'Enter your current password';

  @override
  String get psetPasswordUpdated => 'Password updated successfully.';

  @override
  String get psetPasswordCreated => 'Password created successfully.';

  @override
  String get psetCouldNotConnect =>
      'Could not connect to server. Please try again.';

  @override
  String get psetSomethingWrong => 'Something went wrong';

  @override
  String get psetPasswordSet => 'Password set';

  @override
  String get psetNoPasswordYet => 'No password yet';

  @override
  String psetLastChanged(String date) {
    return 'Last changed $date';
  }

  @override
  String get psetPasswordActive => 'Password is active';

  @override
  String get psetCreatePasswordHint =>
      'Create a password to enable username login';

  @override
  String psetPasswordCooldown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'You can change your password again in $_temp0.';
  }

  @override
  String get psetChangePassword => 'Change Password';

  @override
  String get psetCreatePassword => 'Create Password';

  @override
  String get psetChangeSubtitle =>
      'Enter your current password, then choose a new one.';

  @override
  String get psetCreateSubtitle =>
      'Set a password so you can also log in with your username.';

  @override
  String get psetCurrentPassword => 'Current password';

  @override
  String get psetNewPassword => 'New password';

  @override
  String get psetConfirmNewPassword => 'Confirm new password';

  @override
  String get psetUpdatePassword => 'Update Password';

  @override
  String get psetPasswordCooldownNote =>
      'Password can only be changed once every 14 days.';

  @override
  String get psetAllHistory => 'All History';

  @override
  String get psetTabPurchases => 'Purchases';

  @override
  String get psetTabPosOrders => 'POS Orders';

  @override
  String get psetNoPurchaseHistory => 'No purchase history found.';

  @override
  String get psetViewBill => 'View Bill';

  @override
  String get psetPurchaseDetails => 'Purchase Details';

  @override
  String psetFromSupplier(String supplier) {
    return 'From $supplier';
  }

  @override
  String psetQtyTimes(String qty, String price) {
    return 'Qty: $qty × ₹$price';
  }

  @override
  String get psetTotalAmount => 'Total Amount';

  @override
  String get psetSalesTxnHistory => 'Sales Transaction History';

  @override
  String get psetSalesTxnDesc =>
      'View and filter all your POS orders, payments, and customer transactions.';

  @override
  String get psetOpenSalesHistory => 'Open Sales History';

  @override
  String get psetSettingsSaved => 'Settings saved';

  @override
  String psetSaveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String get psetResetToDefaults => 'Reset to defaults';

  @override
  String get psetResetConfirm =>
      'All settings will be reset to their default values.';

  @override
  String get psetConfiguration => 'Configuration';

  @override
  String get psetPosPreferences => 'POS Preferences';

  @override
  String get psetAiForecasting => 'AI & Forecasting';

  @override
  String get psetAlertThresholds => 'Alert Thresholds';

  @override
  String get psetMarketing => 'Marketing';

  @override
  String get psetNotifications => 'Notifications';

  @override
  String get psetDefaultPayment => 'Default Payment Method';

  @override
  String get psetDefaultPaymentHint =>
      'Pre-selected method when adding a new sale';

  @override
  String get psetCash => 'Cash';

  @override
  String get psetCard => 'Card';

  @override
  String get psetForecastHorizon => 'Forecast Horizon';

  @override
  String get psetForecastHorizonHint =>
      'How many days ahead the AI predicts stock needs';

  @override
  String psetDaysValue(int days) {
    return '$days days';
  }

  @override
  String get psetStockoutRisk => 'Stockout Risk Threshold';

  @override
  String get psetStockoutRiskHint =>
      'Show stockout alert when 7-day risk exceeds this';

  @override
  String get psetMinVelocity => 'Min Velocity Threshold';

  @override
  String get psetMinVelocityHint =>
      'Items selling slower than this are flagged as dead stock';

  @override
  String get psetReorderAlertDays => 'Reorder Alert Days';

  @override
  String get psetReorderAlertHint =>
      'Alert when projected stock will run out within N days';

  @override
  String get psetDeadStockDays => 'Dead Stock Days';

  @override
  String get psetDeadStockHint => 'Flag items with no sales for N or more days';

  @override
  String get psetExpiryAlertDays => 'Expiry Alert Days';

  @override
  String get psetExpiryAlertHint =>
      'Alert this many days before a batch/item expires';

  @override
  String psetDaysBeforeValue(int days) {
    return '$days days before';
  }

  @override
  String get psetAllowMarketing => 'Allow LohiyaAI to Market My Store';

  @override
  String get psetAllowMarketingHint =>
      'We promote your store on Facebook, Instagram & WhatsApp on your behalf';

  @override
  String get psetInAppAlerts => 'In-app Alerts';

  @override
  String get psetInAppAlertsHint => 'Show alerts inside the app';

  @override
  String get psetWhatsappNotif => 'WhatsApp Notifications';

  @override
  String get psetWhatsappNotifHint =>
      'Send restocking and udhaar alerts via WhatsApp';

  @override
  String get psetQuietHours => 'Quiet Hours';

  @override
  String get psetQuietHoursHint =>
      'No notifications will be sent during this window';

  @override
  String get psetStart => 'Start';

  @override
  String get psetEnd => 'End';

  @override
  String get psetSaveChanges => 'Save Changes';

  @override
  String get psetCashflowSupport => 'Cashflow Support';

  @override
  String get psetRequestUnderReview => 'Request Under Review';

  @override
  String psetReqProcessingFull(String amount, String bank) {
    return 'Your cashflow request for ₹$amount via $bank is being processed.\n\nOur team will contact you within 2 business days.';
  }

  @override
  String get psetReqProcessing =>
      'Your cashflow request is being processed.\n\nOur team will contact you within 2 business days.';

  @override
  String get psetRequestSubmitted => 'Request Submitted!';

  @override
  String get psetRequestSubmittedBody =>
      'We\'ve received your cashflow request.\nOur team will contact you within\n2 business days.';

  @override
  String get psetBackToProfile => 'Back to Profile';

  @override
  String get psetApplyCashflow => 'Apply for\nCashflow Support';

  @override
  String get psetCashflowSubtitle =>
      'Quick business finance, powered by LohiyaAI partners.';

  @override
  String get psetYourBusinessProfile => 'Your Business Profile';

  @override
  String get psetStore => 'Store';

  @override
  String get psetLocation => 'Location';

  @override
  String get psetDailyFootfall => 'Daily Footfall';

  @override
  String psetCustomersPerDay(int count) {
    return '$count customers/day';
  }

  @override
  String get psetHowMuchNeed => 'How much do you need?';

  @override
  String get psetDragToSelect => 'Drag to select — ₹50,000 to ₹10,00,000';

  @override
  String get psetLoanAmount => 'loan amount';

  @override
  String get psetChoosePartnerBank => 'Choose a Partner Bank';

  @override
  String get psetSelectBankHint =>
      'Select a bank to proceed with your request.';

  @override
  String get psetSubmitRequest => 'Submit Request';

  @override
  String get psetSubmitDisclaimer =>
      'By submitting, you agree to be contacted by our team regarding this request.';

  @override
  String get psetBankSbiDesc => 'Government-backed scheme for small businesses';

  @override
  String get psetBankHdfcDesc => 'Quick disbursal for retail growth';

  @override
  String get psetBankIciciDesc => 'Flexible credit for kirana owners';

  @override
  String get psetBankAxisDesc => 'Tailored finance for retail stores';

  @override
  String get widgetTitleSales => 'Today\'s Sales';

  @override
  String get widgetTitleUdhaar => 'Udhaar Due';

  @override
  String get widgetTitleLowStock => 'Low Stock';

  @override
  String get widgetTitlePayToday => 'Pay Today';

  @override
  String get widgetNewBill => '+ New Bill';

  @override
  String get widgetUnitOrders => 'orders';

  @override
  String get widgetUnitItems => 'items';

  @override
  String get widgetUnitOverdue => 'overdue';

  @override
  String get widgetUnitPending => 'pending';

  @override
  String get widgetUnitToPay => 'to pay';

  @override
  String get widgetSignIn => 'Open Outlet AI to sign in';

  @override
  String get widgetNoData => 'Open the app to load today\'s numbers';

  @override
  String get visionComingSoon => 'Vision AI is coming soon!';

  @override
  String get mktTierBronze => 'Bronze';

  @override
  String get mktTierSilver => 'Silver';

  @override
  String get mktTierGold => 'Gold';

  @override
  String get mktTierPlatinum => 'Platinum';

  @override
  String get mktTierSettings => 'Tier settings';

  @override
  String get mktShowArchived => 'Show archived';

  @override
  String get mktHideArchived => 'Hide archived';

  @override
  String get mktArchived => 'Archived';

  @override
  String get mktEdit => 'Edit';

  @override
  String get mktAlertedToday => 'Alerted today';

  @override
  String get mktRestore => 'Restore';

  @override
  String get mktArchive => 'Archive';

  @override
  String get mktBasketArchived => 'Basket archived';

  @override
  String get mktBasketRestored => 'Basket restored';

  @override
  String get mktSomethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get mktEditBasket => 'Edit Basket';

  @override
  String get mktSaveChanges => 'Save Changes';

  @override
  String get mktAddItemsForPrice =>
      'Add items to see the auto-discounted bundle price';

  @override
  String get mktItemsTotal => 'Items total';

  @override
  String get mktBundlePrice => 'Bundle price';

  @override
  String get mktTierConfigTitle => 'Basket Tiers';

  @override
  String get mktTierConfigIntro =>
      'Baskets are auto-priced by their total value. Set the value range and discount for each tier — the matching tier\'s discount is applied automatically as you add items.';

  @override
  String get mktTierRangeInvalid =>
      'Each tier\'s limit must be higher than the previous, and discounts between 0–100%.';

  @override
  String get mktTiersSaved => 'Tiers saved';

  @override
  String get mktRecomputeTitle => 'Recompute existing baskets?';

  @override
  String get mktKeepAsIs => 'Keep as-is';

  @override
  String get mktRecompute => 'Recompute';

  @override
  String get mktSaveTiers => 'Save Tiers';

  @override
  String get mktUpToLabel => 'Up to';

  @override
  String get mktTopTierHint => 'Everything above the previous tier';

  @override
  String get mktDiscountLabel => 'Discount';

  @override
  String get psetBasketTiers => 'Basket Tiers';

  @override
  String get psetBasketTiersHint => 'Auto-discount baskets by value';

  @override
  String mktYouSave(String amount, String pct) {
    return 'Save ₹$amount ($pct% off)';
  }

  @override
  String mktTierBasketLabel(String tier) {
    return '$tier basket';
  }

  @override
  String mktPctOff(String pct) {
    return '$pct% off';
  }

  @override
  String mktSaveAmount(String amount) {
    return 'Save ₹$amount';
  }

  @override
  String mktRecomputeBody(int count) {
    return '$count existing baskets are priced under your old tiers. Apply the new tiers to them too?';
  }

  @override
  String mktBasketsRecomputed(int count) {
    return '$count baskets updated';
  }

  @override
  String mktAboveAmount(String amount) {
    return 'Above ₹$amount';
  }

  @override
  String mktRangeAmount(String from, String to) {
    return '₹$from – ₹$to';
  }

  @override
  String get mktSaveAsBasket => 'Save as Basket';

  @override
  String mktBasketSavedFromCampaign(String name) {
    return 'Saved \"$name\" to your baskets';
  }

  @override
  String get mktSelectDate => 'Select date';

  @override
  String get mktBasketsProTitle => 'Baskets is a Pro feature';

  @override
  String get mktBasketsProDesc =>
      'Create combo deals with automatic tier discounts and alert customers on WhatsApp. Upgrade to Pro to unlock baskets.';

  @override
  String get visionNavLabel => 'Vision';

  @override
  String get visionTitle => 'Vision';

  @override
  String get visionTabShelf => 'Shelf Scan';

  @override
  String get visionTabResults => 'Results';

  @override
  String get visionTabCounter => 'Counter';

  @override
  String get visionProTitle => 'Vision AI';

  @override
  String get visionProDesc =>
      'Snap your shelf morning and evening — AI counts your stock and tells you what sold.';

  @override
  String get visionFromCamera => 'Take a photo';

  @override
  String get visionFromGallery => 'Choose from gallery';

  @override
  String get visionMorningTitle => 'Morning — Start of Day';

  @override
  String get visionEveningTitle => 'Evening — End of Day';

  @override
  String get visionTakePhoto => 'Add Photos';

  @override
  String get visionRetake => 'Retake';

  @override
  String get visionReview => 'Review';

  @override
  String get visionAnalyzing => 'Analyzing shelf… this can take up to a minute';

  @override
  String get visionScanFailed => 'Scan failed. Please retake the photo.';

  @override
  String get visionNoPhotoYet => 'No photo taken yet.';

  @override
  String get visionProductsIdentified => 'Products identified';

  @override
  String get visionUnitsCounted => 'Units counted';

  @override
  String get visionNeedsReview => 'Needs review';

  @override
  String get visionViewSales => 'View Today\'s Sales';

  @override
  String get visionTip =>
      'Tip: take the morning photo before opening and the evening photo before closing. AI works out how many of each product sold.';

  @override
  String get visionSalesEmpty =>
      'Take a morning and an evening photo to see what sold today.';

  @override
  String get visionTotalSold => 'Total items sold';

  @override
  String get visionSold => 'sold';

  @override
  String get visionMorningCount => 'AM';

  @override
  String get visionEveningCount => 'PM';

  @override
  String get visionUnknownItem => 'Unknown — tap to fix';

  @override
  String get visionCorrected => 'Corrected';

  @override
  String get visionCorrectTitle => 'Which product is this?';

  @override
  String get visionSearchProducts => 'Search your products';

  @override
  String get visionClearCorrection => 'Clear correction';

  @override
  String get visionNoProducts =>
      'No products loaded yet. Open the Billing tab once, then come back.';

  @override
  String get visionCounterSoonTitle => 'Live Counter — coming soon';

  @override
  String get visionCounterSoonDesc =>
      'Point your phone at the billing counter to auto-count sales as items pass. We\'re putting the finishing touches on it.';

  @override
  String get visionAddPhotosTitle => 'Add shelf photos';

  @override
  String get visionAddPhotosHint =>
      'Take 3 to 10 photos covering your shelves.';

  @override
  String get visionMinPhotosHint => 'Add at least 3 photos';

  @override
  String get visionMaxReached => 'Maximum 10 photos';

  @override
  String get visionAnalyze => 'Analyze';

  @override
  String get forecastSectionLabel => 'SALES FORECAST';

  @override
  String forecastStripCount(int count) {
    return '$count items may sell tomorrow';
  }

  @override
  String forecastStripEst(String amount) {
    return 'Est. $amount';
  }

  @override
  String get forecastStripViewAll => 'See full list';

  @override
  String get forecastScreenTitle => 'Sales Forecast';

  @override
  String get forecastHorizonTomorrow => 'Tomorrow';

  @override
  String get forecastHorizon3d => '3 Days';

  @override
  String get forecastHorizon5d => '5 Days';

  @override
  String get forecastHorizon7d => '7 Days';

  @override
  String get forecastHorizon14d => '14 Days';

  @override
  String get forecastHorizon30d => '30 Days';

  @override
  String get forecastRevLabel => 'Est. revenue';

  @override
  String get forecastOosWarning => 'May run out';

  @override
  String get forecastWhyTitle => 'Why this item?';

  @override
  String get forecastWhyAvgDaily => 'Avg daily sales';

  @override
  String get forecastWhyStockDays => 'Stock left';

  @override
  String get forecastWhyOosRisk => 'Chance of running out';

  @override
  String forecastWhyExplain(String avg, String days, String units) {
    return 'This item sells about $avg units every day. In $days days, we expect about $units units to sell from your store.';
  }

  @override
  String get forecastNoData =>
      'Forecast not ready yet. Please try again later.';

  @override
  String get forecastDataStale => 'Data may be outdated';
}
