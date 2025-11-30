import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mine_lab/core/utils/method.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class ChangePasswordRepo {
  ApiClient apiClient;

  ChangePasswordRepo({required this.apiClient});

  String token = '', tokenType = '';

  Future<bool> changePassword(
      BuildContext context, String currentPass, String password) async {
    final params = modelToMap(currentPass, password);
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.changePasswordEndPoint}';

    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);

    if (responseModel.statusCode == 200) {
      final MyStrings = context != null ? AppLocalizations.of(context)! : null;
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      if (model.status?.toLowerCase() == 'success') {
        CustomSnackBar.showCustomSnackBar(
            errorList: [],
            msg: model.message?.success ?? [MyStrings!.requestSuccess],
            isError: false);
        return true;
      } else {
        CustomSnackBar.showCustomSnackBar(
            errorList: model.message?.error ?? [MyStrings!.requestFail],
            msg: [],
            isError: true);
        return false;
      }
    } else {
      return false;
    }
  }

  modelToMap(String currentPassword, String newPass) {
    Map<String, dynamic> map2 = {
      'current_password': currentPassword,
      'password': newPass,
      'password_confirmation': newPass
    };
    return map2;
  }
}

