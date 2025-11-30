import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../data/controller/deposit/add_new_deposit_controller.dart';
import '../../../components/row_widget/custom_row.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<AddNewDepositController>(builder: (controller) {
      bool showRate = controller.isShowRate();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.space20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColor.colorWhite,
              boxShadow: MyUtils.getShadow2(blurRadius: 10),
              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                CustomRow(
                  firstText: MyStrings!.depositLimit.tr,
                  lastText: controller.depositLimit,
                  first: interRegularDefault,
                  last: interSemiBoldDefault,
                ),
                CustomRow(
                  firstText: MyStrings.depositCharge.tr,
                  lastText: controller.charge,
                ),
                CustomRow(
                  firstText: MyStrings.payable.tr,
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
                            'in ${controller.paymentMethod?.currency}'.tr,
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
