import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';
import 'package:mine_lab/data/controller/auth/forget_password/forget_password_controller.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/text-field/custom_text_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<ForgetPasswordController>(
      builder: (controller) => Form(
        child: Column(
          children: [
            CustomTextField(
              needLabel: false,
              needOutlineBorder: true,
              labelText: MyStrings!.usernameOrEmail,
              hintText: MyStrings.usernameOrEmailHint,
              textInputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
              controller: controller.emailOrUsernameController,
              onSuffixTap: () {},
              onChanged: (value) {
                return;
              },
            ),
            const SizedBox(height: Dimensions.space25),
            RoundedButton(
              isLoading: controller.submitLoading,
              press: () {
                controller.submitForgetPassCode(context);
              },
              width: MediaQuery.of(context).size.width,
              color: MyColor.primaryColor,
              text: MyStrings.send,
              textColor: MyColor.colorWhite,
            ),
          ],
        ),
      ),
    );
  }
}
