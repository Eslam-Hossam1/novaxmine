import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/text-field/search_text_field.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/util.dart';
import '../../../../data/controller/deposit/deposit_history_controller.dart';

class DepositHistoryTop extends StatefulWidget {
  const DepositHistoryTop({super.key});

  @override
  State<DepositHistoryTop> createState() => _DepositHistoryTopState();
}

class _DepositHistoryTopState extends State<DepositHistoryTop> {
  @override
  Widget build(BuildContext context) {
    final MyStrings = AppLocalizations.of(context);
    return GetBuilder<DepositController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.space15, vertical: Dimensions.space15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
          color: MyColor.getCardBgColor(),
          boxShadow: MyUtils.getBottomSheetShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(MyStrings!.trxNo.tr,
                style: interRegularSmall.copyWith(
                    color: MyColor.labelTextColor,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: Dimensions.space5 + 3),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: SearchTextField(
                        needOutlineBorder: true,
                        controller: controller.searchController,
                        onChanged: (value) {
                          return;
                        },
                        hintText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.space10),
                  InkWell(
                    onTap: () {
                      controller.searchDepositTrx();
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
            )
          ],
        ),
      ),
    );
  }
}
