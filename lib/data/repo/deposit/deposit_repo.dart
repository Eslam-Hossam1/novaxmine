import '../../../core/utils/method.dart';
import '../../../core/utils/url_container.dart';
import '../../model/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class DepositRepo {
  ApiClient apiClient;
  DepositRepo({required this.apiClient});

  Future<ResponseModel> getDepositHistory(
      {required int page, String searchText = ""}) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.depositHistoryEndPoint}?page=$page&search=$searchText";

    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<dynamic> getDepositMethods() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.depositMethodEndPoint}';

    ResponseModel response =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }

  Future<ResponseModel> getCoinWallets() async {
    final String url =
        '${UrlContainer.baseUrl}${UrlContainer.coinWalletsEndPoint}';
    return apiClient.request(url, Method.getMethod, null, passHeader: true);
  }

  Future<ResponseModel> insertDeposit(
      {required String amount,
      required String methodCode,
      required String currency}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.depositInsertEndPoint}";
    Map<String, String> map = {
      "amount": amount,
      "method_code": methodCode,
      "currency": currency
    };

    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return responseModel;
  }

  Future<dynamic> getUserInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    ResponseModel response =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return response;
  }
}
