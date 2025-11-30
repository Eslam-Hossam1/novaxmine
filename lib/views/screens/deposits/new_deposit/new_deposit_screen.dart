import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/image/my_image_widget.dart';
import 'package:mine_lab/views/components/text-field/custom_amount_text_field.dart';
import 'package:mine_lab/views/components/text/label_text.dart';
import 'package:mine_lab/views/screens/deposits/new_deposit/widget/payment_method_list_bottom_sheet.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../data/controller/deposit/add_new_deposit_controller.dart';
import '../../../../data/repo/deposit/deposit_repo.dart';
import '../../../../data/services/api_service.dart';
import '../../../components/buttons/rounded_button.dart';
import 'info_widget.dart';

class NewDepositScreen extends StatefulWidget {
  const NewDepositScreen({super.key});

  @override
  State<NewDepositScreen> createState() => _NewDepositScreenState();
}

class _NewDepositScreenState extends State<NewDepositScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DepositRepo(apiClient: Get.find()));
    final controller =
        Get.put(AddNewDepositController(depositRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getDepositMethod();
    });
  }

  @override
  void dispose() {
    Get.find<AddNewDepositController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = AppLocalizations.of(context);

    return GetBuilder<AddNewDepositController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          title: MyStrings!.deposit,
          bgColor: MyColor.primaryColor,
          action: [
            // ActionButtonIconWidget(
            //   pressed: () {
            //     Get.toNamed(RouteHelper.depositsScreen);
            //   },
            //   icon: Icons.history,
            // ),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: MyColor.colorWhite,
                          boxShadow: MyUtils.getShadow2(blurRadius: 10),
                          borderRadius:
                              BorderRadius.circular(Dimensions.mediumRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelText(text: MyStrings.paymentMethod.tr),
                            const SizedBox(height: Dimensions.space10),
                            GestureDetector(
                              onTap: () {
                                CustomBottomSheet(
                                        child: PaymentMethodListBottomSheet())
                                    .customBottomSheet(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: MyColor.colorWhite,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: MyColor.borderColor, width: .5),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        MyImageWidget(
                                          imageUrl:
                                              "${UrlContainer.baseUrl}/${controller.imagePath}/${controller.paymentMethod?.method?.image}",
                                          width: 30,
                                          height: 30,
                                          boxFit: BoxFit.fitWidth,
                                          radius: 4,
                                        ),
                                        const SizedBox(
                                            width: Dimensions.space10),
                                        Text(
                                          (controller.paymentMethod?.method
                                                      ?.name ??
                                                  '')
                                              .tr,
                                          style: interRegularDefault,
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_drop_down,
                                        color: MyColor.colorGrey),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.space15),
                            CustomAmountTextField(
                              labelText: MyStrings.amount.tr,
                              hintText: MyStrings.enterAmount.tr,
                              inputAction: TextInputAction.done,
                              currency: controller.currency,
                              controller: controller.amountController,
                              onChanged: (value) {
                                if (value.toString().isEmpty) {
                                  controller.changeInfoWidgetValue(0);
                                } else {
                                  double amount =
                                      double.tryParse(value.toString()) ?? 0;
                                  controller.changeInfoWidgetValue(amount);
                                }
                                return;
                              },
                            ),
                            const SizedBox(height: Dimensions.space10),
                          ],
                        ),
                      ),
                      if (controller.paymentMethod?.name !=
                              MyStrings.selectOne &&
                          controller.mainAmount > 0) ...[InfoWidget()],
                      const SizedBox(height: 35),
                      RoundedButton(
                        isLoading: controller.submitLoading,
                        text: MyStrings.submit,
                        press: () {
                          controller.submitDeposit();
                        },
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
