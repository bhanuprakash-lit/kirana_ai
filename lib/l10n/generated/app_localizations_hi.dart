// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get languageName => 'हिन्दी';

  @override
  String get languageChooseTitle => 'अपनी भाषा चुनें';

  @override
  String get languageChooseSubtitle =>
      'आप इसे कभी भी सेटिंग्स में बदल सकते हैं।';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get commonContinue => 'जारी रखें';

  @override
  String get commonServerError =>
      'सर्वर से कनेक्ट नहीं हो सका। कृपया फिर से प्रयास करें।';

  @override
  String get commonSomethingWrong =>
      'कुछ गलत हो गया। कृपया फिर से प्रयास करें।';

  @override
  String get authErrEnterPhone => 'अपना फ़ोन नंबर दर्ज करें';

  @override
  String get authErrEnter6Otp => '6-अंकों का OTP दर्ज करें';

  @override
  String get authErrSessionExpired =>
      'सत्र समाप्त हो गया। फिर से भेजें पर टैप करें।';

  @override
  String get authErrInvalidPhone =>
      'अमान्य फ़ोन नंबर। देश कोड शामिल करें (जैसे +91...)।';

  @override
  String get authErrTooManyRequests =>
      'बहुत अधिक प्रयास। कृपया बाद में फिर से प्रयास करें।';

  @override
  String get authErrWrongOtp => 'गलत OTP। कृपया जाँच कर फिर से प्रयास करें।';

  @override
  String get authErrOtpExpired =>
      'OTP की अवधि समाप्त। नया कोड पाने के लिए फिर से भेजें पर टैप करें।';

  @override
  String get authErrVerificationFailed => 'सत्यापन विफल। फिर से प्रयास करें।';

  @override
  String get welcomeSlide1Title => 'Outlet AI में\nआपका स्वागत है';

  @override
  String get welcomeSlide1Subtitle =>
      'आपकी किराना दुकान को संभालने के लिए आपका स्मार्ट व्यापार साथी — दक्षिण भारत के लिए बनाया गया।';

  @override
  String get welcomeSlide2Title => 'स्मार्ट इन्वेंटरी\nप्रबंधन';

  @override
  String get welcomeSlide2Subtitle =>
      'स्टॉक स्तर ट्रैक करें, कम-स्टॉक अलर्ट पाएँ, और अपने सबसे ज़्यादा बिकने वाले उत्पाद कभी खत्म न होने दें।';

  @override
  String get welcomeSlide3Title => 'अपना व्यापार\nबढ़ाएँ';

  @override
  String get welcomeSlide3Subtitle =>
      'AI-आधारित जानकारी, बिक्री विश्लेषण, और अपनी दुकान के लिए व्यक्तिगत सुझाव पाएँ।';

  @override
  String get welcomeGetStarted => 'शुरू करें';

  @override
  String get welcomeHaveAccount => 'पहले से खाता है? ';

  @override
  String get welcomeSignIn => 'साइन इन करें';

  @override
  String get loginWelcomeBack => 'वापसी पर स्वागत है';

  @override
  String get loginSubtitle => 'अपने Outlet AI खाते में साइन इन करें।';

  @override
  String get loginTabPhone => 'फ़ोन OTP';

  @override
  String get loginTabUsername => 'यूज़रनेम';

  @override
  String get loginPhoneLabel => 'फ़ोन नंबर';

  @override
  String get loginSendOtp => 'OTP भेजें';

  @override
  String get loginOtpHelp => 'हम इस नंबर पर एक वन-टाइम पासवर्ड भेजेंगे';

  @override
  String loginOtpSentTo(String phone) {
    return '$phone पर OTP भेजा गया';
  }

  @override
  String get loginOtp6Label => '6-अंकों का OTP';

  @override
  String get loginVerifyOtp => 'OTP सत्यापित करें';

  @override
  String get loginResendOtp => 'OTP फिर से भेजें';

  @override
  String get loginUsernameLabel => 'यूज़रनेम';

  @override
  String get loginUsernameHint => 'जैसे mykiranastore';

  @override
  String get loginUsernameRequired => 'यूज़रनेम आवश्यक है';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordHint => 'आपका पासवर्ड';

  @override
  String get loginPasswordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get loginSignIn => 'साइन इन करें';

  @override
  String get loginNoAccount => 'खाता नहीं है? ';

  @override
  String get loginCreateOne => 'एक बनाएँ';

  @override
  String get loginIncorrect =>
      'गलत यूज़रनेम या पासवर्ड। कृपया फिर से प्रयास करें।';

  @override
  String loginFailed(String message) {
    return 'लॉगिन विफल: $message';
  }

  @override
  String onboardingStepCount(int step) {
    return '$step/4';
  }

  @override
  String get accountVerifyPhoneTitle => 'अपना फ़ोन नंबर\nसत्यापित करें';

  @override
  String get accountVerifyPhoneSubtitle =>
      'आपका नंबर पुष्टि करने के लिए हम एक वन-टाइम पासवर्ड भेजेंगे।';

  @override
  String get accountPhoneLabel => 'फ़ोन नंबर';

  @override
  String get accountSendOtp => 'OTP भेजें';

  @override
  String get accountEnterOtpTitle => 'OTP दर्ज करें';

  @override
  String get accountEnterOtpSubtitle => 'आपके फ़ोन पर 6-अंकों का कोड भेजा गया।';

  @override
  String accountOtpSentTo(String phone) {
    return '+91 $phone पर OTP भेजा गया';
  }

  @override
  String get accountOtp6Label => '6-अंकों का OTP';

  @override
  String get accountVerify => 'सत्यापित करें';

  @override
  String get accountResendOtp => 'OTP फिर से भेजें';

  @override
  String accountPhoneVerified(String phone) {
    return 'फ़ोन सत्यापित: $phone';
  }

  @override
  String get accountChooseUsernameTitle => 'दुकान का यूज़रनेम\nचुनें';

  @override
  String get accountChooseUsernameSubtitle =>
      'आपका यूज़रनेम आपकी दुकान के लिए अद्वितीय है और लॉगिन के लिए उपयोग होता है।';

  @override
  String get accountUsernameLabel => 'यूज़रनेम';

  @override
  String get accountUsernameHint => 'जैसे lohiyastore123';

  @override
  String get accountUsernameTaken => 'यूज़रनेम पहले से लिया जा चुका है';

  @override
  String get accountUsernameRules =>
      'केवल अक्षर, संख्याएँ, अंडरस्कोर • कम से कम 3 अक्षर';

  @override
  String get accountErrChooseUsername =>
      'अपनी दुकान के लिए एक अद्वितीय यूज़रनेम चुनें';

  @override
  String get accountErrUsernameMin3 =>
      'यूज़रनेम कम से कम 3 अक्षरों का होना चाहिए';

  @override
  String get accountErrUsernameMax30 =>
      'उपयोगकर्ता नाम अधिकतम 30 अक्षरों का हो सकता है';

  @override
  String get accountErrUsernameChars =>
      'केवल अक्षर, संख्याएँ और अंडरस्कोर की अनुमति है';

  @override
  String get accountErrUsernameTakenTry =>
      'वह यूज़रनेम लिया जा चुका है। दूसरा आज़माएँ।';

  @override
  String get accountUsernameAvailable => 'उपयोगकर्ता नाम उपलब्ध है';

  @override
  String get businessTitle => 'अपनी दुकान के बारे में\nहमें बताएँ';

  @override
  String get businessSubtitle =>
      'आपके अनुभव को व्यक्तिगत बनाने में हमारी मदद करें।';

  @override
  String get businessOwnerLabel => 'मालिक का पूरा नाम';

  @override
  String get businessOwnerHint => 'जैसे रमेश कुमार';

  @override
  String get businessOwnerRequired => 'नाम आवश्यक है';

  @override
  String get businessStoreLabel => 'दुकान का नाम';

  @override
  String get businessStoreHint => 'जैसे श्री लक्ष्मी स्टोर्स';

  @override
  String get businessStoreRequired => 'दुकान का नाम आवश्यक है';

  @override
  String get businessEmailLabel => 'ईमेल पता';

  @override
  String get businessEmailHint => 'you@example.com';

  @override
  String get businessEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get businessEmailInvalid => 'एक मान्य ईमेल पता दर्ज करें';

  @override
  String get businessTypeLabel => 'व्यापार का प्रकार';

  @override
  String get businessTypeHint => 'अपनी दुकान का प्रकार चुनें';

  @override
  String get businessTypeRequired => 'कृपया अपने व्यापार का प्रकार चुनें';

  @override
  String get businessFootfallLabel => 'अनुमानित दैनिक ग्राहक';

  @override
  String get businessFootfallHint => 'जैसे 40';

  @override
  String get businessFootfallSuffix => 'ग्राहक/दिन';

  @override
  String get businessFootfallInvalid => 'एक मान्य संख्या दर्ज करें';

  @override
  String get businessBudgetLabel => 'मासिक बिक्री लक्ष्य (वैकल्पिक)';

  @override
  String get businessBudgetHint => 'जैसे 150000';

  @override
  String get businessBudgetHelper =>
      'दैनिक प्रगति ट्रैक करने के लिए उपयोग होता है। आप इसे बाद में बदल सकते हैं।';

  @override
  String get businessBudgetInvalid => 'एक मान्य राशि दर्ज करें';

  @override
  String get businessTypeKirana => 'किराना / जनरल स्टोर';

  @override
  String get businessTypeGeneral => 'जनरल स्टोर';

  @override
  String get businessTypeProvision => 'प्रोविज़न स्टोर';

  @override
  String get businessTypeFruitsVeg => 'फल एवं सब्ज़ियाँ';

  @override
  String get businessTypeStationery => 'स्टेशनरी एवं किताबें';

  @override
  String get businessTypeSupermarket => 'सुपरमार्केट';

  @override
  String get businessTypeMiniSupermarket => 'मिनी सुपरमार्केट';

  @override
  String get businessTypeMonoBrand => 'मोनो ब्रांड स्टोर';

  @override
  String get businessTypeBoutique => 'बुटीक';

  @override
  String get businessTypeSalon => 'सैलून एवं पार्लर';

  @override
  String get businessTypeFancyGift => 'फैंसी एवं गिफ्ट स्टोर';

  @override
  String get businessTypeSportsFitness => 'स्पोर्ट्स एवं फिटनेस';

  @override
  String get businessTypeFootwear => 'जूते-चप्पल की दुकान';

  @override
  String get businessTypeOptical => 'ऑप्टिकल स्टोर';

  @override
  String get businessTypeBakery => 'बेकरी एवं मिठाई की दुकान';

  @override
  String get businessTypeApparel => 'कपड़े एवं परिधान';

  @override
  String get businessTypeElectronics => 'मोबाइल एवं इलेक्ट्रॉनिक्स';

  @override
  String get businessTypeOthers => 'अन्य';

  @override
  String get locationTitle => 'आपकी दुकान\nकहाँ स्थित है?';

  @override
  String get locationSubtitle =>
      'हम इसका उपयोग स्थानीय जानकारी दिखाने और डिलीवरी ज़ोन सक्षम करने के लिए करते हैं।';

  @override
  String get locationDetecting => 'स्थान का पता लगाया जा रहा है…';

  @override
  String get locationDetect => 'मेरा स्थान पता करें';

  @override
  String get locationOrManual => 'या मैन्युअल रूप से दर्ज करें';

  @override
  String get locationAddressLabel => 'दुकान का पता';

  @override
  String get locationAddressHint => 'गली, क्षेत्र, लैंडमार्क…';

  @override
  String get locationCityLabel => 'शहर / ज़िला';

  @override
  String get locationCityHint => 'जैसे हैदराबाद';

  @override
  String get locationGettingCoords => 'निर्देशांक प्राप्त किए जा रहे हैं…';

  @override
  String get locationDetected => 'स्थान का पता चला';

  @override
  String get locationErrAddress =>
      'कृपया अपनी दुकान का पता पता करें या दर्ज करें।';

  @override
  String get locationErrCity => 'कृपया अपना शहर या ज़िला दर्ज करें।';

  @override
  String get locationPermDenied =>
      'स्थान की अनुमति अस्वीकृत। कृपया पता मैन्युअल रूप से दर्ज करें।';

  @override
  String get locationDetectFailed =>
      'स्थान का पता नहीं चल सका। कृपया पता मैन्युअल रूप से दर्ज करें।';

  @override
  String get consentTitle => 'बस हो गया!\nसमीक्षा करें और सहमति दें';

  @override
  String get consentSubtitle =>
      'अपना सेटअप पूरा करने के लिए कृपया निम्नलिखित पढ़ें और स्वीकार करें।';

  @override
  String get consentTermsTitle => 'नियम एवं शर्तें';

  @override
  String get consentTermsSummary =>
      'Outlet AI का उपयोग करके, आप इस सेवा का उपयोग केवल वैध व्यापारिक उद्देश्यों के लिए करने पर सहमत होते हैं। इन शर्तों का उल्लंघन करने वाले खातों को निलंबित करने का अधिकार LohiyaAI के पास सुरक्षित है। आपके डेटा का उपयोग केवल सेवा प्रदान करने और सुधारने के लिए किया जाता है।';

  @override
  String get consentPrivacyTitle => 'गोपनीयता नीति';

  @override
  String get consentPrivacySummary =>
      'आपके अनुभव को व्यक्तिगत बनाने के लिए हम आपकी दुकान के विवरण, स्थान और लेन-देन डेटा एकत्र करते हैं। हम आपका व्यक्तिगत डेटा कभी भी तीसरे पक्ष को नहीं बेचते। सारा डेटा एन्क्रिप्ट किया जाता है और हमारे क्लाउड इन्फ्रास्ट्रक्चर पर सुरक्षित रूप से संग्रहीत होता है।';

  @override
  String get consentTermsCheckPrefix => 'मैंने पढ़ लिया है और सहमत हूँ: ';

  @override
  String get consentPrivacyCheckPrefix => 'मैं सहमत हूँ: ';

  @override
  String get consentAcceptBoth =>
      'जारी रखने के लिए कृपया दोनों समझौतों को स्वीकार करें।';

  @override
  String get consentCompleteSetup => 'सेटअप पूरा करें';

  @override
  String get regErrPhoneExists =>
      'यह फ़ोन नंबर पहले से पंजीकृत है। कृपया इसके बजाय साइन इन करें।';

  @override
  String get regErrUsernameTaken =>
      'यह यूज़रनेम पहले से लिया जा चुका है। कृपया दूसरा चुनें।';

  @override
  String get regErrInvalidDetails =>
      'अमान्य विवरण। कृपया अपनी प्रविष्टियाँ जाँचें और फिर से प्रयास करें।';

  @override
  String regErrFailed(String message) {
    return 'पंजीकरण विफल: $message';
  }

  @override
  String get dashNavHome => 'होम';

  @override
  String get dashNavKhata => 'खाता';

  @override
  String get dashNavBilling => 'बिलिंग';

  @override
  String get dashTrialWelcome => 'Outlet AI में आपका स्वागत है';

  @override
  String get dashTrialChoosePlan =>
      'मुफ़्त ट्रायल के लिए एक प्लान चुनें। हमारी टीम इसे जल्द ही एक्टिवेट कर देगी।';

  @override
  String get dashTrialSelectPlan => 'अपना ट्रायल प्लान चुनें';

  @override
  String get dashTrialRequestPro => 'Pro ट्रायल का अनुरोध करें';

  @override
  String get dashTrialRequestBasic => 'Basic ट्रायल का अनुरोध करें';

  @override
  String get dashTrialRequestError =>
      'अभी आपका ट्रायल शुरू नहीं हो सका। कृपया अपना कनेक्शन जांचें और फिर से प्रयास करें।';

  @override
  String get dashTrialSignInDifferent => 'किसी अन्य खाते में साइन इन करें';

  @override
  String get dashPlanBadgeAllFeatures => 'सभी फ़ीचर्स';

  @override
  String get dashPlanBasicName => 'Basic प्लान';

  @override
  String get dashPlanProName => 'Pro प्लान';

  @override
  String get dashFeatPos => 'POS & बिक्री प्रबंधन';

  @override
  String get dashFeatInventoryTracking => 'इन्वेंटरी ट्रैकिंग';

  @override
  String get dashFeatFinanceUdhaar => 'फाइनेंस & उधार';

  @override
  String get dashFeatKpiInsights => 'KPI जानकारी (प्रति कैटेगरी 3)';

  @override
  String get dashFeatAiReco => 'AI सिफ़ारिशें';

  @override
  String get dashFeatEverythingBasic => 'Basic का सब कुछ';

  @override
  String get dashFeatAllKpi => 'सभी KPI कैटेगरी (असीमित)';

  @override
  String get dashFeatVendorProcurement => 'वेंडर & प्रोक्योरमेंट प्रबंधन';

  @override
  String get dashFeatCashflowSupport => 'कैशफ्लो सपोर्ट (₹10L तक)';

  @override
  String get dashFeatCustomerGrowth => 'कस्टमर ग्रोथ इंजन';

  @override
  String get dashPendingTitle => 'ट्रायल अनुरोध मिल गया!';

  @override
  String get dashPendingBody =>
      'आपके ट्रायल एक्टिवेशन की समीक्षा हमारी टीम कर रही है। मंज़ूरी मिलते ही आपके डिवाइस पर नोटिफिकेशन आ जाएगा — आमतौर पर कुछ घंटों में।';

  @override
  String get dashPendingNotifNote =>
      'ध्यान रखें कि नोटिफिकेशन चालू हों ताकि आप एक्टिवेशन अलर्ट न चूकें।';

  @override
  String get dashPendingCheckStatus => 'स्थिति जाँचें';

  @override
  String get dashUpgradeTitle => 'मुफ़्त ट्रायल समाप्त';

  @override
  String get dashUpgradeBody =>
      'आपका मुफ़्त ट्रायल समाप्त हो गया। Outlet AI का उपयोग जारी रखने और अपनी दुकान बढ़ाते रहने के लिए एक प्लान चुनें।';

  @override
  String get dashUpgradeBasic => 'Basic';

  @override
  String get dashUpgradePro => 'Pro';

  @override
  String get dashUpgradeBadgeBest => 'बेस्ट';

  @override
  String dashUpgradeJustPerDay(String price) {
    return 'सिर्फ़ $price';
  }

  @override
  String get dashUpgradeAlreadySubscribed =>
      'पहले से सब्सक्राइब्ड हैं? रिफ्रेश करें';

  @override
  String get dashFeatPosInventory => 'POS & इन्वेंटरी';

  @override
  String get dashFeatFinanceKpis => 'फाइनेंस & KPIs';

  @override
  String get dashFeatVendorManagement => 'वेंडर प्रबंधन';

  @override
  String get dashFeatCashflowReferrals => 'कैशफ्लो + रेफरल';

  @override
  String get dashNewSale => 'नई बिक्री';

  @override
  String get dashGreetingMorning => 'सुप्रभात';

  @override
  String get dashGreetingAfternoon => 'नमस्कार';

  @override
  String get dashGreetingEvening => 'शुभ संध्या';

  @override
  String dashGreetingWithName(String greeting, String name) {
    return '$greeting, \n$name';
  }

  @override
  String get dashMorningBriefing => 'मॉर्निंग ब्रीफिंग';

  @override
  String dashBriefingBody(int risk, int reorder) {
    return 'आज आपके $risk SKU क्रिटिकल रिस्क पर हैं और $reorder आइटम रीऑर्डर करने हैं। ठीक करने के लिए टैप करें।';
  }

  @override
  String get dashIntelligence => 'इंटेलिजेंस';

  @override
  String get dashMetricStockoutLabel => 'स्टॉकआउट रिस्क';

  @override
  String get dashMetricStockoutSub => 'SKU क्रिटिकल';

  @override
  String get dashMetricReorderLabel => 'अभी रीऑर्डर करें';

  @override
  String get dashMetricReorderSub => 'कम स्टॉक SKU';

  @override
  String get dashMetricFastLabel => 'फ़ास्ट मूविंग';

  @override
  String get dashMetricFastSub => 'टॉप सेलर';

  @override
  String get dashMetricProfitLabel => 'प्रॉफ़िट पिक्स';

  @override
  String get dashMetricProfitSub => 'अवसर';

  @override
  String get dashMetricCustomerLabel => 'कस्टमर बकाया';

  @override
  String get dashMetricCustomerSub => 'पेंडिंग खाता';

  @override
  String get dashMetricSalesLabel => 'बिके आइटम';

  @override
  String get dashMetricSalesSub => 'आज अब तक';

  @override
  String get dashTodaysPerformance => 'आज का प्रदर्शन';

  @override
  String get dashPosNotAvailable => 'POS डेटा उपलब्ध नहीं';

  @override
  String get dashStatRevenue => 'राजस्व';

  @override
  String get dashStatOrders => 'बिल';

  @override
  String get dashStatAvgOrder => 'औसत बिल';

  @override
  String get dashStoreOverview => 'दुकान का ओवरव्यू';

  @override
  String get dashStoreSkus => 'SKU';

  @override
  String get dashStoreFootfall => 'दैनिक फुटफॉल';

  @override
  String get dashStoreDailyBudget => 'रोज़ का माल खर्च';

  @override
  String dashKpiPeriod(int days) {
    return 'पिछले $days दिन';
  }

  @override
  String get dashCouldNotLoad => 'डेटा लोड नहीं हो सका';

  @override
  String get dashRetry => 'फिर से प्रयास करें';

  @override
  String get dashAlerts => 'अलर्ट';

  @override
  String get dashSeeAll => 'सभी देखें';

  @override
  String get dashStoreKpis => 'दुकान KPIs';

  @override
  String dashKpiCoverageTooltip(String pct) {
    return 'बिक्री के $pct% पर आधारित — कुछ आइटम का कॉस्ट डेटा नहीं है';
  }

  @override
  String get dashDetailStockout => 'स्टॉकआउट रिस्क';

  @override
  String get dashDetailReorder => 'रीऑर्डर आवश्यक';

  @override
  String get dashDetailFastMoving => 'फ़ास्ट मूविंग आइटम';

  @override
  String get dashDetailProfit => 'हाई प्रॉफ़िट आइटम';

  @override
  String get dashDetailDefault => 'इंटेलिजेंस विवरण';

  @override
  String get dashSearchProducts => 'उत्पाद खोजें...';

  @override
  String get dashSortBy => 'इसके अनुसार क्रमबद्ध करें:';

  @override
  String get dashSortProfit => 'लाभ';

  @override
  String get dashSortDemand => 'डिमांड';

  @override
  String get dashSortRisk => 'रिस्क';

  @override
  String dashStockLabel(String qty) {
    return 'स्टॉक: $qty';
  }

  @override
  String get dashStockRunway => 'स्टॉक रनवे';

  @override
  String get dashOutOfStock => 'स्टॉक खत्म';

  @override
  String dashDaysLeft(String days) {
    return '~$days दिन शेष';
  }

  @override
  String get dashStatStockoutRisk => 'स्टॉकआउट रिस्क';

  @override
  String get dashStatReorderQty => 'रीऑर्डर मात्रा';

  @override
  String dashUnitsValue(String qty) {
    return '$qty यूनिट';
  }

  @override
  String dashWeeklyProfitImpact(String amount) {
    return '₹$amount अनुमानित साप्ताहिक लाभ प्रभाव';
  }

  @override
  String dashCreatePurchaseOrder(String qty) {
    return 'परचेज़ ऑर्डर बनाएँ · $qty यूनिट';
  }

  @override
  String get dashNoItemsFound => 'कोई आइटम नहीं मिला';

  @override
  String dashNoResultsFor(String query) {
    return '\"$query\" के लिए कोई परिणाम नहीं';
  }

  @override
  String get dashClearSearch => 'खोज साफ़ करें';

  @override
  String get dashConnectionError => 'कनेक्शन एरर';

  @override
  String get posCommonCancel => 'रद्द करें';

  @override
  String get posCommonClear => 'क्लियर';

  @override
  String get posCommonRefresh => 'रिफ्रेश';

  @override
  String get posCommonAddToCart => 'कार्ट में जोड़ें';

  @override
  String get posCameraPermissionRequired =>
      'बारकोड स्कैन करने के लिए कैमरा अनुमति आवश्यक है।';

  @override
  String get posCommonSettings => 'सेटिंग्स';

  @override
  String posEnterQtyTitle(String unit) {
    return '$unit दर्ज करें';
  }

  @override
  String get posQtyFallback => 'मात्रा';

  @override
  String get posSelectVariant => 'वेरिएंट चुनें';

  @override
  String posInclGst(String amount) {
    return 'GST सहित $amount';
  }

  @override
  String get posOutOfStock => 'स्टॉक ख़त्म';

  @override
  String posVariantStockLine(String stock) {
    return '$stock स्टॉक में';
  }

  @override
  String posPriceLabel(String price) {
    return 'कीमत: $price';
  }

  @override
  String get posWeightMeasurement => 'वज़न / माप';

  @override
  String get posUnknownBarcodeTitle => 'अज्ञात बारकोड';

  @override
  String posUnknownBarcodeBody(String barcode) {
    return 'बारकोड \"$barcode\" आपकी इन्वेंट्री में नहीं है. आप क्या करना चाहेंगे?';
  }

  @override
  String get posAddAsNew => 'नए के रूप में जोड़ें';

  @override
  String get posLinkToExisting => 'मौजूदा आइटम से लिंक करें';

  @override
  String posErrLoadingInventory(String error) {
    return 'इन्वेंट्री लोड करने में एरर: $error';
  }

  @override
  String posLinkBarcodeTitle(String barcode) {
    return 'बारकोड \"$barcode\" लिंक करें';
  }

  @override
  String get posNoUnbarcodedItems => 'बिना बारकोड वाले आइटम नहीं मिले.';

  @override
  String posCategoryLabel(String category) {
    return 'कैटेगरी: $category';
  }

  @override
  String get posCategoryGeneral => 'जनरल';

  @override
  String posLinkedToItem(String barcode, String name) {
    return '$barcode को $name से लिंक किया';
  }

  @override
  String get posScanReferralQr => 'रेफरल QR स्कैन करें';

  @override
  String posCampaignOutOfStock(String name) {
    return '\"$name\" के सभी आइटम स्टॉक में नहीं हैं';
  }

  @override
  String posCampaignItemsAdded(int count, String name) {
    return '\"$name\" से $count आइटम जोड़े गए';
  }

  @override
  String posAddedSkipped(int added, int skipped) {
    return '$added जोड़े गए · $skipped छोड़े गए (स्टॉक में नहीं)';
  }

  @override
  String posBasketAddedAtPrice(String name, String price) {
    return 'बंडल \"$name\" ₹$price में जोड़ा गया';
  }

  @override
  String posItemsRegularPrice(int count) {
    return '$count आइटम सामान्य कीमत पर जोड़े गए (बंडल के लिए सभी आइटम स्टॉक में होने चाहिए)';
  }

  @override
  String posBasketItemsAdded(int count, String name) {
    return '\"$name\" से $count आइटम जोड़े गए';
  }

  @override
  String posItemsAddedToCart(int count) {
    return '$count आइटम कार्ट में जोड़े गए';
  }

  @override
  String get posSelectCustomer => 'कस्टमर चुनें';

  @override
  String get posNew => 'नया';

  @override
  String get posSearchNameOrPhone => 'नाम या फ़ोन से खोजें...';

  @override
  String get posNoCustomersFound => 'कोई कस्टमर नहीं मिला.';

  @override
  String get posAddNewCustomer => 'नया कस्टमर जोड़ें';

  @override
  String get posSelectFromContacts => 'कॉन्टैक्ट्स से चुनें';

  @override
  String get posCustomerName => 'कस्टमर का नाम';

  @override
  String get posPhoneNumber => 'फ़ोन नंबर';

  @override
  String get posSaveAndSelect => 'सेव करके चुनें';

  @override
  String get posSearchProducts => 'प्रोडक्ट खोजें…';

  @override
  String get posReferralScan => 'रेफरल स्कैन';

  @override
  String get posOrderHistory => 'ऑर्डर हिस्ट्री';

  @override
  String get posRefreshingProducts => 'प्रोडक्ट रिफ्रेश हो रहे हैं...';

  @override
  String posRefreshFailed(String error) {
    return 'रिफ्रेश विफल: $error';
  }

  @override
  String posProductsRefreshed(int count) {
    return 'प्रोडक्ट रिफ्रेश हुए ($count आइटम)';
  }

  @override
  String posItemsInCart(int count) {
    return 'कार्ट में $count आइटम';
  }

  @override
  String get posClearCartTitle => 'कार्ट क्लियर करें?';

  @override
  String get posClearCartBody => 'सभी आइटम कार्ट से हटा दिए जाएंगे.';

  @override
  String get posFrequentlyBought => 'अक्सर साथ में खरीदे जाने वाले';

  @override
  String get posNoProductsFound => 'कोई प्रोडक्ट नहीं मिला';

  @override
  String posStockColon(String stock) {
    return 'स्टॉक: $stock';
  }

  @override
  String get posOffline => 'POS ऑफ़लाइन';

  @override
  String get posCouldNotConnect => 'POS से कनेक्ट नहीं हो सका.';

  @override
  String get posBundlesAndDeals => 'बंडल और डील';

  @override
  String get posRefreshAi => 'AI रिफ्रेश';

  @override
  String posItemsInBundle(int count) {
    return 'बंडल में $count आइटम';
  }

  @override
  String get posBundlePrice => 'बंडल कीमत';

  @override
  String get posItemFallback => 'आइटम';

  @override
  String posValidUntil(String date) {
    return '$date तक मान्य';
  }

  @override
  String posStockUnitPrice(String stock, String unit, String price) {
    return 'स्टॉक: $stock $unit  ·  ₹$price';
  }

  @override
  String get posNotInStock => 'स्टॉक में नहीं';

  @override
  String get posBundlePriceLabel => 'बंडल कीमत';

  @override
  String get posAddAvailableToCart => 'उपलब्ध आइटम कार्ट में जोड़ें';

  @override
  String posVoiceCount(int remaining, int total) {
    return 'वॉइस ($remaining/$total)';
  }

  @override
  String get posVoiceOrder => 'वॉइस ऑर्डर';

  @override
  String posHandwriteCount(int remaining, int total) {
    return 'हैंडराइट ($remaining/$total)';
  }

  @override
  String get posHandwrite => 'हैंडराइट';

  @override
  String get posCartEmpty => 'कार्ट खाली है';

  @override
  String get posCartEmptyHint =>
      'बिक्री शुरू करने के लिए प्रोडक्ट खोजें या बारकोड स्कैन करें.';

  @override
  String get posAddCustomer => 'कस्टमर जोड़ें';

  @override
  String posItemCount(String count) {
    return '$count आइटम';
  }

  @override
  String posPlaceOrderAmount(String amount) {
    return 'ऑर्डर करें · $amount';
  }

  @override
  String get posPosInventory => 'POS / इन्वेंट्री';

  @override
  String get posOnline => 'POS ऑनलाइन';

  @override
  String get posTabSales => 'बिक्री';

  @override
  String get posTabStock => 'स्टॉक';

  @override
  String get posTabPurchase => 'खरीद';

  @override
  String get posPurchaseSuppliers => 'खरीद और सप्लायर';

  @override
  String get posPurchaseSuppliersDesc =>
      'परचेज़ ऑर्डर बनाएँ, अपने सप्लायर मैनेज करें, और उन्हें कितना देना है ट्रैक करें — सब एक जगह.';

  @override
  String get posPaywallPurchaseDesc =>
      'परचेज़ ऑर्डर और सप्लायर मैनेज करें. डिस्ट्रिब्यूटर को भुगतान ट्रैक करें. Pro प्लान पर उपलब्ध.';

  @override
  String get posPrinterSetup => 'प्रिंटर सेटअप';

  @override
  String get posReconnect => 'फिर से कनेक्ट करें';

  @override
  String get posForgetPrinter => 'इस प्रिंटर को भूल जाएँ';

  @override
  String get posPairedDevices => 'पेयर किए गए Bluetooth डिवाइस';

  @override
  String get posNoPairedDevices => 'कोई पेयर किया डिवाइस नहीं मिला';

  @override
  String get posPairDeviceHint =>
      'पहले अपने थर्मल प्रिंटर को Android\nBluetooth सेटिंग्स में पेयर करें, फिर रिफ्रेश करें.';

  @override
  String get posProOnly => 'केवल PRO';

  @override
  String get posUpgradeToProDay =>
      'Pro में अपग्रेड करें  ₹500/माह · सिर्फ़ ₹17/दिन';

  @override
  String get posReceiptSent => 'रसीद प्रिंटर को भेजी गई';

  @override
  String get posPrintFailedCheck => 'प्रिंट विफल — प्रिंटर चेक करें';

  @override
  String get posOrderPlaced => 'ऑर्डर हो गया!';

  @override
  String posOrderNumber(String id) {
    return 'ऑर्डर #$id';
  }

  @override
  String get posPrintReceipt => 'रसीद प्रिंट करें';

  @override
  String get posNewSale => 'नई बिक्री';

  @override
  String get posViewOrderDetails => 'ऑर्डर विवरण देखें';

  @override
  String get posSelectCustomerForUdhaar => 'उधार बिक्री के लिए कस्टमर चुनें';

  @override
  String get posConfirmOrder => 'ऑर्डर कन्फ़र्म करें';

  @override
  String get posOrderConfirmed => 'ऑर्डर कन्फ़र्म हुआ!';

  @override
  String get posSubtotal => 'सबटोटल';

  @override
  String posReferralDiscount(String pct, String referrer) {
    return 'रेफरल डिस्काउंट ($pct%)$referrer';
  }

  @override
  String get posGrandTotal => 'ग्रैंड टोटल';

  @override
  String get posPaymentMethod => 'भुगतान का तरीका';

  @override
  String get posPayCash => 'कैश';

  @override
  String get posPayUdhaar => 'उधार';

  @override
  String get posUdhaarDueDate => 'वापसी की तारीख़';

  @override
  String get posUdhaarDueDateHint => 'ग्राहक कब चुकाएगा?';

  @override
  String posBundlePercentOff(int pct) {
    return '$pct% छूट';
  }

  @override
  String posBundleYouSave(String amount) {
    return '$amount की बचत';
  }

  @override
  String get posBundleRegularPrice =>
      'सामान्य कीमत पर जोड़ा गया (बंडल के लिए सभी आइटम स्टॉक में चाहिए)';

  @override
  String get posPayUpi => 'UPI';

  @override
  String get posComingSoon => 'जल्द आ रहा है';

  @override
  String get posSelectCustomerRequired => 'कस्टमर चुनें (उधार के लिए ज़रूरी)';

  @override
  String get posSelectCustomerForUdhaarTitle => 'उधार के लिए कस्टमर चुनें';

  @override
  String get posSearchNameOrPhoneHint => 'नाम या फ़ोन से खोजें…';

  @override
  String get posPrintAutomatically => 'रसीद अपने आप प्रिंट करें';

  @override
  String get posWillPrintAfter => 'ऑर्डर होने के बाद प्रिंट होगी';

  @override
  String posPrinterStatus(String status) {
    return 'प्रिंटर: $status';
  }

  @override
  String get posAutoPrintDisabled => 'बंद — ऑर्डर विवरण से मैनुअल प्रिंट करें';

  @override
  String get posConnectPrinterToEnable =>
      'इसे चालू करने के लिए ब्लूटूथ प्रिंटर कनेक्ट करें';

  @override
  String get posCustomDiscount => 'छूट (पूरे बिल पर)';

  @override
  String get procPayFirst => 'पहले चुकाएं';

  @override
  String get procUnpaid => 'बकाया';

  @override
  String get procNextDue => 'अगली देय';

  @override
  String get procProductsSupplied => 'इनसे मिलने वाले प्रोडक्ट';

  @override
  String get procTagProduct => 'प्रोडक्ट जोड़ें';

  @override
  String get procNoTaggedProducts =>
      'अभी कोई प्रोडक्ट टैग नहीं है। जो सामान इनसे खरीदते हैं उसे टैग करें — परचेज़ ऑर्डर रिसीव करने पर यह अपने आप भी जुड़ जाता है।';

  @override
  String get posHowMuchUdhaar => 'कितना उधार पर जाएगा?';

  @override
  String get posCashNow => 'अभी कैश';

  @override
  String get posOnUdhaar => 'उधार पर';

  @override
  String get posPrintFailedCheckConnection =>
      'प्रिंट विफल — प्रिंटर कनेक्शन चेक करें';

  @override
  String get posTodaysOrders => 'आज के ऑर्डर';

  @override
  String posTransactionsSoFar(int count) {
    return 'अब तक $count ट्रांज़ैक्शन';
  }

  @override
  String get posViewAll => 'सभी देखें';

  @override
  String get posNoOrdersToday => 'आज अभी तक कोई ऑर्डर नहीं';

  @override
  String get posSalesAppearHere => 'बिक्री ट्रांज़ैक्शन यहाँ दिखेंगे';

  @override
  String posOrderMeta(String time, String payment, String status) {
    return '$time · $payment · $status';
  }

  @override
  String get posPrint => 'प्रिंट';

  @override
  String get posScanBarcode => 'बारकोड स्कैन करें';

  @override
  String get posAlignBarcode => 'बारकोड को फ्रेम के अंदर रखें';

  @override
  String get posLookingUp => 'खोज रहे हैं…';

  @override
  String posAlreadyInList(String name) {
    return '$name पहले से लिस्ट में है';
  }

  @override
  String posItemQty(String name, int qty) {
    return '$name ×$qty';
  }

  @override
  String posItemAdded(String name) {
    return '$name जोड़ा गया';
  }

  @override
  String get posNotFoundTapAdd => 'नहीं मिला — मैनुअल जोड़ने के लिए टैप करें';

  @override
  String posItemsScanned(int count) {
    return '$count आइटम स्कैन हुए';
  }

  @override
  String get posScanItems => 'आइटम स्कैन करें';

  @override
  String get posClearAll => 'सभी क्लियर करें';

  @override
  String posLookingUpItems(int count) {
    return '$count आइटम खोज रहे हैं…';
  }

  @override
  String posAddItemsToCart(int count, String total) {
    return '$count आइटम कार्ट में जोड़ें  ·  ₹$total';
  }

  @override
  String get posPointCamera => 'कैमरा बारकोड की ओर रखें';

  @override
  String get posItemsAppearHere => 'स्कैन करते ही आइटम यहाँ दिखेंगे';

  @override
  String get posTransactionHistory => 'ट्रांज़ैक्शन हिस्ट्री';

  @override
  String get posFilters => 'फ़िल्टर:';

  @override
  String get posClearAllFilters => 'सभी क्लियर करें';

  @override
  String get posNoTransactions => 'कोई ट्रांज़ैक्शन नहीं मिला';

  @override
  String get posTryAdjustFilters => 'अपने फ़िल्टर बदलकर देखें';

  @override
  String get posResetFilters => 'फ़िल्टर रीसेट करें';

  @override
  String get posFilterTransactions => 'ट्रांज़ैक्शन फ़िल्टर करें';

  @override
  String get posPaymentStatus => 'भुगतान स्थिति';

  @override
  String get posFilterAll => 'सभी';

  @override
  String get posStatusCompleted => 'पूरा हुआ';

  @override
  String get posStatusPending => 'पेंडिंग';

  @override
  String get posDateRange => 'तारीख़ रेंज';

  @override
  String get posSelectDateRange => 'तारीख़ रेंज चुनें';

  @override
  String get posApplyFilters => 'फ़िल्टर लागू करें';

  @override
  String get posOrderDetails => 'ऑर्डर विवरण';

  @override
  String get posPaymentLabel => 'भुगतान';

  @override
  String get posTotalAmount => 'कुल राशि';

  @override
  String posCustomerNumber(String id) {
    return 'कस्टमर #$id';
  }

  @override
  String get posItemsSummary => 'आइटम सारांश';

  @override
  String posProductNumber(String id) {
    return 'प्रोडक्ट #$id';
  }

  @override
  String get posUnitFallback => 'यूनिट';

  @override
  String posPrintReceiptStatus(String status) {
    return 'रसीद प्रिंट करें ($status)';
  }

  @override
  String get posReturnExchange => 'रिटर्न / एक्सचेंज';

  @override
  String get posSplitPayment => 'स्प्लिट भुगतान';

  @override
  String get posCashPaidNow => 'अभी चुकाया कैश';

  @override
  String get posOnUdhaarCredit => 'उधार पर (क्रेडिट)';

  @override
  String get posUdhaarRecordedNote =>
      'उधार हिस्सा क्रेडिट के रूप में दर्ज — बैलेंस के लिए उधार टैब देखें';

  @override
  String get posUdhaarSale => 'उधार बिक्री';

  @override
  String get posTotalPaid => 'कुल चुकाया';

  @override
  String get posRecordedAsCredit => 'क्रेडिट के रूप में दर्ज — उधार टैब देखें';

  @override
  String get posBoughtAsBasket => 'बास्केट के रूप में खरीदा गया';

  @override
  String get posBasketValue => 'बास्केट मूल्य';

  @override
  String get posCustomerSaved => 'ग्राहक ने बचाए';

  @override
  String get invSearchItemsOrCategories => 'आइटम या कैटेगरी खोजें...';

  @override
  String get invShowLess => 'कम दिखाएँ';

  @override
  String invViewMore(int count) {
    return '+$count और';
  }

  @override
  String get invAll => 'सभी';

  @override
  String get invUncategorised => 'बिना कैटेगरी';

  @override
  String get invNoMatchesFound => 'कोई मैच नहीं मिला';

  @override
  String invNearExpiryBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count आइटम जल्द एक्सपायर हो रहे हैं — मार्क डाउन या क्लियर करने के लिए टैप करें',
      one:
          '1 आइटम जल्द एक्सपायर हो रहा है — मार्क डाउन या क्लियर करने के लिए टैप करें',
    );
    return '$_temp0';
  }

  @override
  String invMissingPriceBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रोडक्ट ₹0 कीमत पर हैं — कीमत सेट करने के लिए टैप करें',
      one: '1 प्रोडक्ट ₹0 कीमत पर है — कीमत सेट करने के लिए टैप करें',
    );
    return '$_temp0';
  }

  @override
  String get invFlagFast => 'फ़ास्ट';

  @override
  String get invFlagReorder => 'रीऑर्डर';

  @override
  String get invFlagLowStock => 'कम स्टॉक';

  @override
  String get invFlagDead => 'डेड';

  @override
  String get invFlagProfit => 'प्रॉफ़िट';

  @override
  String invStockLabel(String stock) {
    return 'स्टॉक: $stock';
  }

  @override
  String get invUnitFallback => 'यूनिट';

  @override
  String get invSyncFailedTapRetry =>
      'सिंक विफल — फिर से कोशिश के लिए टैप करें';

  @override
  String get invSyncingToServer => 'सर्वर पर सिंक हो रहा है...';

  @override
  String get invNoInventoryYet => 'अभी कोई इन्वेंटरी नहीं';

  @override
  String get invNoInventoryHint =>
      'अपना पहला प्रोडक्ट जोड़ने के लिए + टैप करें.\nपहले एक कैटेगरी बनाएँ, फिर आइटम जोड़ें.';

  @override
  String get invAddFirstProduct => 'पहला प्रोडक्ट जोड़ें';

  @override
  String get invCouldNotLoadInventory => 'इन्वेंटरी लोड नहीं हो सकी';

  @override
  String get invRetry => 'फिर से प्रयास करें';

  @override
  String get invSelectCategoryError => 'कृपया एक कैटेगरी चुनें';

  @override
  String invVariantPriceRequired(int number) {
    return 'वेरिएंट $number: बिक्री कीमत आवश्यक है';
  }

  @override
  String get invProductSavedSyncing =>
      'प्रोडक्ट सेव हुआ — बैकग्राउंड में सिंक हो रहा है';

  @override
  String invVariantsSavedSyncing(int count) {
    return '$count वेरिएंट सेव हुए — बैकग्राउंड में सिंक हो रहा है';
  }

  @override
  String get invAddProduct => 'प्रोडक्ट जोड़ें';

  @override
  String get invAddFromCatalog => 'कैटलॉग से जोड़ें';

  @override
  String get invNewProduct => 'नया प्रोडक्ट';

  @override
  String get invSave => 'सेव करें';

  @override
  String get invSearchProductName => 'प्रोडक्ट का नाम खोजें...';

  @override
  String get invLoadMoreResults => 'और परिणाम लोड करें';

  @override
  String get invNoMoreSearchResults => 'और कोई खोज परिणाम नहीं';

  @override
  String get invSearchProductCatalog => 'प्रोडक्ट कैटलॉग खोजें';

  @override
  String get invSearchCatalogHint =>
      'नाम टाइप करें या बारकोड स्कैन करें.\nन मिले तो मैन्युअल रूप से जोड़ें.';

  @override
  String get invAddManually => 'मैन्युअल रूप से जोड़ें';

  @override
  String get invAddManuallySub =>
      'प्रोडक्ट कैटलॉग में नहीं है? विवरण खुद दर्ज करें.';

  @override
  String get invProductAdded => 'प्रोडक्ट जोड़ा गया!';

  @override
  String invVariantsAdded(int count) {
    return '$count वेरिएंट जोड़े गए!';
  }

  @override
  String get invLooseItem => 'लूज़ आइटम';

  @override
  String get invLooseItemSub => 'वज़न से बेचा जाता है (जैसे मैदा, दाल)';

  @override
  String get invBasicDetails => 'बुनियादी विवरण';

  @override
  String get invProductNameLabel => 'प्रोडक्ट का नाम *';

  @override
  String get invRequired => 'आवश्यक';

  @override
  String get invBrandOptional => 'ब्रांड (वैकल्पिक)';

  @override
  String get invSelectCategoryStar => 'कैटेगरी चुनें *';

  @override
  String get invOther => 'अन्य';

  @override
  String get invPerishableItem => 'खराब होने वाला आइटम';

  @override
  String get invPerishableItemSub => 'एक्सपायरी तारीख़ है';

  @override
  String get invSizePriceStock => 'साइज़, कीमत & स्टॉक';

  @override
  String invVariantsCount(int count) {
    return 'वेरिएंट ($count)';
  }

  @override
  String get invAddVariant => 'वेरिएंट जोड़ें';

  @override
  String get invManageVariants => 'वेरिएंट प्रबंधित करें';

  @override
  String get invVariants => 'वेरिएंट';

  @override
  String get invEditVariant => 'वेरिएंट संपादित करें';

  @override
  String get invSaveVariant => 'वेरिएंट सहेजें';

  @override
  String get invNoVariantsYet =>
      'अभी कोई वेरिएंट नहीं। साइज़, रंग या मॉडल जोड़ें।';

  @override
  String get invStockPerVariantNote =>
      'स्टॉक हर वेरिएंट के लिए अलग ट्रैक होता है। नीचे \'वेरिएंट प्रबंधित करें\' का उपयोग करें।';

  @override
  String get invDefaultVariant => 'डिफ़ॉल्ट';

  @override
  String invVariantAxisRequired(String label) {
    return 'कृपया $label चुनें';
  }

  @override
  String get invSaveProduct => 'प्रोडक्ट सेव करें';

  @override
  String invSaveVariants(int count) {
    return '$count वेरिएंट सेव करें';
  }

  @override
  String get invProduct => 'प्रोडक्ट';

  @override
  String invVariantNumber(int number) {
    return 'वेरिएंट $number';
  }

  @override
  String get invUnit => 'यूनिट';

  @override
  String get invBaseUnit => 'बेस यूनिट';

  @override
  String get invPackSize => 'पैक साइज़';

  @override
  String get invPackSizeHint => 'जैसे 250';

  @override
  String get invBarcode => 'बारकोड';

  @override
  String get invFromCatalog => 'कैटलॉग से';

  @override
  String get invOptional => 'वैकल्पिक';

  @override
  String invPricePerUnit(String unit) {
    return 'कीमत / $unit *';
  }

  @override
  String get invSellingPriceStar => 'बिक्री कीमत *';

  @override
  String get invInvalid => 'अमान्य';

  @override
  String get invMrp => 'MRP';

  @override
  String get invCostPrice => 'कॉस्ट कीमत (जो आप चुकाते हैं)';

  @override
  String get invCostPriceHint => 'वैकल्पिक — प्रॉफ़िट सटीकता बेहतर करता है';

  @override
  String invOpeningStockUnit(String unit) {
    return 'ओपनिंग स्टॉक ($unit) *';
  }

  @override
  String get invOpeningStockUnits => 'ओपनिंग स्टॉक (यूनिट) *';

  @override
  String get invExpiryDate => 'एक्सपायरी तारीख़';

  @override
  String get invExpiryDateHint => 'YYYY-MM-DD';

  @override
  String get invRequiredForPerishables => 'खराब होने वाले आइटम के लिए आवश्यक';

  @override
  String get invLinkedFromCatalog => 'कैटलॉग से लिंक किया';

  @override
  String get invSelectCategory => 'कैटेगरी चुनें';

  @override
  String get invSearchCategories => 'कैटेगरी खोजें...';

  @override
  String get invNoCategoriesFound => 'कोई कैटेगरी नहीं मिली';

  @override
  String get invEditProduct => 'प्रोडक्ट एडिट करें';

  @override
  String invProductUpdated(String name) {
    return '$name अपडेट हुआ!';
  }

  @override
  String get invProductUpdatedSuccess => 'प्रोडक्ट सफलतापूर्वक अपडेट हुआ!';

  @override
  String get invSellingUnit => 'बिक्री यूनिट';

  @override
  String get invPricing => 'कीमत';

  @override
  String invPricePerSelected(String unit) {
    return '$unit प्रति कीमत *';
  }

  @override
  String get invMrpOptional => 'MRP (वैकल्पिक)';

  @override
  String get invStock => 'स्टॉक';

  @override
  String get invGstRate => 'GST %';

  @override
  String get invHsnCode => 'HSN कोड';

  @override
  String get invWarranty => 'वारंटी';

  @override
  String get invWarrantyCovered => 'वारंटी में कवर';

  @override
  String get invWarrantyCoveredSub =>
      'कितने समय के लिए सेट करें — खरीद की तारीख से गिना जाता है';

  @override
  String get invWarrantyPeriod => 'वारंटी अवधि';

  @override
  String invStockInUnit(String unit) {
    return 'स्टॉक ($unit में) *';
  }

  @override
  String get invStockQuantityStar => 'स्टॉक मात्रा *';

  @override
  String get invPerishableBatchNote =>
      'खराब होने वाले बैच विवरण के लिए, इन्वेंटरी से \"बैच प्राप्त करें\" इस्तेमाल करें.';

  @override
  String get invSaveChanges => 'बदलाव सेव करें';

  @override
  String get invCategoryNameRequired => 'कैटेगरी का नाम आवश्यक है';

  @override
  String get invCreateCategoryFailed =>
      'कैटेगरी बनाने में विफल. कृपया फिर से प्रयास करें.';

  @override
  String get invNewCategory => 'नई कैटेगरी';

  @override
  String get invNewCategorySub =>
      'अपने प्रोडक्ट व्यवस्थित करने के लिए एक कैटेगरी जोड़ें.';

  @override
  String get invCategoryCreated => 'कैटेगरी बन गई!';

  @override
  String get invCategoryNameLabel => 'कैटेगरी का नाम';

  @override
  String get invCategoryNameHint => 'जैसे स्टेपल्स, डेयरी, स्नैक्स…';

  @override
  String get invCreateCategory => 'कैटेगरी बनाएँ';

  @override
  String get invCardOutOfStock => 'स्टॉक में नहीं';

  @override
  String invCardStockLow(String qty) {
    return '$qty — कम';
  }

  @override
  String invCardStockInStock(String qty) {
    return '$qty स्टॉक में';
  }

  @override
  String get invCardFast => 'फ़ास्ट';

  @override
  String get invCardSlow => 'स्लो';

  @override
  String get invCardExpired => 'एक्सपायर';

  @override
  String invCardDays(String days) {
    return '${days}d';
  }

  @override
  String get invCardBarcode => 'बारकोड';

  @override
  String get invCardSoldToday => 'आज बिके';

  @override
  String get invCardReorder => 'रीऑर्डर';

  @override
  String invCardReorderUnits(String qty) {
    return '$qty यूनिट';
  }

  @override
  String get invCard7dRisk => '7d रिस्क';

  @override
  String get invExpiringSoon => 'जल्द एक्सपायर होने वाले';

  @override
  String get invNext => 'अगले';

  @override
  String invDaysWindow(int days) {
    return '$days दिन';
  }

  @override
  String get invExpired => 'एक्सपायर';

  @override
  String get invExpiresToday => 'आज एक्सपायर होगा';

  @override
  String get invExpiresTomorrow => 'कल एक्सपायर होगा';

  @override
  String invExpiresInDays(int days) {
    return '$days दिन में एक्सपायर होगा';
  }

  @override
  String invQtyInStock(String qty, String unit) {
    return '$qty $unit स्टॉक में';
  }

  @override
  String get invAtRisk => 'रिस्क पर';

  @override
  String get invMarkedDown => 'मार्क डाउन किया';

  @override
  String get invPrice => 'कीमत';

  @override
  String get invChangeMarkdown => 'मार्कडाउन बदलें';

  @override
  String get invMarkDown => 'मार्क डाउन';

  @override
  String get invRecordWaste => 'वेस्ट रिकॉर्ड करें';

  @override
  String invMarkDownTitle(String name) {
    return '$name को मार्क डाउन करें';
  }

  @override
  String get invClearanceDiscount =>
      'एक्सपायरी से पहले बेचने के लिए क्लियरेंस डिस्काउंट';

  @override
  String invPctSuggested(String pct) {
    return '$pct% (सुझाया)';
  }

  @override
  String invPct(String pct) {
    return '$pct%';
  }

  @override
  String get invCustom => 'कस्टम';

  @override
  String get invApplyMarkdown => 'मार्कडाउन लागू करें';

  @override
  String get invMarkdownApplied => 'मार्कडाउन लागू हुआ';

  @override
  String get invMarkdownFailed => 'मार्कडाउन लागू नहीं हो सका';

  @override
  String invWriteOff(String name) {
    return '$name को राइट ऑफ़ करें';
  }

  @override
  String get invWriteOffSub =>
      'खराब यूनिट स्टॉक से हटाता है और नुकसान दर्ज करता है.';

  @override
  String invOfQtyInStock(int qty) {
    return 'स्टॉक में $qty में से';
  }

  @override
  String invUnitsWrittenOff(int units) {
    return '$units यूनिट राइट ऑफ़ हुईं';
  }

  @override
  String get invWasteFailed => 'वेस्ट रिकॉर्ड नहीं हो सका';

  @override
  String get invNothingExpiring => 'जल्द कुछ भी एक्सपायर नहीं हो रहा';

  @override
  String get invNothingExpiringSub =>
      'एक्सपायरी के करीब खराब होने वाले बैच यहाँ दिखेंगे.';

  @override
  String get invCouldNotLoadExpiry => 'एक्सपायरी डेटा लोड नहीं हो सका';

  @override
  String get invMissingPrices => 'कीमत बाकी';

  @override
  String get invCouldNotLoadPrices => 'कीमतें लोड नहीं हो सकीं';

  @override
  String invStockCurrentlyZero(String qty, String unit) {
    return '$qty $unit स्टॉक में · फ़िलहाल ₹0';
  }

  @override
  String invSuggestedPrice(String price, String source) {
    return 'सुझाई ₹$price ($source)';
  }

  @override
  String get invSellingPrice => 'बिक्री कीमत';

  @override
  String get invSet => 'सेट करें';

  @override
  String get invEnterValidPrice => 'एक मान्य कीमत दर्ज करें';

  @override
  String invProductPriced(String name, String price) {
    return '$name की कीमत ₹$price रखी';
  }

  @override
  String get invCouldNotSetPrice => 'कीमत सेट नहीं हो सकी';

  @override
  String get invEveryProductPriced => 'हर प्रोडक्ट की कीमत है';

  @override
  String get invEveryProductPricedSub => 'कुछ भी ₹0 पर नहीं बिक रहा. बढ़िया!';

  @override
  String get finFinance => 'फाइनेंस';

  @override
  String get finErrorLoadingStats => 'आँकड़े लोड करने में एरर';

  @override
  String get finTabCashflow => 'कैशफ़्लो';

  @override
  String get finTabCustomerUdhaar => 'ग्राहक\nउधार';

  @override
  String get finTabSupplierUdhaar => 'सप्लायर उधार';

  @override
  String get finMonthlySales => 'मासिक सेल्स';

  @override
  String get finMonthlySkus => 'मासिक SKUs';

  @override
  String get finAvailableInFuture => 'आगे के अपडेट में उपलब्ध होगा';

  @override
  String get finFailedLoadUdhaar => 'उधार डेटा लोड नहीं हुआ';

  @override
  String get finCheckConnection =>
      'कृपया अपना कनेक्शन चेक करके फिर से कोशिश करें।';

  @override
  String get finRetry => 'फिर से कोशिश करें';

  @override
  String get finCustomerDues => 'ग्राहक बकाया';

  @override
  String get finNewUdhaar => 'नया उधार';

  @override
  String get finAddNewUdhaar => 'नया उधार जोड़ें';

  @override
  String get finContacts => 'कॉन्टैक्ट्स';

  @override
  String get finSelectExistingCustomer => 'मौजूदा ग्राहक चुनें';

  @override
  String get finOrEnterManually => 'या मैन्युअल रूप से डालें';

  @override
  String get finUdhaarRecorded => 'उधार रिकॉर्ड हो गया!';

  @override
  String get finCustomerName => 'ग्राहक का नाम';

  @override
  String get finPhoneNumber => 'फ़ोन नंबर';

  @override
  String get finAmount => 'रकम';

  @override
  String get finSaveUdhaar => 'उधार सेव करें';

  @override
  String get finEnterValidNamePhoneAmount => 'सही नाम, फ़ोन और रकम डालें';

  @override
  String get finSelectCustomer => 'ग्राहक चुनें';

  @override
  String get finSearchByNameOrPhone => 'नाम या फ़ोन से खोजें...';

  @override
  String get finNoCustomersFound => 'कोई ग्राहक नहीं मिला';

  @override
  String get finTotalPending => 'कुल पेंडिंग';

  @override
  String get finRecovered => 'वसूल हुआ';

  @override
  String get finCustomers => 'ग्राहक';

  @override
  String finHighRiskDues(int count) {
    return '$count हाई-रिस्क बकाया — इन्हें पहले वसूलें';
  }

  @override
  String get finSmartRemindersSubtitle =>
      'स्मार्ट रिमाइंडर — रिकवरी रैंक किए बकाया';

  @override
  String finTakenDaysAgo(String date, int days) {
    return 'लिया: $date ($days दिन पहले)';
  }

  @override
  String get finWhatsappReminderSent => 'WhatsApp रिमाइंडर भेज दिया!';

  @override
  String finFailedSendReminder(String error) {
    return 'रिमाइंडर भेजने में विफल: $error';
  }

  @override
  String get finSendWhatsappReminder => 'WhatsApp रिमाइंडर भेजें';

  @override
  String get finRemind => 'याद दिलाएं';

  @override
  String get finRemindedToday => 'आज याद दिला दिया';

  @override
  String get finRecover => 'वसूल करें';

  @override
  String get finHistory => 'हिस्ट्री';

  @override
  String get finSettled => 'सेटल हो गया';

  @override
  String get finRecordPayment => 'भुगतान दर्ज करें';

  @override
  String get finPaymentOldestFirstNote =>
      'सबसे पुराने बकाया में पहले लगाया गया';

  @override
  String get finTaken => 'लिया';

  @override
  String get finPaid => 'चुकाया';

  @override
  String get finBalanceShort => 'बकाया';

  @override
  String finOpenDuesSummary(int count, int days) {
    return '$count बकाया · सबसे पुराना $days दिन';
  }

  @override
  String finSettledSectionTitle(int count) {
    return 'सेटल ($count)';
  }

  @override
  String finRecoverUdhaarFrom(String name) {
    return '$name से उधार वसूल करें';
  }

  @override
  String get finRecoveryRecorded => 'रिकवरी रिकॉर्ड हो गई!';

  @override
  String finBalanceLabel(String value) {
    return 'बैलेंस: ₹$value';
  }

  @override
  String get finConfirmRecovery => 'रिकवरी कन्फर्म करें';

  @override
  String get finEnterValidAmount => 'कृपया सही रकम डालें';

  @override
  String finAmountExceedsBalance(String value) {
    return 'रकम बैलेंस ₹$value से ज़्यादा नहीं हो सकती';
  }

  @override
  String get finNoPendingUdhaars => 'कोई पेंडिंग उधार नहीं';

  @override
  String get finRecoveryHistory => 'रिकवरी हिस्ट्री';

  @override
  String get finNoRecoveriesYet => 'अभी तक कोई रिकवरी रिकॉर्ड नहीं हुई।';

  @override
  String finRecoveryNumber(int number) {
    return 'रिकवरी #$number';
  }

  @override
  String finErrorWithMessage(String message) {
    return 'एरर: $message';
  }

  @override
  String get finOverdue => 'ओवरड्यू';

  @override
  String get finDueToday => 'आज ड्यू';

  @override
  String get finNext7Days => 'अगले 7 दिन';

  @override
  String get finNoPendingPayments7Days =>
      'अगले 7 दिनों में कोई पेंडिंग भुगतान नहीं';

  @override
  String get finPaidLast7Days => 'पिछले 7 दिनों में चुकाया';

  @override
  String get finNoPaymentsRecorded7Days =>
      'पिछले 7 दिनों में कोई भुगतान रिकॉर्ड नहीं हुआ';

  @override
  String get finSuppliers => 'सप्लायर';

  @override
  String get finAddEditSuppliersHint =>
      'सप्लायर को पर्चेस टैब में जोड़ें या एडिट करें';

  @override
  String get finNoSuppliersYet => 'अभी तक कोई सप्लायर नहीं।';

  @override
  String get finTotalOutstanding => 'कुल बकाया';

  @override
  String get finToday => 'आज';

  @override
  String get finPaid7d => 'चुकाया (7d)';

  @override
  String get finStockPurchase => 'स्टॉक पर्चेस';

  @override
  String finOverdueSince(String date) {
    return '$date से ओवरड्यू';
  }

  @override
  String finDueOn(String day) {
    return '$day ड्यू';
  }

  @override
  String get finDueTodayLabel => 'आज ड्यू';

  @override
  String get finToPay => 'चुकाना है';

  @override
  String get finDetails => 'विवरण';

  @override
  String get finMarkPaid => 'चुकाया मार्क करें';

  @override
  String finPurchaseOn(String date) {
    return '$date को पर्चेस';
  }

  @override
  String get finNoItemsFound => 'कोई आइटम नहीं मिला।';

  @override
  String get finTotalBill => 'कुल बिल';

  @override
  String get finTomorrow => 'कल';

  @override
  String get finWeekdayMon => 'सोम';

  @override
  String get finWeekdayTue => 'मंगल';

  @override
  String get finWeekdayWed => 'बुध';

  @override
  String get finWeekdayThu => 'गुरु';

  @override
  String get finWeekdayFri => 'शुक्र';

  @override
  String get finWeekdaySat => 'शनि';

  @override
  String get finWeekdaySun => 'रवि';

  @override
  String get finFailedLoadCashflow => 'कैशफ़्लो डेटा लोड नहीं हुआ';

  @override
  String get finIncome => 'आय';

  @override
  String get finTodaysSales => 'आज की सेल्स';

  @override
  String get finCreditExposureUdhaar => 'क्रेडिट एक्सपोज़र (उधार)';

  @override
  String get finOutstanding => 'बकाया';

  @override
  String get finCustomersWithPendingDues => 'पेंडिंग बकाया वाले ग्राहक';

  @override
  String finCustomersCount(int count) {
    return '$count ग्राहक';
  }

  @override
  String get finCreditVsSalesRatio => 'क्रेडिट vs सेल्स अनुपात';

  @override
  String finPercentOnCredit(String value) {
    return '$value% उधार पर';
  }

  @override
  String finOfMonthly(String value) {
    return 'मासिक $value में से';
  }

  @override
  String get finCreditHealthy => 'ठीक — क्रेडिट एक्सपोज़र कम है';

  @override
  String get finCreditModerate => 'मध्यम — बकाया वसूलने के बारे में सोचें';

  @override
  String get finCreditHigh => 'ज़्यादा — कई सेल्स उधार पर हैं';

  @override
  String get finConsentTitle => 'ग्राहक की सहमति रिकॉर्ड करें';

  @override
  String get finConsentSubtitle => 'इस उधार की आवाज़ से पुष्टि';

  @override
  String get finConsentScriptIntro => 'ग्राहक से यह कहलवाएँ:';

  @override
  String finConsentScript(String total, String udhaar, String date) {
    return 'मैं सहमत हूँ — कुल $total, उधार $udhaar, मैं $date तक चुका दूँगा।';
  }

  @override
  String get finConsentTapToRecord => 'माइक दबाएँ और ग्राहक को बोलने दें';

  @override
  String get finConsentRecording => 'रिकॉर्ड हो रहा है';

  @override
  String get finConsentSaved =>
      'सहमति सहेजी गई — बैकग्राउंड में अपलोड हो रही है';

  @override
  String get finConsentSkip => 'छोड़ें';

  @override
  String get finConsentSectionTitle => 'आवाज़ सहमति';

  @override
  String get finConsentStatusPending => 'अपलोड हो गया · विश्लेषण बाकी';

  @override
  String get finConsentStatusAnalyzed => 'सत्यापित';

  @override
  String finConsentMatchScore(String pct) {
    return 'आवाज़ मिलान: $pct%';
  }

  @override
  String get finConsentNone => 'कोई आवाज़ सहमति रिकॉर्ड नहीं';

  @override
  String get finDueDate => 'वापसी की तारीख़';

  @override
  String get finDueDateHint => 'ग्राहक कब चुकाएगा?';

  @override
  String finDueBy(String date) {
    return '$date तक देना है';
  }

  @override
  String finClearingDues(int count) {
    return '$count उधार चुकाए जा रहे हैं…';
  }

  @override
  String finDuesCleared(int count) {
    return '$count उधार चुकाए गए';
  }

  @override
  String finClearingDuesProgress(int cleared, int total) {
    return 'बकाया चुकाया जा रहा: $cleared/$total';
  }

  @override
  String finDuesClearFailed(int cleared, int total) {
    return 'सभी बकाया नहीं चुक पाए ($cleared/$total)';
  }

  @override
  String get finSmartReminders => 'स्मार्ट रिमाइंडर';

  @override
  String get finCouldNotLoadReminders => 'रिमाइंडर लोड नहीं हो सके';

  @override
  String finDaysPending(int days) {
    return '$days दिन पेंडिंग';
  }

  @override
  String finRiskBadge(String band) {
    return '$band रिस्क';
  }

  @override
  String finLikelyToRecover(int percent) {
    return '~$percent% वसूल होने की संभावना';
  }

  @override
  String get finSendReminder => 'रिमाइंडर भेजें';

  @override
  String finReminderSentTo(String name) {
    return '$name को रिमाइंडर भेज दिया';
  }

  @override
  String get finCouldNotSendReminder => 'रिमाइंडर नहीं भेज सके';

  @override
  String get finNoOpenUdhaar => 'कोई खुला उधार नहीं';

  @override
  String get finAllCreditSettled => 'सारा उधार सेटल हो गया। बढ़िया और साफ़!';

  @override
  String get procAddSupplierFirstToCreatePo =>
      'पर्चेस ऑर्डर बनाने के लिए पहले एक सप्लायर ऐड करें';

  @override
  String procErrorWithMessage(String message) {
    return 'एरर: $message';
  }

  @override
  String get procSuppliers => 'सप्लायर';

  @override
  String get procNoSuppliersYet => 'अभी तक कोई सप्लायर ऐड नहीं हुआ.';

  @override
  String get procRecentPurchases => 'हाल की खरीद';

  @override
  String get procAddAtLeastOneSupplier =>
      'अगर आप खरीद ऐड करना चाहते हैं तो कम से कम 1 सप्लायर ऐड करें.';

  @override
  String get procNoPurchaseOrdersYet => 'अभी तक कोई पर्चेस ऑर्डर नहीं.';

  @override
  String get procScanInvoice => 'इनवॉइस स्कैन';

  @override
  String get procAdd => 'ऐड';

  @override
  String get procSuggestedReorders => 'सुझाए गए रीऑर्डर';

  @override
  String get procRunningLowLast30Days =>
      'पिछले 30 दिनों की बिक्री के आधार पर स्टॉक कम हो रहा है';

  @override
  String get procAddNewSupplier => 'नया सप्लायर ऐड करें';

  @override
  String get procContacts => 'कॉन्टैक्ट';

  @override
  String get procSupplierName => 'सप्लायर का नाम';

  @override
  String get procPhoneNumber => 'फोन नंबर';

  @override
  String get procCategoryHint => 'कैटेगरी (जैसे डेयरी, FMCG)';

  @override
  String get procEnterValidPhone => 'सही फोन नंबर डालें';

  @override
  String get procSaveSupplier => 'सप्लायर सेव करें';

  @override
  String get procEditSupplier => 'सप्लायर एडिट करें';

  @override
  String get procSaveChanges => 'बदलाव सेव करें';

  @override
  String get procNewPurchaseOrder => 'नया पर्चेस ऑर्डर';

  @override
  String get procRecordItemsFromDistributor =>
      'डिस्ट्रिब्यूटर से खरीदे गए सामान को रिकॉर्ड करें.';

  @override
  String get procOrderDetails => 'ऑर्डर की जानकारी';

  @override
  String get procDistributor => 'डिस्ट्रिब्यूटर';

  @override
  String get procPaymentDueDate => 'पेमेंट की ड्यू डेट';

  @override
  String get procSelectDate => 'तारीख चुनें';

  @override
  String procItemsCount(int count) {
    return 'आइटम ($count)';
  }

  @override
  String get procAddItem => 'आइटम ऐड करें';

  @override
  String get procNoItemsAddedYet => 'अभी तक कोई आइटम ऐड नहीं हुआ';

  @override
  String get procNotes => 'नोट्स';

  @override
  String get procNotesHint => 'बिल नंबर, डिलीवरी नोट्स आदि.';

  @override
  String get procTotalAmount => 'कुल राशि';

  @override
  String get procSaveOrder => 'ऑर्डर सेव करें';

  @override
  String get procSearchProduct => 'प्रोडक्ट सर्च करें...';

  @override
  String procAddProduct(String name) {
    return '$name ऐड करें';
  }

  @override
  String get procQuantity => 'क्वांटिटी';

  @override
  String get procCostPricePerUnit => 'प्रति यूनिट कॉस्ट प्राइस';

  @override
  String get procCancel => 'कैंसिल';

  @override
  String procDaysCover(String days) {
    return '${days}d कवर';
  }

  @override
  String procOrderQty(String qty) {
    return '$qty ऑर्डर करें';
  }

  @override
  String procStockLine(String stock, String perDay, String cover) {
    return 'स्टॉक $stock · ~$perDay/दिन · $cover';
  }

  @override
  String get procCreatePurchaseOrder => 'पर्चेस ऑर्डर बनाएं';

  @override
  String get procEditSupplierTooltip => 'सप्लायर एडिट करें';

  @override
  String get procMarkAsReceived => 'मिल गया के रूप में मार्क करें';

  @override
  String get procPleaseSelectSupplierFirst => 'पहले एक सप्लायर चुनें';

  @override
  String get procFromScannedInvoice => 'स्कैन की गई इनवॉइस से';

  @override
  String procPoCreatedWithUnmatched(int count) {
    return 'पर्चेस ऑर्डर बन गया! ($count आइटम मैच नहीं हुए)';
  }

  @override
  String get procPoCreatedFromInvoice => 'इनवॉइस से पर्चेस ऑर्डर बन गया!';

  @override
  String get procCameraGalleryPdf => 'कैमरा · गैलरी · PDF';

  @override
  String get procScansLabel => 'स्कैन';

  @override
  String get procScanAgain => 'फिर से स्कैन करें';

  @override
  String get procInvoiceScanProFeature => 'इनवॉइस स्कैन एक Pro फीचर है.';

  @override
  String get procUpgradeToPro => 'Pro में अपग्रेड करें';

  @override
  String get procDailyLimitReached =>
      'डेली लिमिट पूरी हो गई. जारी रखने के लिए क्रेडिट टॉप अप करें.';

  @override
  String get procBuyCredits => 'क्रेडिट खरीदें';

  @override
  String get procCreatingPurchaseOrder => 'पर्चेस ऑर्डर बन रहा है…';

  @override
  String get procPurchaseOrderCreated => 'पर्चेस ऑर्डर बन गया!';

  @override
  String get procTryAgain => 'फिर से कोशिश करें';

  @override
  String get procCaptureOrUploadInvoice =>
      'सप्लायर इनवॉइस की फोटो लें या अपलोड करें';

  @override
  String get procUpgradeOrTopUp =>
      'Pro में अपग्रेड करें या क्रेडिट टॉप अप करें';

  @override
  String get procKiranaAiReadsInvoice =>
      'Outlet AI आइटम, टोटल और सप्लायर की जानकारी पढ़ता है';

  @override
  String get procCamera => 'कैमरा';

  @override
  String get procGallery => 'गैलरी';

  @override
  String get procUploadPdfImageFile => 'PDF / इमेज फाइल अपलोड करें';

  @override
  String get procKiranaAiReadingInvoice => 'Outlet AI आपकी इनवॉइस पढ़ रहा है…';

  @override
  String get procExtractingItems => 'आइटम, क्वांटिटी और टोटल निकाल रहा है';

  @override
  String get procGrandTotal => 'ग्रैंड टोटल';

  @override
  String get procSupplierUpper => 'सप्लायर';

  @override
  String procItemsUpperCount(int count) {
    return 'आइटम ($count)';
  }

  @override
  String procMatchedCount(int count) {
    return '$count मैच हुए';
  }

  @override
  String procUnmatchedItemsWarning(int count) {
    return '$count मैच न हुए आइटम लाइन आइटम के रूप में ऐड नहीं होंगे, लेकिन पूरा इनवॉइस टोटल रिकॉर्ड हो जाएगा.';
  }

  @override
  String get procSelectSupplierToContinue =>
      'जारी रखने के लिए एक सप्लायर चुनें';

  @override
  String get procCreatePurchaseOrderTitle => 'पर्चेस ऑर्डर बनाएं';

  @override
  String procConfidencePercent(int pct) {
    return '$pct% कॉन्फिडेंस';
  }

  @override
  String get procTotalsMatch => '✓ टोटल मैच हुए';

  @override
  String get procTotalMismatch => '⚠ टोटल मैच नहीं हुआ';

  @override
  String get procUnverified => 'वेरिफाई नहीं हुआ';

  @override
  String get procPick => 'चुनें';

  @override
  String procNoMatchTapToSelect(String vendor) {
    return '\"$vendor\" के लिए कोई मैच नहीं — चुनने के लिए टैप करें';
  }

  @override
  String get procSelectSupplier => 'सप्लायर चुनें';

  @override
  String get procSelectSupplierTitle => 'सप्लायर चुनें';

  @override
  String get procNoSuppliersAddInPurchaseTab =>
      'अभी कोई सप्लायर नहीं. पर्चेस टैब में सप्लायर ऐड करें.';

  @override
  String get procLinkToInventory => 'इन्वेंटरी से लिंक करें';

  @override
  String get procSearchProducts => 'प्रोडक्ट सर्च करें…';

  @override
  String get procNoProductsFound => 'कोई प्रोडक्ट नहीं मिला';

  @override
  String procPriceStockLabel(String price, String stock) {
    return '$price · स्टॉक: $stock';
  }

  @override
  String get procMicPermissionDenied =>
      'माइक्रोफोन परमिशन नहीं मिली. कृपया इसे सेटिंग्स में एनेबल करें.';

  @override
  String get procMicNotAccessible => 'माइक्रोफोन एक्सेस नहीं हो रहा.';

  @override
  String procAddedToCartFromVoice(int count) {
    return 'वॉइस ऑर्डर से $count आइटम कार्ट में ऐड हुए';
  }

  @override
  String get procVoiceOrder => 'वॉइस ऑर्डर';

  @override
  String get procSpeakAnyIndianLanguage => 'किसी भी भारतीय भाषा में बोलें';

  @override
  String get procVoiceOrderProFeature =>
      'वॉइस ऑर्डर एक Pro फीचर है. एक्सेस के लिए अपग्रेड करें.';

  @override
  String get procUpgrade => 'अपग्रेड';

  @override
  String get procNoVoiceOrdersLeft =>
      'आज कोई वॉइस ऑर्डर नहीं बचा. और क्रेडिट लें.';

  @override
  String get procGetCredits => 'क्रेडिट लें';

  @override
  String get procVoiceLabel => 'वॉइस';

  @override
  String get procTapMicToStart => 'रिकॉर्डिंग शुरू करने के लिए माइक टैप करें';

  @override
  String get procTapToStopAndProcess => 'रोकने और प्रोसेस करने के लिए टैप करें';

  @override
  String get procKiranaAiProcessing => 'Outlet AI प्रोसेस कर रहा है…';

  @override
  String get procHeard => 'सुना';

  @override
  String get procNoItemsDetectedTryAgain =>
      'कोई आइटम नहीं मिला. कृपया फिर से कोशिश करें.';

  @override
  String get procRecordAgain => 'फिर से रिकॉर्ड करें';

  @override
  String procAddToCartCount(int count) {
    return '$count कार्ट में ऐड करें';
  }

  @override
  String get procAutoDetectsLanguages =>
      'अपने आप पहचानता है: तेलुगु · हिंदी · उर्दू · तमिल · कन्नड़ · मलयालम · इंग्लिश';

  @override
  String get procInStock => 'स्टॉक में है';

  @override
  String get procLowStock => 'स्टॉक कम';

  @override
  String get procNotFound => 'नहीं मिला';

  @override
  String get procPickFromInventory => 'इन्वेंटरी से चुनें';

  @override
  String procAddedToCartFromHandwriting(int count) {
    return 'लिखावट से $count आइटम कार्ट में ऐड हुए';
  }

  @override
  String get procCanvasNotReady => 'कैनवास तैयार नहीं है';

  @override
  String get procFailedToCaptureCanvas => 'कैनवास कैप्चर नहीं हो पाया';

  @override
  String get procHandwriteOrder => 'लिखकर ऑर्डर';

  @override
  String get procWriteItemsAnyScript => 'किसी भी लिपि में आइटम लिखें';

  @override
  String get procDrawsLabel => 'ड्रॉ';

  @override
  String get procUndoLastStroke => 'आखिरी स्ट्रोक अनडू करें';

  @override
  String get procClear => 'क्लियर';

  @override
  String get procHandwriteOrderProFeature => 'लिखकर ऑर्डर एक Pro फीचर है.';

  @override
  String get procAutoDetectAfter5s => '5s बाद अपने आप पहचानें';

  @override
  String get procWriteItemsHere => 'आइटम यहां लिखें';

  @override
  String get procUpgradeOrTopUpToWrite =>
      'लिखने के लिए अपग्रेड करें या टॉप अप करें';

  @override
  String get procHandwriteExample => 'जैसे राइस 5kg, शुगर 2kg';

  @override
  String get procDetecting => 'पहचान रहा है…';

  @override
  String get procDetectItems => 'आइटम पहचानें';

  @override
  String get procRead => 'पढ़ा';

  @override
  String get procNoItemsDetectedWriteClearly =>
      'कोई आइटम नहीं मिला. ज्यादा साफ लिखने की कोशिश करें.';

  @override
  String get procWriteAgain => 'फिर से लिखें';

  @override
  String get procAnyScriptLanguages =>
      'किसी भी लिपि में: English · తెలుగు · हिंदी · Tamil · ಕನ್ನಡ · മലയാളം';

  @override
  String procProductNumber(String id) {
    return 'प्रोडक्ट #$id';
  }

  @override
  String get procReturnExchange => 'रिटर्न / एक्सचेंज';

  @override
  String procOrderPickItemsToReturn(String id) {
    return 'ऑर्डर #$id · रिटर्न करने के लिए आइटम चुनें';
  }

  @override
  String get procRecordReturn => 'रिटर्न रिकॉर्ड करें';

  @override
  String get rackTitle => 'स्टॉक रैक';

  @override
  String get rackPlaceStock => 'स्टॉक रखें';

  @override
  String get rackSearchHint => 'उत्पाद या रैक खोजें (जैसे A1)';

  @override
  String get rackSaved => 'स्टॉक रैक में रखा गया';

  @override
  String get rackChangeQty => 'मात्रा बदलें';

  @override
  String get rackMove => 'दूसरे रैक में ले जाएँ';

  @override
  String get rackRemove => 'रैक से हटाएँ';

  @override
  String get rackRemoved => 'रैक से हटाया गया';

  @override
  String get rackMoved => 'नए रैक में ले जाया गया';

  @override
  String get rackEmpty =>
      'अभी कोई रैक सेट नहीं है। किसी उत्पाद को रैक में रखने के लिए \'स्टॉक रखें\' पर टैप करें — फिर आप उसे जल्दी ढूँढ सकते हैं।';

  @override
  String get rackNoMatch => 'आपकी खोज से कोई उत्पाद या रैक मेल नहीं खाता।';

  @override
  String get rackItems => 'वस्तुएँ';

  @override
  String get rackProduct => 'उत्पाद';

  @override
  String get rackSelectProduct => 'उत्पाद चुनें';

  @override
  String get rackPickProductFirst => 'पहले एक उत्पाद चुनें';

  @override
  String get rackNeedLabel => 'रैक / बिन लेबल दर्ज करें';

  @override
  String get rackSaveFailed => 'सहेज नहीं सका। कृपया फिर से प्रयास करें।';

  @override
  String get rackLabel => 'रैक / बिन';

  @override
  String get rackLabelHint => 'जैसे A1, ऊपरी शेल्फ़, कोल्ड स्टोरेज';

  @override
  String get rackQuantity => 'इस रैक में मात्रा';

  @override
  String get rackSave => 'सहेजें';

  @override
  String get rackLoadFailed => 'रैक लोड नहीं हो सके। अपना कनेक्शन जांचें।';

  @override
  String get rackRetry => 'फिर से कोशिश करें';

  @override
  String get rackLocation => 'रैक स्थान';

  @override
  String get rackSetLocation => 'रैक स्थान सेट करें';

  @override
  String get rackNoneForProduct => 'अभी किसी रैक में नहीं रखा गया।';

  @override
  String get tutNext => 'आगे';

  @override
  String get tutDone => 'समझ गया';

  @override
  String get tutSkip => 'छोड़ें';

  @override
  String get tutTapHere => 'आगे बढ़ने के लिए चमकते बटन पर टैप करें';

  @override
  String get tutDismiss => 'छिपाएं';

  @override
  String get tutChecklistTitle => 'शुरुआत करें';

  @override
  String tutChecklistSubtitle(int done, int total) {
    return '$total में से $done पूरे — कोई भी कदम टैप करें';
  }

  @override
  String get tutStepAddProduct => 'अपना पहला प्रोडक्ट जोड़ें';

  @override
  String get tutStepFirstSale => 'अपना पहला बिल बनाएं';

  @override
  String get tutStepUdhaar => 'एक उधार लिखें';

  @override
  String get tutStepReport => 'आज का धंधा देखें';

  @override
  String get tutStepLanguage => 'अपनी भाषा चुनें';

  @override
  String get tutWelcomeHomeTitle => 'होम';

  @override
  String get tutWelcomeHomeBody =>
      'आपका पूरा दिन एक नज़र में — बिक्री, कमाई और ज़रूरी सूचनाएं यहां हैं।';

  @override
  String get tutWelcomeKhataTitle => 'खाता';

  @override
  String get tutWelcomeKhataBody => 'आपकी उधार बही। हर उधार और वसूली एक जगह।';

  @override
  String get tutWelcomeBillingTitle => 'बिलिंग और स्टॉक';

  @override
  String get tutWelcomeBillingBody => 'बिल बनाएं और अपना माल यहां संभालें।';

  @override
  String get tutWelcomeVisionTitle => 'विज़न AI';

  @override
  String get tutWelcomeVisionBody =>
      'कैमरे से स्टॉक गिनें — शेल्फ स्कैन करें, सामान गिनें।';

  @override
  String get tutWelcomeChecklistTitle => 'यहां से शुरू करें';

  @override
  String get tutWelcomeChecklistBody =>
      'दुकान चालू करने के पांच छोटे कदम। कोई भी कदम टैप करें, हम साथ में करेंगे।';

  @override
  String get tutReportTitle => 'आज का धंधा';

  @override
  String get tutReportBody =>
      'यह कार्ड दिखाता है कि आज क्या बिका और कितना कमाया। हर शाम देखें।';

  @override
  String get tutFsSearchTitle => 'प्रोडक्ट खोजें';

  @override
  String get tutFsSearchBody =>
      'यहां प्रोडक्ट का नाम लिखें, फिर बिल में जोड़ने के लिए उस पर टैप करें।';

  @override
  String get tutFsCustomerTitle => 'ग्राहक जोड़ें';

  @override
  String get tutFsCustomerBody =>
      'खरीदने वाले ग्राहक को चुनने के लिए यहां टैप करें — या सिर्फ नाम और फोन से नया जोड़ें।';

  @override
  String get tutFsChargeTitle => 'पैसे लें';

  @override
  String get tutFsChargeBody =>
      'बिल तैयार है। पेमेंट का तरीका चुनने और बिल पूरा करने के लिए यहां टैप करें।';

  @override
  String get tutFsPaymentTitle => 'पेमेंट कैसे होगा?';

  @override
  String get tutFsPaymentBody =>
      'अभी नकद — या बाद में वसूलने के लिए उधार। उधार सीधे आपके खाते में जाता है।';

  @override
  String get tutFsConfirmTitle => 'बिल पूरा करें';

  @override
  String get tutFsConfirmBody => 'बिक्री पूरी करने के लिए इस बटन पर टैप करें।';

  @override
  String get tutApFabTitle => 'प्रोडक्ट जोड़ें';

  @override
  String get tutApFabBody =>
      'अपना पहला प्रोडक्ट दुकान में डालने के लिए + बटन टैप करें।';

  @override
  String get tutApSearchTitle => 'कैटलॉग में खोजें';

  @override
  String get tutApSearchBody =>
      'प्रोडक्ट का नाम लिखें और सूची से चुनें — नाम, फोटो और जानकारी अपने आप भर जाएगी।';

  @override
  String get tutApPriceTitle => 'आपका बेचने का दाम';

  @override
  String get tutApPriceBody => 'जिस दाम पर आप बेचते हैं, वह लिखें।';

  @override
  String get tutApStockTitle => 'कितने हैं?';

  @override
  String get tutApStockBody => 'अभी शेल्फ पर जितने हैं, वह संख्या लिखें।';

  @override
  String get tutApSaveTitle => 'सेव करें';

  @override
  String get tutApSaveBody =>
      'सेव पर टैप करें — प्रोडक्ट बेचने के लिए तैयार है।';

  @override
  String get learnTitle => 'सीखें';

  @override
  String get learnSubtitle =>
      'छोटी गाइड जो आपको ऐप घुमाती हैं। कभी भी दोबारा देखें।';

  @override
  String get learnReplayWelcome => 'ऐप की सैर';

  @override
  String get learnFlowAddProduct => 'प्रोडक्ट कैसे जोड़ें';

  @override
  String get learnFlowFirstSale => 'बिल कैसे बनाएं';

  @override
  String get learnReplay => 'दिखाओ';

  @override
  String get learnShowTips => 'टिप्स दिखाएं';

  @override
  String get learnShowTipsDesc => 'पहली बार खुलने वाली स्क्रीन पर मदद की टिप्स';

  @override
  String get procExchangeInstead => 'एक्सचेंज (ग्राहक दूसरी वस्तु लेता है)';

  @override
  String get procRefundAmount => 'रिफ़ंड राशि';

  @override
  String get fulTitle => 'अनुमान और रिटर्न';

  @override
  String get fulTabEstimates => 'अनुमान';

  @override
  String get fulTabReturns => 'रिटर्न';

  @override
  String get fulNoReturns =>
      'अभी कोई रिटर्न नहीं। जब ग्राहक कुछ वापस लाए, तो \'रिटर्न दर्ज करें\' पर टैप करके उनका ऑर्डर चुनें।';

  @override
  String get fulLogReturn => 'रिटर्न दर्ज करें';

  @override
  String get fulPickOrderTitle => 'कौन-सा ऑर्डर वापस किया जा रहा है?';

  @override
  String get fulSearchOrders => 'ऑर्डर # या ग्राहक से खोजें';

  @override
  String get fulNoOrders => 'कोई हालिया ऑर्डर नहीं मिला।';

  @override
  String get fulExchange => 'एक्सचेंज';

  @override
  String get fulRefund => 'रिफ़ंड';

  @override
  String get fulBackToShelf => 'शेल्फ़ पर वापस';

  @override
  String get fulToVendor => 'विक्रेता को';

  @override
  String get fulItems => 'वस्तुएँ';

  @override
  String get fulLoadFailed => 'लोड नहीं हो सका। कृपया अपना कनेक्शन जांचें।';

  @override
  String get fulRetry => 'फिर से कोशिश करें';

  @override
  String get estEmpty =>
      'अभी कोई अनुमान नहीं। ग्राहक के लिए एक कोटेशन बनाएँ — आप इसे साझा कर सकते हैं और बाद में बिक्री में बदल सकते हैं।';

  @override
  String get estNewEstimate => 'नया अनुमान';

  @override
  String get estWalkIn => 'वॉक-इन ग्राहक';

  @override
  String get estAddOneItem => 'कम से कम एक वस्तु जोड़ें';

  @override
  String get estSaveFailed => 'सहेज नहीं सका। कृपया फिर से प्रयास करें।';

  @override
  String get estCustomerOptional => 'ग्राहक (वैकल्पिक)';

  @override
  String get estSelectCustomer => 'ग्राहक चुनें';

  @override
  String get estAddItem => 'वस्तु जोड़ें';

  @override
  String get estValidUntil => 'इस तक मान्य';

  @override
  String get estNoExpiry => 'कोई समाप्ति नहीं';

  @override
  String get estSaveEstimate => 'अनुमान सहेजें';

  @override
  String get estItemName => 'वस्तु का नाम';

  @override
  String get estPickFromCatalog => 'कैटलॉग से चुनें';

  @override
  String get estQty => 'मात्रा';

  @override
  String get estUnitPrice => 'इकाई मूल्य';

  @override
  String get estAddedToBill => 'बिल में जोड़ा गया';

  @override
  String get estSkippedNotInCatalog => 'छोड़ा गया (कैटलॉग में नहीं)';

  @override
  String get estShareHeading => 'अनुमान / कोटेशन';

  @override
  String get estShareTotal => 'कुल';

  @override
  String get estTotal => 'कुल';

  @override
  String get estStatus => 'स्थिति';

  @override
  String get estStatusDraft => 'ड्राफ़्ट';

  @override
  String get estStatusSent => 'भेजा गया';

  @override
  String get estStatusAccepted => 'स्वीकृत';

  @override
  String get estStatusRejected => 'अस्वीकृत';

  @override
  String get estShare => 'साझा करें';

  @override
  String get estConvert => 'बिक्री में बदलें';

  @override
  String get staffTitle => 'स्टाफ़';

  @override
  String get staffTeamTab => 'टीम और उपस्थिति';

  @override
  String get staffTasksTab => 'कार्य';

  @override
  String get staffNoStaff => 'अभी कोई स्टाफ़ नहीं। अपनी टीम जोड़ें।';

  @override
  String get staffAddStaff => 'स्टाफ़ जोड़ें';

  @override
  String get staffNoTasks =>
      'अभी कोई कार्य नहीं। अपनी टीम के लिए कार्य या चेकलिस्ट आइटम जोड़ें।';

  @override
  String get staffAddTask => 'कार्य जोड़ें';

  @override
  String get jobTitle => 'जॉब कार्ड';

  @override
  String get jobNewJob => 'नया जॉब';

  @override
  String get jobNewJobCard => 'नया जॉब कार्ड';

  @override
  String get jobRepair => 'मरम्मत';

  @override
  String get jobAlteration => 'फेरबदल';

  @override
  String get jobPreorder => 'प्री-ऑर्डर';

  @override
  String get wtyIssue => 'समस्या';

  @override
  String get wtySelectSerial => 'एक सीरियल चुनें';

  @override
  String get wtyCreateClaim => 'क्लेम बनाएँ';

  @override
  String get wtyNoClaims => 'कोई वारंटी क्लेम दर्ज नहीं।';

  @override
  String get wtyTitle => 'वारंटी और सीरियल';

  @override
  String get wtyTabClaims => 'क्लेम';

  @override
  String get wtyTabSerials => 'सीरियल';

  @override
  String get wtyNewClaim => 'नया क्लेम';

  @override
  String get wtyAddSerial => 'सीरियल जोड़ें';

  @override
  String get wtySearchSerials => 'सीरियल / IMEI या उत्पाद खोजें';

  @override
  String get wtyNoSerials =>
      'अभी कोई सीरियल पंजीकृत नहीं। चेकआउट पर या नीचे दिए बटन से सीरियल जोड़ें।';

  @override
  String get wtyAll => 'सभी';

  @override
  String get wtyInStock => 'स्टॉक में';

  @override
  String get wtySold => 'बिका';

  @override
  String get wtyProduct => 'उत्पाद';

  @override
  String get wtySelectProduct => 'उत्पाद चुनें';

  @override
  String get wtySerialImei => 'सीरियल / IMEI नंबर';

  @override
  String get wtySoldOn => 'बिका';

  @override
  String get wtyExpired => 'वारंटी समाप्त';

  @override
  String get wtyExpires => 'समाप्त होगी';

  @override
  String get wtyWarrantyTill => 'वारंटी में तक';

  @override
  String get wtyPickProduct => 'पहले उत्पाद चुनें';

  @override
  String get wtyEnterSerial => 'सीरियल / IMEI दर्ज करें';

  @override
  String get wtySaveFailed => 'सहेज नहीं सका। कृपया फिर से प्रयास करें।';

  @override
  String get wtySave => 'सहेजें';

  @override
  String get staffComm => 'कमीशन';

  @override
  String get staffEdit => 'संपादित करें';

  @override
  String get staffOrders30d => 'ऑर्डर (30 दिन)';

  @override
  String get staffCommEarned => 'कमीशन';

  @override
  String get staffEditMember => 'स्टाफ़ सदस्य संपादित करें';

  @override
  String get staffName => 'नाम';

  @override
  String get staffPhoneOptional => 'फ़ोन (वैकल्पिक)';

  @override
  String get staffRoleOptional => 'भूमिका (वैकल्पिक)';

  @override
  String get staffCommissionField => 'कमीशन';

  @override
  String get staffActive => 'सक्रिय';

  @override
  String get staffActiveHint =>
      'निष्क्रिय स्टाफ़ सूचियों और बिलिंग से छिपा रहता है।';

  @override
  String get staffSaveChanges => 'बदलाव सहेजें';

  @override
  String get staffAssignedTo => 'को सौंपा गया';

  @override
  String get staffBilledBy => 'बिल किसने बनाया (वैकल्पिक)';

  @override
  String get staffNotSet => 'सेट नहीं';

  @override
  String get fulReturnsOnOrder => 'इस बिल पर रिटर्न';

  @override
  String procBoughtQty(String qty) {
    return 'खरीदा $qty ';
  }

  @override
  String get procBackToShelf => 'शेल्फ पर वापस';

  @override
  String get procResaleable => 'फिर से बेचने लायक';

  @override
  String get procDamagedToVendor => 'खराब → वेंडर को';

  @override
  String procReturnRecordedShelf(int count) {
    return 'रिटर्न रिकॉर्ड हुआ — $count शेल्फ पर वापस';
  }

  @override
  String procReturnToVendorSuffix(int count) {
    return ', $count वेंडर को';
  }

  @override
  String get procCouldNotRecordReturn => 'रिटर्न रिकॉर्ड नहीं हो पाया';

  @override
  String get subYourInsights => 'आपके इनसाइट्स';

  @override
  String get subError => 'एरर';

  @override
  String get subManageKpis => 'KPI मैनेज करें';

  @override
  String get subManageSubscriptions => 'सब्सक्रिप्शन मैनेज करें';

  @override
  String get subDone => 'हो गया';

  @override
  String subKpisSelected(int n) {
    return '$n KPI चुने गए';
  }

  @override
  String get subSelectAll => 'सभी चुनें';

  @override
  String get subClear => 'क्लियर';

  @override
  String get subUnselect => 'हटाएं';

  @override
  String subProKpiName(String name) {
    return 'Pro KPI: $name';
  }

  @override
  String get subConfirmSelections => 'चयन की पुष्टि करें';

  @override
  String get subNoActiveKpis => 'कोई एक्टिव KPI नहीं';

  @override
  String get subManageToSeeInsights =>
      'इनसाइट्स देखने के लिए अपने सब्सक्रिप्शन मैनेज करें';

  @override
  String get subFailedLoadInsights => 'लाइव इनसाइट्स लोड करने में विफल';

  @override
  String get subManageInventory => 'इन्वेंटरी मैनेज करें';

  @override
  String get subSendReminders => 'रिमाइंडर भेजें';

  @override
  String get subReminderMessage =>
      'नमस्ते, यह आपके साथ हमारे व्यापार के बारे में एक रिमाइंडर है। कृपया अपने नवीनतम अपडेट देखें।';

  @override
  String get subNewSale => 'नई बिक्री';

  @override
  String get subAiSummary => 'AI सारांश';

  @override
  String subPoweredBy(String agent) {
    return '$agent द्वारा';
  }

  @override
  String get subTarget => 'टारगेट';

  @override
  String get subBaseline => 'बेसलाइन';

  @override
  String get subLiveDataBreakdown => 'लाइव डेटा ब्रेकडाउन';

  @override
  String get subMlInsights => 'MI इनसाइट्स';

  @override
  String get subNoDynamicInsights =>
      'इस KPI के लिए कोई डायनामिक इनसाइट्स उपलब्ध नहीं हैं।';

  @override
  String subPctVsLastPeriod(String pct) {
    return 'पिछली अवधि की तुलना में $pct%';
  }

  @override
  String get subCurrent => 'वर्तमान';

  @override
  String get subWhyThisValue => 'यह वैल्यू क्यों?';

  @override
  String get subSomethingWentWrong => 'ओह! कुछ गलत हो गया';

  @override
  String get subRetry => 'फिर से प्रयास करें';

  @override
  String get subSubscriptionAndPlans => 'सब्सक्रिप्शन & प्लान';

  @override
  String subErrorWithDetail(String detail) {
    return 'एरर: $detail';
  }

  @override
  String get subCancelSubscriptionTitle => 'सब्सक्रिप्शन कैंसिल करें?';

  @override
  String get subCancelSubscriptionBody =>
      'आपका सब्सक्रिप्शन तुरंत कैंसिल हो जाएगा। आप कभी भी फिर से सब्सक्राइब कर सकते हैं।';

  @override
  String get subKeepPlan => 'प्लान रखें';

  @override
  String get subCancelSubscription => 'सब्सक्रिप्शन कैंसिल करें';

  @override
  String get subSubscriptionCancelled => 'सब्सक्रिप्शन कैंसिल हो गया।';

  @override
  String subCancelFailed(String detail) {
    return 'कैंसिल विफल: $detail';
  }

  @override
  String get subChooseYourPlan => 'अपना प्लान चुनें';

  @override
  String get subFeaturePosSales => 'POS & बिक्री मैनेजमेंट';

  @override
  String get subFeatureInventoryTracking => 'इन्वेंटरी ट्रैकिंग';

  @override
  String get subFeatureFinanceUdhaar => 'फाइनेंस & उधार';

  @override
  String get subFeatureKpiInsights => 'KPI इनसाइट्स (प्रति कैटेगरी 3)';

  @override
  String get subFeatureCustomerRelations => 'कस्टमर रिलेशन्स';

  @override
  String get subFeatureAiRecommendations => 'AI सिफारिशें';

  @override
  String get subFeatureAllKpiCategories => 'सभी KPI कैटेगरी (असीमित)';

  @override
  String get subFeatureVendorProcurement => 'वेंडर & प्रोक्योरमेंट मैनेजमेंट';

  @override
  String get subFeatureCashflowSupport => 'कैशफ्लो सपोर्ट (₹10L तक)';

  @override
  String get subFeatureCustomerGrowth => 'कस्टमर ग्रोथ इंजन';

  @override
  String get subPerMonth => '/महीना';

  @override
  String get subRestorePurchases => 'खरीदारी रीस्टोर करें';

  @override
  String get subNeedHelp => 'मदद चाहिए?';

  @override
  String get subReachWhatsApp =>
      'प्लान संबंधी सवाल या बिलिंग सपोर्ट के लिए WhatsApp पर हमसे संपर्क करें।';

  @override
  String get subWhatsAppSupport => 'WhatsApp सपोर्ट';

  @override
  String get subWhatsAppHelpMessage =>
      'नमस्ते! मुझे अपने Outlet AI सब्सक्रिप्शन में मदद चाहिए।';

  @override
  String subCurrentPlanLabel(String plan) {
    return 'वर्तमान: $plan';
  }

  @override
  String get subTimeRemaining => 'शेष समय: ';

  @override
  String get subBest => 'BEST';

  @override
  String subJustPerDay(String price) {
    return 'केवल $price/दिन';
  }

  @override
  String get subTrialPlanNotice =>
      'आप इस प्लान के फ्री ट्रायल पर हैं। ट्रायल खत्म होने के बाद एक्सेस बनाए रखने के लिए अपग्रेड करें।';

  @override
  String get subCurrentPlan => 'वर्तमान प्लान';

  @override
  String subUpgradeToKeepAccess(String name) {
    return '$name एक्सेस बनाए रखने के लिए अपग्रेड करें';
  }

  @override
  String subPayAndActivate(String name) {
    return '$name पे करें & एक्टिवेट करें';
  }

  @override
  String get subPaywallFeatureEverythingBasic => 'Basic में सब कुछ';

  @override
  String get subPaywallFeaturePriorityAi => 'प्राथमिकता AI सिफारिशें';

  @override
  String get subProFeature => 'PRO फीचर';

  @override
  String get subProPlanIncludes => 'Pro प्लान में शामिल है:';

  @override
  String get subNotNow => 'अभी नहीं';

  @override
  String get subUpgradeToProPrice =>
      'Pro में अपग्रेड करें  ₹500/माह · केवल ₹17/दिन';

  @override
  String get subInvoicePack => 'इनवॉइस पैक';

  @override
  String get subVoicePack => 'वॉइस पैक';

  @override
  String get subHandwritingPack => 'हैंडराइटिंग पैक';

  @override
  String get subInvoicePackDesc => '10 और सप्लायर बिल प्रोसेस करें';

  @override
  String get subVoicePackDesc => '10 और ऑडियो/वॉइस ऑर्डर जोड़ें';

  @override
  String get subHandwritingPackDesc => '10 और हस्तलिखित नोट्स स्कैन करें';

  @override
  String get subPrice => 'कीमत';

  @override
  String get subCreditsRollOverDaily =>
      'क्रेडिट खत्म नहीं होते — हर दिन रोल ओवर हो जाते हैं।';

  @override
  String get subCancel => 'रद्द करें';

  @override
  String subPayAmount(int amount) {
    return '₹$amount पे करें';
  }

  @override
  String subCreditsAdded(int count, String name) {
    return '$count $name क्रेडिट जोड़े गए!';
  }

  @override
  String get subTopUpCredits => 'अपने क्रेडिट टॉप अप करें';

  @override
  String get subCreditsNeverExpire =>
      'क्रेडिट कभी खत्म नहीं होते — कल के लिए रोल ओवर हो जाते हैं!';

  @override
  String subCreditsCount(int count) {
    return '$count क्रेडिट';
  }

  @override
  String get subBuy => 'खरीदें';

  @override
  String get subTrialExpiredMessage =>
      'आपका फ्री ट्रायल खत्म हो गया है। जारी रखने के लिए अपग्रेड करें।';

  @override
  String get subTrialLastDayMessage =>
      'आपके फ्री ट्रायल का आखिरी दिन! अभी अपग्रेड करें।';

  @override
  String subTrialDaysLeftMessage(int n) {
    return 'आपके ट्रायल में $n दिन बचे हैं। Basic या Pro में अपग्रेड करें।';
  }

  @override
  String get subTrialExpiringSoon => 'ट्रायल जल्द खत्म हो रहा है';

  @override
  String get subTrialExpiredTitle => 'ट्रायल समाप्त';

  @override
  String get mktMyBaskets => 'मेरे बास्केट';

  @override
  String get mktCouldNotLoadBaskets => 'बास्केट लोड नहीं हो सके';

  @override
  String get mktPullDownToRetry => 'फिर से कोशिश करने के लिए नीचे खींचें';

  @override
  String get mktRetry => 'फिर कोशिश करें';

  @override
  String get mktNewBasket => 'नया बास्केट';

  @override
  String get mktNoBasketsYet => 'अभी कोई बास्केट नहीं';

  @override
  String get mktBasketsEmptySubtitle =>
      'कॉम्बो डील और बंडल ऑफर बनाएं.\nWhatsApp के जरिए अपने सभी ग्राहकों को अलर्ट भेजें.';

  @override
  String get mktCreateFirstBasket => 'पहला बास्केट बनाएं';

  @override
  String get mktDeleteBasketTitle => 'बास्केट हटाएं?';

  @override
  String mktDeleteBasketConfirm(String name) {
    return '\"$name\" हटाएं? इसे वापस नहीं किया जा सकता.';
  }

  @override
  String get mktCancel => 'रद्द करें';

  @override
  String get mktBasketDeleted => 'बास्केट हटा दिया गया';

  @override
  String get mktCouldNotDeleteBasket =>
      'बास्केट नहीं हटा सके. कृपया फिर कोशिश करें.';

  @override
  String get mktDelete => 'हटाएं';

  @override
  String get mktSendWhatsAppAlertTitle => 'WhatsApp अलर्ट भेजें?';

  @override
  String mktSendWhatsAppAlertConfirm(String name) {
    return '\"$name\" बास्केट डील WhatsApp के जरिए अपने सभी ग्राहकों को भेजें?';
  }

  @override
  String get mktSend => 'भेजें';

  @override
  String mktWhatsAppAlertSent(int sent, int total) {
    return '$total में से $sent ग्राहकों को WhatsApp अलर्ट भेज दिया गया!';
  }

  @override
  String get mktNoCustomersWithPhone => 'फोन नंबर वाला कोई ग्राहक नहीं मिला.';

  @override
  String mktWhatsAppNotActiveYet(int total) {
    return 'WhatsApp अभी चालू नहीं है. चालू होने पर $total ग्राहकों को अलर्ट अपने आप भेज दिया जाएगा.';
  }

  @override
  String mktAlertFailed(String error) {
    return 'विफल: $error';
  }

  @override
  String get mktExpired => 'समाप्त';

  @override
  String get mktItem => 'आइटम';

  @override
  String mktFromDate(String date) {
    return '$date से';
  }

  @override
  String mktToDate(String date) {
    return '$date तक';
  }

  @override
  String get mktAlertCustomers => 'ग्राहकों को अलर्ट';

  @override
  String get mktNoProductsInInventory =>
      'इन्वेंटरी में कोई प्रोडक्ट नहीं. पहले POS सिंक करें.';

  @override
  String get mktAllProductsAdded =>
      'सभी प्रोडक्ट पहले से इस बास्केट में जुड़े हैं';

  @override
  String get mktBasketNameRequired => 'बास्केट का नाम जरूरी है';

  @override
  String get mktAddAtLeastOneProduct =>
      'इन्वेंटरी से कम से कम एक प्रोडक्ट जोड़ें';

  @override
  String get mktSave => 'सेव करें';

  @override
  String get mktBasketNameLabel => 'बास्केट का नाम *';

  @override
  String get mktBasketNameHint => 'उदा. ब्रेकफास्ट बंडल';

  @override
  String get mktDescriptionOptional => 'विवरण (वैकल्पिक)';

  @override
  String get mktDescriptionHint => 'उदा. दूध + ब्रेड + अंडे';

  @override
  String get mktBundlePriceOptional => 'बंडल कीमत (वैकल्पिक)';

  @override
  String get mktValidity => 'वैधता';

  @override
  String get mktFromDateLabel => 'किस तारीख से';

  @override
  String get mktToDateLabel => 'किस तारीख तक';

  @override
  String get mktProducts => 'प्रोडक्ट';

  @override
  String get mktAddProduct => 'प्रोडक्ट जोड़ें';

  @override
  String get mktTapToPickProducts =>
      'अपनी इन्वेंटरी से प्रोडक्ट चुनने के लिए टैप करें';

  @override
  String mktPricePerUnit(String price) {
    return '₹$price / यूनिट';
  }

  @override
  String get mktQty => 'मात्रा';

  @override
  String get mktCreateBasket => 'बास्केट बनाएं';

  @override
  String get mktSelectProduct => 'प्रोडक्ट चुनें';

  @override
  String get mktSearchProducts => 'प्रोडक्ट खोजें...';

  @override
  String get mktNoProductsFound => 'कोई प्रोडक्ट नहीं मिला';

  @override
  String get mktAdd => 'जोड़ें';

  @override
  String get mktEstTotal => 'अनुमानित कुल';

  @override
  String get mktAddAll => 'सभी जोड़ें';

  @override
  String get mktNotInStock => 'स्टॉक में नहीं';

  @override
  String mktCampaignItemStock(String qty, String unit, String price) {
    return 'स्टॉक: $qty $unit  ·  ₹$price';
  }

  @override
  String get mktEstimatedTotal => 'अनुमानित कुल';

  @override
  String get mktNoItemsInStock => 'स्टॉक में कोई आइटम नहीं';

  @override
  String mktAddAvailableItemsToCart(int count) {
    return 'उपलब्ध $count आइटम कार्ट में जोड़ें';
  }

  @override
  String get mktAreaAssociations => 'एरिया एसोसिएशन';

  @override
  String get mktMyAreas => 'मेरे एरिया';

  @override
  String get mktCustomerHeatmap => 'ग्राहक हीटमैप';

  @override
  String mktErrorWithMessage(String error) {
    return 'एरर: $error';
  }

  @override
  String get mktNoAreasAddedYet => 'अभी कोई एरिया नहीं जोड़ा';

  @override
  String get mktAreasEmptySubtitle =>
      'टार्गेटेड कैंपेन सुझाव पाने के लिए आसपास के अपार्टमेंट, हॉस्टल, स्कूल या ऑफिस जोड़ें.';

  @override
  String get mktAddFirstArea => 'पहला एरिया जोड़ें';

  @override
  String get mktRemoveAreaTitle => 'एरिया हटाएं?';

  @override
  String mktRemoveAreaConfirm(String name) {
    return '\"$name\" को अपने एसोसिएशन से हटाएं?';
  }

  @override
  String get mktRemove => 'हटाएं';

  @override
  String mktHouseholdsCount(int count) {
    return '~$count घर';
  }

  @override
  String get mktNoHeatmapDataYet => 'अभी कोई हीटमैप डेटा नहीं';

  @override
  String get mktHeatmapEmptySubtitle =>
      'एरिया जोड़ें और ग्राहकों को उन एरिया से टैग करें. आय का डेटा समय के साथ यहां दिखेगा.';

  @override
  String get mktLast90DaysByRevenue => 'पिछले 90 दिन · आय के अनुसार';

  @override
  String get mktCustomers => 'ग्राहक';

  @override
  String get mktOrders => 'ऑर्डर';

  @override
  String get mktAvgOrder => 'औसत ऑर्डर';

  @override
  String get mktNoOrdersYetTagCustomers =>
      'अभी कोई ऑर्डर नहीं — ट्रैक करने के लिए ग्राहकों को इस एरिया से टैग करें';

  @override
  String get mktAddNearbyArea => 'आसपास का एरिया जोड़ें';

  @override
  String get mktAreaType => 'एरिया का प्रकार';

  @override
  String get mktAreaNameLabel => 'नाम (उदा. प्रेस्टीज अपार्टमेंट्स)';

  @override
  String get mktEstimatedHouseholdsOptional =>
      'अनुमानित घरों की संख्या (वैकल्पिक)';

  @override
  String get mktNotesOptional => 'नोट्स (वैकल्पिक)';

  @override
  String get mktAddArea => 'एरिया जोड़ें';

  @override
  String get mktCustomerGrowth => 'ग्राहक ग्रोथ';

  @override
  String get mktNewCampaign => 'नया कैंपेन';

  @override
  String get mktNoCampaignsYet => 'अभी कोई कैंपेन नहीं';

  @override
  String get mktReferralEmptySubtitle =>
      'एक रेफरल कैंपेन बनाएं ताकि आपके मौजूदा ग्राहक नए ग्राहक लाएं — और इसके लिए उन्हें रिवॉर्ड दें.';

  @override
  String get mktCreateFirstCampaign => 'पहला कैंपेन बनाएं';

  @override
  String get mktReferralHowItWorks =>
      'ग्राहक अपना QR दोस्तों के साथ शेयर करते हैं. नए आने वाले POS में इसे स्कैन करके डिस्काउंट पाते हैं — और रेफर करने वाले को माइलस्टोन रिवॉर्ड मिलते हैं.';

  @override
  String mktCampaignSummary(String discount, String reward, int n) {
    return 'नए ग्राहकों के लिए $discount% ऑफ  •  हर $n रेफ पर $reward% रिवॉर्ड';
  }

  @override
  String get mktQrCodes => 'QR कोड';

  @override
  String get mktReferrals => 'रेफरल';

  @override
  String get mktMaxPerPerson => 'अधिकतम/व्यक्ति';

  @override
  String get mktGenerateQr => 'QR जनरेट करें';

  @override
  String mktGenerateQrTitle(String name) {
    return 'QR जनरेट करें · $name';
  }

  @override
  String get mktSearchCustomer => 'ग्राहक खोजें…';

  @override
  String get mktNoCustomersFound => 'कोई ग्राहक नहीं मिला';

  @override
  String get mktNoPhoneForCustomer => 'इस ग्राहक का फोन नंबर नहीं है';

  @override
  String mktReferralWhatsAppMessage(
    String name,
    String code,
    String discount,
    int n,
  ) {
    return 'हाय $name! 🎁\n\nआपको हमारी दुकान अपने दोस्तों के साथ शेयर करने का न्योता है!\n\nआपका रेफरल कोड: $code\n\nजब आपका दोस्त हमारी दुकान पर आकर यह कोड दिखाएगा, तो उसे $discount% ऑफ मिलेगा — और आप हर $n दोस्त लाने पर रिवॉर्ड कमाएंगे! 🙌\n\n— LohiyaAI Kirana से';
  }

  @override
  String get mktWhatsAppNotInstalled => 'इस डिवाइस पर WhatsApp इंस्टॉल नहीं है';

  @override
  String get mktReferralQrCode => 'रेफरल QR कोड';

  @override
  String mktPercentOffForNewCustomers(String discount) {
    return 'नए ग्राहकों के लिए $discount% ऑफ';
  }

  @override
  String mktMilestoneRewardLabel(String reward, int n) {
    return 'माइलस्टोन रिवॉर्ड: हर $n रेफरल पर $reward%';
  }

  @override
  String get mktReferralCodeCopied => 'रेफरल कोड कॉपी हो गया';

  @override
  String get mktSendViaWhatsApp => 'WhatsApp के जरिए भेजें';

  @override
  String get mktQrScreenshotHint =>
      'या यह QR स्क्रीन सीधे ग्राहक को दिखाएं ताकि वे स्क्रीनशॉट ले सकें.';

  @override
  String get mktInvalidQrCode => 'गलत QR कोड';

  @override
  String get mktCampaignNoLongerActive => 'यह रेफरल कैंपेन अब चालू नहीं है';

  @override
  String get mktCouldNotLoadReferralInfo => 'रेफरल जानकारी लोड नहीं हो सकी';

  @override
  String get mktEnterValidPhone => 'सही 10-अंकों का फोन नंबर डालें';

  @override
  String get mktClose => 'बंद करें';

  @override
  String mktReferralFrom(String name) {
    return '$name से रेफरल';
  }

  @override
  String mktCampaignDiscountForNewCustomer(String campaign, String discount) {
    return '$campaign  •  नए ग्राहक के लिए $discount% डिस्काउंट';
  }

  @override
  String get mktNewCustomerDetails => 'नए ग्राहक का विवरण';

  @override
  String get mktNewCustomerPhoneHelper =>
      'नए ग्राहक का फोन डालें. जब आप ऑर्डर लगाएंगे तब डिस्काउंट लागू होगा.';

  @override
  String get mktPhoneNumber => 'फोन नंबर';

  @override
  String get mktCustomerNameOptional => 'ग्राहक का नाम (वैकल्पिक)';

  @override
  String get mktCustomerNameHint => 'उदा. ज्ञान कुमार';

  @override
  String mktApplyReferralDiscount(String discount) {
    return '$discount% रेफरल डिस्काउंट लागू करें';
  }

  @override
  String get mktCampaignNameRequired => 'कैंपेन का नाम जरूरी है';

  @override
  String get mktEnterValidDiscount => 'सही डिस्काउंट % डालें (1–100)';

  @override
  String get mktMilestoneCountMin => 'माइलस्टोन काउंट कम से कम 1 होना चाहिए';

  @override
  String get mktEnterValidReward => 'सही रिवॉर्ड % डालें (1–100)';

  @override
  String get mktMaxReferralsMin => 'अधिकतम रेफरल कम से कम 1 होने चाहिए';

  @override
  String get mktFailedToCreateCampaign =>
      'कैंपेन बनाना विफल रहा. कृपया फिर कोशिश करें.';

  @override
  String get mktNewReferralCampaign => 'नया रेफरल कैंपेन';

  @override
  String get mktCampaignName => 'कैंपेन का नाम';

  @override
  String get mktCampaignNameHint => 'उदा. समर रेफरल ड्राइव';

  @override
  String get mktNewCustomerDiscountPct => 'नए ग्राहक का डिस्काउंट %';

  @override
  String get mktMilestoneRewardPct => 'माइलस्टोन रिवॉर्ड %';

  @override
  String get mktRewardEveryNReferrals => 'हर N रेफरल पर रिवॉर्ड';

  @override
  String get mktRewardEveryNHelper =>
      'रेफर करने वाला हर N नए ग्राहक लाने पर एक माइलस्टोन रिवॉर्ड कमाता है';

  @override
  String get mktMaxReferralsPerCustomer => 'प्रति ग्राहक अधिकतम रेफरल';

  @override
  String get mktMaxReferralsHelper =>
      'इतने सफल रेफरल के बाद ग्राहक को रिवॉर्ड देना बंद करें';

  @override
  String get mktCreateCampaign => 'कैंपेन बनाएं';

  @override
  String get profProfile => 'प्रोफ़ाइल';

  @override
  String profErrorLoadingProfile(String error) {
    return 'प्रोफ़ाइल लोड करने में दिक्कत: $error';
  }

  @override
  String get profNoUserData => 'कोई यूज़र डेटा नहीं मिला.';

  @override
  String get profCashflowSupport => 'कैशफ़्लो सपोर्ट';

  @override
  String get profCashflowSupportDesc =>
      'अपने हिसाब के रीपेमेंट प्लान के साथ ₹50K – ₹10L बिज़नेस फ़ाइनेंस के लिए अप्लाई करें.';

  @override
  String get profCashflowBannerSubtitle =>
      '₹50K – ₹10L बिज़नेस फ़ाइनेंस के लिए अप्लाई करें';

  @override
  String get profSectionCustomers => 'ग्राहक';

  @override
  String get profSectionAnalytics => 'एनालिटिक्स';

  @override
  String get profSectionOperations => 'संचालन';

  @override
  String get profSectionSalesMarketing => 'बिक्री और मार्केटिंग';

  @override
  String get profSectionStoreAccount => 'स्टोर & अकाउंट';

  @override
  String get profSectionPlanSupport => 'प्लान & सपोर्ट';

  @override
  String get profSectionAdmin => 'एडमिन';

  @override
  String get profCustomerGrowth => 'कस्टमर ग्रोथ';

  @override
  String get profCustomerGrowthDesc =>
      'रेफ़रल इंजन बनाएं — अपने खुश ग्राहकों से नए ग्राहक अपने आप लाएं.';

  @override
  String get profCustomerRelations => 'कस्टमर रिलेशन्स';

  @override
  String get profAreaAssociations => 'एरिया एसोसिएशन';

  @override
  String get profKpiSubscriptions => 'KPI सब्सक्रिप्शन';

  @override
  String get profTransactionHistory => 'ट्रांज़ैक्शन हिस्ट्री';

  @override
  String get profMyBaskets => 'मेरी बास्केट';

  @override
  String get profLoyalty => 'लॉयल्टी एवं ऑफ़र';

  @override
  String get profServices => 'सेवाएँ एवं अपॉइंटमेंट';

  @override
  String get profStoreComparison => 'स्टोर तुलना';

  @override
  String get profStaff => 'स्टाफ़';

  @override
  String get profEstimatesReturns => 'अनुमान एवं वापसी';

  @override
  String get profStockRacks => 'स्टॉक रैक';

  @override
  String get profJobCards => 'जॉब कार्ड';

  @override
  String get profWarranty => 'वारंटी एवं सीरियल';

  @override
  String get profGstReport => 'जीएसटी रिपोर्ट';

  @override
  String get profLanguage => 'भाषा';

  @override
  String get profStoreSettings => 'स्टोर सेटिंग्स';

  @override
  String get profSwitchStore => 'स्टोर बदलें / जोड़ें';

  @override
  String get profConfiguration => 'कॉन्फ़िगरेशन';

  @override
  String get profPasswordSecurity => 'पासवर्ड & सिक्योरिटी';

  @override
  String get profSubscriptionPlans => 'सब्सक्रिप्शन & प्लान';

  @override
  String get profHelpSupport => 'हेल्प & सपोर्ट';

  @override
  String get profUserActivity => 'यूज़र एक्टिविटी';

  @override
  String get profSignOut => 'साइन आउट';

  @override
  String get profTrialExpired => 'ट्रायल खत्म';

  @override
  String get profAwaitingActivation => 'एक्टिवेशन का इंतज़ार';

  @override
  String get profProTrial => 'प्रो ट्रायल';

  @override
  String get profBasicTrial => 'बेसिक ट्रायल';

  @override
  String profTrialDaysLeft(String tier, int days) {
    return '$tier · ${days}d बाकी';
  }

  @override
  String profTrialActive(String tier) {
    return '$tier एक्टिव';
  }

  @override
  String get profBasicPlan => 'बेसिक प्लान';

  @override
  String get profProPlan => 'प्रो प्लान';

  @override
  String get profSyncContacts => 'कॉन्टैक्ट सिंक करें';

  @override
  String get profRefreshList => 'लिस्ट रिफ्रेश करें';

  @override
  String get profAddCustomer => 'ग्राहक जोड़ें';

  @override
  String get profSearchByNameOrPhone => 'नाम या फ़ोन से खोजें...';

  @override
  String get profRetry => 'फिर से कोशिश करें';

  @override
  String profNoSegmentCustomers(String segment) {
    return 'कोई $segment ग्राहक नहीं';
  }

  @override
  String get profNoCustomersFound => 'कोई ग्राहक नहीं मिला.';

  @override
  String get profSegRegular => 'रेगुलर';

  @override
  String get profSegOccasional => 'कभी-कभी';

  @override
  String get profSegImpulse => 'इंपल्स';

  @override
  String get profSegBulk => 'बल्क';

  @override
  String get profSegCredit => 'क्रेडिट';

  @override
  String get profSegInactive => 'इनएक्टिव';

  @override
  String get profSyncContactsTitle => 'कॉन्टैक्ट सिंक करें?';

  @override
  String get profSyncContactsBody =>
      'इससे आपके फ़ोन के कॉन्टैक्ट आपकी ग्राहक लिस्ट में आ जाएंगे. रेगुलर ग्राहकों को फ़ोन नंबर से मैच किया जाएगा.';

  @override
  String get profCancel => 'कैंसिल';

  @override
  String get profSyncNow => 'अभी सिंक करें';

  @override
  String profSyncedContacts(int count) {
    return '$count कॉन्टैक्ट सक्सेसफुली सिंक हो गए!';
  }

  @override
  String profSyncFailed(String error) {
    return 'सिंक फेल हो गया: $error';
  }

  @override
  String get profSendWhatsappReengagement => 'WhatsApp री-एंगेजमेंट भेजें';

  @override
  String profWhatsappReengagementMessage(String name) {
    return 'हाय $name! हमें आपकी हमारे स्टोर पर कमी खल रही है. आपको आए हुए काफ़ी वक्त हो गया, और आपके लिए ताज़ा स्टॉक और बढ़िया डील तैयार हैं. जल्दी आइए — आपकी पसंद की चीज़ें रेडी हैं! जल्द मिलते हैं!';
  }

  @override
  String get profAddNewCustomer => 'नया ग्राहक जोड़ें';

  @override
  String get profEditCustomer => 'ग्राहक एडिट करें';

  @override
  String get profFullName => 'पूरा नाम';

  @override
  String get profPhoneNumber => 'फ़ोन नंबर';

  @override
  String get profEmailAddressOptional => 'ईमेल अड्रेस (ऑप्शनल)';

  @override
  String get profHouseholdSize => 'घर में लोगों की संख्या';

  @override
  String get profBirthdayOptional => 'जन्मदिन (वैकल्पिक)';

  @override
  String get profAnniversaryOptional => 'सालगिरह (वैकल्पिक)';

  @override
  String get profSaveCustomer => 'ग्राहक सेव करें';

  @override
  String get profFillNameAndPhone => 'कृपया नाम और फ़ोन भरें';

  @override
  String get profEnterValidPhone => 'सही फ़ोन नंबर डालें (सिर्फ़ अंक)';

  @override
  String get profCustomerSaved => 'ग्राहक सक्सेसफुली सेव हो गया';

  @override
  String get profLoading => 'लोड हो रहा है...';

  @override
  String get profCustomerDetails => 'ग्राहक की डिटेल';

  @override
  String get profStatBalance => 'बैलेंस';

  @override
  String get profStatSpent => 'खर्च';

  @override
  String get profStatOrders => 'ऑर्डर';

  @override
  String get profCustomerInfo => 'ग्राहक की जानकारी';

  @override
  String profMembersCount(int count) {
    return '$count लोग';
  }

  @override
  String get profJoinedOn => 'जुड़ने की तारीख';

  @override
  String get profUnknown => 'पता नहीं';

  @override
  String get profPurchaseHistory => 'खरीद हिस्ट्री';

  @override
  String get profNoOrdersForCustomer => 'इस ग्राहक का कोई ऑर्डर नहीं मिला.';

  @override
  String profErrorLoadingOrders(String error) {
    return 'ऑर्डर लोड करने में दिक्कत: $error';
  }

  @override
  String get profDeleteCustomerTitle => 'ग्राहक हटाएं?';

  @override
  String profDeleteCustomerBody(String name) {
    return 'क्या आप वाकई $name को हटाना चाहते हैं? यह वापस नहीं किया जा सकता.';
  }

  @override
  String get profDelete => 'डिलीट';

  @override
  String profFailedToUpdateArea(String error) {
    return 'एरिया अपडेट करना फेल हो गया: $error';
  }

  @override
  String get profAreaAssociation => 'एरिया / एसोसिएशन';

  @override
  String get profAddNewArea => 'नया एरिया जोड़ें…';

  @override
  String get profUnableToLoadAreas => 'एरिया लोड नहीं हो पाए';

  @override
  String get profNoAreasTapToAdd => 'कोई एरिया नहीं — जोड़ने के लिए टैप करें';

  @override
  String get profNone => 'कोई नहीं';

  @override
  String profOrderNumber(String id) {
    return 'ऑर्डर #$id';
  }

  @override
  String get profSave => 'सेव';

  @override
  String profError(String error) {
    return 'दिक्कत: $error';
  }

  @override
  String get profBasicInformation => 'बेसिक जानकारी';

  @override
  String get profStoreName => 'स्टोर का नाम';

  @override
  String get profStoreType => 'स्टोर का टाइप (जैसे किराना, सुपरमार्केट)';

  @override
  String get profBusinessIntelligence => 'बिज़नेस इंटेलिजेंस';

  @override
  String get profFootfallAutoComputed =>
      'औसत फ़ुटफ़ॉल आपकी सेल्स के आधार पर अपने आप कैलकुलेट होता है.';

  @override
  String get profProvideInitialValues =>
      'हमारे AI को आपका बिज़नेस ऑप्टिमाइज़ करने में मदद के लिए शुरुआती वैल्यू दें.';

  @override
  String get profAvgDailyFootfall => 'रोज़ाना औसत फ़ुटफ़ॉल';

  @override
  String get profAiAutoUpdating => 'AI ऑटो-अपडेटिंग';

  @override
  String get profMonthlyStockBudget => 'मासिक स्टॉक बजट';

  @override
  String get profDailyExpenseBuffer => 'रोज़ाना खर्च बफ़र';

  @override
  String get profLocationDetails => 'लोकेशन की डिटेल';

  @override
  String get profCityArea => 'सिटी / एरिया';

  @override
  String get profStateRegion => 'राज्य / रीजन';

  @override
  String get profCity => 'शहर';

  @override
  String get profBusinessVertical => 'व्यवसाय वर्टिकल';

  @override
  String get profRequired => 'ज़रूरी है';

  @override
  String get profSettingsSaved => 'सेटिंग्स सक्सेसफुली सेव हो गईं!';

  @override
  String profFailedToSave(String error) {
    return 'सेव करना फेल हो गया: $error';
  }

  @override
  String get supSplashTagline => 'स्मार्ट बिज़नेस, और स्मार्ट आप';

  @override
  String get supBlockedAppTitle => 'ऐप अस्थायी रूप से उपलब्ध नहीं है';

  @override
  String get supBlockedStoreTitle => 'स्टोर अस्थायी रूप से उपलब्ध नहीं है';

  @override
  String get supBlockedBody =>
      'हम इसे जल्द से जल्द हल करने के लिए काम कर रहे हैं. अगर आपको तुरंत मदद चाहिए, तो नीचे दिए बटन पर टैप करें.';

  @override
  String get supBlockedContactUs => 'हमसे संपर्क करें';

  @override
  String get supBlockedEmailSubjectApp => 'ऐप एक्सेस समस्या — Outlet AI';

  @override
  String get supBlockedEmailSubjectStore => 'स्टोर एक्सेस समस्या — Outlet AI';

  @override
  String supBlockedEmailBody(String reason) {
    return 'हैलो LohiyaAI टीम,\n\nमैं Outlet AI ऐप एक्सेस नहीं कर पा रहा हूँ.\n\nदिखाया गया कारण: $reason\n\nकृपया एक्सेस वापस पाने में मेरी मदद करें.\n\n— Kirana मालिक';
  }

  @override
  String get supBlockedEmailFallback =>
      'कृपया सीधे support@lohiyaai.com पर ईमेल करें.';

  @override
  String get supSupportTitle => 'मदद और सपोर्ट';

  @override
  String get supSupportHeading => 'हम आपकी कैसे मदद कर सकते हैं?';

  @override
  String get supSupportSubheading => 'अपने सवालों के तुरंत जवाब पाएं';

  @override
  String get supOptionFaqTitle => 'अक्सर पूछे जाने वाले सवाल';

  @override
  String get supOptionFaqSubtitle => 'आम सवाल और जवाब';

  @override
  String get supOptionReportTitle => 'समस्या रिपोर्ट करें';

  @override
  String get supOptionReportSubtitle => 'कोई बग मिला? हमें बताएं';

  @override
  String get supOptionChatTitle => 'हमसे चैट करें';

  @override
  String get supOptionChatSubtitle => 'हमारी सपोर्ट टीम से जुड़ें';

  @override
  String get supOptionEmailTitle => 'ईमेल सपोर्ट';

  @override
  String get supOptionEmailSubtitle => 'हमें सीधे ईमेल भेजें';

  @override
  String get supChatComingSoon => 'चैट सपोर्ट जल्द आ रहा है!';

  @override
  String get supEmailUnableToOpen => 'ईमेल ऐप नहीं खोल पाए.';

  @override
  String get supEmailError => 'ईमेल ऐप खोलते समय कुछ गलत हो गया.';

  @override
  String get supFaqTitle => 'FAQs';

  @override
  String get supFaqQ1 => 'नया प्रोडक्ट कैसे जोड़ें?';

  @override
  String get supFaqA1 =>
      'आप POS टैब में + बटन दबाकर, या Inventory टैब से प्रोडक्ट जोड़ सकते हैं. उपलब्ध होने पर डिटेल अपने-आप लाने के लिए बारकोड भी स्कैन कर सकते हैं.';

  @override
  String get supFaqQ2 => 'Stockout Risk का अनुमान कैसे काम करता है?';

  @override
  String get supFaqA2 =>
      'हमारा AI आपकी पिछली बिक्री की गति और मौजूदा स्टॉक स्तर का विश्लेषण करता है. अगर वह अनुमान लगाता है कि कोई आइटम अगले 3-7 दिनों में खत्म हो जाएगा, तो उसे Stockout Risk के रूप में फ्लैग करता है.';

  @override
  String get supFaqQ3 => 'ग्राहक उधार (खाता) कैसे मैनेज करें?';

  @override
  String get supFaqA3 =>
      'ऑर्डर लगाते समय, एक ग्राहक चुनें और पेमेंट तरीके के रूप में \"Credit\" चुनें. सभी बकाया Finance -> Udhaar टैब या Customer Relations सेक्शन में देख सकते हैं.';

  @override
  String get supFaqQ4 => 'क्या मैं अपने फोन के कॉन्टैक्ट सिंक कर सकता हूँ?';

  @override
  String get supFaqA4 =>
      'हाँ! Profile -> Customer Relations पर जाएं और Sync आइकन दबाएं. इससे आसान उधार ट्रैकिंग के लिए आपके नियमित ग्राहक ऐप में आ जाएंगे.';

  @override
  String get supFaqQ5 => 'KPI सब्सक्रिप्शन क्या हैं?';

  @override
  String get supFaqA5 =>
      'KPIs अहम बिज़नेस मेट्रिक हैं जैसे Revenue, Margin, और Footfall. किन मेट्रिक पर नज़र रखनी है, यह आप Profile -> Subscription सेक्शन से चुन सकते हैं.';

  @override
  String get supFaqQ6 => 'रोज़ाना सेल्स रिपोर्ट कैसे जनरेट करें?';

  @override
  String get supFaqA6 =>
      'आज का प्रदर्शन Dashboard पर देख सकते हैं. विस्तृत पुरानी रिपोर्ट के लिए, अपने Profile में Transaction History सेक्शन देखें.';

  @override
  String get supReportTitle => 'समस्या रिपोर्ट करें';

  @override
  String get supReportHeading => 'समस्या बताएं';

  @override
  String get supReportSubheading =>
      'हमारी टीम आपकी रिपोर्ट की समीक्षा करेगी और इसे जल्द से जल्द ठीक करेगी.';

  @override
  String get supReportCategoryLabel => 'समस्या श्रेणी';

  @override
  String get supReportSummaryLabel => 'छोटा सारांश';

  @override
  String get supReportSummaryHint =>
      'जैसे बारकोड स्कैन करते समय ऐप क्रैश हो जाता है';

  @override
  String get supReportDescriptionLabel => 'विस्तृत विवरण';

  @override
  String get supReportDescriptionHint =>
      'समस्या को दोबारा कैसे लाएं, इसका विवरण दें...';

  @override
  String get supReportSubmit => 'रिपोर्ट सबमिट करें';

  @override
  String get supReportFillFields => 'कृपया सभी फ़ील्ड भरें';

  @override
  String get supReportSubmittedTitle => 'रिपोर्ट सबमिट हो गई';

  @override
  String get supReportSubmittedBody =>
      'आपके फीडबैक के लिए धन्यवाद. हमारी टीम इसे तुरंत देखेगी.';

  @override
  String get supOk => 'ठीक है';

  @override
  String supReportSubmitFailed(String error) {
    return 'रिपोर्ट सबमिट करना विफल रहा: $error';
  }

  @override
  String get supCategoryAppBug => 'ऐप बग';

  @override
  String get supCategoryPricing => 'मूल्य समस्या';

  @override
  String get supCategoryInventory => 'इन्वेंटरी बेमेल';

  @override
  String get supCategoryAiFeedback => 'AI सिफ़ारिश फीडबैक';

  @override
  String get supCategoryPosError => 'POS एरर';

  @override
  String get supCategoryFeatureRequest => 'फ़ीचर अनुरोध';

  @override
  String get supCategoryOther => 'अन्य';

  @override
  String get shrSavingChanges => 'बदलाव सेव हो रहे हैं...';

  @override
  String get shrRetry => 'फिर से प्रयास करें';

  @override
  String get shrSavedSuccessfully => 'सफलतापूर्वक सेव हो गया!';

  @override
  String get shrBusinessAlerts => 'बिज़नेस अलर्ट';

  @override
  String get shrAllCaughtUp => 'सब अपडेट है!';

  @override
  String get shrNoUrgentAlerts => 'फ़िलहाल कोई ज़रूरी अलर्ट नहीं है।';

  @override
  String get shrAlertOutOfStock => 'स्टॉक खत्म';

  @override
  String get shrAlertLowStock => 'कम स्टॉक';

  @override
  String get shrAlertExpiringSoon => 'जल्द एक्सपायर हो रहा';

  @override
  String get shrAlertOverdueUdhaar => 'लंबे समय से बकाया उधार';

  @override
  String get shrAlertOverduePayment => 'बकाया पेमेंट';

  @override
  String get shrAlertUpcomingPayment => 'आने वाला पेमेंट';

  @override
  String shrMsgOutOfStock(String name) {
    return '$name पूरी तरह स्टॉक से बाहर है।';
  }

  @override
  String shrMsgLowStock(String name, String stock) {
    return '$name कम हो रहा है ($stock)।';
  }

  @override
  String shrMsgExpiringSoon(String name, int days) {
    return '$name $days दिनों में एक्सपायर हो जाएगा।';
  }

  @override
  String shrMsgOverdueUdhaar(String name, String amount, int days) {
    return '$name पर $days दिनों से ₹$amount बकाया है।';
  }

  @override
  String shrMsgPaymentOverdue(String amount, String supplier) {
    return '$supplier को ₹$amount का भुगतान बकाया है।';
  }

  @override
  String shrMsgPaymentDue(String amount, String supplier, int days) {
    return '$supplier को ₹$amount $days दिनों में देना है।';
  }

  @override
  String psetErrorWith(String error) {
    return 'एरर: $error';
  }

  @override
  String get psetCancel => 'रद्द करें';

  @override
  String get psetReset => 'रीसेट';

  @override
  String get psetUserActivity => 'यूज़र एक्टिविटी';

  @override
  String get psetNoUsersFound => 'कोई यूज़र नहीं मिला';

  @override
  String get psetNoStore => 'कोई स्टोर नहीं';

  @override
  String get psetNever => 'कभी नहीं';

  @override
  String get psetActiveToday => 'आज एक्टिव';

  @override
  String get psetInactive => 'इनएक्टिव';

  @override
  String get psetLastSeen => 'आखिरी बार देखा';

  @override
  String get psetOpensToday => 'आज खोले';

  @override
  String get psetTimeInApp => 'ऐप में समय';

  @override
  String get psetSalesToday => 'आज की सेल्स';

  @override
  String get psetJustNow => 'अभी-अभी';

  @override
  String psetMinsAgo(int m) {
    return '$mमि पहले';
  }

  @override
  String psetHoursAgo(int h) {
    return '$hघं पहले';
  }

  @override
  String psetDaysAgo(int d) {
    return '$dदि पहले';
  }

  @override
  String get psetPasswordSecurity => 'पासवर्ड और सुरक्षा';

  @override
  String psetCouldNotLoadStatus(String error) {
    return 'स्टेटस लोड नहीं हो सका: $error';
  }

  @override
  String get psetEnterNewPassword => 'नया पासवर्ड दर्ज करें';

  @override
  String get psetPasswordMin6 => 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get psetPasswordsNoMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get psetEnterCurrentPassword => 'अपना मौजूदा पासवर्ड दर्ज करें';

  @override
  String get psetPasswordUpdated => 'पासवर्ड सफलतापूर्वक अपडेट हो गया।';

  @override
  String get psetPasswordCreated => 'पासवर्ड सफलतापूर्वक बन गया।';

  @override
  String get psetCouldNotConnect =>
      'सर्वर से कनेक्ट नहीं हो सका। कृपया फिर से प्रयास करें।';

  @override
  String get psetSomethingWrong => 'कुछ गलत हो गया';

  @override
  String get psetPasswordSet => 'पासवर्ड सेट है';

  @override
  String get psetNoPasswordYet => 'अभी कोई पासवर्ड नहीं';

  @override
  String psetLastChanged(String date) {
    return 'आखिरी बार बदला $date';
  }

  @override
  String get psetPasswordActive => 'पासवर्ड एक्टिव है';

  @override
  String get psetCreatePasswordHint =>
      'यूज़रनेम लॉगिन सक्षम करने के लिए पासवर्ड बनाएँ';

  @override
  String psetPasswordCooldown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिनों',
      one: '1 दिन',
    );
    return 'आप $_temp0 में अपना पासवर्ड फिर से बदल सकते हैं।';
  }

  @override
  String get psetChangePassword => 'पासवर्ड बदलें';

  @override
  String get psetCreatePassword => 'पासवर्ड बनाएँ';

  @override
  String get psetChangeSubtitle =>
      'अपना मौजूदा पासवर्ड दर्ज करें, फिर एक नया चुनें।';

  @override
  String get psetCreateSubtitle =>
      'एक पासवर्ड सेट करें ताकि आप अपने यूज़रनेम से भी लॉगिन कर सकें।';

  @override
  String get psetCurrentPassword => 'मौजूदा पासवर्ड';

  @override
  String get psetNewPassword => 'नया पासवर्ड';

  @override
  String get psetConfirmNewPassword => 'नया पासवर्ड पुष्टि करें';

  @override
  String get psetUpdatePassword => 'पासवर्ड अपडेट करें';

  @override
  String get psetPasswordCooldownNote =>
      'पासवर्ड हर 14 दिनों में केवल एक बार बदला जा सकता है।';

  @override
  String get psetAllHistory => 'पूरा इतिहास';

  @override
  String get psetTabPurchases => 'खरीद';

  @override
  String get psetTabPosOrders => 'POS ऑर्डर';

  @override
  String get psetNoPurchaseHistory => 'कोई खरीद इतिहास नहीं मिला।';

  @override
  String get psetViewBill => 'बिल देखें';

  @override
  String get psetPurchaseDetails => 'खरीद विवरण';

  @override
  String psetFromSupplier(String supplier) {
    return '$supplier से';
  }

  @override
  String psetQtyTimes(String qty, String price) {
    return 'मात्रा: $qty × ₹$price';
  }

  @override
  String get psetTotalAmount => 'कुल राशि';

  @override
  String get psetSalesTxnHistory => 'सेल्स लेन-देन इतिहास';

  @override
  String get psetSalesTxnDesc =>
      'अपने सभी POS ऑर्डर, पेमेंट और ग्राहक लेन-देन देखें और फ़िल्टर करें।';

  @override
  String get psetOpenSalesHistory => 'सेल्स इतिहास खोलें';

  @override
  String get psetSettingsSaved => 'सेटिंग्स सेव हो गईं';

  @override
  String psetSaveFailed(String error) {
    return 'सेव विफल: $error';
  }

  @override
  String get psetResetToDefaults => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get psetResetConfirm =>
      'सभी सेटिंग्स उनके डिफ़ॉल्ट मानों पर रीसेट हो जाएँगी।';

  @override
  String get psetConfiguration => 'कॉन्फ़िगरेशन';

  @override
  String get psetPosPreferences => 'POS प्राथमिकताएँ';

  @override
  String get psetAiForecasting => 'AI और फ़ोरकास्टिंग';

  @override
  String get psetAlertThresholds => 'अलर्ट थ्रेशोल्ड';

  @override
  String get psetMarketing => 'मार्केटिंग';

  @override
  String get psetNotifications => 'नोटिफ़िकेशन';

  @override
  String get psetDefaultPayment => 'डिफ़ॉल्ट पेमेंट मेथड';

  @override
  String get psetDefaultPaymentHint =>
      'नई सेल जोड़ते समय पहले से चुना गया मेथड';

  @override
  String get psetCash => 'कैश';

  @override
  String get psetCard => 'कार्ड';

  @override
  String get psetForecastHorizon => 'फ़ोरकास्ट होराइज़न';

  @override
  String get psetForecastHorizonHint =>
      'AI कितने दिन आगे की स्टॉक ज़रूरतों का अनुमान लगाता है';

  @override
  String psetDaysValue(int days) {
    return '$days दिन';
  }

  @override
  String get psetStockoutRisk => 'स्टॉकआउट रिस्क थ्रेशोल्ड';

  @override
  String get psetStockoutRiskHint =>
      'जब 7-दिन का रिस्क इससे ज़्यादा हो तो स्टॉकआउट अलर्ट दिखाएँ';

  @override
  String get psetMinVelocity => 'न्यूनतम वेलोसिटी थ्रेशोल्ड';

  @override
  String get psetMinVelocityHint =>
      'इससे धीमे बिकने वाले आइटम डेड स्टॉक के रूप में फ़्लैग होते हैं';

  @override
  String get psetReorderAlertDays => 'रीऑर्डर अलर्ट दिन';

  @override
  String get psetReorderAlertHint =>
      'जब अनुमानित स्टॉक N दिनों में खत्म होने वाला हो तो अलर्ट करें';

  @override
  String get psetDeadStockDays => 'डेड स्टॉक दिन';

  @override
  String get psetDeadStockHint =>
      'N या अधिक दिनों से बिना बिक्री वाले आइटम फ़्लैग करें';

  @override
  String get psetExpiryAlertDays => 'एक्सपायरी अलर्ट दिन';

  @override
  String get psetExpiryAlertHint =>
      'बैच/आइटम एक्सपायर होने से इतने दिन पहले अलर्ट करें';

  @override
  String psetDaysBeforeValue(int days) {
    return '$days दिन पहले';
  }

  @override
  String get psetAllowMarketing =>
      'LohiyaAI को मेरे स्टोर की मार्केटिंग करने दें';

  @override
  String get psetAllowMarketingHint =>
      'हम आपकी ओर से आपके स्टोर को Facebook, Instagram और WhatsApp पर प्रमोट करते हैं';

  @override
  String get psetInAppAlerts => 'इन-ऐप अलर्ट';

  @override
  String get psetInAppAlertsHint => 'ऐप के अंदर अलर्ट दिखाएँ';

  @override
  String get psetWhatsappNotif => 'WhatsApp नोटिफ़िकेशन';

  @override
  String get psetWhatsappNotifHint =>
      'रीस्टॉकिंग और उधार अलर्ट WhatsApp के ज़रिए भेजें';

  @override
  String get psetQuietHours => 'क्वायट आवर्स';

  @override
  String get psetQuietHoursHint =>
      'इस अवधि के दौरान कोई नोटिफ़िकेशन नहीं भेजा जाएगा';

  @override
  String get psetStart => 'शुरू';

  @override
  String get psetEnd => 'अंत';

  @override
  String get psetSaveChanges => 'बदलाव सेव करें';

  @override
  String get psetCashflowSupport => 'कैशफ़्लो सपोर्ट';

  @override
  String get psetRequestUnderReview => 'रिक्वेस्ट समीक्षा में है';

  @override
  String psetReqProcessingFull(String amount, String bank) {
    return '₹$amount के लिए $bank के ज़रिए आपकी कैशफ़्लो रिक्वेस्ट प्रोसेस हो रही है।\n\nहमारी टीम 2 कारोबारी दिनों में आपसे संपर्क करेगी।';
  }

  @override
  String get psetReqProcessing =>
      'आपकी कैशफ़्लो रिक्वेस्ट प्रोसेस हो रही है।\n\nहमारी टीम 2 कारोबारी दिनों में आपसे संपर्क करेगी।';

  @override
  String get psetRequestSubmitted => 'रिक्वेस्ट सबमिट हो गई!';

  @override
  String get psetRequestSubmittedBody =>
      'हमें आपकी कैशफ़्लो रिक्वेस्ट मिल गई है।\nहमारी टीम 2 कारोबारी दिनों में\nआपसे संपर्क करेगी।';

  @override
  String get psetBackToProfile => 'प्रोफ़ाइल पर वापस';

  @override
  String get psetApplyCashflow => 'कैशफ़्लो सपोर्ट के लिए\nआवेदन करें';

  @override
  String get psetCashflowSubtitle =>
      'तेज़ बिज़नेस फाइनेंस, LohiyaAI पार्टनर्स द्वारा।';

  @override
  String get psetYourBusinessProfile => 'आपका बिज़नेस प्रोफ़ाइल';

  @override
  String get psetStore => 'स्टोर';

  @override
  String get psetLocation => 'लोकेशन';

  @override
  String get psetDailyFootfall => 'दैनिक फुटफॉल';

  @override
  String psetCustomersPerDay(int count) {
    return '$count ग्राहक/दिन';
  }

  @override
  String get psetHowMuchNeed => 'आपको कितना चाहिए?';

  @override
  String get psetDragToSelect =>
      'चुनने के लिए ड्रैग करें — ₹50,000 से ₹10,00,000';

  @override
  String get psetLoanAmount => 'लोन राशि';

  @override
  String get psetChoosePartnerBank => 'पार्टनर बैंक चुनें';

  @override
  String get psetSelectBankHint =>
      'अपनी रिक्वेस्ट आगे बढ़ाने के लिए एक बैंक चुनें।';

  @override
  String get psetSubmitRequest => 'रिक्वेस्ट सबमिट करें';

  @override
  String get psetSubmitDisclaimer =>
      'सबमिट करके, आप इस रिक्वेस्ट के बारे में हमारी टीम द्वारा संपर्क किए जाने पर सहमत होते हैं।';

  @override
  String get psetBankSbiDesc => 'छोटे व्यवसायों के लिए सरकार-समर्थित योजना';

  @override
  String get psetBankHdfcDesc => 'रिटेल ग्रोथ के लिए तेज़ डिस्बर्सल';

  @override
  String get psetBankIciciDesc => 'किराना मालिकों के लिए फ्लेक्सिबल क्रेडिट';

  @override
  String get psetBankAxisDesc => 'रिटेल स्टोर्स के लिए अनुकूल फाइनेंस';

  @override
  String get widgetTitleSales => 'आज की बिक्री';

  @override
  String get widgetTitleUdhaar => 'उधार बकाया';

  @override
  String get widgetTitleLowStock => 'कम स्टॉक';

  @override
  String get widgetTitlePayToday => 'आज भुगतान करें';

  @override
  String get widgetNewBill => '+ नया बिल';

  @override
  String get widgetUnitOrders => 'ऑर्डर';

  @override
  String get widgetUnitItems => 'आइटम';

  @override
  String get widgetUnitOverdue => 'अतिदेय';

  @override
  String get widgetUnitPending => 'लंबित';

  @override
  String get widgetUnitToPay => 'भुगतान करना है';

  @override
  String get widgetSignIn => 'साइन इन करने के लिए Outlet AI खोलें';

  @override
  String get widgetNoData => 'आज के आंकड़े लोड करने के लिए ऐप खोलें';

  @override
  String get visionComingSoon => 'विज़न AI जल्द आ रहा है!';

  @override
  String get mktTierBronze => 'Bronze';

  @override
  String get mktTierSilver => 'Silver';

  @override
  String get mktTierGold => 'Gold';

  @override
  String get mktTierPlatinum => 'Platinum';

  @override
  String get mktTierSettings => 'टियर सेटिंग्स';

  @override
  String get mktShowArchived => 'संग्रहित दिखाएँ';

  @override
  String get mktHideArchived => 'संग्रहित छिपाएँ';

  @override
  String get mktArchived => 'संग्रहित';

  @override
  String get mktEdit => 'संपादित करें';

  @override
  String get mktAlertedToday => 'आज सूचित किया';

  @override
  String get mktRestore => 'पुनर्स्थापित करें';

  @override
  String get mktArchive => 'संग्रहित करें';

  @override
  String get mktBasketArchived => 'बास्केट संग्रहित';

  @override
  String get mktBasketRestored => 'बास्केट पुनर्स्थापित';

  @override
  String get mktSomethingWentWrong =>
      'कुछ गड़बड़ हुई। कृपया फिर से प्रयास करें।';

  @override
  String get mktEditBasket => 'बास्केट संपादित करें';

  @override
  String get mktSaveChanges => 'बदलाव सहेजें';

  @override
  String get mktAddItemsForPrice =>
      'स्वतः छूट वाली बंडल कीमत देखने के लिए आइटम जोड़ें';

  @override
  String get mktItemsTotal => 'आइटम कुल';

  @override
  String get mktBundlePrice => 'बंडल कीमत';

  @override
  String get mktTierConfigTitle => 'बास्केट टियर';

  @override
  String get mktTierConfigIntro =>
      'बास्केट की कुल कीमत के आधार पर स्वतः मूल्य तय होता है। हर टियर के लिए कीमत सीमा और छूट सेट करें — आइटम जोड़ते ही मिलान वाले टियर की छूट अपने आप लागू होती है।';

  @override
  String get mktTierRangeInvalid =>
      'हर टियर की सीमा पिछले से अधिक होनी चाहिए, और छूट 0–100% के बीच।';

  @override
  String get mktTiersSaved => 'टियर सहेजे गए';

  @override
  String get mktRecomputeTitle => 'मौजूदा बास्केट फिर से गणना करें?';

  @override
  String get mktKeepAsIs => 'जैसा है वैसा रखें';

  @override
  String get mktRecompute => 'फिर से गणना करें';

  @override
  String get mktSaveTiers => 'टियर सहेजें';

  @override
  String get mktUpToLabel => 'तक';

  @override
  String get mktTopTierHint => 'पिछले टियर से ऊपर सब कुछ';

  @override
  String get mktDiscountLabel => 'छूट';

  @override
  String get psetBasketTiers => 'बास्केट टियर';

  @override
  String get psetBasketTiersHint => 'मूल्य के अनुसार बास्केट पर स्वतः छूट';

  @override
  String mktYouSave(String amount, String pct) {
    return '₹$amount बचाएँ ($pct% छूट)';
  }

  @override
  String mktTierBasketLabel(String tier) {
    return '$tier बास्केट';
  }

  @override
  String mktPctOff(String pct) {
    return '$pct% छूट';
  }

  @override
  String mktSaveAmount(String amount) {
    return '₹$amount बचाएँ';
  }

  @override
  String mktRecomputeBody(int count) {
    return '$count मौजूदा बास्केट पुराने टियर पर कीमत वाले हैं। क्या उन पर भी नए टियर लागू करें?';
  }

  @override
  String mktBasketsRecomputed(int count) {
    return '$count बास्केट अपडेट हुए';
  }

  @override
  String mktAboveAmount(String amount) {
    return '₹$amount से ऊपर';
  }

  @override
  String mktRangeAmount(String from, String to) {
    return '₹$from – ₹$to';
  }

  @override
  String get mktSaveAsBasket => 'बास्केट के रूप में सहेजें';

  @override
  String mktBasketSavedFromCampaign(String name) {
    return '\"$name\" आपकी बास्केट में सहेजा गया';
  }

  @override
  String get mktSelectDate => 'तारीख चुनें';

  @override
  String get mktBasketsProTitle => 'बास्केट एक Pro सुविधा है';

  @override
  String get mktBasketsProDesc =>
      'स्वचालित टियर छूट के साथ कॉम्बो डील बनाएँ और ग्राहकों को WhatsApp पर सूचित करें। बास्केट अनलॉक करने के लिए Pro में अपग्रेड करें।';

  @override
  String get visionNavLabel => 'विज़न';

  @override
  String get visionTitle => 'विज़न';

  @override
  String get visionTabShelf => 'शेल्फ़ स्कैन';

  @override
  String get visionTabResults => 'परिणाम';

  @override
  String get visionTabCounter => 'काउंटर';

  @override
  String get visionProTitle => 'विज़न AI';

  @override
  String get visionProDesc =>
      'सुबह और शाम अपनी शेल्फ़ की फ़ोटो लें — AI आपका स्टॉक गिनेगा और बताएगा कि क्या बिका।';

  @override
  String get visionFromCamera => 'फ़ोटो लें';

  @override
  String get visionFromGallery => 'गैलरी से चुनें';

  @override
  String get visionMorningTitle => 'सुबह — दिन की शुरुआत';

  @override
  String get visionEveningTitle => 'शाम — दिन का अंत';

  @override
  String get visionTakePhoto => 'फ़ोटो लें';

  @override
  String get visionRetake => 'फिर से लें';

  @override
  String get visionReview => 'समीक्षा करें';

  @override
  String get visionAnalyzing =>
      'शेल्फ़ का विश्लेषण हो रहा है… इसमें एक मिनट तक लग सकता है';

  @override
  String get visionScanFailed => 'स्कैन विफल। कृपया फिर से फ़ोटो लें।';

  @override
  String get visionStillProcessing =>
      'आपकी फ़ोटो का विश्लेषण जारी है — इसमें कुछ मिनट लग सकते हैं। तैयार होने पर परिणाम यहाँ दिखेगा।';

  @override
  String get visionCheckAgain => 'फिर से जाँचें';

  @override
  String get visionNoPhotoYet => 'अभी तक कोई फ़ोटो नहीं ली गई।';

  @override
  String get visionProductsIdentified => 'पहचाने गए उत्पाद';

  @override
  String get visionUnitsCounted => 'गिनी गई इकाइयाँ';

  @override
  String get visionNeedsReview => 'समीक्षा ज़रूरी';

  @override
  String get visionViewSales => 'आज की बिक्री देखें';

  @override
  String get visionTip =>
      'सुझाव: दुकान खोलने से पहले सुबह की फ़ोटो और बंद करने से पहले शाम की फ़ोटो लें। AI हिसाब लगाएगा कि हर उत्पाद कितना बिका।';

  @override
  String get visionSalesEmpty =>
      'आज क्या बिका यह देखने के लिए सुबह और शाम की एक-एक फ़ोटो लें।';

  @override
  String get visionTotalSold => 'कुल बिकी वस्तुएँ';

  @override
  String get visionSold => 'बिका';

  @override
  String get visionMorningCount => 'सुबह';

  @override
  String get visionEveningCount => 'शाम';

  @override
  String get visionUnknownItem => 'अज्ञात — ठीक करने के लिए टैप करें';

  @override
  String get visionCorrected => 'ठीक किया गया';

  @override
  String get visionCorrectTitle => 'यह कौन-सा उत्पाद है?';

  @override
  String get visionSearchProducts => 'अपने उत्पाद खोजें';

  @override
  String get visionClearCorrection => 'सुधार हटाएँ';

  @override
  String get visionNoProducts =>
      'अभी कोई उत्पाद लोड नहीं हुआ। एक बार बिलिंग टैब खोलें, फिर वापस आएँ।';

  @override
  String get visionCounterSoonTitle => 'लाइव काउंटर — जल्द आ रहा है';

  @override
  String get visionCounterSoonDesc =>
      'बिलिंग काउंटर पर अपना फ़ोन तानें और वस्तुएँ गुज़रते ही बिक्री अपने-आप गिनी जाएगी। हम इस पर आख़िरी काम कर रहे हैं।';

  @override
  String get visionCounterStartTitle => 'लाइव सेल काउंटर';

  @override
  String get visionCounterStartDesc =>
      'अपना फ़ोन बिलिंग काउंटर की ओर रखें। लाइन पार करने वाली वस्तुएं अपने आप गिनी जाती हैं — कोई बारकोड स्कैनिंग नहीं।';

  @override
  String get visionCounterStart => 'गिनती शुरू करें';

  @override
  String get visionCounterFinish => 'समाप्त करें';

  @override
  String get visionCounterPause => 'रोकें';

  @override
  String get visionCounterResume => 'जारी रखें';

  @override
  String get visionCounterUndo => 'पूर्ववत करें';

  @override
  String get visionCounterFlip => 'साइड बदलें';

  @override
  String get visionCounterCounted => 'गिना गया';

  @override
  String get visionCounterNothingYet =>
      'वस्तुओं को गिनने के लिए उन्हें लाइन के पार ले जाएं।';

  @override
  String get visionCounterHint =>
      'हरे क्षेत्र में पार करने वाली वस्तुएं बिकी हुई मानी जाती हैं।';

  @override
  String get visionCounterZoneStore => 'स्टोर में';

  @override
  String get visionCounterZoneSold => 'बिका';

  @override
  String get visionCounterModelMissingTitle => 'काउंटर मॉडल इंस्टॉल नहीं है';

  @override
  String get visionCounterModelMissingDesc =>
      'ऑन-डिवाइस गिनती मॉडल अभी इस बिल्ड में शामिल नहीं है। यह एक अपडेट में आ रहा है — शेल्फ़ स्कैनिंग अब भी काम करती है।';

  @override
  String get visionCounterPermTitle => 'कैमरा एक्सेस आवश्यक है';

  @override
  String get visionCounterPermDesc =>
      'बिलिंग काउंटर पर वस्तुओं को गिनने के लिए कैमरा एक्सेस की अनुमति दें।';

  @override
  String get visionCounterGrant => 'कैमरा अनुमति दें';

  @override
  String get visionCounterOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get visionCounterFinishConfirmTitle => 'गिनती समाप्त करें?';

  @override
  String get visionCounterFinishConfirmDesc =>
      'हम आज की गिनती सहेजेंगे और उसे आपके काउंटर सारांश में जोड़ देंगे।';

  @override
  String get visionCounterSave => 'गिनती सहेजें';

  @override
  String get visionCounterDiscard => 'रद्द करें';

  @override
  String get visionCounterKeepCounting => 'गिनती जारी रखें';

  @override
  String get visionCounterSavedTitle => 'गिनती सहेजी गई';

  @override
  String visionCounterSaved(int count, int skus) {
    return '$skus उत्पादों में $count वस्तुएं सहेजी गईं।';
  }

  @override
  String get visionCounterOfflineNote =>
      'आपके फ़ोन पर सहेजा गया। काउंटर सेवा उपलब्ध होने पर यह सिंक हो जाएगा।';

  @override
  String visionCounterPending(int count) {
    return '$count अभी तक सिंक नहीं हुईं';
  }

  @override
  String get visionCounterSummaryTitle => 'आज की काउंटर गिनती';

  @override
  String get visionCounterSummaryEmpty =>
      'आज कोई वस्तु नहीं गिनी गई। शुरू करने के लिए \'गिनती शुरू करें\' पर टैप करें।';

  @override
  String get visionCounterSummaryTotal => 'आज कुल गिना गया';

  @override
  String get visionCounterUnknownItem => 'अपरिचित उत्पाद';

  @override
  String get onbCtaTitle => 'सैकड़ों वस्तुएं हैं?';

  @override
  String get onbCtaSubtitle =>
      'अपनी शेल्फ़ की फ़ोटो लें और हम उत्पादों को पहचानकर आपकी इन्वेंट्री में जोड़ देंगे — हर एक को स्कैन करने की ज़रूरत नहीं।';

  @override
  String get onbCtaButton => 'अपनी शेल्फ़ की फ़ोटो लें';

  @override
  String get onbCaptureTitle => 'अपनी शेल्फ़ की फ़ोटो लें';

  @override
  String get onbCaptureHint =>
      'अपनी सभी शेल्फ़ को कवर करते हुए 3 से 10 स्पष्ट फ़ोटो लें। अच्छी रोशनी हमें अधिक उत्पाद पहचानने में मदद करती है।';

  @override
  String get onbTakePhoto => 'फ़ोटो लें';

  @override
  String onbPhotosProgress(int count) {
    return '10 में से $count फ़ोटो';
  }

  @override
  String get onbMinPhotos => 'कम से कम 3 फ़ोटो जोड़ें';

  @override
  String get onbAnalyze => 'उत्पाद पहचानें';

  @override
  String get onbProcessingTitle => 'हम आपकी शेल्फ़ फ़ोटो की समीक्षा कर रहे हैं';

  @override
  String get onbProcessingDesc =>
      'हमारा सिस्टम आपकी शेल्फ़ के उत्पादों को पहचान रहा है। इसमें आमतौर पर एक मिनट से कम लगता है। कृपया यह स्क्रीन खुली रखें — हम परिणाम यहां जल्द ही दिखाएंगे।';

  @override
  String get onbReviewTitle => 'अपना स्टॉक पुष्टि करें';

  @override
  String get onbReviewDisclaimer =>
      'ये वे उत्पाद हैं जिन्हें हमने आपकी फ़ोटो से पहचाना। हम कभी-कभी किसी वस्तु को चूक सकते हैं या गलत पढ़ सकते हैं, इसलिए कृपया मात्रा जांचें और समायोजित करें। हम लगातार अपनी सटीकता सुधार रहे हैं।';

  @override
  String onbReviewSummary(int mapped, int unmapped) {
    return '$mapped तैयार · $unmapped को उत्पाद चाहिए';
  }

  @override
  String get onbUnrecognised => 'पहचाना नहीं गया — एक उत्पाद चुनें';

  @override
  String get onbChooseProduct => 'उत्पाद चुनें';

  @override
  String get onbQuantity => 'मात्रा';

  @override
  String get onbCommit => 'मेरी इन्वेंट्री में जोड़ें';

  @override
  String get onbCommitting => 'आपकी इन्वेंट्री में जोड़ा जा रहा है…';

  @override
  String get onbDoneTitle => 'स्टॉक जोड़ा गया';

  @override
  String onbDoneDesc(int products, int units) {
    return '$products उत्पाद ($units वस्तुएं) आपकी इन्वेंट्री में जोड़े गए। आप इन्वेंट्री टैब से कभी भी कीमतें सेट कर सकते हैं।';
  }

  @override
  String get onbEmptyDetected =>
      'हम इन फ़ोटो में उत्पाद नहीं पहचान सके। कृपया बेहतर रोशनी में, पैकेजिंग स्पष्ट दिखाते हुए फिर से फ़ोटो लें।';

  @override
  String get onbRetake => 'फ़ोटो फिर से लें';

  @override
  String get onbFailedTitle => 'हम पूरा नहीं कर सके';

  @override
  String get onbDone => 'पूर्ण';

  @override
  String get onbRemove => 'हटाएं';

  @override
  String get visionAddPhotosTitle => 'शेल्फ़ की फ़ोटो जोड़ें';

  @override
  String get visionAddPhotosHint =>
      'अपनी शेल्फ़ को कवर करते हुए 3 से 10 फ़ोटो लें।';

  @override
  String get visionMinPhotosHint => 'कम से कम 3 फ़ोटो जोड़ें';

  @override
  String get visionMaxReached => 'अधिकतम 10 फ़ोटो';

  @override
  String get visionAnalyze => 'विश्लेषण करें';

  @override
  String get forecastSectionLabel => 'बिक्री अनुमान';

  @override
  String forecastStripCount(int count) {
    return 'कल $count सामान बिक सकते हैं';
  }

  @override
  String forecastStripEst(String amount) {
    return 'अनुमानित $amount';
  }

  @override
  String get forecastStripViewAll => 'पूरी सूची देखें';

  @override
  String get forecastScreenTitle => 'बिक्री अनुमान';

  @override
  String get forecastHorizonTomorrow => 'कल';

  @override
  String get forecastHorizon3d => '3 दिन';

  @override
  String get forecastHorizon5d => '5 दिन';

  @override
  String get forecastHorizon7d => '7 दिन';

  @override
  String get forecastHorizon14d => '14 दिन';

  @override
  String get forecastHorizon30d => '30 दिन';

  @override
  String get forecastRevLabel => 'अनुमानित कमाई';

  @override
  String get forecastOosWarning => 'स्टॉक खत्म हो सकता है';

  @override
  String get forecastWhyTitle => 'यह यहाँ क्यों है?';

  @override
  String get forecastWhyAvgDaily => 'रोज़ की औसत बिक्री';

  @override
  String get forecastWhyStockDays => 'स्टॉक बचा';

  @override
  String get forecastWhyOosRisk => 'खत्म होने की संभावना';

  @override
  String forecastWhyExplain(String avg, String days, String units) {
    return 'यह सामान हर दिन औसतन $avg नग बिकता है। $days दिनों में, आपकी दुकान से लगभग $units नग बिकने की उम्मीद है।';
  }

  @override
  String get forecastNoData => 'अनुमान अभी तैयार नहीं है। कृपया बाद में देखें।';

  @override
  String get forecastDataStale => 'डेटा पुराना हो सकता है';
}
