import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/auth/registration/registration_controller.dart';
import 'package:mine_lab/data/controller/auth/social_login_controller.dart';
import 'package:mine_lab/data/controller/auth/social_login_repo.dart';
import 'package:mine_lab/data/repo/auth/general_setting_repo.dart';
import 'package:mine_lab/data/repo/auth/registration/registration_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/will_pop_widget.dart';
import 'package:mine_lab/views/screens/auth/registration/widget/registration_form.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(SocialLoginRepo(apiClient: Get.find()));
    Get.put(RegistrationRepo(apiClient: Get.find()));
    Get.put(SocialLoginController(repo: Get.find()));
    Get.put(RegistrationController(
        registrationRepo: Get.find(), generalSettingRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RegistrationController>().initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: MyColor.screenBgColor,
          appBar: CustomAppBar(
            title: MyStrings!.signUp,
            bgColor: MyColor.primaryColor,
            fromAuth: true,
          ),
          body: GetBuilder<RegistrationController>(
              builder: (controller) => SingleChildScrollView(
                    padding: Dimensions.screenPadding,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(MyStrings.signUp.tr.toTitleCase(),
                              style:
                                  interRegularDefault.copyWith(fontSize: 32)),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(MyStrings.signUpMSG.tr,
                              style: interRegularDefault.copyWith(
                                  fontSize: 16,
                                  color: MyColor.bodyTextColor
                                      .withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w400)), //
                        ),
                        SizedBox(height: Dimensions.space30),
                        const RegistrationForm(),
                      ],
                    ),
                  )

              // AuthLayout(
              //   showBackButton: true,
              //   imageUrl: MyImages.registrationImage,
              //   imageHeight: 230,
              //   imageWidth: 230,
              //   child: SingleChildScrollView(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Text(MyStrings.signUpTitle, textAlign: TextAlign.center, style: interRegularExtraLarge.copyWith(fontWeight: FontWeight.w600)),
              //         const SizedBox(height: Dimensions.space20),
              //         const RegistrationForm(),
              //       ],
              //     ),
              //   ),
              // ),
              ),
        ),
      ),
    );
  }
}
