import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';

class ChooseFileItem extends StatelessWidget {
  final String fileName;

  const ChooseFileItem({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space15, vertical: 8),
      decoration: BoxDecoration(
          color: MyColor.transparentColor,
          border: Border.all(
              color: MyColor.textFieldDisableBorderColor, width: 0.5),
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.space5),
            decoration: BoxDecoration(
                color: MyColor.primaryColor.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(MyStrings!.chooseFile.tr,
                textAlign: TextAlign.center,
                style: interRegularDefault.copyWith(
                    color: MyColor.primaryColor, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(
            width: Dimensions.space15,
          ),
          Expanded(
            flex: 5,
            child: TextField(
              readOnly: true,
              cursorColor: MyColor.getTextColor(),
              style:
                  interRegularDefault.copyWith(color: MyColor.getTextColor()),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: fileName.tr),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 16),
                  hintText: fileName.tr,
                  hintStyle: interRegularDefault.copyWith(
                      color: MyColor.hintTextColor,
                      height: 1.452,
                      overflow: TextOverflow.ellipsis),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorBorder: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
