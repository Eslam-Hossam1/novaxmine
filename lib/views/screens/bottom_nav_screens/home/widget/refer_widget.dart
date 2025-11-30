import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/bottom_nav/home/home_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class ReferWidget extends StatelessWidget {
  const ReferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.space20, horizontal: Dimensions.space15),
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
        decoration: BoxDecoration(
            color: MyColor.colorWhite,
            borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(MyStrings!.referralLink,
                style:
                    interSemiBoldDefault.copyWith(color: MyColor.colorBlack)),
            const SizedBox(height: Dimensions.space10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.72,
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.space10,
                      horizontal: Dimensions.space15),
                  decoration: BoxDecoration(
                      color: MyColor.transparentColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.defaultRadius),
                      border:
                          Border.all(color: MyColor.primaryColor, width: 0.5)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      controller.referralLink.toString(),
                      style: interRegularDefault.copyWith(
                          color: MyColor.colorBlack),
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.space15),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: controller.referralLink.toString()));
                    CustomSnackBar.showCustomSnackBar(
                        errorList: [],
                        msg: [MyStrings.referralLinkCopied],
                        isError: false);
                  },
                  child: const Icon(Icons.copy,
                      color: MyColor.primaryColor, size: 20),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
