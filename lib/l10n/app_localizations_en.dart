// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Novaxmine';

  @override
  String get signIn => 'Sign In';

  @override
  String loginMsg(String appName) {
    return 'to your $appName account';
  }

  @override
  String get pleaseEnterTransactionHash => 'Please enter the transaction hash';

  @override
  String get pleaseEnterAmount => 'Please enter the amount';

  @override
  String get amountMustBeNumeric => 'Amount must be numeric';

  @override
  String get walletAddress => 'Wallet Address:';

  @override
  String get withdrawAddress => 'Withdraw Address:';

  @override
  String get depositWith => 'Deposit with';

  @override
  String get depositInstructions => 'Deposit Instructions';

  @override
  String get youHaveSelected => 'You have selected';

  @override
  String coinSelection(Object coinTitle) {
    return '$coinTitle';
  }

  @override
  String coinSubtitleTemplate(Object coinSubtitle) {
    return ' ($coinSubtitle).';
  }

  @override
  String get amountMustBeGreaterThanZero => 'Amount must be greater than 0';

  @override
  String get sendAmountMsg =>
      'Please send the desired amount to the wallet address below, then click \"I Have Transferred\".';

  @override
  String get doubleCheckMsg =>
      'Make sure to double-check the address and network before sending. Transactions cannot be reversed.';

  @override
  String get iHaveTransferred => 'I Have Transferred';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get confirmYourDeposit => 'Confirm Your Deposit';

  @override
  String get selectedNetwork => 'Selected Network';

  @override
  String get transactionIdHash => 'Transaction ID / Hash';

  @override
  String get enterTransactionHash => 'Enter your transaction hash';

  @override
  String get amountTransferred => 'Amount Transferred';

  @override
  String get enterTransferredAmount => 'Enter transferred amount';

  @override
  String get enterSameNetworkAmount =>
      'Enter the amount in the same coin / network you transferred.';

  @override
  String get submitForReview => 'Submit For Review';

  @override
  String get walletInfoMissing => 'Wallet information missing';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signUpMSG =>
      'Start mining and achieve the highest level of Hashrate.';

  @override
  String get skip => 'Skip';

  @override
  String get hashRate => 'Hashrate';

  @override
  String get currency => 'Currency';

  @override
  String get walletType => 'Wallet Type';

  @override
  String get totalReturned => 'Total Returned';

  @override
  String get refCommission => 'Total Ref. Commission';

  @override
  String get usernameOrEmail => 'Username or Email';

  @override
  String get usernameOrEmailHint => 'Enter your username or email';

  @override
  String get withdrawInformation => 'Withdraw Information';

  @override
  String get withdrawLimit => 'Withdraw Limit';

  @override
  String get withdrawConfirm => 'Withdraw Confirm';

  @override
  String get lockBadges => 'Lock Badges';

  @override
  String get unlockBadges => 'Unlock Badges';

  @override
  String get noBadgesUnlocked => 'You have not unlocked any badges yet';

  @override
  String get discountOnMaintenanceAmount => 'Maintenance Discount';

  @override
  String get discountOnPlanPrice => 'Plan Purchase Discount';

  @override
  String get increaseEarningBoost => 'Increase Earning Boost';

  @override
  String get enhanceReferralBonus => 'Enhance Referral Bonus';

  @override
  String get deposit => 'Deposit';

  @override
  String get createDepositScreenAppBarText => 'Deposit via Crypto Coins';

  @override
  String get depositInfo => 'Deposit Info';

  @override
  String get transactions => 'Transactions';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get depositHistory => 'Deposit History';

  @override
  String get depositCharge => 'Deposit Charge';

  @override
  String get kycRejectedMsg => 'KYC document rejected';

  @override
  String get kycUnderReviewMsg => 'Your KYC data is under review';

  @override
  String get exitTitle => 'Do you want to exit\nthe app?';

  @override
  String get no => 'No';

  @override
  String get ticketDetails => 'Ticket Details';

  @override
  String get ticket => 'Ticket';

  @override
  String get attachments => 'Attachments';

  @override
  String get message => 'Message';

  @override
  String get replyTicket => 'Ticket Details';

  @override
  String get subject => 'Subject';

  @override
  String get enterYourSubject => 'Enter your subject';

  @override
  String get priority => 'Priority';

  @override
  String get upload => 'Upload';

  @override
  String get enterFile => 'Enter file';

  @override
  String get you => 'You';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get admin => 'Admin';

  @override
  String get supportedFileHint =>
      'Supported file type:.jpg, .jpeg, .png, .pdf, .doc, .docx';

  @override
  String get repliedSuccessfully => 'Replied successfully';

  @override
  String get fileNotFound => 'file Not Found';

  @override
  String get customerReply => 'Customer Reply';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully';

  @override
  String get yes => 'Yes';

  @override
  String get yourReply => 'Your Reply';

  @override
  String get reply => 'Reply';

  @override
  String get noFileChosen => 'No file chosen';

  @override
  String get high => 'High';

  @override
  String get unableToAccessStorage => 'Unsupported file type';

  @override
  String get unsupportedFileType => 'Unable to access storage';

  @override
  String get postedOn => 'Posted on';

  @override
  String get answered => 'Answered';

  @override
  String get open => 'Open';

  @override
  String get replied => 'Replied';

  @override
  String get closed => 'Closed';

  @override
  String get close => 'Close';

  @override
  String get addNewTicket => 'Create Ticket';

  @override
  String get enterYourMessage => 'Enter your message';

  @override
  String get subjectRequired => 'Subject is required';

  @override
  String get messageRequired => 'Message is required';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get replyTicketEmptyMsg => 'Reply ticket can\'t be empty';

  @override
  String get ticketCreateSuccessfully => 'Ticket created successfully';

  @override
  String get cancelTicketMessage => 'Are you sure you want to close the ticket';

  @override
  String get noTicketFound => 'No Ticket Found';

  @override
  String get noMSgFound => 'No Message Found';

  @override
  String get supportTicket => 'Support Ticket';

  @override
  String get in_ => 'in';

  @override
  String get viewAll => 'View All';

  @override
  String get referralCode => 'Referral code (optional)';

  @override
  String get enterReferralCode => 'Enter referral code';

  @override
  String get details => 'Details';

  @override
  String get confirm => 'Confirm';

  @override
  String get setupKey => 'Setup Key';

  @override
  String get faq => 'FAQ';

  @override
  String get buyMinningPlan => 'Buy mining plan';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get searchCountry => 'Search Country';

  @override
  String get language => 'Language';

  @override
  String get enter => 'Enter';

  @override
  String get noWithdrawFound => 'No withdraw found';

  @override
  String get createNewPassword => 'Create new password';

  @override
  String get makeWithdraw => 'Make withdraw';

  @override
  String get attachment => 'Attachment';

  @override
  String get or => 'OR';

  @override
  String get payableAmount => 'Payable Amount';

  @override
  String get finalAmount => 'Final Amount';

  @override
  String get selectPaymentMethod => 'Select PaymentMethod';

  @override
  String get createPasswordSubText =>
      'To secure your account pls provide a strong password';

  @override
  String get fileDownloadedSuccess => 'File downloaded successfully';

  @override
  String get downloading => 'Downloading';

  @override
  String get addWithdraw => 'Add Withdraw';

  @override
  String get receivable => 'Receivable';

  @override
  String get authorizationMethod => 'Authorization Method';

  @override
  String get kyc => 'KYC';

  @override
  String get kycVerification => 'KYC Verification';

  @override
  String get please => 'Please';

  @override
  String get noDataToShow => 'Sorry! there are no data to show';

  @override
  String get selectAuthModeMsg => 'Please select an authorization mode';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String get download => 'Download';

  @override
  String get disable2Fa => 'Disable 2FA Security';

  @override
  String get copiedToClipBoard => 'Copied to your clipboard!';

  @override
  String get selectACountry => 'Select a Country';

  @override
  String get isRequired => 'is required';

  @override
  String get retry => 'Retry';

  @override
  String get chooseFile => 'Choose File';

  @override
  String get kycAlreadyVerifiedMsg => 'You are already verified';

  @override
  String get kycVerificationRequired => 'KYC Verification Required';

  @override
  String get kycRejectSubtitleMsg =>
      'Your KYC document has been rejected. Please resubmit the document for further review.';

  @override
  String get kycVerificationMsg =>
      'Please submit the required KYC information to verify yourself. Otherwise, you couldn\'t make any withdrawal request.';

  @override
  String get kycPendingMsg =>
      'Thank you for submitting your KYC documents. Our team is currently reviewing the information.';

  @override
  String get passwordResetEmailSentTo => 'Password reset email sent to';

  @override
  String get yourEmail => 'your email';

  @override
  String get plsSelectOne => 'Please Select One';

  @override
  String get signInWithGoogle => 'Sign In with Google';

  @override
  String get signInWithFacebook => 'Sign In with Facebook';

  @override
  String get signInWithLinkedin => 'Sign In with Linkedin';

  @override
  String get loginTitle => 'Login To Your Account';

  @override
  String get phoneNo => 'Phone No.';

  @override
  String get otpFieldEmptyMsg => 'Otp field can\'t be empty';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get usernameHint => 'Enter username';

  @override
  String get passwordHint => 'Enter password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email or username to reset your password';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get createNew => 'Create New';

  @override
  String get login => 'Login';

  @override
  String get loginNow => 'Login Now';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailAddressHint => 'Enter email address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Enter confirm password';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get signUpTitle => 'Create Your Account';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get selectGateway => 'Select Gateway';

  @override
  String get selectAGateway => 'Please select a gateway';

  @override
  String get selectOne => 'Select One';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get pleaseEnterYourAmount => 'Please enter your amount';

  @override
  String get plsEnterAnAmount => 'Please enter an amount';

  @override
  String get depositLimit => 'Deposit Limit';

  @override
  String get useQRCODETips =>
      'Use the QR code or setup key on your Google Authenticator app to add your account.';

  @override
  String get useQRCODETips2 =>
      'Google Authenticator is a multifactor app for mobile devices. It generates timed codes used during the 2-step verification process. To use Google Authenticator, install the Google Authenticator application on your mobile device.';

  @override
  String get addYourAccount => 'Add Your Account';

  @override
  String get enable2Fa => 'Enable 2FA Security';

  @override
  String get resetYourPassword => 'Reset Your Password';

  @override
  String get send => 'Send';

  @override
  String get passwordVerification => 'Password Verification';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get otpEmptyMsg => 'OTP field can\'t be empty';

  @override
  String get verifyPasswordSubText =>
      'A 6 digits verification code sent to your\nemail address';

  @override
  String get viaEmailVerify =>
      'We\'ve sent you six-digit verification code via email for email verification';

  @override
  String get smsVerificationMsg =>
      'We\'ve sent you an access code to your phone number for SMS verification';

  @override
  String get submit => 'Submit';

  @override
  String get twoFactorAuth => 'Two Factor Authentication';

  @override
  String get twoFactorMsg =>
      'Enter 6-digit code from your two factor authenticator APP.';

  @override
  String get badResponseMsg => 'Bad Response Format!';

  @override
  String get serverError => 'Server Error';

  @override
  String get unAuthorized => 'Unauthorized';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get orderNo => 'Order No.';

  @override
  String get orderAmount => 'Order Amount';

  @override
  String get time => 'Time';

  @override
  String get referralLink => 'Referral Link';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get plan => 'Mining Plan';

  @override
  String get planTitle => 'Plan';

  @override
  String get referrals => 'Referrals';

  @override
  String get wallet => 'Wallet';

  @override
  String get newMine => 'New Mine';

  @override
  String get miningTracks => 'Mining Tracks';

  @override
  String get profile => 'Profile';

  @override
  String get transaction => 'Transactions';

  @override
  String get latestTransaction => 'Latest Transactions';

  @override
  String get minerTracksInfo => 'Mining Tracks Info';

  @override
  String get balance => 'Balance';

  @override
  String get depositWallet => 'Deposit Wallet';

  @override
  String get earningWallet => 'Earning Wallet';

  @override
  String get referralBonus => 'Referral Bonus';

  @override
  String get miningDetails => 'Mining Details';

  @override
  String get miningTrackDetails => 'Mining Tracks Details';

  @override
  String get orderedAt => 'Ordered At';

  @override
  String get date => 'Date';

  @override
  String get amount => 'Amount';

  @override
  String get miner => 'Miner';

  @override
  String get speed => 'Speed';

  @override
  String get returnDay => 'Return / Day';

  @override
  String get day => 'Day';

  @override
  String get totalDays => 'Total Days';

  @override
  String get remainingDays => 'Remaining Days';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get dLogout => 'Logout';

  @override
  String get approved => 'Approved';

  @override
  String get pending => 'Pending';

  @override
  String get rejected => 'Rejected';

  @override
  String get charge => 'Charge';

  @override
  String get payable => 'Payable';

  @override
  String get conversionRate => 'Conversion Rate';

  @override
  String get rate => 'Rate';

  @override
  String get youWillGet => 'You will get';

  @override
  String get trx => 'TRX No';

  @override
  String get trxNo => 'TRX';

  @override
  String get trxID => 'TRX Id';

  @override
  String get postBalance => 'Post Balance';

  @override
  String get gateway => 'Gateway';

  @override
  String get initiated => 'initiated';

  @override
  String get withdrawPreview => 'Withdraw Preview';

  @override
  String get withdrawHistory => 'Withdraw History';

  @override
  String get withdrawNow => 'Withdraw Now';

  @override
  String get withdrawMoney => 'Withdraw Money';

  @override
  String get withdrawDetails => 'Withdraw Details';

  @override
  String get withdrawRequestSuccess =>
      'Withdrawal request successfully submitted';

  @override
  String get startMining => 'Start Mining';

  @override
  String get achievements => 'Achievements';

  @override
  String get planPrice => 'Plan Price';

  @override
  String get fromBalance => 'From Balance';

  @override
  String get fromProfitWallet => 'From Profit Wallet';

  @override
  String get directPayment => 'Direct Payment';

  @override
  String get referralBonusLogs => 'Referral Bonus Logs';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get level => 'Level';

  @override
  String get joinOn => 'Join On';

  @override
  String get yourReferees => 'Your Referees';

  @override
  String get changeYourPassword => 'Change Your Password';

  @override
  String get welcome => 'Welcome to MineLab';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get currentPasswordHint => 'Enter current password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get changePassword => 'Change Password';

  @override
  String get requestSuccess => 'Request Success';

  @override
  String get currentPassEmptyMsg => 'Current password field is empty';

  @override
  String get newPassEmptyMsg => 'New password field is empty';

  @override
  String get passNoMatchMsg => 'Password not match';

  @override
  String get createNewPassDescription =>
      'Your new password must be different\nfrom previous used password';

  @override
  String get logoutSuccessMsg => 'Logout Successfully';

  @override
  String get notification => 'Notification';

  @override
  String get confirmEmailAddress => 'Confirm Your E-mail Address';

  @override
  String get newPlanReady => 'New plan is ready for you';

  @override
  String get planUpdateRequest => 'Plan update request';

  @override
  String get resetPassword => 'Reset Your Password';

  @override
  String get privacyPolicy => 'Privacy & Policies';

  @override
  String get amountError => 'Amount must be less than or equal to';

  @override
  String get toEarningWallet => 'to Earning Wallet';

  @override
  String get totalEarning => 'Total Earning';

  @override
  String get totalReceived => 'Total Received';

  @override
  String get transfer => 'Transfer';

  @override
  String get wallets => 'Wallets';

  @override
  String get coinWallets => 'Coin Wallets';

  @override
  String get minerWallets => 'Miner Wallets';

  @override
  String get updateWallet => 'Update Wallet';

  @override
  String get walletAddressEmptyMsg => 'Wallet address can\'t be empty';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get country => 'Country';

  @override
  String get address => 'Address';

  @override
  String get state => 'State';

  @override
  String get zipCode => 'Zip Code';

  @override
  String get city => 'City';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get firstName => 'First Name';

  @override
  String get enterFirstName => 'Enter first Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get enterLastName => 'Enter last Name';

  @override
  String get userName => 'Username';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get enterYourAddress => 'Enter your address';

  @override
  String get enterYourState => 'Enter your state';

  @override
  String get enterYourZipcode => 'Enter your zip code';

  @override
  String get enterYourCity => 'Enter your city';

  @override
  String get minLimit => 'Min Limit';

  @override
  String get maxLimit => 'Max Limit';

  @override
  String get withdrawMethod => 'Withdraw Method';

  @override
  String get profileComplete => 'Profile Complete';

  @override
  String get success => 'success';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get resendCodeFail => 'Resend code fail';

  @override
  String get successfullyCodeResend => 'Resend code successfully';

  @override
  String get emailVerify => 'Email Verification';

  @override
  String get smsVerify => 'Sms Verification';

  @override
  String get kMatchPassError => 'Password doesn\'t match';

  @override
  String get kFirstNameNullError => 'Please enter first name';

  @override
  String get kLastNameNullError => 'Please enter last name';

  @override
  String get kShortUserNameError => 'Username must be 6 character';

  @override
  String get kUserNameNullError => 'Please enter username';

  @override
  String get kPhoneNumberNullError => 'Please enter your phone number';

  @override
  String get currentPassNullError => 'Current pass null ';

  @override
  String get verify => 'Verify';

  @override
  String get passVerification => 'Password Verification';

  @override
  String get didNotReceiveCode => 'Didn\'t receive the code?';

  @override
  String get resend => 'Resend';

  @override
  String get plsFillProperly => 'Please fill up all the cells properly';

  @override
  String get plsEnter => 'Please Enter ';

  @override
  String get emailOrUsername => 'Email or user name';

  @override
  String get loginFailedTryAgain => 'User login failed , pls try again';

  @override
  String get error => 'error';

  @override
  String get requestFail => 'Request Failed';

  @override
  String get type => 'Type';

  @override
  String get coinCode => 'Coin Code';

  @override
  String get remark => 'Remark';

  @override
  String get home => 'Home';

  @override
  String get searchByTransactions => 'Search by transactions';

  @override
  String get transactionNo => 'Transaction No';

  @override
  String get user => 'User';

  @override
  String get percent => 'Percent';

  @override
  String get myReferrals => 'My Referrals';

  @override
  String get referralLinkCopied => 'Referral link copied';

  @override
  String get purchasedDate => 'Purchased Date';

  @override
  String get unPaid => 'Unpaid';

  @override
  String get status => 'Status';

  @override
  String get payNow => 'Pay Now';

  @override
  String get menu => 'Menu';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get noData => 'No Data Found';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteYourAccount => 'Delete your Account';

  @override
  String get deleteBottomSheetSubtitle =>
      'You will lose all of your data by deleting your account. This action cannot be undone.';

  @override
  String get pleaseEnterUsername => 'Please enter username';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get pleaseEnterPassword => 'Please enter password';

  @override
  String get enterValidEmail => 'Enter valid email';

  @override
  String get enterPhoneNo => 'Enter phone number';

  @override
  String get iAgree => 'I agree with';

  @override
  String get trxType => 'Trx type';

  @override
  String get any => 'Any';

  @override
  String get enterTransactionNo => 'Enter transaction no.';

  @override
  String get days => 'Days';

  @override
  String get months => 'Months';

  @override
  String get years => 'Years';

  @override
  String get sms => 'SMS';

  @override
  String get verificationSuccess => 'Verification Success';

  @override
  String get verificationFailed => 'Verification Failed';

  @override
  String get emailVerificationSuccess => 'Email Verification Success';

  @override
  String get emailVerificationFailed => 'Email Verification Failed';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get enterYourPassword_ => 'Enter your password';

  @override
  String get invalidPassMsg =>
      'Password must be contain 1 special character and number';

  @override
  String get hasUpperLetter => 'Has uppercase letter';

  @override
  String get hasLowerLetter => 'Has lowercase letter';

  @override
  String get hasDigit => 'Has digit';

  @override
  String get hasSpecialChar => 'Has special character';

  @override
  String get minSixChar => 'Min of 6 characters';

  @override
  String get myReferredUsers => 'My Referred Users';

  @override
  String get miningHistory => 'Mining History';

  @override
  String get orderHistory => 'Order History';

  @override
  String get running => 'Running';

  @override
  String get maintenanceCost => 'Maintenance Cost';

  @override
  String get submitDepositSuccessMessage =>
      'Your deposit request has been submitted and is pending admin';

  @override
  String get faqQuestion1 => 'What is Cryptocurrency?';

  @override
  String get faqAnswer1 =>
      'Cryptocurrency is decentralized digital money, based on blockchain technology. You may be familiar with the most popular versions, Bitcoin and Ethereum, but there are more than 5,000 different cryptocurrencies in circulation.';

  @override
  String get faqQuestion2 => 'What is crypto currency mining?';

  @override
  String get faqAnswer2 =>
      'In a nutshell, cryptocurrency mining is a term that refers to the process of gathering cryptocurrency as a reward for work that you complete.';

  @override
  String get faqQuestion3 => 'How does cryptocurrency work?';

  @override
  String get faqAnswer3 =>
      'Cryptocurrencies run on a distributed public ledger called blockchain, a record of all transactions updated and held by currency holders.';

  @override
  String get faqQuestion4 => 'Is cryptocurrency safe?';

  @override
  String get faqAnswer4 =>
      'Cryptocurrencies are usually built using blockchain technology. Blockchain describes the way transactions are recorded into blocks and time stamped. It\'s fairly complex, but the result is a digital ledger that is difficult to tamper with.';

  @override
  String get faqQuestion5 => 'How can I buy cryptocurrency?';

  @override
  String get faqAnswer5 =>
      'You can buy cryptocurrency through exchanges, brokers, or peer-to-peer platforms. Make sure to use reputable platforms and secure your digital wallet.';
}
