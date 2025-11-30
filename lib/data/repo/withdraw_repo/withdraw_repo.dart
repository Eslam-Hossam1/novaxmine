import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/kyc/kyc_response_model.dart';
import 'package:mine_lab/data/repo/kyc/kyc_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mine_lab/core/utils/method.dart' as request;

class WithdrawRepo {
  ApiClient apiClient;

  WithdrawRepo({required this.apiClient});

  Future<dynamic> getAllWithdrawMethod() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawMethodUrl}';
    ResponseModel responseModel = await apiClient
        .request(url, request.Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<dynamic> getWithdrawConfirmScreenData(String trxId) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.withdrawConfirmScreenUrl}$trxId';
    ResponseModel responseModel = await apiClient
        .request(url, request.Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<dynamic> addWithdrawRequest(BuildContext context, int methodCode,
      double amount, String? authMode) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.addWithdrawRequestUrl}';
    Map<String, dynamic> params = {
      'method_id': methodCode.toString(),
      'amount': amount.toString()
    };

    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    if (authMode != null &&
        authMode.isNotEmpty &&
        authMode.toLowerCase() != MyStrings!.selectOne.toLowerCase()) {
      params['auth_mode'] = authMode.toLowerCase();
    }

    ResponseModel responseModel = await apiClient
        .request(url, request.Method.postMethod, params, passHeader: true);

    return responseModel;
  }

  List<Map<String, String>> fieldList = [];
  List<ModelDynamicValue> filesList = [];

  Future<dynamic> confirmWithdrawRequest(
      String trx, List<GlobalFormModel> list, String twoFactorCode) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.withdrawRequestConfirm}';

    apiClient.initToken();
    await modelToMap(list);

    var request = http.MultipartRequest('POST', Uri.parse(url));
    Map<String, String> finalMap = {
      'trx': trx,
    };

    for (var element in fieldList) {
      finalMap.addAll(element);
    }

    request.headers
        .addAll(<String, String>{'Authorization': 'Bearer ${apiClient.token}'});

    for (var file in filesList) {
      request.files.add(http.MultipartFile(file.key ?? '',
          file.value.readAsBytes().asStream(), file.value.lengthSync(),
          filename: file.value.path.split('/').last));
    }

    if (twoFactorCode.isNotEmpty) {
      request.fields.addAll({'authenticator_code': twoFactorCode});
    }

    request.fields.addAll(finalMap);

    http.StreamedResponse response = await request.send();
    String jsonResponse = await response.stream.bytesToString();
    printX(url);
    printX(finalMap);
    printX(jsonResponse);
    AuthorizationResponseModel model =
        AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

    return model;
  }

  Future<dynamic> getAllWithdrawHistory(int page,
      {String searchText = ""}) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.withdrawHistoryUrl}?page=$page&search=$searchText";
    ResponseModel responseModel = await apiClient
        .request(url, request.Method.getMethod, null, passHeader: true);

    return responseModel;
  }

  Future<dynamic> modelToMap(List<GlobalFormModel> list) async {
    for (var e in list) {
      if (e.type == 'checkbox') {
        if (e.cbSelected != null && e.cbSelected!.isNotEmpty) {
          for (int i = 0; i < e.cbSelected!.length; i++) {
            fieldList.add({'${e.label}[$i]': e.cbSelected![i]});
          }
        }
      } else if (e.type == 'file') {
        if (e.imageFile != null) {
          filesList.add(ModelDynamicValue(e.label, e.imageFile!));
        }
      } else {
        if (e.selectedValue != null && e.selectedValue.toString().isNotEmpty) {
          fieldList.add({e.label ?? '': e.selectedValue});
        }
      }
    }
  }
}
