import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_animation.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/auth/email_verification_controler.dart';
import 'package:mine_lab/data/repo/auth/general_setting_repo.dart';
import 'package:mine_lab/data/repo/auth/sms_email_verification_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/text/default_text.dart';
import 'package:mine_lab/views/components/will_pop_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SmsEmailVerificationRepo(apiClient: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    final controller = Get.put(EmailVerificationController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            fromAuth: true,
            isShowBackBtn: true,
            bgColor: MyColor.primaryColor,
            title: MyStrings!.emailVerify,
          ),
          body: GetBuilder<EmailVerificationController>(
            builder: (controller) => SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: Dimensions.space10),
                  Container(
                    height: 120,
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: MyColor.primaryColor.withValues(alpha: .075), shape: BoxShape.circle),
                    // child: CustomSvgPicture(image: MyImages.emailVerifyImage, height: 50, width: 50, color: MyColor.getPrimaryColor()),
                    child: Lottie.asset(MyAnimation.email, height: 120, width: 120),
                  ),
                  Container(
                    padding: Dimensions.screenPadding,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                    child: controller.isLoading
                        ? CustomLoader(isCustom: true, loaderColor: MyColor.primaryColor.withValues(alpha: 0.5))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: Dimensions.space20),
                              Text(MyStrings.viaEmailVerify, textAlign: TextAlign.center, style: interRegularDefault.copyWith(color: MyColor.primarySubTitleColor)),
                              const SizedBox(height: Dimensions.space10),
                              DefaultText(text: "${MyStrings.email.tr}: ${MyUtils.getMaskedMail(controller.userEmail)}", textAlign: TextAlign.center, textColor: MyColor.bodyTextColor),
                              const SizedBox(height: Dimensions.space20),
                              PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: interRegularDefault.copyWith(color: MyColor.primaryColor),
                                length: 6,
                                textStyle: interRegularDefault.copyWith(color: MyColor.colorBlack),
                                obscureText: false,
                                obscuringCharacter: '*',
                                blinkWhenObscuring: false,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(shape: PinCodeFieldShape.box, borderWidth: 1, borderRadius: BorderRadius.circular(5), fieldHeight: 40, fieldWidth: 40, inactiveColor: MyColor.colorGrey, inactiveFillColor: MyColor.transparentColor, activeFillColor: MyColor.transparentColor, activeColor: MyColor.primaryColor, selectedFillColor: MyColor.transparentColor, selectedColor: MyColor.primaryColor),
                                cursorColor: MyColor.colorBlack,
                                animationDuration: const Duration(milliseconds: 100),
                                enableActiveFill: true,
                                keyboardType: TextInputType.number,
                                beforeTextPaste: (text) {
                                  return true;
                                },
                                onChanged: (value) {
                                  controller.currentText = value;
                                },
                              ),
                              const SizedBox(height: Dimensions.space25),
                              RoundedButton(
                                isLoading: controller.submitLoading,
                                text: MyStrings.submit,
                                textColor: MyColor.colorWhite,
                                color: MyColor.primaryColor,
                                press: () {
                                  controller.verifyEmail(controller.currentText);
                                },
                              ),
                              const SizedBox(height: Dimensions.space20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(MyStrings.didNotReceiveCode.tr, style: interRegularDefault.copyWith(color: MyColor.labelTextColor)),
                                  const SizedBox(width: Dimensions.space10),
                                  controller.resendLoading
                                      ? Container(
                                          margin: const EdgeInsetsDirectional.only(start: 5, top: 5),
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(color: MyColor.primaryColor),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            controller.sendCodeAgain(context);
                                          },
                                          child: Text(MyStrings.resend.tr, style: interRegularDefault.copyWith(color: MyColor.primaryColor, decoration: TextDecoration.underline, decorationColor: MyColor.primaryColor)),
                                        )
                                ],
                              )
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
