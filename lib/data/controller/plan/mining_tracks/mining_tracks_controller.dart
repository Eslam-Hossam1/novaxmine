import 'dart:convert';

import 'package:get/get.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/plan/mining_track/mining_track_response_model.dart';
import 'package:mine_lab/data/repo/plan/mining_track/mining_track_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class MiningTracksController extends GetxController {
  MiningTrackRepo miningTrackRepo;
  MiningTracksController({required this.miningTrackRepo});

  bool isLoading = true;
  List<MiningTrackData> miningTrackList = [];

  int page = 0;
  String? nextPageUrl;

  String currency = '';

  void loadPaginationData() async {
    await loadMiningTrackData();
    update();
  }

  void initData({bool isOrder = false}) async {
    page = 0;
    miningTrackList.clear();
    isLoading = true;
    update();
    await loadMiningTrackData(isOrder: isOrder);
    isLoading = false;
    update();
  }

  Future<void> loadMiningTrackData({bool isOrder = false}) async {
    currency = miningTrackRepo.apiClient
        .getCurrencyOrUsername(isCurrency: true, isSymbol: false);

    page = page + 1;
    if (page == 1) {
      miningTrackList.clear();
    }

    ResponseModel responseModel =
        await miningTrackRepo.getMiningTracksData(page, isOrder: isOrder);
    if (responseModel.statusCode == 200) {
      MiningTrackResponseModel model = MiningTrackResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      nextPageUrl = model.data?.orders?.nextPageUrl;
      if (model.status.toString().toLowerCase() == "success") {
        List<MiningTrackData>? tempMiningList =
            isOrder ? model.data?.orders?.data : model.data?.miningTracks?.data;
        if (tempMiningList != null && tempMiningList.isNotEmpty) {
          miningTrackList.addAll(tempMiningList);
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
  }

  bool hasNext() {
    return nextPageUrl != null &&
            nextPageUrl!.isNotEmpty &&
            nextPageUrl != 'null'
        ? true
        : false;
  }
}
