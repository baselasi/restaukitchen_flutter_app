import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @commonAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter Demo'**
  String get commonAppTitle;

  /// No description provided for @commonHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get commonHome;

  /// No description provided for @commonMenus.
  ///
  /// In en, this message translates to:
  /// **'Menus'**
  String get commonMenus;

  /// No description provided for @commonOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get commonOrders;

  /// No description provided for @commonTables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get commonTables;

  /// No description provided for @commonCombinations.
  ///
  /// In en, this message translates to:
  /// **'Combinations'**
  String get commonCombinations;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @commonCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get commonCategories;

  /// No description provided for @commonIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get commonIngredients;

  /// No description provided for @commonDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get commonDimensions;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonAddDish.
  ///
  /// In en, this message translates to:
  /// **'Add dish'**
  String get commonAddDish;

  /// No description provided for @commonAddDishes.
  ///
  /// In en, this message translates to:
  /// **'Add Dishes'**
  String get commonAddDishes;

  /// No description provided for @commonAddIngredients.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredients'**
  String get commonAddIngredients;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get commonUpdate;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get commonArchive;

  /// No description provided for @commonPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get commonPrint;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonLoadingEllipsis.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get commonLoadingEllipsis;

  /// No description provided for @commonRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get commonRequiredField;

  /// No description provided for @commonValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get commonValidNumber;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @commonErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get commonErrorOccurred;

  /// No description provided for @commonAreYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get commonAreYouSure;

  /// No description provided for @commonDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get commonDescription;

  /// No description provided for @commonAddDescription.
  ///
  /// In en, this message translates to:
  /// **'Add description'**
  String get commonAddDescription;

  /// No description provided for @commonNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get commonNote;

  /// No description provided for @commonNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get commonNotAvailable;

  /// No description provided for @commonNoPriceSet.
  ///
  /// In en, this message translates to:
  /// **'No price set'**
  String get commonNoPriceSet;

  /// No description provided for @commonSelectDimension.
  ///
  /// In en, this message translates to:
  /// **'Select dimension'**
  String get commonSelectDimension;

  /// No description provided for @commonNoDimensionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No dimensions available'**
  String get commonNoDimensionsAvailable;

  /// No description provided for @commonSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get commonSelectCategory;

  /// No description provided for @commonGenerateQrCode.
  ///
  /// In en, this message translates to:
  /// **'Generate QR Code'**
  String get commonGenerateQrCode;

  /// No description provided for @commonFailedLoadQrCode.
  ///
  /// In en, this message translates to:
  /// **'Failed to load QR code'**
  String get commonFailedLoadQrCode;

  /// No description provided for @commonFailedLoadCombination.
  ///
  /// In en, this message translates to:
  /// **'Failed to load combination'**
  String get commonFailedLoadCombination;

  /// No description provided for @commonNoCombinationDataFound.
  ///
  /// In en, this message translates to:
  /// **'No combination data found'**
  String get commonNoCombinationDataFound;

  /// No description provided for @commonFailedLoadDish.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dish'**
  String get commonFailedLoadDish;

  /// No description provided for @commonFailedLoadIngredients.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ingredients'**
  String get commonFailedLoadIngredients;

  /// No description provided for @commonFailedLoadDimensions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dimensions'**
  String get commonFailedLoadDimensions;

  /// No description provided for @commonChangeImage.
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get commonChangeImage;

  /// No description provided for @commonChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonChange;

  /// No description provided for @commonNewOrder.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get commonNewOrder;

  /// No description provided for @commonCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get commonCreateOrder;

  /// No description provided for @commonSaveOrder.
  ///
  /// In en, this message translates to:
  /// **'Save Order'**
  String get commonSaveOrder;

  /// No description provided for @commonNoDishesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No dishes available'**
  String get commonNoDishesAvailable;

  /// No description provided for @commonNoMenus.
  ///
  /// In en, this message translates to:
  /// **'No menus'**
  String get commonNoMenus;

  /// No description provided for @commonAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get commonAvailable;

  /// No description provided for @commonUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get commonUnavailable;

  /// No description provided for @commonFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get commonFree;

  /// No description provided for @commonReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get commonReserved;

  /// No description provided for @commonOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get commonOccupied;

  /// No description provided for @commonReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get commonReceived;

  /// No description provided for @commonOnFire.
  ///
  /// In en, this message translates to:
  /// **'On Fire'**
  String get commonOnFire;

  /// No description provided for @commonDoneStatus.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDoneStatus;

  /// No description provided for @commonEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get commonEnglish;

  /// No description provided for @commonItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get commonItalian;

  /// No description provided for @commonFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get commonFrench;

  /// No description provided for @commonSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get commonSpanish;

  /// No description provided for @commonArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get commonArabic;

  /// No description provided for @commonMonthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get commonMonthJan;

  /// No description provided for @commonMonthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get commonMonthFeb;

  /// No description provided for @commonMonthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get commonMonthMar;

  /// No description provided for @commonMonthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get commonMonthApr;

  /// No description provided for @commonMonthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get commonMonthMay;

  /// No description provided for @commonMonthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get commonMonthJun;

  /// No description provided for @commonMonthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get commonMonthJul;

  /// No description provided for @commonMonthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get commonMonthAug;

  /// No description provided for @commonMonthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get commonMonthSep;

  /// No description provided for @commonMonthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get commonMonthOct;

  /// No description provided for @commonMonthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get commonMonthNov;

  /// No description provided for @commonMonthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get commonMonthDec;

  /// No description provided for @commonCurrencyDollar.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get commonCurrencyDollar;

  /// No description provided for @commonCurrencyEuro.
  ///
  /// In en, this message translates to:
  /// **'€'**
  String get commonCurrencyEuro;

  /// No description provided for @commonEmDash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get commonEmDash;

  /// No description provided for @commonHyphen.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get commonHyphen;

  /// No description provided for @commonCurrencyLebanesePound.
  ///
  /// In en, this message translates to:
  /// **'L.L.'**
  String get commonCurrencyLebanesePound;

  /// No description provided for @commonPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price: {price}'**
  String commonPriceLabel(String price);

  /// No description provided for @commonTableLabel.
  ///
  /// In en, this message translates to:
  /// **'Table {number}'**
  String commonTableLabel(String number);

  /// No description provided for @commonCourseLabel.
  ///
  /// In en, this message translates to:
  /// **'Course {number}'**
  String commonCourseLabel(int number);

  /// No description provided for @commonQuantityLeading.
  ///
  /// In en, this message translates to:
  /// **'x{quantity}'**
  String commonQuantityLeading(int quantity);

  /// No description provided for @commonQuantityTrailing.
  ///
  /// In en, this message translates to:
  /// **'{quantity}x'**
  String commonQuantityTrailing(int quantity);

  /// No description provided for @commonNoteWithValue.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String commonNoteWithValue(String note);

  /// No description provided for @authValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authValidEmailAddress;

  /// No description provided for @authLoginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get authLoginSuccessful;

  /// No description provided for @authBadCredentials.
  ///
  /// In en, this message translates to:
  /// **'Bad credentials'**
  String get authBadCredentials;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// No description provided for @authSignInContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInContinue;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailHint;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authDemoEmail.
  ///
  /// In en, this message translates to:
  /// **'ziadkhaled_822@hotmail.com'**
  String get authDemoEmail;

  /// No description provided for @authDemoPassword.
  ///
  /// In en, this message translates to:
  /// **'ziad'**
  String get authDemoPassword;

  /// No description provided for @homeTableAvailability.
  ///
  /// In en, this message translates to:
  /// **'Table availability'**
  String get homeTableAvailability;

  /// No description provided for @homeOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get homeOpen;

  /// No description provided for @homeTotalTables.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 tables total} one{1 table total} other{{count} tables total}}'**
  String homeTotalTables(int count);

  /// No description provided for @homeOpenOrders.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 open orders} one{1 open order} other{{count} open orders}}'**
  String homeOpenOrders(int count);

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsLogout;

  /// No description provided for @settingsCatalogue.
  ///
  /// In en, this message translates to:
  /// **'CATALOGUE'**
  String get settingsCatalogue;

  /// No description provided for @settingsMenusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure different seasonal menus'**
  String get settingsMenusSubtitle;

  /// No description provided for @settingsCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize dishes into menu sections'**
  String get settingsCategoriesSubtitle;

  /// No description provided for @settingsIngredientsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allergens, stock and supplier info'**
  String get settingsIngredientsSubtitle;

  /// No description provided for @settingsDimensionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Portion sizes and measurement units'**
  String get settingsDimensionsSubtitle;

  /// No description provided for @settingsErrorLoadingRestaurantInfo.
  ///
  /// In en, this message translates to:
  /// **'Error loading restaurant info'**
  String get settingsErrorLoadingRestaurantInfo;

  /// No description provided for @settingsPersonalSettings.
  ///
  /// In en, this message translates to:
  /// **'Personal Settings'**
  String get settingsPersonalSettings;

  /// No description provided for @settingsSystemLanguage.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM LANGUAGE'**
  String get settingsSystemLanguage;

  /// No description provided for @restaurantEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Restaurant'**
  String get restaurantEditTitle;

  /// No description provided for @restaurantNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Name'**
  String get restaurantNameLabel;

  /// No description provided for @restaurantNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter restaurant name'**
  String get restaurantNameHint;

  /// No description provided for @restaurantCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get restaurantCountryLabel;

  /// No description provided for @restaurantLoadingCountries.
  ///
  /// In en, this message translates to:
  /// **'Loading countries...'**
  String get restaurantLoadingCountries;

  /// No description provided for @restaurantSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select a country'**
  String get restaurantSelectCountry;

  /// No description provided for @restaurantSelectCountryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a country'**
  String get restaurantSelectCountryRequired;

  /// No description provided for @restaurantCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get restaurantCityLabel;

  /// No description provided for @restaurantSearchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get restaurantSearchCity;

  /// No description provided for @restaurantSelectCountryFirstHint.
  ///
  /// In en, this message translates to:
  /// **'Select a country first'**
  String get restaurantSelectCountryFirstHint;

  /// No description provided for @restaurantSelectCountryFirstError.
  ///
  /// In en, this message translates to:
  /// **'Please select a country first'**
  String get restaurantSelectCountryFirstError;

  /// No description provided for @restaurantSelectCityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get restaurantSelectCityRequired;

  /// No description provided for @restaurantChooseCityFromList.
  ///
  /// In en, this message translates to:
  /// **'Please choose a city from the list'**
  String get restaurantChooseCityFromList;

  /// No description provided for @restaurantFailedLoadCountries.
  ///
  /// In en, this message translates to:
  /// **'Failed to load countries'**
  String get restaurantFailedLoadCountries;

  /// No description provided for @restaurantFailedLoadCities.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cities'**
  String get restaurantFailedLoadCities;

  /// No description provided for @restaurantNoCitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No cities found'**
  String get restaurantNoCitiesFound;

  /// No description provided for @restaurantCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get restaurantCurrencyLabel;

  /// No description provided for @restaurantSelectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Please select a currency'**
  String get restaurantSelectCurrency;

  /// No description provided for @restaurantAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get restaurantAddressLabel;

  /// No description provided for @restaurantAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get restaurantAddressHint;

  /// No description provided for @restaurantDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get restaurantDescriptionHint;

  /// No description provided for @restaurantErrorUpdating.
  ///
  /// In en, this message translates to:
  /// **'Error updating restaurant'**
  String get restaurantErrorUpdating;

  /// No description provided for @tablesNewTable.
  ///
  /// In en, this message translates to:
  /// **'New Table'**
  String get tablesNewTable;

  /// No description provided for @tablesSortTables.
  ///
  /// In en, this message translates to:
  /// **'Sort tables'**
  String get tablesSortTables;

  /// No description provided for @tablesNoTables.
  ///
  /// In en, this message translates to:
  /// **'No tables'**
  String get tablesNoTables;

  /// No description provided for @tablesTotalCoversTitle.
  ///
  /// In en, this message translates to:
  /// **'Total covers'**
  String get tablesTotalCoversTitle;

  /// No description provided for @tablesTotalCoversHint.
  ///
  /// In en, this message translates to:
  /// **'Enter total covers'**
  String get tablesTotalCoversHint;

  /// No description provided for @tablesTableNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Table Number'**
  String get tablesTableNumberLabel;

  /// No description provided for @tablesTableSeatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Table Number of Seats'**
  String get tablesTableSeatsLabel;

  /// No description provided for @tablesTableNumberInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Table number'**
  String get tablesTableNumberInputLabel;

  /// No description provided for @tablesStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tablesStatusLabel;

  /// No description provided for @tablesErrorLoadingTable.
  ///
  /// In en, this message translates to:
  /// **'Error loading table'**
  String get tablesErrorLoadingTable;

  /// No description provided for @tablesQrPreviewPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'QR preview placeholder'**
  String get tablesQrPreviewPlaceholder;

  /// No description provided for @tablesSeatsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} seat} other{{count} seats}}'**
  String tablesSeatsCount(int count);

  /// No description provided for @menusListTitle.
  ///
  /// In en, this message translates to:
  /// **'Menus List'**
  String get menusListTitle;

  /// No description provided for @menusUpdatedRecently.
  ///
  /// In en, this message translates to:
  /// **'Updated recently'**
  String get menusUpdatedRecently;

  /// No description provided for @menusEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit menu'**
  String get menusEditTooltip;

  /// No description provided for @menusDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete menu'**
  String get menusDeleteTooltip;

  /// No description provided for @menusFailedDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete menu'**
  String get menusFailedDelete;

  /// No description provided for @menusEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Menu'**
  String get menusEditTitle;

  /// No description provided for @menusCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Menu'**
  String get menusCreateTitle;

  /// No description provided for @menusEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit the name of your menu.'**
  String get menusEditDescription;

  /// No description provided for @menusCreateDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a name for your new menu.'**
  String get menusCreateDescription;

  /// No description provided for @menusNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Menu name'**
  String get menusNameLabel;

  /// No description provided for @menusFailedCreate.
  ///
  /// In en, this message translates to:
  /// **'Failed to create menu'**
  String get menusFailedCreate;

  /// No description provided for @menusItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 items} one{1 item} other{{count} items}}'**
  String menusItemsCount(int count);

  /// No description provided for @menusCombinationMenuBadge.
  ///
  /// In en, this message translates to:
  /// **'Combination menu'**
  String get menusCombinationMenuBadge;

  /// No description provided for @dishesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Dish'**
  String get dishesDeleteTitle;

  /// No description provided for @dishesDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{dishName}\"? This action cannot be undone.'**
  String dishesDeleteConfirmation(String dishName);

  /// No description provided for @dishesDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Dish deleted successfully'**
  String get dishesDeletedSuccessfully;

  /// No description provided for @dishesFailedDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete dish'**
  String get dishesFailedDelete;

  /// No description provided for @dishesCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Dish created successfully'**
  String get dishesCreatedSuccessfully;

  /// No description provided for @dishesNewDish.
  ///
  /// In en, this message translates to:
  /// **'New Dish'**
  String get dishesNewDish;

  /// No description provided for @dishesEssentials.
  ///
  /// In en, this message translates to:
  /// **'Essentials'**
  String get dishesEssentials;

  /// No description provided for @dishesNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get dishesNameLabel;

  /// No description provided for @dishesAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get dishesAvailability;

  /// No description provided for @dishesDimensionPricing.
  ///
  /// In en, this message translates to:
  /// **'Dimension & pricing'**
  String get dishesDimensionPricing;

  /// No description provided for @categoriesListTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories List'**
  String get categoriesListTitle;

  /// No description provided for @categoriesFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get categoriesFailedLoad;

  /// No description provided for @categoriesEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get categoriesEditTooltip;

  /// No description provided for @categoriesDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get categoriesDeleteTooltip;

  /// No description provided for @categoriesFailedDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete category'**
  String get categoriesFailedDelete;

  /// No description provided for @categoriesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get categoriesEditTitle;

  /// No description provided for @categoriesCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get categoriesCreateTitle;

  /// No description provided for @categoriesEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit the name of your category.'**
  String get categoriesEditDescription;

  /// No description provided for @categoriesCreateDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a name for your new category.'**
  String get categoriesCreateDescription;

  /// No description provided for @categoriesNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoriesNameLabel;

  /// No description provided for @categoriesUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Category'**
  String get categoriesUpdateTitle;

  /// No description provided for @categoriesFailedCreate.
  ///
  /// In en, this message translates to:
  /// **'Failed to create category'**
  String get categoriesFailedCreate;

  /// No description provided for @ingredientsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients List'**
  String get ingredientsListTitle;

  /// No description provided for @ingredientsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading ingredients'**
  String get ingredientsErrorLoading;

  /// No description provided for @ingredientsEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit ingredient'**
  String get ingredientsEditTooltip;

  /// No description provided for @ingredientsDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete ingredient'**
  String get ingredientsDeleteTooltip;

  /// No description provided for @ingredientsErrorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting ingredient'**
  String get ingredientsErrorDeleting;

  /// No description provided for @ingredientsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Ingredient'**
  String get ingredientsCreateTitle;

  /// No description provided for @ingredientsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get ingredientsNameLabel;

  /// No description provided for @ingredientsErrorLoadingDimensions.
  ///
  /// In en, this message translates to:
  /// **'Error loading dimensions'**
  String get ingredientsErrorLoadingDimensions;

  /// No description provided for @ingredientsNoIngredientsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No ingredients available'**
  String get ingredientsNoIngredientsAvailable;

  /// No description provided for @ingredientsFailedAdd.
  ///
  /// In en, this message translates to:
  /// **'Failed to add ingredients'**
  String get ingredientsFailedAdd;

  /// No description provided for @ingredientsSelectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected Ingredients'**
  String get ingredientsSelectedTitle;

  /// No description provided for @dimensionsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Dimension List'**
  String get dimensionsListTitle;

  /// No description provided for @dimensionsStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard dimension'**
  String get dimensionsStandard;

  /// No description provided for @dimensionsCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom dimension'**
  String get dimensionsCustom;

  /// No description provided for @dimensionsEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit dimension'**
  String get dimensionsEditTooltip;

  /// No description provided for @dimensionsDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete dimension'**
  String get dimensionsDeleteTooltip;

  /// No description provided for @dimensionsErrorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting dimension'**
  String get dimensionsErrorDeleting;

  /// No description provided for @dimensionsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Dimension'**
  String get dimensionsEditTitle;

  /// No description provided for @dimensionsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Dimension'**
  String get dimensionsCreateTitle;

  /// No description provided for @dimensionsEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit the name and settings of your dimension.'**
  String get dimensionsEditDescription;

  /// No description provided for @dimensionsCreateDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a name for your new dimension.'**
  String get dimensionsCreateDescription;

  /// No description provided for @dimensionsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Dimension name'**
  String get dimensionsNameLabel;

  /// No description provided for @dimensionsSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Dimension'**
  String get dimensionsSaveTitle;

  /// No description provided for @dimensionsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Dimension'**
  String get dimensionsAddTitle;

  /// No description provided for @dimensionsCombinationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Combination name'**
  String get dimensionsCombinationNameLabel;

  /// No description provided for @dimensionsCombinationNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for this combination'**
  String get dimensionsCombinationNameHint;

  /// No description provided for @dimensionsNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get dimensionsNext;

  /// No description provided for @dimensionsPriceHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get dimensionsPriceHint;

  /// No description provided for @combinationsNoCombinations.
  ///
  /// In en, this message translates to:
  /// **'No combinations'**
  String get combinationsNoCombinations;

  /// No description provided for @combinationsEditPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Combo'**
  String get combinationsEditPreviewTitle;

  /// No description provided for @combinationsAddMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Menu'**
  String get combinationsAddMenuTitle;

  /// No description provided for @combinationsGroupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get combinationsGroupNameLabel;

  /// No description provided for @combinationsErrorCreatingGroup.
  ///
  /// In en, this message translates to:
  /// **'Error creating group'**
  String get combinationsErrorCreatingGroup;

  /// No description provided for @combinationsNoDishesInMenu.
  ///
  /// In en, this message translates to:
  /// **'No dishes in this menu'**
  String get combinationsNoDishesInMenu;

  /// No description provided for @combinationsNoPlatesForSelectedDimension.
  ///
  /// In en, this message translates to:
  /// **'No plates available for selected dimension'**
  String get combinationsNoPlatesForSelectedDimension;

  /// No description provided for @combinationsDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Combination deleted successfully'**
  String get combinationsDeletedSuccessfully;

  /// No description provided for @combinationsErrorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting combination'**
  String get combinationsErrorDeleting;

  /// No description provided for @orderFormSelectDimension.
  ///
  /// In en, this message translates to:
  /// **'Select the dimension'**
  String get orderFormSelectDimension;

  /// No description provided for @orderFormAddNoteForDish.
  ///
  /// In en, this message translates to:
  /// **'Add note for this dish'**
  String get orderFormAddNoteForDish;

  /// No description provided for @orderFormAddNoteForOrder.
  ///
  /// In en, this message translates to:
  /// **'Add note for this order'**
  String get orderFormAddNoteForOrder;

  /// No description provided for @orderFormPleaseChooseDimension.
  ///
  /// In en, this message translates to:
  /// **'Please choose a dimension'**
  String get orderFormPleaseChooseDimension;

  /// No description provided for @orderFormNoDishesInCourse.
  ///
  /// In en, this message translates to:
  /// **'No dishes in this course'**
  String get orderFormNoDishesInCourse;

  /// No description provided for @orderFormCreateNewCourse.
  ///
  /// In en, this message translates to:
  /// **'CREATE NEW COURSE'**
  String get orderFormCreateNewCourse;

  /// No description provided for @ordersKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get ordersKitchen;

  /// No description provided for @ordersArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get ordersArchive;

  /// No description provided for @ordersDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get ordersDeleted;

  /// No description provided for @ordersNoOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get ordersNoOrdersYet;

  /// No description provided for @ordersNoArchivedOrders.
  ///
  /// In en, this message translates to:
  /// **'No archived orders'**
  String get ordersNoArchivedOrders;

  /// No description provided for @ordersNoDeletedOrders.
  ///
  /// In en, this message translates to:
  /// **'No deleted orders'**
  String get ordersNoDeletedOrders;

  /// No description provided for @ordersNoDishesInOrder.
  ///
  /// In en, this message translates to:
  /// **'No dishes in this order.'**
  String get ordersNoDishesInOrder;

  /// No description provided for @ordersTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total: {currency}{amount}'**
  String ordersTotalLabel(String amount, String currency);

  /// No description provided for @ordersCombinationDishBullet.
  ///
  /// In en, this message translates to:
  /// **'• {name}'**
  String ordersCombinationDishBullet(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
