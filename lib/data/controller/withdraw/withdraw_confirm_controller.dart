import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/kyc/kyc_response_model.dart';
import 'package:mine_lab/data/repo/withdraw_repo/withdraw_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';

import '../../../core/helper/date_converter.dart';
import '../../model/account/profile_response_model.dart';
import '../../repo/account/profile_repo.dart';

class WithdrawConfirmController extends GetxController {
  final WithdrawRepo repo;
  final ProfileRepo profileRepo;

  WithdrawConfirmController({
    required this.repo,
    required this.profileRepo,
  });

  // helper للوصول للـ l10n من أي مكان جوه الكنترولر
  AppLocalizations? get _l10n =>
      Get.context != null ? AppLocalizations.of(Get.context!) : null;

  // نص "Select one" من الترجمة
  String get _selectOneText => _l10n?.selectOne ?? 'Select one';

  List<GlobalFormModel> formList = [];
  bool isLoading = true;
  String trxId = '';

  String twoFactorCode = '';
  bool submitLoading = false;

  bool isTFAEnable = false;

  void initData(dynamic model) async {
    isLoading = true;
    update();

    twoFactorCode = '';
    trxId = model.data?.trx ?? '';
    final List<GlobalFormModel>? tList = model.data?.form?.list;

    if (tList != null && tList.isNotEmpty) {
      formList.clear();
      for (var element in tList) {
        if (element.type == 'select') {
          final bool empty = (element.options?.isEmpty) ?? true;
          if (element.options != null && !empty) {
            // إدخال "Select one" من الترجمة
            element.options?.insert(0, _selectOneText);
            element.selectedValue = element.options?.first;
            formList.add(element);
          }
        } else {
          formList.add(element);
        }
      }
    }

    await checkTwoFactorStatus();

    isLoading = false;
    update();
  }

  void clearData() {
    formList.clear();
  }

  Future<void> submitConfirmWithdrawRequest() async {
    final l10n = _l10n;

    final List<String> list = hasError();
    if (list.isNotEmpty) {
      CustomSnackBar.error(errorList: list);
      return;
    }

    submitLoading = true;
    update();

    try {
      final AuthorizationResponseModel model =
          await repo.confirmWithdrawRequest(trxId, formList, twoFactorCode);

      if (model.status?.toLowerCase() == 'success') {
        Get.close(1);
        Get.offAndToNamed(RouteHelper.withdrawHistoryScreen);
        CustomSnackBar.success(
          successList: model.message?.error ??
              [l10n?.requestSuccess ?? 'Request successful'],
        );
      } else {
        CustomSnackBar.error(
          errorList:
              model.message?.error ?? [l10n?.requestFail ?? 'Request failed'],
        );
      }
    } catch (e) {
      printX(e);
    } finally {
      submitLoading = false;
      update();
    }
  }

  List<String> hasError() {
    final l10n = _l10n;
    final List<String> errorList = [];

    for (var element in formList) {
      if (element.isRequired == 'required') {
        final String requiredText = l10n?.isRequired ?? 'is required';

        if (element.type == 'checkbox') {
          if (element.cbSelected == null) {
            errorList.add('${element.name} $requiredText');
          }
        } else if (element.type == 'file') {
          if (element.imageFile == null) {
            errorList.add('${element.name} $requiredText');
          }
        } else {
          if (element.selectedValue == '' ||
              element.selectedValue == _selectOneText) {
            errorList.add('${element.name} $requiredText');
          }
        }
      }
    }

    return errorList;
  }

  void setStatusTrue() {
    isLoading = true;
    update();
  }

  void setStatusFalse() {
    isLoading = false;
    update();
  }

  void changeSelectedValue(dynamic value, int index) {
    formList[index].selectedValue = value;
    update();
  }

  void changeSelectedRadioBtnValue(int listIndex, int selectedIndex) {
    formList[listIndex].selectedValue =
        formList[listIndex].options?[selectedIndex];
    update();
  }

  void changeSelectedCheckBoxValue(int listIndex, String value) {
    final List<String> list = value.split('_');
    final int index = int.parse(list[0]);
    final bool status = list[1] == 'true';

    List<String>? selectedValue = formList[listIndex].cbSelected;

    if (selectedValue != null) {
      final String? optionValue = formList[listIndex].options?[index];

      if (status) {
        if (!selectedValue.contains(optionValue)) {
          selectedValue.add(optionValue!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(optionValue)) {
          selectedValue.removeWhere((element) => element == optionValue);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    } else {
      selectedValue = [];
      final String? optionValue = formList[listIndex].options?[index];

      if (status) {
        if (!selectedValue.contains(optionValue)) {
          selectedValue.add(optionValue!);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      } else {
        if (selectedValue.contains(optionValue)) {
          selectedValue.removeWhere((element) => element == optionValue);
          formList[listIndex].cbSelected = selectedValue;
          update();
        }
      }
    }
  }

  Future<void> checkTwoFactorStatus() async {
    final ResponseModel responseModel = await profileRepo.loadProfileInfo();

    if (responseModel.statusCode == 200) {
      final ProfileResponseModel model =
          ProfileResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == 'success') {
        isTFAEnable = (model.data?.user?.ts ?? '0') == '1';
      }
    }
  }

  void pickFile(int index) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result == null) return;

    formList[index].imageFile = File(result.files.single.path!);
    final String fileName = result.files.single.name;
    formList[index].selectedValue = fileName;
    update();
    return;
  }

  void changeSelectedDateTimeValue(int index, BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        final String formatted =
            DateConverter.estimatedDateTime(selectedDateTime);

        formList[index].selectedValue = formatted;
        formList[index].textEditingController?.text = formatted;
        printX(formList[index].textEditingController?.text);
        printX(formList[index].selectedValue);
        update();
      }
    }

    update();
  }

  void changeSelectedDateOnlyValue(int index, BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final DateTime selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );

      final String formatted = DateConverter.estimatedDate(selectedDateTime);

      formList[index].selectedValue = formatted;
      formList[index].textEditingController?.text = formatted;
      printX(formList[index].textEditingController?.text);
      printX(formList[index].selectedValue);
      update();
    }

    update();
  }

  void changeSelectedTimeOnlyValue(int index, BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final DateTime selectedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );

      final String formatted = DateConverter.estimatedTime(selectedDateTime);

      formList[index].selectedValue = formatted;
      formList[index].textEditingController?.text = formatted;
      printX(formList[index].textEditingController?.text);
      printX(formList[index].selectedValue);
      update();
    }

    update();
  }
}
