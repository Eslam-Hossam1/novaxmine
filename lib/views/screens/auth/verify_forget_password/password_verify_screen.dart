import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/auth/forget_password/verify_password_controller.dart';
import 'package:mine_lab/data/controller/profile/user_profile_controller.dart';
import 'package:mine_lab/data/repo/auth/login/login_repo.dart';
import 'package:mine_lab/data/repo/profile/user_profile_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/auth_components/auth_layout.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/text/default_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyForgetPassScreen extends StatefulWidget {
  const VerifyForgetPassScreen({super.key});

  @override
  State<VerifyForgetPassScreen> createState() => _VerifyForgetPassScreenState();
}

class _VerifyForgetPassScreenState extends State<VerifyForgetPassScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(UserProfileRepo(apiClient: Get.find()));
    Get.put(UserProfileController(userProfileRepo: Get.find()));
    final controller = Get.put(VerifyPasswordController(loginRepo: Get.find()));
    controller.email = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: MyColor.screenBgColor,
          appBar: CustomAppBar(
            fromAuth: true,
            isShowBackBtn: true,
            bgColor: MyColor.primaryColor,
            title: MyStrings!.passwordVerification,
          ),
          body: GetBuilder<VerifyPasswordController>(
            builder: (controller) => AuthLayout(
              bottomSpace: Dimensions.space50 * 2,
              imageUrl: MyImages.resetPassImage,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(MyStrings.enterOtp,
                        textAlign: TextAlign.center,
                        style: interRegularExtraLarge.copyWith(
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: Dimensions.space10),
                    Text(MyStrings.verifyPasswordSubText,
                        textAlign: TextAlign.center,
                        style: interRegularDefault.copyWith(
                            color: MyColor.primarySubTitleColor)),
                    const SizedBox(height: Dimensions.space20),
                    PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: interRegularDefault.copyWith(
                          color: MyColor.primaryColor),
                      length: 6,
                      textStyle: interRegularDefault.copyWith(
                          color: MyColor.colorBlack),
                      obscureText: false,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderWidth: 1,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 40,
                          inactiveColor: MyColor.colorGrey,
                          inactiveFillColor: MyColor.transparentColor,
                          activeFillColor: MyColor.transparentColor,
                          activeColor: MyColor.primaryColor,
                          selectedFillColor: MyColor.transparentColor,
                          selectedColor: MyColor.primaryColor),
                      cursorColor: MyColor.colorBlack,
                      animationDuration: const Duration(milliseconds: 100),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      beforeTextPaste: (text) {
                        return true;
                      },
                      onChanged: (value) {
                        setState(() {
                          controller.currentText = value;
                        });
                      },
                    ),
                    const SizedBox(height: Dimensions.space25),
                    RoundedButton(
                        isLoading: controller.verifyLoading,
                        text: MyStrings.submit,
                        textColor: MyColor.colorWhite,
                        color: MyColor.primaryColor,
                        press: () {
                          if (controller.currentText.length != 6) {
                            controller.hasError = true;
                          } else {
                            controller.verifyForgetPasswordCode(
                                controller.currentText);
                          }
                        }),
                    const SizedBox(height: Dimensions.space25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultText(
                            text: MyStrings.didNotReceiveCode,
                            textColor: MyColor.colorGrey),
                        const SizedBox(width: Dimensions.space5),
                        TextButton(
                          onPressed: () {
                            controller.resendForgetPassCode(context);
                          },
                          child: DefaultText(
                              text: MyStrings.resend,
                              textStyle: interRegularDefault.copyWith(
                                  color: MyColor.primaryColor)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
