import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/auth/social_login_repo.dart';
import 'package:mine_lab/environment.dart';
import 'package:mine_lab/views/components/packages/signin_with_linkdin/signin_with_linkedin.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';

import '../../model/auth/login/login_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../model/user/user.dart';

const List<String> scopes = <String>[
  'https://www.googleapis.com/auth/userinfo.profile',
];

class SocialLoginController extends GetxController {
  final SocialLoginRepo repo;
  SocialLoginController({required this.repo});

  final GoogleSignIn signIn = GoogleSignIn.instance;
  bool isGoogleSignInLoading = false;
  GoogleSignInAccount? user;

  Future<void> signInWithGoogle() async {
    isGoogleSignInLoading = true;
    update();
    try {
      signIn.signOut();
      await signIn.initialize(clientId: null, serverClientId: null).then((_) {
        signIn.authenticationEvents
            .listen(_handleAuthenticationEvent)
            .onError(_handleAuthenticationError);
        signIn.attemptLightweightAuthentication();
      });
    } catch (e) {
      printX(e.toString());
      CustomSnackBar.error(errorList: [e.toString()]);
    }

    isGoogleSignInLoading = false;
    update();
  }

  Future<void> _handleAuthenticationEvent(
      GoogleSignInAuthenticationEvent event) async {
    try {
      isGoogleSignInLoading = true;
      update();

      final GoogleSignInAccount? user = switch (event) {
        GoogleSignInAuthenticationEventSignIn() => event.user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };

      final GoogleSignInClientAuthorization? authorization =
          await user?.authorizationClient.authorizationForScopes(scopes);

      if (user != null && authorization != null) {
        printX('User ID: ${user.id}');
        printX('Access token: ${authorization.accessToken}');
        await socialLoginUser(
          accessToken: authorization.accessToken,
          provider: "google",
        );
      }
    } catch (e) {
      printX(e);
    } finally {
      isGoogleSignInLoading = false;
      update();
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    // ممكن تضيف لوج أو سناackbar لو حابب
    printX('Google auth error: $e');
  }

  // SIGN IN with LinkedIn
  bool isLinkedinLoading = false;

  Future<void> signInWithLinkedin(BuildContext context) async {
    try {
      isLinkedinLoading = true;
      update();

      final String linkedinCredentialRedirectUrl =
          "${repo.apiClient.getSocialCredentialsRedirectUrl()}/linkedin";

      final linkedin = SignInWithLinkedIn(
        config: LinkedInConfig(
          clientId: Environment.linkedinCredentialClientId,
          clientSecret: Environment.linkedinCredentialclientSecret,
          scope: ['openid', 'profile', 'email'],
          redirectUrl: linkedinCredentialRedirectUrl,
        ),
      );

      final (authCode, error) = await linkedin.getAuthorizationCode(
        context: context,
      );

      if (authCode != null) {
        final (tokenInfo, tokenError) = await linkedin.getAccessToken(
          authorizationCode: authCode,
        );

        if (tokenInfo != null) {
          await socialLoginUser(
            provider: 'linkedin',
            accessToken: tokenInfo.accessToken,
          );
        } else {
          printX('Error on sign in: $tokenError');
        }
      } else {
        printX('Error getting auth code: $error');
      }
    } catch (e) {
      printX(e.toString());
      CustomSnackBar.error(errorList: [e.toString()]);
    } finally {
      isLinkedinLoading = false;
      update();
    }
  }

  Future<void> socialLoginUser({
    String accessToken = '',
    String? provider,
  }) async {
    // نجيب الـ localization من Get.context (لو متاح)
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final defaultLoginFailed =
        l10n?.loginFailedTryAgain ?? 'Login failed, please try again';
    final defaultSomethingWrong =
        l10n?.somethingWentWrong ?? 'Something went wrong';

    try {
      final ResponseModel responseModel = await repo.socialLoginUser(
        accessToken: accessToken,
        provider: provider,
      );

      if (responseModel.statusCode == 200) {
        final LoginResponseModel loginModel = LoginResponseModel.fromJson(
          jsonDecode(responseModel.responseJson),
        );

        // API بيرجع "success" كستاتس صريحة
        if (loginModel.status?.toLowerCase() == 'success') {
          final String token = loginModel.data?.accessToken ?? "";
          final String tokenType = loginModel.data?.tokenType ?? "";
          final GlobalUser? user = loginModel.data?.user;

          await RouteHelper.checkUserStatusAndGoToNextStep(
            user,
            accessToken: token,
            tokenType: tokenType,
            isRemember: true,
          );
        } else {
          CustomSnackBar.error(
            errorList:
                loginModel.message?.error ?? <String>[defaultLoginFailed],
          );
        }
      } else {
        CustomSnackBar.error(
          errorList: <String>[
            responseModel.message.isNotEmpty
                ? responseModel.message
                : defaultSomethingWrong
          ],
        );
      }
    } catch (e) {
      printX(e.toString());
      CustomSnackBar.error(errorList: <String>[e.toString()]);
    }
  }

  bool checkSocialAuthActiveOrNot({String provider = 'all'}) {
    if (provider == 'google') {
      return repo.apiClient.getGSData().data?.generalSetting?.googleLogin ==
          '1';
    } else if (provider == 'linkedin') {
      return repo.apiClient.getGSData().data?.generalSetting?.linkedinLogin ==
          '1';
    } else {
      return repo.apiClient.getSocialCredentialsEnabledAll();
    }
  }
}
