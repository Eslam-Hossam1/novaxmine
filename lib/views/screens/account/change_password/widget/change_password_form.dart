import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/data/controller/account/change_password_controller.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/text-field/custom_text_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<ChangePasswordController>(
      builder: (controller) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
                needLabel: false,
                needOutlineBorder: true,
                labelText: MyStrings!.currentPassword,
                hintText: MyStrings.currentPasswordHint,
                controller: controller.currentPassController,
                focusNode: controller.currentPassFocusNode,
                nextFocus: controller.passwordFocusNode,
                isPassword: true,
                isShowSuffixIcon: true,
                onChanged: (value) {}),
            const SizedBox(height: Dimensions.space20),
            CustomTextField(
                needLabel: false,
                needOutlineBorder: true,
                labelText: MyStrings.newPassword,
                hintText: MyStrings.passwordHint,
                controller: controller.passController,
                focusNode: controller.passwordFocusNode,
                nextFocus: controller.confirmPassFocusNode,
                isPassword: true,
                isShowSuffixIcon: true,
                onChanged: (value) {}),
            const SizedBox(height: Dimensions.space20),
            CustomTextField(
                needLabel: false,
                needOutlineBorder: true,
                labelText: MyStrings.confirmNewPassword,
                hintText: MyStrings.confirmPasswordHint,
                controller: controller.confirmPassController,
                focusNode: controller.confirmPassFocusNode,
                inputAction: TextInputAction.done,
                isPassword: true,
                isShowSuffixIcon: true,
                onChanged: (value) {}),
            const SizedBox(height: Dimensions.space25),
            RoundedButton(
              isLoading: controller.submitLoading,
              press: () {
                FocusScope.of(context!).unfocus();
                controller.changePassword(context);
              },
              width: MediaQuery.of(context).size.width,
              color: MyColor.primaryColor,
              text: MyStrings.changePassword,
              textColor: MyColor.colorWhite,
            ),
          ],
        ),
      ),
    );
  }
}

