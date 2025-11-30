import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/date_converter.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/bottom_nav/home/home_controller.dart';
import 'package:mine_lab/data/controller/profile/user_profile_controller.dart';
import 'package:mine_lab/data/repo/bottom_nav/home/home_repo.dart';
import 'package:mine_lab/data/repo/profile/user_profile_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/general_components/no_data_found.dart';
import 'package:mine_lab/views/components/text/default_text.dart';
import 'package:mine_lab/views/components/text/small_text.dart';
import 'package:mine_lab/views/components/will_pop_widget.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/home/widget/home_top_section.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/home/widget/kyc_warning_section.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/home/widget/refer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    MyUtils.allScreenUtil();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(HomeRepo(apiClient: Get.find()));
    Get.put(UserProfileRepo(apiClient: Get.find()));

    final controller = Get.put(HomeController(homeRepo: Get.find()));
    final userController =
        Get.put(UserProfileController(userProfileRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadDashboardData();
      userController.loadProfileInfo();
      controller.minersList.clear();
    });
  }

  @override
  void dispose() {
    MyUtils.allScreenUtil();
    super.dispose();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return WillPopWidget(
      nextRoute: '',
      child: Container(
        color: MyColor.primaryColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: MyColor.screenBgColor,
            body: GetBuilder<HomeController>(
              builder: (controller) => controller.isLoading
                  ? const CustomLoader(isFullScreen: true)
                  : RefreshIndicator(
                      color: MyColor.primaryColor,
                      onRefresh: () async {
                        controller.loadDashboardData();
                      },
                      child: SingleChildScrollView(
                        padding:
                            const EdgeInsets.only(bottom: Dimensions.space20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HomeTopSection(),
                            const SizedBox(height: Dimensions.space20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.space10),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: cardWidget(
                                        img: MyImages.moneyHistory,
                                        title: MyStrings!.totalReturned,
                                        subTitle:
                                            "${controller.currencySymbol}${MyConverter.formatNumber(controller.widgetData?.totalReturnedAmount ?? "0.0")}",
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.space10),
                                    Expanded(
                                      child: cardWidget(
                                        img: MyImages.wallet,
                                        title: MyStrings.refCommission,
                                        subTitle:
                                            "${controller.currencySymbol}${MyConverter.formatNumber(controller.widgetData?.totalReferralCommission ?? "0.0")}",
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.space10),
                                    Expanded(
                                      child: cardWidget(
                                        img: MyImages.wallet,
                                        title: MyStrings.totalEarning,
                                        subTitle:
                                            "${controller.currencySymbol}${MyConverter.formatNumber(controller.widgetData?.totalEarning ?? "0.0")}",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.space20),
                            KYCWarningSection(),
                            ReferWidget(),
                            const SizedBox(height: Dimensions.space20),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.space15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(MyStrings.latestTransaction,
                                        style: interRegularDefault.copyWith(
                                            fontWeight: FontWeight.w600)),
                                    InkWell(
                                      onTap: () => Get.toNamed(
                                          RouteHelper.transactionScreen),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        child: Text(MyStrings.viewAll,
                                            style: interRegularSmall.copyWith(
                                                color: MyColor.primaryColor)),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(height: Dimensions.space10),
                            controller.transactionList.isEmpty
                                ? const Center(child: NoDataFound())
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        controller.transactionList.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                            height: Dimensions.space10),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: Dimensions.space15),
                                        padding: const EdgeInsets.all(
                                            Dimensions.space15),
                                        decoration: BoxDecoration(
                                            color: MyColor.colorWhite,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.defaultRadius)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SmallText(
                                                        text: MyStrings.trxNo,
                                                        textColor: MyColor
                                                            .labelTextColor),
                                                    const SizedBox(
                                                        height:
                                                            Dimensions.space5),
                                                    DefaultText(
                                                        text: controller
                                                                .transactionList[
                                                                    index]
                                                                .trx ??
                                                            "",
                                                        textColor:
                                                            MyColor.colorBlack)
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SmallText(
                                                        text: MyStrings.date,
                                                        textColor: MyColor
                                                            .labelTextColor),
                                                    const SizedBox(height: 8),
                                                    DefaultText(
                                                        text: DateConverter
                                                            .isoStringToLocalDateOnly(controller
                                                                    .transactionList[
                                                                        index]
                                                                    .createdAt ??
                                                                ""),
                                                        textColor:
                                                            MyColor.colorBlack)
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const CustomDivider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SmallText(
                                                        text: MyStrings.amount,
                                                        textColor: MyColor
                                                            .labelTextColor),
                                                    const SizedBox(
                                                        height:
                                                            Dimensions.space5),
                                                    DefaultText(
                                                        text:
                                                            "${controller.transactionList[index].trxType} "
                                                            "${MyConverter.twoDecimalPlaceFixedWithoutRounding(controller.transactionList[index].amount.toString())} "
                                                            "${controller.transactionList[index].currency ?? ''}",
                                                        textColor: controller
                                                            .changeStatusColor(
                                                                controller
                                                                    .transactionList[
                                                                        index]
                                                                    .trxType
                                                                    .toString(),
                                                                index))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SmallText(
                                                        text: MyStrings
                                                            .postBalance,
                                                        textColor: MyColor
                                                            .labelTextColor),
                                                    const SizedBox(
                                                        height:
                                                            Dimensions.space5),
                                                    DefaultText(
                                                      text:
                                                          "${MyConverter.twoDecimalPlaceFixedWithoutRounding(controller.transactionList[index].postBalance.toString())} "
                                                          "${controller.transactionList[index].currency ?? ''}",
                                                      textColor:
                                                          MyColor.colorBlack,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            const CustomDivider(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SmallText(
                                                    text: MyStrings.details,
                                                    textColor:
                                                        MyColor.labelTextColor),
                                                const SizedBox(
                                                    height: Dimensions.space5),
                                                DefaultText(
                                                  text: controller
                                                          .transactionList[
                                                              index]
                                                          .details ??
                                                      "",
                                                  textColor: MyColor.colorBlack,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cardWidget(
      {required String img, required String title, required String subTitle}) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.space15, horizontal: Dimensions.space5),
      decoration: BoxDecoration(
          color: MyColor.colorWhite,
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: MyColor.screenBgColor.withValues(alpha: 0.5),
                shape: BoxShape.circle),
            child: Image.asset(img,
                color: MyColor.primaryColor, height: 15, width: 15),
          ),
          const SizedBox(height: Dimensions.space8),
          Text(
            title,
            style: interRegularDefault.copyWith(color: MyColor.labelTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.space5),
          Text(
            subTitle,
            style: interRegularExtraLarge.copyWith(
                color: MyColor.colorBlack, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
