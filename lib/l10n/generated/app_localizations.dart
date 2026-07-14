import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('ta'),
    Locale('te'),
  ];

  /// Native name of this language, shown in the language picker.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @languageChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageChooseTitle;

  /// No description provided for @languageChooseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in Settings.'**
  String get languageChooseSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonServerError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server. Please try again.'**
  String get commonServerError;

  /// No description provided for @commonSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonSomethingWrong;

  /// No description provided for @authErrEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get authErrEnterPhone;

  /// No description provided for @authErrEnter6Otp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP'**
  String get authErrEnter6Otp;

  /// No description provided for @authErrSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Tap Resend.'**
  String get authErrSessionExpired;

  /// No description provided for @authErrInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number. Include country code (e.g. +91...).'**
  String get authErrInvalidPhone;

  /// No description provided for @authErrTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authErrTooManyRequests;

  /// No description provided for @authErrWrongOtp.
  ///
  /// In en, this message translates to:
  /// **'Wrong OTP. Please check and try again.'**
  String get authErrWrongOtp;

  /// No description provided for @authErrOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'OTP expired. Tap Resend to get a new code.'**
  String get authErrOtpExpired;

  /// No description provided for @authErrVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed. Try again.'**
  String get authErrVerificationFailed;

  /// No description provided for @welcomeSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nOutlet AI'**
  String get welcomeSlide1Title;

  /// No description provided for @welcomeSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your smart business partner for managing your kirana store — built for South India.'**
  String get welcomeSlide1Subtitle;

  /// No description provided for @welcomeSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Inventory\nManagement'**
  String get welcomeSlide2Title;

  /// No description provided for @welcomeSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track stock levels, get low-stock alerts, and never run out of your bestselling products.'**
  String get welcomeSlide2Subtitle;

  /// No description provided for @welcomeSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Grow Your\nBusiness'**
  String get welcomeSlide3Title;

  /// No description provided for @welcomeSlide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get AI-powered insights, sales analytics, and personalised tips for your store.'**
  String get welcomeSlide3Subtitle;

  /// No description provided for @welcomeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get welcomeGetStarted;

  /// No description provided for @welcomeHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get welcomeHaveAccount;

  /// No description provided for @welcomeSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get welcomeSignIn;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your Outlet AI account.'**
  String get loginSubtitle;

  /// No description provided for @loginTabPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone OTP'**
  String get loginTabPhone;

  /// No description provided for @loginTabUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginTabUsername;

  /// No description provided for @loginPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get loginPhoneLabel;

  /// No description provided for @loginSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get loginSendOtp;

  /// No description provided for @loginOtpHelp.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a one-time password to this number'**
  String get loginOtpHelp;

  /// No description provided for @loginOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to {phone}'**
  String loginOtpSentTo(String phone);

  /// No description provided for @loginOtp6Label.
  ///
  /// In en, this message translates to:
  /// **'6-digit OTP'**
  String get loginOtp6Label;

  /// No description provided for @loginVerifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get loginVerifyOtp;

  /// No description provided for @loginResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get loginResendOtp;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// No description provided for @loginUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. mykiranastore'**
  String get loginUsernameHint;

  /// No description provided for @loginUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get loginUsernameRequired;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get loginPasswordHint;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginPasswordRequired;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccount;

  /// No description provided for @loginCreateOne.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get loginCreateOne;

  /// No description provided for @loginIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password. Please try again.'**
  String get loginIncorrect;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {message}'**
  String loginFailed(String message);

  /// No description provided for @onboardingStepCount.
  ///
  /// In en, this message translates to:
  /// **'{step}/4'**
  String onboardingStepCount(int step);

  /// No description provided for @accountVerifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your\nphone number'**
  String get accountVerifyPhoneTitle;

  /// No description provided for @accountVerifyPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a one-time password to confirm your number.'**
  String get accountVerifyPhoneSubtitle;

  /// No description provided for @accountPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get accountPhoneLabel;

  /// No description provided for @accountSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get accountSendOtp;

  /// No description provided for @accountEnterOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get accountEnterOtpTitle;

  /// No description provided for @accountEnterOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'6-digit code sent to your phone.'**
  String get accountEnterOtpSubtitle;

  /// No description provided for @accountOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to +91 {phone}'**
  String accountOtpSentTo(String phone);

  /// No description provided for @accountOtp6Label.
  ///
  /// In en, this message translates to:
  /// **'6-digit OTP'**
  String get accountOtp6Label;

  /// No description provided for @accountVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get accountVerify;

  /// No description provided for @accountResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get accountResendOtp;

  /// No description provided for @accountPhoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone verified: {phone}'**
  String accountPhoneVerified(String phone);

  /// No description provided for @accountChooseUsernameTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a\nstore username'**
  String get accountChooseUsernameTitle;

  /// No description provided for @accountChooseUsernameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your username is unique to your store and used to log in.'**
  String get accountChooseUsernameSubtitle;

  /// No description provided for @accountUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get accountUsernameLabel;

  /// No description provided for @accountUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. lohiyastore123'**
  String get accountUsernameHint;

  /// No description provided for @accountUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'Username already taken'**
  String get accountUsernameTaken;

  /// No description provided for @accountUsernameRules.
  ///
  /// In en, this message translates to:
  /// **'3–30 characters • letters, numbers and underscores only'**
  String get accountUsernameRules;

  /// No description provided for @accountErrChooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Choose a unique username for your store'**
  String get accountErrChooseUsername;

  /// No description provided for @accountErrUsernameMin3.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get accountErrUsernameMin3;

  /// No description provided for @accountErrUsernameMax30.
  ///
  /// In en, this message translates to:
  /// **'Username can be at most 30 characters'**
  String get accountErrUsernameMax30;

  /// No description provided for @accountErrUsernameChars.
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers, and underscores allowed'**
  String get accountErrUsernameChars;

  /// No description provided for @accountErrUsernameTakenTry.
  ///
  /// In en, this message translates to:
  /// **'That username is taken. Try another.'**
  String get accountErrUsernameTakenTry;

  /// No description provided for @accountUsernameAvailable.
  ///
  /// In en, this message translates to:
  /// **'Username is available'**
  String get accountUsernameAvailable;

  /// No description provided for @businessTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about\nyour store'**
  String get businessTitle;

  /// No description provided for @businessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us personalise your experience.'**
  String get businessSubtitle;

  /// No description provided for @businessOwnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner\'s full name'**
  String get businessOwnerLabel;

  /// No description provided for @businessOwnerHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ramesh Kumar'**
  String get businessOwnerHint;

  /// No description provided for @businessOwnerRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get businessOwnerRequired;

  /// No description provided for @businessStoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get businessStoreLabel;

  /// No description provided for @businessStoreHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sri Lakshmi Stores'**
  String get businessStoreHint;

  /// No description provided for @businessStoreRequired.
  ///
  /// In en, this message translates to:
  /// **'Store name is required'**
  String get businessStoreRequired;

  /// No description provided for @businessEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get businessEmailLabel;

  /// No description provided for @businessEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get businessEmailHint;

  /// No description provided for @businessEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get businessEmailRequired;

  /// No description provided for @businessEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get businessEmailInvalid;

  /// No description provided for @businessTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Business type'**
  String get businessTypeLabel;

  /// No description provided for @businessTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select your store type'**
  String get businessTypeHint;

  /// No description provided for @businessTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your business type'**
  String get businessTypeRequired;

  /// No description provided for @businessFootfallLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated daily customers'**
  String get businessFootfallLabel;

  /// No description provided for @businessFootfallHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 40'**
  String get businessFootfallHint;

  /// No description provided for @businessFootfallSuffix.
  ///
  /// In en, this message translates to:
  /// **'customers/day'**
  String get businessFootfallSuffix;

  /// No description provided for @businessFootfallInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get businessFootfallInvalid;

  /// No description provided for @businessBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly sales target (optional)'**
  String get businessBudgetLabel;

  /// No description provided for @businessBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 150000'**
  String get businessBudgetHint;

  /// No description provided for @businessBudgetHelper.
  ///
  /// In en, this message translates to:
  /// **'Used to track daily progress. You can change it later.'**
  String get businessBudgetHelper;

  /// No description provided for @businessBudgetInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get businessBudgetInvalid;

  /// No description provided for @businessTypeKirana.
  ///
  /// In en, this message translates to:
  /// **'Kirana / General Stores'**
  String get businessTypeKirana;

  /// No description provided for @businessTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Store'**
  String get businessTypeGeneral;

  /// No description provided for @businessTypeProvision.
  ///
  /// In en, this message translates to:
  /// **'Provision Store'**
  String get businessTypeProvision;

  /// No description provided for @businessTypeFruitsVeg.
  ///
  /// In en, this message translates to:
  /// **'Fruits & Vegetables'**
  String get businessTypeFruitsVeg;

  /// No description provided for @businessTypeStationery.
  ///
  /// In en, this message translates to:
  /// **'Stationery & Books'**
  String get businessTypeStationery;

  /// No description provided for @businessTypeSupermarket.
  ///
  /// In en, this message translates to:
  /// **'Supermarket'**
  String get businessTypeSupermarket;

  /// No description provided for @businessTypeMiniSupermarket.
  ///
  /// In en, this message translates to:
  /// **'Mini Supermarket'**
  String get businessTypeMiniSupermarket;

  /// No description provided for @businessTypeMonoBrand.
  ///
  /// In en, this message translates to:
  /// **'Mono Brand Store'**
  String get businessTypeMonoBrand;

  /// No description provided for @businessTypeBoutique.
  ///
  /// In en, this message translates to:
  /// **'Boutique'**
  String get businessTypeBoutique;

  /// No description provided for @businessTypeSalon.
  ///
  /// In en, this message translates to:
  /// **'Salon & Parlour'**
  String get businessTypeSalon;

  /// No description provided for @businessTypeFancyGift.
  ///
  /// In en, this message translates to:
  /// **'Fancy & Gift Store'**
  String get businessTypeFancyGift;

  /// No description provided for @businessTypeSportsFitness.
  ///
  /// In en, this message translates to:
  /// **'Sports & Fitness'**
  String get businessTypeSportsFitness;

  /// No description provided for @businessTypeFootwear.
  ///
  /// In en, this message translates to:
  /// **'Footwear Shop'**
  String get businessTypeFootwear;

  /// No description provided for @businessTypeOptical.
  ///
  /// In en, this message translates to:
  /// **'Optical Store'**
  String get businessTypeOptical;

  /// No description provided for @businessTypeBakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery & Sweet Shop'**
  String get businessTypeBakery;

  /// No description provided for @businessTypeApparel.
  ///
  /// In en, this message translates to:
  /// **'Apparel & Clothing'**
  String get businessTypeApparel;

  /// No description provided for @businessTypeElectronics.
  ///
  /// In en, this message translates to:
  /// **'Mobile & Electronics'**
  String get businessTypeElectronics;

  /// No description provided for @businessTypeOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get businessTypeOthers;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Where is your\nstore located?'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We use this to show local insights and enable delivery zones.'**
  String get locationSubtitle;

  /// No description provided for @locationDetecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting location…'**
  String get locationDetecting;

  /// No description provided for @locationDetect.
  ///
  /// In en, this message translates to:
  /// **'Detect My Location'**
  String get locationDetect;

  /// No description provided for @locationOrManual.
  ///
  /// In en, this message translates to:
  /// **'or enter manually'**
  String get locationOrManual;

  /// No description provided for @locationAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Store address'**
  String get locationAddressLabel;

  /// No description provided for @locationAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Street, area, landmark…'**
  String get locationAddressHint;

  /// No description provided for @locationCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City / District'**
  String get locationCityLabel;

  /// No description provided for @locationCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hyderabad'**
  String get locationCityHint;

  /// No description provided for @locationGettingCoords.
  ///
  /// In en, this message translates to:
  /// **'Getting coordinates…'**
  String get locationGettingCoords;

  /// No description provided for @locationDetected.
  ///
  /// In en, this message translates to:
  /// **'Location detected'**
  String get locationDetected;

  /// No description provided for @locationErrAddress.
  ///
  /// In en, this message translates to:
  /// **'Please detect or enter your store address.'**
  String get locationErrAddress;

  /// No description provided for @locationErrCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter your city or district.'**
  String get locationErrCity;

  /// No description provided for @locationPermDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Please enter address manually.'**
  String get locationPermDenied;

  /// No description provided for @locationDetectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not detect location. Please enter address manually.'**
  String get locationDetectFailed;

  /// No description provided for @consentTitle.
  ///
  /// In en, this message translates to:
  /// **'Almost there!\nReview & agree'**
  String get consentTitle;

  /// No description provided for @consentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please read and accept the following to complete your setup.'**
  String get consentSubtitle;

  /// No description provided for @consentTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get consentTermsTitle;

  /// No description provided for @consentTermsSummary.
  ///
  /// In en, this message translates to:
  /// **'By using Outlet AI, you agree to use the service for legitimate business purposes only. LohiyaAI reserves the right to suspend accounts that violate these terms. Your data is used solely to provide and improve the service.'**
  String get consentTermsSummary;

  /// No description provided for @consentPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get consentPrivacyTitle;

  /// No description provided for @consentPrivacySummary.
  ///
  /// In en, this message translates to:
  /// **'We collect your store details, location, and transaction data to personalise your experience. We never sell your personal data to third parties. All data is encrypted and stored securely on our cloud infrastructure.'**
  String get consentPrivacySummary;

  /// No description provided for @consentTermsCheckPrefix.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the '**
  String get consentTermsCheckPrefix;

  /// No description provided for @consentPrivacyCheckPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get consentPrivacyCheckPrefix;

  /// No description provided for @consentAcceptBoth.
  ///
  /// In en, this message translates to:
  /// **'Please accept both agreements to continue.'**
  String get consentAcceptBoth;

  /// No description provided for @consentCompleteSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get consentCompleteSetup;

  /// No description provided for @regErrPhoneExists.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already registered. Please sign in instead.'**
  String get regErrPhoneExists;

  /// No description provided for @regErrUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken. Please choose another.'**
  String get regErrUsernameTaken;

  /// No description provided for @regErrInvalidDetails.
  ///
  /// In en, this message translates to:
  /// **'Invalid details. Please check your entries and try again.'**
  String get regErrInvalidDetails;

  /// No description provided for @regErrFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed: {message}'**
  String regErrFailed(String message);

  /// No description provided for @dashNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashNavHome;

  /// No description provided for @dashNavKhata.
  ///
  /// In en, this message translates to:
  /// **'Khata'**
  String get dashNavKhata;

  /// No description provided for @dashNavBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get dashNavBilling;

  /// No description provided for @dashTrialWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Outlet AI'**
  String get dashTrialWelcome;

  /// No description provided for @dashTrialChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan to trial free. Our team will activate it shortly.'**
  String get dashTrialChoosePlan;

  /// No description provided for @dashTrialSelectPlan.
  ///
  /// In en, this message translates to:
  /// **'SELECT YOUR TRIAL PLAN'**
  String get dashTrialSelectPlan;

  /// No description provided for @dashTrialRequestPro.
  ///
  /// In en, this message translates to:
  /// **'Request Pro Trial'**
  String get dashTrialRequestPro;

  /// No description provided for @dashTrialRequestBasic.
  ///
  /// In en, this message translates to:
  /// **'Request Basic Trial'**
  String get dashTrialRequestBasic;

  /// No description provided for @dashTrialRequestError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start your trial just now. Please check your connection and try again.'**
  String get dashTrialRequestError;

  /// No description provided for @dashTrialSignInDifferent.
  ///
  /// In en, this message translates to:
  /// **'Sign in to a different account'**
  String get dashTrialSignInDifferent;

  /// No description provided for @dashPlanBadgeAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'ALL FEATURES'**
  String get dashPlanBadgeAllFeatures;

  /// No description provided for @dashPlanBasicName.
  ///
  /// In en, this message translates to:
  /// **'Basic Plan'**
  String get dashPlanBasicName;

  /// No description provided for @dashPlanProName.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get dashPlanProName;

  /// No description provided for @dashFeatPos.
  ///
  /// In en, this message translates to:
  /// **'POS & Sales Management'**
  String get dashFeatPos;

  /// No description provided for @dashFeatInventoryTracking.
  ///
  /// In en, this message translates to:
  /// **'Inventory Tracking'**
  String get dashFeatInventoryTracking;

  /// No description provided for @dashFeatFinanceUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Finance & Udhaar'**
  String get dashFeatFinanceUdhaar;

  /// No description provided for @dashFeatKpiInsights.
  ///
  /// In en, this message translates to:
  /// **'KPI Insights (3 per category)'**
  String get dashFeatKpiInsights;

  /// No description provided for @dashFeatAiReco.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendations'**
  String get dashFeatAiReco;

  /// No description provided for @dashFeatEverythingBasic.
  ///
  /// In en, this message translates to:
  /// **'Everything in Basic'**
  String get dashFeatEverythingBasic;

  /// No description provided for @dashFeatAllKpi.
  ///
  /// In en, this message translates to:
  /// **'All KPI Categories (unlimited)'**
  String get dashFeatAllKpi;

  /// No description provided for @dashFeatVendorProcurement.
  ///
  /// In en, this message translates to:
  /// **'Vendor & Procurement Management'**
  String get dashFeatVendorProcurement;

  /// No description provided for @dashFeatCashflowSupport.
  ///
  /// In en, this message translates to:
  /// **'Cashflow Support (up to ₹10L)'**
  String get dashFeatCashflowSupport;

  /// No description provided for @dashFeatCustomerGrowth.
  ///
  /// In en, this message translates to:
  /// **'Customer Growth Engine'**
  String get dashFeatCustomerGrowth;

  /// No description provided for @dashPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trial Request Received!'**
  String get dashPendingTitle;

  /// No description provided for @dashPendingBody.
  ///
  /// In en, this message translates to:
  /// **'Your trial activation is being reviewed by our team. You\'ll receive a notification on your device as soon as it\'s approved — usually within a few hours.'**
  String get dashPendingBody;

  /// No description provided for @dashPendingNotifNote.
  ///
  /// In en, this message translates to:
  /// **'Make sure notifications are enabled so you don\'t miss the activation alert.'**
  String get dashPendingNotifNote;

  /// No description provided for @dashPendingCheckStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get dashPendingCheckStatus;

  /// No description provided for @dashUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Trial Ended'**
  String get dashUpgradeTitle;

  /// No description provided for @dashUpgradeBody.
  ///
  /// In en, this message translates to:
  /// **'Your free trial has ended. Choose a plan to continue using Outlet AI and keep growing your store.'**
  String get dashUpgradeBody;

  /// No description provided for @dashUpgradeBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get dashUpgradeBasic;

  /// No description provided for @dashUpgradePro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get dashUpgradePro;

  /// No description provided for @dashUpgradeBadgeBest.
  ///
  /// In en, this message translates to:
  /// **'BEST'**
  String get dashUpgradeBadgeBest;

  /// No description provided for @dashUpgradeJustPerDay.
  ///
  /// In en, this message translates to:
  /// **'just {price}'**
  String dashUpgradeJustPerDay(String price);

  /// No description provided for @dashUpgradeAlreadySubscribed.
  ///
  /// In en, this message translates to:
  /// **'Already subscribed? Refresh'**
  String get dashUpgradeAlreadySubscribed;

  /// No description provided for @dashFeatPosInventory.
  ///
  /// In en, this message translates to:
  /// **'POS & Inventory'**
  String get dashFeatPosInventory;

  /// No description provided for @dashFeatFinanceKpis.
  ///
  /// In en, this message translates to:
  /// **'Finance & KPIs'**
  String get dashFeatFinanceKpis;

  /// No description provided for @dashFeatVendorManagement.
  ///
  /// In en, this message translates to:
  /// **'Vendor Management'**
  String get dashFeatVendorManagement;

  /// No description provided for @dashFeatCashflowReferrals.
  ///
  /// In en, this message translates to:
  /// **'Cashflow + Referrals'**
  String get dashFeatCashflowReferrals;

  /// No description provided for @dashNewSale.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get dashNewSale;

  /// No description provided for @dashGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashGreetingMorning;

  /// No description provided for @dashGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get dashGreetingAfternoon;

  /// No description provided for @dashGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get dashGreetingEvening;

  /// No description provided for @dashGreetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, \n{name}'**
  String dashGreetingWithName(String greeting, String name);

  /// No description provided for @dashMorningBriefing.
  ///
  /// In en, this message translates to:
  /// **'MORNING BRIEFING'**
  String get dashMorningBriefing;

  /// No description provided for @dashBriefingBody.
  ///
  /// In en, this message translates to:
  /// **'You have {risk} SKUs at critical risk and {reorder} items to reorder today. Tap to fix.'**
  String dashBriefingBody(int risk, int reorder);

  /// No description provided for @dashIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get dashIntelligence;

  /// No description provided for @dashMetricStockoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Stockout Risk'**
  String get dashMetricStockoutLabel;

  /// No description provided for @dashMetricStockoutSub.
  ///
  /// In en, this message translates to:
  /// **'SKUs critical'**
  String get dashMetricStockoutSub;

  /// No description provided for @dashMetricReorderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reorder Now'**
  String get dashMetricReorderLabel;

  /// No description provided for @dashMetricReorderSub.
  ///
  /// In en, this message translates to:
  /// **'SKUs low stock'**
  String get dashMetricReorderSub;

  /// No description provided for @dashMetricFastLabel.
  ///
  /// In en, this message translates to:
  /// **'Fast Moving'**
  String get dashMetricFastLabel;

  /// No description provided for @dashMetricFastSub.
  ///
  /// In en, this message translates to:
  /// **'Top sellers'**
  String get dashMetricFastSub;

  /// No description provided for @dashMetricProfitLabel.
  ///
  /// In en, this message translates to:
  /// **'Profit Picks'**
  String get dashMetricProfitLabel;

  /// No description provided for @dashMetricProfitSub.
  ///
  /// In en, this message translates to:
  /// **'Opportunities'**
  String get dashMetricProfitSub;

  /// No description provided for @dashMetricCustomerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer Dues'**
  String get dashMetricCustomerLabel;

  /// No description provided for @dashMetricCustomerSub.
  ///
  /// In en, this message translates to:
  /// **'Pending khata'**
  String get dashMetricCustomerSub;

  /// No description provided for @dashMetricSalesLabel.
  ///
  /// In en, this message translates to:
  /// **'Items Sold'**
  String get dashMetricSalesLabel;

  /// No description provided for @dashMetricSalesSub.
  ///
  /// In en, this message translates to:
  /// **'Today so far'**
  String get dashMetricSalesSub;

  /// No description provided for @dashTodaysPerformance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Performance'**
  String get dashTodaysPerformance;

  /// No description provided for @dashPosNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'POS data not available'**
  String get dashPosNotAvailable;

  /// No description provided for @dashStatRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get dashStatRevenue;

  /// No description provided for @dashStatOrders.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get dashStatOrders;

  /// No description provided for @dashStatAvgOrder.
  ///
  /// In en, this message translates to:
  /// **'Avg bill'**
  String get dashStatAvgOrder;

  /// No description provided for @dashStoreOverview.
  ///
  /// In en, this message translates to:
  /// **'Store Overview'**
  String get dashStoreOverview;

  /// No description provided for @dashStoreSkus.
  ///
  /// In en, this message translates to:
  /// **'SKUs'**
  String get dashStoreSkus;

  /// No description provided for @dashStoreFootfall.
  ///
  /// In en, this message translates to:
  /// **'Daily footfall'**
  String get dashStoreFootfall;

  /// No description provided for @dashStoreDailyBudget.
  ///
  /// In en, this message translates to:
  /// **'Daily stock cost'**
  String get dashStoreDailyBudget;

  /// No description provided for @dashKpiPeriod.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days'**
  String dashKpiPeriod(int days);

  /// No description provided for @dashCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load data'**
  String get dashCouldNotLoad;

  /// No description provided for @dashRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get dashRetry;

  /// No description provided for @dashAlerts.
  ///
  /// In en, this message translates to:
  /// **'ALERTS'**
  String get dashAlerts;

  /// No description provided for @dashSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get dashSeeAll;

  /// No description provided for @dashStoreKpis.
  ///
  /// In en, this message translates to:
  /// **'Store KPIs'**
  String get dashStoreKpis;

  /// No description provided for @dashKpiCoverageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Based on {pct}% of sales — some items have no cost data'**
  String dashKpiCoverageTooltip(String pct);

  /// No description provided for @dashDetailStockout.
  ///
  /// In en, this message translates to:
  /// **'Stockout Risk'**
  String get dashDetailStockout;

  /// No description provided for @dashDetailReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder Required'**
  String get dashDetailReorder;

  /// No description provided for @dashDetailFastMoving.
  ///
  /// In en, this message translates to:
  /// **'Fast Moving Items'**
  String get dashDetailFastMoving;

  /// No description provided for @dashDetailProfit.
  ///
  /// In en, this message translates to:
  /// **'High Profit Items'**
  String get dashDetailProfit;

  /// No description provided for @dashDetailDefault.
  ///
  /// In en, this message translates to:
  /// **'Intelligence Detail'**
  String get dashDetailDefault;

  /// No description provided for @dashSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get dashSearchProducts;

  /// No description provided for @dashSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by:'**
  String get dashSortBy;

  /// No description provided for @dashSortProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get dashSortProfit;

  /// No description provided for @dashSortDemand.
  ///
  /// In en, this message translates to:
  /// **'Demand'**
  String get dashSortDemand;

  /// No description provided for @dashSortRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get dashSortRisk;

  /// No description provided for @dashStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock: {qty}'**
  String dashStockLabel(String qty);

  /// No description provided for @dashStockRunway.
  ///
  /// In en, this message translates to:
  /// **'Stock runway'**
  String get dashStockRunway;

  /// No description provided for @dashOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'OUT OF STOCK'**
  String get dashOutOfStock;

  /// No description provided for @dashDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'~{days} days left'**
  String dashDaysLeft(String days);

  /// No description provided for @dashStatStockoutRisk.
  ///
  /// In en, this message translates to:
  /// **'Stockout risk'**
  String get dashStatStockoutRisk;

  /// No description provided for @dashStatReorderQty.
  ///
  /// In en, this message translates to:
  /// **'Reorder qty'**
  String get dashStatReorderQty;

  /// No description provided for @dashUnitsValue.
  ///
  /// In en, this message translates to:
  /// **'{qty} units'**
  String dashUnitsValue(String qty);

  /// No description provided for @dashWeeklyProfitImpact.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} estimated weekly profit impact'**
  String dashWeeklyProfitImpact(String amount);

  /// No description provided for @dashCreatePurchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Purchase Order · {qty} units'**
  String dashCreatePurchaseOrder(String qty);

  /// No description provided for @dashNoItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get dashNoItemsFound;

  /// No description provided for @dashNoResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String dashNoResultsFor(String query);

  /// No description provided for @dashClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get dashClearSearch;

  /// No description provided for @dashConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get dashConnectionError;

  /// No description provided for @posCommonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get posCommonCancel;

  /// No description provided for @posCommonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get posCommonClear;

  /// No description provided for @posCommonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get posCommonRefresh;

  /// No description provided for @posCommonAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get posCommonAddToCart;

  /// No description provided for @posCameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan barcodes.'**
  String get posCameraPermissionRequired;

  /// No description provided for @posCommonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get posCommonSettings;

  /// No description provided for @posEnterQtyTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter {unit}'**
  String posEnterQtyTitle(String unit);

  /// No description provided for @posQtyFallback.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get posQtyFallback;

  /// No description provided for @posSelectVariant.
  ///
  /// In en, this message translates to:
  /// **'Select variant'**
  String get posSelectVariant;

  /// No description provided for @posInclGst.
  ///
  /// In en, this message translates to:
  /// **'Incl. GST {amount}'**
  String posInclGst(String amount);

  /// No description provided for @posOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get posOutOfStock;

  /// No description provided for @posVariantStockLine.
  ///
  /// In en, this message translates to:
  /// **'{stock} in stock'**
  String posVariantStockLine(String stock);

  /// No description provided for @posPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price: {price}'**
  String posPriceLabel(String price);

  /// No description provided for @posWeightMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Weight / Measurement'**
  String get posWeightMeasurement;

  /// No description provided for @posUnknownBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown Barcode'**
  String get posUnknownBarcodeTitle;

  /// No description provided for @posUnknownBarcodeBody.
  ///
  /// In en, this message translates to:
  /// **'Barcode \"{barcode}\" is not in your inventory. What would you like to do?'**
  String posUnknownBarcodeBody(String barcode);

  /// No description provided for @posAddAsNew.
  ///
  /// In en, this message translates to:
  /// **'Add as New'**
  String get posAddAsNew;

  /// No description provided for @posLinkToExisting.
  ///
  /// In en, this message translates to:
  /// **'Link to Existing Item'**
  String get posLinkToExisting;

  /// No description provided for @posErrLoadingInventory.
  ///
  /// In en, this message translates to:
  /// **'Error loading inventory: {error}'**
  String posErrLoadingInventory(String error);

  /// No description provided for @posLinkBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Link Barcode \"{barcode}\"'**
  String posLinkBarcodeTitle(String barcode);

  /// No description provided for @posNoUnbarcodedItems.
  ///
  /// In en, this message translates to:
  /// **'No items found without barcodes.'**
  String get posNoUnbarcodedItems;

  /// No description provided for @posCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String posCategoryLabel(String category);

  /// No description provided for @posCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get posCategoryGeneral;

  /// No description provided for @posLinkedToItem.
  ///
  /// In en, this message translates to:
  /// **'Linked {barcode} to {name}'**
  String posLinkedToItem(String barcode, String name);

  /// No description provided for @posScanReferralQr.
  ///
  /// In en, this message translates to:
  /// **'Scan Referral QR'**
  String get posScanReferralQr;

  /// No description provided for @posCampaignOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'All items in \"{name}\" are out of stock'**
  String posCampaignOutOfStock(String name);

  /// No description provided for @posCampaignItemsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{item} other{items}} from \"{name}\" added'**
  String posCampaignItemsAdded(int count, String name);

  /// No description provided for @posAddedSkipped.
  ///
  /// In en, this message translates to:
  /// **'{added} added · {skipped} skipped (out of stock)'**
  String posAddedSkipped(int added, int skipped);

  /// No description provided for @posBasketAddedAtPrice.
  ///
  /// In en, this message translates to:
  /// **'Bundle \"{name}\" added at ₹{price}'**
  String posBasketAddedAtPrice(String name, String price);

  /// No description provided for @posItemsRegularPrice.
  ///
  /// In en, this message translates to:
  /// **'{count} items added at regular price (bundle needs all items in stock)'**
  String posItemsRegularPrice(int count);

  /// No description provided for @posBasketItemsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{item} other{items}} from \"{name}\" added'**
  String posBasketItemsAdded(int count, String name);

  /// No description provided for @posItemsAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{item} other{items}} added to cart'**
  String posItemsAddedToCart(int count);

  /// No description provided for @posSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get posSelectCustomer;

  /// No description provided for @posNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get posNew;

  /// No description provided for @posSearchNameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone...'**
  String get posSearchNameOrPhone;

  /// No description provided for @posNoCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found.'**
  String get posNoCustomersFound;

  /// No description provided for @posAddNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get posAddNewCustomer;

  /// No description provided for @posSelectFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Select from Contacts'**
  String get posSelectFromContacts;

  /// No description provided for @posCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get posCustomerName;

  /// No description provided for @posPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get posPhoneNumber;

  /// No description provided for @posSaveAndSelect.
  ///
  /// In en, this message translates to:
  /// **'Save & Select'**
  String get posSaveAndSelect;

  /// No description provided for @posSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products…'**
  String get posSearchProducts;

  /// No description provided for @posReferralScan.
  ///
  /// In en, this message translates to:
  /// **'Referral Scan'**
  String get posReferralScan;

  /// No description provided for @posOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get posOrderHistory;

  /// No description provided for @posRefreshingProducts.
  ///
  /// In en, this message translates to:
  /// **'Refreshing products...'**
  String get posRefreshingProducts;

  /// No description provided for @posRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Refresh failed: {error}'**
  String posRefreshFailed(String error);

  /// No description provided for @posProductsRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Products refreshed ({count} items)'**
  String posProductsRefreshed(int count);

  /// No description provided for @posItemsInCart.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{item} other{items}} in cart'**
  String posItemsInCart(int count);

  /// No description provided for @posClearCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart?'**
  String get posClearCartTitle;

  /// No description provided for @posClearCartBody.
  ///
  /// In en, this message translates to:
  /// **'All items will be removed from the cart.'**
  String get posClearCartBody;

  /// No description provided for @posFrequentlyBought.
  ///
  /// In en, this message translates to:
  /// **'FREQUENTLY BOUGHT TOGETHER'**
  String get posFrequentlyBought;

  /// No description provided for @posNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get posNoProductsFound;

  /// No description provided for @posStockColon.
  ///
  /// In en, this message translates to:
  /// **'Stock: {stock}'**
  String posStockColon(String stock);

  /// No description provided for @posOffline.
  ///
  /// In en, this message translates to:
  /// **'POS Offline'**
  String get posOffline;

  /// No description provided for @posCouldNotConnect.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to POS.'**
  String get posCouldNotConnect;

  /// No description provided for @posBundlesAndDeals.
  ///
  /// In en, this message translates to:
  /// **'Bundles & Deals'**
  String get posBundlesAndDeals;

  /// No description provided for @posRefreshAi.
  ///
  /// In en, this message translates to:
  /// **'Refresh AI'**
  String get posRefreshAi;

  /// No description provided for @posItemsInBundle.
  ///
  /// In en, this message translates to:
  /// **'{count} items in bundle'**
  String posItemsInBundle(int count);

  /// No description provided for @posBundlePrice.
  ///
  /// In en, this message translates to:
  /// **'bundle price'**
  String get posBundlePrice;

  /// No description provided for @posItemFallback.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get posItemFallback;

  /// No description provided for @posValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String posValidUntil(String date);

  /// No description provided for @posStockUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Stock: {stock} {unit}  ·  ₹{price}'**
  String posStockUnitPrice(String stock, String unit, String price);

  /// No description provided for @posNotInStock.
  ///
  /// In en, this message translates to:
  /// **'Not in stock'**
  String get posNotInStock;

  /// No description provided for @posBundlePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Bundle Price'**
  String get posBundlePriceLabel;

  /// No description provided for @posAddAvailableToCart.
  ///
  /// In en, this message translates to:
  /// **'Add Available Items to Cart'**
  String get posAddAvailableToCart;

  /// No description provided for @posVoiceCount.
  ///
  /// In en, this message translates to:
  /// **'Voice ({remaining}/{total})'**
  String posVoiceCount(int remaining, int total);

  /// No description provided for @posVoiceOrder.
  ///
  /// In en, this message translates to:
  /// **'Voice Order'**
  String get posVoiceOrder;

  /// No description provided for @posHandwriteCount.
  ///
  /// In en, this message translates to:
  /// **'Handwrite ({remaining}/{total})'**
  String posHandwriteCount(int remaining, int total);

  /// No description provided for @posHandwrite.
  ///
  /// In en, this message translates to:
  /// **'Handwrite'**
  String get posHandwrite;

  /// No description provided for @posCartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get posCartEmpty;

  /// No description provided for @posCartEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a product or scan a barcode to start a sale.'**
  String get posCartEmptyHint;

  /// No description provided for @posAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get posAddCustomer;

  /// No description provided for @posItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String posItemCount(String count);

  /// No description provided for @posPlaceOrderAmount.
  ///
  /// In en, this message translates to:
  /// **'Place Order · {amount}'**
  String posPlaceOrderAmount(String amount);

  /// No description provided for @posPosInventory.
  ///
  /// In en, this message translates to:
  /// **'POS / Inventory'**
  String get posPosInventory;

  /// No description provided for @posOnline.
  ///
  /// In en, this message translates to:
  /// **'POS Online'**
  String get posOnline;

  /// No description provided for @posTabSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get posTabSales;

  /// No description provided for @posTabStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get posTabStock;

  /// No description provided for @posTabPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get posTabPurchase;

  /// No description provided for @posPurchaseSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Purchase & Suppliers'**
  String get posPurchaseSuppliers;

  /// No description provided for @posPurchaseSuppliersDesc.
  ///
  /// In en, this message translates to:
  /// **'Create purchase orders, manage your suppliers, and track what you owe them — all in one place.'**
  String get posPurchaseSuppliersDesc;

  /// No description provided for @posPaywallPurchaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage purchase orders and suppliers. Track payments to distributors. Available on the Pro plan.'**
  String get posPaywallPurchaseDesc;

  /// No description provided for @posPrinterSetup.
  ///
  /// In en, this message translates to:
  /// **'Printer Setup'**
  String get posPrinterSetup;

  /// No description provided for @posReconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get posReconnect;

  /// No description provided for @posForgetPrinter.
  ///
  /// In en, this message translates to:
  /// **'Forget this printer'**
  String get posForgetPrinter;

  /// No description provided for @posPairedDevices.
  ///
  /// In en, this message translates to:
  /// **'PAIRED BLUETOOTH DEVICES'**
  String get posPairedDevices;

  /// No description provided for @posNoPairedDevices.
  ///
  /// In en, this message translates to:
  /// **'No paired devices found'**
  String get posNoPairedDevices;

  /// No description provided for @posPairDeviceHint.
  ///
  /// In en, this message translates to:
  /// **'Pair your thermal printer in Android\nBluetooth settings first, then refresh.'**
  String get posPairDeviceHint;

  /// No description provided for @posProOnly.
  ///
  /// In en, this message translates to:
  /// **'PRO ONLY'**
  String get posProOnly;

  /// No description provided for @posUpgradeToProDay.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro  ₹500/mo · just ₹17/day'**
  String get posUpgradeToProDay;

  /// No description provided for @posReceiptSent.
  ///
  /// In en, this message translates to:
  /// **'Receipt sent to printer'**
  String get posReceiptSent;

  /// No description provided for @posPrintFailedCheck.
  ///
  /// In en, this message translates to:
  /// **'Print failed — check printer'**
  String get posPrintFailedCheck;

  /// No description provided for @posOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed!'**
  String get posOrderPlaced;

  /// No description provided for @posOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String posOrderNumber(String id);

  /// No description provided for @posPrintReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get posPrintReceipt;

  /// No description provided for @posNewSale.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get posNewSale;

  /// No description provided for @posViewOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'View Order Details'**
  String get posViewOrderDetails;

  /// No description provided for @posSelectCustomerForUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer for Udhaar sale'**
  String get posSelectCustomerForUdhaar;

  /// No description provided for @posConfirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get posConfirmOrder;

  /// No description provided for @posOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed!'**
  String get posOrderConfirmed;

  /// No description provided for @posSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get posSubtotal;

  /// No description provided for @posReferralDiscount.
  ///
  /// In en, this message translates to:
  /// **'Referral Discount ({pct}%){referrer}'**
  String posReferralDiscount(String pct, String referrer);

  /// No description provided for @posGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get posGrandTotal;

  /// No description provided for @posPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get posPaymentMethod;

  /// No description provided for @posPayCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get posPayCash;

  /// No description provided for @posPayUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Udhaar'**
  String get posPayUdhaar;

  /// No description provided for @posUdhaarDueDate.
  ///
  /// In en, this message translates to:
  /// **'Repayment due'**
  String get posUdhaarDueDate;

  /// No description provided for @posUdhaarDueDateHint.
  ///
  /// In en, this message translates to:
  /// **'When will the customer repay?'**
  String get posUdhaarDueDateHint;

  /// No description provided for @posBundlePercentOff.
  ///
  /// In en, this message translates to:
  /// **'{pct}% OFF'**
  String posBundlePercentOff(int pct);

  /// No description provided for @posBundleYouSave.
  ///
  /// In en, this message translates to:
  /// **'You save {amount}'**
  String posBundleYouSave(String amount);

  /// No description provided for @posBundleRegularPrice.
  ///
  /// In en, this message translates to:
  /// **'Added at regular price (bundle needs all items in stock)'**
  String get posBundleRegularPrice;

  /// No description provided for @posPayUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get posPayUpi;

  /// No description provided for @posComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get posComingSoon;

  /// No description provided for @posSelectCustomerRequired.
  ///
  /// In en, this message translates to:
  /// **'Select customer (required for Udhaar)'**
  String get posSelectCustomerRequired;

  /// No description provided for @posSelectCustomerForUdhaarTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Customer for Udhaar'**
  String get posSelectCustomerForUdhaarTitle;

  /// No description provided for @posSearchNameOrPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone…'**
  String get posSearchNameOrPhoneHint;

  /// No description provided for @posPrintAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Print receipt automatically'**
  String get posPrintAutomatically;

  /// No description provided for @posWillPrintAfter.
  ///
  /// In en, this message translates to:
  /// **'Will print after order is placed'**
  String get posWillPrintAfter;

  /// No description provided for @posPrinterStatus.
  ///
  /// In en, this message translates to:
  /// **'Printer: {status}'**
  String posPrinterStatus(String status);

  /// No description provided for @posAutoPrintDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled — print manually from order details'**
  String get posAutoPrintDisabled;

  /// No description provided for @posConnectPrinterToEnable.
  ///
  /// In en, this message translates to:
  /// **'Connect a Bluetooth printer to enable this'**
  String get posConnectPrinterToEnable;

  /// No description provided for @posCustomDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount (whole bill)'**
  String get posCustomDiscount;

  /// No description provided for @procPayFirst.
  ///
  /// In en, this message translates to:
  /// **'Pay first'**
  String get procPayFirst;

  /// No description provided for @procUnpaid.
  ///
  /// In en, this message translates to:
  /// **'unpaid'**
  String get procUnpaid;

  /// No description provided for @procNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next due'**
  String get procNextDue;

  /// No description provided for @procProductsSupplied.
  ///
  /// In en, this message translates to:
  /// **'Products they supply'**
  String get procProductsSupplied;

  /// No description provided for @procTagProduct.
  ///
  /// In en, this message translates to:
  /// **'Tag product'**
  String get procTagProduct;

  /// No description provided for @procNoTaggedProducts.
  ///
  /// In en, this message translates to:
  /// **'No products tagged yet. Tag what you buy from them — it also fills in automatically when you receive a purchase order.'**
  String get procNoTaggedProducts;

  /// No description provided for @posHowMuchUdhaar.
  ///
  /// In en, this message translates to:
  /// **'How much goes on Udhaar?'**
  String get posHowMuchUdhaar;

  /// No description provided for @posCashNow.
  ///
  /// In en, this message translates to:
  /// **'Cash now'**
  String get posCashNow;

  /// No description provided for @posOnUdhaar.
  ///
  /// In en, this message translates to:
  /// **'On Udhaar'**
  String get posOnUdhaar;

  /// No description provided for @posPrintFailedCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Print failed — check printer connection'**
  String get posPrintFailedCheckConnection;

  /// No description provided for @posTodaysOrders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get posTodaysOrders;

  /// No description provided for @posTransactionsSoFar.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions so far'**
  String posTransactionsSoFar(int count);

  /// No description provided for @posViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get posViewAll;

  /// No description provided for @posNoOrdersToday.
  ///
  /// In en, this message translates to:
  /// **'No orders today yet'**
  String get posNoOrdersToday;

  /// No description provided for @posSalesAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Sales transactions will appear here'**
  String get posSalesAppearHere;

  /// No description provided for @posOrderMeta.
  ///
  /// In en, this message translates to:
  /// **'{time} · {payment} · {status}'**
  String posOrderMeta(String time, String payment, String status);

  /// No description provided for @posPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get posPrint;

  /// No description provided for @posScanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get posScanBarcode;

  /// No description provided for @posAlignBarcode.
  ///
  /// In en, this message translates to:
  /// **'Align barcode within the frame'**
  String get posAlignBarcode;

  /// No description provided for @posLookingUp.
  ///
  /// In en, this message translates to:
  /// **'Looking up…'**
  String get posLookingUp;

  /// No description provided for @posAlreadyInList.
  ///
  /// In en, this message translates to:
  /// **'{name} already in list'**
  String posAlreadyInList(String name);

  /// No description provided for @posItemQty.
  ///
  /// In en, this message translates to:
  /// **'{name} ×{qty}'**
  String posItemQty(String name, int qty);

  /// No description provided for @posItemAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String posItemAdded(String name);

  /// No description provided for @posNotFoundTapAdd.
  ///
  /// In en, this message translates to:
  /// **'Not found — tap to add manually'**
  String get posNotFoundTapAdd;

  /// No description provided for @posItemsScanned.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{item} other{items}} scanned'**
  String posItemsScanned(int count);

  /// No description provided for @posScanItems.
  ///
  /// In en, this message translates to:
  /// **'Scan items'**
  String get posScanItems;

  /// No description provided for @posClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get posClearAll;

  /// No description provided for @posLookingUpItems.
  ///
  /// In en, this message translates to:
  /// **'Looking up {count} {count, plural, =1{item} other{items}}…'**
  String posLookingUpItems(int count);

  /// No description provided for @posAddItemsToCart.
  ///
  /// In en, this message translates to:
  /// **'Add {count} {count, plural, =1{item} other{items}} to Cart  ·  ₹{total}'**
  String posAddItemsToCart(int count, String total);

  /// No description provided for @posPointCamera.
  ///
  /// In en, this message translates to:
  /// **'Point camera at a barcode'**
  String get posPointCamera;

  /// No description provided for @posItemsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Items appear here as you scan'**
  String get posItemsAppearHere;

  /// No description provided for @posTransactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get posTransactionHistory;

  /// No description provided for @posFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters:'**
  String get posFilters;

  /// No description provided for @posClearAllFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get posClearAllFilters;

  /// No description provided for @posNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get posNoTransactions;

  /// No description provided for @posTryAdjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get posTryAdjustFilters;

  /// No description provided for @posResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get posResetFilters;

  /// No description provided for @posFilterTransactions.
  ///
  /// In en, this message translates to:
  /// **'Filter Transactions'**
  String get posFilterTransactions;

  /// No description provided for @posPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get posPaymentStatus;

  /// No description provided for @posFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get posFilterAll;

  /// No description provided for @posStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get posStatusCompleted;

  /// No description provided for @posStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get posStatusPending;

  /// No description provided for @posDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get posDateRange;

  /// No description provided for @posSelectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get posSelectDateRange;

  /// No description provided for @posApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get posApplyFilters;

  /// No description provided for @posOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get posOrderDetails;

  /// No description provided for @posPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get posPaymentLabel;

  /// No description provided for @posTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get posTotalAmount;

  /// No description provided for @posCustomerNumber.
  ///
  /// In en, this message translates to:
  /// **'Customer #{id}'**
  String posCustomerNumber(String id);

  /// No description provided for @posItemsSummary.
  ///
  /// In en, this message translates to:
  /// **'Items Summary'**
  String get posItemsSummary;

  /// No description provided for @posProductNumber.
  ///
  /// In en, this message translates to:
  /// **'Product #{id}'**
  String posProductNumber(String id);

  /// No description provided for @posUnitFallback.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get posUnitFallback;

  /// No description provided for @posPrintReceiptStatus.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt ({status})'**
  String posPrintReceiptStatus(String status);

  /// No description provided for @posReturnExchange.
  ///
  /// In en, this message translates to:
  /// **'Return / Exchange'**
  String get posReturnExchange;

  /// No description provided for @posSplitPayment.
  ///
  /// In en, this message translates to:
  /// **'SPLIT PAYMENT'**
  String get posSplitPayment;

  /// No description provided for @posCashPaidNow.
  ///
  /// In en, this message translates to:
  /// **'Cash paid now'**
  String get posCashPaidNow;

  /// No description provided for @posOnUdhaarCredit.
  ///
  /// In en, this message translates to:
  /// **'On Udhaar (credit)'**
  String get posOnUdhaarCredit;

  /// No description provided for @posUdhaarRecordedNote.
  ///
  /// In en, this message translates to:
  /// **'Udhaar portion recorded as credit — check Udhaar tab for balance'**
  String get posUdhaarRecordedNote;

  /// No description provided for @posUdhaarSale.
  ///
  /// In en, this message translates to:
  /// **'Udhaar Sale'**
  String get posUdhaarSale;

  /// No description provided for @posTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get posTotalPaid;

  /// No description provided for @posRecordedAsCredit.
  ///
  /// In en, this message translates to:
  /// **'Recorded as credit — check Udhaar tab'**
  String get posRecordedAsCredit;

  /// No description provided for @posBoughtAsBasket.
  ///
  /// In en, this message translates to:
  /// **'Bought as a basket'**
  String get posBoughtAsBasket;

  /// No description provided for @posBasketValue.
  ///
  /// In en, this message translates to:
  /// **'Basket value'**
  String get posBasketValue;

  /// No description provided for @posCustomerSaved.
  ///
  /// In en, this message translates to:
  /// **'Customer saved'**
  String get posCustomerSaved;

  /// No description provided for @invSearchItemsOrCategories.
  ///
  /// In en, this message translates to:
  /// **'Search items or categories...'**
  String get invSearchItemsOrCategories;

  /// No description provided for @invShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get invShowLess;

  /// No description provided for @invViewMore.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String invViewMore(int count);

  /// No description provided for @invAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get invAll;

  /// No description provided for @invUncategorised.
  ///
  /// In en, this message translates to:
  /// **'Uncategorised'**
  String get invUncategorised;

  /// No description provided for @invNoMatchesFound.
  ///
  /// In en, this message translates to:
  /// **'No matches found'**
  String get invNoMatchesFound;

  /// No description provided for @invNearExpiryBanner.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item expiring soon — tap to mark down or clear} other{{count} items expiring soon — tap to mark down or clear}}'**
  String invNearExpiryBanner(int count);

  /// No description provided for @invMissingPriceBanner.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product priced ₹0 — tap to set prices} other{{count} products priced ₹0 — tap to set prices}}'**
  String invMissingPriceBanner(int count);

  /// No description provided for @invFlagFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get invFlagFast;

  /// No description provided for @invFlagReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get invFlagReorder;

  /// No description provided for @invFlagLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get invFlagLowStock;

  /// No description provided for @invFlagDead.
  ///
  /// In en, this message translates to:
  /// **'Dead'**
  String get invFlagDead;

  /// No description provided for @invFlagProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get invFlagProfit;

  /// No description provided for @invStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock: {stock}'**
  String invStockLabel(String stock);

  /// No description provided for @invUnitFallback.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get invUnitFallback;

  /// No description provided for @invSyncFailedTapRetry.
  ///
  /// In en, this message translates to:
  /// **'Sync failed — tap to retry'**
  String get invSyncFailedTapRetry;

  /// No description provided for @invSyncingToServer.
  ///
  /// In en, this message translates to:
  /// **'Syncing to server...'**
  String get invSyncingToServer;

  /// No description provided for @invNoInventoryYet.
  ///
  /// In en, this message translates to:
  /// **'No inventory yet'**
  String get invNoInventoryYet;

  /// No description provided for @invNoInventoryHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first product.\nCreate a category first, then add items.'**
  String get invNoInventoryHint;

  /// No description provided for @invAddFirstProduct.
  ///
  /// In en, this message translates to:
  /// **'Add First Product'**
  String get invAddFirstProduct;

  /// No description provided for @invCouldNotLoadInventory.
  ///
  /// In en, this message translates to:
  /// **'Could not load inventory'**
  String get invCouldNotLoadInventory;

  /// No description provided for @invRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get invRetry;

  /// No description provided for @invSelectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get invSelectCategoryError;

  /// No description provided for @invVariantPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Variant {number}: selling price is required'**
  String invVariantPriceRequired(int number);

  /// No description provided for @invProductSavedSyncing.
  ///
  /// In en, this message translates to:
  /// **'Product saved — syncing in background'**
  String get invProductSavedSyncing;

  /// No description provided for @invVariantsSavedSyncing.
  ///
  /// In en, this message translates to:
  /// **'{count} variants saved — syncing in background'**
  String invVariantsSavedSyncing(int count);

  /// No description provided for @invAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get invAddProduct;

  /// No description provided for @invAddFromCatalog.
  ///
  /// In en, this message translates to:
  /// **'Add from Catalog'**
  String get invAddFromCatalog;

  /// No description provided for @invNewProduct.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get invNewProduct;

  /// No description provided for @invSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get invSave;

  /// No description provided for @invSearchProductName.
  ///
  /// In en, this message translates to:
  /// **'Search product name...'**
  String get invSearchProductName;

  /// No description provided for @invLoadMoreResults.
  ///
  /// In en, this message translates to:
  /// **'Load more results'**
  String get invLoadMoreResults;

  /// No description provided for @invNoMoreSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No more search results'**
  String get invNoMoreSearchResults;

  /// No description provided for @invSearchProductCatalog.
  ///
  /// In en, this message translates to:
  /// **'Search the product catalog'**
  String get invSearchProductCatalog;

  /// No description provided for @invSearchCatalogHint.
  ///
  /// In en, this message translates to:
  /// **'Type a name or scan a barcode.\nIf not found, add manually.'**
  String get invSearchCatalogHint;

  /// No description provided for @invAddManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get invAddManually;

  /// No description provided for @invAddManuallySub.
  ///
  /// In en, this message translates to:
  /// **'Product not in catalog? Enter details yourself.'**
  String get invAddManuallySub;

  /// No description provided for @invProductAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added!'**
  String get invProductAdded;

  /// No description provided for @invVariantsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} variants added!'**
  String invVariantsAdded(int count);

  /// No description provided for @invLooseItem.
  ///
  /// In en, this message translates to:
  /// **'Loose item'**
  String get invLooseItem;

  /// No description provided for @invLooseItemSub.
  ///
  /// In en, this message translates to:
  /// **'Sold by weight (e.g. Maida, Pulse)'**
  String get invLooseItemSub;

  /// No description provided for @invBasicDetails.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get invBasicDetails;

  /// No description provided for @invProductNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product name *'**
  String get invProductNameLabel;

  /// No description provided for @invRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get invRequired;

  /// No description provided for @invBrandOptional.
  ///
  /// In en, this message translates to:
  /// **'Brand (optional)'**
  String get invBrandOptional;

  /// No description provided for @invSelectCategoryStar.
  ///
  /// In en, this message translates to:
  /// **'Select category *'**
  String get invSelectCategoryStar;

  /// No description provided for @invOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get invOther;

  /// No description provided for @invPerishableItem.
  ///
  /// In en, this message translates to:
  /// **'Perishable item'**
  String get invPerishableItem;

  /// No description provided for @invPerishableItemSub.
  ///
  /// In en, this message translates to:
  /// **'Has an expiry date'**
  String get invPerishableItemSub;

  /// No description provided for @invSizePriceStock.
  ///
  /// In en, this message translates to:
  /// **'Size, Price & Stock'**
  String get invSizePriceStock;

  /// No description provided for @invVariantsCount.
  ///
  /// In en, this message translates to:
  /// **'Variants ({count})'**
  String invVariantsCount(int count);

  /// No description provided for @invAddVariant.
  ///
  /// In en, this message translates to:
  /// **'Add Variant'**
  String get invAddVariant;

  /// No description provided for @invManageVariants.
  ///
  /// In en, this message translates to:
  /// **'Manage Variants'**
  String get invManageVariants;

  /// No description provided for @invVariants.
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get invVariants;

  /// No description provided for @invEditVariant.
  ///
  /// In en, this message translates to:
  /// **'Edit Variant'**
  String get invEditVariant;

  /// No description provided for @invSaveVariant.
  ///
  /// In en, this message translates to:
  /// **'Save Variant'**
  String get invSaveVariant;

  /// No description provided for @invNoVariantsYet.
  ///
  /// In en, this message translates to:
  /// **'No variants yet. Add sizes, colours or models.'**
  String get invNoVariantsYet;

  /// No description provided for @invStockPerVariantNote.
  ///
  /// In en, this message translates to:
  /// **'Stock is tracked per variant. Use Manage Variants below.'**
  String get invStockPerVariantNote;

  /// No description provided for @invDefaultVariant.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get invDefaultVariant;

  /// No description provided for @invVariantAxisRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose {label}'**
  String invVariantAxisRequired(String label);

  /// No description provided for @invSaveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get invSaveProduct;

  /// No description provided for @invSaveVariants.
  ///
  /// In en, this message translates to:
  /// **'Save {count} Variants'**
  String invSaveVariants(int count);

  /// No description provided for @invProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get invProduct;

  /// No description provided for @invVariantNumber.
  ///
  /// In en, this message translates to:
  /// **'Variant {number}'**
  String invVariantNumber(int number);

  /// No description provided for @invUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get invUnit;

  /// No description provided for @invBaseUnit.
  ///
  /// In en, this message translates to:
  /// **'Base unit'**
  String get invBaseUnit;

  /// No description provided for @invPackSize.
  ///
  /// In en, this message translates to:
  /// **'Pack size'**
  String get invPackSize;

  /// No description provided for @invPackSizeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 250'**
  String get invPackSizeHint;

  /// No description provided for @invBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get invBarcode;

  /// No description provided for @invFromCatalog.
  ///
  /// In en, this message translates to:
  /// **'From catalog'**
  String get invFromCatalog;

  /// No description provided for @invOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get invOptional;

  /// No description provided for @invPricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price / {unit} *'**
  String invPricePerUnit(String unit);

  /// No description provided for @invSellingPriceStar.
  ///
  /// In en, this message translates to:
  /// **'Selling price *'**
  String get invSellingPriceStar;

  /// No description provided for @invInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invInvalid;

  /// No description provided for @invMrp.
  ///
  /// In en, this message translates to:
  /// **'MRP'**
  String get invMrp;

  /// No description provided for @invCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost price (what you pay)'**
  String get invCostPrice;

  /// No description provided for @invCostPriceHint.
  ///
  /// In en, this message translates to:
  /// **'optional — improves profit accuracy'**
  String get invCostPriceHint;

  /// No description provided for @invOpeningStockUnit.
  ///
  /// In en, this message translates to:
  /// **'Opening stock ({unit}) *'**
  String invOpeningStockUnit(String unit);

  /// No description provided for @invOpeningStockUnits.
  ///
  /// In en, this message translates to:
  /// **'Opening stock (units) *'**
  String get invOpeningStockUnits;

  /// No description provided for @invExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get invExpiryDate;

  /// No description provided for @invExpiryDateHint.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get invExpiryDateHint;

  /// No description provided for @invRequiredForPerishables.
  ///
  /// In en, this message translates to:
  /// **'Required for perishables'**
  String get invRequiredForPerishables;

  /// No description provided for @invLinkedFromCatalog.
  ///
  /// In en, this message translates to:
  /// **'Linked from catalog'**
  String get invLinkedFromCatalog;

  /// No description provided for @invSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get invSelectCategory;

  /// No description provided for @invSearchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get invSearchCategories;

  /// No description provided for @invNoCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get invNoCategoriesFound;

  /// No description provided for @invEditProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get invEditProduct;

  /// No description provided for @invProductUpdated.
  ///
  /// In en, this message translates to:
  /// **'{name} updated!'**
  String invProductUpdated(String name);

  /// No description provided for @invProductUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully!'**
  String get invProductUpdatedSuccess;

  /// No description provided for @invSellingUnit.
  ///
  /// In en, this message translates to:
  /// **'Selling unit'**
  String get invSellingUnit;

  /// No description provided for @invPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get invPricing;

  /// No description provided for @invPricePerSelected.
  ///
  /// In en, this message translates to:
  /// **'Price per {unit} *'**
  String invPricePerSelected(String unit);

  /// No description provided for @invMrpOptional.
  ///
  /// In en, this message translates to:
  /// **'MRP (optional)'**
  String get invMrpOptional;

  /// No description provided for @invStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get invStock;

  /// No description provided for @invGstRate.
  ///
  /// In en, this message translates to:
  /// **'GST %'**
  String get invGstRate;

  /// No description provided for @invHsnCode.
  ///
  /// In en, this message translates to:
  /// **'HSN code'**
  String get invHsnCode;

  /// No description provided for @invWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get invWarranty;

  /// No description provided for @invWarrantyCovered.
  ///
  /// In en, this message translates to:
  /// **'Covered under warranty'**
  String get invWarrantyCovered;

  /// No description provided for @invWarrantyCoveredSub.
  ///
  /// In en, this message translates to:
  /// **'Set how long — counted from the purchase date'**
  String get invWarrantyCoveredSub;

  /// No description provided for @invWarrantyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Warranty period'**
  String get invWarrantyPeriod;

  /// No description provided for @invStockInUnit.
  ///
  /// In en, this message translates to:
  /// **'Stock (in {unit}) *'**
  String invStockInUnit(String unit);

  /// No description provided for @invStockQuantityStar.
  ///
  /// In en, this message translates to:
  /// **'Stock quantity *'**
  String get invStockQuantityStar;

  /// No description provided for @invPerishableBatchNote.
  ///
  /// In en, this message translates to:
  /// **'For perishable batch details, use \"Receive Batch\" from inventory.'**
  String get invPerishableBatchNote;

  /// No description provided for @invSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get invSaveChanges;

  /// No description provided for @invCategoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get invCategoryNameRequired;

  /// No description provided for @invCreateCategoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create category. Please try again.'**
  String get invCreateCategoryFailed;

  /// No description provided for @invNewCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get invNewCategory;

  /// No description provided for @invNewCategorySub.
  ///
  /// In en, this message translates to:
  /// **'Add a category to organise your products.'**
  String get invNewCategorySub;

  /// No description provided for @invCategoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created!'**
  String get invCategoryCreated;

  /// No description provided for @invCategoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get invCategoryNameLabel;

  /// No description provided for @invCategoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Staples, Dairy, Snacks…'**
  String get invCategoryNameHint;

  /// No description provided for @invCreateCategory.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get invCreateCategory;

  /// No description provided for @invCardOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get invCardOutOfStock;

  /// No description provided for @invCardStockLow.
  ///
  /// In en, this message translates to:
  /// **'{qty} — low'**
  String invCardStockLow(String qty);

  /// No description provided for @invCardStockInStock.
  ///
  /// In en, this message translates to:
  /// **'{qty} in stock'**
  String invCardStockInStock(String qty);

  /// No description provided for @invCardFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get invCardFast;

  /// No description provided for @invCardSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get invCardSlow;

  /// No description provided for @invCardExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get invCardExpired;

  /// No description provided for @invCardDays.
  ///
  /// In en, this message translates to:
  /// **'{days}d'**
  String invCardDays(String days);

  /// No description provided for @invCardBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get invCardBarcode;

  /// No description provided for @invCardSoldToday.
  ///
  /// In en, this message translates to:
  /// **'Sold today'**
  String get invCardSoldToday;

  /// No description provided for @invCardReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get invCardReorder;

  /// No description provided for @invCardReorderUnits.
  ///
  /// In en, this message translates to:
  /// **'{qty} units'**
  String invCardReorderUnits(String qty);

  /// No description provided for @invCard7dRisk.
  ///
  /// In en, this message translates to:
  /// **'7d risk'**
  String get invCard7dRisk;

  /// No description provided for @invExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get invExpiringSoon;

  /// No description provided for @invNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get invNext;

  /// No description provided for @invDaysWindow.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String invDaysWindow(int days);

  /// No description provided for @invExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get invExpired;

  /// No description provided for @invExpiresToday.
  ///
  /// In en, this message translates to:
  /// **'Expires today'**
  String get invExpiresToday;

  /// No description provided for @invExpiresTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Expires tomorrow'**
  String get invExpiresTomorrow;

  /// No description provided for @invExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Expires in {days} days'**
  String invExpiresInDays(int days);

  /// No description provided for @invQtyInStock.
  ///
  /// In en, this message translates to:
  /// **'{qty} {unit} in stock'**
  String invQtyInStock(String qty, String unit);

  /// No description provided for @invAtRisk.
  ///
  /// In en, this message translates to:
  /// **'At risk'**
  String get invAtRisk;

  /// No description provided for @invMarkedDown.
  ///
  /// In en, this message translates to:
  /// **'Marked down'**
  String get invMarkedDown;

  /// No description provided for @invPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get invPrice;

  /// No description provided for @invChangeMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Change markdown'**
  String get invChangeMarkdown;

  /// No description provided for @invMarkDown.
  ///
  /// In en, this message translates to:
  /// **'Mark down'**
  String get invMarkDown;

  /// No description provided for @invRecordWaste.
  ///
  /// In en, this message translates to:
  /// **'Record waste'**
  String get invRecordWaste;

  /// No description provided for @invMarkDownTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark down {name}'**
  String invMarkDownTitle(String name);

  /// No description provided for @invClearanceDiscount.
  ///
  /// In en, this message translates to:
  /// **'Clearance discount to sell before expiry'**
  String get invClearanceDiscount;

  /// No description provided for @invPctSuggested.
  ///
  /// In en, this message translates to:
  /// **'{pct}% (suggested)'**
  String invPctSuggested(String pct);

  /// No description provided for @invPct.
  ///
  /// In en, this message translates to:
  /// **'{pct}%'**
  String invPct(String pct);

  /// No description provided for @invCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get invCustom;

  /// No description provided for @invApplyMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Apply markdown'**
  String get invApplyMarkdown;

  /// No description provided for @invMarkdownApplied.
  ///
  /// In en, this message translates to:
  /// **'Markdown applied'**
  String get invMarkdownApplied;

  /// No description provided for @invMarkdownFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not apply markdown'**
  String get invMarkdownFailed;

  /// No description provided for @invWriteOff.
  ///
  /// In en, this message translates to:
  /// **'Write off {name}'**
  String invWriteOff(String name);

  /// No description provided for @invWriteOffSub.
  ///
  /// In en, this message translates to:
  /// **'Removes spoiled units from stock and records the loss.'**
  String get invWriteOffSub;

  /// No description provided for @invOfQtyInStock.
  ///
  /// In en, this message translates to:
  /// **'of {qty} in stock'**
  String invOfQtyInStock(int qty);

  /// No description provided for @invUnitsWrittenOff.
  ///
  /// In en, this message translates to:
  /// **'{units} units written off'**
  String invUnitsWrittenOff(int units);

  /// No description provided for @invWasteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not record waste'**
  String get invWasteFailed;

  /// No description provided for @invNothingExpiring.
  ///
  /// In en, this message translates to:
  /// **'Nothing expiring soon'**
  String get invNothingExpiring;

  /// No description provided for @invNothingExpiringSub.
  ///
  /// In en, this message translates to:
  /// **'Perishable batches nearing expiry will show up here.'**
  String get invNothingExpiringSub;

  /// No description provided for @invCouldNotLoadExpiry.
  ///
  /// In en, this message translates to:
  /// **'Could not load expiry data'**
  String get invCouldNotLoadExpiry;

  /// No description provided for @invMissingPrices.
  ///
  /// In en, this message translates to:
  /// **'Missing Prices'**
  String get invMissingPrices;

  /// No description provided for @invCouldNotLoadPrices.
  ///
  /// In en, this message translates to:
  /// **'Could not load prices'**
  String get invCouldNotLoadPrices;

  /// No description provided for @invStockCurrentlyZero.
  ///
  /// In en, this message translates to:
  /// **'{qty} {unit} in stock · currently ₹0'**
  String invStockCurrentlyZero(String qty, String unit);

  /// No description provided for @invSuggestedPrice.
  ///
  /// In en, this message translates to:
  /// **'Suggested ₹{price} ({source})'**
  String invSuggestedPrice(String price, String source);

  /// No description provided for @invSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling price'**
  String get invSellingPrice;

  /// No description provided for @invSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get invSet;

  /// No description provided for @invEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get invEnterValidPrice;

  /// No description provided for @invProductPriced.
  ///
  /// In en, this message translates to:
  /// **'{name} priced ₹{price}'**
  String invProductPriced(String name, String price);

  /// No description provided for @invCouldNotSetPrice.
  ///
  /// In en, this message translates to:
  /// **'Could not set price'**
  String get invCouldNotSetPrice;

  /// No description provided for @invEveryProductPriced.
  ///
  /// In en, this message translates to:
  /// **'Every product is priced'**
  String get invEveryProductPriced;

  /// No description provided for @invEveryProductPricedSub.
  ///
  /// In en, this message translates to:
  /// **'Nothing is selling at ₹0. Good going!'**
  String get invEveryProductPricedSub;

  /// No description provided for @finFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finFinance;

  /// No description provided for @finErrorLoadingStats.
  ///
  /// In en, this message translates to:
  /// **'Error loading stats'**
  String get finErrorLoadingStats;

  /// No description provided for @finTabCashflow.
  ///
  /// In en, this message translates to:
  /// **'Cashflow'**
  String get finTabCashflow;

  /// No description provided for @finTabCustomerUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Customer\nUdhaar'**
  String get finTabCustomerUdhaar;

  /// No description provided for @finTabSupplierUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Supplier Udhaar'**
  String get finTabSupplierUdhaar;

  /// No description provided for @finMonthlySales.
  ///
  /// In en, this message translates to:
  /// **'Monthly Sales'**
  String get finMonthlySales;

  /// No description provided for @finMonthlySkus.
  ///
  /// In en, this message translates to:
  /// **'Monthly SKUs'**
  String get finMonthlySkus;

  /// No description provided for @finAvailableInFuture.
  ///
  /// In en, this message translates to:
  /// **'Will be available in future updates'**
  String get finAvailableInFuture;

  /// No description provided for @finFailedLoadUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Failed to load udhaar data'**
  String get finFailedLoadUdhaar;

  /// No description provided for @finCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get finCheckConnection;

  /// No description provided for @finRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get finRetry;

  /// No description provided for @finCustomerDues.
  ///
  /// In en, this message translates to:
  /// **'Customer Dues'**
  String get finCustomerDues;

  /// No description provided for @finNewUdhaar.
  ///
  /// In en, this message translates to:
  /// **'New Udhaar'**
  String get finNewUdhaar;

  /// No description provided for @finAddNewUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Add New Udhaar'**
  String get finAddNewUdhaar;

  /// No description provided for @finContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get finContacts;

  /// No description provided for @finSelectExistingCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select existing customer'**
  String get finSelectExistingCustomer;

  /// No description provided for @finOrEnterManually.
  ///
  /// In en, this message translates to:
  /// **'or enter manually'**
  String get finOrEnterManually;

  /// No description provided for @finUdhaarRecorded.
  ///
  /// In en, this message translates to:
  /// **'Udhaar recorded!'**
  String get finUdhaarRecorded;

  /// No description provided for @finCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get finCustomerName;

  /// No description provided for @finPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get finPhoneNumber;

  /// No description provided for @finAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get finAmount;

  /// No description provided for @finSaveUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Save Udhaar'**
  String get finSaveUdhaar;

  /// No description provided for @finEnterValidNamePhoneAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter valid name, phone and amount'**
  String get finEnterValidNamePhoneAmount;

  /// No description provided for @finSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get finSelectCustomer;

  /// No description provided for @finSearchByNameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone...'**
  String get finSearchByNameOrPhone;

  /// No description provided for @finNoCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get finNoCustomersFound;

  /// No description provided for @finTotalPending.
  ///
  /// In en, this message translates to:
  /// **'Total Pending'**
  String get finTotalPending;

  /// No description provided for @finRecovered.
  ///
  /// In en, this message translates to:
  /// **'Recovered'**
  String get finRecovered;

  /// No description provided for @finCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get finCustomers;

  /// No description provided for @finHighRiskDues.
  ///
  /// In en, this message translates to:
  /// **'{count} high-risk due{count, plural, =1{} other{s}} — chase these first'**
  String finHighRiskDues(int count);

  /// No description provided for @finSmartRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Reminders — recovery-ranked dues'**
  String get finSmartRemindersSubtitle;

  /// No description provided for @finTakenDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Taken: {date} ({days} days ago)'**
  String finTakenDaysAgo(String date, int days);

  /// No description provided for @finWhatsappReminderSent.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp reminder sent!'**
  String get finWhatsappReminderSent;

  /// No description provided for @finFailedSendReminder.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reminder: {error}'**
  String finFailedSendReminder(String error);

  /// No description provided for @finSendWhatsappReminder.
  ///
  /// In en, this message translates to:
  /// **'Send WhatsApp Reminder'**
  String get finSendWhatsappReminder;

  /// No description provided for @finRemind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get finRemind;

  /// No description provided for @finRemindedToday.
  ///
  /// In en, this message translates to:
  /// **'Reminded today'**
  String get finRemindedToday;

  /// No description provided for @finRecover.
  ///
  /// In en, this message translates to:
  /// **'Recover'**
  String get finRecover;

  /// No description provided for @finHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get finHistory;

  /// No description provided for @finSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get finSettled;

  /// No description provided for @finRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get finRecordPayment;

  /// No description provided for @finPaymentOldestFirstNote.
  ///
  /// In en, this message translates to:
  /// **'Applied to oldest dues first'**
  String get finPaymentOldestFirstNote;

  /// No description provided for @finTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get finTaken;

  /// No description provided for @finPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get finPaid;

  /// No description provided for @finBalanceShort.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get finBalanceShort;

  /// No description provided for @finOpenDuesSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} open · oldest {days}d'**
  String finOpenDuesSummary(int count, int days);

  /// No description provided for @finSettledSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Settled ({count})'**
  String finSettledSectionTitle(int count);

  /// No description provided for @finRecoverUdhaarFrom.
  ///
  /// In en, this message translates to:
  /// **'Recover Udhaar from {name}'**
  String finRecoverUdhaarFrom(String name);

  /// No description provided for @finRecoveryRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recovery recorded!'**
  String get finRecoveryRecorded;

  /// No description provided for @finBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance: ₹{value}'**
  String finBalanceLabel(String value);

  /// No description provided for @finConfirmRecovery.
  ///
  /// In en, this message translates to:
  /// **'Confirm Recovery'**
  String get finConfirmRecovery;

  /// No description provided for @finEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get finEnterValidAmount;

  /// No description provided for @finAmountExceedsBalance.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed balance ₹{value}'**
  String finAmountExceedsBalance(String value);

  /// No description provided for @finNoPendingUdhaars.
  ///
  /// In en, this message translates to:
  /// **'No pending udhaars'**
  String get finNoPendingUdhaars;

  /// No description provided for @finRecoveryHistory.
  ///
  /// In en, this message translates to:
  /// **'Recovery History'**
  String get finRecoveryHistory;

  /// No description provided for @finNoRecoveriesYet.
  ///
  /// In en, this message translates to:
  /// **'No recoveries recorded yet.'**
  String get finNoRecoveriesYet;

  /// No description provided for @finRecoveryNumber.
  ///
  /// In en, this message translates to:
  /// **'Recovery #{number}'**
  String finRecoveryNumber(int number);

  /// No description provided for @finErrorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String finErrorWithMessage(String message);

  /// No description provided for @finOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get finOverdue;

  /// No description provided for @finDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get finDueToday;

  /// No description provided for @finNext7Days.
  ///
  /// In en, this message translates to:
  /// **'Next 7 Days'**
  String get finNext7Days;

  /// No description provided for @finNoPendingPayments7Days.
  ///
  /// In en, this message translates to:
  /// **'No pending payments in the next 7 days'**
  String get finNoPendingPayments7Days;

  /// No description provided for @finPaidLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Paid Last 7 Days'**
  String get finPaidLast7Days;

  /// No description provided for @finNoPaymentsRecorded7Days.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded in the last 7 days'**
  String get finNoPaymentsRecorded7Days;

  /// No description provided for @finSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get finSuppliers;

  /// No description provided for @finAddEditSuppliersHint.
  ///
  /// In en, this message translates to:
  /// **'Add or edit suppliers in the Purchase tab'**
  String get finAddEditSuppliersHint;

  /// No description provided for @finNoSuppliersYet.
  ///
  /// In en, this message translates to:
  /// **'No suppliers yet.'**
  String get finNoSuppliersYet;

  /// No description provided for @finTotalOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Total Outstanding'**
  String get finTotalOutstanding;

  /// No description provided for @finToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get finToday;

  /// No description provided for @finPaid7d.
  ///
  /// In en, this message translates to:
  /// **'Paid (7d)'**
  String get finPaid7d;

  /// No description provided for @finStockPurchase.
  ///
  /// In en, this message translates to:
  /// **'Stock Purchase'**
  String get finStockPurchase;

  /// No description provided for @finOverdueSince.
  ///
  /// In en, this message translates to:
  /// **'Overdue since {date}'**
  String finOverdueSince(String date);

  /// No description provided for @finDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {day}'**
  String finDueOn(String day);

  /// No description provided for @finDueTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get finDueTodayLabel;

  /// No description provided for @finToPay.
  ///
  /// In en, this message translates to:
  /// **'to pay'**
  String get finToPay;

  /// No description provided for @finDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get finDetails;

  /// No description provided for @finMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark Paid'**
  String get finMarkPaid;

  /// No description provided for @finPurchaseOn.
  ///
  /// In en, this message translates to:
  /// **'Purchase on {date}'**
  String finPurchaseOn(String date);

  /// No description provided for @finNoItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found.'**
  String get finNoItemsFound;

  /// No description provided for @finTotalBill.
  ///
  /// In en, this message translates to:
  /// **'Total Bill'**
  String get finTotalBill;

  /// No description provided for @finTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get finTomorrow;

  /// No description provided for @finWeekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get finWeekdayMon;

  /// No description provided for @finWeekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get finWeekdayTue;

  /// No description provided for @finWeekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get finWeekdayWed;

  /// No description provided for @finWeekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get finWeekdayThu;

  /// No description provided for @finWeekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get finWeekdayFri;

  /// No description provided for @finWeekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get finWeekdaySat;

  /// No description provided for @finWeekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get finWeekdaySun;

  /// No description provided for @finFailedLoadCashflow.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cashflow data'**
  String get finFailedLoadCashflow;

  /// No description provided for @finIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get finIncome;

  /// No description provided for @finTodaysSales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get finTodaysSales;

  /// No description provided for @finCreditExposureUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Credit Exposure (Udhaar)'**
  String get finCreditExposureUdhaar;

  /// No description provided for @finOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get finOutstanding;

  /// No description provided for @finCustomersWithPendingDues.
  ///
  /// In en, this message translates to:
  /// **'Customers with pending dues'**
  String get finCustomersWithPendingDues;

  /// No description provided for @finCustomersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} customers'**
  String finCustomersCount(int count);

  /// No description provided for @finCreditVsSalesRatio.
  ///
  /// In en, this message translates to:
  /// **'Credit vs Sales Ratio'**
  String get finCreditVsSalesRatio;

  /// No description provided for @finPercentOnCredit.
  ///
  /// In en, this message translates to:
  /// **'{value}% on credit'**
  String finPercentOnCredit(String value);

  /// No description provided for @finOfMonthly.
  ///
  /// In en, this message translates to:
  /// **'of {value} monthly'**
  String finOfMonthly(String value);

  /// No description provided for @finCreditHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy — credit exposure is low'**
  String get finCreditHealthy;

  /// No description provided for @finCreditModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate — consider collecting dues'**
  String get finCreditModerate;

  /// No description provided for @finCreditHigh.
  ///
  /// In en, this message translates to:
  /// **'High — many sales are on credit'**
  String get finCreditHigh;

  /// No description provided for @finConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Record customer consent'**
  String get finConsentTitle;

  /// No description provided for @finConsentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Voice confirmation of this udhaar'**
  String get finConsentSubtitle;

  /// No description provided for @finConsentScriptIntro.
  ///
  /// In en, this message translates to:
  /// **'ASK THE CUSTOMER TO SAY:'**
  String get finConsentScriptIntro;

  /// No description provided for @finConsentScript.
  ///
  /// In en, this message translates to:
  /// **'I agree — total {total}, udhaar {udhaar}, I will repay by {date}.'**
  String finConsentScript(String total, String udhaar, String date);

  /// No description provided for @finConsentTapToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic and let the customer speak'**
  String get finConsentTapToRecord;

  /// No description provided for @finConsentRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get finConsentRecording;

  /// No description provided for @finConsentSaved.
  ///
  /// In en, this message translates to:
  /// **'Consent saved — uploading in background'**
  String get finConsentSaved;

  /// No description provided for @finConsentSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get finConsentSkip;

  /// No description provided for @finConsentSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice consent'**
  String get finConsentSectionTitle;

  /// No description provided for @finConsentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Uploaded · analysis pending'**
  String get finConsentStatusPending;

  /// No description provided for @finConsentStatusAnalyzed.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get finConsentStatusAnalyzed;

  /// No description provided for @finConsentMatchScore.
  ///
  /// In en, this message translates to:
  /// **'Voice match: {pct}%'**
  String finConsentMatchScore(String pct);

  /// No description provided for @finConsentNone.
  ///
  /// In en, this message translates to:
  /// **'No voice consent recorded'**
  String get finConsentNone;

  /// No description provided for @finDueDate.
  ///
  /// In en, this message translates to:
  /// **'Repayment due date'**
  String get finDueDate;

  /// No description provided for @finDueDateHint.
  ///
  /// In en, this message translates to:
  /// **'When will the customer repay?'**
  String get finDueDateHint;

  /// No description provided for @finDueBy.
  ///
  /// In en, this message translates to:
  /// **'Due by {date}'**
  String finDueBy(String date);

  /// No description provided for @finClearingDues.
  ///
  /// In en, this message translates to:
  /// **'Clearing {count, plural, =1{1 due} other{{count} dues}}…'**
  String finClearingDues(int count);

  /// No description provided for @finDuesCleared.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 due cleared} other{{count} dues cleared}}'**
  String finDuesCleared(int count);

  /// No description provided for @finClearingDuesProgress.
  ///
  /// In en, this message translates to:
  /// **'Clearing dues: {cleared}/{total}'**
  String finClearingDuesProgress(int cleared, int total);

  /// No description provided for @finDuesClearFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t clear all dues ({cleared}/{total})'**
  String finDuesClearFailed(int cleared, int total);

  /// No description provided for @finSmartReminders.
  ///
  /// In en, this message translates to:
  /// **'Smart Reminders'**
  String get finSmartReminders;

  /// No description provided for @finCouldNotLoadReminders.
  ///
  /// In en, this message translates to:
  /// **'Could not load reminders'**
  String get finCouldNotLoadReminders;

  /// No description provided for @finDaysPending.
  ///
  /// In en, this message translates to:
  /// **'{days} days pending'**
  String finDaysPending(int days);

  /// No description provided for @finRiskBadge.
  ///
  /// In en, this message translates to:
  /// **'{band} RISK'**
  String finRiskBadge(String band);

  /// No description provided for @finLikelyToRecover.
  ///
  /// In en, this message translates to:
  /// **'~{percent}% likely to recover'**
  String finLikelyToRecover(int percent);

  /// No description provided for @finSendReminder.
  ///
  /// In en, this message translates to:
  /// **'Send reminder'**
  String get finSendReminder;

  /// No description provided for @finReminderSentTo.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent to {name}'**
  String finReminderSentTo(String name);

  /// No description provided for @finCouldNotSendReminder.
  ///
  /// In en, this message translates to:
  /// **'Could not send reminder'**
  String get finCouldNotSendReminder;

  /// No description provided for @finNoOpenUdhaar.
  ///
  /// In en, this message translates to:
  /// **'No open udhaar'**
  String get finNoOpenUdhaar;

  /// No description provided for @finAllCreditSettled.
  ///
  /// In en, this message translates to:
  /// **'All credit is settled. Nice and clean!'**
  String get finAllCreditSettled;

  /// No description provided for @procAddSupplierFirstToCreatePo.
  ///
  /// In en, this message translates to:
  /// **'Add a supplier first to create a purchase order'**
  String get procAddSupplierFirstToCreatePo;

  /// No description provided for @procErrorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String procErrorWithMessage(String message);

  /// No description provided for @procSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get procSuppliers;

  /// No description provided for @procNoSuppliersYet.
  ///
  /// In en, this message translates to:
  /// **'No suppliers added yet.'**
  String get procNoSuppliersYet;

  /// No description provided for @procRecentPurchases.
  ///
  /// In en, this message translates to:
  /// **'Recent Purchases'**
  String get procRecentPurchases;

  /// No description provided for @procAddAtLeastOneSupplier.
  ///
  /// In en, this message translates to:
  /// **'If you want to add a purchase, add at least 1 supplier.'**
  String get procAddAtLeastOneSupplier;

  /// No description provided for @procNoPurchaseOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No purchase orders yet.'**
  String get procNoPurchaseOrdersYet;

  /// No description provided for @procScanInvoice.
  ///
  /// In en, this message translates to:
  /// **'Scan Invoice'**
  String get procScanInvoice;

  /// No description provided for @procAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get procAdd;

  /// No description provided for @procSuggestedReorders.
  ///
  /// In en, this message translates to:
  /// **'Suggested Reorders'**
  String get procSuggestedReorders;

  /// No description provided for @procRunningLowLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Running low based on the last 30 days of sales'**
  String get procRunningLowLast30Days;

  /// No description provided for @procAddNewSupplier.
  ///
  /// In en, this message translates to:
  /// **'Add New Supplier'**
  String get procAddNewSupplier;

  /// No description provided for @procContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get procContacts;

  /// No description provided for @procSupplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier Name'**
  String get procSupplierName;

  /// No description provided for @procPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get procPhoneNumber;

  /// No description provided for @procCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Category (e.g. Dairy, FMCG)'**
  String get procCategoryHint;

  /// No description provided for @procEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get procEnterValidPhone;

  /// No description provided for @procSaveSupplier.
  ///
  /// In en, this message translates to:
  /// **'Save Supplier'**
  String get procSaveSupplier;

  /// No description provided for @procEditSupplier.
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get procEditSupplier;

  /// No description provided for @procSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get procSaveChanges;

  /// No description provided for @procNewPurchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'New Purchase Order'**
  String get procNewPurchaseOrder;

  /// No description provided for @procRecordItemsFromDistributor.
  ///
  /// In en, this message translates to:
  /// **'Record items purchased from a distributor.'**
  String get procRecordItemsFromDistributor;

  /// No description provided for @procOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get procOrderDetails;

  /// No description provided for @procDistributor.
  ///
  /// In en, this message translates to:
  /// **'Distributor'**
  String get procDistributor;

  /// No description provided for @procPaymentDueDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Due Date'**
  String get procPaymentDueDate;

  /// No description provided for @procSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get procSelectDate;

  /// No description provided for @procItemsCount.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String procItemsCount(int count);

  /// No description provided for @procAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get procAddItem;

  /// No description provided for @procNoItemsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No items added yet'**
  String get procNoItemsAddedYet;

  /// No description provided for @procNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get procNotes;

  /// No description provided for @procNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Bill number, delivery notes, etc.'**
  String get procNotesHint;

  /// No description provided for @procTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get procTotalAmount;

  /// No description provided for @procSaveOrder.
  ///
  /// In en, this message translates to:
  /// **'Save Order'**
  String get procSaveOrder;

  /// No description provided for @procSearchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search product...'**
  String get procSearchProduct;

  /// No description provided for @procAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add {name}'**
  String procAddProduct(String name);

  /// No description provided for @procQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get procQuantity;

  /// No description provided for @procCostPricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Cost Price per unit'**
  String get procCostPricePerUnit;

  /// No description provided for @procCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get procCancel;

  /// No description provided for @procDaysCover.
  ///
  /// In en, this message translates to:
  /// **'{days}d cover'**
  String procDaysCover(String days);

  /// No description provided for @procOrderQty.
  ///
  /// In en, this message translates to:
  /// **'Order {qty}'**
  String procOrderQty(String qty);

  /// No description provided for @procStockLine.
  ///
  /// In en, this message translates to:
  /// **'Stock {stock} · ~{perDay}/day · {cover}'**
  String procStockLine(String stock, String perDay, String cover);

  /// No description provided for @procCreatePurchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Create purchase order'**
  String get procCreatePurchaseOrder;

  /// No description provided for @procEditSupplierTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit supplier'**
  String get procEditSupplierTooltip;

  /// No description provided for @procMarkAsReceived.
  ///
  /// In en, this message translates to:
  /// **'Mark as Received'**
  String get procMarkAsReceived;

  /// No description provided for @procPleaseSelectSupplierFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a supplier first'**
  String get procPleaseSelectSupplierFirst;

  /// No description provided for @procFromScannedInvoice.
  ///
  /// In en, this message translates to:
  /// **'From scanned invoice'**
  String get procFromScannedInvoice;

  /// No description provided for @procPoCreatedWithUnmatched.
  ///
  /// In en, this message translates to:
  /// **'Purchase order created! ({count} item{count, plural, one{} other{s}} not matched)'**
  String procPoCreatedWithUnmatched(int count);

  /// No description provided for @procPoCreatedFromInvoice.
  ///
  /// In en, this message translates to:
  /// **'Purchase order created from invoice!'**
  String get procPoCreatedFromInvoice;

  /// No description provided for @procCameraGalleryPdf.
  ///
  /// In en, this message translates to:
  /// **'Camera · Gallery · PDF'**
  String get procCameraGalleryPdf;

  /// No description provided for @procScansLabel.
  ///
  /// In en, this message translates to:
  /// **'scans'**
  String get procScansLabel;

  /// No description provided for @procScanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get procScanAgain;

  /// No description provided for @procInvoiceScanProFeature.
  ///
  /// In en, this message translates to:
  /// **'Invoice Scan is a Pro feature.'**
  String get procInvoiceScanProFeature;

  /// No description provided for @procUpgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get procUpgradeToPro;

  /// No description provided for @procDailyLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Daily limit reached. Top up credits to continue.'**
  String get procDailyLimitReached;

  /// No description provided for @procBuyCredits.
  ///
  /// In en, this message translates to:
  /// **'Buy Credits'**
  String get procBuyCredits;

  /// No description provided for @procCreatingPurchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Creating purchase order…'**
  String get procCreatingPurchaseOrder;

  /// No description provided for @procPurchaseOrderCreated.
  ///
  /// In en, this message translates to:
  /// **'Purchase order created!'**
  String get procPurchaseOrderCreated;

  /// No description provided for @procTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get procTryAgain;

  /// No description provided for @procCaptureOrUploadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Capture or upload a supplier invoice'**
  String get procCaptureOrUploadInvoice;

  /// No description provided for @procUpgradeOrTopUp.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro or top up credits'**
  String get procUpgradeOrTopUp;

  /// No description provided for @procKiranaAiReadsInvoice.
  ///
  /// In en, this message translates to:
  /// **'Outlet AI reads items, totals & supplier details'**
  String get procKiranaAiReadsInvoice;

  /// No description provided for @procCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get procCamera;

  /// No description provided for @procGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get procGallery;

  /// No description provided for @procUploadPdfImageFile.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF / Image File'**
  String get procUploadPdfImageFile;

  /// No description provided for @procKiranaAiReadingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Outlet AI is reading your invoice…'**
  String get procKiranaAiReadingInvoice;

  /// No description provided for @procExtractingItems.
  ///
  /// In en, this message translates to:
  /// **'Extracting items, quantities and totals'**
  String get procExtractingItems;

  /// No description provided for @procGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get procGrandTotal;

  /// No description provided for @procSupplierUpper.
  ///
  /// In en, this message translates to:
  /// **'SUPPLIER'**
  String get procSupplierUpper;

  /// No description provided for @procItemsUpperCount.
  ///
  /// In en, this message translates to:
  /// **'ITEMS ({count})'**
  String procItemsUpperCount(int count);

  /// No description provided for @procMatchedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} matched'**
  String procMatchedCount(int count);

  /// No description provided for @procUnmatchedItemsWarning.
  ///
  /// In en, this message translates to:
  /// **'{count} unmatched item{count, plural, one{} other{s}} will not be added as line items, but the full invoice total will be recorded.'**
  String procUnmatchedItemsWarning(int count);

  /// No description provided for @procSelectSupplierToContinue.
  ///
  /// In en, this message translates to:
  /// **'Select a supplier to continue'**
  String get procSelectSupplierToContinue;

  /// No description provided for @procCreatePurchaseOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Purchase Order'**
  String get procCreatePurchaseOrderTitle;

  /// No description provided for @procConfidencePercent.
  ///
  /// In en, this message translates to:
  /// **'{pct}% confidence'**
  String procConfidencePercent(int pct);

  /// No description provided for @procTotalsMatch.
  ///
  /// In en, this message translates to:
  /// **'✓ Totals match'**
  String get procTotalsMatch;

  /// No description provided for @procTotalMismatch.
  ///
  /// In en, this message translates to:
  /// **'⚠ Total mismatch'**
  String get procTotalMismatch;

  /// No description provided for @procUnverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get procUnverified;

  /// No description provided for @procPick.
  ///
  /// In en, this message translates to:
  /// **'Pick'**
  String get procPick;

  /// No description provided for @procNoMatchTapToSelect.
  ///
  /// In en, this message translates to:
  /// **'No match for \"{vendor}\" — tap to select'**
  String procNoMatchTapToSelect(String vendor);

  /// No description provided for @procSelectSupplier.
  ///
  /// In en, this message translates to:
  /// **'Select supplier'**
  String get procSelectSupplier;

  /// No description provided for @procSelectSupplierTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Supplier'**
  String get procSelectSupplierTitle;

  /// No description provided for @procNoSuppliersAddInPurchaseTab.
  ///
  /// In en, this message translates to:
  /// **'No suppliers yet. Add suppliers in the Purchase tab.'**
  String get procNoSuppliersAddInPurchaseTab;

  /// No description provided for @procLinkToInventory.
  ///
  /// In en, this message translates to:
  /// **'Link to Inventory'**
  String get procLinkToInventory;

  /// No description provided for @procSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products…'**
  String get procSearchProducts;

  /// No description provided for @procNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get procNoProductsFound;

  /// No description provided for @procPriceStockLabel.
  ///
  /// In en, this message translates to:
  /// **'{price} · Stock: {stock}'**
  String procPriceStockLabel(String price, String stock);

  /// No description provided for @procMicPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied. Please enable it in Settings.'**
  String get procMicPermissionDenied;

  /// No description provided for @procMicNotAccessible.
  ///
  /// In en, this message translates to:
  /// **'Microphone not accessible.'**
  String get procMicNotAccessible;

  /// No description provided for @procAddedToCartFromVoice.
  ///
  /// In en, this message translates to:
  /// **'{count} item{count, plural, one{} other{s}} added to cart from voice order'**
  String procAddedToCartFromVoice(int count);

  /// No description provided for @procVoiceOrder.
  ///
  /// In en, this message translates to:
  /// **'Voice Order'**
  String get procVoiceOrder;

  /// No description provided for @procSpeakAnyIndianLanguage.
  ///
  /// In en, this message translates to:
  /// **'Speak in any Indian language'**
  String get procSpeakAnyIndianLanguage;

  /// No description provided for @procVoiceOrderProFeature.
  ///
  /// In en, this message translates to:
  /// **'Voice Order is a Pro feature. Upgrade to access.'**
  String get procVoiceOrderProFeature;

  /// No description provided for @procUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get procUpgrade;

  /// No description provided for @procNoVoiceOrdersLeft.
  ///
  /// In en, this message translates to:
  /// **'No voice orders left today. Get more credits.'**
  String get procNoVoiceOrdersLeft;

  /// No description provided for @procGetCredits.
  ///
  /// In en, this message translates to:
  /// **'Get Credits'**
  String get procGetCredits;

  /// No description provided for @procVoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'voice'**
  String get procVoiceLabel;

  /// No description provided for @procTapMicToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap mic to start recording'**
  String get procTapMicToStart;

  /// No description provided for @procTapToStopAndProcess.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop & process'**
  String get procTapToStopAndProcess;

  /// No description provided for @procKiranaAiProcessing.
  ///
  /// In en, this message translates to:
  /// **'Outlet AI is processing…'**
  String get procKiranaAiProcessing;

  /// No description provided for @procHeard.
  ///
  /// In en, this message translates to:
  /// **'Heard'**
  String get procHeard;

  /// No description provided for @procNoItemsDetectedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'No items detected. Please try again.'**
  String get procNoItemsDetectedTryAgain;

  /// No description provided for @procRecordAgain.
  ///
  /// In en, this message translates to:
  /// **'Record Again'**
  String get procRecordAgain;

  /// No description provided for @procAddToCartCount.
  ///
  /// In en, this message translates to:
  /// **'Add {count} to Cart'**
  String procAddToCartCount(int count);

  /// No description provided for @procAutoDetectsLanguages.
  ///
  /// In en, this message translates to:
  /// **'Auto-detects: Telugu · Hindi · Urdu · Tamil · Kannada · Malayalam · English'**
  String get procAutoDetectsLanguages;

  /// No description provided for @procInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get procInStock;

  /// No description provided for @procLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get procLowStock;

  /// No description provided for @procNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get procNotFound;

  /// No description provided for @procPickFromInventory.
  ///
  /// In en, this message translates to:
  /// **'Pick from Inventory'**
  String get procPickFromInventory;

  /// No description provided for @procAddedToCartFromHandwriting.
  ///
  /// In en, this message translates to:
  /// **'{count} item{count, plural, one{} other{s}} added to cart from handwriting'**
  String procAddedToCartFromHandwriting(int count);

  /// No description provided for @procCanvasNotReady.
  ///
  /// In en, this message translates to:
  /// **'Canvas not ready'**
  String get procCanvasNotReady;

  /// No description provided for @procFailedToCaptureCanvas.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture canvas'**
  String get procFailedToCaptureCanvas;

  /// No description provided for @procHandwriteOrder.
  ///
  /// In en, this message translates to:
  /// **'Handwrite Order'**
  String get procHandwriteOrder;

  /// No description provided for @procWriteItemsAnyScript.
  ///
  /// In en, this message translates to:
  /// **'Write items in any script'**
  String get procWriteItemsAnyScript;

  /// No description provided for @procDrawsLabel.
  ///
  /// In en, this message translates to:
  /// **'draws'**
  String get procDrawsLabel;

  /// No description provided for @procUndoLastStroke.
  ///
  /// In en, this message translates to:
  /// **'Undo last stroke'**
  String get procUndoLastStroke;

  /// No description provided for @procClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get procClear;

  /// No description provided for @procHandwriteOrderProFeature.
  ///
  /// In en, this message translates to:
  /// **'Handwrite Order is a Pro feature.'**
  String get procHandwriteOrderProFeature;

  /// No description provided for @procAutoDetectAfter5s.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect after 5s'**
  String get procAutoDetectAfter5s;

  /// No description provided for @procWriteItemsHere.
  ///
  /// In en, this message translates to:
  /// **'Write items here'**
  String get procWriteItemsHere;

  /// No description provided for @procUpgradeOrTopUpToWrite.
  ///
  /// In en, this message translates to:
  /// **'Upgrade or top up to write'**
  String get procUpgradeOrTopUpToWrite;

  /// No description provided for @procHandwriteExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rice 5kg, Sugar 2kg'**
  String get procHandwriteExample;

  /// No description provided for @procDetecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting…'**
  String get procDetecting;

  /// No description provided for @procDetectItems.
  ///
  /// In en, this message translates to:
  /// **'Detect Items'**
  String get procDetectItems;

  /// No description provided for @procRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get procRead;

  /// No description provided for @procNoItemsDetectedWriteClearly.
  ///
  /// In en, this message translates to:
  /// **'No items detected. Try writing more clearly.'**
  String get procNoItemsDetectedWriteClearly;

  /// No description provided for @procWriteAgain.
  ///
  /// In en, this message translates to:
  /// **'Write Again'**
  String get procWriteAgain;

  /// No description provided for @procAnyScriptLanguages.
  ///
  /// In en, this message translates to:
  /// **'Any script: English · తెలుగు · हिंदी · Tamil · ಕನ್ನಡ · മലയാളം'**
  String get procAnyScriptLanguages;

  /// No description provided for @procProductNumber.
  ///
  /// In en, this message translates to:
  /// **'Product #{id}'**
  String procProductNumber(String id);

  /// No description provided for @procReturnExchange.
  ///
  /// In en, this message translates to:
  /// **'Return / Exchange'**
  String get procReturnExchange;

  /// No description provided for @procOrderPickItemsToReturn.
  ///
  /// In en, this message translates to:
  /// **'Order #{id} · pick items to return'**
  String procOrderPickItemsToReturn(String id);

  /// No description provided for @procRecordReturn.
  ///
  /// In en, this message translates to:
  /// **'Record return'**
  String get procRecordReturn;

  /// No description provided for @rackTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock Racks'**
  String get rackTitle;

  /// No description provided for @rackPlaceStock.
  ///
  /// In en, this message translates to:
  /// **'Place stock'**
  String get rackPlaceStock;

  /// No description provided for @rackSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search product or rack (e.g. A1)'**
  String get rackSearchHint;

  /// No description provided for @rackSaved.
  ///
  /// In en, this message translates to:
  /// **'Stock placed in rack'**
  String get rackSaved;

  /// No description provided for @rackChangeQty.
  ///
  /// In en, this message translates to:
  /// **'Change quantity'**
  String get rackChangeQty;

  /// No description provided for @rackMove.
  ///
  /// In en, this message translates to:
  /// **'Move to another rack'**
  String get rackMove;

  /// No description provided for @rackRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from rack'**
  String get rackRemove;

  /// No description provided for @rackRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from rack'**
  String get rackRemoved;

  /// No description provided for @rackMoved.
  ///
  /// In en, this message translates to:
  /// **'Moved to new rack'**
  String get rackMoved;

  /// No description provided for @rackEmpty.
  ///
  /// In en, this message translates to:
  /// **'No racks set up yet. Tap Place stock to put a product in a rack — then you can find it fast.'**
  String get rackEmpty;

  /// No description provided for @rackNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No products or racks match your search.'**
  String get rackNoMatch;

  /// No description provided for @rackItems.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get rackItems;

  /// No description provided for @rackProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get rackProduct;

  /// No description provided for @rackSelectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select a product'**
  String get rackSelectProduct;

  /// No description provided for @rackPickProductFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick a product first'**
  String get rackPickProductFirst;

  /// No description provided for @rackNeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter a rack / bin label'**
  String get rackNeedLabel;

  /// No description provided for @rackSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get rackSaveFailed;

  /// No description provided for @rackLabel.
  ///
  /// In en, this message translates to:
  /// **'Rack / bin'**
  String get rackLabel;

  /// No description provided for @rackLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. A1, top shelf, cold storage'**
  String get rackLabelHint;

  /// No description provided for @rackQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity in this rack'**
  String get rackQuantity;

  /// No description provided for @rackSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get rackSave;

  /// No description provided for @rackLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load racks. Check your connection.'**
  String get rackLoadFailed;

  /// No description provided for @rackRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get rackRetry;

  /// No description provided for @rackLocation.
  ///
  /// In en, this message translates to:
  /// **'Rack location'**
  String get rackLocation;

  /// No description provided for @rackSetLocation.
  ///
  /// In en, this message translates to:
  /// **'Set rack location'**
  String get rackSetLocation;

  /// No description provided for @rackNoneForProduct.
  ///
  /// In en, this message translates to:
  /// **'Not placed in any rack yet.'**
  String get rackNoneForProduct;

  /// No description provided for @tutNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutNext;

  /// No description provided for @tutDone.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get tutDone;

  /// No description provided for @tutSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tutSkip;

  /// No description provided for @tutTapHere.
  ///
  /// In en, this message translates to:
  /// **'Tap the highlighted button to continue'**
  String get tutTapHere;

  /// No description provided for @tutDismiss.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get tutDismiss;

  /// No description provided for @tutChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get tutChecklistTitle;

  /// No description provided for @tutChecklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done — tap a step to do it'**
  String tutChecklistSubtitle(int done, int total);

  /// No description provided for @tutStepAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add your first product'**
  String get tutStepAddProduct;

  /// No description provided for @tutStepFirstSale.
  ///
  /// In en, this message translates to:
  /// **'Make your first bill'**
  String get tutStepFirstSale;

  /// No description provided for @tutStepUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Record an udhaar (pay later)'**
  String get tutStepUdhaar;

  /// No description provided for @tutStepReport.
  ///
  /// In en, this message translates to:
  /// **'See today\'s business'**
  String get tutStepReport;

  /// No description provided for @tutStepLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get tutStepLanguage;

  /// No description provided for @tutWelcomeHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tutWelcomeHomeTitle;

  /// No description provided for @tutWelcomeHomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your day at a glance — sales, profit and alerts live here.'**
  String get tutWelcomeHomeBody;

  /// No description provided for @tutWelcomeKhataTitle.
  ///
  /// In en, this message translates to:
  /// **'Khata'**
  String get tutWelcomeKhataTitle;

  /// No description provided for @tutWelcomeKhataBody.
  ///
  /// In en, this message translates to:
  /// **'Your udhaar book. Every credit and collection in one place.'**
  String get tutWelcomeKhataBody;

  /// No description provided for @tutWelcomeBillingTitle.
  ///
  /// In en, this message translates to:
  /// **'Billing & Stock'**
  String get tutWelcomeBillingTitle;

  /// No description provided for @tutWelcomeBillingBody.
  ///
  /// In en, this message translates to:
  /// **'Make bills and manage your products here.'**
  String get tutWelcomeBillingBody;

  /// No description provided for @tutWelcomeVisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Vision AI'**
  String get tutWelcomeVisionTitle;

  /// No description provided for @tutWelcomeVisionBody.
  ///
  /// In en, this message translates to:
  /// **'Count stock with your camera — scan shelves, count items.'**
  String get tutWelcomeVisionBody;

  /// No description provided for @tutWelcomeChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Start here'**
  String get tutWelcomeChecklistTitle;

  /// No description provided for @tutWelcomeChecklistBody.
  ///
  /// In en, this message translates to:
  /// **'Five small steps to set up your shop. Tap any step and we\'ll do it together.'**
  String get tutWelcomeChecklistBody;

  /// No description provided for @tutReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s business'**
  String get tutReportTitle;

  /// No description provided for @tutReportBody.
  ///
  /// In en, this message translates to:
  /// **'This card shows what you sold today and what you earned. Check it every evening.'**
  String get tutReportBody;

  /// No description provided for @tutFsSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the product'**
  String get tutFsSearchTitle;

  /// No description provided for @tutFsSearchBody.
  ///
  /// In en, this message translates to:
  /// **'Type the product\'s name here, then tap it to add it to the bill.'**
  String get tutFsSearchBody;

  /// No description provided for @tutFsCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add the customer'**
  String get tutFsCustomerTitle;

  /// No description provided for @tutFsCustomerBody.
  ///
  /// In en, this message translates to:
  /// **'Tap here to pick the customer who is buying — or add a new one with just a name and phone.'**
  String get tutFsCustomerBody;

  /// No description provided for @tutFsChargeTitle.
  ///
  /// In en, this message translates to:
  /// **'Take payment'**
  String get tutFsChargeTitle;

  /// No description provided for @tutFsChargeBody.
  ///
  /// In en, this message translates to:
  /// **'The bill is ready. Tap here to choose how they pay and finish it.'**
  String get tutFsChargeBody;

  /// No description provided for @tutFsPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'How are they paying?'**
  String get tutFsPaymentTitle;

  /// No description provided for @tutFsPaymentBody.
  ///
  /// In en, this message translates to:
  /// **'Cash now — or Udhaar to collect later. Udhaar goes straight into your Khata book.'**
  String get tutFsPaymentBody;

  /// No description provided for @tutFsConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish the bill'**
  String get tutFsConfirmTitle;

  /// No description provided for @tutFsConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Tap this button to complete your sale.'**
  String get tutFsConfirmBody;

  /// No description provided for @tutApFabTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a product'**
  String get tutApFabTitle;

  /// No description provided for @tutApFabBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to put your first product in the shop.'**
  String get tutApFabBody;

  /// No description provided for @tutApSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search the catalog'**
  String get tutApSearchTitle;

  /// No description provided for @tutApSearchBody.
  ///
  /// In en, this message translates to:
  /// **'Type the product\'s name and pick it from the list — name, photo and details fill in by themselves.'**
  String get tutApSearchBody;

  /// No description provided for @tutApPriceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your selling price'**
  String get tutApPriceTitle;

  /// No description provided for @tutApPriceBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the price you sell this at in your shop.'**
  String get tutApPriceBody;

  /// No description provided for @tutApStockTitle.
  ///
  /// In en, this message translates to:
  /// **'How many do you have?'**
  String get tutApStockTitle;

  /// No description provided for @tutApStockBody.
  ///
  /// In en, this message translates to:
  /// **'Enter how many are on your shelf right now.'**
  String get tutApStockBody;

  /// No description provided for @tutApSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save it'**
  String get tutApSaveTitle;

  /// No description provided for @tutApSaveBody.
  ///
  /// In en, this message translates to:
  /// **'Tap Save — the product is ready to sell.'**
  String get tutApSaveBody;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTitle;

  /// No description provided for @learnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short guides that show you around the app. Replay any of them, any time.'**
  String get learnSubtitle;

  /// No description provided for @learnReplayWelcome.
  ///
  /// In en, this message translates to:
  /// **'App tour'**
  String get learnReplayWelcome;

  /// No description provided for @learnFlowAddProduct.
  ///
  /// In en, this message translates to:
  /// **'How to add a product'**
  String get learnFlowAddProduct;

  /// No description provided for @learnFlowFirstSale.
  ///
  /// In en, this message translates to:
  /// **'How to make a bill'**
  String get learnFlowFirstSale;

  /// No description provided for @learnReplay.
  ///
  /// In en, this message translates to:
  /// **'Show me'**
  String get learnReplay;

  /// No description provided for @learnShowTips.
  ///
  /// In en, this message translates to:
  /// **'Show tips'**
  String get learnShowTips;

  /// No description provided for @learnShowTipsDesc.
  ///
  /// In en, this message translates to:
  /// **'Guided tips on screens you open for the first time'**
  String get learnShowTipsDesc;

  /// No description provided for @procExchangeInstead.
  ///
  /// In en, this message translates to:
  /// **'Exchange (customer takes another item)'**
  String get procExchangeInstead;

  /// No description provided for @procRefundAmount.
  ///
  /// In en, this message translates to:
  /// **'Refund amount'**
  String get procRefundAmount;

  /// No description provided for @fulTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimates & Returns'**
  String get fulTitle;

  /// No description provided for @fulTabEstimates.
  ///
  /// In en, this message translates to:
  /// **'Estimates'**
  String get fulTabEstimates;

  /// No description provided for @fulTabReturns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get fulTabReturns;

  /// No description provided for @fulNoReturns.
  ///
  /// In en, this message translates to:
  /// **'No returns yet. When a customer brings something back, tap Log return and pick their order.'**
  String get fulNoReturns;

  /// No description provided for @fulLogReturn.
  ///
  /// In en, this message translates to:
  /// **'Log return'**
  String get fulLogReturn;

  /// No description provided for @fulPickOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Which order is being returned?'**
  String get fulPickOrderTitle;

  /// No description provided for @fulSearchOrders.
  ///
  /// In en, this message translates to:
  /// **'Search by order # or customer'**
  String get fulSearchOrders;

  /// No description provided for @fulNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No recent orders found.'**
  String get fulNoOrders;

  /// No description provided for @fulExchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get fulExchange;

  /// No description provided for @fulRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get fulRefund;

  /// No description provided for @fulBackToShelf.
  ///
  /// In en, this message translates to:
  /// **'back to shelf'**
  String get fulBackToShelf;

  /// No description provided for @fulToVendor.
  ///
  /// In en, this message translates to:
  /// **'to vendor'**
  String get fulToVendor;

  /// No description provided for @fulItems.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get fulItems;

  /// No description provided for @fulLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load. Please check your connection.'**
  String get fulLoadFailed;

  /// No description provided for @fulRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get fulRetry;

  /// No description provided for @estEmpty.
  ///
  /// In en, this message translates to:
  /// **'No estimates yet. Create a quote for a customer — you can share it and turn it into a sale later.'**
  String get estEmpty;

  /// No description provided for @estNewEstimate.
  ///
  /// In en, this message translates to:
  /// **'New estimate'**
  String get estNewEstimate;

  /// No description provided for @estWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Walk-in customer'**
  String get estWalkIn;

  /// No description provided for @estAddOneItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item'**
  String get estAddOneItem;

  /// No description provided for @estSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get estSaveFailed;

  /// No description provided for @estCustomerOptional.
  ///
  /// In en, this message translates to:
  /// **'Customer (optional)'**
  String get estCustomerOptional;

  /// No description provided for @estSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select customer'**
  String get estSelectCustomer;

  /// No description provided for @estAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get estAddItem;

  /// No description provided for @estValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get estValidUntil;

  /// No description provided for @estNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get estNoExpiry;

  /// No description provided for @estSaveEstimate.
  ///
  /// In en, this message translates to:
  /// **'Save estimate'**
  String get estSaveEstimate;

  /// No description provided for @estItemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get estItemName;

  /// No description provided for @estPickFromCatalog.
  ///
  /// In en, this message translates to:
  /// **'Pick from catalog'**
  String get estPickFromCatalog;

  /// No description provided for @estQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get estQty;

  /// No description provided for @estUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get estUnitPrice;

  /// No description provided for @estAddedToBill.
  ///
  /// In en, this message translates to:
  /// **'added to bill'**
  String get estAddedToBill;

  /// No description provided for @estSkippedNotInCatalog.
  ///
  /// In en, this message translates to:
  /// **'skipped (not in catalog)'**
  String get estSkippedNotInCatalog;

  /// No description provided for @estShareHeading.
  ///
  /// In en, this message translates to:
  /// **'Estimate / Quotation'**
  String get estShareHeading;

  /// No description provided for @estShareTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get estShareTotal;

  /// No description provided for @estTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get estTotal;

  /// No description provided for @estStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get estStatus;

  /// No description provided for @estStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get estStatusDraft;

  /// No description provided for @estStatusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get estStatusSent;

  /// No description provided for @estStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get estStatusAccepted;

  /// No description provided for @estStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get estStatusRejected;

  /// No description provided for @estShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get estShare;

  /// No description provided for @estConvert.
  ///
  /// In en, this message translates to:
  /// **'Convert to sale'**
  String get estConvert;

  /// No description provided for @staffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffTitle;

  /// No description provided for @staffTeamTab.
  ///
  /// In en, this message translates to:
  /// **'Team & attendance'**
  String get staffTeamTab;

  /// No description provided for @staffTasksTab.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get staffTasksTab;

  /// No description provided for @staffNoStaff.
  ///
  /// In en, this message translates to:
  /// **'No staff yet. Add your team.'**
  String get staffNoStaff;

  /// No description provided for @staffAddStaff.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get staffAddStaff;

  /// No description provided for @staffNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet. Add a task or checklist item for your team.'**
  String get staffNoTasks;

  /// No description provided for @staffAddTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get staffAddTask;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Cards'**
  String get jobTitle;

  /// No description provided for @jobNewJob.
  ///
  /// In en, this message translates to:
  /// **'New job'**
  String get jobNewJob;

  /// No description provided for @jobNewJobCard.
  ///
  /// In en, this message translates to:
  /// **'New job card'**
  String get jobNewJobCard;

  /// No description provided for @jobRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get jobRepair;

  /// No description provided for @jobAlteration.
  ///
  /// In en, this message translates to:
  /// **'Alteration'**
  String get jobAlteration;

  /// No description provided for @jobPreorder.
  ///
  /// In en, this message translates to:
  /// **'Pre-order'**
  String get jobPreorder;

  /// No description provided for @wtyIssue.
  ///
  /// In en, this message translates to:
  /// **'Issue / problem'**
  String get wtyIssue;

  /// No description provided for @wtySelectSerial.
  ///
  /// In en, this message translates to:
  /// **'Select a serial'**
  String get wtySelectSerial;

  /// No description provided for @wtyCreateClaim.
  ///
  /// In en, this message translates to:
  /// **'Create claim'**
  String get wtyCreateClaim;

  /// No description provided for @wtyNoClaims.
  ///
  /// In en, this message translates to:
  /// **'No warranty claims logged.'**
  String get wtyNoClaims;

  /// No description provided for @wtyTitle.
  ///
  /// In en, this message translates to:
  /// **'Warranty & Serials'**
  String get wtyTitle;

  /// No description provided for @wtyTabClaims.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get wtyTabClaims;

  /// No description provided for @wtyTabSerials.
  ///
  /// In en, this message translates to:
  /// **'Serials'**
  String get wtyTabSerials;

  /// No description provided for @wtyNewClaim.
  ///
  /// In en, this message translates to:
  /// **'New claim'**
  String get wtyNewClaim;

  /// No description provided for @wtyAddSerial.
  ///
  /// In en, this message translates to:
  /// **'Add serial'**
  String get wtyAddSerial;

  /// No description provided for @wtySearchSerials.
  ///
  /// In en, this message translates to:
  /// **'Search serial / IMEI or product'**
  String get wtySearchSerials;

  /// No description provided for @wtyNoSerials.
  ///
  /// In en, this message translates to:
  /// **'No serials registered yet. Add serials at checkout or with the button below.'**
  String get wtyNoSerials;

  /// No description provided for @wtyAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get wtyAll;

  /// No description provided for @wtyInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get wtyInStock;

  /// No description provided for @wtySold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get wtySold;

  /// No description provided for @wtyProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get wtyProduct;

  /// No description provided for @wtySelectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select a product'**
  String get wtySelectProduct;

  /// No description provided for @wtySerialImei.
  ///
  /// In en, this message translates to:
  /// **'Serial / IMEI number'**
  String get wtySerialImei;

  /// No description provided for @wtySoldOn.
  ///
  /// In en, this message translates to:
  /// **'Sold on'**
  String get wtySoldOn;

  /// No description provided for @wtyExpired.
  ///
  /// In en, this message translates to:
  /// **'Warranty expired'**
  String get wtyExpired;

  /// No description provided for @wtyExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get wtyExpires;

  /// No description provided for @wtyWarrantyTill.
  ///
  /// In en, this message translates to:
  /// **'Under warranty till'**
  String get wtyWarrantyTill;

  /// No description provided for @wtyPickProduct.
  ///
  /// In en, this message translates to:
  /// **'Pick a product first'**
  String get wtyPickProduct;

  /// No description provided for @wtyEnterSerial.
  ///
  /// In en, this message translates to:
  /// **'Enter the serial / IMEI'**
  String get wtyEnterSerial;

  /// No description provided for @wtySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get wtySaveFailed;

  /// No description provided for @wtySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get wtySave;

  /// No description provided for @staffComm.
  ///
  /// In en, this message translates to:
  /// **'comm'**
  String get staffComm;

  /// No description provided for @staffEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get staffEdit;

  /// No description provided for @staffOrders30d.
  ///
  /// In en, this message translates to:
  /// **'orders (30d)'**
  String get staffOrders30d;

  /// No description provided for @staffCommEarned.
  ///
  /// In en, this message translates to:
  /// **'commission'**
  String get staffCommEarned;

  /// No description provided for @staffEditMember.
  ///
  /// In en, this message translates to:
  /// **'Edit staff member'**
  String get staffEditMember;

  /// No description provided for @staffName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get staffName;

  /// No description provided for @staffPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get staffPhoneOptional;

  /// No description provided for @staffRoleOptional.
  ///
  /// In en, this message translates to:
  /// **'Role (optional)'**
  String get staffRoleOptional;

  /// No description provided for @staffCommissionField.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get staffCommissionField;

  /// No description provided for @staffActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get staffActive;

  /// No description provided for @staffActiveHint.
  ///
  /// In en, this message translates to:
  /// **'Inactive staff are hidden from lists and billing.'**
  String get staffActiveHint;

  /// No description provided for @staffSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get staffSaveChanges;

  /// No description provided for @staffAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get staffAssignedTo;

  /// No description provided for @staffBilledBy.
  ///
  /// In en, this message translates to:
  /// **'Billed by (optional)'**
  String get staffBilledBy;

  /// No description provided for @staffNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get staffNotSet;

  /// No description provided for @fulReturnsOnOrder.
  ///
  /// In en, this message translates to:
  /// **'Returns on this bill'**
  String get fulReturnsOnOrder;

  /// No description provided for @procBoughtQty.
  ///
  /// In en, this message translates to:
  /// **'bought {qty} '**
  String procBoughtQty(String qty);

  /// No description provided for @procBackToShelf.
  ///
  /// In en, this message translates to:
  /// **'Back to shelf'**
  String get procBackToShelf;

  /// No description provided for @procResaleable.
  ///
  /// In en, this message translates to:
  /// **'Resaleable'**
  String get procResaleable;

  /// No description provided for @procDamagedToVendor.
  ///
  /// In en, this message translates to:
  /// **'Damaged → vendor'**
  String get procDamagedToVendor;

  /// No description provided for @procReturnRecordedShelf.
  ///
  /// In en, this message translates to:
  /// **'Return recorded — {count} back to shelf'**
  String procReturnRecordedShelf(int count);

  /// No description provided for @procReturnToVendorSuffix.
  ///
  /// In en, this message translates to:
  /// **', {count} to vendor'**
  String procReturnToVendorSuffix(int count);

  /// No description provided for @procCouldNotRecordReturn.
  ///
  /// In en, this message translates to:
  /// **'Could not record return'**
  String get procCouldNotRecordReturn;

  /// No description provided for @subYourInsights.
  ///
  /// In en, this message translates to:
  /// **'Your Insights'**
  String get subYourInsights;

  /// No description provided for @subError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get subError;

  /// No description provided for @subManageKpis.
  ///
  /// In en, this message translates to:
  /// **'Manage KPIs'**
  String get subManageKpis;

  /// No description provided for @subManageSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Manage subscriptions'**
  String get subManageSubscriptions;

  /// No description provided for @subDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get subDone;

  /// No description provided for @subKpisSelected.
  ///
  /// In en, this message translates to:
  /// **'{n} KPIs selected'**
  String subKpisSelected(int n);

  /// No description provided for @subSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get subSelectAll;

  /// No description provided for @subClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get subClear;

  /// No description provided for @subUnselect.
  ///
  /// In en, this message translates to:
  /// **'Unselect'**
  String get subUnselect;

  /// No description provided for @subProKpiName.
  ///
  /// In en, this message translates to:
  /// **'Pro KPI: {name}'**
  String subProKpiName(String name);

  /// No description provided for @subConfirmSelections.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selections'**
  String get subConfirmSelections;

  /// No description provided for @subNoActiveKpis.
  ///
  /// In en, this message translates to:
  /// **'No active KPIs'**
  String get subNoActiveKpis;

  /// No description provided for @subManageToSeeInsights.
  ///
  /// In en, this message translates to:
  /// **'Manage your subscriptions to see insights'**
  String get subManageToSeeInsights;

  /// No description provided for @subFailedLoadInsights.
  ///
  /// In en, this message translates to:
  /// **'Failed to load live insights'**
  String get subFailedLoadInsights;

  /// No description provided for @subManageInventory.
  ///
  /// In en, this message translates to:
  /// **'Manage Inventory'**
  String get subManageInventory;

  /// No description provided for @subSendReminders.
  ///
  /// In en, this message translates to:
  /// **'Send Reminders'**
  String get subSendReminders;

  /// No description provided for @subReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi, this is a reminder regarding your business with us. Please check your latest updates.'**
  String get subReminderMessage;

  /// No description provided for @subNewSale.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get subNewSale;

  /// No description provided for @subAiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get subAiSummary;

  /// No description provided for @subPoweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by {agent}'**
  String subPoweredBy(String agent);

  /// No description provided for @subTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get subTarget;

  /// No description provided for @subBaseline.
  ///
  /// In en, this message translates to:
  /// **'Baseline'**
  String get subBaseline;

  /// No description provided for @subLiveDataBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Live Data Breakdown'**
  String get subLiveDataBreakdown;

  /// No description provided for @subMlInsights.
  ///
  /// In en, this message translates to:
  /// **'MI Insights'**
  String get subMlInsights;

  /// No description provided for @subNoDynamicInsights.
  ///
  /// In en, this message translates to:
  /// **'No dynamic insights available for this KPI.'**
  String get subNoDynamicInsights;

  /// No description provided for @subPctVsLastPeriod.
  ///
  /// In en, this message translates to:
  /// **'{pct}% vs last period'**
  String subPctVsLastPeriod(String pct);

  /// No description provided for @subCurrent.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get subCurrent;

  /// No description provided for @subWhyThisValue.
  ///
  /// In en, this message translates to:
  /// **'Why this value?'**
  String get subWhyThisValue;

  /// No description provided for @subSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get subSomethingWentWrong;

  /// No description provided for @subRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get subRetry;

  /// No description provided for @subSubscriptionAndPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Plans'**
  String get subSubscriptionAndPlans;

  /// No description provided for @subErrorWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Error: {detail}'**
  String subErrorWithDetail(String detail);

  /// No description provided for @subCancelSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription?'**
  String get subCancelSubscriptionTitle;

  /// No description provided for @subCancelSubscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Your subscription will be cancelled immediately. You can re-subscribe at any time.'**
  String get subCancelSubscriptionBody;

  /// No description provided for @subKeepPlan.
  ///
  /// In en, this message translates to:
  /// **'Keep Plan'**
  String get subKeepPlan;

  /// No description provided for @subCancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get subCancelSubscription;

  /// No description provided for @subSubscriptionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled.'**
  String get subSubscriptionCancelled;

  /// No description provided for @subCancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Cancel failed: {detail}'**
  String subCancelFailed(String detail);

  /// No description provided for @subChooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE YOUR PLAN'**
  String get subChooseYourPlan;

  /// No description provided for @subFeaturePosSales.
  ///
  /// In en, this message translates to:
  /// **'POS & Sales Management'**
  String get subFeaturePosSales;

  /// No description provided for @subFeatureInventoryTracking.
  ///
  /// In en, this message translates to:
  /// **'Inventory Tracking'**
  String get subFeatureInventoryTracking;

  /// No description provided for @subFeatureFinanceUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Finance & Udhaar'**
  String get subFeatureFinanceUdhaar;

  /// No description provided for @subFeatureKpiInsights.
  ///
  /// In en, this message translates to:
  /// **'KPI Insights (3 per category)'**
  String get subFeatureKpiInsights;

  /// No description provided for @subFeatureCustomerRelations.
  ///
  /// In en, this message translates to:
  /// **'Customer Relations'**
  String get subFeatureCustomerRelations;

  /// No description provided for @subFeatureAiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendations'**
  String get subFeatureAiRecommendations;

  /// No description provided for @subFeatureAllKpiCategories.
  ///
  /// In en, this message translates to:
  /// **'All KPI Categories (unlimited)'**
  String get subFeatureAllKpiCategories;

  /// No description provided for @subFeatureVendorProcurement.
  ///
  /// In en, this message translates to:
  /// **'Vendor & Procurement Management'**
  String get subFeatureVendorProcurement;

  /// No description provided for @subFeatureCashflowSupport.
  ///
  /// In en, this message translates to:
  /// **'Cashflow Support (up to ₹10L)'**
  String get subFeatureCashflowSupport;

  /// No description provided for @subFeatureCustomerGrowth.
  ///
  /// In en, this message translates to:
  /// **'Customer Growth Engine'**
  String get subFeatureCustomerGrowth;

  /// No description provided for @subPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get subPerMonth;

  /// No description provided for @subRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get subRestorePurchases;

  /// No description provided for @subNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get subNeedHelp;

  /// No description provided for @subReachWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Reach us on WhatsApp for plan queries or billing support.'**
  String get subReachWhatsApp;

  /// No description provided for @subWhatsAppSupport.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Support'**
  String get subWhatsAppSupport;

  /// No description provided for @subWhatsAppHelpMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi! I need help with my Outlet AI subscription.'**
  String get subWhatsAppHelpMessage;

  /// No description provided for @subCurrentPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Current: {plan}'**
  String subCurrentPlanLabel(String plan);

  /// No description provided for @subTimeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining: '**
  String get subTimeRemaining;

  /// No description provided for @subBest.
  ///
  /// In en, this message translates to:
  /// **'BEST'**
  String get subBest;

  /// No description provided for @subJustPerDay.
  ///
  /// In en, this message translates to:
  /// **'just {price}/day'**
  String subJustPerDay(String price);

  /// No description provided for @subTrialPlanNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'re on a free trial of this plan. Upgrade to keep access after trial ends.'**
  String get subTrialPlanNotice;

  /// No description provided for @subCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subCurrentPlan;

  /// No description provided for @subUpgradeToKeepAccess.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Keep {name} Access'**
  String subUpgradeToKeepAccess(String name);

  /// No description provided for @subPayAndActivate.
  ///
  /// In en, this message translates to:
  /// **'Pay & Activate {name}'**
  String subPayAndActivate(String name);

  /// No description provided for @subPaywallFeatureEverythingBasic.
  ///
  /// In en, this message translates to:
  /// **'Everything in Basic'**
  String get subPaywallFeatureEverythingBasic;

  /// No description provided for @subPaywallFeaturePriorityAi.
  ///
  /// In en, this message translates to:
  /// **'Priority AI recommendations'**
  String get subPaywallFeaturePriorityAi;

  /// No description provided for @subProFeature.
  ///
  /// In en, this message translates to:
  /// **'PRO FEATURE'**
  String get subProFeature;

  /// No description provided for @subProPlanIncludes.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan includes:'**
  String get subProPlanIncludes;

  /// No description provided for @subNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get subNotNow;

  /// No description provided for @subUpgradeToProPrice.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro  ₹500/mo · just ₹17/day'**
  String get subUpgradeToProPrice;

  /// No description provided for @subInvoicePack.
  ///
  /// In en, this message translates to:
  /// **'Invoice Pack'**
  String get subInvoicePack;

  /// No description provided for @subVoicePack.
  ///
  /// In en, this message translates to:
  /// **'Voice Pack'**
  String get subVoicePack;

  /// No description provided for @subHandwritingPack.
  ///
  /// In en, this message translates to:
  /// **'Handwriting Pack'**
  String get subHandwritingPack;

  /// No description provided for @subInvoicePackDesc.
  ///
  /// In en, this message translates to:
  /// **'Process 10 more supplier bills'**
  String get subInvoicePackDesc;

  /// No description provided for @subVoicePackDesc.
  ///
  /// In en, this message translates to:
  /// **'Add 10 more audio/voice orders'**
  String get subVoicePackDesc;

  /// No description provided for @subHandwritingPackDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan 10 more handwritten notes'**
  String get subHandwritingPackDesc;

  /// No description provided for @subPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get subPrice;

  /// No description provided for @subCreditsRollOverDaily.
  ///
  /// In en, this message translates to:
  /// **'Credits do not expire — they roll over each day.'**
  String get subCreditsRollOverDaily;

  /// No description provided for @subCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get subCancel;

  /// No description provided for @subPayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay ₹{amount}'**
  String subPayAmount(int amount);

  /// No description provided for @subCreditsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} {name} credits added!'**
  String subCreditsAdded(int count, String name);

  /// No description provided for @subTopUpCredits.
  ///
  /// In en, this message translates to:
  /// **'Top Up Your Credits'**
  String get subTopUpCredits;

  /// No description provided for @subCreditsNeverExpire.
  ///
  /// In en, this message translates to:
  /// **'Credits never expire — they roll over to tomorrow!'**
  String get subCreditsNeverExpire;

  /// No description provided for @subCreditsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} credits'**
  String subCreditsCount(int count);

  /// No description provided for @subBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get subBuy;

  /// No description provided for @subTrialExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your free trial has expired. Upgrade to continue.'**
  String get subTrialExpiredMessage;

  /// No description provided for @subTrialLastDayMessage.
  ///
  /// In en, this message translates to:
  /// **'Last day of your free trial! Upgrade now.'**
  String get subTrialLastDayMessage;

  /// No description provided for @subTrialDaysLeftMessage.
  ///
  /// In en, this message translates to:
  /// **'{n} days left in your trial. Upgrade to Basic or Pro.'**
  String subTrialDaysLeftMessage(int n);

  /// No description provided for @subTrialExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Trial Expiring Soon'**
  String get subTrialExpiringSoon;

  /// No description provided for @subTrialExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Trial Expired'**
  String get subTrialExpiredTitle;

  /// No description provided for @mktMyBaskets.
  ///
  /// In en, this message translates to:
  /// **'My Baskets'**
  String get mktMyBaskets;

  /// No description provided for @mktCouldNotLoadBaskets.
  ///
  /// In en, this message translates to:
  /// **'Could not load baskets'**
  String get mktCouldNotLoadBaskets;

  /// No description provided for @mktPullDownToRetry.
  ///
  /// In en, this message translates to:
  /// **'Pull down to retry'**
  String get mktPullDownToRetry;

  /// No description provided for @mktRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get mktRetry;

  /// No description provided for @mktNewBasket.
  ///
  /// In en, this message translates to:
  /// **'New Basket'**
  String get mktNewBasket;

  /// No description provided for @mktNoBasketsYet.
  ///
  /// In en, this message translates to:
  /// **'No baskets yet'**
  String get mktNoBasketsYet;

  /// No description provided for @mktBasketsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create combo deals and bundle offers.\nAlert all your customers via WhatsApp.'**
  String get mktBasketsEmptySubtitle;

  /// No description provided for @mktCreateFirstBasket.
  ///
  /// In en, this message translates to:
  /// **'Create First Basket'**
  String get mktCreateFirstBasket;

  /// No description provided for @mktDeleteBasketTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Basket?'**
  String get mktDeleteBasketTitle;

  /// No description provided for @mktDeleteBasketConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String mktDeleteBasketConfirm(String name);

  /// No description provided for @mktCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get mktCancel;

  /// No description provided for @mktBasketDeleted.
  ///
  /// In en, this message translates to:
  /// **'Basket deleted'**
  String get mktBasketDeleted;

  /// No description provided for @mktCouldNotDeleteBasket.
  ///
  /// In en, this message translates to:
  /// **'Could not delete basket. Please try again.'**
  String get mktCouldNotDeleteBasket;

  /// No description provided for @mktDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get mktDelete;

  /// No description provided for @mktSendWhatsAppAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Send WhatsApp Alert?'**
  String get mktSendWhatsAppAlertTitle;

  /// No description provided for @mktSendWhatsAppAlertConfirm.
  ///
  /// In en, this message translates to:
  /// **'Send basket deal for \"{name}\" to all your customers via WhatsApp?'**
  String mktSendWhatsAppAlertConfirm(String name);

  /// No description provided for @mktSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get mktSend;

  /// No description provided for @mktWhatsAppAlertSent.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp alert sent to {sent} of {total} customers!'**
  String mktWhatsAppAlertSent(int sent, int total);

  /// No description provided for @mktNoCustomersWithPhone.
  ///
  /// In en, this message translates to:
  /// **'No customers with phone numbers found.'**
  String get mktNoCustomersWithPhone;

  /// No description provided for @mktWhatsAppNotActiveYet.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp not active yet. Alert will auto-send to {total} customers once enabled.'**
  String mktWhatsAppNotActiveYet(int total);

  /// No description provided for @mktAlertFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String mktAlertFailed(String error);

  /// No description provided for @mktExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get mktExpired;

  /// No description provided for @mktItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get mktItem;

  /// No description provided for @mktFromDate.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String mktFromDate(String date);

  /// No description provided for @mktToDate.
  ///
  /// In en, this message translates to:
  /// **'To {date}'**
  String mktToDate(String date);

  /// No description provided for @mktAlertCustomers.
  ///
  /// In en, this message translates to:
  /// **'Alert Customers'**
  String get mktAlertCustomers;

  /// No description provided for @mktNoProductsInInventory.
  ///
  /// In en, this message translates to:
  /// **'No products in inventory. Please sync POS first.'**
  String get mktNoProductsInInventory;

  /// No description provided for @mktAllProductsAdded.
  ///
  /// In en, this message translates to:
  /// **'All products already added to this basket'**
  String get mktAllProductsAdded;

  /// No description provided for @mktBasketNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Basket name is required'**
  String get mktBasketNameRequired;

  /// No description provided for @mktAddAtLeastOneProduct.
  ///
  /// In en, this message translates to:
  /// **'Add at least one product from inventory'**
  String get mktAddAtLeastOneProduct;

  /// No description provided for @mktSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get mktSave;

  /// No description provided for @mktBasketNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Basket Name *'**
  String get mktBasketNameLabel;

  /// No description provided for @mktBasketNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Breakfast Bundle'**
  String get mktBasketNameHint;

  /// No description provided for @mktDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get mktDescriptionOptional;

  /// No description provided for @mktDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Milk + Bread + Eggs'**
  String get mktDescriptionHint;

  /// No description provided for @mktBundlePriceOptional.
  ///
  /// In en, this message translates to:
  /// **'Bundle Price (optional)'**
  String get mktBundlePriceOptional;

  /// No description provided for @mktValidity.
  ///
  /// In en, this message translates to:
  /// **'VALIDITY'**
  String get mktValidity;

  /// No description provided for @mktFromDateLabel.
  ///
  /// In en, this message translates to:
  /// **'From date'**
  String get mktFromDateLabel;

  /// No description provided for @mktToDateLabel.
  ///
  /// In en, this message translates to:
  /// **'To date'**
  String get mktToDateLabel;

  /// No description provided for @mktProducts.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTS'**
  String get mktProducts;

  /// No description provided for @mktAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get mktAddProduct;

  /// No description provided for @mktTapToPickProducts.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick products from your inventory'**
  String get mktTapToPickProducts;

  /// No description provided for @mktPricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'₹{price} / unit'**
  String mktPricePerUnit(String price);

  /// No description provided for @mktQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get mktQty;

  /// No description provided for @mktCreateBasket.
  ///
  /// In en, this message translates to:
  /// **'Create Basket'**
  String get mktCreateBasket;

  /// No description provided for @mktSelectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select Product'**
  String get mktSelectProduct;

  /// No description provided for @mktSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get mktSearchProducts;

  /// No description provided for @mktNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get mktNoProductsFound;

  /// No description provided for @mktAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get mktAdd;

  /// No description provided for @mktEstTotal.
  ///
  /// In en, this message translates to:
  /// **'est. total'**
  String get mktEstTotal;

  /// No description provided for @mktAddAll.
  ///
  /// In en, this message translates to:
  /// **'Add All'**
  String get mktAddAll;

  /// No description provided for @mktNotInStock.
  ///
  /// In en, this message translates to:
  /// **'Not in stock'**
  String get mktNotInStock;

  /// No description provided for @mktCampaignItemStock.
  ///
  /// In en, this message translates to:
  /// **'Stock: {qty} {unit}  ·  ₹{price}'**
  String mktCampaignItemStock(String qty, String unit, String price);

  /// No description provided for @mktEstimatedTotal.
  ///
  /// In en, this message translates to:
  /// **'Estimated Total'**
  String get mktEstimatedTotal;

  /// No description provided for @mktNoItemsInStock.
  ///
  /// In en, this message translates to:
  /// **'No items in stock'**
  String get mktNoItemsInStock;

  /// No description provided for @mktAddAvailableItemsToCart.
  ///
  /// In en, this message translates to:
  /// **'Add {count} Available Items to Cart'**
  String mktAddAvailableItemsToCart(int count);

  /// No description provided for @mktAreaAssociations.
  ///
  /// In en, this message translates to:
  /// **'Area Associations'**
  String get mktAreaAssociations;

  /// No description provided for @mktMyAreas.
  ///
  /// In en, this message translates to:
  /// **'My Areas'**
  String get mktMyAreas;

  /// No description provided for @mktCustomerHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Customer Heatmap'**
  String get mktCustomerHeatmap;

  /// No description provided for @mktErrorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String mktErrorWithMessage(String error);

  /// No description provided for @mktNoAreasAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No areas added yet'**
  String get mktNoAreasAddedYet;

  /// No description provided for @mktAreasEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add nearby apartments, hostels, schools or offices to get targeted campaign suggestions.'**
  String get mktAreasEmptySubtitle;

  /// No description provided for @mktAddFirstArea.
  ///
  /// In en, this message translates to:
  /// **'Add First Area'**
  String get mktAddFirstArea;

  /// No description provided for @mktRemoveAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Area?'**
  String get mktRemoveAreaTitle;

  /// No description provided for @mktRemoveAreaConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from your associations?'**
  String mktRemoveAreaConfirm(String name);

  /// No description provided for @mktRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get mktRemove;

  /// No description provided for @mktHouseholdsCount.
  ///
  /// In en, this message translates to:
  /// **'~{count} households'**
  String mktHouseholdsCount(int count);

  /// No description provided for @mktNoHeatmapDataYet.
  ///
  /// In en, this message translates to:
  /// **'No heatmap data yet'**
  String get mktNoHeatmapDataYet;

  /// No description provided for @mktHeatmapEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add areas and tag customers to those areas. Revenue data will appear here over time.'**
  String get mktHeatmapEmptySubtitle;

  /// No description provided for @mktLast90DaysByRevenue.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days · by revenue'**
  String get mktLast90DaysByRevenue;

  /// No description provided for @mktCustomers.
  ///
  /// In en, this message translates to:
  /// **'customers'**
  String get mktCustomers;

  /// No description provided for @mktOrders.
  ///
  /// In en, this message translates to:
  /// **'orders'**
  String get mktOrders;

  /// No description provided for @mktAvgOrder.
  ///
  /// In en, this message translates to:
  /// **'avg order'**
  String get mktAvgOrder;

  /// No description provided for @mktNoOrdersYetTagCustomers.
  ///
  /// In en, this message translates to:
  /// **'No orders yet — tag customers to this area to track'**
  String get mktNoOrdersYetTagCustomers;

  /// No description provided for @mktAddNearbyArea.
  ///
  /// In en, this message translates to:
  /// **'Add Nearby Area'**
  String get mktAddNearbyArea;

  /// No description provided for @mktAreaType.
  ///
  /// In en, this message translates to:
  /// **'Area Type'**
  String get mktAreaType;

  /// No description provided for @mktAreaNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name (e.g. Prestige Apartments)'**
  String get mktAreaNameLabel;

  /// No description provided for @mktEstimatedHouseholdsOptional.
  ///
  /// In en, this message translates to:
  /// **'Estimated households (optional)'**
  String get mktEstimatedHouseholdsOptional;

  /// No description provided for @mktNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get mktNotesOptional;

  /// No description provided for @mktAddArea.
  ///
  /// In en, this message translates to:
  /// **'Add Area'**
  String get mktAddArea;

  /// No description provided for @mktCustomerGrowth.
  ///
  /// In en, this message translates to:
  /// **'Customer Growth'**
  String get mktCustomerGrowth;

  /// No description provided for @mktNewCampaign.
  ///
  /// In en, this message translates to:
  /// **'New Campaign'**
  String get mktNewCampaign;

  /// No description provided for @mktNoCampaignsYet.
  ///
  /// In en, this message translates to:
  /// **'No Campaigns Yet'**
  String get mktNoCampaignsYet;

  /// No description provided for @mktReferralEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a referral campaign to let your existing customers bring in new ones — and reward them for it.'**
  String get mktReferralEmptySubtitle;

  /// No description provided for @mktCreateFirstCampaign.
  ///
  /// In en, this message translates to:
  /// **'Create First Campaign'**
  String get mktCreateFirstCampaign;

  /// No description provided for @mktReferralHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'Customers share their QR with friends. New visitors scan it in POS to get a discount — and the referrer earns milestone rewards.'**
  String get mktReferralHowItWorks;

  /// No description provided for @mktCampaignSummary.
  ///
  /// In en, this message translates to:
  /// **'{discount}% off for new customers  •  {reward}% reward every {n} refs'**
  String mktCampaignSummary(String discount, String reward, int n);

  /// No description provided for @mktQrCodes.
  ///
  /// In en, this message translates to:
  /// **'QR Codes'**
  String get mktQrCodes;

  /// No description provided for @mktReferrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get mktReferrals;

  /// No description provided for @mktMaxPerPerson.
  ///
  /// In en, this message translates to:
  /// **'Max/person'**
  String get mktMaxPerPerson;

  /// No description provided for @mktGenerateQr.
  ///
  /// In en, this message translates to:
  /// **'Generate QR'**
  String get mktGenerateQr;

  /// No description provided for @mktGenerateQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate QR · {name}'**
  String mktGenerateQrTitle(String name);

  /// No description provided for @mktSearchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search customer…'**
  String get mktSearchCustomer;

  /// No description provided for @mktNoCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get mktNoCustomersFound;

  /// No description provided for @mktNoPhoneForCustomer.
  ///
  /// In en, this message translates to:
  /// **'No phone number for this customer'**
  String get mktNoPhoneForCustomer;

  /// No description provided for @mktReferralWhatsAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}! 🎁\n\nYou\'re invited to share our store with your friends!\n\nYour referral code: {code}\n\nWhen your friend visits our store and shows this code, they get {discount}% off — and you earn rewards for every {n} friends you bring! 🙌\n\n— via LohiyaAI Kirana'**
  String mktReferralWhatsAppMessage(
    String name,
    String code,
    String discount,
    int n,
  );

  /// No description provided for @mktWhatsAppNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp not installed on this device'**
  String get mktWhatsAppNotInstalled;

  /// No description provided for @mktReferralQrCode.
  ///
  /// In en, this message translates to:
  /// **'Referral QR Code'**
  String get mktReferralQrCode;

  /// No description provided for @mktPercentOffForNewCustomers.
  ///
  /// In en, this message translates to:
  /// **'{discount}% off for new customers'**
  String mktPercentOffForNewCustomers(String discount);

  /// No description provided for @mktMilestoneRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Milestone reward: {reward}% every {n} referrals'**
  String mktMilestoneRewardLabel(String reward, int n);

  /// No description provided for @mktReferralCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied'**
  String get mktReferralCodeCopied;

  /// No description provided for @mktSendViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Send via WhatsApp'**
  String get mktSendViaWhatsApp;

  /// No description provided for @mktQrScreenshotHint.
  ///
  /// In en, this message translates to:
  /// **'Or show this QR screen directly to the customer for them to screenshot.'**
  String get mktQrScreenshotHint;

  /// No description provided for @mktInvalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code'**
  String get mktInvalidQrCode;

  /// No description provided for @mktCampaignNoLongerActive.
  ///
  /// In en, this message translates to:
  /// **'This referral campaign is no longer active'**
  String get mktCampaignNoLongerActive;

  /// No description provided for @mktCouldNotLoadReferralInfo.
  ///
  /// In en, this message translates to:
  /// **'Could not load referral info'**
  String get mktCouldNotLoadReferralInfo;

  /// No description provided for @mktEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number'**
  String get mktEnterValidPhone;

  /// No description provided for @mktClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mktClose;

  /// No description provided for @mktReferralFrom.
  ///
  /// In en, this message translates to:
  /// **'Referral from {name}'**
  String mktReferralFrom(String name);

  /// No description provided for @mktCampaignDiscountForNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'{campaign}  •  {discount}% discount for new customer'**
  String mktCampaignDiscountForNewCustomer(String campaign, String discount);

  /// No description provided for @mktNewCustomerDetails.
  ///
  /// In en, this message translates to:
  /// **'New Customer Details'**
  String get mktNewCustomerDetails;

  /// No description provided for @mktNewCustomerPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter the new customer\'s phone. The discount will be applied when you place the order.'**
  String get mktNewCustomerPhoneHelper;

  /// No description provided for @mktPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get mktPhoneNumber;

  /// No description provided for @mktCustomerNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Customer Name (optional)'**
  String get mktCustomerNameOptional;

  /// No description provided for @mktCustomerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Gnyan Kumar'**
  String get mktCustomerNameHint;

  /// No description provided for @mktApplyReferralDiscount.
  ///
  /// In en, this message translates to:
  /// **'Apply {discount}% Referral Discount'**
  String mktApplyReferralDiscount(String discount);

  /// No description provided for @mktCampaignNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Campaign name is required'**
  String get mktCampaignNameRequired;

  /// No description provided for @mktEnterValidDiscount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid discount % (1–100)'**
  String get mktEnterValidDiscount;

  /// No description provided for @mktMilestoneCountMin.
  ///
  /// In en, this message translates to:
  /// **'Milestone count must be at least 1'**
  String get mktMilestoneCountMin;

  /// No description provided for @mktEnterValidReward.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid reward % (1–100)'**
  String get mktEnterValidReward;

  /// No description provided for @mktMaxReferralsMin.
  ///
  /// In en, this message translates to:
  /// **'Max referrals must be at least 1'**
  String get mktMaxReferralsMin;

  /// No description provided for @mktFailedToCreateCampaign.
  ///
  /// In en, this message translates to:
  /// **'Failed to create campaign. Please try again.'**
  String get mktFailedToCreateCampaign;

  /// No description provided for @mktNewReferralCampaign.
  ///
  /// In en, this message translates to:
  /// **'New Referral Campaign'**
  String get mktNewReferralCampaign;

  /// No description provided for @mktCampaignName.
  ///
  /// In en, this message translates to:
  /// **'Campaign Name'**
  String get mktCampaignName;

  /// No description provided for @mktCampaignNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Summer Referral Drive'**
  String get mktCampaignNameHint;

  /// No description provided for @mktNewCustomerDiscountPct.
  ///
  /// In en, this message translates to:
  /// **'New Customer Discount %'**
  String get mktNewCustomerDiscountPct;

  /// No description provided for @mktMilestoneRewardPct.
  ///
  /// In en, this message translates to:
  /// **'Milestone Reward %'**
  String get mktMilestoneRewardPct;

  /// No description provided for @mktRewardEveryNReferrals.
  ///
  /// In en, this message translates to:
  /// **'Reward Every N Referrals'**
  String get mktRewardEveryNReferrals;

  /// No description provided for @mktRewardEveryNHelper.
  ///
  /// In en, this message translates to:
  /// **'Referrer earns a milestone reward every N new customers they bring'**
  String get mktRewardEveryNHelper;

  /// No description provided for @mktMaxReferralsPerCustomer.
  ///
  /// In en, this message translates to:
  /// **'Max Referrals per Customer'**
  String get mktMaxReferralsPerCustomer;

  /// No description provided for @mktMaxReferralsHelper.
  ///
  /// In en, this message translates to:
  /// **'Stop rewarding a customer after this many successful referrals'**
  String get mktMaxReferralsHelper;

  /// No description provided for @mktCreateCampaign.
  ///
  /// In en, this message translates to:
  /// **'Create Campaign'**
  String get mktCreateCampaign;

  /// No description provided for @profProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profProfile;

  /// No description provided for @profErrorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String profErrorLoadingProfile(String error);

  /// No description provided for @profNoUserData.
  ///
  /// In en, this message translates to:
  /// **'No user data found.'**
  String get profNoUserData;

  /// No description provided for @profCashflowSupport.
  ///
  /// In en, this message translates to:
  /// **'Cashflow Support'**
  String get profCashflowSupport;

  /// No description provided for @profCashflowSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Apply for ₹50K – ₹10L business finance with tailored repayment plans.'**
  String get profCashflowSupportDesc;

  /// No description provided for @profCashflowBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Apply for ₹50K – ₹10L business finance'**
  String get profCashflowBannerSubtitle;

  /// No description provided for @profSectionCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get profSectionCustomers;

  /// No description provided for @profSectionAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get profSectionAnalytics;

  /// No description provided for @profSectionOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get profSectionOperations;

  /// No description provided for @profSectionSalesMarketing.
  ///
  /// In en, this message translates to:
  /// **'Sales & marketing'**
  String get profSectionSalesMarketing;

  /// No description provided for @profSectionStoreAccount.
  ///
  /// In en, this message translates to:
  /// **'Store & Account'**
  String get profSectionStoreAccount;

  /// No description provided for @profSectionPlanSupport.
  ///
  /// In en, this message translates to:
  /// **'Plan & Support'**
  String get profSectionPlanSupport;

  /// No description provided for @profSectionAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get profSectionAdmin;

  /// No description provided for @profCustomerGrowth.
  ///
  /// In en, this message translates to:
  /// **'Customer Growth'**
  String get profCustomerGrowth;

  /// No description provided for @profCustomerGrowthDesc.
  ///
  /// In en, this message translates to:
  /// **'Build a referral engine — let your happy customers bring in new ones automatically.'**
  String get profCustomerGrowthDesc;

  /// No description provided for @profCustomerRelations.
  ///
  /// In en, this message translates to:
  /// **'Customer Relations'**
  String get profCustomerRelations;

  /// No description provided for @profAreaAssociations.
  ///
  /// In en, this message translates to:
  /// **'Area Associations'**
  String get profAreaAssociations;

  /// No description provided for @profKpiSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'KPI Subscriptions'**
  String get profKpiSubscriptions;

  /// No description provided for @profTransactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get profTransactionHistory;

  /// No description provided for @profMyBaskets.
  ///
  /// In en, this message translates to:
  /// **'My Baskets'**
  String get profMyBaskets;

  /// No description provided for @profLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Loyalty & Offers'**
  String get profLoyalty;

  /// No description provided for @profServices.
  ///
  /// In en, this message translates to:
  /// **'Services & Appointments'**
  String get profServices;

  /// No description provided for @profStoreComparison.
  ///
  /// In en, this message translates to:
  /// **'Store Comparison'**
  String get profStoreComparison;

  /// No description provided for @profStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get profStaff;

  /// No description provided for @profEstimatesReturns.
  ///
  /// In en, this message translates to:
  /// **'Estimates & Returns'**
  String get profEstimatesReturns;

  /// No description provided for @profStockRacks.
  ///
  /// In en, this message translates to:
  /// **'Stock Racks'**
  String get profStockRacks;

  /// No description provided for @profJobCards.
  ///
  /// In en, this message translates to:
  /// **'Job Cards'**
  String get profJobCards;

  /// No description provided for @profWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty & Serials'**
  String get profWarranty;

  /// No description provided for @profGstReport.
  ///
  /// In en, this message translates to:
  /// **'GST Report'**
  String get profGstReport;

  /// No description provided for @profLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profLanguage;

  /// No description provided for @profStoreSettings.
  ///
  /// In en, this message translates to:
  /// **'Store Settings'**
  String get profStoreSettings;

  /// No description provided for @profSwitchStore.
  ///
  /// In en, this message translates to:
  /// **'Switch / add store'**
  String get profSwitchStore;

  /// No description provided for @profConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get profConfiguration;

  /// No description provided for @profPasswordSecurity.
  ///
  /// In en, this message translates to:
  /// **'Password & Security'**
  String get profPasswordSecurity;

  /// No description provided for @profSubscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Plans'**
  String get profSubscriptionPlans;

  /// No description provided for @profHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get profHelpSupport;

  /// No description provided for @profUserActivity.
  ///
  /// In en, this message translates to:
  /// **'User Activity'**
  String get profUserActivity;

  /// No description provided for @profSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profSignOut;

  /// No description provided for @profTrialExpired.
  ///
  /// In en, this message translates to:
  /// **'Trial Expired'**
  String get profTrialExpired;

  /// No description provided for @profAwaitingActivation.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Activation'**
  String get profAwaitingActivation;

  /// No description provided for @profProTrial.
  ///
  /// In en, this message translates to:
  /// **'Pro Trial'**
  String get profProTrial;

  /// No description provided for @profBasicTrial.
  ///
  /// In en, this message translates to:
  /// **'Basic Trial'**
  String get profBasicTrial;

  /// No description provided for @profTrialDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{tier} · {days}d left'**
  String profTrialDaysLeft(String tier, int days);

  /// No description provided for @profTrialActive.
  ///
  /// In en, this message translates to:
  /// **'{tier} Active'**
  String profTrialActive(String tier);

  /// No description provided for @profBasicPlan.
  ///
  /// In en, this message translates to:
  /// **'Basic Plan'**
  String get profBasicPlan;

  /// No description provided for @profProPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get profProPlan;

  /// No description provided for @profSyncContacts.
  ///
  /// In en, this message translates to:
  /// **'Sync Contacts'**
  String get profSyncContacts;

  /// No description provided for @profRefreshList.
  ///
  /// In en, this message translates to:
  /// **'Refresh List'**
  String get profRefreshList;

  /// No description provided for @profAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get profAddCustomer;

  /// No description provided for @profSearchByNameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone...'**
  String get profSearchByNameOrPhone;

  /// No description provided for @profRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profRetry;

  /// No description provided for @profNoSegmentCustomers.
  ///
  /// In en, this message translates to:
  /// **'No {segment} customers'**
  String profNoSegmentCustomers(String segment);

  /// No description provided for @profNoCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found.'**
  String get profNoCustomersFound;

  /// No description provided for @profSegRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get profSegRegular;

  /// No description provided for @profSegOccasional.
  ///
  /// In en, this message translates to:
  /// **'Occasional'**
  String get profSegOccasional;

  /// No description provided for @profSegImpulse.
  ///
  /// In en, this message translates to:
  /// **'Impulse'**
  String get profSegImpulse;

  /// No description provided for @profSegBulk.
  ///
  /// In en, this message translates to:
  /// **'Bulk'**
  String get profSegBulk;

  /// No description provided for @profSegCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get profSegCredit;

  /// No description provided for @profSegInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get profSegInactive;

  /// No description provided for @profSyncContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Contacts?'**
  String get profSyncContactsTitle;

  /// No description provided for @profSyncContactsBody.
  ///
  /// In en, this message translates to:
  /// **'This will import your phone contacts into your customer list. Regular customers will be matched by phone number.'**
  String get profSyncContactsBody;

  /// No description provided for @profCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profCancel;

  /// No description provided for @profSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get profSyncNow;

  /// No description provided for @profSyncedContacts.
  ///
  /// In en, this message translates to:
  /// **'Synced {count} contacts successfully!'**
  String profSyncedContacts(int count);

  /// No description provided for @profSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {error}'**
  String profSyncFailed(String error);

  /// No description provided for @profSendWhatsappReengagement.
  ///
  /// In en, this message translates to:
  /// **'Send WhatsApp Re-engagement'**
  String get profSendWhatsappReengagement;

  /// No description provided for @profWhatsappReengagementMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}! We miss you at our store. It\'s been a while since your last visit, and we have fresh stock and great deals waiting for you. Come visit us soon — your favourite items are ready! See you soon!'**
  String profWhatsappReengagementMessage(String name);

  /// No description provided for @profAddNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get profAddNewCustomer;

  /// No description provided for @profEditCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get profEditCustomer;

  /// No description provided for @profFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profFullName;

  /// No description provided for @profPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profPhoneNumber;

  /// No description provided for @profEmailAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Email Address (Optional)'**
  String get profEmailAddressOptional;

  /// No description provided for @profHouseholdSize.
  ///
  /// In en, this message translates to:
  /// **'Household Size'**
  String get profHouseholdSize;

  /// No description provided for @profBirthdayOptional.
  ///
  /// In en, this message translates to:
  /// **'Birthday (optional)'**
  String get profBirthdayOptional;

  /// No description provided for @profAnniversaryOptional.
  ///
  /// In en, this message translates to:
  /// **'Anniversary (optional)'**
  String get profAnniversaryOptional;

  /// No description provided for @profSaveCustomer.
  ///
  /// In en, this message translates to:
  /// **'Save Customer'**
  String get profSaveCustomer;

  /// No description provided for @profFillNameAndPhone.
  ///
  /// In en, this message translates to:
  /// **'Please fill name and phone'**
  String get profFillNameAndPhone;

  /// No description provided for @profEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number (digits only)'**
  String get profEnterValidPhone;

  /// No description provided for @profCustomerSaved.
  ///
  /// In en, this message translates to:
  /// **'Customer saved successfully'**
  String get profCustomerSaved;

  /// No description provided for @profLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get profLoading;

  /// No description provided for @profCustomerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get profCustomerDetails;

  /// No description provided for @profStatBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get profStatBalance;

  /// No description provided for @profStatSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get profStatSpent;

  /// No description provided for @profStatOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get profStatOrders;

  /// No description provided for @profCustomerInfo.
  ///
  /// In en, this message translates to:
  /// **'Customer Info'**
  String get profCustomerInfo;

  /// No description provided for @profMembersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String profMembersCount(int count);

  /// No description provided for @profJoinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined On'**
  String get profJoinedOn;

  /// No description provided for @profUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get profUnknown;

  /// No description provided for @profPurchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get profPurchaseHistory;

  /// No description provided for @profNoOrdersForCustomer.
  ///
  /// In en, this message translates to:
  /// **'No orders found for this customer.'**
  String get profNoOrdersForCustomer;

  /// No description provided for @profErrorLoadingOrders.
  ///
  /// In en, this message translates to:
  /// **'Error loading orders: {error}'**
  String profErrorLoadingOrders(String error);

  /// No description provided for @profDeleteCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Customer?'**
  String get profDeleteCustomerTitle;

  /// No description provided for @profDeleteCustomerBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This action cannot be undone.'**
  String profDeleteCustomerBody(String name);

  /// No description provided for @profDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profDelete;

  /// No description provided for @profFailedToUpdateArea.
  ///
  /// In en, this message translates to:
  /// **'Failed to update area: {error}'**
  String profFailedToUpdateArea(String error);

  /// No description provided for @profAreaAssociation.
  ///
  /// In en, this message translates to:
  /// **'Area / Association'**
  String get profAreaAssociation;

  /// No description provided for @profAddNewArea.
  ///
  /// In en, this message translates to:
  /// **'Add new area…'**
  String get profAddNewArea;

  /// No description provided for @profUnableToLoadAreas.
  ///
  /// In en, this message translates to:
  /// **'Unable to load areas'**
  String get profUnableToLoadAreas;

  /// No description provided for @profNoAreasTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'No areas — tap to add one'**
  String get profNoAreasTapToAdd;

  /// No description provided for @profNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get profNone;

  /// No description provided for @profOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String profOrderNumber(String id);

  /// No description provided for @profSave.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get profSave;

  /// No description provided for @profError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String profError(String error);

  /// No description provided for @profBasicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get profBasicInformation;

  /// No description provided for @profStoreName.
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get profStoreName;

  /// No description provided for @profStoreType.
  ///
  /// In en, this message translates to:
  /// **'Store Type (e.g. Kirana, Supermarket)'**
  String get profStoreType;

  /// No description provided for @profBusinessIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Business Intelligence'**
  String get profBusinessIntelligence;

  /// No description provided for @profFootfallAutoComputed.
  ///
  /// In en, this message translates to:
  /// **'Average footfall is automatically computed based on your sales.'**
  String get profFootfallAutoComputed;

  /// No description provided for @profProvideInitialValues.
  ///
  /// In en, this message translates to:
  /// **'Provide initial values to help our AI optimize your business.'**
  String get profProvideInitialValues;

  /// No description provided for @profAvgDailyFootfall.
  ///
  /// In en, this message translates to:
  /// **'Avg Daily Footfall'**
  String get profAvgDailyFootfall;

  /// No description provided for @profAiAutoUpdating.
  ///
  /// In en, this message translates to:
  /// **'AI Auto-Updating'**
  String get profAiAutoUpdating;

  /// No description provided for @profMonthlyStockBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Stock Budget'**
  String get profMonthlyStockBudget;

  /// No description provided for @profDailyExpenseBuffer.
  ///
  /// In en, this message translates to:
  /// **'Daily Expense Buffer'**
  String get profDailyExpenseBuffer;

  /// No description provided for @profLocationDetails.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get profLocationDetails;

  /// No description provided for @profCityArea.
  ///
  /// In en, this message translates to:
  /// **'City / Area'**
  String get profCityArea;

  /// No description provided for @profStateRegion.
  ///
  /// In en, this message translates to:
  /// **'State / Region'**
  String get profStateRegion;

  /// No description provided for @profCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profCity;

  /// No description provided for @profBusinessVertical.
  ///
  /// In en, this message translates to:
  /// **'Business vertical'**
  String get profBusinessVertical;

  /// No description provided for @profRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get profRequired;

  /// No description provided for @profSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully!'**
  String get profSettingsSaved;

  /// No description provided for @profFailedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String profFailedToSave(String error);

  /// No description provided for @supSplashTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart business, smarter you'**
  String get supSplashTagline;

  /// No description provided for @supBlockedAppTitle.
  ///
  /// In en, this message translates to:
  /// **'App Temporarily Unavailable'**
  String get supBlockedAppTitle;

  /// No description provided for @supBlockedStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Temporarily Unavailable'**
  String get supBlockedStoreTitle;

  /// No description provided for @supBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'We are working to resolve this as soon as possible. If you need immediate help, tap the button below.'**
  String get supBlockedBody;

  /// No description provided for @supBlockedContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get supBlockedContactUs;

  /// No description provided for @supBlockedEmailSubjectApp.
  ///
  /// In en, this message translates to:
  /// **'App Access Issue — Outlet AI'**
  String get supBlockedEmailSubjectApp;

  /// No description provided for @supBlockedEmailSubjectStore.
  ///
  /// In en, this message translates to:
  /// **'Store Access Issue — Outlet AI'**
  String get supBlockedEmailSubjectStore;

  /// No description provided for @supBlockedEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Hello LohiyaAI Team,\n\nI am unable to access the Outlet AI app.\n\nDisplayed reason: {reason}\n\nPlease help me restore access.\n\n— Kirana Owner'**
  String supBlockedEmailBody(String reason);

  /// No description provided for @supBlockedEmailFallback.
  ///
  /// In en, this message translates to:
  /// **'Please email support@lohiyaai.com directly.'**
  String get supBlockedEmailFallback;

  /// No description provided for @supSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get supSupportTitle;

  /// No description provided for @supSupportHeading.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get supSupportHeading;

  /// No description provided for @supSupportSubheading.
  ///
  /// In en, this message translates to:
  /// **'Get instant answers to your questions'**
  String get supSupportSubheading;

  /// No description provided for @supOptionFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get supOptionFaqTitle;

  /// No description provided for @supOptionFaqSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Common questions and answers'**
  String get supOptionFaqSubtitle;

  /// No description provided for @supOptionReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get supOptionReportTitle;

  /// No description provided for @supOptionReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encountered a bug? let us know'**
  String get supOptionReportSubtitle;

  /// No description provided for @supOptionChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get supOptionChatTitle;

  /// No description provided for @supOptionChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with our support team'**
  String get supOptionChatSubtitle;

  /// No description provided for @supOptionEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get supOptionEmailTitle;

  /// No description provided for @supOptionEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send us an email directly'**
  String get supOptionEmailSubtitle;

  /// No description provided for @supChatComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Chat support coming soon!'**
  String get supChatComingSoon;

  /// No description provided for @supEmailUnableToOpen.
  ///
  /// In en, this message translates to:
  /// **'Unable to open email app.'**
  String get supEmailUnableToOpen;

  /// No description provided for @supEmailError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while opening email app.'**
  String get supEmailError;

  /// No description provided for @supFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get supFaqTitle;

  /// No description provided for @supFaqQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I add a new product?'**
  String get supFaqQ1;

  /// No description provided for @supFaqA1.
  ///
  /// In en, this message translates to:
  /// **'You can add products from the POS tab by clicking the + button, or from the Inventory tab. You can also scan a barcode to automatically fetch details if available.'**
  String get supFaqA1;

  /// No description provided for @supFaqQ2.
  ///
  /// In en, this message translates to:
  /// **'How does the Stockout Risk prediction work?'**
  String get supFaqQ2;

  /// No description provided for @supFaqA2.
  ///
  /// In en, this message translates to:
  /// **'Our AI analyzes your past sales velocity and current stock levels. If it predicts you will run out of an item within the next 3-7 days, it flags it as a Stockout Risk.'**
  String get supFaqA2;

  /// No description provided for @supFaqQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I manage customer credit (Khata)?'**
  String get supFaqQ3;

  /// No description provided for @supFaqA3.
  ///
  /// In en, this message translates to:
  /// **'When placing an order, select a customer and choose \"Credit\" as the payment method. You can view all pending dues in the Finance -> Udhaar tab or Customer Relations section.'**
  String get supFaqA3;

  /// No description provided for @supFaqQ4.
  ///
  /// In en, this message translates to:
  /// **'Can I sync my phone contacts?'**
  String get supFaqQ4;

  /// No description provided for @supFaqA4.
  ///
  /// In en, this message translates to:
  /// **'Yes! Go to Profile -> Customer Relations and click the Sync icon. This will import your regular shoppers into the app for easy credit tracking.'**
  String get supFaqA4;

  /// No description provided for @supFaqQ5.
  ///
  /// In en, this message translates to:
  /// **'What are KPI Subscriptions?'**
  String get supFaqQ5;

  /// No description provided for @supFaqA5.
  ///
  /// In en, this message translates to:
  /// **'KPIs are key business metrics like Revenue, Margin, and Footfall. You can choose which metrics to monitor from the Profile -> Subscription section.'**
  String get supFaqA5;

  /// No description provided for @supFaqQ6.
  ///
  /// In en, this message translates to:
  /// **'How do I generate a daily sales report?'**
  String get supFaqQ6;

  /// No description provided for @supFaqA6.
  ///
  /// In en, this message translates to:
  /// **'You can view today\'s performance on the Dashboard. For detailed past reports, visit the Transaction History section in your Profile.'**
  String get supFaqA6;

  /// No description provided for @supReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get supReportTitle;

  /// No description provided for @supReportHeading.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem'**
  String get supReportHeading;

  /// No description provided for @supReportSubheading.
  ///
  /// In en, this message translates to:
  /// **'Our team will review your report and fix it as soon as possible.'**
  String get supReportSubheading;

  /// No description provided for @supReportCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'ISSUE CATEGORY'**
  String get supReportCategoryLabel;

  /// No description provided for @supReportSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'SHORT SUMMARY'**
  String get supReportSummaryLabel;

  /// No description provided for @supReportSummaryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. App crashes when scanning barcode'**
  String get supReportSummaryHint;

  /// No description provided for @supReportDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'DETAILED DESCRIPTION'**
  String get supReportDescriptionLabel;

  /// No description provided for @supReportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Provide details on how to reproduce the issue...'**
  String get supReportDescriptionHint;

  /// No description provided for @supReportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get supReportSubmit;

  /// No description provided for @supReportFillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get supReportFillFields;

  /// No description provided for @supReportSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Submitted'**
  String get supReportSubmittedTitle;

  /// No description provided for @supReportSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback. Our team will look into it immediately.'**
  String get supReportSubmittedBody;

  /// No description provided for @supOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get supOk;

  /// No description provided for @supReportSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit report: {error}'**
  String supReportSubmitFailed(String error);

  /// No description provided for @supCategoryAppBug.
  ///
  /// In en, this message translates to:
  /// **'App Bug'**
  String get supCategoryAppBug;

  /// No description provided for @supCategoryPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing Issue'**
  String get supCategoryPricing;

  /// No description provided for @supCategoryInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory Mismatch'**
  String get supCategoryInventory;

  /// No description provided for @supCategoryAiFeedback.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendation Feedback'**
  String get supCategoryAiFeedback;

  /// No description provided for @supCategoryPosError.
  ///
  /// In en, this message translates to:
  /// **'POS Error'**
  String get supCategoryPosError;

  /// No description provided for @supCategoryFeatureRequest.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get supCategoryFeatureRequest;

  /// No description provided for @supCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get supCategoryOther;

  /// No description provided for @shrSavingChanges.
  ///
  /// In en, this message translates to:
  /// **'Saving changes...'**
  String get shrSavingChanges;

  /// No description provided for @shrRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get shrRetry;

  /// No description provided for @shrSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully!'**
  String get shrSavedSuccessfully;

  /// No description provided for @shrBusinessAlerts.
  ///
  /// In en, this message translates to:
  /// **'Business Alerts'**
  String get shrBusinessAlerts;

  /// No description provided for @shrAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get shrAllCaughtUp;

  /// No description provided for @shrNoUrgentAlerts.
  ///
  /// In en, this message translates to:
  /// **'No urgent alerts at the moment.'**
  String get shrNoUrgentAlerts;

  /// No description provided for @shrAlertOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get shrAlertOutOfStock;

  /// No description provided for @shrAlertLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get shrAlertLowStock;

  /// No description provided for @shrAlertExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get shrAlertExpiringSoon;

  /// No description provided for @shrAlertOverdueUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Long Overdue Udhaar'**
  String get shrAlertOverdueUdhaar;

  /// No description provided for @shrAlertOverduePayment.
  ///
  /// In en, this message translates to:
  /// **'Overdue Payment'**
  String get shrAlertOverduePayment;

  /// No description provided for @shrAlertUpcomingPayment.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Payment'**
  String get shrAlertUpcomingPayment;

  /// No description provided for @shrMsgOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'{name} is completely out of stock.'**
  String shrMsgOutOfStock(String name);

  /// No description provided for @shrMsgLowStock.
  ///
  /// In en, this message translates to:
  /// **'{name} is running low ({stock}).'**
  String shrMsgLowStock(String name, String stock);

  /// No description provided for @shrMsgExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'{name} expires in {days} days.'**
  String shrMsgExpiringSoon(String name, int days);

  /// No description provided for @shrMsgOverdueUdhaar.
  ///
  /// In en, this message translates to:
  /// **'{name} has pending ₹{amount} for {days} days.'**
  String shrMsgOverdueUdhaar(String name, String amount, int days);

  /// No description provided for @shrMsgPaymentOverdue.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} to {supplier} is overdue.'**
  String shrMsgPaymentOverdue(String amount, String supplier);

  /// No description provided for @shrMsgPaymentDue.
  ///
  /// In en, this message translates to:
  /// **'₹{amount} to {supplier} due in {days} days.'**
  String shrMsgPaymentDue(String amount, String supplier, int days);

  /// No description provided for @psetErrorWith.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String psetErrorWith(String error);

  /// No description provided for @psetCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get psetCancel;

  /// No description provided for @psetReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get psetReset;

  /// No description provided for @psetUserActivity.
  ///
  /// In en, this message translates to:
  /// **'User Activity'**
  String get psetUserActivity;

  /// No description provided for @psetNoUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get psetNoUsersFound;

  /// No description provided for @psetNoStore.
  ///
  /// In en, this message translates to:
  /// **'No store'**
  String get psetNoStore;

  /// No description provided for @psetNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get psetNever;

  /// No description provided for @psetActiveToday.
  ///
  /// In en, this message translates to:
  /// **'Active today'**
  String get psetActiveToday;

  /// No description provided for @psetInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get psetInactive;

  /// No description provided for @psetLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get psetLastSeen;

  /// No description provided for @psetOpensToday.
  ///
  /// In en, this message translates to:
  /// **'Opens today'**
  String get psetOpensToday;

  /// No description provided for @psetTimeInApp.
  ///
  /// In en, this message translates to:
  /// **'Time in app'**
  String get psetTimeInApp;

  /// No description provided for @psetSalesToday.
  ///
  /// In en, this message translates to:
  /// **'Sales today'**
  String get psetSalesToday;

  /// No description provided for @psetJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get psetJustNow;

  /// No description provided for @psetMinsAgo.
  ///
  /// In en, this message translates to:
  /// **'{m}m ago'**
  String psetMinsAgo(int m);

  /// No description provided for @psetHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{h}h ago'**
  String psetHoursAgo(int h);

  /// No description provided for @psetDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{d}d ago'**
  String psetDaysAgo(int d);

  /// No description provided for @psetPasswordSecurity.
  ///
  /// In en, this message translates to:
  /// **'Password & Security'**
  String get psetPasswordSecurity;

  /// No description provided for @psetCouldNotLoadStatus.
  ///
  /// In en, this message translates to:
  /// **'Could not load status: {error}'**
  String psetCouldNotLoadStatus(String error);

  /// No description provided for @psetEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get psetEnterNewPassword;

  /// No description provided for @psetPasswordMin6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get psetPasswordMin6;

  /// No description provided for @psetPasswordsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get psetPasswordsNoMatch;

  /// No description provided for @psetEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get psetEnterCurrentPassword;

  /// No description provided for @psetPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully.'**
  String get psetPasswordUpdated;

  /// No description provided for @psetPasswordCreated.
  ///
  /// In en, this message translates to:
  /// **'Password created successfully.'**
  String get psetPasswordCreated;

  /// No description provided for @psetCouldNotConnect.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to server. Please try again.'**
  String get psetCouldNotConnect;

  /// No description provided for @psetSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get psetSomethingWrong;

  /// No description provided for @psetPasswordSet.
  ///
  /// In en, this message translates to:
  /// **'Password set'**
  String get psetPasswordSet;

  /// No description provided for @psetNoPasswordYet.
  ///
  /// In en, this message translates to:
  /// **'No password yet'**
  String get psetNoPasswordYet;

  /// No description provided for @psetLastChanged.
  ///
  /// In en, this message translates to:
  /// **'Last changed {date}'**
  String psetLastChanged(String date);

  /// No description provided for @psetPasswordActive.
  ///
  /// In en, this message translates to:
  /// **'Password is active'**
  String get psetPasswordActive;

  /// No description provided for @psetCreatePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password to enable username login'**
  String get psetCreatePasswordHint;

  /// No description provided for @psetPasswordCooldown.
  ///
  /// In en, this message translates to:
  /// **'You can change your password again in {days, plural, =1{1 day} other{{days} days}}.'**
  String psetPasswordCooldown(int days);

  /// No description provided for @psetChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get psetChangePassword;

  /// No description provided for @psetCreatePassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get psetCreatePassword;

  /// No description provided for @psetChangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password, then choose a new one.'**
  String get psetChangeSubtitle;

  /// No description provided for @psetCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a password so you can also log in with your username.'**
  String get psetCreateSubtitle;

  /// No description provided for @psetCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get psetCurrentPassword;

  /// No description provided for @psetNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get psetNewPassword;

  /// No description provided for @psetConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get psetConfirmNewPassword;

  /// No description provided for @psetUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get psetUpdatePassword;

  /// No description provided for @psetPasswordCooldownNote.
  ///
  /// In en, this message translates to:
  /// **'Password can only be changed once every 14 days.'**
  String get psetPasswordCooldownNote;

  /// No description provided for @psetAllHistory.
  ///
  /// In en, this message translates to:
  /// **'All History'**
  String get psetAllHistory;

  /// No description provided for @psetTabPurchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get psetTabPurchases;

  /// No description provided for @psetTabPosOrders.
  ///
  /// In en, this message translates to:
  /// **'POS Orders'**
  String get psetTabPosOrders;

  /// No description provided for @psetNoPurchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'No purchase history found.'**
  String get psetNoPurchaseHistory;

  /// No description provided for @psetViewBill.
  ///
  /// In en, this message translates to:
  /// **'View Bill'**
  String get psetViewBill;

  /// No description provided for @psetPurchaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Purchase Details'**
  String get psetPurchaseDetails;

  /// No description provided for @psetFromSupplier.
  ///
  /// In en, this message translates to:
  /// **'From {supplier}'**
  String psetFromSupplier(String supplier);

  /// No description provided for @psetQtyTimes.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty} × ₹{price}'**
  String psetQtyTimes(String qty, String price);

  /// No description provided for @psetTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get psetTotalAmount;

  /// No description provided for @psetSalesTxnHistory.
  ///
  /// In en, this message translates to:
  /// **'Sales Transaction History'**
  String get psetSalesTxnHistory;

  /// No description provided for @psetSalesTxnDesc.
  ///
  /// In en, this message translates to:
  /// **'View and filter all your POS orders, payments, and customer transactions.'**
  String get psetSalesTxnDesc;

  /// No description provided for @psetOpenSalesHistory.
  ///
  /// In en, this message translates to:
  /// **'Open Sales History'**
  String get psetOpenSalesHistory;

  /// No description provided for @psetSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get psetSettingsSaved;

  /// No description provided for @psetSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String psetSaveFailed(String error);

  /// No description provided for @psetResetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get psetResetToDefaults;

  /// No description provided for @psetResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'All settings will be reset to their default values.'**
  String get psetResetConfirm;

  /// No description provided for @psetConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get psetConfiguration;

  /// No description provided for @psetPosPreferences.
  ///
  /// In en, this message translates to:
  /// **'POS Preferences'**
  String get psetPosPreferences;

  /// No description provided for @psetAiForecasting.
  ///
  /// In en, this message translates to:
  /// **'AI & Forecasting'**
  String get psetAiForecasting;

  /// No description provided for @psetAlertThresholds.
  ///
  /// In en, this message translates to:
  /// **'Alert Thresholds'**
  String get psetAlertThresholds;

  /// No description provided for @psetMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get psetMarketing;

  /// No description provided for @psetNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get psetNotifications;

  /// No description provided for @psetDefaultPayment.
  ///
  /// In en, this message translates to:
  /// **'Default Payment Method'**
  String get psetDefaultPayment;

  /// No description provided for @psetDefaultPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Pre-selected method when adding a new sale'**
  String get psetDefaultPaymentHint;

  /// No description provided for @psetCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get psetCash;

  /// No description provided for @psetCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get psetCard;

  /// No description provided for @psetForecastHorizon.
  ///
  /// In en, this message translates to:
  /// **'Forecast Horizon'**
  String get psetForecastHorizon;

  /// No description provided for @psetForecastHorizonHint.
  ///
  /// In en, this message translates to:
  /// **'How many days ahead the AI predicts stock needs'**
  String get psetForecastHorizonHint;

  /// No description provided for @psetDaysValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String psetDaysValue(int days);

  /// No description provided for @psetStockoutRisk.
  ///
  /// In en, this message translates to:
  /// **'Stockout Risk Threshold'**
  String get psetStockoutRisk;

  /// No description provided for @psetStockoutRiskHint.
  ///
  /// In en, this message translates to:
  /// **'Show stockout alert when 7-day risk exceeds this'**
  String get psetStockoutRiskHint;

  /// No description provided for @psetMinVelocity.
  ///
  /// In en, this message translates to:
  /// **'Min Velocity Threshold'**
  String get psetMinVelocity;

  /// No description provided for @psetMinVelocityHint.
  ///
  /// In en, this message translates to:
  /// **'Items selling slower than this are flagged as dead stock'**
  String get psetMinVelocityHint;

  /// No description provided for @psetReorderAlertDays.
  ///
  /// In en, this message translates to:
  /// **'Reorder Alert Days'**
  String get psetReorderAlertDays;

  /// No description provided for @psetReorderAlertHint.
  ///
  /// In en, this message translates to:
  /// **'Alert when projected stock will run out within N days'**
  String get psetReorderAlertHint;

  /// No description provided for @psetDeadStockDays.
  ///
  /// In en, this message translates to:
  /// **'Dead Stock Days'**
  String get psetDeadStockDays;

  /// No description provided for @psetDeadStockHint.
  ///
  /// In en, this message translates to:
  /// **'Flag items with no sales for N or more days'**
  String get psetDeadStockHint;

  /// No description provided for @psetExpiryAlertDays.
  ///
  /// In en, this message translates to:
  /// **'Expiry Alert Days'**
  String get psetExpiryAlertDays;

  /// No description provided for @psetExpiryAlertHint.
  ///
  /// In en, this message translates to:
  /// **'Alert this many days before a batch/item expires'**
  String get psetExpiryAlertHint;

  /// No description provided for @psetDaysBeforeValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days before'**
  String psetDaysBeforeValue(int days);

  /// No description provided for @psetAllowMarketing.
  ///
  /// In en, this message translates to:
  /// **'Allow LohiyaAI to Market My Store'**
  String get psetAllowMarketing;

  /// No description provided for @psetAllowMarketingHint.
  ///
  /// In en, this message translates to:
  /// **'We promote your store on Facebook, Instagram & WhatsApp on your behalf'**
  String get psetAllowMarketingHint;

  /// No description provided for @psetInAppAlerts.
  ///
  /// In en, this message translates to:
  /// **'In-app Alerts'**
  String get psetInAppAlerts;

  /// No description provided for @psetInAppAlertsHint.
  ///
  /// In en, this message translates to:
  /// **'Show alerts inside the app'**
  String get psetInAppAlertsHint;

  /// No description provided for @psetWhatsappNotif.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Notifications'**
  String get psetWhatsappNotif;

  /// No description provided for @psetWhatsappNotifHint.
  ///
  /// In en, this message translates to:
  /// **'Send restocking and udhaar alerts via WhatsApp'**
  String get psetWhatsappNotifHint;

  /// No description provided for @psetQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get psetQuietHours;

  /// No description provided for @psetQuietHoursHint.
  ///
  /// In en, this message translates to:
  /// **'No notifications will be sent during this window'**
  String get psetQuietHoursHint;

  /// No description provided for @psetStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get psetStart;

  /// No description provided for @psetEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get psetEnd;

  /// No description provided for @psetSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get psetSaveChanges;

  /// No description provided for @psetCashflowSupport.
  ///
  /// In en, this message translates to:
  /// **'Cashflow Support'**
  String get psetCashflowSupport;

  /// No description provided for @psetRequestUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Request Under Review'**
  String get psetRequestUnderReview;

  /// No description provided for @psetReqProcessingFull.
  ///
  /// In en, this message translates to:
  /// **'Your cashflow request for ₹{amount} via {bank} is being processed.\n\nOur team will contact you within 2 business days.'**
  String psetReqProcessingFull(String amount, String bank);

  /// No description provided for @psetReqProcessing.
  ///
  /// In en, this message translates to:
  /// **'Your cashflow request is being processed.\n\nOur team will contact you within 2 business days.'**
  String get psetReqProcessing;

  /// No description provided for @psetRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted!'**
  String get psetRequestSubmitted;

  /// No description provided for @psetRequestSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ve received your cashflow request.\nOur team will contact you within\n2 business days.'**
  String get psetRequestSubmittedBody;

  /// No description provided for @psetBackToProfile.
  ///
  /// In en, this message translates to:
  /// **'Back to Profile'**
  String get psetBackToProfile;

  /// No description provided for @psetApplyCashflow.
  ///
  /// In en, this message translates to:
  /// **'Apply for\nCashflow Support'**
  String get psetApplyCashflow;

  /// No description provided for @psetCashflowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick business finance, powered by LohiyaAI partners.'**
  String get psetCashflowSubtitle;

  /// No description provided for @psetYourBusinessProfile.
  ///
  /// In en, this message translates to:
  /// **'Your Business Profile'**
  String get psetYourBusinessProfile;

  /// No description provided for @psetStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get psetStore;

  /// No description provided for @psetLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get psetLocation;

  /// No description provided for @psetDailyFootfall.
  ///
  /// In en, this message translates to:
  /// **'Daily Footfall'**
  String get psetDailyFootfall;

  /// No description provided for @psetCustomersPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} customers/day'**
  String psetCustomersPerDay(int count);

  /// No description provided for @psetHowMuchNeed.
  ///
  /// In en, this message translates to:
  /// **'How much do you need?'**
  String get psetHowMuchNeed;

  /// No description provided for @psetDragToSelect.
  ///
  /// In en, this message translates to:
  /// **'Drag to select — ₹50,000 to ₹10,00,000'**
  String get psetDragToSelect;

  /// No description provided for @psetLoanAmount.
  ///
  /// In en, this message translates to:
  /// **'loan amount'**
  String get psetLoanAmount;

  /// No description provided for @psetChoosePartnerBank.
  ///
  /// In en, this message translates to:
  /// **'Choose a Partner Bank'**
  String get psetChoosePartnerBank;

  /// No description provided for @psetSelectBankHint.
  ///
  /// In en, this message translates to:
  /// **'Select a bank to proceed with your request.'**
  String get psetSelectBankHint;

  /// No description provided for @psetSubmitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get psetSubmitRequest;

  /// No description provided for @psetSubmitDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'By submitting, you agree to be contacted by our team regarding this request.'**
  String get psetSubmitDisclaimer;

  /// No description provided for @psetBankSbiDesc.
  ///
  /// In en, this message translates to:
  /// **'Government-backed scheme for small businesses'**
  String get psetBankSbiDesc;

  /// No description provided for @psetBankHdfcDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick disbursal for retail growth'**
  String get psetBankHdfcDesc;

  /// No description provided for @psetBankIciciDesc.
  ///
  /// In en, this message translates to:
  /// **'Flexible credit for kirana owners'**
  String get psetBankIciciDesc;

  /// No description provided for @psetBankAxisDesc.
  ///
  /// In en, this message translates to:
  /// **'Tailored finance for retail stores'**
  String get psetBankAxisDesc;

  /// No description provided for @widgetTitleSales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get widgetTitleSales;

  /// No description provided for @widgetTitleUdhaar.
  ///
  /// In en, this message translates to:
  /// **'Udhaar Due'**
  String get widgetTitleUdhaar;

  /// No description provided for @widgetTitleLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get widgetTitleLowStock;

  /// No description provided for @widgetTitlePayToday.
  ///
  /// In en, this message translates to:
  /// **'Pay Today'**
  String get widgetTitlePayToday;

  /// No description provided for @widgetNewBill.
  ///
  /// In en, this message translates to:
  /// **'+ New Bill'**
  String get widgetNewBill;

  /// No description provided for @widgetUnitOrders.
  ///
  /// In en, this message translates to:
  /// **'orders'**
  String get widgetUnitOrders;

  /// No description provided for @widgetUnitItems.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get widgetUnitItems;

  /// No description provided for @widgetUnitOverdue.
  ///
  /// In en, this message translates to:
  /// **'overdue'**
  String get widgetUnitOverdue;

  /// No description provided for @widgetUnitPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get widgetUnitPending;

  /// No description provided for @widgetUnitToPay.
  ///
  /// In en, this message translates to:
  /// **'to pay'**
  String get widgetUnitToPay;

  /// No description provided for @widgetSignIn.
  ///
  /// In en, this message translates to:
  /// **'Open Outlet AI to sign in'**
  String get widgetSignIn;

  /// No description provided for @widgetNoData.
  ///
  /// In en, this message translates to:
  /// **'Open the app to load today\'s numbers'**
  String get widgetNoData;

  /// No description provided for @visionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Vision AI is coming soon!'**
  String get visionComingSoon;

  /// No description provided for @mktTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get mktTierBronze;

  /// No description provided for @mktTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get mktTierSilver;

  /// No description provided for @mktTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get mktTierGold;

  /// No description provided for @mktTierPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get mktTierPlatinum;

  /// No description provided for @mktTierSettings.
  ///
  /// In en, this message translates to:
  /// **'Tier settings'**
  String get mktTierSettings;

  /// No description provided for @mktShowArchived.
  ///
  /// In en, this message translates to:
  /// **'Show archived'**
  String get mktShowArchived;

  /// No description provided for @mktHideArchived.
  ///
  /// In en, this message translates to:
  /// **'Hide archived'**
  String get mktHideArchived;

  /// No description provided for @mktArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get mktArchived;

  /// No description provided for @mktEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get mktEdit;

  /// No description provided for @mktAlertedToday.
  ///
  /// In en, this message translates to:
  /// **'Alerted today'**
  String get mktAlertedToday;

  /// No description provided for @mktRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get mktRestore;

  /// No description provided for @mktArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get mktArchive;

  /// No description provided for @mktBasketArchived.
  ///
  /// In en, this message translates to:
  /// **'Basket archived'**
  String get mktBasketArchived;

  /// No description provided for @mktBasketRestored.
  ///
  /// In en, this message translates to:
  /// **'Basket restored'**
  String get mktBasketRestored;

  /// No description provided for @mktSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get mktSomethingWentWrong;

  /// No description provided for @mktEditBasket.
  ///
  /// In en, this message translates to:
  /// **'Edit Basket'**
  String get mktEditBasket;

  /// No description provided for @mktSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get mktSaveChanges;

  /// No description provided for @mktAddItemsForPrice.
  ///
  /// In en, this message translates to:
  /// **'Add items to see the auto-discounted bundle price'**
  String get mktAddItemsForPrice;

  /// No description provided for @mktItemsTotal.
  ///
  /// In en, this message translates to:
  /// **'Items total'**
  String get mktItemsTotal;

  /// No description provided for @mktBundlePrice.
  ///
  /// In en, this message translates to:
  /// **'Bundle price'**
  String get mktBundlePrice;

  /// No description provided for @mktTierConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Basket Tiers'**
  String get mktTierConfigTitle;

  /// No description provided for @mktTierConfigIntro.
  ///
  /// In en, this message translates to:
  /// **'Baskets are auto-priced by their total value. Set the value range and discount for each tier — the matching tier\'s discount is applied automatically as you add items.'**
  String get mktTierConfigIntro;

  /// No description provided for @mktTierRangeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Each tier\'s limit must be higher than the previous, and discounts between 0–100%.'**
  String get mktTierRangeInvalid;

  /// No description provided for @mktTiersSaved.
  ///
  /// In en, this message translates to:
  /// **'Tiers saved'**
  String get mktTiersSaved;

  /// No description provided for @mktRecomputeTitle.
  ///
  /// In en, this message translates to:
  /// **'Recompute existing baskets?'**
  String get mktRecomputeTitle;

  /// No description provided for @mktKeepAsIs.
  ///
  /// In en, this message translates to:
  /// **'Keep as-is'**
  String get mktKeepAsIs;

  /// No description provided for @mktRecompute.
  ///
  /// In en, this message translates to:
  /// **'Recompute'**
  String get mktRecompute;

  /// No description provided for @mktSaveTiers.
  ///
  /// In en, this message translates to:
  /// **'Save Tiers'**
  String get mktSaveTiers;

  /// No description provided for @mktUpToLabel.
  ///
  /// In en, this message translates to:
  /// **'Up to'**
  String get mktUpToLabel;

  /// No description provided for @mktTopTierHint.
  ///
  /// In en, this message translates to:
  /// **'Everything above the previous tier'**
  String get mktTopTierHint;

  /// No description provided for @mktDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get mktDiscountLabel;

  /// No description provided for @psetBasketTiers.
  ///
  /// In en, this message translates to:
  /// **'Basket Tiers'**
  String get psetBasketTiers;

  /// No description provided for @psetBasketTiersHint.
  ///
  /// In en, this message translates to:
  /// **'Auto-discount baskets by value'**
  String get psetBasketTiersHint;

  /// No description provided for @mktYouSave.
  ///
  /// In en, this message translates to:
  /// **'Save ₹{amount} ({pct}% off)'**
  String mktYouSave(String amount, String pct);

  /// No description provided for @mktTierBasketLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier} basket'**
  String mktTierBasketLabel(String tier);

  /// No description provided for @mktPctOff.
  ///
  /// In en, this message translates to:
  /// **'{pct}% off'**
  String mktPctOff(String pct);

  /// No description provided for @mktSaveAmount.
  ///
  /// In en, this message translates to:
  /// **'Save ₹{amount}'**
  String mktSaveAmount(String amount);

  /// No description provided for @mktRecomputeBody.
  ///
  /// In en, this message translates to:
  /// **'{count} existing baskets are priced under your old tiers. Apply the new tiers to them too?'**
  String mktRecomputeBody(int count);

  /// No description provided for @mktBasketsRecomputed.
  ///
  /// In en, this message translates to:
  /// **'{count} baskets updated'**
  String mktBasketsRecomputed(int count);

  /// No description provided for @mktAboveAmount.
  ///
  /// In en, this message translates to:
  /// **'Above ₹{amount}'**
  String mktAboveAmount(String amount);

  /// No description provided for @mktRangeAmount.
  ///
  /// In en, this message translates to:
  /// **'₹{from} – ₹{to}'**
  String mktRangeAmount(String from, String to);

  /// No description provided for @mktSaveAsBasket.
  ///
  /// In en, this message translates to:
  /// **'Save as Basket'**
  String get mktSaveAsBasket;

  /// No description provided for @mktBasketSavedFromCampaign.
  ///
  /// In en, this message translates to:
  /// **'Saved \"{name}\" to your baskets'**
  String mktBasketSavedFromCampaign(String name);

  /// No description provided for @mktSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get mktSelectDate;

  /// No description provided for @mktBasketsProTitle.
  ///
  /// In en, this message translates to:
  /// **'Baskets is a Pro feature'**
  String get mktBasketsProTitle;

  /// No description provided for @mktBasketsProDesc.
  ///
  /// In en, this message translates to:
  /// **'Create combo deals with automatic tier discounts and alert customers on WhatsApp. Upgrade to Pro to unlock baskets.'**
  String get mktBasketsProDesc;

  /// No description provided for @visionNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get visionNavLabel;

  /// No description provided for @visionTitle.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get visionTitle;

  /// No description provided for @visionTabShelf.
  ///
  /// In en, this message translates to:
  /// **'Shelf Scan'**
  String get visionTabShelf;

  /// No description provided for @visionTabResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get visionTabResults;

  /// No description provided for @visionTabCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get visionTabCounter;

  /// No description provided for @visionProTitle.
  ///
  /// In en, this message translates to:
  /// **'Vision AI'**
  String get visionProTitle;

  /// No description provided for @visionProDesc.
  ///
  /// In en, this message translates to:
  /// **'Snap your shelf morning and evening — AI counts your stock and tells you what sold.'**
  String get visionProDesc;

  /// No description provided for @visionFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get visionFromCamera;

  /// No description provided for @visionFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get visionFromGallery;

  /// No description provided for @visionMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning — Start of Day'**
  String get visionMorningTitle;

  /// No description provided for @visionEveningTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening — End of Day'**
  String get visionEveningTitle;

  /// No description provided for @visionTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get visionTakePhoto;

  /// No description provided for @visionRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get visionRetake;

  /// No description provided for @visionReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get visionReview;

  /// No description provided for @visionAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing shelf… this can take up to a minute'**
  String get visionAnalyzing;

  /// No description provided for @visionScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed. Please retake the photo.'**
  String get visionScanFailed;

  /// No description provided for @visionStillProcessing.
  ///
  /// In en, this message translates to:
  /// **'Still analysing your photos — this can take a couple of minutes. The result will appear here when it\'s ready.'**
  String get visionStillProcessing;

  /// No description provided for @visionCheckAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get visionCheckAgain;

  /// No description provided for @visionNoPhotoYet.
  ///
  /// In en, this message translates to:
  /// **'No photo taken yet.'**
  String get visionNoPhotoYet;

  /// No description provided for @visionProductsIdentified.
  ///
  /// In en, this message translates to:
  /// **'Products identified'**
  String get visionProductsIdentified;

  /// No description provided for @visionUnitsCounted.
  ///
  /// In en, this message translates to:
  /// **'Units counted'**
  String get visionUnitsCounted;

  /// No description provided for @visionNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get visionNeedsReview;

  /// No description provided for @visionViewSales.
  ///
  /// In en, this message translates to:
  /// **'View Today\'s Sales'**
  String get visionViewSales;

  /// No description provided for @visionTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: take the morning photo before opening and the evening photo before closing. AI works out how many of each product sold.'**
  String get visionTip;

  /// No description provided for @visionSalesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Take a morning and an evening photo to see what sold today.'**
  String get visionSalesEmpty;

  /// No description provided for @visionTotalSold.
  ///
  /// In en, this message translates to:
  /// **'Total items sold'**
  String get visionTotalSold;

  /// No description provided for @visionSold.
  ///
  /// In en, this message translates to:
  /// **'sold'**
  String get visionSold;

  /// No description provided for @visionMorningCount.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get visionMorningCount;

  /// No description provided for @visionEveningCount.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get visionEveningCount;

  /// No description provided for @visionUnknownItem.
  ///
  /// In en, this message translates to:
  /// **'Unknown — tap to fix'**
  String get visionUnknownItem;

  /// No description provided for @visionCorrected.
  ///
  /// In en, this message translates to:
  /// **'Corrected'**
  String get visionCorrected;

  /// No description provided for @visionCorrectTitle.
  ///
  /// In en, this message translates to:
  /// **'Which product is this?'**
  String get visionCorrectTitle;

  /// No description provided for @visionSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search your products'**
  String get visionSearchProducts;

  /// No description provided for @visionClearCorrection.
  ///
  /// In en, this message translates to:
  /// **'Clear correction'**
  String get visionClearCorrection;

  /// No description provided for @visionNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products loaded yet. Open the Billing tab once, then come back.'**
  String get visionNoProducts;

  /// No description provided for @visionCounterSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Counter — coming soon'**
  String get visionCounterSoonTitle;

  /// No description provided for @visionCounterSoonDesc.
  ///
  /// In en, this message translates to:
  /// **'Point your phone at the billing counter to auto-count sales as items pass. We\'re putting the finishing touches on it.'**
  String get visionCounterSoonDesc;

  /// No description provided for @visionCounterStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Sale Counter'**
  String get visionCounterStartTitle;

  /// No description provided for @visionCounterStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Point your phone at the billing counter. Items passing across the line are counted automatically — no barcode scanning.'**
  String get visionCounterStartDesc;

  /// No description provided for @visionCounterStart.
  ///
  /// In en, this message translates to:
  /// **'Start counting'**
  String get visionCounterStart;

  /// No description provided for @visionCounterFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get visionCounterFinish;

  /// No description provided for @visionCounterPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get visionCounterPause;

  /// No description provided for @visionCounterResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get visionCounterResume;

  /// No description provided for @visionCounterUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get visionCounterUndo;

  /// No description provided for @visionCounterFlip.
  ///
  /// In en, this message translates to:
  /// **'Flip side'**
  String get visionCounterFlip;

  /// No description provided for @visionCounterCounted.
  ///
  /// In en, this message translates to:
  /// **'Counted'**
  String get visionCounterCounted;

  /// No description provided for @visionCounterNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Move items across the line to count them.'**
  String get visionCounterNothingYet;

  /// No description provided for @visionCounterHint.
  ///
  /// In en, this message translates to:
  /// **'Items crossing into the green zone are counted as sold.'**
  String get visionCounterHint;

  /// No description provided for @visionCounterZoneStore.
  ///
  /// In en, this message translates to:
  /// **'In store'**
  String get visionCounterZoneStore;

  /// No description provided for @visionCounterZoneSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get visionCounterZoneSold;

  /// No description provided for @visionCounterModelMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Counter model not installed'**
  String get visionCounterModelMissingTitle;

  /// No description provided for @visionCounterModelMissingDesc.
  ///
  /// In en, this message translates to:
  /// **'The on-device counting model isn\'t bundled in this build yet. It\'s coming in an update — shelf scanning still works.'**
  String get visionCounterModelMissingDesc;

  /// No description provided for @visionCounterPermTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access needed'**
  String get visionCounterPermTitle;

  /// No description provided for @visionCounterPermDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access to count items at the billing counter.'**
  String get visionCounterPermDesc;

  /// No description provided for @visionCounterGrant.
  ///
  /// In en, this message translates to:
  /// **'Allow camera'**
  String get visionCounterGrant;

  /// No description provided for @visionCounterOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get visionCounterOpenSettings;

  /// No description provided for @visionCounterFinishConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish counting?'**
  String get visionCounterFinishConfirmTitle;

  /// No description provided for @visionCounterFinishConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ll save today\'s tally and add it to your counter summary.'**
  String get visionCounterFinishConfirmDesc;

  /// No description provided for @visionCounterSave.
  ///
  /// In en, this message translates to:
  /// **'Save count'**
  String get visionCounterSave;

  /// No description provided for @visionCounterDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get visionCounterDiscard;

  /// No description provided for @visionCounterKeepCounting.
  ///
  /// In en, this message translates to:
  /// **'Keep counting'**
  String get visionCounterKeepCounting;

  /// No description provided for @visionCounterSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Counting saved'**
  String get visionCounterSavedTitle;

  /// No description provided for @visionCounterSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {count} items across {skus} products.'**
  String visionCounterSaved(int count, int skus);

  /// No description provided for @visionCounterOfflineNote.
  ///
  /// In en, this message translates to:
  /// **'Saved on your phone. It\'ll sync when the counter service is available.'**
  String get visionCounterOfflineNote;

  /// No description provided for @visionCounterPending.
  ///
  /// In en, this message translates to:
  /// **'{count} not synced yet'**
  String visionCounterPending(int count);

  /// No description provided for @visionCounterSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s counter tally'**
  String get visionCounterSummaryTitle;

  /// No description provided for @visionCounterSummaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items counted today. Tap Start counting to begin.'**
  String get visionCounterSummaryEmpty;

  /// No description provided for @visionCounterSummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total counted today'**
  String get visionCounterSummaryTotal;

  /// No description provided for @visionCounterUnknownItem.
  ///
  /// In en, this message translates to:
  /// **'Unrecognised product'**
  String get visionCounterUnknownItem;

  /// No description provided for @onbCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Have hundreds of items?'**
  String get onbCtaTitle;

  /// No description provided for @onbCtaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Photograph your shelves and we\'ll identify the products and add them to your inventory — no scanning each one.'**
  String get onbCtaSubtitle;

  /// No description provided for @onbCtaButton.
  ///
  /// In en, this message translates to:
  /// **'Snap your shelves'**
  String get onbCtaButton;

  /// No description provided for @onbCaptureTitle.
  ///
  /// In en, this message translates to:
  /// **'Photograph your shelves'**
  String get onbCaptureTitle;

  /// No description provided for @onbCaptureHint.
  ///
  /// In en, this message translates to:
  /// **'Take 3 to 10 clear photos covering all your shelves. Good lighting helps us identify more products.'**
  String get onbCaptureHint;

  /// No description provided for @onbTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get onbTakePhoto;

  /// No description provided for @onbPhotosProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} of 10 photos'**
  String onbPhotosProgress(int count);

  /// No description provided for @onbMinPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 photos'**
  String get onbMinPhotos;

  /// No description provided for @onbAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Identify products'**
  String get onbAnalyze;

  /// No description provided for @onbProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re reviewing your shelf photos'**
  String get onbProcessingTitle;

  /// No description provided for @onbProcessingDesc.
  ///
  /// In en, this message translates to:
  /// **'Our system is identifying the products on your shelves. This usually takes under a minute. Please keep this screen open — we\'ll show the results here shortly.'**
  String get onbProcessingDesc;

  /// No description provided for @onbReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your stock'**
  String get onbReviewTitle;

  /// No description provided for @onbReviewDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These are the products we identified from your photos. We may occasionally miss or misread an item, so please cross-check and adjust the quantities. We\'re continually improving our accuracy.'**
  String get onbReviewDisclaimer;

  /// No description provided for @onbReviewSummary.
  ///
  /// In en, this message translates to:
  /// **'{mapped} ready · {unmapped} need a product'**
  String onbReviewSummary(int mapped, int unmapped);

  /// No description provided for @onbUnrecognised.
  ///
  /// In en, this message translates to:
  /// **'Not recognised — choose a product'**
  String get onbUnrecognised;

  /// No description provided for @onbChooseProduct.
  ///
  /// In en, this message translates to:
  /// **'Choose product'**
  String get onbChooseProduct;

  /// No description provided for @onbQuantity.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get onbQuantity;

  /// No description provided for @onbCommit.
  ///
  /// In en, this message translates to:
  /// **'Add to my inventory'**
  String get onbCommit;

  /// No description provided for @onbCommitting.
  ///
  /// In en, this message translates to:
  /// **'Adding to your inventory…'**
  String get onbCommitting;

  /// No description provided for @onbDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock added'**
  String get onbDoneTitle;

  /// No description provided for @onbDoneDesc.
  ///
  /// In en, this message translates to:
  /// **'{products} products ({units} units) added to your inventory. You can set prices anytime from the Inventory tab.'**
  String onbDoneDesc(int products, int units);

  /// No description provided for @onbEmptyDetected.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t identify products in these photos. Please retake them in better light, showing the packaging clearly.'**
  String get onbEmptyDetected;

  /// No description provided for @onbRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake photos'**
  String get onbRetake;

  /// No description provided for @onbFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t finish'**
  String get onbFailedTitle;

  /// No description provided for @onbDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get onbDone;

  /// No description provided for @onbRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get onbRemove;

  /// No description provided for @visionAddPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Add shelf photos'**
  String get visionAddPhotosTitle;

  /// No description provided for @visionAddPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Take 3 to 10 photos covering your shelves.'**
  String get visionAddPhotosHint;

  /// No description provided for @visionMinPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 photos'**
  String get visionMinPhotosHint;

  /// No description provided for @visionMaxReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 photos'**
  String get visionMaxReached;

  /// No description provided for @visionAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get visionAnalyze;

  /// No description provided for @forecastSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'SALES FORECAST'**
  String get forecastSectionLabel;

  /// No description provided for @forecastStripCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items may sell tomorrow'**
  String forecastStripCount(int count);

  /// No description provided for @forecastStripEst.
  ///
  /// In en, this message translates to:
  /// **'Est. {amount}'**
  String forecastStripEst(String amount);

  /// No description provided for @forecastStripViewAll.
  ///
  /// In en, this message translates to:
  /// **'See full list'**
  String get forecastStripViewAll;

  /// No description provided for @forecastScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Forecast'**
  String get forecastScreenTitle;

  /// No description provided for @forecastHorizonTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get forecastHorizonTomorrow;

  /// No description provided for @forecastHorizon3d.
  ///
  /// In en, this message translates to:
  /// **'3 Days'**
  String get forecastHorizon3d;

  /// No description provided for @forecastHorizon5d.
  ///
  /// In en, this message translates to:
  /// **'5 Days'**
  String get forecastHorizon5d;

  /// No description provided for @forecastHorizon7d.
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get forecastHorizon7d;

  /// No description provided for @forecastHorizon14d.
  ///
  /// In en, this message translates to:
  /// **'14 Days'**
  String get forecastHorizon14d;

  /// No description provided for @forecastHorizon30d.
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get forecastHorizon30d;

  /// No description provided for @forecastRevLabel.
  ///
  /// In en, this message translates to:
  /// **'Est. revenue'**
  String get forecastRevLabel;

  /// No description provided for @forecastOosWarning.
  ///
  /// In en, this message translates to:
  /// **'May run out'**
  String get forecastOosWarning;

  /// No description provided for @forecastWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this item?'**
  String get forecastWhyTitle;

  /// No description provided for @forecastWhyAvgDaily.
  ///
  /// In en, this message translates to:
  /// **'Avg daily sales'**
  String get forecastWhyAvgDaily;

  /// No description provided for @forecastWhyStockDays.
  ///
  /// In en, this message translates to:
  /// **'Stock left'**
  String get forecastWhyStockDays;

  /// No description provided for @forecastWhyOosRisk.
  ///
  /// In en, this message translates to:
  /// **'Chance of running out'**
  String get forecastWhyOosRisk;

  /// No description provided for @forecastWhyExplain.
  ///
  /// In en, this message translates to:
  /// **'This item sells about {avg} units every day. In {days} days, we expect about {units} units to sell from your store.'**
  String forecastWhyExplain(String avg, String days, String units);

  /// No description provided for @forecastNoData.
  ///
  /// In en, this message translates to:
  /// **'Forecast not ready yet. Please try again later.'**
  String get forecastNoData;

  /// No description provided for @forecastDataStale.
  ///
  /// In en, this message translates to:
  /// **'Data may be outdated'**
  String get forecastDataStale;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'hi',
    'kn',
    'ml',
    'mr',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
