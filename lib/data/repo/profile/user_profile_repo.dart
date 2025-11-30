import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mine_lab/core/utils/method.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/model/account/profile_response_model.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/profile/edit_profile/user_post_model.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class UserProfileRepo {
  ApiClient apiClient;
  UserProfileRepo({required this.apiClient});

  Future<bool> updateProfile(
      BuildContext context, UserPostModel m, bool isProfile) async {
    try {
      apiClient.initToken();

      String url =
          '${UrlContainer.baseUrl}${isProfile ? UrlContainer.updateProfileEndPoint : UrlContainer.profileCompleteEndPoint}';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      Map<String, String> finalMap = {
        'firstname': m.firstname,
        'lastname': m.lastName,
        'address': m.address ?? '',
        'zip': m.zip ?? '',
        'state': m.state ?? "",
        'city': m.city ?? '',
      };

      request.headers.addAll(
          <String, String>{'Authorization': 'Bearer ${apiClient.token}'});
      if (m.image != null) {
        request.files.add(http.MultipartFile(
            'image', m.image!.readAsBytes().asStream(), m.image!.lengthSync(),
            filename: m.image!.path.split('/').last));
      }
      request.fields.addAll(finalMap);

      http.StreamedResponse response = await request.send();

      String jsonResponse = await response.stream.bytesToString();
      AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

      final MyStrings = context != null ? AppLocalizations.of(context)! : null;
      if (model.status?.toLowerCase() == MyStrings!.success.toLowerCase()) {
        CustomSnackBar.showCustomSnackBar(
            errorList: [],
            msg: model.message?.success ?? [MyStrings.success],
            isError: false);
        return true;
      } else {
        CustomSnackBar.showCustomSnackBar(
            errorList: [],
            msg: model.message?.error ?? [MyStrings.requestFail],
            isError: false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<ProfileResponseModel> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);

    if (responseModel.statusCode == 200) {
      ProfileResponseModel model =
          ProfileResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == 'success') {
        return model;
      } else {
        return ProfileResponseModel();
      }
    } else {
      return ProfileResponseModel();
    }
  }
}
