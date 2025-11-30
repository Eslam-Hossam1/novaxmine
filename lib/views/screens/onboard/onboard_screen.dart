import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/screens/onboard/widget/circular_button_with_indicator.dart';
import 'package:mine_lab/views/screens/onboard/widget/onboard_content.dart';

import '../../../core/route/route.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../data/controller/onboard/onboard_controller.dart';
import '../../../data/services/api_service.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(OnboardController());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ApiClient>().storeAppOpeningStatus(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = AppLocalizations.of(context);
    Size size = MediaQuery.of(context).size;

    return GetBuilder<OnboardController>(
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColor.colorWhite,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            controller.currentIndex == controller.onboardTitleList.length - 1
                ? const SizedBox.shrink()
                : SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: size.height * .02, right: size.width * .06),
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(RouteHelper.loginScreen);
                        },
                        child: Text(MyStrings!.skip.tr,
                            style: interSemiBoldLarge.copyWith(
                                color: MyColor.titleColor)),
                      ),
                    ),
                  ),
            Expanded(
              child: PageView.builder(
                controller: controller.controller,
                itemCount: controller.onboardTitleList.length,
                onPageChanged: (int index) {
                  setState(() {
                    controller.currentIndex = index;
                  });
                },
                itemBuilder: (_, index) {
                  return OnboardContent(
                    controller: controller,
                    title: controller.onboardTitleList[index].toString(),
                    subTitle: controller.onboardSubtitleList[index].toString(),
                    index: index,
                    image: controller.onboardImageList[index],
                  );
                },
              ),
            ),
            const SizedBox(height: Dimensions.space10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.onboardTitleList.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 10,
                  width: controller.currentIndex == index
                      ? Dimensions.space30
                      : Dimensions.space10,
                  margin: const EdgeInsets.only(right: Dimensions.space5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: controller.currentIndex == index
                          ? MyColor.primaryColor
                          : MyColor.bodyTextColor),
                ),
              ),
            ),
            CircularButtonWithIndicator(controller: controller)
          ],
        ),
      ),
    );
  }
}
