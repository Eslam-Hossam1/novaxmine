import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/wallet/wallet_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/text-field/custom_text_field.dart';

class WalletUpdateBottomSheet {
  static void bottomSheet(BuildContext context, int index) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: MyColor.transparentColor,
        context: context,
        builder: (context) =>
            GetBuilder<WalletController>(builder: (controller) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.space10,
                        horizontal: Dimensions.space15),
                    decoration: const BoxDecoration(
                        color: MyColor.colorWhite,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
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
                                  color:
                                      MyColor.colorGrey.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space15),
                          Row(
                            children: [
                              Text(
                                "${MyStrings!.transfer.tr} ${controller.walletList[index].miner?.coinCode ?? ""} ${MyStrings.wallet.tr}",
                                style: interRegularLarge.copyWith(
                                    color: MyColor.colorBlack),
                              ),
                              Icon(Icons.arrow_right_alt_outlined,
                                  size: 15, color: MyColor.colorBlack),
                              Text(
                                MyStrings.toEarningWallet.tr,
                                style: interRegularLarge.copyWith(
                                    color: MyColor.colorBlack),
                              )
                            ],
                          ),
                          const SizedBox(height: Dimensions.space5),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "${MyStrings.balance}: ",
                                    style: interRegularSmall.copyWith(
                                        color: MyColor.colorGrey)),
                                TextSpan(
                                  text:
                                      "${MyConverter.twoDecimalPlaceFixedWithoutRounding(controller.walletList[index].balance ?? "")} "
                                      "${controller.walletList[index].miner?.coinCode ?? ""}",
                                  style: interRegularSmall.copyWith(
                                      color: MyColor.colorBlack),
                                ),
                              ],
                            ),
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          CustomTextField(
                            needLabel: false,
                            needOutlineBorder: true,
                            labelText: MyStrings.amount,
                            hintText: MyStrings.enterAmount,
                            textInputType: TextInputType.text,
                            controller: controller.amountController,
                            onChanged: (value) {
                              controller.calculateReceivedAmount(index);
                            },
                            isShowSuffixIcon: true,
                            isIcon: false,
                            isPassword: false,
                            suffixWidget: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color:
                                    MyColor.primaryColor.withValues(alpha: 0.1),
                                border: Border.all(color: MyColor.primaryColor),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.mediumRadius),
                              ),
                              child: Text(
                                controller.walletList[index].miner?.coinCode ??
                                    "",
                                style: interSemiBoldDefault.copyWith(
                                    color: MyColor.primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(MyStrings.rate.tr),
                              Text(
                                "1 ${controller.walletList[index].miner?.coinCode ?? ""} = ${MyConverter.twoDecimalPlaceFixedWithoutRounding(controller.walletList[index].miner?.rate ?? "", precision: 6)} ${controller.currency}",
                                style: interRegularSmall.copyWith(
                                    color: MyColor.colorBlack),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(MyStrings.youWillGet.tr),
                              Text(
                                "${controller.receivedAmount} ${controller.currency}",
                                style: interRegularSmall.copyWith(
                                    color: MyColor.colorBlack),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.space25),
                          RoundedButton(
                            isLoading: controller.submitLoading,
                            press: () {
                              controller.moveToProfitWallet(
                                  coin: controller.walletList[index]);
                            },
                            text: MyStrings.transfer.toTitleCase(),
                            color: MyColor.primaryColor,
                            textColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
