import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/data/controller/auth/profile_complete/profile_complete_controller.dart';
import 'package:mine_lab/data/repo/auth/profile_complete/profile_complete_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/card/custom_card.dart';
import 'package:mine_lab/views/components/will_pop_widget.dart';
import 'package:mine_lab/views/screens/auth/profile_complete/widget/profile_complete_form.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProfileCompleteRepo(apiClient: Get.find()));
    final controller =
        Get.put(ProfileCompleteController(profileRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          isProfileCompleted: true,
          title: l10n.profileComplete, // بدل MyStrings.profileComplete
          isShowBackBtn: true,
          bgColor: MyColor.primaryColor,
        ),
        body: Stack(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height),
            Positioned(
              bottom: Dimensions.space50,
              left: -25,
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  color: MyColor.smallCircleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.space15,
                vertical: Dimensions.space10,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.space15,
                  vertical: Dimensions.space10 * 1.5,
                ),
                child: const SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: CustomCard(
                    verticalPadding: Dimensions.space25,
                    borderRadius: 5,
                    child: ProfileCompleteForm(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
