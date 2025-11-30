import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/data/controller/plan/purchased_plan/plan_payment_method_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

import 'custom_row.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<PlanPaymentMethodController>(builder: (controller) {
      bool showRate = controller.isShowRate();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.space20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: MyColor.transparentColor,
                borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                border: Border.all(color: MyColor.lineColor)),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                CustomRow(
                  firstText: MyStrings!.depositLimit,
                  lastText: controller.depositLimit,
                ),
                CustomRow(
                  firstText: MyStrings.charge,
                  lastText: controller.charge,
                ),
                CustomRow(
                  firstText: MyStrings.payable,
                  lastText: controller.paymentMethod?.method?.crypto == "0"
                      ? MyConverter.twoDecimalPlaceFixedWithoutRounding(
                          controller.payableText)
                      : controller.payableText,
                  showDivider: showRate,
                ),
                showRate
                    ? CustomRow(
                        firstText: MyStrings.conversionRate,
                        lastText: controller.conversionRate,
                        showDivider: showRate,
                      )
                    : const SizedBox.shrink(),
                showRate
                    ? CustomRow(
                        firstText:
                            '${MyStrings.in_} ${controller.paymentMethod?.currency}',
                        lastText: controller.inLocal,
                        showDivider: false,
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ],
      );
    });
  }
}
