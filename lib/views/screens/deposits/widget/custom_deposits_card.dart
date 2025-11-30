import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/util.dart';
import '../../../components/column_widget/card_column.dart';

class CustomDepositsCard extends StatelessWidget {
  final String trxValue, date, status, amount;
  final Color statusBgColor;
  final VoidCallback onPressed;

  const CustomDepositsCard(
      {super.key,
      required this.trxValue,
      required this.date,
      required this.status,
      required this.statusBgColor,
      required this.amount,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final MyStrings = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.space15, horizontal: Dimensions.space15),
          decoration: BoxDecoration(
              color: MyColor.colorWhite,
              borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
              boxShadow: MyUtils.getCardShadow()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardColumn(
                    header: MyStrings!.trxNo,
                    body: trxValue,
                  ),
                  CardColumn(
                    alignmentEnd: true,
                    header: MyStrings.date,
                    body: date,
                  ),
                ],
              ),
              const CustomDivider(space: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardColumn(
                    header: MyStrings.amount,
                    body: amount,
                  ),
                  StatusWidget(
                    status: status,
                    color: statusBgColor,
                  )
                ],
              ),
            ],
          )),
    );
  }
}

class StatusWidget extends StatelessWidget {
  final String status;
  final Color color;

  const StatusWidget({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.space3, horizontal: Dimensions.space8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: color.withValues(alpha: .1),
            border: Border.all(color: color, width: .5)),
        child:
            Text(status.tr, style: interRegularSmall.copyWith(color: color)));
  }
}
