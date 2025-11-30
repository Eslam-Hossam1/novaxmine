import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/plan/buy_plan/buy_plan_controller.dart';
import 'package:mine_lab/data/repo/plan/buy_plan/buy_plan_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/general_components/no_data_found.dart';
import 'package:mine_lab/views/components/text/default_text.dart';

import 'widget/buy_plan_bottom_sheet.dart';
import 'widget/plan_card.dart';

class MiningPlanScreen extends StatefulWidget {
  const MiningPlanScreen({super.key});

  @override
  State<MiningPlanScreen> createState() => _MiningPlanScreenState();
}

class _MiningPlanScreenState extends State<MiningPlanScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(BuyPlanRepo(apiClient: Get.find()));
    final controller = Get.put(BuyPlanController(buyPlanRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<BuyPlanController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColor.primaryColor,
          title: Text(MyStrings!.plan,
              style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back,
                color: MyColor.colorWhite, size: 20),
          ),
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : controller.walletList.isEmpty
                ? const Center(child: NoDataFound())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        padding: Dimensions.screenPaddingHV,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            spacing: 10,
                            children: List.generate(
                                controller.walletList.length,
                                (index) => InkWell(
                                      onTap: () {
                                        controller.changeWallet(index);
                                      },
                                      customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions.space20,
                                            vertical: Dimensions.space10),
                                        // margin: const EdgeInsets.only(right: Dimensions.space15),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:
                                                index == controller.walletIndex
                                                    ? MyColor.primaryColor
                                                    : MyColor.colorWhite,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: DefaultText(
                                          text: controller
                                                  .walletList[index].name ??
                                              "",
                                          textColor:
                                              index == controller.walletIndex
                                                  ? MyColor.colorWhite
                                                  : MyColor.colorBlack,
                                        ),
                                      ),
                                    ))),
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: controller.planList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Dimensions.space10),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space15),
                            child: PlanCard(
                              index: index,
                              title: controller.planList[index].title ?? "",
                              amount: controller.planList[index].price ?? "",
                              currency: controller.currency,
                              validationTime:
                                  "${controller.planList[index].period} "
                                  "${controller.planList[index].periodUnit == "2" ? MyStrings.years : controller.planList[index].periodUnit == "1" ? MyStrings.months : MyStrings.days}",
                              features:
                                  controller.planList[index].features ?? [],
                              onPressed: () {
                                BuyPlanBottomSheet.bottomSheet(context, index);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
