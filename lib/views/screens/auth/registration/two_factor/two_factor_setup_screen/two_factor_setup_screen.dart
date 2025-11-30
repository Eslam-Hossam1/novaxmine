import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/my_color.dart';

import 'package:mine_lab/data/controller/account/profile_controller.dart';
import 'package:mine_lab/data/controller/auth/two_factor_controller.dart';
import 'package:mine_lab/data/repo/account/profile_repo.dart';
import 'package:mine_lab/data/repo/auth/two_factor_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/screens/auth/registration/two_factor/two_factor_setup_screen/sections/two_factor_disable_section.dart';
import 'package:mine_lab/views/screens/auth/registration/two_factor/two_factor_setup_screen/sections/two_factor_enable_section.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TwoFactorRepo(apiClient: Get.find()));
    final controller = Get.put(TwoFactorController(repo: Get.find()));
    Get.put(ProfileRepo(apiClient: Get.find()));
    final pcontroller = Get.put(ProfileController(profileRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pcontroller.loadProfileInfo();
      controller.get2FaCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<TwoFactorController>(builder: (controller) {
      return GetBuilder<ProfileController>(builder: (profileController) {
        return Scaffold(
          backgroundColor: MyColor.screenBgColor,
          appBar: CustomAppBar(
            bgColor: MyColor.primaryColor,
            isShowBackBtn: true,
            title: MyStrings!.twoFactorAuth.tr,
          ),
          body: controller.isLoading || profileController.isLoading
              ? const CustomLoader()
              : profileController.user2faIsOne == false
                  ? const TwoFactorEnableSection()
                  : const TwoFactorDisableSection(),
        );
      });
    });
  }
}
