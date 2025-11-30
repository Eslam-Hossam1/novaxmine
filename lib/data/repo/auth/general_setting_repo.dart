import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/utils/method.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/model/general_setting/general_settings_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/services/api_service.dart';

class GeneralSettingRepo {
  ApiClient apiClient;

  GeneralSettingRepo({required this.apiClient});

  Future<dynamic> getGeneralSetting() async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.generalSettingEndPoint}';
    ResponseModel response =
        await apiClient.request(url, Method.getMethod, null, passHeader: false);
    return response;
  }

  storeGeneralSetting(GeneralSettingResponseModel model) {
    String json = jsonEncode(model.toJson());
    apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.generalSettingKey, json);
    getGSData();
  }

  GeneralSettingResponseModel getGSData() {
    String pre = apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.generalSettingKey) ??
        '';
    GeneralSettingResponseModel model =
        GeneralSettingResponseModel.fromJson(jsonDecode(pre));
    return model;
  }

  Future<dynamic> getLanguage(BuildContext context, String languageCode) async {
    try {
      String url =
          '${UrlContainer.baseUrl}${UrlContainer.languageUrl}$languageCode';
      ResponseModel response = await apiClient
          .request(url, Method.getMethod, null, passHeader: false);
      return response;
    } catch (e) {
      final MyStrings = context != null ? AppLocalizations.of(context)! : null;
      return ResponseModel(false, MyStrings!.somethingWentWrong, 300, '');
    }
  }
}
