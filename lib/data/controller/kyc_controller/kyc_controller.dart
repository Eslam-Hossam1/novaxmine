import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/date_converter.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/kyc/kyc_response_model.dart';
import 'package:mine_lab/data/repo/kyc/kyc_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class KycController extends GetxController {
  final KycRepo repo;

  KycController({required this.repo});

  File? imageFile;

  bool isLoading = true;
  List<GlobalFormModel> formList = [];
  List<KycPendingData> pendingData = [];
  String path = "";
  String selectOne = '';

  KycResponseModel model = KycResponseModel();
  bool isNoDataFound = false;
  bool isAlreadyVerified = false;
  bool isAlreadyPending = false;

  Future<void> beforeInitLoadKycData() async {
    setStatusTrue();

    try {
      // localization
      final context = Get.context;
      final l10n = context != null ? AppLocalizations.of(context)! : null;

      // "Select one" نص الاختيار الافتراضي
      selectOne = l10n?.selectOne ?? 'Select one';

      model = await repo.getKycData(context!);

      final statusLower = (model.status ?? '').toLowerCase();

      if (model.data != null && statusLower == 'success') {
        final remarkLower = (model.remark ?? '').toLowerCase();

        if (remarkLower == 'under_review') {
          isAlreadyPending = true;
        }

        final List<GlobalFormModel>? tList = model.data?.form?.list;
        path = model.data?.path ?? '';
        final List<KycPendingData>? pList = model.data?.kycPendingData;

        printX("pList?.length ${pList?.length}");

        if (pList != null && pList.isNotEmpty) {
          pendingData.addAll(pList);
        }

        if (tList != null && tList.isNotEmpty) {
          formList.clear();
          for (final element in tList) {
            if (element.type == 'select') {
              final bool empty = (element.options?.isEmpty) ?? true;
              if (element.options != null && !empty) {
                element.options?.insert(0, selectOne);
                element.selectedValue = element.options?.first;
                formList.add(element);
              }
            } else {
              formList.add(element);
            }
          }
        }

        isNoDataFound = false;
      } else {
        final remarkLower = (model.remark ?? '').toLowerCase();
        if (remarkLower == 'already_verified') {
          isAlreadyVerified = true;
        } else if (remarkLower == 'under_review') {
          isAlreadyPending = true;
        } else {
          isNoDataFound = true;
        }
      }
    } finally {
      setStatusFalse();
    }
  }

  void setStatusTrue() {
    isLoading = true;
    update();
  }

  void setStatusFalse() {
    isLoading = false;
    update();
  }

  bool submitLoading = false;

  Future<void> submitKycData() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final successText = l10n?.success ?? 'Success';
    final requestFailText = l10n?.requestFail ?? 'Request failed';

    final List<String> list = hasError();

    if (list.isNotEmpty) {
      CustomSnackBar.error(errorList: list);
      return;
    }

    submitLoading = true;
    update();

    final AuthorizationResponseModel response =
        await repo.submitKycData(context!, formList);

    final statusLower = (response.status ?? '').toLowerCase();

    if (statusLower == 'success') {
      isAlreadyPending = true;
      CustomSnackBar.success(
        successList: response.message?.success ?? [successText],
      );
    } else {
      CustomSnackBar.error(
        errorList: response.message?.error ?? [requestFailText],
      );
    }

    submitLoading = false;
    update();
  }

  List<String> hasError() {
    final List<String> errorList = [];

    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final isRequiredText = l10n?.isRequired ?? 'is required';

    for (final element in formList) {
      if (element.isRequired == 'required') {
        if (element.type == 'checkbox') {
          if (element.cbSelected == null) {
            errorList.add('${element.name} $isRequiredText');
          }
        } else if (element.type == 'file') {
          if (element.imageFile == null) {
            errorList.add('${element.name} $isRequiredText');
          }
        } else {
          if (element.selectedValue == '' ||
              element.selectedValue == selectOne) {
            errorList.add('${element.name} $isRequiredText');
          }
        }
      }
    }

    return errorList;
  }

  void changeSelectedValue(dynamic value, int index) {
    formList[index].selectedValue = value;
    update();
  }

  // NEW DATE TIME
  Future<void> changeSelectedDateTimeValue(
      int index, BuildContext context) async {
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

  Future<void> changeSelectedDateOnlyValue(
      int index, BuildContext context) async {
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

  Future<void> changeSelectedTimeOnlyValue(
      int index, BuildContext context) async {
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

  // End DATE TIME
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

    final String? optionValue = formList[listIndex].options?[index];

    selectedValue ??= [];

    if (status) {
      if (optionValue != null && !selectedValue.contains(optionValue)) {
        selectedValue.add(optionValue);
        formList[listIndex].cbSelected = selectedValue;
        update();
      }
    } else {
      if (optionValue != null && selectedValue.contains(optionValue)) {
        selectedValue.removeWhere((element) => element == optionValue);
        formList[listIndex].cbSelected = selectedValue;
        update();
      }
    }
  }

  Future<void> pickFile(int index) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: <String>[
        'jpg',
        'png',
        'jpeg',
        'pdf',
        'doc',
        'docx',
        'csv',
        'txt',
        'docx',
        'xls',
        'xlsx',
      ],
    );

    if (result == null) return;

    formList[index].imageFile = File(result.files.single.path!);
    final String fileName = result.files.single.name;
    formList[index].selectedValue = fileName;
    update();
  }
}

