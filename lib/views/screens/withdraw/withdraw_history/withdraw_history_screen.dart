import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/date_converter.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/withdraw/withdraw_history_controller.dart';
import 'package:mine_lab/data/repo/withdraw_repo/withdraw_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/general_components/no_data_found.dart';
import 'package:mine_lab/views/screens/withdraw/withdraw_history/widget/custom_withdraw_card.dart';
import 'package:mine_lab/views/screens/withdraw/withdraw_history/widget/withdraw_history_bottom_sheet.dart';
import 'package:mine_lab/views/screens/withdraw/withdraw_history/widget/withdraw_history_top.dart';

class WithdrawHistoryScreen extends StatefulWidget {
  const WithdrawHistoryScreen({super.key});

  @override
  State<WithdrawHistoryScreen> createState() => _WithdrawHistoryScreenState();
}

class _WithdrawHistoryScreenState extends State<WithdrawHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<WithdrawHistoryController>().hasNext()) {
        Get.find<WithdrawHistoryController>().loadPaginationData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(WithdrawRepo(apiClient: Get.find()));
    final controller =
        Get.put(WithdrawHistoryController(withdrawHistoryRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initData();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<WithdrawHistoryController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.lBackgroundColor,
        appBar: AppBar(
          title: Text(MyStrings!.withdraw.tr,
              style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
          backgroundColor: MyColor.primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back,
                color: MyColor.colorWhite, size: 20),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                controller.changeSearchStatus();
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.space7),
                decoration: const BoxDecoration(
                    color: MyColor.colorWhite, shape: BoxShape.circle),
                child: Icon(controller.isSearch ? Icons.clear : Icons.search,
                    color: MyColor.primaryColor, size: 15),
              ),
            ),
            const SizedBox(width: Dimensions.space7),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.addWithdrawScreen);
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 7, right: 10, bottom: 7, top: 7),
                padding: const EdgeInsets.all(Dimensions.space7),
                decoration: const BoxDecoration(
                    color: MyColor.colorWhite, shape: BoxShape.circle),
                child: const Icon(Icons.add,
                    color: MyColor.primaryColor, size: 15),
              ),
            ),
            const SizedBox(width: Dimensions.space10),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.space20,
                    left: Dimensions.space15,
                    right: Dimensions.space15),
                child: Column(
                  children: [
                    Visibility(
                      visible: controller.isSearch,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WithdrawHistoryTop(),
                          SizedBox(height: Dimensions.space10),
                        ],
                      ),
                    ),
                    Expanded(
                      child: controller.withdrawList.isEmpty &&
                              controller.filterLoading == false
                          ? const Center(child: NoDataFound())
                          : controller.filterLoading
                              ? const CustomLoader()
                              : SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        controller.withdrawList.length + 1,
                                    controller: scrollController,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                            height: Dimensions.space10),
                                    itemBuilder: (context, index) {
                                      if (index ==
                                          controller.withdrawList.length) {
                                        return controller.hasNext()
                                            ? const CustomLoader(
                                                isPagination: true)
                                            : const SizedBox();
                                      }

                                      return CustomWithdrawCard(
                                        onPressed: () {
                                          WithdrawBottomSheet()
                                              .withdrawBottomSheet(
                                                  index,
                                                  context,
                                                  controller.currency,
                                                  controller);
                                        },
                                        trxValue: controller
                                                .withdrawList[index].trx ??
                                            "",
                                        date:
                                            DateConverter.isoToLocalDateAndTime(
                                                controller.withdrawList[index]
                                                        .createdAt ??
                                                    ""),
                                        status: controller.getStatus(index),
                                        statusBgColor:
                                            controller.getColor(index),
                                        amount:
                                            "${MyConverter.formatNumber(controller.withdrawList[index].finalAmount ?? " ")} ${controller.currency}",
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
