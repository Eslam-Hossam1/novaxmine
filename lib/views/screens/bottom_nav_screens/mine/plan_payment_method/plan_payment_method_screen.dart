import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/plan/purchased_plan/plan_payment_method_controller.dart';
import 'package:mine_lab/data/model/plan/plan_payment_method/plan_payment_method_response_model.dart';
import 'package:mine_lab/data/repo/plan/purchased_plan/purchased_plan_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/card/custom_card.dart';
import 'package:mine_lab/views/components/text-field/outlined_text_field.dart';
import 'package:mine_lab/views/components/text/label_text.dart';

import '../../../../components/custom_loader.dart';
import 'info_widget.dart';

class PlanPaymentMethodScreen extends StatefulWidget {
  final String title;
  final String amount;
  final String orderId;
  const PlanPaymentMethodScreen(
      {super.key,
      required this.title,
      required this.amount,
      required this.orderId});

  @override
  State<PlanPaymentMethodScreen> createState() =>
      _PlanPaymentMethodScreenState();
}

class _PlanPaymentMethodScreenState extends State<PlanPaymentMethodScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PurchasedPlanRepo(apiClient: Get.find()));
    final controller = Get.put(PlanPaymentMethodController(
        purchasedPlanRepo: Get.find(), amount: widget.amount));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.beforeInitLoadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<PlanPaymentMethodController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: AppBar(
            title: Text(MyStrings!.paymentMethod,
                style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
            backgroundColor: MyColor.primaryColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            )),
        body: controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      color: MyColor.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space15),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space15,
                            vertical: Dimensions.space20),
                        child: CustomCard(
                          verticalPadding: Dimensions.space20,
                          horizontalPadding: Dimensions.space15,
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: Dimensions.space15),
                                OutlinedTextField(
                                  needLabel: true,
                                  readOnly: true,
                                  labelText: MyStrings.planTitle,
                                  needOutlineBorder: true,
                                  controller:
                                      TextEditingController(text: widget.title),
                                  onChanged: (value) {},
                                ),
                                const SizedBox(height: Dimensions.space15),
                                LabelText(text: MyStrings.selectGateway),
                                const SizedBox(height: 8),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                    left: Dimensions.space15,
                                    right: Dimensions.space15,
                                  ),
                                  decoration: BoxDecoration(
                                      color: MyColor.transparentColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.defaultRadius),
                                      border: Border.all(
                                          color: MyColor.primaryColor,
                                          width: 0.5)),
                                  child: DropdownButton<Methods>(
                                    dropdownColor: MyColor.colorWhite,
                                    value: controller.paymentMethod,
                                    elevation: 8,
                                    icon: const Icon(Icons.keyboard_arrow_down,
                                        color: MyColor.primaryColor),
                                    iconDisabledColor: Colors.red,
                                    iconEnabledColor: MyColor.primaryColor,
                                    isExpanded: true,
                                    underline: Container(
                                        height: 0, color: MyColor.primaryColor),
                                    onChanged: (Methods? newValue) {
                                      controller.setPaymentMethod(newValue);
                                    },
                                    items: controller.paymentMethodList
                                        .map((Methods method) {
                                      return DropdownMenuItem<Methods>(
                                        value: method,
                                        child: Text(method.name.toString(),
                                            style: interRegularDefault),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.space15),
                                OutlinedTextField(
                                  needLabel: true,
                                  readOnly: true,
                                  labelText: MyStrings.amount,
                                  needOutlineBorder: true,
                                  controller: TextEditingController(
                                    text:
                                        "${MyConverter.twoDecimalPlaceFixedWithoutRounding(widget.amount)} ${controller.currency}",
                                  ),
                                  onChanged: (value) {},
                                ),
                                controller.mainAmount > 0
                                    ? const InfoWidget()
                                    : const SizedBox(),
                                const SizedBox(height: Dimensions.space35),
                                RoundedButton(
                                  isLoading: controller.isSubmitLoading,
                                  press: () {
                                    controller.submitPayment(
                                        amount: MyConverter
                                            .twoDecimalPlaceFixedWithoutRounding(
                                          widget.amount,
                                        ),
                                        orderId: widget.orderId);
                                  },
                                  width: MediaQuery.of(context).size.width,
                                  color: MyColor.primaryColor,
                                  text: MyStrings.submit,
                                  textColor: MyColor.colorWhite,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
