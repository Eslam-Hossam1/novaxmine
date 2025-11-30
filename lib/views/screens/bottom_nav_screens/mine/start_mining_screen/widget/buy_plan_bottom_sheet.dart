import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/plan/buy_plan/buy_plan_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/views/components/text-field/outlined_text_field.dart';
import 'package:mine_lab/views/components/text/label_text.dart';

class BuyPlanBottomSheet {
  static void bottomSheet(BuildContext context, int index) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: MyColor.transparentColor,
      context: context,
      builder: (context) => GetBuilder<BuyPlanController>(
        builder: (buyPlanController) => SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.space15, horizontal: Dimensions.space15),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: MyColor.colorWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                          color: MyColor.colorGrey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  Text(MyStrings!.newMine,
                      style: interRegularLarge.copyWith(
                          color: MyColor.colorBlack)),
                  const CustomDivider(space: Dimensions.space15),
                  OutlinedTextField(
                    needLabel: true,
                    labelText: MyStrings.planTitle,
                    readOnly: true,
                    needOutlineBorder: true,
                    controller: TextEditingController(
                        text: buyPlanController.planList[index].title ?? ""),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: Dimensions.space15),
                  OutlinedTextField(
                    needLabel: true,
                    readOnly: true,
                    labelText: MyStrings.planPrice,
                    needOutlineBorder: true,
                    controller: TextEditingController(
                        text:
                            "${MyConverter.twoDecimalPlaceFixedWithoutRounding(buyPlanController.planList[index].price ?? "")} ${buyPlanController.currency}"),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: Dimensions.space15),
                  LabelText(text: MyStrings.selectGateway),
                  const SizedBox(height: Dimensions.textToTextSpace),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                          left: Dimensions.space15, right: Dimensions.space15),
                      decoration: BoxDecoration(
                          color: MyColor.transparentColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.defaultRadius),
                          border: Border.all(
                              color: buyPlanController.selectPaymentSystem ==
                                      MyStrings.selectOne
                                  ? MyColor.lineColor
                                  : MyColor.primaryColor,
                              width: 1)),
                      child: DropdownButton(
                        dropdownColor: MyColor.colorWhite,
                        value: buyPlanController.selectPaymentSystem,
                        elevation: 8,
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: MyColor.primaryColor),
                        iconDisabledColor: Colors.red,
                        iconEnabledColor: MyColor.primaryColor,
                        isExpanded: true,
                        underline:
                            Container(height: 0, color: MyColor.primaryColor),
                        onChanged: (value) {
                          buyPlanController.setPaymentMethod(value!);
                        },
                        items: buyPlanController.paymentSystemList.map((data) {
                          return DropdownMenuItem(
                            value: data,
                            child: Text(data, style: interRegularDefault),
                          );
                        }).toList(),
                      )),
                  const CustomDivider(space: Dimensions.space15),
                  RoundedButton(
                    isLoading: buyPlanController.purchaseLoading,
                    color: MyColor.primaryColor,
                    text: MyStrings.submit,
                    textColor: MyColor.colorWhite,
                    press: () {
                      if (buyPlanController.selectPaymentSystem ==
                          MyStrings.selectOne) {
                        CustomSnackBar.error(
                            errorList: [(MyStrings.selectAGateway)]);
                        return;
                      }
                      buyPlanController.planPurchase(
                          planId: buyPlanController.planList[index].id ?? 0);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
