import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';

import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/auth/login/login_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/text-field/custom_text_field.dart';
import 'package:mine_lab/views/screens/auth/login/widget/social_login_section.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GetBuilder<LoginController>(
      builder: (controller) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              needLabel: false,
              needOutlineBorder: true,
              textInputType: TextInputType.text,
              labelText: l10n.username,
              hintText: l10n.usernameHint,
              controller: controller.usernameController,
              focusNode: controller.usernameFocusNode,
              nextFocus: controller.passwordFocusNode,
              onChanged: (value) {
                return;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterUsername;
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: Dimensions.space20),
            CustomTextField(
              needLabel: false,
              needOutlineBorder: true,
              textInputType: TextInputType.text,
              labelText: l10n.password,
              hintText: l10n.passwordHint,
              isPassword: true,
              isShowSuffixIcon: true,
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              onChanged: (value) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterPassword;
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: Dimensions.space10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.changeRememberMe();
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          activeColor: MyColor.primaryColor,
                          value: controller.remember,
                          side: WidgetStateBorderSide.resolveWith(
                            (states) => BorderSide(
                              width: 1.0,
                              color: controller.remember
                                  ? MyColor.transparentColor
                                  : MyColor.colorGrey,
                            ),
                          ),
                          onChanged: (value) {
                            controller.changeRememberMe();
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.space10),
                      Text(
                        l10n.rememberMe,
                        style: interRegularSmall.copyWith(
                          color: MyColor.colorBlack,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.clearData();
                    controller.forgetPassword();
                  },
                  child: Text(
                    l10n.forgotPassword,
                    style: interRegularSmall.copyWith(
                      color: MyColor.redCancelTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.space15),
            RoundedButton(
              isLoading: controller.isSubmitLoading,
              press: () {
                if (formKey.currentState!.validate()) {
                  controller.loginUser();
                }
              },
              width: MediaQuery.of(context).size.width,
              color: MyColor.primaryColor,
              text: l10n.login,
              textColor: MyColor.colorWhite,
            ),
            const SocialLoginSection(),
            const SizedBox(height: Dimensions.space15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.noAccount,
                  style: interRegularDefault.copyWith(
                    color: MyColor.accountEnsureTextColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.offAndToNamed(RouteHelper.registrationScreen);
                    controller.clearData();
                  },
                  child: Text(
                    " ${l10n.createNew}",
                    style: interRegularDefault.copyWith(
                      color: MyColor.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
