class UrlContainer {
  // static const String baseUrl = "https://script.viserlab.com/minelab/demo/"; // Enter your URL, ending with a trailing slash (/)
  static const String baseUrl = "https://novaxmine.com/";

  static const String loginEndPoint = 'api/login';
  static const String registrationEndPoint = 'api/register';
  static const String userDashboardEndPoint = 'api/dashboard';
  static const String forgetPasswordEndPoint = 'api/password/email';
  static const String passwordVerifyEndPoint = 'api/password/verify-code';
  static const String resetPasswordEndPoint = 'api/password/reset';
  static const String countryEndPoint = 'api/get-countries';
  static const String verify2FAUrl = 'api/verify-g2fa';
  static const String accountDisable = "api/delete-account";
  static const String achievementEndPoint = "${baseUrl}api/achievements";

  //social login
  static const String socialLoginEndPoint = 'api/social-login';

  // plan
  static const String planEndPoint = "api/plans";
  static const String planPurchaseEndPoint = "api/plan/purchase";
  static const String purchasedPlanEndPoint = "api/purchased-plan";
  static const String planPaymentMethodEndPoint = "api/deposit/methods";
  static const String planPaymentInsertEndPoint = "api/deposit/insert";
  static const String order = "api/orders";
  static const String miningTrackEndPoint = "api/mining-tracks";

  // wallet
  static const String walletEndPoint = "api/wallets";
  static const String walletUpdateEndPoint = "api/wallet/moving/site-currency";

  // withdraw
  static const String addWithdrawRequestUrl = 'api/withdraw/request';
  static const String withdrawMethodUrl = 'api/withdraw/method';
  static const String withdrawRequestConfirm = 'api/withdraw/request/confirm';
  static const String withdrawHistoryUrl = 'api/withdraw/history';
  static const String withdrawStoreUrl = 'api/withdraw/store/';
  static const String withdrawConfirmScreenUrl = 'api/withdraw/preview/';

  // verification
  static const String verifyEmailEndPoint = 'api/verify-email';
  static const String verifySmsEndPoint = 'api/verify-mobile';
  static const String resendVerifyCodeEndPoint = 'api/resend-verify/';
  static const String twoFactorEnable = "api/twofactor/enable";
  static const String twoFactorDisable = "api/twofactor/disable";
  static const String twoFactor = "api/twofactor";

  //support
  static const String supportMethodsEndPoint = 'api/support/method';
  static const String supportListEndPoint = 'api/ticket';
  static const String storeSupportEndPoint = 'api/ticket/create';
  static const String supportViewEndPoint = 'api/ticket/view';
  static const String supportReplyEndPoint = 'api/ticket/reply';
  static const String supportCloseEndPoint = 'api/ticket/close';
  static const String supportDownloadEndPoint = 'api/ticket/download';
  static const String communityGroupsEndPoint = 'api/community-groups';

  // deposit
  static const String depositHistoryEndPoint = 'api/deposit/history';
  static const String depositMethodEndPoint = 'api/deposit/methods';
  static const String depositInsertEndPoint = 'api/deposit/insert';
  static const String coinWalletsEndPoint = 'api/coin-wallets';

  static const String authorizationCodeEndPoint = 'api/authorization';
  static const String generalSettingEndPoint = 'api/general-setting';
  static const String privacyPolicyEndPoint = 'api/policies';

  // profile
  static const String getProfileEndPoint = 'api/user-info';
  static const String updateProfileEndPoint = 'api/profile-setting';
  static const String profileCompleteEndPoint = 'api/user-data-submit';
  static const String changePasswordEndPoint = 'api/change-password';
  static const String faqEndPoint = 'api/faq';
  static const String languageUrl = 'api/language/';

  // transaction
  static const String transactionEndpoint = 'api/transactions';
  static const String deviceTokenEndPoint = 'api/add-device-token';
  static const String logout = 'api/logout';

  // referral
  static const String myReferralEndPoint = 'api/referral';
  static const String referralLogEndPoint = 'api/referral/log';

  //kyc
  static const String kycFormUrl = 'api/kyc-form';
  static const String kycSubmitUrl = 'api/kyc-submit';

  static const String countryFlagImageLink =
      'https://flagpedia.net/data/flags/h24/{countryCode}.webp';
  static const String supportImagePath = '${baseUrl}assets/support/';
  static const String mineWalletImagePath = '${baseUrl}assets/images/miner/';
  static const String withDrawImagePath =
      '${baseUrl}assets/images/withdraw_method/';
}
