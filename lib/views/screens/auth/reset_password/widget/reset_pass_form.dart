import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/data/controller/auth/forget_password/reset_password_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/text-field/custom_text_field.dart';
import 'package:mine_lab/views/components/validation_widget/validation_widget.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<ResetPasswordController>(
      builder: (controller) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: controller.hasPasswordFocus &&
                    controller.checkPasswordStrength,
                child: ValidationWidget(
                    list: controller.passwordValidationRules,
                    heightBottom: 15)),
            Focus(
              onFocusChange: (hasFocus) {
                controller.changePasswordFocus(hasFocus);
              },
              child: CustomTextField(
                  needLabel: false,
                  needOutlineBorder: true,
                  labelText: MyStrings!.password.tr,
                  hintText: MyStrings.passwordHint.tr,
                  isShowSuffixIcon: true,
                  isPassword: true,
                  textInputType: TextInputType.text,
                  controller: controller.passController,
                  focusNode: controller.passwordFocusNode,
                  nextFocus: controller.confirmPasswordFocusNode,
                  validator: (value) {
                    return controller.validPassword(value ?? '');
                  },
                  onChanged: (value) {
                    if (controller.checkPasswordStrength) {
                      controller.updateValidationList(value);
                    }
                    return;
                  }),
            ),
            const SizedBox(height: Dimensions.space25),
            CustomTextField(
              needOutlineBorder: true,
              inputAction: TextInputAction.done,
              isPassword: true,
              needLabel: false,
              labelText: MyStrings.confirmPassword,
              hintText: MyStrings.confirmYourPassword.tr,
              isShowSuffixIcon: true,
              controller: controller.confirmPassController,
              focusNode: controller.confirmPasswordFocusNode,
              onChanged: (value) {
                return;
              },
              validator: (value) {
                if (controller.passController.text.toLowerCase() !=
                    controller.confirmPassController.text.toLowerCase()) {
                  return MyStrings.kMatchPassError.tr;
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: Dimensions.space25),
            RoundedButton(
              isLoading: controller.submitLoading,
              color: MyColor.primaryColor,
              textColor: MyColor.colorWhite,
              width: 1,
              text: MyStrings.submit,
              press: () {
                if (formKey.currentState!.validate()) {
                  controller.resetPassword();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
