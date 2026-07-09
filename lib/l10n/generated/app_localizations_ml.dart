// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get languageName => 'മലയാളം';

  @override
  String get languageChooseTitle => 'നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get languageChooseSubtitle =>
      'ഇത് ക്രമീകരണങ്ങളിൽ എപ്പോൾ വേണമെങ്കിലും മാറ്റാം.';

  @override
  String get settingsLanguage => 'ഭാഷ';

  @override
  String get commonContinue => 'തുടരുക';

  @override
  String get commonServerError =>
      'സെർവറുമായി ബന്ധിപ്പിക്കാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get commonSomethingWrong =>
      'എന്തോ പിഴവ് സംഭവിച്ചു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get authErrEnterPhone => 'നിങ്ങളുടെ ഫോൺ നമ്പർ നൽകുക';

  @override
  String get authErrEnter6Otp => '6-അക്ക OTP നൽകുക';

  @override
  String get authErrSessionExpired =>
      'സെഷൻ കാലഹരണപ്പെട്ടു. വീണ്ടും അയയ്ക്കുക ടാപ്പ് ചെയ്യുക.';

  @override
  String get authErrInvalidPhone =>
      'അസാധുവായ ഫോൺ നമ്പർ. രാജ്യ കോഡ് ഉൾപ്പെടുത്തുക (ഉദാ. +91...).';

  @override
  String get authErrTooManyRequests =>
      'വളരെയധികം ശ്രമങ്ങൾ. ദയവായി പിന്നീട് ശ്രമിക്കുക.';

  @override
  String get authErrWrongOtp => 'തെറ്റായ OTP. പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get authErrOtpExpired =>
      'OTP കാലഹരണപ്പെട്ടു. പുതിയ കോഡിന് വീണ്ടും അയയ്ക്കുക ടാപ്പ് ചെയ്യുക.';

  @override
  String get authErrVerificationFailed =>
      'പരിശോധന പരാജയപ്പെട്ടു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get welcomeSlide1Title => 'Outlet AI യിലേക്ക്\nസ്വാഗതം';

  @override
  String get welcomeSlide1Subtitle =>
      'നിങ്ങളുടെ പലചരക്ക് കട കൈകാര്യം ചെയ്യാനുള്ള നിങ്ങളുടെ സ്മാർട്ട് ബിസിനസ് പങ്കാളി — ദക്ഷിണേന്ത്യയ്ക്കായി നിർമിച്ചത്.';

  @override
  String get welcomeSlide2Title => 'സ്മാർട്ട് ഇൻവെന്ററി\nമാനേജ്മെന്റ്';

  @override
  String get welcomeSlide2Subtitle =>
      'സ്റ്റോക്ക് നിലവാരം ട്രാക്ക് ചെയ്യുക, ലോ-സ്റ്റോക്ക് അലേർട്ടുകൾ നേടുക, നിങ്ങളുടെ ഏറ്റവും കൂടുതൽ വിൽക്കുന്ന ഉൽപ്പന്നങ്ങൾ ഒരിക്കലും തീരാതെ സൂക്ഷിക്കുക.';

  @override
  String get welcomeSlide3Title => 'നിങ്ങളുടെ ബിസിനസ്\nവളർത്തുക';

  @override
  String get welcomeSlide3Subtitle =>
      'AI-പവർഡ് ഉൾക്കാഴ്ചകൾ, വിൽപ്പന അനലിറ്റിക്സ്, നിങ്ങളുടെ കടയ്ക്കായി വ്യക്തിഗതമാക്കിയ നുറുങ്ങുകൾ എന്നിവ നേടുക.';

  @override
  String get welcomeGetStarted => 'ആരംഭിക്കുക';

  @override
  String get welcomeHaveAccount => 'ഇതിനകം അക്കൗണ്ട് ഉണ്ടോ? ';

  @override
  String get welcomeSignIn => 'സൈൻ ഇൻ';

  @override
  String get loginWelcomeBack => 'വീണ്ടും സ്വാഗതം';

  @override
  String get loginSubtitle =>
      'നിങ്ങളുടെ Outlet AI അക്കൗണ്ടിലേക്ക് സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get loginTabPhone => 'ഫോൺ OTP';

  @override
  String get loginTabUsername => 'ഉപയോക്തൃനാമം';

  @override
  String get loginPhoneLabel => 'ഫോൺ നമ്പർ';

  @override
  String get loginSendOtp => 'OTP അയയ്ക്കുക';

  @override
  String get loginOtpHelp => 'ഈ നമ്പറിലേക്ക് ഒറ്റത്തവണ പാസ്‌വേഡ് അയയ്ക്കും';

  @override
  String loginOtpSentTo(String phone) {
    return '$phone ലേക്ക് OTP അയച്ചു';
  }

  @override
  String get loginOtp6Label => '6-അക്ക OTP';

  @override
  String get loginVerifyOtp => 'OTP പരിശോധിക്കുക';

  @override
  String get loginResendOtp => 'OTP വീണ്ടും അയയ്ക്കുക';

  @override
  String get loginUsernameLabel => 'ഉപയോക്തൃനാമം';

  @override
  String get loginUsernameHint => 'ഉദാ. mykiranastore';

  @override
  String get loginUsernameRequired => 'ഉപയോക്തൃനാമം ആവശ്യമാണ്';

  @override
  String get loginPasswordLabel => 'പാസ്‌വേഡ്';

  @override
  String get loginPasswordHint => 'നിങ്ങളുടെ പാസ്‌വേഡ്';

  @override
  String get loginPasswordRequired => 'പാസ്‌വേഡ് ആവശ്യമാണ്';

  @override
  String get loginSignIn => 'സൈൻ ഇൻ';

  @override
  String get loginNoAccount => 'അക്കൗണ്ട് ഇല്ലേ? ';

  @override
  String get loginCreateOne => 'ഒന്ന് സൃഷ്ടിക്കുക';

  @override
  String get loginIncorrect =>
      'തെറ്റായ ഉപയോക്തൃനാമം അല്ലെങ്കിൽ പാസ്‌വേഡ്. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String loginFailed(String message) {
    return 'ലോഗിൻ പരാജയപ്പെട്ടു: $message';
  }

  @override
  String onboardingStepCount(int step) {
    return '$step/4';
  }

  @override
  String get accountVerifyPhoneTitle => 'നിങ്ങളുടെ ഫോൺ\nനമ്പർ പരിശോധിക്കുക';

  @override
  String get accountVerifyPhoneSubtitle =>
      'നിങ്ങളുടെ നമ്പർ സ്ഥിരീകരിക്കാൻ ഒറ്റത്തവണ പാസ്‌വേഡ് അയയ്ക്കും.';

  @override
  String get accountPhoneLabel => 'ഫോൺ നമ്പർ';

  @override
  String get accountSendOtp => 'OTP അയയ്ക്കുക';

  @override
  String get accountEnterOtpTitle => 'OTP നൽകുക';

  @override
  String get accountEnterOtpSubtitle =>
      'നിങ്ങളുടെ ഫോണിലേക്ക് 6-അക്ക കോഡ് അയച്ചു.';

  @override
  String accountOtpSentTo(String phone) {
    return '+91 $phone ലേക്ക് OTP അയച്ചു';
  }

  @override
  String get accountOtp6Label => '6-അക്ക OTP';

  @override
  String get accountVerify => 'പരിശോധിക്കുക';

  @override
  String get accountResendOtp => 'OTP വീണ്ടും അയയ്ക്കുക';

  @override
  String accountPhoneVerified(String phone) {
    return 'ഫോൺ പരിശോധിച്ചു: $phone';
  }

  @override
  String get accountChooseUsernameTitle =>
      'ഒരു സ്റ്റോർ\nഉപയോക്തൃനാമം തിരഞ്ഞെടുക്കുക';

  @override
  String get accountChooseUsernameSubtitle =>
      'നിങ്ങളുടെ ഉപയോക്തൃനാമം നിങ്ങളുടെ കടയ്ക്ക് അദ്വിതീയമാണ്, ലോഗിൻ ചെയ്യാൻ ഉപയോഗിക്കുന്നു.';

  @override
  String get accountUsernameLabel => 'ഉപയോക്തൃനാമം';

  @override
  String get accountUsernameHint => 'ഉദാ. lohiyastore123';

  @override
  String get accountUsernameTaken => 'ഉപയോക്തൃനാമം ഇതിനകം എടുത്തിട്ടുണ്ട്';

  @override
  String get accountUsernameRules =>
      'അക്ഷരങ്ങൾ, അക്കങ്ങൾ, അണ്ടർസ്കോറുകൾ മാത്രം • കുറഞ്ഞത് 3 പ്രതീകങ്ങൾ';

  @override
  String get accountErrChooseUsername =>
      'നിങ്ങളുടെ കടയ്ക്ക് ഒരു അദ്വിതീയ ഉപയോക്തൃനാമം തിരഞ്ഞെടുക്കുക';

  @override
  String get accountErrUsernameMin3 =>
      'ഉപയോക്തൃനാമം കുറഞ്ഞത് 3 പ്രതീകങ്ങൾ ഉണ്ടായിരിക്കണം';

  @override
  String get accountErrUsernameMax30 =>
      'ഉപയോക്തൃനാമം പരമാവധി 30 അക്ഷരങ്ങൾ വരെയാകാം';

  @override
  String get accountErrUsernameChars =>
      'അക്ഷരങ്ങൾ, അക്കങ്ങൾ, അണ്ടർസ്കോറുകൾ മാത്രമേ അനുവദിക്കൂ';

  @override
  String get accountErrUsernameTakenTry =>
      'ആ ഉപയോക്തൃനാമം എടുത്തിട്ടുണ്ട്. മറ്റൊന്ന് ശ്രമിക്കുക.';

  @override
  String get accountUsernameAvailable => 'ഉപയോക്തൃനാമം ലഭ്യമാണ്';

  @override
  String get businessTitle => 'നിങ്ങളുടെ കടയെക്കുറിച്ച്\nഞങ്ങളോട് പറയുക';

  @override
  String get businessSubtitle =>
      'നിങ്ങളുടെ അനുഭവം വ്യക്തിഗതമാക്കാൻ ഞങ്ങളെ സഹായിക്കുക.';

  @override
  String get businessOwnerLabel => 'ഉടമയുടെ പൂർണ്ണ നാമം';

  @override
  String get businessOwnerHint => 'ഉദാ. രമേഷ് കുമാർ';

  @override
  String get businessOwnerRequired => 'പേര് ആവശ്യമാണ്';

  @override
  String get businessStoreLabel => 'സ്റ്റോർ പേര്';

  @override
  String get businessStoreHint => 'ഉദാ. ശ്രീ ലക്ഷ്മി സ്റ്റോേഴ്സ്';

  @override
  String get businessStoreRequired => 'സ്റ്റോർ പേര് ആവശ്യമാണ്';

  @override
  String get businessEmailLabel => 'ഇമെയിൽ വിലാസം';

  @override
  String get businessEmailHint => 'you@example.com';

  @override
  String get businessEmailRequired => 'ഇമെയിൽ ആവശ്യമാണ്';

  @override
  String get businessEmailInvalid => 'സാധുവായ ഇമെയിൽ വിലാസം നൽകുക';

  @override
  String get businessTypeLabel => 'ബിസിനസ് തരം';

  @override
  String get businessTypeHint => 'നിങ്ങളുടെ സ്റ്റോർ തരം തിരഞ്ഞെടുക്കുക';

  @override
  String get businessTypeRequired =>
      'ദയവായി നിങ്ങളുടെ ബിസിനസ് തരം തിരഞ്ഞെടുക്കുക';

  @override
  String get businessFootfallLabel => 'ഏകദേശ ദൈനംദിന ഉപഭോക്താക്കൾ';

  @override
  String get businessFootfallHint => 'ഉദാ. 40';

  @override
  String get businessFootfallSuffix => 'ഉപഭോക്താക്കൾ/ദിവസം';

  @override
  String get businessFootfallInvalid => 'സാധുവായ നമ്പർ നൽകുക';

  @override
  String get businessBudgetLabel => 'പ്രതിമാസ വിൽപ്പന ലക്ഷ്യം (ഓപ്ഷണൽ)';

  @override
  String get businessBudgetHint => 'ഉദാ. 150000';

  @override
  String get businessBudgetHelper =>
      'ദൈനംദിന പുരോഗതി ട്രാക്ക് ചെയ്യാൻ ഉപയോഗിക്കുന്നു. നിങ്ങൾക്ക് പിന്നീട് മാറ്റാം.';

  @override
  String get businessBudgetInvalid => 'സാധുവായ തുക നൽകുക';

  @override
  String get businessTypeKirana => 'കിരാന / ജനറൽ സ്റ്റോർ';

  @override
  String get businessTypeGeneral => 'ജനറൽ സ്റ്റോർ';

  @override
  String get businessTypeProvision => 'പ്രൊവിഷൻ സ്റ്റോർ';

  @override
  String get businessTypeFruitsVeg => 'പഴങ്ങൾ & പച്ചക്കറികൾ';

  @override
  String get businessTypeStationery => 'സ്റ്റേഷനറി & പുസ്തകങ്ങൾ';

  @override
  String get businessTypeSupermarket => 'സൂപ്പർമാർക്കറ്റ്';

  @override
  String get businessTypeMiniSupermarket => 'മിനി സൂപ്പർമാർക്കറ്റ്';

  @override
  String get businessTypeMonoBrand => 'മോണോ ബ്രാൻഡ് സ്റ്റോർ';

  @override
  String get businessTypeBoutique => 'ബൊട്ടീക്ക്';

  @override
  String get businessTypeSalon => 'സലൂൺ & പാർലർ';

  @override
  String get businessTypeFancyGift => 'ഫാൻസി & ഗിഫ്റ്റ് സ്റ്റോർ';

  @override
  String get businessTypeSportsFitness => 'സ്പോർട്സ് & ഫിറ്റ്നസ്';

  @override
  String get businessTypeFootwear => 'പാദരക്ഷ കട';

  @override
  String get businessTypeOptical => 'ഒപ്റ്റിക്കൽ സ്റ്റോർ';

  @override
  String get businessTypeBakery => 'ബേക്കറി & മധുരപലഹാര കട';

  @override
  String get businessTypeApparel => 'വസ്ത്രങ്ങൾ';

  @override
  String get businessTypeElectronics => 'മൊബൈൽ & ഇലക്ട്രോണിക്സ്';

  @override
  String get businessTypeOthers => 'മറ്റുള്ളവ';

  @override
  String get locationTitle => 'നിങ്ങളുടെ കട\nഎവിടെയാണ്?';

  @override
  String get locationSubtitle =>
      'പ്രാദേശിക ഉൾക്കാഴ്ചകൾ കാണിക്കാനും ഡെലിവറി സോണുകൾ പ്രവർത്തനക്ഷമമാക്കാനും ഇത് ഉപയോഗിക്കുന്നു.';

  @override
  String get locationDetecting => 'ലൊക്കേഷൻ കണ്ടെത്തുന്നു…';

  @override
  String get locationDetect => 'എന്റെ ലൊക്കേഷൻ കണ്ടെത്തുക';

  @override
  String get locationOrManual => 'അല്ലെങ്കിൽ നേരിട്ട് നൽകുക';

  @override
  String get locationAddressLabel => 'സ്റ്റോർ വിലാസം';

  @override
  String get locationAddressHint => 'തെരുവ്, പ്രദേശം, ലാൻഡ്മാർക്ക്…';

  @override
  String get locationCityLabel => 'നഗരം / ജില്ല';

  @override
  String get locationCityHint => 'ഉദാ. ഹൈദരാബാദ്';

  @override
  String get locationGettingCoords => 'കോർഡിനേറ്റുകൾ ലഭിക്കുന്നു…';

  @override
  String get locationDetected => 'ലൊക്കേഷൻ കണ്ടെത്തി';

  @override
  String get locationErrAddress =>
      'ദയവായി നിങ്ങളുടെ സ്റ്റോർ വിലാസം കണ്ടെത്തുകയോ നൽകുകയോ ചെയ്യുക.';

  @override
  String get locationErrCity => 'ദയവായി നിങ്ങളുടെ നഗരം അല്ലെങ്കിൽ ജില്ല നൽകുക.';

  @override
  String get locationPermDenied =>
      'ലൊക്കേഷൻ അനുമതി നിഷേധിച്ചു. ദയവായി വിലാസം നേരിട്ട് നൽകുക.';

  @override
  String get locationDetectFailed =>
      'ലൊക്കേഷൻ കണ്ടെത്താനായില്ല. ദയവായി വിലാസം നേരിട്ട് നൽകുക.';

  @override
  String get consentTitle => 'ഏതാണ്ട് പൂർത്തിയായി!\nഅവലോകനം ചെയ്ത് സമ്മതിക്കുക';

  @override
  String get consentSubtitle =>
      'നിങ്ങളുടെ സജ്ജീകരണം പൂർത്തിയാക്കാൻ ദയവായി താഴെപ്പറയുന്നവ വായിച്ച് അംഗീകരിക്കുക.';

  @override
  String get consentTermsTitle => 'നിബന്ധനകൾ & വ്യവസ്ഥകൾ';

  @override
  String get consentTermsSummary =>
      'Outlet AI ഉപയോഗിക്കുന്നതിലൂടെ, സേവനം നിയമാനുസൃത ബിസിനസ് ആവശ്യങ്ങൾക്ക് മാത്രം ഉപയോഗിക്കാൻ നിങ്ങൾ സമ്മതിക്കുന്നു. ഈ നിബന്ധനകൾ ലംഘിക്കുന്ന അക്കൗണ്ടുകൾ താൽക്കാലികമായി നിർത്താനുള്ള അവകാശം LohiyaAI നിക്ഷിപ്തമാണ്. നിങ്ങളുടെ ഡാറ്റ സേവനം നൽകാനും മെച്ചപ്പെടുത്താനും മാത്രമേ ഉപയോഗിക്കൂ.';

  @override
  String get consentPrivacyTitle => 'സ്വകാര്യതാ നയം';

  @override
  String get consentPrivacySummary =>
      'നിങ്ങളുടെ അനുഭവം വ്യക്തിഗതമാക്കാൻ ഞങ്ങൾ നിങ്ങളുടെ സ്റ്റോർ വിശദാംശങ്ങൾ, ലൊക്കേഷൻ, ഇടപാട് ഡാറ്റ എന്നിവ ശേഖരിക്കുന്നു. നിങ്ങളുടെ വ്യക്തിഗത ഡാറ്റ ഞങ്ങൾ ഒരിക്കലും മൂന്നാം കക്ഷികൾക്ക് വിൽക്കില്ല. എല്ലാ ഡാറ്റയും എൻക്രിപ്റ്റ് ചെയ്ത് ഞങ്ങളുടെ ക്ലൗഡ് ഇൻഫ്രാസ്ട്രക്ചറിൽ സുരക്ഷിതമായി സംഭരിക്കുന്നു.';

  @override
  String get consentTermsCheckPrefix => 'ഞാൻ വായിച്ച് സമ്മതിക്കുന്നു ';

  @override
  String get consentPrivacyCheckPrefix => 'ഞാൻ സമ്മതിക്കുന്നു ';

  @override
  String get consentAcceptBoth => 'തുടരാൻ രണ്ട് കരാറുകളും അംഗീകരിക്കുക.';

  @override
  String get consentCompleteSetup => 'സജ്ജീകരണം പൂർത്തിയാക്കുക';

  @override
  String get regErrPhoneExists =>
      'ഈ ഫോൺ നമ്പർ ഇതിനകം രജിസ്റ്റർ ചെയ്തിട്ടുണ്ട്. പകരം സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get regErrUsernameTaken =>
      'ഈ ഉപയോക്തൃനാമം ഇതിനകം എടുത്തിട്ടുണ്ട്. ദയവായി മറ്റൊന്ന് തിരഞ്ഞെടുക്കുക.';

  @override
  String get regErrInvalidDetails =>
      'അസാധുവായ വിശദാംശങ്ങൾ. നിങ്ങളുടെ എൻട്രികൾ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String regErrFailed(String message) {
    return 'രജിസ്ട്രേഷൻ പരാജയപ്പെട്ടു: $message';
  }

  @override
  String get dashNavHome => 'ഹോം';

  @override
  String get dashNavKhata => 'കണക്ക്';

  @override
  String get dashNavBilling => 'ബില്ലിംഗ്';

  @override
  String get dashTrialWelcome => 'Outlet AI യിലേക്ക് സ്വാഗതം';

  @override
  String get dashTrialChoosePlan =>
      'സൗജന്യമായി പരീക്ഷിക്കാൻ ഒരു പ്ലാൻ തിരഞ്ഞെടുക്കുക. ഞങ്ങളുടെ ടീം ഉടൻ ഇത് സജീവമാക്കും.';

  @override
  String get dashTrialSelectPlan => 'നിങ്ങളുടെ ട്രയൽ പ്ലാൻ തിരഞ്ഞെടുക്കുക';

  @override
  String get dashTrialRequestPro => 'Pro ട്രയൽ അഭ്യർത്ഥിക്കുക';

  @override
  String get dashTrialRequestBasic => 'Basic ട്രയൽ അഭ്യർത്ഥിക്കുക';

  @override
  String get dashTrialRequestError =>
      'ഇപ്പോൾ നിങ്ങളുടെ ട്രയൽ ആരംഭിക്കാനായില്ല. ദയവായി നിങ്ങളുടെ കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get dashTrialSignInDifferent =>
      'മറ്റൊരു അക്കൗണ്ടിലേക്ക് സൈൻ ഇൻ ചെയ്യുക';

  @override
  String get dashPlanBadgeAllFeatures => 'എല്ലാ ഫീച്ചറുകളും';

  @override
  String get dashPlanBasicName => 'ബേസിക് പ്ലാൻ';

  @override
  String get dashPlanProName => 'Pro പ്ലാൻ';

  @override
  String get dashFeatPos => 'POS & വിൽപ്പന മാനേജ്മെന്റ്';

  @override
  String get dashFeatInventoryTracking => 'ഇൻവെന്ററി ട്രാക്കിംഗ്';

  @override
  String get dashFeatFinanceUdhaar => 'ഫിനാൻസ് & ഉധാർ';

  @override
  String get dashFeatKpiInsights => 'KPI ഉൾക്കാഴ്ചകൾ (വിഭാഗത്തിന് 3)';

  @override
  String get dashFeatAiReco => 'AI ശുപാർശകൾ';

  @override
  String get dashFeatEverythingBasic => 'ബേസിക്കിലുള്ളതെല്ലാം';

  @override
  String get dashFeatAllKpi => 'എല്ലാ KPI വിഭാഗങ്ങളും (പരിധിയില്ലാത്തത്)';

  @override
  String get dashFeatVendorProcurement =>
      'വെണ്ടർ & പ്രൊക്യുർമെന്റ് മാനേജ്മെന്റ്';

  @override
  String get dashFeatCashflowSupport => 'ക്യാഷ്ഫ്ലോ പിന്തുണ (₹10L വരെ)';

  @override
  String get dashFeatCustomerGrowth => 'കസ്റ്റമർ ഗ്രോത്ത് എഞ്ചിൻ';

  @override
  String get dashPendingTitle => 'ട്രയൽ അഭ്യർത്ഥന ലഭിച്ചു!';

  @override
  String get dashPendingBody =>
      'നിങ്ങളുടെ ട്രയൽ സജീവമാക്കൽ ഞങ്ങളുടെ ടീം അവലോകനം ചെയ്യുന്നു. അംഗീകരിച്ചാലുടൻ നിങ്ങളുടെ ഉപകരണത്തിൽ അറിയിപ്പ് ലഭിക്കും — സാധാരണയായി ഏതാനും മണിക്കൂറുകൾക്കുള്ളിൽ.';

  @override
  String get dashPendingNotifNote =>
      'സജീവമാക്കൽ അലേർട്ട് നഷ്ടപ്പെടാതിരിക്കാൻ അറിയിപ്പുകൾ പ്രവർത്തനക്ഷമമാണെന്ന് ഉറപ്പാക്കുക.';

  @override
  String get dashPendingCheckStatus => 'സ്റ്റാറ്റസ് പരിശോധിക്കുക';

  @override
  String get dashUpgradeTitle => 'സൗജന്യ ട്രയൽ അവസാനിച്ചു';

  @override
  String get dashUpgradeBody =>
      'നിങ്ങളുടെ സൗജന്യ ട്രയൽ അവസാനിച്ചു. Outlet AI ഉപയോഗിക്കുന്നത് തുടരാനും നിങ്ങളുടെ കട വളർത്താനും ഒരു പ്ലാൻ തിരഞ്ഞെടുക്കുക.';

  @override
  String get dashUpgradeBasic => 'ബേസിക്';

  @override
  String get dashUpgradePro => 'Pro';

  @override
  String get dashUpgradeBadgeBest => 'മികച്ചത്';

  @override
  String dashUpgradeJustPerDay(String price) {
    return 'വെറും $price';
  }

  @override
  String get dashUpgradeAlreadySubscribed =>
      'ഇതിനകം സബ്സ്ക്രൈബ് ചെയ്തോ? പുതുക്കുക';

  @override
  String get dashFeatPosInventory => 'POS & ഇൻവെന്ററി';

  @override
  String get dashFeatFinanceKpis => 'ഫിനാൻസ് & KPIകൾ';

  @override
  String get dashFeatVendorManagement => 'വെണ്ടർ മാനേജ്മെന്റ്';

  @override
  String get dashFeatCashflowReferrals => 'ക്യാഷ്ഫ്ലോ + റഫറലുകൾ';

  @override
  String get dashNewSale => 'പുതിയ വിൽപ്പന';

  @override
  String get dashGreetingMorning => 'സുപ്രഭാതം';

  @override
  String get dashGreetingAfternoon => 'ശുഭ മധ്യാഹ്നം';

  @override
  String get dashGreetingEvening => 'ശുഭ സന്ധ്യ';

  @override
  String dashGreetingWithName(String greeting, String name) {
    return '$greeting, \n$name';
  }

  @override
  String get dashMorningBriefing => 'പ്രഭാത ബ്രീഫിംഗ്';

  @override
  String dashBriefingBody(int risk, int reorder) {
    return 'നിങ്ങൾക്ക് $risk SKU-കൾ ഗുരുതരമായ അപകടത്തിലാണ്, ഇന്ന് $reorder ഇനങ്ങൾ വീണ്ടും ഓർഡർ ചെയ്യണം. പരിഹരിക്കാൻ ടാപ്പ് ചെയ്യുക.';
  }

  @override
  String get dashIntelligence => 'ഇന്റലിജൻസ്';

  @override
  String get dashMetricStockoutLabel => 'സ്റ്റോക്ക്ഔട്ട് റിസ്ക്';

  @override
  String get dashMetricStockoutSub => 'SKU-കൾ ഗുരുതരം';

  @override
  String get dashMetricReorderLabel => 'ഇപ്പോൾ വീണ്ടും ഓർഡർ ചെയ്യുക';

  @override
  String get dashMetricReorderSub => 'SKU-കൾ കുറഞ്ഞ സ്റ്റോക്ക്';

  @override
  String get dashMetricFastLabel => 'വേഗത്തിൽ വിറ്റുപോകുന്നവ';

  @override
  String get dashMetricFastSub => 'മികച്ച വിൽപ്പന';

  @override
  String get dashMetricProfitLabel => 'ലാഭ തിരഞ്ഞെടുപ്പുകൾ';

  @override
  String get dashMetricProfitSub => 'അവസരങ്ങൾ';

  @override
  String get dashMetricCustomerLabel => 'ഉപഭോക്തൃ കുടിശ്ശിക';

  @override
  String get dashMetricCustomerSub => 'തീർപ്പാക്കാത്ത ഖാത';

  @override
  String get dashMetricSalesLabel => 'വിറ്റ ഇനങ്ങൾ';

  @override
  String get dashMetricSalesSub => 'ഇന്ന് ഇതുവരെ';

  @override
  String get dashTodaysPerformance => 'ഇന്നത്തെ പ്രകടനം';

  @override
  String get dashPosNotAvailable => 'POS ഡാറ്റ ലഭ്യമല്ല';

  @override
  String get dashStatRevenue => 'വരുമാനം';

  @override
  String get dashStatOrders => 'ബില്ലുകൾ';

  @override
  String get dashStatAvgOrder => 'ശരാശരി ബിൽ';

  @override
  String get dashStoreOverview => 'സ്റ്റോർ അവലോകനം';

  @override
  String get dashStoreSkus => 'SKU-കൾ';

  @override
  String get dashStoreFootfall => 'ദൈനംദിന ഉപഭോക്തൃ വരവ്';

  @override
  String get dashStoreDailyBudget => 'ദിവസേനയുള്ള സാധന ചെലവ്';

  @override
  String dashKpiPeriod(int days) {
    return 'കഴിഞ്ഞ $days ദിവസം';
  }

  @override
  String get dashCouldNotLoad => 'ഡാറ്റ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get dashRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get dashAlerts => 'അലേർട്ടുകൾ';

  @override
  String get dashSeeAll => 'എല്ലാം കാണുക';

  @override
  String get dashStoreKpis => 'സ്റ്റോർ KPI-കൾ';

  @override
  String dashKpiCoverageTooltip(String pct) {
    return '$pct% വിൽപ്പനയെ അടിസ്ഥാനമാക്കി — ചില ഇനങ്ങൾക്ക് ചെലവ് ഡാറ്റ ഇല്ല';
  }

  @override
  String get dashDetailStockout => 'സ്റ്റോക്ക്ഔട്ട് റിസ്ക്';

  @override
  String get dashDetailReorder => 'വീണ്ടും ഓർഡർ ആവശ്യമാണ്';

  @override
  String get dashDetailFastMoving => 'വേഗത്തിൽ വിറ്റുപോകുന്ന ഇനങ്ങൾ';

  @override
  String get dashDetailProfit => 'ഉയർന്ന ലാഭ ഇനങ്ങൾ';

  @override
  String get dashDetailDefault => 'ഇന്റലിജൻസ് വിശദാംശം';

  @override
  String get dashSearchProducts => 'ഉൽപ്പന്നങ്ങൾ തിരയുക...';

  @override
  String get dashSortBy => 'ക്രമീകരിക്കുക:';

  @override
  String get dashSortProfit => 'ലാഭം';

  @override
  String get dashSortDemand => 'ഡിമാൻഡ്';

  @override
  String get dashSortRisk => 'റിസ്ക്';

  @override
  String dashStockLabel(String qty) {
    return 'സ്റ്റോക്ക്: $qty';
  }

  @override
  String get dashStockRunway => 'സ്റ്റോക്ക് കാലയളവ്';

  @override
  String get dashOutOfStock => 'സ്റ്റോക്ക് തീർന്നു';

  @override
  String dashDaysLeft(String days) {
    return '~$days ദിവസം ബാക്കി';
  }

  @override
  String get dashStatStockoutRisk => 'സ്റ്റോക്ക്ഔട്ട് റിസ്ക്';

  @override
  String get dashStatReorderQty => 'വീണ്ടും ഓർഡർ അളവ്';

  @override
  String dashUnitsValue(String qty) {
    return '$qty യൂണിറ്റുകൾ';
  }

  @override
  String dashWeeklyProfitImpact(String amount) {
    return '₹$amount കണക്കാക്കിയ പ്രതിവാര ലാഭ സ്വാധീനം';
  }

  @override
  String dashCreatePurchaseOrder(String qty) {
    return 'പർച്ചേസ് ഓർഡർ സൃഷ്ടിക്കുക · $qty യൂണിറ്റുകൾ';
  }

  @override
  String get dashNoItemsFound => 'ഇനങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String dashNoResultsFor(String query) {
    return '\"$query\" എന്നതിന് ഫലങ്ങളൊന്നുമില്ല';
  }

  @override
  String get dashClearSearch => 'തിരയൽ മായ്ക്കുക';

  @override
  String get dashConnectionError => 'കണക്ഷൻ പിശക്';

  @override
  String get posCommonCancel => 'റദ്ദാക്കുക';

  @override
  String get posCommonClear => 'മായ്ക്കുക';

  @override
  String get posCommonRefresh => 'പുതുക്കുക';

  @override
  String get posCommonAddToCart => 'കാർട്ടിൽ ചേർക്കുക';

  @override
  String get posCameraPermissionRequired =>
      'ബാർകോഡുകൾ സ്കാൻ ചെയ്യാൻ ക്യാമറ അനുമതി ആവശ്യമാണ്.';

  @override
  String get posCommonSettings => 'സെറ്റിങ്സ്';

  @override
  String posEnterQtyTitle(String unit) {
    return '$unit നൽകുക';
  }

  @override
  String get posQtyFallback => 'അളവ്';

  @override
  String get posSelectVariant => 'വേരിയന്റ് തിരഞ്ഞെടുക്കുക';

  @override
  String posInclGst(String amount) {
    return 'GST ഉൾപ്പെടെ $amount';
  }

  @override
  String get posOutOfStock => 'സ്റ്റോക്ക് ഇല്ല';

  @override
  String posVariantStockLine(String stock) {
    return '$stock സ്റ്റോക്കിൽ';
  }

  @override
  String posPriceLabel(String price) {
    return 'വില: $price';
  }

  @override
  String get posWeightMeasurement => 'ഭാരം / അളവ്';

  @override
  String get posUnknownBarcodeTitle => 'അജ്ഞാത ബാർകോഡ്';

  @override
  String posUnknownBarcodeBody(String barcode) {
    return 'ബാർകോഡ് \"$barcode\" നിങ്ങളുടെ ഇൻവെന്ററിയിൽ ഇല്ല. നിങ്ങൾ എന്തു ചെയ്യാൻ ആഗ്രഹിക്കുന്നു?';
  }

  @override
  String get posAddAsNew => 'പുതിയതായി ചേർക്കുക';

  @override
  String get posLinkToExisting => 'നിലവിലുള്ള ഇനവുമായി ലിങ്ക് ചെയ്യുക';

  @override
  String posErrLoadingInventory(String error) {
    return 'ഇൻവെന്ററി ലോഡ് ചെയ്യുന്നതിൽ പിശക്: $error';
  }

  @override
  String posLinkBarcodeTitle(String barcode) {
    return 'ബാർകോഡ് \"$barcode\" ലിങ്ക് ചെയ്യുക';
  }

  @override
  String get posNoUnbarcodedItems =>
      'ബാർകോഡ് ഇല്ലാത്ത ഇനങ്ങളൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String posCategoryLabel(String category) {
    return 'വിഭാഗം: $category';
  }

  @override
  String get posCategoryGeneral => 'ജനറൽ';

  @override
  String posLinkedToItem(String barcode, String name) {
    return '$barcode $name ഉമായി ലിങ്ക് ചെയ്തു';
  }

  @override
  String get posScanReferralQr => 'റഫറൽ QR സ്കാൻ ചെയ്യുക';

  @override
  String posCampaignOutOfStock(String name) {
    return '\"$name\" ലെ എല്ലാ ഇനങ്ങളും സ്റ്റോക്കിൽ ഇല്ല';
  }

  @override
  String posCampaignItemsAdded(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഇനങ്ങൾ',
      one: 'ഇനം',
    );
    return '\"$name\" ൽ നിന്ന് $count $_temp0 ചേർത്തു';
  }

  @override
  String posAddedSkipped(int added, int skipped) {
    return '$added ചേർത്തു · $skipped ഒഴിവാക്കി (സ്റ്റോക്ക് ഇല്ല)';
  }

  @override
  String posBasketAddedAtPrice(String name, String price) {
    return 'ബണ്ടിൽ \"$name\" ₹$price ന് ചേർത്തു';
  }

  @override
  String posItemsRegularPrice(int count) {
    return '$count ഇനങ്ങൾ സാധാരണ വിലയിൽ ചേർത്തു (ബണ്ടിലിന് എല്ലാ ഇനങ്ങളും സ്റ്റോക്കിൽ വേണം)';
  }

  @override
  String posBasketItemsAdded(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഇനങ്ങൾ',
      one: 'ഇനം',
    );
    return '\"$name\" ൽ നിന്ന് $count $_temp0 ചേർത്തു';
  }

  @override
  String posItemsAddedToCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഇനങ്ങൾ',
      one: 'ഇനം',
    );
    return '$count $_temp0 കാർട്ടിൽ ചേർത്തു';
  }

  @override
  String get posSelectCustomer => 'ഉപഭോക്താവിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get posNew => 'പുതിയത്';

  @override
  String get posSearchNameOrPhone => 'പേര് അല്ലെങ്കിൽ ഫോൺ ഉപയോഗിച്ച് തിരയുക...';

  @override
  String get posNoCustomersFound => 'ഉപഭോക്താക്കളെ കണ്ടെത്തിയില്ല.';

  @override
  String get posAddNewCustomer => 'പുതിയ ഉപഭോക്താവിനെ ചേർക്കുക';

  @override
  String get posSelectFromContacts => 'കോൺടാക്റ്റുകളിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get posCustomerName => 'ഉപഭോക്തൃ പേര്';

  @override
  String get posPhoneNumber => 'ഫോൺ നമ്പർ';

  @override
  String get posSaveAndSelect => 'സംരക്ഷിച്ച് തിരഞ്ഞെടുക്കുക';

  @override
  String get posSearchProducts => 'ഉൽപ്പന്നങ്ങൾ തിരയുക…';

  @override
  String get posReferralScan => 'റഫറൽ സ്കാൻ';

  @override
  String get posOrderHistory => 'ഓർഡർ ചരിത്രം';

  @override
  String get posRefreshingProducts => 'ഉൽപ്പന്നങ്ങൾ പുതുക്കുന്നു...';

  @override
  String posRefreshFailed(String error) {
    return 'പുതുക്കൽ പരാജയപ്പെട്ടു: $error';
  }

  @override
  String posProductsRefreshed(int count) {
    return 'ഉൽപ്പന്നങ്ങൾ പുതുക്കി ($count ഇനങ്ങൾ)';
  }

  @override
  String posItemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഇനങ്ങൾ',
      one: 'ഇനം',
    );
    return 'കാർട്ടിൽ $count $_temp0';
  }

  @override
  String get posClearCartTitle => 'കാർട്ട് മായ്ക്കണോ?';

  @override
  String get posClearCartBody =>
      'എല്ലാ ഇനങ്ങളും കാർട്ടിൽ നിന്ന് നീക്കം ചെയ്യപ്പെടും.';

  @override
  String get posFrequentlyBought => 'പതിവായി ഒരുമിച്ച് വാങ്ങുന്നവ';

  @override
  String get posNoProductsFound => 'ഉൽപ്പന്നങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String posStockColon(String stock) {
    return 'സ്റ്റോക്ക്: $stock';
  }

  @override
  String get posOffline => 'POS ഓഫ്‌ലൈൻ';

  @override
  String get posCouldNotConnect => 'POS ലേക്ക് ബന്ധിപ്പിക്കാനായില്ല.';

  @override
  String get posBundlesAndDeals => 'ബണ്ടിലുകൾ & ഡീലുകൾ';

  @override
  String get posRefreshAi => 'AI പുതുക്കുക';

  @override
  String posItemsInBundle(int count) {
    return 'ബണ്ടിലിൽ $count ഇനങ്ങൾ';
  }

  @override
  String get posBundlePrice => 'ബണ്ടിൽ വില';

  @override
  String get posItemFallback => 'ഇനം';

  @override
  String posValidUntil(String date) {
    return '$date വരെ സാധുവാണ്';
  }

  @override
  String posStockUnitPrice(String stock, String unit, String price) {
    return 'സ്റ്റോക്ക്: $stock $unit  ·  ₹$price';
  }

  @override
  String get posNotInStock => 'സ്റ്റോക്കിൽ ഇല്ല';

  @override
  String get posBundlePriceLabel => 'ബണ്ടിൽ വില';

  @override
  String get posAddAvailableToCart => 'ലഭ്യമായ ഇനങ്ങൾ കാർട്ടിൽ ചേർക്കുക';

  @override
  String posVoiceCount(int remaining, int total) {
    return 'വോയ്സ് ($remaining/$total)';
  }

  @override
  String get posVoiceOrder => 'വോയ്സ് ഓർഡർ';

  @override
  String posHandwriteCount(int remaining, int total) {
    return 'കൈയെഴുത്ത് ($remaining/$total)';
  }

  @override
  String get posHandwrite => 'കൈയെഴുത്ത്';

  @override
  String get posCartEmpty => 'കാർട്ട് ശൂന്യമാണ്';

  @override
  String get posCartEmptyHint =>
      'വിൽപ്പന ആരംഭിക്കാൻ ഒരു ഉൽപ്പന്നം തിരയുകയോ ബാർകോഡ് സ്കാൻ ചെയ്യുകയോ ചെയ്യുക.';

  @override
  String get posAddCustomer => 'ഉപഭോക്താവിനെ ചേർക്കുക';

  @override
  String posItemCount(String count) {
    return '$count ഇനങ്ങൾ';
  }

  @override
  String posPlaceOrderAmount(String amount) {
    return 'ഓർഡർ ചെയ്യുക · $amount';
  }

  @override
  String get posPosInventory => 'POS / ഇൻവെന്ററി';

  @override
  String get posOnline => 'POS ഓൺലൈൻ';

  @override
  String get posTabSales => 'വിൽപ്പന';

  @override
  String get posTabStock => 'സ്റ്റോക്ക്';

  @override
  String get posTabPurchase => 'പർച്ചേസ്';

  @override
  String get posPurchaseSuppliers => 'പർച്ചേസ് & വിതരണക്കാർ';

  @override
  String get posPurchaseSuppliersDesc =>
      'പർച്ചേസ് ഓർഡറുകൾ സൃഷ്ടിക്കുക, നിങ്ങളുടെ വിതരണക്കാരെ കൈകാര്യം ചെയ്യുക, അവർക്ക് നൽകാനുള്ളത് ട്രാക്ക് ചെയ്യുക — എല്ലാം ഒരിടത്ത്.';

  @override
  String get posPaywallPurchaseDesc =>
      'പർച്ചേസ് ഓർഡറുകളും വിതരണക്കാരെയും കൈകാര്യം ചെയ്യുക. വിതരണക്കാർക്കുള്ള പേയ്മെന്റുകൾ ട്രാക്ക് ചെയ്യുക. Pro പ്ലാനിൽ ലഭ്യമാണ്.';

  @override
  String get posPrinterSetup => 'പ്രിന്റർ സജ്ജീകരണം';

  @override
  String get posReconnect => 'വീണ്ടും ബന്ധിപ്പിക്കുക';

  @override
  String get posForgetPrinter => 'ഈ പ്രിന്റർ മറക്കുക';

  @override
  String get posPairedDevices => 'ജോടിയാക്കിയ ബ്ലൂടൂത്ത് ഉപകരണങ്ങൾ';

  @override
  String get posNoPairedDevices => 'ജോടിയാക്കിയ ഉപകരണങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String get posPairDeviceHint =>
      'ആദ്യം നിങ്ങളുടെ തെർമൽ പ്രിന്റർ Android\nബ്ലൂടൂത്ത് ക്രമീകരണങ്ങളിൽ ജോടിയാക്കുക, പിന്നെ പുതുക്കുക.';

  @override
  String get posProOnly => 'Pro മാത്രം';

  @override
  String get posUpgradeToProDay =>
      'Pro ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യുക  ₹500/മാസം · വെറും ₹17/ദിവസം';

  @override
  String get posReceiptSent => 'രസീത് പ്രിന്ററിലേക്ക് അയച്ചു';

  @override
  String get posPrintFailedCheck =>
      'പ്രിന്റ് പരാജയപ്പെട്ടു — പ്രിന്റർ പരിശോധിക്കുക';

  @override
  String get posOrderPlaced => 'ഓർഡർ ചെയ്തു!';

  @override
  String posOrderNumber(String id) {
    return 'ഓർഡർ #$id';
  }

  @override
  String get posPrintReceipt => 'രസീത് പ്രിന്റ് ചെയ്യുക';

  @override
  String get posNewSale => 'പുതിയ വിൽപ്പന';

  @override
  String get posViewOrderDetails => 'ഓർഡർ വിശദാംശങ്ങൾ കാണുക';

  @override
  String get posSelectCustomerForUdhaar =>
      'ഉധാർ വിൽപ്പനയ്ക്ക് ഒരു ഉപഭോക്താവിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get posConfirmOrder => 'ഓർഡർ സ്ഥിരീകരിക്കുക';

  @override
  String get posOrderConfirmed => 'ഓർഡർ സ്ഥിരീകരിച്ചു!';

  @override
  String get posSubtotal => 'ഉപമൊത്തം';

  @override
  String posReferralDiscount(String pct, String referrer) {
    return 'റഫറൽ ഡിസ്കൗണ്ട് ($pct%)$referrer';
  }

  @override
  String get posGrandTotal => 'ആകെ തുക';

  @override
  String get posPaymentMethod => 'പേയ്മെന്റ് രീതി';

  @override
  String get posPayCash => 'പണം';

  @override
  String get posPayUdhaar => 'ഉധാർ';

  @override
  String get posUdhaarDueDate => 'അടവ് തീയതി';

  @override
  String get posUdhaarDueDateHint => 'ഉപഭോക്താവ് എപ്പോൾ തിരിച്ചടയ്ക്കും?';

  @override
  String posBundlePercentOff(int pct) {
    return '$pct% കിഴിവ്';
  }

  @override
  String posBundleYouSave(String amount) {
    return '$amount ലാഭം';
  }

  @override
  String get posBundleRegularPrice =>
      'സാധാരണ വിലയ്ക്ക് ചേർത്തു (ബണ്ടിലിന് എല്ലാ സാധനങ്ങളും സ്റ്റോക്കിൽ വേണം)';

  @override
  String get posPayUpi => 'UPI';

  @override
  String get posComingSoon => 'ഉടൻ വരുന്നു';

  @override
  String get posSelectCustomerRequired =>
      'ഉപഭോക്താവിനെ തിരഞ്ഞെടുക്കുക (ഉധാറിന് ആവശ്യം)';

  @override
  String get posSelectCustomerForUdhaarTitle =>
      'ഉധാറിന് ഉപഭോക്താവിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get posSearchNameOrPhoneHint =>
      'പേര് അല്ലെങ്കിൽ ഫോൺ ഉപയോഗിച്ച് തിരയുക…';

  @override
  String get posPrintAutomatically => 'രസീത് സ്വയമേവ പ്രിന്റ് ചെയ്യുക';

  @override
  String get posWillPrintAfter => 'ഓർഡർ ചെയ്തതിന് ശേഷം പ്രിന്റ് ചെയ്യും';

  @override
  String posPrinterStatus(String status) {
    return 'പ്രിന്റർ: $status';
  }

  @override
  String get posAutoPrintDisabled =>
      'പ്രവർത്തനരഹിതം — ഓർഡർ വിശദാംശങ്ങളിൽ നിന്ന് നേരിട്ട് പ്രിന്റ് ചെയ്യുക';

  @override
  String get posHowMuchUdhaar => 'എത്ര ഉധാറിലേക്ക് പോകുന്നു?';

  @override
  String get posCashNow => 'ഇപ്പോൾ പണം';

  @override
  String get posOnUdhaar => 'ഉധാറിൽ';

  @override
  String get posPrintFailedCheckConnection =>
      'പ്രിന്റ് പരാജയപ്പെട്ടു — പ്രിന്റർ കണക്ഷൻ പരിശോധിക്കുക';

  @override
  String get posTodaysOrders => 'ഇന്നത്തെ ഓർഡറുകൾ';

  @override
  String posTransactionsSoFar(int count) {
    return 'ഇതുവരെ $count ഇടപാടുകൾ';
  }

  @override
  String get posViewAll => 'എല്ലാം കാണുക';

  @override
  String get posNoOrdersToday => 'ഇന്ന് ഇതുവരെ ഓർഡറുകളില്ല';

  @override
  String get posSalesAppearHere => 'വിൽപ്പന ഇടപാടുകൾ ഇവിടെ ദൃശ്യമാകും';

  @override
  String posOrderMeta(String time, String payment, String status) {
    return '$time · $payment · $status';
  }

  @override
  String get posPrint => 'പ്രിന്റ്';

  @override
  String get posScanBarcode => 'ബാർകോഡ് സ്കാൻ ചെയ്യുക';

  @override
  String get posAlignBarcode => 'ഫ്രെയിമിനുള്ളിൽ ബാർകോഡ് ക്രമീകരിക്കുക';

  @override
  String get posLookingUp => 'തിരയുന്നു…';

  @override
  String posAlreadyInList(String name) {
    return '$name ഇതിനകം പട്ടികയിലുണ്ട്';
  }

  @override
  String posItemQty(String name, int qty) {
    return '$name ×$qty';
  }

  @override
  String posItemAdded(String name) {
    return '$name ചേർത്തു';
  }

  @override
  String get posNotFoundTapAdd =>
      'കണ്ടെത്തിയില്ല — നേരിട്ട് ചേർക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String posItemsScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഇനങ്ങൾ',
      one: 'ഇനം',
    );
    return '$count $_temp0 സ്കാൻ ചെയ്തു';
  }

  @override
  String get posScanItems => 'ഇനങ്ങൾ സ്കാൻ ചെയ്യുക';

  @override
  String get posClearAll => 'എല്ലാം മായ്ക്കുക';

  @override
  String posLookingUpItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഇനങ്ങൾ',
      one: 'ഇനം',
    );
    return '$count $_temp0 തിരയുന്നു…';
  }

  @override
  String posAddItemsToCart(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഇനങ്ങൾ',
      one: 'ഇനം',
    );
    return '$count $_temp0 കാർട്ടിൽ ചേർക്കുക  ·  ₹$total';
  }

  @override
  String get posPointCamera => 'ക്യാമറ ബാർകോഡിലേക്ക് ചൂണ്ടുക';

  @override
  String get posItemsAppearHere =>
      'നിങ്ങൾ സ്കാൻ ചെയ്യുമ്പോൾ ഇനങ്ങൾ ഇവിടെ ദൃശ്യമാകും';

  @override
  String get posTransactionHistory => 'ഇടപാട് ചരിത്രം';

  @override
  String get posFilters => 'ഫിൽട്ടറുകൾ:';

  @override
  String get posClearAllFilters => 'എല്ലാം മായ്ക്കുക';

  @override
  String get posNoTransactions => 'ഇടപാടുകളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String get posTryAdjustFilters =>
      'നിങ്ങളുടെ ഫിൽട്ടറുകൾ ക്രമീകരിക്കാൻ ശ്രമിക്കുക';

  @override
  String get posResetFilters => 'ഫിൽട്ടറുകൾ പുനഃസജ്ജമാക്കുക';

  @override
  String get posFilterTransactions => 'ഇടപാടുകൾ ഫിൽട്ടർ ചെയ്യുക';

  @override
  String get posPaymentStatus => 'പേയ്മെന്റ് സ്റ്റാറ്റസ്';

  @override
  String get posFilterAll => 'എല്ലാം';

  @override
  String get posStatusCompleted => 'പൂർത്തിയായി';

  @override
  String get posStatusPending => 'തീർപ്പാക്കാത്തത്';

  @override
  String get posDateRange => 'തീയതി ശ്രേണി';

  @override
  String get posSelectDateRange => 'തീയതി ശ്രേണി തിരഞ്ഞെടുക്കുക';

  @override
  String get posApplyFilters => 'ഫിൽട്ടറുകൾ പ്രയോഗിക്കുക';

  @override
  String get posOrderDetails => 'ഓർഡർ വിശദാംശങ്ങൾ';

  @override
  String get posPaymentLabel => 'പേയ്മെന്റ്';

  @override
  String get posTotalAmount => 'ആകെ തുക';

  @override
  String posCustomerNumber(String id) {
    return 'ഉപഭോക്താവ് #$id';
  }

  @override
  String get posItemsSummary => 'ഇനങ്ങളുടെ സംഗ്രഹം';

  @override
  String posProductNumber(String id) {
    return 'ഉൽപ്പന്നം #$id';
  }

  @override
  String get posUnitFallback => 'യൂണിറ്റ്';

  @override
  String posPrintReceiptStatus(String status) {
    return 'രസീത് പ്രിന്റ് ചെയ്യുക ($status)';
  }

  @override
  String get posReturnExchange => 'റിട്ടേൺ / എക്സ്ചേഞ്ച്';

  @override
  String get posSplitPayment => 'സ്പ്ലിറ്റ് പേയ്മെന്റ്';

  @override
  String get posCashPaidNow => 'ഇപ്പോൾ നൽകിയ പണം';

  @override
  String get posOnUdhaarCredit => 'ഉധാറിൽ (ക്രെഡിറ്റ്)';

  @override
  String get posUdhaarRecordedNote =>
      'ഉധാർ ഭാഗം ക്രെഡിറ്റായി രേഖപ്പെടുത്തി — ബാലൻസിന് ഉധാർ ടാബ് പരിശോധിക്കുക';

  @override
  String get posUdhaarSale => 'ഉധാർ വിൽപ്പന';

  @override
  String get posTotalPaid => 'ആകെ നൽകിയത്';

  @override
  String get posRecordedAsCredit =>
      'ക്രെഡിറ്റായി രേഖപ്പെടുത്തി — ഉധാർ ടാബ് പരിശോധിക്കുക';

  @override
  String get posBoughtAsBasket => 'ബാസ്ക്കറ്റായി വാങ്ങി';

  @override
  String get posBasketValue => 'ബാസ്ക്കറ്റ് മൂല്യം';

  @override
  String get posCustomerSaved => 'ഉപഭോക്താവ് ലാഭിച്ചു';

  @override
  String get invSearchItemsOrCategories =>
      'ഇനങ്ങൾ അല്ലെങ്കിൽ വിഭാഗങ്ങൾ തിരയുക...';

  @override
  String get invShowLess => 'കുറച്ച് കാണിക്കുക';

  @override
  String invViewMore(int count) {
    return '+$count കൂടുതൽ';
  }

  @override
  String get invAll => 'എല്ലാം';

  @override
  String get invUncategorised => 'വർഗ്ഗീകരിക്കാത്തവ';

  @override
  String get invNoMatchesFound => 'പൊരുത്തങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String invNearExpiryBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ഇനങ്ങൾ ഉടൻ കാലഹരണപ്പെടുന്നു — വില കുറയ്ക്കാനോ മായ്ക്കാനോ ടാപ്പ് ചെയ്യുക',
      one:
          '1 ഇനം ഉടൻ കാലഹരണപ്പെടുന്നു — വില കുറയ്ക്കാനോ മായ്ക്കാനോ ടാപ്പ് ചെയ്യുക',
    );
    return '$_temp0';
  }

  @override
  String invMissingPriceBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ഉൽപ്പന്നങ്ങൾക്ക് ₹0 വില — വില സജ്ജമാക്കാൻ ടാപ്പ് ചെയ്യുക',
      one: '1 ഉൽപ്പന്നത്തിന് ₹0 വില — വില സജ്ജമാക്കാൻ ടാപ്പ് ചെയ്യുക',
    );
    return '$_temp0';
  }

  @override
  String get invFlagFast => 'വേഗം';

  @override
  String get invFlagReorder => 'വീണ്ടും ഓർഡർ';

  @override
  String get invFlagLowStock => 'കുറഞ്ഞ സ്റ്റോക്ക്';

  @override
  String get invFlagDead => 'നിർജ്ജീവം';

  @override
  String get invFlagProfit => 'ലാഭം';

  @override
  String invStockLabel(String stock) {
    return 'സ്റ്റോക്ക്: $stock';
  }

  @override
  String get invUnitFallback => 'യൂണിറ്റ്';

  @override
  String get invSyncFailedTapRetry =>
      'സിങ്ക് പരാജയപ്പെട്ടു — വീണ്ടും ശ്രമിക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get invSyncingToServer => 'സെർവറിലേക്ക് സിങ്ക് ചെയ്യുന്നു...';

  @override
  String get invNoInventoryYet => 'ഇതുവരെ ഇൻവെന്ററി ഇല്ല';

  @override
  String get invNoInventoryHint =>
      'നിങ്ങളുടെ ആദ്യ ഉൽപ്പന്നം ചേർക്കാൻ + ടാപ്പ് ചെയ്യുക.\nആദ്യം ഒരു വിഭാഗം സൃഷ്ടിക്കുക, പിന്നെ ഇനങ്ങൾ ചേർക്കുക.';

  @override
  String get invAddFirstProduct => 'ആദ്യ ഉൽപ്പന്നം ചേർക്കുക';

  @override
  String get invCouldNotLoadInventory => 'ഇൻവെന്ററി ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get invRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get invSelectCategoryError => 'ദയവായി ഒരു വിഭാഗം തിരഞ്ഞെടുക്കുക';

  @override
  String invVariantPriceRequired(int number) {
    return 'വേരിയന്റ് $number: വിൽപ്പന വില ആവശ്യമാണ്';
  }

  @override
  String get invProductSavedSyncing =>
      'ഉൽപ്പന്നം സംരക്ഷിച്ചു — പശ്ചാത്തലത്തിൽ സിങ്ക് ചെയ്യുന്നു';

  @override
  String invVariantsSavedSyncing(int count) {
    return '$count വേരിയന്റുകൾ സംരക്ഷിച്ചു — പശ്ചാത്തലത്തിൽ സിങ്ക് ചെയ്യുന്നു';
  }

  @override
  String get invAddProduct => 'ഉൽപ്പന്നം ചേർക്കുക';

  @override
  String get invAddFromCatalog => 'കാറ്റലോഗിൽ നിന്ന് ചേർക്കുക';

  @override
  String get invNewProduct => 'പുതിയ ഉൽപ്പന്നം';

  @override
  String get invSave => 'സംരക്ഷിക്കുക';

  @override
  String get invSearchProductName => 'ഉൽപ്പന്ന പേര് തിരയുക...';

  @override
  String get invLoadMoreResults => 'കൂടുതൽ ഫലങ്ങൾ ലോഡ് ചെയ്യുക';

  @override
  String get invNoMoreSearchResults => 'കൂടുതൽ തിരയൽ ഫലങ്ങളില്ല';

  @override
  String get invSearchProductCatalog => 'ഉൽപ്പന്ന കാറ്റലോഗ് തിരയുക';

  @override
  String get invSearchCatalogHint =>
      'ഒരു പേര് ടൈപ്പ് ചെയ്യുക അല്ലെങ്കിൽ ബാർകോഡ് സ്കാൻ ചെയ്യുക.\nകണ്ടെത്തിയില്ലെങ്കിൽ, നേരിട്ട് ചേർക്കുക.';

  @override
  String get invAddManually => 'നേരിട്ട് ചേർക്കുക';

  @override
  String get invAddManuallySub =>
      'ഉൽപ്പന്നം കാറ്റലോഗിൽ ഇല്ലേ? വിശദാംശങ്ങൾ സ്വയം നൽകുക.';

  @override
  String get invProductAdded => 'ഉൽപ്പന്നം ചേർത്തു!';

  @override
  String invVariantsAdded(int count) {
    return '$count വേരിയന്റുകൾ ചേർത്തു!';
  }

  @override
  String get invLooseItem => 'ലൂസ് ഇനം';

  @override
  String get invLooseItemSub => 'ഭാരം അനുസരിച്ച് വിൽക്കുന്നു (ഉദാ. മൈദ, പയർ)';

  @override
  String get invBasicDetails => 'അടിസ്ഥാന വിശദാംശങ്ങൾ';

  @override
  String get invProductNameLabel => 'ഉൽപ്പന്ന പേര് *';

  @override
  String get invRequired => 'ആവശ്യമാണ്';

  @override
  String get invBrandOptional => 'ബ്രാൻഡ് (ഓപ്ഷണൽ)';

  @override
  String get invSelectCategoryStar => 'വിഭാഗം തിരഞ്ഞെടുക്കുക *';

  @override
  String get invOther => 'മറ്റുള്ളവ';

  @override
  String get invPerishableItem => 'നശിക്കുന്ന ഇനം';

  @override
  String get invPerishableItemSub => 'കാലഹരണ തീയതി ഉണ്ട്';

  @override
  String get invSizePriceStock => 'വലുപ്പം, വില & സ്റ്റോക്ക്';

  @override
  String invVariantsCount(int count) {
    return 'വേരിയന്റുകൾ ($count)';
  }

  @override
  String get invAddVariant => 'വേരിയന്റ് ചേർക്കുക';

  @override
  String get invManageVariants => 'വേരിയന്റുകൾ കൈകാര്യം ചെയ്യുക';

  @override
  String get invVariants => 'വേരിയന്റുകൾ';

  @override
  String get invEditVariant => 'വേരിയന്റ് എഡിറ്റ് ചെയ്യുക';

  @override
  String get invSaveVariant => 'വേരിയന്റ് സേവ് ചെയ്യുക';

  @override
  String get invNoVariantsYet =>
      'വേരിയന്റുകൾ ഇല്ല. സൈസ്, നിറം അല്ലെങ്കിൽ മോഡൽ ചേർക്കുക.';

  @override
  String get invStockPerVariantNote =>
      'സ്റ്റോക്ക് ഓരോ വേരിയന്റിനും പ്രത്യേകം ട്രാക്ക് ചെയ്യുന്നു. താഴെയുള്ള \'വേരിയന്റുകൾ കൈകാര്യം ചെയ്യുക\' ഉപയോഗിക്കുക.';

  @override
  String get invDefaultVariant => 'ഡിഫോൾട്ട്';

  @override
  String invVariantAxisRequired(String label) {
    return 'ദയവായി $label തിരഞ്ഞെടുക്കുക';
  }

  @override
  String get invSaveProduct => 'ഉൽപ്പന്നം സംരക്ഷിക്കുക';

  @override
  String invSaveVariants(int count) {
    return '$count വേരിയന്റുകൾ സംരക്ഷിക്കുക';
  }

  @override
  String get invProduct => 'ഉൽപ്പന്നം';

  @override
  String invVariantNumber(int number) {
    return 'വേരിയന്റ് $number';
  }

  @override
  String get invUnit => 'യൂണിറ്റ്';

  @override
  String get invBaseUnit => 'അടിസ്ഥാന യൂണിറ്റ്';

  @override
  String get invPackSize => 'പായ്ക്ക് വലുപ്പം';

  @override
  String get invPackSizeHint => 'ഉദാ. 250';

  @override
  String get invBarcode => 'ബാർകോഡ്';

  @override
  String get invFromCatalog => 'കാറ്റലോഗിൽ നിന്ന്';

  @override
  String get invOptional => 'ഓപ്ഷണൽ';

  @override
  String invPricePerUnit(String unit) {
    return 'വില / $unit *';
  }

  @override
  String get invSellingPriceStar => 'വിൽപ്പന വില *';

  @override
  String get invInvalid => 'അസാധു';

  @override
  String get invMrp => 'MRP';

  @override
  String get invCostPrice => 'ചെലവ് വില (നിങ്ങൾ നൽകുന്നത്)';

  @override
  String get invCostPriceHint => 'ഓപ്ഷണൽ — ലാഭ കൃത്യത മെച്ചപ്പെടുത്തുന്നു';

  @override
  String invOpeningStockUnit(String unit) {
    return 'ഓപ്പണിംഗ് സ്റ്റോക്ക് ($unit) *';
  }

  @override
  String get invOpeningStockUnits => 'ഓപ്പണിംഗ് സ്റ്റോക്ക് (യൂണിറ്റുകൾ) *';

  @override
  String get invExpiryDate => 'കാലഹരണ തീയതി';

  @override
  String get invExpiryDateHint => 'YYYY-MM-DD';

  @override
  String get invRequiredForPerishables => 'നശിക്കുന്ന ഇനങ്ങൾക്ക് ആവശ്യമാണ്';

  @override
  String get invLinkedFromCatalog => 'കാറ്റലോഗിൽ നിന്ന് ലിങ്ക് ചെയ്തു';

  @override
  String get invSelectCategory => 'വിഭാഗം തിരഞ്ഞെടുക്കുക';

  @override
  String get invSearchCategories => 'വിഭാഗങ്ങൾ തിരയുക...';

  @override
  String get invNoCategoriesFound => 'വിഭാഗങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String get invEditProduct => 'ഉൽപ്പന്നം എഡിറ്റ് ചെയ്യുക';

  @override
  String invProductUpdated(String name) {
    return '$name അപ്ഡേറ്റ് ചെയ്തു!';
  }

  @override
  String get invProductUpdatedSuccess =>
      'ഉൽപ്പന്നം വിജയകരമായി അപ്ഡേറ്റ് ചെയ്തു!';

  @override
  String get invSellingUnit => 'വിൽപ്പന യൂണിറ്റ്';

  @override
  String get invPricing => 'വിലനിർണ്ണയം';

  @override
  String invPricePerSelected(String unit) {
    return 'ഓരോ $unit വില *';
  }

  @override
  String get invMrpOptional => 'MRP (ഓപ്ഷണൽ)';

  @override
  String get invStock => 'സ്റ്റോക്ക്';

  @override
  String get invGstRate => 'GST %';

  @override
  String get invHsnCode => 'HSN കോഡ്';

  @override
  String get invWarranty => 'വാറന്റി';

  @override
  String get invWarrantyCovered => 'വാറന്റിയിൽ ഉൾപ്പെടുന്നു';

  @override
  String get invWarrantyCoveredSub =>
      'എത്ര കാലം എന്ന് സജ്ജമാക്കുക — വാങ്ങിയ തീയതി മുതൽ കണക്കാക്കുന്നു';

  @override
  String get invWarrantyPeriod => 'വാറന്റി കാലയളവ്';

  @override
  String invStockInUnit(String unit) {
    return 'സ്റ്റോക്ക് ($unit ൽ) *';
  }

  @override
  String get invStockQuantityStar => 'സ്റ്റോക്ക് അളവ് *';

  @override
  String get invPerishableBatchNote =>
      'നശിക്കുന്ന ബാച്ച് വിശദാംശങ്ങൾക്ക്, ഇൻവെന്ററിയിൽ നിന്ന് \"ബാച്ച് സ്വീകരിക്കുക\" ഉപയോഗിക്കുക.';

  @override
  String get invSaveChanges => 'മാറ്റങ്ങൾ സംരക്ഷിക്കുക';

  @override
  String get invCategoryNameRequired => 'വിഭാഗ പേര് ആവശ്യമാണ്';

  @override
  String get invCreateCategoryFailed =>
      'വിഭാഗം സൃഷ്ടിക്കാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get invNewCategory => 'പുതിയ വിഭാഗം';

  @override
  String get invNewCategorySub =>
      'നിങ്ങളുടെ ഉൽപ്പന്നങ്ങൾ ക്രമീകരിക്കാൻ ഒരു വിഭാഗം ചേർക്കുക.';

  @override
  String get invCategoryCreated => 'വിഭാഗം സൃഷ്ടിച്ചു!';

  @override
  String get invCategoryNameLabel => 'വിഭാഗ പേര്';

  @override
  String get invCategoryNameHint => 'ഉദാ. അവശ്യവസ്തുക്കൾ, ഡയറി, സ്നാക്സ്…';

  @override
  String get invCreateCategory => 'വിഭാഗം സൃഷ്ടിക്കുക';

  @override
  String get invCardOutOfStock => 'സ്റ്റോക്ക് തീർന്നു';

  @override
  String invCardStockLow(String qty) {
    return '$qty — കുറവ്';
  }

  @override
  String invCardStockInStock(String qty) {
    return '$qty സ്റ്റോക്കിലുണ്ട്';
  }

  @override
  String get invCardFast => 'വേഗം';

  @override
  String get invCardSlow => 'സ്ലോ';

  @override
  String get invCardExpired => 'കാലഹരണപ്പെട്ടു';

  @override
  String invCardDays(String days) {
    return '$daysദി';
  }

  @override
  String get invCardBarcode => 'ബാർകോഡ്';

  @override
  String get invCardSoldToday => 'ഇന്ന് വിറ്റു';

  @override
  String get invCardReorder => 'വീണ്ടും ഓർഡർ';

  @override
  String invCardReorderUnits(String qty) {
    return '$qty യൂണിറ്റുകൾ';
  }

  @override
  String get invCard7dRisk => '7ദി റിസ്ക്';

  @override
  String get invExpiringSoon => 'ഉടൻ കാലഹരണപ്പെടുന്നു';

  @override
  String get invNext => 'അടുത്തത്';

  @override
  String invDaysWindow(int days) {
    return '$days ദിവസം';
  }

  @override
  String get invExpired => 'കാലഹരണപ്പെട്ടു';

  @override
  String get invExpiresToday => 'ഇന്ന് കാലഹരണപ്പെടുന്നു';

  @override
  String get invExpiresTomorrow => 'നാളെ കാലഹരണപ്പെടുന്നു';

  @override
  String invExpiresInDays(int days) {
    return '$days ദിവസത്തിനുള്ളിൽ കാലഹരണപ്പെടുന്നു';
  }

  @override
  String invQtyInStock(String qty, String unit) {
    return '$qty $unit സ്റ്റോക്കിലുണ്ട്';
  }

  @override
  String get invAtRisk => 'അപകടത്തിൽ';

  @override
  String get invMarkedDown => 'വില കുറച്ചു';

  @override
  String get invPrice => 'വില';

  @override
  String get invChangeMarkdown => 'മാർക്ക്ഡൗൺ മാറ്റുക';

  @override
  String get invMarkDown => 'വില കുറയ്ക്കുക';

  @override
  String get invRecordWaste => 'പാഴായത് രേഖപ്പെടുത്തുക';

  @override
  String invMarkDownTitle(String name) {
    return '$name വില കുറയ്ക്കുക';
  }

  @override
  String get invClearanceDiscount =>
      'കാലഹരണത്തിന് മുമ്പ് വിൽക്കാൻ ക്ലിയറൻസ് ഡിസ്കൗണ്ട്';

  @override
  String invPctSuggested(String pct) {
    return '$pct% (നിർദ്ദേശിച്ചത്)';
  }

  @override
  String invPct(String pct) {
    return '$pct%';
  }

  @override
  String get invCustom => 'ഇഷ്ടാനുസൃതം';

  @override
  String get invApplyMarkdown => 'മാർക്ക്ഡൗൺ പ്രയോഗിക്കുക';

  @override
  String get invMarkdownApplied => 'മാർക്ക്ഡൗൺ പ്രയോഗിച്ചു';

  @override
  String get invMarkdownFailed => 'മാർക്ക്ഡൗൺ പ്രയോഗിക്കാനായില്ല';

  @override
  String invWriteOff(String name) {
    return '$name റൈറ്റ് ഓഫ് ചെയ്യുക';
  }

  @override
  String get invWriteOffSub =>
      'കേടായ യൂണിറ്റുകൾ സ്റ്റോക്കിൽ നിന്ന് നീക്കം ചെയ്ത് നഷ്ടം രേഖപ്പെടുത്തുന്നു.';

  @override
  String invOfQtyInStock(int qty) {
    return 'സ്റ്റോക്കിലുള്ള $qty ൽ';
  }

  @override
  String invUnitsWrittenOff(int units) {
    return '$units യൂണിറ്റുകൾ റൈറ്റ് ഓഫ് ചെയ്തു';
  }

  @override
  String get invWasteFailed => 'പാഴായത് രേഖപ്പെടുത്താനായില്ല';

  @override
  String get invNothingExpiring => 'ഉടൻ ഒന്നും കാലഹരണപ്പെടുന്നില്ല';

  @override
  String get invNothingExpiringSub =>
      'കാലഹരണത്തിന് അടുത്ത നശിക്കുന്ന ബാച്ചുകൾ ഇവിടെ ദൃശ്യമാകും.';

  @override
  String get invCouldNotLoadExpiry => 'കാലഹരണ ഡാറ്റ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get invMissingPrices => 'നഷ്ടമായ വിലകൾ';

  @override
  String get invCouldNotLoadPrices => 'വിലകൾ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String invStockCurrentlyZero(String qty, String unit) {
    return '$qty $unit സ്റ്റോക്കിലുണ്ട് · നിലവിൽ ₹0';
  }

  @override
  String invSuggestedPrice(String price, String source) {
    return 'നിർദ്ദേശിച്ചത് ₹$price ($source)';
  }

  @override
  String get invSellingPrice => 'വിൽപ്പന വില';

  @override
  String get invSet => 'സജ്ജമാക്കുക';

  @override
  String get invEnterValidPrice => 'സാധുവായ വില നൽകുക';

  @override
  String invProductPriced(String name, String price) {
    return '$name വില ₹$price';
  }

  @override
  String get invCouldNotSetPrice => 'വില സജ്ജമാക്കാനായില്ല';

  @override
  String get invEveryProductPriced => 'എല്ലാ ഉൽപ്പന്നത്തിനും വില ഉണ്ട്';

  @override
  String get invEveryProductPricedSub =>
      'ഒന്നും ₹0 ന് വിൽക്കുന്നില്ല. കൊള്ളാം!';

  @override
  String get finFinance => 'ഫിനാൻസ്';

  @override
  String get finErrorLoadingStats =>
      'സ്ഥിതിവിവരക്കണക്ക് ലോഡ് ചെയ്യുന്നതിൽ പിശക്';

  @override
  String get finTabCashflow => 'ക്യാഷ്ഫ്ലോ';

  @override
  String get finTabCustomerUdhaar => 'ഉപഭോക്തൃ\nഉധാർ';

  @override
  String get finTabSupplierUdhaar => 'വിതരണക്കാരൻ ഉധാർ';

  @override
  String get finMonthlySales => 'പ്രതിമാസ വിൽപ്പന';

  @override
  String get finMonthlySkus => 'പ്രതിമാസ SKU-കൾ';

  @override
  String get finAvailableInFuture => 'ഭാവി അപ്ഡേറ്റുകളിൽ ലഭ്യമാകും';

  @override
  String get finFailedLoadUdhaar => 'ഉധാർ ഡാറ്റ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get finCheckConnection =>
      'ദയവായി നിങ്ങളുടെ കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get finRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get finCustomerDues => 'ഉപഭോക്തൃ കുടിശ്ശിക';

  @override
  String get finNewUdhaar => 'പുതിയ ഉധാർ';

  @override
  String get finAddNewUdhaar => 'പുതിയ ഉധാർ ചേർക്കുക';

  @override
  String get finContacts => 'കോൺടാക്റ്റുകൾ';

  @override
  String get finSelectExistingCustomer =>
      'നിലവിലുള്ള ഉപഭോക്താവിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get finOrEnterManually => 'അല്ലെങ്കിൽ നേരിട്ട് നൽകുക';

  @override
  String get finUdhaarRecorded => 'ഉധാർ രേഖപ്പെടുത്തി!';

  @override
  String get finCustomerName => 'ഉപഭോക്തൃ പേര്';

  @override
  String get finPhoneNumber => 'ഫോൺ നമ്പർ';

  @override
  String get finAmount => 'തുക';

  @override
  String get finSaveUdhaar => 'ഉധാർ സംരക്ഷിക്കുക';

  @override
  String get finEnterValidNamePhoneAmount => 'സാധുവായ പേര്, ഫോൺ, തുക നൽകുക';

  @override
  String get finSelectCustomer => 'ഉപഭോക്താവിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get finSearchByNameOrPhone =>
      'പേര് അല്ലെങ്കിൽ ഫോൺ ഉപയോഗിച്ച് തിരയുക...';

  @override
  String get finNoCustomersFound => 'ഉപഭോക്താക്കളെ കണ്ടെത്തിയില്ല';

  @override
  String get finTotalPending => 'ആകെ തീർപ്പാക്കാത്തത്';

  @override
  String get finRecovered => 'വീണ്ടെടുത്തു';

  @override
  String get finCustomers => 'ഉപഭോക്താക്കൾ';

  @override
  String finHighRiskDues(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'കൾ',
      one: '',
    );
    return '$count ഉയർന്ന-റിസ്ക് കുടിശ്ശിക$_temp0 — ഇവ ആദ്യം പിന്തുടരുക';
  }

  @override
  String get finSmartRemindersSubtitle =>
      'സ്മാർട്ട് റിമൈൻഡറുകൾ — വീണ്ടെടുപ്പ്-റാങ്ക് ചെയ്ത കുടിശ്ശിക';

  @override
  String finTakenDaysAgo(String date, int days) {
    return 'എടുത്തത്: $date ($days ദിവസം മുമ്പ്)';
  }

  @override
  String get finWhatsappReminderSent => 'WhatsApp റിമൈൻഡർ അയച്ചു!';

  @override
  String finFailedSendReminder(String error) {
    return 'റിമൈൻഡർ അയയ്ക്കാനായില്ല: $error';
  }

  @override
  String get finSendWhatsappReminder => 'WhatsApp റിമൈൻഡർ അയയ്ക്കുക';

  @override
  String get finRemind => 'ഓർമ്മിപ്പിക്കുക';

  @override
  String get finRemindedToday => 'ഇന്ന് ഓർമ്മിപ്പിച്ചു';

  @override
  String get finRecover => 'വീണ്ടെടുക്കുക';

  @override
  String get finHistory => 'ചരിത്രം';

  @override
  String get finSettled => 'തീർപ്പാക്കി';

  @override
  String get finRecordPayment => 'പേയ്മെന്റ് രേഖപ്പെടുത്തുക';

  @override
  String get finPaymentOldestFirstNote =>
      'ഏറ്റവും പഴയ കുടിശ്ശികയിൽ ആദ്യം ചേർക്കുന്നു';

  @override
  String get finTaken => 'എടുത്തത്';

  @override
  String get finPaid => 'നൽകിയത്';

  @override
  String get finBalanceShort => 'ബാക്കി';

  @override
  String finOpenDuesSummary(int count, int days) {
    return '$count കുടിശ്ശിക · ഏറ്റവും പഴയത് $days ദിവസം';
  }

  @override
  String finSettledSectionTitle(int count) {
    return 'തീർപ്പാക്കി ($count)';
  }

  @override
  String finRecoverUdhaarFrom(String name) {
    return '$name ൽ നിന്ന് ഉധാർ വീണ്ടെടുക്കുക';
  }

  @override
  String get finRecoveryRecorded => 'വീണ്ടെടുപ്പ് രേഖപ്പെടുത്തി!';

  @override
  String finBalanceLabel(String value) {
    return 'ബാലൻസ്: ₹$value';
  }

  @override
  String get finConfirmRecovery => 'വീണ്ടെടുപ്പ് സ്ഥിരീകരിക്കുക';

  @override
  String get finEnterValidAmount => 'ദയവായി സാധുവായ തുക നൽകുക';

  @override
  String finAmountExceedsBalance(String value) {
    return 'തുക ബാലൻസ് ₹$value കവിയാൻ പാടില്ല';
  }

  @override
  String get finNoPendingUdhaars => 'തീർപ്പാക്കാത്ത ഉധാറുകൾ ഇല്ല';

  @override
  String get finRecoveryHistory => 'വീണ്ടെടുപ്പ് ചരിത്രം';

  @override
  String get finNoRecoveriesYet =>
      'ഇതുവരെ വീണ്ടെടുപ്പുകൾ രേഖപ്പെടുത്തിയിട്ടില്ല.';

  @override
  String finRecoveryNumber(int number) {
    return 'വീണ്ടെടുപ്പ് #$number';
  }

  @override
  String finErrorWithMessage(String message) {
    return 'പിശക്: $message';
  }

  @override
  String get finOverdue => 'കാലാവധി കഴിഞ്ഞത്';

  @override
  String get finDueToday => 'ഇന്ന് അടയ്ക്കേണ്ടത്';

  @override
  String get finNext7Days => 'അടുത്ത 7 ദിവസം';

  @override
  String get finNoPendingPayments7Days =>
      'അടുത്ത 7 ദിവസത്തിൽ തീർപ്പാക്കാത്ത പേയ്മെന്റുകൾ ഇല്ല';

  @override
  String get finPaidLast7Days => 'കഴിഞ്ഞ 7 ദിവസത്തിൽ അടച്ചത്';

  @override
  String get finNoPaymentsRecorded7Days =>
      'കഴിഞ്ഞ 7 ദിവസത്തിൽ പേയ്മെന്റുകൾ രേഖപ്പെടുത്തിയിട്ടില്ല';

  @override
  String get finSuppliers => 'വിതരണക്കാർ';

  @override
  String get finAddEditSuppliersHint =>
      'പർച്ചേസ് ടാബിൽ വിതരണക്കാരെ ചേർക്കുകയോ എഡിറ്റ് ചെയ്യുകയോ ചെയ്യുക';

  @override
  String get finNoSuppliersYet => 'ഇതുവരെ വിതരണക്കാർ ഇല്ല.';

  @override
  String get finTotalOutstanding => 'ആകെ കുടിശ്ശിക';

  @override
  String get finToday => 'ഇന്ന്';

  @override
  String get finPaid7d => 'അടച്ചത് (7ദി)';

  @override
  String get finStockPurchase => 'സ്റ്റോക്ക് പർച്ചേസ്';

  @override
  String finOverdueSince(String date) {
    return '$date മുതൽ കാലാവധി കഴിഞ്ഞു';
  }

  @override
  String finDueOn(String day) {
    return '$day അടയ്ക്കണം';
  }

  @override
  String get finDueTodayLabel => 'ഇന്ന് അടയ്ക്കേണ്ടത്';

  @override
  String get finToPay => 'അടയ്ക്കാൻ';

  @override
  String get finDetails => 'വിശദാംശങ്ങൾ';

  @override
  String get finMarkPaid => 'അടച്ചതായി അടയാളപ്പെടുത്തുക';

  @override
  String finPurchaseOn(String date) {
    return '$date ന് പർച്ചേസ്';
  }

  @override
  String get finNoItemsFound => 'ഇനങ്ങളൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get finTotalBill => 'ആകെ ബിൽ';

  @override
  String get finTomorrow => 'നാളെ';

  @override
  String get finWeekdayMon => 'തിങ്ക';

  @override
  String get finWeekdayTue => 'ചൊവ്വ';

  @override
  String get finWeekdayWed => 'ബുധൻ';

  @override
  String get finWeekdayThu => 'വ്യാഴം';

  @override
  String get finWeekdayFri => 'വെള്ളി';

  @override
  String get finWeekdaySat => 'ശനി';

  @override
  String get finWeekdaySun => 'ഞായർ';

  @override
  String get finFailedLoadCashflow => 'ക്യാഷ്ഫ്ലോ ഡാറ്റ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get finIncome => 'വരുമാനം';

  @override
  String get finTodaysSales => 'ഇന്നത്തെ വിൽപ്പന';

  @override
  String get finCreditExposureUdhaar => 'ക്രെഡിറ്റ് എക്സ്പോഷർ (ഉധാർ)';

  @override
  String get finOutstanding => 'കുടിശ്ശിക';

  @override
  String get finCustomersWithPendingDues => 'കുടിശ്ശികയുള്ള ഉപഭോക്താക്കൾ';

  @override
  String finCustomersCount(int count) {
    return '$count ഉപഭോക്താക്കൾ';
  }

  @override
  String get finCreditVsSalesRatio => 'ക്രെഡിറ്റ് vs വിൽപ്പന അനുപാതം';

  @override
  String finPercentOnCredit(String value) {
    return '$value% ക്രെഡിറ്റിൽ';
  }

  @override
  String finOfMonthly(String value) {
    return 'പ്രതിമാസ $value ൽ';
  }

  @override
  String get finCreditHealthy => 'ആരോഗ്യകരം — ക്രെഡിറ്റ് എക്സ്പോഷർ കുറവാണ്';

  @override
  String get finCreditModerate =>
      'മിതമായത് — കുടിശ്ശിക പിരിക്കുന്നത് പരിഗണിക്കുക';

  @override
  String get finCreditHigh => 'ഉയർന്നത് — പല വിൽപ്പനകളും ക്രെഡിറ്റിലാണ്';

  @override
  String get finConsentTitle => 'ഉപഭോക്താവിന്റെ സമ്മതം റെക്കോർഡ് ചെയ്യുക';

  @override
  String get finConsentSubtitle => 'ഈ ഉധാറിന്റെ ശബ്ദ സ്ഥിരീകരണം';

  @override
  String get finConsentScriptIntro =>
      'ഉപഭോക്താവിനോട് ഇങ്ങനെ പറയാൻ ആവശ്യപ്പെടുക:';

  @override
  String finConsentScript(String total, String udhaar, String date) {
    return 'ഞാൻ സമ്മതിക്കുന്നു — ആകെ $total, ഉധാർ $udhaar, $date നകം തിരിച്ചടയ്ക്കും.';
  }

  @override
  String get finConsentTapToRecord =>
      'മൈക്ക് അമർത്തി ഉപഭോക്താവിനെ സംസാരിക്കാൻ അനുവദിക്കുക';

  @override
  String get finConsentRecording => 'റെക്കോർഡ് ചെയ്യുന്നു';

  @override
  String get finConsentSaved =>
      'സമ്മതം സേവ് ചെയ്തു — പശ്ചാത്തലത്തിൽ അപ്‌ലോഡ് ചെയ്യുന്നു';

  @override
  String get finConsentSkip => 'ഒഴിവാക്കുക';

  @override
  String get finConsentSectionTitle => 'ശബ്ദ സമ്മതം';

  @override
  String get finConsentStatusPending => 'അപ്‌ലോഡ് ചെയ്തു · വിശകലനം ബാക്കി';

  @override
  String get finConsentStatusAnalyzed => 'സ്ഥിരീകരിച്ചു';

  @override
  String finConsentMatchScore(String pct) {
    return 'ശബ്ദ പൊരുത്തം: $pct%';
  }

  @override
  String get finConsentNone => 'ശബ്ദ സമ്മതം രേഖപ്പെടുത്തിയിട്ടില്ല';

  @override
  String get finDueDate => 'തിരിച്ചടവ് തീയതി';

  @override
  String get finDueDateHint => 'ഉപഭോക്താവ് എപ്പോൾ തിരിച്ചടയ്ക്കും?';

  @override
  String finDueBy(String date) {
    return '$date നകം അടയ്ക്കണം';
  }

  @override
  String finClearingDues(int count) {
    return '$count കടങ്ങൾ തീർക്കുന്നു…';
  }

  @override
  String finDuesCleared(int count) {
    return '$count കടങ്ങൾ തീർത്തു';
  }

  @override
  String finClearingDuesProgress(int cleared, int total) {
    return 'കുടിശ്ശിക തീർക്കുന്നു: $cleared/$total';
  }

  @override
  String finDuesClearFailed(int cleared, int total) {
    return 'എല്ലാ കുടിശ്ശികയും തീർക്കാനായില്ല ($cleared/$total)';
  }

  @override
  String get finSmartReminders => 'സ്മാർട്ട് റിമൈൻഡറുകൾ';

  @override
  String get finCouldNotLoadReminders => 'റിമൈൻഡറുകൾ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String finDaysPending(int days) {
    return '$days ദിവസം തീർപ്പാക്കാത്തത്';
  }

  @override
  String finRiskBadge(String band) {
    return '$band റിസ്ക്';
  }

  @override
  String finLikelyToRecover(int percent) {
    return '~$percent% വീണ്ടെടുക്കാൻ സാധ്യത';
  }

  @override
  String get finSendReminder => 'റിമൈൻഡർ അയയ്ക്കുക';

  @override
  String finReminderSentTo(String name) {
    return '$name ന് റിമൈൻഡർ അയച്ചു';
  }

  @override
  String get finCouldNotSendReminder => 'റിമൈൻഡർ അയയ്ക്കാനായില്ല';

  @override
  String get finNoOpenUdhaar => 'തുറന്ന ഉധാർ ഇല്ല';

  @override
  String get finAllCreditSettled => 'എല്ലാ ക്രെഡിറ്റും തീർപ്പാക്കി. കൊള്ളാം!';

  @override
  String get procAddSupplierFirstToCreatePo =>
      'പർച്ചേസ് ഓർഡർ സൃഷ്ടിക്കാൻ ആദ്യം ഒരു വിതരണക്കാരനെ ചേർക്കുക';

  @override
  String procErrorWithMessage(String message) {
    return 'പിശക്: $message';
  }

  @override
  String get procSuppliers => 'വിതരണക്കാർ';

  @override
  String get procNoSuppliersYet => 'ഇതുവരെ വിതരണക്കാരെ ചേർത്തിട്ടില്ല.';

  @override
  String get procRecentPurchases => 'സമീപകാല പർച്ചേസുകൾ';

  @override
  String get procAddAtLeastOneSupplier =>
      'ഒരു പർച്ചേസ് ചേർക്കണമെങ്കിൽ, കുറഞ്ഞത് 1 വിതരണക്കാരനെ ചേർക്കുക.';

  @override
  String get procNoPurchaseOrdersYet => 'ഇതുവരെ പർച്ചേസ് ഓർഡറുകൾ ഇല്ല.';

  @override
  String get procScanInvoice => 'ഇൻവോയ്സ് സ്കാൻ ചെയ്യുക';

  @override
  String get procAdd => 'ചേർക്കുക';

  @override
  String get procSuggestedReorders => 'നിർദ്ദേശിച്ച റീഓർഡറുകൾ';

  @override
  String get procRunningLowLast30Days =>
      'കഴിഞ്ഞ 30 ദിവസത്തെ വിൽപ്പന അടിസ്ഥാനമാക്കി കുറയുന്നു';

  @override
  String get procAddNewSupplier => 'പുതിയ വിതരണക്കാരനെ ചേർക്കുക';

  @override
  String get procContacts => 'കോൺടാക്റ്റുകൾ';

  @override
  String get procSupplierName => 'വിതരണക്കാരന്റെ പേര്';

  @override
  String get procPhoneNumber => 'ഫോൺ നമ്പർ';

  @override
  String get procCategoryHint => 'വിഭാഗം (ഉദാ. ഡയറി, FMCG)';

  @override
  String get procEnterValidPhone => 'സാധുവായ ഫോൺ നമ്പർ നൽകുക';

  @override
  String get procSaveSupplier => 'വിതരണക്കാരനെ സംരക്ഷിക്കുക';

  @override
  String get procEditSupplier => 'വിതരണക്കാരനെ എഡിറ്റ് ചെയ്യുക';

  @override
  String get procSaveChanges => 'മാറ്റങ്ങൾ സംരക്ഷിക്കുക';

  @override
  String get procNewPurchaseOrder => 'പുതിയ പർച്ചേസ് ഓർഡർ';

  @override
  String get procRecordItemsFromDistributor =>
      'ഒരു വിതരണക്കാരനിൽ നിന്ന് വാങ്ങിയ ഇനങ്ങൾ രേഖപ്പെടുത്തുക.';

  @override
  String get procOrderDetails => 'ഓർഡർ വിശദാംശങ്ങൾ';

  @override
  String get procDistributor => 'വിതരണക്കാരൻ';

  @override
  String get procPaymentDueDate => 'പേയ്മെന്റ് അവസാന തീയതി';

  @override
  String get procSelectDate => 'തീയതി തിരഞ്ഞെടുക്കുക';

  @override
  String procItemsCount(int count) {
    return 'ഇനങ്ങൾ ($count)';
  }

  @override
  String get procAddItem => 'ഇനം ചേർക്കുക';

  @override
  String get procNoItemsAddedYet => 'ഇതുവരെ ഇനങ്ങൾ ചേർത്തിട്ടില്ല';

  @override
  String get procNotes => 'കുറിപ്പുകൾ';

  @override
  String get procNotesHint => 'ബിൽ നമ്പർ, ഡെലിവറി കുറിപ്പുകൾ, മുതലായവ.';

  @override
  String get procTotalAmount => 'ആകെ തുക';

  @override
  String get procSaveOrder => 'ഓർഡർ സംരക്ഷിക്കുക';

  @override
  String get procSearchProduct => 'ഉൽപ്പന്നം തിരയുക...';

  @override
  String procAddProduct(String name) {
    return '$name ചേർക്കുക';
  }

  @override
  String get procQuantity => 'അളവ്';

  @override
  String get procCostPricePerUnit => 'ഓരോ യൂണിറ്റിന്റെ ചെലവ് വില';

  @override
  String get procCancel => 'റദ്ദാക്കുക';

  @override
  String procDaysCover(String days) {
    return '$daysദി കവർ';
  }

  @override
  String procOrderQty(String qty) {
    return 'ഓർഡർ $qty';
  }

  @override
  String procStockLine(String stock, String perDay, String cover) {
    return 'സ്റ്റോക്ക് $stock · ~$perDay/ദിവസം · $cover';
  }

  @override
  String get procCreatePurchaseOrder => 'പർച്ചേസ് ഓർഡർ സൃഷ്ടിക്കുക';

  @override
  String get procEditSupplierTooltip => 'വിതരണക്കാരനെ എഡിറ്റ് ചെയ്യുക';

  @override
  String get procMarkAsReceived => 'ലഭിച്ചതായി അടയാളപ്പെടുത്തുക';

  @override
  String get procPleaseSelectSupplierFirst =>
      'ദയവായി ആദ്യം ഒരു വിതരണക്കാരനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get procFromScannedInvoice => 'സ്കാൻ ചെയ്ത ഇൻവോയ്സിൽ നിന്ന്';

  @override
  String procPoCreatedWithUnmatched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ങ്ങൾ',
      one: '',
    );
    return 'പർച്ചേസ് ഓർഡർ സൃഷ്ടിച്ചു! ($count ഇനം$_temp0 പൊരുത്തപ്പെട്ടില്ല)';
  }

  @override
  String get procPoCreatedFromInvoice =>
      'ഇൻവോയ്സിൽ നിന്ന് പർച്ചേസ് ഓർഡർ സൃഷ്ടിച്ചു!';

  @override
  String get procCameraGalleryPdf => 'ക്യാമറ · ഗാലറി · PDF';

  @override
  String get procScansLabel => 'സ്കാനുകൾ';

  @override
  String get procScanAgain => 'വീണ്ടും സ്കാൻ ചെയ്യുക';

  @override
  String get procInvoiceScanProFeature => 'ഇൻവോയ്സ് സ്കാൻ ഒരു Pro ഫീച്ചറാണ്.';

  @override
  String get procUpgradeToPro => 'Pro ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യുക';

  @override
  String get procDailyLimitReached =>
      'ദൈനംദിന പരിധി എത്തി. തുടരാൻ ക്രെഡിറ്റുകൾ ടോപ്പ് അപ്പ് ചെയ്യുക.';

  @override
  String get procBuyCredits => 'ക്രെഡിറ്റുകൾ വാങ്ങുക';

  @override
  String get procCreatingPurchaseOrder => 'പർച്ചേസ് ഓർഡർ സൃഷ്ടിക്കുന്നു…';

  @override
  String get procPurchaseOrderCreated => 'പർച്ചേസ് ഓർഡർ സൃഷ്ടിച്ചു!';

  @override
  String get procTryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get procCaptureOrUploadInvoice =>
      'ഒരു വിതരണക്കാരന്റെ ഇൻവോയ്സ് ക്യാപ്ചർ ചെയ്യുകയോ അപ്‌ലോഡ് ചെയ്യുകയോ ചെയ്യുക';

  @override
  String get procUpgradeOrTopUp =>
      'Pro ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യുക അല്ലെങ്കിൽ ക്രെഡിറ്റുകൾ ടോപ്പ് അപ്പ് ചെയ്യുക';

  @override
  String get procKiranaAiReadsInvoice =>
      'Outlet AI ഇനങ്ങൾ, ആകെത്തുകകൾ & വിതരണക്കാരന്റെ വിശദാംശങ്ങൾ വായിക്കുന്നു';

  @override
  String get procCamera => 'ക്യാമറ';

  @override
  String get procGallery => 'ഗാലറി';

  @override
  String get procUploadPdfImageFile => 'PDF / ഇമേജ് ഫയൽ അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get procKiranaAiReadingInvoice =>
      'Outlet AI നിങ്ങളുടെ ഇൻവോയ്സ് വായിക്കുന്നു…';

  @override
  String get procExtractingItems =>
      'ഇനങ്ങൾ, അളവുകൾ, ആകെത്തുകകൾ എന്നിവ വേർതിരിച്ചെടുക്കുന്നു';

  @override
  String get procGrandTotal => 'ആകെ തുക';

  @override
  String get procSupplierUpper => 'വിതരണക്കാരൻ';

  @override
  String procItemsUpperCount(int count) {
    return 'ഇനങ്ങൾ ($count)';
  }

  @override
  String procMatchedCount(int count) {
    return '$count പൊരുത്തപ്പെട്ടു';
  }

  @override
  String procUnmatchedItemsWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ങ്ങൾ',
      one: '',
    );
    return '$count പൊരുത്തപ്പെടാത്ത ഇനം$_temp0 ലൈൻ ഇനങ്ങളായി ചേർക്കില്ല, പക്ഷേ പൂർണ്ണ ഇൻവോയ്സ് ആകെത്തുക രേഖപ്പെടുത്തും.';
  }

  @override
  String get procSelectSupplierToContinue =>
      'തുടരാൻ ഒരു വിതരണക്കാരനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get procCreatePurchaseOrderTitle => 'പർച്ചേസ് ഓർഡർ സൃഷ്ടിക്കുക';

  @override
  String procConfidencePercent(int pct) {
    return '$pct% ആത്മവിശ്വാസം';
  }

  @override
  String get procTotalsMatch => '✓ ആകെത്തുകകൾ പൊരുത്തപ്പെടുന്നു';

  @override
  String get procTotalMismatch => '⚠ ആകെത്തുക പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get procUnverified => 'പരിശോധിക്കാത്തത്';

  @override
  String get procPick => 'തിരഞ്ഞെടുക്കുക';

  @override
  String procNoMatchTapToSelect(String vendor) {
    return '\"$vendor\" ന് പൊരുത്തമില്ല — തിരഞ്ഞെടുക്കാൻ ടാപ്പ് ചെയ്യുക';
  }

  @override
  String get procSelectSupplier => 'വിതരണക്കാരനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get procSelectSupplierTitle => 'വിതരണക്കാരനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get procNoSuppliersAddInPurchaseTab =>
      'ഇതുവരെ വിതരണക്കാർ ഇല്ല. പർച്ചേസ് ടാബിൽ വിതരണക്കാരെ ചേർക്കുക.';

  @override
  String get procLinkToInventory => 'ഇൻവെന്ററിയുമായി ലിങ്ക് ചെയ്യുക';

  @override
  String get procSearchProducts => 'ഉൽപ്പന്നങ്ങൾ തിരയുക…';

  @override
  String get procNoProductsFound => 'ഉൽപ്പന്നങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String procPriceStockLabel(String price, String stock) {
    return '$price · സ്റ്റോക്ക്: $stock';
  }

  @override
  String get procMicPermissionDenied =>
      'മൈക്രോഫോൺ അനുമതി നിഷേധിച്ചു. ദയവായി ക്രമീകരണങ്ങളിൽ പ്രവർത്തനക്ഷമമാക്കുക.';

  @override
  String get procMicNotAccessible => 'മൈക്രോഫോൺ ആക്സസ് ചെയ്യാനാകുന്നില്ല.';

  @override
  String procAddedToCartFromVoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ങ്ങൾ',
      one: '',
    );
    return 'വോയ്സ് ഓർഡറിൽ നിന്ന് $count ഇനം$_temp0 കാർട്ടിൽ ചേർത്തു';
  }

  @override
  String get procVoiceOrder => 'വോയ്സ് ഓർഡർ';

  @override
  String get procSpeakAnyIndianLanguage => 'ഏത് ഇന്ത്യൻ ഭാഷയിലും സംസാരിക്കുക';

  @override
  String get procVoiceOrderProFeature =>
      'വോയ്സ് ഓർഡർ ഒരു Pro ഫീച്ചറാണ്. ആക്സസ് ചെയ്യാൻ അപ്ഗ്രേഡ് ചെയ്യുക.';

  @override
  String get procUpgrade => 'അപ്ഗ്രേഡ്';

  @override
  String get procNoVoiceOrdersLeft =>
      'ഇന്ന് വോയ്സ് ഓർഡറുകൾ ബാക്കിയില്ല. കൂടുതൽ ക്രെഡിറ്റുകൾ നേടുക.';

  @override
  String get procGetCredits => 'ക്രെഡിറ്റുകൾ നേടുക';

  @override
  String get procVoiceLabel => 'വോയ്സ്';

  @override
  String get procTapMicToStart =>
      'റെക്കോർഡിംഗ് ആരംഭിക്കാൻ മൈക്ക് ടാപ്പ് ചെയ്യുക';

  @override
  String get procTapToStopAndProcess =>
      'നിർത്തി പ്രോസസ്സ് ചെയ്യാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get procKiranaAiProcessing => 'Outlet AI പ്രോസസ്സ് ചെയ്യുന്നു…';

  @override
  String get procHeard => 'കേട്ടത്';

  @override
  String get procNoItemsDetectedTryAgain =>
      'ഇനങ്ങളൊന്നും കണ്ടെത്തിയില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get procRecordAgain => 'വീണ്ടും റെക്കോർഡ് ചെയ്യുക';

  @override
  String procAddToCartCount(int count) {
    return '$count കാർട്ടിൽ ചേർക്കുക';
  }

  @override
  String get procAutoDetectsLanguages =>
      'സ്വയം കണ്ടെത്തുന്നു: തെലുങ്ക് · ഹിന്ദി · ഉർദു · തമിഴ് · കന്നഡ · മലയാളം · ഇംഗ്ലീഷ്';

  @override
  String get procInStock => 'സ്റ്റോക്കിലുണ്ട്';

  @override
  String get procLowStock => 'കുറഞ്ഞ സ്റ്റോക്ക്';

  @override
  String get procNotFound => 'കണ്ടെത്തിയില്ല';

  @override
  String get procPickFromInventory => 'ഇൻവെന്ററിയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String procAddedToCartFromHandwriting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ങ്ങൾ',
      one: '',
    );
    return 'കൈയെഴുത്തിൽ നിന്ന് $count ഇനം$_temp0 കാർട്ടിൽ ചേർത്തു';
  }

  @override
  String get procCanvasNotReady => 'ക്യാൻവാസ് തയ്യാറല്ല';

  @override
  String get procFailedToCaptureCanvas => 'ക്യാൻവാസ് ക്യാപ്ചർ ചെയ്യാനായില്ല';

  @override
  String get procHandwriteOrder => 'കൈയെഴുത്ത് ഓർഡർ';

  @override
  String get procWriteItemsAnyScript => 'ഏത് ലിപിയിലും ഇനങ്ങൾ എഴുതുക';

  @override
  String get procDrawsLabel => 'ഡ്രോകൾ';

  @override
  String get procUndoLastStroke => 'അവസാന സ്ട്രോക്ക് പഴയപടിയാക്കുക';

  @override
  String get procClear => 'മായ്ക്കുക';

  @override
  String get procHandwriteOrderProFeature =>
      'കൈയെഴുത്ത് ഓർഡർ ഒരു Pro ഫീച്ചറാണ്.';

  @override
  String get procAutoDetectAfter5s => '5സെ ന് ശേഷം സ്വയം കണ്ടെത്തുക';

  @override
  String get procWriteItemsHere => 'ഇവിടെ ഇനങ്ങൾ എഴുതുക';

  @override
  String get procUpgradeOrTopUpToWrite =>
      'എഴുതാൻ അപ്ഗ്രേഡ് ചെയ്യുകയോ ടോപ്പ് അപ്പ് ചെയ്യുകയോ ചെയ്യുക';

  @override
  String get procHandwriteExample => 'ഉദാ. അരി 5കിലോ, പഞ്ചസാര 2കിലോ';

  @override
  String get procDetecting => 'കണ്ടെത്തുന്നു…';

  @override
  String get procDetectItems => 'ഇനങ്ങൾ കണ്ടെത്തുക';

  @override
  String get procRead => 'വായിക്കുക';

  @override
  String get procNoItemsDetectedWriteClearly =>
      'ഇനങ്ങളൊന്നും കണ്ടെത്തിയില്ല. കൂടുതൽ വ്യക്തമായി എഴുതാൻ ശ്രമിക്കുക.';

  @override
  String get procWriteAgain => 'വീണ്ടും എഴുതുക';

  @override
  String get procAnyScriptLanguages =>
      'ഏത് ലിപിയും: English · తెలుగు · हिंदी · Tamil · ಕನ್ನಡ · മലയാളം';

  @override
  String procProductNumber(String id) {
    return 'ഉൽപ്പന്നം #$id';
  }

  @override
  String get procReturnExchange => 'റിട്ടേൺ / എക്സ്ചേഞ്ച്';

  @override
  String procOrderPickItemsToReturn(String id) {
    return 'ഓർഡർ #$id · റിട്ടേൺ ചെയ്യാൻ ഇനങ്ങൾ തിരഞ്ഞെടുക്കുക';
  }

  @override
  String get procRecordReturn => 'റിട്ടേൺ രേഖപ്പെടുത്തുക';

  @override
  String get rackTitle => 'സ്റ്റോക്ക് റാക്കുകൾ';

  @override
  String get rackPlaceStock => 'സ്റ്റോക്ക് വയ്ക്കുക';

  @override
  String get rackSearchHint => 'ഉൽപ്പന്നം അല്ലെങ്കിൽ റാക്ക് തിരയുക (ഉദാ. A1)';

  @override
  String get rackSaved => 'സ്റ്റോക്ക് റാക്കിൽ വച്ചു';

  @override
  String get rackChangeQty => 'അളവ് മാറ്റുക';

  @override
  String get rackMove => 'മറ്റൊരു റാക്കിലേക്ക് നീക്കുക';

  @override
  String get rackRemove => 'റാക്കിൽ നിന്ന് നീക്കം ചെയ്യുക';

  @override
  String get rackRemoved => 'റാക്കിൽ നിന്ന് നീക്കി';

  @override
  String get rackMoved => 'പുതിയ റാക്കിലേക്ക് നീക്കി';

  @override
  String get rackEmpty =>
      'ഇതുവരെ റാക്കുകളൊന്നും സജ്ജീകരിച്ചിട്ടില്ല. ഒരു ഉൽപ്പന്നം റാക്കിൽ വയ്ക്കാൻ \'സ്റ്റോക്ക് വയ്ക്കുക\' ടാപ്പ് ചെയ്യുക — പിന്നെ അത് വേഗം കണ്ടെത്താം.';

  @override
  String get rackNoMatch =>
      'നിങ്ങളുടെ തിരയലുമായി ഉൽപ്പന്നങ്ങളോ റാക്കുകളോ പൊരുത്തപ്പെടുന്നില്ല.';

  @override
  String get rackItems => 'സാധനങ്ങൾ';

  @override
  String get rackProduct => 'ഉൽപ്പന്നം';

  @override
  String get rackSelectProduct => 'ഒരു ഉൽപ്പന്നം തിരഞ്ഞെടുക്കുക';

  @override
  String get rackPickProductFirst => 'ആദ്യം ഒരു ഉൽപ്പന്നം തിരഞ്ഞെടുക്കുക';

  @override
  String get rackNeedLabel => 'റാക്ക് / ബിൻ ലേബൽ നൽകുക';

  @override
  String get rackSaveFailed => 'സംരക്ഷിക്കാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get rackLabel => 'റാക്ക് / ബിൻ';

  @override
  String get rackLabelHint => 'ഉദാ. A1, മുകളിലെ ഷെൽഫ്, കോൾഡ് സ്റ്റോറേജ്';

  @override
  String get rackQuantity => 'ഈ റാക്കിലെ അളവ്';

  @override
  String get rackSave => 'സംരക്ഷിക്കുക';

  @override
  String get rackLoadFailed =>
      'റാക്കുകൾ ലോഡ് ചെയ്യാനായില്ല. നിങ്ങളുടെ കണക്ഷൻ പരിശോധിക്കുക.';

  @override
  String get rackRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get rackLocation => 'റാക്ക് സ്ഥാനം';

  @override
  String get rackSetLocation => 'റാക്ക് സ്ഥാനം സജ്ജമാക്കുക';

  @override
  String get rackNoneForProduct => 'ഇതുവരെ ഒരു റാക്കിലും വച്ചിട്ടില്ല.';

  @override
  String get procExchangeInstead =>
      'എക്സ്ചേഞ്ച് (ഉപഭോക്താവ് മറ്റൊരു സാധനം എടുക്കുന്നു)';

  @override
  String get procRefundAmount => 'റീഫണ്ട് തുക';

  @override
  String get fulTitle => 'എസ്റ്റിമേറ്റുകളും റിട്ടേണുകളും';

  @override
  String get fulTabEstimates => 'എസ്റ്റിമേറ്റുകൾ';

  @override
  String get fulTabReturns => 'റിട്ടേണുകൾ';

  @override
  String get fulNoReturns =>
      'ഇതുവരെ റിട്ടേണുകളില്ല. ഉപഭോക്താവ് എന്തെങ്കിലും തിരികെ കൊണ്ടുവരുമ്പോൾ, \'റിട്ടേൺ രേഖപ്പെടുത്തുക\' ടാപ്പ് ചെയ്ത് അവരുടെ ഓർഡർ തിരഞ്ഞെടുക്കുക.';

  @override
  String get fulLogReturn => 'റിട്ടേൺ രേഖപ്പെടുത്തുക';

  @override
  String get fulPickOrderTitle => 'ഏത് ഓർഡറാണ് തിരികെ നൽകുന്നത്?';

  @override
  String get fulSearchOrders =>
      'ഓർഡർ # അല്ലെങ്കിൽ ഉപഭോക്താവ് ഉപയോഗിച്ച് തിരയുക';

  @override
  String get fulNoOrders => 'സമീപകാല ഓർഡറുകളൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get fulExchange => 'എക്സ്ചേഞ്ച്';

  @override
  String get fulRefund => 'റീഫണ്ട്';

  @override
  String get fulBackToShelf => 'ഷെൽഫിലേക്ക് തിരികെ';

  @override
  String get fulToVendor => 'വെണ്ടർക്ക്';

  @override
  String get fulItems => 'സാധനങ്ങൾ';

  @override
  String get fulLoadFailed =>
      'ലോഡ് ചെയ്യാനായില്ല. ദയവായി നിങ്ങളുടെ കണക്ഷൻ പരിശോധിക്കുക.';

  @override
  String get fulRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get estEmpty =>
      'ഇതുവരെ എസ്റ്റിമേറ്റുകളില്ല. ഒരു ഉപഭോക്താവിനായി ഒരു ക്വോട്ട് സൃഷ്ടിക്കുക — അത് പങ്കിടാം, പിന്നീട് വിൽപ്പനയാക്കാം.';

  @override
  String get estNewEstimate => 'പുതിയ എസ്റ്റിമേറ്റ്';

  @override
  String get estWalkIn => 'വാക്ക്-ഇൻ ഉപഭോക്താവ്';

  @override
  String get estAddOneItem => 'കുറഞ്ഞത് ഒരു സാധനം ചേർക്കുക';

  @override
  String get estSaveFailed => 'സംരക്ഷിക്കാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get estCustomerOptional => 'ഉപഭോക്താവ് (ഓപ്ഷണൽ)';

  @override
  String get estSelectCustomer => 'ഉപഭോക്താവിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get estAddItem => 'സാധനം ചേർക്കുക';

  @override
  String get estValidUntil => 'വരെ സാധുവാണ്';

  @override
  String get estNoExpiry => 'കാലഹരണമില്ല';

  @override
  String get estSaveEstimate => 'എസ്റ്റിമേറ്റ് സംരക്ഷിക്കുക';

  @override
  String get estItemName => 'സാധനത്തിന്റെ പേര്';

  @override
  String get estPickFromCatalog => 'കാറ്റലോഗിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get estQty => 'എണ്ണം';

  @override
  String get estUnitPrice => 'യൂണിറ്റ് വില';

  @override
  String get estAddedToBill => 'ബില്ലിൽ ചേർത്തു';

  @override
  String get estSkippedNotInCatalog => 'ഒഴിവാക്കി (കാറ്റലോഗിൽ ഇല്ല)';

  @override
  String get estShareHeading => 'എസ്റ്റിമേറ്റ് / ക്വോട്ടേഷൻ';

  @override
  String get estShareTotal => 'ആകെ';

  @override
  String get estTotal => 'ആകെ';

  @override
  String get estStatus => 'നില';

  @override
  String get estStatusDraft => 'ഡ്രാഫ്റ്റ്';

  @override
  String get estStatusSent => 'അയച്ചു';

  @override
  String get estStatusAccepted => 'സ്വീകരിച്ചു';

  @override
  String get estStatusRejected => 'നിരസിച്ചു';

  @override
  String get estShare => 'പങ്കിടുക';

  @override
  String get estConvert => 'വിൽപ്പനയാക്കുക';

  @override
  String get staffTitle => 'സ്റ്റാഫ്';

  @override
  String get staffTeamTab => 'ടീമും ഹാജരും';

  @override
  String get staffTasksTab => 'ടാസ്ക്കുകൾ';

  @override
  String get staffNoStaff => 'ഇതുവരെ സ്റ്റാഫ് ഇല്ല. നിങ്ങളുടെ ടീമിനെ ചേർക്കുക.';

  @override
  String get staffAddStaff => 'സ്റ്റാഫ് ചേർക്കുക';

  @override
  String get staffNoTasks =>
      'ഇതുവരെ ടാസ്ക്കുകളില്ല. നിങ്ങളുടെ ടീമിനായി ഒരു ടാസ്ക്ക് അല്ലെങ്കിൽ ചെക്ക്‌ലിസ്റ്റ് ഇനം ചേർക്കുക.';

  @override
  String get staffAddTask => 'ടാസ്ക്ക് ചേർക്കുക';

  @override
  String get jobTitle => 'ജോബ് കാർഡുകൾ';

  @override
  String get jobNewJob => 'പുതിയ ജോലി';

  @override
  String get jobNewJobCard => 'പുതിയ ജോബ് കാർഡ്';

  @override
  String get jobRepair => 'റിപ്പയർ';

  @override
  String get jobAlteration => 'മാറ്റം';

  @override
  String get jobPreorder => 'പ്രീ-ഓർഡർ';

  @override
  String get wtyIssue => 'പ്രശ്നം';

  @override
  String get wtySelectSerial => 'ഒരു സീരിയൽ തിരഞ്ഞെടുക്കുക';

  @override
  String get wtyCreateClaim => 'ക്ലെയിം സൃഷ്ടിക്കുക';

  @override
  String get wtyNoClaims => 'വാറന്റി ക്ലെയിമുകളൊന്നും രേഖപ്പെടുത്തിയിട്ടില്ല.';

  @override
  String get wtyTitle => 'വാറന്റിയും സീരിയലുകളും';

  @override
  String get wtyTabClaims => 'ക്ലെയിമുകൾ';

  @override
  String get wtyTabSerials => 'സീരിയലുകൾ';

  @override
  String get wtyNewClaim => 'പുതിയ ക്ലെയിം';

  @override
  String get wtyAddSerial => 'സീരിയൽ ചേർക്കുക';

  @override
  String get wtySearchSerials => 'സീരിയൽ / IMEI അല്ലെങ്കിൽ ഉൽപ്പന്നം തിരയുക';

  @override
  String get wtyNoSerials =>
      'ഇതുവരെ സീരിയലുകളൊന്നും രജിസ്റ്റർ ചെയ്തിട്ടില്ല. ചെക്ക്ഔട്ടിലോ താഴെയുള്ള ബട്ടൺ ഉപയോഗിച്ചോ സീരിയലുകൾ ചേർക്കുക.';

  @override
  String get wtyAll => 'എല്ലാം';

  @override
  String get wtyInStock => 'സ്റ്റോക്കിൽ';

  @override
  String get wtySold => 'വിറ്റു';

  @override
  String get wtyProduct => 'ഉൽപ്പന്നം';

  @override
  String get wtySelectProduct => 'ഒരു ഉൽപ്പന്നം തിരഞ്ഞെടുക്കുക';

  @override
  String get wtySerialImei => 'സീരിയൽ / IMEI നമ്പർ';

  @override
  String get wtySoldOn => 'വിറ്റത്';

  @override
  String get wtyExpired => 'വാറന്റി കാലഹരണപ്പെട്ടു';

  @override
  String get wtyExpires => 'കാലഹരണം';

  @override
  String get wtyWarrantyTill => 'വാറന്റിയിൽ വരെ';

  @override
  String get wtyPickProduct => 'ആദ്യം ഒരു ഉൽപ്പന്നം തിരഞ്ഞെടുക്കുക';

  @override
  String get wtyEnterSerial => 'സീരിയൽ / IMEI നൽകുക';

  @override
  String get wtySaveFailed => 'സംരക്ഷിക്കാനായില്ല. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get wtySave => 'സംരക്ഷിക്കുക';

  @override
  String get staffComm => 'കമ്മീഷൻ';

  @override
  String get staffEdit => 'എഡിറ്റ്';

  @override
  String get staffOrders30d => 'ഓർഡറുകൾ (30ദി)';

  @override
  String get staffCommEarned => 'കമ്മീഷൻ';

  @override
  String get staffEditMember => 'സ്റ്റാഫ് അംഗത്തെ എഡിറ്റ് ചെയ്യുക';

  @override
  String get staffName => 'പേര്';

  @override
  String get staffPhoneOptional => 'ഫോൺ (ഓപ്ഷണൽ)';

  @override
  String get staffRoleOptional => 'റോൾ (ഓപ്ഷണൽ)';

  @override
  String get staffCommissionField => 'കമ്മീഷൻ';

  @override
  String get staffActive => 'സജീവം';

  @override
  String get staffActiveHint =>
      'നിഷ്ക്രിയ സ്റ്റാഫ് ലിസ്റ്റുകളിൽ നിന്നും ബില്ലിംഗിൽ നിന്നും മറയ്ക്കപ്പെടും.';

  @override
  String get staffSaveChanges => 'മാറ്റങ്ങൾ സംരക്ഷിക്കുക';

  @override
  String get staffAssignedTo => 'ന് നൽകി';

  @override
  String get staffBilledBy => 'ബിൽ ചെയ്തത് (ഓപ്ഷണൽ)';

  @override
  String get staffNotSet => 'സജ്ജമാക്കിയിട്ടില്ല';

  @override
  String get fulReturnsOnOrder => 'ഈ ബില്ലിലെ റിട്ടേണുകൾ';

  @override
  String procBoughtQty(String qty) {
    return 'വാങ്ങിയത് $qty ';
  }

  @override
  String get procBackToShelf => 'ഷെൽഫിലേക്ക് തിരികെ';

  @override
  String get procResaleable => 'വീണ്ടും വിൽക്കാവുന്നത്';

  @override
  String get procDamagedToVendor => 'കേടായത് → വെണ്ടർ';

  @override
  String procReturnRecordedShelf(int count) {
    return 'റിട്ടേൺ രേഖപ്പെടുത്തി — $count ഷെൽഫിലേക്ക് തിരികെ';
  }

  @override
  String procReturnToVendorSuffix(int count) {
    return ', $count വെണ്ടറിലേക്ക്';
  }

  @override
  String get procCouldNotRecordReturn => 'റിട്ടേൺ രേഖപ്പെടുത്താനായില്ല';

  @override
  String get subYourInsights => 'നിങ്ങളുടെ ഉൾക്കാഴ്ചകൾ';

  @override
  String get subError => 'പിശക്';

  @override
  String get subManageKpis => 'KPI-കൾ കൈകാര്യം ചെയ്യുക';

  @override
  String get subManageSubscriptions => 'സബ്സ്ക്രിപ്ഷനുകൾ കൈകാര്യം ചെയ്യുക';

  @override
  String get subDone => 'പൂർത്തിയായി';

  @override
  String subKpisSelected(int n) {
    return '$n KPI-കൾ തിരഞ്ഞെടുത്തു';
  }

  @override
  String get subSelectAll => 'എല്ലാം തിരഞ്ഞെടുക്കുക';

  @override
  String get subClear => 'മായ്ക്കുക';

  @override
  String get subUnselect => 'തിരഞ്ഞെടുപ്പ് മാറ്റുക';

  @override
  String subProKpiName(String name) {
    return 'Pro KPI: $name';
  }

  @override
  String get subConfirmSelections => 'തിരഞ്ഞെടുപ്പുകൾ സ്ഥിരീകരിക്കുക';

  @override
  String get subNoActiveKpis => 'സജീവ KPI-കൾ ഇല്ല';

  @override
  String get subManageToSeeInsights =>
      'ഉൾക്കാഴ്ചകൾ കാണാൻ നിങ്ങളുടെ സബ്സ്ക്രിപ്ഷനുകൾ കൈകാര്യം ചെയ്യുക';

  @override
  String get subFailedLoadInsights => 'തത്സമയ ഉൾക്കാഴ്ചകൾ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get subManageInventory => 'ഇൻവെന്ററി കൈകാര്യം ചെയ്യുക';

  @override
  String get subSendReminders => 'റിമൈൻഡറുകൾ അയയ്ക്കുക';

  @override
  String get subReminderMessage =>
      'ഹായ്, ഞങ്ങളുമായുള്ള നിങ്ങളുടെ ബിസിനസ് സംബന്ധിച്ച ഓർമ്മപ്പെടുത്തലാണിത്. നിങ്ങളുടെ ഏറ്റവും പുതിയ അപ്ഡേറ്റുകൾ പരിശോധിക്കുക.';

  @override
  String get subNewSale => 'പുതിയ വിൽപ്പന';

  @override
  String get subAiSummary => 'AI സംഗ്രഹം';

  @override
  String subPoweredBy(String agent) {
    return '$agent പിന്തുണയോടെ';
  }

  @override
  String get subTarget => 'ലക്ഷ്യം';

  @override
  String get subBaseline => 'അടിസ്ഥാന നില';

  @override
  String get subLiveDataBreakdown => 'തത്സമയ ഡാറ്റ വിശകലനം';

  @override
  String get subMlInsights => 'MI ഉൾക്കാഴ്ചകൾ';

  @override
  String get subNoDynamicInsights =>
      'ഈ KPI ക്ക് ഡൈനാമിക് ഉൾക്കാഴ്ചകൾ ലഭ്യമല്ല.';

  @override
  String subPctVsLastPeriod(String pct) {
    return '$pct% കഴിഞ്ഞ കാലയളവുമായി';
  }

  @override
  String get subCurrent => 'നിലവിലുള്ളത്';

  @override
  String get subWhyThisValue => 'ഈ മൂല്യം എന്തുകൊണ്ട്?';

  @override
  String get subSomethingWentWrong => 'അയ്യോ! എന്തോ പിഴവ് സംഭവിച്ചു';

  @override
  String get subRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get subSubscriptionAndPlans => 'സബ്സ്ക്രിപ്ഷൻ & പ്ലാനുകൾ';

  @override
  String subErrorWithDetail(String detail) {
    return 'പിശക്: $detail';
  }

  @override
  String get subCancelSubscriptionTitle => 'സബ്സ്ക്രിപ്ഷൻ റദ്ദാക്കണോ?';

  @override
  String get subCancelSubscriptionBody =>
      'നിങ്ങളുടെ സബ്സ്ക്രിപ്ഷൻ ഉടൻ റദ്ദാക്കും. എപ്പോൾ വേണമെങ്കിലും വീണ്ടും സബ്സ്ക്രൈബ് ചെയ്യാം.';

  @override
  String get subKeepPlan => 'പ്ലാൻ നിലനിർത്തുക';

  @override
  String get subCancelSubscription => 'സബ്സ്ക്രിപ്ഷൻ റദ്ദാക്കുക';

  @override
  String get subSubscriptionCancelled => 'സബ്സ്ക്രിപ്ഷൻ റദ്ദാക്കി.';

  @override
  String subCancelFailed(String detail) {
    return 'റദ്ദാക്കൽ പരാജയപ്പെട്ടു: $detail';
  }

  @override
  String get subChooseYourPlan => 'നിങ്ങളുടെ പ്ലാൻ തിരഞ്ഞെടുക്കുക';

  @override
  String get subFeaturePosSales => 'POS & വിൽപ്പന മാനേജ്മെന്റ്';

  @override
  String get subFeatureInventoryTracking => 'ഇൻവെന്ററി ട്രാക്കിംഗ്';

  @override
  String get subFeatureFinanceUdhaar => 'ഫിനാൻസ് & ഉധാർ';

  @override
  String get subFeatureKpiInsights => 'KPI ഉൾക്കാഴ്ചകൾ (വിഭാഗത്തിന് 3)';

  @override
  String get subFeatureCustomerRelations => 'ഉപഭോക്തൃ ബന്ധങ്ങൾ';

  @override
  String get subFeatureAiRecommendations => 'AI ശുപാർശകൾ';

  @override
  String get subFeatureAllKpiCategories =>
      'എല്ലാ KPI വിഭാഗങ്ങളും (പരിധിയില്ലാത്തത്)';

  @override
  String get subFeatureVendorProcurement =>
      'വെണ്ടർ & പ്രൊക്യുർമെന്റ് മാനേജ്മെന്റ്';

  @override
  String get subFeatureCashflowSupport => 'ക്യാഷ്ഫ്ലോ പിന്തുണ (₹10L വരെ)';

  @override
  String get subFeatureCustomerGrowth => 'കസ്റ്റമർ ഗ്രോത്ത് എഞ്ചിൻ';

  @override
  String get subPerMonth => '/മാസം';

  @override
  String get subRestorePurchases => 'പർച്ചേസുകൾ പുനഃസ്ഥാപിക്കുക';

  @override
  String get subNeedHelp => 'സഹായം വേണോ?';

  @override
  String get subReachWhatsApp =>
      'പ്ലാൻ ചോദ്യങ്ങൾക്കോ ബില്ലിംഗ് പിന്തുണയ്ക്കോ WhatsApp ൽ ഞങ്ങളെ ബന്ധപ്പെടുക.';

  @override
  String get subWhatsAppSupport => 'WhatsApp പിന്തുണ';

  @override
  String get subWhatsAppHelpMessage =>
      'ഹായ്! എന്റെ Outlet AI സബ്സ്ക്രിപ്ഷനിൽ എനിക്ക് സഹായം വേണം.';

  @override
  String subCurrentPlanLabel(String plan) {
    return 'നിലവിലുള്ളത്: $plan';
  }

  @override
  String get subTimeRemaining => 'ബാക്കിയുള്ള സമയം: ';

  @override
  String get subBest => 'മികച്ചത്';

  @override
  String subJustPerDay(String price) {
    return 'വെറും $price/ദിവസം';
  }

  @override
  String get subTrialPlanNotice =>
      'നിങ്ങൾ ഈ പ്ലാനിന്റെ സൗജന്യ ട്രയലിലാണ്. ട്രയൽ കഴിഞ്ഞ ശേഷം ആക്സസ് നിലനിർത്താൻ അപ്ഗ്രേഡ് ചെയ്യുക.';

  @override
  String get subCurrentPlan => 'നിലവിലുള്ള പ്ലാൻ';

  @override
  String subUpgradeToKeepAccess(String name) {
    return '$name ആക്സസ് നിലനിർത്താൻ അപ്ഗ്രേഡ് ചെയ്യുക';
  }

  @override
  String subPayAndActivate(String name) {
    return '$name പേ ചെയ്ത് സജീവമാക്കുക';
  }

  @override
  String get subPaywallFeatureEverythingBasic => 'ബേസിക്കിലുള്ളതെല്ലാം';

  @override
  String get subPaywallFeaturePriorityAi => 'മുൻഗണനാ AI ശുപാർശകൾ';

  @override
  String get subProFeature => 'Pro ഫീച്ചർ';

  @override
  String get subProPlanIncludes => 'Pro പ്ലാനിൽ ഉൾപ്പെടുന്നു:';

  @override
  String get subNotNow => 'ഇപ്പോൾ വേണ്ട';

  @override
  String get subUpgradeToProPrice =>
      'Pro ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യുക  ₹500/മാസം · വെറും ₹17/ദിവസം';

  @override
  String get subInvoicePack => 'ഇൻവോയ്സ് പായ്ക്ക്';

  @override
  String get subVoicePack => 'വോയ്സ് പായ്ക്ക്';

  @override
  String get subHandwritingPack => 'കൈയെഴുത്ത് പായ്ക്ക്';

  @override
  String get subInvoicePackDesc =>
      '10 വിതരണക്കാരന്റെ ബില്ലുകൾ കൂടി പ്രോസസ്സ് ചെയ്യുക';

  @override
  String get subVoicePackDesc => '10 ഓഡിയോ/വോയ്സ് ഓർഡറുകൾ കൂടി ചേർക്കുക';

  @override
  String get subHandwritingPackDesc =>
      '10 കൈയെഴുത്ത് കുറിപ്പുകൾ കൂടി സ്കാൻ ചെയ്യുക';

  @override
  String get subPrice => 'വില';

  @override
  String get subCreditsRollOverDaily =>
      'ക്രെഡിറ്റുകൾ കാലഹരണപ്പെടില്ല — അവ ഓരോ ദിവസവും കൈമാറ്റം ചെയ്യപ്പെടും.';

  @override
  String get subCancel => 'റദ്ദാക്കുക';

  @override
  String subPayAmount(int amount) {
    return '₹$amount അടയ്ക്കുക';
  }

  @override
  String subCreditsAdded(int count, String name) {
    return '$count $name ക്രെഡിറ്റുകൾ ചേർത്തു!';
  }

  @override
  String get subTopUpCredits => 'നിങ്ങളുടെ ക്രെഡിറ്റുകൾ ടോപ്പ് അപ്പ് ചെയ്യുക';

  @override
  String get subCreditsNeverExpire =>
      'ക്രെഡിറ്റുകൾ ഒരിക്കലും കാലഹരണപ്പെടില്ല — അവ നാളെയ്ക്ക് കൈമാറ്റം ചെയ്യപ്പെടും!';

  @override
  String subCreditsCount(int count) {
    return '$count ക്രെഡിറ്റുകൾ';
  }

  @override
  String get subBuy => 'വാങ്ങുക';

  @override
  String get subTrialExpiredMessage =>
      'നിങ്ങളുടെ സൗജന്യ ട്രയൽ കാലഹരണപ്പെട്ടു. തുടരാൻ അപ്ഗ്രേഡ് ചെയ്യുക.';

  @override
  String get subTrialLastDayMessage =>
      'നിങ്ങളുടെ സൗജന്യ ട്രയലിന്റെ അവസാന ദിവസം! ഇപ്പോൾ അപ്ഗ്രേഡ് ചെയ്യുക.';

  @override
  String subTrialDaysLeftMessage(int n) {
    return 'നിങ്ങളുടെ ട്രയലിൽ $n ദിവസം ബാക്കി. Basic അല്ലെങ്കിൽ Pro ലേക്ക് അപ്ഗ്രേഡ് ചെയ്യുക.';
  }

  @override
  String get subTrialExpiringSoon => 'ട്രയൽ ഉടൻ കാലഹരണപ്പെടുന്നു';

  @override
  String get subTrialExpiredTitle => 'ട്രയൽ കാലഹരണപ്പെട്ടു';

  @override
  String get mktMyBaskets => 'എന്റെ ബാസ്കറ്റുകൾ';

  @override
  String get mktCouldNotLoadBaskets => 'ബാസ്കറ്റുകൾ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get mktPullDownToRetry => 'വീണ്ടും ശ്രമിക്കാൻ താഴേക്ക് വലിക്കുക';

  @override
  String get mktRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get mktNewBasket => 'പുതിയ ബാസ്കറ്റ്';

  @override
  String get mktNoBasketsYet => 'ഇതുവരെ ബാസ്കറ്റുകൾ ഇല്ല';

  @override
  String get mktBasketsEmptySubtitle =>
      'കോമ്പോ ഡീലുകളും ബണ്ടിൽ ഓഫറുകളും സൃഷ്ടിക്കുക.\nWhatsApp വഴി നിങ്ങളുടെ എല്ലാ ഉപഭോക്താക്കളെയും അറിയിക്കുക.';

  @override
  String get mktCreateFirstBasket => 'ആദ്യ ബാസ്കറ്റ് സൃഷ്ടിക്കുക';

  @override
  String get mktDeleteBasketTitle => 'ബാസ്കറ്റ് ഇല്ലാതാക്കണോ?';

  @override
  String mktDeleteBasketConfirm(String name) {
    return '\"$name\" ഇല്ലാതാക്കണോ? ഇത് പഴയപടിയാക്കാനാകില്ല.';
  }

  @override
  String get mktCancel => 'റദ്ദാക്കുക';

  @override
  String get mktBasketDeleted => 'ബാസ്കറ്റ് ഇല്ലാതാക്കി';

  @override
  String get mktCouldNotDeleteBasket =>
      'ബാസ്കറ്റ് ഇല്ലാതാക്കാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get mktDelete => 'ഇല്ലാതാക്കുക';

  @override
  String get mktSendWhatsAppAlertTitle => 'WhatsApp അലേർട്ട് അയയ്ക്കണോ?';

  @override
  String mktSendWhatsAppAlertConfirm(String name) {
    return '\"$name\" ന്റെ ബാസ്കറ്റ് ഡീൽ WhatsApp വഴി നിങ്ങളുടെ എല്ലാ ഉപഭോക്താക്കൾക്കും അയയ്ക്കണോ?';
  }

  @override
  String get mktSend => 'അയയ്ക്കുക';

  @override
  String mktWhatsAppAlertSent(int sent, int total) {
    return '$total ഉപഭോക്താക്കളിൽ $sent പേർക്ക് WhatsApp അലേർട്ട് അയച്ചു!';
  }

  @override
  String get mktNoCustomersWithPhone =>
      'ഫോൺ നമ്പറുള്ള ഉപഭോക്താക്കളെ കണ്ടെത്തിയില്ല.';

  @override
  String mktWhatsAppNotActiveYet(int total) {
    return 'WhatsApp ഇതുവരെ സജീവമല്ല. പ്രവർത്തനക്ഷമമാക്കിയാൽ $total ഉപഭോക്താക്കൾക്ക് അലേർട്ട് സ്വയം അയയ്ക്കും.';
  }

  @override
  String mktAlertFailed(String error) {
    return 'പരാജയപ്പെട്ടു: $error';
  }

  @override
  String get mktExpired => 'കാലഹരണപ്പെട്ടു';

  @override
  String get mktItem => 'ഇനം';

  @override
  String mktFromDate(String date) {
    return '$date മുതൽ';
  }

  @override
  String mktToDate(String date) {
    return '$date വരെ';
  }

  @override
  String get mktAlertCustomers => 'ഉപഭോക്താക്കളെ അറിയിക്കുക';

  @override
  String get mktNoProductsInInventory =>
      'ഇൻവെന്ററിയിൽ ഉൽപ്പന്നങ്ങൾ ഇല്ല. ദയവായി ആദ്യം POS സിങ്ക് ചെയ്യുക.';

  @override
  String get mktAllProductsAdded =>
      'എല്ലാ ഉൽപ്പന്നങ്ങളും ഇതിനകം ഈ ബാസ്കറ്റിൽ ചേർത്തിട്ടുണ്ട്';

  @override
  String get mktBasketNameRequired => 'ബാസ്കറ്റ് പേര് ആവശ്യമാണ്';

  @override
  String get mktAddAtLeastOneProduct =>
      'ഇൻവെന്ററിയിൽ നിന്ന് കുറഞ്ഞത് ഒരു ഉൽപ്പന്നം ചേർക്കുക';

  @override
  String get mktSave => 'സംരക്ഷിക്കുക';

  @override
  String get mktBasketNameLabel => 'ബാസ്കറ്റ് പേര് *';

  @override
  String get mktBasketNameHint => 'ഉദാ. ബ്രേക്ഫാസ്റ്റ് ബണ്ടിൽ';

  @override
  String get mktDescriptionOptional => 'വിവരണം (ഓപ്ഷണൽ)';

  @override
  String get mktDescriptionHint => 'ഉദാ. പാൽ + ബ്രെഡ് + മുട്ട';

  @override
  String get mktBundlePriceOptional => 'ബണ്ടിൽ വില (ഓപ്ഷണൽ)';

  @override
  String get mktValidity => 'സാധുത';

  @override
  String get mktFromDateLabel => 'ആരംഭ തീയതി';

  @override
  String get mktToDateLabel => 'അവസാന തീയതി';

  @override
  String get mktProducts => 'ഉൽപ്പന്നങ്ങൾ';

  @override
  String get mktAddProduct => 'ഉൽപ്പന്നം ചേർക്കുക';

  @override
  String get mktTapToPickProducts =>
      'നിങ്ങളുടെ ഇൻവെന്ററിയിൽ നിന്ന് ഉൽപ്പന്നങ്ങൾ തിരഞ്ഞെടുക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String mktPricePerUnit(String price) {
    return '₹$price / യൂണിറ്റ്';
  }

  @override
  String get mktQty => 'അളവ്';

  @override
  String get mktCreateBasket => 'ബാസ്കറ്റ് സൃഷ്ടിക്കുക';

  @override
  String get mktSelectProduct => 'ഉൽപ്പന്നം തിരഞ്ഞെടുക്കുക';

  @override
  String get mktSearchProducts => 'ഉൽപ്പന്നങ്ങൾ തിരയുക...';

  @override
  String get mktNoProductsFound => 'ഉൽപ്പന്നങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String get mktAdd => 'ചേർക്കുക';

  @override
  String get mktEstTotal => 'ഏകദേശ ആകെത്തുക';

  @override
  String get mktAddAll => 'എല്ലാം ചേർക്കുക';

  @override
  String get mktNotInStock => 'സ്റ്റോക്കിൽ ഇല്ല';

  @override
  String mktCampaignItemStock(String qty, String unit, String price) {
    return 'സ്റ്റോക്ക്: $qty $unit  ·  ₹$price';
  }

  @override
  String get mktEstimatedTotal => 'ഏകദേശ ആകെത്തുക';

  @override
  String get mktNoItemsInStock => 'സ്റ്റോക്കിൽ ഇനങ്ങൾ ഇല്ല';

  @override
  String mktAddAvailableItemsToCart(int count) {
    return '$count ലഭ്യമായ ഇനങ്ങൾ കാർട്ടിൽ ചേർക്കുക';
  }

  @override
  String get mktAreaAssociations => 'ഏരിയ അസോസിയേഷനുകൾ';

  @override
  String get mktMyAreas => 'എന്റെ ഏരിയകൾ';

  @override
  String get mktCustomerHeatmap => 'ഉപഭോക്തൃ ഹീറ്റ്മാപ്പ്';

  @override
  String mktErrorWithMessage(String error) {
    return 'പിശക്: $error';
  }

  @override
  String get mktNoAreasAddedYet => 'ഇതുവരെ ഏരിയകൾ ചേർത്തിട്ടില്ല';

  @override
  String get mktAreasEmptySubtitle =>
      'ലക്ഷ്യമിട്ട ക്യാമ്പെയ്ൻ നിർദ്ദേശങ്ങൾ ലഭിക്കാൻ സമീപത്തെ അപ്പാർട്ട്മെന്റുകൾ, ഹോസ്റ്റലുകൾ, സ്കൂളുകൾ അല്ലെങ്കിൽ ഓഫീസുകൾ ചേർക്കുക.';

  @override
  String get mktAddFirstArea => 'ആദ്യ ഏരിയ ചേർക്കുക';

  @override
  String get mktRemoveAreaTitle => 'ഏരിയ നീക്കം ചെയ്യണോ?';

  @override
  String mktRemoveAreaConfirm(String name) {
    return 'നിങ്ങളുടെ അസോസിയേഷനുകളിൽ നിന്ന് \"$name\" നീക്കം ചെയ്യണോ?';
  }

  @override
  String get mktRemove => 'നീക്കം ചെയ്യുക';

  @override
  String mktHouseholdsCount(int count) {
    return '~$count കുടുംബങ്ങൾ';
  }

  @override
  String get mktNoHeatmapDataYet => 'ഇതുവരെ ഹീറ്റ്മാപ്പ് ഡാറ്റ ഇല്ല';

  @override
  String get mktHeatmapEmptySubtitle =>
      'ഏരിയകൾ ചേർത്ത് ആ ഏരിയകളിലേക്ക് ഉപഭോക്താക്കളെ ടാഗ് ചെയ്യുക. വരുമാന ഡാറ്റ കാലക്രമേണ ഇവിടെ ദൃശ്യമാകും.';

  @override
  String get mktLast90DaysByRevenue => 'കഴിഞ്ഞ 90 ദിവസം · വരുമാനം അനുസരിച്ച്';

  @override
  String get mktCustomers => 'ഉപഭോക്താക്കൾ';

  @override
  String get mktOrders => 'ഓർഡറുകൾ';

  @override
  String get mktAvgOrder => 'ശരാശരി ഓർഡർ';

  @override
  String get mktNoOrdersYetTagCustomers =>
      'ഇതുവരെ ഓർഡറുകൾ ഇല്ല — ട്രാക്ക് ചെയ്യാൻ ഈ ഏരിയയിലേക്ക് ഉപഭോക്താക്കളെ ടാഗ് ചെയ്യുക';

  @override
  String get mktAddNearbyArea => 'സമീപത്തെ ഏരിയ ചേർക്കുക';

  @override
  String get mktAreaType => 'ഏരിയ തരം';

  @override
  String get mktAreaNameLabel => 'പേര് (ഉദാ. പ്രസ്റ്റീജ് അപ്പാർട്ട്മെന്റ്സ്)';

  @override
  String get mktEstimatedHouseholdsOptional => 'ഏകദേശ കുടുംബങ്ങൾ (ഓപ്ഷണൽ)';

  @override
  String get mktNotesOptional => 'കുറിപ്പുകൾ (ഓപ്ഷണൽ)';

  @override
  String get mktAddArea => 'ഏരിയ ചേർക്കുക';

  @override
  String get mktCustomerGrowth => 'ഉപഭോക്തൃ വളർച്ച';

  @override
  String get mktNewCampaign => 'പുതിയ ക്യാമ്പെയ്ൻ';

  @override
  String get mktNoCampaignsYet => 'ഇതുവരെ ക്യാമ്പെയ്നുകൾ ഇല്ല';

  @override
  String get mktReferralEmptySubtitle =>
      'നിങ്ങളുടെ നിലവിലുള്ള ഉപഭോക്താക്കൾ പുതിയവരെ കൊണ്ടുവരാൻ ഒരു റഫറൽ ക്യാമ്പെയ്ൻ സൃഷ്ടിക്കുക — അതിന് അവർക്ക് പ്രതിഫലം നൽകുക.';

  @override
  String get mktCreateFirstCampaign => 'ആദ്യ ക്യാമ്പെയ്ൻ സൃഷ്ടിക്കുക';

  @override
  String get mktReferralHowItWorks =>
      'ഉപഭോക്താക്കൾ അവരുടെ QR സുഹൃത്തുക്കളുമായി പങ്കിടുന്നു. പുതിയ സന്ദർശകർ ഡിസ്കൗണ്ട് ലഭിക്കാൻ POS ൽ അത് സ്കാൻ ചെയ്യുന്നു — റഫറർ നാഴികക്കല്ല് റിവാർഡുകൾ നേടുന്നു.';

  @override
  String mktCampaignSummary(String discount, String reward, int n) {
    return 'പുതിയ ഉപഭോക്താക്കൾക്ക് $discount% കിഴിവ്  •  ഓരോ $n റഫറലുകൾക്കും $reward% റിവാർഡ്';
  }

  @override
  String get mktQrCodes => 'QR കോഡുകൾ';

  @override
  String get mktReferrals => 'റഫറലുകൾ';

  @override
  String get mktMaxPerPerson => 'പരമാവധി/വ്യക്തി';

  @override
  String get mktGenerateQr => 'QR സൃഷ്ടിക്കുക';

  @override
  String mktGenerateQrTitle(String name) {
    return 'QR സൃഷ്ടിക്കുക · $name';
  }

  @override
  String get mktSearchCustomer => 'ഉപഭോക്താവിനെ തിരയുക…';

  @override
  String get mktNoCustomersFound => 'ഉപഭോക്താക്കളെ കണ്ടെത്തിയില്ല';

  @override
  String get mktNoPhoneForCustomer => 'ഈ ഉപഭോക്താവിന് ഫോൺ നമ്പർ ഇല്ല';

  @override
  String mktReferralWhatsAppMessage(
    String name,
    String code,
    String discount,
    int n,
  ) {
    return 'ഹായ് $name! 🎁\n\nഞങ്ങളുടെ കട നിങ്ങളുടെ സുഹൃത്തുക്കളുമായി പങ്കിടാൻ നിങ്ങളെ ക്ഷണിക്കുന്നു!\n\nനിങ്ങളുടെ റഫറൽ കോഡ്: $code\n\nനിങ്ങളുടെ സുഹൃത്ത് ഞങ്ങളുടെ കടയിൽ വന്ന് ഈ കോഡ് കാണിക്കുമ്പോൾ, അവർക്ക് $discount% കിഴിവ് ലഭിക്കും — നിങ്ങൾ കൊണ്ടുവരുന്ന ഓരോ $n സുഹൃത്തുക്കൾക്കും നിങ്ങൾ റിവാർഡുകൾ നേടും! 🙌\n\n— LohiyaAI Kirana വഴി';
  }

  @override
  String get mktWhatsAppNotInstalled =>
      'ഈ ഉപകരണത്തിൽ WhatsApp ഇൻസ്റ്റാൾ ചെയ്തിട്ടില്ല';

  @override
  String get mktReferralQrCode => 'റഫറൽ QR കോഡ്';

  @override
  String mktPercentOffForNewCustomers(String discount) {
    return 'പുതിയ ഉപഭോക്താക്കൾക്ക് $discount% കിഴിവ്';
  }

  @override
  String mktMilestoneRewardLabel(String reward, int n) {
    return 'നാഴികക്കല്ല് റിവാർഡ്: ഓരോ $n റഫറലുകൾക്കും $reward%';
  }

  @override
  String get mktReferralCodeCopied => 'റഫറൽ കോഡ് പകർത്തി';

  @override
  String get mktSendViaWhatsApp => 'WhatsApp വഴി അയയ്ക്കുക';

  @override
  String get mktQrScreenshotHint =>
      'അല്ലെങ്കിൽ ഉപഭോക്താവിന് സ്ക്രീൻഷോട്ട് എടുക്കാൻ ഈ QR സ്ക്രീൻ നേരിട്ട് കാണിക്കുക.';

  @override
  String get mktInvalidQrCode => 'അസാധുവായ QR കോഡ്';

  @override
  String get mktCampaignNoLongerActive => 'ഈ റഫറൽ ക്യാമ്പെയ്ൻ ഇനി സജീവമല്ല';

  @override
  String get mktCouldNotLoadReferralInfo => 'റഫറൽ വിവരം ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get mktEnterValidPhone => 'സാധുവായ 10-അക്ക ഫോൺ നമ്പർ നൽകുക';

  @override
  String get mktClose => 'അടയ്ക്കുക';

  @override
  String mktReferralFrom(String name) {
    return '$name ൽ നിന്നുള്ള റഫറൽ';
  }

  @override
  String mktCampaignDiscountForNewCustomer(String campaign, String discount) {
    return '$campaign  •  പുതിയ ഉപഭോക്താവിന് $discount% കിഴിവ്';
  }

  @override
  String get mktNewCustomerDetails => 'പുതിയ ഉപഭോക്തൃ വിശദാംശങ്ങൾ';

  @override
  String get mktNewCustomerPhoneHelper =>
      'പുതിയ ഉപഭോക്താവിന്റെ ഫോൺ നൽകുക. നിങ്ങൾ ഓർഡർ ചെയ്യുമ്പോൾ കിഴിവ് ബാധകമാകും.';

  @override
  String get mktPhoneNumber => 'ഫോൺ നമ്പർ';

  @override
  String get mktCustomerNameOptional => 'ഉപഭോക്തൃ പേര് (ഓപ്ഷണൽ)';

  @override
  String get mktCustomerNameHint => 'ഉദാ. ഗ്യാൻ കുമാർ';

  @override
  String mktApplyReferralDiscount(String discount) {
    return '$discount% റഫറൽ കിഴിവ് പ്രയോഗിക്കുക';
  }

  @override
  String get mktCampaignNameRequired => 'ക്യാമ്പെയ്ൻ പേര് ആവശ്യമാണ്';

  @override
  String get mktEnterValidDiscount => 'സാധുവായ കിഴിവ് % നൽകുക (1–100)';

  @override
  String get mktMilestoneCountMin => 'നാഴികക്കല്ല് എണ്ണം കുറഞ്ഞത് 1 ആയിരിക്കണം';

  @override
  String get mktEnterValidReward => 'സാധുവായ റിവാർഡ് % നൽകുക (1–100)';

  @override
  String get mktMaxReferralsMin => 'പരമാവധി റഫറലുകൾ കുറഞ്ഞത് 1 ആയിരിക്കണം';

  @override
  String get mktFailedToCreateCampaign =>
      'ക്യാമ്പെയ്ൻ സൃഷ്ടിക്കാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get mktNewReferralCampaign => 'പുതിയ റഫറൽ ക്യാമ്പെയ്ൻ';

  @override
  String get mktCampaignName => 'ക്യാമ്പെയ്ൻ പേര്';

  @override
  String get mktCampaignNameHint => 'ഉദാ. സമ്മർ റഫറൽ ഡ്രൈവ്';

  @override
  String get mktNewCustomerDiscountPct => 'പുതിയ ഉപഭോക്തൃ കിഴിവ് %';

  @override
  String get mktMilestoneRewardPct => 'നാഴികക്കല്ല് റിവാർഡ് %';

  @override
  String get mktRewardEveryNReferrals => 'ഓരോ N റഫറലുകൾക്കും റിവാർഡ്';

  @override
  String get mktRewardEveryNHelper =>
      'റഫറർ കൊണ്ടുവരുന്ന ഓരോ N പുതിയ ഉപഭോക്താക്കൾക്കും ഒരു നാഴികക്കല്ല് റിവാർഡ് നേടുന്നു';

  @override
  String get mktMaxReferralsPerCustomer => 'ഓരോ ഉപഭോക്താവിനും പരമാവധി റഫറലുകൾ';

  @override
  String get mktMaxReferralsHelper =>
      'ഇത്രയും വിജയകരമായ റഫറലുകൾക്ക് ശേഷം ഒരു ഉപഭോക്താവിന് റിവാർഡ് നൽകുന്നത് നിർത്തുക';

  @override
  String get mktCreateCampaign => 'ക്യാമ്പെയ്ൻ സൃഷ്ടിക്കുക';

  @override
  String get profProfile => 'പ്രൊഫൈൽ';

  @override
  String profErrorLoadingProfile(String error) {
    return 'പ്രൊഫൈൽ ലോഡ് ചെയ്യുന്നതിൽ പിശക്: $error';
  }

  @override
  String get profNoUserData => 'ഉപയോക്തൃ ഡാറ്റ കണ്ടെത്തിയില്ല.';

  @override
  String get profCashflowSupport => 'ക്യാഷ്ഫ്ലോ പിന്തുണ';

  @override
  String get profCashflowSupportDesc =>
      'അനുയോജ്യമായ തിരിച്ചടവ് പ്ലാനുകളോടെ ₹50K – ₹10L ബിസിനസ് ഫിനാൻസിന് അപേക്ഷിക്കുക.';

  @override
  String get profCashflowBannerSubtitle =>
      '₹50K – ₹10L ബിസിനസ് ഫിനാൻസിന് അപേക്ഷിക്കുക';

  @override
  String get profSectionCustomers => 'ഉപഭോക്താക്കൾ';

  @override
  String get profSectionAnalytics => 'അനലിറ്റിക്സ്';

  @override
  String get profSectionOperations => 'പ്രവർത്തനങ്ങൾ';

  @override
  String get profSectionSalesMarketing => 'വിൽപ്പനയും മാർക്കറ്റിംഗും';

  @override
  String get profSectionStoreAccount => 'സ്റ്റോർ & അക്കൗണ്ട്';

  @override
  String get profSectionPlanSupport => 'പ്ലാൻ & പിന്തുണ';

  @override
  String get profSectionAdmin => 'അഡ്മിൻ';

  @override
  String get profCustomerGrowth => 'ഉപഭോക്തൃ വളർച്ച';

  @override
  String get profCustomerGrowthDesc =>
      'ഒരു റഫറൽ എഞ്ചിൻ നിർമ്മിക്കുക — നിങ്ങളുടെ സന്തുഷ്ടരായ ഉപഭോക്താക്കൾ സ്വയം പുതിയവരെ കൊണ്ടുവരട്ടെ.';

  @override
  String get profCustomerRelations => 'ഉപഭോക്തൃ ബന്ധങ്ങൾ';

  @override
  String get profAreaAssociations => 'ഏരിയ അസോസിയേഷനുകൾ';

  @override
  String get profKpiSubscriptions => 'KPI സബ്സ്ക്രിപ്ഷനുകൾ';

  @override
  String get profTransactionHistory => 'ഇടപാട് ചരിത്രം';

  @override
  String get profMyBaskets => 'എന്റെ ബാസ്കറ്റുകൾ';

  @override
  String get profLoyalty => 'ലോയൽറ്റി & ഓഫറുകൾ';

  @override
  String get profServices => 'സേവനങ്ങൾ & അപ്പോയിന്റ്മെന്റുകൾ';

  @override
  String get profStoreComparison => 'സ്റ്റോർ താരതമ്യം';

  @override
  String get profStaff => 'സ്റ്റാഫ്';

  @override
  String get profEstimatesReturns => 'എസ്റ്റിമേറ്റ് & റിട്ടേണുകൾ';

  @override
  String get profStockRacks => 'സ്റ്റോക്ക് റാക്കുകൾ';

  @override
  String get profJobCards => 'ജോബ് കാർഡുകൾ';

  @override
  String get profWarranty => 'വാറന്റി & സീരിയലുകൾ';

  @override
  String get profGstReport => 'ജിഎസ്‌ടി റിപ്പോർട്ട്';

  @override
  String get profLanguage => 'ഭാഷ';

  @override
  String get profStoreSettings => 'സ്റ്റോർ ക്രമീകരണങ്ങൾ';

  @override
  String get profSwitchStore => 'സ്റ്റോർ മാറ്റുക / ചേർക്കുക';

  @override
  String get profConfiguration => 'കോൺഫിഗറേഷൻ';

  @override
  String get profPasswordSecurity => 'പാസ്‌വേഡ് & സുരക്ഷ';

  @override
  String get profSubscriptionPlans => 'സബ്സ്ക്രിപ്ഷൻ & പ്ലാനുകൾ';

  @override
  String get profHelpSupport => 'സഹായം & പിന്തുണ';

  @override
  String get profUserActivity => 'ഉപയോക്തൃ പ്രവർത്തനം';

  @override
  String get profSignOut => 'സൈൻ ഔട്ട്';

  @override
  String get profTrialExpired => 'ട്രയൽ കാലഹരണപ്പെട്ടു';

  @override
  String get profAwaitingActivation => 'സജീവമാക്കലിനായി കാത്തിരിക്കുന്നു';

  @override
  String get profProTrial => 'Pro ട്രയൽ';

  @override
  String get profBasicTrial => 'Basic ട്രയൽ';

  @override
  String profTrialDaysLeft(String tier, int days) {
    return '$tier · $daysദി ബാക്കി';
  }

  @override
  String profTrialActive(String tier) {
    return '$tier സജീവം';
  }

  @override
  String get profBasicPlan => 'Basic പ്ലാൻ';

  @override
  String get profProPlan => 'Pro പ്ലാൻ';

  @override
  String get profSyncContacts => 'കോൺടാക്റ്റുകൾ സിങ്ക് ചെയ്യുക';

  @override
  String get profRefreshList => 'ലിസ്റ്റ് പുതുക്കുക';

  @override
  String get profAddCustomer => 'ഉപഭോക്താവിനെ ചേർക്കുക';

  @override
  String get profSearchByNameOrPhone =>
      'പേര് അല്ലെങ്കിൽ ഫോൺ ഉപയോഗിച്ച് തിരയുക...';

  @override
  String get profRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String profNoSegmentCustomers(String segment) {
    return '$segment ഉപഭോക്താക്കൾ ഇല്ല';
  }

  @override
  String get profNoCustomersFound => 'ഉപഭോക്താക്കളെ കണ്ടെത്തിയില്ല.';

  @override
  String get profSegRegular => 'സ്ഥിരം';

  @override
  String get profSegOccasional => 'ഇടയ്ക്കിടെ';

  @override
  String get profSegImpulse => 'ഇംപൾസ്';

  @override
  String get profSegBulk => 'ബൾക്ക്';

  @override
  String get profSegCredit => 'ക്രെഡിറ്റ്';

  @override
  String get profSegInactive => 'നിഷ്ക്രിയം';

  @override
  String get profSyncContactsTitle => 'കോൺടാക്റ്റുകൾ സിങ്ക് ചെയ്യണോ?';

  @override
  String get profSyncContactsBody =>
      'ഇത് നിങ്ങളുടെ ഫോൺ കോൺടാക്റ്റുകൾ നിങ്ങളുടെ ഉപഭോക്തൃ പട്ടികയിലേക്ക് ഇമ്പോർട്ട് ചെയ്യും. സ്ഥിരം ഉപഭോക്താക്കളെ ഫോൺ നമ്പർ ഉപയോഗിച്ച് പൊരുത്തപ്പെടുത്തും.';

  @override
  String get profCancel => 'റദ്ദാക്കുക';

  @override
  String get profSyncNow => 'ഇപ്പോൾ സിങ്ക് ചെയ്യുക';

  @override
  String profSyncedContacts(int count) {
    return '$count കോൺടാക്റ്റുകൾ വിജയകരമായി സിങ്ക് ചെയ്തു!';
  }

  @override
  String profSyncFailed(String error) {
    return 'സിങ്ക് പരാജയപ്പെട്ടു: $error';
  }

  @override
  String get profSendWhatsappReengagement =>
      'WhatsApp റീ-എൻഗേജ്മെന്റ് അയയ്ക്കുക';

  @override
  String profWhatsappReengagementMessage(String name) {
    return 'ഹായ് $name! ഞങ്ങളുടെ കടയിൽ നിങ്ങളെ മിസ് ചെയ്യുന്നു. നിങ്ങളുടെ അവസാന സന്ദർശനത്തിന് ശേഷം കുറച്ച് കാലമായി, നിങ്ങൾക്കായി പുതിയ സ്റ്റോക്കും മികച്ച ഡീലുകളും കാത്തിരിക്കുന്നു. ഉടൻ സന്ദർശിക്കുക — നിങ്ങളുടെ പ്രിയപ്പെട്ട ഇനങ്ങൾ തയ്യാറാണ്! ഉടൻ കാണാം!';
  }

  @override
  String get profAddNewCustomer => 'പുതിയ ഉപഭോക്താവിനെ ചേർക്കുക';

  @override
  String get profEditCustomer => 'ഉപഭോക്താവിനെ എഡിറ്റ് ചെയ്യുക';

  @override
  String get profFullName => 'പൂർണ്ണ നാമം';

  @override
  String get profPhoneNumber => 'ഫോൺ നമ്പർ';

  @override
  String get profEmailAddressOptional => 'ഇമെയിൽ വിലാസം (ഓപ്ഷണൽ)';

  @override
  String get profHouseholdSize => 'കുടുംബ വലുപ്പം';

  @override
  String get profBirthdayOptional => 'ജന്മദിനം (ഓപ്ഷണൽ)';

  @override
  String get profAnniversaryOptional => 'വാർഷികം (ഓപ്ഷണൽ)';

  @override
  String get profSaveCustomer => 'ഉപഭോക്താവിനെ സംരക്ഷിക്കുക';

  @override
  String get profFillNameAndPhone => 'ദയവായി പേരും ഫോണും പൂരിപ്പിക്കുക';

  @override
  String get profEnterValidPhone => 'സാധുവായ ഫോൺ നമ്പർ നൽകുക (അക്കങ്ങൾ മാത്രം)';

  @override
  String get profCustomerSaved => 'ഉപഭോക്താവിനെ വിജയകരമായി സംരക്ഷിച്ചു';

  @override
  String get profLoading => 'ലോഡ് ചെയ്യുന്നു...';

  @override
  String get profCustomerDetails => 'ഉപഭോക്തൃ വിശദാംശങ്ങൾ';

  @override
  String get profStatBalance => 'ബാലൻസ്';

  @override
  String get profStatSpent => 'ചെലവഴിച്ചത്';

  @override
  String get profStatOrders => 'ഓർഡറുകൾ';

  @override
  String get profCustomerInfo => 'ഉപഭോക്തൃ വിവരം';

  @override
  String profMembersCount(int count) {
    return '$count അംഗങ്ങൾ';
  }

  @override
  String get profJoinedOn => 'ചേർന്ന തീയതി';

  @override
  String get profUnknown => 'അജ്ഞാതം';

  @override
  String get profPurchaseHistory => 'പർച്ചേസ് ചരിത്രം';

  @override
  String get profNoOrdersForCustomer =>
      'ഈ ഉപഭോക്താവിന് ഓർഡറുകളൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String profErrorLoadingOrders(String error) {
    return 'ഓർഡറുകൾ ലോഡ് ചെയ്യുന്നതിൽ പിശക്: $error';
  }

  @override
  String get profDeleteCustomerTitle => 'ഉപഭോക്താവിനെ ഇല്ലാതാക്കണോ?';

  @override
  String profDeleteCustomerBody(String name) {
    return '$name ഇല്ലാതാക്കണമെന്ന് ഉറപ്പാണോ? ഈ പ്രവർത്തനം പഴയപടിയാക്കാനാകില്ല.';
  }

  @override
  String get profDelete => 'ഇല്ലാതാക്കുക';

  @override
  String profFailedToUpdateArea(String error) {
    return 'ഏരിയ അപ്ഡേറ്റ് ചെയ്യാനായില്ല: $error';
  }

  @override
  String get profAreaAssociation => 'ഏരിയ / അസോസിയേഷൻ';

  @override
  String get profUnableToLoadAreas => 'ഏരിയകൾ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get profNoAreasTapToAdd =>
      'ഏരിയകൾ ഇല്ല — ഒന്ന് ചേർക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get profNone => 'ഒന്നുമില്ല';

  @override
  String profOrderNumber(String id) {
    return 'ഓർഡർ #$id';
  }

  @override
  String get profSave => 'സംരക്ഷിക്കുക';

  @override
  String profError(String error) {
    return 'പിശക്: $error';
  }

  @override
  String get profBasicInformation => 'അടിസ്ഥാന വിവരം';

  @override
  String get profStoreName => 'സ്റ്റോർ പേര്';

  @override
  String get profStoreType => 'സ്റ്റോർ തരം (ഉദാ. കിരാന, സൂപ്പർമാർക്കറ്റ്)';

  @override
  String get profBusinessIntelligence => 'ബിസിനസ് ഇന്റലിജൻസ്';

  @override
  String get profFootfallAutoComputed =>
      'ശരാശരി ഉപഭോക്തൃ വരവ് നിങ്ങളുടെ വിൽപ്പന അടിസ്ഥാനമാക്കി സ്വയമേവ കണക്കാക്കുന്നു.';

  @override
  String get profProvideInitialValues =>
      'നിങ്ങളുടെ ബിസിനസ് ഒപ്റ്റിമൈസ് ചെയ്യാൻ ഞങ്ങളുടെ AI യെ സഹായിക്കാൻ പ്രാരംഭ മൂല്യങ്ങൾ നൽകുക.';

  @override
  String get profAvgDailyFootfall => 'ശരാശരി ദൈനംദിന ഉപഭോക്തൃ വരവ്';

  @override
  String get profAiAutoUpdating => 'AI സ്വയം-അപ്ഡേറ്റ്';

  @override
  String get profMonthlyStockBudget => 'പ്രതിമാസ സ്റ്റോക്ക് ബജറ്റ്';

  @override
  String get profDailyExpenseBuffer => 'ദൈനംദിന ചെലവ് ബഫർ';

  @override
  String get profLocationDetails => 'ലൊക്കേഷൻ വിശദാംശങ്ങൾ';

  @override
  String get profCityArea => 'നഗരം / ഏരിയ';

  @override
  String get profStateRegion => 'സംസ്ഥാനം / പ്രദേശം';

  @override
  String get profCity => 'നഗരം';

  @override
  String get profBusinessVertical => 'ബിസിനസ് വിഭാഗം';

  @override
  String get profRequired => 'ആവശ്യമാണ്';

  @override
  String get profSettingsSaved => 'ക്രമീകരണങ്ങൾ വിജയകരമായി സംരക്ഷിച്ചു!';

  @override
  String profFailedToSave(String error) {
    return 'സംരക്ഷിക്കാനായില്ല: $error';
  }

  @override
  String get supSplashTagline => 'സ്മാർട്ട് ബിസിനസ്, സ്മാർട്ടർ നിങ്ങൾ';

  @override
  String get supBlockedAppTitle => 'ആപ്പ് താൽക്കാലികമായി ലഭ്യമല്ല';

  @override
  String get supBlockedStoreTitle => 'സ്റ്റോർ താൽക്കാലികമായി ലഭ്യമല്ല';

  @override
  String get supBlockedBody =>
      'ഇത് എത്രയും വേഗം പരിഹരിക്കാൻ ഞങ്ങൾ പ്രവർത്തിക്കുന്നു. നിങ്ങൾക്ക് ഉടനടി സഹായം വേണമെങ്കിൽ, ചുവടെയുള്ള ബട്ടൺ ടാപ്പ് ചെയ്യുക.';

  @override
  String get supBlockedContactUs => 'ഞങ്ങളെ ബന്ധപ്പെടുക';

  @override
  String get supBlockedEmailSubjectApp => 'ആപ്പ് ആക്സസ് പ്രശ്നം — Outlet AI';

  @override
  String get supBlockedEmailSubjectStore =>
      'സ്റ്റോർ ആക്സസ് പ്രശ്നം — Outlet AI';

  @override
  String supBlockedEmailBody(String reason) {
    return 'ഹലോ LohiyaAI ടീം,\n\nഎനിക്ക് Outlet AI ആപ്പ് ആക്സസ് ചെയ്യാൻ കഴിയുന്നില്ല.\n\nപ്രദർശിപ്പിച്ച കാരണം: $reason\n\nആക്സസ് പുനഃസ്ഥാപിക്കാൻ എന്നെ സഹായിക്കുക.\n\n— കിരാന ഉടമ';
  }

  @override
  String get supBlockedEmailFallback =>
      'ദയവായി support@lohiyaai.com ലേക്ക് നേരിട്ട് ഇമെയിൽ ചെയ്യുക.';

  @override
  String get supSupportTitle => 'സഹായം & പിന്തുണ';

  @override
  String get supSupportHeading => 'ഞങ്ങൾ നിങ്ങളെ എങ്ങനെ സഹായിക്കും?';

  @override
  String get supSupportSubheading =>
      'നിങ്ങളുടെ ചോദ്യങ്ങൾക്ക് തൽക്ഷണ ഉത്തരങ്ങൾ നേടുക';

  @override
  String get supOptionFaqTitle => 'പതിവായി ചോദിക്കുന്ന ചോദ്യങ്ങൾ';

  @override
  String get supOptionFaqSubtitle => 'സാധാരണ ചോദ്യങ്ങളും ഉത്തരങ്ങളും';

  @override
  String get supOptionReportTitle => 'ഒരു പ്രശ്നം റിപ്പോർട്ട് ചെയ്യുക';

  @override
  String get supOptionReportSubtitle => 'ഒരു ബഗ് നേരിട്ടോ? ഞങ്ങളെ അറിയിക്കുക';

  @override
  String get supOptionChatTitle => 'ഞങ്ങളുമായി ചാറ്റ് ചെയ്യുക';

  @override
  String get supOptionChatSubtitle => 'ഞങ്ങളുടെ പിന്തുണാ ടീമുമായി ബന്ധപ്പെടുക';

  @override
  String get supOptionEmailTitle => 'ഇമെയിൽ പിന്തുണ';

  @override
  String get supOptionEmailSubtitle =>
      'ഞങ്ങൾക്ക് നേരിട്ട് ഒരു ഇമെയിൽ അയയ്ക്കുക';

  @override
  String get supChatComingSoon => 'ചാറ്റ് പിന്തുണ ഉടൻ വരുന്നു!';

  @override
  String get supEmailUnableToOpen => 'ഇമെയിൽ ആപ്പ് തുറക്കാനായില്ല.';

  @override
  String get supEmailError =>
      'ഇമെയിൽ ആപ്പ് തുറക്കുമ്പോൾ എന്തോ പിഴവ് സംഭവിച്ചു.';

  @override
  String get supFaqTitle => 'പതിവുചോദ്യങ്ങൾ';

  @override
  String get supFaqQ1 => 'പുതിയ ഉൽപ്പന്നം എങ്ങനെ ചേർക്കാം?';

  @override
  String get supFaqA1 =>
      'POS ടാബിൽ + ബട്ടൺ ക്ലിക്ക് ചെയ്തോ ഇൻവെന്ററി ടാബിൽ നിന്നോ ഉൽപ്പന്നങ്ങൾ ചേർക്കാം. ലഭ്യമാണെങ്കിൽ വിശദാംശങ്ങൾ സ്വയമേവ ലഭിക്കാൻ ബാർകോഡ് സ്കാൻ ചെയ്യാം.';

  @override
  String get supFaqQ2 =>
      'സ്റ്റോക്ക്ഔട്ട് റിസ്ക് പ്രവചനം എങ്ങനെ പ്രവർത്തിക്കുന്നു?';

  @override
  String get supFaqA2 =>
      'ഞങ്ങളുടെ AI നിങ്ങളുടെ മുൻ വിൽപ്പന വേഗതയും നിലവിലെ സ്റ്റോക്ക് നിലവാരവും വിശകലനം ചെയ്യുന്നു. അടുത്ത 3-7 ദിവസത്തിനുള്ളിൽ ഒരു ഇനം തീരുമെന്ന് പ്രവചിച്ചാൽ, അത് സ്റ്റോക്ക്ഔട്ട് റിസ്ക് ആയി അടയാളപ്പെടുത്തുന്നു.';

  @override
  String get supFaqQ3 => 'ഉപഭോക്തൃ ക്രെഡിറ്റ് (ഖാത) എങ്ങനെ കൈകാര്യം ചെയ്യാം?';

  @override
  String get supFaqA3 =>
      'ഓർഡർ ചെയ്യുമ്പോൾ, ഒരു ഉപഭോക്താവിനെ തിരഞ്ഞെടുത്ത് പേയ്മെന്റ് രീതിയായി \"ക്രെഡിറ്റ്\" തിരഞ്ഞെടുക്കുക. എല്ലാ കുടിശ്ശികയും ഫിനാൻസ് -> ഉധാർ ടാബിലോ ഉപഭോക്തൃ ബന്ധങ്ങൾ വിഭാഗത്തിലോ കാണാം.';

  @override
  String get supFaqQ4 => 'എന്റെ ഫോൺ കോൺടാക്റ്റുകൾ സിങ്ക് ചെയ്യാമോ?';

  @override
  String get supFaqA4 =>
      'അതെ! പ്രൊഫൈൽ -> ഉപഭോക്തൃ ബന്ധങ്ങളിലേക്ക് പോയി സിങ്ക് ഐക്കൺ ക്ലിക്ക് ചെയ്യുക. ഇത് എളുപ്പമുള്ള ക്രെഡിറ്റ് ട്രാക്കിംഗിനായി നിങ്ങളുടെ സ്ഥിരം ഉപഭോക്താക്കളെ ആപ്പിലേക്ക് ഇമ്പോർട്ട് ചെയ്യും.';

  @override
  String get supFaqQ5 => 'KPI സബ്സ്ക്രിപ്ഷനുകൾ എന്തൊക്കെയാണ്?';

  @override
  String get supFaqA5 =>
      'KPI-കൾ വരുമാനം, മാർജിൻ, ഉപഭോക്തൃ വരവ് പോലുള്ള പ്രധാന ബിസിനസ് മെട്രിക്സ് ആണ്. പ്രൊഫൈൽ -> സബ്സ്ക്രിപ്ഷൻ വിഭാഗത്തിൽ നിന്ന് ഏതൊക്കെ മെട്രിക്സ് നിരീക്ഷിക്കണമെന്ന് തിരഞ്ഞെടുക്കാം.';

  @override
  String get supFaqQ6 => 'ദൈനംദിന വിൽപ്പന റിപ്പോർട്ട് എങ്ങനെ ഉണ്ടാക്കാം?';

  @override
  String get supFaqA6 =>
      'ഇന്നത്തെ പ്രകടനം ഡാഷ്ബോർഡിൽ കാണാം. വിശദമായ മുൻ റിപ്പോർട്ടുകൾക്ക്, നിങ്ങളുടെ പ്രൊഫൈലിലെ ഇടപാട് ചരിത്രം വിഭാഗം സന്ദർശിക്കുക.';

  @override
  String get supReportTitle => 'ഒരു പ്രശ്നം റിപ്പോർട്ട് ചെയ്യുക';

  @override
  String get supReportHeading => 'പ്രശ്നം വിവരിക്കുക';

  @override
  String get supReportSubheading =>
      'ഞങ്ങളുടെ ടീം നിങ്ങളുടെ റിപ്പോർട്ട് അവലോകനം ചെയ്ത് എത്രയും വേഗം പരിഹരിക്കും.';

  @override
  String get supReportCategoryLabel => 'പ്രശ്ന വിഭാഗം';

  @override
  String get supReportSummaryLabel => 'ഹ്രസ്വ സംഗ്രഹം';

  @override
  String get supReportSummaryHint =>
      'ഉദാ. ബാർകോഡ് സ്കാൻ ചെയ്യുമ്പോൾ ആപ്പ് ക്രാഷ് ആകുന്നു';

  @override
  String get supReportDescriptionLabel => 'വിശദമായ വിവരണം';

  @override
  String get supReportDescriptionHint =>
      'പ്രശ്നം എങ്ങനെ ആവർത്തിക്കാമെന്നതിന്റെ വിശദാംശങ്ങൾ നൽകുക...';

  @override
  String get supReportSubmit => 'റിപ്പോർട്ട് സമർപ്പിക്കുക';

  @override
  String get supReportFillFields => 'ദയവായി എല്ലാ ഫീൽഡുകളും പൂരിപ്പിക്കുക';

  @override
  String get supReportSubmittedTitle => 'റിപ്പോർട്ട് സമർപ്പിച്ചു';

  @override
  String get supReportSubmittedBody =>
      'നിങ്ങളുടെ പ്രതികരണത്തിന് നന്ദി. ഞങ്ങളുടെ ടീം അത് ഉടനടി പരിശോധിക്കും.';

  @override
  String get supOk => 'ശരി';

  @override
  String supReportSubmitFailed(String error) {
    return 'റിപ്പോർട്ട് സമർപ്പിക്കാനായില്ല: $error';
  }

  @override
  String get supCategoryAppBug => 'ആപ്പ് ബഗ്';

  @override
  String get supCategoryPricing => 'വിലനിർണ്ണയ പ്രശ്നം';

  @override
  String get supCategoryInventory => 'ഇൻവെന്ററി പൊരുത്തക്കേട്';

  @override
  String get supCategoryAiFeedback => 'AI ശുപാർശ ഫീഡ്ബാക്ക്';

  @override
  String get supCategoryPosError => 'POS പിശക്';

  @override
  String get supCategoryFeatureRequest => 'ഫീച്ചർ അഭ്യർത്ഥന';

  @override
  String get supCategoryOther => 'മറ്റുള്ളവ';

  @override
  String get shrSavingChanges => 'മാറ്റങ്ങൾ സംരക്ഷിക്കുന്നു...';

  @override
  String get shrRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get shrSavedSuccessfully => 'വിജയകരമായി സംരക്ഷിച്ചു!';

  @override
  String get shrBusinessAlerts => 'ബിസിനസ് അലേർട്ടുകൾ';

  @override
  String get shrAllCaughtUp => 'എല്ലാം പൂർത്തിയായി!';

  @override
  String get shrNoUrgentAlerts => 'ഇപ്പോൾ അടിയന്തര അലേർട്ടുകൾ ഇല്ല.';

  @override
  String get shrAlertOutOfStock => 'സ്റ്റോക്ക് തീർന്നു';

  @override
  String get shrAlertLowStock => 'കുറഞ്ഞ സ്റ്റോക്ക്';

  @override
  String get shrAlertExpiringSoon => 'ഉടൻ കാലഹരണപ്പെടുന്നു';

  @override
  String get shrAlertOverdueUdhaar => 'ദീർഘകാലം കുടിശ്ശികയായ ഉധാർ';

  @override
  String get shrAlertOverduePayment => 'കാലാവധി കഴിഞ്ഞ പേയ്മെന്റ്';

  @override
  String get shrAlertUpcomingPayment => 'വരാനിരിക്കുന്ന പേയ്മെന്റ്';

  @override
  String shrMsgOutOfStock(String name) {
    return '$name പൂർണ്ണമായും സ്റ്റോക്കിൽ ഇല്ല.';
  }

  @override
  String shrMsgLowStock(String name, String stock) {
    return '$name കുറയുന്നു ($stock).';
  }

  @override
  String shrMsgExpiringSoon(String name, int days) {
    return '$name $days ദിവസത്തിനുള്ളിൽ കാലഹരണപ്പെടുന്നു.';
  }

  @override
  String shrMsgOverdueUdhaar(String name, String amount, int days) {
    return '$name $days ദിവസമായി ₹$amount കുടിശ്ശികയുണ്ട്.';
  }

  @override
  String shrMsgPaymentOverdue(String amount, String supplier) {
    return '$supplier ന് ₹$amount കാലാവധി കഴിഞ്ഞു.';
  }

  @override
  String shrMsgPaymentDue(String amount, String supplier, int days) {
    return '$supplier ന് ₹$amount $days ദിവസത്തിനുള്ളിൽ അടയ്ക്കണം.';
  }

  @override
  String psetErrorWith(String error) {
    return 'പിശക്: $error';
  }

  @override
  String get psetCancel => 'റദ്ദാക്കുക';

  @override
  String get psetReset => 'പുനഃസജ്ജമാക്കുക';

  @override
  String get psetUserActivity => 'ഉപയോക്തൃ പ്രവർത്തനം';

  @override
  String get psetNoUsersFound => 'ഉപയോക്താക്കളെ കണ്ടെത്തിയില്ല';

  @override
  String get psetNoStore => 'സ്റ്റോർ ഇല്ല';

  @override
  String get psetNever => 'ഒരിക്കലുമില്ല';

  @override
  String get psetActiveToday => 'ഇന്ന് സജീവം';

  @override
  String get psetInactive => 'നിഷ്ക്രിയം';

  @override
  String get psetLastSeen => 'അവസാനം കണ്ടത്';

  @override
  String get psetOpensToday => 'ഇന്ന് തുറന്നത്';

  @override
  String get psetTimeInApp => 'ആപ്പിലെ സമയം';

  @override
  String get psetSalesToday => 'ഇന്ന് വിൽപ്പന';

  @override
  String get psetJustNow => 'ഇപ്പോൾ തന്നെ';

  @override
  String psetMinsAgo(int m) {
    return '$mമി മുമ്പ്';
  }

  @override
  String psetHoursAgo(int h) {
    return '$hമ മുമ്പ്';
  }

  @override
  String psetDaysAgo(int d) {
    return '$dദി മുമ്പ്';
  }

  @override
  String get psetPasswordSecurity => 'പാസ്‌വേഡ് & സുരക്ഷ';

  @override
  String psetCouldNotLoadStatus(String error) {
    return 'സ്റ്റാറ്റസ് ലോഡ് ചെയ്യാനായില്ല: $error';
  }

  @override
  String get psetEnterNewPassword => 'ഒരു പുതിയ പാസ്‌വേഡ് നൽകുക';

  @override
  String get psetPasswordMin6 =>
      'പാസ്‌വേഡ് കുറഞ്ഞത് 6 പ്രതീകങ്ങൾ ഉണ്ടായിരിക്കണം';

  @override
  String get psetPasswordsNoMatch => 'പാസ്‌വേഡുകൾ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get psetEnterCurrentPassword => 'നിങ്ങളുടെ നിലവിലെ പാസ്‌വേഡ് നൽകുക';

  @override
  String get psetPasswordUpdated => 'പാസ്‌വേഡ് വിജയകരമായി അപ്ഡേറ്റ് ചെയ്തു.';

  @override
  String get psetPasswordCreated => 'പാസ്‌വേഡ് വിജയകരമായി സൃഷ്ടിച്ചു.';

  @override
  String get psetCouldNotConnect =>
      'സെർവറുമായി ബന്ധിപ്പിക്കാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get psetSomethingWrong => 'എന്തോ പിഴവ് സംഭവിച്ചു';

  @override
  String get psetPasswordSet => 'പാസ്‌വേഡ് സജ്ജമാക്കി';

  @override
  String get psetNoPasswordYet => 'ഇതുവരെ പാസ്‌വേഡ് ഇല്ല';

  @override
  String psetLastChanged(String date) {
    return 'അവസാനം മാറ്റിയത് $date';
  }

  @override
  String get psetPasswordActive => 'പാസ്‌വേഡ് സജീവമാണ്';

  @override
  String get psetCreatePasswordHint =>
      'ഉപയോക്തൃനാമം ലോഗിൻ പ്രവർത്തനക്ഷമമാക്കാൻ ഒരു പാസ്‌വേഡ് സൃഷ്ടിക്കുക';

  @override
  String psetPasswordCooldown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ദിവസത്തിനുള്ളിൽ',
      one: '1 ദിവസത്തിനുള്ളിൽ',
    );
    return '$_temp0 നിങ്ങളുടെ പാസ്‌വേഡ് വീണ്ടും മാറ്റാം.';
  }

  @override
  String get psetChangePassword => 'പാസ്‌വേഡ് മാറ്റുക';

  @override
  String get psetCreatePassword => 'പാസ്‌വേഡ് സൃഷ്ടിക്കുക';

  @override
  String get psetChangeSubtitle =>
      'നിങ്ങളുടെ നിലവിലെ പാസ്‌വേഡ് നൽകുക, പിന്നെ ഒരു പുതിയത് തിരഞ്ഞെടുക്കുക.';

  @override
  String get psetCreateSubtitle =>
      'നിങ്ങളുടെ ഉപയോക്തൃനാമം ഉപയോഗിച്ച് ലോഗിൻ ചെയ്യാൻ ഒരു പാസ്‌വേഡ് സജ്ജമാക്കുക.';

  @override
  String get psetCurrentPassword => 'നിലവിലെ പാസ്‌വേഡ്';

  @override
  String get psetNewPassword => 'പുതിയ പാസ്‌വേഡ്';

  @override
  String get psetConfirmNewPassword => 'പുതിയ പാസ്‌വേഡ് സ്ഥിരീകരിക്കുക';

  @override
  String get psetUpdatePassword => 'പാസ്‌വേഡ് അപ്ഡേറ്റ് ചെയ്യുക';

  @override
  String get psetPasswordCooldownNote =>
      'പാസ്‌വേഡ് 14 ദിവസത്തിലൊരിക്കൽ മാത്രമേ മാറ്റാൻ കഴിയൂ.';

  @override
  String get psetAllHistory => 'എല്ലാ ചരിത്രവും';

  @override
  String get psetTabPurchases => 'പർച്ചേസുകൾ';

  @override
  String get psetTabPosOrders => 'POS ഓർഡറുകൾ';

  @override
  String get psetNoPurchaseHistory => 'പർച്ചേസ് ചരിത്രമൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get psetViewBill => 'ബിൽ കാണുക';

  @override
  String get psetPurchaseDetails => 'പർച്ചേസ് വിശദാംശങ്ങൾ';

  @override
  String psetFromSupplier(String supplier) {
    return '$supplier ൽ നിന്ന്';
  }

  @override
  String psetQtyTimes(String qty, String price) {
    return 'അളവ്: $qty × ₹$price';
  }

  @override
  String get psetTotalAmount => 'ആകെ തുക';

  @override
  String get psetSalesTxnHistory => 'വിൽപ്പന ഇടപാട് ചരിത്രം';

  @override
  String get psetSalesTxnDesc =>
      'നിങ്ങളുടെ എല്ലാ POS ഓർഡറുകളും പേയ്മെന്റുകളും ഉപഭോക്തൃ ഇടപാടുകളും കാണുകയും ഫിൽട്ടർ ചെയ്യുകയും ചെയ്യുക.';

  @override
  String get psetOpenSalesHistory => 'വിൽപ്പന ചരിത്രം തുറക്കുക';

  @override
  String get psetSettingsSaved => 'ക്രമീകരണങ്ങൾ സംരക്ഷിച്ചു';

  @override
  String psetSaveFailed(String error) {
    return 'സംരക്ഷിക്കൽ പരാജയപ്പെട്ടു: $error';
  }

  @override
  String get psetResetToDefaults => 'ഡിഫോൾട്ടിലേക്ക് പുനഃസജ്ജമാക്കുക';

  @override
  String get psetResetConfirm =>
      'എല്ലാ ക്രമീകരണങ്ങളും അവയുടെ ഡിഫോൾട്ട് മൂല്യങ്ങളിലേക്ക് പുനഃസജ്ജമാക്കും.';

  @override
  String get psetConfiguration => 'കോൺഫിഗറേഷൻ';

  @override
  String get psetPosPreferences => 'POS മുൻഗണനകൾ';

  @override
  String get psetAiForecasting => 'AI & പ്രവചനം';

  @override
  String get psetAlertThresholds => 'അലേർട്ട് പരിധികൾ';

  @override
  String get psetMarketing => 'മാർക്കറ്റിംഗ്';

  @override
  String get psetNotifications => 'അറിയിപ്പുകൾ';

  @override
  String get psetDefaultPayment => 'ഡിഫോൾട്ട് പേയ്മെന്റ് രീതി';

  @override
  String get psetDefaultPaymentHint =>
      'പുതിയ വിൽപ്പന ചേർക്കുമ്പോൾ മുൻകൂട്ടി തിരഞ്ഞെടുത്ത രീതി';

  @override
  String get psetCash => 'പണം';

  @override
  String get psetCard => 'കാർഡ്';

  @override
  String get psetForecastHorizon => 'പ്രവചന കാലയളവ്';

  @override
  String get psetForecastHorizonHint =>
      'AI എത്ര ദിവസം മുമ്പ് സ്റ്റോക്ക് ആവശ്യങ്ങൾ പ്രവചിക്കുന്നു';

  @override
  String psetDaysValue(int days) {
    return '$days ദിവസം';
  }

  @override
  String get psetStockoutRisk => 'സ്റ്റോക്ക്ഔട്ട് റിസ്ക് പരിധി';

  @override
  String get psetStockoutRiskHint =>
      '7-ദിവസ റിസ്ക് ഇത് കവിയുമ്പോൾ സ്റ്റോക്ക്ഔട്ട് അലേർട്ട് കാണിക്കുക';

  @override
  String get psetMinVelocity => 'കുറഞ്ഞ വേഗത പരിധി';

  @override
  String get psetMinVelocityHint =>
      'ഇതിനെക്കാൾ പതുക്കെ വിൽക്കുന്ന ഇനങ്ങൾ ഡെഡ് സ്റ്റോക്ക് ആയി അടയാളപ്പെടുത്തും';

  @override
  String get psetReorderAlertDays => 'റീഓർഡർ അലേർട്ട് ദിവസങ്ങൾ';

  @override
  String get psetReorderAlertHint =>
      'പ്രതീക്ഷിത സ്റ്റോക്ക് N ദിവസത്തിനുള്ളിൽ തീരുമ്പോൾ അലേർട്ട് ചെയ്യുക';

  @override
  String get psetDeadStockDays => 'ഡെഡ് സ്റ്റോക്ക് ദിവസങ്ങൾ';

  @override
  String get psetDeadStockHint =>
      'N അല്ലെങ്കിൽ അതിലധികം ദിവസം വിൽപ്പനയില്ലാത്ത ഇനങ്ങൾ അടയാളപ്പെടുത്തുക';

  @override
  String get psetExpiryAlertDays => 'കാലഹരണ അലേർട്ട് ദിവസങ്ങൾ';

  @override
  String get psetExpiryAlertHint =>
      'ഒരു ബാച്ച്/ഇനം കാലഹരണപ്പെടുന്നതിന് ഇത്രയും ദിവസം മുമ്പ് അലേർട്ട് ചെയ്യുക';

  @override
  String psetDaysBeforeValue(int days) {
    return '$days ദിവസം മുമ്പ്';
  }

  @override
  String get psetAllowMarketing =>
      'എന്റെ സ്റ്റോർ മാർക്കറ്റ് ചെയ്യാൻ LohiyaAI യെ അനുവദിക്കുക';

  @override
  String get psetAllowMarketingHint =>
      'നിങ്ങൾക്ക് വേണ്ടി Facebook, Instagram & WhatsApp എന്നിവയിൽ നിങ്ങളുടെ സ്റ്റോർ പ്രമോട്ട് ചെയ്യുന്നു';

  @override
  String get psetInAppAlerts => 'ഇൻ-ആപ്പ് അലേർട്ടുകൾ';

  @override
  String get psetInAppAlertsHint => 'ആപ്പിനുള്ളിൽ അലേർട്ടുകൾ കാണിക്കുക';

  @override
  String get psetWhatsappNotif => 'WhatsApp അറിയിപ്പുകൾ';

  @override
  String get psetWhatsappNotifHint =>
      'റീസ്റ്റോക്കിംഗ്, ഉധാർ അലേർട്ടുകൾ WhatsApp വഴി അയയ്ക്കുക';

  @override
  String get psetQuietHours => 'നിശ്ശബ്ദ സമയം';

  @override
  String get psetQuietHoursHint => 'ഈ സമയത്ത് അറിയിപ്പുകളൊന്നും അയയ്ക്കില്ല';

  @override
  String get psetStart => 'ആരംഭം';

  @override
  String get psetEnd => 'അവസാനം';

  @override
  String get psetSaveChanges => 'മാറ്റങ്ങൾ സംരക്ഷിക്കുക';

  @override
  String get psetCashflowSupport => 'ക്യാഷ്ഫ്ലോ പിന്തുണ';

  @override
  String get psetRequestUnderReview => 'അഭ്യർത്ഥന അവലോകനത്തിലാണ്';

  @override
  String psetReqProcessingFull(String amount, String bank) {
    return '$bank വഴി ₹$amount ന്റെ നിങ്ങളുടെ ക്യാഷ്ഫ്ലോ അഭ്യർത്ഥന പ്രോസസ്സ് ചെയ്യുന്നു.\n\nഞങ്ങളുടെ ടീം 2 പ്രവൃത്തി ദിവസത്തിനുള്ളിൽ നിങ്ങളെ ബന്ധപ്പെടും.';
  }

  @override
  String get psetReqProcessing =>
      'നിങ്ങളുടെ ക്യാഷ്ഫ്ലോ അഭ്യർത്ഥന പ്രോസസ്സ് ചെയ്യുന്നു.\n\nഞങ്ങളുടെ ടീം 2 പ്രവൃത്തി ദിവസത്തിനുള്ളിൽ നിങ്ങളെ ബന്ധപ്പെടും.';

  @override
  String get psetRequestSubmitted => 'അഭ്യർത്ഥന സമർപ്പിച്ചു!';

  @override
  String get psetRequestSubmittedBody =>
      'നിങ്ങളുടെ ക്യാഷ്ഫ്ലോ അഭ്യർത്ഥന ഞങ്ങൾക്ക് ലഭിച്ചു.\nഞങ്ങളുടെ ടീം\n2 പ്രവൃത്തി ദിവസത്തിനുള്ളിൽ നിങ്ങളെ ബന്ധപ്പെടും.';

  @override
  String get psetBackToProfile => 'പ്രൊഫൈലിലേക്ക് മടങ്ങുക';

  @override
  String get psetApplyCashflow => 'ക്യാഷ്ഫ്ലോ പിന്തുണയ്ക്കായി\nഅപേക്ഷിക്കുക';

  @override
  String get psetCashflowSubtitle =>
      'വേഗത്തിലുള്ള ബിസിനസ് ഫിനാൻസ്, LohiyaAI പങ്കാളികളുടെ പിന്തുണയോടെ.';

  @override
  String get psetYourBusinessProfile => 'നിങ്ങളുടെ ബിസിനസ് പ്രൊഫൈൽ';

  @override
  String get psetStore => 'സ്റ്റോർ';

  @override
  String get psetLocation => 'ലൊക്കേഷൻ';

  @override
  String get psetDailyFootfall => 'ദൈനംദിന ഉപഭോക്തൃ വരവ്';

  @override
  String psetCustomersPerDay(int count) {
    return '$count ഉപഭോക്താക്കൾ/ദിവസം';
  }

  @override
  String get psetHowMuchNeed => 'നിങ്ങൾക്ക് എത്ര വേണം?';

  @override
  String get psetDragToSelect =>
      'തിരഞ്ഞെടുക്കാൻ വലിക്കുക — ₹50,000 മുതൽ ₹10,00,000 വരെ';

  @override
  String get psetLoanAmount => 'വായ്പ തുക';

  @override
  String get psetChoosePartnerBank => 'ഒരു പങ്കാളി ബാങ്ക് തിരഞ്ഞെടുക്കുക';

  @override
  String get psetSelectBankHint =>
      'നിങ്ങളുടെ അഭ്യർത്ഥനയുമായി മുന്നോട്ട് പോകാൻ ഒരു ബാങ്ക് തിരഞ്ഞെടുക്കുക.';

  @override
  String get psetSubmitRequest => 'അഭ്യർത്ഥന സമർപ്പിക്കുക';

  @override
  String get psetSubmitDisclaimer =>
      'സമർപ്പിക്കുന്നതിലൂടെ, ഈ അഭ്യർത്ഥന സംബന്ധിച്ച് ഞങ്ങളുടെ ടീം ബന്ധപ്പെടാൻ നിങ്ങൾ സമ്മതിക്കുന്നു.';

  @override
  String get psetBankSbiDesc =>
      'ചെറുകിട ബിസിനസുകൾക്കുള്ള സർക്കാർ പിന്തുണയുള്ള പദ്ധതി';

  @override
  String get psetBankHdfcDesc => 'റീട്ടെയിൽ വളർച്ചയ്ക്കായി വേഗത്തിലുള്ള വിതരണം';

  @override
  String get psetBankIciciDesc => 'കിരാന ഉടമകൾക്കുള്ള ഫ്ലെക്സിബിൾ ക്രെഡിറ്റ്';

  @override
  String get psetBankAxisDesc =>
      'റീട്ടെയിൽ സ്റ്റോറുകൾക്കായി ഇഷ്ടാനുസൃത ഫിനാൻസ്';

  @override
  String get widgetTitleSales => 'ഇന്നത്തെ വിൽപ്പന';

  @override
  String get widgetTitleUdhaar => 'ഉധാർ കുടിശ്ശിക';

  @override
  String get widgetTitleLowStock => 'കുറഞ്ഞ സ്റ്റോക്ക്';

  @override
  String get widgetTitlePayToday => 'ഇന്ന് അടയ്ക്കുക';

  @override
  String get widgetNewBill => '+ പുതിയ ബിൽ';

  @override
  String get widgetUnitOrders => 'ഓർഡറുകൾ';

  @override
  String get widgetUnitItems => 'ഇനങ്ങൾ';

  @override
  String get widgetUnitOverdue => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String get widgetUnitPending => 'തീർപ്പാക്കാത്തത്';

  @override
  String get widgetUnitToPay => 'അടയ്ക്കാൻ';

  @override
  String get widgetSignIn => 'സൈൻ ഇൻ ചെയ്യാൻ Outlet AI തുറക്കുക';

  @override
  String get widgetNoData => 'ഇന്നത്തെ കണക്കുകൾ ലോഡ് ചെയ്യാൻ ആപ്പ് തുറക്കുക';

  @override
  String get visionComingSoon => 'വിഷൻ AI ഉടൻ വരുന്നു!';

  @override
  String get mktTierBronze => 'Bronze';

  @override
  String get mktTierSilver => 'Silver';

  @override
  String get mktTierGold => 'Gold';

  @override
  String get mktTierPlatinum => 'Platinum';

  @override
  String get mktTierSettings => 'ടയർ ക്രമീകരണങ്ങൾ';

  @override
  String get mktShowArchived => 'ആർക്കൈവ് ചെയ്തവ കാണിക്കുക';

  @override
  String get mktHideArchived => 'ആർക്കൈവ് ചെയ്തവ മറയ്ക്കുക';

  @override
  String get mktArchived => 'ആർക്കൈവ് ചെയ്തു';

  @override
  String get mktEdit => 'എഡിറ്റ് ചെയ്യുക';

  @override
  String get mktAlertedToday => 'ഇന്ന് അറിയിച്ചു';

  @override
  String get mktRestore => 'പുനഃസ്ഥാപിക്കുക';

  @override
  String get mktArchive => 'ആർക്കൈവ് ചെയ്യുക';

  @override
  String get mktBasketArchived => 'ബാസ്കറ്റ് ആർക്കൈവ് ചെയ്തു';

  @override
  String get mktBasketRestored => 'ബാസ്കറ്റ് പുനഃസ്ഥാപിച്ചു';

  @override
  String get mktSomethingWentWrong =>
      'എന്തോ കുഴപ്പം സംഭവിച്ചു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get mktEditBasket => 'ബാസ്കറ്റ് എഡിറ്റ് ചെയ്യുക';

  @override
  String get mktSaveChanges => 'മാറ്റങ്ങൾ സംരക്ഷിക്കുക';

  @override
  String get mktAddItemsForPrice =>
      'ഓട്ടോ-ഡിസ്കൗണ്ട് ബണ്ടിൽ വില കാണാൻ ഇനങ്ങൾ ചേർക്കുക';

  @override
  String get mktItemsTotal => 'ഇനങ്ങളുടെ ആകെത്തുക';

  @override
  String get mktBundlePrice => 'ബണ്ടിൽ വില';

  @override
  String get mktTierConfigTitle => 'ബാസ്കറ്റ് ടയറുകൾ';

  @override
  String get mktTierConfigIntro =>
      'ബാസ്കറ്റുകൾക്ക് അവയുടെ മൊത്തം മൂല്യത്തിന്റെ അടിസ്ഥാനത്തിൽ സ്വയം വില നിശ്ചയിക്കപ്പെടുന്നു. ഓരോ ടയറിനും മൂല്യ പരിധിയും കിഴിവും സജ്ജമാക്കുക — ഇനങ്ങൾ ചേർക്കുമ്പോൾ പൊരുത്തപ്പെടുന്ന ടയറിന്റെ കിഴിവ് സ്വയമേവ ബാധകമാകും.';

  @override
  String get mktTierRangeInvalid =>
      'ഓരോ ടയറിന്റെയും പരിധി മുമ്പത്തേതിനേക്കാൾ കൂടുതലായിരിക്കണം, കിഴിവ് 0–100% ഇടയിൽ.';

  @override
  String get mktTiersSaved => 'ടയറുകൾ സംരക്ഷിച്ചു';

  @override
  String get mktRecomputeTitle => 'നിലവിലുള്ള ബാസ്കറ്റുകൾ വീണ്ടും കണക്കാക്കണോ?';

  @override
  String get mktKeepAsIs => 'ഉള്ളതുപോലെ വയ്ക്കുക';

  @override
  String get mktRecompute => 'വീണ്ടും കണക്കാക്കുക';

  @override
  String get mktSaveTiers => 'ടയറുകൾ സംരക്ഷിക്കുക';

  @override
  String get mktUpToLabel => 'വരെ';

  @override
  String get mktTopTierHint => 'മുമ്പത്തെ ടയറിന് മുകളിലുള്ളതെല്ലാം';

  @override
  String get mktDiscountLabel => 'കിഴിവ്';

  @override
  String get psetBasketTiers => 'ബാസ്കറ്റ് ടയറുകൾ';

  @override
  String get psetBasketTiersHint =>
      'മൂല്യത്തിന്റെ അടിസ്ഥാനത്തിൽ ബാസ്കറ്റുകൾക്ക് ഓട്ടോ-ഡിസ്കൗണ്ട്';

  @override
  String mktYouSave(String amount, String pct) {
    return '₹$amount ലാഭിക്കൂ ($pct% കിഴിവ്)';
  }

  @override
  String mktTierBasketLabel(String tier) {
    return '$tier ബാസ്കറ്റ്';
  }

  @override
  String mktPctOff(String pct) {
    return '$pct% കിഴിവ്';
  }

  @override
  String mktSaveAmount(String amount) {
    return '₹$amount ലാഭിക്കൂ';
  }

  @override
  String mktRecomputeBody(int count) {
    return '$count നിലവിലുള്ള ബാസ്കറ്റുകൾ പഴയ ടയറുകൾ പ്രകാരം വില നിശ്ചയിച്ചവയാണ്. അവയ്ക്കും പുതിയ ടയറുകൾ ബാധകമാക്കണോ?';
  }

  @override
  String mktBasketsRecomputed(int count) {
    return '$count ബാസ്കറ്റുകൾ പുതുക്കി';
  }

  @override
  String mktAboveAmount(String amount) {
    return '₹$amount മുകളിൽ';
  }

  @override
  String mktRangeAmount(String from, String to) {
    return '₹$from – ₹$to';
  }

  @override
  String get mktSaveAsBasket => 'ബാസ്കറ്റായി സംരക്ഷിക്കുക';

  @override
  String mktBasketSavedFromCampaign(String name) {
    return '\"$name\" നിങ്ങളുടെ ബാസ്കറ്റുകളിൽ സംരക്ഷിച്ചു';
  }

  @override
  String get mktSelectDate => 'തീയതി തിരഞ്ഞെടുക്കുക';

  @override
  String get mktBasketsProTitle => 'ബാസ്കറ്റുകൾ ഒരു Pro ഫീച്ചറാണ്';

  @override
  String get mktBasketsProDesc =>
      'ഓട്ടോമാറ്റിക് ടയർ കിഴിവുകളോടെ കോംബോ ഡീലുകൾ സൃഷ്ടിക്കുകയും ഉപഭോക്താക്കളെ WhatsApp‌ൽ അറിയിക്കുകയും ചെയ്യുക. ബാസ്കറ്റുകൾ അൺലോക്ക് ചെയ്യാൻ Pro‌യിലേക്ക് അപ്‌ഗ്രേഡ് ചെയ്യുക.';

  @override
  String get visionNavLabel => 'വിഷൻ';

  @override
  String get visionTitle => 'വിഷൻ';

  @override
  String get visionTabShelf => 'ഷെൽഫ് സ്കാൻ';

  @override
  String get visionTabResults => 'ഫലങ്ങൾ';

  @override
  String get visionTabCounter => 'കൗണ്ടർ';

  @override
  String get visionProTitle => 'വിഷൻ AI';

  @override
  String get visionProDesc =>
      'രാവിലെയും വൈകുന്നേരവും നിങ്ങളുടെ ഷെൽഫ് ഫോട്ടോ എടുക്കൂ — AI നിങ്ങളുടെ സ്റ്റോക്ക് എണ്ണി എന്താണ് വിറ്റതെന്ന് പറയും.';

  @override
  String get visionFromCamera => 'ഫോട്ടോ എടുക്കുക';

  @override
  String get visionFromGallery => 'ഗാലറിയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get visionMorningTitle => 'രാവിലെ — ദിവസത്തിന്റെ തുടക്കം';

  @override
  String get visionEveningTitle => 'വൈകുന്നേരം — ദിവസത്തിന്റെ അവസാനം';

  @override
  String get visionTakePhoto => 'ഫോട്ടോ എടുക്കുക';

  @override
  String get visionRetake => 'വീണ്ടും എടുക്കുക';

  @override
  String get visionReview => 'അവലോകനം';

  @override
  String get visionAnalyzing =>
      'ഷെൽഫ് വിശകലനം ചെയ്യുന്നു… ഇതിന് ഒരു മിനിറ്റ് വരെ എടുത്തേക്കാം';

  @override
  String get visionScanFailed =>
      'സ്കാൻ പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ഫോട്ടോ എടുക്കുക.';

  @override
  String get visionStillProcessing =>
      'നിങ്ങളുടെ ഫോട്ടോകൾ വിശകലനം ചെയ്യുന്നു — ഇതിന് കുറച്ച് മിനിറ്റ് എടുത്തേക്കാം. തയ്യാറാകുമ്പോൾ ഫലം ഇവിടെ കാണിക്കും.';

  @override
  String get visionCheckAgain => 'വീണ്ടും പരിശോധിക്കുക';

  @override
  String get visionNoPhotoYet => 'ഇതുവരെ ഫോട്ടോ എടുത്തിട്ടില്ല.';

  @override
  String get visionProductsIdentified => 'തിരിച്ചറിഞ്ഞ ഉൽപ്പന്നങ്ങൾ';

  @override
  String get visionUnitsCounted => 'എണ്ണിയ യൂണിറ്റുകൾ';

  @override
  String get visionNeedsReview => 'അവലോകനം വേണം';

  @override
  String get visionViewSales => 'ഇന്നത്തെ വിൽപ്പന കാണുക';

  @override
  String get visionTip =>
      'നുറുങ്ങ്: കട തുറക്കുന്നതിന് മുമ്പ് രാവിലെയും അടയ്ക്കുന്നതിന് മുമ്പ് വൈകുന്നേരവും ഫോട്ടോ എടുക്കുക. ഓരോ ഉൽപ്പന്നവും എത്ര വിറ്റു എന്ന് AI കണക്കാക്കും.';

  @override
  String get visionSalesEmpty =>
      'ഇന്ന് എന്ത് വിറ്റു എന്ന് കാണാൻ രാവിലെയും വൈകുന്നേരവും ഓരോ ഫോട്ടോ എടുക്കുക.';

  @override
  String get visionTotalSold => 'ആകെ വിറ്റ സാധനങ്ങൾ';

  @override
  String get visionSold => 'വിറ്റു';

  @override
  String get visionMorningCount => 'AM';

  @override
  String get visionEveningCount => 'PM';

  @override
  String get visionUnknownItem => 'അജ്ഞാതം — ശരിയാക്കാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get visionCorrected => 'ശരിയാക്കി';

  @override
  String get visionCorrectTitle => 'ഇത് ഏത് ഉൽപ്പന്നമാണ്?';

  @override
  String get visionSearchProducts => 'നിങ്ങളുടെ ഉൽപ്പന്നങ്ങൾ തിരയുക';

  @override
  String get visionClearCorrection => 'തിരുത്തൽ മായ്ക്കുക';

  @override
  String get visionNoProducts =>
      'ഇതുവരെ ഉൽപ്പന്നങ്ങൾ ലോഡ് ആയിട്ടില്ല. ഒരിക്കൽ ബില്ലിംഗ് ടാബ് തുറന്ന് തിരികെ വരൂ.';

  @override
  String get visionCounterSoonTitle => 'ലൈവ് കൗണ്ടർ — ഉടൻ വരുന്നു';

  @override
  String get visionCounterSoonDesc =>
      'ബില്ലിംഗ് കൗണ്ടറിലേക്ക് നിങ്ങളുടെ ഫോൺ ചൂണ്ടൂ, സാധനങ്ങൾ കടന്നുപോകുമ്പോൾ വിൽപ്പന സ്വയമേവ എണ്ണപ്പെടും. ഞങ്ങൾ ഇതിന് അവസാന മിനുക്കുപണികൾ നടത്തുകയാണ്.';

  @override
  String get visionCounterStartTitle => 'ലൈവ് സെയിൽ കൗണ്ടർ';

  @override
  String get visionCounterStartDesc =>
      'നിങ്ങളുടെ ഫോൺ ബില്ലിംഗ് കൗണ്ടറിന് നേരെ പിടിക്കുക. ലൈൻ കടക്കുന്ന വസ്തുക്കൾ സ്വയമേവ എണ്ണപ്പെടും — ബാർകോഡ് സ്കാനിംഗ് ഇല്ല.';

  @override
  String get visionCounterStart => 'എണ്ണം ആരംഭിക്കുക';

  @override
  String get visionCounterFinish => 'പൂർത്തിയാക്കുക';

  @override
  String get visionCounterPause => 'താൽക്കാലികമായി നിർത്തുക';

  @override
  String get visionCounterResume => 'തുടരുക';

  @override
  String get visionCounterUndo => 'പഴയപടിയാക്കുക';

  @override
  String get visionCounterFlip => 'വശം മാറ്റുക';

  @override
  String get visionCounterCounted => 'എണ്ണി';

  @override
  String get visionCounterNothingYet =>
      'വസ്തുക്കൾ എണ്ണാൻ അവയെ ലൈനിന് കുറുകെ നീക്കുക.';

  @override
  String get visionCounterHint =>
      'പച്ച മേഖലയിലേക്ക് കടക്കുന്ന വസ്തുക്കൾ വിറ്റതായി എണ്ണപ്പെടും.';

  @override
  String get visionCounterZoneStore => 'സ്റ്റോറിൽ';

  @override
  String get visionCounterZoneSold => 'വിറ്റു';

  @override
  String get visionCounterModelMissingTitle =>
      'കൗണ്ടർ മോഡൽ ഇൻസ്റ്റാൾ ചെയ്തിട്ടില്ല';

  @override
  String get visionCounterModelMissingDesc =>
      'ഓൺ-ഡിവൈസ് എണ്ണൽ മോഡൽ ഈ ബിൽഡിൽ ഇതുവരെ ഉൾപ്പെടുത്തിയിട്ടില്ല. ഇത് ഒരു അപ്ഡേറ്റിൽ വരുന്നു — ഷെൽഫ് സ്കാനിംഗ് ഇപ്പോഴും പ്രവർത്തിക്കുന്നു.';

  @override
  String get visionCounterPermTitle => 'ക്യാമറ ആക്സസ് ആവശ്യമാണ്';

  @override
  String get visionCounterPermDesc =>
      'ബില്ലിംഗ് കൗണ്ടറിൽ വസ്തുക്കൾ എണ്ണാൻ ക്യാമറ ആക്സസ് അനുവദിക്കുക.';

  @override
  String get visionCounterGrant => 'ക്യാമറ അനുവദിക്കുക';

  @override
  String get visionCounterOpenSettings => 'ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get visionCounterFinishConfirmTitle => 'എണ്ണം പൂർത്തിയാക്കണോ?';

  @override
  String get visionCounterFinishConfirmDesc =>
      'ഞങ്ങൾ ഇന്നത്തെ എണ്ണം സംരക്ഷിച്ച് നിങ്ങളുടെ കൗണ്ടർ സംഗ്രഹത്തിലേക്ക് ചേർക്കും.';

  @override
  String get visionCounterSave => 'എണ്ണം സംരക്ഷിക്കുക';

  @override
  String get visionCounterDiscard => 'ഉപേക്ഷിക്കുക';

  @override
  String get visionCounterKeepCounting => 'എണ്ണം തുടരുക';

  @override
  String get visionCounterSavedTitle => 'എണ്ണം സംരക്ഷിച്ചു';

  @override
  String visionCounterSaved(int count, int skus) {
    return '$skus ഉൽപ്പന്നങ്ങളിലായി $count വസ്തുക്കൾ സംരക്ഷിച്ചു.';
  }

  @override
  String get visionCounterOfflineNote =>
      'നിങ്ങളുടെ ഫോണിൽ സംരക്ഷിച്ചു. കൗണ്ടർ സേവനം ലഭ്യമാകുമ്പോൾ ഇത് സിങ്ക് ചെയ്യും.';

  @override
  String visionCounterPending(int count) {
    return '$count ഇതുവരെ സിങ്ക് ചെയ്തിട്ടില്ല';
  }

  @override
  String get visionCounterSummaryTitle => 'ഇന്നത്തെ കൗണ്ടർ എണ്ണം';

  @override
  String get visionCounterSummaryEmpty =>
      'ഇന്ന് ഒരു വസ്തുവും എണ്ണിയിട്ടില്ല. ആരംഭിക്കാൻ \'എണ്ണം ആരംഭിക്കുക\' ടാപ്പ് ചെയ്യുക.';

  @override
  String get visionCounterSummaryTotal => 'ഇന്ന് ആകെ എണ്ണിയത്';

  @override
  String get visionCounterUnknownItem => 'തിരിച്ചറിയാത്ത ഉൽപ്പന്നം';

  @override
  String get onbCtaTitle => 'നൂറുകണക്കിന് വസ്തുക്കൾ ഉണ്ടോ?';

  @override
  String get onbCtaSubtitle =>
      'നിങ്ങളുടെ ഷെൽഫുകൾ ഫോട്ടോ എടുക്കുക, ഞങ്ങൾ ഉൽപ്പന്നങ്ങൾ തിരിച്ചറിഞ്ഞ് നിങ്ങളുടെ ഇൻവെന്ററിയിലേക്ക് ചേർക്കും — ഓരോന്നും സ്കാൻ ചെയ്യേണ്ട ആവശ്യമില്ല.';

  @override
  String get onbCtaButton => 'നിങ്ങളുടെ ഷെൽഫുകൾ ഫോട്ടോ എടുക്കുക';

  @override
  String get onbCaptureTitle => 'നിങ്ങളുടെ ഷെൽഫുകൾ ഫോട്ടോ എടുക്കുക';

  @override
  String get onbCaptureHint =>
      'നിങ്ങളുടെ എല്ലാ ഷെൽഫുകളും ഉൾക്കൊള്ളുന്ന 3 മുതൽ 10 വരെ വ്യക്തമായ ഫോട്ടോകൾ എടുക്കുക. നല്ല വെളിച്ചം കൂടുതൽ ഉൽപ്പന്നങ്ങൾ തിരിച്ചറിയാൻ സഹായിക്കുന്നു.';

  @override
  String get onbTakePhoto => 'ഫോട്ടോ എടുക്കുക';

  @override
  String onbPhotosProgress(int count) {
    return '10-ൽ $count ഫോട്ടോകൾ';
  }

  @override
  String get onbMinPhotos => 'കുറഞ്ഞത് 3 ഫോട്ടോകൾ ചേർക്കുക';

  @override
  String get onbAnalyze => 'ഉൽപ്പന്നങ്ങൾ തിരിച്ചറിയുക';

  @override
  String get onbProcessingTitle =>
      'ഞങ്ങൾ നിങ്ങളുടെ ഷെൽഫ് ഫോട്ടോകൾ അവലോകനം ചെയ്യുന്നു';

  @override
  String get onbProcessingDesc =>
      'ഞങ്ങളുടെ സിസ്റ്റം നിങ്ങളുടെ ഷെൽഫിലെ ഉൽപ്പന്നങ്ങൾ തിരിച്ചറിയുന്നു. ഇതിന് സാധാരണയായി ഒരു മിനിറ്റിൽ താഴെ സമയമെടുക്കും. ദയവായി ഈ സ്ക്രീൻ തുറന്നിടുക — ഞങ്ങൾ ഫലങ്ങൾ ഉടൻ ഇവിടെ കാണിക്കും.';

  @override
  String get onbReviewTitle => 'നിങ്ങളുടെ സ്റ്റോക്ക് സ്ഥിരീകരിക്കുക';

  @override
  String get onbReviewDisclaimer =>
      'ഇവ നിങ്ങളുടെ ഫോട്ടോകളിൽ നിന്ന് ഞങ്ങൾ തിരിച്ചറിഞ്ഞ ഉൽപ്പന്നങ്ങളാണ്. ഞങ്ങൾ ചിലപ്പോൾ ഒരു വസ്തു നഷ്ടപ്പെടുത്തുകയോ തെറ്റായി വായിക്കുകയോ ചെയ്യാം, അതിനാൽ ദയവായി അളവുകൾ ക്രോസ്-ചെക്ക് ചെയ്ത് ക്രമീകരിക്കുക. ഞങ്ങൾ തുടർച്ചയായി ഞങ്ങളുടെ കൃത്യത മെച്ചപ്പെടുത്തുന്നു.';

  @override
  String onbReviewSummary(int mapped, int unmapped) {
    return '$mapped തയ്യാർ · $unmapped എണ്ണത്തിന് ഉൽപ്പന്നം വേണം';
  }

  @override
  String get onbUnrecognised =>
      'തിരിച്ചറിഞ്ഞില്ല — ഒരു ഉൽപ്പന്നം തിരഞ്ഞെടുക്കുക';

  @override
  String get onbChooseProduct => 'ഉൽപ്പന്നം തിരഞ്ഞെടുക്കുക';

  @override
  String get onbQuantity => 'എണ്ണം';

  @override
  String get onbCommit => 'എന്റെ ഇൻവെന്ററിയിലേക്ക് ചേർക്കുക';

  @override
  String get onbCommitting => 'നിങ്ങളുടെ ഇൻവെന്ററിയിലേക്ക് ചേർക്കുന്നു…';

  @override
  String get onbDoneTitle => 'സ്റ്റോക്ക് ചേർത്തു';

  @override
  String onbDoneDesc(int products, int units) {
    return '$products ഉൽപ്പന്നങ്ങൾ ($units വസ്തുക്കൾ) നിങ്ങളുടെ ഇൻവെന്ററിയിലേക്ക് ചേർത്തു. ഇൻവെന്ററി ടാബിൽ നിന്ന് എപ്പോൾ വേണമെങ്കിലും വിലകൾ സജ്ജമാക്കാം.';
  }

  @override
  String get onbEmptyDetected =>
      'ഈ ഫോട്ടോകളിൽ ഞങ്ങൾക്ക് ഉൽപ്പന്നങ്ങൾ തിരിച്ചറിയാനായില്ല. ദയവായി നല്ല വെളിച്ചത്തിൽ, പാക്കേജിംഗ് വ്യക്തമായി കാണിച്ച് വീണ്ടും ഫോട്ടോ എടുക്കുക.';

  @override
  String get onbRetake => 'ഫോട്ടോകൾ വീണ്ടും എടുക്കുക';

  @override
  String get onbFailedTitle => 'ഞങ്ങൾക്ക് പൂർത്തിയാക്കാനായില്ല';

  @override
  String get onbDone => 'പൂർത്തിയായി';

  @override
  String get onbRemove => 'നീക്കം ചെയ്യുക';

  @override
  String get visionAddPhotosTitle => 'ഷെൽഫ് ഫോട്ടോകൾ ചേർക്കുക';

  @override
  String get visionAddPhotosHint =>
      'നിങ്ങളുടെ ഷെൽഫുകൾ ഉൾപ്പെടുത്തി 3 മുതൽ 10 വരെ ഫോട്ടോകൾ എടുക്കുക.';

  @override
  String get visionMinPhotosHint => 'കുറഞ്ഞത് 3 ഫോട്ടോകൾ ചേർക്കുക';

  @override
  String get visionMaxReached => 'പരമാവധി 10 ഫോട്ടോകൾ';

  @override
  String get visionAnalyze => 'വിശകലനം ചെയ്യുക';

  @override
  String get forecastSectionLabel => 'വിൽപ്പന പ്രവചനം';

  @override
  String forecastStripCount(int count) {
    return 'നാളെ $count സാധനങ്ങൾ വിൽക്കപ്പെടാം';
  }

  @override
  String forecastStripEst(String amount) {
    return 'ഏകദേശം $amount';
  }

  @override
  String get forecastStripViewAll => 'മുഴുവൻ ലിസ്റ്റ് കാണുക';

  @override
  String get forecastScreenTitle => 'വിൽപ്പന പ്രവചനം';

  @override
  String get forecastHorizonTomorrow => 'നാളെ';

  @override
  String get forecastHorizon3d => '3 ദിവസം';

  @override
  String get forecastHorizon5d => '5 ദിവസം';

  @override
  String get forecastHorizon7d => '7 ദിവസം';

  @override
  String get forecastHorizon14d => '14 ദിവസം';

  @override
  String get forecastHorizon30d => '30 ദിവസം';

  @override
  String get forecastRevLabel => 'ഏകദേശ വരുമാനം';

  @override
  String get forecastOosWarning => 'സ്റ്റോക്ക് തീർന്നേക്കാം';

  @override
  String get forecastWhyTitle => 'ഇത് ഇവിടെ ഉള്ളത് എന്തുകൊണ്ട്?';

  @override
  String get forecastWhyAvgDaily => 'ദൈനംദിന ശരാശരി വിൽപ്പന';

  @override
  String get forecastWhyStockDays => 'ബാക്കി സ്റ്റോക്ക്';

  @override
  String get forecastWhyOosRisk => 'തീർന്നു പോകാൻ ഉള്ള സാധ്യത';

  @override
  String forecastWhyExplain(String avg, String days, String units) {
    return 'ഈ സാധനം ദിവസവും ശരാശരി $avg പീസ് വിൽക്കുന്നു. $days ദിവസത്തിൽ, നിങ്ങളുടെ കടയിൽ നിന്ന് ഏകദേശം $units പീസ് വിൽക്കപ്പെടും എന്ന് പ്രതീക്ഷിക്കുന്നു.';
  }

  @override
  String get forecastNoData =>
      'പ്രവചനം ഇനിയും തയ്യാറായിട്ടില്ല. ദയവായി പിന്നീട് നോക്കുക.';

  @override
  String get forecastDataStale => 'ഡേറ്റ പഴകിയിരിക്കാം';
}
