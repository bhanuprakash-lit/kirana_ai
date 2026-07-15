// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get languageName => 'తెలుగు';

  @override
  String get languageChooseTitle => 'మీ భాషను ఎంచుకోండి';

  @override
  String get languageChooseSubtitle =>
      'మీరు దీన్ని సెట్టింగ్‌లలో ఎప్పుడైనా మార్చుకోవచ్చు.';

  @override
  String get settingsLanguage => 'భాష';

  @override
  String get commonContinue => 'కొనసాగించు';

  @override
  String get commonServerError =>
      'సర్వర్‌కు కనెక్ట్ కాలేకపోయింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get commonSomethingWrong =>
      'ఏదో తప్పు జరిగింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrEnterPhone => 'మీ ఫోన్ నంబర్‌ను నమోదు చేయండి';

  @override
  String get authErrEnter6Otp => '6-అంకెల OTPని నమోదు చేయండి';

  @override
  String get authErrSessionExpired =>
      'సెషన్ గడువు ముగిసింది. మళ్లీ పంపుపై నొక్కండి.';

  @override
  String get authErrInvalidPhone =>
      'చెల్లని ఫోన్ నంబర్. దేశ కోడ్‌ను చేర్చండి (ఉదా. +91...).';

  @override
  String get authErrTooManyRequests =>
      'చాలా ప్రయత్నాలు. దయచేసి తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrWrongOtp =>
      'తప్పు OTP. దయచేసి సరిచూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrOtpExpired =>
      'OTP గడువు ముగిసింది. కొత్త కోడ్ కోసం మళ్లీ పంపుపై నొక్కండి.';

  @override
  String get authErrVerificationFailed =>
      'ధృవీకరణ విఫలమైంది. మళ్లీ ప్రయత్నించండి.';

  @override
  String get welcomeSlide1Title => 'Outlet AI కి\n\nస్వాగతం';

  @override
  String get welcomeSlide1Subtitle =>
      'మీ కిరాణా దుకాణాన్ని నిర్వహించడానికి మీ తెలివైన వ్యాపార భాగస్వామి — దక్షిణ భారతదేశం కోసం రూపొందించబడింది.';

  @override
  String get welcomeSlide2Title => 'స్మార్ట్ ఇన్వెంటరీ\n\nనిర్వహణ';

  @override
  String get welcomeSlide2Subtitle =>
      'స్టాక్ స్థాయిలను ట్రాక్ చేయండి, తక్కువ-స్టాక్ హెచ్చరికలను పొందండి, మీ బాగా అమ్ముడయ్యే ఉత్పత్తులు ఎప్పుడూ నిండుకోకుండా చూసుకోండి.';

  @override
  String get welcomeSlide3Title => 'మీ వ్యాపారాన్ని\n\nవృద్ధి చేసుకోండి';

  @override
  String get welcomeSlide3Subtitle =>
      'AI ఆధారిత అంతర్దృష్టులు, విక్రయ విశ్లేషణలు మరియు మీ దుకాణానికి వ్యక్తిగతీకరించిన చిట్కాలను పొందండి.';

  @override
  String get welcomeGetStarted => 'ప్రారంభించండి';

  @override
  String get welcomeHaveAccount => 'ఇప్పటికే ఖాతా ఉందా? ';

  @override
  String get welcomeSignIn => 'సైన్ ఇన్ చేయండి';

  @override
  String get loginWelcomeBack => 'తిరిగి స్వాగతం';

  @override
  String get loginSubtitle => 'మీ Outlet AI ఖాతాలోకి సైన్ ఇన్ చేయండి.';

  @override
  String get loginTabPhone => 'ఫోన్ OTP';

  @override
  String get loginTabUsername => 'యూజర్‌నేమ్';

  @override
  String get loginPhoneLabel => 'ఫోన్ నంబర్';

  @override
  String get loginSendOtp => 'OTP పంపండి';

  @override
  String get loginOtpHelp => 'ఈ నంబర్‌కు మేము ఒక OTP పంపుతాము';

  @override
  String loginOtpSentTo(String phone) {
    return '$phoneకి OTP పంపబడింది';
  }

  @override
  String get loginOtp6Label => '6-అంకెల OTP';

  @override
  String get loginVerifyOtp => 'OTP ధృవీకరించండి';

  @override
  String get loginResendOtp => 'OTP మళ్లీ పంపండి';

  @override
  String get loginUsernameLabel => 'యూజర్‌నేమ్';

  @override
  String get loginUsernameHint => 'ఉదా. mykiranastore';

  @override
  String get loginUsernameRequired => 'యూజర్‌నేమ్ అవసరం';

  @override
  String get loginPasswordLabel => 'పాస్‌వర్డ్';

  @override
  String get loginPasswordHint => 'మీ పాస్‌వర్డ్';

  @override
  String get loginPasswordRequired => 'పాస్‌వర్డ్ అవసరం';

  @override
  String get loginSignIn => 'సైన్ ఇన్ చేయండి';

  @override
  String get loginNoAccount => 'ఖాతా లేదా? ';

  @override
  String get loginCreateOne => 'ఒకటి సృష్టించండి';

  @override
  String get loginIncorrect =>
      'తప్పు యూజర్‌నేమ్ లేదా పాస్‌వర్డ్. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String loginFailed(String message) {
    return 'లాగిన్ విఫలమైంది: $message';
  }

  @override
  String onboardingStepCount(int step) {
    return '$step/4';
  }

  @override
  String get accountVerifyPhoneTitle => 'మీ ఫోన్ నంబర్‌ను\nధృవీకరించండి';

  @override
  String get accountVerifyPhoneSubtitle =>
      'మీ నంబర్‌ను నిర్ధారించడానికి మేము ఒక OTP పంపుతాము.';

  @override
  String get accountPhoneLabel => 'ఫోన్ నంబర్';

  @override
  String get accountSendOtp => 'OTP పంపండి';

  @override
  String get accountEnterOtpTitle => 'OTP నమోదు చేయండి';

  @override
  String get accountEnterOtpSubtitle => 'మీ ఫోన్‌కు 6-అంకెల కోడ్ పంపబడింది.';

  @override
  String accountOtpSentTo(String phone) {
    return '+91 $phoneకి OTP పంపబడింది';
  }

  @override
  String get accountOtp6Label => '6-అంకెల OTP';

  @override
  String get accountVerify => 'ధృవీకరించండి';

  @override
  String get accountResendOtp => 'OTP మళ్లీ పంపండి';

  @override
  String accountPhoneVerified(String phone) {
    return 'ఫోన్ ధృవీకరించబడింది: $phone';
  }

  @override
  String get accountChooseUsernameTitle => 'దుకాణ యూజర్‌నేమ్‌ను\nఎంచుకోండి';

  @override
  String get accountChooseUsernameSubtitle =>
      'మీ యూజర్‌నేమ్ మీ దుకాణానికి ప్రత్యేకమైనది మరియు లాగిన్ చేయడానికి ఉపయోగించబడుతుంది.';

  @override
  String get accountUsernameLabel => 'యూజర్‌నేమ్';

  @override
  String get accountUsernameHint => 'ఉదా. lohiyastore123';

  @override
  String get accountUsernameTaken => 'యూజర్‌నేమ్ ఇప్పటికే తీసుకోబడింది';

  @override
  String get accountUsernameRules =>
      'అక్షరాలు, సంఖ్యలు, అండర్‌స్కోర్‌లు మాత్రమే • కనిష్టం 3 అక్షరాలు';

  @override
  String get accountErrChooseUsername =>
      'మీ దుకాణానికి ప్రత్యేకమైన యూజర్‌నేమ్‌ను ఎంచుకోండి';

  @override
  String get accountErrUsernameMin3 => 'యూజర్‌నేమ్ కనీసం 3 అక్షరాలు ఉండాలి';

  @override
  String get accountErrUsernameMax30 =>
      'వినియోగదారు పేరు గరిష్టంగా 30 అక్షరాలు ఉండవచ్చు';

  @override
  String get accountErrUsernameChars =>
      'అక్షరాలు, సంఖ్యలు మరియు అండర్‌స్కోర్‌లు మాత్రమే అనుమతించబడతాయి';

  @override
  String get accountErrUsernameTakenTry =>
      'ఆ యూజర్‌నేమ్ తీసుకోబడింది. మరొకటి ప్రయత్నించండి.';

  @override
  String get accountUsernameAvailable => 'వినియోగదారు పేరు అందుబాటులో ఉంది';

  @override
  String get businessTitle => 'మీ దుకాణం గురించి\nమాకు చెప్పండి';

  @override
  String get businessSubtitle =>
      'మీ అనుభవాన్ని వ్యక్తిగతీకరించడంలో మాకు సహాయపడండి.';

  @override
  String get businessOwnerLabel => 'యజమాని పూర్తి పేరు';

  @override
  String get businessOwnerHint => 'ఉదా. రమేష్ కుమార్';

  @override
  String get businessOwnerRequired => 'పేరు అవసరం';

  @override
  String get businessStoreLabel => 'దుకాణం పేరు';

  @override
  String get businessStoreHint => 'ఉదా. శ్రీ లక్ష్మి స్టోర్స్';

  @override
  String get businessStoreRequired => 'దుకాణం పేరు అవసరం';

  @override
  String get businessEmailLabel => 'ఇమెయిల్ చిరునామా';

  @override
  String get businessEmailHint => 'you@example.com';

  @override
  String get businessEmailRequired => 'ఇమెయిల్ అవసరం';

  @override
  String get businessEmailInvalid =>
      'చెల్లుబాటు అయ్యే ఇమెయిల్ చిరునామాను నమోదు చేయండి';

  @override
  String get businessTypeLabel => 'వ్యాపార రకం';

  @override
  String get businessTypeHint => 'మీ దుకాణం రకాన్ని ఎంచుకోండి';

  @override
  String get businessTypeRequired => 'దయచేసి మీ వ్యాపార రకాన్ని ఎంచుకోండి';

  @override
  String get businessFootfallLabel => 'అంచనా రోజువారీ కస్టమర్లు';

  @override
  String get businessFootfallHint => 'ఉదా. 40';

  @override
  String get businessFootfallSuffix => 'కస్టమర్లు/రోజు';

  @override
  String get businessFootfallInvalid => 'చెల్లుబాటు అయ్యే సంఖ్యను నమోదు చేయండి';

  @override
  String get businessBudgetLabel => 'నెలవారీ విక్రయ లక్ష్యం (ఐచ్ఛికం)';

  @override
  String get businessBudgetHint => 'ఉదా. 150000';

  @override
  String get businessBudgetHelper =>
      'రోజువారీ పురోగతిని ట్రాక్ చేయడానికి ఉపయోగించబడుతుంది. మీరు దీన్ని తర్వాత మార్చుకోవచ్చు.';

  @override
  String get businessBudgetInvalid =>
      'చెల్లుబాటు అయ్యే మొత్తాన్ని నమోదు చేయండి';

  @override
  String get businessTypeKirana => 'కిరాణా / జనరల్ స్టోర్స్';

  @override
  String get businessTypeGeneral => 'జనరల్ స్టోర్';

  @override
  String get businessTypeProvision => 'ప్రొవిజన్ స్టోర్';

  @override
  String get businessTypeFruitsVeg => 'పండ్లు & కూరగాయలు';

  @override
  String get businessTypeStationery => 'స్టేషనరీ & పుస్తకాలు';

  @override
  String get businessTypeSupermarket => 'సూపర్‌మార్కెట్';

  @override
  String get businessTypeMiniSupermarket => 'మినీ సూపర్‌మార్కెట్';

  @override
  String get businessTypeMonoBrand => 'మోనో బ్రాండ్ స్టోర్';

  @override
  String get businessTypeBoutique => 'బొటిక్';

  @override
  String get businessTypeSalon => 'సెలూన్ & పార్లర్';

  @override
  String get businessTypeFancyGift => 'ఫ్యాన్సీ & గిఫ్ట్ స్టోర్';

  @override
  String get businessTypeSportsFitness => 'స్పోర్ట్స్ & ఫిట్‌నెస్';

  @override
  String get businessTypeFootwear => 'పాదరక్షల దుకాణం';

  @override
  String get businessTypeOptical => 'ఆప్టికల్ స్టోర్';

  @override
  String get businessTypeBakery => 'బేకరీ & స్వీట్ షాప్';

  @override
  String get businessTypeApparel => 'దుస్తులు & వస్త్రాలు';

  @override
  String get businessTypeElectronics => 'మొబైల్ & ఎలక్ట్రానిక్స్';

  @override
  String get businessTypeOthers => 'ఇతరాలు';

  @override
  String get locationTitle => 'మీ దుకాణం\nఎక్కడ ఉంది?';

  @override
  String get locationSubtitle =>
      'స్థానిక అంతర్దృష్టులను చూపించడానికి మరియు డెలివరీ జోన్‌లను ప్రారంభించడానికి మేము దీన్ని ఉపయోగిస్తాము.';

  @override
  String get locationDetecting => 'స్థానాన్ని గుర్తిస్తోంది…';

  @override
  String get locationDetect => 'నా స్థానాన్ని గుర్తించు';

  @override
  String get locationOrManual => 'లేదా మాన్యువల్‌గా నమోదు చేయండి';

  @override
  String get locationAddressLabel => 'దుకాణం చిరునామా';

  @override
  String get locationAddressHint => 'వీధి, ప్రాంతం, ల్యాండ్‌మార్క్…';

  @override
  String get locationCityLabel => 'నగరం / జిల్లా';

  @override
  String get locationCityHint => 'ఉదా. హైదరాబాద్';

  @override
  String get locationGettingCoords => 'కోఆర్డినేట్‌లను పొందుతోంది…';

  @override
  String get locationDetected => 'స్థానం గుర్తించబడింది';

  @override
  String get locationErrAddress =>
      'దయచేసి మీ దుకాణం చిరునామాను గుర్తించండి లేదా నమోదు చేయండి.';

  @override
  String get locationErrCity => 'దయచేసి మీ నగరం లేదా జిల్లాను నమోదు చేయండి.';

  @override
  String get locationPermDenied =>
      'స్థాన అనుమతి నిరాకరించబడింది. దయచేసి చిరునామాను మాన్యువల్‌గా నమోదు చేయండి.';

  @override
  String get locationDetectFailed =>
      'స్థానాన్ని గుర్తించలేకపోయింది. దయచేసి చిరునామాను మాన్యువల్‌గా నమోదు చేయండి.';

  @override
  String get consentTitle => 'దాదాపు పూర్తయింది!\nసమీక్షించి అంగీకరించండి';

  @override
  String get consentSubtitle =>
      'మీ సెటప్‌ను పూర్తి చేయడానికి దయచేసి కింది వాటిని చదివి అంగీకరించండి.';

  @override
  String get consentTermsTitle => 'నిబంధనలు & షరతులు';

  @override
  String get consentTermsSummary =>
      'Outlet AIని ఉపయోగించడం ద్వారా, మీరు ఈ సేవను చట్టబద్ధమైన వ్యాపార అవసరాల కోసం మాత్రమే ఉపయోగిస్తారని అంగీకరిస్తారు. ఈ నిబంధనలను ఉల్లంఘించే ఖాతాలను సస్పెండ్ చేసే హక్కు LohiyaAIకి ఉంది. మీ డేటా సేవను అందించడానికి మరియు మెరుగుపరచడానికి మాత్రమే ఉపయోగించబడుతుంది.';

  @override
  String get consentPrivacyTitle => 'గోప్యతా విధానం';

  @override
  String get consentPrivacySummary =>
      'మీ అనుభవాన్ని వ్యక్తిగతీకరించడానికి మేము మీ దుకాణ వివరాలు, స్థానం మరియు లావాదేవీ డేటాను సేకరిస్తాము. మేము మీ వ్యక్తిగత డేటాను థర్డ్-పార్టీలకు ఎప్పుడూ విక్రయించము. మొత్తం డేటా ఎన్‌క్రిప్ట్ చేయబడి మా క్లౌడ్ మౌలిక సదుపాయంలో సురక్షితంగా నిల్వ చేయబడుతుంది.';

  @override
  String get consentTermsCheckPrefix => 'నేను చదివి అంగీకరిస్తున్నాను: ';

  @override
  String get consentPrivacyCheckPrefix => 'నేను అంగీకరిస్తున్నాను: ';

  @override
  String get consentAcceptBoth =>
      'కొనసాగించడానికి దయచేసి రెండు ఒప్పందాలను అంగీకరించండి.';

  @override
  String get consentCompleteSetup => 'సెటప్ పూర్తి చేయండి';

  @override
  String get regErrPhoneExists =>
      'ఈ ఫోన్ నంబర్ ఇప్పటికే నమోదు చేయబడింది. దయచేసి బదులుగా సైన్ ఇన్ చేయండి.';

  @override
  String get regErrUsernameTaken =>
      'ఈ యూజర్‌నేమ్ ఇప్పటికే తీసుకోబడింది. దయచేసి మరొకటి ఎంచుకోండి.';

  @override
  String get regErrInvalidDetails =>
      'చెల్లని వివరాలు. దయచేసి మీ ఎంట్రీలను సరిచూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String regErrFailed(String message) {
    return 'నమోదు విఫలమైంది: $message';
  }

  @override
  String get dashNavHome => 'హోమ్';

  @override
  String get dashNavKhata => 'ఖాతా';

  @override
  String get dashNavBilling => 'బిల్లింగ్';

  @override
  String get dashTrialWelcome => 'Outlet AI కి స్వాగతం';

  @override
  String get dashTrialChoosePlan =>
      'ఉచితంగా ట్రయల్ చేయడానికి ఒక ప్లాన్ ఎంచుకోండి. మా టీం దాన్ని త్వరలో యాక్టివేట్ చేస్తుంది.';

  @override
  String get dashTrialSelectPlan => 'మీ ట్రయల్ ప్లాన్‌ను ఎంచుకోండి';

  @override
  String get dashTrialRequestPro => 'Pro ట్రయల్ అభ్యర్థించండి';

  @override
  String get dashTrialRequestBasic => 'Basic ట్రయల్ అభ్యర్థించండి';

  @override
  String get dashTrialRequestError =>
      'ఇప్పుడు మీ ట్రయల్ ప్రారంభించలేకపోయాము. దయచేసి మీ కనెక్షన్‌ను తనిఖీ చేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get dashTrialSignInDifferent => 'వేరే ఖాతాలోకి సైన్ ఇన్ చేయండి';

  @override
  String get dashPlanBadgeAllFeatures => 'అన్ని ఫీచర్లు';

  @override
  String get dashPlanBasicName => 'Basic ప్లాన్';

  @override
  String get dashPlanProName => 'Pro ప్లాన్';

  @override
  String get dashFeatPos => 'POS & విక్రయ నిర్వహణ';

  @override
  String get dashFeatInventoryTracking => 'ఇన్వెంటరీ ట్రాకింగ్';

  @override
  String get dashFeatFinanceUdhaar => 'ఫైనాన్స్ & ఉధార్';

  @override
  String get dashFeatKpiInsights => 'KPI అంతర్దృష్టులు (ఒక్కో కేటగిరీకి 3)';

  @override
  String get dashFeatAiReco => 'AI సిఫార్సులు';

  @override
  String get dashFeatEverythingBasic => 'Basicలోని అన్నీ';

  @override
  String get dashFeatAllKpi => 'అన్ని KPI కేటగిరీలు (అపరిమితం)';

  @override
  String get dashFeatVendorProcurement => 'వెండర్ & ప్రొక్యూర్‌మెంట్ నిర్వహణ';

  @override
  String get dashFeatCashflowSupport => 'క్యాష్‌ఫ్లో సపోర్ట్ (₹10L వరకు)';

  @override
  String get dashFeatCustomerGrowth => 'కస్టమర్ గ్రోత్ ఇంజిన్';

  @override
  String get dashPendingTitle => 'ట్రయల్ అభ్యర్థన అందింది!';

  @override
  String get dashPendingBody =>
      'మీ ట్రయల్ యాక్టివేషన్‌ను మా టీం సమీక్షిస్తోంది. ఆమోదం పొందిన వెంటనే మీ పరికరానికి నోటిఫికేషన్ వస్తుంది — సాధారణంగా కొన్ని గంటల్లో.';

  @override
  String get dashPendingNotifNote =>
      'యాక్టివేషన్ హెచ్చరికను మిస్ కాకుండా నోటిఫికేషన్‌లు ఎనేబుల్ అయ్యేలా చూసుకోండి.';

  @override
  String get dashPendingCheckStatus => 'స్థితిని తనిఖీ చేయండి';

  @override
  String get dashUpgradeTitle => 'ఉచిత ట్రయల్ ముగిసింది';

  @override
  String get dashUpgradeBody =>
      'మీ ఉచిత ట్రయల్ ముగిసింది. Outlet AIని వాడటం కొనసాగించడానికి మరియు మీ దుకాణాన్ని వృద్ధి చేయడానికి ఒక ప్లాన్ ఎంచుకోండి.';

  @override
  String get dashUpgradeBasic => 'Basic';

  @override
  String get dashUpgradePro => 'Pro';

  @override
  String get dashUpgradeBadgeBest => 'బెస్ట్';

  @override
  String dashUpgradeJustPerDay(String price) {
    return 'కేవలం $price';
  }

  @override
  String get dashUpgradeAlreadySubscribed =>
      'ఇప్పటికే సబ్‌స్క్రయిబ్ చేశారా? రిఫ్రెష్ చేయండి';

  @override
  String get dashFeatPosInventory => 'POS & ఇన్వెంటరీ';

  @override
  String get dashFeatFinanceKpis => 'ఫైనాన్స్ & KPIలు';

  @override
  String get dashFeatVendorManagement => 'వెండర్ నిర్వహణ';

  @override
  String get dashFeatCashflowReferrals => 'క్యాష్‌ఫ్లో + రెఫరల్స్';

  @override
  String get dashNewSale => 'కొత్త అమ్మకం';

  @override
  String get dashGreetingMorning => 'శుభోదయం';

  @override
  String get dashGreetingAfternoon => 'శుభ మధ్యాహ్నం';

  @override
  String get dashGreetingEvening => 'శుభ సాయంత్రం';

  @override
  String dashGreetingWithName(String greeting, String name) {
    return '$greeting, \n$name';
  }

  @override
  String get dashMorningBriefing => 'మార్నింగ్ బ్రీఫింగ్';

  @override
  String dashBriefingBody(int risk, int reorder) {
    return 'ఈరోజు మీకు $risk SKUలు క్రిటికల్ రిస్క్‌లో ఉన్నాయి, $reorder ఐటెమ్‌లను రీఆర్డర్ చేయాలి. సరిచేయడానికి నొక్కండి.';
  }

  @override
  String get dashIntelligence => 'ఇంటెలిజెన్స్';

  @override
  String get dashMetricStockoutLabel => 'స్టాకౌట్ రిస్క్';

  @override
  String get dashMetricStockoutSub => 'SKUలు క్రిటికల్';

  @override
  String get dashMetricReorderLabel => 'ఇప్పుడే రీఆర్డర్';

  @override
  String get dashMetricReorderSub => 'తక్కువ స్టాక్ SKUలు';

  @override
  String get dashMetricFastLabel => 'ఫాస్ట్ మూవింగ్';

  @override
  String get dashMetricFastSub => 'టాప్ సెల్లర్స్';

  @override
  String get dashMetricProfitLabel => 'ప్రాఫిట్ పిక్స్';

  @override
  String get dashMetricProfitSub => 'అవకాశాలు';

  @override
  String get dashMetricCustomerLabel => 'కస్టమర్ బకాయిలు';

  @override
  String get dashMetricCustomerSub => 'పెండింగ్ ఖాతా';

  @override
  String get dashMetricSalesLabel => 'అమ్మిన ఐటెమ్‌లు';

  @override
  String get dashMetricSalesSub => 'ఈరోజు ఇప్పటివరకు';

  @override
  String get dashTodaysPerformance => 'ఈరోజు పనితీరు';

  @override
  String get dashPosNotAvailable => 'POS డేటా అందుబాటులో లేదు';

  @override
  String get dashStatRevenue => 'ఆదాయం';

  @override
  String get dashStatOrders => 'బిల్లులు';

  @override
  String get dashStatAvgOrder => 'సగటు బిల్లు';

  @override
  String get dashStoreOverview => 'దుకాణం ఓవర్‌వ్యూ';

  @override
  String get dashStoreSkus => 'SKUలు';

  @override
  String get dashStoreFootfall => 'రోజువారీ ఫుట్‌ఫాల్';

  @override
  String get dashStoreDailyBudget => 'రోజువారీ సరుకు ఖర్చు';

  @override
  String dashKpiPeriod(int days) {
    return 'గత $days రోజులు';
  }

  @override
  String get dashCouldNotLoad => 'డేటాను లోడ్ చేయలేకపోయింది';

  @override
  String get dashRetry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get dashAlerts => 'హెచ్చరికలు';

  @override
  String get dashSeeAll => 'అన్నీ చూడండి';

  @override
  String get dashStoreKpis => 'దుకాణం KPIలు';

  @override
  String dashKpiCoverageTooltip(String pct) {
    return 'అమ్మకాల్లో $pct% ఆధారంగా — కొన్ని ఐటెమ్‌లకు కాస్ట్ డేటా లేదు';
  }

  @override
  String get dashDetailStockout => 'స్టాకౌట్ రిస్క్';

  @override
  String get dashDetailReorder => 'రీఆర్డర్ అవసరం';

  @override
  String get dashDetailFastMoving => 'ఫాస్ట్ మూవింగ్ ఐటెమ్‌లు';

  @override
  String get dashDetailProfit => 'హై ప్రాఫిట్ ఐటెమ్‌లు';

  @override
  String get dashDetailDefault => 'ఇంటెలిజెన్స్ వివరాలు';

  @override
  String get dashSearchProducts => 'ఉత్పత్తులను వెతకండి...';

  @override
  String get dashSortBy => 'దీని ద్వారా క్రమబద్ధీకరించు:';

  @override
  String get dashSortProfit => 'లాభం';

  @override
  String get dashSortDemand => 'డిమాండ్';

  @override
  String get dashSortRisk => 'రిస్క్';

  @override
  String dashStockLabel(String qty) {
    return 'స్టాక్: $qty';
  }

  @override
  String get dashStockRunway => 'స్టాక్ రన్‌వే';

  @override
  String get dashOutOfStock => 'స్టాక్ అయిపోయింది';

  @override
  String dashDaysLeft(String days) {
    return '~$days రోజులు మిగిలాయి';
  }

  @override
  String get dashStatStockoutRisk => 'స్టాకౌట్ రిస్క్';

  @override
  String get dashStatReorderQty => 'రీఆర్డర్ పరిమాణం';

  @override
  String dashUnitsValue(String qty) {
    return '$qty యూనిట్లు';
  }

  @override
  String dashWeeklyProfitImpact(String amount) {
    return '₹$amount అంచనా వారపు లాభ ప్రభావం';
  }

  @override
  String dashCreatePurchaseOrder(String qty) {
    return 'పర్చేస్ ఆర్డర్ సృష్టించండి · $qty యూనిట్లు';
  }

  @override
  String get dashNoItemsFound => 'ఐటెమ్‌లు కనుగొనబడలేదు';

  @override
  String dashNoResultsFor(String query) {
    return '\"$query\" కోసం ఫలితాలు లేవు';
  }

  @override
  String get dashClearSearch => 'శోధనను క్లియర్ చేయండి';

  @override
  String get dashConnectionError => 'కనెక్షన్ ఎర్రర్';

  @override
  String get posCommonCancel => 'రద్దు చేయి';

  @override
  String get posCommonClear => 'క్లియర్';

  @override
  String get posCommonRefresh => 'రిఫ్రెష్';

  @override
  String get posCommonAddToCart => 'కార్ట్‌కి జోడించు';

  @override
  String get posCameraPermissionRequired =>
      'బార్‌కోడ్‌లను స్కాన్ చేయడానికి కెమెరా అనుమతి అవసరం.';

  @override
  String get posCommonSettings => 'సెట్టింగ్స్';

  @override
  String posEnterQtyTitle(String unit) {
    return '$unit నమోదు చేయండి';
  }

  @override
  String get posQtyFallback => 'క్వాంటిటీ';

  @override
  String get posSelectVariant => 'వేరియంట్ ఎంచుకోండి';

  @override
  String posInclGst(String amount) {
    return 'GST తో $amount';
  }

  @override
  String get posOutOfStock => 'స్టాక్ లేదు';

  @override
  String posVariantStockLine(String stock) {
    return '$stock స్టాక్‌లో';
  }

  @override
  String posPriceLabel(String price) {
    return 'ధర: $price';
  }

  @override
  String get posWeightMeasurement => 'బరువు / కొలత';

  @override
  String get posUnknownBarcodeTitle => 'తెలియని బార్‌కోడ్';

  @override
  String posUnknownBarcodeBody(String barcode) {
    return 'బార్‌కోడ్ \"$barcode\" మీ ఇన్వెంటరీలో లేదు. మీరు ఏం చేయాలనుకుంటున్నారు?';
  }

  @override
  String get posAddAsNew => 'కొత్తగా జోడించు';

  @override
  String get posLinkToExisting => 'ఉన్న ఐటెమ్‌కి లింక్ చేయి';

  @override
  String posErrLoadingInventory(String error) {
    return 'ఇన్వెంటరీ లోడ్ చేయడంలో ఎర్రర్: $error';
  }

  @override
  String posLinkBarcodeTitle(String barcode) {
    return 'బార్‌కోడ్ \"$barcode\" లింక్ చేయి';
  }

  @override
  String get posNoUnbarcodedItems => 'బార్‌కోడ్ లేని ఐటెమ్‌లు కనుగొనబడలేదు.';

  @override
  String posCategoryLabel(String category) {
    return 'కేటగిరీ: $category';
  }

  @override
  String get posCategoryGeneral => 'జనరల్';

  @override
  String posLinkedToItem(String barcode, String name) {
    return '$barcodeని $nameకి లింక్ చేశారు';
  }

  @override
  String get posScanReferralQr => 'రెఫరల్ QR స్కాన్ చేయి';

  @override
  String posCampaignOutOfStock(String name) {
    return '\"$name\"లోని అన్ని ఐటెమ్‌లు స్టాక్‌లో లేవు';
  }

  @override
  String posCampaignItemsAdded(int count, String name) {
    return '\"$name\" నుండి $count ఐటెమ్‌లు జోడించబడ్డాయి';
  }

  @override
  String posAddedSkipped(int added, int skipped) {
    return '$added జోడించబడ్డాయి · $skipped స్కిప్ చేయబడ్డాయి (స్టాక్ లేదు)';
  }

  @override
  String posBasketAddedAtPrice(String name, String price) {
    return 'బండిల్ \"$name\" ₹$priceకి జోడించబడింది';
  }

  @override
  String posItemsRegularPrice(int count) {
    return '$count ఐటెమ్‌లు సాధారణ ధరకు జోడించబడ్డాయి (బండిల్‌కి అన్ని ఐటెమ్‌లు స్టాక్‌లో ఉండాలి)';
  }

  @override
  String posBasketItemsAdded(int count, String name) {
    return '\"$name\" నుండి $count ఐటెమ్‌లు జోడించబడ్డాయి';
  }

  @override
  String posItemsAddedToCart(int count) {
    return '$count ఐటెమ్‌లు కార్ట్‌కి జోడించబడ్డాయి';
  }

  @override
  String get posSelectCustomer => 'కస్టమర్‌ని ఎంచుకోండి';

  @override
  String get posNew => 'కొత్త';

  @override
  String get posSearchNameOrPhone => 'పేరు లేదా ఫోన్‌తో వెతకండి...';

  @override
  String get posNoCustomersFound => 'కస్టమర్లు కనుగొనబడలేదు.';

  @override
  String get posAddNewCustomer => 'కొత్త కస్టమర్‌ని జోడించు';

  @override
  String get posSelectFromContacts => 'కాంటాక్ట్స్ నుండి ఎంచుకోండి';

  @override
  String get posCustomerName => 'కస్టమర్ పేరు';

  @override
  String get posPhoneNumber => 'ఫోన్ నంబర్';

  @override
  String get posSaveAndSelect => 'సేవ్ చేసి ఎంచుకో';

  @override
  String get posSearchProducts => 'ప్రొడక్ట్‌లను వెతకండి…';

  @override
  String get posReferralScan => 'రెఫరల్ స్కాన్';

  @override
  String get posOrderHistory => 'ఆర్డర్ హిస్టరీ';

  @override
  String get posRefreshingProducts => 'ప్రొడక్ట్‌లను రిఫ్రెష్ చేస్తోంది...';

  @override
  String posRefreshFailed(String error) {
    return 'రిఫ్రెష్ విఫలమైంది: $error';
  }

  @override
  String posProductsRefreshed(int count) {
    return 'ప్రొడక్ట్‌లు రిఫ్రెష్ అయ్యాయి ($count ఐటెమ్‌లు)';
  }

  @override
  String posItemsInCart(int count) {
    return 'కార్ట్‌లో $count ఐటెమ్‌లు';
  }

  @override
  String get posClearCartTitle => 'కార్ట్ క్లియర్ చేయాలా?';

  @override
  String get posClearCartBody => 'అన్ని ఐటెమ్‌లు కార్ట్ నుండి తొలగించబడతాయి.';

  @override
  String get posFrequentlyBought => 'తరచుగా కలిసి కొనేవి';

  @override
  String get posNoProductsFound => 'ప్రొడక్ట్‌లు కనుగొనబడలేదు';

  @override
  String posStockColon(String stock) {
    return 'స్టాక్: $stock';
  }

  @override
  String get posOffline => 'POS ఆఫ్‌లైన్';

  @override
  String get posCouldNotConnect => 'POSకి కనెక్ట్ కాలేకపోయింది.';

  @override
  String get posBundlesAndDeals => 'బండిల్స్ & డీల్స్';

  @override
  String get posRefreshAi => 'AI రిఫ్రెష్';

  @override
  String posItemsInBundle(int count) {
    return 'బండిల్‌లో $count ఐటెమ్‌లు';
  }

  @override
  String get posBundlePrice => 'బండిల్ ధర';

  @override
  String get posItemFallback => 'ఐటెమ్';

  @override
  String posValidUntil(String date) {
    return '$date వరకు చెల్లుతుంది';
  }

  @override
  String posStockUnitPrice(String stock, String unit, String price) {
    return 'స్టాక్: $stock $unit  ·  ₹$price';
  }

  @override
  String get posNotInStock => 'స్టాక్‌లో లేదు';

  @override
  String get posBundlePriceLabel => 'బండిల్ ధర';

  @override
  String get posAddAvailableToCart =>
      'అందుబాటులో ఉన్న ఐటెమ్‌లను కార్ట్‌కి జోడించు';

  @override
  String posVoiceCount(int remaining, int total) {
    return 'వాయిస్ ($remaining/$total)';
  }

  @override
  String get posVoiceOrder => 'వాయిస్ ఆర్డర్';

  @override
  String posHandwriteCount(int remaining, int total) {
    return 'హ్యాండ్‌రైట్ ($remaining/$total)';
  }

  @override
  String get posHandwrite => 'హ్యాండ్‌రైట్';

  @override
  String get posCartEmpty => 'కార్ట్ ఖాళీగా ఉంది';

  @override
  String get posCartEmptyHint =>
      'అమ్మకం మొదలుపెట్టడానికి ప్రొడక్ట్ వెతకండి లేదా బార్‌కోడ్ స్కాన్ చేయండి.';

  @override
  String get posAddCustomer => 'కస్టమర్‌ని జోడించు';

  @override
  String posItemCount(String count) {
    return '$count ఐటెమ్‌లు';
  }

  @override
  String posPlaceOrderAmount(String amount) {
    return 'ఆర్డర్ చేయి · $amount';
  }

  @override
  String get posPosInventory => 'POS / ఇన్వెంటరీ';

  @override
  String get posOnline => 'POS ఆన్‌లైన్';

  @override
  String get posTabSales => 'అమ్మకాలు';

  @override
  String get posTabStock => 'స్టాక్';

  @override
  String get posTabPurchase => 'కొనుగోలు';

  @override
  String get posPurchaseSuppliers => 'కొనుగోలు & సప్లయర్‌లు';

  @override
  String get posPurchaseSuppliersDesc =>
      'పర్చేస్ ఆర్డర్‌లు సృష్టించండి, మీ సప్లయర్‌లను నిర్వహించండి, వారికి ఎంత బాకీ ఉందో ట్రాక్ చేయండి — అన్నీ ఒకే చోట.';

  @override
  String get posPaywallPurchaseDesc =>
      'పర్చేస్ ఆర్డర్‌లు, సప్లయర్‌లను నిర్వహించండి. డిస్ట్రిబ్యూటర్‌లకు చెల్లింపులను ట్రాక్ చేయండి. Pro ప్లాన్‌లో అందుబాటులో ఉంది.';

  @override
  String get posPrinterSetup => 'ప్రింటర్ సెటప్';

  @override
  String get posReconnect => 'మళ్లీ కనెక్ట్ చేయి';

  @override
  String get posForgetPrinter => 'ఈ ప్రింటర్‌ను మర్చిపో';

  @override
  String get posPairedDevices => 'పెయిర్ చేసిన Bluetooth డివైజ్‌లు';

  @override
  String get posNoPairedDevices => 'పెయిర్ చేసిన డివైజ్‌లు కనుగొనబడలేదు';

  @override
  String get posPairDeviceHint =>
      'ముందుగా మీ థర్మల్ ప్రింటర్‌ను Android\nBluetooth సెట్టింగ్‌లలో పెయిర్ చేయండి, తర్వాత రిఫ్రెష్ చేయండి.';

  @override
  String get posProOnly => 'PRO మాత్రమే';

  @override
  String get posUpgradeToProDay =>
      'Proకి అప్‌గ్రేడ్ చేయండి  ₹500/నెల · రోజుకి ₹17 మాత్రమే';

  @override
  String get posReceiptSent => 'రసీదు ప్రింటర్‌కి పంపబడింది';

  @override
  String get posPrintFailedCheck => 'ప్రింట్ విఫలమైంది — ప్రింటర్ చెక్ చేయండి';

  @override
  String get posOrderPlaced => 'ఆర్డర్ చేయబడింది!';

  @override
  String posOrderNumber(String id) {
    return 'ఆర్డర్ #$id';
  }

  @override
  String get posPrintReceipt => 'రసీదు ప్రింట్ చేయి';

  @override
  String get posNewSale => 'కొత్త అమ్మకం';

  @override
  String get posViewOrderDetails => 'ఆర్డర్ వివరాలు చూడండి';

  @override
  String get posSelectCustomerForUdhaar =>
      'ఉధార్ అమ్మకానికి కస్టమర్‌ని ఎంచుకోండి';

  @override
  String get posConfirmOrder => 'ఆర్డర్ నిర్ధారించండి';

  @override
  String get posOrderConfirmed => 'ఆర్డర్ నిర్ధారించబడింది!';

  @override
  String get posSubtotal => 'సబ్‌టోటల్';

  @override
  String posReferralDiscount(String pct, String referrer) {
    return 'రెఫరల్ డిస్కౌంట్ ($pct%)$referrer';
  }

  @override
  String get posGrandTotal => 'గ్రాండ్ టోటల్';

  @override
  String get posPaymentMethod => 'చెల్లింపు పద్ధతి';

  @override
  String get posPayCash => 'క్యాష్';

  @override
  String get posPayUdhaar => 'ఉధార్';

  @override
  String get posUdhaarDueDate => 'చెల్లింపు గడువు';

  @override
  String get posUdhaarDueDateHint => 'కస్టమర్ ఎప్పుడు చెల్లిస్తారు?';

  @override
  String posBundlePercentOff(int pct) {
    return '$pct% తగ్గింపు';
  }

  @override
  String posBundleYouSave(String amount) {
    return '$amount ఆదా';
  }

  @override
  String get posBundleRegularPrice =>
      'సాధారణ ధరకు చేర్చబడింది (బండిల్‌కు అన్ని వస్తువులు స్టాక్‌లో ఉండాలి)';

  @override
  String get posPayUpi => 'UPI';

  @override
  String get posComingSoon => 'త్వరలో వస్తోంది';

  @override
  String get posSelectCustomerRequired =>
      'కస్టమర్‌ని ఎంచుకోండి (ఉధార్‌కి తప్పనిసరి)';

  @override
  String get posSelectCustomerForUdhaarTitle =>
      'ఉధార్ కోసం కస్టమర్‌ని ఎంచుకోండి';

  @override
  String get posSearchNameOrPhoneHint => 'పేరు లేదా ఫోన్‌తో వెతకండి…';

  @override
  String get posPrintAutomatically => 'రసీదు ఆటోమేటిక్‌గా ప్రింట్ చేయి';

  @override
  String get posWillPrintAfter => 'ఆర్డర్ చేసిన తర్వాత ప్రింట్ అవుతుంది';

  @override
  String posPrinterStatus(String status) {
    return 'ప్రింటర్: $status';
  }

  @override
  String get posAutoPrintDisabled =>
      'ఆఫ్ చేయబడింది — ఆర్డర్ వివరాల నుండి మాన్యువల్‌గా ప్రింట్ చేయండి';

  @override
  String get posConnectPrinterToEnable =>
      'దీన్ని ఆన్ చేయడానికి బ్లూటూత్ ప్రింటర్‌ను కనెక్ట్ చేయండి';

  @override
  String get posCustomDiscount => 'డిస్కౌంట్ (మొత్తం బిల్లుపై)';

  @override
  String get vcopyServicesAddTitle => 'ఐటమ్ జోడించండి';

  @override
  String get visionComingSoonTitle => 'విజన్ AI మీ దుకాణానికి వస్తోంది';

  @override
  String get dashForYourStore => 'మీ దుకాణం కోసం';

  @override
  String get profGstRegistered => 'GST రిజిస్టర్డ్';

  @override
  String get profGstRegisteredHint => 'ఈ దుకాణానికి GST రిపోర్ట్ చూపించండి';

  @override
  String get posBarScan => 'స్కాన్';

  @override
  String get navAppointments => 'బుకింగ్స్';

  @override
  String get posServiceChip => 'సేవ';

  @override
  String get navRepairs => 'రిపేర్లు';

  @override
  String get navOrders => 'ఆర్డర్లు';

  @override
  String get posBarVoice => 'వాయిస్';

  @override
  String get posBarWrite => 'రాయండి';

  @override
  String get posBarAppointments => 'అపాయింట్‌మెంట్లు';

  @override
  String get posBarPrescription => 'ప్రిస్క్రిప్షన్';

  @override
  String get qaCustomers => 'కస్టమర్లు';

  @override
  String get qaBookAppointment => 'అపాయింట్‌మెంట్ బుక్ చేయండి';

  @override
  String get qaMemberships => 'మెంబర్‌షిప్‌లు';

  @override
  String get qaNewJobCard => 'కొత్త జాబ్ కార్డ్';

  @override
  String get qaCheckWarranty => 'వారంటీ చూడండి';

  @override
  String get qaNewEstimate => 'కొత్త ఎస్టిమేట్';

  @override
  String get qaReturns => 'రిటర్న్స్';

  @override
  String get qaAddProduct => 'ఐటమ్ జోడించండి';

  @override
  String get qaAddUdhaar => 'ఉధార్ జోడించండి';

  @override
  String get qaScanShelves => 'షెల్ఫ్ స్కాన్ చేయండి';

  @override
  String get visionComingSoonBody =>
      'విజన్ AI ఫోటో నుండి షెల్ఫ్‌లను చదువుతుంది — ప్రస్తుతం ఇది కిరాణా వస్తువులను గుర్తిస్తుంది, మీ దుకాణ ఉత్పత్తుల కోసం శిక్షణ జరుగుతోంది. మీ వస్తువులకు మద్దతు రాగానే స్కానింగ్, అప్‌లోడ్‌లు, కౌంటర్ కెమెరా ఇక్కడ ఆటోమేటిక్‌గా ఆన్ అవుతాయి.';

  @override
  String get visionComingSoonBadge => 'మీ వస్తువుల కోసం త్వరలో';

  @override
  String get vcopyServicesSearchHint => 'ఐటమ్స్ వెతకండి…';

  @override
  String get vcopyServicesEmptyTitle => 'ఇంకా రిటైల్ ఐటమ్స్ లేవు';

  @override
  String get vcopyServicesEmptyHint =>
      'కౌంటర్ వద్ద అమ్మే వస్తువులను జోడించండి (షాంపూ, సప్లిమెంట్స్). మీ సేవలు సర్వీసెస్ & అపాయింట్‌మెంట్స్‌లో నిర్వహించబడతాయి.';

  @override
  String get vcopyServicesInvTab => 'ఐటమ్స్';

  @override
  String get vcopyElectronicsAddTitle => 'పరికరం లేదా యాక్సెసరీ జోడించండి';

  @override
  String get vcopyElectronicsSearchHint =>
      'పేరు, మోడల్ లేదా బార్‌కోడ్‌తో వెతకండి…';

  @override
  String get vcopyElectronicsEmptyTitle => 'ఇంకా స్టాక్ లేదు';

  @override
  String get vcopyElectronicsEmptyHint =>
      'మీ ఫోన్లు, యాక్సెసరీలు, ఉపకరణాలను జోడించండి — మోడల్ వేరియంట్లు, IMEI/సీరియల్, వారంటీతో.';

  @override
  String get vcopyElectronicsInvTab => 'స్టాక్';

  @override
  String get vcopyApparelAddTitle => 'వస్తువు జోడించండి';

  @override
  String get vcopyApparelSearchHint => 'వస్తువులు వెతకండి (పేరు, సైజ్, రంగు)…';

  @override
  String get vcopyApparelEmptyTitle => 'ఇంకా వస్తువులు లేవు';

  @override
  String get vcopyApparelEmptyHint =>
      'సైజ్ మరియు రంగు వేరియంట్లతో మీ వస్తువులను జోడించండి — ప్రతి సైజ్/రంగుకు దాని సొంత స్టాక్ ఉంటుంది.';

  @override
  String get vcopyApparelInvTab => 'వస్తువులు';

  @override
  String get vcopyOpticalAddTitle => 'ఫ్రేమ్/లెన్స్ జోడించండి';

  @override
  String get vcopyOpticalSearchHint =>
      'ఫ్రేమ్స్, లెన్స్‌లు, సొల్యూషన్స్ వెతకండి…';

  @override
  String get vcopyOpticalEmptyTitle => 'ఇంకా ఫ్రేమ్స్ లేదా లెన్స్‌లు లేవు';

  @override
  String get vcopyOpticalEmptyHint =>
      'ఫ్రేమ్స్, లెన్స్‌లు, సొల్యూషన్స్ జోడించండి — అవసరమైన చోట వేరియంట్లు, వారంటీతో.';

  @override
  String get vcopyOpticalInvTab => 'స్టాక్';

  @override
  String get vcopyGeneralAddTitle => 'ఐటమ్ జోడించండి';

  @override
  String get vcopyGeneralSearchHint => 'ఐటమ్స్ వెతకండి…';

  @override
  String get vcopyGeneralEmptyTitle => 'ఇంకా ఐటమ్స్ లేవు';

  @override
  String get vcopyGeneralEmptyHint =>
      'బిల్లింగ్ ప్రారంభించడానికి మీరు అమ్మే వస్తువులను జోడించండి.';

  @override
  String get vcopyGeneralInvTab => 'ఐటమ్స్';

  @override
  String get procPayFirst => 'ముందుగా చెల్లించండి';

  @override
  String get procUnpaid => 'బకాయి';

  @override
  String get procNextDue => 'తదుపరి గడువు';

  @override
  String get procProductsSupplied => 'వీరు సరఫరా చేసే వస్తువులు';

  @override
  String get procTagProduct => 'వస్తువును ట్యాగ్ చేయండి';

  @override
  String get procNoTaggedProducts =>
      'ఇంకా వస్తువులు ట్యాగ్ చేయలేదు. వీరి నుండి కొనే వస్తువులను ట్యాగ్ చేయండి — పర్చేజ్ ఆర్డర్ స్వీకరించినప్పుడు ఇది ఆటోమేటిక్‌గా కూడా నింపబడుతుంది.';

  @override
  String get posHowMuchUdhaar => 'ఎంత ఉధార్‌కి వెళ్తుంది?';

  @override
  String get posCashNow => 'ఇప్పుడు క్యాష్';

  @override
  String get posOnUdhaar => 'ఉధార్‌లో';

  @override
  String get posPrintFailedCheckConnection =>
      'ప్రింట్ విఫలమైంది — ప్రింటర్ కనెక్షన్ చెక్ చేయండి';

  @override
  String get posTodaysOrders => 'నేటి ఆర్డర్‌లు';

  @override
  String posTransactionsSoFar(int count) {
    return 'ఇప్పటివరకు $count లావాదేవీలు';
  }

  @override
  String get posViewAll => 'అన్నీ చూడండి';

  @override
  String get posNoOrdersToday => 'ఈరోజు ఇంకా ఆర్డర్‌లు లేవు';

  @override
  String get posSalesAppearHere => 'అమ్మకాల లావాదేవీలు ఇక్కడ కనిపిస్తాయి';

  @override
  String posOrderMeta(String time, String payment, String status) {
    return '$time · $payment · $status';
  }

  @override
  String get posPrint => 'ప్రింట్';

  @override
  String get posScanBarcode => 'బార్‌కోడ్ స్కాన్ చేయి';

  @override
  String get posAlignBarcode => 'బార్‌కోడ్‌ను ఫ్రేమ్‌లో ఉంచండి';

  @override
  String get posLookingUp => 'వెతుకుతోంది…';

  @override
  String posAlreadyInList(String name) {
    return '$name ఇప్పటికే లిస్ట్‌లో ఉంది';
  }

  @override
  String posItemQty(String name, int qty) {
    return '$name ×$qty';
  }

  @override
  String posItemAdded(String name) {
    return '$name జోడించబడింది';
  }

  @override
  String get posNotFoundTapAdd =>
      'కనుగొనబడలేదు — మాన్యువల్‌గా జోడించడానికి ట్యాప్ చేయండి';

  @override
  String posItemsScanned(int count) {
    return '$count ఐటెమ్‌లు స్కాన్ చేయబడ్డాయి';
  }

  @override
  String get posScanItems => 'ఐటెమ్‌లను స్కాన్ చేయండి';

  @override
  String get posClearAll => 'అన్నీ క్లియర్ చేయి';

  @override
  String posLookingUpItems(int count) {
    return '$count ఐటెమ్‌లను వెతుకుతోంది…';
  }

  @override
  String posAddItemsToCart(int count, String total) {
    return '$count ఐటెమ్‌లను కార్ట్‌కి జోడించు  ·  ₹$total';
  }

  @override
  String get posPointCamera => 'కెమెరాను బార్‌కోడ్ వైపు ఉంచండి';

  @override
  String get posItemsAppearHere =>
      'మీరు స్కాన్ చేస్తుండగా ఐటెమ్‌లు ఇక్కడ కనిపిస్తాయి';

  @override
  String get posTransactionHistory => 'లావాదేవీల హిస్టరీ';

  @override
  String get posFilters => 'ఫిల్టర్‌లు:';

  @override
  String get posClearAllFilters => 'అన్నీ క్లియర్ చేయి';

  @override
  String get posNoTransactions => 'లావాదేవీలు కనుగొనబడలేదు';

  @override
  String get posTryAdjustFilters => 'మీ ఫిల్టర్‌లను సర్దుబాటు చేసి చూడండి';

  @override
  String get posResetFilters => 'ఫిల్టర్‌లను రీసెట్ చేయి';

  @override
  String get posFilterTransactions => 'లావాదేవీలను ఫిల్టర్ చేయి';

  @override
  String get posPaymentStatus => 'చెల్లింపు స్థితి';

  @override
  String get posFilterAll => 'అన్నీ';

  @override
  String get posStatusCompleted => 'పూర్తయింది';

  @override
  String get posStatusPending => 'పెండింగ్';

  @override
  String get posDateRange => 'తేదీ పరిధి';

  @override
  String get posSelectDateRange => 'తేదీ పరిధిని ఎంచుకోండి';

  @override
  String get posApplyFilters => 'ఫిల్టర్‌లను వర్తింపజేయి';

  @override
  String get posOrderDetails => 'ఆర్డర్ వివరాలు';

  @override
  String get posPaymentLabel => 'చెల్లింపు';

  @override
  String get posTotalAmount => 'మొత్తం మొత్తం';

  @override
  String posCustomerNumber(String id) {
    return 'కస్టమర్ #$id';
  }

  @override
  String get posItemsSummary => 'ఐటెమ్‌ల సారాంశం';

  @override
  String posProductNumber(String id) {
    return 'ప్రొడక్ట్ #$id';
  }

  @override
  String get posUnitFallback => 'యూనిట్';

  @override
  String posPrintReceiptStatus(String status) {
    return 'రసీదు ప్రింట్ చేయి ($status)';
  }

  @override
  String get posReturnExchange => 'రిటర్న్ / ఎక్స్ఛేంజ్';

  @override
  String get posSplitPayment => 'స్ప్లిట్ చెల్లింపు';

  @override
  String get posCashPaidNow => 'ఇప్పుడు చెల్లించిన క్యాష్';

  @override
  String get posOnUdhaarCredit => 'ఉధార్‌లో (క్రెడిట్)';

  @override
  String get posUdhaarRecordedNote =>
      'ఉధార్ భాగం క్రెడిట్‌గా రికార్డ్ చేయబడింది — బ్యాలెన్స్ కోసం ఉధార్ ట్యాబ్ చూడండి';

  @override
  String get posUdhaarSale => 'ఉధార్ అమ్మకం';

  @override
  String get posTotalPaid => 'మొత్తం చెల్లించబడింది';

  @override
  String get posRecordedAsCredit =>
      'క్రెడిట్‌గా రికార్డ్ చేయబడింది — ఉధార్ ట్యాబ్ చూడండి';

  @override
  String get posBoughtAsBasket => 'బాస్కెట్‌గా కొనుగోలు చేయబడింది';

  @override
  String get posBasketValue => 'బాస్కెట్ విలువ';

  @override
  String get posCustomerSaved => 'కస్టమర్ ఆదా చేసారు';

  @override
  String get invSearchItemsOrCategories =>
      'ఐటెమ్‌లు లేదా కేటగిరీలను వెతకండి...';

  @override
  String get invShowLess => 'తక్కువ చూపించు';

  @override
  String invViewMore(int count) {
    return '+$count ఇంకా';
  }

  @override
  String get invAll => 'అన్నీ';

  @override
  String get invUncategorised => 'కేటగిరీ లేనివి';

  @override
  String get invNoMatchesFound => 'మ్యాచ్‌లు కనుగొనబడలేదు';

  @override
  String invNearExpiryBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ఐటెమ్‌లు త్వరలో ఎక్స్‌పైర్ అవుతున్నాయి — మార్క్ డౌన్ చేయడానికి లేదా క్లియర్ చేయడానికి నొక్కండి',
      one:
          '1 ఐటెమ్ త్వరలో ఎక్స్‌పైర్ అవుతోంది — మార్క్ డౌన్ చేయడానికి లేదా క్లియర్ చేయడానికి నొక్కండి',
    );
    return '$_temp0';
  }

  @override
  String invMissingPriceBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ప్రొడక్ట్‌లు ₹0 ధరతో ఉన్నాయి — ధరలు సెట్ చేయడానికి నొక్కండి',
      one: '1 ప్రొడక్ట్ ₹0 ధరతో ఉంది — ధరలు సెట్ చేయడానికి నొక్కండి',
    );
    return '$_temp0';
  }

  @override
  String get invFlagFast => 'ఫాస్ట్';

  @override
  String get invFlagReorder => 'రీఆర్డర్';

  @override
  String get invFlagLowStock => 'తక్కువ స్టాక్';

  @override
  String get invFlagDead => 'డెడ్';

  @override
  String get invFlagProfit => 'లాభం';

  @override
  String invStockLabel(String stock) {
    return 'స్టాక్: $stock';
  }

  @override
  String get invUnitFallback => 'యూనిట్';

  @override
  String get invSyncFailedTapRetry =>
      'సింక్ విఫలమైంది — మళ్లీ ప్రయత్నించడానికి నొక్కండి';

  @override
  String get invSyncingToServer => 'సర్వర్‌కి సింక్ అవుతోంది...';

  @override
  String get invNoInventoryYet => 'ఇంకా ఇన్వెంటరీ లేదు';

  @override
  String get invNoInventoryHint =>
      'మీ మొదటి ప్రొడక్ట్‌ను జోడించడానికి + నొక్కండి.\nముందుగా ఒక కేటగిరీ సృష్టించి, తర్వాత ఐటెమ్‌లను జోడించండి.';

  @override
  String get invAddFirstProduct => 'మొదటి ప్రొడక్ట్ జోడించు';

  @override
  String get invCouldNotLoadInventory => 'ఇన్వెంటరీని లోడ్ చేయలేకపోయింది';

  @override
  String get invRetry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get invSelectCategoryError => 'దయచేసి ఒక కేటగిరీని ఎంచుకోండి';

  @override
  String invVariantPriceRequired(int number) {
    return 'వేరియంట్ $number: అమ్మకపు ధర అవసరం';
  }

  @override
  String get invProductSavedSyncing =>
      'ప్రొడక్ట్ సేవ్ అయింది — బ్యాక్‌గ్రౌండ్‌లో సింక్ అవుతోంది';

  @override
  String invVariantsSavedSyncing(int count) {
    return '$count వేరియంట్‌లు సేవ్ అయ్యాయి — బ్యాక్‌గ్రౌండ్‌లో సింక్ అవుతోంది';
  }

  @override
  String get invAddProduct => 'ప్రొడక్ట్ జోడించు';

  @override
  String get invAddFromCatalog => 'కేటలాగ్ నుండి జోడించు';

  @override
  String get invNewProduct => 'కొత్త ప్రొడక్ట్';

  @override
  String get invSave => 'సేవ్ చేయి';

  @override
  String get invSearchProductName => 'ప్రొడక్ట్ పేరు వెతకండి...';

  @override
  String get invLoadMoreResults => 'మరిన్ని ఫలితాలు లోడ్ చేయి';

  @override
  String get invNoMoreSearchResults => 'ఇంకా శోధన ఫలితాలు లేవు';

  @override
  String get invSearchProductCatalog => 'ప్రొడక్ట్ కేటలాగ్‌ను వెతకండి';

  @override
  String get invSearchCatalogHint =>
      'ఒక పేరు టైప్ చేయండి లేదా బార్‌కోడ్ స్కాన్ చేయండి.\nకనుగొనబడకపోతే, మాన్యువల్‌గా జోడించండి.';

  @override
  String get invAddManually => 'మాన్యువల్‌గా జోడించు';

  @override
  String get invAddManuallySub =>
      'ప్రొడక్ట్ కేటలాగ్‌లో లేదా? వివరాలను మీరే నమోదు చేయండి.';

  @override
  String get invProductAdded => 'ప్రొడక్ట్ జోడించబడింది!';

  @override
  String invVariantsAdded(int count) {
    return '$count వేరియంట్‌లు జోడించబడ్డాయి!';
  }

  @override
  String get invLooseItem => 'లూజ్ ఐటెమ్';

  @override
  String get invLooseItemSub => 'బరువు ద్వారా అమ్ముతారు (ఉదా. మైదా, పప్పు)';

  @override
  String get invBasicDetails => 'ప్రాథమిక వివరాలు';

  @override
  String get invProductNameLabel => 'ప్రొడక్ట్ పేరు *';

  @override
  String get invRequired => 'అవసరం';

  @override
  String get invBrandOptional => 'బ్రాండ్ (ఐచ్ఛికం)';

  @override
  String get invSelectCategoryStar => 'కేటగిరీని ఎంచుకోండి *';

  @override
  String get invOther => 'ఇతర';

  @override
  String get invPerishableItem => 'పాడయ్యే ఐటెమ్';

  @override
  String get invPerishableItemSub => 'ఎక్స్‌పైరీ తేదీ ఉంది';

  @override
  String get invSizePriceStock => 'సైజ్, ధర & స్టాక్';

  @override
  String invVariantsCount(int count) {
    return 'వేరియంట్‌లు ($count)';
  }

  @override
  String get invAddVariant => 'వేరియంట్ జోడించు';

  @override
  String get invManageVariants => 'వేరియంట్‌లను నిర్వహించండి';

  @override
  String get invVariants => 'వేరియంట్‌లు';

  @override
  String get invEditVariant => 'వేరియంట్‌ను సవరించండి';

  @override
  String get invSaveVariant => 'వేరియంట్‌ను సేవ్ చేయండి';

  @override
  String get invNoVariantsYet =>
      'ఇంకా వేరియంట్‌లు లేవు. సైజు, రంగు లేదా మోడల్ జోడించండి.';

  @override
  String get invStockPerVariantNote =>
      'స్టాక్ ప్రతి వేరియంట్‌కు విడిగా ట్రాక్ చేయబడుతుంది. క్రింద ఉన్న \'వేరియంట్‌లను నిర్వహించండి\' ఉపయోగించండి.';

  @override
  String get invDefaultVariant => 'డిఫాల్ట్';

  @override
  String invVariantAxisRequired(String label) {
    return 'దయచేసి $label ఎంచుకోండి';
  }

  @override
  String get invSaveProduct => 'ప్రొడక్ట్ సేవ్ చేయి';

  @override
  String invSaveVariants(int count) {
    return '$count వేరియంట్‌లు సేవ్ చేయి';
  }

  @override
  String get invProduct => 'ప్రొడక్ట్';

  @override
  String invVariantNumber(int number) {
    return 'వేరియంట్ $number';
  }

  @override
  String get invUnit => 'యూనిట్';

  @override
  String get invBaseUnit => 'బేస్ యూనిట్';

  @override
  String get invPackSize => 'ప్యాక్ సైజ్';

  @override
  String get invPackSizeHint => 'ఉదా. 250';

  @override
  String get invBarcode => 'బార్‌కోడ్';

  @override
  String get invFromCatalog => 'కేటలాగ్ నుండి';

  @override
  String get invOptional => 'ఐచ్ఛికం';

  @override
  String invPricePerUnit(String unit) {
    return 'ధర / $unit *';
  }

  @override
  String get invSellingPriceStar => 'అమ్మకపు ధర *';

  @override
  String get invInvalid => 'చెల్లదు';

  @override
  String get invMrp => 'MRP';

  @override
  String get invCostPrice => 'కాస్ట్ ధర (మీరు చెల్లించేది)';

  @override
  String get invCostPriceHint =>
      'ఐచ్ఛికం — లాభ ఖచ్చితత్వాన్ని మెరుగుపరుస్తుంది';

  @override
  String invOpeningStockUnit(String unit) {
    return 'ఓపెనింగ్ స్టాక్ ($unit) *';
  }

  @override
  String get invOpeningStockUnits => 'ఓపెనింగ్ స్టాక్ (యూనిట్లు) *';

  @override
  String get invExpiryDate => 'ఎక్స్‌పైరీ తేదీ';

  @override
  String get invExpiryDateHint => 'YYYY-MM-DD';

  @override
  String get invRequiredForPerishables => 'పాడయ్యే వస్తువులకు అవసరం';

  @override
  String get invLinkedFromCatalog => 'కేటలాగ్ నుండి లింక్ చేయబడింది';

  @override
  String get invSelectCategory => 'కేటగిరీని ఎంచుకోండి';

  @override
  String get invSearchCategories => 'కేటగిరీలను వెతకండి...';

  @override
  String get invNoCategoriesFound => 'కేటగిరీలు కనుగొనబడలేదు';

  @override
  String get invEditProduct => 'ప్రొడక్ట్‌ను ఎడిట్ చేయి';

  @override
  String invProductUpdated(String name) {
    return '$name అప్‌డేట్ అయింది!';
  }

  @override
  String get invProductUpdatedSuccess =>
      'ప్రొడక్ట్ విజయవంతంగా అప్‌డేట్ అయింది!';

  @override
  String get invSellingUnit => 'అమ్మకపు యూనిట్';

  @override
  String get invPricing => 'ధర నిర్ణయం';

  @override
  String invPricePerSelected(String unit) {
    return '$unitకి ధర *';
  }

  @override
  String get invMrpOptional => 'MRP (ఐచ్ఛికం)';

  @override
  String get invStock => 'స్టాక్';

  @override
  String get invGstRate => 'GST %';

  @override
  String get invHsnCode => 'HSN కోడ్';

  @override
  String get invWarranty => 'వారంటీ';

  @override
  String get invWarrantyCovered => 'వారంటీలో కవర్';

  @override
  String get invWarrantyCoveredSub =>
      'ఎంత కాలమో సెట్ చేయండి — కొనుగోలు తేదీ నుండి లెక్కిస్తారు';

  @override
  String get invWarrantyPeriod => 'వారంటీ వ్యవధి';

  @override
  String invStockInUnit(String unit) {
    return 'స్టాక్ ($unitలో) *';
  }

  @override
  String get invStockQuantityStar => 'స్టాక్ పరిమాణం *';

  @override
  String get invPerishableBatchNote =>
      'పాడయ్యే బ్యాచ్ వివరాల కోసం, ఇన్వెంటరీ నుండి \"బ్యాచ్ స్వీకరించు\" వాడండి.';

  @override
  String get invSaveChanges => 'మార్పులను సేవ్ చేయి';

  @override
  String get invCategoryNameRequired => 'కేటగిరీ పేరు అవసరం';

  @override
  String get invCreateCategoryFailed =>
      'కేటగిరీ సృష్టించడం విఫలమైంది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get invNewCategory => 'కొత్త కేటగిరీ';

  @override
  String get invNewCategorySub =>
      'మీ ప్రొడక్ట్‌లను నిర్వహించడానికి ఒక కేటగిరీని జోడించండి.';

  @override
  String get invCategoryCreated => 'కేటగిరీ సృష్టించబడింది!';

  @override
  String get invCategoryNameLabel => 'కేటగిరీ పేరు';

  @override
  String get invCategoryNameHint => 'ఉదా. స్టేపుల్స్, డెయిరీ, స్నాక్స్…';

  @override
  String get invCreateCategory => 'కేటగిరీ సృష్టించు';

  @override
  String get invCardOutOfStock => 'స్టాక్‌లో లేదు';

  @override
  String invCardStockLow(String qty) {
    return '$qty — తక్కువ';
  }

  @override
  String invCardStockInStock(String qty) {
    return '$qty స్టాక్‌లో ఉంది';
  }

  @override
  String get invCardFast => 'ఫాస్ట్';

  @override
  String get invCardSlow => 'స్లో';

  @override
  String get invCardExpired => 'ఎక్స్‌పైర్ అయింది';

  @override
  String invCardDays(String days) {
    return '${days}d';
  }

  @override
  String get invCardBarcode => 'బార్‌కోడ్';

  @override
  String get invCardSoldToday => 'ఈరోజు అమ్మినవి';

  @override
  String get invCardReorder => 'రీఆర్డర్';

  @override
  String invCardReorderUnits(String qty) {
    return '$qty యూనిట్లు';
  }

  @override
  String get invCard7dRisk => '7d రిస్క్';

  @override
  String get invExpiringSoon => 'త్వరలో ఎక్స్‌పైర్ అవుతున్నవి';

  @override
  String get invNext => 'తర్వాతి';

  @override
  String invDaysWindow(int days) {
    return '$days రోజులు';
  }

  @override
  String get invExpired => 'ఎక్స్‌పైర్ అయింది';

  @override
  String get invExpiresToday => 'ఈరోజు ఎక్స్‌పైర్ అవుతుంది';

  @override
  String get invExpiresTomorrow => 'రేపు ఎక్స్‌పైర్ అవుతుంది';

  @override
  String invExpiresInDays(int days) {
    return '$days రోజుల్లో ఎక్స్‌పైర్ అవుతుంది';
  }

  @override
  String invQtyInStock(String qty, String unit) {
    return '$qty $unit స్టాక్‌లో ఉంది';
  }

  @override
  String get invAtRisk => 'రిస్క్‌లో';

  @override
  String get invMarkedDown => 'మార్క్ డౌన్ చేయబడింది';

  @override
  String get invPrice => 'ధర';

  @override
  String get invChangeMarkdown => 'మార్క్‌డౌన్ మార్చు';

  @override
  String get invMarkDown => 'మార్క్ డౌన్';

  @override
  String get invRecordWaste => 'వేస్ట్ రికార్డ్ చేయి';

  @override
  String invMarkDownTitle(String name) {
    return '$nameని మార్క్ డౌన్ చేయి';
  }

  @override
  String get invClearanceDiscount =>
      'ఎక్స్‌పైరీకి ముందు అమ్మడానికి క్లియరెన్స్ డిస్కౌంట్';

  @override
  String invPctSuggested(String pct) {
    return '$pct% (సూచించబడింది)';
  }

  @override
  String invPct(String pct) {
    return '$pct%';
  }

  @override
  String get invCustom => 'కస్టమ్';

  @override
  String get invApplyMarkdown => 'మార్క్‌డౌన్ వర్తింపజేయి';

  @override
  String get invMarkdownApplied => 'మార్క్‌డౌన్ వర్తింపజేయబడింది';

  @override
  String get invMarkdownFailed => 'మార్క్‌డౌన్ వర్తింపజేయలేకపోయింది';

  @override
  String invWriteOff(String name) {
    return '$nameని రైట్ ఆఫ్ చేయి';
  }

  @override
  String get invWriteOffSub =>
      'పాడైన యూనిట్లను స్టాక్ నుండి తీసివేసి నష్టాన్ని రికార్డ్ చేస్తుంది.';

  @override
  String invOfQtyInStock(int qty) {
    return 'స్టాక్‌లో ఉన్న $qtyలో';
  }

  @override
  String invUnitsWrittenOff(int units) {
    return '$units యూనిట్లు రైట్ ఆఫ్ చేయబడ్డాయి';
  }

  @override
  String get invWasteFailed => 'వేస్ట్ రికార్డ్ చేయలేకపోయింది';

  @override
  String get invNothingExpiring => 'త్వరలో ఎక్స్‌పైర్ అయ్యేవి ఏవీ లేవు';

  @override
  String get invNothingExpiringSub =>
      'ఎక్స్‌పైరీకి దగ్గరవుతున్న పాడయ్యే బ్యాచ్‌లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get invCouldNotLoadExpiry => 'ఎక్స్‌పైరీ డేటాను లోడ్ చేయలేకపోయింది';

  @override
  String get invMissingPrices => 'ధరలు లేనివి';

  @override
  String get invCouldNotLoadPrices => 'ధరలను లోడ్ చేయలేకపోయింది';

  @override
  String invStockCurrentlyZero(String qty, String unit) {
    return '$qty $unit స్టాక్‌లో ఉంది · ప్రస్తుతం ₹0';
  }

  @override
  String invSuggestedPrice(String price, String source) {
    return 'సూచించిన ₹$price ($source)';
  }

  @override
  String get invSellingPrice => 'అమ్మకపు ధర';

  @override
  String get invSet => 'సెట్ చేయి';

  @override
  String get invEnterValidPrice => 'చెల్లుబాటు అయ్యే ధరను నమోదు చేయండి';

  @override
  String invProductPriced(String name, String price) {
    return '$name ₹$price ధర నిర్ణయించబడింది';
  }

  @override
  String get invCouldNotSetPrice => 'ధరను సెట్ చేయలేకపోయింది';

  @override
  String get invEveryProductPriced => 'ప్రతి ప్రొడక్ట్‌కి ధర ఉంది';

  @override
  String get invEveryProductPricedSub => 'ఏదీ ₹0కి అమ్ముడవట్లేదు. బాగుంది!';

  @override
  String get finFinance => 'ఫైనాన్స్';

  @override
  String get finErrorLoadingStats => 'గణాంకాలు లోడ్ చేయడంలో ఎర్రర్';

  @override
  String get finTabCashflow => 'క్యాష్‌ఫ్లో';

  @override
  String get finTabCustomerUdhaar => 'కస్టమర్\nఉధార్';

  @override
  String get finTabSupplierUdhaar => 'సప్లయర్ ఉధార్';

  @override
  String get finMonthlySales => 'నెలవారీ సేల్స్';

  @override
  String get finMonthlySkus => 'నెలవారీ SKUs';

  @override
  String get finAvailableInFuture =>
      'భవిష్యత్ అప్‌డేట్లలో అందుబాటులోకి వస్తుంది';

  @override
  String get finFailedLoadUdhaar => 'ఉధార్ డేటా లోడ్ కాలేదు';

  @override
  String get finCheckConnection => 'మీ కనెక్షన్ చెక్ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get finRetry => 'మళ్లీ ప్రయత్నించు';

  @override
  String get finCustomerDues => 'కస్టమర్ బకాయిలు';

  @override
  String get finNewUdhaar => 'కొత్త ఉధార్';

  @override
  String get finAddNewUdhaar => 'కొత్త ఉధార్ యాడ్ చేయి';

  @override
  String get finContacts => 'కాంటాక్ట్స్';

  @override
  String get finSelectExistingCustomer => 'ఉన్న కస్టమర్‌ను సెలెక్ట్ చేయి';

  @override
  String get finOrEnterManually => 'లేదా మాన్యువల్‌గా ఎంటర్ చేయి';

  @override
  String get finUdhaarRecorded => 'ఉధార్ రికార్డ్ అయింది!';

  @override
  String get finCustomerName => 'కస్టమర్ పేరు';

  @override
  String get finPhoneNumber => 'ఫోన్ నంబర్';

  @override
  String get finAmount => 'అమౌంట్';

  @override
  String get finSaveUdhaar => 'ఉధార్ సేవ్ చేయి';

  @override
  String get finEnterValidNamePhoneAmount =>
      'సరైన పేరు, ఫోన్, అమౌంట్ ఎంటర్ చేయండి';

  @override
  String get finSelectCustomer => 'కస్టమర్‌ను సెలెక్ట్ చేయి';

  @override
  String get finSearchByNameOrPhone => 'పేరు లేదా ఫోన్‌తో వెతకండి...';

  @override
  String get finNoCustomersFound => 'కస్టమర్లు ఎవరూ దొరకలేదు';

  @override
  String get finTotalPending => 'మొత్తం పెండింగ్';

  @override
  String get finRecovered => 'రికవర్ అయింది';

  @override
  String get finCustomers => 'కస్టమర్లు';

  @override
  String finHighRiskDues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'లు',
      one: '',
    );
    return '$count హై-రిస్క్ బకాయి$_temp0 — వీటిని ముందుగా వసూలు చేయండి';
  }

  @override
  String get finSmartRemindersSubtitle =>
      'స్మార్ట్ రిమైండర్లు — రికవరీ ర్యాంక్ చేసిన బకాయిలు';

  @override
  String finTakenDaysAgo(String date, int days) {
    return 'తీసుకున్నది: $date ($days రోజుల క్రితం)';
  }

  @override
  String get finWhatsappReminderSent => 'WhatsApp రిమైండర్ పంపబడింది!';

  @override
  String finFailedSendReminder(String error) {
    return 'రిమైండర్ పంపడం విఫలమైంది: $error';
  }

  @override
  String get finSendWhatsappReminder => 'WhatsApp రిమైండర్ పంపు';

  @override
  String get finRemind => 'గుర్తు చేయి';

  @override
  String get finRemindedToday => 'ఈరోజు గుర్తు చేశారు';

  @override
  String get finRecover => 'వసూలు';

  @override
  String get finHistory => 'హిస్టరీ';

  @override
  String get finSettled => 'సెటిల్ అయింది';

  @override
  String get finRecordPayment => 'చెల్లింపు నమోదు చేయండి';

  @override
  String get finPaymentOldestFirstNote =>
      'పురాతన బకాయిలకు ముందుగా వర్తింపజేయబడుతుంది';

  @override
  String get finTaken => 'తీసుకున్నది';

  @override
  String get finPaid => 'చెల్లించింది';

  @override
  String get finBalanceShort => 'నిల్వ';

  @override
  String finOpenDuesSummary(int count, int days) {
    return '$count బకాయి · పురాతనం $days రోజులు';
  }

  @override
  String finSettledSectionTitle(int count) {
    return 'సెటిల్ ($count)';
  }

  @override
  String finRecoverUdhaarFrom(String name) {
    return '$name నుండి ఉధార్ వసూలు చేయి';
  }

  @override
  String get finRecoveryRecorded => 'రికవరీ రికార్డ్ అయింది!';

  @override
  String finBalanceLabel(String value) {
    return 'బ్యాలెన్స్: ₹$value';
  }

  @override
  String get finConfirmRecovery => 'రికవరీ కన్ఫర్మ్ చేయి';

  @override
  String get finEnterValidAmount => 'సరైన అమౌంట్ ఎంటర్ చేయండి';

  @override
  String finAmountExceedsBalance(String value) {
    return 'అమౌంట్ బ్యాలెన్స్ ₹$value కంటే ఎక్కువ ఉండకూడదు';
  }

  @override
  String get finNoPendingUdhaars => 'పెండింగ్ ఉధార్లు ఏవీ లేవు';

  @override
  String get finRecoveryHistory => 'రికవరీ హిస్టరీ';

  @override
  String get finNoRecoveriesYet => 'ఇంకా రికవరీలు ఏవీ రికార్డ్ కాలేదు.';

  @override
  String finRecoveryNumber(int number) {
    return 'రికవరీ #$number';
  }

  @override
  String finErrorWithMessage(String message) {
    return 'ఎర్రర్: $message';
  }

  @override
  String get finOverdue => 'ఓవర్‌డ్యూ';

  @override
  String get finDueToday => 'ఈరోజు డ్యూ';

  @override
  String get finNext7Days => 'తర్వాతి 7 రోజులు';

  @override
  String get finNoPendingPayments7Days =>
      'తర్వాతి 7 రోజులలో పెండింగ్ పేమెంట్లు ఏవీ లేవు';

  @override
  String get finPaidLast7Days => 'గత 7 రోజులలో చెల్లించినవి';

  @override
  String get finNoPaymentsRecorded7Days =>
      'గత 7 రోజులలో ఏ పేమెంట్లూ రికార్డ్ కాలేదు';

  @override
  String get finSuppliers => 'సప్లయర్లు';

  @override
  String get finAddEditSuppliersHint =>
      'సప్లయర్లను పర్చేస్ ట్యాబ్‌లో యాడ్ చేయండి లేదా ఎడిట్ చేయండి';

  @override
  String get finNoSuppliersYet => 'ఇంకా సప్లయర్లు ఎవరూ లేరు.';

  @override
  String get finTotalOutstanding => 'మొత్తం ఔట్‌స్టాండింగ్';

  @override
  String get finToday => 'ఈరోజు';

  @override
  String get finPaid7d => 'చెల్లించినది (7d)';

  @override
  String get finStockPurchase => 'స్టాక్ పర్చేస్';

  @override
  String finOverdueSince(String date) {
    return '$date నుండి ఓవర్‌డ్యూ';
  }

  @override
  String finDueOn(String day) {
    return '$day డ్యూ';
  }

  @override
  String get finDueTodayLabel => 'ఈరోజు డ్యూ';

  @override
  String get finToPay => 'చెల్లించాలి';

  @override
  String get finDetails => 'వివరాలు';

  @override
  String get finMarkPaid => 'చెల్లించినట్లు మార్క్ చేయి';

  @override
  String finPurchaseOn(String date) {
    return '$dateన పర్చేస్';
  }

  @override
  String get finNoItemsFound => 'ఐటెమ్స్ ఏవీ దొరకలేదు.';

  @override
  String get finTotalBill => 'మొత్తం బిల్లు';

  @override
  String get finTomorrow => 'రేపు';

  @override
  String get finWeekdayMon => 'సోమ';

  @override
  String get finWeekdayTue => 'మంగళ';

  @override
  String get finWeekdayWed => 'బుధ';

  @override
  String get finWeekdayThu => 'గురు';

  @override
  String get finWeekdayFri => 'శుక్ర';

  @override
  String get finWeekdaySat => 'శని';

  @override
  String get finWeekdaySun => 'ఆది';

  @override
  String get finFailedLoadCashflow => 'క్యాష్‌ఫ్లో డేటా లోడ్ కాలేదు';

  @override
  String get finIncome => 'ఆదాయం';

  @override
  String get finTodaysSales => 'ఈరోజు సేల్స్';

  @override
  String get finCreditExposureUdhaar => 'క్రెడిట్ ఎక్స్‌పోజర్ (ఉధార్)';

  @override
  String get finOutstanding => 'ఔట్‌స్టాండింగ్';

  @override
  String get finCustomersWithPendingDues => 'బకాయిలు పెండింగ్ ఉన్న కస్టమర్లు';

  @override
  String finCustomersCount(int count) {
    return '$count కస్టమర్లు';
  }

  @override
  String get finCreditVsSalesRatio => 'క్రెడిట్ vs సేల్స్ నిష్పత్తి';

  @override
  String finPercentOnCredit(String value) {
    return '$value% క్రెడిట్‌పై';
  }

  @override
  String finOfMonthly(String value) {
    return 'నెలవారీ $valueలో';
  }

  @override
  String get finCreditHealthy => 'ఆరోగ్యకరం — క్రెడిట్ ఎక్స్‌పోజర్ తక్కువ';

  @override
  String get finCreditModerate =>
      'మోస్తరు — బకాయిలు వసూలు చేయడం గురించి ఆలోచించండి';

  @override
  String get finCreditHigh => 'ఎక్కువ — చాలా సేల్స్ క్రెడిట్‌పై ఉన్నాయి';

  @override
  String get finConsentTitle => 'కస్టమర్ సమ్మతిని రికార్డ్ చేయండి';

  @override
  String get finConsentSubtitle => 'ఈ ఉధార్‌కు వాయిస్ నిర్ధారణ';

  @override
  String get finConsentScriptIntro => 'కస్టమర్‌ను ఇలా చెప్పమనండి:';

  @override
  String finConsentScript(String total, String udhaar, String date) {
    return 'నేను అంగీకరిస్తున్నాను — మొత్తం $total, ఉధార్ $udhaar, $date లోపు చెల్లిస్తాను.';
  }

  @override
  String get finConsentTapToRecord => 'మైక్ నొక్కి కస్టమర్‌ను మాట్లాడనివ్వండి';

  @override
  String get finConsentRecording => 'రికార్డ్ అవుతోంది';

  @override
  String get finConsentSaved =>
      'సమ్మతి సేవ్ అయింది — బ్యాక్‌గ్రౌండ్‌లో అప్‌లోడ్ అవుతోంది';

  @override
  String get finConsentSkip => 'దాటవేయి';

  @override
  String get finConsentSectionTitle => 'వాయిస్ సమ్మతి';

  @override
  String get finConsentStatusPending => 'అప్‌లోడ్ అయింది · విశ్లేషణ పెండింగ్';

  @override
  String get finConsentStatusAnalyzed => 'ధృవీకరించబడింది';

  @override
  String finConsentMatchScore(String pct) {
    return 'వాయిస్ సరిపోలిక: $pct%';
  }

  @override
  String get finConsentNone => 'వాయిస్ సమ్మతి రికార్డ్ కాలేదు';

  @override
  String get finDueDate => 'తిరిగి చెల్లించే తేదీ';

  @override
  String get finDueDateHint => 'కస్టమర్ ఎప్పుడు చెల్లిస్తారు?';

  @override
  String finDueBy(String date) {
    return '$date లోపు చెల్లించాలి';
  }

  @override
  String finClearingDues(int count) {
    return '$count ఉధార్‌లు క్లియర్ అవుతున్నాయి…';
  }

  @override
  String finDuesCleared(int count) {
    return '$count ఉధార్‌లు క్లియర్ అయ్యాయి';
  }

  @override
  String finClearingDuesProgress(int cleared, int total) {
    return 'బకాయిలు తీర్చబడుతున్నాయి: $cleared/$total';
  }

  @override
  String finDuesClearFailed(int cleared, int total) {
    return 'అన్ని బకాయిలు తీర్చలేకపోయాం ($cleared/$total)';
  }

  @override
  String get finSmartReminders => 'స్మార్ట్ రిమైండర్లు';

  @override
  String get finCouldNotLoadReminders => 'రిమైండర్లు లోడ్ చేయలేకపోయాం';

  @override
  String finDaysPending(int days) {
    return '$days రోజులు పెండింగ్';
  }

  @override
  String finRiskBadge(String band) {
    return '$band రిస్క్';
  }

  @override
  String finLikelyToRecover(int percent) {
    return '~$percent% రికవర్ అయ్యే అవకాశం';
  }

  @override
  String get finSendReminder => 'రిమైండర్ పంపు';

  @override
  String finReminderSentTo(String name) {
    return '$nameకి రిమైండర్ పంపబడింది';
  }

  @override
  String get finCouldNotSendReminder => 'రిమైండర్ పంపలేకపోయాం';

  @override
  String get finNoOpenUdhaar => 'ఓపెన్ ఉధార్ ఏదీ లేదు';

  @override
  String get finAllCreditSettled =>
      'మొత్తం క్రెడిట్ సెటిల్ అయింది. చాలా బాగుంది!';

  @override
  String get procAddSupplierFirstToCreatePo =>
      'పర్చేస్ ఆర్డర్ పెట్టడానికి ముందు ఒక సప్లయర్‌ను యాడ్ చేయండి';

  @override
  String procErrorWithMessage(String message) {
    return 'ఎర్రర్: $message';
  }

  @override
  String get procSuppliers => 'సప్లయర్లు';

  @override
  String get procNoSuppliersYet => 'ఇంకా సప్లయర్లు ఎవరూ యాడ్ కాలేదు.';

  @override
  String get procRecentPurchases => 'ఇటీవలి పర్చేస్‌లు';

  @override
  String get procAddAtLeastOneSupplier =>
      'పర్చేస్ యాడ్ చేయాలంటే కనీసం 1 సప్లయర్‌ను యాడ్ చేయండి.';

  @override
  String get procNoPurchaseOrdersYet => 'ఇంకా పర్చేస్ ఆర్డర్లు లేవు.';

  @override
  String get procScanInvoice => 'ఇన్‌వాయిస్ స్కాన్';

  @override
  String get procAdd => 'యాడ్';

  @override
  String get procSuggestedReorders => 'సూచించిన రీఆర్డర్లు';

  @override
  String get procRunningLowLast30Days =>
      'గత 30 రోజుల అమ్మకాల ఆధారంగా స్టాక్ తగ్గుతోంది';

  @override
  String get procAddNewSupplier => 'కొత్త సప్లయర్‌ను యాడ్ చేయండి';

  @override
  String get procContacts => 'కాంటాక్ట్‌లు';

  @override
  String get procSupplierName => 'సప్లయర్ పేరు';

  @override
  String get procPhoneNumber => 'ఫోన్ నంబర్';

  @override
  String get procCategoryHint => 'కేటగిరీ (ఉదా. డెయిరీ, FMCG)';

  @override
  String get procEnterValidPhone => 'సరైన ఫోన్ నంబర్ ఎంటర్ చేయండి';

  @override
  String get procSaveSupplier => 'సప్లయర్‌ను సేవ్ చేయండి';

  @override
  String get procEditSupplier => 'సప్లయర్‌ను ఎడిట్ చేయండి';

  @override
  String get procSaveChanges => 'మార్పులను సేవ్ చేయండి';

  @override
  String get procNewPurchaseOrder => 'కొత్త పర్చేస్ ఆర్డర్';

  @override
  String get procRecordItemsFromDistributor =>
      'డిస్ట్రిబ్యూటర్ నుండి కొనుగోలు చేసిన వస్తువులను రికార్డ్ చేయండి.';

  @override
  String get procOrderDetails => 'ఆర్డర్ వివరాలు';

  @override
  String get procDistributor => 'డిస్ట్రిబ్యూటర్';

  @override
  String get procPaymentDueDate => 'పేమెంట్ గడువు తేదీ';

  @override
  String get procSelectDate => 'తేదీని ఎంచుకోండి';

  @override
  String procItemsCount(int count) {
    return 'వస్తువులు ($count)';
  }

  @override
  String get procAddItem => 'వస్తువును యాడ్ చేయండి';

  @override
  String get procNoItemsAddedYet => 'ఇంకా వస్తువులు యాడ్ కాలేదు';

  @override
  String get procNotes => 'నోట్స్';

  @override
  String get procNotesHint => 'బిల్ నంబర్, డెలివరీ నోట్స్ మొదలైనవి.';

  @override
  String get procTotalAmount => 'మొత్తం మొత్తం';

  @override
  String get procSaveOrder => 'ఆర్డర్‌ను సేవ్ చేయండి';

  @override
  String get procSearchProduct => 'ప్రొడక్ట్‌ను వెతకండి...';

  @override
  String procAddProduct(String name) {
    return '$name యాడ్ చేయండి';
  }

  @override
  String get procQuantity => 'క్వాంటిటీ';

  @override
  String get procCostPricePerUnit => 'యూనిట్‌కు కాస్ట్ ధర';

  @override
  String get procCancel => 'క్యాన్సిల్';

  @override
  String procDaysCover(String days) {
    return '${days}d కవర్';
  }

  @override
  String procOrderQty(String qty) {
    return '$qty ఆర్డర్ చేయండి';
  }

  @override
  String procStockLine(String stock, String perDay, String cover) {
    return 'స్టాక్ $stock · ~$perDay/రోజు · $cover';
  }

  @override
  String get procCreatePurchaseOrder => 'పర్చేస్ ఆర్డర్ క్రియేట్ చేయండి';

  @override
  String get procEditSupplierTooltip => 'సప్లయర్‌ను ఎడిట్ చేయండి';

  @override
  String get procMarkAsReceived => 'అందినట్లు మార్క్ చేయండి';

  @override
  String get procPleaseSelectSupplierFirst => 'ముందు ఒక సప్లయర్‌ను ఎంచుకోండి';

  @override
  String get procFromScannedInvoice => 'స్కాన్ చేసిన ఇన్‌వాయిస్ నుండి';

  @override
  String procPoCreatedWithUnmatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'లు',
      one: '',
    );
    return 'పర్చేస్ ఆర్డర్ క్రియేట్ అయింది! ($count వస్తువు$_temp0 మ్యాచ్ కాలేదు)';
  }

  @override
  String get procPoCreatedFromInvoice =>
      'ఇన్‌వాయిస్ నుండి పర్చేస్ ఆర్డర్ క్రియేట్ అయింది!';

  @override
  String get procCameraGalleryPdf => 'కెమెరా · గ్యాలరీ · PDF';

  @override
  String get procScansLabel => 'స్కాన్‌లు';

  @override
  String get procScanAgain => 'మళ్లీ స్కాన్ చేయండి';

  @override
  String get procInvoiceScanProFeature => 'ఇన్‌వాయిస్ స్కాన్ Pro ఫీచర్.';

  @override
  String get procUpgradeToPro => 'Pro కి అప్‌గ్రేడ్ చేయండి';

  @override
  String get procDailyLimitReached =>
      'రోజువారీ లిమిట్ అయిపోయింది. కొనసాగించడానికి క్రెడిట్‌లు టాప్ అప్ చేయండి.';

  @override
  String get procBuyCredits => 'క్రెడిట్‌లు కొనండి';

  @override
  String get procCreatingPurchaseOrder => 'పర్చేస్ ఆర్డర్ క్రియేట్ అవుతోంది…';

  @override
  String get procPurchaseOrderCreated => 'పర్చేస్ ఆర్డర్ క్రియేట్ అయింది!';

  @override
  String get procTryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get procCaptureOrUploadInvoice =>
      'సప్లయర్ ఇన్‌వాయిస్‌ను ఫోటో తీయండి లేదా అప్‌లోడ్ చేయండి';

  @override
  String get procUpgradeOrTopUp =>
      'Pro కి అప్‌గ్రేడ్ చేయండి లేదా క్రెడిట్‌లు టాప్ అప్ చేయండి';

  @override
  String get procKiranaAiReadsInvoice =>
      'Outlet AI వస్తువులు, మొత్తాలు & సప్లయర్ వివరాలను చదువుతుంది';

  @override
  String get procCamera => 'కెమెరా';

  @override
  String get procGallery => 'గ్యాలరీ';

  @override
  String get procUploadPdfImageFile => 'PDF / ఇమేజ్ ఫైల్ అప్‌లోడ్ చేయండి';

  @override
  String get procKiranaAiReadingInvoice =>
      'Outlet AI మీ ఇన్‌వాయిస్‌ను చదువుతోంది…';

  @override
  String get procExtractingItems =>
      'వస్తువులు, క్వాంటిటీలు మరియు మొత్తాలను తీస్తోంది';

  @override
  String get procGrandTotal => 'గ్రాండ్ టోటల్';

  @override
  String get procSupplierUpper => 'సప్లయర్';

  @override
  String procItemsUpperCount(int count) {
    return 'వస్తువులు ($count)';
  }

  @override
  String procMatchedCount(int count) {
    return '$count మ్యాచ్ అయ్యాయి';
  }

  @override
  String procUnmatchedItemsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'లు',
      one: '',
    );
    return '$count మ్యాచ్ కాని వస్తువు$_temp0 లైన్ ఐటమ్‌లుగా యాడ్ కావు, కానీ పూర్తి ఇన్‌వాయిస్ టోటల్ రికార్డ్ అవుతుంది.';
  }

  @override
  String get procSelectSupplierToContinue =>
      'కొనసాగించడానికి ఒక సప్లయర్‌ను ఎంచుకోండి';

  @override
  String get procCreatePurchaseOrderTitle => 'పర్చేస్ ఆర్డర్ క్రియేట్ చేయండి';

  @override
  String procConfidencePercent(int pct) {
    return '$pct% కాన్ఫిడెన్స్';
  }

  @override
  String get procTotalsMatch => '✓ టోటల్‌లు మ్యాచ్ అయ్యాయి';

  @override
  String get procTotalMismatch => '⚠ టోటల్ మ్యాచ్ కాలేదు';

  @override
  String get procUnverified => 'వెరిఫై కాలేదు';

  @override
  String get procPick => 'ఎంచుకోండి';

  @override
  String procNoMatchTapToSelect(String vendor) {
    return '\"$vendor\" కి మ్యాచ్ లేదు — ఎంచుకోవడానికి ట్యాప్ చేయండి';
  }

  @override
  String get procSelectSupplier => 'సప్లయర్‌ను ఎంచుకోండి';

  @override
  String get procSelectSupplierTitle => 'సప్లయర్‌ను ఎంచుకోండి';

  @override
  String get procNoSuppliersAddInPurchaseTab =>
      'ఇంకా సప్లయర్లు లేరు. పర్చేస్ ట్యాబ్‌లో సప్లయర్లను యాడ్ చేయండి.';

  @override
  String get procLinkToInventory => 'ఇన్వెంటరీకి లింక్ చేయండి';

  @override
  String get procSearchProducts => 'ప్రొడక్ట్‌లను వెతకండి…';

  @override
  String get procNoProductsFound => 'ప్రొడక్ట్‌లు ఏవీ దొరకలేదు';

  @override
  String procPriceStockLabel(String price, String stock) {
    return '$price · స్టాక్: $stock';
  }

  @override
  String get procMicPermissionDenied =>
      'మైక్రోఫోన్ పర్మిషన్ నిరాకరించబడింది. దయచేసి సెట్టింగ్స్‌లో దాన్ని ఎనేబుల్ చేయండి.';

  @override
  String get procMicNotAccessible => 'మైక్రోఫోన్ యాక్సెస్ కావడం లేదు.';

  @override
  String procAddedToCartFromVoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'లు',
      one: '',
    );
    return 'వాయిస్ ఆర్డర్ నుండి $count వస్తువు$_temp0 కార్ట్‌కు యాడ్ అయ్యాయి';
  }

  @override
  String get procVoiceOrder => 'వాయిస్ ఆర్డర్';

  @override
  String get procSpeakAnyIndianLanguage => 'ఏ భారతీయ భాషలోనైనా మాట్లాడండి';

  @override
  String get procVoiceOrderProFeature =>
      'వాయిస్ ఆర్డర్ Pro ఫీచర్. యాక్సెస్ కోసం అప్‌గ్రేడ్ చేయండి.';

  @override
  String get procUpgrade => 'అప్‌గ్రేడ్';

  @override
  String get procNoVoiceOrdersLeft =>
      'ఈ రోజు వాయిస్ ఆర్డర్లు ఏవీ మిగల్లేదు. ఎక్కువ క్రెడిట్‌లు తీసుకోండి.';

  @override
  String get procGetCredits => 'క్రెడిట్‌లు తీసుకోండి';

  @override
  String get procVoiceLabel => 'వాయిస్';

  @override
  String get procTapMicToStart =>
      'రికార్డింగ్ మొదలుపెట్టడానికి మైక్ ట్యాప్ చేయండి';

  @override
  String get procTapToStopAndProcess => 'ఆపి ప్రాసెస్ చేయడానికి ట్యాప్ చేయండి';

  @override
  String get procKiranaAiProcessing => 'Outlet AI ప్రాసెస్ చేస్తోంది…';

  @override
  String get procHeard => 'విన్నది';

  @override
  String get procNoItemsDetectedTryAgain =>
      'ఏ వస్తువులూ గుర్తించలేదు. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get procRecordAgain => 'మళ్లీ రికార్డ్ చేయండి';

  @override
  String procAddToCartCount(int count) {
    return '$count కార్ట్‌కు యాడ్ చేయండి';
  }

  @override
  String get procAutoDetectsLanguages =>
      'ఆటోమేటిక్‌గా గుర్తిస్తుంది: తెలుగు · హిందీ · ఉర్దూ · తమిళం · కన్నడ · మలయాళం · ఇంగ్లీష్';

  @override
  String get procInStock => 'స్టాక్‌లో ఉంది';

  @override
  String get procLowStock => 'స్టాక్ తక్కువ';

  @override
  String get procNotFound => 'దొరకలేదు';

  @override
  String get procPickFromInventory => 'ఇన్వెంటరీ నుండి ఎంచుకోండి';

  @override
  String procAddedToCartFromHandwriting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'లు',
      one: '',
    );
    return 'రాత నుండి $count వస్తువు$_temp0 కార్ట్‌కు యాడ్ అయ్యాయి';
  }

  @override
  String get procCanvasNotReady => 'క్యాన్వాస్ సిద్ధంగా లేదు';

  @override
  String get procFailedToCaptureCanvas =>
      'క్యాన్వాస్‌ను క్యాప్చర్ చేయడం విఫలమైంది';

  @override
  String get procHandwriteOrder => 'రాతతో ఆర్డర్';

  @override
  String get procWriteItemsAnyScript => 'ఏ లిపిలోనైనా వస్తువులను రాయండి';

  @override
  String get procDrawsLabel => 'డ్రాలు';

  @override
  String get procUndoLastStroke => 'చివరి స్ట్రోక్‌ను అన్‌డూ చేయండి';

  @override
  String get procClear => 'క్లియర్';

  @override
  String get procHandwriteOrderProFeature => 'రాతతో ఆర్డర్ Pro ఫీచర్.';

  @override
  String get procAutoDetectAfter5s => '5s తర్వాత ఆటోమేటిక్‌గా గుర్తించు';

  @override
  String get procWriteItemsHere => 'వస్తువులను ఇక్కడ రాయండి';

  @override
  String get procUpgradeOrTopUpToWrite =>
      'రాయడానికి అప్‌గ్రేడ్ చేయండి లేదా టాప్ అప్ చేయండి';

  @override
  String get procHandwriteExample => 'ఉదా. రైస్ 5kg, షుగర్ 2kg';

  @override
  String get procDetecting => 'గుర్తిస్తోంది…';

  @override
  String get procDetectItems => 'వస్తువులను గుర్తించండి';

  @override
  String get procRead => 'చదివింది';

  @override
  String get procNoItemsDetectedWriteClearly =>
      'ఏ వస్తువులూ గుర్తించలేదు. ఇంకా స్పష్టంగా రాయడానికి ప్రయత్నించండి.';

  @override
  String get procWriteAgain => 'మళ్లీ రాయండి';

  @override
  String get procAnyScriptLanguages =>
      'ఏ లిపిలోనైనా: English · తెలుగు · हिंदी · Tamil · ಕನ್ನಡ · മലയാളം';

  @override
  String procProductNumber(String id) {
    return 'ప్రొడక్ట్ #$id';
  }

  @override
  String get procReturnExchange => 'రిటర్న్ / ఎక్స్‌ఛేంజ్';

  @override
  String procOrderPickItemsToReturn(String id) {
    return 'ఆర్డర్ #$id · రిటర్న్ చేయాల్సిన వస్తువులను ఎంచుకోండి';
  }

  @override
  String get procRecordReturn => 'రిటర్న్ రికార్డ్ చేయండి';

  @override
  String get rackTitle => 'స్టాక్ ర్యాక్‌లు';

  @override
  String get rackPlaceStock => 'స్టాక్ ఉంచండి';

  @override
  String get rackSearchHint => 'ఉత్పత్తి లేదా ర్యాక్ వెతకండి (ఉదా. A1)';

  @override
  String get rackSaved => 'స్టాక్ ర్యాక్‌లో ఉంచబడింది';

  @override
  String get rackChangeQty => 'పరిమాణం మార్చండి';

  @override
  String get rackMove => 'మరో ర్యాక్‌కు తరలించండి';

  @override
  String get rackRemove => 'ర్యాక్ నుండి తీసివేయండి';

  @override
  String get rackRemoved => 'ర్యాక్ నుండి తీసివేయబడింది';

  @override
  String get rackMoved => 'కొత్త ర్యాక్‌కు తరలించబడింది';

  @override
  String get rackEmpty =>
      'ఇంకా ర్యాక్‌లు సెటప్ చేయలేదు. ఉత్పత్తిని ర్యాక్‌లో ఉంచడానికి \'స్టాక్ ఉంచండి\' నొక్కండి — తర్వాత దాన్ని త్వరగా కనుగొనవచ్చు.';

  @override
  String get rackNoMatch => 'మీ శోధనకు ఏ ఉత్పత్తి లేదా ర్యాక్ సరిపోలలేదు.';

  @override
  String get rackItems => 'వస్తువులు';

  @override
  String get rackProduct => 'ఉత్పత్తి';

  @override
  String get rackSelectProduct => 'ఉత్పత్తిని ఎంచుకోండి';

  @override
  String get rackPickProductFirst => 'ముందుగా ఉత్పత్తిని ఎంచుకోండి';

  @override
  String get rackNeedLabel => 'ర్యాక్ / బిన్ లేబుల్ నమోదు చేయండి';

  @override
  String get rackSaveFailed => 'సేవ్ చేయలేకపోయాము. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get rackLabel => 'ర్యాక్ / బిన్';

  @override
  String get rackLabelHint => 'ఉదా. A1, పై షెల్ఫ్, కోల్డ్ స్టోరేజ్';

  @override
  String get rackQuantity => 'ఈ ర్యాక్‌లో పరిమాణం';

  @override
  String get rackSave => 'సేవ్ చేయండి';

  @override
  String get rackLoadFailed =>
      'ర్యాక్‌లను లోడ్ చేయలేకపోయాము. మీ కనెక్షన్‌ను తనిఖీ చేయండి.';

  @override
  String get rackRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get rackLocation => 'ర్యాక్ స్థానం';

  @override
  String get rackSetLocation => 'ర్యాక్ స్థానాన్ని సెట్ చేయండి';

  @override
  String get rackNoneForProduct => 'ఇంకా ఏ ర్యాక్‌లోనూ ఉంచలేదు.';

  @override
  String get tutNext => 'తర్వాత';

  @override
  String get tutDone => 'అర్థమైంది';

  @override
  String get tutSkip => 'వదిలేయండి';

  @override
  String get tutTapHere => 'కొనసాగడానికి వెలుగుతున్న బటన్ నొక్కండి';

  @override
  String get tutDismiss => 'దాచు';

  @override
  String get tutChecklistTitle => 'మొదలుపెడదాం';

  @override
  String tutChecklistSubtitle(int done, int total) {
    return '$totalలో $done పూర్తి — ఏదైనా అడుగు నొక్కండి';
  }

  @override
  String get tutStepAddProduct => 'మీ మొదటి సరుకు జోడించండి';

  @override
  String get tutStepFirstSale => 'మీ మొదటి బిల్లు వేయండి';

  @override
  String get tutStepUdhaar => 'ఒక అప్పు రాయండి';

  @override
  String get tutStepReport => 'ఈరోజు వ్యాపారం చూడండి';

  @override
  String get tutStepLanguage => 'మీ భాష ఎంచుకోండి';

  @override
  String get tutWelcomeHomeTitle => 'హోమ్';

  @override
  String get tutWelcomeHomeBody =>
      'మీ రోజంతా ఒక్క చూపులో — అమ్మకాలు, లాభం, హెచ్చరికలు ఇక్కడ.';

  @override
  String get tutWelcomeKhataTitle => 'ఖాతా';

  @override
  String get tutWelcomeKhataBody =>
      'మీ అప్పుల పుస్తకం. ప్రతి అప్పు, వసూలు ఒకే చోట.';

  @override
  String get tutWelcomeBillingTitle => 'బిల్లింగ్ & స్టాక్';

  @override
  String get tutWelcomeBillingBody => 'బిల్లులు వేయడం, సరుకు చూసుకోవడం ఇక్కడ.';

  @override
  String get tutWelcomeVisionTitle => 'విజన్ AI';

  @override
  String get tutWelcomeVisionBody =>
      'కెమెరాతో స్టాక్ లెక్కించండి — షెల్ఫ్ స్కాన్ చేయండి, సరుకు లెక్కపెట్టండి.';

  @override
  String get tutWelcomeChecklistTitle => 'ఇక్కడ మొదలుపెట్టండి';

  @override
  String get tutWelcomeChecklistBody =>
      'దుకాణం సిద్ధం చేయడానికి ఐదు చిన్న అడుగులు. ఏదైనా నొక్కండి, కలిసి చేద్దాం.';

  @override
  String get tutReportTitle => 'ఈరోజు వ్యాపారం';

  @override
  String get tutReportBody =>
      'ఈరోజు ఏమి అమ్మారో, ఎంత సంపాదించారో ఈ కార్డు చూపిస్తుంది. ప్రతి సాయంత్రం చూడండి.';

  @override
  String get tutFsSearchTitle => 'సరుకు వెతకండి';

  @override
  String get tutFsSearchBody =>
      'ఇక్కడ సరుకు పేరు టైప్ చేసి, బిల్లులో చేర్చడానికి దాన్ని నొక్కండి.';

  @override
  String get tutFsCustomerTitle => 'కస్టమర్ జోడించండి';

  @override
  String get tutFsCustomerBody =>
      'కొంటున్న కస్టమర్‌ను ఎంచుకోవడానికి ఇక్కడ నొక్కండి — లేదా పేరు, ఫోన్‌తో కొత్తవారిని జోడించండి.';

  @override
  String get tutFsChargeTitle => 'డబ్బు తీసుకోండి';

  @override
  String get tutFsChargeBody =>
      'బిల్లు సిద్ధం. చెల్లింపు విధానం ఎంచుకుని బిల్లు ముగించడానికి ఇక్కడ నొక్కండి.';

  @override
  String get tutFsPaymentTitle => 'ఎలా చెల్లిస్తున్నారు?';

  @override
  String get tutFsPaymentBody =>
      'ఇప్పుడు నగదు — లేదా తర్వాత వసూలుకు అప్పు. అప్పు నేరుగా మీ ఖాతాలోకి వెళ్తుంది.';

  @override
  String get tutFsConfirmTitle => 'బిల్లు ముగించండి';

  @override
  String get tutFsConfirmBody => 'అమ్మకం పూర్తి చేయడానికి ఈ బటన్ నొక్కండి.';

  @override
  String get tutApFabTitle => 'సరుకు జోడించండి';

  @override
  String get tutApFabBody =>
      'మీ మొదటి సరుకును దుకాణంలో పెట్టడానికి + బటన్ నొక్కండి.';

  @override
  String get tutApSearchTitle => 'క్యాటలాగ్‌లో వెతకండి';

  @override
  String get tutApSearchBody =>
      'సరుకు పేరు టైప్ చేసి జాబితా నుండి ఎంచుకోండి — పేరు, ఫోటో, వివరాలు వాటంతటవే నిండుతాయి.';

  @override
  String get tutApPriceTitle => 'మీ అమ్మకపు ధర';

  @override
  String get tutApPriceBody => 'మీరు అమ్మే ధర రాయండి.';

  @override
  String get tutApStockTitle => 'ఎన్ని ఉన్నాయి?';

  @override
  String get tutApStockBody => 'ఇప్పుడు షెల్ఫ్‌లో ఎన్ని ఉన్నాయో రాయండి.';

  @override
  String get tutApSaveTitle => 'సేవ్ చేయండి';

  @override
  String get tutApSaveBody => 'సేవ్ నొక్కండి — సరుకు అమ్మకానికి సిద్ధం.';

  @override
  String get learnTitle => 'నేర్చుకోండి';

  @override
  String get learnSubtitle =>
      'యాప్ చూపించే చిన్న గైడ్‌లు. ఎప్పుడైనా మళ్లీ చూడండి.';

  @override
  String get learnReplayWelcome => 'యాప్ పర్యటన';

  @override
  String get learnFlowAddProduct => 'సరుకు ఎలా జోడించాలి';

  @override
  String get learnFlowFirstSale => 'బిల్లు ఎలా వేయాలి';

  @override
  String get learnReplay => 'చూపించు';

  @override
  String get learnShowTips => 'చిట్కాలు చూపించు';

  @override
  String get learnShowTipsDesc => 'మొదటిసారి తెరిచే స్క్రీన్‌లపై సహాయ చిట్కాలు';

  @override
  String get procExchangeInstead =>
      'ఎక్స్చేంజ్ (కస్టమర్ వేరే వస్తువు తీసుకుంటారు)';

  @override
  String get procRefundAmount => 'రీఫండ్ మొత్తం';

  @override
  String get fulTitle => 'అంచనాలు & రిటర్న్స్';

  @override
  String get fulTabEstimates => 'అంచనాలు';

  @override
  String get fulTabReturns => 'రిటర్న్స్';

  @override
  String get fulNoReturns =>
      'ఇంకా రిటర్న్స్ లేవు. కస్టమర్ ఏదైనా తిరిగి తెచ్చినప్పుడు, \'రిటర్న్ నమోదు చేయండి\' నొక్కి వారి ఆర్డర్‌ను ఎంచుకోండి.';

  @override
  String get fulLogReturn => 'రిటర్న్ నమోదు చేయండి';

  @override
  String get fulPickOrderTitle => 'ఏ ఆర్డర్ తిరిగి ఇవ్వబడుతోంది?';

  @override
  String get fulSearchOrders => 'ఆర్డర్ # లేదా కస్టమర్ ద్వారా వెతకండి';

  @override
  String get fulNoOrders => 'ఇటీవలి ఆర్డర్‌లు కనబడలేదు.';

  @override
  String get fulExchange => 'ఎక్స్చేంజ్';

  @override
  String get fulRefund => 'రీఫండ్';

  @override
  String get fulBackToShelf => 'షెల్ఫ్‌కు తిరిగి';

  @override
  String get fulToVendor => 'వెండర్‌కు';

  @override
  String get fulItems => 'వస్తువులు';

  @override
  String get fulLoadFailed =>
      'లోడ్ కాలేదు. దయచేసి మీ కనెక్షన్‌ను తనిఖీ చేయండి.';

  @override
  String get fulRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get estEmpty =>
      'ఇంకా అంచనాలు లేవు. కస్టమర్ కోసం కొటేషన్ సృష్టించండి — దాన్ని షేర్ చేసి తర్వాత అమ్మకంగా మార్చవచ్చు.';

  @override
  String get estNewEstimate => 'కొత్త అంచనా';

  @override
  String get estWalkIn => 'వాక్-ఇన్ కస్టమర్';

  @override
  String get estAddOneItem => 'కనీసం ఒక వస్తువును జోడించండి';

  @override
  String get estSaveFailed => 'సేవ్ చేయలేకపోయాము. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get estCustomerOptional => 'కస్టమర్ (ఐచ్ఛికం)';

  @override
  String get estSelectCustomer => 'కస్టమర్‌ను ఎంచుకోండి';

  @override
  String get estAddItem => 'వస్తువును జోడించండి';

  @override
  String get estValidUntil => 'వరకు చెల్లుతుంది';

  @override
  String get estNoExpiry => 'గడువు లేదు';

  @override
  String get estSaveEstimate => 'అంచనాను సేవ్ చేయండి';

  @override
  String get estItemName => 'వస్తువు పేరు';

  @override
  String get estPickFromCatalog => 'క్యాటలాగ్ నుండి ఎంచుకోండి';

  @override
  String get estQty => 'పరిమాణం';

  @override
  String get estUnitPrice => 'యూనిట్ ధర';

  @override
  String get estAddedToBill => 'బిల్లుకు జోడించబడింది';

  @override
  String get estSkippedNotInCatalog => 'దాటవేయబడింది (క్యాటలాగ్‌లో లేదు)';

  @override
  String get estShareHeading => 'అంచనా / కొటేషన్';

  @override
  String get estShareTotal => 'మొత్తం';

  @override
  String get estTotal => 'మొత్తం';

  @override
  String get estStatus => 'స్థితి';

  @override
  String get estStatusDraft => 'డ్రాఫ్ట్';

  @override
  String get estStatusSent => 'పంపబడింది';

  @override
  String get estStatusAccepted => 'ఆమోదించబడింది';

  @override
  String get estStatusRejected => 'తిరస్కరించబడింది';

  @override
  String get estShare => 'షేర్ చేయండి';

  @override
  String get estConvert => 'అమ్మకంగా మార్చండి';

  @override
  String get staffTitle => 'సిబ్బంది';

  @override
  String get staffTeamTab => 'బృందం & హాజరు';

  @override
  String get staffTasksTab => 'పనులు';

  @override
  String get staffNoStaff => 'ఇంకా సిబ్బంది లేరు. మీ బృందాన్ని జోడించండి.';

  @override
  String get staffAddStaff => 'సిబ్బందిని జోడించండి';

  @override
  String get staffNoTasks =>
      'ఇంకా పనులు లేవు. మీ బృందం కోసం పని లేదా చెక్‌లిస్ట్ అంశాన్ని జోడించండి.';

  @override
  String get staffAddTask => 'పనిని జోడించండి';

  @override
  String get jobTitle => 'జాబ్ కార్డులు';

  @override
  String get jobNewJob => 'కొత్త జాబ్';

  @override
  String get jobNewJobCard => 'కొత్త జాబ్ కార్డ్';

  @override
  String get jobRepair => 'రిపేర్';

  @override
  String get jobAlteration => 'మార్పు';

  @override
  String get jobPreorder => 'ప్రీ-ఆర్డర్';

  @override
  String get wtyIssue => 'సమస్య';

  @override
  String get wtySelectSerial => 'ఒక సీరియల్‌ను ఎంచుకోండి';

  @override
  String get wtyCreateClaim => 'క్లెయిమ్ సృష్టించండి';

  @override
  String get wtyNoClaims => 'వారంటీ క్లెయిమ్‌లు ఏవీ నమోదు కాలేదు.';

  @override
  String get wtyTitle => 'వారంటీ & సీరియల్స్';

  @override
  String get wtyTabClaims => 'క్లెయిమ్‌లు';

  @override
  String get wtyTabSerials => 'సీరియల్స్';

  @override
  String get wtyNewClaim => 'కొత్త క్లెయిమ్';

  @override
  String get wtyAddSerial => 'సీరియల్ జోడించండి';

  @override
  String get wtySearchSerials => 'సీరియల్ / IMEI లేదా ఉత్పత్తిని వెతకండి';

  @override
  String get wtyNoSerials =>
      'ఇంకా సీరియల్స్ నమోదు కాలేదు. చెక్అవుట్‌లో లేదా క్రింది బటన్‌తో సీరియల్స్ జోడించండి.';

  @override
  String get wtyAll => 'అన్నీ';

  @override
  String get wtyInStock => 'స్టాక్‌లో';

  @override
  String get wtySold => 'అమ్ముడైంది';

  @override
  String get wtyProduct => 'ఉత్పత్తి';

  @override
  String get wtySelectProduct => 'ఉత్పత్తిని ఎంచుకోండి';

  @override
  String get wtySerialImei => 'సీరియల్ / IMEI నంబర్';

  @override
  String get wtySoldOn => 'అమ్మిన తేదీ';

  @override
  String get wtyExpired => 'వారంటీ ముగిసింది';

  @override
  String get wtyExpires => 'ముగుస్తుంది';

  @override
  String get wtyWarrantyTill => 'వారంటీలో వరకు';

  @override
  String get wtyPickProduct => 'ముందుగా ఉత్పత్తిని ఎంచుకోండి';

  @override
  String get wtyEnterSerial => 'సీరియల్ / IMEI నమోదు చేయండి';

  @override
  String get wtySaveFailed => 'సేవ్ చేయలేకపోయాము. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get wtySave => 'సేవ్ చేయండి';

  @override
  String get staffComm => 'కమిషన్';

  @override
  String get staffEdit => 'సవరించండి';

  @override
  String get staffOrders30d => 'ఆర్డర్‌లు (30రో)';

  @override
  String get staffCommEarned => 'కమిషన్';

  @override
  String get staffEditMember => 'సిబ్బంది సభ్యుడిని సవరించండి';

  @override
  String get staffName => 'పేరు';

  @override
  String get staffPhoneOptional => 'ఫోన్ (ఐచ్ఛికం)';

  @override
  String get staffRoleOptional => 'పాత్ర (ఐచ్ఛికం)';

  @override
  String get staffCommissionField => 'కమిషన్';

  @override
  String get staffActive => 'యాక్టివ్';

  @override
  String get staffActiveHint =>
      'క్రియారహిత సిబ్బంది జాబితాలు మరియు బిల్లింగ్ నుండి దాచబడతారు.';

  @override
  String get staffSaveChanges => 'మార్పులను సేవ్ చేయండి';

  @override
  String get staffAssignedTo => 'కు కేటాయించబడింది';

  @override
  String get staffBilledBy => 'బిల్ చేసినవారు (ఐచ్ఛికం)';

  @override
  String get staffNotSet => 'సెట్ చేయలేదు';

  @override
  String get fulReturnsOnOrder => 'ఈ బిల్లుపై రిటర్న్స్';

  @override
  String procBoughtQty(String qty) {
    return 'కొన్నది $qty ';
  }

  @override
  String get procBackToShelf => 'షెల్ఫ్‌కు తిరిగి';

  @override
  String get procResaleable => 'మళ్లీ అమ్మదగినది';

  @override
  String get procDamagedToVendor => 'పాడైనది → వెండర్‌కు';

  @override
  String procReturnRecordedShelf(int count) {
    return 'రిటర్న్ రికార్డ్ అయింది — $count షెల్ఫ్‌కు తిరిగి';
  }

  @override
  String procReturnToVendorSuffix(int count) {
    return ', $count వెండర్‌కు';
  }

  @override
  String get procCouldNotRecordReturn => 'రిటర్న్ రికార్డ్ చేయలేకపోయాం';

  @override
  String get subYourInsights => 'మీ ఇన్‌సైట్స్';

  @override
  String get subError => 'ఎర్రర్';

  @override
  String get subManageKpis => 'KPIలు మేనేజ్ చేయండి';

  @override
  String get subManageSubscriptions => 'సబ్‌స్క్రిప్షన్‌లు మేనేజ్ చేయండి';

  @override
  String get subDone => 'పూర్తయింది';

  @override
  String subKpisSelected(int n) {
    return '$n KPIలు ఎంచుకున్నారు';
  }

  @override
  String get subSelectAll => 'అన్నీ ఎంచుకోండి';

  @override
  String get subClear => 'క్లియర్';

  @override
  String get subUnselect => 'తీసివేయండి';

  @override
  String subProKpiName(String name) {
    return 'Pro KPI: $name';
  }

  @override
  String get subConfirmSelections => 'ఎంపికలను నిర్ధారించండి';

  @override
  String get subNoActiveKpis => 'యాక్టివ్ KPIలు లేవు';

  @override
  String get subManageToSeeInsights =>
      'ఇన్‌సైట్స్ చూడటానికి మీ సబ్‌స్క్రిప్షన్‌లను మేనేజ్ చేయండి';

  @override
  String get subFailedLoadInsights => 'లైవ్ ఇన్‌సైట్స్ లోడ్ చేయడంలో విఫలమైంది';

  @override
  String get subManageInventory => 'ఇన్వెంటరీ మేనేజ్ చేయండి';

  @override
  String get subSendReminders => 'రిమైండర్‌లు పంపండి';

  @override
  String get subReminderMessage =>
      'నమస్తే, మీతో మా వ్యాపారానికి సంబంధించి ఇది ఒక రిమైండర్. దయచేసి మీ తాజా అప్‌డేట్‌లను చూడండి.';

  @override
  String get subNewSale => 'కొత్త అమ్మకం';

  @override
  String get subAiSummary => 'AI సారాంశం';

  @override
  String subPoweredBy(String agent) {
    return '$agent ద్వారా';
  }

  @override
  String get subTarget => 'టార్గెట్';

  @override
  String get subBaseline => 'బేస్‌లైన్';

  @override
  String get subLiveDataBreakdown => 'లైవ్ డేటా వివరణ';

  @override
  String get subMlInsights => 'MI ఇన్‌సైట్స్';

  @override
  String get subNoDynamicInsights =>
      'ఈ KPI కోసం డైనమిక్ ఇన్‌సైట్స్ అందుబాటులో లేవు.';

  @override
  String subPctVsLastPeriod(String pct) {
    return 'గత పీరియడ్‌తో పోలిస్తే $pct%';
  }

  @override
  String get subCurrent => 'ప్రస్తుతం';

  @override
  String get subWhyThisValue => 'ఈ విలువ ఎందుకు?';

  @override
  String get subSomethingWentWrong => 'అయ్యో! ఏదో తప్పు జరిగింది';

  @override
  String get subRetry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get subSubscriptionAndPlans => 'సబ్‌స్క్రిప్షన్ & ప్లాన్‌లు';

  @override
  String subErrorWithDetail(String detail) {
    return 'ఎర్రర్: $detail';
  }

  @override
  String get subCancelSubscriptionTitle => 'సబ్‌స్క్రిప్షన్ క్యాన్సిల్ చేయాలా?';

  @override
  String get subCancelSubscriptionBody =>
      'మీ సబ్‌స్క్రిప్షన్ వెంటనే క్యాన్సిల్ అవుతుంది. మీరు ఎప్పుడైనా మళ్లీ సబ్‌స్క్రైబ్ చేసుకోవచ్చు.';

  @override
  String get subKeepPlan => 'ప్లాన్ ఉంచండి';

  @override
  String get subCancelSubscription => 'సబ్‌స్క్రిప్షన్ క్యాన్సిల్ చేయండి';

  @override
  String get subSubscriptionCancelled => 'సబ్‌స్క్రిప్షన్ క్యాన్సిల్ అయింది.';

  @override
  String subCancelFailed(String detail) {
    return 'క్యాన్సిల్ విఫలమైంది: $detail';
  }

  @override
  String get subChooseYourPlan => 'మీ ప్లాన్ ఎంచుకోండి';

  @override
  String get subFeaturePosSales => 'POS & అమ్మకాల మేనేజ్‌మెంట్';

  @override
  String get subFeatureInventoryTracking => 'ఇన్వెంటరీ ట్రాకింగ్';

  @override
  String get subFeatureFinanceUdhaar => 'ఫైనాన్స్ & ఉధార్';

  @override
  String get subFeatureKpiInsights => 'KPI ఇన్‌సైట్స్ (కేటగిరీకి 3)';

  @override
  String get subFeatureCustomerRelations => 'కస్టమర్ రిలేషన్స్';

  @override
  String get subFeatureAiRecommendations => 'AI సిఫార్సులు';

  @override
  String get subFeatureAllKpiCategories => 'అన్ని KPI కేటగిరీలు (అపరిమితం)';

  @override
  String get subFeatureVendorProcurement =>
      'వెండర్ & ప్రొక్యూర్‌మెంట్ మేనేజ్‌మెంట్';

  @override
  String get subFeatureCashflowSupport => 'క్యాష్‌ఫ్లో సపోర్ట్ (₹10L వరకు)';

  @override
  String get subFeatureCustomerGrowth => 'కస్టమర్ గ్రోత్ ఇంజిన్';

  @override
  String get subPerMonth => '/నెల';

  @override
  String get subRestorePurchases => 'కొనుగోళ్లను రీస్టోర్ చేయండి';

  @override
  String get subNeedHelp => 'సహాయం కావాలా?';

  @override
  String get subReachWhatsApp =>
      'ప్లాన్ సందేహాలు లేదా బిల్లింగ్ సపోర్ట్ కోసం WhatsApp లో మమ్మల్ని సంప్రదించండి.';

  @override
  String get subWhatsAppSupport => 'WhatsApp సపోర్ట్';

  @override
  String get subWhatsAppHelpMessage =>
      'నమస్తే! నా Outlet AI సబ్‌స్క్రిప్షన్‌తో సహాయం కావాలి.';

  @override
  String subCurrentPlanLabel(String plan) {
    return 'ప్రస్తుతం: $plan';
  }

  @override
  String get subTimeRemaining => 'మిగిలిన సమయం: ';

  @override
  String get subBest => 'BEST';

  @override
  String subJustPerDay(String price) {
    return 'రోజుకు కేవలం $price';
  }

  @override
  String get subTrialPlanNotice =>
      'మీరు ఈ ప్లాన్ ఫ్రీ ట్రయల్‌లో ఉన్నారు. ట్రయల్ ముగిసిన తర్వాత యాక్సెస్ కొనసాగించడానికి అప్‌గ్రేడ్ చేయండి.';

  @override
  String get subCurrentPlan => 'ప్రస్తుత ప్లాన్';

  @override
  String subUpgradeToKeepAccess(String name) {
    return '$name యాక్సెస్ ఉంచుకోవడానికి అప్‌గ్రేడ్ చేయండి';
  }

  @override
  String subPayAndActivate(String name) {
    return '$name చెల్లించి యాక్టివేట్ చేయండి';
  }

  @override
  String get subPaywallFeatureEverythingBasic => 'Basic లో ఉన్నవన్నీ';

  @override
  String get subPaywallFeaturePriorityAi => 'ప్రాధాన్యత AI సిఫార్సులు';

  @override
  String get subProFeature => 'PRO ఫీచర్';

  @override
  String get subProPlanIncludes => 'Pro ప్లాన్‌లో ఉన్నవి:';

  @override
  String get subNotNow => 'ఇప్పుడు కాదు';

  @override
  String get subUpgradeToProPrice =>
      'Pro కి అప్‌గ్రేడ్ చేయండి  ₹500/నెల · రోజుకు కేవలం ₹17';

  @override
  String get subInvoicePack => 'ఇన్‌వాయిస్ ప్యాక్';

  @override
  String get subVoicePack => 'వాయిస్ ప్యాక్';

  @override
  String get subHandwritingPack => 'హ్యాండ్‌రైటింగ్ ప్యాక్';

  @override
  String get subInvoicePackDesc => 'మరో 10 సప్లయర్ బిల్లులను ప్రాసెస్ చేయండి';

  @override
  String get subVoicePackDesc => 'మరో 10 ఆడియో/వాయిస్ ఆర్డర్లు జోడించండి';

  @override
  String get subHandwritingPackDesc => 'మరో 10 చేతిరాత నోట్లను స్కాన్ చేయండి';

  @override
  String get subPrice => 'ధర';

  @override
  String get subCreditsRollOverDaily =>
      'క్రెడిట్స్ గడువు ముగియవు — ప్రతిరోజూ రోల్ ఓవర్ అవుతాయి.';

  @override
  String get subCancel => 'రద్దు చేయండి';

  @override
  String subPayAmount(int amount) {
    return '₹$amount చెల్లించండి';
  }

  @override
  String subCreditsAdded(int count, String name) {
    return '$count $name క్రెడిట్స్ జోడించబడ్డాయి!';
  }

  @override
  String get subTopUpCredits => 'మీ క్రెడిట్స్ టాప్ అప్ చేయండి';

  @override
  String get subCreditsNeverExpire =>
      'క్రెడిట్స్ ఎప్పటికీ గడువు ముగియవు — రేపటికి రోల్ ఓవర్ అవుతాయి!';

  @override
  String subCreditsCount(int count) {
    return '$count క్రెడిట్స్';
  }

  @override
  String get subBuy => 'కొనండి';

  @override
  String get subTrialExpiredMessage =>
      'మీ ఫ్రీ ట్రయల్ గడువు ముగిసింది. కొనసాగించడానికి అప్‌గ్రేడ్ చేయండి.';

  @override
  String get subTrialLastDayMessage =>
      'మీ ఫ్రీ ట్రయల్ చివరి రోజు! ఇప్పుడే అప్‌గ్రేడ్ చేయండి.';

  @override
  String subTrialDaysLeftMessage(int n) {
    return 'మీ ట్రయల్‌లో $n రోజులు మిగిలాయి. Basic లేదా Pro కి అప్‌గ్రేడ్ చేయండి.';
  }

  @override
  String get subTrialExpiringSoon => 'ట్రయల్ త్వరలో ముగుస్తుంది';

  @override
  String get subTrialExpiredTitle => 'ట్రయల్ ముగిసింది';

  @override
  String get mktMyBaskets => 'నా బాస్కెట్‌లు';

  @override
  String get mktCouldNotLoadBaskets => 'బాస్కెట్‌లు లోడ్ చేయలేకపోయాం';

  @override
  String get mktPullDownToRetry => 'మళ్లీ ప్రయత్నించడానికి కిందికి లాగండి';

  @override
  String get mktRetry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get mktNewBasket => 'కొత్త బాస్కెట్';

  @override
  String get mktNoBasketsYet => 'ఇంకా బాస్కెట్‌లు లేవు';

  @override
  String get mktBasketsEmptySubtitle =>
      'కాంబో డీల్స్, బండిల్ ఆఫర్లు తయారు చేయండి.\nWhatsApp ద్వారా మీ కస్టమర్లందరికీ అలర్ట్ పంపండి.';

  @override
  String get mktCreateFirstBasket => 'మొదటి బాస్కెట్ తయారు చేయండి';

  @override
  String get mktDeleteBasketTitle => 'బాస్కెట్ తొలగించాలా?';

  @override
  String mktDeleteBasketConfirm(String name) {
    return '\"$name\" తొలగించాలా? ఇది తిరిగి తేలేం.';
  }

  @override
  String get mktCancel => 'రద్దు';

  @override
  String get mktBasketDeleted => 'బాస్కెట్ తొలగించబడింది';

  @override
  String get mktCouldNotDeleteBasket =>
      'బాస్కెట్ తొలగించలేకపోయాం. మళ్లీ ప్రయత్నించండి.';

  @override
  String get mktDelete => 'తొలగించు';

  @override
  String get mktSendWhatsAppAlertTitle => 'WhatsApp అలర్ట్ పంపాలా?';

  @override
  String mktSendWhatsAppAlertConfirm(String name) {
    return '\"$name\" బాస్కెట్ డీల్‌ను WhatsApp ద్వారా మీ కస్టమర్లందరికీ పంపాలా?';
  }

  @override
  String get mktSend => 'పంపు';

  @override
  String mktWhatsAppAlertSent(int sent, int total) {
    return '$total కస్టమర్లలో $sent మందికి WhatsApp అలర్ట్ పంపబడింది!';
  }

  @override
  String get mktNoCustomersWithPhone =>
      'ఫోన్ నంబర్లున్న కస్టమర్లు ఎవరూ కనిపించలేదు.';

  @override
  String mktWhatsAppNotActiveYet(int total) {
    return 'WhatsApp ఇంకా యాక్టివ్ కాలేదు. యాక్టివ్ అయిన తర్వాత $total కస్టమర్లకు అలర్ట్ ఆటోమేటిక్‌గా వెళ్తుంది.';
  }

  @override
  String mktAlertFailed(String error) {
    return 'విఫలమైంది: $error';
  }

  @override
  String get mktExpired => 'గడువు ముగిసింది';

  @override
  String get mktItem => 'ఐటెం';

  @override
  String mktFromDate(String date) {
    return '$date నుండి';
  }

  @override
  String mktToDate(String date) {
    return '$date వరకు';
  }

  @override
  String get mktAlertCustomers => 'కస్టమర్లకు అలర్ట్';

  @override
  String get mktNoProductsInInventory =>
      'ఇన్వెంటరీలో ప్రొడక్ట్‌లు లేవు. ముందుగా POS సింక్ చేయండి.';

  @override
  String get mktAllProductsAdded =>
      'అన్ని ప్రొడక్ట్‌లు ఇప్పటికే ఈ బాస్కెట్‌కి జోడించారు';

  @override
  String get mktBasketNameRequired => 'బాస్కెట్ పేరు తప్పనిసరి';

  @override
  String get mktAddAtLeastOneProduct =>
      'ఇన్వెంటరీ నుండి కనీసం ఒక ప్రొడక్ట్ జోడించండి';

  @override
  String get mktSave => 'సేవ్';

  @override
  String get mktBasketNameLabel => 'బాస్కెట్ పేరు *';

  @override
  String get mktBasketNameHint => 'ఉదా. బ్రేక్‌ఫాస్ట్ బండిల్';

  @override
  String get mktDescriptionOptional => 'వివరణ (ఐచ్ఛికం)';

  @override
  String get mktDescriptionHint => 'ఉదా. పాలు + బ్రెడ్ + గుడ్లు';

  @override
  String get mktBundlePriceOptional => 'బండిల్ ధర (ఐచ్ఛికం)';

  @override
  String get mktValidity => 'చెల్లుబాటు';

  @override
  String get mktFromDateLabel => 'నుండి తేదీ';

  @override
  String get mktToDateLabel => 'వరకు తేదీ';

  @override
  String get mktProducts => 'ప్రొడక్ట్‌లు';

  @override
  String get mktAddProduct => 'ప్రొడక్ట్ జోడించు';

  @override
  String get mktTapToPickProducts =>
      'మీ ఇన్వెంటరీ నుండి ప్రొడక్ట్‌లు ఎంచుకోవడానికి టాప్ చేయండి';

  @override
  String mktPricePerUnit(String price) {
    return '₹$price / యూనిట్';
  }

  @override
  String get mktQty => 'పరిమాణం';

  @override
  String get mktCreateBasket => 'బాస్కెట్ తయారు చేయి';

  @override
  String get mktSelectProduct => 'ప్రొడక్ట్ ఎంచుకోండి';

  @override
  String get mktSearchProducts => 'ప్రొడక్ట్‌లు వెతకండి...';

  @override
  String get mktNoProductsFound => 'ప్రొడక్ట్‌లు ఏవీ కనిపించలేదు';

  @override
  String get mktAdd => 'జోడించు';

  @override
  String get mktEstTotal => 'అంచనా మొత్తం';

  @override
  String get mktAddAll => 'అన్నీ జోడించు';

  @override
  String get mktNotInStock => 'స్టాక్‌లో లేదు';

  @override
  String mktCampaignItemStock(String qty, String unit, String price) {
    return 'స్టాక్: $qty $unit  ·  ₹$price';
  }

  @override
  String get mktEstimatedTotal => 'అంచనా మొత్తం';

  @override
  String get mktNoItemsInStock => 'స్టాక్‌లో ఐటెంలు లేవు';

  @override
  String mktAddAvailableItemsToCart(int count) {
    return 'అందుబాటులో ఉన్న $count ఐటెంలను కార్ట్‌కి జోడించు';
  }

  @override
  String get mktAreaAssociations => 'ఏరియా అసోసియేషన్‌లు';

  @override
  String get mktMyAreas => 'నా ఏరియాలు';

  @override
  String get mktCustomerHeatmap => 'కస్టమర్ హీట్‌మ్యాప్';

  @override
  String mktErrorWithMessage(String error) {
    return 'ఎర్రర్: $error';
  }

  @override
  String get mktNoAreasAddedYet => 'ఇంకా ఏరియాలు జోడించలేదు';

  @override
  String get mktAreasEmptySubtitle =>
      'టార్గెటెడ్ క్యాంపెయిన్ సూచనలు పొందడానికి దగ్గర్లోని అపార్ట్‌మెంట్లు, హాస్టళ్లు, స్కూళ్లు లేదా ఆఫీసులను జోడించండి.';

  @override
  String get mktAddFirstArea => 'మొదటి ఏరియా జోడించు';

  @override
  String get mktRemoveAreaTitle => 'ఏరియా తీసివేయాలా?';

  @override
  String mktRemoveAreaConfirm(String name) {
    return '\"$name\"ని మీ అసోసియేషన్‌ల నుండి తీసివేయాలా?';
  }

  @override
  String get mktRemove => 'తీసివేయి';

  @override
  String mktHouseholdsCount(int count) {
    return '~$count ఇళ్లు';
  }

  @override
  String get mktNoHeatmapDataYet => 'ఇంకా హీట్‌మ్యాప్ డేటా లేదు';

  @override
  String get mktHeatmapEmptySubtitle =>
      'ఏరియాలు జోడించి కస్టమర్లను ఆ ఏరియాలకు ట్యాగ్ చేయండి. ఆదాయ డేటా కాలక్రమేణా ఇక్కడ కనిపిస్తుంది.';

  @override
  String get mktLast90DaysByRevenue => 'గత 90 రోజులు · ఆదాయం ప్రకారం';

  @override
  String get mktCustomers => 'కస్టమర్లు';

  @override
  String get mktOrders => 'ఆర్డర్లు';

  @override
  String get mktAvgOrder => 'సగటు ఆర్డర్';

  @override
  String get mktNoOrdersYetTagCustomers =>
      'ఇంకా ఆర్డర్లు లేవు — ట్రాక్ చేయడానికి కస్టమర్లను ఈ ఏరియాకు ట్యాగ్ చేయండి';

  @override
  String get mktAddNearbyArea => 'దగ్గర్లోని ఏరియా జోడించు';

  @override
  String get mktAreaType => 'ఏరియా రకం';

  @override
  String get mktAreaNameLabel => 'పేరు (ఉదా. ప్రెస్టీజ్ అపార్ట్‌మెంట్స్)';

  @override
  String get mktEstimatedHouseholdsOptional => 'అంచనా ఇళ్ల సంఖ్య (ఐచ్ఛికం)';

  @override
  String get mktNotesOptional => 'నోట్స్ (ఐచ్ఛికం)';

  @override
  String get mktAddArea => 'ఏరియా జోడించు';

  @override
  String get mktCustomerGrowth => 'కస్టమర్ గ్రోత్';

  @override
  String get mktNewCampaign => 'కొత్త క్యాంపెయిన్';

  @override
  String get mktNoCampaignsYet => 'ఇంకా క్యాంపెయిన్‌లు లేవు';

  @override
  String get mktReferralEmptySubtitle =>
      'మీ ప్రస్తుత కస్టమర్లు కొత్తవారిని తీసుకురావడానికి ఒక రెఫరల్ క్యాంపెయిన్ తయారు చేయండి — దానికి వారికి రివార్డ్ ఇవ్వండి.';

  @override
  String get mktCreateFirstCampaign => 'మొదటి క్యాంపెయిన్ తయారు చేయి';

  @override
  String get mktReferralHowItWorks =>
      'కస్టమర్లు తమ QRను స్నేహితులతో షేర్ చేస్తారు. కొత్త వచ్చేవారు POSలో దాన్ని స్కాన్ చేసి డిస్కౌంట్ పొందుతారు — రెఫర్ చేసినవారు మైల్‌స్టోన్ రివార్డ్‌లు పొందుతారు.';

  @override
  String mktCampaignSummary(String discount, String reward, int n) {
    return 'కొత్త కస్టమర్లకు $discount% ఆఫ్  •  ప్రతి $n రెఫ్‌లకు $reward% రివార్డ్';
  }

  @override
  String get mktQrCodes => 'QR కోడ్‌లు';

  @override
  String get mktReferrals => 'రెఫరల్‌లు';

  @override
  String get mktMaxPerPerson => 'గరిష్టం/వ్యక్తి';

  @override
  String get mktGenerateQr => 'QR జనరేట్ చేయి';

  @override
  String mktGenerateQrTitle(String name) {
    return 'QR జనరేట్ చేయి · $name';
  }

  @override
  String get mktSearchCustomer => 'కస్టమర్‌ను వెతకండి…';

  @override
  String get mktNoCustomersFound => 'కస్టమర్లు ఎవరూ కనిపించలేదు';

  @override
  String get mktNoPhoneForCustomer => 'ఈ కస్టమర్‌కి ఫోన్ నంబర్ లేదు';

  @override
  String mktReferralWhatsAppMessage(
    String name,
    String code,
    String discount,
    int n,
  ) {
    return 'హాయ్ $name! 🎁\n\nమా షాప్‌ను మీ స్నేహితులతో షేర్ చేయడానికి మీకు ఆహ్వానం!\n\nమీ రెఫరల్ కోడ్: $code\n\nమీ స్నేహితుడు మా షాప్‌కి వచ్చి ఈ కోడ్ చూపిస్తే, వారికి $discount% ఆఫ్ — మీరు తీసుకొచ్చే ప్రతి $n స్నేహితులకు మీకు రివార్డ్‌లు వస్తాయి! 🙌\n\n— LohiyaAI Kirana ద్వారా';
  }

  @override
  String get mktWhatsAppNotInstalled =>
      'ఈ డివైజ్‌లో WhatsApp ఇన్‌స్టాల్ చేయలేదు';

  @override
  String get mktReferralQrCode => 'రెఫరల్ QR కోడ్';

  @override
  String mktPercentOffForNewCustomers(String discount) {
    return 'కొత్త కస్టమర్లకు $discount% ఆఫ్';
  }

  @override
  String mktMilestoneRewardLabel(String reward, int n) {
    return 'మైల్‌స్టోన్ రివార్డ్: ప్రతి $n రెఫరల్‌లకు $reward%';
  }

  @override
  String get mktReferralCodeCopied => 'రెఫరల్ కోడ్ కాపీ అయింది';

  @override
  String get mktSendViaWhatsApp => 'WhatsApp ద్వారా పంపు';

  @override
  String get mktQrScreenshotHint =>
      'లేదా ఈ QR స్క్రీన్‌ను నేరుగా కస్టమర్‌కి చూపించి స్క్రీన్‌షాట్ తీయించండి.';

  @override
  String get mktInvalidQrCode => 'చెల్లని QR కోడ్';

  @override
  String get mktCampaignNoLongerActive =>
      'ఈ రెఫరల్ క్యాంపెయిన్ ఇక యాక్టివ్‌గా లేదు';

  @override
  String get mktCouldNotLoadReferralInfo => 'రెఫరల్ సమాచారం లోడ్ చేయలేకపోయాం';

  @override
  String get mktEnterValidPhone => 'సరైన 10-అంకెల ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get mktClose => 'మూసివేయి';

  @override
  String mktReferralFrom(String name) {
    return '$name నుండి రెఫరల్';
  }

  @override
  String mktCampaignDiscountForNewCustomer(String campaign, String discount) {
    return '$campaign  •  కొత్త కస్టమర్‌కి $discount% డిస్కౌంట్';
  }

  @override
  String get mktNewCustomerDetails => 'కొత్త కస్టమర్ వివరాలు';

  @override
  String get mktNewCustomerPhoneHelper =>
      'కొత్త కస్టమర్ ఫోన్ నమోదు చేయండి. మీరు ఆర్డర్ పెట్టినప్పుడు డిస్కౌంట్ వర్తిస్తుంది.';

  @override
  String get mktPhoneNumber => 'ఫోన్ నంబర్';

  @override
  String get mktCustomerNameOptional => 'కస్టమర్ పేరు (ఐచ్ఛికం)';

  @override
  String get mktCustomerNameHint => 'ఉదా. జ్ఞాన్ కుమార్';

  @override
  String mktApplyReferralDiscount(String discount) {
    return '$discount% రెఫరల్ డిస్కౌంట్ వర్తింపజేయి';
  }

  @override
  String get mktCampaignNameRequired => 'క్యాంపెయిన్ పేరు తప్పనిసరి';

  @override
  String get mktEnterValidDiscount => 'సరైన డిస్కౌంట్ % నమోదు చేయండి (1–100)';

  @override
  String get mktMilestoneCountMin => 'మైల్‌స్టోన్ కౌంట్ కనీసం 1 ఉండాలి';

  @override
  String get mktEnterValidReward => 'సరైన రివార్డ్ % నమోదు చేయండి (1–100)';

  @override
  String get mktMaxReferralsMin => 'గరిష్ట రెఫరల్‌లు కనీసం 1 ఉండాలి';

  @override
  String get mktFailedToCreateCampaign =>
      'క్యాంపెయిన్ తయారు చేయడం విఫలమైంది. మళ్లీ ప్రయత్నించండి.';

  @override
  String get mktNewReferralCampaign => 'కొత్త రెఫరల్ క్యాంపెయిన్';

  @override
  String get mktCampaignName => 'క్యాంపెయిన్ పేరు';

  @override
  String get mktCampaignNameHint => 'ఉదా. సమ్మర్ రెఫరల్ డ్రైవ్';

  @override
  String get mktNewCustomerDiscountPct => 'కొత్త కస్టమర్ డిస్కౌంట్ %';

  @override
  String get mktMilestoneRewardPct => 'మైల్‌స్టోన్ రివార్డ్ %';

  @override
  String get mktRewardEveryNReferrals => 'ప్రతి N రెఫరల్‌లకు రివార్డ్';

  @override
  String get mktRewardEveryNHelper =>
      'రెఫర్ చేసేవారు తీసుకొచ్చే ప్రతి N కొత్త కస్టమర్లకు ఒక మైల్‌స్టోన్ రివార్డ్ పొందుతారు';

  @override
  String get mktMaxReferralsPerCustomer => 'ఒక్కో కస్టమర్‌కి గరిష్ట రెఫరల్‌లు';

  @override
  String get mktMaxReferralsHelper =>
      'ఇన్ని విజయవంతమైన రెఫరల్‌ల తర్వాత కస్టమర్‌కి రివార్డ్ ఇవ్వడం ఆపండి';

  @override
  String get mktCreateCampaign => 'క్యాంపెయిన్ తయారు చేయి';

  @override
  String get profProfile => 'ప్రొఫైల్';

  @override
  String profErrorLoadingProfile(String error) {
    return 'ప్రొఫైల్ లోడ్ చేయడంలో పొరపాటు: $error';
  }

  @override
  String get profNoUserData => 'యూజర్ డేటా ఏదీ దొరకలేదు.';

  @override
  String get profCashflowSupport => 'క్యాష్‌ఫ్లో సపోర్ట్';

  @override
  String get profCashflowSupportDesc =>
      'మీకు తగిన చెల్లింపు ప్లాన్‌లతో ₹50K – ₹10L బిజినెస్ ఫైనాన్స్ కోసం అప్లై చేయండి.';

  @override
  String get profCashflowBannerSubtitle =>
      '₹50K – ₹10L బిజినెస్ ఫైనాన్స్ కోసం అప్లై చేయండి';

  @override
  String get profSectionCustomers => 'కస్టమర్లు';

  @override
  String get profSectionAnalytics => 'అనలిటిక్స్';

  @override
  String get profSectionOperations => 'కార్యకలాపాలు';

  @override
  String get profSectionSalesMarketing => 'అమ్మకాలు & మార్కెటింగ్';

  @override
  String get profSectionStoreAccount => 'స్టోర్ & అకౌంట్';

  @override
  String get profSectionPlanSupport => 'ప్లాన్ & సపోర్ట్';

  @override
  String get profSectionAdmin => 'అడ్మిన్';

  @override
  String get profCustomerGrowth => 'కస్టమర్ గ్రోత్';

  @override
  String get profCustomerGrowthDesc =>
      'రిఫరల్ ఇంజిన్ తయారు చేయండి — మీ సంతోషంగా ఉన్న కస్టమర్లు కొత్తవారిని వాళ్లే తీసుకొచ్చేలా చేయండి.';

  @override
  String get profCustomerRelations => 'కస్టమర్ రిలేషన్స్';

  @override
  String get profAreaAssociations => 'ఏరియా అసోసియేషన్లు';

  @override
  String get profKpiSubscriptions => 'KPI సబ్‌స్క్రిప్షన్లు';

  @override
  String get profTransactionHistory => 'ట్రాన్సాక్షన్ హిస్టరీ';

  @override
  String get profMyBaskets => 'నా బాస్కెట్‌లు';

  @override
  String get profLoyalty => 'లాయల్టీ & ఆఫర్‌లు';

  @override
  String get profServices => 'సేవలు & అపాయింట్‌మెంట్‌లు';

  @override
  String get profStoreComparison => 'స్టోర్ పోలిక';

  @override
  String get profStaff => 'సిబ్బంది';

  @override
  String get profEstimatesReturns => 'అంచనాలు & రిటర్న్‌లు';

  @override
  String get profStockRacks => 'స్టాక్ ర్యాక్‌లు';

  @override
  String get profJobCards => 'జాబ్ కార్డ్‌లు';

  @override
  String get profWarranty => 'వారంటీ & సీరియల్‌లు';

  @override
  String get profGstReport => 'జీఎస్‌టీ నివేదిక';

  @override
  String get profLanguage => 'భాష';

  @override
  String get profStoreSettings => 'స్టోర్ సెట్టింగ్‌లు';

  @override
  String get profSwitchStore => 'స్టోర్ మార్చు / జోడించు';

  @override
  String get profConfiguration => 'కాన్ఫిగరేషన్';

  @override
  String get profPasswordSecurity => 'పాస్‌వర్డ్ & సెక్యూరిటీ';

  @override
  String get profSubscriptionPlans => 'సబ్‌స్క్రిప్షన్ & ప్లాన్‌లు';

  @override
  String get profHelpSupport => 'హెల్ప్ & సపోర్ట్';

  @override
  String get profUserActivity => 'యూజర్ యాక్టివిటీ';

  @override
  String get profSignOut => 'సైన్ అవుట్';

  @override
  String get profTrialExpired => 'ట్రయల్ ముగిసింది';

  @override
  String get profAwaitingActivation => 'యాక్టివేషన్ కోసం వేచి ఉంది';

  @override
  String get profProTrial => 'ప్రో ట్రయల్';

  @override
  String get profBasicTrial => 'బేసిక్ ట్రయల్';

  @override
  String profTrialDaysLeft(String tier, int days) {
    return '$tier · ${days}d మిగిలింది';
  }

  @override
  String profTrialActive(String tier) {
    return '$tier యాక్టివ్';
  }

  @override
  String get profBasicPlan => 'బేసిక్ ప్లాన్';

  @override
  String get profProPlan => 'ప్రో ప్లాన్';

  @override
  String get profSyncContacts => 'కాంటాక్ట్‌లు సింక్ చేయండి';

  @override
  String get profRefreshList => 'లిస్ట్ రిఫ్రెష్ చేయండి';

  @override
  String get profAddCustomer => 'కస్టమర్‌ను జోడించండి';

  @override
  String get profSearchByNameOrPhone => 'పేరు లేదా ఫోన్‌తో వెతకండి...';

  @override
  String get profRetry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String profNoSegmentCustomers(String segment) {
    return '$segment కస్టమర్లు ఎవరూ లేరు';
  }

  @override
  String get profNoCustomersFound => 'కస్టమర్లు ఎవరూ దొరకలేదు.';

  @override
  String get profSegRegular => 'రెగ్యులర్';

  @override
  String get profSegOccasional => 'అప్పుడప్పుడు';

  @override
  String get profSegImpulse => 'ఇంపల్స్';

  @override
  String get profSegBulk => 'బల్క్';

  @override
  String get profSegCredit => 'క్రెడిట్';

  @override
  String get profSegInactive => 'ఇన్‌యాక్టివ్';

  @override
  String get profSyncContactsTitle => 'కాంటాక్ట్‌లు సింక్ చేయాలా?';

  @override
  String get profSyncContactsBody =>
      'ఇది మీ ఫోన్ కాంటాక్ట్‌లను మీ కస్టమర్ లిస్ట్‌లోకి తీసుకొస్తుంది. రెగ్యులర్ కస్టమర్లను ఫోన్ నంబర్‌తో మ్యాచ్ చేస్తుంది.';

  @override
  String get profCancel => 'క్యాన్సిల్';

  @override
  String get profSyncNow => 'ఇప్పుడే సింక్ చేయండి';

  @override
  String profSyncedContacts(int count) {
    return '$count కాంటాక్ట్‌లు సక్సెస్‌ఫుల్‌గా సింక్ అయ్యాయి!';
  }

  @override
  String profSyncFailed(String error) {
    return 'సింక్ ఫెయిల్ అయ్యింది: $error';
  }

  @override
  String get profSendWhatsappReengagement => 'WhatsApp రీ-ఎంగేజ్‌మెంట్ పంపండి';

  @override
  String profWhatsappReengagementMessage(String name) {
    return 'హాయ్ $name! మీరు మా స్టోర్‌కి రాకపోవడం మిస్ అవుతున్నాం. మీరు చివరిసారి వచ్చి చాలా రోజులైంది, మీ కోసం తాజా స్టాక్, మంచి ఆఫర్‌లు సిద్ధంగా ఉన్నాయి. త్వరగా రండి — మీకు ఇష్టమైన వస్తువులు రెడీగా ఉన్నాయి! త్వరలో కలుద్దాం!';
  }

  @override
  String get profAddNewCustomer => 'కొత్త కస్టమర్‌ను జోడించండి';

  @override
  String get profEditCustomer => 'కస్టమర్‌ను ఎడిట్ చేయండి';

  @override
  String get profFullName => 'పూర్తి పేరు';

  @override
  String get profPhoneNumber => 'ఫోన్ నంబర్';

  @override
  String get profEmailAddressOptional => 'ఈమెయిల్ అడ్రస్ (ఆప్షనల్)';

  @override
  String get profHouseholdSize => 'ఇంట్లో మనుషుల సంఖ్య';

  @override
  String get profBirthdayOptional => 'పుట్టినరోజు (ఐచ్ఛికం)';

  @override
  String get profAnniversaryOptional => 'వార్షికోత్సవం (ఐచ్ఛికం)';

  @override
  String get profSaveCustomer => 'కస్టమర్‌ను సేవ్ చేయండి';

  @override
  String get profFillNameAndPhone => 'దయచేసి పేరు, ఫోన్ నింపండి';

  @override
  String get profEnterValidPhone =>
      'సరైన ఫోన్ నంబర్ ఎంటర్ చేయండి (అంకెలు మాత్రమే)';

  @override
  String get profCustomerSaved => 'కస్టమర్ సక్సెస్‌ఫుల్‌గా సేవ్ అయ్యారు';

  @override
  String get profLoading => 'లోడ్ అవుతోంది...';

  @override
  String get profCustomerDetails => 'కస్టమర్ వివరాలు';

  @override
  String get profStatBalance => 'బ్యాలెన్స్';

  @override
  String get profStatSpent => 'ఖర్చు';

  @override
  String get profStatOrders => 'ఆర్డర్లు';

  @override
  String get profCustomerInfo => 'కస్టమర్ సమాచారం';

  @override
  String profMembersCount(int count) {
    return '$count మంది';
  }

  @override
  String get profJoinedOn => 'చేరిన తేదీ';

  @override
  String get profUnknown => 'తెలియదు';

  @override
  String get profPurchaseHistory => 'కొనుగోలు హిస్టరీ';

  @override
  String get profNoOrdersForCustomer => 'ఈ కస్టమర్‌కి ఆర్డర్లు ఏవీ లేవు.';

  @override
  String profErrorLoadingOrders(String error) {
    return 'ఆర్డర్లు లోడ్ చేయడంలో పొరపాటు: $error';
  }

  @override
  String get profDeleteCustomerTitle => 'కస్టమర్‌ను తీసేయాలా?';

  @override
  String profDeleteCustomerBody(String name) {
    return 'మీరు నిజంగా $nameను తీసేయాలనుకుంటున్నారా? ఈ చర్యను తిరిగి తీసుకోలేరు.';
  }

  @override
  String get profDelete => 'డిలీట్';

  @override
  String profFailedToUpdateArea(String error) {
    return 'ఏరియా అప్‌డేట్ చేయడం ఫెయిల్ అయ్యింది: $error';
  }

  @override
  String get profAreaAssociation => 'ఏరియా / అసోసియేషన్';

  @override
  String get profAddNewArea => 'కొత్త ఏరియా జోడించండి…';

  @override
  String get profUnableToLoadAreas => 'ఏరియాలు లోడ్ చేయలేకపోయాం';

  @override
  String get profNoAreasTapToAdd => 'ఏరియాలు లేవు — జోడించడానికి టాప్ చేయండి';

  @override
  String get profNone => 'ఏదీ లేదు';

  @override
  String profOrderNumber(String id) {
    return 'ఆర్డర్ #$id';
  }

  @override
  String get profSave => 'సేవ్';

  @override
  String profError(String error) {
    return 'పొరపాటు: $error';
  }

  @override
  String get profBasicInformation => 'ప్రాథమిక సమాచారం';

  @override
  String get profStoreName => 'స్టోర్ పేరు';

  @override
  String get profStoreType => 'స్టోర్ రకం (ఉదా. కిరాణా, సూపర్‌మార్కెట్)';

  @override
  String get profBusinessIntelligence => 'బిజినెస్ ఇంటెలిజెన్స్';

  @override
  String get profFootfallAutoComputed =>
      'సగటు ఫుట్‌ఫాల్ మీ సేల్స్ ఆధారంగా ఆటోమేటిక్‌గా లెక్కించబడుతుంది.';

  @override
  String get profProvideInitialValues =>
      'మా AI మీ బిజినెస్‌ను ఆప్టిమైజ్ చేయడానికి సహాయపడేలా మొదటి విలువలను ఇవ్వండి.';

  @override
  String get profAvgDailyFootfall => 'రోజువారీ సగటు ఫుట్‌ఫాల్';

  @override
  String get profAiAutoUpdating => 'AI ఆటో-అప్‌డేటింగ్';

  @override
  String get profMonthlyStockBudget => 'నెలవారీ స్టాక్ బడ్జెట్';

  @override
  String get profDailyExpenseBuffer => 'రోజువారీ ఖర్చు బఫర్';

  @override
  String get profLocationDetails => 'లొకేషన్ వివరాలు';

  @override
  String get profCityArea => 'సిటీ / ఏరియా';

  @override
  String get profStateRegion => 'రాష్ట్రం / రీజియన్';

  @override
  String get profCity => 'నగరం';

  @override
  String get profBusinessVertical => 'వ్యాపార విభాగం';

  @override
  String get profRequired => 'తప్పనిసరి';

  @override
  String get profSettingsSaved => 'సెట్టింగ్‌లు సక్సెస్‌ఫుల్‌గా సేవ్ అయ్యాయి!';

  @override
  String profFailedToSave(String error) {
    return 'సేవ్ చేయడం ఫెయిల్ అయ్యింది: $error';
  }

  @override
  String get supSplashTagline => 'స్మార్ట్ వ్యాపారం, మరింత స్మార్ట్ మీరు';

  @override
  String get supBlockedAppTitle => 'యాప్ తాత్కాలికంగా అందుబాటులో లేదు';

  @override
  String get supBlockedStoreTitle => 'స్టోర్ తాత్కాలికంగా అందుబాటులో లేదు';

  @override
  String get supBlockedBody =>
      'దీనిని వీలైనంత త్వరగా పరిష్కరించడానికి మేము పని చేస్తున్నాం. మీకు వెంటనే సహాయం కావాలంటే, కింది బటన్‌ను నొక్కండి.';

  @override
  String get supBlockedContactUs => 'మమ్మల్ని సంప్రదించండి';

  @override
  String get supBlockedEmailSubjectApp => 'యాప్ యాక్సెస్ సమస్య — Outlet AI';

  @override
  String get supBlockedEmailSubjectStore => 'స్టోర్ యాక్సెస్ సమస్య — Outlet AI';

  @override
  String supBlockedEmailBody(String reason) {
    return 'హలో LohiyaAI టీమ్,\n\nనేను Outlet AI యాప్‌ను యాక్సెస్ చేయలేకపోతున్నాను.\n\nచూపిన కారణం: $reason\n\nదయచేసి యాక్సెస్‌ను తిరిగి పొందడంలో నాకు సహాయం చేయండి.\n\n— Kirana ఓనర్';
  }

  @override
  String get supBlockedEmailFallback =>
      'దయచేసి నేరుగా support@lohiyaai.com కు ఇమెయిల్ చేయండి.';

  @override
  String get supSupportTitle => 'సహాయం & సపోర్ట్';

  @override
  String get supSupportHeading => 'మేము మీకు ఎలా సహాయం చేయగలం?';

  @override
  String get supSupportSubheading => 'మీ ప్రశ్నలకు వెంటనే సమాధానాలు పొందండి';

  @override
  String get supOptionFaqTitle => 'తరచుగా అడిగే ప్రశ్నలు';

  @override
  String get supOptionFaqSubtitle => 'సాధారణ ప్రశ్నలు మరియు సమాధానాలు';

  @override
  String get supOptionReportTitle => 'సమస్యను రిపోర్ట్ చేయండి';

  @override
  String get supOptionReportSubtitle => 'బగ్ కనిపించిందా? మాకు తెలియజేయండి';

  @override
  String get supOptionChatTitle => 'మాతో చాట్ చేయండి';

  @override
  String get supOptionChatSubtitle => 'మా సపోర్ట్ టీమ్‌తో కనెక్ట్ అవ్వండి';

  @override
  String get supOptionEmailTitle => 'ఇమెయిల్ సపోర్ట్';

  @override
  String get supOptionEmailSubtitle => 'మాకు నేరుగా ఇమెయిల్ పంపండి';

  @override
  String get supChatComingSoon => 'చాట్ సపోర్ట్ త్వరలో వస్తుంది!';

  @override
  String get supEmailUnableToOpen => 'ఇమెయిల్ యాప్‌ను తెరవలేకపోయాం.';

  @override
  String get supEmailError =>
      'ఇమెయిల్ యాప్‌ను తెరిచేటప్పుడు ఏదో తప్పు జరిగింది.';

  @override
  String get supFaqTitle => 'FAQs';

  @override
  String get supFaqQ1 => 'కొత్త ప్రొడక్ట్‌ను ఎలా జోడించాలి?';

  @override
  String get supFaqA1 =>
      'POS ట్యాబ్‌లో + బటన్‌ను నొక్కి, లేదా Inventory ట్యాబ్ నుండి ప్రొడక్ట్‌లను జోడించవచ్చు. వివరాలు అందుబాటులో ఉంటే వాటిని ఆటోమేటిక్‌గా తీసుకోవడానికి బార్‌కోడ్‌ను కూడా స్కాన్ చేయవచ్చు.';

  @override
  String get supFaqQ2 => 'Stockout Risk అంచనా ఎలా పని చేస్తుంది?';

  @override
  String get supFaqA2 =>
      'మా AI మీ గత అమ్మకాల వేగాన్ని మరియు ప్రస్తుత స్టాక్ స్థాయిలను విశ్లేషిస్తుంది. తదుపరి 3-7 రోజుల్లో ఒక వస్తువు అయిపోతుందని అంచనా వేస్తే, దానిని Stockout Risk గా గుర్తిస్తుంది.';

  @override
  String get supFaqQ3 => 'కస్టమర్ క్రెడిట్ (ఖాతా)ను ఎలా నిర్వహించాలి?';

  @override
  String get supFaqA3 =>
      'ఆర్డర్ పెట్టేటప్పుడు, ఒక కస్టమర్‌ను ఎంచుకుని పేమెంట్ పద్ధతిగా \"Credit\"ను ఎంచుకోండి. పెండింగ్‌లో ఉన్న బకాయిలన్నింటినీ Finance -> Udhaar ట్యాబ్‌లో లేదా Customer Relations సెక్షన్‌లో చూడవచ్చు.';

  @override
  String get supFaqQ4 => 'నా ఫోన్ కాంటాక్ట్‌లను సింక్ చేయవచ్చా?';

  @override
  String get supFaqA4 =>
      'అవును! Profile -> Customer Relations కు వెళ్లి Sync ఐకాన్‌ను నొక్కండి. ఇది మీ రెగ్యులర్ షాపర్‌లను సులభమైన క్రెడిట్ ట్రాకింగ్ కోసం యాప్‌లోకి తీసుకొస్తుంది.';

  @override
  String get supFaqQ5 => 'KPI సబ్‌స్క్రిప్షన్‌లు అంటే ఏమిటి?';

  @override
  String get supFaqA5 =>
      'KPIs అనేవి Revenue, Margin, మరియు Footfall వంటి కీలక వ్యాపార మెట్రిక్‌లు. ఏ మెట్రిక్‌లను పర్యవేక్షించాలో Profile -> Subscription సెక్షన్ నుండి ఎంచుకోవచ్చు.';

  @override
  String get supFaqQ6 => 'రోజువారీ సేల్స్ రిపోర్ట్‌ను ఎలా జనరేట్ చేయాలి?';

  @override
  String get supFaqA6 =>
      'ఈరోజు పనితీరును Dashboard లో చూడవచ్చు. వివరణాత్మక గత రిపోర్ట్‌ల కోసం, మీ Profile లోని Transaction History సెక్షన్‌ను చూడండి.';

  @override
  String get supReportTitle => 'సమస్యను రిపోర్ట్ చేయండి';

  @override
  String get supReportHeading => 'సమస్యను వివరించండి';

  @override
  String get supReportSubheading =>
      'మా టీమ్ మీ రిపోర్ట్‌ను సమీక్షించి వీలైనంత త్వరగా దాన్ని పరిష్కరిస్తుంది.';

  @override
  String get supReportCategoryLabel => 'సమస్య కేటగిరీ';

  @override
  String get supReportSummaryLabel => 'చిన్న సారాంశం';

  @override
  String get supReportSummaryHint =>
      'ఉదా. బార్‌కోడ్ స్కాన్ చేస్తున్నప్పుడు యాప్ క్రాష్ అవుతుంది';

  @override
  String get supReportDescriptionLabel => 'వివరణాత్మక వివరణ';

  @override
  String get supReportDescriptionHint =>
      'సమస్యను ఎలా మళ్లీ రప్పించవచ్చో వివరాలు ఇవ్వండి...';

  @override
  String get supReportSubmit => 'రిపోర్ట్ సబ్మిట్ చేయండి';

  @override
  String get supReportFillFields => 'దయచేసి అన్ని ఫీల్డ్‌లను నింపండి';

  @override
  String get supReportSubmittedTitle => 'రిపోర్ట్ సబ్మిట్ అయింది';

  @override
  String get supReportSubmittedBody =>
      'మీ ఫీడ్‌బ్యాక్‌కు ధన్యవాదాలు. మా టీమ్ దీన్ని వెంటనే పరిశీలిస్తుంది.';

  @override
  String get supOk => 'సరే';

  @override
  String supReportSubmitFailed(String error) {
    return 'రిపోర్ట్ సబ్మిట్ చేయడం విఫలమైంది: $error';
  }

  @override
  String get supCategoryAppBug => 'యాప్ బగ్';

  @override
  String get supCategoryPricing => 'ధర సమస్య';

  @override
  String get supCategoryInventory => 'ఇన్వెంటరీ తేడా';

  @override
  String get supCategoryAiFeedback => 'AI సిఫార్సు ఫీడ్‌బ్యాక్';

  @override
  String get supCategoryPosError => 'POS ఎర్రర్';

  @override
  String get supCategoryFeatureRequest => 'ఫీచర్ రిక్వెస్ట్';

  @override
  String get supCategoryOther => 'ఇతర';

  @override
  String get shrSavingChanges => 'మార్పులు సేవ్ అవుతున్నాయి...';

  @override
  String get shrRetry => 'మళ్లీ ప్రయత్నించు';

  @override
  String get shrSavedSuccessfully => 'విజయవంతంగా సేవ్ అయింది!';

  @override
  String get shrBusinessAlerts => 'వ్యాపార అలర్ట్‌లు';

  @override
  String get shrAllCaughtUp => 'అంతా అప్‌డేట్‌గా ఉంది!';

  @override
  String get shrNoUrgentAlerts => 'ప్రస్తుతం అత్యవసర అలర్ట్‌లు ఏవీ లేవు.';

  @override
  String get shrAlertOutOfStock => 'స్టాక్ అయిపోయింది';

  @override
  String get shrAlertLowStock => 'తక్కువ స్టాక్';

  @override
  String get shrAlertExpiringSoon => 'త్వరలో గడువు ముగుస్తుంది';

  @override
  String get shrAlertOverdueUdhaar => 'చాలా కాలంగా బకాయి ఉన్న ఉధార్';

  @override
  String get shrAlertOverduePayment => 'గడువు మించిన పేమెంట్';

  @override
  String get shrAlertUpcomingPayment => 'రాబోయే పేమెంట్';

  @override
  String shrMsgOutOfStock(String name) {
    return '$name పూర్తిగా స్టాక్ అయిపోయింది.';
  }

  @override
  String shrMsgLowStock(String name, String stock) {
    return '$name తక్కువగా ఉంది ($stock).';
  }

  @override
  String shrMsgExpiringSoon(String name, int days) {
    return '$name $days రోజుల్లో గడువు ముగుస్తుంది.';
  }

  @override
  String shrMsgOverdueUdhaar(String name, String amount, int days) {
    return '$name $days రోజులుగా ₹$amount బకాయి ఉన్నారు.';
  }

  @override
  String shrMsgPaymentOverdue(String amount, String supplier) {
    return '$supplierకి ₹$amount గడువు మించింది.';
  }

  @override
  String shrMsgPaymentDue(String amount, String supplier, int days) {
    return '$supplierకి ₹$amount $days రోజుల్లో చెల్లించాలి.';
  }

  @override
  String psetErrorWith(String error) {
    return 'ఎర్రర్: $error';
  }

  @override
  String get psetCancel => 'రద్దు చేయి';

  @override
  String get psetReset => 'రీసెట్';

  @override
  String get psetUserActivity => 'యూజర్ యాక్టివిటీ';

  @override
  String get psetNoUsersFound => 'యూజర్లు ఎవరూ కనబడలేదు';

  @override
  String get psetNoStore => 'స్టోర్ లేదు';

  @override
  String get psetNever => 'ఎప్పుడూ లేదు';

  @override
  String get psetActiveToday => 'ఈరోజు యాక్టివ్';

  @override
  String get psetInactive => 'ఇన్‌యాక్టివ్';

  @override
  String get psetLastSeen => 'చివరిగా చూసింది';

  @override
  String get psetOpensToday => 'ఈరోజు ఓపెన్‌లు';

  @override
  String get psetTimeInApp => 'యాప్‌లో సమయం';

  @override
  String get psetSalesToday => 'ఈరోజు సేల్స్';

  @override
  String get psetJustNow => 'ఇప్పుడే';

  @override
  String psetMinsAgo(int m) {
    return '$mని క్రితం';
  }

  @override
  String psetHoursAgo(int h) {
    return '$hగం క్రితం';
  }

  @override
  String psetDaysAgo(int d) {
    return '$dరో క్రితం';
  }

  @override
  String get psetPasswordSecurity => 'పాస్‌వర్డ్ & సెక్యూరిటీ';

  @override
  String psetCouldNotLoadStatus(String error) {
    return 'స్టేటస్ లోడ్ చేయలేకపోయింది: $error';
  }

  @override
  String get psetEnterNewPassword => 'కొత్త పాస్‌వర్డ్ నమోదు చేయండి';

  @override
  String get psetPasswordMin6 => 'పాస్‌వర్డ్ కనీసం 6 అక్షరాలు ఉండాలి';

  @override
  String get psetPasswordsNoMatch => 'పాస్‌వర్డ్‌లు సరిపోలడం లేదు';

  @override
  String get psetEnterCurrentPassword => 'మీ ప్రస్తుత పాస్‌వర్డ్ నమోదు చేయండి';

  @override
  String get psetPasswordUpdated => 'పాస్‌వర్డ్ విజయవంతంగా అప్‌డేట్ అయింది.';

  @override
  String get psetPasswordCreated => 'పాస్‌వర్డ్ విజయవంతంగా సృష్టించబడింది.';

  @override
  String get psetCouldNotConnect =>
      'సర్వర్‌కు కనెక్ట్ కాలేకపోయింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get psetSomethingWrong => 'ఏదో తప్పు జరిగింది';

  @override
  String get psetPasswordSet => 'పాస్‌వర్డ్ సెట్ చేయబడింది';

  @override
  String get psetNoPasswordYet => 'ఇంకా పాస్‌వర్డ్ లేదు';

  @override
  String psetLastChanged(String date) {
    return 'చివరిగా మార్చింది $date';
  }

  @override
  String get psetPasswordActive => 'పాస్‌వర్డ్ యాక్టివ్‌గా ఉంది';

  @override
  String get psetCreatePasswordHint =>
      'యూజర్‌నేమ్ లాగిన్ ఎనేబుల్ చేయడానికి పాస్‌వర్డ్ సృష్టించండి';

  @override
  String psetPasswordCooldown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days రోజుల్లో',
      one: '1 రోజులో',
    );
    return 'మీరు $_temp0 మీ పాస్‌వర్డ్‌ను మళ్లీ మార్చుకోవచ్చు.';
  }

  @override
  String get psetChangePassword => 'పాస్‌వర్డ్ మార్చండి';

  @override
  String get psetCreatePassword => 'పాస్‌వర్డ్ సృష్టించండి';

  @override
  String get psetChangeSubtitle =>
      'మీ ప్రస్తుత పాస్‌వర్డ్ నమోదు చేసి, ఆపై కొత్తది ఎంచుకోండి.';

  @override
  String get psetCreateSubtitle =>
      'మీ యూజర్‌నేమ్‌తో కూడా లాగిన్ చేయడానికి పాస్‌వర్డ్ సెట్ చేయండి.';

  @override
  String get psetCurrentPassword => 'ప్రస్తుత పాస్‌వర్డ్';

  @override
  String get psetNewPassword => 'కొత్త పాస్‌వర్డ్';

  @override
  String get psetConfirmNewPassword => 'కొత్త పాస్‌వర్డ్‌ను నిర్ధారించండి';

  @override
  String get psetUpdatePassword => 'పాస్‌వర్డ్ అప్‌డేట్ చేయండి';

  @override
  String get psetPasswordCooldownNote =>
      'పాస్‌వర్డ్‌ను ప్రతి 14 రోజులకు ఒకసారి మాత్రమే మార్చవచ్చు.';

  @override
  String get psetAllHistory => 'మొత్తం హిస్టరీ';

  @override
  String get psetTabPurchases => 'పర్చేస్‌లు';

  @override
  String get psetTabPosOrders => 'POS ఆర్డర్‌లు';

  @override
  String get psetNoPurchaseHistory => 'పర్చేస్ హిస్టరీ ఏదీ కనబడలేదు.';

  @override
  String get psetViewBill => 'బిల్ చూడండి';

  @override
  String get psetPurchaseDetails => 'పర్చేస్ వివరాలు';

  @override
  String psetFromSupplier(String supplier) {
    return '$supplier నుండి';
  }

  @override
  String psetQtyTimes(String qty, String price) {
    return 'క్వాంటిటీ: $qty × ₹$price';
  }

  @override
  String get psetTotalAmount => 'మొత్తం అమౌంట్';

  @override
  String get psetSalesTxnHistory => 'సేల్స్ లావాదేవీ హిస్టరీ';

  @override
  String get psetSalesTxnDesc =>
      'మీ అన్ని POS ఆర్డర్‌లు, పేమెంట్‌లు మరియు కస్టమర్ లావాదేవీలను చూడండి, ఫిల్టర్ చేయండి.';

  @override
  String get psetOpenSalesHistory => 'సేల్స్ హిస్టరీ ఓపెన్ చేయండి';

  @override
  String get psetSettingsSaved => 'సెట్టింగ్‌లు సేవ్ అయ్యాయి';

  @override
  String psetSaveFailed(String error) {
    return 'సేవ్ విఫలమైంది: $error';
  }

  @override
  String get psetResetToDefaults => 'డిఫాల్ట్‌లకు రీసెట్ చేయి';

  @override
  String get psetResetConfirm =>
      'అన్ని సెట్టింగ్‌లు వాటి డిఫాల్ట్ విలువలకు రీసెట్ అవుతాయి.';

  @override
  String get psetConfiguration => 'కాన్ఫిగరేషన్';

  @override
  String get psetPosPreferences => 'POS ప్రాధాన్యతలు';

  @override
  String get psetAiForecasting => 'AI & ఫోర్‌కాస్టింగ్';

  @override
  String get psetAlertThresholds => 'అలర్ట్ థ్రెషోల్డ్‌లు';

  @override
  String get psetMarketing => 'మార్కెటింగ్';

  @override
  String get psetNotifications => 'నోటిఫికేషన్‌లు';

  @override
  String get psetDefaultPayment => 'డిఫాల్ట్ పేమెంట్ మెథడ్';

  @override
  String get psetDefaultPaymentHint =>
      'కొత్త సేల్ జోడించేటప్పుడు ముందుగా ఎంచుకున్న మెథడ్';

  @override
  String get psetCash => 'క్యాష్';

  @override
  String get psetCard => 'కార్డ్';

  @override
  String get psetForecastHorizon => 'ఫోర్‌కాస్ట్ హొరైజన్';

  @override
  String get psetForecastHorizonHint =>
      'AI స్టాక్ అవసరాలను ఎన్ని రోజుల ముందుగా అంచనా వేస్తుంది';

  @override
  String psetDaysValue(int days) {
    return '$days రోజులు';
  }

  @override
  String get psetStockoutRisk => 'స్టాకౌట్ రిస్క్ థ్రెషోల్డ్';

  @override
  String get psetStockoutRiskHint =>
      '7-రోజుల రిస్క్ దీన్ని మించినప్పుడు స్టాకౌట్ అలర్ట్ చూపించు';

  @override
  String get psetMinVelocity => 'కనిష్ట వెలాసిటీ థ్రెషోల్డ్';

  @override
  String get psetMinVelocityHint =>
      'దీని కంటే నెమ్మదిగా అమ్ముడయ్యే ఐటెమ్‌లు డెడ్ స్టాక్‌గా గుర్తించబడతాయి';

  @override
  String get psetReorderAlertDays => 'రీఆర్డర్ అలర్ట్ రోజులు';

  @override
  String get psetReorderAlertHint =>
      'అంచనా స్టాక్ N రోజుల్లో అయిపోతుందని అలర్ట్ చేయి';

  @override
  String get psetDeadStockDays => 'డెడ్ స్టాక్ రోజులు';

  @override
  String get psetDeadStockHint =>
      'N లేదా అంతకంటే ఎక్కువ రోజులు సేల్ లేని ఐటెమ్‌లను ఫ్లాగ్ చేయి';

  @override
  String get psetExpiryAlertDays => 'ఎక్స్‌పైరీ అలర్ట్ రోజులు';

  @override
  String get psetExpiryAlertHint =>
      'బ్యాచ్/ఐటెమ్ గడువు ముగియడానికి ఇన్ని రోజుల ముందు అలర్ట్ చేయి';

  @override
  String psetDaysBeforeValue(int days) {
    return '$days రోజుల ముందు';
  }

  @override
  String get psetAllowMarketing =>
      'నా స్టోర్‌ను మార్కెట్ చేయడానికి LohiyaAIకి అనుమతించు';

  @override
  String get psetAllowMarketingHint =>
      'మేము మీ తరఫున మీ స్టోర్‌ను Facebook, Instagram & WhatsAppలో ప్రమోట్ చేస్తాము';

  @override
  String get psetInAppAlerts => 'యాప్-లోపల అలర్ట్‌లు';

  @override
  String get psetInAppAlertsHint => 'యాప్ లోపల అలర్ట్‌లు చూపించు';

  @override
  String get psetWhatsappNotif => 'WhatsApp నోటిఫికేషన్‌లు';

  @override
  String get psetWhatsappNotifHint =>
      'రీస్టాకింగ్ మరియు ఉధార్ అలర్ట్‌లను WhatsApp ద్వారా పంపు';

  @override
  String get psetQuietHours => 'క్వైట్ అవర్స్';

  @override
  String get psetQuietHoursHint => 'ఈ సమయంలో ఎలాంటి నోటిఫికేషన్‌లు పంపబడవు';

  @override
  String get psetStart => 'ప్రారంభం';

  @override
  String get psetEnd => 'ముగింపు';

  @override
  String get psetSaveChanges => 'మార్పులను సేవ్ చేయి';

  @override
  String get psetCashflowSupport => 'క్యాష్‌ఫ్లో సపోర్ట్';

  @override
  String get psetRequestUnderReview => 'రిక్వెస్ట్ సమీక్షలో ఉంది';

  @override
  String psetReqProcessingFull(String amount, String bank) {
    return '₹$amount కోసం $bank ద్వారా మీ క్యాష్‌ఫ్లో రిక్వెస్ట్ ప్రాసెస్ అవుతోంది.\n\nమా టీమ్ 2 వ్యాపార రోజుల్లో మిమ్మల్ని సంప్రదిస్తుంది.';
  }

  @override
  String get psetReqProcessing =>
      'మీ క్యాష్‌ఫ్లో రిక్వెస్ట్ ప్రాసెస్ అవుతోంది.\n\nమా టీమ్ 2 వ్యాపార రోజుల్లో మిమ్మల్ని సంప్రదిస్తుంది.';

  @override
  String get psetRequestSubmitted => 'రిక్వెస్ట్ సబ్మిట్ అయింది!';

  @override
  String get psetRequestSubmittedBody =>
      'మేము మీ క్యాష్‌ఫ్లో రిక్వెస్ట్‌ను స్వీకరించాము.\nమా టీమ్ 2 వ్యాపార రోజుల్లో\nమిమ్మల్ని సంప్రదిస్తుంది.';

  @override
  String get psetBackToProfile => 'ప్రొఫైల్‌కు తిరిగి';

  @override
  String get psetApplyCashflow => 'క్యాష్‌ఫ్లో సపోర్ట్ కోసం\nదరఖాస్తు చేయండి';

  @override
  String get psetCashflowSubtitle =>
      'త్వరిత వ్యాపార ఫైనాన్స్, LohiyaAI భాగస్వాముల ద్వారా.';

  @override
  String get psetYourBusinessProfile => 'మీ వ్యాపార ప్రొఫైల్';

  @override
  String get psetStore => 'స్టోర్';

  @override
  String get psetLocation => 'లొకేషన్';

  @override
  String get psetDailyFootfall => 'రోజువారీ ఫుట్‌ఫాల్';

  @override
  String psetCustomersPerDay(int count) {
    return '$count కస్టమర్లు/రోజు';
  }

  @override
  String get psetHowMuchNeed => 'మీకు ఎంత అవసరం?';

  @override
  String get psetDragToSelect =>
      'ఎంచుకోవడానికి డ్రాగ్ చేయండి — ₹50,000 నుండి ₹10,00,000';

  @override
  String get psetLoanAmount => 'లోన్ అమౌంట్';

  @override
  String get psetChoosePartnerBank => 'పార్ట్‌నర్ బ్యాంక్‌ను ఎంచుకోండి';

  @override
  String get psetSelectBankHint =>
      'మీ రిక్వెస్ట్‌తో కొనసాగడానికి ఒక బ్యాంక్‌ను ఎంచుకోండి.';

  @override
  String get psetSubmitRequest => 'రిక్వెస్ట్ సబ్మిట్ చేయి';

  @override
  String get psetSubmitDisclaimer =>
      'సబ్మిట్ చేయడం ద్వారా, ఈ రిక్వెస్ట్ గురించి మా టీమ్ మిమ్మల్ని సంప్రదించడానికి మీరు అంగీకరిస్తారు.';

  @override
  String get psetBankSbiDesc => 'చిన్న వ్యాపారాల కోసం ప్రభుత్వ మద్దతు గల పథకం';

  @override
  String get psetBankHdfcDesc => 'రిటైల్ వృద్ధికి త్వరిత డిస్‌బర్సల్';

  @override
  String get psetBankIciciDesc => 'కిరాణా యజమానుల కోసం ఫ్లెక్సిబుల్ క్రెడిట్';

  @override
  String get psetBankAxisDesc => 'రిటైల్ స్టోర్‌ల కోసం తగిన ఫైనాన్స్';

  @override
  String get widgetTitleSales => 'నేటి అమ్మకాలు';

  @override
  String get widgetTitleUdhaar => 'ఉధార్ బకాయి';

  @override
  String get widgetTitleLowStock => 'తక్కువ స్టాక్';

  @override
  String get widgetTitlePayToday => 'ఈరోజు చెల్లించండి';

  @override
  String get widgetNewBill => '+ కొత్త బిల్లు';

  @override
  String get widgetUnitOrders => 'ఆర్డర్లు';

  @override
  String get widgetUnitItems => 'వస్తువులు';

  @override
  String get widgetUnitOverdue => 'గడువు మించింది';

  @override
  String get widgetUnitPending => 'పెండింగ్‌లో';

  @override
  String get widgetUnitToPay => 'చెల్లించాలి';

  @override
  String get widgetSignIn => 'సైన్ ఇన్ చేయడానికి Outlet AI తెరవండి';

  @override
  String get widgetNoData => 'నేటి గణాంకాల కోసం యాప్ తెరవండి';

  @override
  String get visionComingSoon => 'విజన్ AI త్వరలో వస్తుంది!';

  @override
  String get mktTierBronze => 'Bronze';

  @override
  String get mktTierSilver => 'Silver';

  @override
  String get mktTierGold => 'Gold';

  @override
  String get mktTierPlatinum => 'Platinum';

  @override
  String get mktTierSettings => 'టైర్ సెట్టింగ్‌లు';

  @override
  String get mktShowArchived => 'ఆర్కైవ్ చేసినవి చూపించు';

  @override
  String get mktHideArchived => 'ఆర్కైవ్ చేసినవి దాచు';

  @override
  String get mktArchived => 'ఆర్కైవ్ చేయబడింది';

  @override
  String get mktEdit => 'సవరించు';

  @override
  String get mktAlertedToday => 'ఈరోజు తెలియజేశారు';

  @override
  String get mktRestore => 'పునరుద్ధరించు';

  @override
  String get mktArchive => 'ఆర్కైవ్ చేయి';

  @override
  String get mktBasketArchived => 'బాస్కెట్ ఆర్కైవ్ చేయబడింది';

  @override
  String get mktBasketRestored => 'బాస్కెట్ పునరుద్ధరించబడింది';

  @override
  String get mktSomethingWentWrong =>
      'ఏదో తప్పు జరిగింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get mktEditBasket => 'బాస్కెట్ సవరించు';

  @override
  String get mktSaveChanges => 'మార్పులను సేవ్ చేయి';

  @override
  String get mktAddItemsForPrice =>
      'ఆటో-డిస్కౌంట్ బండిల్ ధర చూడటానికి వస్తువులను జోడించండి';

  @override
  String get mktItemsTotal => 'వస్తువుల మొత్తం';

  @override
  String get mktBundlePrice => 'బండిల్ ధర';

  @override
  String get mktTierConfigTitle => 'బాస్కెట్ టైర్‌లు';

  @override
  String get mktTierConfigIntro =>
      'బాస్కెట్‌లకు వాటి మొత్తం విలువ ఆధారంగా ఆటోమేటిక్‌గా ధర నిర్ణయించబడుతుంది. ప్రతి టైర్‌కు విలువ పరిధి, డిస్కౌంట్ సెట్ చేయండి — వస్తువులు జోడించగానే సరిపోలే టైర్ డిస్కౌంట్ స్వయంచాలకంగా వర్తిస్తుంది.';

  @override
  String get mktTierRangeInvalid =>
      'ప్రతి టైర్ పరిమితి మునుపటి దానికంటే ఎక్కువగా ఉండాలి, డిస్కౌంట్ 0–100% మధ్య ఉండాలి.';

  @override
  String get mktTiersSaved => 'టైర్‌లు సేవ్ చేయబడ్డాయి';

  @override
  String get mktRecomputeTitle =>
      'ఇప్పటికే ఉన్న బాస్కెట్‌లను తిరిగి లెక్కించాలా?';

  @override
  String get mktKeepAsIs => 'ఉన్నట్లుగా ఉంచు';

  @override
  String get mktRecompute => 'తిరిగి లెక్కించు';

  @override
  String get mktSaveTiers => 'టైర్‌లను సేవ్ చేయి';

  @override
  String get mktUpToLabel => 'వరకు';

  @override
  String get mktTopTierHint => 'మునుపటి టైర్ కంటే ఎక్కువ అన్నీ';

  @override
  String get mktDiscountLabel => 'డిస్కౌంట్';

  @override
  String get psetBasketTiers => 'బాస్కెట్ టైర్‌లు';

  @override
  String get psetBasketTiersHint => 'విలువ ఆధారంగా బాస్కెట్‌లపై ఆటో-డిస్కౌంట్';

  @override
  String mktYouSave(String amount, String pct) {
    return '₹$amount ఆదా ($pct% తగ్గింపు)';
  }

  @override
  String mktTierBasketLabel(String tier) {
    return '$tier బాస్కెట్';
  }

  @override
  String mktPctOff(String pct) {
    return '$pct% తగ్గింపు';
  }

  @override
  String mktSaveAmount(String amount) {
    return '₹$amount ఆదా';
  }

  @override
  String mktRecomputeBody(int count) {
    return '$count ఇప్పటికే ఉన్న బాస్కెట్‌లు పాత టైర్‌ల ప్రకారం ధర కలిగి ఉన్నాయి. వాటికి కూడా కొత్త టైర్‌లు వర్తింపజేయాలా?';
  }

  @override
  String mktBasketsRecomputed(int count) {
    return '$count బాస్కెట్‌లు నవీకరించబడ్డాయి';
  }

  @override
  String mktAboveAmount(String amount) {
    return '₹$amount పైన';
  }

  @override
  String mktRangeAmount(String from, String to) {
    return '₹$from – ₹$to';
  }

  @override
  String get mktSaveAsBasket => 'బాస్కెట్‌గా సేవ్ చేయి';

  @override
  String mktBasketSavedFromCampaign(String name) {
    return '\"$name\" మీ బాస్కెట్‌లకు సేవ్ చేయబడింది';
  }

  @override
  String get mktSelectDate => 'తేదీని ఎంచుకోండి';

  @override
  String get mktBasketsProTitle => 'బాస్కెట్‌లు ఒక Pro ఫీచర్';

  @override
  String get mktBasketsProDesc =>
      'ఆటోమేటిక్ టైర్ డిస్కౌంట్‌లతో కాంబో డీల్‌లను సృష్టించండి, కస్టమర్‌లకు WhatsApp‌లో తెలియజేయండి. బాస్కెట్‌లను అన్‌లాక్ చేయడానికి Pro‌కి అప్‌గ్రేడ్ చేయండి.';

  @override
  String get visionNavLabel => 'విజన్';

  @override
  String get visionTitle => 'విజన్';

  @override
  String get visionTabShelf => 'షెల్ఫ్ స్కాన్';

  @override
  String get visionTabResults => 'ఫలితాలు';

  @override
  String get visionTabCounter => 'కౌంటర్';

  @override
  String get visionProTitle => 'విజన్ AI';

  @override
  String get visionProDesc =>
      'ఉదయం, సాయంత్రం మీ షెల్ఫ్ ఫోటో తీయండి — AI మీ స్టాక్‌ను లెక్కించి ఏది అమ్ముడైందో చెబుతుంది.';

  @override
  String get visionFromCamera => 'ఫోటో తీయండి';

  @override
  String get visionFromGallery => 'గ్యాలరీ నుండి ఎంచుకోండి';

  @override
  String get visionMorningTitle => 'ఉదయం — రోజు ప్రారంభం';

  @override
  String get visionEveningTitle => 'సాయంత్రం — రోజు ముగింపు';

  @override
  String get visionTakePhoto => 'ఫోటో తీయండి';

  @override
  String get visionRetake => 'మళ్ళీ తీయండి';

  @override
  String get visionReview => 'సమీక్షించండి';

  @override
  String get visionAnalyzing =>
      'షెల్ఫ్‌ను విశ్లేషిస్తోంది… దీనికి ఒక నిమిషం వరకు పట్టవచ్చు';

  @override
  String get visionScanFailed => 'స్కాన్ విఫలమైంది. దయచేసి మళ్ళీ ఫోటో తీయండి.';

  @override
  String get visionStillProcessing =>
      'మీ ఫోటోల విశ్లేషణ జరుగుతోంది — దీనికి కొన్ని నిమిషాలు పట్టవచ్చు. సిద్ధమైనప్పుడు ఫలితం ఇక్కడ కనిపిస్తుంది.';

  @override
  String get visionCheckAgain => 'మళ్ళీ తనిఖీ చేయండి';

  @override
  String get visionNoPhotoYet => 'ఇంకా ఫోటో తీయలేదు.';

  @override
  String get visionProductsIdentified => 'గుర్తించిన ఉత్పత్తులు';

  @override
  String get visionUnitsCounted => 'లెక్కించిన యూనిట్లు';

  @override
  String get visionNeedsReview => 'సమీక్ష అవసరం';

  @override
  String get visionViewSales => 'ఈరోజు అమ్మకాలు చూడండి';

  @override
  String get visionTip =>
      'చిట్కా: దుకాణం తెరవడానికి ముందు ఉదయం ఫోటో, మూసివేయడానికి ముందు సాయంత్రం ఫోటో తీయండి. ప్రతి ఉత్పత్తి ఎంత అమ్ముడైందో AI లెక్కిస్తుంది.';

  @override
  String get visionSalesEmpty =>
      'ఈరోజు ఏది అమ్ముడైందో చూడటానికి ఉదయం, సాయంత్రం ఒక్కో ఫోటో తీయండి.';

  @override
  String get visionTotalSold => 'మొత్తం అమ్ముడైన వస్తువులు';

  @override
  String get visionSold => 'అమ్ముడైంది';

  @override
  String get visionMorningCount => 'AM';

  @override
  String get visionEveningCount => 'PM';

  @override
  String get visionUnknownItem => 'తెలియదు — సరిచేయడానికి నొక్కండి';

  @override
  String get visionCorrected => 'సరిచేయబడింది';

  @override
  String get visionCorrectTitle => 'ఇది ఏ ఉత్పత్తి?';

  @override
  String get visionSearchProducts => 'మీ ఉత్పత్తులను వెతకండి';

  @override
  String get visionClearCorrection => 'సవరణను తొలగించండి';

  @override
  String get visionNoProducts =>
      'ఇంకా ఉత్పత్తులు లోడ్ కాలేదు. ఒకసారి బిల్లింగ్ ట్యాబ్ తెరిచి, తిరిగి రండి.';

  @override
  String get visionCounterSoonTitle => 'లైవ్ కౌంటర్ — త్వరలో వస్తోంది';

  @override
  String get visionCounterSoonDesc =>
      'బిల్లింగ్ కౌంటర్ వైపు మీ ఫోన్ చూపించండి, వస్తువులు దాటుతుండగానే అమ్మకాలు ఆటోమేటిక్‌గా లెక్కించబడతాయి. మేము దీనికి తుది మెరుగులు దిద్దుతున్నాం.';

  @override
  String get visionCounterStartTitle => 'లైవ్ సేల్ కౌంటర్';

  @override
  String get visionCounterStartDesc =>
      'మీ ఫోన్‌ను బిల్లింగ్ కౌంటర్ వైపు పట్టుకోండి. గీతను దాటే వస్తువులు స్వయంచాలకంగా లెక్కించబడతాయి — బార్‌కోడ్ స్కానింగ్ లేదు.';

  @override
  String get visionCounterStart => 'లెక్కింపు ప్రారంభించండి';

  @override
  String get visionCounterFinish => 'ముగించండి';

  @override
  String get visionCounterPause => 'పాజ్ చేయండి';

  @override
  String get visionCounterResume => 'కొనసాగించండి';

  @override
  String get visionCounterUndo => 'రద్దు చేయండి';

  @override
  String get visionCounterFlip => 'వైపు మార్చండి';

  @override
  String get visionCounterCounted => 'లెక్కించబడింది';

  @override
  String get visionCounterNothingYet =>
      'వస్తువులను లెక్కించడానికి వాటిని గీత దాటి కదిలించండి.';

  @override
  String get visionCounterHint =>
      'ఆకుపచ్చ జోన్‌లోకి దాటే వస్తువులు అమ్ముడైనట్లు లెక్కించబడతాయి.';

  @override
  String get visionCounterZoneStore => 'దుకాణంలో';

  @override
  String get visionCounterZoneSold => 'అమ్ముడైంది';

  @override
  String get visionCounterModelMissingTitle =>
      'కౌంటర్ మోడల్ ఇన్‌స్టాల్ చేయబడలేదు';

  @override
  String get visionCounterModelMissingDesc =>
      'ఆన్-డివైస్ లెక్కింపు మోడల్ ఈ బిల్డ్‌లో ఇంకా చేర్చబడలేదు. ఇది ఒక అప్‌డేట్‌లో వస్తోంది — షెల్ఫ్ స్కానింగ్ ఇంకా పనిచేస్తుంది.';

  @override
  String get visionCounterPermTitle => 'కెమెరా యాక్సెస్ అవసరం';

  @override
  String get visionCounterPermDesc =>
      'బిల్లింగ్ కౌంటర్‌లో వస్తువులను లెక్కించడానికి కెమెరా యాక్సెస్‌ను అనుమతించండి.';

  @override
  String get visionCounterGrant => 'కెమెరాను అనుమతించండి';

  @override
  String get visionCounterOpenSettings => 'సెట్టింగ్‌లను తెరవండి';

  @override
  String get visionCounterFinishConfirmTitle => 'లెక్కింపు ముగించాలా?';

  @override
  String get visionCounterFinishConfirmDesc =>
      'మేము నేటి లెక్కను సేవ్ చేసి మీ కౌంటర్ సారాంశానికి జోడిస్తాము.';

  @override
  String get visionCounterSave => 'లెక్కను సేవ్ చేయండి';

  @override
  String get visionCounterDiscard => 'విస్మరించండి';

  @override
  String get visionCounterKeepCounting => 'లెక్కింపు కొనసాగించండి';

  @override
  String get visionCounterSavedTitle => 'లెక్కింపు సేవ్ చేయబడింది';

  @override
  String visionCounterSaved(int count, int skus) {
    return '$skus ఉత్పత్తులలో $count వస్తువులు సేవ్ చేయబడ్డాయి.';
  }

  @override
  String get visionCounterOfflineNote =>
      'మీ ఫోన్‌లో సేవ్ చేయబడింది. కౌంటర్ సేవ అందుబాటులోకి వచ్చినప్పుడు ఇది సింక్ అవుతుంది.';

  @override
  String visionCounterPending(int count) {
    return '$count ఇంకా సింక్ కాలేదు';
  }

  @override
  String get visionCounterSummaryTitle => 'నేటి కౌంటర్ లెక్క';

  @override
  String get visionCounterSummaryEmpty =>
      'ఈరోజు ఏ వస్తువూ లెక్కించబడలేదు. ప్రారంభించడానికి \'లెక్కింపు ప్రారంభించండి\' నొక్కండి.';

  @override
  String get visionCounterSummaryTotal => 'ఈరోజు మొత్తం లెక్కించబడింది';

  @override
  String get visionCounterUnknownItem => 'గుర్తించని ఉత్పత్తి';

  @override
  String get onbCtaTitle => 'వందల వస్తువులు ఉన్నాయా?';

  @override
  String get onbCtaSubtitle =>
      'మీ షెల్ఫ్‌లను ఫోటో తీయండి, మేము ఉత్పత్తులను గుర్తించి మీ ఇన్వెంటరీకి జోడిస్తాము — ప్రతిదాన్ని స్కాన్ చేయాల్సిన అవసరం లేదు.';

  @override
  String get onbCtaButton => 'మీ షెల్ఫ్‌లను ఫోటో తీయండి';

  @override
  String get onbCaptureTitle => 'మీ షెల్ఫ్‌లను ఫోటో తీయండి';

  @override
  String get onbCaptureHint =>
      'మీ అన్ని షెల్ఫ్‌లను కవర్ చేస్తూ 3 నుండి 10 స్పష్టమైన ఫోటోలు తీయండి. మంచి వెలుతురు ఎక్కువ ఉత్పత్తులను గుర్తించడంలో సహాయపడుతుంది.';

  @override
  String get onbTakePhoto => 'ఫోటో తీయండి';

  @override
  String onbPhotosProgress(int count) {
    return '10లో $count ఫోటోలు';
  }

  @override
  String get onbMinPhotos => 'కనీసం 3 ఫోటోలు జోడించండి';

  @override
  String get onbAnalyze => 'ఉత్పత్తులను గుర్తించండి';

  @override
  String get onbProcessingTitle => 'మేము మీ షెల్ఫ్ ఫోటోలను సమీక్షిస్తున్నాము';

  @override
  String get onbProcessingDesc =>
      'మా వ్యవస్థ మీ షెల్ఫ్‌లోని ఉత్పత్తులను గుర్తిస్తోంది. దీనికి సాధారణంగా ఒక నిమిషం కంటే తక్కువ సమయం పడుతుంది. దయచేసి ఈ స్క్రీన్‌ను తెరిచి ఉంచండి — మేము ఫలితాలను త్వరలో ఇక్కడ చూపిస్తాము.';

  @override
  String get onbReviewTitle => 'మీ స్టాక్‌ను నిర్ధారించండి';

  @override
  String get onbReviewDisclaimer =>
      'ఇవి మీ ఫోటోల నుండి మేము గుర్తించిన ఉత్పత్తులు. మేము అప్పుడప్పుడు ఒక వస్తువును కోల్పోవచ్చు లేదా తప్పుగా చదవవచ్చు, కాబట్టి దయచేసి పరిమాణాలను సరిచూసి సర్దుబాటు చేయండి. మేము నిరంతరం మా ఖచ్చితత్వాన్ని మెరుగుపరుస్తున్నాము.';

  @override
  String onbReviewSummary(int mapped, int unmapped) {
    return '$mapped సిద్ధం · $unmapped కి ఉత్పత్తి కావాలి';
  }

  @override
  String get onbUnrecognised => 'గుర్తించబడలేదు — ఒక ఉత్పత్తిని ఎంచుకోండి';

  @override
  String get onbChooseProduct => 'ఉత్పత్తిని ఎంచుకోండి';

  @override
  String get onbQuantity => 'పరిమాణం';

  @override
  String get onbCommit => 'నా ఇన్వెంటరీకి జోడించండి';

  @override
  String get onbCommitting => 'మీ ఇన్వెంటరీకి జోడించబడుతోంది…';

  @override
  String get onbDoneTitle => 'స్టాక్ జోడించబడింది';

  @override
  String onbDoneDesc(int products, int units) {
    return '$products ఉత్పత్తులు ($units వస్తువులు) మీ ఇన్వెంటరీకి జోడించబడ్డాయి. మీరు ఇన్వెంటరీ ట్యాబ్ నుండి ఎప్పుడైనా ధరలను సెట్ చేయవచ్చు.';
  }

  @override
  String get onbEmptyDetected =>
      'ఈ ఫోటోలలో మేము ఉత్పత్తులను గుర్తించలేకపోయాము. దయచేసి మంచి వెలుతురులో, ప్యాకేజింగ్‌ను స్పష్టంగా చూపిస్తూ మళ్ళీ ఫోటో తీయండి.';

  @override
  String get onbRetake => 'మళ్ళీ ఫోటోలు తీయండి';

  @override
  String get onbFailedTitle => 'మేము పూర్తి చేయలేకపోయాము';

  @override
  String get onbDone => 'పూర్తయింది';

  @override
  String get onbRemove => 'తీసివేయండి';

  @override
  String get visionAddPhotosTitle => 'షెల్ఫ్ ఫోటోలు జోడించండి';

  @override
  String get visionAddPhotosHint =>
      'మీ షెల్ఫ్‌లను కవర్ చేస్తూ 3 నుండి 10 ఫోటోలు తీయండి.';

  @override
  String get visionMinPhotosHint => 'కనీసం 3 ఫోటోలు జోడించండి';

  @override
  String get visionMaxReached => 'గరిష్టంగా 10 ఫోటోలు';

  @override
  String get visionAnalyze => 'విశ్లేషించు';

  @override
  String get forecastSectionLabel => 'అమ్మకాల అంచనా';

  @override
  String forecastStripCount(int count) {
    return 'రేపు $count వస్తువులు అమ్ముడుపోవచ్చు';
  }

  @override
  String forecastStripEst(String amount) {
    return 'అంచనా $amount';
  }

  @override
  String get forecastStripViewAll => 'పూర్తి జాబితా చూడండి';

  @override
  String get forecastScreenTitle => 'అమ్మకాల అంచనా';

  @override
  String get forecastHorizonTomorrow => 'రేపు';

  @override
  String get forecastHorizon3d => '3 రోజులు';

  @override
  String get forecastHorizon5d => '5 రోజులు';

  @override
  String get forecastHorizon7d => '7 రోజులు';

  @override
  String get forecastHorizon14d => '14 రోజులు';

  @override
  String get forecastHorizon30d => '30 రోజులు';

  @override
  String get forecastRevLabel => 'అంచనా ఆదాయం';

  @override
  String get forecastOosWarning => 'స్టాక్ అయిపోవచ్చు';

  @override
  String get forecastWhyTitle => 'ఇది ఇక్కడ ఎందుకు?';

  @override
  String get forecastWhyAvgDaily => 'రోజువారీ సగటు అమ్మకాలు';

  @override
  String get forecastWhyStockDays => 'మిగిలిన స్టాక్';

  @override
  String get forecastWhyOosRisk => 'అయిపోయే అవకాశం';

  @override
  String forecastWhyExplain(String avg, String days, String units) {
    return 'ఈ వస్తువు రోజూ సగటున $avg నగలు అమ్ముడవుతుంది. $days రోజుల్లో, మీ దుకాణం నుండి దాదాపు $units నగలు అమ్ముడవుతాయని అంచనా.';
  }

  @override
  String get forecastNoData => 'అంచనా ఇంకా తయారుకాలేదు. దయచేసి తర్వాత చూడండి.';

  @override
  String get forecastDataStale => 'డేటా పాతది కావచ్చు';
}
