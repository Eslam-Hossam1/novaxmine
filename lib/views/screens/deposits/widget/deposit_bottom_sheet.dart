import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/custom_container/bottom_sheet_container.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../data/controller/deposit/deposit_history_controller.dart';
import '../../../components/bottom-sheet/custom_bottom_sheet.dart';
import '../../../components/column_widget/bottom_sheet_column.dart';
import '../../../components/row_widget/bottom_sheet_top_row.dart';

class DepositBottomSheet {
  static void depositBottomSheet(BuildContext context, int index) {
    final MyStrings = AppLocalizations.of(context);
    CustomBottomSheet(
      child: GetBuilder<DepositController>(
          builder: (controller) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BottomSheetTopRow(header: MyStrings!.depositInfo),
                  BottomSheetContainer(
                      child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: BottomSheetColumn(
                                  header: MyStrings.paymentMethod,
                                  body: controller
                                          .depositList[index].gateway?.name ??
                                      '')),
                          Expanded(
                              child: BottomSheetColumn(
                                  alignmentEnd: true,
                                  header: MyStrings.amount,
                                  body:
                                      '${controller.curSymbol}${MyConverter.formatNumber(controller.depositList[index].amount ?? '')}')),
                        ],
                      ),
                      const SizedBox(height: Dimensions.space20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: BottomSheetColumn(
                                  header: MyStrings.depositCharge,
                                  body:
                                      '${controller.curSymbol}${MyConverter.formatNumber(controller.depositList[index].charge ?? '0')}')),
                          Expanded(
                              child: BottomSheetColumn(
                                  alignmentEnd: true,
                                  header: MyStrings.payableAmount,
                                  body:
                                      '${controller.curSymbol}${MyConverter.sum(controller.depositList[index].amount ?? '0', controller.depositList[index].charge ?? '0')}')),
                        ],
                      ),
                      const SizedBox(height: Dimensions.space20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: BottomSheetColumn(
                                  header: MyStrings.conversionRate,
                                  body:
                                      "1 ${controller.currency} = ${MyConverter.formatNumber(controller.depositList[index].rate ?? "")} ${controller.depositList[index].methodCurrency}")),
                          Expanded(
                              child: BottomSheetColumn(
                                  alignmentEnd: true,
                                  header: MyStrings.finalAmount,
                                  body:
                                      '${controller.curSymbol}${MyConverter.formatNumber(controller.depositList[index].finalAmo ?? '')}')),
                        ],
                      ),
                    ],
                  )),
                ],
              )),
    ).customBottomSheet(context);
  }
}
