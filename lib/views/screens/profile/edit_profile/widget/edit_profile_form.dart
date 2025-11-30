import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/data/controller/profile/user_profile_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/text-field/custom_text_field.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<UserProfileController>(
      builder: (controller) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              needLabel: false,
              needOutlineBorder: true,
              labelText: MyStrings!.firstName,
              focusNode: controller.firstNameFocusNode,
              controller: controller.firstNameController,
              onChanged: (value) {
                return;
              },
            ),
            const SizedBox(height: Dimensions.space15),
            CustomTextField(
              needLabel: false,
              needOutlineBorder: true,
              labelText: MyStrings.lastName,
              focusNode: controller.lastNameFocusNode,
              controller: controller.lastNameController,
              onChanged: (value) {
                return;
              },
            ),
            const SizedBox(height: Dimensions.space15),
            CustomTextField(
                needLabel: false,
                needOutlineBorder: true,
                labelText: MyStrings.address,
                focusNode: controller.addressFocusNode,
                controller: controller.addressController,
                onChanged: (value) {
                  return;
                }),
            const SizedBox(height: Dimensions.space15),
            CustomTextField(
                needLabel: false,
                needOutlineBorder: true,
                labelText: MyStrings.state,
                onChanged: (value) {
                  return;
                },
                focusNode: controller.stateFocusNode,
                controller: controller.stateController),
            const SizedBox(height: Dimensions.space15),
            CustomTextField(
                needLabel: false,
                needOutlineBorder: true,
                labelText: MyStrings.zipCode,
                onChanged: (value) {
                  return;
                },
                focusNode: controller.zipCodeFocusNode,
                controller: controller.zipCodeController),
            const SizedBox(height: Dimensions.space15),
            CustomTextField(
              needLabel: false,
              needOutlineBorder: true,
              labelText: MyStrings.city,
              onChanged: (value) {
                return;
              },
              focusNode: controller.cityFocusNode,
              controller: controller.cityController,
            ),
            const SizedBox(height: Dimensions.space25),
            RoundedButton(
              isLoading: controller.isSubmit,
              press: () {
                controller.updateProfile(context);
              },
              width: MediaQuery.of(context).size.width,
              color: MyColor.primaryColor,
              text: MyStrings.updateProfile,
              textColor: MyColor.colorWhite,
            )
          ],
        ),
      ),
    );
  }
}
