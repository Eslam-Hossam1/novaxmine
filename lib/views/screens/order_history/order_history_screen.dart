import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/date_converter.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
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
import 'package:mine_lab/views/components/will_pop_widget.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/mine/mining_track/widget/mining_track_bottom_sheet.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
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
      controller.initData(isOrder: true);
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
      builder: (controller) => WillPopWidget(
        nextRoute: RouteHelper.menuScreen,
        child: Scaffold(
          backgroundColor: MyColor.screenBgColor,
          appBar: AppBar(
            title: Text(MyStrings!.orderHistory,
                style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
            backgroundColor: MyColor.primaryColor,
            automaticallyImplyLeading: false,
          ),
          body: controller.isLoading
              ? const CustomLoader()
              : controller.miningTrackList.isEmpty
                  ? const Center(
                      child: NoDataFound(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.space20,
                          left: Dimensions.space15,
                          right: Dimensions.space15),
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: controller.miningTrackList.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: Dimensions.space10),
                        itemBuilder: (context, index) {
                          if (index == controller.miningTrackList.length) {
                            return controller.hasNext()
                                ? const CustomLoader(isPagination: true)
                                : const SizedBox();
                          }
                          return Container(
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
                                            text: MyStrings.orderNo,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        DefaultText(
                                            text: controller
                                                    .miningTrackList[index]
                                                    .trx ??
                                                "")
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SmallText(
                                            text: MyStrings.time,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        DefaultText(
                                            text: DateConverter
                                                .getFormatedSubtractTime(
                                                    controller
                                                            .miningTrackList[
                                                                index]
                                                            .createdAt ??
                                                        "")),
                                      ],
                                    )
                                  ],
                                ),
                                const CustomDivider(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                            text: MyStrings.amount,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        DefaultText(
                                            text:
                                                "${MyConverter.twoDecimalPlaceFixedWithoutRounding(controller.miningTrackList[index].amount ?? "")} ${controller.currency}"),
                                      ],
                                    ),
                                  ],
                                ),
                                const CustomDivider(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SmallText(
                                            text: MyStrings.status,
                                            textColor: MyColor.labelTextColor),
                                        const SizedBox(
                                            height: Dimensions.space5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions.space5,
                                              horizontal: Dimensions.space10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: controller
                                                              .miningTrackList[
                                                                  index]
                                                              .status ==
                                                          "0"
                                                      ? MyColor.colorGrey
                                                      : controller
                                                                  .miningTrackList[
                                                                      index]
                                                                  .status ==
                                                              "1"
                                                          ? MyColor.primaryColor
                                                          : controller
                                                                      .miningTrackList[
                                                                          index]
                                                                      .status ==
                                                                  "2"
                                                              ? Colors
                                                                  .orangeAccent
                                                              : controller
                                                                          .miningTrackList[
                                                                              index]
                                                                          .status ==
                                                                      "3"
                                                                  ? Colors.red
                                                                  : MyColor
                                                                      .primaryColor)),
                                          child: Text(
                                            controller.miningTrackList[index]
                                                        .status ==
                                                    "0"
                                                ? MyStrings.unPaid
                                                : controller
                                                            .miningTrackList[
                                                                index]
                                                            .status ==
                                                        "1"
                                                    ? MyStrings.approved
                                                    : controller
                                                                .miningTrackList[
                                                                    index]
                                                                .status ==
                                                            "2"
                                                        ? MyStrings.pending
                                                        : controller
                                                                    .miningTrackList[
                                                                        index]
                                                                    .status ==
                                                                "3"
                                                            ? MyStrings.rejected
                                                            : "",
                                            textAlign: TextAlign.center,
                                            style: interRegularDefault.copyWith(
                                                color: controller
                                                            .miningTrackList[
                                                                index]
                                                            .status ==
                                                        "0"
                                                    ? MyColor.colorBlack
                                                    : controller
                                                                .miningTrackList[
                                                                    index]
                                                                .status ==
                                                            "1"
                                                        ? MyColor.primaryColor
                                                        : controller
                                                                    .miningTrackList[
                                                                        index]
                                                                    .status ==
                                                                "2"
                                                            ? Colors
                                                                .orangeAccent
                                                            : controller
                                                                        .miningTrackList[
                                                                            index]
                                                                        .status ==
                                                                    "3"
                                                                ? Colors.red
                                                                : MyColor
                                                                    .primaryColor,
                                                fontSize:
                                                    Dimensions.fontExtraSmall),
                                          ),
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        MiningTrackBottomSheet.orderBottomSheet(
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
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
