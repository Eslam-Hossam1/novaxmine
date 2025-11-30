import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/messages.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';
import 'package:mine_lab/data/controller/localization/localization_controller.dart';
import 'package:mine_lab/data/model/general_setting/general_settings_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/repo/auth/general_setting_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class SplashController extends GetxController {
  final GeneralSettingRepo repo;
  final LocalizationController localizationController;

  SplashController({
    required this.repo,
    required this.localizationController,
  });

  Future<void> gotoNext(BuildContext context) async {
    await loadLanguage(context);

    bool isRemember = repo.apiClient.sharedPreferences
            .getBool(SharedPreferenceHelper.rememberMeKey) ??
        false;

    ResponseModel response = await repo.getGeneralSetting();

    if (response.statusCode == 200) {
      final context = Get.context;
      final MyStrings = context != null ? AppLocalizations.of(context)! : null;
      try {
        GeneralSettingResponseModel model =
            GeneralSettingResponseModel.fromJson(
                jsonDecode(response.responseJson));
        if (model.status?.toLowerCase() == "success") {
          repo.apiClient.storeGeneralSetting(model);
          checkAndGo(isRemember);
        } else {
          CustomSnackBar.showCustomSnackBar(
            errorList: model.message?.error ?? [MyStrings!.somethingWentWrong],
            msg: [],
            isError: true,
          );
        }
      } catch (e) {
        CustomSnackBar.showCustomSnackBar(
          errorList: [MyStrings!.somethingWentWrong],
          msg: [],
          isError: true,
        );
      }
    } else {
      CustomSnackBar.showCustomSnackBar(
        errorList: [response.message],
        msg: [],
        isError: true,
      );
    }
  }

  void checkAndGo(bool isRemember) {
    if (repo.apiClient.getFirstTimeAppOpeningStatus() == false) {
      Get.toNamed(RouteHelper.onboardScreen);
    } else {
      if (isRemember) {
        Get.offAndToNamed(RouteHelper.bottomNav);
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAndToNamed(RouteHelper.loginScreen);
        });
      }
    }
  }

  Future<void> loadLanguage(BuildContext context) async {
    // تحميل اللغة الحالية من الكنترولر
    localizationController.loadCurrentLanguage();
    final locale = localizationController.locale;
    final String languageCode = locale.languageCode;

    ResponseModel response = await repo.getLanguage(context, languageCode);

    if (response.statusCode == 200) {
      try {
        final dynamic resJson = jsonDecode(response.responseJson);
        // حفظ الـ JSON الخام في الـ SharedPreferences كما هو
        saveLanguageList(response.responseJson);

        // تحديد مكان ملف اللغة بشكل مرن (data.file أو file أو الجذر نفسه)
        dynamic fileNode;

        if (resJson is Map<String, dynamic>) {
          if (resJson['data'] != null &&
              resJson['data'] is Map &&
              (resJson['data'] as Map)['file'] != null) {
            fileNode = (resJson['data'] as Map)['file'];
          } else if (resJson['file'] != null) {
            fileNode = resJson['file'];
          } else {
            // fallback: افترض أن الجذر نفسه هو ملف اللغة
            fileNode = resJson;
          }
        } else {
          // لو مش Map أصلاً
          fileNode = {};
        }

        // تحويل أي شكل لملف اللغة إلى Map<String, String>
        final Map<String, String> jsonMap = {};

        // 1) لو fileNode = Map
        if (fileNode is Map) {
          fileNode.forEach((key, value) {
            if (key != null) {
              jsonMap[key.toString()] = value?.toString() ?? '';
            }
          });
        }
        // 2) لو fileNode = List من Maps (بعض الـ APIs بترجعها كـ array)
        else if (fileNode is List) {
          for (final element in fileNode) {
            if (element is Map) {
              element.forEach((key, value) {
                if (key != null) {
                  jsonMap[key.toString()] = value?.toString() ?? '';
                }
              });
            }
          }
        }
        // 3) لو fileNode = String وداخله JSON
        else if (fileNode is String) {
          try {
            final decoded = jsonDecode(fileNode);
            if (decoded is Map) {
              decoded.forEach((key, value) {
                if (key != null) {
                  jsonMap[key.toString()] = value?.toString() ?? '';
                }
              });
            }
          } catch (_) {
            // تجاهل الخطأ، وسِب jsonMap فاضي
          }
        }

        if (jsonMap.isEmpty) {
          final context = Get.context;
          final MyStrings =
              context != null ? AppLocalizations.of(context)! : null;
          // لو مفيش أي حاجة اتحملت، نرجع برسالة خطأ بدل ما يحصل كراش صامت
          CustomSnackBar.error(errorList: [MyStrings!.somethingWentWrong]);
          return;
        }

        // مفتاح اللغة: en_US / ar_SA ... إلخ
        final String langKey =
            '${localizationController.locale.languageCode}_${localizationController.locale.countryCode}';

        final Map<String, Map<String, String>> language = {
          langKey: jsonMap,
        };

        // إضافة الترجمات إلى GetX
        Get.addTranslations(Messages(languages: language).keys);
      } catch (e) {
        CustomSnackBar.error(errorList: [e.toString()]);
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }
  }

  Future<void> saveLanguageList(String languageJson) async {
    await repo.apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.languageListKey, languageJson);
  }
}
