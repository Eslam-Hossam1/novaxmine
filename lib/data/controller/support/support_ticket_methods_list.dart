import 'package:get/get.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

import 'package:mine_lab/gen_l10n/app_localizations.dart';
import '../../model/global/response_model/response_model.dart';
import '../../model/support/community_group_model.dart';
import '../../model/support/support_methods_model.dart';
import '../../repo/support/support_repo.dart';

class SupportTicketMethodsController extends GetxController {
  SupportRepo repo;
  SupportTicketMethodsController({required this.repo});

  bool isLoading = false;
  String methodFilePath = "";
  List<SupportMethod> supportMethodsList = [];

  Future<void> getSupportMethodsList() async {
    isLoading = true;
    update();

    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    try {
      ResponseModel responseModel = await repo.getSupportMethodsList();
      if (responseModel.statusCode == 200) {
        supportMethodsList.clear();
        SupportMethods model =
            supportMethodsFromJson(responseModel.responseJson);
        if (model.status == MyStrings!.success) {
          methodFilePath = model.data!.methodFilePath ?? '';
          List<SupportMethod>? tempList = model.data?.methods;

          if (tempList != null && tempList.isNotEmpty) {
            supportMethodsList.addAll(tempList);
          }
        } else {
          CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  String communityGroupImagePath = "";
  List<CommunityGroupElement> getCommunityGroupList = [];

  Future<void> getCommunityMethodGroupList() async {
    isLoading = true;
    update();
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    try {
      ResponseModel responseModel = await repo.getCommunityGroupListList();
      if (responseModel.statusCode == 200) {
        getCommunityGroupList.clear();
        CommunityGroup model =
            communityGroupFromJson(responseModel.responseJson);
        if (model.status == MyStrings!.success) {
          communityGroupImagePath = model.data!.communityGroupImagePath ?? '';
          List<CommunityGroupElement>? tempList = model.data?.communityGroups;

          if (tempList != null && tempList.isNotEmpty) {
            getCommunityGroupList.addAll(tempList);
          }
        } else {
          CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}
