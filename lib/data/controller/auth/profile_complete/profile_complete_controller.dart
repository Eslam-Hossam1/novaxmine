import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/data/model/country_model/country_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/profile/profile_complete/profile_complete_post_model.dart';
import 'package:mine_lab/data/model/profile/profile_complete/profile_complete_response_model.dart';
import 'package:mine_lab/data/model/user/user.dart';
import 'package:mine_lab/data/repo/auth/profile_complete/profile_complete_repo.dart';
import 'package:mine_lab/environment.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class ProfileCompleteController extends GetxController {
  final ProfileCompleteRepo profileRepo;

  ProfileCompleteController({required this.profileRepo});

  bool isLoading = false;
  String? countryName;
  String? countryCode;
  String? mobileCode;
  String? userName;
  String? phoneNo;

  String emailData = '';
  String countryData = '';
  String countryCodeData = '';
  String phoneCodeData = '';
  String phoneData = '';

  TextEditingController userNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  FocusNode userNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  Future<void> initialData() async {
    await getCountryData();
  }

  bool submitLoading = false;

  Future<void> updateProfile() async {
    final String username = userNameController.text.trim();
    final String mobileNumber = mobileController.text.trim();
    final String address = addressController.text.trim();
    final String city = cityController.text.trim();
    final String zip = zipCodeController.text.trim();
    final String state = stateController.text.trim();

    submitLoading = true;
    update();

    final ProfileCompletePostModel model = ProfileCompletePostModel(
      username: username,
      countryName: countryName ?? "",
      countryCode: countryCode ?? "",
      mobileNumber: mobileNumber,
      mobileCode: mobileCode ?? "",
      address: address,
      state: state,
      zip: zip,
      city: city,
      image: null,
    );

    final ResponseModel responseModel =
        await profileRepo.completeProfile(model);

    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final String defaultFailMsg = l10n?.requestFail ?? 'Request failed';

    if (responseModel.statusCode == 200) {
      final ProfileCompleteResponseModel resModel =
          ProfileCompleteResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      // حالة الـ API دايمًا بتكون "success" بالإنجليزي من السيرفر
      if (resModel.status?.toLowerCase() == 'success') {
        checkAndGotoNextStep(resModel.data?.user);
      } else {
        CustomSnackBar.error(
          errorList: resModel.message?.error ?? <String>[defaultFailMsg],
        );
      }
    } else {
      CustomSnackBar.error(errorList: <String>[responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  void checkAndGotoNextStep(GlobalUser? user) async {
    final bool needEmailVerification = user?.ev == "1" ? false : true;
    final bool needSmsVerification = user?.sv == '1' ? false : true;
    final bool isTwoFactorEnable = user?.tv == '1' ? false : true;

    await profileRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userIdKey,
      user?.id.toString() ?? '-1',
    );
    await profileRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userEmailKey,
      user?.email ?? '',
    );
    await profileRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userPhoneNumberKey,
      user?.mobile ?? '',
    );
    await profileRepo.apiClient.sharedPreferences.setString(
      SharedPreferenceHelper.userNameKey,
      user?.username ?? '',
    );

    if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerifyScreen);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerifyScreen);
    } else if (isTwoFactorEnable) {
      Get.offAndToNamed(RouteHelper.twoFactorScreen);
    } else {
      await profileRepo.updateDeviceToken();
      Get.offAndToNamed(RouteHelper.bottomNav);
    }
  }

  TextEditingController searchCountryController = TextEditingController();
  bool countryLoading = true;
  List<Countries> countryList = <Countries>[];
  List<Countries> filteredCountries = <Countries>[];

  String dialCode = Environment.defaultPhoneCode;

  void updateMobilecode(String code) {
    dialCode = code;
    update();
  }

  Future<dynamic> getCountryData() async {
    final ResponseModel mainResponse = await profileRepo.getCountryList();

    if (mainResponse.statusCode == 200) {
      final CountryModel model =
          CountryModel.fromJson(jsonDecode(mainResponse.responseJson));
      final List<Countries>? tempList = model.data?.countries;

      if (tempList != null && tempList.isNotEmpty) {
        countryList.addAll(tempList);
        filteredCountries.addAll(tempList);
      }

      final Countries selectDefCountry = tempList!.firstWhere(
        (Countries country) =>
            (country.countryCode ?? '').toLowerCase() ==
            Environment.defaultCountryCode.toLowerCase(),
        orElse: () => Countries(),
      );

      if (selectDefCountry.dialCode != null) {
        selectCountryData(selectDefCountry);
        setCountryNameAndCode(
          selectDefCountry.country.toString(),
          selectDefCountry.countryCode.toString(),
          selectDefCountry.dialCode.toString(),
        );
      }

      countryLoading = false;
      isLoading = false;
      update();
    } else {
      CustomSnackBar.error(errorList: <String>[mainResponse.message]);
      countryLoading = false;
      isLoading = false;
      update();
      return;
    }
  }

  void setCountryNameAndCode(
    String cName,
    String countryCode,
    String mobileCode,
  ) {
    countryName = cName;
    this.countryCode = countryCode;
    this.mobileCode = mobileCode;
    update();
  }

  Countries selectedCountryData = Countries();

  void selectCountryData(Countries value) {
    selectedCountryData = value;
    update();
  }
}

