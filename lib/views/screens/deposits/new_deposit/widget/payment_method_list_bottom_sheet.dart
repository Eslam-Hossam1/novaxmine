import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/controller/deposit/add_new_deposit_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:mine_lab/views/components/text/header_text.dart';
import 'package:mine_lab/views/screens/deposits/new_deposit/widget/payment_method_card.dart';

class PaymentMethodListBottomSheet extends StatelessWidget {
  const PaymentMethodListBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<AddNewDepositController>(builder: (controller) {
      return Container(
        height: context.height / 1.6,
        color: MyColor.colorWhite,
        child: Column(
          children: [
            const BottomSheetHeaderRow(),
            HeaderText(
                text: MyStrings!.paymentMethod.tr,
                textStyle: interMediumOverLarge.copyWith(
                    fontSize: Dimensions.fontOverLarge,
                    fontWeight: FontWeight.normal,
                    color: MyColor.colorBlack)),
            const SizedBox(height: Dimensions.space15),
            Flexible(
              child: ListView.builder(
                itemCount: controller.methodList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return PaymentMethodCard(
                    paymentMethod: controller.methodList[index],
                    assetPath:
                        "${UrlContainer.baseUrl}/${controller.imagePath}",
                    selected: controller.methodList[index].id.toString() ==
                        controller.paymentMethod?.id.toString(),
                    press: () {
                      controller.setPaymentMethod(controller.methodList[index]);
                      Get.back();
                    },
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
