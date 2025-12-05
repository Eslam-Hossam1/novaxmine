// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Novaxmine ';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String loginMsg(String appName) {
    return 'إلى حساب $appName';
  }

  @override
  String get pleaseEnterTransactionHash => 'من فضلك أدخل هاش المعاملة';

  @override
  String get pleaseEnterAmount => 'من فضلك أدخل المبلغ';

  @override
  String get amountMustBeNumeric => 'يجب أن يكون المبلغ رقمًا';

  @override
  String get walletAddress => 'عنوان المحفظة:';

  @override
  String get withdrawAddress => 'عنوان السحب:';

  @override
  String get depositWith => 'الإيداع باستخدام';

  @override
  String get depositInstructions => 'تعليمات الإيداع';

  @override
  String get youHaveSelected => 'لقد قمت باختيار';

  @override
  String coinSelection(Object coinTitle) {
    return '$coinTitle';
  }

  @override
  String coinSubtitleTemplate(Object coinSubtitle) {
    return ' ($coinSubtitle).';
  }

  @override
  String get amountMustBeGreaterThanZero => 'يجب أن يكون المبلغ أكبر من 0';

  @override
  String get sendAmountMsg =>
      'يرجى إرسال المبلغ المطلوب إلى عنوان المحفظة أدناه، ثم الضغط على \"لقد قمت بالتحويل\".';

  @override
  String get doubleCheckMsg =>
      'تأكد من مطابقة العنوان والشبكة قبل الإرسال. المعاملات لا يمكن عكسها.';

  @override
  String get iHaveTransferred => 'لقد قمت بالتحويل';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم النسخ';

  @override
  String get confirmYourDeposit => 'تأكيد الإيداع';

  @override
  String get selectedNetwork => 'الشبكة المختارة';

  @override
  String get transactionIdHash => 'معرّف / هاش المعاملة';

  @override
  String get enterTransactionHash => 'أدخل هاش المعاملة';

  @override
  String get amountTransferred => 'المبلغ المحول';

  @override
  String get enterTransferredAmount => 'أدخل المبلغ المحول';

  @override
  String get enterSameNetworkAmount =>
      'أدخل المبلغ بنفس العملة / الشبكة التي قمت بالتحويل من خلالها.';

  @override
  String get submitForReview => 'إرسال للمراجعة';

  @override
  String get walletInfoMissing => 'معلومات المحفظة مفقودة';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signUpMSG => 'ابدأ التعدين وحقق أعلى مستوى من معدل الهاش.';

  @override
  String get skip => 'تخطي';

  @override
  String get hashRate => 'معدل الهاش';

  @override
  String get currency => 'العملة';

  @override
  String get walletType => 'نوع المحفظة';

  @override
  String get totalReturned => 'إجمالي العائد';

  @override
  String get refCommission => 'إجمالي عمولة الإحالة';

  @override
  String get usernameOrEmail => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get usernameOrEmailHint => 'أدخل اسم المستخدم أو البريد الإلكتروني';

  @override
  String get withdrawInformation => 'معلومات السحب';

  @override
  String get withdrawLimit => 'حد السحب';

  @override
  String get withdrawConfirm => 'تأكيد السحب';

  @override
  String get lockBadges => 'قفل الشارات';

  @override
  String get unlockBadges => 'فتح الشارات';

  @override
  String get noBadgesUnlocked => 'لم تقم بفتح أي شارات بعد';

  @override
  String get discountOnMaintenanceAmount => 'خصم الصيانة';

  @override
  String get discountOnPlanPrice => 'خصم شراء الخطة';

  @override
  String get increaseEarningBoost => 'زيادة تعزيز الأرباح';

  @override
  String get enhanceReferralBonus => 'تعزيز مكافأة الإحالة';

  @override
  String get deposit => 'إيداع';

  @override
  String get createDepositScreenAppBarText => 'الإيداع عبر العملات المشفرة';

  @override
  String get depositInfo => 'معلومات الإيداع';

  @override
  String get transactions => 'المعاملات';

  @override
  String get recentTransactions => 'أحدث المعاملات';

  @override
  String get depositHistory => 'سجل الإيداع';

  @override
  String get depositCharge => 'رسوم الإيداع';

  @override
  String get kycRejectedMsg => 'تم رفض مستندات KYC';

  @override
  String get kycUnderReviewMsg => 'بيانات KYC قيد المراجعة';

  @override
  String get exitTitle => 'هل تريد الخروج\nمن التطبيق؟';

  @override
  String get no => 'لا';

  @override
  String get ticketDetails => 'تفاصيل التذكرة';

  @override
  String get ticket => 'تذكرة';

  @override
  String get attachments => 'مرفقات';

  @override
  String get message => 'رسالة';

  @override
  String get replyTicket => 'تفاصيل التذكرة';

  @override
  String get subject => 'الموضوع';

  @override
  String get enterYourSubject => 'أدخل الموضوع';

  @override
  String get priority => 'الأولوية';

  @override
  String get upload => 'رفع';

  @override
  String get enterFile => 'أدخل ملف';

  @override
  String get you => 'أنت';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get admin => 'المشرف';

  @override
  String get supportedFileHint =>
      'أنواع الملفات المدعومة: .jpg, .jpeg, .png, .pdf, .doc, .docx';

  @override
  String get repliedSuccessfully => 'تم الرد بنجاح';

  @override
  String get fileNotFound => 'الملف غير موجود';

  @override
  String get customerReply => 'رد العميل';

  @override
  String get accountDeletedSuccessfully => 'تم حذف الحساب بنجاح';

  @override
  String get yes => 'نعم';

  @override
  String get yourReply => 'ردك';

  @override
  String get reply => 'رد';

  @override
  String get noFileChosen => 'لم يتم اختيار ملف';

  @override
  String get high => 'عالية';

  @override
  String get unableToAccessStorage => 'نوع الملف غير مدعوم';

  @override
  String get unsupportedFileType => 'تعذر الوصول للتخزين';

  @override
  String get postedOn => 'تم النشر في';

  @override
  String get answered => 'تم الرد';

  @override
  String get open => 'مفتوحة';

  @override
  String get replied => 'تم الرد';

  @override
  String get closed => 'مغلقة';

  @override
  String get close => 'إغلاق';

  @override
  String get addNewTicket => 'إنشاء تذكرة';

  @override
  String get enterYourMessage => 'أدخل رسالتك';

  @override
  String get subjectRequired => 'الموضوع مطلوب';

  @override
  String get messageRequired => 'الرسالة مطلوبة';

  @override
  String get medium => 'متوسطة';

  @override
  String get low => 'منخفضة';

  @override
  String get replyTicketEmptyMsg => 'لا يمكن ترك الرد فارغًا';

  @override
  String get ticketCreateSuccessfully => 'تم إنشاء التذكرة بنجاح';

  @override
  String get cancelTicketMessage => 'هل أنت متأكد أنك تريد إغلاق التذكرة';

  @override
  String get noTicketFound => 'لا توجد تذاكر';

  @override
  String get noMSgFound => 'لا توجد رسائل';

  @override
  String get supportTicket => 'تذاكر الدعم';

  @override
  String get in_ => 'في';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get referralCode => 'كود الإحالة (اختياري)';

  @override
  String get enterReferralCode => 'أدخل كود الإحالة';

  @override
  String get details => 'التفاصيل';

  @override
  String get confirm => 'تأكيد';

  @override
  String get setupKey => 'مفتاح الإعداد';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get buyMinningPlan => 'شراء خطة تعدين';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get searchCountry => 'ابحث عن دولة';

  @override
  String get language => 'اللغة';

  @override
  String get enter => 'إدخال';

  @override
  String get noWithdrawFound => 'لا توجد عمليات سحب';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get makeWithdraw => 'إجراء سحب';

  @override
  String get attachment => 'مرفق';

  @override
  String get or => 'أو';

  @override
  String get payableAmount => 'المبلغ المستحق';

  @override
  String get finalAmount => 'المبلغ النهائي';

  @override
  String get selectPaymentMethod => 'اختر طريقة الدفع';

  @override
  String get createPasswordSubText => 'لتأمين حسابك، يرجى إدخال كلمة مرور قوية';

  @override
  String get fileDownloadedSuccess => 'تم تنزيل الملف بنجاح';

  @override
  String get downloading => 'جارٍ التنزيل';

  @override
  String get addWithdraw => 'إضافة سحب';

  @override
  String get receivable => 'المستلم';

  @override
  String get authorizationMethod => 'طريقة التفويض';

  @override
  String get kyc => 'KYC';

  @override
  String get kycVerification => 'التحقق من KYC';

  @override
  String get please => 'من فضلك';

  @override
  String get noDataToShow => 'عذرًا! لا توجد بيانات للعرض';

  @override
  String get selectAuthModeMsg => 'يرجى اختيار طريقة التفويض';

  @override
  String get invalidAmount => 'مبلغ غير صالح';

  @override
  String get download => 'تنزيل';

  @override
  String get disable2Fa => 'تعطيل حماية 2FA';

  @override
  String get copiedToClipBoard => 'تم النسخ إلى الحافظة!';

  @override
  String get selectACountry => 'اختر دولة';

  @override
  String get isRequired => 'مطلوب';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get chooseFile => 'اختر ملفًا';

  @override
  String get kycAlreadyVerifiedMsg => 'تم التحقق مسبقًا';

  @override
  String get kycVerificationRequired => 'مطلوب التحقق من KYC';

  @override
  String get kycRejectSubtitleMsg =>
      'تم رفض مستندات KYC. يرجى إعادة رفع المستند للمراجعة مرة أخرى.';

  @override
  String get kycVerificationMsg =>
      'يرجى تقديم بيانات KYC المطلوبة للتحقق. بدون ذلك لن تتمكن من تقديم طلب سحب.';

  @override
  String get kycPendingMsg =>
      'شكرًا لتقديم مستندات KYC. فريقنا يراجع البيانات حاليًا.';

  @override
  String get passwordResetEmailSentTo =>
      'تم إرسال رابط إعادة تعيين كلمة المرور إلى';

  @override
  String get yourEmail => 'بريدك الإلكتروني';

  @override
  String get plsSelectOne => 'يرجى اختيار واحد';

  @override
  String get signInWithGoogle => 'تسجيل الدخول عبر Google';

  @override
  String get signInWithFacebook => 'تسجيل الدخول عبر Facebook';

  @override
  String get signInWithLinkedin => 'تسجيل الدخول عبر LinkedIn';

  @override
  String get loginTitle => 'تسجيل الدخول إلى حسابك';

  @override
  String get phoneNo => 'رقم الهاتف';

  @override
  String get otpFieldEmptyMsg => 'لا يمكن ترك خانة OTP فارغة';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get usernameHint => 'أدخل اسم المستخدم';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني أو اسم المستخدم لإعادة تعيين كلمة المرور';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get createNew => 'إنشاء جديد';

  @override
  String get login => 'دخول';

  @override
  String get loginNow => 'سجّل الدخول الآن';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get emailAddressHint => 'أدخل البريد الإلكتروني';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get signUpTitle => 'أنشئ حسابك';

  @override
  String get confirmYourPassword => 'أكد كلمة المرور';

  @override
  String get selectGateway => 'اختر بوابة الدفع';

  @override
  String get selectAGateway => 'يرجى اختيار بوابة';

  @override
  String get selectOne => 'اختر';

  @override
  String get enterAmount => 'أدخل المبلغ';

  @override
  String get pleaseEnterYourAmount => 'يرجى إدخال المبلغ';

  @override
  String get plsEnterAnAmount => 'يرجى إدخال مبلغ';

  @override
  String get depositLimit => 'حد الإيداع';

  @override
  String get useQRCODETips =>
      'استخدم رمز QR أو مفتاح الإعداد في تطبيق Google Authenticator لإضافة حسابك.';

  @override
  String get useQRCODETips2 =>
      'Google Authenticator تطبيق مصادقة متعددة العوامل للأجهزة المحمولة، يولد رموزًا زمنية تُستخدم أثناء التحقق بخطوتين. لاستخدامه قم بتثبيت التطبيق على جهازك.';

  @override
  String get addYourAccount => 'أضف حسابك';

  @override
  String get enable2Fa => 'تفعيل حماية 2FA';

  @override
  String get resetYourPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get send => 'إرسال';

  @override
  String get passwordVerification => 'التحقق من كلمة المرور';

  @override
  String get enterOtp => 'أدخل OTP';

  @override
  String get otpEmptyMsg => 'لا يمكن ترك خانة OTP فارغة';

  @override
  String get verifyPasswordSubText =>
      'تم إرسال كود تحقق مكوّن من 6 أرقام إلى\nبريدك الإلكتروني';

  @override
  String get viaEmailVerify =>
      'أرسلنا كود تحقق من 6 أرقام عبر البريد الإلكتروني للتحقق';

  @override
  String get smsVerificationMsg =>
      'أرسلنا كود وصول إلى رقم هاتفك للتحقق عبر SMS';

  @override
  String get submit => 'إرسال';

  @override
  String get twoFactorAuth => 'المصادقة الثنائية';

  @override
  String get twoFactorMsg => 'أدخل كود 6 أرقام من تطبيق المصادقة الثنائية.';

  @override
  String get badResponseMsg => 'تنسيق استجابة غير صحيح!';

  @override
  String get serverError => 'خطأ في الخادم';

  @override
  String get unAuthorized => 'غير مصرح';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get orderNo => 'رقم الطلب';

  @override
  String get orderAmount => 'قيمة الطلب';

  @override
  String get time => 'الوقت';

  @override
  String get referralLink => 'رابط الإحالة';

  @override
  String get withdraw => 'سحب';

  @override
  String get plan => 'خطة التعدين';

  @override
  String get planTitle => 'الخطة';

  @override
  String get referrals => 'الإحالات';

  @override
  String get wallet => 'المحفظة';

  @override
  String get newMine => 'تعدين جديد';

  @override
  String get miningTracks => 'مسارات التعدين';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get transaction => 'المعاملات';

  @override
  String get latestTransaction => 'أحدث المعاملات';

  @override
  String get minerTracksInfo => 'معلومات مسارات التعدين';

  @override
  String get balance => 'الرصيد';

  @override
  String get depositWallet => 'محفظة الإيداع';

  @override
  String get earningWallet => 'محفظة الأرباح';

  @override
  String get referralBonus => 'مكافأة الإحالة';

  @override
  String get miningDetails => 'تفاصيل التعدين';

  @override
  String get miningTrackDetails => 'تفاصيل مسارات التعدين';

  @override
  String get orderedAt => 'تاريخ الطلب';

  @override
  String get date => 'التاريخ';

  @override
  String get amount => 'المبلغ';

  @override
  String get miner => 'المُعدّن';

  @override
  String get speed => 'السرعة';

  @override
  String get returnDay => 'العائد / يوم';

  @override
  String get day => 'يوم';

  @override
  String get totalDays => 'إجمالي الأيام';

  @override
  String get remainingDays => 'الأيام المتبقية';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get dLogout => 'تسجيل الخروج';

  @override
  String get approved => 'مقبول';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get rejected => 'مرفوض';

  @override
  String get charge => 'رسوم';

  @override
  String get payable => 'مستحق';

  @override
  String get conversionRate => 'سعر التحويل';

  @override
  String get rate => 'السعر';

  @override
  String get youWillGet => 'ستحصل على';

  @override
  String get trx => 'رقم TRX';

  @override
  String get trxNo => 'TRX';

  @override
  String get trxID => 'معرف TRX';

  @override
  String get postBalance => 'الرصيد بعد';

  @override
  String get gateway => 'البوابة';

  @override
  String get initiated => 'تم البدء';

  @override
  String get withdrawPreview => 'معاينة السحب';

  @override
  String get withdrawHistory => 'سجل السحب';

  @override
  String get withdrawNow => 'اسحب الآن';

  @override
  String get withdrawMoney => 'سحب الأموال';

  @override
  String get withdrawDetails => 'تفاصيل السحب';

  @override
  String get withdrawRequestSuccess => 'تم إرسال طلب السحب بنجاح';

  @override
  String get startMining => 'ابدأ التعدين';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get planPrice => 'سعر الخطة';

  @override
  String get fromBalance => 'من الرصيد';

  @override
  String get fromProfitWallet => 'من محفظة الأرباح';

  @override
  String get directPayment => 'دفع مباشر';

  @override
  String get referralBonusLogs => 'سجل مكافآت الإحالة';

  @override
  String get inviteFriends => 'ادعُ أصدقاءك';

  @override
  String get level => 'المستوى';

  @override
  String get joinOn => 'تاريخ الانضمام';

  @override
  String get yourReferees => 'المحالون';

  @override
  String get changeYourPassword => 'تغيير كلمة المرور';

  @override
  String get welcome => 'مرحبًا بك في MineLab';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get currentPasswordHint => 'أدخل كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get requestSuccess => 'تم بنجاح';

  @override
  String get currentPassEmptyMsg => 'حقل كلمة المرور الحالية فارغ';

  @override
  String get newPassEmptyMsg => 'حقل كلمة المرور الجديدة فارغ';

  @override
  String get passNoMatchMsg => 'كلمتا المرور غير متطابقتين';

  @override
  String get createNewPassDescription =>
      'يجب أن تكون كلمة المرور الجديدة مختلفة\nعن كلمات المرور المستخدمة سابقًا';

  @override
  String get logoutSuccessMsg => 'تم تسجيل الخروج بنجاح';

  @override
  String get notification => 'الإشعارات';

  @override
  String get confirmEmailAddress => 'تأكيد البريد الإلكتروني';

  @override
  String get newPlanReady => 'خطة جديدة جاهزة لك';

  @override
  String get planUpdateRequest => 'طلب تحديث الخطة';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get privacyPolicy => 'الخصوصية والسياسات';

  @override
  String get amountError => 'يجب أن يكون المبلغ أقل من أو يساوي';

  @override
  String get toEarningWallet => 'إلى محفظة الأرباح';

  @override
  String get totalEarning => 'إجمالي الأرباح';

  @override
  String get totalReceived => 'إجمالي المستلم';

  @override
  String get transfer => 'تحويل';

  @override
  String get wallets => 'المحافظ';

  @override
  String get coinWallets => 'محافظ العملات';

  @override
  String get minerWallets => 'محافظ المُعدّن';

  @override
  String get updateWallet => 'تحديث المحفظة';

  @override
  String get walletAddressEmptyMsg => 'عنوان المحفظة لا يمكن أن يكون فارغًا';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String get country => 'الدولة';

  @override
  String get address => 'العنوان';

  @override
  String get state => 'المحافظة/الولاية';

  @override
  String get zipCode => 'الرمز البريدي';

  @override
  String get city => 'المدينة';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get updateProfile => 'تحديث الملف الشخصي';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get enterFirstName => 'أدخل الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get enterLastName => 'أدخل اسم العائلة';

  @override
  String get userName => 'اسم المستخدم';

  @override
  String get mobileNumber => 'رقم الموبايل';

  @override
  String get enterYourAddress => 'أدخل عنوانك';

  @override
  String get enterYourState => 'أدخل محافظتك/ولايتك';

  @override
  String get enterYourZipcode => 'أدخل الرمز البريدي';

  @override
  String get enterYourCity => 'أدخل مدينتك';

  @override
  String get minLimit => 'الحد الأدنى';

  @override
  String get maxLimit => 'الحد الأقصى';

  @override
  String get withdrawMethod => 'طريقة السحب';

  @override
  String get profileComplete => 'اكتمال الملف الشخصي';

  @override
  String get success => 'نجاح';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get resendCodeFail => 'فشل إعادة الإرسال';

  @override
  String get successfullyCodeResend => 'تمت إعادة الإرسال بنجاح';

  @override
  String get emailVerify => 'التحقق من البريد الإلكتروني';

  @override
  String get smsVerify => 'التحقق عبر SMS';

  @override
  String get kMatchPassError => 'كلمة المرور غير متطابقة';

  @override
  String get kFirstNameNullError => 'يرجى إدخال الاسم الأول';

  @override
  String get kLastNameNullError => 'يرجى إدخال اسم العائلة';

  @override
  String get kShortUserNameError => 'اسم المستخدم يجب أن يكون 6 أحرف';

  @override
  String get kUserNameNullError => 'يرجى إدخال اسم المستخدم';

  @override
  String get kPhoneNumberNullError => 'يرجى إدخال رقم الهاتف';

  @override
  String get currentPassNullError => 'كلمة المرور الحالية فارغة ';

  @override
  String get verify => 'تحقق';

  @override
  String get passVerification => 'التحقق من كلمة المرور';

  @override
  String get didNotReceiveCode => 'لم يصلك الكود؟';

  @override
  String get resend => 'إعادة الإرسال';

  @override
  String get plsFillProperly => 'يرجى ملء جميع الخانات بشكل صحيح';

  @override
  String get plsEnter => 'يرجى إدخال ';

  @override
  String get emailOrUsername => 'البريد الإلكتروني أو اسم المستخدم';

  @override
  String get loginFailedTryAgain => 'فشل تسجيل الدخول، يرجى المحاولة مرة أخرى';

  @override
  String get error => 'خطأ';

  @override
  String get requestFail => 'فشل الطلب';

  @override
  String get type => 'النوع';

  @override
  String get coinCode => 'رمز العملة';

  @override
  String get remark => 'ملاحظة';

  @override
  String get home => 'الرئيسية';

  @override
  String get searchByTransactions => 'بحث بالمعاملات';

  @override
  String get transactionNo => 'رقم المعاملة';

  @override
  String get user => 'المستخدم';

  @override
  String get percent => 'النسبة';

  @override
  String get myReferrals => 'إحالاتي';

  @override
  String get referralLinkCopied => 'تم نسخ رابط الإحالة';

  @override
  String get purchasedDate => 'تاريخ الشراء';

  @override
  String get unPaid => 'غير مدفوع';

  @override
  String get status => 'الحالة';

  @override
  String get payNow => 'ادفع الآن';

  @override
  String get menu => 'القائمة';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cancel => 'إلغاء';

  @override
  String get deleteYourAccount => 'حذف حسابك';

  @override
  String get deleteBottomSheetSubtitle =>
      'ستفقد جميع بياناتك عند حذف الحساب. هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get pleaseEnterUsername => 'يرجى إدخال اسم المستخدم';

  @override
  String get enterUsername => 'أدخل اسم المستخدم';

  @override
  String get pleaseEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get enterValidEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get enterPhoneNo => 'أدخل رقم الهاتف';

  @override
  String get iAgree => 'أوافق على';

  @override
  String get trxType => 'نوع TRX';

  @override
  String get any => 'أي';

  @override
  String get enterTransactionNo => 'أدخل رقم المعاملة.';

  @override
  String get days => 'أيام';

  @override
  String get months => 'شهور';

  @override
  String get years => 'سنوات';

  @override
  String get sms => 'SMS';

  @override
  String get verificationSuccess => 'تم التحقق بنجاح';

  @override
  String get verificationFailed => 'فشل التحقق';

  @override
  String get emailVerificationSuccess => 'تم التحقق من البريد بنجاح';

  @override
  String get emailVerificationFailed => 'فشل التحقق من البريد';

  @override
  String get enterYourPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get enterYourPassword_ => 'أدخل كلمة المرور';

  @override
  String get invalidPassMsg =>
      'يجب أن تحتوي كلمة المرور على رقم ورمز خاص واحد على الأقل';

  @override
  String get hasUpperLetter => 'يحتوي على حرف كبير';

  @override
  String get hasLowerLetter => 'يحتوي على حرف صغير';

  @override
  String get hasDigit => 'يحتوي على رقم';

  @override
  String get hasSpecialChar => 'يحتوي على رمز خاص';

  @override
  String get minSixChar => '6 أحرف على الأقل';

  @override
  String get myReferredUsers => 'المستخدمون المُحالون';

  @override
  String get miningHistory => 'سجل التعدين';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String get running => 'قيد التشغيل';

  @override
  String get maintenanceCost => 'تكلفة الصيانة';

  @override
  String get submitDepositSuccessMessage =>
      'لقد تم تقديم طلب الإيداع الخاص بك وهو قيد الانتظار من قبل الادارة';
}
