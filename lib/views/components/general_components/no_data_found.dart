import 'package:flutter/material.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/views/components/text/default_text.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(MyImages.noData, height: 150, width: 150),
          const SizedBox(height: Dimensions.space15),
          DefaultText(
              text: MyStrings!.noData,
              textAlign: TextAlign.center,
              textStyle:
                  interRegularDefault.copyWith(color: MyColor.colorBlack))
        ],
      ),
    );
  }
}

