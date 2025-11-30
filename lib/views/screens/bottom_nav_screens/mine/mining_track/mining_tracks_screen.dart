import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/plan/mining_tracks/mining_tracks_controller.dart';
import 'package:mine_lab/data/repo/plan/mining_track/mining_track_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/general_components/no_data_found.dart';
import 'package:mine_lab/views/components/text/default_text.dart';
import 'package:mine_lab/views/components/text/small_text.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/mine/mining_track/widget/mining_track_bottom_sheet.dart';

class MiningTracksScreen extends StatefulWidget {
  const MiningTracksScreen({super.key});

  @override
  State<MiningTracksScreen> createState() => _MiningTracksScreenState();
}

class _MiningTracksScreenState extends State<MiningTracksScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<MiningTracksController>().hasNext()) {
        Get.find<MiningTracksController>().loadPaginationData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MiningTrackRepo(apiClient: Get.find()));
    final controller =
        Get.put(MiningTracksController(miningTrackRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initData(isOrder: false);
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    MyUtils.allScreenUtil();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<MiningTracksController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: AppBar(
          title: Text(MyStrings!.miningTracks,
              style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
          backgroundColor: MyColor.primaryColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            InkWell(
              onTap: () => Get.toNamed(RouteHelper.miningPlanScreen),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space10),
                  margin: const EdgeInsets.symmetric(
                      vertical: Dimensions.space10,
                      horizontal: Dimensions.space15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: MyColor.colorWhite,
                      borderRadius:
                          BorderRadius.circular(Dimensions.defaultRadius)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(MyImages.miningTracks,
                          color: MyColor.primaryColor, height: 17, width: 17),
                      const SizedBox(width: Dimensions.space10),
                      SmallText(
                          text: MyStrings.startMining,
                          textAlign: TextAlign.center,
                          textColor: MyColor.primaryColor),
                    ],
                  )),
            )
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : controller.miningTrackList.isEmpty
                ? const Center(
                    child: NoDataFound(),
                  )
                : RefreshIndicator(
                    color: MyColor.primaryColor,
                    onRefresh: () async {
                      controller.initData(isOrder: false);
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics()),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.space15,
                          vertical: Dimensions.space15),
                      itemCount: controller.miningTrackList.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: Dimensions.space10),
                      itemBuilder: (context, index) {
                        if (index == controller.miningTrackList.length) {
                          return controller.hasNext()
                              ? const CustomLoader(isPagination: true)
                              : const SizedBox();
                        }
                        final track = controller.miningTrackList[index];
                        return InkWell(
                          onTap: () {
                            MiningTrackBottomSheet.bottomSheet(context, index);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space15,
                                vertical: Dimensions.space12),
                            decoration: BoxDecoration(
                                color: MyColor.colorWhite,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.defaultRadius)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SmallText(
                                            text: MyStrings.planTitle,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        DefaultText(
                                            text: controller
                                                    .miningTrackList[index]
                                                    .planDetails
                                                    ?.title ??
                                                "")
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SmallText(
                                            text: MyStrings.returnDay,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        DefaultText(
                                          text:
                                              "${MyConverter.minMaxReturn(min: track.minReturnPerDay ?? '', max: track.maxReturnPerDay ?? '')} ${track.currencyCode}",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const CustomDivider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SmallText(
                                            text: MyStrings.totalDays,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        DefaultText(text: track.period ?? ""),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SmallText(
                                            text: MyStrings.remainingDays,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        DefaultText(
                                          text: track.periodRemain ?? '',
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const CustomDivider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SmallText(
                                            text: MyStrings.totalReceived,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        DefaultText(
                                            text:
                                                "${MyConverter.formatNumber(track.totalEarnedAmount ?? '', precision: 2)}${track.currencyCode}"),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        MiningTrackBottomSheet.bottomSheet(
                                            context, index);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.space10,
                                            vertical: Dimensions.space5),
                                        decoration: BoxDecoration(
                                          color: MyColor.primaryColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.mediumRadius),
                                        ),
                                        child: Text(
                                          MyStrings.details,
                                          style: interRegularDefault.copyWith(
                                              color: MyColor.colorWhite),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
