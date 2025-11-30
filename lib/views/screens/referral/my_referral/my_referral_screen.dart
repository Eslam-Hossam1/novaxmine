import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/referral/my_referral_controller.dart';
import 'package:mine_lab/data/repo/referral/my_referral_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/general_components/no_data_found.dart';
import 'package:mine_lab/views/components/text/default_text.dart';
import 'package:mine_lab/views/components/text/small_text.dart';

class MyReferralScreen extends StatefulWidget {
  const MyReferralScreen({super.key});

  @override
  State<MyReferralScreen> createState() => _MyReferralScreenState();
}

class _MyReferralScreenState extends State<MyReferralScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MyReferralRepo(apiClient: Get.find()));
    final controller =
        Get.put(MyReferralController(myReferralRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadMyReferralData();
    });
  }

  @override
  void dispose() {
    MyUtils.allScreenUtil();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColor.primaryColor,
        title: Text(MyStrings!.myReferredUsers,
            style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon:
              const Icon(Icons.arrow_back, color: MyColor.colorWhite, size: 20),
        ),
      ),
      body: GetBuilder<MyReferralController>(
        builder: (controller) => controller.isLoading
            ? const CustomLoader()
            : controller.myReferralsList.isEmpty
                ? const Center(child: NoDataFound())
                : SingleChildScrollView(
                    padding: Dimensions.screenPaddingHV,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.myReferralsList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: Dimensions.space10),
                      itemBuilder: (context, index) => Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space15,
                            vertical: Dimensions.space20),
                        decoration: BoxDecoration(
                            color: MyColor.colorWhite,
                            borderRadius: BorderRadius.circular(
                                Dimensions.defaultRadius)),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: MyColor.transparentColor,
                              radius: 20,
                              backgroundImage: AssetImage(MyImages.avatar),
                            ),
                            const SizedBox(width: Dimensions.space10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SmallText(
                                          text: MyStrings.user,
                                          textColor: MyColor.colorGrey),
                                      SmallText(
                                          text: MyStrings.level,
                                          textColor: MyColor.colorGrey),
                                    ],
                                  ),
                                  const SizedBox(height: Dimensions.space5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DefaultText(
                                        text: controller.myReferralsList[index]
                                                .username ??
                                            "",
                                      ),
                                      const SizedBox(width: Dimensions.space5),
                                      DefaultText(
                                        text: MyConverter.getTrailingExtension(
                                            int.tryParse(controller
                                                        .myReferralsList[index]
                                                        .level ??
                                                    '0') ??
                                                0),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
