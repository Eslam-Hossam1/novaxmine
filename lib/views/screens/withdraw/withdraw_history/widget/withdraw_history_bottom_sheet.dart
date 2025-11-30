import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/withdraw/withdraw_history_controller.dart';
import 'package:mine_lab/data/model/withdraw/withdraw_history_response_model.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:mine_lab/views/components/column_widget/label_column.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/row_widget/bottom_sheet_top_row.dart';
import 'package:mine_lab/views/components/text/bottom_sheet_label_text.dart';

class WithdrawBottomSheet {
  void withdrawBottomSheet(int index, BuildContext context, String currency,
      WithdrawHistoryController controller) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    CustomBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BottomSheetTopRow(header: MyStrings!.withdrawInformation),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 6,
                  child: LabelColumn(
                      header: MyStrings.amount,
                      body:
                          '${controller.curSymbol}${MyConverter.formatNumber(controller.withdrawList[index].amount ?? '0')}')),
              Expanded(
                  flex: 2,
                  child: LabelColumn(
                      alignmentEnd: true,
                      header: MyStrings.charge,
                      body:
                          '${controller.curSymbol}${MyConverter.formatNumber(controller.withdrawList[index].charge ?? '')}')),
            ],
          ),
          const SizedBox(height: Dimensions.space20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: LabelColumn(
                      header: MyStrings.payableAmount,
                      body:
                          '${controller.curSymbol}${MyConverter.formatNumber(controller.withdrawList[index].afterCharge ?? '')}')),
              Expanded(
                  flex: 4,
                  child: LabelColumn(
                      alignmentEnd: true,
                      header: MyStrings.conversionRate,
                      body:
                          '1 ${controller.currency} = ${MyConverter.formatNumber(controller.withdrawList[index].rate ?? '')} ${controller.withdrawList[index].currency}')),
            ],
          ),
          const SizedBox(height: Dimensions.space20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 4,
                  child: LabelColumn(
                      header: MyStrings.finalAmount,
                      body:
                          '${controller.curSymbol}${MyConverter.formatNumber(controller.withdrawList[index].finalAmount ?? '0')}')),
              Expanded(
                  flex: 3,
                  child: LabelColumn(
                      alignmentEnd: true,
                      header: MyStrings.paymentMethod,
                      body: MyConverter.formatNumber(
                          controller.withdrawList[index].method?.name ?? ''))),
            ],
          ),
          Visibility(
            visible: controller.withdrawList[index].details != null &&
                controller.withdrawList[index].details!.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomDivider(space: Dimensions.space15),
                BottomSheetLabelText(text: MyStrings.details.tr),
                const SizedBox(height: Dimensions.space15),
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        controller.withdrawList[index].details?.length ?? 0,
                    itemBuilder: (BuildContext context, int detailsIndex) {
                      Details? details =
                          controller.withdrawList[index].details?[detailsIndex];
                      return Container(
                        margin:
                            const EdgeInsets.only(bottom: Dimensions.space15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4)),
                        child: details?.type == 'file'
                            ? InkWell(
                                onTap: () {
                                  controller.downloadAttachment(
                                      details?.value ?? '', context);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      (details?.name
                                                  .toString()
                                                  .capitalizeFirst ??
                                              '')
                                          .tr,
                                      style: interRegularDefault.copyWith(
                                          color: MyColor.bodyTextColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.file_download,
                                          size: 17,
                                          color: MyColor.primaryColor,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          MyStrings.attachment.tr,
                                          style: interRegularDefault.copyWith(
                                              color: MyColor.primaryColor),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : LabelColumn(
                                header:
                                    (details?.name ?? '').tr.capitalizeFirst ??
                                        '',
                                body: details?.value.toString() ?? ''),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ).customBottomSheet(context);
  }
}
