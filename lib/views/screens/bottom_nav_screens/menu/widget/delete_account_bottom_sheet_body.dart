import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/menu_controller/menu_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class DeleteAccountBottomsheetBody extends StatefulWidget {
  const DeleteAccountBottomsheetBody({
    super.key,
  });

  @override
  State<DeleteAccountBottomsheetBody> createState() =>
      _DeleteAccountBottomsheetBodyState();
}

class _DeleteAccountBottomsheetBodyState
    extends State<DeleteAccountBottomsheetBody> {
  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<MyMenuController>(builder: (controller) {
      return LayoutBuilder(builder: (context, box) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(Dimensions.space15),
            decoration: const BoxDecoration(
                color: MyColor.colorWhite,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.space25),
                Image.asset(
                  MyImages.userdeleteImage,
                  width: 120,
                  height: 120,
                  // fit: BoxFit.cover,
                ),
                const SizedBox(height: Dimensions.space25),
                Text(
                  MyStrings!.deleteYourAccount.tr,
                  style: interMediumDefault.copyWith(
                      color: MyColor.colorBlack,
                      fontSize: Dimensions.fontLarge),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.space25),
                Text(
                  MyStrings.deleteBottomSheetSubtitle.tr,
                  style: interRegularDefault.copyWith(
                      color: MyColor.colorBlack.withValues(alpha: 0.8),
                      fontSize: Dimensions.fontLarge),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.space40),
                GestureDetector(
                  onTap: () {
                    controller.removeAccount();
                  },
                  child: Container(
                    width: context.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space15,
                        vertical: Dimensions.space17),
                    decoration: BoxDecoration(
                      color: MyColor.colorRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: controller.removeLoading
                          ? const SizedBox(
                              width: Dimensions.fontExtraLarge + 3,
                              height: Dimensions.fontExtraLarge + 3,
                              child: CircularProgressIndicator(
                                  color: MyColor.colorWhite, strokeWidth: 2),
                            )
                          : Text(
                              MyStrings.deleteAccount.tr,
                              style: interMediumDefault.copyWith(
                                  color: MyColor.colorWhite,
                                  fontSize: Dimensions.fontLarge),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.space10),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: context.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: MyColor.colorGrey3,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        MyStrings.cancel.tr,
                        style: interMediumDefault.copyWith(
                            color: MyColor.colorBlack,
                            fontSize: Dimensions.fontLarge),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
