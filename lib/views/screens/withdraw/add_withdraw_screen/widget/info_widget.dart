import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/data/controller/withdraw/add_new_withdraw_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/mine/plan_payment_method/custom_row.dart';

class AddMoneyInfoWidget extends StatelessWidget {
  const AddMoneyInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<AddNewWithdrawController>(builder: (controller) {
      bool showRate = controller.isShowRate();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.space20),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: MyColor.lCardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: MyColor.borderColor, width: 1)),
            padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                CustomRow(
                  firstText: MyStrings!.withdrawLimit.tr,
                  lastText: controller.withdrawLimit,
                ),
                CustomRow(
                  firstText: MyStrings.charge.tr,
                  lastText: controller.charge,
                ),
                CustomRow(
                  firstText: MyStrings.receivable.tr,
                  lastText: controller.payableText,
                  showDivider: showRate,
                ),
                showRate
                    ? CustomRow(
                        firstText: MyStrings.conversionRate.tr,
                        lastText: controller.conversionRate,
                        showDivider: showRate,
                      )
                    : const SizedBox.shrink(),
                showRate
                    ? CustomRow(
                        firstText:
                            '${MyStrings.in_.tr} ${controller.withdrawMethod?.currency}',
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
