import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Novaxmine'**
  String get appName;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @loginMsg.
  ///
  /// In en, this message translates to:
  /// **'to your {appName} account'**
  String loginMsg(String appName);

  /// No description provided for @pleaseEnterTransactionHash.
  ///
  /// In en, this message translates to:
  /// **'Please enter the transaction hash'**
  String get pleaseEnterTransactionHash;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter the amount'**
  String get pleaseEnterAmount;

  /// No description provided for @amountMustBeNumeric.
  ///
  /// In en, this message translates to:
  /// **'Amount must be numeric'**
  String get amountMustBeNumeric;

  /// No description provided for @walletAddress.
  ///
  /// In en, this message translates to:
  /// **'Wallet Address:'**
  String get walletAddress;

  /// No description provided for @withdrawAddress.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Address:'**
  String get withdrawAddress;

  /// No description provided for @depositWith.
  ///
  /// In en, this message translates to:
  /// **'Deposit with'**
  String get depositWith;

  /// No description provided for @depositInstructions.
  ///
  /// In en, this message translates to:
  /// **'Deposit Instructions'**
  String get depositInstructions;

  /// No description provided for @youHaveSelected.
  ///
  /// In en, this message translates to:
  /// **'You have selected'**
  String get youHaveSelected;

  /// No description provided for @coinSelection.
  ///
  /// In en, this message translates to:
  /// **'{coinTitle}'**
  String coinSelection(Object coinTitle);

  /// No description provided for @coinSubtitleTemplate.
  ///
  /// In en, this message translates to:
  /// **' ({coinSubtitle}).'**
  String coinSubtitleTemplate(Object coinSubtitle);

  /// No description provided for @amountMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get amountMustBeGreaterThanZero;

  /// No description provided for @sendAmountMsg.
  ///
  /// In en, this message translates to:
  /// **'Please send the desired amount to the wallet address below, then click \"I Have Transferred\".'**
  String get sendAmountMsg;

  /// No description provided for @doubleCheckMsg.
  ///
  /// In en, this message translates to:
  /// **'Make sure to double-check the address and network before sending. Transactions cannot be reversed.'**
  String get doubleCheckMsg;

  /// No description provided for @iHaveTransferred.
  ///
  /// In en, this message translates to:
  /// **'I Have Transferred'**
  String get iHaveTransferred;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @confirmYourDeposit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Deposit'**
  String get confirmYourDeposit;

  /// No description provided for @selectedNetwork.
  ///
  /// In en, this message translates to:
  /// **'Selected Network'**
  String get selectedNetwork;

  /// No description provided for @transactionIdHash.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID / Hash'**
  String get transactionIdHash;

  /// No description provided for @enterTransactionHash.
  ///
  /// In en, this message translates to:
  /// **'Enter your transaction hash'**
  String get enterTransactionHash;

  /// No description provided for @amountTransferred.
  ///
  /// In en, this message translates to:
  /// **'Amount Transferred'**
  String get amountTransferred;

  /// No description provided for @enterTransferredAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter transferred amount'**
  String get enterTransferredAmount;

  /// No description provided for @enterSameNetworkAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount in the same coin / network you transferred.'**
  String get enterSameNetworkAmount;

  /// No description provided for @submitForReview.
  ///
  /// In en, this message translates to:
  /// **'Submit For Review'**
  String get submitForReview;

  /// No description provided for @walletInfoMissing.
  ///
  /// In en, this message translates to:
  /// **'Wallet information missing'**
  String get walletInfoMissing;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signUpMSG.
  ///
  /// In en, this message translates to:
  /// **'Start mining and achieve the highest level of Hashrate.'**
  String get signUpMSG;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @hashRate.
  ///
  /// In en, this message translates to:
  /// **'Hashrate'**
  String get hashRate;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @walletType.
  ///
  /// In en, this message translates to:
  /// **'Wallet Type'**
  String get walletType;

  /// No description provided for @totalReturned.
  ///
  /// In en, this message translates to:
  /// **'Total Returned'**
  String get totalReturned;

  /// No description provided for @refCommission.
  ///
  /// In en, this message translates to:
  /// **'Total Ref. Commission'**
  String get refCommission;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get usernameOrEmail;

  /// No description provided for @usernameOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username or email'**
  String get usernameOrEmailHint;

  /// No description provided for @withdrawInformation.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Information'**
  String get withdrawInformation;

  /// No description provided for @withdrawLimit.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Limit'**
  String get withdrawLimit;

  /// No description provided for @withdrawConfirm.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Confirm'**
  String get withdrawConfirm;

  /// No description provided for @lockBadges.
  ///
  /// In en, this message translates to:
  /// **'Lock Badges'**
  String get lockBadges;

  /// No description provided for @unlockBadges.
  ///
  /// In en, this message translates to:
  /// **'Unlock Badges'**
  String get unlockBadges;

  /// No description provided for @noBadgesUnlocked.
  ///
  /// In en, this message translates to:
  /// **'You have not unlocked any badges yet'**
  String get noBadgesUnlocked;

  /// No description provided for @discountOnMaintenanceAmount.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Discount'**
  String get discountOnMaintenanceAmount;

  /// No description provided for @discountOnPlanPrice.
  ///
  /// In en, this message translates to:
  /// **'Plan Purchase Discount'**
  String get discountOnPlanPrice;

  /// No description provided for @increaseEarningBoost.
  ///
  /// In en, this message translates to:
  /// **'Increase Earning Boost'**
  String get increaseEarningBoost;

  /// No description provided for @enhanceReferralBonus.
  ///
  /// In en, this message translates to:
  /// **'Enhance Referral Bonus'**
  String get enhanceReferralBonus;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @createDepositScreenAppBarText.
  ///
  /// In en, this message translates to:
  /// **'Deposit via Crypto Coins'**
  String get createDepositScreenAppBarText;

  /// No description provided for @depositInfo.
  ///
  /// In en, this message translates to:
  /// **'Deposit Info'**
  String get depositInfo;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @depositHistory.
  ///
  /// In en, this message translates to:
  /// **'Deposit History'**
  String get depositHistory;

  /// No description provided for @depositCharge.
  ///
  /// In en, this message translates to:
  /// **'Deposit Charge'**
  String get depositCharge;

  /// No description provided for @kycRejectedMsg.
  ///
  /// In en, this message translates to:
  /// **'KYC document rejected'**
  String get kycRejectedMsg;

  /// No description provided for @kycUnderReviewMsg.
  ///
  /// In en, this message translates to:
  /// **'Your KYC data is under review'**
  String get kycUnderReviewMsg;

  /// No description provided for @exitTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit\nthe app?'**
  String get exitTitle;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ticketDetails.
  ///
  /// In en, this message translates to:
  /// **'Ticket Details'**
  String get ticketDetails;

  /// No description provided for @ticket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get ticket;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @replyTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket Details'**
  String get replyTicket;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @enterYourSubject.
  ///
  /// In en, this message translates to:
  /// **'Enter your subject'**
  String get enterYourSubject;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @enterFile.
  ///
  /// In en, this message translates to:
  /// **'Enter file'**
  String get enterFile;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @supportedFileHint.
  ///
  /// In en, this message translates to:
  /// **'Supported file type:.jpg, .jpeg, .png, .pdf, .doc, .docx'**
  String get supportedFileHint;

  /// No description provided for @repliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Replied successfully'**
  String get repliedSuccessfully;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'file Not Found'**
  String get fileNotFound;

  /// No description provided for @customerReply.
  ///
  /// In en, this message translates to:
  /// **'Customer Reply'**
  String get customerReply;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yourReply.
  ///
  /// In en, this message translates to:
  /// **'Your Reply'**
  String get yourReply;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @noFileChosen.
  ///
  /// In en, this message translates to:
  /// **'No file chosen'**
  String get noFileChosen;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @unableToAccessStorage.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type'**
  String get unableToAccessStorage;

  /// No description provided for @unsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'Unable to access storage'**
  String get unsupportedFileType;

  /// No description provided for @postedOn.
  ///
  /// In en, this message translates to:
  /// **'Posted on'**
  String get postedOn;

  /// No description provided for @answered.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get answered;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @replied.
  ///
  /// In en, this message translates to:
  /// **'Replied'**
  String get replied;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addNewTicket.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get addNewTicket;

  /// No description provided for @enterYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your message'**
  String get enterYourMessage;

  /// No description provided for @subjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get subjectRequired;

  /// No description provided for @messageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get messageRequired;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @replyTicketEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'Reply ticket can\'t be empty'**
  String get replyTicketEmptyMsg;

  /// No description provided for @ticketCreateSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ticket created successfully'**
  String get ticketCreateSuccessfully;

  /// No description provided for @cancelTicketMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the ticket'**
  String get cancelTicketMessage;

  /// No description provided for @noTicketFound.
  ///
  /// In en, this message translates to:
  /// **'No Ticket Found'**
  String get noTicketFound;

  /// No description provided for @noMSgFound.
  ///
  /// In en, this message translates to:
  /// **'No Message Found'**
  String get noMSgFound;

  /// No description provided for @supportTicket.
  ///
  /// In en, this message translates to:
  /// **'Support Ticket'**
  String get supportTicket;

  /// No description provided for @in_.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get in_;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral code (optional)'**
  String get referralCode;

  /// No description provided for @enterReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Enter referral code'**
  String get enterReferralCode;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @setupKey.
  ///
  /// In en, this message translates to:
  /// **'Setup Key'**
  String get setupKey;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @buyMinningPlan.
  ///
  /// In en, this message translates to:
  /// **'Buy mining plan'**
  String get buyMinningPlan;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search Country'**
  String get searchCountry;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @noWithdrawFound.
  ///
  /// In en, this message translates to:
  /// **'No withdraw found'**
  String get noWithdrawFound;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get createNewPassword;

  /// No description provided for @makeWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Make withdraw'**
  String get makeWithdraw;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @payableAmount.
  ///
  /// In en, this message translates to:
  /// **'Payable Amount'**
  String get payableAmount;

  /// No description provided for @finalAmount.
  ///
  /// In en, this message translates to:
  /// **'Final Amount'**
  String get finalAmount;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select PaymentMethod'**
  String get selectPaymentMethod;

  /// No description provided for @createPasswordSubText.
  ///
  /// In en, this message translates to:
  /// **'To secure your account pls provide a strong password'**
  String get createPasswordSubText;

  /// No description provided for @fileDownloadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'File downloaded successfully'**
  String get fileDownloadedSuccess;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloading;

  /// No description provided for @addWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Add Withdraw'**
  String get addWithdraw;

  /// No description provided for @receivable.
  ///
  /// In en, this message translates to:
  /// **'Receivable'**
  String get receivable;

  /// No description provided for @authorizationMethod.
  ///
  /// In en, this message translates to:
  /// **'Authorization Method'**
  String get authorizationMethod;

  /// No description provided for @kyc.
  ///
  /// In en, this message translates to:
  /// **'KYC'**
  String get kyc;

  /// No description provided for @kycVerification.
  ///
  /// In en, this message translates to:
  /// **'KYC Verification'**
  String get kycVerification;

  /// No description provided for @please.
  ///
  /// In en, this message translates to:
  /// **'Please'**
  String get please;

  /// No description provided for @noDataToShow.
  ///
  /// In en, this message translates to:
  /// **'Sorry! there are no data to show'**
  String get noDataToShow;

  /// No description provided for @selectAuthModeMsg.
  ///
  /// In en, this message translates to:
  /// **'Please select an authorization mode'**
  String get selectAuthModeMsg;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @disable2Fa.
  ///
  /// In en, this message translates to:
  /// **'Disable 2FA Security'**
  String get disable2Fa;

  /// No description provided for @copiedToClipBoard.
  ///
  /// In en, this message translates to:
  /// **'Copied to your clipboard!'**
  String get copiedToClipBoard;

  /// No description provided for @selectACountry.
  ///
  /// In en, this message translates to:
  /// **'Select a Country'**
  String get selectACountry;

  /// No description provided for @isRequired.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get isRequired;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @kycAlreadyVerifiedMsg.
  ///
  /// In en, this message translates to:
  /// **'You are already verified'**
  String get kycAlreadyVerifiedMsg;

  /// No description provided for @kycVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'KYC Verification Required'**
  String get kycVerificationRequired;

  /// No description provided for @kycRejectSubtitleMsg.
  ///
  /// In en, this message translates to:
  /// **'Your KYC document has been rejected. Please resubmit the document for further review.'**
  String get kycRejectSubtitleMsg;

  /// No description provided for @kycVerificationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please submit the required KYC information to verify yourself. Otherwise, you couldn\'t make any withdrawal request.'**
  String get kycVerificationMsg;

  /// No description provided for @kycPendingMsg.
  ///
  /// In en, this message translates to:
  /// **'Thank you for submitting your KYC documents. Our team is currently reviewing the information.'**
  String get kycPendingMsg;

  /// No description provided for @passwordResetEmailSentTo.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent to'**
  String get passwordResetEmailSentTo;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'your email'**
  String get yourEmail;

  /// No description provided for @plsSelectOne.
  ///
  /// In en, this message translates to:
  /// **'Please Select One'**
  String get plsSelectOne;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Facebook'**
  String get signInWithFacebook;

  /// No description provided for @signInWithLinkedin.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Linkedin'**
  String get signInWithLinkedin;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login To Your Account'**
  String get loginTitle;

  /// No description provided for @phoneNo.
  ///
  /// In en, this message translates to:
  /// **'Phone No.'**
  String get phoneNo;

  /// No description provided for @otpFieldEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'Otp field can\'t be empty'**
  String get otpFieldEmptyMsg;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get usernameHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or username to reset your password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get createNew;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get loginNow;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get emailAddressHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter confirm password'**
  String get confirmPasswordHint;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get signUpTitle;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @selectGateway.
  ///
  /// In en, this message translates to:
  /// **'Select Gateway'**
  String get selectGateway;

  /// No description provided for @selectAGateway.
  ///
  /// In en, this message translates to:
  /// **'Please select a gateway'**
  String get selectAGateway;

  /// No description provided for @selectOne.
  ///
  /// In en, this message translates to:
  /// **'Select One'**
  String get selectOne;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @pleaseEnterYourAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter your amount'**
  String get pleaseEnterYourAmount;

  /// No description provided for @plsEnterAnAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get plsEnterAnAmount;

  /// No description provided for @depositLimit.
  ///
  /// In en, this message translates to:
  /// **'Deposit Limit'**
  String get depositLimit;

  /// No description provided for @useQRCODETips.
  ///
  /// In en, this message translates to:
  /// **'Use the QR code or setup key on your Google Authenticator app to add your account.'**
  String get useQRCODETips;

  /// No description provided for @useQRCODETips2.
  ///
  /// In en, this message translates to:
  /// **'Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the 2-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device.'**
  String get useQRCODETips2;

  /// No description provided for @addYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Your Account'**
  String get addYourAccount;

  /// No description provided for @enable2Fa.
  ///
  /// In en, this message translates to:
  /// **'Enable 2FA Security'**
  String get enable2Fa;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @passwordVerification.
  ///
  /// In en, this message translates to:
  /// **'Password Verification'**
  String get passwordVerification;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @otpEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'OTP field can\'t be empty'**
  String get otpEmptyMsg;

  /// No description provided for @verifyPasswordSubText.
  ///
  /// In en, this message translates to:
  /// **'A 6 digits verification code sent to your\nemail address'**
  String get verifyPasswordSubText;

  /// No description provided for @viaEmailVerify.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you six-digit verification code via email for email verification'**
  String get viaEmailVerify;

  /// No description provided for @smsVerificationMsg.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you an access code to your phone number for SMS verification'**
  String get smsVerificationMsg;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @twoFactorMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code from your two factor authenticator APP.'**
  String get twoFactorMsg;

  /// No description provided for @badResponseMsg.
  ///
  /// In en, this message translates to:
  /// **'Bad Response Format!'**
  String get badResponseMsg;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// No description provided for @unAuthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unAuthorized;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @orderNo.
  ///
  /// In en, this message translates to:
  /// **'Order No.'**
  String get orderNo;

  /// No description provided for @orderAmount.
  ///
  /// In en, this message translates to:
  /// **'Order Amount'**
  String get orderAmount;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @referralLink.
  ///
  /// In en, this message translates to:
  /// **'Referral Link'**
  String get referralLink;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Mining Plan'**
  String get plan;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planTitle;

  /// No description provided for @referrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get referrals;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @newMine.
  ///
  /// In en, this message translates to:
  /// **'New Mine'**
  String get newMine;

  /// No description provided for @miningTracks.
  ///
  /// In en, this message translates to:
  /// **'Mining Tracks'**
  String get miningTracks;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transaction;

  /// No description provided for @latestTransaction.
  ///
  /// In en, this message translates to:
  /// **'Latest Transactions'**
  String get latestTransaction;

  /// No description provided for @minerTracksInfo.
  ///
  /// In en, this message translates to:
  /// **'Mining Tracks Info'**
  String get minerTracksInfo;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @depositWallet.
  ///
  /// In en, this message translates to:
  /// **'Deposit Wallet'**
  String get depositWallet;

  /// No description provided for @earningWallet.
  ///
  /// In en, this message translates to:
  /// **'Earning Wallet'**
  String get earningWallet;

  /// No description provided for @referralBonus.
  ///
  /// In en, this message translates to:
  /// **'Referral Bonus'**
  String get referralBonus;

  /// No description provided for @miningDetails.
  ///
  /// In en, this message translates to:
  /// **'Mining Details'**
  String get miningDetails;

  /// No description provided for @miningTrackDetails.
  ///
  /// In en, this message translates to:
  /// **'Mining Tracks Details'**
  String get miningTrackDetails;

  /// No description provided for @orderedAt.
  ///
  /// In en, this message translates to:
  /// **'Ordered At'**
  String get orderedAt;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @miner.
  ///
  /// In en, this message translates to:
  /// **'Miner'**
  String get miner;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @returnDay.
  ///
  /// In en, this message translates to:
  /// **'Return / Day'**
  String get returnDay;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get totalDays;

  /// No description provided for @remainingDays.
  ///
  /// In en, this message translates to:
  /// **'Remaining Days'**
  String get remainingDays;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @dLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dLogout;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @charge.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get charge;

  /// No description provided for @payable.
  ///
  /// In en, this message translates to:
  /// **'Payable'**
  String get payable;

  /// No description provided for @conversionRate.
  ///
  /// In en, this message translates to:
  /// **'Conversion Rate'**
  String get conversionRate;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @youWillGet.
  ///
  /// In en, this message translates to:
  /// **'You will get'**
  String get youWillGet;

  /// No description provided for @trx.
  ///
  /// In en, this message translates to:
  /// **'TRX No'**
  String get trx;

  /// No description provided for @trxNo.
  ///
  /// In en, this message translates to:
  /// **'TRX'**
  String get trxNo;

  /// No description provided for @trxID.
  ///
  /// In en, this message translates to:
  /// **'TRX Id'**
  String get trxID;

  /// No description provided for @postBalance.
  ///
  /// In en, this message translates to:
  /// **'Post Balance'**
  String get postBalance;

  /// No description provided for @gateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get gateway;

  /// No description provided for @initiated.
  ///
  /// In en, this message translates to:
  /// **'initiated'**
  String get initiated;

  /// No description provided for @withdrawPreview.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Preview'**
  String get withdrawPreview;

  /// No description provided for @withdrawHistory.
  ///
  /// In en, this message translates to:
  /// **'Withdraw History'**
  String get withdrawHistory;

  /// No description provided for @withdrawNow.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Now'**
  String get withdrawNow;

  /// No description provided for @withdrawMoney.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Money'**
  String get withdrawMoney;

  /// No description provided for @withdrawDetails.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Details'**
  String get withdrawDetails;

  /// No description provided for @withdrawRequestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request successfully submitted'**
  String get withdrawRequestSuccess;

  /// No description provided for @startMining.
  ///
  /// In en, this message translates to:
  /// **'Start Mining'**
  String get startMining;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @planPrice.
  ///
  /// In en, this message translates to:
  /// **'Plan Price'**
  String get planPrice;

  /// No description provided for @fromBalance.
  ///
  /// In en, this message translates to:
  /// **'From Balance'**
  String get fromBalance;

  /// No description provided for @fromProfitWallet.
  ///
  /// In en, this message translates to:
  /// **'From Profit Wallet'**
  String get fromProfitWallet;

  /// No description provided for @directPayment.
  ///
  /// In en, this message translates to:
  /// **'Direct Payment'**
  String get directPayment;

  /// No description provided for @referralBonusLogs.
  ///
  /// In en, this message translates to:
  /// **'Referral Bonus Logs'**
  String get referralBonusLogs;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @joinOn.
  ///
  /// In en, this message translates to:
  /// **'Join On'**
  String get joinOn;

  /// No description provided for @yourReferees.
  ///
  /// In en, this message translates to:
  /// **'Your Referees'**
  String get yourReferees;

  /// No description provided for @changeYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Change Your Password'**
  String get changeYourPassword;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MineLab'**
  String get welcome;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @currentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get currentPasswordHint;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @requestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Request Success'**
  String get requestSuccess;

  /// No description provided for @currentPassEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'Current password field is empty'**
  String get currentPassEmptyMsg;

  /// No description provided for @newPassEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'New password field is empty'**
  String get newPassEmptyMsg;

  /// No description provided for @passNoMatchMsg.
  ///
  /// In en, this message translates to:
  /// **'Password not match'**
  String get passNoMatchMsg;

  /// No description provided for @createNewPassDescription.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different\nfrom previous used password'**
  String get createNewPassDescription;

  /// No description provided for @logoutSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Logout Successfully'**
  String get logoutSuccessMsg;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @confirmEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your E-mail Address'**
  String get confirmEmailAddress;

  /// No description provided for @newPlanReady.
  ///
  /// In en, this message translates to:
  /// **'New plan is ready for you'**
  String get newPlanReady;

  /// No description provided for @planUpdateRequest.
  ///
  /// In en, this message translates to:
  /// **'Plan update request'**
  String get planUpdateRequest;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetPassword;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Policies'**
  String get privacyPolicy;

  /// No description provided for @amountError.
  ///
  /// In en, this message translates to:
  /// **'Amount must be less than or equal to'**
  String get amountError;

  /// No description provided for @toEarningWallet.
  ///
  /// In en, this message translates to:
  /// **'to Earning Wallet'**
  String get toEarningWallet;

  /// No description provided for @totalEarning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get totalEarning;

  /// No description provided for @totalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total Received'**
  String get totalReceived;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @coinWallets.
  ///
  /// In en, this message translates to:
  /// **'Coin Wallets'**
  String get coinWallets;

  /// No description provided for @minerWallets.
  ///
  /// In en, this message translates to:
  /// **'Miner Wallets'**
  String get minerWallets;

  /// No description provided for @updateWallet.
  ///
  /// In en, this message translates to:
  /// **'Update Wallet'**
  String get updateWallet;

  /// No description provided for @walletAddressEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'Wallet address can\'t be empty'**
  String get walletAddressEmptyMsg;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter first Name'**
  String get enterFirstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter last Name'**
  String get enterLastName;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterYourAddress;

  /// No description provided for @enterYourState.
  ///
  /// In en, this message translates to:
  /// **'Enter your state'**
  String get enterYourState;

  /// No description provided for @enterYourZipcode.
  ///
  /// In en, this message translates to:
  /// **'Enter your zip code'**
  String get enterYourZipcode;

  /// No description provided for @enterYourCity.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get enterYourCity;

  /// No description provided for @minLimit.
  ///
  /// In en, this message translates to:
  /// **'Min Limit'**
  String get minLimit;

  /// No description provided for @maxLimit.
  ///
  /// In en, this message translates to:
  /// **'Max Limit'**
  String get maxLimit;

  /// No description provided for @withdrawMethod.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Method'**
  String get withdrawMethod;

  /// No description provided for @profileComplete.
  ///
  /// In en, this message translates to:
  /// **'Profile Complete'**
  String get profileComplete;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'success'**
  String get success;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @resendCodeFail.
  ///
  /// In en, this message translates to:
  /// **'Resend code fail'**
  String get resendCodeFail;

  /// No description provided for @successfullyCodeResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code successfully'**
  String get successfullyCodeResend;

  /// No description provided for @emailVerify.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerify;

  /// No description provided for @smsVerify.
  ///
  /// In en, this message translates to:
  /// **'Sms Verification'**
  String get smsVerify;

  /// No description provided for @kMatchPassError.
  ///
  /// In en, this message translates to:
  /// **'Password doesn\'t match'**
  String get kMatchPassError;

  /// No description provided for @kFirstNameNullError.
  ///
  /// In en, this message translates to:
  /// **'Please enter first name'**
  String get kFirstNameNullError;

  /// No description provided for @kLastNameNullError.
  ///
  /// In en, this message translates to:
  /// **'Please enter last name'**
  String get kLastNameNullError;

  /// No description provided for @kShortUserNameError.
  ///
  /// In en, this message translates to:
  /// **'Username must be 6 character'**
  String get kShortUserNameError;

  /// No description provided for @kUserNameNullError.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get kUserNameNullError;

  /// No description provided for @kPhoneNumberNullError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get kPhoneNumberNullError;

  /// No description provided for @currentPassNullError.
  ///
  /// In en, this message translates to:
  /// **'Current pass null '**
  String get currentPassNullError;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @passVerification.
  ///
  /// In en, this message translates to:
  /// **'Password Verification'**
  String get passVerification;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didNotReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @plsFillProperly.
  ///
  /// In en, this message translates to:
  /// **'Please fill up all the cells properly'**
  String get plsFillProperly;

  /// No description provided for @plsEnter.
  ///
  /// In en, this message translates to:
  /// **'Please Enter '**
  String get plsEnter;

  /// No description provided for @emailOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Email or user name'**
  String get emailOrUsername;

  /// No description provided for @loginFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'User login failed , pls try again'**
  String get loginFailedTryAgain;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get error;

  /// No description provided for @requestFail.
  ///
  /// In en, this message translates to:
  /// **'Request Failed'**
  String get requestFail;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @coinCode.
  ///
  /// In en, this message translates to:
  /// **'Coin Code'**
  String get coinCode;

  /// No description provided for @remark.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get remark;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @searchByTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search by transactions'**
  String get searchByTransactions;

  /// No description provided for @transactionNo.
  ///
  /// In en, this message translates to:
  /// **'Transaction No'**
  String get transactionNo;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get percent;

  /// No description provided for @myReferrals.
  ///
  /// In en, this message translates to:
  /// **'My Referrals'**
  String get myReferrals;

  /// No description provided for @referralLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral link copied'**
  String get referralLinkCopied;

  /// No description provided for @purchasedDate.
  ///
  /// In en, this message translates to:
  /// **'Purchased Date'**
  String get purchasedDate;

  /// No description provided for @unPaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unPaid;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get noData;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete your Account'**
  String get deleteYourAccount;

  /// No description provided for @deleteBottomSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You will lose all of your data by deleting your account. This action cannot be undone.'**
  String get deleteBottomSheetSubtitle;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get pleaseEnterUsername;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter valid email'**
  String get enterValidEmail;

  /// No description provided for @enterPhoneNo.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNo;

  /// No description provided for @iAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree with'**
  String get iAgree;

  /// No description provided for @trxType.
  ///
  /// In en, this message translates to:
  /// **'Trx type'**
  String get trxType;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @enterTransactionNo.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction no.'**
  String get enterTransactionNo;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @sms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @verificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification Success'**
  String get verificationSuccess;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification Failed'**
  String get verificationFailed;

  /// No description provided for @emailVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email Verification Success'**
  String get emailVerificationSuccess;

  /// No description provided for @emailVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Email Verification Failed'**
  String get emailVerificationFailed;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @enterYourPassword_.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword_;

  /// No description provided for @invalidPassMsg.
  ///
  /// In en, this message translates to:
  /// **'Password must be contain 1 special character and number'**
  String get invalidPassMsg;

  /// No description provided for @hasUpperLetter.
  ///
  /// In en, this message translates to:
  /// **'Has uppercase letter'**
  String get hasUpperLetter;

  /// No description provided for @hasLowerLetter.
  ///
  /// In en, this message translates to:
  /// **'Has lowercase letter'**
  String get hasLowerLetter;

  /// No description provided for @hasDigit.
  ///
  /// In en, this message translates to:
  /// **'Has digit'**
  String get hasDigit;

  /// No description provided for @hasSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Has special character'**
  String get hasSpecialChar;

  /// No description provided for @minSixChar.
  ///
  /// In en, this message translates to:
  /// **'Min of 6 characters'**
  String get minSixChar;

  /// No description provided for @myReferredUsers.
  ///
  /// In en, this message translates to:
  /// **'My Referred Users'**
  String get myReferredUsers;

  /// No description provided for @miningHistory.
  ///
  /// In en, this message translates to:
  /// **'Mining History'**
  String get miningHistory;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @maintenanceCost.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Cost'**
  String get maintenanceCost;

  /// No description provided for @submitDepositSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your deposit request has been submitted and is pending admin'**
  String get submitDepositSuccessMessage;
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
      <String>['ar', 'en'].contains(locale.languageCode);

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
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
