import 'dart:convert';

import 'package:get/get.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/referral/my_referral/my_referral_response_model.dart';
import 'package:mine_lab/data/repo/referral/my_referral_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class MyReferralController extends GetxController {
  MyReferralRepo myReferralRepo;
  MyReferralController({required this.myReferralRepo});

  bool isLoading = true;

  List<Referrals> myReferralsList = [];
  String referralLink = "";

  Future<void> loadMyReferralData() async {
    isLoading = true;
    myReferralsList.clear();

    ResponseModel responseModel = await myReferralRepo.getMyReferralData();
    if (responseModel.statusCode == 200) {
      MyReferralResponseModel model = MyReferralResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() == "success") {
        List<Referrals>? tempList = model.data?.referrals;
        referralLink = model.data?.referralLink ?? "";
        if (tempList != null && tempList.isNotEmpty) {
          myReferralsList.addAll(tempList);
        }
      } else {
        final context = Get.context;
        final MyStrings =
            context != null ? AppLocalizations.of(context)! : null;
        CustomSnackBar.showCustomSnackBar(
            errorList: model.message?.error ?? [MyStrings!.somethingWentWrong],
            msg: [],
            isError: true);
      }
    } else {
      CustomSnackBar.showCustomSnackBar(
          errorList: [responseModel.message], msg: [], isError: true);
    }
    isLoading = false;
    update();
  }
}
