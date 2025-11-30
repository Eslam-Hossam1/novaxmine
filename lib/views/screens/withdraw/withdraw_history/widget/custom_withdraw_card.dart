import 'package:flutter/material.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/column_widget/card_column.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/status/status_widget.dart';

class CustomWithdrawCard extends StatelessWidget {
  final String trxValue, date, status, amount;
  final Color statusBgColor;
  final VoidCallback onPressed;

  const CustomWithdrawCard({
    super.key,
    required this.trxValue,
    required this.date,
    required this.status,
    required this.statusBgColor,
    required this.amount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.space20, horizontal: Dimensions.space15),
          decoration: BoxDecoration(
            color: MyColor.colorWhite,
            borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
            boxShadow: MyUtils.getCardShadow(),
            border: Border.all(color: MyColor.borderColor, width: .5),
          ),
          child: Column(
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
                    isDate: true,
                    body: date,
                  ),
                ],
              ),
              const CustomDivider(space: Dimensions.space10),
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
                    needBorder: true,
                    backgroundColor: statusBgColor,
                    borderColor: statusBgColor,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
