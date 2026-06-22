// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get languageName => 'मराठी';

  @override
  String get languageChooseTitle => 'तुमची भाषा निवडा';

  @override
  String get languageChooseSubtitle =>
      'तुम्ही हे कधीही सेटिंग्जमध्ये बदलू शकता.';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get commonContinue => 'सुरू ठेवा';

  @override
  String get commonServerError =>
      'सर्व्हरशी कनेक्ट करता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get commonSomethingWrong =>
      'काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get authErrEnterPhone => 'तुमचा फोन नंबर टाका';

  @override
  String get authErrEnter6Otp => '6-अंकी OTP टाका';

  @override
  String get authErrSessionExpired => 'सत्र संपले. पुन्हा पाठवा वर टॅप करा.';

  @override
  String get authErrInvalidPhone =>
      'अवैध फोन नंबर. देश कोड समाविष्ट करा (उदा. +91...).';

  @override
  String get authErrTooManyRequests =>
      'खूप प्रयत्न झाले. कृपया नंतर पुन्हा प्रयत्न करा.';

  @override
  String get authErrWrongOtp => 'चुकीचा OTP. कृपया तपासून पुन्हा प्रयत्न करा.';

  @override
  String get authErrOtpExpired =>
      'OTP ची मुदत संपली. नवीन कोडसाठी पुन्हा पाठवा वर टॅप करा.';

  @override
  String get authErrVerificationFailed =>
      'पडताळणी अयशस्वी. पुन्हा प्रयत्न करा.';

  @override
  String get welcomeSlide1Title => 'Outlet AI मध्ये\nआपले स्वागत आहे';

  @override
  String get welcomeSlide1Subtitle =>
      'तुमचे किराणा दुकान व्यवस्थापित करण्यासाठी तुमचा स्मार्ट व्यवसाय भागीदार — दक्षिण भारतासाठी बनवलेला.';

  @override
  String get welcomeSlide2Title => 'स्मार्ट इन्व्हेंटरी\nव्यवस्थापन';

  @override
  String get welcomeSlide2Subtitle =>
      'स्टॉक पातळी ट्रॅक करा, कमी-स्टॉक अलर्ट मिळवा आणि तुमची सर्वाधिक विकली जाणारी उत्पादने कधीही संपू देऊ नका.';

  @override
  String get welcomeSlide3Title => 'तुमचा व्यवसाय\nवाढवा';

  @override
  String get welcomeSlide3Subtitle =>
      'AI-आधारित अंतर्दृष्टी, विक्री विश्लेषण आणि तुमच्या दुकानासाठी वैयक्तिकृत टिप्स मिळवा.';

  @override
  String get welcomeGetStarted => 'सुरुवात करा';

  @override
  String get welcomeHaveAccount => 'आधीच खाते आहे? ';

  @override
  String get welcomeSignIn => 'साइन इन करा';

  @override
  String get loginWelcomeBack => 'पुन्हा स्वागत आहे';

  @override
  String get loginSubtitle => 'तुमच्या Outlet AI खात्यात साइन इन करा.';

  @override
  String get loginTabPhone => 'फोन OTP';

  @override
  String get loginTabUsername => 'वापरकर्तानाव';

  @override
  String get loginPhoneLabel => 'फोन नंबर';

  @override
  String get loginSendOtp => 'OTP पाठवा';

  @override
  String get loginOtpHelp => 'आम्ही या नंबरवर एक-वेळ पासवर्ड पाठवू';

  @override
  String loginOtpSentTo(String phone) {
    return '$phone वर OTP पाठवला';
  }

  @override
  String get loginOtp6Label => '6-अंकी OTP';

  @override
  String get loginVerifyOtp => 'OTP पडताळा';

  @override
  String get loginResendOtp => 'OTP पुन्हा पाठवा';

  @override
  String get loginUsernameLabel => 'वापरकर्तानाव';

  @override
  String get loginUsernameHint => 'उदा. mykiranastore';

  @override
  String get loginUsernameRequired => 'वापरकर्तानाव आवश्यक आहे';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordHint => 'तुमचा पासवर्ड';

  @override
  String get loginPasswordRequired => 'पासवर्ड आवश्यक आहे';

  @override
  String get loginSignIn => 'साइन इन करा';

  @override
  String get loginNoAccount => 'खाते नाही? ';

  @override
  String get loginCreateOne => 'एक तयार करा';

  @override
  String get loginIncorrect =>
      'चुकीचे वापरकर्तानाव किंवा पासवर्ड. कृपया पुन्हा प्रयत्न करा.';

  @override
  String loginFailed(String message) {
    return 'लॉगिन अयशस्वी: $message';
  }

  @override
  String onboardingStepCount(int step) {
    return '$step/4';
  }

  @override
  String get accountVerifyPhoneTitle => 'तुमचा फोन नंबर\nपडताळा';

  @override
  String get accountVerifyPhoneSubtitle =>
      'तुमचा नंबर पुष्टी करण्यासाठी आम्ही एक-वेळ पासवर्ड पाठवू.';

  @override
  String get accountPhoneLabel => 'फोन नंबर';

  @override
  String get accountSendOtp => 'OTP पाठवा';

  @override
  String get accountEnterOtpTitle => 'OTP टाका';

  @override
  String get accountEnterOtpSubtitle => 'तुमच्या फोनवर पाठवलेला 6-अंकी कोड.';

  @override
  String accountOtpSentTo(String phone) {
    return '+91 $phone वर OTP पाठवला';
  }

  @override
  String get accountOtp6Label => '6-अंकी OTP';

  @override
  String get accountVerify => 'पडताळा';

  @override
  String get accountResendOtp => 'OTP पुन्हा पाठवा';

  @override
  String accountPhoneVerified(String phone) {
    return 'फोन पडताळला: $phone';
  }

  @override
  String get accountChooseUsernameTitle => 'दुकानाचे\nवापरकर्तानाव निवडा';

  @override
  String get accountChooseUsernameSubtitle =>
      'तुमचे वापरकर्तानाव तुमच्या दुकानासाठी अद्वितीय आहे आणि लॉगिनसाठी वापरले जाते.';

  @override
  String get accountUsernameLabel => 'वापरकर्तानाव';

  @override
  String get accountUsernameHint => 'उदा. lohiyastore123';

  @override
  String get accountUsernameTaken => 'वापरकर्तानाव आधीच घेतले आहे';

  @override
  String get accountUsernameRules =>
      'फक्त अक्षरे, अंक, अंडरस्कोर • किमान 3 अक्षरे';

  @override
  String get accountErrChooseUsername =>
      'तुमच्या दुकानासाठी एक अद्वितीय वापरकर्तानाव निवडा';

  @override
  String get accountErrUsernameMin3 => 'वापरकर्तानाव किमान 3 अक्षरांचे असावे';

  @override
  String get accountErrUsernameChars =>
      'फक्त अक्षरे, अंक आणि अंडरस्कोर अनुमत आहेत';

  @override
  String get accountErrUsernameTakenTry =>
      'ते वापरकर्तानाव घेतले आहे. दुसरे वापरून पहा.';

  @override
  String get businessTitle => 'तुमच्या दुकानाबद्दल\nआम्हाला सांगा';

  @override
  String get businessSubtitle =>
      'तुमचा अनुभव वैयक्तिकृत करण्यात आम्हाला मदत करा.';

  @override
  String get businessOwnerLabel => 'मालकाचे पूर्ण नाव';

  @override
  String get businessOwnerHint => 'उदा. रमेश कुमार';

  @override
  String get businessOwnerRequired => 'नाव आवश्यक आहे';

  @override
  String get businessStoreLabel => 'दुकानाचे नाव';

  @override
  String get businessStoreHint => 'उदा. श्री लक्ष्मी स्टोअर्स';

  @override
  String get businessStoreRequired => 'दुकानाचे नाव आवश्यक आहे';

  @override
  String get businessEmailLabel => 'ईमेल पत्ता';

  @override
  String get businessEmailHint => 'you@example.com';

  @override
  String get businessEmailRequired => 'ईमेल आवश्यक आहे';

  @override
  String get businessEmailInvalid => 'वैध ईमेल पत्ता टाका';

  @override
  String get businessTypeLabel => 'व्यवसायाचा प्रकार';

  @override
  String get businessTypeHint => 'तुमच्या दुकानाचा प्रकार निवडा';

  @override
  String get businessTypeRequired => 'कृपया तुमच्या व्यवसायाचा प्रकार निवडा';

  @override
  String get businessFootfallLabel => 'अंदाजे दैनिक ग्राहक';

  @override
  String get businessFootfallHint => 'उदा. 40';

  @override
  String get businessFootfallSuffix => 'ग्राहक/दिवस';

  @override
  String get businessFootfallInvalid => 'वैध संख्या टाका';

  @override
  String get businessBudgetLabel => 'मासिक विक्री लक्ष्य (पर्यायी)';

  @override
  String get businessBudgetHint => 'उदा. 150000';

  @override
  String get businessBudgetHelper =>
      'दैनिक प्रगती ट्रॅक करण्यासाठी वापरले जाते. तुम्ही नंतर बदलू शकता.';

  @override
  String get businessBudgetInvalid => 'वैध रक्कम टाका';

  @override
  String get businessTypeKirana => 'किराणा / जनरल स्टोअर';

  @override
  String get businessTypeGeneral => 'जनरल स्टोअर';

  @override
  String get businessTypeProvision => 'प्रोव्हिजन स्टोअर';

  @override
  String get businessTypeFruitsVeg => 'फळे आणि भाजीपाला';

  @override
  String get businessTypePharmacy => 'मेडिकल / फार्मसी';

  @override
  String get businessTypeStationery => 'स्टेशनरी आणि पुस्तके';

  @override
  String get businessTypeSupermarket => 'सुपरमार्केट';

  @override
  String get businessTypeMiniSupermarket => 'मिनी सुपरमार्केट';

  @override
  String get businessTypeMonoBrand => 'मोनो ब्रँड स्टोअर';

  @override
  String get businessTypeBoutique => 'बुटीक';

  @override
  String get businessTypeSalon => 'सलून व पार्लर';

  @override
  String get businessTypeFancyGift => 'फॅन्सी व गिफ्ट स्टोअर';

  @override
  String get businessTypeSportsFitness => 'स्पोर्ट्स व फिटनेस';

  @override
  String get businessTypeFootwear => 'पादत्राणे दुकान';

  @override
  String get businessTypeOptical => 'ऑप्टिकल स्टोअर';

  @override
  String get businessTypeBakery => 'बेकरी व मिठाई दुकान';

  @override
  String get businessTypeApparel => 'कपडे व पोशाख';

  @override
  String get businessTypeElectronics => 'मोबाइल व इलेक्ट्रॉनिक्स';

  @override
  String get businessTypeOthers => 'इतर';

  @override
  String get locationTitle => 'तुमचे दुकान\nकुठे आहे?';

  @override
  String get locationSubtitle =>
      'स्थानिक अंतर्दृष्टी दाखवण्यासाठी आणि डिलिव्हरी झोन सक्षम करण्यासाठी आम्ही याचा वापर करतो.';

  @override
  String get locationDetecting => 'स्थान शोधत आहे…';

  @override
  String get locationDetect => 'माझे स्थान शोधा';

  @override
  String get locationOrManual => 'किंवा स्वतः टाका';

  @override
  String get locationAddressLabel => 'दुकानाचा पत्ता';

  @override
  String get locationAddressHint => 'रस्ता, परिसर, खूण…';

  @override
  String get locationCityLabel => 'शहर / जिल्हा';

  @override
  String get locationCityHint => 'उदा. हैदराबाद';

  @override
  String get locationGettingCoords => 'निर्देशांक मिळवत आहे…';

  @override
  String get locationDetected => 'स्थान सापडले';

  @override
  String get locationErrAddress =>
      'कृपया तुमच्या दुकानाचा पत्ता शोधा किंवा टाका.';

  @override
  String get locationErrCity => 'कृपया तुमचे शहर किंवा जिल्हा टाका.';

  @override
  String get locationPermDenied =>
      'स्थान परवानगी नाकारली. कृपया पत्ता स्वतः टाका.';

  @override
  String get locationDetectFailed =>
      'स्थान शोधता आले नाही. कृपया पत्ता स्वतः टाका.';

  @override
  String get consentTitle => 'जवळजवळ झाले!\nपुनरावलोकन करा आणि सहमत व्हा';

  @override
  String get consentSubtitle =>
      'तुमची सेटअप पूर्ण करण्यासाठी कृपया खालील वाचा आणि स्वीकारा.';

  @override
  String get consentTermsTitle => 'अटी आणि नियम';

  @override
  String get consentTermsSummary =>
      'Outlet AI वापरून, तुम्ही सेवा फक्त कायदेशीर व्यवसाय हेतूंसाठी वापरण्यास सहमत आहात. या अटींचे उल्लंघन करणारी खाती निलंबित करण्याचा अधिकार LohiyaAI राखून ठेवते. तुमचा डेटा फक्त सेवा प्रदान करण्यासाठी आणि सुधारण्यासाठी वापरला जातो.';

  @override
  String get consentPrivacyTitle => 'गोपनीयता धोरण';

  @override
  String get consentPrivacySummary =>
      'तुमचा अनुभव वैयक्तिकृत करण्यासाठी आम्ही तुमचे दुकान तपशील, स्थान आणि व्यवहार डेटा गोळा करतो. आम्ही तुमचा वैयक्तिक डेटा तृतीय पक्षांना कधीही विकत नाही. सर्व डेटा एनक्रिप्ट केलेला आहे आणि Firebase पायाभूत सुविधेवर सुरक्षितपणे साठवला जातो.';

  @override
  String get consentTermsCheckPrefix => 'मी वाचले आहे आणि सहमत आहे ';

  @override
  String get consentPrivacyCheckPrefix => 'मी सहमत आहे ';

  @override
  String get consentAcceptBoth =>
      'सुरू ठेवण्यासाठी कृपया दोन्ही करार स्वीकारा.';

  @override
  String get consentCompleteSetup => 'सेटअप पूर्ण करा';

  @override
  String get regErrPhoneExists =>
      'हा फोन नंबर आधीच नोंदणीकृत आहे. कृपया त्याऐवजी साइन इन करा.';

  @override
  String get regErrUsernameTaken =>
      'हे वापरकर्तानाव आधीच घेतले आहे. कृपया दुसरे निवडा.';

  @override
  String get regErrInvalidDetails =>
      'अवैध तपशील. कृपया तुमची माहिती तपासून पुन्हा प्रयत्न करा.';

  @override
  String regErrFailed(String message) {
    return 'नोंदणी अयशस्वी: $message';
  }

  @override
  String get dashNavHome => 'मुख्यपृष्ठ';

  @override
  String get dashNavKhata => 'खाते';

  @override
  String get dashNavBilling => 'बिलिंग';

  @override
  String get dashTrialWelcome => 'Outlet AI मध्ये आपले स्वागत आहे';

  @override
  String get dashTrialChoosePlan =>
      'मोफत चाचणीसाठी एक योजना निवडा. आमची टीम लवकरच ती सक्रिय करेल.';

  @override
  String get dashTrialSelectPlan => 'तुमची चाचणी योजना निवडा';

  @override
  String get dashTrialRequestPro => 'Pro चाचणीची विनंती करा';

  @override
  String get dashTrialRequestBasic => 'Basic चाचणीची विनंती करा';

  @override
  String get dashTrialSignInDifferent => 'वेगळ्या खात्यात साइन इन करा';

  @override
  String get dashPlanBadgeAllFeatures => 'सर्व वैशिष्ट्ये';

  @override
  String get dashPlanBasicName => 'Basic योजना';

  @override
  String get dashPlanProName => 'Pro योजना';

  @override
  String get dashFeatPos => 'POS आणि विक्री व्यवस्थापन';

  @override
  String get dashFeatInventoryTracking => 'इन्व्हेंटरी ट्रॅकिंग';

  @override
  String get dashFeatFinanceUdhaar => 'वित्त आणि उधार';

  @override
  String get dashFeatKpiInsights => 'KPI अंतर्दृष्टी (प्रति श्रेणी 3)';

  @override
  String get dashFeatAiReco => 'AI शिफारसी';

  @override
  String get dashFeatEverythingBasic => 'Basic मधील सर्व काही';

  @override
  String get dashFeatAllKpi => 'सर्व KPI श्रेणी (अमर्यादित)';

  @override
  String get dashFeatVendorProcurement => 'विक्रेता आणि खरेदी व्यवस्थापन';

  @override
  String get dashFeatCashflowSupport => 'कॅशफ्लो सहाय्य (₹10L पर्यंत)';

  @override
  String get dashFeatCustomerGrowth => 'ग्राहक वाढ इंजिन';

  @override
  String get dashPendingTitle => 'चाचणी विनंती प्राप्त झाली!';

  @override
  String get dashPendingBody =>
      'तुमची चाचणी सक्रियता आमच्या टीमकडून पुनरावलोकन केली जात आहे. मंजूर होताच तुम्हाला तुमच्या डिव्हाइसवर सूचना मिळेल — सहसा काही तासांत.';

  @override
  String get dashPendingNotifNote =>
      'सक्रियता अलर्ट चुकू नये म्हणून सूचना सक्षम असल्याची खात्री करा.';

  @override
  String get dashPendingCheckStatus => 'स्थिती तपासा';

  @override
  String get dashUpgradeTitle => 'मोफत चाचणी संपली';

  @override
  String get dashUpgradeBody =>
      'तुमची मोफत चाचणी संपली आहे. Outlet AI वापरणे सुरू ठेवण्यासाठी आणि तुमचे दुकान वाढवत राहण्यासाठी एक योजना निवडा.';

  @override
  String get dashUpgradeBasic => 'Basic';

  @override
  String get dashUpgradePro => 'Pro';

  @override
  String get dashUpgradeBadgeBest => 'सर्वोत्तम';

  @override
  String dashUpgradeJustPerDay(String price) {
    return 'फक्त $price';
  }

  @override
  String get dashUpgradeAlreadySubscribed => 'आधीच सदस्यता घेतली? रिफ्रेश करा';

  @override
  String get dashFeatPosInventory => 'POS आणि इन्व्हेंटरी';

  @override
  String get dashFeatFinanceKpis => 'वित्त आणि KPIs';

  @override
  String get dashFeatVendorManagement => 'विक्रेता व्यवस्थापन';

  @override
  String get dashFeatCashflowReferrals => 'कॅशफ्लो + रेफरल्स';

  @override
  String get dashNewSale => 'नवीन विक्री';

  @override
  String get dashGreetingMorning => 'शुभ सकाळ';

  @override
  String get dashGreetingAfternoon => 'शुभ दुपार';

  @override
  String get dashGreetingEvening => 'शुभ संध्याकाळ';

  @override
  String dashGreetingWithName(String greeting, String name) {
    return '$greeting, \n$name';
  }

  @override
  String get dashMorningBriefing => 'सकाळचे ब्रीफिंग';

  @override
  String dashBriefingBody(int risk, int reorder) {
    return 'तुमच्याकडे $risk SKUs गंभीर जोखमीत आहेत आणि $reorder वस्तू आज पुन्हा ऑर्डर करायच्या आहेत. दुरुस्त करण्यासाठी टॅप करा.';
  }

  @override
  String get dashIntelligence => 'इंटेलिजन्स';

  @override
  String get dashMetricStockoutLabel => 'स्टॉकआउट जोखीम';

  @override
  String get dashMetricStockoutSub => 'SKUs गंभीर';

  @override
  String get dashMetricReorderLabel => 'आता पुन्हा ऑर्डर करा';

  @override
  String get dashMetricReorderSub => 'कमी स्टॉक SKUs';

  @override
  String get dashMetricFastLabel => 'वेगाने विकणारे';

  @override
  String get dashMetricFastSub => 'टॉप विक्रेते';

  @override
  String get dashMetricProfitLabel => 'नफा निवडी';

  @override
  String get dashMetricProfitSub => 'संधी';

  @override
  String get dashMetricCustomerLabel => 'ग्राहक थकबाकी';

  @override
  String get dashMetricCustomerSub => 'प्रलंबित खाते';

  @override
  String get dashMetricSalesLabel => 'विकलेल्या वस्तू';

  @override
  String get dashMetricSalesSub => 'आज आतापर्यंत';

  @override
  String get dashTodaysPerformance => 'आजची कामगिरी';

  @override
  String get dashPosNotAvailable => 'POS डेटा उपलब्ध नाही';

  @override
  String get dashStatRevenue => 'महसूल';

  @override
  String get dashStatOrders => 'बिले';

  @override
  String get dashStatAvgOrder => 'सरासरी बिल';

  @override
  String get dashStoreOverview => 'दुकान विहंगावलोकन';

  @override
  String get dashStoreSkus => 'SKUs';

  @override
  String get dashStoreFootfall => 'दैनिक ग्राहक';

  @override
  String get dashStoreDailyBudget => 'रोजचा माल खर्च';

  @override
  String dashKpiPeriod(int days) {
    return 'मागील $days दिवस';
  }

  @override
  String get dashCouldNotLoad => 'डेटा लोड करता आला नाही';

  @override
  String get dashRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get dashAlerts => 'अलर्ट';

  @override
  String get dashSeeAll => 'सर्व पहा';

  @override
  String get dashStoreKpis => 'दुकान KPIs';

  @override
  String dashKpiCoverageTooltip(String pct) {
    return 'विक्रीच्या $pct% वर आधारित — काही वस्तूंना किंमत डेटा नाही';
  }

  @override
  String get dashDetailStockout => 'स्टॉकआउट जोखीम';

  @override
  String get dashDetailReorder => 'पुन्हा ऑर्डर आवश्यक';

  @override
  String get dashDetailFastMoving => 'वेगाने विकणाऱ्या वस्तू';

  @override
  String get dashDetailProfit => 'उच्च नफा वस्तू';

  @override
  String get dashDetailDefault => 'इंटेलिजन्स तपशील';

  @override
  String get dashSearchProducts => 'उत्पादने शोधा...';

  @override
  String get dashSortBy => 'क्रमवारी:';

  @override
  String get dashSortProfit => 'नफा';

  @override
  String get dashSortDemand => 'मागणी';

  @override
  String get dashSortRisk => 'जोखीम';

  @override
  String dashStockLabel(String qty) {
    return 'स्टॉक: $qty';
  }

  @override
  String get dashStockRunway => 'स्टॉक रनवे';

  @override
  String get dashOutOfStock => 'स्टॉक संपला';

  @override
  String dashDaysLeft(String days) {
    return '~$days दिवस बाकी';
  }

  @override
  String get dashStatStockoutRisk => 'स्टॉकआउट जोखीम';

  @override
  String get dashStatReorderQty => 'पुन्हा ऑर्डर प्रमाण';

  @override
  String dashUnitsValue(String qty) {
    return '$qty युनिट्स';
  }

  @override
  String dashWeeklyProfitImpact(String amount) {
    return '₹$amount अंदाजे साप्ताहिक नफा परिणाम';
  }

  @override
  String dashCreatePurchaseOrder(String qty) {
    return 'खरेदी ऑर्डर तयार करा · $qty युनिट्स';
  }

  @override
  String get dashNoItemsFound => 'कोणत्याही वस्तू सापडल्या नाहीत';

  @override
  String dashNoResultsFor(String query) {
    return '\"$query\" साठी कोणतेही परिणाम नाहीत';
  }

  @override
  String get dashClearSearch => 'शोध साफ करा';

  @override
  String get dashConnectionError => 'कनेक्शन त्रुटी';

  @override
  String get posCommonCancel => 'रद्द करा';

  @override
  String get posCommonClear => 'साफ करा';

  @override
  String get posCommonRefresh => 'रिफ्रेश करा';

  @override
  String get posCommonAddToCart => 'कार्टमध्ये जोडा';

  @override
  String get posCameraPermissionRequired =>
      'बारकोड स्कॅन करण्यासाठी कॅमेरा परवानगी आवश्यक आहे.';

  @override
  String get posCommonSettings => 'सेटिंग्ज';

  @override
  String posEnterQtyTitle(String unit) {
    return '$unit टाका';
  }

  @override
  String get posQtyFallback => 'प्रमाण';

  @override
  String get posSelectVariant => 'व्हेरियंट निवडा';

  @override
  String posInclGst(String amount) {
    return 'GST सह $amount';
  }

  @override
  String get posOutOfStock => 'स्टॉक संपला';

  @override
  String posVariantStockLine(String stock) {
    return '$stock स्टॉकमध्ये';
  }

  @override
  String posPriceLabel(String price) {
    return 'किंमत: $price';
  }

  @override
  String get posWeightMeasurement => 'वजन / मोजमाप';

  @override
  String get posUnknownBarcodeTitle => 'अज्ञात बारकोड';

  @override
  String posUnknownBarcodeBody(String barcode) {
    return 'बारकोड \"$barcode\" तुमच्या इन्व्हेंटरीमध्ये नाही. तुम्हाला काय करायचे आहे?';
  }

  @override
  String get posAddAsNew => 'नवीन म्हणून जोडा';

  @override
  String get posLinkToExisting => 'विद्यमान वस्तूशी लिंक करा';

  @override
  String posErrLoadingInventory(String error) {
    return 'इन्व्हेंटरी लोड करताना त्रुटी: $error';
  }

  @override
  String posLinkBarcodeTitle(String barcode) {
    return 'बारकोड \"$barcode\" लिंक करा';
  }

  @override
  String get posNoUnbarcodedItems =>
      'बारकोडशिवाय कोणत्याही वस्तू सापडल्या नाहीत.';

  @override
  String posCategoryLabel(String category) {
    return 'श्रेणी: $category';
  }

  @override
  String get posCategoryGeneral => 'जनरल';

  @override
  String posLinkedToItem(String barcode, String name) {
    return '$barcode ला $name शी लिंक केले';
  }

  @override
  String get posScanReferralQr => 'रेफरल QR स्कॅन करा';

  @override
  String posCampaignOutOfStock(String name) {
    return '\"$name\" मधील सर्व वस्तू स्टॉकमध्ये नाहीत';
  }

  @override
  String posCampaignItemsAdded(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return '\"$name\" मधील $count $_temp0 जोडल्या';
  }

  @override
  String posAddedSkipped(int added, int skipped) {
    return '$added जोडल्या · $skipped वगळल्या (स्टॉक संपला)';
  }

  @override
  String posBasketAddedAtPrice(String name, String price) {
    return 'बंडल \"$name\" ₹$price ला जोडले';
  }

  @override
  String posItemsRegularPrice(int count) {
    return '$count वस्तू नियमित किमतीला जोडल्या (बंडलसाठी सर्व वस्तू स्टॉकमध्ये असणे आवश्यक)';
  }

  @override
  String posBasketItemsAdded(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return '\"$name\" मधील $count $_temp0 जोडल्या';
  }

  @override
  String posItemsAddedToCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return '$count $_temp0 कार्टमध्ये जोडल्या';
  }

  @override
  String get posSelectCustomer => 'ग्राहक निवडा';

  @override
  String get posNew => 'नवीन';

  @override
  String get posSearchNameOrPhone => 'नाव किंवा फोनद्वारे शोधा...';

  @override
  String get posNoCustomersFound => 'कोणतेही ग्राहक सापडले नाहीत.';

  @override
  String get posAddNewCustomer => 'नवीन ग्राहक जोडा';

  @override
  String get posSelectFromContacts => 'संपर्कांमधून निवडा';

  @override
  String get posCustomerName => 'ग्राहकाचे नाव';

  @override
  String get posPhoneNumber => 'फोन नंबर';

  @override
  String get posSaveAndSelect => 'जतन करा आणि निवडा';

  @override
  String get posSearchProducts => 'उत्पादने शोधा…';

  @override
  String get posReferralScan => 'रेफरल स्कॅन';

  @override
  String get posOrderHistory => 'ऑर्डर इतिहास';

  @override
  String get posRefreshingProducts => 'उत्पादने रिफ्रेश करत आहे...';

  @override
  String posRefreshFailed(String error) {
    return 'रिफ्रेश अयशस्वी: $error';
  }

  @override
  String posProductsRefreshed(int count) {
    return 'उत्पादने रिफ्रेश केली ($count वस्तू)';
  }

  @override
  String posItemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return 'कार्टमध्ये $count $_temp0';
  }

  @override
  String get posClearCartTitle => 'कार्ट साफ करायचे?';

  @override
  String get posClearCartBody => 'सर्व वस्तू कार्टमधून काढल्या जातील.';

  @override
  String get posFrequentlyBought => 'वारंवार एकत्र खरेदी केले';

  @override
  String get posNoProductsFound => 'कोणतीही उत्पादने सापडली नाहीत';

  @override
  String posStockColon(String stock) {
    return 'स्टॉक: $stock';
  }

  @override
  String get posOffline => 'POS ऑफलाइन';

  @override
  String get posCouldNotConnect => 'POS शी कनेक्ट करता आले नाही.';

  @override
  String get posBundlesAndDeals => 'बंडल आणि डील्स';

  @override
  String get posRefreshAi => 'AI रिफ्रेश करा';

  @override
  String posItemsInBundle(int count) {
    return 'बंडलमध्ये $count वस्तू';
  }

  @override
  String get posBundlePrice => 'बंडल किंमत';

  @override
  String get posItemFallback => 'वस्तू';

  @override
  String posValidUntil(String date) {
    return '$date पर्यंत वैध';
  }

  @override
  String posStockUnitPrice(String stock, String unit, String price) {
    return 'स्टॉक: $stock $unit  ·  ₹$price';
  }

  @override
  String get posNotInStock => 'स्टॉकमध्ये नाही';

  @override
  String get posBundlePriceLabel => 'बंडल किंमत';

  @override
  String get posAddAvailableToCart => 'उपलब्ध वस्तू कार्टमध्ये जोडा';

  @override
  String posVoiceCount(int remaining, int total) {
    return 'व्हॉइस ($remaining/$total)';
  }

  @override
  String get posVoiceOrder => 'व्हॉइस ऑर्डर';

  @override
  String posHandwriteCount(int remaining, int total) {
    return 'हस्तलेखन ($remaining/$total)';
  }

  @override
  String get posHandwrite => 'हस्तलेखन';

  @override
  String get posCartEmpty => 'कार्ट रिकामे आहे';

  @override
  String get posCartEmptyHint =>
      'विक्री सुरू करण्यासाठी उत्पादन शोधा किंवा बारकोड स्कॅन करा.';

  @override
  String get posAddCustomer => 'ग्राहक जोडा';

  @override
  String posItemCount(String count) {
    return '$count वस्तू';
  }

  @override
  String posPlaceOrderAmount(String amount) {
    return 'ऑर्डर द्या · $amount';
  }

  @override
  String get posPosInventory => 'POS / इन्व्हेंटरी';

  @override
  String get posOnline => 'POS ऑनलाइन';

  @override
  String get posTabSales => 'विक्री';

  @override
  String get posTabStock => 'स्टॉक';

  @override
  String get posTabPurchase => 'खरेदी';

  @override
  String get posPurchaseSuppliers => 'खरेदी आणि पुरवठादार';

  @override
  String get posPurchaseSuppliersDesc =>
      'खरेदी ऑर्डर तयार करा, तुमचे पुरवठादार व्यवस्थापित करा आणि तुम्ही त्यांचे काय देणे लागता ते ट्रॅक करा — सर्व एकाच ठिकाणी.';

  @override
  String get posPaywallPurchaseDesc =>
      'खरेदी ऑर्डर आणि पुरवठादार व्यवस्थापित करा. वितरकांना देयके ट्रॅक करा. Pro योजनेवर उपलब्ध.';

  @override
  String get posPrinterSetup => 'प्रिंटर सेटअप';

  @override
  String get posReconnect => 'पुन्हा कनेक्ट करा';

  @override
  String get posForgetPrinter => 'हा प्रिंटर विसरा';

  @override
  String get posPairedDevices => 'जोडलेली ब्लूटूथ डिव्हाइस';

  @override
  String get posNoPairedDevices => 'कोणतीही जोडलेली डिव्हाइस सापडली नाहीत';

  @override
  String get posPairDeviceHint =>
      'प्रथम तुमचा थर्मल प्रिंटर Android\nब्लूटूथ सेटिंग्जमध्ये जोडा, नंतर रिफ्रेश करा.';

  @override
  String get posProOnly => 'फक्त PRO';

  @override
  String get posUpgradeToProDay =>
      'Pro वर अपग्रेड करा  ₹500/महिना · फक्त ₹17/दिवस';

  @override
  String get posReceiptSent => 'पावती प्रिंटरला पाठवली';

  @override
  String get posPrintFailedCheck => 'प्रिंट अयशस्वी — प्रिंटर तपासा';

  @override
  String get posOrderPlaced => 'ऑर्डर दिली!';

  @override
  String posOrderNumber(String id) {
    return 'ऑर्डर #$id';
  }

  @override
  String get posPrintReceipt => 'पावती प्रिंट करा';

  @override
  String get posNewSale => 'नवीन विक्री';

  @override
  String get posViewOrderDetails => 'ऑर्डर तपशील पहा';

  @override
  String get posSelectCustomerForUdhaar => 'कृपया उधार विक्रीसाठी ग्राहक निवडा';

  @override
  String get posConfirmOrder => 'ऑर्डर पुष्टी करा';

  @override
  String get posOrderConfirmed => 'ऑर्डर पुष्टी झाली!';

  @override
  String get posSubtotal => 'उपएकूण';

  @override
  String posReferralDiscount(String pct, String referrer) {
    return 'रेफरल सूट ($pct%)$referrer';
  }

  @override
  String get posGrandTotal => 'एकूण रक्कम';

  @override
  String get posPaymentMethod => 'देयक पद्धत';

  @override
  String get posPayCash => 'रोख';

  @override
  String get posPayUdhaar => 'उधार';

  @override
  String get posUdhaarDueDate => 'परतफेड तारीख';

  @override
  String get posUdhaarDueDateHint => 'ग्राहक कधी परतफेड करेल?';

  @override
  String posBundlePercentOff(int pct) {
    return '$pct% सूट';
  }

  @override
  String posBundleYouSave(String amount) {
    return '$amount ची बचत';
  }

  @override
  String get posBundleRegularPrice =>
      'नियमित किमतीत जोडले (बंडलसाठी सर्व वस्तू स्टॉकमध्ये हव्यात)';

  @override
  String get posPayUpi => 'UPI';

  @override
  String get posComingSoon => 'लवकरच येत आहे';

  @override
  String get posSelectCustomerRequired => 'ग्राहक निवडा (उधारसाठी आवश्यक)';

  @override
  String get posSelectCustomerForUdhaarTitle => 'उधारसाठी ग्राहक निवडा';

  @override
  String get posSearchNameOrPhoneHint => 'नाव किंवा फोनद्वारे शोधा…';

  @override
  String get posPrintAutomatically => 'पावती आपोआप प्रिंट करा';

  @override
  String get posWillPrintAfter => 'ऑर्डर दिल्यानंतर प्रिंट होईल';

  @override
  String posPrinterStatus(String status) {
    return 'प्रिंटर: $status';
  }

  @override
  String get posAutoPrintDisabled =>
      'अक्षम — ऑर्डर तपशीलांमधून स्वतः प्रिंट करा';

  @override
  String get posHowMuchUdhaar => 'किती उधारीवर जाते?';

  @override
  String get posCashNow => 'आता रोख';

  @override
  String get posOnUdhaar => 'उधारीवर';

  @override
  String get posPrintFailedCheckConnection =>
      'प्रिंट अयशस्वी — प्रिंटर कनेक्शन तपासा';

  @override
  String get posTodaysOrders => 'आजच्या ऑर्डर्स';

  @override
  String posTransactionsSoFar(int count) {
    return 'आतापर्यंत $count व्यवहार';
  }

  @override
  String get posViewAll => 'सर्व पहा';

  @override
  String get posNoOrdersToday => 'आज अद्याप कोणतीही ऑर्डर नाही';

  @override
  String get posSalesAppearHere => 'विक्री व्यवहार येथे दिसतील';

  @override
  String posOrderMeta(String time, String payment, String status) {
    return '$time · $payment · $status';
  }

  @override
  String get posPrint => 'प्रिंट';

  @override
  String get posScanBarcode => 'बारकोड स्कॅन करा';

  @override
  String get posAlignBarcode => 'फ्रेममध्ये बारकोड संरेखित करा';

  @override
  String get posLookingUp => 'शोधत आहे…';

  @override
  String posAlreadyInList(String name) {
    return '$name आधीच यादीत आहे';
  }

  @override
  String posItemQty(String name, int qty) {
    return '$name ×$qty';
  }

  @override
  String posItemAdded(String name) {
    return '$name जोडले';
  }

  @override
  String get posNotFoundTapAdd => 'सापडले नाही — स्वतः जोडण्यासाठी टॅप करा';

  @override
  String posItemsScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return '$count $_temp0 स्कॅन केल्या';
  }

  @override
  String get posScanItems => 'वस्तू स्कॅन करा';

  @override
  String get posClearAll => 'सर्व साफ करा';

  @override
  String posLookingUpItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return '$count $_temp0 शोधत आहे…';
  }

  @override
  String posAddItemsToCart(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return '$count $_temp0 कार्टमध्ये जोडा  ·  ₹$total';
  }

  @override
  String get posPointCamera => 'कॅमेरा बारकोडकडे दाखवा';

  @override
  String get posItemsAppearHere => 'तुम्ही स्कॅन करताच वस्तू येथे दिसतील';

  @override
  String get posTransactionHistory => 'व्यवहार इतिहास';

  @override
  String get posFilters => 'फिल्टर्स:';

  @override
  String get posClearAllFilters => 'सर्व साफ करा';

  @override
  String get posNoTransactions => 'कोणतेही व्यवहार सापडले नाहीत';

  @override
  String get posTryAdjustFilters => 'तुमचे फिल्टर्स समायोजित करून पहा';

  @override
  String get posResetFilters => 'फिल्टर्स रीसेट करा';

  @override
  String get posFilterTransactions => 'व्यवहार फिल्टर करा';

  @override
  String get posPaymentStatus => 'देयक स्थिती';

  @override
  String get posFilterAll => 'सर्व';

  @override
  String get posStatusCompleted => 'पूर्ण';

  @override
  String get posStatusPending => 'प्रलंबित';

  @override
  String get posDateRange => 'तारीख श्रेणी';

  @override
  String get posSelectDateRange => 'तारीख श्रेणी निवडा';

  @override
  String get posApplyFilters => 'फिल्टर्स लागू करा';

  @override
  String get posOrderDetails => 'ऑर्डर तपशील';

  @override
  String get posPaymentLabel => 'देयक';

  @override
  String get posTotalAmount => 'एकूण रक्कम';

  @override
  String posCustomerNumber(String id) {
    return 'ग्राहक #$id';
  }

  @override
  String get posItemsSummary => 'वस्तू सारांश';

  @override
  String posProductNumber(String id) {
    return 'उत्पादन #$id';
  }

  @override
  String get posUnitFallback => 'युनिट';

  @override
  String posPrintReceiptStatus(String status) {
    return 'पावती प्रिंट करा ($status)';
  }

  @override
  String get posReturnExchange => 'परतावा / देवाणघेवाण';

  @override
  String get posSplitPayment => 'विभाजित देयक';

  @override
  String get posCashPaidNow => 'आता रोख दिले';

  @override
  String get posOnUdhaarCredit => 'उधारीवर (क्रेडिट)';

  @override
  String get posUdhaarRecordedNote =>
      'उधार भाग क्रेडिट म्हणून नोंदवला — शिल्लकसाठी उधार टॅब तपासा';

  @override
  String get posUdhaarSale => 'उधार विक्री';

  @override
  String get posTotalPaid => 'एकूण भरले';

  @override
  String get posRecordedAsCredit => 'क्रेडिट म्हणून नोंदवले — उधार टॅब तपासा';

  @override
  String get posBoughtAsBasket => 'बास्केट म्हणून खरेदी केले';

  @override
  String get posBasketValue => 'बास्केट मूल्य';

  @override
  String get posCustomerSaved => 'ग्राहकाने वाचवले';

  @override
  String get invSearchItemsOrCategories => 'वस्तू किंवा श्रेणी शोधा...';

  @override
  String get invShowLess => 'कमी दाखवा';

  @override
  String invViewMore(int count) {
    return '+$count अधिक';
  }

  @override
  String get invAll => 'सर्व';

  @override
  String get invUncategorised => 'वर्गीकरण न केलेले';

  @override
  String get invNoMatchesFound => 'कोणतीही जुळणी सापडली नाही';

  @override
  String invNearExpiryBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count वस्तू लवकरच कालबाह्य — मार्कडाउन किंवा क्लिअर करण्यासाठी टॅप करा',
      one: '1 वस्तू लवकरच कालबाह्य — मार्कडाउन किंवा क्लिअर करण्यासाठी टॅप करा',
    );
    return '$_temp0';
  }

  @override
  String invMissingPriceBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उत्पादनांची किंमत ₹0 — किमती सेट करण्यासाठी टॅप करा',
      one: '1 उत्पादनाची किंमत ₹0 — किमती सेट करण्यासाठी टॅप करा',
    );
    return '$_temp0';
  }

  @override
  String get invFlagFast => 'वेगवान';

  @override
  String get invFlagReorder => 'पुन्हा ऑर्डर';

  @override
  String get invFlagLowStock => 'कमी स्टॉक';

  @override
  String get invFlagDead => 'मृत';

  @override
  String get invFlagProfit => 'नफा';

  @override
  String invStockLabel(String stock) {
    return 'स्टॉक: $stock';
  }

  @override
  String get invUnitFallback => 'युनिट';

  @override
  String get invSyncFailedTapRetry =>
      'सिंक अयशस्वी — पुन्हा प्रयत्न करण्यासाठी टॅप करा';

  @override
  String get invSyncingToServer => 'सर्व्हरवर सिंक करत आहे...';

  @override
  String get invNoInventoryYet => 'अद्याप इन्व्हेंटरी नाही';

  @override
  String get invNoInventoryHint =>
      'तुमचे पहिले उत्पादन जोडण्यासाठी + टॅप करा.\nप्रथम श्रेणी तयार करा, नंतर वस्तू जोडा.';

  @override
  String get invAddFirstProduct => 'पहिले उत्पादन जोडा';

  @override
  String get invCouldNotLoadInventory => 'इन्व्हेंटरी लोड करता आली नाही';

  @override
  String get invRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get invSelectCategoryError => 'कृपया श्रेणी निवडा';

  @override
  String invVariantPriceRequired(int number) {
    return 'व्हेरियंट $number: विक्री किंमत आवश्यक आहे';
  }

  @override
  String get invProductSavedSyncing =>
      'उत्पादन जतन केले — पार्श्वभूमीत सिंक होत आहे';

  @override
  String invVariantsSavedSyncing(int count) {
    return '$count व्हेरियंट जतन केले — पार्श्वभूमीत सिंक होत आहे';
  }

  @override
  String get invAddProduct => 'उत्पादन जोडा';

  @override
  String get invAddFromCatalog => 'कॅटलॉगमधून जोडा';

  @override
  String get invNewProduct => 'नवीन उत्पादन';

  @override
  String get invSave => 'जतन करा';

  @override
  String get invSearchProductName => 'उत्पादनाचे नाव शोधा...';

  @override
  String get invLoadMoreResults => 'अधिक परिणाम लोड करा';

  @override
  String get invNoMoreSearchResults => 'आणखी शोध परिणाम नाहीत';

  @override
  String get invSearchProductCatalog => 'उत्पादन कॅटलॉग शोधा';

  @override
  String get invSearchCatalogHint =>
      'नाव टाइप करा किंवा बारकोड स्कॅन करा.\nसापडले नाही तर, स्वतः जोडा.';

  @override
  String get invAddManually => 'स्वतः जोडा';

  @override
  String get invAddManuallySub => 'उत्पादन कॅटलॉगमध्ये नाही? स्वतः तपशील टाका.';

  @override
  String get invProductAdded => 'उत्पादन जोडले!';

  @override
  String invVariantsAdded(int count) {
    return '$count व्हेरियंट जोडले!';
  }

  @override
  String get invLooseItem => 'सुटी वस्तू';

  @override
  String get invLooseItemSub => 'वजनाने विकले (उदा. मैदा, डाळ)';

  @override
  String get invBasicDetails => 'मूलभूत तपशील';

  @override
  String get invProductNameLabel => 'उत्पादनाचे नाव *';

  @override
  String get invRequired => 'आवश्यक';

  @override
  String get invBrandOptional => 'ब्रँड (पर्यायी)';

  @override
  String get invSelectCategoryStar => 'श्रेणी निवडा *';

  @override
  String get invOther => 'इतर';

  @override
  String get invPerishableItem => 'नाशवंत वस्तू';

  @override
  String get invPerishableItemSub => 'कालबाह्यता तारीख आहे';

  @override
  String get invSizePriceStock => 'आकार, किंमत आणि स्टॉक';

  @override
  String invVariantsCount(int count) {
    return 'व्हेरियंट ($count)';
  }

  @override
  String get invAddVariant => 'व्हेरियंट जोडा';

  @override
  String get invManageVariants => 'व्हेरियंट व्यवस्थापित करा';

  @override
  String get invVariants => 'व्हेरियंट';

  @override
  String get invEditVariant => 'व्हेरियंट संपादित करा';

  @override
  String get invSaveVariant => 'व्हेरियंट जतन करा';

  @override
  String get invNoVariantsYet =>
      'अद्याप व्हेरियंट नाहीत. साइज, रंग किंवा मॉडेल जोडा.';

  @override
  String get invStockPerVariantNote =>
      'Stock is tracked per variant. Use Manage Variants below.';

  @override
  String get invDefaultVariant => 'डीफॉल्ट';

  @override
  String invVariantAxisRequired(String label) {
    return 'कृपया $label निवडा';
  }

  @override
  String get invSaveProduct => 'उत्पादन जतन करा';

  @override
  String invSaveVariants(int count) {
    return '$count व्हेरियंट जतन करा';
  }

  @override
  String get invProduct => 'उत्पादन';

  @override
  String invVariantNumber(int number) {
    return 'व्हेरियंट $number';
  }

  @override
  String get invUnit => 'युनिट';

  @override
  String get invBaseUnit => 'मूळ युनिट';

  @override
  String get invPackSize => 'पॅक आकार';

  @override
  String get invPackSizeHint => 'उदा. 250';

  @override
  String get invBarcode => 'बारकोड';

  @override
  String get invFromCatalog => 'कॅटलॉगमधून';

  @override
  String get invOptional => 'पर्यायी';

  @override
  String invPricePerUnit(String unit) {
    return 'किंमत / $unit *';
  }

  @override
  String get invSellingPriceStar => 'विक्री किंमत *';

  @override
  String get invInvalid => 'अवैध';

  @override
  String get invMrp => 'MRP';

  @override
  String get invCostPrice => 'खरेदी किंमत (तुम्ही जे देता)';

  @override
  String get invCostPriceHint => 'पर्यायी — नफा अचूकता सुधारते';

  @override
  String invOpeningStockUnit(String unit) {
    return 'सुरुवातीचा स्टॉक ($unit) *';
  }

  @override
  String get invOpeningStockUnits => 'सुरुवातीचा स्टॉक (युनिट्स) *';

  @override
  String get invExpiryDate => 'कालबाह्यता तारीख';

  @override
  String get invExpiryDateHint => 'YYYY-MM-DD';

  @override
  String get invRequiredForPerishables => 'नाशवंत वस्तूंसाठी आवश्यक';

  @override
  String get invLinkedFromCatalog => 'कॅटलॉगमधून लिंक केले';

  @override
  String get invSelectCategory => 'श्रेणी निवडा';

  @override
  String get invSearchCategories => 'श्रेणी शोधा...';

  @override
  String get invNoCategoriesFound => 'कोणतीही श्रेणी सापडली नाही';

  @override
  String get invEditProduct => 'उत्पादन संपादित करा';

  @override
  String invProductUpdated(String name) {
    return '$name अद्यतनित केले!';
  }

  @override
  String get invProductUpdatedSuccess => 'उत्पादन यशस्वीरित्या अद्यतनित केले!';

  @override
  String get invSellingUnit => 'विक्री युनिट';

  @override
  String get invPricing => 'किंमत';

  @override
  String invPricePerSelected(String unit) {
    return 'प्रति $unit किंमत *';
  }

  @override
  String get invMrpOptional => 'MRP (पर्यायी)';

  @override
  String get invStock => 'स्टॉक';

  @override
  String get invGstRate => 'GST %';

  @override
  String get invHsnCode => 'HSN कोड';

  @override
  String invStockInUnit(String unit) {
    return 'स्टॉक ($unit मध्ये) *';
  }

  @override
  String get invStockQuantityStar => 'स्टॉक प्रमाण *';

  @override
  String get invPerishableBatchNote =>
      'नाशवंत बॅच तपशीलांसाठी, इन्व्हेंटरीमधून \"बॅच प्राप्त करा\" वापरा.';

  @override
  String get invSaveChanges => 'बदल जतन करा';

  @override
  String get invCategoryNameRequired => 'श्रेणीचे नाव आवश्यक आहे';

  @override
  String get invCreateCategoryFailed =>
      'श्रेणी तयार करण्यात अयशस्वी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get invNewCategory => 'नवीन श्रेणी';

  @override
  String get invNewCategorySub =>
      'तुमची उत्पादने व्यवस्थित करण्यासाठी एक श्रेणी जोडा.';

  @override
  String get invCategoryCreated => 'श्रेणी तयार केली!';

  @override
  String get invCategoryNameLabel => 'श्रेणीचे नाव';

  @override
  String get invCategoryNameHint => 'उदा. किराणा, दुग्धजन्य, स्नॅक्स…';

  @override
  String get invCreateCategory => 'श्रेणी तयार करा';

  @override
  String get invCardOutOfStock => 'स्टॉक संपला';

  @override
  String invCardStockLow(String qty) {
    return '$qty — कमी';
  }

  @override
  String invCardStockInStock(String qty) {
    return '$qty स्टॉकमध्ये';
  }

  @override
  String get invCardFast => 'वेगवान';

  @override
  String get invCardSlow => 'मंद';

  @override
  String get invCardExpired => 'कालबाह्य';

  @override
  String invCardDays(String days) {
    return '$daysदि';
  }

  @override
  String get invCardBarcode => 'बारकोड';

  @override
  String get invCardSoldToday => 'आज विकले';

  @override
  String get invCardReorder => 'पुन्हा ऑर्डर';

  @override
  String invCardReorderUnits(String qty) {
    return '$qty युनिट्स';
  }

  @override
  String get invCard7dRisk => '7दि जोखीम';

  @override
  String get invExpiringSoon => 'लवकरच कालबाह्य';

  @override
  String get invNext => 'पुढे';

  @override
  String invDaysWindow(int days) {
    return '$days दिवस';
  }

  @override
  String get invExpired => 'कालबाह्य';

  @override
  String get invExpiresToday => 'आज कालबाह्य होते';

  @override
  String get invExpiresTomorrow => 'उद्या कालबाह्य होते';

  @override
  String invExpiresInDays(int days) {
    return '$days दिवसांत कालबाह्य होते';
  }

  @override
  String invQtyInStock(String qty, String unit) {
    return '$qty $unit स्टॉकमध्ये';
  }

  @override
  String get invAtRisk => 'जोखमीत';

  @override
  String get invMarkedDown => 'मार्कडाउन केले';

  @override
  String get invPrice => 'किंमत';

  @override
  String get invChangeMarkdown => 'मार्कडाउन बदला';

  @override
  String get invMarkDown => 'मार्कडाउन करा';

  @override
  String get invRecordWaste => 'कचरा नोंदवा';

  @override
  String invMarkDownTitle(String name) {
    return '$name मार्कडाउन करा';
  }

  @override
  String get invClearanceDiscount =>
      'कालबाह्यतेपूर्वी विकण्यासाठी क्लिअरन्स सूट';

  @override
  String invPctSuggested(String pct) {
    return '$pct% (सुचवलेले)';
  }

  @override
  String invPct(String pct) {
    return '$pct%';
  }

  @override
  String get invCustom => 'सानुकूल';

  @override
  String get invApplyMarkdown => 'मार्कडाउन लागू करा';

  @override
  String get invMarkdownApplied => 'मार्कडाउन लागू केले';

  @override
  String get invMarkdownFailed => 'मार्कडाउन लागू करता आले नाही';

  @override
  String invWriteOff(String name) {
    return '$name राइट ऑफ करा';
  }

  @override
  String get invWriteOffSub =>
      'खराब झालेले युनिट्स स्टॉकमधून काढते आणि नुकसान नोंदवते.';

  @override
  String invOfQtyInStock(int qty) {
    return 'स्टॉकमधील $qty पैकी';
  }

  @override
  String invUnitsWrittenOff(int units) {
    return '$units युनिट्स राइट ऑफ केली';
  }

  @override
  String get invWasteFailed => 'कचरा नोंदवता आला नाही';

  @override
  String get invNothingExpiring => 'लवकरच काहीही कालबाह्य होत नाही';

  @override
  String get invNothingExpiringSub =>
      'कालबाह्यतेजवळ येणारे नाशवंत बॅच येथे दिसतील.';

  @override
  String get invCouldNotLoadExpiry => 'कालबाह्यता डेटा लोड करता आला नाही';

  @override
  String get invMissingPrices => 'गहाळ किमती';

  @override
  String get invCouldNotLoadPrices => 'किमती लोड करता आल्या नाहीत';

  @override
  String invStockCurrentlyZero(String qty, String unit) {
    return '$qty $unit स्टॉकमध्ये · सध्या ₹0';
  }

  @override
  String invSuggestedPrice(String price, String source) {
    return 'सुचवलेले ₹$price ($source)';
  }

  @override
  String get invSellingPrice => 'विक्री किंमत';

  @override
  String get invSet => 'सेट करा';

  @override
  String get invEnterValidPrice => 'वैध किंमत टाका';

  @override
  String invProductPriced(String name, String price) {
    return '$name ची किंमत ₹$price';
  }

  @override
  String get invCouldNotSetPrice => 'किंमत सेट करता आली नाही';

  @override
  String get invEveryProductPriced => 'प्रत्येक उत्पादनाची किंमत आहे';

  @override
  String get invEveryProductPricedSub => 'काहीही ₹0 ला विकत नाही. छान!';

  @override
  String get finFinance => 'वित्त';

  @override
  String get finErrorLoadingStats => 'आकडेवारी लोड करताना त्रुटी';

  @override
  String get finTabCashflow => 'कॅशफ्लो';

  @override
  String get finTabCustomerUdhaar => 'ग्राहक\nउधार';

  @override
  String get finTabSupplierUdhaar => 'पुरवठादार उधार';

  @override
  String get finMonthlySales => 'मासिक विक्री';

  @override
  String get finMonthlySkus => 'मासिक SKUs';

  @override
  String get finAvailableInFuture => 'भविष्यातील अद्यतनांमध्ये उपलब्ध होईल';

  @override
  String get finFailedLoadUdhaar => 'उधार डेटा लोड करण्यात अयशस्वी';

  @override
  String get finCheckConnection =>
      'कृपया तुमचे कनेक्शन तपासून पुन्हा प्रयत्न करा.';

  @override
  String get finRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get finCustomerDues => 'ग्राहक थकबाकी';

  @override
  String get finNewUdhaar => 'नवीन उधार';

  @override
  String get finAddNewUdhaar => 'नवीन उधार जोडा';

  @override
  String get finContacts => 'संपर्क';

  @override
  String get finSelectExistingCustomer => 'विद्यमान ग्राहक निवडा';

  @override
  String get finOrEnterManually => 'किंवा स्वतः टाका';

  @override
  String get finUdhaarRecorded => 'उधार नोंदवले!';

  @override
  String get finCustomerName => 'ग्राहकाचे नाव';

  @override
  String get finPhoneNumber => 'फोन नंबर';

  @override
  String get finAmount => 'रक्कम';

  @override
  String get finSaveUdhaar => 'उधार जतन करा';

  @override
  String get finEnterValidNamePhoneAmount => 'वैध नाव, फोन आणि रक्कम टाका';

  @override
  String get finSelectCustomer => 'ग्राहक निवडा';

  @override
  String get finSearchByNameOrPhone => 'नाव किंवा फोनद्वारे शोधा...';

  @override
  String get finNoCustomersFound => 'कोणतेही ग्राहक सापडले नाहीत';

  @override
  String get finTotalPending => 'एकूण प्रलंबित';

  @override
  String get finRecovered => 'वसूल केले';

  @override
  String get finCustomers => 'ग्राहक';

  @override
  String finHighRiskDues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उच्च-जोखीम थकबाक्या',
      one: '1 उच्च-जोखीम थकबाकी',
    );
    return '$_temp0 — प्रथम यांचा पाठपुरावा करा';
  }

  @override
  String get finSmartRemindersSubtitle =>
      'स्मार्ट स्मरणपत्रे — वसुली-क्रमवारीनुसार थकबाकी';

  @override
  String finTakenDaysAgo(String date, int days) {
    return 'घेतले: $date ($days दिवसांपूर्वी)';
  }

  @override
  String get finWhatsappReminderSent => 'WhatsApp स्मरणपत्र पाठवले!';

  @override
  String finFailedSendReminder(String error) {
    return 'स्मरणपत्र पाठवण्यात अयशस्वी: $error';
  }

  @override
  String get finSendWhatsappReminder => 'WhatsApp स्मरणपत्र पाठवा';

  @override
  String get finRemind => 'आठवण करा';

  @override
  String get finRemindedToday => 'आज आठवण दिली';

  @override
  String get finRecover => 'वसूल करा';

  @override
  String get finHistory => 'इतिहास';

  @override
  String get finSettled => 'निकाली काढले';

  @override
  String get finRecordPayment => 'पेमेंट नोंदवा';

  @override
  String get finPaymentOldestFirstNote => 'सर्वात जुन्या थकबाकीवर प्रथम लागू';

  @override
  String get finTaken => 'घेतले';

  @override
  String get finPaid => 'भरले';

  @override
  String get finBalanceShort => 'शिल्लक';

  @override
  String finOpenDuesSummary(int count, int days) {
    return '$count थकबाकी · सर्वात जुने $days दिवस';
  }

  @override
  String finSettledSectionTitle(int count) {
    return 'निकाली ($count)';
  }

  @override
  String finRecoverUdhaarFrom(String name) {
    return '$name कडून उधार वसूल करा';
  }

  @override
  String get finRecoveryRecorded => 'वसुली नोंदवली!';

  @override
  String finBalanceLabel(String value) {
    return 'शिल्लक: ₹$value';
  }

  @override
  String get finConfirmRecovery => 'वसुली पुष्टी करा';

  @override
  String get finEnterValidAmount => 'कृपया वैध रक्कम टाका';

  @override
  String finAmountExceedsBalance(String value) {
    return 'रक्कम शिल्लक ₹$value पेक्षा जास्त असू शकत नाही';
  }

  @override
  String get finNoPendingUdhaars => 'कोणतेही प्रलंबित उधार नाहीत';

  @override
  String get finRecoveryHistory => 'वसुली इतिहास';

  @override
  String get finNoRecoveriesYet => 'अद्याप कोणतीही वसुली नोंदवली नाही.';

  @override
  String finRecoveryNumber(int number) {
    return 'वसुली #$number';
  }

  @override
  String finErrorWithMessage(String message) {
    return 'त्रुटी: $message';
  }

  @override
  String get finOverdue => 'मुदत संपलेली';

  @override
  String get finDueToday => 'आज देय';

  @override
  String get finNext7Days => 'पुढील 7 दिवस';

  @override
  String get finNoPendingPayments7Days =>
      'पुढील 7 दिवसांत कोणतीही प्रलंबित देयके नाहीत';

  @override
  String get finPaidLast7Days => 'मागील 7 दिवसांत भरले';

  @override
  String get finNoPaymentsRecorded7Days =>
      'मागील 7 दिवसांत कोणतीही देयके नोंदवली नाहीत';

  @override
  String get finSuppliers => 'पुरवठादार';

  @override
  String get finAddEditSuppliersHint =>
      'खरेदी टॅबमध्ये पुरवठादार जोडा किंवा संपादित करा';

  @override
  String get finNoSuppliersYet => 'अद्याप कोणतेही पुरवठादार नाहीत.';

  @override
  String get finTotalOutstanding => 'एकूण थकबाकी';

  @override
  String get finToday => 'आज';

  @override
  String get finPaid7d => 'भरले (7दि)';

  @override
  String get finStockPurchase => 'स्टॉक खरेदी';

  @override
  String finOverdueSince(String date) {
    return '$date पासून मुदत संपलेली';
  }

  @override
  String finDueOn(String day) {
    return 'देय $day';
  }

  @override
  String get finDueTodayLabel => 'आज देय';

  @override
  String get finToPay => 'भरायचे';

  @override
  String get finDetails => 'तपशील';

  @override
  String get finMarkPaid => 'भरले म्हणून चिन्हांकित करा';

  @override
  String finPurchaseOn(String date) {
    return '$date रोजी खरेदी';
  }

  @override
  String get finNoItemsFound => 'कोणत्याही वस्तू सापडल्या नाहीत.';

  @override
  String get finTotalBill => 'एकूण बिल';

  @override
  String get finTomorrow => 'उद्या';

  @override
  String get finWeekdayMon => 'सोम';

  @override
  String get finWeekdayTue => 'मंगळ';

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
  String get finFailedLoadCashflow => 'कॅशफ्लो डेटा लोड करण्यात अयशस्वी';

  @override
  String get finIncome => 'उत्पन्न';

  @override
  String get finTodaysSales => 'आजची विक्री';

  @override
  String get finCreditExposureUdhaar => 'क्रेडिट एक्सपोजर (उधार)';

  @override
  String get finOutstanding => 'थकबाकी';

  @override
  String get finCustomersWithPendingDues => 'प्रलंबित थकबाकी असलेले ग्राहक';

  @override
  String finCustomersCount(int count) {
    return '$count ग्राहक';
  }

  @override
  String get finCreditVsSalesRatio => 'क्रेडिट विरुद्ध विक्री गुणोत्तर';

  @override
  String finPercentOnCredit(String value) {
    return '$value% क्रेडिटवर';
  }

  @override
  String finOfMonthly(String value) {
    return '$value मासिक पैकी';
  }

  @override
  String get finCreditHealthy => 'निरोगी — क्रेडिट एक्सपोजर कमी आहे';

  @override
  String get finCreditModerate => 'मध्यम — थकबाकी वसूल करण्याचा विचार करा';

  @override
  String get finCreditHigh => 'उच्च — अनेक विक्री क्रेडिटवर आहेत';

  @override
  String get finConsentTitle => 'ग्राहकाची संमती रेकॉर्ड करा';

  @override
  String get finConsentSubtitle => 'या उधारीची आवाजाद्वारे पुष्टी';

  @override
  String get finConsentScriptIntro => 'ग्राहकाला असे म्हणायला सांगा:';

  @override
  String finConsentScript(String total, String udhaar, String date) {
    return 'मी सहमत आहे — एकूण $total, उधार $udhaar, मी $date पर्यंत परतफेड करेन.';
  }

  @override
  String get finConsentTapToRecord => 'माइक दाबा आणि ग्राहकाला बोलू द्या';

  @override
  String get finConsentRecording => 'रेकॉर्ड होत आहे';

  @override
  String get finConsentSaved => 'संमती जतन केली — पार्श्वभूमीत अपलोड होत आहे';

  @override
  String get finConsentSkip => 'वगळा';

  @override
  String get finConsentSectionTitle => 'आवाज संमती';

  @override
  String get finConsentStatusPending => 'अपलोड झाले · विश्लेषण प्रलंबित';

  @override
  String get finConsentStatusAnalyzed => 'सत्यापित';

  @override
  String finConsentMatchScore(String pct) {
    return 'आवाज जुळणी: $pct%';
  }

  @override
  String get finConsentNone => 'आवाज संमती रेकॉर्ड नाही';

  @override
  String get finDueDate => 'परतफेडीची तारीख';

  @override
  String get finDueDateHint => 'ग्राहक कधी परतफेड करेल?';

  @override
  String finDueBy(String date) {
    return '$date पर्यंत द्यायचे';
  }

  @override
  String finClearingDues(int count) {
    return '$count उधार फेडले जात आहेत…';
  }

  @override
  String finDuesCleared(int count) {
    return '$count उधार फेडले';
  }

  @override
  String finClearingDuesProgress(int cleared, int total) {
    return 'उधारी फेडली जात आहे: $cleared/$total';
  }

  @override
  String finDuesClearFailed(int cleared, int total) {
    return 'सर्व उधारी फेडता आली नाही ($cleared/$total)';
  }

  @override
  String get finSmartReminders => 'स्मार्ट स्मरणपत्रे';

  @override
  String get finCouldNotLoadReminders => 'स्मरणपत्रे लोड करता आली नाहीत';

  @override
  String finDaysPending(int days) {
    return '$days दिवस प्रलंबित';
  }

  @override
  String finRiskBadge(String band) {
    return '$band जोखीम';
  }

  @override
  String finLikelyToRecover(int percent) {
    return '~$percent% वसूल होण्याची शक्यता';
  }

  @override
  String get finSendReminder => 'स्मरणपत्र पाठवा';

  @override
  String finReminderSentTo(String name) {
    return '$name ला स्मरणपत्र पाठवले';
  }

  @override
  String get finCouldNotSendReminder => 'स्मरणपत्र पाठवता आले नाही';

  @override
  String get finNoOpenUdhaar => 'कोणतेही खुले उधार नाही';

  @override
  String get finAllCreditSettled =>
      'सर्व क्रेडिट निकाली काढले. छान आणि स्वच्छ!';

  @override
  String get procAddSupplierFirstToCreatePo =>
      'खरेदी ऑर्डर तयार करण्यासाठी प्रथम पुरवठादार जोडा';

  @override
  String procErrorWithMessage(String message) {
    return 'त्रुटी: $message';
  }

  @override
  String get procSuppliers => 'पुरवठादार';

  @override
  String get procNoSuppliersYet => 'अद्याप कोणतेही पुरवठादार जोडले नाहीत.';

  @override
  String get procRecentPurchases => 'अलीकडील खरेदी';

  @override
  String get procAddAtLeastOneSupplier =>
      'तुम्हाला खरेदी जोडायची असल्यास, किमान 1 पुरवठादार जोडा.';

  @override
  String get procNoPurchaseOrdersYet => 'अद्याप कोणत्याही खरेदी ऑर्डर नाहीत.';

  @override
  String get procScanInvoice => 'इन्व्हॉइस स्कॅन करा';

  @override
  String get procAdd => 'जोडा';

  @override
  String get procSuggestedReorders => 'सुचवलेल्या पुन्हा ऑर्डर्स';

  @override
  String get procRunningLowLast30Days =>
      'मागील 30 दिवसांच्या विक्रीवर आधारित कमी होत आहे';

  @override
  String get procAddNewSupplier => 'नवीन पुरवठादार जोडा';

  @override
  String get procContacts => 'संपर्क';

  @override
  String get procSupplierName => 'पुरवठादाराचे नाव';

  @override
  String get procPhoneNumber => 'फोन नंबर';

  @override
  String get procCategoryHint => 'श्रेणी (उदा. दुग्धजन्य, FMCG)';

  @override
  String get procEnterValidPhone => 'वैध फोन नंबर टाका';

  @override
  String get procSaveSupplier => 'पुरवठादार जतन करा';

  @override
  String get procEditSupplier => 'पुरवठादार संपादित करा';

  @override
  String get procSaveChanges => 'बदल जतन करा';

  @override
  String get procNewPurchaseOrder => 'नवीन खरेदी ऑर्डर';

  @override
  String get procRecordItemsFromDistributor =>
      'वितरकाकडून खरेदी केलेल्या वस्तू नोंदवा.';

  @override
  String get procOrderDetails => 'ऑर्डर तपशील';

  @override
  String get procDistributor => 'वितरक';

  @override
  String get procPaymentDueDate => 'देयक देय तारीख';

  @override
  String get procSelectDate => 'तारीख निवडा';

  @override
  String procItemsCount(int count) {
    return 'वस्तू ($count)';
  }

  @override
  String get procAddItem => 'वस्तू जोडा';

  @override
  String get procNoItemsAddedYet => 'अद्याप कोणत्याही वस्तू जोडल्या नाहीत';

  @override
  String get procNotes => 'नोट्स';

  @override
  String get procNotesHint => 'बिल नंबर, डिलिव्हरी नोट्स इ.';

  @override
  String get procTotalAmount => 'एकूण रक्कम';

  @override
  String get procSaveOrder => 'ऑर्डर जतन करा';

  @override
  String get procSearchProduct => 'उत्पादन शोधा...';

  @override
  String procAddProduct(String name) {
    return '$name जोडा';
  }

  @override
  String get procQuantity => 'प्रमाण';

  @override
  String get procCostPricePerUnit => 'प्रति युनिट खरेदी किंमत';

  @override
  String get procCancel => 'रद्द करा';

  @override
  String procDaysCover(String days) {
    return '$daysदि कव्हर';
  }

  @override
  String procOrderQty(String qty) {
    return 'ऑर्डर $qty';
  }

  @override
  String procStockLine(String stock, String perDay, String cover) {
    return 'स्टॉक $stock · ~$perDay/दिवस · $cover';
  }

  @override
  String get procCreatePurchaseOrder => 'खरेदी ऑर्डर तयार करा';

  @override
  String get procEditSupplierTooltip => 'पुरवठादार संपादित करा';

  @override
  String get procMarkAsReceived => 'प्राप्त म्हणून चिन्हांकित करा';

  @override
  String get procPleaseSelectSupplierFirst => 'कृपया प्रथम पुरवठादार निवडा';

  @override
  String get procFromScannedInvoice => 'स्कॅन केलेल्या इन्व्हॉइसमधून';

  @override
  String procPoCreatedWithUnmatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return 'खरेदी ऑर्डर तयार केली! ($count $_temp0 जुळल्या नाहीत)';
  }

  @override
  String get procPoCreatedFromInvoice => 'इन्व्हॉइसमधून खरेदी ऑर्डर तयार केली!';

  @override
  String get procCameraGalleryPdf => 'कॅमेरा · गॅलरी · PDF';

  @override
  String get procScansLabel => 'स्कॅन';

  @override
  String get procScanAgain => 'पुन्हा स्कॅन करा';

  @override
  String get procInvoiceScanProFeature =>
      'इन्व्हॉइस स्कॅन हे Pro वैशिष्ट्य आहे.';

  @override
  String get procUpgradeToPro => 'Pro वर अपग्रेड करा';

  @override
  String get procDailyLimitReached =>
      'दैनिक मर्यादा गाठली. सुरू ठेवण्यासाठी क्रेडिट्स टॉप अप करा.';

  @override
  String get procBuyCredits => 'क्रेडिट्स खरेदी करा';

  @override
  String get procCreatingPurchaseOrder => 'खरेदी ऑर्डर तयार करत आहे…';

  @override
  String get procPurchaseOrderCreated => 'खरेदी ऑर्डर तयार केली!';

  @override
  String get procTryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get procCaptureOrUploadInvoice =>
      'पुरवठादार इन्व्हॉइस कॅप्चर करा किंवा अपलोड करा';

  @override
  String get procUpgradeOrTopUp =>
      'Pro वर अपग्रेड करा किंवा क्रेडिट्स टॉप अप करा';

  @override
  String get procKiranaAiReadsInvoice =>
      'Outlet AI वस्तू, एकूण आणि पुरवठादार तपशील वाचते';

  @override
  String get procCamera => 'कॅमेरा';

  @override
  String get procGallery => 'गॅलरी';

  @override
  String get procUploadPdfImageFile => 'PDF / प्रतिमा फाइल अपलोड करा';

  @override
  String get procKiranaAiReadingInvoice =>
      'Outlet AI तुमचे इन्व्हॉइस वाचत आहे…';

  @override
  String get procExtractingItems => 'वस्तू, प्रमाण आणि एकूण काढत आहे';

  @override
  String get procGrandTotal => 'एकूण रक्कम';

  @override
  String get procSupplierUpper => 'पुरवठादार';

  @override
  String procItemsUpperCount(int count) {
    return 'वस्तू ($count)';
  }

  @override
  String procMatchedCount(int count) {
    return '$count जुळल्या';
  }

  @override
  String procUnmatchedItemsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'न जुळलेल्या वस्तू',
      one: 'न जुळलेली वस्तू',
    );
    return '$count $_temp0 लाइन आयटम म्हणून जोडल्या जाणार नाहीत, परंतु संपूर्ण इन्व्हॉइस एकूण नोंदवली जाईल.';
  }

  @override
  String get procSelectSupplierToContinue => 'सुरू ठेवण्यासाठी पुरवठादार निवडा';

  @override
  String get procCreatePurchaseOrderTitle => 'खरेदी ऑर्डर तयार करा';

  @override
  String procConfidencePercent(int pct) {
    return '$pct% विश्वास';
  }

  @override
  String get procTotalsMatch => '✓ एकूण जुळतात';

  @override
  String get procTotalMismatch => '⚠ एकूण जुळत नाही';

  @override
  String get procUnverified => 'अपडताळलेले';

  @override
  String get procPick => 'निवडा';

  @override
  String procNoMatchTapToSelect(String vendor) {
    return '\"$vendor\" साठी जुळणी नाही — निवडण्यासाठी टॅप करा';
  }

  @override
  String get procSelectSupplier => 'पुरवठादार निवडा';

  @override
  String get procSelectSupplierTitle => 'पुरवठादार निवडा';

  @override
  String get procNoSuppliersAddInPurchaseTab =>
      'अद्याप कोणतेही पुरवठादार नाहीत. खरेदी टॅबमध्ये पुरवठादार जोडा.';

  @override
  String get procLinkToInventory => 'इन्व्हेंटरीशी लिंक करा';

  @override
  String get procSearchProducts => 'उत्पादने शोधा…';

  @override
  String get procNoProductsFound => 'कोणतीही उत्पादने सापडली नाहीत';

  @override
  String procPriceStockLabel(String price, String stock) {
    return '$price · स्टॉक: $stock';
  }

  @override
  String get procMicPermissionDenied =>
      'मायक्रोफोन परवानगी नाकारली. कृपया सेटिंग्जमध्ये ती सक्षम करा.';

  @override
  String get procMicNotAccessible => 'मायक्रोफोन प्रवेशयोग्य नाही.';

  @override
  String procAddedToCartFromVoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return 'व्हॉइस ऑर्डरमधून $count $_temp0 कार्टमध्ये जोडल्या';
  }

  @override
  String get procVoiceOrder => 'व्हॉइस ऑर्डर';

  @override
  String get procSpeakAnyIndianLanguage => 'कोणत्याही भारतीय भाषेत बोला';

  @override
  String get procVoiceOrderProFeature =>
      'व्हॉइस ऑर्डर हे Pro वैशिष्ट्य आहे. प्रवेशासाठी अपग्रेड करा.';

  @override
  String get procUpgrade => 'अपग्रेड करा';

  @override
  String get procNoVoiceOrdersLeft =>
      'आज कोणत्याही व्हॉइस ऑर्डर शिल्लक नाहीत. अधिक क्रेडिट्स मिळवा.';

  @override
  String get procGetCredits => 'क्रेडिट्स मिळवा';

  @override
  String get procVoiceLabel => 'व्हॉइस';

  @override
  String get procTapMicToStart => 'रेकॉर्डिंग सुरू करण्यासाठी मायक टॅप करा';

  @override
  String get procTapToStopAndProcess =>
      'थांबवण्यासाठी आणि प्रक्रिया करण्यासाठी टॅप करा';

  @override
  String get procKiranaAiProcessing => 'Outlet AI प्रक्रिया करत आहे…';

  @override
  String get procHeard => 'ऐकले';

  @override
  String get procNoItemsDetectedTryAgain =>
      'कोणत्याही वस्तू आढळल्या नाहीत. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get procRecordAgain => 'पुन्हा रेकॉर्ड करा';

  @override
  String procAddToCartCount(int count) {
    return '$count कार्टमध्ये जोडा';
  }

  @override
  String get procAutoDetectsLanguages =>
      'स्वयं-शोधते: तेलुगू · हिंदी · उर्दू · तमिळ · कन्नड · मल्याळम · इंग्रजी';

  @override
  String get procInStock => 'स्टॉकमध्ये';

  @override
  String get procLowStock => 'कमी स्टॉक';

  @override
  String get procNotFound => 'सापडले नाही';

  @override
  String get procPickFromInventory => 'इन्व्हेंटरीमधून निवडा';

  @override
  String procAddedToCartFromHandwriting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वस्तू',
      one: 'वस्तू',
    );
    return 'हस्तलेखनातून $count $_temp0 कार्टमध्ये जोडल्या';
  }

  @override
  String get procCanvasNotReady => 'कॅनव्हास तयार नाही';

  @override
  String get procFailedToCaptureCanvas => 'कॅनव्हास कॅप्चर करण्यात अयशस्वी';

  @override
  String get procHandwriteOrder => 'हस्तलेखन ऑर्डर';

  @override
  String get procWriteItemsAnyScript => 'कोणत्याही लिपीत वस्तू लिहा';

  @override
  String get procDrawsLabel => 'ड्रॉ';

  @override
  String get procUndoLastStroke => 'शेवटचा स्ट्रोक पूर्ववत करा';

  @override
  String get procClear => 'साफ करा';

  @override
  String get procHandwriteOrderProFeature =>
      'हस्तलेखन ऑर्डर हे Pro वैशिष्ट्य आहे.';

  @override
  String get procAutoDetectAfter5s => '5 सेकंदांनंतर स्वयं-शोध';

  @override
  String get procWriteItemsHere => 'येथे वस्तू लिहा';

  @override
  String get procUpgradeOrTopUpToWrite =>
      'लिहिण्यासाठी अपग्रेड करा किंवा टॉप अप करा';

  @override
  String get procHandwriteExample => 'उदा. तांदूळ 5kg, साखर 2kg';

  @override
  String get procDetecting => 'शोधत आहे…';

  @override
  String get procDetectItems => 'वस्तू शोधा';

  @override
  String get procRead => 'वाचा';

  @override
  String get procNoItemsDetectedWriteClearly =>
      'कोणत्याही वस्तू आढळल्या नाहीत. अधिक स्पष्टपणे लिहिण्याचा प्रयत्न करा.';

  @override
  String get procWriteAgain => 'पुन्हा लिहा';

  @override
  String get procAnyScriptLanguages =>
      'कोणतीही लिपी: English · తెలుగు · हिंदी · Tamil · ಕನ್ನಡ · മലയാളം';

  @override
  String procProductNumber(String id) {
    return 'उत्पादन #$id';
  }

  @override
  String get procReturnExchange => 'परतावा / देवाणघेवाण';

  @override
  String procOrderPickItemsToReturn(String id) {
    return 'ऑर्डर #$id · परत करायच्या वस्तू निवडा';
  }

  @override
  String get procRecordReturn => 'परतावा नोंदवा';

  @override
  String procBoughtQty(String qty) {
    return '$qty खरेदी केले ';
  }

  @override
  String get procBackToShelf => 'शेल्फवर परत';

  @override
  String get procResaleable => 'पुनर्विक्रीयोग्य';

  @override
  String get procDamagedToVendor => 'खराब → विक्रेता';

  @override
  String procReturnRecordedShelf(int count) {
    return 'परतावा नोंदवला — $count शेल्फवर परत';
  }

  @override
  String procReturnToVendorSuffix(int count) {
    return ', $count विक्रेत्याकडे';
  }

  @override
  String get procCouldNotRecordReturn => 'परतावा नोंदवता आला नाही';

  @override
  String get subYourInsights => 'तुमची अंतर्दृष्टी';

  @override
  String get subError => 'त्रुटी';

  @override
  String get subManageKpis => 'KPIs व्यवस्थापित करा';

  @override
  String get subManageSubscriptions => 'सदस्यता व्यवस्थापित करा';

  @override
  String get subDone => 'पूर्ण';

  @override
  String subKpisSelected(int n) {
    return '$n KPIs निवडले';
  }

  @override
  String get subSelectAll => 'सर्व निवडा';

  @override
  String get subClear => 'साफ करा';

  @override
  String get subUnselect => 'निवड रद्द करा';

  @override
  String subProKpiName(String name) {
    return 'Pro KPI: $name';
  }

  @override
  String get subConfirmSelections => 'निवडी पुष्टी करा';

  @override
  String get subNoActiveKpis => 'कोणतेही सक्रिय KPIs नाहीत';

  @override
  String get subManageToSeeInsights =>
      'अंतर्दृष्टी पाहण्यासाठी तुमच्या सदस्यता व्यवस्थापित करा';

  @override
  String get subFailedLoadInsights => 'थेट अंतर्दृष्टी लोड करण्यात अयशस्वी';

  @override
  String get subManageInventory => 'इन्व्हेंटरी व्यवस्थापित करा';

  @override
  String get subSendReminders => 'स्मरणपत्रे पाठवा';

  @override
  String get subReminderMessage =>
      'नमस्कार, हे आमच्यासोबतच्या तुमच्या व्यवसायाबाबत स्मरणपत्र आहे. कृपया तुमची नवीनतम अद्यतने तपासा.';

  @override
  String get subNewSale => 'नवीन विक्री';

  @override
  String get subAiSummary => 'AI सारांश';

  @override
  String subPoweredBy(String agent) {
    return '$agent द्वारे समर्थित';
  }

  @override
  String get subTarget => 'लक्ष्य';

  @override
  String get subBaseline => 'आधाररेखा';

  @override
  String get subLiveDataBreakdown => 'थेट डेटा विश्लेषण';

  @override
  String get subMlInsights => 'MI अंतर्दृष्टी';

  @override
  String get subNoDynamicInsights =>
      'या KPI साठी कोणतीही डायनॅमिक अंतर्दृष्टी उपलब्ध नाही.';

  @override
  String subPctVsLastPeriod(String pct) {
    return 'मागील कालावधीच्या तुलनेत $pct%';
  }

  @override
  String get subCurrent => 'सध्याचे';

  @override
  String get subWhyThisValue => 'हे मूल्य का?';

  @override
  String get subSomethingWentWrong => 'अरे! काहीतरी चूक झाली';

  @override
  String get subRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get subSubscriptionAndPlans => 'सदस्यता आणि योजना';

  @override
  String subErrorWithDetail(String detail) {
    return 'त्रुटी: $detail';
  }

  @override
  String get subCancelSubscriptionTitle => 'सदस्यता रद्द करायची?';

  @override
  String get subCancelSubscriptionBody =>
      'तुमची सदस्यता त्वरित रद्द केली जाईल. तुम्ही कधीही पुन्हा सदस्यता घेऊ शकता.';

  @override
  String get subKeepPlan => 'योजना ठेवा';

  @override
  String get subCancelSubscription => 'सदस्यता रद्द करा';

  @override
  String get subSubscriptionCancelled => 'सदस्यता रद्द केली.';

  @override
  String subCancelFailed(String detail) {
    return 'रद्द करणे अयशस्वी: $detail';
  }

  @override
  String get subChooseYourPlan => 'तुमची योजना निवडा';

  @override
  String get subFeaturePosSales => 'POS आणि विक्री व्यवस्थापन';

  @override
  String get subFeatureInventoryTracking => 'इन्व्हेंटरी ट्रॅकिंग';

  @override
  String get subFeatureFinanceUdhaar => 'वित्त आणि उधार';

  @override
  String get subFeatureKpiInsights => 'KPI अंतर्दृष्टी (प्रति श्रेणी 3)';

  @override
  String get subFeatureCustomerRelations => 'ग्राहक संबंध';

  @override
  String get subFeatureAiRecommendations => 'AI शिफारसी';

  @override
  String get subFeatureAllKpiCategories => 'सर्व KPI श्रेणी (अमर्यादित)';

  @override
  String get subFeatureVendorProcurement => 'विक्रेता आणि खरेदी व्यवस्थापन';

  @override
  String get subFeatureCashflowSupport => 'कॅशफ्लो सहाय्य (₹10L पर्यंत)';

  @override
  String get subFeatureCustomerGrowth => 'ग्राहक वाढ इंजिन';

  @override
  String get subPerMonth => '/महिना';

  @override
  String get subRestorePurchases => 'खरेदी पुनर्संचयित करा';

  @override
  String get subNeedHelp => 'मदत हवी?';

  @override
  String get subReachWhatsApp =>
      'योजना प्रश्न किंवा बिलिंग सहाय्यासाठी आम्हाला WhatsApp वर संपर्क साधा.';

  @override
  String get subWhatsAppSupport => 'WhatsApp सहाय्य';

  @override
  String get subWhatsAppHelpMessage =>
      'नमस्कार! मला माझ्या Outlet AI सदस्यतेबाबत मदत हवी आहे.';

  @override
  String subCurrentPlanLabel(String plan) {
    return 'सध्याची: $plan';
  }

  @override
  String get subTimeRemaining => 'उर्वरित वेळ: ';

  @override
  String get subBest => 'सर्वोत्तम';

  @override
  String subJustPerDay(String price) {
    return 'फक्त $price/दिवस';
  }

  @override
  String get subTrialPlanNotice =>
      'तुम्ही या योजनेच्या मोफत चाचणीवर आहात. चाचणी संपल्यानंतर प्रवेश ठेवण्यासाठी अपग्रेड करा.';

  @override
  String get subCurrentPlan => 'सध्याची योजना';

  @override
  String subUpgradeToKeepAccess(String name) {
    return '$name प्रवेश ठेवण्यासाठी अपग्रेड करा';
  }

  @override
  String subPayAndActivate(String name) {
    return '$name भरा आणि सक्रिय करा';
  }

  @override
  String get subPaywallFeatureEverythingBasic => 'Basic मधील सर्व काही';

  @override
  String get subPaywallFeaturePriorityAi => 'प्राधान्य AI शिफारसी';

  @override
  String get subProFeature => 'PRO वैशिष्ट्य';

  @override
  String get subProPlanIncludes => 'Pro योजनेत समाविष्ट:';

  @override
  String get subNotNow => 'आता नाही';

  @override
  String get subUpgradeToProPrice =>
      'Pro वर अपग्रेड करा  ₹500/महिना · फक्त ₹17/दिवस';

  @override
  String get subInvoicePack => 'इन्व्हॉइस पॅक';

  @override
  String get subVoicePack => 'व्हॉइस पॅक';

  @override
  String get subHandwritingPack => 'हस्तलेखन पॅक';

  @override
  String get subInvoicePackDesc => 'आणखी 10 पुरवठादार बिले प्रक्रिया करा';

  @override
  String get subVoicePackDesc => 'आणखी 10 ऑडिओ/व्हॉइस ऑर्डर जोडा';

  @override
  String get subHandwritingPackDesc => 'आणखी 10 हस्तलिखित नोट्स स्कॅन करा';

  @override
  String get subPrice => 'किंमत';

  @override
  String get subCreditsRollOverDaily =>
      'क्रेडिट्स कालबाह्य होत नाहीत — ते दररोज पुढे जातात.';

  @override
  String get subCancel => 'रद्द करा';

  @override
  String subPayAmount(int amount) {
    return '₹$amount भरा';
  }

  @override
  String subCreditsAdded(int count, String name) {
    return '$count $name क्रेडिट्स जोडले!';
  }

  @override
  String get subTopUpCredits => 'तुमचे क्रेडिट्स टॉप अप करा';

  @override
  String get subCreditsNeverExpire =>
      'क्रेडिट्स कधीही कालबाह्य होत नाहीत — ते उद्यापर्यंत पुढे जातात!';

  @override
  String subCreditsCount(int count) {
    return '$count क्रेडिट्स';
  }

  @override
  String get subBuy => 'खरेदी करा';

  @override
  String get subTrialExpiredMessage =>
      'तुमची मोफत चाचणी संपली आहे. सुरू ठेवण्यासाठी अपग्रेड करा.';

  @override
  String get subTrialLastDayMessage =>
      'तुमच्या मोफत चाचणीचा शेवटचा दिवस! आता अपग्रेड करा.';

  @override
  String subTrialDaysLeftMessage(int n) {
    return 'तुमच्या चाचणीत $n दिवस बाकी. Basic किंवा Pro वर अपग्रेड करा.';
  }

  @override
  String get subTrialExpiringSoon => 'चाचणी लवकरच संपत आहे';

  @override
  String get subTrialExpiredTitle => 'चाचणी संपली';

  @override
  String get mktMyBaskets => 'माझ्या बास्केट';

  @override
  String get mktCouldNotLoadBaskets => 'बास्केट लोड करता आल्या नाहीत';

  @override
  String get mktPullDownToRetry => 'पुन्हा प्रयत्न करण्यासाठी खाली खेचा';

  @override
  String get mktRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get mktNewBasket => 'नवीन बास्केट';

  @override
  String get mktNoBasketsYet => 'अद्याप कोणत्याही बास्केट नाहीत';

  @override
  String get mktBasketsEmptySubtitle =>
      'कॉम्बो डील्स आणि बंडल ऑफर तयार करा.\nWhatsApp द्वारे तुमच्या सर्व ग्राहकांना अलर्ट करा.';

  @override
  String get mktCreateFirstBasket => 'पहिली बास्केट तयार करा';

  @override
  String get mktDeleteBasketTitle => 'बास्केट हटवायची?';

  @override
  String mktDeleteBasketConfirm(String name) {
    return '\"$name\" हटवायची? हे पूर्ववत करता येणार नाही.';
  }

  @override
  String get mktCancel => 'रद्द करा';

  @override
  String get mktBasketDeleted => 'बास्केट हटवली';

  @override
  String get mktCouldNotDeleteBasket =>
      'बास्केट हटवता आली नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get mktDelete => 'हटवा';

  @override
  String get mktSendWhatsAppAlertTitle => 'WhatsApp अलर्ट पाठवायचा?';

  @override
  String mktSendWhatsAppAlertConfirm(String name) {
    return '\"$name\" साठी बास्केट डील तुमच्या सर्व ग्राहकांना WhatsApp द्वारे पाठवायची?';
  }

  @override
  String get mktSend => 'पाठवा';

  @override
  String mktWhatsAppAlertSent(int sent, int total) {
    return '$total पैकी $sent ग्राहकांना WhatsApp अलर्ट पाठवला!';
  }

  @override
  String get mktNoCustomersWithPhone =>
      'फोन नंबर असलेले कोणतेही ग्राहक सापडले नाहीत.';

  @override
  String mktWhatsAppNotActiveYet(int total) {
    return 'WhatsApp अद्याप सक्रिय नाही. सक्षम झाल्यावर अलर्ट आपोआप $total ग्राहकांना पाठवला जाईल.';
  }

  @override
  String mktAlertFailed(String error) {
    return 'अयशस्वी: $error';
  }

  @override
  String get mktExpired => 'कालबाह्य';

  @override
  String get mktItem => 'वस्तू';

  @override
  String mktFromDate(String date) {
    return '$date पासून';
  }

  @override
  String mktToDate(String date) {
    return '$date पर्यंत';
  }

  @override
  String get mktAlertCustomers => 'ग्राहकांना अलर्ट करा';

  @override
  String get mktNoProductsInInventory =>
      'इन्व्हेंटरीमध्ये कोणतीही उत्पादने नाहीत. कृपया प्रथम POS सिंक करा.';

  @override
  String get mktAllProductsAdded =>
      'सर्व उत्पादने आधीच या बास्केटमध्ये जोडली आहेत';

  @override
  String get mktBasketNameRequired => 'बास्केटचे नाव आवश्यक आहे';

  @override
  String get mktAddAtLeastOneProduct => 'इन्व्हेंटरीमधून किमान एक उत्पादन जोडा';

  @override
  String get mktSave => 'जतन करा';

  @override
  String get mktBasketNameLabel => 'बास्केटचे नाव *';

  @override
  String get mktBasketNameHint => 'उदा. नाश्ता बंडल';

  @override
  String get mktDescriptionOptional => 'वर्णन (पर्यायी)';

  @override
  String get mktDescriptionHint => 'उदा. दूध + ब्रेड + अंडी';

  @override
  String get mktBundlePriceOptional => 'बंडल किंमत (पर्यायी)';

  @override
  String get mktValidity => 'वैधता';

  @override
  String get mktFromDateLabel => 'पासून तारीख';

  @override
  String get mktToDateLabel => 'पर्यंत तारीख';

  @override
  String get mktProducts => 'उत्पादने';

  @override
  String get mktAddProduct => 'उत्पादन जोडा';

  @override
  String get mktTapToPickProducts =>
      'तुमच्या इन्व्हेंटरीमधून उत्पादने निवडण्यासाठी टॅप करा';

  @override
  String mktPricePerUnit(String price) {
    return '₹$price / युनिट';
  }

  @override
  String get mktQty => 'प्रमाण';

  @override
  String get mktCreateBasket => 'बास्केट तयार करा';

  @override
  String get mktSelectProduct => 'उत्पादन निवडा';

  @override
  String get mktSearchProducts => 'उत्पादने शोधा...';

  @override
  String get mktNoProductsFound => 'कोणतीही उत्पादने सापडली नाहीत';

  @override
  String get mktAdd => 'जोडा';

  @override
  String get mktEstTotal => 'अंदाजे एकूण';

  @override
  String get mktAddAll => 'सर्व जोडा';

  @override
  String get mktNotInStock => 'स्टॉकमध्ये नाही';

  @override
  String mktCampaignItemStock(String qty, String unit, String price) {
    return 'स्टॉक: $qty $unit  ·  ₹$price';
  }

  @override
  String get mktEstimatedTotal => 'अंदाजे एकूण';

  @override
  String get mktNoItemsInStock => 'स्टॉकमध्ये कोणत्याही वस्तू नाहीत';

  @override
  String mktAddAvailableItemsToCart(int count) {
    return '$count उपलब्ध वस्तू कार्टमध्ये जोडा';
  }

  @override
  String get mktAreaAssociations => 'क्षेत्र संघटना';

  @override
  String get mktMyAreas => 'माझी क्षेत्रे';

  @override
  String get mktCustomerHeatmap => 'ग्राहक हीटमॅप';

  @override
  String mktErrorWithMessage(String error) {
    return 'त्रुटी: $error';
  }

  @override
  String get mktNoAreasAddedYet => 'अद्याप कोणतीही क्षेत्रे जोडली नाहीत';

  @override
  String get mktAreasEmptySubtitle =>
      'लक्ष्यित मोहीम सूचना मिळवण्यासाठी जवळपासच्या अपार्टमेंट, वसतिगृह, शाळा किंवा कार्यालये जोडा.';

  @override
  String get mktAddFirstArea => 'पहिले क्षेत्र जोडा';

  @override
  String get mktRemoveAreaTitle => 'क्षेत्र काढायचे?';

  @override
  String mktRemoveAreaConfirm(String name) {
    return 'तुमच्या संघटनांमधून \"$name\" काढायचे?';
  }

  @override
  String get mktRemove => 'काढा';

  @override
  String mktHouseholdsCount(int count) {
    return '~$count कुटुंबे';
  }

  @override
  String get mktNoHeatmapDataYet => 'अद्याप कोणताही हीटमॅप डेटा नाही';

  @override
  String get mktHeatmapEmptySubtitle =>
      'क्षेत्रे जोडा आणि त्या क्षेत्रांना ग्राहक टॅग करा. कालांतराने महसूल डेटा येथे दिसेल.';

  @override
  String get mktLast90DaysByRevenue => 'मागील 90 दिवस · महसुलानुसार';

  @override
  String get mktCustomers => 'ग्राहक';

  @override
  String get mktOrders => 'ऑर्डर्स';

  @override
  String get mktAvgOrder => 'सरासरी ऑर्डर';

  @override
  String get mktNoOrdersYetTagCustomers =>
      'अद्याप कोणत्याही ऑर्डर नाहीत — ट्रॅक करण्यासाठी या क्षेत्राला ग्राहक टॅग करा';

  @override
  String get mktAddNearbyArea => 'जवळचे क्षेत्र जोडा';

  @override
  String get mktAreaType => 'क्षेत्र प्रकार';

  @override
  String get mktAreaNameLabel => 'नाव (उदा. प्रेस्टिज अपार्टमेंट्स)';

  @override
  String get mktEstimatedHouseholdsOptional => 'अंदाजे कुटुंबे (पर्यायी)';

  @override
  String get mktNotesOptional => 'नोट्स (पर्यायी)';

  @override
  String get mktAddArea => 'क्षेत्र जोडा';

  @override
  String get mktCustomerGrowth => 'ग्राहक वाढ';

  @override
  String get mktNewCampaign => 'नवीन मोहीम';

  @override
  String get mktNoCampaignsYet => 'अद्याप कोणत्याही मोहिमा नाहीत';

  @override
  String get mktReferralEmptySubtitle =>
      'तुमच्या विद्यमान ग्राहकांना नवीन ग्राहक आणू देण्यासाठी रेफरल मोहीम तयार करा — आणि त्यांना त्यासाठी बक्षीस द्या.';

  @override
  String get mktCreateFirstCampaign => 'पहिली मोहीम तयार करा';

  @override
  String get mktReferralHowItWorks =>
      'ग्राहक त्यांचा QR मित्रांसोबत शेअर करतात. नवीन अभ्यागत POS मध्ये तो स्कॅन करून सूट मिळवतात — आणि रेफरर मैलाचा दगड बक्षिसे कमावतो.';

  @override
  String mktCampaignSummary(String discount, String reward, int n) {
    return 'नवीन ग्राहकांसाठी $discount% सूट  •  दर $n रेफरलला $reward% बक्षीस';
  }

  @override
  String get mktQrCodes => 'QR कोड';

  @override
  String get mktReferrals => 'रेफरल्स';

  @override
  String get mktMaxPerPerson => 'कमाल/व्यक्ती';

  @override
  String get mktGenerateQr => 'QR तयार करा';

  @override
  String mktGenerateQrTitle(String name) {
    return 'QR तयार करा · $name';
  }

  @override
  String get mktSearchCustomer => 'ग्राहक शोधा…';

  @override
  String get mktNoCustomersFound => 'कोणतेही ग्राहक सापडले नाहीत';

  @override
  String get mktNoPhoneForCustomer => 'या ग्राहकासाठी फोन नंबर नाही';

  @override
  String mktReferralWhatsAppMessage(
    String name,
    String code,
    String discount,
    int n,
  ) {
    return 'नमस्कार $name! 🎁\n\nतुम्हाला आमचे दुकान तुमच्या मित्रांसोबत शेअर करण्यासाठी आमंत्रित केले आहे!\n\nतुमचा रेफरल कोड: $code\n\nजेव्हा तुमचा मित्र आमच्या दुकानात येतो आणि हा कोड दाखवतो, तेव्हा त्यांना $discount% सूट मिळते — आणि तुम्ही आणलेल्या प्रत्येक $n मित्रांसाठी तुम्ही बक्षिसे कमावता! 🙌\n\n— LohiyaAI Kirana द्वारे';
  }

  @override
  String get mktWhatsAppNotInstalled =>
      'या डिव्हाइसवर WhatsApp इन्स्टॉल केलेले नाही';

  @override
  String get mktReferralQrCode => 'रेफरल QR कोड';

  @override
  String mktPercentOffForNewCustomers(String discount) {
    return 'नवीन ग्राहकांसाठी $discount% सूट';
  }

  @override
  String mktMilestoneRewardLabel(String reward, int n) {
    return 'मैलाचा दगड बक्षीस: दर $n रेफरलला $reward%';
  }

  @override
  String get mktReferralCodeCopied => 'रेफरल कोड कॉपी केला';

  @override
  String get mktSendViaWhatsApp => 'WhatsApp द्वारे पाठवा';

  @override
  String get mktQrScreenshotHint =>
      'किंवा ग्राहकाला स्क्रीनशॉट घेण्यासाठी हा QR स्क्रीन थेट दाखवा.';

  @override
  String get mktInvalidQrCode => 'अवैध QR कोड';

  @override
  String get mktCampaignNoLongerActive => 'ही रेफरल मोहीम यापुढे सक्रिय नाही';

  @override
  String get mktCouldNotLoadReferralInfo => 'रेफरल माहिती लोड करता आली नाही';

  @override
  String get mktEnterValidPhone => 'वैध 10-अंकी फोन नंबर टाका';

  @override
  String get mktClose => 'बंद करा';

  @override
  String mktReferralFrom(String name) {
    return '$name कडून रेफरल';
  }

  @override
  String mktCampaignDiscountForNewCustomer(String campaign, String discount) {
    return '$campaign  •  नवीन ग्राहकासाठी $discount% सूट';
  }

  @override
  String get mktNewCustomerDetails => 'नवीन ग्राहक तपशील';

  @override
  String get mktNewCustomerPhoneHelper =>
      'नवीन ग्राहकाचा फोन टाका. ऑर्डर दिल्यावर सूट लागू केली जाईल.';

  @override
  String get mktPhoneNumber => 'फोन नंबर';

  @override
  String get mktCustomerNameOptional => 'ग्राहकाचे नाव (पर्यायी)';

  @override
  String get mktCustomerNameHint => 'उदा. ज्ञान कुमार';

  @override
  String mktApplyReferralDiscount(String discount) {
    return '$discount% रेफरल सूट लागू करा';
  }

  @override
  String get mktCampaignNameRequired => 'मोहिमेचे नाव आवश्यक आहे';

  @override
  String get mktEnterValidDiscount => 'वैध सूट % टाका (1–100)';

  @override
  String get mktMilestoneCountMin => 'मैलाचा दगड संख्या किमान 1 असावी';

  @override
  String get mktEnterValidReward => 'वैध बक्षीस % टाका (1–100)';

  @override
  String get mktMaxReferralsMin => 'कमाल रेफरल्स किमान 1 असावे';

  @override
  String get mktFailedToCreateCampaign =>
      'मोहीम तयार करण्यात अयशस्वी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get mktNewReferralCampaign => 'नवीन रेफरल मोहीम';

  @override
  String get mktCampaignName => 'मोहिमेचे नाव';

  @override
  String get mktCampaignNameHint => 'उदा. उन्हाळी रेफरल मोहीम';

  @override
  String get mktNewCustomerDiscountPct => 'नवीन ग्राहक सूट %';

  @override
  String get mktMilestoneRewardPct => 'मैलाचा दगड बक्षीस %';

  @override
  String get mktRewardEveryNReferrals => 'दर N रेफरलला बक्षीस';

  @override
  String get mktRewardEveryNHelper =>
      'रेफरर त्यांनी आणलेल्या दर N नवीन ग्राहकांसाठी मैलाचा दगड बक्षीस कमावतो';

  @override
  String get mktMaxReferralsPerCustomer => 'प्रति ग्राहक कमाल रेफरल्स';

  @override
  String get mktMaxReferralsHelper =>
      'इतक्या यशस्वी रेफरल्सनंतर ग्राहकाला बक्षीस देणे थांबवा';

  @override
  String get mktCreateCampaign => 'मोहीम तयार करा';

  @override
  String get profProfile => 'प्रोफाइल';

  @override
  String profErrorLoadingProfile(String error) {
    return 'प्रोफाइल लोड करताना त्रुटी: $error';
  }

  @override
  String get profNoUserData => 'कोणताही वापरकर्ता डेटा सापडला नाही.';

  @override
  String get profCashflowSupport => 'कॅशफ्लो सहाय्य';

  @override
  String get profCashflowSupportDesc =>
      'अनुकूल परतफेड योजनांसह ₹50K – ₹10L व्यवसाय वित्तासाठी अर्ज करा.';

  @override
  String get profCashflowBannerSubtitle =>
      '₹50K – ₹10L व्यवसाय वित्तासाठी अर्ज करा';

  @override
  String get profSectionCustomers => 'ग्राहक';

  @override
  String get profSectionAnalytics => 'विश्लेषण';

  @override
  String get profSectionStoreAccount => 'दुकान आणि खाते';

  @override
  String get profSectionPlanSupport => 'योजना आणि सहाय्य';

  @override
  String get profSectionAdmin => 'प्रशासक';

  @override
  String get profCustomerGrowth => 'ग्राहक वाढ';

  @override
  String get profCustomerGrowthDesc =>
      'रेफरल इंजिन तयार करा — तुमच्या आनंदी ग्राहकांना आपोआप नवीन ग्राहक आणू द्या.';

  @override
  String get profCustomerRelations => 'ग्राहक संबंध';

  @override
  String get profAreaAssociations => 'क्षेत्र संघटना';

  @override
  String get profKpiSubscriptions => 'KPI सदस्यता';

  @override
  String get profTransactionHistory => 'व्यवहार इतिहास';

  @override
  String get profMyBaskets => 'माझ्या बास्केट';

  @override
  String get profLoyalty => 'लॉयल्टी व ऑफर';

  @override
  String get profServices => 'सेवा व अपॉइंटमेंट';

  @override
  String get profStoreComparison => 'दुकान तुलना';

  @override
  String get profStaff => 'कर्मचारी';

  @override
  String get profEstimatesReturns => 'अंदाज व परतावा';

  @override
  String get profStockRacks => 'स्टॉक रॅक';

  @override
  String get profJobCards => 'जॉब कार्ड';

  @override
  String get profWarranty => 'वॉरंटी व सीरियल';

  @override
  String get profGstReport => 'जीएसटी अहवाल';

  @override
  String get profLanguage => 'भाषा';

  @override
  String get profStoreSettings => 'दुकान सेटिंग्ज';

  @override
  String get profSwitchStore => 'दुकान बदला / जोडा';

  @override
  String get profConfiguration => 'कॉन्फिगरेशन';

  @override
  String get profPasswordSecurity => 'पासवर्ड आणि सुरक्षा';

  @override
  String get profSubscriptionPlans => 'सदस्यता आणि योजना';

  @override
  String get profHelpSupport => 'मदत आणि सहाय्य';

  @override
  String get profUserActivity => 'वापरकर्ता क्रियाकलाप';

  @override
  String get profSignOut => 'साइन आउट करा';

  @override
  String get profTrialExpired => 'चाचणी संपली';

  @override
  String get profAwaitingActivation => 'सक्रियतेची प्रतीक्षा';

  @override
  String get profProTrial => 'Pro चाचणी';

  @override
  String get profBasicTrial => 'Basic चाचणी';

  @override
  String profTrialDaysLeft(String tier, int days) {
    return '$tier · $daysदि बाकी';
  }

  @override
  String profTrialActive(String tier) {
    return '$tier सक्रिय';
  }

  @override
  String get profBasicPlan => 'Basic योजना';

  @override
  String get profProPlan => 'Pro योजना';

  @override
  String get profSyncContacts => 'संपर्क सिंक करा';

  @override
  String get profRefreshList => 'यादी रिफ्रेश करा';

  @override
  String get profAddCustomer => 'ग्राहक जोडा';

  @override
  String get profSearchByNameOrPhone => 'नाव किंवा फोनद्वारे शोधा...';

  @override
  String get profRetry => 'पुन्हा प्रयत्न करा';

  @override
  String profNoSegmentCustomers(String segment) {
    return 'कोणतेही $segment ग्राहक नाहीत';
  }

  @override
  String get profNoCustomersFound => 'कोणतेही ग्राहक सापडले नाहीत.';

  @override
  String get profSegRegular => 'नियमित';

  @override
  String get profSegOccasional => 'प्रासंगिक';

  @override
  String get profSegImpulse => 'आवेगी';

  @override
  String get profSegBulk => 'मोठ्या प्रमाणात';

  @override
  String get profSegCredit => 'क्रेडिट';

  @override
  String get profSegInactive => 'निष्क्रिय';

  @override
  String get profSyncContactsTitle => 'संपर्क सिंक करायचे?';

  @override
  String get profSyncContactsBody =>
      'हे तुमचे फोन संपर्क तुमच्या ग्राहक यादीत आयात करेल. नियमित ग्राहक फोन नंबरद्वारे जुळवले जातील.';

  @override
  String get profCancel => 'रद्द करा';

  @override
  String get profSyncNow => 'आता सिंक करा';

  @override
  String profSyncedContacts(int count) {
    return '$count संपर्क यशस्वीरित्या सिंक केले!';
  }

  @override
  String profSyncFailed(String error) {
    return 'सिंक अयशस्वी: $error';
  }

  @override
  String get profSendWhatsappReengagement => 'WhatsApp पुनर्संलग्नता पाठवा';

  @override
  String profWhatsappReengagementMessage(String name) {
    return 'नमस्कार $name! आम्हाला तुमची आमच्या दुकानात आठवण येते. तुमच्या शेवटच्या भेटीला बराच काळ झाला आहे, आणि आमच्याकडे ताजा स्टॉक आणि उत्तम डील्स तुमची वाट पाहत आहेत. लवकरच आम्हाला भेट द्या — तुमच्या आवडत्या वस्तू तयार आहेत! लवकरच भेटू!';
  }

  @override
  String get profAddNewCustomer => 'नवीन ग्राहक जोडा';

  @override
  String get profEditCustomer => 'ग्राहक संपादित करा';

  @override
  String get profFullName => 'पूर्ण नाव';

  @override
  String get profPhoneNumber => 'फोन नंबर';

  @override
  String get profEmailAddressOptional => 'ईमेल पत्ता (पर्यायी)';

  @override
  String get profHouseholdSize => 'कुटुंब आकार';

  @override
  String get profBirthdayOptional => 'वाढदिवस (पर्यायी)';

  @override
  String get profAnniversaryOptional => 'वर्धापनदिन (पर्यायी)';

  @override
  String get profSaveCustomer => 'ग्राहक जतन करा';

  @override
  String get profFillNameAndPhone => 'कृपया नाव आणि फोन भरा';

  @override
  String get profEnterValidPhone => 'वैध फोन नंबर टाका (फक्त अंक)';

  @override
  String get profCustomerSaved => 'ग्राहक यशस्वीरित्या जतन केला';

  @override
  String get profLoading => 'लोड करत आहे...';

  @override
  String get profCustomerDetails => 'ग्राहक तपशील';

  @override
  String get profStatBalance => 'शिल्लक';

  @override
  String get profStatSpent => 'खर्च केले';

  @override
  String get profStatOrders => 'ऑर्डर्स';

  @override
  String get profCustomerInfo => 'ग्राहक माहिती';

  @override
  String profMembersCount(int count) {
    return '$count सदस्य';
  }

  @override
  String get profJoinedOn => 'सामील झाले';

  @override
  String get profUnknown => 'अज्ञात';

  @override
  String get profPurchaseHistory => 'खरेदी इतिहास';

  @override
  String get profNoOrdersForCustomer =>
      'या ग्राहकासाठी कोणत्याही ऑर्डर सापडल्या नाहीत.';

  @override
  String profErrorLoadingOrders(String error) {
    return 'ऑर्डर्स लोड करताना त्रुटी: $error';
  }

  @override
  String get profDeleteCustomerTitle => 'ग्राहक हटवायचा?';

  @override
  String profDeleteCustomerBody(String name) {
    return 'तुम्हाला खात्री आहे की तुम्ही $name हटवू इच्छिता? ही क्रिया पूर्ववत करता येणार नाही.';
  }

  @override
  String get profDelete => 'हटवा';

  @override
  String profFailedToUpdateArea(String error) {
    return 'क्षेत्र अद्यतनित करण्यात अयशस्वी: $error';
  }

  @override
  String get profAreaAssociation => 'क्षेत्र / संघटना';

  @override
  String get profUnableToLoadAreas => 'क्षेत्रे लोड करण्यात अक्षम';

  @override
  String get profNoAreasTapToAdd =>
      'कोणतीही क्षेत्रे नाहीत — एक जोडण्यासाठी टॅप करा';

  @override
  String get profNone => 'काहीही नाही';

  @override
  String profOrderNumber(String id) {
    return 'ऑर्डर #$id';
  }

  @override
  String get profSave => 'जतन करा';

  @override
  String profError(String error) {
    return 'त्रुटी: $error';
  }

  @override
  String get profBasicInformation => 'मूलभूत माहिती';

  @override
  String get profStoreName => 'दुकानाचे नाव';

  @override
  String get profStoreType => 'दुकान प्रकार (उदा. किराणा, सुपरमार्केट)';

  @override
  String get profBusinessIntelligence => 'व्यवसाय इंटेलिजन्स';

  @override
  String get profFootfallAutoComputed =>
      'सरासरी ग्राहक संख्या तुमच्या विक्रीवर आधारित आपोआप मोजली जाते.';

  @override
  String get profProvideInitialValues =>
      'आमच्या AI ला तुमचा व्यवसाय ऑप्टिमाइझ करण्यात मदत करण्यासाठी प्रारंभिक मूल्ये द्या.';

  @override
  String get profAvgDailyFootfall => 'सरासरी दैनिक ग्राहक';

  @override
  String get profAiAutoUpdating => 'AI स्वयं-अद्यतन';

  @override
  String get profMonthlyStockBudget => 'मासिक स्टॉक बजेट';

  @override
  String get profDailyExpenseBuffer => 'दैनिक खर्च बफर';

  @override
  String get profLocationDetails => 'स्थान तपशील';

  @override
  String get profCityArea => 'शहर / क्षेत्र';

  @override
  String get profStateRegion => 'राज्य / प्रदेश';

  @override
  String get profCity => 'शहर';

  @override
  String get profBusinessVertical => 'व्यवसाय प्रकार';

  @override
  String get profRequired => 'आवश्यक';

  @override
  String get profSettingsSaved => 'सेटिंग्ज यशस्वीरित्या जतन केल्या!';

  @override
  String profFailedToSave(String error) {
    return 'जतन करण्यात अयशस्वी: $error';
  }

  @override
  String get supSplashTagline => 'स्मार्ट व्यवसाय, अधिक स्मार्ट तुम्ही';

  @override
  String get supBlockedAppTitle => 'अ‍ॅप तात्पुरते अनुपलब्ध';

  @override
  String get supBlockedStoreTitle => 'दुकान तात्पुरते अनुपलब्ध';

  @override
  String get supBlockedBody =>
      'आम्ही हे शक्य तितक्या लवकर सोडवण्यासाठी काम करत आहोत. तुम्हाला त्वरित मदत हवी असल्यास, खालील बटण टॅप करा.';

  @override
  String get supBlockedContactUs => 'आमच्याशी संपर्क साधा';

  @override
  String get supBlockedEmailSubjectApp => 'अ‍ॅप प्रवेश समस्या — Outlet AI';

  @override
  String get supBlockedEmailSubjectStore => 'दुकान प्रवेश समस्या — Outlet AI';

  @override
  String supBlockedEmailBody(String reason) {
    return 'नमस्कार LohiyaAI टीम,\n\nमी Outlet AI अ‍ॅप वापरण्यास अक्षम आहे.\n\nप्रदर्शित कारण: $reason\n\nकृपया मला प्रवेश पुनर्संचयित करण्यात मदत करा.\n\n— Kirana मालक';
  }

  @override
  String get supBlockedEmailFallback =>
      'कृपया थेट support@lohiyaai.com वर ईमेल करा.';

  @override
  String get supSupportTitle => 'मदत आणि सहाय्य';

  @override
  String get supSupportHeading => 'आम्ही तुम्हाला कशी मदत करू शकतो?';

  @override
  String get supSupportSubheading => 'तुमच्या प्रश्नांची त्वरित उत्तरे मिळवा';

  @override
  String get supOptionFaqTitle => 'वारंवार विचारले जाणारे प्रश्न';

  @override
  String get supOptionFaqSubtitle => 'सामान्य प्रश्न आणि उत्तरे';

  @override
  String get supOptionReportTitle => 'समस्या नोंदवा';

  @override
  String get supOptionReportSubtitle => 'बग आढळला? आम्हाला कळवा';

  @override
  String get supOptionChatTitle => 'आमच्याशी चॅट करा';

  @override
  String get supOptionChatSubtitle => 'आमच्या सहाय्य टीमशी संपर्क साधा';

  @override
  String get supOptionEmailTitle => 'ईमेल सहाय्य';

  @override
  String get supOptionEmailSubtitle => 'आम्हाला थेट ईमेल पाठवा';

  @override
  String get supChatComingSoon => 'चॅट सहाय्य लवकरच येत आहे!';

  @override
  String get supEmailUnableToOpen => 'ईमेल अ‍ॅप उघडण्यास अक्षम.';

  @override
  String get supEmailError => 'ईमेल अ‍ॅप उघडताना काहीतरी चूक झाली.';

  @override
  String get supFaqTitle => 'FAQs';

  @override
  String get supFaqQ1 => 'मी नवीन उत्पादन कसे जोडू?';

  @override
  String get supFaqA1 =>
      'तुम्ही POS टॅबमधून + बटण क्लिक करून किंवा इन्व्हेंटरी टॅबमधून उत्पादने जोडू शकता. उपलब्ध असल्यास तपशील आपोआप मिळवण्यासाठी तुम्ही बारकोड देखील स्कॅन करू शकता.';

  @override
  String get supFaqQ2 => 'स्टॉकआउट जोखीम अंदाज कसा कार्य करतो?';

  @override
  String get supFaqA2 =>
      'आमचे AI तुमच्या मागील विक्री वेग आणि सध्याच्या स्टॉक पातळीचे विश्लेषण करते. जर त्याने अंदाज लावला की तुम्ही पुढील 3-7 दिवसांत एखादी वस्तू संपवाल, तर ते स्टॉकआउट जोखीम म्हणून ध्वजांकित करते.';

  @override
  String get supFaqQ3 => 'मी ग्राहक क्रेडिट (खाते) कसे व्यवस्थापित करू?';

  @override
  String get supFaqA3 =>
      'ऑर्डर देताना, ग्राहक निवडा आणि देयक पद्धत म्हणून \"क्रेडिट\" निवडा. तुम्ही सर्व प्रलंबित थकबाकी वित्त -> उधार टॅब किंवा ग्राहक संबंध विभागात पाहू शकता.';

  @override
  String get supFaqQ4 => 'मी माझे फोन संपर्क सिंक करू शकतो का?';

  @override
  String get supFaqA4 =>
      'होय! प्रोफाइल -> ग्राहक संबंध वर जा आणि सिंक चिन्ह क्लिक करा. हे सोप्या क्रेडिट ट्रॅकिंगसाठी तुमचे नियमित खरेदीदार अ‍ॅपमध्ये आयात करेल.';

  @override
  String get supFaqQ5 => 'KPI सदस्यता म्हणजे काय?';

  @override
  String get supFaqA5 =>
      'KPIs म्हणजे महसूल, मार्जिन आणि ग्राहक संख्या यासारखे प्रमुख व्यवसाय मेट्रिक्स. तुम्ही प्रोफाइल -> सदस्यता विभागातून कोणते मेट्रिक्स निरीक्षण करायचे ते निवडू शकता.';

  @override
  String get supFaqQ6 => 'मी दैनिक विक्री अहवाल कसा तयार करू?';

  @override
  String get supFaqA6 =>
      'तुम्ही डॅशबोर्डवर आजची कामगिरी पाहू शकता. तपशीलवार मागील अहवालांसाठी, तुमच्या प्रोफाइलमधील व्यवहार इतिहास विभागाला भेट द्या.';

  @override
  String get supReportTitle => 'समस्या नोंदवा';

  @override
  String get supReportHeading => 'समस्येचे वर्णन करा';

  @override
  String get supReportSubheading =>
      'आमची टीम तुमचा अहवाल पुनरावलोकन करेल आणि शक्य तितक्या लवकर तो दुरुस्त करेल.';

  @override
  String get supReportCategoryLabel => 'समस्या श्रेणी';

  @override
  String get supReportSummaryLabel => 'संक्षिप्त सारांश';

  @override
  String get supReportSummaryHint => 'उदा. बारकोड स्कॅन करताना अ‍ॅप क्रॅश होते';

  @override
  String get supReportDescriptionLabel => 'तपशीलवार वर्णन';

  @override
  String get supReportDescriptionHint =>
      'समस्या पुन्हा कशी निर्माण करायची याबद्दल तपशील द्या...';

  @override
  String get supReportSubmit => 'अहवाल सबमिट करा';

  @override
  String get supReportFillFields => 'कृपया सर्व फील्ड भरा';

  @override
  String get supReportSubmittedTitle => 'अहवाल सबमिट केला';

  @override
  String get supReportSubmittedBody =>
      'तुमच्या अभिप्रायाबद्दल धन्यवाद. आमची टीम त्वरित यात लक्ष घालेल.';

  @override
  String get supOk => 'ठीक आहे';

  @override
  String supReportSubmitFailed(String error) {
    return 'अहवाल सबमिट करण्यात अयशस्वी: $error';
  }

  @override
  String get supCategoryAppBug => 'अ‍ॅप बग';

  @override
  String get supCategoryPricing => 'किंमत समस्या';

  @override
  String get supCategoryInventory => 'इन्व्हेंटरी जुळत नाही';

  @override
  String get supCategoryAiFeedback => 'AI शिफारस अभिप्राय';

  @override
  String get supCategoryPosError => 'POS त्रुटी';

  @override
  String get supCategoryFeatureRequest => 'वैशिष्ट्य विनंती';

  @override
  String get supCategoryOther => 'इतर';

  @override
  String get shrSavingChanges => 'बदल जतन करत आहे...';

  @override
  String get shrRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get shrSavedSuccessfully => 'यशस्वीरित्या जतन केले!';

  @override
  String get shrBusinessAlerts => 'व्यवसाय अलर्ट';

  @override
  String get shrAllCaughtUp => 'सर्व पूर्ण झाले!';

  @override
  String get shrNoUrgentAlerts => 'सध्या कोणतेही तातडीचे अलर्ट नाहीत.';

  @override
  String get shrAlertOutOfStock => 'स्टॉक संपला';

  @override
  String get shrAlertLowStock => 'कमी स्टॉक';

  @override
  String get shrAlertExpiringSoon => 'लवकरच कालबाह्य';

  @override
  String get shrAlertOverdueUdhaar => 'दीर्घ मुदत संपलेले उधार';

  @override
  String get shrAlertOverduePayment => 'मुदत संपलेले देयक';

  @override
  String get shrAlertUpcomingPayment => 'आगामी देयक';

  @override
  String shrMsgOutOfStock(String name) {
    return '$name पूर्णपणे स्टॉकमध्ये नाही.';
  }

  @override
  String shrMsgLowStock(String name, String stock) {
    return '$name कमी होत आहे ($stock).';
  }

  @override
  String shrMsgExpiringSoon(String name, int days) {
    return '$name $days दिवसांत कालबाह्य होते.';
  }

  @override
  String shrMsgOverdueUdhaar(String name, String amount, int days) {
    return '$name कडे $days दिवसांपासून ₹$amount प्रलंबित आहे.';
  }

  @override
  String shrMsgPaymentOverdue(String amount, String supplier) {
    return '$supplier ला ₹$amount ची मुदत संपली आहे.';
  }

  @override
  String shrMsgPaymentDue(String amount, String supplier, int days) {
    return '$supplier ला ₹$amount $days दिवसांत देय.';
  }

  @override
  String psetErrorWith(String error) {
    return 'त्रुटी: $error';
  }

  @override
  String get psetCancel => 'रद्द करा';

  @override
  String get psetReset => 'रीसेट करा';

  @override
  String get psetUserActivity => 'वापरकर्ता क्रियाकलाप';

  @override
  String get psetNoUsersFound => 'कोणतेही वापरकर्ते सापडले नाहीत';

  @override
  String get psetNoStore => 'कोणतेही दुकान नाही';

  @override
  String get psetNever => 'कधीही नाही';

  @override
  String get psetActiveToday => 'आज सक्रिय';

  @override
  String get psetInactive => 'निष्क्रिय';

  @override
  String get psetLastSeen => 'शेवटचे पाहिले';

  @override
  String get psetOpensToday => 'आज उघडले';

  @override
  String get psetTimeInApp => 'अ‍ॅपमधील वेळ';

  @override
  String get psetSalesToday => 'आजची विक्री';

  @override
  String get psetJustNow => 'आत्ताच';

  @override
  String psetMinsAgo(int m) {
    return '$mमि पूर्वी';
  }

  @override
  String psetHoursAgo(int h) {
    return '$hता पूर्वी';
  }

  @override
  String psetDaysAgo(int d) {
    return '$dदि पूर्वी';
  }

  @override
  String get psetPasswordSecurity => 'पासवर्ड आणि सुरक्षा';

  @override
  String psetCouldNotLoadStatus(String error) {
    return 'स्थिती लोड करता आली नाही: $error';
  }

  @override
  String get psetEnterNewPassword => 'नवीन पासवर्ड टाका';

  @override
  String get psetPasswordMin6 => 'पासवर्ड किमान 6 अक्षरांचा असावा';

  @override
  String get psetPasswordsNoMatch => 'पासवर्ड जुळत नाहीत';

  @override
  String get psetEnterCurrentPassword => 'तुमचा सध्याचा पासवर्ड टाका';

  @override
  String get psetPasswordUpdated => 'पासवर्ड यशस्वीरित्या अद्यतनित केला.';

  @override
  String get psetPasswordCreated => 'पासवर्ड यशस्वीरित्या तयार केला.';

  @override
  String get psetCouldNotConnect =>
      'सर्व्हरशी कनेक्ट करता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get psetSomethingWrong => 'काहीतरी चूक झाली';

  @override
  String get psetPasswordSet => 'पासवर्ड सेट केला';

  @override
  String get psetNoPasswordYet => 'अद्याप पासवर्ड नाही';

  @override
  String psetLastChanged(String date) {
    return 'शेवटचे बदलले $date';
  }

  @override
  String get psetPasswordActive => 'पासवर्ड सक्रिय आहे';

  @override
  String get psetCreatePasswordHint =>
      'वापरकर्तानाव लॉगिन सक्षम करण्यासाठी पासवर्ड तयार करा';

  @override
  String psetPasswordCooldown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिवसांत',
      one: '1 दिवसात',
    );
    return 'तुम्ही $_temp0 पुन्हा तुमचा पासवर्ड बदलू शकता.';
  }

  @override
  String get psetChangePassword => 'पासवर्ड बदला';

  @override
  String get psetCreatePassword => 'पासवर्ड तयार करा';

  @override
  String get psetChangeSubtitle =>
      'तुमचा सध्याचा पासवर्ड टाका, नंतर नवीन निवडा.';

  @override
  String get psetCreateSubtitle =>
      'तुम्ही तुमच्या वापरकर्तानावाने देखील लॉगिन करू शकता म्हणून पासवर्ड सेट करा.';

  @override
  String get psetCurrentPassword => 'सध्याचा पासवर्ड';

  @override
  String get psetNewPassword => 'नवीन पासवर्ड';

  @override
  String get psetConfirmNewPassword => 'नवीन पासवर्ड पुष्टी करा';

  @override
  String get psetUpdatePassword => 'पासवर्ड अद्यतनित करा';

  @override
  String get psetPasswordCooldownNote =>
      'पासवर्ड दर 14 दिवसांतून एकदाच बदलता येतो.';

  @override
  String get psetAllHistory => 'सर्व इतिहास';

  @override
  String get psetTabPurchases => 'खरेदी';

  @override
  String get psetTabPosOrders => 'POS ऑर्डर्स';

  @override
  String get psetNoPurchaseHistory => 'कोणताही खरेदी इतिहास सापडला नाही.';

  @override
  String get psetViewBill => 'बिल पहा';

  @override
  String get psetPurchaseDetails => 'खरेदी तपशील';

  @override
  String psetFromSupplier(String supplier) {
    return '$supplier कडून';
  }

  @override
  String psetQtyTimes(String qty, String price) {
    return 'प्रमाण: $qty × ₹$price';
  }

  @override
  String get psetTotalAmount => 'एकूण रक्कम';

  @override
  String get psetSalesTxnHistory => 'विक्री व्यवहार इतिहास';

  @override
  String get psetSalesTxnDesc =>
      'तुमच्या सर्व POS ऑर्डर्स, देयके आणि ग्राहक व्यवहार पहा आणि फिल्टर करा.';

  @override
  String get psetOpenSalesHistory => 'विक्री इतिहास उघडा';

  @override
  String get psetSettingsSaved => 'सेटिंग्ज जतन केल्या';

  @override
  String psetSaveFailed(String error) {
    return 'जतन अयशस्वी: $error';
  }

  @override
  String get psetResetToDefaults => 'डीफॉल्टवर रीसेट करा';

  @override
  String get psetResetConfirm =>
      'सर्व सेटिंग्ज त्यांच्या डीफॉल्ट मूल्यांवर रीसेट केल्या जातील.';

  @override
  String get psetConfiguration => 'कॉन्फिगरेशन';

  @override
  String get psetPosPreferences => 'POS प्राधान्ये';

  @override
  String get psetAiForecasting => 'AI आणि अंदाज';

  @override
  String get psetAlertThresholds => 'अलर्ट थ्रेशोल्ड';

  @override
  String get psetMarketing => 'मार्केटिंग';

  @override
  String get psetNotifications => 'सूचना';

  @override
  String get psetDefaultPayment => 'डीफॉल्ट देयक पद्धत';

  @override
  String get psetDefaultPaymentHint =>
      'नवीन विक्री जोडताना पूर्व-निवडलेली पद्धत';

  @override
  String get psetCash => 'रोख';

  @override
  String get psetCard => 'कार्ड';

  @override
  String get psetForecastHorizon => 'अंदाज क्षितिज';

  @override
  String get psetForecastHorizonHint =>
      'AI किती दिवस पुढे स्टॉक गरजांचा अंदाज लावते';

  @override
  String psetDaysValue(int days) {
    return '$days दिवस';
  }

  @override
  String get psetStockoutRisk => 'स्टॉकआउट जोखीम थ्रेशोल्ड';

  @override
  String get psetStockoutRiskHint =>
      '7-दिवसांची जोखीम यापेक्षा जास्त असेल तेव्हा स्टॉकआउट अलर्ट दाखवा';

  @override
  String get psetMinVelocity => 'किमान वेग थ्रेशोल्ड';

  @override
  String get psetMinVelocityHint =>
      'यापेक्षा हळू विकणाऱ्या वस्तू मृत स्टॉक म्हणून ध्वजांकित केल्या जातात';

  @override
  String get psetReorderAlertDays => 'पुन्हा ऑर्डर अलर्ट दिवस';

  @override
  String get psetReorderAlertHint =>
      'अंदाजित स्टॉक N दिवसांत संपेल तेव्हा अलर्ट करा';

  @override
  String get psetDeadStockDays => 'मृत स्टॉक दिवस';

  @override
  String get psetDeadStockHint =>
      'N किंवा अधिक दिवस विक्री नसलेल्या वस्तू ध्वजांकित करा';

  @override
  String get psetExpiryAlertDays => 'कालबाह्यता अलर्ट दिवस';

  @override
  String get psetExpiryAlertHint =>
      'बॅच/वस्तू कालबाह्य होण्याच्या इतक्या दिवस आधी अलर्ट करा';

  @override
  String psetDaysBeforeValue(int days) {
    return '$days दिवस आधी';
  }

  @override
  String get psetAllowMarketing => 'LohiyaAI ला माझे दुकान मार्केट करू द्या';

  @override
  String get psetAllowMarketingHint =>
      'आम्ही तुमच्या वतीने Facebook, Instagram आणि WhatsApp वर तुमच्या दुकानाचा प्रचार करतो';

  @override
  String get psetInAppAlerts => 'अ‍ॅपमधील अलर्ट';

  @override
  String get psetInAppAlertsHint => 'अ‍ॅपमध्ये अलर्ट दाखवा';

  @override
  String get psetWhatsappNotif => 'WhatsApp सूचना';

  @override
  String get psetWhatsappNotifHint =>
      'WhatsApp द्वारे रीस्टॉकिंग आणि उधार अलर्ट पाठवा';

  @override
  String get psetQuietHours => 'शांत तास';

  @override
  String get psetQuietHoursHint =>
      'या कालावधीत कोणत्याही सूचना पाठवल्या जाणार नाहीत';

  @override
  String get psetStart => 'सुरुवात';

  @override
  String get psetEnd => 'शेवट';

  @override
  String get psetSaveChanges => 'बदल जतन करा';

  @override
  String get psetCashflowSupport => 'कॅशफ्लो सहाय्य';

  @override
  String get psetRequestUnderReview => 'विनंती पुनरावलोकनाधीन';

  @override
  String psetReqProcessingFull(String amount, String bank) {
    return '$bank द्वारे ₹$amount साठी तुमची कॅशफ्लो विनंती प्रक्रिया केली जात आहे.\n\nआमची टीम 2 व्यावसायिक दिवसांत तुमच्याशी संपर्क साधेल.';
  }

  @override
  String get psetReqProcessing =>
      'तुमची कॅशफ्लो विनंती प्रक्रिया केली जात आहे.\n\nआमची टीम 2 व्यावसायिक दिवसांत तुमच्याशी संपर्क साधेल.';

  @override
  String get psetRequestSubmitted => 'विनंती सबमिट केली!';

  @override
  String get psetRequestSubmittedBody =>
      'आम्हाला तुमची कॅशफ्लो विनंती मिळाली.\nआमची टीम 2 व्यावसायिक दिवसांत\nतुमच्याशी संपर्क साधेल.';

  @override
  String get psetBackToProfile => 'प्रोफाइलवर परत';

  @override
  String get psetApplyCashflow => 'कॅशफ्लो सहाय्यासाठी\nअर्ज करा';

  @override
  String get psetCashflowSubtitle =>
      'जलद व्यवसाय वित्त, LohiyaAI भागीदारांद्वारे समर्थित.';

  @override
  String get psetYourBusinessProfile => 'तुमची व्यवसाय प्रोफाइल';

  @override
  String get psetStore => 'दुकान';

  @override
  String get psetLocation => 'स्थान';

  @override
  String get psetDailyFootfall => 'दैनिक ग्राहक';

  @override
  String psetCustomersPerDay(int count) {
    return '$count ग्राहक/दिवस';
  }

  @override
  String get psetHowMuchNeed => 'तुम्हाला किती हवे आहे?';

  @override
  String get psetDragToSelect =>
      'निवडण्यासाठी ड्रॅग करा — ₹50,000 ते ₹10,00,000';

  @override
  String get psetLoanAmount => 'कर्ज रक्कम';

  @override
  String get psetChoosePartnerBank => 'भागीदार बँक निवडा';

  @override
  String get psetSelectBankHint =>
      'तुमच्या विनंतीसह पुढे जाण्यासाठी बँक निवडा.';

  @override
  String get psetSubmitRequest => 'विनंती सबमिट करा';

  @override
  String get psetSubmitDisclaimer =>
      'सबमिट करून, तुम्ही या विनंतीबाबत आमच्या टीमकडून संपर्क साधला जाण्यास सहमत आहात.';

  @override
  String get psetBankSbiDesc => 'लहान व्यवसायांसाठी सरकार-समर्थित योजना';

  @override
  String get psetBankHdfcDesc => 'किरकोळ वाढीसाठी जलद वितरण';

  @override
  String get psetBankIciciDesc => 'किराणा मालकांसाठी लवचिक क्रेडिट';

  @override
  String get psetBankAxisDesc => 'किरकोळ दुकानांसाठी अनुकूल वित्त';

  @override
  String get widgetTitleSales => 'आजची विक्री';

  @override
  String get widgetTitleUdhaar => 'उधार येणे';

  @override
  String get widgetTitleLowStock => 'कमी स्टॉक';

  @override
  String get widgetTitlePayToday => 'आज पैसे द्या';

  @override
  String get widgetNewBill => '+ नवीन बिल';

  @override
  String get widgetUnitOrders => 'ऑर्डर';

  @override
  String get widgetUnitItems => 'वस्तू';

  @override
  String get widgetUnitOverdue => 'मुदत संपलेले';

  @override
  String get widgetUnitPending => 'प्रलंबित';

  @override
  String get widgetUnitToPay => 'द्यायचे';

  @override
  String get widgetSignIn => 'साइन इन करण्यासाठी Outlet AI उघडा';

  @override
  String get widgetNoData => 'आजचे आकडे लोड करण्यासाठी अॅप उघडा';

  @override
  String get visionComingSoon => 'व्हिजन AI लवकरच येत आहे!';

  @override
  String get mktTierBronze => 'Bronze';

  @override
  String get mktTierSilver => 'Silver';

  @override
  String get mktTierGold => 'Gold';

  @override
  String get mktTierPlatinum => 'Platinum';

  @override
  String get mktTierSettings => 'टियर सेटिंग्ज';

  @override
  String get mktShowArchived => 'संग्रहित दाखवा';

  @override
  String get mktHideArchived => 'संग्रहित लपवा';

  @override
  String get mktArchived => 'संग्रहित';

  @override
  String get mktEdit => 'संपादित करा';

  @override
  String get mktAlertedToday => 'आज सूचित केले';

  @override
  String get mktRestore => 'पुनर्संचयित करा';

  @override
  String get mktArchive => 'संग्रहित करा';

  @override
  String get mktBasketArchived => 'बास्केट संग्रहित';

  @override
  String get mktBasketRestored => 'बास्केट पुनर्संचयित';

  @override
  String get mktSomethingWentWrong =>
      'काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get mktEditBasket => 'बास्केट संपादित करा';

  @override
  String get mktSaveChanges => 'बदल जतन करा';

  @override
  String get mktAddItemsForPrice =>
      'स्वयं-सवलत बंडल किंमत पाहण्यासाठी वस्तू जोडा';

  @override
  String get mktItemsTotal => 'वस्तू एकूण';

  @override
  String get mktBundlePrice => 'बंडल किंमत';

  @override
  String get mktTierConfigTitle => 'बास्केट टियर';

  @override
  String get mktTierConfigIntro =>
      'बास्केटची एकूण किंमत त्यांच्या एकूण मूल्यानुसार आपोआप ठरते. प्रत्येक टियरसाठी मूल्य श्रेणी व सवलत सेट करा — वस्तू जोडताच जुळणाऱ्या टियरची सवलत आपोआप लागू होते.';

  @override
  String get mktTierRangeInvalid =>
      'प्रत्येक टियरची मर्यादा मागील पेक्षा जास्त असावी, आणि सवलत 0–100% दरम्यान.';

  @override
  String get mktTiersSaved => 'टियर जतन केले';

  @override
  String get mktRecomputeTitle => 'विद्यमान बास्केट पुन्हा मोजायचे?';

  @override
  String get mktKeepAsIs => 'जसे आहे तसे ठेवा';

  @override
  String get mktRecompute => 'पुन्हा मोजा';

  @override
  String get mktSaveTiers => 'टियर जतन करा';

  @override
  String get mktUpToLabel => 'पर्यंत';

  @override
  String get mktTopTierHint => 'मागील टियरच्या वरील सर्व काही';

  @override
  String get mktDiscountLabel => 'सवलत';

  @override
  String get psetBasketTiers => 'बास्केट टियर';

  @override
  String get psetBasketTiersHint => 'मूल्यानुसार बास्केटवर स्वयं-सवलत';

  @override
  String mktYouSave(String amount, String pct) {
    return '₹$amount वाचवा ($pct% सवलत)';
  }

  @override
  String mktTierBasketLabel(String tier) {
    return '$tier बास्केट';
  }

  @override
  String mktPctOff(String pct) {
    return '$pct% सवलत';
  }

  @override
  String mktSaveAmount(String amount) {
    return '₹$amount वाचवा';
  }

  @override
  String mktRecomputeBody(int count) {
    return '$count विद्यमान बास्केट जुन्या टियरनुसार किंमत असलेले आहेत. त्यांनाही नवीन टियर लागू करायचे?';
  }

  @override
  String mktBasketsRecomputed(int count) {
    return '$count बास्केट अपडेट केले';
  }

  @override
  String mktAboveAmount(String amount) {
    return '₹$amount वर';
  }

  @override
  String mktRangeAmount(String from, String to) {
    return '₹$from – ₹$to';
  }

  @override
  String get mktSaveAsBasket => 'बास्केट म्हणून जतन करा';

  @override
  String mktBasketSavedFromCampaign(String name) {
    return '\"$name\" तुमच्या बास्केटमध्ये जतन केले';
  }

  @override
  String get mktSelectDate => 'तारीख निवडा';

  @override
  String get mktBasketsProTitle => 'बास्केट हे एक Pro वैशिष्ट्य आहे';

  @override
  String get mktBasketsProDesc =>
      'स्वयंचलित टियर सवलतींसह कॉम्बो डील तयार करा आणि ग्राहकांना WhatsApp वर सूचित करा. बास्केट अनलॉक करण्यासाठी Pro मध्ये अपग्रेड करा.';

  @override
  String get visionNavLabel => 'व्हिजन';

  @override
  String get visionTitle => 'व्हिजन';

  @override
  String get visionTabShelf => 'शेल्फ स्कॅन';

  @override
  String get visionTabResults => 'निकाल';

  @override
  String get visionTabCounter => 'काउंटर';

  @override
  String get visionProTitle => 'व्हिजन AI';

  @override
  String get visionProDesc =>
      'सकाळी आणि संध्याकाळी तुमच्या शेल्फचा फोटो काढा — AI तुमचा स्टॉक मोजेल आणि काय विकले गेले ते सांगेल.';

  @override
  String get visionFromCamera => 'फोटो काढा';

  @override
  String get visionFromGallery => 'गॅलरीमधून निवडा';

  @override
  String get visionMorningTitle => 'सकाळ — दिवसाची सुरुवात';

  @override
  String get visionEveningTitle => 'संध्याकाळ — दिवसाचा शेवट';

  @override
  String get visionTakePhoto => 'फोटो काढा';

  @override
  String get visionRetake => 'पुन्हा काढा';

  @override
  String get visionReview => 'पुनरावलोकन';

  @override
  String get visionAnalyzing =>
      'शेल्फचे विश्लेषण होत आहे… यास एक मिनिटापर्यंत वेळ लागू शकतो';

  @override
  String get visionScanFailed => 'स्कॅन अयशस्वी. कृपया पुन्हा फोटो काढा.';

  @override
  String get visionNoPhotoYet => 'अद्याप फोटो काढलेला नाही.';

  @override
  String get visionProductsIdentified => 'ओळखलेली उत्पादने';

  @override
  String get visionUnitsCounted => 'मोजलेली युनिट्स';

  @override
  String get visionNeedsReview => 'पुनरावलोकन आवश्यक';

  @override
  String get visionViewSales => 'आजची विक्री पहा';

  @override
  String get visionTip =>
      'टीप: दुकान उघडण्यापूर्वी सकाळचा आणि बंद करण्यापूर्वी संध्याकाळचा फोटो काढा. प्रत्येक उत्पादन किती विकले गेले हे AI मोजेल.';

  @override
  String get visionSalesEmpty =>
      'आज काय विकले गेले हे पाहण्यासाठी सकाळचा आणि संध्याकाळचा एक-एक फोटो काढा.';

  @override
  String get visionTotalSold => 'एकूण विकलेल्या वस्तू';

  @override
  String get visionSold => 'विकले';

  @override
  String get visionMorningCount => 'AM';

  @override
  String get visionEveningCount => 'PM';

  @override
  String get visionUnknownItem => 'अज्ञात — दुरुस्त करण्यासाठी टॅप करा';

  @override
  String get visionCorrected => 'दुरुस्त केले';

  @override
  String get visionCorrectTitle => 'हे कोणते उत्पादन आहे?';

  @override
  String get visionSearchProducts => 'तुमची उत्पादने शोधा';

  @override
  String get visionClearCorrection => 'दुरुस्ती काढून टाका';

  @override
  String get visionNoProducts =>
      'अद्याप उत्पादने लोड झालेली नाहीत. एकदा बिलिंग टॅब उघडा, मग परत या.';

  @override
  String get visionCounterSoonTitle => 'लाइव्ह काउंटर — लवकरच येत आहे';

  @override
  String get visionCounterSoonDesc =>
      'बिलिंग काउंटरकडे तुमचा फोन रोखा, वस्तू पुढे जात असतानाच विक्री आपोआप मोजली जाईल. आम्ही यावर अंतिम काम करत आहोत.';

  @override
  String get visionAddPhotosTitle => 'शेल्फचे फोटो जोडा';

  @override
  String get visionAddPhotosHint => 'तुमचे शेल्फ कव्हर करत 3 ते 10 फोटो काढा.';

  @override
  String get visionMinPhotosHint => 'किमान 3 फोटो जोडा';

  @override
  String get visionMaxReached => 'जास्तीत जास्त 10 फोटो';

  @override
  String get visionAnalyze => 'विश्लेषण करा';
}
