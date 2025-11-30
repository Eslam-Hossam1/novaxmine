import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mine_lab/core/utils/method.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/model/account/profile_post_model.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/profile/profile_complete/profile_complete_post_model.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class ProfileRepo {
  ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<bool> updateProfile(ProfilePostModel model, bool isProfile) async {
    try {
      apiClient.initToken();

      String url =
          '${UrlContainer.baseUrl}${isProfile ? UrlContainer.updateProfileEndPoint : UrlContainer.profileCompleteEndPoint}';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      Map<String, String> finalMap = {
        'firstname': model.firstname,
        'lastname': model.lastName,
        'address': model.address ?? '',
        'zip': model.zip ?? '',
        'state': model.state ?? "",
        'city': model.city ?? '',
      };

      request.headers.addAll(
          <String, String>{'Authorization': 'Bearer ${apiClient.token}'});
      /*if(model.image!=null){
        request.files.add( http.MultipartFile('image', model.image!.readAsBytes().asStream(), model.image!.lengthSync(), filename: model.image!.path.split('/').last));
      }*/
      request.fields.addAll(finalMap);

      http.StreamedResponse response = await request.send();

      String jsonResponse = await response.stream.bytesToString();
      AuthorizationResponseModel authorizationResponseModel =
          AuthorizationResponseModel.fromJson(jsonDecode(jsonResponse));

      final context = Get.context;
      final MyStrings = context != null ? AppLocalizations.of(context)! : null;
      if (authorizationResponseModel.status?.toLowerCase() ==
          MyStrings!.success.toLowerCase()) {
        CustomSnackBar.success(
            successList: authorizationResponseModel.message?.success ??
                [MyStrings.success]);
        return true;
      } else {
        CustomSnackBar.error(
            errorList: authorizationResponseModel.message?.error ??
                [MyStrings.requestFail.tr]);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<ResponseModel> completeProfile(ProfileCompletePostModel model) async {
    dynamic params = model.toMap();
    String url =
        '${UrlContainer.baseUrl}${UrlContainer.profileCompleteEndPoint}';
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> loadProfileInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  // Future<void>updateDeviceToken() async{
  //   await PushNotificationService(apiClient: Get.find()).sendUserToken();
  // }

  Future<dynamic> getCountryList() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.countryEndPoint}';
    ResponseModel model = await apiClient.request(url, Method.getMethod, null);
    return model;
  }
}

