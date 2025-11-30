import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/achievements/achievement_controller.dart';
import 'package:mine_lab/data/repo/achievement/achievement_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/views/components/image/my_image_widget.dart';
import 'package:mine_lab/views/components/shimmer/match_card_shimmer.dart';
import 'package:mine_lab/views/screens/achivement/widget/achivement_card.dart';
import 'package:mine_lab/views/screens/achivement/widget/lock_achivement_card.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final ScrollController scrollController = ScrollController();
  double scrollPosition = 0;
  String unlockBadgeId = "-1";

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(AchievementRepo(apiClient: Get.find()));
    final controller =
        Get.put(AchievementController(achievementRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getAchievement();
      initScroll();
    });
  }

  void initScroll() {
    scrollController.addListener(() {
      setState(() {
        scrollPosition = scrollController.position.pixels;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: MyColor.primaryColor,
      //   title: Text(MyStrings.achievements, style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
      //   leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: MyColor.colorWhite)),
      // ),
      body: GetBuilder<AchievementController>(
        builder: (controller) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                backgroundColor: MyColor.screenBgColor,
                expandedHeight: 200,
                automaticallyImplyLeading: false,
                foregroundColor: MyColor.transparentColor,
                onStretchTrigger: () async {
                  return;
                },
                scrolledUnderElevation: 0,
                snap: true,
                elevation: 0,
                stretch: true,
                surfaceTintColor: MyColor.transparentColor,
                stretchTriggerOffset: 160,
                title: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 32,
                          width: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: MyColor.colorGrey.withValues(alpha: 0.2),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_back,
                              color: MyColor.colorBlack, size: 16),
                        ),
                      ),
                      if (scrollPosition > 110)
                        Text(MyStrings!.achievements.tr,
                            style: interRegularLarge.copyWith(
                                color: MyColor.primaryColor)),
                    ],
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: MyColor.colorWhite,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImageWidget(
                          imageUrl: controller
                                  .achievementRepo.apiClient.sharedPreferences
                                  .getString(
                                      SharedPreferenceHelper.userImageKey) ??
                              '',
                          height: 60,
                          width: 60,
                          isProfile: true,
                          radius: 30,
                        ),
                        Text(
                            controller.achievementRepo.apiClient
                                .getCurrencyOrUsername(
                                    isCurrency: false, isSymbol: false)
                                .toCapitalized(),
                            style: interRegularLarge.copyWith(
                                color: MyColor.primaryColor)),
                        Text(
                            controller.achievementRepo.apiClient.getUserEmail(),
                            style: interLightDefault.copyWith()),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(MyStrings!.achievements.tr,
                          style: interBoldDefault.copyWith(
                              color: MyColor.primaryColor)),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: controller.isLoading
                        ? List.generate(10, (index) => AchieveMentCardShimmer())
                        : [
                            controller.unlockBadges.isEmpty &&
                                    !controller.isLoading
                                ? Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        color: MyColor.colorWhite,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                          MyStrings!.noBadgesUnlocked.tr,
                                          style: interLightDefault.copyWith(
                                              color: MyColor.bodyTextColor)),
                                    ),
                                  )
                                : Column(
                                    spacing: 10,
                                    children: List.generate(
                                      controller.unlockBadges.length,
                                      (index) => AchievementCard(
                                        index: index,
                                        isOpen: unlockBadgeId ==
                                            controller.unlockBadges[index].id,
                                        isUnlocked: true,
                                        onTap: () {
                                          if (unlockBadgeId ==
                                              controller
                                                  .unlockBadges[index].id) {
                                            setState(() {
                                              unlockBadgeId = "-1";
                                            });
                                          } else {
                                            setState(() {
                                              unlockBadgeId = controller
                                                      .unlockBadges[index].id ??
                                                  "-1";
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 10),
                            Column(
                              spacing: 10,
                              children: List.generate(
                                controller.lockBadges.length,
                                (index) => LockAchievementCard(
                                  index: index,
                                  isOpen: unlockBadgeId ==
                                      controller.lockBadges[index].id,
                                  isUnlocked: false,
                                  onTap: () {
                                    if (unlockBadgeId ==
                                        controller.lockBadges[index].id) {
                                      setState(() {
                                        unlockBadgeId = "-1";
                                      });
                                    } else {
                                      setState(() {
                                        unlockBadgeId =
                                            controller.lockBadges[index].id ??
                                                "-1";
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

