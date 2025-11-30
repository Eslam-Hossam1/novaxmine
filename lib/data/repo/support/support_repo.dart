import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mine_lab/core/utils/method.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/support/new_ticket_store_model.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class SupportRepo {
  ApiClient apiClient;
  SupportRepo({required this.apiClient});

  Future<ResponseModel> getCommunityGroupListList() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.communityGroupsEndPoint}";
    final response =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> getSupportMethodsList() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.supportMethodsEndPoint}";
    final response =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> getSupportTicketList(String page) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.supportListEndPoint}?page=$page";
    final response =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<dynamic> storeTicket(
      BuildContext context, TicketStoreModel model) async {
    apiClient.initToken();

    String url = "${UrlContainer.baseUrl}${UrlContainer.storeSupportEndPoint}";

    Map<String, String> map = {
      'subject': model.subject,
      'message': model.message,
      'priority': model.priority
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers
        .addAll(<String, String>{'Authorization': 'Bearer ${apiClient.token}'});

    if (model.list != null && model.list!.isNotEmpty) {
      for (var file in model.list!) {
        request.files.add(http.MultipartFile(
            'attachments[]', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last));
      }
    }

    request.fields.addAll(map);
    http.StreamedResponse response = await request.send();

    String jsonResponse = await response.stream.bytesToString();
    printX("-=----------------------$jsonResponse");
    AuthorizationResponseModel authorization =
        AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    if (authorization.status?.toLowerCase() ==
        MyStrings!.success.toLowerCase()) {
      // CustomSnackBar.success(successList: authorization.message?.success ?? []);
      return true;
    } else {
      CustomSnackBar.error(
          errorList: authorization.message?.error ?? [MyStrings.error]);
      return false;
    }
  }

  Future<dynamic> getSingleTicket(String ticketId) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.supportViewEndPoint}/$ticketId';
    ResponseModel response =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<dynamic> replyTicket(
    BuildContext context,
    String message,
    List<File> fileList,
    String ticketId,
  ) async {
    apiClient.initToken();

    try {
      String url =
          "${UrlContainer.baseUrl}${UrlContainer.supportReplyEndPoint}/$ticketId";
      Map<String, String> map = {
        'message': message.toString(),
      };
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(
          <String, String>{'Authorization': 'Bearer ${apiClient.token}'});

      for (var file in fileList) {
        request.files.add(http.MultipartFile(
            'attachments[]', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last));
      }

      request.fields.addAll(map);
      http.StreamedResponse response = await request.send();

      String jsonResponse = await response.stream.bytesToString();
      AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

      printX("-=----------------------$jsonResponse");

      final MyStrings = context != null ? AppLocalizations.of(context)! : null;
      if (model.status?.toLowerCase() == MyStrings!.success.toLowerCase()) {
        // CustomSnackBar.success(successList: model.message?.success ?? []);
        return true;
      } else {
        CustomSnackBar.error(
            errorList: model.message?.error ?? [MyStrings.error]);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> closeTicket(String ticketId) async {
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.supportCloseEndPoint}/$ticketId';
    ResponseModel response =
        await apiClient.request(url, Method.postMethod, null, passHeader: true);
    return response;
  }
}

class ReplyTicketModel {
  final String? message;
  final List<File>? fileList;

  ReplyTicketModel(this.message, this.fileList);
}
