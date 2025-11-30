import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/date_converter.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/transaction/transaction_controller.dart';
import 'package:mine_lab/data/repo/transaction/transaction_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/card/custom_card.dart';
import 'package:mine_lab/views/components/general_components/no_data_found.dart';
import 'package:mine_lab/views/screens/transaction/widget/bottom_sheet.dart';
import 'package:mine_lab/views/screens/transaction/widget/custom_transaction_card.dart';
import 'package:mine_lab/views/screens/transaction/widget/filter_row_widget.dart';

import '../../components/custom_loader.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final ScrollController scrollController = ScrollController();

  fetchData() {
    Get.find<TransactionController>().loadTransaction();
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<TransactionController>().hasNext()) {
        fetchData();
      }
    }
  }

  @override
  void initState() {
    MyUtils.makePortraitOnly();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TransactionRepo(apiClient: Get.find()));
    final controller =
        Get.put(TransactionController(transactionRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialSelectedValue();
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

    return GetBuilder<TransactionController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: AppBar(
          backgroundColor: MyColor.primaryColor,
          elevation: 0,
          title: Text(MyStrings!.transaction,
              style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back,
                color: MyColor.colorWhite, size: 20),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Dimensions.space15),
              child: GestureDetector(
                onTap: () {
                  controller.changeSearchIcon();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: MyColor.colorWhite, shape: BoxShape.circle),
                  child: controller.isSearch
                      ? const Icon(Icons.clear,
                          color: MyColor.primaryColor, size: 15)
                      : Image.asset(MyImages.filter,
                          color: MyColor.primaryColor, height: 15, width: 15),
                ),
              ),
            )
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: controller.isSearch,
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(MyStrings.walletType,
                                          style: interRegularSmall.copyWith(
                                              color: MyColor.colorGrey)),
                                      const SizedBox(
                                          height: Dimensions.space10),
                                      SizedBox(
                                        height: 40,
                                        child: FilterRowWidget(
                                            bgColor: MyColor.transparentColor,
                                            fromTrx: true,
                                            text: controller
                                                    .selectedWalletType.isEmpty
                                                ? MyStrings.walletType
                                                : controller.selectedWalletType,
                                            press: () {
                                              showTrxBottomSheet(
                                                  controller.walletTypeList, 3,
                                                  context: context);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: Dimensions.space15),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(MyStrings.currency,
                                          style: interRegularSmall.copyWith(
                                              color: MyColor.colorGrey)),
                                      const SizedBox(
                                          height: Dimensions.space10),
                                      SizedBox(
                                        height: 40,
                                        child: FilterRowWidget(
                                            bgColor: MyColor.transparentColor,
                                            fromTrx: true,
                                            text: MyConverter
                                                .replaceUnderscoreWithSpace(
                                                    controller.selectedCurrency
                                                            .isEmpty
                                                        ? MyStrings.any
                                                        : controller
                                                            .selectedCurrency),
                                            press: () {
                                              showTrxBottomSheet(
                                                  controller.currencyList
                                                      .map((e) =>
                                                          e.currency.toString())
                                                      .toList(),
                                                  4,
                                                  context: context);
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: Dimensions.space10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(MyStrings.type,
                                          style: interRegularSmall.copyWith(
                                              color: MyColor.colorGrey)),
                                      const SizedBox(
                                          height: Dimensions.space10),
                                      SizedBox(
                                        height: 40,
                                        child: FilterRowWidget(
                                            bgColor: MyColor.transparentColor,
                                            fromTrx: true,
                                            text: controller
                                                    .selectedTrxType.isEmpty
                                                ? MyStrings.trxType
                                                : controller.selectedTrxType,
                                            press: () {
                                              showTrxBottomSheet(
                                                  controller
                                                      .transactionTypeList,
                                                  1,
                                                  context: context);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: Dimensions.space15),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(MyStrings.remark,
                                          style: interRegularSmall.copyWith(
                                              color: MyColor.colorGrey)),
                                      const SizedBox(
                                          height: Dimensions.space10),
                                      SizedBox(
                                        height: 40,
                                        child: FilterRowWidget(
                                            bgColor: MyColor.transparentColor,
                                            fromTrx: true,
                                            text: MyConverter
                                                .replaceUnderscoreWithSpace(
                                                    controller.selectedRemark
                                                            .isEmpty
                                                        ? MyStrings.any
                                                        : controller
                                                            .selectedRemark),
                                            press: () {
                                              showTrxBottomSheet(
                                                  controller.remarksList
                                                      .map((e) =>
                                                          e.remark.toString())
                                                      .toList(),
                                                  2,
                                                  context: context);
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: Dimensions.space10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(MyStrings.transactionNo,
                                          style: interRegularSmall.copyWith(
                                              color: MyColor.colorGrey,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: Dimensions.space5),
                                      SizedBox(
                                        height: 45,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: TextFormField(
                                          cursorColor: MyColor.primaryColor,
                                          style: interRegularSmall.copyWith(
                                              color: MyColor.colorBlack),
                                          keyboardType: TextInputType.text,
                                          controller: controller.trxController,
                                          decoration: InputDecoration(
                                              hintText: MyStrings
                                                  .enterTransactionNo,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                              hintStyle:
                                                  interRegularSmall.copyWith(
                                                      color: MyColor
                                                          .hintTextColor),
                                              filled: true,
                                              fillColor:
                                                  MyColor.transparentColor,
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: MyColor.colorGrey,
                                                      width: 0.5)),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              MyColor.colorGrey,
                                                          width: 0.5)),
                                              focusedBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: MyColor.primaryColor,
                                                      width: 0.5))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: Dimensions.space10),
                                InkWell(
                                  onTap: () {
                                    controller.filterData();
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: MyColor.primaryColor,
                                    ),
                                    child: const Icon(Icons.search_outlined,
                                        color: MyColor.colorWhite, size: 18),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: Dimensions.space20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space10),
                    Expanded(
                        child: controller.transactionList.isEmpty &&
                                controller.filterLoading == false
                            ? const Center(
                                child: NoDataFound(),
                              )
                            : controller.filterLoading
                                ? const CustomLoader()
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: ListView.separated(
                                      controller: scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          controller.transactionList.length + 1,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                              height: Dimensions.space10),
                                      itemBuilder: (context, index) {
                                        if (controller.transactionList.length ==
                                            index) {
                                          return controller.hasNext()
                                              ? Container(
                                                  height: 40,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  child: const CustomLoader())
                                              : const SizedBox();
                                        }
                                        return GestureDetector(
                                          onTap: () {},
                                          child: CustomTransactionCard(
                                              index: index,
                                              detailsText: controller
                                                      .transactionList[index]
                                                      .details ??
                                                  "",
                                              trxData: controller
                                                      .transactionList[index]
                                                      .trx ??
                                                  "",
                                              dateData: DateConverter
                                                  .isoStringToLocalDateOnly(
                                                      controller
                                                              .transactionList[
                                                                  index]
                                                              .createdAt ??
                                                          ""),
                                              amountData:
                                                  "${controller.transactionList[index].trxType} ${MyConverter.twoDecimalPlaceFixedWithoutRounding(controller.transactionList[index].amount.toString())} ${controller.transactionList[index].currency ?? ''}",
                                              postBalanceData:
                                                  "${MyConverter.twoDecimalPlaceFixedWithoutRounding(controller.transactionList[index].postBalance.toString())} ${controller.transactionList[index].currency ?? ''}"),
                                        );
                                      },
                                    ),
                                  ))
                  ],
                ),
              ),
      ),
    );
  }
}
