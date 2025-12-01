import 'dart:convert';

import 'package:get/get.dart';
import 'package:mine_lab/data/model/deposit/coin_wallet_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/repo/deposit/deposit_repo.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class CoinWalletController extends GetxController {
  CoinWalletController({required this.depositRepo});

  final DepositRepo depositRepo;

  bool isLoading = false;
  String? errorMessage;
  List<CoinWalletModel> wallets = [];

  @override
  void onInit() {
    super.onInit();
    fetchCoinWallets();
  }

  Future<void> fetchCoinWallets() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final defaultError = l10n?.somethingWentWrong ?? 'Something went wrong';

    isLoading = true;
    errorMessage = null;
    update();

    ResponseModel responseModel;
    try {
      responseModel = await depositRepo.getCoinWallets();
    } catch (e) {
      errorMessage = e.toString();
      CustomSnackBar.error(errorList: [errorMessage ?? defaultError]);
      isLoading = false;
      update();
      return;
    }

    if (responseModel.statusCode == 200) {
      try {
        final decoded = jsonDecode(responseModel.responseJson);
        final data = CoinWalletResponseModel.fromJson(decoded);
        if (data.success == true && data.data != null) {
          wallets = data.data!;
          errorMessage = null;
        } else {
          wallets = [];
          errorMessage = data.message ?? defaultError;
          CustomSnackBar.error(errorList: [errorMessage ?? defaultError]);
        }
      } catch (e) {
        wallets = [];
        errorMessage = defaultError;
        CustomSnackBar.error(errorList: [defaultError]);
      }
    } else {
      errorMessage = responseModel.message;
      CustomSnackBar.error(errorList: [errorMessage ?? defaultError]);
    }

    isLoading = false;
    update();
  }
}
