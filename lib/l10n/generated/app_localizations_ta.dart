// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get languageName => 'தமிழ்';

  @override
  String get languageChooseTitle => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get languageChooseSubtitle =>
      'இதை அமைப்புகளில் எப்போது வேண்டுமானாலும் மாற்றலாம்.';

  @override
  String get settingsLanguage => 'மொழி';

  @override
  String get commonContinue => 'தொடரவும்';

  @override
  String get commonServerError =>
      'சர்வருடன் இணைக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get commonSomethingWrong =>
      'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authErrEnterPhone => 'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get authErrEnter6Otp => '6-இலக்க OTP ஐ உள்ளிடவும்';

  @override
  String get authErrSessionExpired =>
      'அமர்வு காலாவதியானது. மீண்டும் அனுப்பு என்பதைத் தட்டவும்.';

  @override
  String get authErrInvalidPhone =>
      'தவறான தொலைபேசி எண். நாட்டுக் குறியீட்டைச் சேர்க்கவும் (எ.கா. +91...).';

  @override
  String get authErrTooManyRequests =>
      'அதிக முயற்சிகள். பின்னர் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authErrWrongOtp =>
      'தவறான OTP. சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authErrOtpExpired =>
      'OTP காலாவதியானது. புதிய குறியீட்டைப் பெற மீண்டும் அனுப்பு என்பதைத் தட்டவும்.';

  @override
  String get authErrVerificationFailed =>
      'சரிபார்ப்பு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get welcomeSlide1Title => 'Outlet AI க்கு\nவரவேற்கிறோம்';

  @override
  String get welcomeSlide1Subtitle =>
      'உங்கள் மளிகைக் கடையை நிர்வகிக்க உங்கள் ஸ்மார்ட் வணிகப் பங்குதாரர் — தென்னிந்தியாவுக்காக உருவாக்கப்பட்டது.';

  @override
  String get welcomeSlide2Title => 'ஸ்மார்ட் சரக்கு\nமேலாண்மை';

  @override
  String get welcomeSlide2Subtitle =>
      'சரக்கு அளவுகளைக் கண்காணியுங்கள், குறைந்த சரக்கு எச்சரிக்கைகளைப் பெறுங்கள், உங்கள் சிறந்த விற்பனைப் பொருட்கள் ஒருபோதும் தீர்ந்துவிடாது.';

  @override
  String get welcomeSlide3Title => 'உங்கள் வணிகத்தை\nவளர்த்துக் கொள்ளுங்கள்';

  @override
  String get welcomeSlide3Subtitle =>
      'AI-இயங்கும் நுண்ணறிவுகள், விற்பனை பகுப்பாய்வு மற்றும் உங்கள் கடைக்கான தனிப்பயனாக்கப்பட்ட குறிப்புகளைப் பெறுங்கள்.';

  @override
  String get welcomeGetStarted => 'தொடங்குங்கள்';

  @override
  String get welcomeHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா? ';

  @override
  String get welcomeSignIn => 'உள்நுழைக';

  @override
  String get loginWelcomeBack => 'மீண்டும் வரவேற்கிறோம்';

  @override
  String get loginSubtitle => 'உங்கள் Outlet AI கணக்கில் உள்நுழையவும்.';

  @override
  String get loginTabPhone => 'தொலைபேசி OTP';

  @override
  String get loginTabUsername => 'பயனர்பெயர்';

  @override
  String get loginPhoneLabel => 'தொலைபேசி எண்';

  @override
  String get loginSendOtp => 'OTP அனுப்பு';

  @override
  String get loginOtpHelp => 'இந்த எண்ணுக்கு ஒரு முறை கடவுச்சொல்லை அனுப்புவோம்';

  @override
  String loginOtpSentTo(String phone) {
    return '$phone க்கு OTP அனுப்பப்பட்டது';
  }

  @override
  String get loginOtp6Label => '6-இலக்க OTP';

  @override
  String get loginVerifyOtp => 'OTP ஐ சரிபார்க்கவும்';

  @override
  String get loginResendOtp => 'OTP ஐ மீண்டும் அனுப்பு';

  @override
  String get loginUsernameLabel => 'பயனர்பெயர்';

  @override
  String get loginUsernameHint => 'எ.கா. mykiranastore';

  @override
  String get loginUsernameRequired => 'பயனர்பெயர் தேவை';

  @override
  String get loginPasswordLabel => 'கடவுச்சொல்';

  @override
  String get loginPasswordHint => 'உங்கள் கடவுச்சொல்';

  @override
  String get loginPasswordRequired => 'கடவுச்சொல் தேவை';

  @override
  String get loginSignIn => 'உள்நுழைக';

  @override
  String get loginNoAccount => 'கணக்கு இல்லையா? ';

  @override
  String get loginCreateOne => 'ஒன்றை உருவாக்கவும்';

  @override
  String get loginIncorrect =>
      'தவறான பயனர்பெயர் அல்லது கடவுச்சொல். மீண்டும் முயற்சிக்கவும்.';

  @override
  String loginFailed(String message) {
    return 'உள்நுழைவு தோல்வி: $message';
  }

  @override
  String onboardingStepCount(int step) {
    return '$step/4';
  }

  @override
  String get accountVerifyPhoneTitle =>
      'உங்கள் தொலைபேசி\nஎண்ணைச் சரிபார்க்கவும்';

  @override
  String get accountVerifyPhoneSubtitle =>
      'உங்கள் எண்ணை உறுதிப்படுத்த ஒரு முறை கடவுச்சொல்லை அனுப்புவோம்.';

  @override
  String get accountPhoneLabel => 'தொலைபேசி எண்';

  @override
  String get accountSendOtp => 'OTP அனுப்பு';

  @override
  String get accountEnterOtpTitle => 'OTP ஐ உள்ளிடவும்';

  @override
  String get accountEnterOtpSubtitle =>
      'உங்கள் தொலைபேசிக்கு 6-இலக்க குறியீடு அனுப்பப்பட்டது.';

  @override
  String accountOtpSentTo(String phone) {
    return '+91 $phone க்கு OTP அனுப்பப்பட்டது';
  }

  @override
  String get accountOtp6Label => '6-இலக்க OTP';

  @override
  String get accountVerify => 'சரிபார்க்கவும்';

  @override
  String get accountResendOtp => 'OTP ஐ மீண்டும் அனுப்பு';

  @override
  String accountPhoneVerified(String phone) {
    return 'தொலைபேசி சரிபார்க்கப்பட்டது: $phone';
  }

  @override
  String get accountChooseUsernameTitle =>
      'ஒரு கடை\nபயனர்பெயரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get accountChooseUsernameSubtitle =>
      'உங்கள் பயனர்பெயர் உங்கள் கடைக்கு தனித்துவமானது மற்றும் உள்நுழைய பயன்படுகிறது.';

  @override
  String get accountUsernameLabel => 'பயனர்பெயர்';

  @override
  String get accountUsernameHint => 'எ.கா. lohiyastore123';

  @override
  String get accountUsernameTaken => 'பயனர்பெயர் ஏற்கனவே எடுக்கப்பட்டது';

  @override
  String get accountUsernameRules =>
      'எழுத்துகள், எண்கள், அடிக்கோடுகள் மட்டுமே • குறைந்தபட்சம் 3 எழுத்துகள்';

  @override
  String get accountErrChooseUsername =>
      'உங்கள் கடைக்கு ஒரு தனித்துவமான பயனர்பெயரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get accountErrUsernameMin3 =>
      'பயனர்பெயர் குறைந்தபட்சம் 3 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get accountErrUsernameMax30 =>
      'பயனர்பெயர் அதிகபட்சம் 30 எழுத்துகள் இருக்கலாம்';

  @override
  String get accountErrUsernameChars =>
      'எழுத்துகள், எண்கள் மற்றும் அடிக்கோடுகள் மட்டுமே அனுமதிக்கப்படும்';

  @override
  String get accountErrUsernameTakenTry =>
      'அந்த பயனர்பெயர் எடுக்கப்பட்டது. வேறொன்றை முயற்சிக்கவும்.';

  @override
  String get accountUsernameAvailable => 'பயனர்பெயர் கிடைக்கிறது';

  @override
  String get businessTitle => 'உங்கள் கடையைப் பற்றி\nஎங்களிடம் கூறுங்கள்';

  @override
  String get businessSubtitle =>
      'உங்கள் அனுபவத்தைத் தனிப்பயனாக்க எங்களுக்கு உதவுங்கள்.';

  @override
  String get businessOwnerLabel => 'உரிமையாளரின் முழுப் பெயர்';

  @override
  String get businessOwnerHint => 'எ.கா. ரமேஷ் குமார்';

  @override
  String get businessOwnerRequired => 'பெயர் தேவை';

  @override
  String get businessStoreLabel => 'கடையின் பெயர்';

  @override
  String get businessStoreHint => 'எ.கா. ஸ்ரீ லட்சுமி ஸ்டோர்ஸ்';

  @override
  String get businessStoreRequired => 'கடையின் பெயர் தேவை';

  @override
  String get businessEmailLabel => 'மின்னஞ்சல் முகவரி';

  @override
  String get businessEmailHint => 'you@example.com';

  @override
  String get businessEmailRequired => 'மின்னஞ்சல் தேவை';

  @override
  String get businessEmailInvalid => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get businessTypeLabel => 'வணிக வகை';

  @override
  String get businessTypeHint => 'உங்கள் கடை வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get businessTypeRequired => 'உங்கள் வணிக வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get businessFootfallLabel => 'தோராயமான தினசரி வாடிக்கையாளர்கள்';

  @override
  String get businessFootfallHint => 'எ.கா. 40';

  @override
  String get businessFootfallSuffix => 'வாடிக்கையாளர்கள்/நாள்';

  @override
  String get businessFootfallInvalid => 'சரியான எண்ணை உள்ளிடவும்';

  @override
  String get businessBudgetLabel =>
      'மாதாந்திர விற்பனை இலக்கு (விருப்பத்தேர்வு)';

  @override
  String get businessBudgetHint => 'எ.கா. 150000';

  @override
  String get businessBudgetHelper =>
      'தினசரி முன்னேற்றத்தைக் கண்காணிக்கப் பயன்படுகிறது. பின்னர் மாற்றலாம்.';

  @override
  String get businessBudgetInvalid => 'சரியான தொகையை உள்ளிடவும்';

  @override
  String get businessTypeKirana => 'கிராணா / ஜெனரல் ஸ்டோர்';

  @override
  String get businessTypeGeneral => 'பொது கடை';

  @override
  String get businessTypeProvision => 'மளிகை சாமான் கடை';

  @override
  String get businessTypeFruitsVeg => 'பழங்கள் & காய்கறிகள்';

  @override
  String get businessTypeStationery => 'எழுதுபொருள் & புத்தகங்கள்';

  @override
  String get businessTypeSupermarket => 'சூப்பர் மார்க்கெட்';

  @override
  String get businessTypeMiniSupermarket => 'மினி சூப்பர் மார்க்கெட்';

  @override
  String get businessTypeMonoBrand => 'மோனோ பிராண்ட் ஸ்டோர்';

  @override
  String get businessTypeBoutique => 'பூட்டிக்';

  @override
  String get businessTypeSalon => 'சலூன் & பார்லர்';

  @override
  String get businessTypeFancyGift => 'ஃபேன்சி & கிஃப்ட் ஸ்டோர்';

  @override
  String get businessTypeSportsFitness => 'ஸ்போர்ட்ஸ் & ஃபிட்னஸ்';

  @override
  String get businessTypeFootwear => 'காலணி கடை';

  @override
  String get businessTypeOptical => 'ஆப்டிகல் ஸ்டோர்';

  @override
  String get businessTypeBakery => 'பேக்கரி & இனிப்பு கடை';

  @override
  String get businessTypeApparel => 'ஆடை & உடைகள்';

  @override
  String get businessTypeElectronics => 'மொபைல் & எலெக்ட்ரானிக்ஸ்';

  @override
  String get businessTypeOthers => 'மற்றவை';

  @override
  String get locationTitle => 'உங்கள் கடை\nஎங்கே அமைந்துள்ளது?';

  @override
  String get locationSubtitle =>
      'உள்ளூர் நுண்ணறிவுகளைக் காட்டவும், டெலிவரி மண்டலங்களை இயக்கவும் இதைப் பயன்படுத்துகிறோம்.';

  @override
  String get locationDetecting => 'இருப்பிடம் கண்டறியப்படுகிறது…';

  @override
  String get locationDetect => 'எனது இருப்பிடத்தைக் கண்டறி';

  @override
  String get locationOrManual => 'அல்லது கைமுறையாக உள்ளிடவும்';

  @override
  String get locationAddressLabel => 'கடை முகவரி';

  @override
  String get locationAddressHint => 'தெரு, பகுதி, அடையாளம்…';

  @override
  String get locationCityLabel => 'நகரம் / மாவட்டம்';

  @override
  String get locationCityHint => 'எ.கா. ஹைதராபாத்';

  @override
  String get locationGettingCoords => 'ஆயத்தொலைவுகள் பெறப்படுகின்றன…';

  @override
  String get locationDetected => 'இருப்பிடம் கண்டறியப்பட்டது';

  @override
  String get locationErrAddress =>
      'உங்கள் கடை முகவரியைக் கண்டறியவும் அல்லது உள்ளிடவும்.';

  @override
  String get locationErrCity => 'உங்கள் நகரம் அல்லது மாவட்டத்தை உள்ளிடவும்.';

  @override
  String get locationPermDenied =>
      'இருப்பிட அனுமதி மறுக்கப்பட்டது. முகவரியைக் கைமுறையாக உள்ளிடவும்.';

  @override
  String get locationDetectFailed =>
      'இருப்பிடத்தைக் கண்டறிய முடியவில்லை. முகவரியைக் கைமுறையாக உள்ளிடவும்.';

  @override
  String get consentTitle =>
      'கிட்டத்தட்ட முடிந்தது!\nபரிசீலித்து ஒப்புக்கொள்ளுங்கள்';

  @override
  String get consentSubtitle =>
      'உங்கள் அமைப்பை முடிக்க பின்வருவனவற்றைப் படித்து ஏற்றுக்கொள்ளுங்கள்.';

  @override
  String get consentTermsTitle => 'விதிமுறைகள் & நிபந்தனைகள்';

  @override
  String get consentTermsSummary =>
      'Outlet AI ஐப் பயன்படுத்துவதன் மூலம், சேவையை சட்டப்பூர்வ வணிக நோக்கங்களுக்காக மட்டுமே பயன்படுத்த ஒப்புக்கொள்கிறீர்கள். இந்த விதிமுறைகளை மீறும் கணக்குகளை இடைநிறுத்தும் உரிமையை LohiyaAI கொண்டுள்ளது. உங்கள் தரவு சேவையை வழங்கவும் மேம்படுத்தவும் மட்டுமே பயன்படுத்தப்படுகிறது.';

  @override
  String get consentPrivacyTitle => 'தனியுரிமைக் கொள்கை';

  @override
  String get consentPrivacySummary =>
      'உங்கள் அனுபவத்தைத் தனிப்பயனாக்க உங்கள் கடை விவரங்கள், இருப்பிடம் மற்றும் பரிவர்த்தனை தரவைச் சேகரிக்கிறோம். உங்கள் தனிப்பட்ட தரவை மூன்றாம் தரப்பினருக்கு ஒருபோதும் விற்க மாட்டோம். அனைத்து தரவும் குறியாக்கம் செய்யப்பட்டு எங்கள் கிளவுட் உள்கட்டமைப்பில் பாதுகாப்பாக சேமிக்கப்படுகிறது.';

  @override
  String get consentTermsCheckPrefix => 'நான் படித்து ஒப்புக்கொள்கிறேன் ';

  @override
  String get consentPrivacyCheckPrefix => 'நான் ஒப்புக்கொள்கிறேன் ';

  @override
  String get consentAcceptBoth =>
      'தொடர இரண்டு ஒப்பந்தங்களையும் ஏற்றுக்கொள்ளுங்கள்.';

  @override
  String get consentCompleteSetup => 'அமைப்பை முடிக்கவும்';

  @override
  String get regErrPhoneExists =>
      'இந்த தொலைபேசி எண் ஏற்கனவே பதிவு செய்யப்பட்டுள்ளது. அதற்கு பதிலாக உள்நுழையவும்.';

  @override
  String get regErrUsernameTaken =>
      'இந்த பயனர்பெயர் ஏற்கனவே எடுக்கப்பட்டது. வேறொன்றைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get regErrInvalidDetails =>
      'தவறான விவரங்கள். உங்கள் உள்ளீடுகளைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String regErrFailed(String message) {
    return 'பதிவு தோல்வி: $message';
  }

  @override
  String get dashNavHome => 'முகப்பு';

  @override
  String get dashNavKhata => 'கணக்கு';

  @override
  String get dashNavBilling => 'பில்லிங்';

  @override
  String get dashTrialWelcome => 'Outlet AI க்கு வரவேற்கிறோம்';

  @override
  String get dashTrialChoosePlan =>
      'இலவசமாக முயற்சிக்க ஒரு திட்டத்தைத் தேர்ந்தெடுக்கவும். எங்கள் குழு விரைவில் அதைச் செயல்படுத்தும்.';

  @override
  String get dashTrialSelectPlan =>
      'உங்கள் சோதனைத் திட்டத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get dashTrialRequestPro => 'Pro சோதனையைக் கோரவும்';

  @override
  String get dashTrialRequestBasic => 'Basic சோதனையைக் கோரவும்';

  @override
  String get dashTrialRequestError =>
      'இப்போது உங்கள் சோதனையைத் தொடங்க முடியவில்லை. உங்கள் இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get dashTrialSignInDifferent => 'வேறு கணக்கில் உள்நுழையவும்';

  @override
  String get dashPlanBadgeAllFeatures => 'அனைத்து அம்சங்கள்';

  @override
  String get dashPlanBasicName => 'அடிப்படை திட்டம்';

  @override
  String get dashPlanProName => 'Pro திட்டம்';

  @override
  String get dashFeatPos => 'POS & விற்பனை மேலாண்மை';

  @override
  String get dashFeatInventoryTracking => 'சரக்கு கண்காணிப்பு';

  @override
  String get dashFeatFinanceUdhaar => 'நிதி & கடன் (உதார்)';

  @override
  String get dashFeatKpiInsights => 'KPI நுண்ணறிவுகள் (வகைக்கு 3)';

  @override
  String get dashFeatAiReco => 'AI பரிந்துரைகள்';

  @override
  String get dashFeatEverythingBasic => 'அடிப்படையில் உள்ள அனைத்தும்';

  @override
  String get dashFeatAllKpi => 'அனைத்து KPI வகைகள் (வரம்பற்றது)';

  @override
  String get dashFeatVendorProcurement => 'விற்பனையாளர் & கொள்முதல் மேலாண்மை';

  @override
  String get dashFeatCashflowSupport => 'பணப்புழக்க ஆதரவு (₹10L வரை)';

  @override
  String get dashFeatCustomerGrowth => 'வாடிக்கையாளர் வளர்ச்சி இயந்திரம்';

  @override
  String get dashPendingTitle => 'சோதனைக் கோரிக்கை பெறப்பட்டது!';

  @override
  String get dashPendingBody =>
      'உங்கள் சோதனை செயல்படுத்தல் எங்கள் குழுவால் பரிசீலிக்கப்படுகிறது. அது அங்கீகரிக்கப்பட்டவுடன் உங்கள் சாதனத்தில் அறிவிப்பைப் பெறுவீர்கள் — பொதுவாக சில மணிநேரங்களுக்குள்.';

  @override
  String get dashPendingNotifNote =>
      'செயல்படுத்தல் எச்சரிக்கையைத் தவறவிடாமல் இருக்க அறிவிப்புகள் இயக்கப்பட்டுள்ளதா என்பதை உறுதிசெய்யவும்.';

  @override
  String get dashPendingCheckStatus => 'நிலையைச் சரிபார்க்கவும்';

  @override
  String get dashUpgradeTitle => 'இலவச சோதனை முடிந்தது';

  @override
  String get dashUpgradeBody =>
      'உங்கள் இலவச சோதனை முடிந்தது. Outlet AI ஐத் தொடர்ந்து பயன்படுத்தவும் உங்கள் கடையை வளர்க்கவும் ஒரு திட்டத்தைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get dashUpgradeBasic => 'அடிப்படை';

  @override
  String get dashUpgradePro => 'Pro';

  @override
  String get dashUpgradeBadgeBest => 'சிறந்தது';

  @override
  String dashUpgradeJustPerDay(String price) {
    return 'வெறும் $price';
  }

  @override
  String get dashUpgradeAlreadySubscribed =>
      'ஏற்கனவே குழுசேர்ந்துவிட்டீர்களா? புதுப்பிக்கவும்';

  @override
  String get dashFeatPosInventory => 'POS & சரக்கு';

  @override
  String get dashFeatFinanceKpis => 'நிதி & KPIகள்';

  @override
  String get dashFeatVendorManagement => 'விற்பனையாளர் மேலாண்மை';

  @override
  String get dashFeatCashflowReferrals => 'பணப்புழக்கம் + பரிந்துரைகள்';

  @override
  String get dashNewSale => 'புதிய விற்பனை';

  @override
  String get dashGreetingMorning => 'காலை வணக்கம்';

  @override
  String get dashGreetingAfternoon => 'மதிய வணக்கம்';

  @override
  String get dashGreetingEvening => 'மாலை வணக்கம்';

  @override
  String dashGreetingWithName(String greeting, String name) {
    return '$greeting, \n$name';
  }

  @override
  String get dashMorningBriefing => 'காலை சுருக்கம்';

  @override
  String dashBriefingBody(int risk, int reorder) {
    return 'உங்களிடம் $risk SKUகள் முக்கிய ஆபத்தில் உள்ளன மற்றும் இன்று $reorder பொருட்களை மீண்டும் ஆர்டர் செய்ய வேண்டும். சரிசெய்ய தட்டவும்.';
  }

  @override
  String get dashIntelligence => 'நுண்ணறிவு';

  @override
  String get dashMetricStockoutLabel => 'சரக்கு தீரும் ஆபத்து';

  @override
  String get dashMetricStockoutSub => 'SKUகள் முக்கியம்';

  @override
  String get dashMetricReorderLabel => 'இப்போது மீண்டும் ஆர்டர் செய்';

  @override
  String get dashMetricReorderSub => 'SKUகள் குறைந்த சரக்கு';

  @override
  String get dashMetricFastLabel => 'வேகமாக விற்பவை';

  @override
  String get dashMetricFastSub => 'சிறந்த விற்பனை';

  @override
  String get dashMetricProfitLabel => 'லாப தேர்வுகள்';

  @override
  String get dashMetricProfitSub => 'வாய்ப்புகள்';

  @override
  String get dashMetricCustomerLabel => 'வாடிக்கையாளர் நிலுவைகள்';

  @override
  String get dashMetricCustomerSub => 'நிலுவையில் உள்ள கணக்கு';

  @override
  String get dashMetricSalesLabel => 'விற்ற பொருட்கள்';

  @override
  String get dashMetricSalesSub => 'இன்று இதுவரை';

  @override
  String get dashTodaysPerformance => 'இன்றைய செயல்திறன்';

  @override
  String get dashPosNotAvailable => 'POS தரவு கிடைக்கவில்லை';

  @override
  String get dashStatRevenue => 'வருவாய்';

  @override
  String get dashStatOrders => 'பில்கள்';

  @override
  String get dashStatAvgOrder => 'சராசரி பில்';

  @override
  String get dashStoreOverview => 'கடை மேலோட்டம்';

  @override
  String get dashStoreSkus => 'SKUகள்';

  @override
  String get dashStoreFootfall => 'தினசரி வருகை';

  @override
  String get dashStoreDailyBudget => 'தினசரி சரக்கு செலவு';

  @override
  String dashKpiPeriod(int days) {
    return 'கடந்த $days நாட்கள்';
  }

  @override
  String get dashCouldNotLoad => 'தரவை ஏற்ற முடியவில்லை';

  @override
  String get dashRetry => 'மீண்டும் முயற்சி';

  @override
  String get dashAlerts => 'எச்சரிக்கைகள்';

  @override
  String get dashSeeAll => 'அனைத்தையும் காண்க';

  @override
  String get dashStoreKpis => 'கடை KPIகள்';

  @override
  String dashKpiCoverageTooltip(String pct) {
    return '$pct% விற்பனையின் அடிப்படையில் — சில பொருட்களுக்கு செலவு தரவு இல்லை';
  }

  @override
  String get dashDetailStockout => 'சரக்கு தீரும் ஆபத்து';

  @override
  String get dashDetailReorder => 'மீண்டும் ஆர்டர் தேவை';

  @override
  String get dashDetailFastMoving => 'வேகமாக விற்கும் பொருட்கள்';

  @override
  String get dashDetailProfit => 'அதிக லாப பொருட்கள்';

  @override
  String get dashDetailDefault => 'நுண்ணறிவு விவரம்';

  @override
  String get dashSearchProducts => 'பொருட்களைத் தேடு...';

  @override
  String get dashSortBy => 'வரிசைப்படுத்து:';

  @override
  String get dashSortProfit => 'லாபம்';

  @override
  String get dashSortDemand => 'தேவை';

  @override
  String get dashSortRisk => 'ஆபத்து';

  @override
  String dashStockLabel(String qty) {
    return 'சரக்கு: $qty';
  }

  @override
  String get dashStockRunway => 'சரக்கு கால அளவு';

  @override
  String get dashOutOfStock => 'சரக்கு இல்லை';

  @override
  String dashDaysLeft(String days) {
    return '~$days நாட்கள் மீதம்';
  }

  @override
  String get dashStatStockoutRisk => 'சரக்கு தீரும் ஆபத்து';

  @override
  String get dashStatReorderQty => 'மீள் ஆர்டர் அளவு';

  @override
  String dashUnitsValue(String qty) {
    return '$qty அலகுகள்';
  }

  @override
  String dashWeeklyProfitImpact(String amount) {
    return '₹$amount மதிப்பிடப்பட்ட வாராந்திர லாப தாக்கம்';
  }

  @override
  String dashCreatePurchaseOrder(String qty) {
    return 'கொள்முதல் ஆர்டர் உருவாக்கு · $qty அலகுகள்';
  }

  @override
  String get dashNoItemsFound => 'பொருட்கள் எதுவும் இல்லை';

  @override
  String dashNoResultsFor(String query) {
    return '\"$query\" க்கு முடிவுகள் இல்லை';
  }

  @override
  String get dashClearSearch => 'தேடலை அழி';

  @override
  String get dashConnectionError => 'இணைப்பு பிழை';

  @override
  String get posCommonCancel => 'ரத்துசெய்';

  @override
  String get posCommonClear => 'அழி';

  @override
  String get posCommonRefresh => 'புதுப்பி';

  @override
  String get posCommonAddToCart => 'கார்ட்டில் சேர்';

  @override
  String get posCameraPermissionRequired =>
      'பார்கோடுகளை ஸ்கேன் செய்ய கேமரா அனுமதி தேவை.';

  @override
  String get posCommonSettings => 'அமைப்புகள்';

  @override
  String posEnterQtyTitle(String unit) {
    return '$unit உள்ளிடவும்';
  }

  @override
  String get posQtyFallback => 'அளவு';

  @override
  String get posSelectVariant => 'வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String posInclGst(String amount) {
    return 'GST உட்பட $amount';
  }

  @override
  String get posOutOfStock => 'கையிருப்பு இல்லை';

  @override
  String posVariantStockLine(String stock) {
    return '$stock கையிருப்பில்';
  }

  @override
  String posPriceLabel(String price) {
    return 'விலை: $price';
  }

  @override
  String get posWeightMeasurement => 'எடை / அளவீடு';

  @override
  String get posUnknownBarcodeTitle => 'தெரியாத பார்கோடு';

  @override
  String posUnknownBarcodeBody(String barcode) {
    return 'பார்கோடு \"$barcode\" உங்கள் சரக்கில் இல்லை. நீங்கள் என்ன செய்ய விரும்புகிறீர்கள்?';
  }

  @override
  String get posAddAsNew => 'புதியதாகச் சேர்';

  @override
  String get posLinkToExisting => 'தற்போதுள்ள பொருளுடன் இணை';

  @override
  String posErrLoadingInventory(String error) {
    return 'சரக்கை ஏற்றுவதில் பிழை: $error';
  }

  @override
  String posLinkBarcodeTitle(String barcode) {
    return 'பார்கோடு \"$barcode\" ஐ இணை';
  }

  @override
  String get posNoUnbarcodedItems => 'பார்கோடு இல்லாத பொருட்கள் எதுவும் இல்லை.';

  @override
  String posCategoryLabel(String category) {
    return 'வகை: $category';
  }

  @override
  String get posCategoryGeneral => 'பொது';

  @override
  String posLinkedToItem(String barcode, String name) {
    return '$barcode ஐ $name உடன் இணைக்கப்பட்டது';
  }

  @override
  String get posScanReferralQr => 'பரிந்துரை QR ஐ ஸ்கேன் செய்';

  @override
  String posCampaignOutOfStock(String name) {
    return '\"$name\" இல் உள்ள அனைத்து பொருட்களும் சரக்கில் இல்லை';
  }

  @override
  String posCampaignItemsAdded(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பொருட்கள்',
      one: 'பொருள்',
    );
    return '\"$name\" இலிருந்து $count $_temp0 சேர்க்கப்பட்டது';
  }

  @override
  String posAddedSkipped(int added, int skipped) {
    return '$added சேர்க்கப்பட்டது · $skipped தவிர்க்கப்பட்டது (சரக்கில் இல்லை)';
  }

  @override
  String posBasketAddedAtPrice(String name, String price) {
    return 'தொகுப்பு \"$name\" ₹$price இல் சேர்க்கப்பட்டது';
  }

  @override
  String posItemsRegularPrice(int count) {
    return '$count பொருட்கள் வழக்கமான விலையில் சேர்க்கப்பட்டது (தொகுப்புக்கு அனைத்து பொருட்களும் சரக்கில் தேவை)';
  }

  @override
  String posBasketItemsAdded(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பொருட்கள்',
      one: 'பொருள்',
    );
    return '\"$name\" இலிருந்து $count $_temp0 சேர்க்கப்பட்டது';
  }

  @override
  String posItemsAddedToCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பொருட்கள்',
      one: 'பொருள்',
    );
    return '$count $_temp0 கார்ட்டில் சேர்க்கப்பட்டது';
  }

  @override
  String get posSelectCustomer => 'வாடிக்கையாளரைத் தேர்ந்தெடு';

  @override
  String get posNew => 'புதிய';

  @override
  String get posSearchNameOrPhone => 'பெயர் அல்லது தொலைபேசி மூலம் தேடு...';

  @override
  String get posNoCustomersFound => 'வாடிக்கையாளர்கள் எவரும் இல்லை.';

  @override
  String get posAddNewCustomer => 'புதிய வாடிக்கையாளரைச் சேர்';

  @override
  String get posSelectFromContacts => 'தொடர்புகளிலிருந்து தேர்ந்தெடு';

  @override
  String get posCustomerName => 'வாடிக்கையாளர் பெயர்';

  @override
  String get posPhoneNumber => 'தொலைபேசி எண்';

  @override
  String get posSaveAndSelect => 'சேமித்து தேர்ந்தெடு';

  @override
  String get posSearchProducts => 'பொருட்களைத் தேடு…';

  @override
  String get posReferralScan => 'பரிந்துரை ஸ்கேன்';

  @override
  String get posOrderHistory => 'ஆர்டர் வரலாறு';

  @override
  String get posRefreshingProducts => 'பொருட்கள் புதுப்பிக்கப்படுகிறது...';

  @override
  String posRefreshFailed(String error) {
    return 'புதுப்பித்தல் தோல்வி: $error';
  }

  @override
  String posProductsRefreshed(int count) {
    return 'பொருட்கள் புதுப்பிக்கப்பட்டன ($count பொருட்கள்)';
  }

  @override
  String posItemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பொருட்கள்',
      one: 'பொருள்',
    );
    return 'கார்ட்டில் $count $_temp0';
  }

  @override
  String get posClearCartTitle => 'கார்ட்டை அழிக்கவா?';

  @override
  String get posClearCartBody =>
      'அனைத்து பொருட்களும் கார்ட்டில் இருந்து அகற்றப்படும்.';

  @override
  String get posFrequentlyBought => 'அடிக்கடி ஒன்றாக வாங்கப்படுபவை';

  @override
  String get posNoProductsFound => 'பொருட்கள் எதுவும் இல்லை';

  @override
  String posStockColon(String stock) {
    return 'சரக்கு: $stock';
  }

  @override
  String get posOffline => 'POS ஆஃப்லைன்';

  @override
  String get posCouldNotConnect => 'POS உடன் இணைக்க முடியவில்லை.';

  @override
  String get posBundlesAndDeals => 'தொகுப்புகள் & சலுகைகள்';

  @override
  String get posRefreshAi => 'AI ஐ புதுப்பி';

  @override
  String posItemsInBundle(int count) {
    return 'தொகுப்பில் $count பொருட்கள்';
  }

  @override
  String get posBundlePrice => 'தொகுப்பு விலை';

  @override
  String get posItemFallback => 'பொருள்';

  @override
  String posValidUntil(String date) {
    return '$date வரை செல்லுபடியாகும்';
  }

  @override
  String posStockUnitPrice(String stock, String unit, String price) {
    return 'சரக்கு: $stock $unit  ·  ₹$price';
  }

  @override
  String get posNotInStock => 'சரக்கில் இல்லை';

  @override
  String get posBundlePriceLabel => 'தொகுப்பு விலை';

  @override
  String get posAddAvailableToCart => 'கிடைக்கும் பொருட்களை கார்ட்டில் சேர்';

  @override
  String posVoiceCount(int remaining, int total) {
    return 'குரல் ($remaining/$total)';
  }

  @override
  String get posVoiceOrder => 'குரல் ஆர்டர்';

  @override
  String posHandwriteCount(int remaining, int total) {
    return 'கையெழுத்து ($remaining/$total)';
  }

  @override
  String get posHandwrite => 'கையெழுத்து';

  @override
  String get posCartEmpty => 'கார்ட் காலியாக உள்ளது';

  @override
  String get posCartEmptyHint =>
      'விற்பனையைத் தொடங்க ஒரு பொருளைத் தேடவும் அல்லது பார்கோடை ஸ்கேன் செய்யவும்.';

  @override
  String get posAddCustomer => 'வாடிக்கையாளரைச் சேர்';

  @override
  String posItemCount(String count) {
    return '$count பொருட்கள்';
  }

  @override
  String posPlaceOrderAmount(String amount) {
    return 'ஆர்டர் செய் · $amount';
  }

  @override
  String get posPosInventory => 'POS / சரக்கு';

  @override
  String get posOnline => 'POS ஆன்லைன்';

  @override
  String get posTabSales => 'விற்பனை';

  @override
  String get posTabStock => 'சரக்கு';

  @override
  String get posTabPurchase => 'கொள்முதல்';

  @override
  String get posPurchaseSuppliers => 'கொள்முதல் & சப்ளையர்கள்';

  @override
  String get posPurchaseSuppliersDesc =>
      'கொள்முதல் ஆர்டர்களை உருவாக்கவும், உங்கள் சப்ளையர்களை நிர்வகிக்கவும், அவர்களுக்கு நீங்கள் செலுத்த வேண்டியதைக் கண்காணிக்கவும் — அனைத்தும் ஒரே இடத்தில்.';

  @override
  String get posPaywallPurchaseDesc =>
      'கொள்முதல் ஆர்டர்கள் மற்றும் சப்ளையர்களை நிர்வகிக்கவும். விநியோகஸ்தர்களுக்கான கட்டணங்களைக் கண்காணிக்கவும். Pro திட்டத்தில் கிடைக்கும்.';

  @override
  String get posPrinterSetup => 'பிரிண்டர் அமைப்பு';

  @override
  String get posReconnect => 'மீண்டும் இணை';

  @override
  String get posForgetPrinter => 'இந்த பிரிண்டரை மறந்துவிடு';

  @override
  String get posPairedDevices => 'இணைக்கப்பட்ட புளூடூத் சாதனங்கள்';

  @override
  String get posNoPairedDevices => 'இணைக்கப்பட்ட சாதனங்கள் எதுவும் இல்லை';

  @override
  String get posPairDeviceHint =>
      'முதலில் உங்கள் தெர்மல் பிரிண்டரை Android\nபுளூடூத் அமைப்புகளில் இணைக்கவும், பின்னர் புதுப்பிக்கவும்.';

  @override
  String get posProOnly => 'Pro மட்டும்';

  @override
  String get posUpgradeToProDay =>
      'Pro க்கு மேம்படுத்து  ₹500/மாதம் · வெறும் ₹17/நாள்';

  @override
  String get posReceiptSent => 'ரசீது பிரிண்டருக்கு அனுப்பப்பட்டது';

  @override
  String get posPrintFailedCheck =>
      'அச்சிடல் தோல்வி — பிரிண்டரைச் சரிபார்க்கவும்';

  @override
  String get posOrderPlaced => 'ஆர்டர் செய்யப்பட்டது!';

  @override
  String posOrderNumber(String id) {
    return 'ஆர்டர் #$id';
  }

  @override
  String get posPrintReceipt => 'ரசீதை அச்சிடு';

  @override
  String get posNewSale => 'புதிய விற்பனை';

  @override
  String get posViewOrderDetails => 'ஆர்டர் விவரங்களைப் பார்';

  @override
  String get posSelectCustomerForUdhaar =>
      'உதார் விற்பனைக்கு ஒரு வாடிக்கையாளரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get posConfirmOrder => 'ஆர்டரை உறுதிப்படுத்து';

  @override
  String get posOrderConfirmed => 'ஆர்டர் உறுதிப்படுத்தப்பட்டது!';

  @override
  String get posSubtotal => 'துணை மொத்தம்';

  @override
  String posReferralDiscount(String pct, String referrer) {
    return 'பரிந்துரை தள்ளுபடி ($pct%)$referrer';
  }

  @override
  String get posGrandTotal => 'மொத்தத் தொகை';

  @override
  String get posPaymentMethod => 'கட்டண முறை';

  @override
  String get posPayCash => 'பணம்';

  @override
  String get posPayUdhaar => 'உதார் (கடன்)';

  @override
  String get posUdhaarDueDate => 'செலுத்தும் தேதி';

  @override
  String get posUdhaarDueDateHint =>
      'வாடிக்கையாளர் எப்போது திருப்பிச் செலுத்துவார்?';

  @override
  String posBundlePercentOff(int pct) {
    return '$pct% தள்ளுபடி';
  }

  @override
  String posBundleYouSave(String amount) {
    return '$amount சேமிப்பு';
  }

  @override
  String get posBundleRegularPrice =>
      'வழக்கமான விலையில் சேர்க்கப்பட்டது (பண்டிலுக்கு அனைத்து பொருட்களும் கையிருப்பில் தேவை)';

  @override
  String get posPayUpi => 'UPI';

  @override
  String get posComingSoon => 'விரைவில் வருகிறது';

  @override
  String get posSelectCustomerRequired =>
      'வாடிக்கையாளரைத் தேர்ந்தெடு (உதாருக்குத் தேவை)';

  @override
  String get posSelectCustomerForUdhaarTitle =>
      'உதாருக்கு வாடிக்கையாளரைத் தேர்ந்தெடு';

  @override
  String get posSearchNameOrPhoneHint => 'பெயர் அல்லது தொலைபேசி மூலம் தேடு…';

  @override
  String get posPrintAutomatically => 'ரசீதைத் தானாக அச்சிடு';

  @override
  String get posWillPrintAfter => 'ஆர்டர் செய்யப்பட்ட பிறகு அச்சிடப்படும்';

  @override
  String posPrinterStatus(String status) {
    return 'பிரிண்டர்: $status';
  }

  @override
  String get posAutoPrintDisabled =>
      'முடக்கப்பட்டது — ஆர்டர் விவரங்களிலிருந்து கைமுறையாக அச்சிடு';

  @override
  String get posHowMuchUdhaar => 'எவ்வளவு உதாரில் செல்கிறது?';

  @override
  String get posCashNow => 'இப்போது பணம்';

  @override
  String get posOnUdhaar => 'உதாரில்';

  @override
  String get posPrintFailedCheckConnection =>
      'அச்சிடல் தோல்வி — பிரிண்டர் இணைப்பைச் சரிபார்க்கவும்';

  @override
  String get posTodaysOrders => 'இன்றைய ஆர்டர்கள்';

  @override
  String posTransactionsSoFar(int count) {
    return 'இதுவரை $count பரிவர்த்தனைகள்';
  }

  @override
  String get posViewAll => 'அனைத்தையும் பார்';

  @override
  String get posNoOrdersToday => 'இன்று இதுவரை ஆர்டர்கள் இல்லை';

  @override
  String get posSalesAppearHere => 'விற்பனை பரிவர்த்தனைகள் இங்கே தோன்றும்';

  @override
  String posOrderMeta(String time, String payment, String status) {
    return '$time · $payment · $status';
  }

  @override
  String get posPrint => 'அச்சிடு';

  @override
  String get posScanBarcode => 'பார்கோடை ஸ்கேன் செய்';

  @override
  String get posAlignBarcode => 'சட்டகத்திற்குள் பார்கோடை சீரமைக்கவும்';

  @override
  String get posLookingUp => 'தேடுகிறது…';

  @override
  String posAlreadyInList(String name) {
    return '$name ஏற்கனவே பட்டியலில் உள்ளது';
  }

  @override
  String posItemQty(String name, int qty) {
    return '$name ×$qty';
  }

  @override
  String posItemAdded(String name) {
    return '$name சேர்க்கப்பட்டது';
  }

  @override
  String get posNotFoundTapAdd => 'கிடைக்கவில்லை — கைமுறையாக சேர்க்க தட்டவும்';

  @override
  String posItemsScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பொருட்கள்',
      one: 'பொருள்',
    );
    return '$count $_temp0 ஸ்கேன் செய்யப்பட்டது';
  }

  @override
  String get posScanItems => 'பொருட்களை ஸ்கேன் செய்';

  @override
  String get posClearAll => 'அனைத்தையும் அழி';

  @override
  String posLookingUpItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பொருட்கள்',
      one: 'பொருள்',
    );
    return '$count $_temp0 தேடப்படுகிறது…';
  }

  @override
  String posAddItemsToCart(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பொருட்கள்',
      one: 'பொருள்',
    );
    return '$count $_temp0 கார்ட்டில் சேர்  ·  ₹$total';
  }

  @override
  String get posPointCamera => 'கேமராவை பார்கோடை நோக்கி காட்டு';

  @override
  String get posItemsAppearHere =>
      'நீங்கள் ஸ்கேன் செய்யும்போது பொருட்கள் இங்கே தோன்றும்';

  @override
  String get posTransactionHistory => 'பரிவர்த்தனை வரலாறு';

  @override
  String get posFilters => 'வடிப்பான்கள்:';

  @override
  String get posClearAllFilters => 'அனைத்தையும் அழி';

  @override
  String get posNoTransactions => 'பரிவர்த்தனைகள் எதுவும் இல்லை';

  @override
  String get posTryAdjustFilters =>
      'உங்கள் வடிப்பான்களை சரிசெய்ய முயற்சிக்கவும்';

  @override
  String get posResetFilters => 'வடிப்பான்களை மீட்டமை';

  @override
  String get posFilterTransactions => 'பரிவர்த்தனைகளை வடிகட்டு';

  @override
  String get posPaymentStatus => 'கட்டண நிலை';

  @override
  String get posFilterAll => 'அனைத்தும்';

  @override
  String get posStatusCompleted => 'முடிந்தது';

  @override
  String get posStatusPending => 'நிலுவையில்';

  @override
  String get posDateRange => 'தேதி வரம்பு';

  @override
  String get posSelectDateRange => 'தேதி வரம்பைத் தேர்ந்தெடு';

  @override
  String get posApplyFilters => 'வடிப்பான்களை பயன்படுத்து';

  @override
  String get posOrderDetails => 'ஆர்டர் விவரங்கள்';

  @override
  String get posPaymentLabel => 'கட்டணம்';

  @override
  String get posTotalAmount => 'மொத்தத் தொகை';

  @override
  String posCustomerNumber(String id) {
    return 'வாடிக்கையாளர் #$id';
  }

  @override
  String get posItemsSummary => 'பொருட்கள் சுருக்கம்';

  @override
  String posProductNumber(String id) {
    return 'பொருள் #$id';
  }

  @override
  String get posUnitFallback => 'அலகு';

  @override
  String posPrintReceiptStatus(String status) {
    return 'ரசீதை அச்சிடு ($status)';
  }

  @override
  String get posReturnExchange => 'திரும்பப்பெறுதல் / பரிமாற்றம்';

  @override
  String get posSplitPayment => 'பிளவு கட்டணம்';

  @override
  String get posCashPaidNow => 'இப்போது செலுத்திய பணம்';

  @override
  String get posOnUdhaarCredit => 'உதாரில் (கடன்)';

  @override
  String get posUdhaarRecordedNote =>
      'உதார் பகுதி கடனாக பதிவு செய்யப்பட்டது — இருப்புக்கு உதார் தாவலைச் சரிபார்க்கவும்';

  @override
  String get posUdhaarSale => 'உதார் விற்பனை';

  @override
  String get posTotalPaid => 'மொத்தம் செலுத்தியது';

  @override
  String get posRecordedAsCredit =>
      'கடனாக பதிவு செய்யப்பட்டது — உதார் தாவலைச் சரிபார்க்கவும்';

  @override
  String get posBoughtAsBasket => 'கூடையாக வாங்கப்பட்டது';

  @override
  String get posBasketValue => 'கூடை மதிப்பு';

  @override
  String get posCustomerSaved => 'வாடிக்கையாளர் சேமித்தது';

  @override
  String get invSearchItemsOrCategories => 'பொருட்கள் அல்லது வகைகளைத் தேடு...';

  @override
  String get invShowLess => 'குறைவாகக் காட்டு';

  @override
  String invViewMore(int count) {
    return '+$count மேலும்';
  }

  @override
  String get invAll => 'அனைத்தும்';

  @override
  String get invUncategorised => 'வகைப்படுத்தப்படாதவை';

  @override
  String get invNoMatchesFound => 'பொருத்தங்கள் எதுவும் இல்லை';

  @override
  String invNearExpiryBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count பொருட்கள் விரைவில் காலாவதியாகின்றன — விலை குறைக்க அல்லது அழிக்க தட்டவும்',
      one:
          '1 பொருள் விரைவில் காலாவதியாகிறது — விலை குறைக்க அல்லது அழிக்க தட்டவும்',
    );
    return '$_temp0';
  }

  @override
  String invMissingPriceBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பொருட்களுக்கு ₹0 விலை — விலைகளை அமைக்க தட்டவும்',
      one: '1 பொருளுக்கு ₹0 விலை — விலைகளை அமைக்க தட்டவும்',
    );
    return '$_temp0';
  }

  @override
  String get invFlagFast => 'வேகம்';

  @override
  String get invFlagReorder => 'மீள் ஆர்டர்';

  @override
  String get invFlagLowStock => 'குறைந்த சரக்கு';

  @override
  String get invFlagDead => 'செயலற்றது';

  @override
  String get invFlagProfit => 'லாபம்';

  @override
  String invStockLabel(String stock) {
    return 'சரக்கு: $stock';
  }

  @override
  String get invUnitFallback => 'அலகு';

  @override
  String get invSyncFailedTapRetry =>
      'ஒத்திசைவு தோல்வி — மீண்டும் முயற்சிக்க தட்டவும்';

  @override
  String get invSyncingToServer => 'சர்வருக்கு ஒத்திசைக்கப்படுகிறது...';

  @override
  String get invNoInventoryYet => 'இன்னும் சரக்கு இல்லை';

  @override
  String get invNoInventoryHint =>
      'உங்கள் முதல் பொருளைச் சேர்க்க + ஐ தட்டவும்.\nமுதலில் ஒரு வகையை உருவாக்கி, பின்னர் பொருட்களைச் சேர்க்கவும்.';

  @override
  String get invAddFirstProduct => 'முதல் பொருளைச் சேர்';

  @override
  String get invCouldNotLoadInventory => 'சரக்கை ஏற்ற முடியவில்லை';

  @override
  String get invRetry => 'மீண்டும் முயற்சி';

  @override
  String get invSelectCategoryError => 'ஒரு வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String invVariantPriceRequired(int number) {
    return 'வகைபேதம் $number: விற்பனை விலை தேவை';
  }

  @override
  String get invProductSavedSyncing =>
      'பொருள் சேமிக்கப்பட்டது — பின்னணியில் ஒத்திசைக்கப்படுகிறது';

  @override
  String invVariantsSavedSyncing(int count) {
    return '$count வகைபேதங்கள் சேமிக்கப்பட்டன — பின்னணியில் ஒத்திசைக்கப்படுகிறது';
  }

  @override
  String get invAddProduct => 'பொருளைச் சேர்';

  @override
  String get invAddFromCatalog => 'பட்டியலிலிருந்து சேர்';

  @override
  String get invNewProduct => 'புதிய பொருள்';

  @override
  String get invSave => 'சேமி';

  @override
  String get invSearchProductName => 'பொருள் பெயரைத் தேடு...';

  @override
  String get invLoadMoreResults => 'மேலும் முடிவுகளை ஏற்று';

  @override
  String get invNoMoreSearchResults => 'மேலும் தேடல் முடிவுகள் இல்லை';

  @override
  String get invSearchProductCatalog => 'பொருள் பட்டியலைத் தேடு';

  @override
  String get invSearchCatalogHint =>
      'ஒரு பெயரை உள்ளிடவும் அல்லது பார்கோடை ஸ்கேன் செய்யவும்.\nகிடைக்கவில்லை எனில், கைமுறையாகச் சேர்க்கவும்.';

  @override
  String get invAddManually => 'கைமுறையாகச் சேர்';

  @override
  String get invAddManuallySub =>
      'பொருள் பட்டியலில் இல்லையா? விவரங்களை நீங்களே உள்ளிடவும்.';

  @override
  String get invProductAdded => 'பொருள் சேர்க்கப்பட்டது!';

  @override
  String invVariantsAdded(int count) {
    return '$count வகைபேதங்கள் சேர்க்கப்பட்டன!';
  }

  @override
  String get invLooseItem => 'தளர்வான பொருள்';

  @override
  String get invLooseItemSub => 'எடையால் விற்கப்படுகிறது (எ.கா. மைதா, பருப்பு)';

  @override
  String get invBasicDetails => 'அடிப்படை விவரங்கள்';

  @override
  String get invProductNameLabel => 'பொருள் பெயர் *';

  @override
  String get invRequired => 'தேவை';

  @override
  String get invBrandOptional => 'பிராண்ட் (விருப்பத்தேர்வு)';

  @override
  String get invSelectCategoryStar => 'வகையைத் தேர்ந்தெடு *';

  @override
  String get invOther => 'மற்றவை';

  @override
  String get invPerishableItem => 'அழியக்கூடிய பொருள்';

  @override
  String get invPerishableItemSub => 'காலாவதி தேதி உள்ளது';

  @override
  String get invSizePriceStock => 'அளவு, விலை & சரக்கு';

  @override
  String invVariantsCount(int count) {
    return 'வகைபேதங்கள் ($count)';
  }

  @override
  String get invAddVariant => 'வகைபேதம் சேர்';

  @override
  String get invManageVariants => 'வகைகளை நிர்வகிக்கவும்';

  @override
  String get invVariants => 'வகைகள்';

  @override
  String get invEditVariant => 'வகையைத் திருத்து';

  @override
  String get invSaveVariant => 'வகையைச் சேமி';

  @override
  String get invNoVariantsYet =>
      'இன்னும் வகைகள் இல்லை. அளவு, நிறம் அல்லது மாடல் சேர்க்கவும்.';

  @override
  String get invStockPerVariantNote =>
      'ஸ்டாக் ஒவ்வொரு வகைக்கும் தனித்தனியாகக் கண்காணிக்கப்படுகிறது. கீழே உள்ள \'வகைகளை நிர்வகிக்கவும்\' ஐப் பயன்படுத்தவும்.';

  @override
  String get invDefaultVariant => 'இயல்புநிலை';

  @override
  String invVariantAxisRequired(String label) {
    return '$label தேர்ந்தெடுக்கவும்';
  }

  @override
  String get invSaveProduct => 'பொருளைச் சேமி';

  @override
  String invSaveVariants(int count) {
    return '$count வகைபேதங்களைச் சேமி';
  }

  @override
  String get invProduct => 'பொருள்';

  @override
  String invVariantNumber(int number) {
    return 'வகைபேதம் $number';
  }

  @override
  String get invUnit => 'அலகு';

  @override
  String get invBaseUnit => 'அடிப்படை அலகு';

  @override
  String get invPackSize => 'தொகுப்பு அளவு';

  @override
  String get invPackSizeHint => 'எ.கா. 250';

  @override
  String get invBarcode => 'பார்கோடு';

  @override
  String get invFromCatalog => 'பட்டியலிலிருந்து';

  @override
  String get invOptional => 'விருப்பத்தேர்வு';

  @override
  String invPricePerUnit(String unit) {
    return 'விலை / $unit *';
  }

  @override
  String get invSellingPriceStar => 'விற்பனை விலை *';

  @override
  String get invInvalid => 'தவறானது';

  @override
  String get invMrp => 'MRP';

  @override
  String get invCostPrice => 'செலவு விலை (நீங்கள் செலுத்துவது)';

  @override
  String get invCostPriceHint =>
      'விருப்பத்தேர்வு — லாப துல்லியத்தை மேம்படுத்துகிறது';

  @override
  String invOpeningStockUnit(String unit) {
    return 'தொடக்க சரக்கு ($unit) *';
  }

  @override
  String get invOpeningStockUnits => 'தொடக்க சரக்கு (அலகுகள்) *';

  @override
  String get invExpiryDate => 'காலாவதி தேதி';

  @override
  String get invExpiryDateHint => 'YYYY-MM-DD';

  @override
  String get invRequiredForPerishables => 'அழியக்கூடிய பொருட்களுக்குத் தேவை';

  @override
  String get invLinkedFromCatalog => 'பட்டியலிலிருந்து இணைக்கப்பட்டது';

  @override
  String get invSelectCategory => 'வகையைத் தேர்ந்தெடு';

  @override
  String get invSearchCategories => 'வகைகளைத் தேடு...';

  @override
  String get invNoCategoriesFound => 'வகைகள் எதுவும் இல்லை';

  @override
  String get invEditProduct => 'பொருளைத் திருத்து';

  @override
  String invProductUpdated(String name) {
    return '$name புதுப்பிக்கப்பட்டது!';
  }

  @override
  String get invProductUpdatedSuccess =>
      'பொருள் வெற்றிகரமாக புதுப்பிக்கப்பட்டது!';

  @override
  String get invSellingUnit => 'விற்பனை அலகு';

  @override
  String get invPricing => 'விலை நிர்ணயம்';

  @override
  String invPricePerSelected(String unit) {
    return 'ஒரு $unit விலை *';
  }

  @override
  String get invMrpOptional => 'MRP (விருப்பத்தேர்வு)';

  @override
  String get invStock => 'சரக்கு';

  @override
  String get invGstRate => 'GST %';

  @override
  String get invHsnCode => 'HSN குறியீடு';

  @override
  String get invWarranty => 'உத்தரவாதம்';

  @override
  String get invWarrantyCovered => 'உத்தரவாதத்தில் அடங்கும்';

  @override
  String get invWarrantyCoveredSub =>
      'எவ்வளவு காலம் என அமைக்கவும் — வாங்கிய தேதியிலிருந்து கணக்கிடப்படும்';

  @override
  String get invWarrantyPeriod => 'உத்தரவாத காலம்';

  @override
  String invStockInUnit(String unit) {
    return 'சரக்கு ($unit இல்) *';
  }

  @override
  String get invStockQuantityStar => 'சரக்கு அளவு *';

  @override
  String get invPerishableBatchNote =>
      'அழியக்கூடிய தொகுதி விவரங்களுக்கு, சரக்கிலிருந்து \"தொகுதியைப் பெறு\" ஐப் பயன்படுத்தவும்.';

  @override
  String get invSaveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get invCategoryNameRequired => 'வகை பெயர் தேவை';

  @override
  String get invCreateCategoryFailed =>
      'வகையை உருவாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get invNewCategory => 'புதிய வகை';

  @override
  String get invNewCategorySub =>
      'உங்கள் பொருட்களை ஒழுங்கமைக்க ஒரு வகையைச் சேர்க்கவும்.';

  @override
  String get invCategoryCreated => 'வகை உருவாக்கப்பட்டது!';

  @override
  String get invCategoryNameLabel => 'வகை பெயர்';

  @override
  String get invCategoryNameHint =>
      'எ.கா. அத்தியாவசியங்கள், பால் பொருட்கள், சிற்றுண்டிகள்…';

  @override
  String get invCreateCategory => 'வகையை உருவாக்கு';

  @override
  String get invCardOutOfStock => 'சரக்கில் இல்லை';

  @override
  String invCardStockLow(String qty) {
    return '$qty — குறைவு';
  }

  @override
  String invCardStockInStock(String qty) {
    return '$qty சரக்கில் உள்ளது';
  }

  @override
  String get invCardFast => 'வேகம்';

  @override
  String get invCardSlow => 'மெதுவாக';

  @override
  String get invCardExpired => 'காலாவதியானது';

  @override
  String invCardDays(String days) {
    return '$daysநா';
  }

  @override
  String get invCardBarcode => 'பார்கோடு';

  @override
  String get invCardSoldToday => 'இன்று விற்றது';

  @override
  String get invCardReorder => 'மீள் ஆர்டர்';

  @override
  String invCardReorderUnits(String qty) {
    return '$qty அலகுகள்';
  }

  @override
  String get invCard7dRisk => '7நா ஆபத்து';

  @override
  String get invExpiringSoon => 'விரைவில் காலாவதியாகிறது';

  @override
  String get invNext => 'அடுத்து';

  @override
  String invDaysWindow(int days) {
    return '$days நாட்கள்';
  }

  @override
  String get invExpired => 'காலாவதியானது';

  @override
  String get invExpiresToday => 'இன்று காலாவதியாகிறது';

  @override
  String get invExpiresTomorrow => 'நாளை காலாவதியாகிறது';

  @override
  String invExpiresInDays(int days) {
    return '$days நாட்களில் காலாவதியாகிறது';
  }

  @override
  String invQtyInStock(String qty, String unit) {
    return '$qty $unit சரக்கில் உள்ளது';
  }

  @override
  String get invAtRisk => 'ஆபத்தில்';

  @override
  String get invMarkedDown => 'விலை குறைக்கப்பட்டது';

  @override
  String get invPrice => 'விலை';

  @override
  String get invChangeMarkdown => 'விலைக் குறைப்பை மாற்று';

  @override
  String get invMarkDown => 'விலை குறை';

  @override
  String get invRecordWaste => 'வீணானதைப் பதிவு செய்';

  @override
  String invMarkDownTitle(String name) {
    return '$name விலையைக் குறை';
  }

  @override
  String get invClearanceDiscount => 'காலாவதிக்கு முன் விற்க தீர்வு தள்ளுபடி';

  @override
  String invPctSuggested(String pct) {
    return '$pct% (பரிந்துரைக்கப்பட்டது)';
  }

  @override
  String invPct(String pct) {
    return '$pct%';
  }

  @override
  String get invCustom => 'தனிப்பயன்';

  @override
  String get invApplyMarkdown => 'விலைக் குறைப்பை பயன்படுத்து';

  @override
  String get invMarkdownApplied => 'விலைக் குறைப்பு பயன்படுத்தப்பட்டது';

  @override
  String get invMarkdownFailed => 'விலைக் குறைப்பை பயன்படுத்த முடியவில்லை';

  @override
  String invWriteOff(String name) {
    return '$name ஐ எழுதி நீக்கு';
  }

  @override
  String get invWriteOffSub =>
      'கெட்டுப்போன அலகுகளை சரக்கிலிருந்து அகற்றி இழப்பைப் பதிவு செய்கிறது.';

  @override
  String invOfQtyInStock(int qty) {
    return 'சரக்கில் உள்ள $qty இல்';
  }

  @override
  String invUnitsWrittenOff(int units) {
    return '$units அலகுகள் எழுதி நீக்கப்பட்டன';
  }

  @override
  String get invWasteFailed => 'வீணானதைப் பதிவு செய்ய முடியவில்லை';

  @override
  String get invNothingExpiring => 'விரைவில் எதுவும் காலாவதியாகவில்லை';

  @override
  String get invNothingExpiringSub =>
      'காலாவதி நெருங்கும் அழியக்கூடிய தொகுதிகள் இங்கே தோன்றும்.';

  @override
  String get invCouldNotLoadExpiry => 'காலாவதி தரவை ஏற்ற முடியவில்லை';

  @override
  String get invMissingPrices => 'விடுபட்ட விலைகள்';

  @override
  String get invCouldNotLoadPrices => 'விலைகளை ஏற்ற முடியவில்லை';

  @override
  String invStockCurrentlyZero(String qty, String unit) {
    return '$qty $unit சரக்கில் உள்ளது · தற்போது ₹0';
  }

  @override
  String invSuggestedPrice(String price, String source) {
    return 'பரிந்துரைக்கப்பட்டது ₹$price ($source)';
  }

  @override
  String get invSellingPrice => 'விற்பனை விலை';

  @override
  String get invSet => 'அமை';

  @override
  String get invEnterValidPrice => 'சரியான விலையை உள்ளிடவும்';

  @override
  String invProductPriced(String name, String price) {
    return '$name விலை ₹$price';
  }

  @override
  String get invCouldNotSetPrice => 'விலையை அமைக்க முடியவில்லை';

  @override
  String get invEveryProductPriced => 'ஒவ்வொரு பொருளுக்கும் விலை உள்ளது';

  @override
  String get invEveryProductPricedSub =>
      'எதுவும் ₹0 க்கு விற்கப்படவில்லை. நன்றாக போகிறது!';

  @override
  String get finFinance => 'நிதி';

  @override
  String get finErrorLoadingStats => 'புள்ளிவிவரங்களை ஏற்றுவதில் பிழை';

  @override
  String get finTabCashflow => 'பணப்புழக்கம்';

  @override
  String get finTabCustomerUdhaar => 'வாடிக்கையாளர்\nஉதார்';

  @override
  String get finTabSupplierUdhaar => 'சப்ளையர் உதார்';

  @override
  String get finMonthlySales => 'மாதாந்திர விற்பனை';

  @override
  String get finMonthlySkus => 'மாதாந்திர SKUகள்';

  @override
  String get finAvailableInFuture => 'எதிர்கால புதுப்பிப்புகளில் கிடைக்கும்';

  @override
  String get finFailedLoadUdhaar => 'உதார் தரவை ஏற்ற முடியவில்லை';

  @override
  String get finCheckConnection =>
      'உங்கள் இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get finRetry => 'மீண்டும் முயற்சி';

  @override
  String get finCustomerDues => 'வாடிக்கையாளர் நிலுவைகள்';

  @override
  String get finNewUdhaar => 'புதிய உதார்';

  @override
  String get finAddNewUdhaar => 'புதிய உதார் சேர்';

  @override
  String get finContacts => 'தொடர்புகள்';

  @override
  String get finSelectExistingCustomer =>
      'தற்போதுள்ள வாடிக்கையாளரைத் தேர்ந்தெடு';

  @override
  String get finOrEnterManually => 'அல்லது கைமுறையாக உள்ளிடவும்';

  @override
  String get finUdhaarRecorded => 'உதார் பதிவு செய்யப்பட்டது!';

  @override
  String get finCustomerName => 'வாடிக்கையாளர் பெயர்';

  @override
  String get finPhoneNumber => 'தொலைபேசி எண்';

  @override
  String get finAmount => 'தொகை';

  @override
  String get finSaveUdhaar => 'உதார் சேமி';

  @override
  String get finEnterValidNamePhoneAmount =>
      'சரியான பெயர், தொலைபேசி மற்றும் தொகையை உள்ளிடவும்';

  @override
  String get finSelectCustomer => 'வாடிக்கையாளரைத் தேர்ந்தெடு';

  @override
  String get finSearchByNameOrPhone => 'பெயர் அல்லது தொலைபேசி மூலம் தேடு...';

  @override
  String get finNoCustomersFound => 'வாடிக்கையாளர்கள் எவரும் இல்லை';

  @override
  String get finTotalPending => 'மொத்த நிலுவை';

  @override
  String get finRecovered => 'மீட்கப்பட்டது';

  @override
  String get finCustomers => 'வாடிக்கையாளர்கள்';

  @override
  String finHighRiskDues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'கள்',
      one: '',
    );
    return '$count அதிக ஆபத்துள்ள நிலுவை$_temp0 — இவற்றை முதலில் பின்தொடரவும்';
  }

  @override
  String get finSmartRemindersSubtitle =>
      'ஸ்மார்ட் நினைவூட்டல்கள் — மீட்பு-வரிசைப்படுத்தப்பட்ட நிலுவைகள்';

  @override
  String finTakenDaysAgo(String date, int days) {
    return 'எடுக்கப்பட்டது: $date ($days நாட்களுக்கு முன்)';
  }

  @override
  String get finWhatsappReminderSent => 'WhatsApp நினைவூட்டல் அனுப்பப்பட்டது!';

  @override
  String finFailedSendReminder(String error) {
    return 'நினைவூட்டலை அனுப்ப முடியவில்லை: $error';
  }

  @override
  String get finSendWhatsappReminder => 'WhatsApp நினைவூட்டலை அனுப்பு';

  @override
  String get finRemind => 'நினைவூட்டு';

  @override
  String get finRemindedToday => 'இன்று நினைவூட்டப்பட்டது';

  @override
  String get finRecover => 'மீட்டெடு';

  @override
  String get finHistory => 'வரலாறு';

  @override
  String get finSettled => 'தீர்க்கப்பட்டது';

  @override
  String get finRecordPayment => 'கட்டணம் பதிவு செய்';

  @override
  String get finPaymentOldestFirstNote =>
      'பழைய நிலுவைகளுக்கு முதலில் பயன்படுத்தப்படும்';

  @override
  String get finTaken => 'எடுத்தது';

  @override
  String get finPaid => 'செலுத்தியது';

  @override
  String get finBalanceShort => 'மீதம்';

  @override
  String finOpenDuesSummary(int count, int days) {
    return '$count நிலுவை · பழையது $days நாட்கள்';
  }

  @override
  String finSettledSectionTitle(int count) {
    return 'தீர்க்கப்பட்டது ($count)';
  }

  @override
  String finRecoverUdhaarFrom(String name) {
    return '$name இடமிருந்து உதார் மீட்டெடு';
  }

  @override
  String get finRecoveryRecorded => 'மீட்பு பதிவு செய்யப்பட்டது!';

  @override
  String finBalanceLabel(String value) {
    return 'இருப்பு: ₹$value';
  }

  @override
  String get finConfirmRecovery => 'மீட்பை உறுதிப்படுத்து';

  @override
  String get finEnterValidAmount => 'சரியான தொகையை உள்ளிடவும்';

  @override
  String finAmountExceedsBalance(String value) {
    return 'தொகை இருப்பு ₹$value ஐ விட அதிகமாக இருக்கக்கூடாது';
  }

  @override
  String get finNoPendingUdhaars => 'நிலுவையில் உதார்கள் இல்லை';

  @override
  String get finRecoveryHistory => 'மீட்பு வரலாறு';

  @override
  String get finNoRecoveriesYet => 'இன்னும் மீட்புகள் பதிவு செய்யப்படவில்லை.';

  @override
  String finRecoveryNumber(int number) {
    return 'மீட்பு #$number';
  }

  @override
  String finErrorWithMessage(String message) {
    return 'பிழை: $message';
  }

  @override
  String get finOverdue => 'தாமதமானது';

  @override
  String get finDueToday => 'இன்று செலுத்த வேண்டியது';

  @override
  String get finNext7Days => 'அடுத்த 7 நாட்கள்';

  @override
  String get finNoPendingPayments7Days =>
      'அடுத்த 7 நாட்களில் நிலுவையில் கட்டணங்கள் இல்லை';

  @override
  String get finPaidLast7Days => 'கடந்த 7 நாட்களில் செலுத்தியது';

  @override
  String get finNoPaymentsRecorded7Days =>
      'கடந்த 7 நாட்களில் கட்டணங்கள் எதுவும் பதிவு செய்யப்படவில்லை';

  @override
  String get finSuppliers => 'சப்ளையர்கள்';

  @override
  String get finAddEditSuppliersHint =>
      'கொள்முதல் தாவலில் சப்ளையர்களைச் சேர்க்கவும் அல்லது திருத்தவும்';

  @override
  String get finNoSuppliersYet => 'இன்னும் சப்ளையர்கள் இல்லை.';

  @override
  String get finTotalOutstanding => 'மொத்த நிலுவைத் தொகை';

  @override
  String get finToday => 'இன்று';

  @override
  String get finPaid7d => 'செலுத்தியது (7நா)';

  @override
  String get finStockPurchase => 'சரக்கு கொள்முதல்';

  @override
  String finOverdueSince(String date) {
    return '$date முதல் தாமதமானது';
  }

  @override
  String finDueOn(String day) {
    return '$day செலுத்த வேண்டும்';
  }

  @override
  String get finDueTodayLabel => 'இன்று செலுத்த வேண்டியது';

  @override
  String get finToPay => 'செலுத்த வேண்டியது';

  @override
  String get finDetails => 'விவரங்கள்';

  @override
  String get finMarkPaid => 'செலுத்தியதாகக் குறி';

  @override
  String finPurchaseOn(String date) {
    return '$date அன்று கொள்முதல்';
  }

  @override
  String get finNoItemsFound => 'பொருட்கள் எதுவும் இல்லை.';

  @override
  String get finTotalBill => 'மொத்த பில்';

  @override
  String get finTomorrow => 'நாளை';

  @override
  String get finWeekdayMon => 'திங்';

  @override
  String get finWeekdayTue => 'செவ்';

  @override
  String get finWeekdayWed => 'புத';

  @override
  String get finWeekdayThu => 'வியா';

  @override
  String get finWeekdayFri => 'வெள்';

  @override
  String get finWeekdaySat => 'சனி';

  @override
  String get finWeekdaySun => 'ஞாயி';

  @override
  String get finFailedLoadCashflow => 'பணப்புழக்க தரவை ஏற்ற முடியவில்லை';

  @override
  String get finIncome => 'வருமானம்';

  @override
  String get finTodaysSales => 'இன்றைய விற்பனை';

  @override
  String get finCreditExposureUdhaar => 'கடன் வெளிப்பாடு (உதார்)';

  @override
  String get finOutstanding => 'நிலுவை';

  @override
  String get finCustomersWithPendingDues => 'நிலுவைகள் உள்ள வாடிக்கையாளர்கள்';

  @override
  String finCustomersCount(int count) {
    return '$count வாடிக்கையாளர்கள்';
  }

  @override
  String get finCreditVsSalesRatio => 'கடன் vs விற்பனை விகிதம்';

  @override
  String finPercentOnCredit(String value) {
    return '$value% கடனில்';
  }

  @override
  String finOfMonthly(String value) {
    return 'மாதாந்திர $value இல்';
  }

  @override
  String get finCreditHealthy => 'ஆரோக்கியமானது — கடன் வெளிப்பாடு குறைவு';

  @override
  String get finCreditModerate =>
      'மிதமானது — நிலுவைகளை வசூலிக்க பரிசீலிக்கவும்';

  @override
  String get finCreditHigh => 'அதிகம் — பல விற்பனைகள் கடனில் உள்ளன';

  @override
  String get finConsentTitle => 'வாடிக்கையாளர் ஒப்புதலைப் பதிவு செய்க';

  @override
  String get finConsentSubtitle => 'இந்த உதாருக்கு குரல் உறுதிப்படுத்தல்';

  @override
  String get finConsentScriptIntro =>
      'வாடிக்கையாளரை இப்படிச் சொல்லச் சொல்லுங்கள்:';

  @override
  String finConsentScript(String total, String udhaar, String date) {
    return 'நான் ஒப்புக்கொள்கிறேன் — மொத்தம் $total, உதார் $udhaar, $date க்குள் திருப்பிச் செலுத்துவேன்.';
  }

  @override
  String get finConsentTapToRecord =>
      'மைக்கை அழுத்தி வாடிக்கையாளரைப் பேச விடுங்கள்';

  @override
  String get finConsentRecording => 'பதிவாகிறது';

  @override
  String get finConsentSaved =>
      'ஒப்புதல் சேமிக்கப்பட்டது — பின்னணியில் பதிவேற்றப்படுகிறது';

  @override
  String get finConsentSkip => 'தவிர்';

  @override
  String get finConsentSectionTitle => 'குரல் ஒப்புதல்';

  @override
  String get finConsentStatusPending =>
      'பதிவேற்றப்பட்டது · பகுப்பாய்வு நிலுவையில்';

  @override
  String get finConsentStatusAnalyzed => 'சரிபார்க்கப்பட்டது';

  @override
  String finConsentMatchScore(String pct) {
    return 'குரல் பொருத்தம்: $pct%';
  }

  @override
  String get finConsentNone => 'குரல் ஒப்புதல் பதிவு இல்லை';

  @override
  String get finDueDate => 'திருப்பிச் செலுத்தும் தேதி';

  @override
  String get finDueDateHint => 'வாடிக்கையாளர் எப்போது திருப்பிச் செலுத்துவார்?';

  @override
  String finDueBy(String date) {
    return '$date க்குள் செலுத்த வேண்டும்';
  }

  @override
  String finClearingDues(int count) {
    return '$count கடன்கள் முடிக்கப்படுகின்றன…';
  }

  @override
  String finDuesCleared(int count) {
    return '$count கடன்கள் முடிக்கப்பட்டன';
  }

  @override
  String finClearingDuesProgress(int cleared, int total) {
    return 'நிலுவைகள் அடைக்கப்படுகின்றன: $cleared/$total';
  }

  @override
  String finDuesClearFailed(int cleared, int total) {
    return 'எல்லா நிலுவைகளையும் அடைக்க முடியவில்லை ($cleared/$total)';
  }

  @override
  String get finSmartReminders => 'ஸ்மார்ட் நினைவூட்டல்கள்';

  @override
  String get finCouldNotLoadReminders => 'நினைவூட்டல்களை ஏற்ற முடியவில்லை';

  @override
  String finDaysPending(int days) {
    return '$days நாட்கள் நிலுவையில்';
  }

  @override
  String finRiskBadge(String band) {
    return '$band ஆபத்து';
  }

  @override
  String finLikelyToRecover(int percent) {
    return '~$percent% மீட்க வாய்ப்பு';
  }

  @override
  String get finSendReminder => 'நினைவூட்டலை அனுப்பு';

  @override
  String finReminderSentTo(String name) {
    return '$name க்கு நினைவூட்டல் அனுப்பப்பட்டது';
  }

  @override
  String get finCouldNotSendReminder => 'நினைவூட்டலை அனுப்ப முடியவில்லை';

  @override
  String get finNoOpenUdhaar => 'திறந்த உதார் இல்லை';

  @override
  String get finAllCreditSettled => 'அனைத்து கடனும் தீர்க்கப்பட்டது. அருமை!';

  @override
  String get procAddSupplierFirstToCreatePo =>
      'கொள்முதல் ஆர்டரை உருவாக்க முதலில் ஒரு சப்ளையரைச் சேர்க்கவும்';

  @override
  String procErrorWithMessage(String message) {
    return 'பிழை: $message';
  }

  @override
  String get procSuppliers => 'சப்ளையர்கள்';

  @override
  String get procNoSuppliersYet => 'இன்னும் சப்ளையர்கள் சேர்க்கப்படவில்லை.';

  @override
  String get procRecentPurchases => 'சமீபத்திய கொள்முதல்கள்';

  @override
  String get procAddAtLeastOneSupplier =>
      'ஒரு கொள்முதலைச் சேர்க்க விரும்பினால், குறைந்தது 1 சப்ளையரைச் சேர்க்கவும்.';

  @override
  String get procNoPurchaseOrdersYet => 'இன்னும் கொள்முதல் ஆர்டர்கள் இல்லை.';

  @override
  String get procScanInvoice => 'விலைப்பட்டியலை ஸ்கேன் செய்';

  @override
  String get procAdd => 'சேர்';

  @override
  String get procSuggestedReorders => 'பரிந்துரைக்கப்பட்ட மீள் ஆர்டர்கள்';

  @override
  String get procRunningLowLast30Days =>
      'கடந்த 30 நாட்களின் விற்பனை அடிப்படையில் குறைந்து வருகிறது';

  @override
  String get procAddNewSupplier => 'புதிய சப்ளையரைச் சேர்';

  @override
  String get procContacts => 'தொடர்புகள்';

  @override
  String get procSupplierName => 'சப்ளையர் பெயர்';

  @override
  String get procPhoneNumber => 'தொலைபேசி எண்';

  @override
  String get procCategoryHint => 'வகை (எ.கா. பால் பொருட்கள், FMCG)';

  @override
  String get procEnterValidPhone => 'சரியான தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get procSaveSupplier => 'சப்ளையரைச் சேமி';

  @override
  String get procEditSupplier => 'சப்ளையரைத் திருத்து';

  @override
  String get procSaveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get procNewPurchaseOrder => 'புதிய கொள்முதல் ஆர்டர்';

  @override
  String get procRecordItemsFromDistributor =>
      'ஒரு விநியோகஸ்தரிடமிருந்து வாங்கிய பொருட்களைப் பதிவு செய்யவும்.';

  @override
  String get procOrderDetails => 'ஆர்டர் விவரங்கள்';

  @override
  String get procDistributor => 'விநியோகஸ்தர்';

  @override
  String get procPaymentDueDate => 'கட்டணம் செலுத்த வேண்டிய தேதி';

  @override
  String get procSelectDate => 'தேதியைத் தேர்ந்தெடு';

  @override
  String procItemsCount(int count) {
    return 'பொருட்கள் ($count)';
  }

  @override
  String get procAddItem => 'பொருளைச் சேர்';

  @override
  String get procNoItemsAddedYet => 'இன்னும் பொருட்கள் சேர்க்கப்படவில்லை';

  @override
  String get procNotes => 'குறிப்புகள்';

  @override
  String get procNotesHint => 'பில் எண், டெலிவரி குறிப்புகள், போன்றவை.';

  @override
  String get procTotalAmount => 'மொத்தத் தொகை';

  @override
  String get procSaveOrder => 'ஆர்டரைச் சேமி';

  @override
  String get procSearchProduct => 'பொருளைத் தேடு...';

  @override
  String procAddProduct(String name) {
    return '$name ஐச் சேர்';
  }

  @override
  String get procQuantity => 'அளவு';

  @override
  String get procCostPricePerUnit => 'ஒரு அலகுக்கான செலவு விலை';

  @override
  String get procCancel => 'ரத்துசெய்';

  @override
  String procDaysCover(String days) {
    return '$daysநா கவரேஜ்';
  }

  @override
  String procOrderQty(String qty) {
    return 'ஆர்டர் $qty';
  }

  @override
  String procStockLine(String stock, String perDay, String cover) {
    return 'சரக்கு $stock · ~$perDay/நாள் · $cover';
  }

  @override
  String get procCreatePurchaseOrder => 'கொள்முதல் ஆர்டரை உருவாக்கு';

  @override
  String get procEditSupplierTooltip => 'சப்ளையரைத் திருத்து';

  @override
  String get procMarkAsReceived => 'பெறப்பட்டதாகக் குறி';

  @override
  String get procPleaseSelectSupplierFirst =>
      'முதலில் ஒரு சப்ளையரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get procFromScannedInvoice =>
      'ஸ்கேன் செய்யப்பட்ட விலைப்பட்டியலிலிருந்து';

  @override
  String procPoCreatedWithUnmatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'கள்',
      one: '',
    );
    return 'கொள்முதல் ஆர்டர் உருவாக்கப்பட்டது! ($count பொருள்$_temp0 பொருந்தவில்லை)';
  }

  @override
  String get procPoCreatedFromInvoice =>
      'விலைப்பட்டியலிலிருந்து கொள்முதல் ஆர்டர் உருவாக்கப்பட்டது!';

  @override
  String get procCameraGalleryPdf => 'கேமரா · கேலரி · PDF';

  @override
  String get procScansLabel => 'ஸ்கேன்கள்';

  @override
  String get procScanAgain => 'மீண்டும் ஸ்கேன் செய்';

  @override
  String get procInvoiceScanProFeature =>
      'விலைப்பட்டியல் ஸ்கேன் ஒரு Pro அம்சம்.';

  @override
  String get procUpgradeToPro => 'Pro க்கு மேம்படுத்து';

  @override
  String get procDailyLimitReached =>
      'தினசரி வரம்பு எட்டப்பட்டது. தொடர கிரெடிட்களை நிரப்பவும்.';

  @override
  String get procBuyCredits => 'கிரெடிட்களை வாங்கு';

  @override
  String get procCreatingPurchaseOrder =>
      'கொள்முதல் ஆர்டர் உருவாக்கப்படுகிறது…';

  @override
  String get procPurchaseOrderCreated => 'கொள்முதல் ஆர்டர் உருவாக்கப்பட்டது!';

  @override
  String get procTryAgain => 'மீண்டும் முயற்சி';

  @override
  String get procCaptureOrUploadInvoice =>
      'ஒரு சப்ளையர் விலைப்பட்டியலைப் படம்பிடிக்கவும் அல்லது பதிவேற்றவும்';

  @override
  String get procUpgradeOrTopUp =>
      'Pro க்கு மேம்படுத்தவும் அல்லது கிரெடிட்களை நிரப்பவும்';

  @override
  String get procKiranaAiReadsInvoice =>
      'Outlet AI பொருட்கள், மொத்தங்கள் & சப்ளையர் விவரங்களைப் படிக்கிறது';

  @override
  String get procCamera => 'கேமரா';

  @override
  String get procGallery => 'கேலரி';

  @override
  String get procUploadPdfImageFile => 'PDF / பட கோப்பைப் பதிவேற்று';

  @override
  String get procKiranaAiReadingInvoice =>
      'Outlet AI உங்கள் விலைப்பட்டியலைப் படிக்கிறது…';

  @override
  String get procExtractingItems =>
      'பொருட்கள், அளவுகள் மற்றும் மொத்தங்கள் பிரித்தெடுக்கப்படுகின்றன';

  @override
  String get procGrandTotal => 'மொத்தத் தொகை';

  @override
  String get procSupplierUpper => 'சப்ளையர்';

  @override
  String procItemsUpperCount(int count) {
    return 'பொருட்கள் ($count)';
  }

  @override
  String procMatchedCount(int count) {
    return '$count பொருந்தியது';
  }

  @override
  String procUnmatchedItemsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'கள்',
      one: '',
    );
    return '$count பொருந்தாத பொருள்$_temp0 வரி உருப்படிகளாகச் சேர்க்கப்படாது, ஆனால் முழு விலைப்பட்டியல் மொத்தம் பதிவு செய்யப்படும்.';
  }

  @override
  String get procSelectSupplierToContinue => 'தொடர ஒரு சப்ளையரைத் தேர்ந்தெடு';

  @override
  String get procCreatePurchaseOrderTitle => 'கொள்முதல் ஆர்டரை உருவாக்கு';

  @override
  String procConfidencePercent(int pct) {
    return '$pct% நம்பகத்தன்மை';
  }

  @override
  String get procTotalsMatch => '✓ மொத்தங்கள் பொருந்துகின்றன';

  @override
  String get procTotalMismatch => '⚠ மொத்தம் பொருந்தவில்லை';

  @override
  String get procUnverified => 'சரிபார்க்கப்படாதது';

  @override
  String get procPick => 'தேர்வுசெய்';

  @override
  String procNoMatchTapToSelect(String vendor) {
    return '\"$vendor\" க்கு பொருத்தம் இல்லை — தேர்ந்தெடுக்க தட்டவும்';
  }

  @override
  String get procSelectSupplier => 'சப்ளையரைத் தேர்ந்தெடு';

  @override
  String get procSelectSupplierTitle => 'சப்ளையரைத் தேர்ந்தெடு';

  @override
  String get procNoSuppliersAddInPurchaseTab =>
      'இன்னும் சப்ளையர்கள் இல்லை. கொள்முதல் தாவலில் சப்ளையர்களைச் சேர்க்கவும்.';

  @override
  String get procLinkToInventory => 'சரக்குடன் இணை';

  @override
  String get procSearchProducts => 'பொருட்களைத் தேடு…';

  @override
  String get procNoProductsFound => 'பொருட்கள் எதுவும் இல்லை';

  @override
  String procPriceStockLabel(String price, String stock) {
    return '$price · சரக்கு: $stock';
  }

  @override
  String get procMicPermissionDenied =>
      'மைக்ரோஃபோன் அனுமதி மறுக்கப்பட்டது. அமைப்புகளில் அதை இயக்கவும்.';

  @override
  String get procMicNotAccessible => 'மைக்ரோஃபோன் அணுக முடியவில்லை.';

  @override
  String procAddedToCartFromVoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'கள்',
      one: '',
    );
    return 'குரல் ஆர்டரிலிருந்து $count பொருள்$_temp0 கார்ட்டில் சேர்க்கப்பட்டது';
  }

  @override
  String get procVoiceOrder => 'குரல் ஆர்டர்';

  @override
  String get procSpeakAnyIndianLanguage => 'எந்த இந்திய மொழியிலும் பேசுங்கள்';

  @override
  String get procVoiceOrderProFeature =>
      'குரல் ஆர்டர் ஒரு Pro அம்சம். அணுக மேம்படுத்தவும்.';

  @override
  String get procUpgrade => 'மேம்படுத்து';

  @override
  String get procNoVoiceOrdersLeft =>
      'இன்று குரல் ஆர்டர்கள் மீதம் இல்லை. மேலும் கிரெடிட்களைப் பெறுங்கள்.';

  @override
  String get procGetCredits => 'கிரெடிட்களைப் பெறு';

  @override
  String get procVoiceLabel => 'குரல்';

  @override
  String get procTapMicToStart => 'பதிவு செய்யத் தொடங்க மைக்கைத் தட்டவும்';

  @override
  String get procTapToStopAndProcess => 'நிறுத்தி செயலாக்க தட்டவும்';

  @override
  String get procKiranaAiProcessing => 'Outlet AI செயலாக்குகிறது…';

  @override
  String get procHeard => 'கேட்டது';

  @override
  String get procNoItemsDetectedTryAgain =>
      'பொருட்கள் எதுவும் கண்டறியப்படவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get procRecordAgain => 'மீண்டும் பதிவு செய்';

  @override
  String procAddToCartCount(int count) {
    return '$count ஐ கார்ட்டில் சேர்';
  }

  @override
  String get procAutoDetectsLanguages =>
      'தானாக கண்டறிகிறது: தெலுங்கு · இந்தி · உருது · தமிழ் · கன்னடம் · மலையாளம் · ஆங்கிலம்';

  @override
  String get procInStock => 'சரக்கில் உள்ளது';

  @override
  String get procLowStock => 'குறைந்த சரக்கு';

  @override
  String get procNotFound => 'கிடைக்கவில்லை';

  @override
  String get procPickFromInventory => 'சரக்கிலிருந்து தேர்வுசெய்';

  @override
  String procAddedToCartFromHandwriting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'கள்',
      one: '',
    );
    return 'கையெழுத்திலிருந்து $count பொருள்$_temp0 கார்ட்டில் சேர்க்கப்பட்டது';
  }

  @override
  String get procCanvasNotReady => 'கேன்வாஸ் தயாராக இல்லை';

  @override
  String get procFailedToCaptureCanvas => 'கேன்வாஸைப் படம்பிடிக்க முடியவில்லை';

  @override
  String get procHandwriteOrder => 'கையெழுத்து ஆர்டர்';

  @override
  String get procWriteItemsAnyScript => 'எந்த எழுத்திலும் பொருட்களை எழுதுங்கள்';

  @override
  String get procDrawsLabel => 'வரைதல்கள்';

  @override
  String get procUndoLastStroke => 'கடைசி கோட்டை செயல்தவிர்';

  @override
  String get procClear => 'அழி';

  @override
  String get procHandwriteOrderProFeature =>
      'கையெழுத்து ஆர்டர் ஒரு Pro அம்சம்.';

  @override
  String get procAutoDetectAfter5s => '5வி பிறகு தானாக கண்டறி';

  @override
  String get procWriteItemsHere => 'இங்கே பொருட்களை எழுதுங்கள்';

  @override
  String get procUpgradeOrTopUpToWrite =>
      'எழுத மேம்படுத்தவும் அல்லது நிரப்பவும்';

  @override
  String get procHandwriteExample => 'எ.கா. அரிசி 5கிலோ, சர்க்கரை 2கிலோ';

  @override
  String get procDetecting => 'கண்டறியப்படுகிறது…';

  @override
  String get procDetectItems => 'பொருட்களைக் கண்டறி';

  @override
  String get procRead => 'படி';

  @override
  String get procNoItemsDetectedWriteClearly =>
      'பொருட்கள் எதுவும் கண்டறியப்படவில்லை. தெளிவாக எழுத முயற்சிக்கவும்.';

  @override
  String get procWriteAgain => 'மீண்டும் எழுது';

  @override
  String get procAnyScriptLanguages =>
      'எந்த எழுத்தும்: English · తెలుగు · हिंदी · Tamil · ಕನ್ನಡ · മലയാളം';

  @override
  String procProductNumber(String id) {
    return 'பொருள் #$id';
  }

  @override
  String get procReturnExchange => 'திரும்பப்பெறுதல் / பரிமாற்றம்';

  @override
  String procOrderPickItemsToReturn(String id) {
    return 'ஆர்டர் #$id · திரும்பப்பெற பொருட்களைத் தேர்வுசெய்';
  }

  @override
  String get procRecordReturn => 'திரும்பப்பெறுதலைப் பதிவு செய்';

  @override
  String procBoughtQty(String qty) {
    return 'வாங்கியது $qty ';
  }

  @override
  String get procBackToShelf => 'அலமாரிக்குத் திரும்ப';

  @override
  String get procResaleable => 'மீண்டும் விற்கக்கூடியது';

  @override
  String get procDamagedToVendor => 'சேதமடைந்தது → விற்பனையாளர்';

  @override
  String procReturnRecordedShelf(int count) {
    return 'திரும்பப்பெறுதல் பதிவு செய்யப்பட்டது — $count அலமாரிக்குத் திரும்ப';
  }

  @override
  String procReturnToVendorSuffix(int count) {
    return ', $count விற்பனையாளருக்கு';
  }

  @override
  String get procCouldNotRecordReturn =>
      'திரும்பப்பெறுதலைப் பதிவு செய்ய முடியவில்லை';

  @override
  String get subYourInsights => 'உங்கள் நுண்ணறிவுகள்';

  @override
  String get subError => 'பிழை';

  @override
  String get subManageKpis => 'KPIகளை நிர்வகி';

  @override
  String get subManageSubscriptions => 'சந்தாக்களை நிர்வகி';

  @override
  String get subDone => 'முடிந்தது';

  @override
  String subKpisSelected(int n) {
    return '$n KPIகள் தேர்ந்தெடுக்கப்பட்டன';
  }

  @override
  String get subSelectAll => 'அனைத்தையும் தேர்ந்தெடு';

  @override
  String get subClear => 'அழி';

  @override
  String get subUnselect => 'தேர்வுநீக்கு';

  @override
  String subProKpiName(String name) {
    return 'Pro KPI: $name';
  }

  @override
  String get subConfirmSelections => 'தேர்வுகளை உறுதிப்படுத்து';

  @override
  String get subNoActiveKpis => 'செயலில் KPIகள் இல்லை';

  @override
  String get subManageToSeeInsights =>
      'நுண்ணறிவுகளைப் பார்க்க உங்கள் சந்தாக்களை நிர்வகிக்கவும்';

  @override
  String get subFailedLoadInsights => 'நேரடி நுண்ணறிவுகளை ஏற்ற முடியவில்லை';

  @override
  String get subManageInventory => 'சரக்கை நிர்வகி';

  @override
  String get subSendReminders => 'நினைவூட்டல்களை அனுப்பு';

  @override
  String get subReminderMessage =>
      'வணக்கம், எங்களுடனான உங்கள் வணிகம் தொடர்பான நினைவூட்டல் இது. உங்கள் சமீபத்திய புதுப்பிப்புகளைச் சரிபார்க்கவும்.';

  @override
  String get subNewSale => 'புதிய விற்பனை';

  @override
  String get subAiSummary => 'AI சுருக்கம்';

  @override
  String subPoweredBy(String agent) {
    return '$agent மூலம் இயக்கப்படுகிறது';
  }

  @override
  String get subTarget => 'இலக்கு';

  @override
  String get subBaseline => 'அடிப்படை நிலை';

  @override
  String get subLiveDataBreakdown => 'நேரடி தரவு பகுப்பாய்வு';

  @override
  String get subMlInsights => 'MI நுண்ணறிவுகள்';

  @override
  String get subNoDynamicInsights =>
      'இந்த KPI க்கு டைனமிக் நுண்ணறிவுகள் எதுவும் இல்லை.';

  @override
  String subPctVsLastPeriod(String pct) {
    return '$pct% கடந்த காலத்துடன்';
  }

  @override
  String get subCurrent => 'தற்போதைய';

  @override
  String get subWhyThisValue => 'இந்த மதிப்பு ஏன்?';

  @override
  String get subSomethingWentWrong => 'அய்யோ! ஏதோ தவறு நடந்தது';

  @override
  String get subRetry => 'மீண்டும் முயற்சி';

  @override
  String get subSubscriptionAndPlans => 'சந்தா & திட்டங்கள்';

  @override
  String subErrorWithDetail(String detail) {
    return 'பிழை: $detail';
  }

  @override
  String get subCancelSubscriptionTitle => 'சந்தாவை ரத்துசெய்யவா?';

  @override
  String get subCancelSubscriptionBody =>
      'உங்கள் சந்தா உடனடியாக ரத்துசெய்யப்படும். எந்த நேரத்திலும் மீண்டும் குழுசேரலாம்.';

  @override
  String get subKeepPlan => 'திட்டத்தை வைத்திரு';

  @override
  String get subCancelSubscription => 'சந்தாவை ரத்துசெய்';

  @override
  String get subSubscriptionCancelled => 'சந்தா ரத்துசெய்யப்பட்டது.';

  @override
  String subCancelFailed(String detail) {
    return 'ரத்துசெய்தல் தோல்வி: $detail';
  }

  @override
  String get subChooseYourPlan => 'உங்கள் திட்டத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get subFeaturePosSales => 'POS & விற்பனை மேலாண்மை';

  @override
  String get subFeatureInventoryTracking => 'சரக்கு கண்காணிப்பு';

  @override
  String get subFeatureFinanceUdhaar => 'நிதி & உதார்';

  @override
  String get subFeatureKpiInsights => 'KPI நுண்ணறிவுகள் (வகைக்கு 3)';

  @override
  String get subFeatureCustomerRelations => 'வாடிக்கையாளர் உறவுகள்';

  @override
  String get subFeatureAiRecommendations => 'AI பரிந்துரைகள்';

  @override
  String get subFeatureAllKpiCategories => 'அனைத்து KPI வகைகள் (வரம்பற்றது)';

  @override
  String get subFeatureVendorProcurement => 'விற்பனையாளர் & கொள்முதல் மேலாண்மை';

  @override
  String get subFeatureCashflowSupport => 'பணப்புழக்க ஆதரவு (₹10L வரை)';

  @override
  String get subFeatureCustomerGrowth => 'வாடிக்கையாளர் வளர்ச்சி இயந்திரம்';

  @override
  String get subPerMonth => '/மாதம்';

  @override
  String get subRestorePurchases => 'கொள்முதல்களை மீட்டமை';

  @override
  String get subNeedHelp => 'உதவி வேண்டுமா?';

  @override
  String get subReachWhatsApp =>
      'திட்ட கேள்விகள் அல்லது பில்லிங் ஆதரவுக்கு WhatsApp இல் எங்களை அணுகவும்.';

  @override
  String get subWhatsAppSupport => 'WhatsApp ஆதரவு';

  @override
  String get subWhatsAppHelpMessage =>
      'வணக்கம்! எனது Outlet AI சந்தாவில் எனக்கு உதவி தேவை.';

  @override
  String subCurrentPlanLabel(String plan) {
    return 'தற்போதைய: $plan';
  }

  @override
  String get subTimeRemaining => 'மீதமுள்ள நேரம்: ';

  @override
  String get subBest => 'சிறந்தது';

  @override
  String subJustPerDay(String price) {
    return 'வெறும் $price/நாள்';
  }

  @override
  String get subTrialPlanNotice =>
      'நீங்கள் இந்த திட்டத்தின் இலவச சோதனையில் உள்ளீர்கள். சோதனை முடிந்த பிறகு அணுகலைத் தக்கவைக்க மேம்படுத்தவும்.';

  @override
  String get subCurrentPlan => 'தற்போதைய திட்டம்';

  @override
  String subUpgradeToKeepAccess(String name) {
    return '$name அணுகலைத் தக்கவைக்க மேம்படுத்து';
  }

  @override
  String subPayAndActivate(String name) {
    return '$name ஐ செலுத்தி செயல்படுத்து';
  }

  @override
  String get subPaywallFeatureEverythingBasic => 'அடிப்படையில் உள்ள அனைத்தும்';

  @override
  String get subPaywallFeaturePriorityAi => 'முன்னுரிமை AI பரிந்துரைகள்';

  @override
  String get subProFeature => 'Pro அம்சம்';

  @override
  String get subProPlanIncludes => 'Pro திட்டத்தில் அடங்கியவை:';

  @override
  String get subNotNow => 'இப்போது இல்லை';

  @override
  String get subUpgradeToProPrice =>
      'Pro க்கு மேம்படுத்து  ₹500/மாதம் · வெறும் ₹17/நாள்';

  @override
  String get subInvoicePack => 'விலைப்பட்டியல் தொகுப்பு';

  @override
  String get subVoicePack => 'குரல் தொகுப்பு';

  @override
  String get subHandwritingPack => 'கையெழுத்து தொகுப்பு';

  @override
  String get subInvoicePackDesc => 'மேலும் 10 சப்ளையர் பில்களைச் செயலாக்கு';

  @override
  String get subVoicePackDesc => 'மேலும் 10 ஆடியோ/குரல் ஆர்டர்களைச் சேர்';

  @override
  String get subHandwritingPackDesc =>
      'மேலும் 10 கையெழுத்து குறிப்புகளை ஸ்கேன் செய்';

  @override
  String get subPrice => 'விலை';

  @override
  String get subCreditsRollOverDaily =>
      'கிரெடிட்கள் காலாவதியாகாது — அவை ஒவ்வொரு நாளும் கொண்டு செல்லப்படும்.';

  @override
  String get subCancel => 'ரத்துசெய்';

  @override
  String subPayAmount(int amount) {
    return '₹$amount செலுத்து';
  }

  @override
  String subCreditsAdded(int count, String name) {
    return '$count $name கிரெடிட்கள் சேர்க்கப்பட்டன!';
  }

  @override
  String get subTopUpCredits => 'உங்கள் கிரெடிட்களை நிரப்பு';

  @override
  String get subCreditsNeverExpire =>
      'கிரெடிட்கள் ஒருபோதும் காலாவதியாகாது — அவை நாளைக்கு கொண்டு செல்லப்படும்!';

  @override
  String subCreditsCount(int count) {
    return '$count கிரெடிட்கள்';
  }

  @override
  String get subBuy => 'வாங்கு';

  @override
  String get subTrialExpiredMessage =>
      'உங்கள் இலவச சோதனை காலாவதியானது. தொடர மேம்படுத்தவும்.';

  @override
  String get subTrialLastDayMessage =>
      'உங்கள் இலவச சோதனையின் கடைசி நாள்! இப்போது மேம்படுத்தவும்.';

  @override
  String subTrialDaysLeftMessage(int n) {
    return 'உங்கள் சோதனையில் $n நாட்கள் மீதம். Basic அல்லது Pro க்கு மேம்படுத்தவும்.';
  }

  @override
  String get subTrialExpiringSoon => 'சோதனை விரைவில் காலாவதியாகிறது';

  @override
  String get subTrialExpiredTitle => 'சோதனை காலாவதியானது';

  @override
  String get mktMyBaskets => 'எனது கூடைகள்';

  @override
  String get mktCouldNotLoadBaskets => 'கூடைகளை ஏற்ற முடியவில்லை';

  @override
  String get mktPullDownToRetry => 'மீண்டும் முயற்சிக்க கீழே இழுக்கவும்';

  @override
  String get mktRetry => 'மீண்டும் முயற்சி';

  @override
  String get mktNewBasket => 'புதிய கூடை';

  @override
  String get mktNoBasketsYet => 'இன்னும் கூடைகள் இல்லை';

  @override
  String get mktBasketsEmptySubtitle =>
      'காம்போ சலுகைகள் மற்றும் தொகுப்பு சலுகைகளை உருவாக்கு.\nWhatsApp மூலம் உங்கள் அனைத்து வாடிக்கையாளர்களையும் எச்சரிக்கவும்.';

  @override
  String get mktCreateFirstBasket => 'முதல் கூடையை உருவாக்கு';

  @override
  String get mktDeleteBasketTitle => 'கூடையை நீக்கவா?';

  @override
  String mktDeleteBasketConfirm(String name) {
    return '\"$name\" ஐ நீக்கவா? இதை மீட்டெடுக்க முடியாது.';
  }

  @override
  String get mktCancel => 'ரத்துசெய்';

  @override
  String get mktBasketDeleted => 'கூடை நீக்கப்பட்டது';

  @override
  String get mktCouldNotDeleteBasket =>
      'கூடையை நீக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get mktDelete => 'நீக்கு';

  @override
  String get mktSendWhatsAppAlertTitle => 'WhatsApp எச்சரிக்கையை அனுப்பவா?';

  @override
  String mktSendWhatsAppAlertConfirm(String name) {
    return '\"$name\" க்கான கூடை சலுகையை WhatsApp மூலம் உங்கள் அனைத்து வாடிக்கையாளர்களுக்கும் அனுப்பவா?';
  }

  @override
  String get mktSend => 'அனுப்பு';

  @override
  String mktWhatsAppAlertSent(int sent, int total) {
    return '$total வாடிக்கையாளர்களில் $sent பேருக்கு WhatsApp எச்சரிக்கை அனுப்பப்பட்டது!';
  }

  @override
  String get mktNoCustomersWithPhone =>
      'தொலைபேசி எண்கள் உள்ள வாடிக்கையாளர்கள் எவரும் இல்லை.';

  @override
  String mktWhatsAppNotActiveYet(int total) {
    return 'WhatsApp இன்னும் செயலில் இல்லை. இயக்கப்பட்டவுடன் $total வாடிக்கையாளர்களுக்கு எச்சரிக்கை தானாக அனுப்பப்படும்.';
  }

  @override
  String mktAlertFailed(String error) {
    return 'தோல்வி: $error';
  }

  @override
  String get mktExpired => 'காலாவதியானது';

  @override
  String get mktItem => 'பொருள்';

  @override
  String mktFromDate(String date) {
    return '$date முதல்';
  }

  @override
  String mktToDate(String date) {
    return '$date வரை';
  }

  @override
  String get mktAlertCustomers => 'வாடிக்கையாளர்களை எச்சரி';

  @override
  String get mktNoProductsInInventory =>
      'சரக்கில் பொருட்கள் இல்லை. முதலில் POS ஐ ஒத்திசைக்கவும்.';

  @override
  String get mktAllProductsAdded =>
      'அனைத்து பொருட்களும் ஏற்கனவே இந்த கூடையில் சேர்க்கப்பட்டுள்ளன';

  @override
  String get mktBasketNameRequired => 'கூடை பெயர் தேவை';

  @override
  String get mktAddAtLeastOneProduct =>
      'சரக்கிலிருந்து குறைந்தது ஒரு பொருளைச் சேர்க்கவும்';

  @override
  String get mktSave => 'சேமி';

  @override
  String get mktBasketNameLabel => 'கூடை பெயர் *';

  @override
  String get mktBasketNameHint => 'எ.கா. காலை உணவு தொகுப்பு';

  @override
  String get mktDescriptionOptional => 'விளக்கம் (விருப்பத்தேர்வு)';

  @override
  String get mktDescriptionHint => 'எ.கா. பால் + ரொட்டி + முட்டை';

  @override
  String get mktBundlePriceOptional => 'தொகுப்பு விலை (விருப்பத்தேர்வு)';

  @override
  String get mktValidity => 'செல்லுபடியாகும் காலம்';

  @override
  String get mktFromDateLabel => 'தொடக்க தேதி';

  @override
  String get mktToDateLabel => 'முடிவு தேதி';

  @override
  String get mktProducts => 'பொருட்கள்';

  @override
  String get mktAddProduct => 'பொருளைச் சேர்';

  @override
  String get mktTapToPickProducts =>
      'உங்கள் சரக்கிலிருந்து பொருட்களைத் தேர்வுசெய்ய தட்டவும்';

  @override
  String mktPricePerUnit(String price) {
    return '₹$price / அலகு';
  }

  @override
  String get mktQty => 'அளவு';

  @override
  String get mktCreateBasket => 'கூடையை உருவாக்கு';

  @override
  String get mktSelectProduct => 'பொருளைத் தேர்ந்தெடு';

  @override
  String get mktSearchProducts => 'பொருட்களைத் தேடு...';

  @override
  String get mktNoProductsFound => 'பொருட்கள் எதுவும் இல்லை';

  @override
  String get mktAdd => 'சேர்';

  @override
  String get mktEstTotal => 'மதிப்பிடப்பட்ட மொத்தம்';

  @override
  String get mktAddAll => 'அனைத்தையும் சேர்';

  @override
  String get mktNotInStock => 'சரக்கில் இல்லை';

  @override
  String mktCampaignItemStock(String qty, String unit, String price) {
    return 'சரக்கு: $qty $unit  ·  ₹$price';
  }

  @override
  String get mktEstimatedTotal => 'மதிப்பிடப்பட்ட மொத்தம்';

  @override
  String get mktNoItemsInStock => 'சரக்கில் பொருட்கள் இல்லை';

  @override
  String mktAddAvailableItemsToCart(int count) {
    return '$count கிடைக்கும் பொருட்களை கார்ட்டில் சேர்';
  }

  @override
  String get mktAreaAssociations => 'பகுதி தொடர்புகள்';

  @override
  String get mktMyAreas => 'எனது பகுதிகள்';

  @override
  String get mktCustomerHeatmap => 'வாடிக்கையாளர் வெப்ப வரைபடம்';

  @override
  String mktErrorWithMessage(String error) {
    return 'பிழை: $error';
  }

  @override
  String get mktNoAreasAddedYet => 'இன்னும் பகுதிகள் சேர்க்கப்படவில்லை';

  @override
  String get mktAreasEmptySubtitle =>
      'இலக்கு பிரச்சார பரிந்துரைகளைப் பெற அருகிலுள்ள குடியிருப்புகள், விடுதிகள், பள்ளிகள் அல்லது அலுவலகங்களைச் சேர்க்கவும்.';

  @override
  String get mktAddFirstArea => 'முதல் பகுதியைச் சேர்';

  @override
  String get mktRemoveAreaTitle => 'பகுதியை அகற்றவா?';

  @override
  String mktRemoveAreaConfirm(String name) {
    return 'உங்கள் தொடர்புகளிலிருந்து \"$name\" ஐ அகற்றவா?';
  }

  @override
  String get mktRemove => 'அகற்று';

  @override
  String mktHouseholdsCount(int count) {
    return '~$count வீடுகள்';
  }

  @override
  String get mktNoHeatmapDataYet => 'இன்னும் வெப்ப வரைபட தரவு இல்லை';

  @override
  String get mktHeatmapEmptySubtitle =>
      'பகுதிகளைச் சேர்த்து அந்த பகுதிகளுக்கு வாடிக்கையாளர்களைக் குறியிடவும். வருவாய் தரவு காலப்போக்கில் இங்கே தோன்றும்.';

  @override
  String get mktLast90DaysByRevenue => 'கடந்த 90 நாட்கள் · வருவாய் வாரியாக';

  @override
  String get mktCustomers => 'வாடிக்கையாளர்கள்';

  @override
  String get mktOrders => 'ஆர்டர்கள்';

  @override
  String get mktAvgOrder => 'சராசரி ஆர்டர்';

  @override
  String get mktNoOrdersYetTagCustomers =>
      'இன்னும் ஆர்டர்கள் இல்லை — கண்காணிக்க இந்த பகுதிக்கு வாடிக்கையாளர்களைக் குறியிடவும்';

  @override
  String get mktAddNearbyArea => 'அருகிலுள்ள பகுதியைச் சேர்';

  @override
  String get mktAreaType => 'பகுதி வகை';

  @override
  String get mktAreaNameLabel => 'பெயர் (எ.கா. பிரஸ்டீஜ் அப்பார்ட்மென்ட்ஸ்)';

  @override
  String get mktEstimatedHouseholdsOptional =>
      'மதிப்பிடப்பட்ட வீடுகள் (விருப்பத்தேர்வு)';

  @override
  String get mktNotesOptional => 'குறிப்புகள் (விருப்பத்தேர்வு)';

  @override
  String get mktAddArea => 'பகுதியைச் சேர்';

  @override
  String get mktCustomerGrowth => 'வாடிக்கையாளர் வளர்ச்சி';

  @override
  String get mktNewCampaign => 'புதிய பிரச்சாரம்';

  @override
  String get mktNoCampaignsYet => 'இன்னும் பிரச்சாரங்கள் இல்லை';

  @override
  String get mktReferralEmptySubtitle =>
      'உங்கள் தற்போதைய வாடிக்கையாளர்கள் புதியவர்களை அழைத்து வர ஒரு பரிந்துரை பிரச்சாரத்தை உருவாக்கி — அதற்கு அவர்களுக்கு வெகுமதி அளியுங்கள்.';

  @override
  String get mktCreateFirstCampaign => 'முதல் பிரச்சாரத்தை உருவாக்கு';

  @override
  String get mktReferralHowItWorks =>
      'வாடிக்கையாளர்கள் தங்கள் QR ஐ நண்பர்களுடன் பகிர்கிறார்கள். புதிய வருகையாளர்கள் தள்ளுபடி பெற POS இல் அதை ஸ்கேன் செய்கிறார்கள் — மேலும் பரிந்துரைத்தவர் மைல்கல் வெகுமதிகளைப் பெறுகிறார்.';

  @override
  String mktCampaignSummary(String discount, String reward, int n) {
    return 'புதிய வாடிக்கையாளர்களுக்கு $discount% தள்ளுபடி  •  ஒவ்வொரு $n பரிந்துரைகளுக்கும் $reward% வெகுமதி';
  }

  @override
  String get mktQrCodes => 'QR குறியீடுகள்';

  @override
  String get mktReferrals => 'பரிந்துரைகள்';

  @override
  String get mktMaxPerPerson => 'அதிகபட்சம்/நபர்';

  @override
  String get mktGenerateQr => 'QR உருவாக்கு';

  @override
  String mktGenerateQrTitle(String name) {
    return 'QR உருவாக்கு · $name';
  }

  @override
  String get mktSearchCustomer => 'வாடிக்கையாளரைத் தேடு…';

  @override
  String get mktNoCustomersFound => 'வாடிக்கையாளர்கள் எவரும் இல்லை';

  @override
  String get mktNoPhoneForCustomer =>
      'இந்த வாடிக்கையாளருக்கு தொலைபேசி எண் இல்லை';

  @override
  String mktReferralWhatsAppMessage(
    String name,
    String code,
    String discount,
    int n,
  ) {
    return 'வணக்கம் $name! 🎁\n\nஎங்கள் கடையை உங்கள் நண்பர்களுடன் பகிர அழைக்கப்படுகிறீர்கள்!\n\nஉங்கள் பரிந்துரை குறியீடு: $code\n\nஉங்கள் நண்பர் எங்கள் கடைக்கு வந்து இந்தக் குறியீட்டைக் காட்டினால், அவர்களுக்கு $discount% தள்ளுபடி கிடைக்கும் — மேலும் நீங்கள் அழைத்து வரும் ஒவ்வொரு $n நண்பர்களுக்கும் வெகுமதிகளைப் பெறுவீர்கள்! 🙌\n\n— LohiyaAI Kirana வழியாக';
  }

  @override
  String get mktWhatsAppNotInstalled =>
      'இந்த சாதனத்தில் WhatsApp நிறுவப்படவில்லை';

  @override
  String get mktReferralQrCode => 'பரிந்துரை QR குறியீடு';

  @override
  String mktPercentOffForNewCustomers(String discount) {
    return 'புதிய வாடிக்கையாளர்களுக்கு $discount% தள்ளுபடி';
  }

  @override
  String mktMilestoneRewardLabel(String reward, int n) {
    return 'மைல்கல் வெகுமதி: ஒவ்வொரு $n பரிந்துரைகளுக்கும் $reward%';
  }

  @override
  String get mktReferralCodeCopied => 'பரிந்துரை குறியீடு நகலெடுக்கப்பட்டது';

  @override
  String get mktSendViaWhatsApp => 'WhatsApp மூலம் அனுப்பு';

  @override
  String get mktQrScreenshotHint =>
      'அல்லது வாடிக்கையாளர் ஸ்கிரீன்ஷாட் எடுக்க இந்த QR திரையை நேரடியாகக் காட்டவும்.';

  @override
  String get mktInvalidQrCode => 'தவறான QR குறியீடு';

  @override
  String get mktCampaignNoLongerActive =>
      'இந்த பரிந்துரை பிரச்சாரம் இனி செயலில் இல்லை';

  @override
  String get mktCouldNotLoadReferralInfo => 'பரிந்துரை தகவலை ஏற்ற முடியவில்லை';

  @override
  String get mktEnterValidPhone => 'சரியான 10-இலக்க தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get mktClose => 'மூடு';

  @override
  String mktReferralFrom(String name) {
    return '$name இடமிருந்து பரிந்துரை';
  }

  @override
  String mktCampaignDiscountForNewCustomer(String campaign, String discount) {
    return '$campaign  •  புதிய வாடிக்கையாளருக்கு $discount% தள்ளுபடி';
  }

  @override
  String get mktNewCustomerDetails => 'புதிய வாடிக்கையாளர் விவரங்கள்';

  @override
  String get mktNewCustomerPhoneHelper =>
      'புதிய வாடிக்கையாளரின் தொலைபேசியை உள்ளிடவும். நீங்கள் ஆர்டர் செய்யும்போது தள்ளுபடி பயன்படுத்தப்படும்.';

  @override
  String get mktPhoneNumber => 'தொலைபேசி எண்';

  @override
  String get mktCustomerNameOptional => 'வாடிக்கையாளர் பெயர் (விருப்பத்தேர்வு)';

  @override
  String get mktCustomerNameHint => 'எ.கா. ஞான் குமார்';

  @override
  String mktApplyReferralDiscount(String discount) {
    return '$discount% பரிந்துரை தள்ளுபடியை பயன்படுத்து';
  }

  @override
  String get mktCampaignNameRequired => 'பிரச்சார பெயர் தேவை';

  @override
  String get mktEnterValidDiscount => 'சரியான தள்ளுபடி % ஐ உள்ளிடவும் (1–100)';

  @override
  String get mktMilestoneCountMin =>
      'மைல்கல் எண்ணிக்கை குறைந்தது 1 ஆக இருக்க வேண்டும்';

  @override
  String get mktEnterValidReward => 'சரியான வெகுமதி % ஐ உள்ளிடவும் (1–100)';

  @override
  String get mktMaxReferralsMin =>
      'அதிகபட்ச பரிந்துரைகள் குறைந்தது 1 ஆக இருக்க வேண்டும்';

  @override
  String get mktFailedToCreateCampaign =>
      'பிரச்சாரத்தை உருவாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get mktNewReferralCampaign => 'புதிய பரிந்துரை பிரச்சாரம்';

  @override
  String get mktCampaignName => 'பிரச்சார பெயர்';

  @override
  String get mktCampaignNameHint => 'எ.கா. கோடை பரிந்துரை இயக்கம்';

  @override
  String get mktNewCustomerDiscountPct => 'புதிய வாடிக்கையாளர் தள்ளுபடி %';

  @override
  String get mktMilestoneRewardPct => 'மைல்கல் வெகுமதி %';

  @override
  String get mktRewardEveryNReferrals => 'ஒவ்வொரு N பரிந்துரைகளுக்கும் வெகுமதி';

  @override
  String get mktRewardEveryNHelper =>
      'பரிந்துரைத்தவர் அழைத்து வரும் ஒவ்வொரு N புதிய வாடிக்கையாளர்களுக்கும் ஒரு மைல்கல் வெகுமதியைப் பெறுகிறார்';

  @override
  String get mktMaxReferralsPerCustomer =>
      'ஒரு வாடிக்கையாளருக்கு அதிகபட்ச பரிந்துரைகள்';

  @override
  String get mktMaxReferralsHelper =>
      'இத்தனை வெற்றிகரமான பரிந்துரைகளுக்குப் பிறகு வாடிக்கையாளருக்கு வெகுமதி அளிப்பதை நிறுத்து';

  @override
  String get mktCreateCampaign => 'பிரச்சாரத்தை உருவாக்கு';

  @override
  String get profProfile => 'சுயவிவரம்';

  @override
  String profErrorLoadingProfile(String error) {
    return 'சுயவிவரத்தை ஏற்றுவதில் பிழை: $error';
  }

  @override
  String get profNoUserData => 'பயனர் தரவு எதுவும் இல்லை.';

  @override
  String get profCashflowSupport => 'பணப்புழக்க ஆதரவு';

  @override
  String get profCashflowSupportDesc =>
      'தனிப்பயனாக்கப்பட்ட திருப்பிச்செலுத்தும் திட்டங்களுடன் ₹50K – ₹10L வணிக நிதிக்கு விண்ணப்பிக்கவும்.';

  @override
  String get profCashflowBannerSubtitle =>
      '₹50K – ₹10L வணிக நிதிக்கு விண்ணப்பிக்கவும்';

  @override
  String get profSectionCustomers => 'வாடிக்கையாளர்கள்';

  @override
  String get profSectionAnalytics => 'பகுப்பாய்வு';

  @override
  String get profSectionStoreAccount => 'கடை & கணக்கு';

  @override
  String get profSectionPlanSupport => 'திட்டம் & ஆதரவு';

  @override
  String get profSectionAdmin => 'நிர்வாகம்';

  @override
  String get profCustomerGrowth => 'வாடிக்கையாளர் வளர்ச்சி';

  @override
  String get profCustomerGrowthDesc =>
      'ஒரு பரிந்துரை இயந்திரத்தை உருவாக்கு — உங்கள் மகிழ்ச்சியான வாடிக்கையாளர்கள் தானாகவே புதியவர்களை அழைத்து வரட்டும்.';

  @override
  String get profCustomerRelations => 'வாடிக்கையாளர் உறவுகள்';

  @override
  String get profAreaAssociations => 'பகுதி தொடர்புகள்';

  @override
  String get profKpiSubscriptions => 'KPI சந்தாக்கள்';

  @override
  String get profTransactionHistory => 'பரிவர்த்தனை வரலாறு';

  @override
  String get profMyBaskets => 'எனது கூடைகள்';

  @override
  String get profLoyalty => 'லாயல்டி & சலுகைகள்';

  @override
  String get profServices => 'சேவைகள் & சந்திப்புகள்';

  @override
  String get profStoreComparison => 'கடை ஒப்பீடு';

  @override
  String get profStaff => 'பணியாளர்கள்';

  @override
  String get profEstimatesReturns => 'மதிப்பீடு & திரும்பப்பெறுதல்';

  @override
  String get profStockRacks => 'இருப்பு அலமாரிகள்';

  @override
  String get profJobCards => 'வேலை அட்டைகள்';

  @override
  String get profWarranty => 'உத்தரவாதம் & சீரியல்';

  @override
  String get profGstReport => 'ஜிஎஸ்டி அறிக்கை';

  @override
  String get profLanguage => 'மொழி';

  @override
  String get profStoreSettings => 'கடை அமைப்புகள்';

  @override
  String get profSwitchStore => 'கடையை மாற்று / சேர்';

  @override
  String get profConfiguration => 'கட்டமைப்பு';

  @override
  String get profPasswordSecurity => 'கடவுச்சொல் & பாதுகாப்பு';

  @override
  String get profSubscriptionPlans => 'சந்தா & திட்டங்கள்';

  @override
  String get profHelpSupport => 'உதவி & ஆதரவு';

  @override
  String get profUserActivity => 'பயனர் செயல்பாடு';

  @override
  String get profSignOut => 'வெளியேறு';

  @override
  String get profTrialExpired => 'சோதனை காலாவதியானது';

  @override
  String get profAwaitingActivation => 'செயல்படுத்தலுக்காக காத்திருக்கிறது';

  @override
  String get profProTrial => 'Pro சோதனை';

  @override
  String get profBasicTrial => 'Basic சோதனை';

  @override
  String profTrialDaysLeft(String tier, int days) {
    return '$tier · $daysநா மீதம்';
  }

  @override
  String profTrialActive(String tier) {
    return '$tier செயலில்';
  }

  @override
  String get profBasicPlan => 'Basic திட்டம்';

  @override
  String get profProPlan => 'Pro திட்டம்';

  @override
  String get profSyncContacts => 'தொடர்புகளை ஒத்திசை';

  @override
  String get profRefreshList => 'பட்டியலைப் புதுப்பி';

  @override
  String get profAddCustomer => 'வாடிக்கையாளரைச் சேர்';

  @override
  String get profSearchByNameOrPhone => 'பெயர் அல்லது தொலைபேசி மூலம் தேடு...';

  @override
  String get profRetry => 'மீண்டும் முயற்சி';

  @override
  String profNoSegmentCustomers(String segment) {
    return '$segment வாடிக்கையாளர்கள் இல்லை';
  }

  @override
  String get profNoCustomersFound => 'வாடிக்கையாளர்கள் எவரும் இல்லை.';

  @override
  String get profSegRegular => 'வழக்கமான';

  @override
  String get profSegOccasional => 'எப்போதாவது';

  @override
  String get profSegImpulse => 'தூண்டுதல்';

  @override
  String get profSegBulk => 'மொத்தம்';

  @override
  String get profSegCredit => 'கடன்';

  @override
  String get profSegInactive => 'செயலற்ற';

  @override
  String get profSyncContactsTitle => 'தொடர்புகளை ஒத்திசைக்கவா?';

  @override
  String get profSyncContactsBody =>
      'இது உங்கள் தொலைபேசி தொடர்புகளை உங்கள் வாடிக்கையாளர் பட்டியலில் இறக்குமதி செய்யும். வழக்கமான வாடிக்கையாளர்கள் தொலைபேசி எண் மூலம் பொருத்தப்படுவார்கள்.';

  @override
  String get profCancel => 'ரத்துசெய்';

  @override
  String get profSyncNow => 'இப்போது ஒத்திசை';

  @override
  String profSyncedContacts(int count) {
    return '$count தொடர்புகள் வெற்றிகரமாக ஒத்திசைக்கப்பட்டன!';
  }

  @override
  String profSyncFailed(String error) {
    return 'ஒத்திசைவு தோல்வி: $error';
  }

  @override
  String get profSendWhatsappReengagement => 'WhatsApp மறு-ஈடுபாட்டை அனுப்பு';

  @override
  String profWhatsappReengagementMessage(String name) {
    return 'வணக்கம் $name! எங்கள் கடையில் உங்களை மிஸ் செய்கிறோம். உங்கள் கடைசி வருகைக்குப் பிறகு சிறிது காலமாகிவிட்டது, உங்களுக்காக புதிய சரக்கு மற்றும் சிறந்த சலுகைகள் காத்திருக்கின்றன. விரைவில் வருகை தாருங்கள் — உங்கள் பிடித்த பொருட்கள் தயாராக உள்ளன! விரைவில் சந்திப்போம்!';
  }

  @override
  String get profAddNewCustomer => 'புதிய வாடிக்கையாளரைச் சேர்';

  @override
  String get profEditCustomer => 'வாடிக்கையாளரைத் திருத்து';

  @override
  String get profFullName => 'முழு பெயர்';

  @override
  String get profPhoneNumber => 'தொலைபேசி எண்';

  @override
  String get profEmailAddressOptional => 'மின்னஞ்சல் முகவரி (விருப்பத்தேர்வு)';

  @override
  String get profHouseholdSize => 'வீட்டின் அளவு';

  @override
  String get profBirthdayOptional => 'பிறந்தநாள் (விரும்பினால்)';

  @override
  String get profAnniversaryOptional => 'ஆண்டுவிழா (விரும்பினால்)';

  @override
  String get profSaveCustomer => 'வாடிக்கையாளரைச் சேமி';

  @override
  String get profFillNameAndPhone => 'பெயர் மற்றும் தொலைபேசியை நிரப்பவும்';

  @override
  String get profEnterValidPhone =>
      'சரியான தொலைபேசி எண்ணை உள்ளிடவும் (இலக்கங்கள் மட்டும்)';

  @override
  String get profCustomerSaved => 'வாடிக்கையாளர் வெற்றிகரமாக சேமிக்கப்பட்டார்';

  @override
  String get profLoading => 'ஏற்றுகிறது...';

  @override
  String get profCustomerDetails => 'வாடிக்கையாளர் விவரங்கள்';

  @override
  String get profStatBalance => 'இருப்பு';

  @override
  String get profStatSpent => 'செலவழித்தது';

  @override
  String get profStatOrders => 'ஆர்டர்கள்';

  @override
  String get profCustomerInfo => 'வாடிக்கையாளர் தகவல்';

  @override
  String profMembersCount(int count) {
    return '$count உறுப்பினர்கள்';
  }

  @override
  String get profJoinedOn => 'சேர்ந்த தேதி';

  @override
  String get profUnknown => 'தெரியாதது';

  @override
  String get profPurchaseHistory => 'கொள்முதல் வரலாறு';

  @override
  String get profNoOrdersForCustomer =>
      'இந்த வாடிக்கையாளருக்கு ஆர்டர்கள் எதுவும் இல்லை.';

  @override
  String profErrorLoadingOrders(String error) {
    return 'ஆர்டர்களை ஏற்றுவதில் பிழை: $error';
  }

  @override
  String get profDeleteCustomerTitle => 'வாடிக்கையாளரை நீக்கவா?';

  @override
  String profDeleteCustomerBody(String name) {
    return '$name ஐ நீக்க விரும்புகிறீர்களா? இந்த செயலை மீட்டெடுக்க முடியாது.';
  }

  @override
  String get profDelete => 'நீக்கு';

  @override
  String profFailedToUpdateArea(String error) {
    return 'பகுதியைப் புதுப்பிக்க முடியவில்லை: $error';
  }

  @override
  String get profAreaAssociation => 'பகுதி / தொடர்பு';

  @override
  String get profUnableToLoadAreas => 'பகுதிகளை ஏற்ற முடியவில்லை';

  @override
  String get profNoAreasTapToAdd => 'பகுதிகள் இல்லை — ஒன்றைச் சேர்க்க தட்டவும்';

  @override
  String get profNone => 'எதுவும் இல்லை';

  @override
  String profOrderNumber(String id) {
    return 'ஆர்டர் #$id';
  }

  @override
  String get profSave => 'சேமி';

  @override
  String profError(String error) {
    return 'பிழை: $error';
  }

  @override
  String get profBasicInformation => 'அடிப்படை தகவல்';

  @override
  String get profStoreName => 'கடையின் பெயர்';

  @override
  String get profStoreType => 'கடை வகை (எ.கா. கிரானா, சூப்பர்மார்க்கெட்)';

  @override
  String get profBusinessIntelligence => 'வணிக நுண்ணறிவு';

  @override
  String get profFootfallAutoComputed =>
      'சராசரி வருகை உங்கள் விற்பனையின் அடிப்படையில் தானாகவே கணக்கிடப்படுகிறது.';

  @override
  String get profProvideInitialValues =>
      'உங்கள் வணிகத்தை மேம்படுத்த எங்கள் AI க்கு உதவ ஆரம்ப மதிப்புகளை வழங்கவும்.';

  @override
  String get profAvgDailyFootfall => 'சராசரி தினசரி வருகை';

  @override
  String get profAiAutoUpdating => 'AI தானாக புதுப்பிக்கிறது';

  @override
  String get profMonthlyStockBudget => 'மாதாந்திர சரக்கு பட்ஜெட்';

  @override
  String get profDailyExpenseBuffer => 'தினசரி செலவு இருப்பு';

  @override
  String get profLocationDetails => 'இருப்பிட விவரங்கள்';

  @override
  String get profCityArea => 'நகரம் / பகுதி';

  @override
  String get profStateRegion => 'மாநிலம் / பகுதி';

  @override
  String get profCity => 'நகரம்';

  @override
  String get profBusinessVertical => 'வணிக வகை';

  @override
  String get profRequired => 'தேவை';

  @override
  String get profSettingsSaved => 'அமைப்புகள் வெற்றிகரமாக சேமிக்கப்பட்டன!';

  @override
  String profFailedToSave(String error) {
    return 'சேமிக்க முடியவில்லை: $error';
  }

  @override
  String get supSplashTagline => 'ஸ்மார்ட் வணிகம், சிறந்த நீங்கள்';

  @override
  String get supBlockedAppTitle => 'ஆப் தற்காலிகமாக கிடைக்கவில்லை';

  @override
  String get supBlockedStoreTitle => 'கடை தற்காலிகமாக கிடைக்கவில்லை';

  @override
  String get supBlockedBody =>
      'இதை விரைவில் தீர்க்க நாங்கள் வேலை செய்கிறோம். உங்களுக்கு உடனடி உதவி தேவைப்பட்டால், கீழே உள்ள பொத்தானைத் தட்டவும்.';

  @override
  String get supBlockedContactUs => 'எங்களை தொடர்புகொள்ளவும்';

  @override
  String get supBlockedEmailSubjectApp => 'ஆப் அணுகல் சிக்கல் — Outlet AI';

  @override
  String get supBlockedEmailSubjectStore => 'கடை அணுகல் சிக்கல் — Outlet AI';

  @override
  String supBlockedEmailBody(String reason) {
    return 'வணக்கம் LohiyaAI குழுவே,\n\nஎன்னால் Outlet AI ஆப்பை அணுக முடியவில்லை.\n\nகாட்டப்பட்ட காரணம்: $reason\n\nஅணுகலை மீட்டெடுக்க எனக்கு உதவவும்.\n\n— கிரானா உரிமையாளர்';
  }

  @override
  String get supBlockedEmailFallback =>
      'support@lohiyaai.com க்கு நேரடியாக மின்னஞ்சல் அனுப்பவும்.';

  @override
  String get supSupportTitle => 'உதவி & ஆதரவு';

  @override
  String get supSupportHeading => 'நாங்கள் உங்களுக்கு எப்படி உதவ முடியும்?';

  @override
  String get supSupportSubheading =>
      'உங்கள் கேள்விகளுக்கு உடனடி பதில்களைப் பெறுங்கள்';

  @override
  String get supOptionFaqTitle => 'அடிக்கடி கேட்கப்படும் கேள்விகள்';

  @override
  String get supOptionFaqSubtitle => 'பொதுவான கேள்விகள் மற்றும் பதில்கள்';

  @override
  String get supOptionReportTitle => 'சிக்கலைப் புகாரளி';

  @override
  String get supOptionReportSubtitle =>
      'பிழையை எதிர்கொண்டீர்களா? எங்களுக்குத் தெரியப்படுத்துங்கள்';

  @override
  String get supOptionChatTitle => 'எங்களுடன் அரட்டையடி';

  @override
  String get supOptionChatSubtitle => 'எங்கள் ஆதரவு குழுவுடன் இணையுங்கள்';

  @override
  String get supOptionEmailTitle => 'மின்னஞ்சல் ஆதரவு';

  @override
  String get supOptionEmailSubtitle =>
      'எங்களுக்கு நேரடியாக மின்னஞ்சல் அனுப்பவும்';

  @override
  String get supChatComingSoon => 'அரட்டை ஆதரவு விரைவில் வருகிறது!';

  @override
  String get supEmailUnableToOpen => 'மின்னஞ்சல் ஆப்பைத் திறக்க முடியவில்லை.';

  @override
  String get supEmailError =>
      'மின்னஞ்சல் ஆப்பைத் திறக்கும்போது ஏதோ தவறு நடந்தது.';

  @override
  String get supFaqTitle => 'அடிக்கடி கேட்கப்படும் கேள்விகள்';

  @override
  String get supFaqQ1 => 'புதிய பொருளை எவ்வாறு சேர்ப்பது?';

  @override
  String get supFaqA1 =>
      'POS தாவலில் + பொத்தானைக் கிளிக் செய்வதன் மூலம் அல்லது சரக்கு தாவலிலிருந்து பொருட்களைச் சேர்க்கலாம். கிடைக்கும் எனில் விவரங்களைத் தானாக பெற பார்கோடையும் ஸ்கேன் செய்யலாம்.';

  @override
  String get supFaqQ2 => 'சரக்கு தீரும் ஆபத்து கணிப்பு எவ்வாறு செயல்படுகிறது?';

  @override
  String get supFaqA2 =>
      'எங்கள் AI உங்கள் கடந்த கால விற்பனை வேகம் மற்றும் தற்போதைய சரக்கு அளவுகளை பகுப்பாய்வு செய்கிறது. அடுத்த 3-7 நாட்களுக்குள் ஒரு பொருள் தீர்ந்துவிடும் என்று கணித்தால், அதை சரக்கு தீரும் ஆபத்தாகக் குறிக்கிறது.';

  @override
  String get supFaqQ3 => 'வாடிக்கையாளர் கடனை (காதா) எவ்வாறு நிர்வகிப்பது?';

  @override
  String get supFaqA3 =>
      'ஆர்டர் செய்யும்போது, ஒரு வாடிக்கையாளரைத் தேர்ந்தெடுத்து கட்டண முறையாக \"கடன்\" ஐத் தேர்ந்தெடுக்கவும். அனைத்து நிலுவைகளையும் நிதி -> உதார் தாவல் அல்லது வாடிக்கையாளர் உறவுகள் பகுதியில் பார்க்கலாம்.';

  @override
  String get supFaqQ4 => 'எனது தொலைபேசி தொடர்புகளை ஒத்திசைக்க முடியுமா?';

  @override
  String get supFaqA4 =>
      'ஆம்! சுயவிவரம் -> வாடிக்கையாளர் உறவுகளுக்குச் சென்று ஒத்திசை ஐகானைக் கிளிக் செய்யவும். இது எளிதான கடன் கண்காணிப்புக்காக உங்கள் வழக்கமான வாங்குபவர்களை ஆப்பில் இறக்குமதி செய்யும்.';

  @override
  String get supFaqQ5 => 'KPI சந்தாக்கள் என்றால் என்ன?';

  @override
  String get supFaqA5 =>
      'KPIகள் வருவாய், மார்ஜின் மற்றும் வருகை போன்ற முக்கிய வணிக அளவீடுகள். சுயவிவரம் -> சந்தா பகுதியிலிருந்து எந்த அளவீடுகளைக் கண்காணிக்க வேண்டும் என்பதைத் தேர்ந்தெடுக்கலாம்.';

  @override
  String get supFaqQ6 => 'தினசரி விற்பனை அறிக்கையை எவ்வாறு உருவாக்குவது?';

  @override
  String get supFaqA6 =>
      'இன்றைய செயல்திறனை டாஷ்போர்டில் பார்க்கலாம். விரிவான கடந்த கால அறிக்கைகளுக்கு, உங்கள் சுயவிவரத்தில் உள்ள பரிவர்த்தனை வரலாறு பகுதியைப் பார்வையிடவும்.';

  @override
  String get supReportTitle => 'சிக்கலைப் புகாரளி';

  @override
  String get supReportHeading => 'சிக்கலை விவரிக்கவும்';

  @override
  String get supReportSubheading =>
      'எங்கள் குழு உங்கள் புகாரைப் பரிசீலித்து விரைவில் சரிசெய்யும்.';

  @override
  String get supReportCategoryLabel => 'சிக்கல் வகை';

  @override
  String get supReportSummaryLabel => 'சுருக்கமான சுருக்கம்';

  @override
  String get supReportSummaryHint =>
      'எ.கா. பார்கோடை ஸ்கேன் செய்யும்போது ஆப் செயலிழக்கிறது';

  @override
  String get supReportDescriptionLabel => 'விரிவான விளக்கம்';

  @override
  String get supReportDescriptionHint =>
      'சிக்கலை எவ்வாறு மீண்டும் உருவாக்குவது என்பது குறித்த விவரங்களை வழங்கவும்...';

  @override
  String get supReportSubmit => 'புகாரைச் சமர்ப்பி';

  @override
  String get supReportFillFields => 'அனைத்து புலங்களையும் நிரப்பவும்';

  @override
  String get supReportSubmittedTitle => 'புகார் சமர்ப்பிக்கப்பட்டது';

  @override
  String get supReportSubmittedBody =>
      'உங்கள் கருத்துக்கு நன்றி. எங்கள் குழு அதை உடனடியாக ஆராயும்.';

  @override
  String get supOk => 'சரி';

  @override
  String supReportSubmitFailed(String error) {
    return 'புகாரைச் சமர்ப்பிக்க முடியவில்லை: $error';
  }

  @override
  String get supCategoryAppBug => 'ஆப் பிழை';

  @override
  String get supCategoryPricing => 'விலை சிக்கல்';

  @override
  String get supCategoryInventory => 'சரக்கு பொருந்தாமை';

  @override
  String get supCategoryAiFeedback => 'AI பரிந்துரை கருத்து';

  @override
  String get supCategoryPosError => 'POS பிழை';

  @override
  String get supCategoryFeatureRequest => 'அம்சக் கோரிக்கை';

  @override
  String get supCategoryOther => 'மற்றவை';

  @override
  String get shrSavingChanges => 'மாற்றங்கள் சேமிக்கப்படுகின்றன...';

  @override
  String get shrRetry => 'மீண்டும் முயற்சி';

  @override
  String get shrSavedSuccessfully => 'வெற்றிகரமாக சேமிக்கப்பட்டது!';

  @override
  String get shrBusinessAlerts => 'வணிக எச்சரிக்கைகள்';

  @override
  String get shrAllCaughtUp => 'அனைத்தும் பார்த்தாயிற்று!';

  @override
  String get shrNoUrgentAlerts => 'தற்போது அவசர எச்சரிக்கைகள் இல்லை.';

  @override
  String get shrAlertOutOfStock => 'சரக்கில் இல்லை';

  @override
  String get shrAlertLowStock => 'குறைந்த சரக்கு';

  @override
  String get shrAlertExpiringSoon => 'விரைவில் காலாவதியாகிறது';

  @override
  String get shrAlertOverdueUdhaar => 'நீண்ட நாள் தாமதமான உதார்';

  @override
  String get shrAlertOverduePayment => 'தாமதமான கட்டணம்';

  @override
  String get shrAlertUpcomingPayment => 'வரவிருக்கும் கட்டணம்';

  @override
  String shrMsgOutOfStock(String name) {
    return '$name முற்றிலும் சரக்கில் இல்லை.';
  }

  @override
  String shrMsgLowStock(String name, String stock) {
    return '$name குறைந்து வருகிறது ($stock).';
  }

  @override
  String shrMsgExpiringSoon(String name, int days) {
    return '$name $days நாட்களில் காலாவதியாகிறது.';
  }

  @override
  String shrMsgOverdueUdhaar(String name, String amount, int days) {
    return '$name $days நாட்களாக ₹$amount நிலுவையில் உள்ளது.';
  }

  @override
  String shrMsgPaymentOverdue(String amount, String supplier) {
    return '$supplier க்கு ₹$amount தாமதமாகியுள்ளது.';
  }

  @override
  String shrMsgPaymentDue(String amount, String supplier, int days) {
    return '$supplier க்கு ₹$amount $days நாட்களில் செலுத்த வேண்டும்.';
  }

  @override
  String psetErrorWith(String error) {
    return 'பிழை: $error';
  }

  @override
  String get psetCancel => 'ரத்துசெய்';

  @override
  String get psetReset => 'மீட்டமை';

  @override
  String get psetUserActivity => 'பயனர் செயல்பாடு';

  @override
  String get psetNoUsersFound => 'பயனர்கள் எவரும் இல்லை';

  @override
  String get psetNoStore => 'கடை இல்லை';

  @override
  String get psetNever => 'ஒருபோதும் இல்லை';

  @override
  String get psetActiveToday => 'இன்று செயலில்';

  @override
  String get psetInactive => 'செயலற்ற';

  @override
  String get psetLastSeen => 'கடைசியாக பார்த்தது';

  @override
  String get psetOpensToday => 'இன்று திறப்புகள்';

  @override
  String get psetTimeInApp => 'ஆப்பில் நேரம்';

  @override
  String get psetSalesToday => 'இன்று விற்பனை';

  @override
  String get psetJustNow => 'இப்போதுதான்';

  @override
  String psetMinsAgo(int m) {
    return '$mநி முன்';
  }

  @override
  String psetHoursAgo(int h) {
    return '$hம முன்';
  }

  @override
  String psetDaysAgo(int d) {
    return '$dநா முன்';
  }

  @override
  String get psetPasswordSecurity => 'கடவுச்சொல் & பாதுகாப்பு';

  @override
  String psetCouldNotLoadStatus(String error) {
    return 'நிலையை ஏற்ற முடியவில்லை: $error';
  }

  @override
  String get psetEnterNewPassword => 'புதிய கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get psetPasswordMin6 =>
      'கடவுச்சொல் குறைந்தது 6 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get psetPasswordsNoMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get psetEnterCurrentPassword =>
      'உங்கள் தற்போதைய கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get psetPasswordUpdated =>
      'கடவுச்சொல் வெற்றிகரமாக புதுப்பிக்கப்பட்டது.';

  @override
  String get psetPasswordCreated => 'கடவுச்சொல் வெற்றிகரமாக உருவாக்கப்பட்டது.';

  @override
  String get psetCouldNotConnect =>
      'சர்வருடன் இணைக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get psetSomethingWrong => 'ஏதோ தவறு நடந்தது';

  @override
  String get psetPasswordSet => 'கடவுச்சொல் அமைக்கப்பட்டது';

  @override
  String get psetNoPasswordYet => 'இன்னும் கடவுச்சொல் இல்லை';

  @override
  String psetLastChanged(String date) {
    return 'கடைசியாக மாற்றப்பட்டது $date';
  }

  @override
  String get psetPasswordActive => 'கடவுச்சொல் செயலில் உள்ளது';

  @override
  String get psetCreatePasswordHint =>
      'பயனர்பெயர் உள்நுழைவை இயக்க கடவுச்சொல்லை உருவாக்கவும்';

  @override
  String psetPasswordCooldown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days நாட்களில்',
      one: '1 நாளில்',
    );
    return '$_temp0 மீண்டும் உங்கள் கடவுச்சொல்லை மாற்றலாம்.';
  }

  @override
  String get psetChangePassword => 'கடவுச்சொல்லை மாற்று';

  @override
  String get psetCreatePassword => 'கடவுச்சொல்லை உருவாக்கு';

  @override
  String get psetChangeSubtitle =>
      'உங்கள் தற்போதைய கடவுச்சொல்லை உள்ளிட்டு, பின்னர் புதியதைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get psetCreateSubtitle =>
      'உங்கள் பயனர்பெயருடன் உள்நுழையவும் ஒரு கடவுச்சொல்லை அமைக்கவும்.';

  @override
  String get psetCurrentPassword => 'தற்போதைய கடவுச்சொல்';

  @override
  String get psetNewPassword => 'புதிய கடவுச்சொல்';

  @override
  String get psetConfirmNewPassword => 'புதிய கடவுச்சொல்லை உறுதிப்படுத்து';

  @override
  String get psetUpdatePassword => 'கடவுச்சொல்லை புதுப்பி';

  @override
  String get psetPasswordCooldownNote =>
      'கடவுச்சொல்லை 14 நாட்களுக்கு ஒரு முறை மட்டுமே மாற்ற முடியும்.';

  @override
  String get psetAllHistory => 'அனைத்து வரலாறு';

  @override
  String get psetTabPurchases => 'கொள்முதல்கள்';

  @override
  String get psetTabPosOrders => 'POS ஆர்டர்கள்';

  @override
  String get psetNoPurchaseHistory => 'கொள்முதல் வரலாறு எதுவும் இல்லை.';

  @override
  String get psetViewBill => 'பில்லைப் பார்';

  @override
  String get psetPurchaseDetails => 'கொள்முதல் விவரங்கள்';

  @override
  String psetFromSupplier(String supplier) {
    return '$supplier இடமிருந்து';
  }

  @override
  String psetQtyTimes(String qty, String price) {
    return 'அளவு: $qty × ₹$price';
  }

  @override
  String get psetTotalAmount => 'மொத்தத் தொகை';

  @override
  String get psetSalesTxnHistory => 'விற்பனை பரிவர்த்தனை வரலாறு';

  @override
  String get psetSalesTxnDesc =>
      'உங்கள் அனைத்து POS ஆர்டர்கள், கட்டணங்கள் மற்றும் வாடிக்கையாளர் பரிவர்த்தனைகளைப் பார்த்து வடிகட்டவும்.';

  @override
  String get psetOpenSalesHistory => 'விற்பனை வரலாற்றைத் திற';

  @override
  String get psetSettingsSaved => 'அமைப்புகள் சேமிக்கப்பட்டன';

  @override
  String psetSaveFailed(String error) {
    return 'சேமிப்பு தோல்வி: $error';
  }

  @override
  String get psetResetToDefaults => 'இயல்புநிலைக்கு மீட்டமை';

  @override
  String get psetResetConfirm =>
      'அனைத்து அமைப்புகளும் அவற்றின் இயல்புநிலை மதிப்புகளுக்கு மீட்டமைக்கப்படும்.';

  @override
  String get psetConfiguration => 'கட்டமைப்பு';

  @override
  String get psetPosPreferences => 'POS விருப்பத்தேர்வுகள்';

  @override
  String get psetAiForecasting => 'AI & கணிப்பு';

  @override
  String get psetAlertThresholds => 'எச்சரிக்கை வரம்புகள்';

  @override
  String get psetMarketing => 'சந்தைப்படுத்தல்';

  @override
  String get psetNotifications => 'அறிவிப்புகள்';

  @override
  String get psetDefaultPayment => 'இயல்புநிலை கட்டண முறை';

  @override
  String get psetDefaultPaymentHint =>
      'புதிய விற்பனையைச் சேர்க்கும்போது முன்-தேர்ந்தெடுக்கப்பட்ட முறை';

  @override
  String get psetCash => 'பணம்';

  @override
  String get psetCard => 'கார்டு';

  @override
  String get psetForecastHorizon => 'கணிப்பு கால எல்லை';

  @override
  String get psetForecastHorizonHint =>
      'AI எத்தனை நாட்கள் முன்னதாக சரக்கு தேவைகளைக் கணிக்கிறது';

  @override
  String psetDaysValue(int days) {
    return '$days நாட்கள்';
  }

  @override
  String get psetStockoutRisk => 'சரக்கு தீரும் ஆபத்து வரம்பு';

  @override
  String get psetStockoutRiskHint =>
      '7-நாள் ஆபத்து இதை மீறும்போது சரக்கு தீரும் எச்சரிக்கையைக் காட்டு';

  @override
  String get psetMinVelocity => 'குறைந்தபட்ச வேக வரம்பு';

  @override
  String get psetMinVelocityHint =>
      'இதைவிட மெதுவாக விற்கும் பொருட்கள் செயலற்ற சரக்காகக் குறிக்கப்படும்';

  @override
  String get psetReorderAlertDays => 'மீள் ஆர்டர் எச்சரிக்கை நாட்கள்';

  @override
  String get psetReorderAlertHint =>
      'திட்டமிடப்பட்ட சரக்கு N நாட்களுக்குள் தீரும்போது எச்சரி';

  @override
  String get psetDeadStockDays => 'செயலற்ற சரக்கு நாட்கள்';

  @override
  String get psetDeadStockHint =>
      'N அல்லது அதற்கு மேற்பட்ட நாட்களாக விற்பனை இல்லாத பொருட்களைக் குறி';

  @override
  String get psetExpiryAlertDays => 'காலாவதி எச்சரிக்கை நாட்கள்';

  @override
  String get psetExpiryAlertHint =>
      'ஒரு தொகுதி/பொருள் காலாவதியாவதற்கு இத்தனை நாட்களுக்கு முன் எச்சரி';

  @override
  String psetDaysBeforeValue(int days) {
    return '$days நாட்களுக்கு முன்';
  }

  @override
  String get psetAllowMarketing => 'எனது கடையை சந்தைப்படுத்த LohiyaAI ஐ அனுமதி';

  @override
  String get psetAllowMarketingHint =>
      'உங்கள் சார்பாக Facebook, Instagram & WhatsApp இல் உங்கள் கடையை விளம்பரப்படுத்துகிறோம்';

  @override
  String get psetInAppAlerts => 'ஆப்-உள் எச்சரிக்கைகள்';

  @override
  String get psetInAppAlertsHint => 'ஆப்பிற்குள் எச்சரிக்கைகளைக் காட்டு';

  @override
  String get psetWhatsappNotif => 'WhatsApp அறிவிப்புகள்';

  @override
  String get psetWhatsappNotifHint =>
      'மறு-சரக்கு மற்றும் உதார் எச்சரிக்கைகளை WhatsApp மூலம் அனுப்பு';

  @override
  String get psetQuietHours => 'அமைதி நேரம்';

  @override
  String get psetQuietHoursHint =>
      'இந்த நேரத்தில் அறிவிப்புகள் எதுவும் அனுப்பப்படாது';

  @override
  String get psetStart => 'தொடக்கம்';

  @override
  String get psetEnd => 'முடிவு';

  @override
  String get psetSaveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get psetCashflowSupport => 'பணப்புழக்க ஆதரவு';

  @override
  String get psetRequestUnderReview => 'கோரிக்கை பரிசீலனையில்';

  @override
  String psetReqProcessingFull(String amount, String bank) {
    return '₹$amount க்கான உங்கள் பணப்புழக்க கோரிக்கை $bank மூலம் செயலாக்கப்படுகிறது.\n\nஎங்கள் குழு 2 வேலை நாட்களுக்குள் உங்களைத் தொடர்புகொள்ளும்.';
  }

  @override
  String get psetReqProcessing =>
      'உங்கள் பணப்புழக்க கோரிக்கை செயலாக்கப்படுகிறது.\n\nஎங்கள் குழு 2 வேலை நாட்களுக்குள் உங்களைத் தொடர்புகொள்ளும்.';

  @override
  String get psetRequestSubmitted => 'கோரிக்கை சமர்ப்பிக்கப்பட்டது!';

  @override
  String get psetRequestSubmittedBody =>
      'உங்கள் பணப்புழக்க கோரிக்கையைப் பெற்றோம்.\nஎங்கள் குழு\n2 வேலை நாட்களுக்குள் உங்களைத் தொடர்புகொள்ளும்.';

  @override
  String get psetBackToProfile => 'சுயவிவரத்திற்குத் திரும்பு';

  @override
  String get psetApplyCashflow => 'பணப்புழக்க ஆதரவுக்கு\nவிண்ணப்பிக்கவும்';

  @override
  String get psetCashflowSubtitle =>
      'விரைவான வணிக நிதி, LohiyaAI கூட்டாளர்களால் இயக்கப்படுகிறது.';

  @override
  String get psetYourBusinessProfile => 'உங்கள் வணிக சுயவிவரம்';

  @override
  String get psetStore => 'கடை';

  @override
  String get psetLocation => 'இருப்பிடம்';

  @override
  String get psetDailyFootfall => 'தினசரி வருகை';

  @override
  String psetCustomersPerDay(int count) {
    return '$count வாடிக்கையாளர்கள்/நாள்';
  }

  @override
  String get psetHowMuchNeed => 'உங்களுக்கு எவ்வளவு தேவை?';

  @override
  String get psetDragToSelect =>
      'தேர்ந்தெடுக்க இழுக்கவும் — ₹50,000 முதல் ₹10,00,000 வரை';

  @override
  String get psetLoanAmount => 'கடன் தொகை';

  @override
  String get psetChoosePartnerBank => 'ஒரு கூட்டாளர் வங்கியைத் தேர்ந்தெடு';

  @override
  String get psetSelectBankHint =>
      'உங்கள் கோரிக்கையுடன் தொடர ஒரு வங்கியைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get psetSubmitRequest => 'கோரிக்கையைச் சமர்ப்பி';

  @override
  String get psetSubmitDisclaimer =>
      'சமர்ப்பிப்பதன் மூலம், இந்த கோரிக்கை தொடர்பாக எங்கள் குழுவால் தொடர்புகொள்ளப்பட ஒப்புக்கொள்கிறீர்கள்.';

  @override
  String get psetBankSbiDesc => 'சிறு வணிகங்களுக்கான அரசு ஆதரவு திட்டம்';

  @override
  String get psetBankHdfcDesc => 'சில்லறை வளர்ச்சிக்கான விரைவான வழங்கல்';

  @override
  String get psetBankIciciDesc =>
      'மளிகைக் கடை உரிமையாளர்களுக்கான நெகிழ்வான கடன்';

  @override
  String get psetBankAxisDesc => 'சில்லறை கடைகளுக்கான தனிப்பயன் நிதி';

  @override
  String get widgetTitleSales => 'இன்றைய விற்பனை';

  @override
  String get widgetTitleUdhaar => 'உதார் நிலுவை';

  @override
  String get widgetTitleLowStock => 'குறைந்த இருப்பு';

  @override
  String get widgetTitlePayToday => 'இன்று செலுத்துங்கள்';

  @override
  String get widgetNewBill => '+ புதிய பில்';

  @override
  String get widgetUnitOrders => 'ஆர்டர்கள்';

  @override
  String get widgetUnitItems => 'பொருட்கள்';

  @override
  String get widgetUnitOverdue => 'தாமதம்';

  @override
  String get widgetUnitPending => 'நிலுவையில்';

  @override
  String get widgetUnitToPay => 'செலுத்த வேண்டும்';

  @override
  String get widgetSignIn => 'உள்நுழைய Outlet AI ஐத் திறக்கவும்';

  @override
  String get widgetNoData => 'இன்றைய எண்களை ஏற்ற ஆப்பைத் திறக்கவும்';

  @override
  String get visionComingSoon => 'விஷன் AI விரைவில் வருகிறது!';

  @override
  String get mktTierBronze => 'Bronze';

  @override
  String get mktTierSilver => 'Silver';

  @override
  String get mktTierGold => 'Gold';

  @override
  String get mktTierPlatinum => 'Platinum';

  @override
  String get mktTierSettings => 'அடுக்கு அமைப்புகள்';

  @override
  String get mktShowArchived => 'காப்பகப்படுத்தியதைக் காட்டு';

  @override
  String get mktHideArchived => 'காப்பகப்படுத்தியதை மறை';

  @override
  String get mktArchived => 'காப்பகப்படுத்தப்பட்டது';

  @override
  String get mktEdit => 'திருத்து';

  @override
  String get mktAlertedToday => 'இன்று அறிவிக்கப்பட்டது';

  @override
  String get mktRestore => 'மீட்டமை';

  @override
  String get mktArchive => 'காப்பகப்படுத்து';

  @override
  String get mktBasketArchived => 'கூடை காப்பகப்படுத்தப்பட்டது';

  @override
  String get mktBasketRestored => 'கூடை மீட்டமைக்கப்பட்டது';

  @override
  String get mktSomethingWentWrong =>
      'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get mktEditBasket => 'கூடையைத் திருத்து';

  @override
  String get mktSaveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get mktAddItemsForPrice =>
      'தானியங்கி தள்ளுபடி பண்டில் விலையைப் பார்க்க பொருட்களைச் சேர்க்கவும்';

  @override
  String get mktItemsTotal => 'பொருட்கள் மொத்தம்';

  @override
  String get mktBundlePrice => 'பண்டில் விலை';

  @override
  String get mktTierConfigTitle => 'கூடை அடுக்குகள்';

  @override
  String get mktTierConfigIntro =>
      'கூடைகள் அவற்றின் மொத்த மதிப்பின் அடிப்படையில் தானாக விலை நிர்ணயிக்கப்படுகின்றன. ஒவ்வொரு அடுக்குக்கும் மதிப்பு வரம்பு மற்றும் தள்ளுபடியை அமைக்கவும் — பொருட்களைச் சேர்க்கும்போது பொருந்தும் அடுக்கின் தள்ளுபடி தானாகவே பயன்படுத்தப்படும்.';

  @override
  String get mktTierRangeInvalid =>
      'ஒவ்வொரு அடுக்கின் வரம்பும் முந்தையதை விட அதிகமாக இருக்க வேண்டும், தள்ளுபடி 0–100% இடையே.';

  @override
  String get mktTiersSaved => 'அடுக்குகள் சேமிக்கப்பட்டன';

  @override
  String get mktRecomputeTitle => 'தற்போதுள்ள கூடைகளை மீண்டும் கணக்கிடவா?';

  @override
  String get mktKeepAsIs => 'உள்ளபடியே வைத்திரு';

  @override
  String get mktRecompute => 'மீண்டும் கணக்கிடு';

  @override
  String get mktSaveTiers => 'அடுக்குகளைச் சேமி';

  @override
  String get mktUpToLabel => 'வரை';

  @override
  String get mktTopTierHint => 'முந்தைய அடுக்குக்கு மேல் அனைத்தும்';

  @override
  String get mktDiscountLabel => 'தள்ளுபடி';

  @override
  String get psetBasketTiers => 'கூடை அடுக்குகள்';

  @override
  String get psetBasketTiersHint =>
      'மதிப்பின் அடிப்படையில் கூடைகளுக்கு தானியங்கி தள்ளுபடி';

  @override
  String mktYouSave(String amount, String pct) {
    return '₹$amount சேமி ($pct% தள்ளுபடி)';
  }

  @override
  String mktTierBasketLabel(String tier) {
    return '$tier கூடை';
  }

  @override
  String mktPctOff(String pct) {
    return '$pct% தள்ளுபடி';
  }

  @override
  String mktSaveAmount(String amount) {
    return '₹$amount சேமி';
  }

  @override
  String mktRecomputeBody(int count) {
    return '$count தற்போதுள்ள கூடைகள் பழைய அடுக்குகளின் கீழ் விலை நிர்ணயிக்கப்பட்டுள்ளன. அவற்றுக்கும் புதிய அடுக்குகளைப் பயன்படுத்தவா?';
  }

  @override
  String mktBasketsRecomputed(int count) {
    return '$count கூடைகள் புதுப்பிக்கப்பட்டன';
  }

  @override
  String mktAboveAmount(String amount) {
    return '₹$amount மேல்';
  }

  @override
  String mktRangeAmount(String from, String to) {
    return '₹$from – ₹$to';
  }

  @override
  String get mktSaveAsBasket => 'கூடையாகச் சேமி';

  @override
  String mktBasketSavedFromCampaign(String name) {
    return '\"$name\" உங்கள் கூடைகளில் சேமிக்கப்பட்டது';
  }

  @override
  String get mktSelectDate => 'தேதியைத் தேர்ந்தெடு';

  @override
  String get mktBasketsProTitle => 'கூடைகள் ஒரு Pro அம்சம்';

  @override
  String get mktBasketsProDesc =>
      'தானியங்கி அடுக்கு தள்ளுபடிகளுடன் காம்போ டீல்களை உருவாக்கி வாடிக்கையாளர்களை WhatsApp இல் அறிவிக்கவும். கூடைகளைத் திறக்க Pro க்கு மேம்படுத்தவும்.';

  @override
  String get visionNavLabel => 'விஷன்';

  @override
  String get visionTitle => 'விஷன்';

  @override
  String get visionTabShelf => 'அலமாரி ஸ்கேன்';

  @override
  String get visionTabResults => 'முடிவுகள்';

  @override
  String get visionTabCounter => 'கவுண்டர்';

  @override
  String get visionProTitle => 'விஷன் AI';

  @override
  String get visionProDesc =>
      'காலையிலும் மாலையிலும் உங்கள் அலமாரியைப் புகைப்படம் எடுங்கள் — AI உங்கள் ஸ்டாக்கை எண்ணி என்ன விற்றது என்று சொல்லும்.';

  @override
  String get visionFromCamera => 'புகைப்படம் எடுக்கவும்';

  @override
  String get visionFromGallery => 'கேலரியில் இருந்து தேர்ந்தெடுக்கவும்';

  @override
  String get visionMorningTitle => 'காலை — நாளின் தொடக்கம்';

  @override
  String get visionEveningTitle => 'மாலை — நாளின் முடிவு';

  @override
  String get visionTakePhoto => 'புகைப்படம் எடுக்கவும்';

  @override
  String get visionRetake => 'மீண்டும் எடுக்கவும்';

  @override
  String get visionReview => 'மதிப்பாய்வு';

  @override
  String get visionAnalyzing =>
      'அலமாரி பகுப்பாய்வு செய்யப்படுகிறது… இதற்கு ஒரு நிமிடம் வரை ஆகலாம்';

  @override
  String get visionScanFailed =>
      'ஸ்கேன் தோல்வியடைந்தது. மீண்டும் புகைப்படம் எடுக்கவும்.';

  @override
  String get visionStillProcessing =>
      'உங்கள் புகைப்படங்கள் பகுப்பாய்வு செய்யப்படுகின்றன — இதற்கு சில நிமிடங்கள் ஆகலாம். தயாரானதும் முடிவு இங்கே காண்பிக்கப்படும்.';

  @override
  String get visionCheckAgain => 'மீண்டும் சரிபார்க்கவும்';

  @override
  String get visionNoPhotoYet => 'இன்னும் புகைப்படம் எடுக்கப்படவில்லை.';

  @override
  String get visionProductsIdentified => 'அடையாளம் காணப்பட்ட பொருட்கள்';

  @override
  String get visionUnitsCounted => 'எண்ணப்பட்ட யூனிட்கள்';

  @override
  String get visionNeedsReview => 'மதிப்பாய்வு தேவை';

  @override
  String get visionViewSales => 'இன்றைய விற்பனையைப் பார்க்கவும்';

  @override
  String get visionTip =>
      'குறிப்பு: கடையைத் திறப்பதற்கு முன் காலைப் புகைப்படமும், மூடுவதற்கு முன் மாலைப் புகைப்படமும் எடுக்கவும். ஒவ்வொரு பொருளும் எவ்வளவு விற்றது என்பதை AI கணக்கிடும்.';

  @override
  String get visionSalesEmpty =>
      'இன்று என்ன விற்றது என்று பார்க்க காலை மற்றும் மாலை ஒவ்வொரு புகைப்படம் எடுக்கவும்.';

  @override
  String get visionTotalSold => 'மொத்தம் விற்ற பொருட்கள்';

  @override
  String get visionSold => 'விற்றது';

  @override
  String get visionMorningCount => 'AM';

  @override
  String get visionEveningCount => 'PM';

  @override
  String get visionUnknownItem => 'தெரியவில்லை — சரிசெய்ய தட்டவும்';

  @override
  String get visionCorrected => 'சரிசெய்யப்பட்டது';

  @override
  String get visionCorrectTitle => 'இது எந்தப் பொருள்?';

  @override
  String get visionSearchProducts => 'உங்கள் பொருட்களைத் தேடுங்கள்';

  @override
  String get visionClearCorrection => 'திருத்தத்தை அழிக்கவும்';

  @override
  String get visionNoProducts =>
      'இன்னும் பொருட்கள் ஏற்றப்படவில்லை. ஒருமுறை பில்லிங் தாவலைத் திறந்து, மீண்டும் வரவும்.';

  @override
  String get visionCounterSoonTitle => 'லைவ் கவுண்டர் — விரைவில் வருகிறது';

  @override
  String get visionCounterSoonDesc =>
      'பில்லிங் கவுண்டரை நோக்கி உங்கள் ஃபோனைக் காட்டுங்கள், பொருட்கள் கடக்கும்போதே விற்பனை தானாக எண்ணப்படும். நாங்கள் இறுதி வேலைகளைச் செய்து வருகிறோம்.';

  @override
  String get visionCounterStartTitle => 'லைவ் விற்பனை கவுண்டர்';

  @override
  String get visionCounterStartDesc =>
      'உங்கள் ஃபோனை பில்லிங் கவுண்டரை நோக்கி பிடிக்கவும். கோட்டைக் கடக்கும் பொருட்கள் தானாகவே எண்ணப்படும் — பார்கோடு ஸ்கேனிங் இல்லை.';

  @override
  String get visionCounterStart => 'எண்ணத் தொடங்கு';

  @override
  String get visionCounterFinish => 'முடி';

  @override
  String get visionCounterPause => 'இடைநிறுத்து';

  @override
  String get visionCounterResume => 'தொடர்';

  @override
  String get visionCounterUndo => 'செயல்தவிர்';

  @override
  String get visionCounterFlip => 'பக்கம் மாற்று';

  @override
  String get visionCounterCounted => 'எண்ணப்பட்டது';

  @override
  String get visionCounterNothingYet =>
      'பொருட்களை எண்ண அவற்றைக் கோட்டைக் கடந்து நகர்த்தவும்.';

  @override
  String get visionCounterHint =>
      'பச்சை மண்டலத்திற்குள் கடக்கும் பொருட்கள் விற்றதாக எண்ணப்படும்.';

  @override
  String get visionCounterZoneStore => 'கடையில்';

  @override
  String get visionCounterZoneSold => 'விற்றது';

  @override
  String get visionCounterModelMissingTitle =>
      'கவுண்டர் மாதிரி நிறுவப்படவில்லை';

  @override
  String get visionCounterModelMissingDesc =>
      'சாதனத்தில் உள்ள எண்ணும் மாதிரி இந்த பதிப்பில் இன்னும் சேர்க்கப்படவில்லை. இது ஒரு புதுப்பிப்பில் வருகிறது — அலமாரி ஸ்கேனிங் இன்னும் வேலை செய்கிறது.';

  @override
  String get visionCounterPermTitle => 'கேமரா அணுகல் தேவை';

  @override
  String get visionCounterPermDesc =>
      'பில்லிங் கவுண்டரில் பொருட்களை எண்ண கேமரா அணுகலை அனுமதிக்கவும்.';

  @override
  String get visionCounterGrant => 'கேமராவை அனுமதி';

  @override
  String get visionCounterOpenSettings => 'அமைப்புகளைத் திற';

  @override
  String get visionCounterFinishConfirmTitle => 'எண்ணுவதை முடிக்கவா?';

  @override
  String get visionCounterFinishConfirmDesc =>
      'நாங்கள் இன்றைய கணக்கைச் சேமித்து உங்கள் கவுண்டர் சுருக்கத்தில் சேர்ப்போம்.';

  @override
  String get visionCounterSave => 'எண்ணிக்கையைச் சேமி';

  @override
  String get visionCounterDiscard => 'நிராகரி';

  @override
  String get visionCounterKeepCounting => 'எண்ணுவதைத் தொடர்';

  @override
  String get visionCounterSavedTitle => 'எண்ணிக்கை சேமிக்கப்பட்டது';

  @override
  String visionCounterSaved(int count, int skus) {
    return '$skus பொருட்களில் $count உருப்படிகள் சேமிக்கப்பட்டன.';
  }

  @override
  String get visionCounterOfflineNote =>
      'உங்கள் ஃபோனில் சேமிக்கப்பட்டது. கவுண்டர் சேவை கிடைக்கும்போது இது ஒத்திசைக்கும்.';

  @override
  String visionCounterPending(int count) {
    return '$count இன்னும் ஒத்திசைக்கப்படவில்லை';
  }

  @override
  String get visionCounterSummaryTitle => 'இன்றைய கவுண்டர் கணக்கு';

  @override
  String get visionCounterSummaryEmpty =>
      'இன்று எந்தப் பொருளும் எண்ணப்படவில்லை. தொடங்க \'எண்ணத் தொடங்கு\' என்பதைத் தட்டவும்.';

  @override
  String get visionCounterSummaryTotal => 'இன்று மொத்தம் எண்ணப்பட்டது';

  @override
  String get visionCounterUnknownItem => 'அடையாளம் தெரியாத பொருள்';

  @override
  String get onbCtaTitle => 'நூற்றுக்கணக்கான பொருட்கள் உள்ளதா?';

  @override
  String get onbCtaSubtitle =>
      'உங்கள் அலமாரிகளைப் புகைப்படம் எடுக்கவும், நாங்கள் பொருட்களை அடையாளம் கண்டு உங்கள் சரக்கில் சேர்ப்போம் — ஒவ்வொன்றையும் ஸ்கேன் செய்ய வேண்டியதில்லை.';

  @override
  String get onbCtaButton => 'உங்கள் அலமாரிகளைப் புகைப்படம் எடு';

  @override
  String get onbCaptureTitle => 'உங்கள் அலமாரிகளைப் புகைப்படம் எடுக்கவும்';

  @override
  String get onbCaptureHint =>
      'உங்கள் அனைத்து அலமாரிகளையும் உள்ளடக்கிய 3 முதல் 10 தெளிவான புகைப்படங்களை எடுக்கவும். நல்ல வெளிச்சம் அதிக பொருட்களை அடையாளம் காண உதவுகிறது.';

  @override
  String get onbTakePhoto => 'புகைப்படம் எடு';

  @override
  String onbPhotosProgress(int count) {
    return '10 இல் $count புகைப்படங்கள்';
  }

  @override
  String get onbMinPhotos => 'குறைந்தது 3 புகைப்படங்களைச் சேர்க்கவும்';

  @override
  String get onbAnalyze => 'பொருட்களை அடையாளம் காண்';

  @override
  String get onbProcessingTitle =>
      'நாங்கள் உங்கள் அலமாரி புகைப்படங்களை மதிப்பாய்வு செய்கிறோம்';

  @override
  String get onbProcessingDesc =>
      'எங்கள் அமைப்பு உங்கள் அலமாரியில் உள்ள பொருட்களை அடையாளம் காண்கிறது. இதற்கு பொதுவாக ஒரு நிமிடத்திற்கும் குறைவாகவே ஆகும். தயவுசெய்து இந்தத் திரையைத் திறந்து வைக்கவும் — நாங்கள் விரைவில் முடிவுகளை இங்கே காண்பிப்போம்.';

  @override
  String get onbReviewTitle => 'உங்கள் இருப்பை உறுதிப்படுத்தவும்';

  @override
  String get onbReviewDisclaimer =>
      'இவை உங்கள் புகைப்படங்களிலிருந்து நாங்கள் அடையாளம் கண்ட பொருட்கள். நாங்கள் சில நேரங்களில் ஒரு பொருளைத் தவறவிடலாம் அல்லது தவறாகப் படிக்கலாம், எனவே அளவுகளைச் சரிபார்த்து சரிசெய்யவும். நாங்கள் தொடர்ந்து எங்கள் துல்லியத்தை மேம்படுத்துகிறோம்.';

  @override
  String onbReviewSummary(int mapped, int unmapped) {
    return '$mapped தயார் · $unmapped க்கு ஒரு பொருள் தேவை';
  }

  @override
  String get onbUnrecognised =>
      'அடையாளம் தெரியவில்லை — ஒரு பொருளைத் தேர்ந்தெடுக்கவும்';

  @override
  String get onbChooseProduct => 'பொருளைத் தேர்ந்தெடு';

  @override
  String get onbQuantity => 'அளவு';

  @override
  String get onbCommit => 'என் சரக்கில் சேர்';

  @override
  String get onbCommitting => 'உங்கள் சரக்கில் சேர்க்கப்படுகிறது…';

  @override
  String get onbDoneTitle => 'இருப்பு சேர்க்கப்பட்டது';

  @override
  String onbDoneDesc(int products, int units) {
    return '$products பொருட்கள் ($units உருப்படிகள்) உங்கள் சரக்கில் சேர்க்கப்பட்டன. சரக்கு தாவலில் இருந்து எப்போது வேண்டுமானாலும் விலைகளை அமைக்கலாம்.';
  }

  @override
  String get onbEmptyDetected =>
      'இந்தப் புகைப்படங்களில் எங்களால் பொருட்களை அடையாளம் காண முடியவில்லை. தயவுசெய்து நல்ல வெளிச்சத்தில், பேக்கேஜிங்கைத் தெளிவாகக் காட்டி மீண்டும் புகைப்படம் எடுக்கவும்.';

  @override
  String get onbRetake => 'மீண்டும் புகைப்படம் எடு';

  @override
  String get onbFailedTitle => 'எங்களால் முடிக்க முடியவில்லை';

  @override
  String get onbDone => 'முடிந்தது';

  @override
  String get onbRemove => 'அகற்று';

  @override
  String get visionAddPhotosTitle => 'அலமாரி புகைப்படங்களைச் சேர்க்கவும்';

  @override
  String get visionAddPhotosHint =>
      'உங்கள் அலமாரிகளை உள்ளடக்கும்படி 3 முதல் 10 புகைப்படங்கள் எடுக்கவும்.';

  @override
  String get visionMinPhotosHint => 'குறைந்தது 3 புகைப்படங்களைச் சேர்க்கவும்';

  @override
  String get visionMaxReached => 'அதிகபட்சம் 10 புகைப்படங்கள்';

  @override
  String get visionAnalyze => 'பகுப்பாய்வு செய்';

  @override
  String get forecastSectionLabel => 'விற்பனை கணிப்பு';

  @override
  String forecastStripCount(int count) {
    return 'நாளை $count பொருட்கள் விற்கப்படலாம்';
  }

  @override
  String forecastStripEst(String amount) {
    return 'மதிப்பீடு $amount';
  }

  @override
  String get forecastStripViewAll => 'முழு பட்டியல் பார்க்க';

  @override
  String get forecastScreenTitle => 'விற்பனை கணிப்பு';

  @override
  String get forecastHorizonTomorrow => 'நாளை';

  @override
  String get forecastHorizon3d => '3 நாட்கள்';

  @override
  String get forecastHorizon5d => '5 நாட்கள்';

  @override
  String get forecastHorizon7d => '7 நாட்கள்';

  @override
  String get forecastHorizon14d => '14 நாட்கள்';

  @override
  String get forecastHorizon30d => '30 நாட்கள்';

  @override
  String get forecastRevLabel => 'மதிப்பிட்ட வருமானம்';

  @override
  String get forecastOosWarning => 'தொக்கு தீர்ந்துவிடலாம்';

  @override
  String get forecastWhyTitle => 'இது ஏன் இங்கே?';

  @override
  String get forecastWhyAvgDaily => 'தினசரி சராசரி விற்பனை';

  @override
  String get forecastWhyStockDays => 'மீதமுள்ள தொக்கு';

  @override
  String get forecastWhyOosRisk => 'தீர்ந்துவிடும் வாய்ப்பு';

  @override
  String forecastWhyExplain(String avg, String days, String units) {
    return 'இந்தப் பொருள் தினமும் சராசரியாக $avg தொகுதிகள் விற்கிறது. $days நாட்களில், உங்கள் கடையில் இருந்து சுமார் $units தொகுதிகள் விற்கும் என எதிர்பார்க்கப்படுகிறது.';
  }

  @override
  String get forecastNoData =>
      'கணிப்பு இன்னும் தயாரில்லை. பிறகு முயற்சிக்கவும்.';

  @override
  String get forecastDataStale => 'தரவு பழையதாக இருக்கலாம்';
}
