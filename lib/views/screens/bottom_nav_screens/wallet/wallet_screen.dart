import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/wallet/wallet_controller.dart';
import 'package:mine_lab/data/repo/wallet_repo/wallet_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/card/custom_card.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/general_components/no_data_found.dart';
import 'package:mine_lab/views/components/image/my_network_image_widget.dart';
import 'package:mine_lab/views/components/text/small_text.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/wallet/widget/wallet_update_bottom_sheet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(WalletRepo(apiClient: Get.find()));
    final controller = Get.put(WalletController(walletRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadWalletData();
    });
  }

  @override
  void dispose() {
    MyUtils.allScreenUtil();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColor.primaryColor,
          title: Text(MyStrings!.minerWallets,
              style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
          automaticallyImplyLeading: false),
      body: GetBuilder<WalletController>(
        builder: (controller) => controller.isLoading
            ? const CustomLoader()
            : controller.walletList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const NoDataFound(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          child: RoundedButton(
                            text: MyStrings!.buyMinningPlan,
                            press: () {
                              Get.toNamed(RouteHelper.miningPlanScreen);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: MyColor.primaryColor,
                    onRefresh: () async {
                      controller.loadWalletData();
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.space15,
                          vertical: Dimensions.space15),
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics()),
                      itemCount: controller.walletList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: Dimensions.space10),
                      itemBuilder: (context, index) {
                        return CustomCard(
                          onPressed: () {
                            controller.setTextFieldData(index);
                            WalletUpdateBottomSheet.bottomSheet(context, index);
                          },
                          cardBgColor: MyColor.colorWhite,
                          verticalPadding: Dimensions.space15,
                          horizontalPadding: Dimensions.space15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "${controller.walletList[index].miner?.coinCode ?? ""} ${MyStrings.wallet}",
                                      style: interRegularDefault.copyWith(
                                          color: MyColor.colorBlack)),
                                  InkWell(
                                    onTap: () {
                                      controller.setTextFieldData(index);
                                      WalletUpdateBottomSheet.bottomSheet(
                                          context, index);
                                    },
                                    child: MyNetworkImageWidget(
                                      imageUrl:
                                          "${UrlContainer.mineWalletImagePath}${controller.walletList[index].miner?.coinImage}",
                                      width: Dimensions.space40,
                                      height: Dimensions.space40,
                                    ),
                                  )
                                ],
                              ),
                              const CustomDivider(space: Dimensions.space12),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SmallText(
                                              text: MyStrings.balance,
                                              textColor:
                                                  MyColor.labelTextColor),
                                          const SizedBox(
                                              height: Dimensions.space5),
                                          Text(
                                              "${MyConverter.twoDecimalPlaceFixedWithoutRounding(controller.walletList[index].balance ?? "")} ${controller.walletList[index].miner?.coinCode ?? ""}",
                                              style:
                                                  interRegularDefault.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: MyColor.colorBlack,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
