import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/styles.dart';

class NoDataWidget extends StatelessWidget {
  final double margin;
  String? text;
  NoDataWidget({
    super.key,
    this.margin = 4,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(MyImages.noData, height: 120, width: 120),
          const SizedBox(height: Dimensions.space3),
          Text(
            MyStrings!.noDataToShow.tr,
            style: interRegularDefault.copyWith(color: MyColor.colorBlack),
          )
        ],
      ),
    );
  }
}

