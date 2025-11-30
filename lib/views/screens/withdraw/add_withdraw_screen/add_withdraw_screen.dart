import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/withdraw/add_new_withdraw_controller.dart';
import 'package:mine_lab/data/repo/withdraw_repo/withdraw_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/image/my_image_widget.dart';
import 'package:mine_lab/views/components/text-field/custom_amount_text_field.dart';
import 'package:mine_lab/views/components/text/label_text.dart';
import 'package:mine_lab/views/screens/withdraw/add_withdraw_screen/widget/info_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AddWithdrawScreen extends StatefulWidget {
  const AddWithdrawScreen({super.key});

  @override
  State<AddWithdrawScreen> createState() => _AddWithdrawScreenState();
}

class _AddWithdrawScreenState extends State<AddWithdrawScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(WithdrawRepo(apiClient: Get.find()));
    final controller = Get.put(AddNewWithdrawController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDepositMethod();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GetBuilder<AddNewWithdrawController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: MyColor.lBackgroundColor,
          appBar: CustomAppBar(
            title: l10n.withdraw, // بدل MyStrings.withdraw
            bgColor: MyColor.primaryColor,
            action: [
              ZoomTapAnimation(
                onTap: () => Get.toNamed(RouteHelper.withdrawHistoryScreen),
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 7,
                    right: 10,
                    bottom: 7,
                    top: 7,
                  ),
                  padding: const EdgeInsets.all(Dimensions.space7),
                  decoration: const BoxDecoration(
                    color: MyColor.colorWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.history,
                    color: MyColor.primaryColor,
                    size: 15,
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.space10),
            ],
          ),
          body: SingleChildScrollView(
            padding: Dimensions.screenPadding,
            controller: scrollController,
            child: controller.isLoading
                ? const CustomLoader(isFullScreen: true)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.space10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.space10,
                          vertical: Dimensions.space10,
                        ),
                        decoration: BoxDecoration(
                          color: MyColor.primaryColor.withValues(alpha: 0.01),
                          border: Border.all(
                            color: MyColor.primaryColor,
                            width: .7,
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.defaultRadius,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(l10n.earningWallet),
                            SizedBox(width: Dimensions.space5),
                            Text(
                              "${controller.currencySym}"
                              "${MyConverter.formatNumber(controller.profitWalletBalance, precision: 4)}",
                              style: interSemiBoldDefault.copyWith(
                                color: MyColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.space30),
                      LabelText(text: l10n.withdrawMethod),
                      SizedBox(height: Dimensions.space5),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.space15,
                          vertical: Dimensions.space10,
                        ),
                        color: MyColor.colorWhite.withValues(alpha: 0.05),
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              controller.withdrawMethodList.length,
                              (index) {
                                final method =
                                    controller.withdrawMethodList[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.space5,
                                  ),
                                  margin: EdgeInsets.only(
                                    bottom: index ==
                                            controller
                                                    .withdrawMethodList.length -
                                                1
                                        ? 0
                                        : Dimensions.space10,
                                  ),
                                  color: MyColor.colorWhite
                                      .withValues(alpha: 0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            MyImageWidget(
                                              imageUrl:
                                                  "${controller.imagePath}/${method.image}",
                                              width: 40,
                                              height: 40,
                                              boxFit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: Dimensions.space5,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                method.name ?? "",
                                                style: interRegularDefault
                                                    .copyWith(
                                                  fontSize: 16,
                                                  color: MyColor.bodyTextColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Radio(
                                        value: method.id,
                                        groupValue:
                                            controller.withdrawMethod?.id,
                                        activeColor: MyColor.primaryColor,
                                        fillColor: WidgetStateProperty.all(
                                          MyColor.primaryColor,
                                        ),
                                        onChanged: (value) {
                                          printX(
                                            "${controller.imagePath}/${method.image}",
                                          );
                                          controller.setWithdrawMethod(method);
                                          scrollController.animateTo(
                                            scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.space20),
                      CustomAmountTextField(
                        labelText: l10n.amount,
                        hintText: l10n.enterAmount,
                        inputAction: TextInputAction.done,
                        currency: controller.currency,
                        controller: controller.amountController,
                        onChanged: (value) {
                          if (value.toString().isEmpty) {
                            controller.changeInfoWidgetValue(0);
                          } else {
                            final amount =
                                double.tryParse(value.toString()) ?? 0;
                            controller.changeInfoWidgetValue(amount);
                          }
                          return;
                        },
                      ),
                      (controller.mainAmount > 0 &&
                              controller.withdrawMethod?.id != null)
                          ? const AddMoneyInfoWidget()
                          : const SizedBox(),
                      SizedBox(height: Dimensions.space40),
                      RoundedButton(
                        text: l10n.submit,
                        isLoading: controller.submitLoading,
                        press: () {
                          controller.submitWithdrawRequest(context);
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
