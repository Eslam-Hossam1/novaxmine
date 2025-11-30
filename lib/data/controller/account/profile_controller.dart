import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/model/account/profile_post_model.dart';
import 'package:mine_lab/data/model/account/profile_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/repo/account/profile_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class ProfileController extends GetxController {
  ProfileRepo profileRepo;
  ProfileResponseModel model = ProfileResponseModel();

  ProfileController({required this.profileRepo});

  String imageUrl = '';

  bool isLoading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  File? imageFile;

  bool isSubmitLoading = false;
  bool user2faIsOne = false;

  Future<void> loadProfileInfo() async {
    isLoading = true;
    update();

    ResponseModel responseModel = await profileRepo.loadProfileInfo();
    if (responseModel.statusCode == 200) {
      model = ProfileResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      // استبدلنا MyStrings.success بسطر ثابت لأن status من الـ API
      if (model.data != null &&
          (model.status ?? '').toLowerCase() == 'success') {
        loadData(model);
      } else {
        isLoading = false;
        update();
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    isSubmitLoading = true;
    update();

    final l10n = AppLocalizations.of(context)!;

    String firstName = firstNameController.text;
    String lastName = lastNameController.text.toString();
    String address = addressController.text.toString();
    String city = cityController.text.toString();
    String zip = zipCodeController.text.toString();
    String state = stateController.text.toString();

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      isLoading = true;
      update();

      ProfilePostModel body = ProfilePostModel(
        address: address,
        state: state,
        zip: zip,
        city: city,
        firstname: firstName,
        lastName: lastName,
      );

      bool ok = await profileRepo.updateProfile(body, true);

      if (ok) {
        await loadProfileInfo();
      }
    } else {
      // رسائل الخطأ من ملف اللغات بدل MyStrings
      if (firstName.isEmpty) {
        CustomSnackBar.error(errorList: [l10n.kFirstNameNullError]);
      }
      if (lastName.isEmpty) {
        CustomSnackBar.error(errorList: [l10n.kLastNameNullError]);
      }
    }

    isSubmitLoading = false;
    update();
  }

  void loadData(ProfileResponseModel? model) {
    profileRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userNameKey,
      '${model?.data?.user?.username}',
    );

    firstNameController.text = model?.data?.user?.firstname ?? '';
    lastNameController.text = model?.data?.user?.lastname ?? '';
    emailController.text = model?.data?.user?.email ?? '';
    mobileNoController.text = model?.data?.user?.mobile ?? '';
    addressController.text = model?.data?.user?.address ?? '';
    stateController.text = model?.data?.user?.state ?? '';
    zipCodeController.text = model?.data?.user?.zip ?? '';
    cityController.text = model?.data?.user?.city ?? '';

    user2faIsOne = model?.data?.user?.ts == '1';

    if (imageUrl.isNotEmpty && imageUrl != 'null') {
      imageUrl = '${UrlContainer.baseUrl}assets/images/user/profile/$imageUrl';
      profileRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userImageKey,
        imageUrl,
      );
    }

    isLoading = false;
    update();
  }
}

