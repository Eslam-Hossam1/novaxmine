import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/menu_controller/menu_controller.dart';
import 'package:mine_lab/data/repo/menu_repo/menu_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/bottom-sheet/custom_bottom_sheet.dart';

import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/menu/widget/delete_account_bottom_sheet_body.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/menu/widget/menu_item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MenuRepo(apiClient: Get.find()));
    Get.put(MyMenuController(menuRepo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColor.primaryColor,
        title: Text(MyStrings!.menu,
            style: interRegularLarge.copyWith(color: MyColor.colorWhite)),
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<MyMenuController>(
        builder: (controller) => SingleChildScrollView(
          padding: Dimensions.screenPaddingHV,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.space15,
                    horizontal: Dimensions.space15),
                decoration: BoxDecoration(
                  color: MyColor.colorWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    MenuItems(
                        imageSrc: MyImages.person,
                        label: MyStrings.profile.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.profileScreen)),
                    const CustomDivider(),
                    MenuItems(
                        imageSrc: MyImages.twoFA,
                        label: MyStrings.twoFactorAuth.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.twoFactorScreen)),
                    const CustomDivider(),
                    MenuItems(
                        imageSrc: MyImages.dChangePass,
                        label: MyStrings.changePassword.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.changePasswordScreen)),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.space15),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.space15,
                    horizontal: Dimensions.space15),
                decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    MenuItems(
                        imageSrc: MyImages.newMine,
                        label: MyStrings.startMining.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.miningPlanScreen)),
                    const CustomDivider(),
                    MenuItems(
                        imageSrc: MyImages.achievement,
                        label: MyStrings.achievements.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.achievementsScreen)),
                    const CustomDivider(),
                    MenuItems(
                        imageSrc: MyImages.miningTracks,
                        label: MyStrings.miningTracks.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.miningTrackScreen)),
                    const CustomDivider(),
                    MenuItems(
                        imageSrc: MyImages.moneyHistory,
                        label: MyStrings.orderHistory.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.orderHistoryScreen)),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.space15),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.space15,
                    horizontal: Dimensions.space15),
                decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    MenuItems(
                      imageSrc: MyImages.dDeposit,
                      label: MyStrings.deposit.tr,
                      onPressed: () =>
                          Get.toNamed(RouteHelper.newDepositScreenScreen),
                    ),
                    const CustomDivider(),
                    MenuItems(
                      imageSrc: MyImages.moneyHistory,
                      label: MyStrings.depositHistory.tr,
                      onPressed: () =>
                          Get.toNamed(RouteHelper.depositHistoryScreen),
                    ),
                    const CustomDivider(),
                    MenuItems(
                      imageSrc: MyImages.withdraw,
                      label: MyStrings.withdraw.tr,
                      onPressed: () =>
                          Get.toNamed(RouteHelper.addWithdrawScreen),
                    ),
                    const CustomDivider(),
                    MenuItems(
                      imageSrc: MyImages.moneyHistory,
                      label: MyStrings.withdrawHistory.tr,
                      onPressed: () =>
                          Get.toNamed(RouteHelper.withdrawHistoryScreen),
                    ),
                    const CustomDivider(),
                    MenuItems(
                      imageSrc: MyImages.transaction,
                      label: MyStrings.transaction.tr,
                      onPressed: () =>
                          Get.toNamed(RouteHelper.transactionScreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.space15),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.space15,
                    horizontal: Dimensions.space15),
                decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    if (controller.menuRepo.apiClient
                            .getGSData()
                            .data
                            ?.generalSetting
                            ?.referralSystem ==
                        "1") ...[
                      MenuItems(
                          imageSrc: MyImages.dReferral,
                          label: MyStrings.referrals.tr,
                          onPressed: () =>
                              Get.toNamed(RouteHelper.referralBonusLogScreen)),
                      const CustomDivider(),
                    ],
                    MenuItems(
                        imageSrc: MyImages.supportTicket,
                        label: MyStrings.supportTicket.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.allTicketScreen)),
                    const CustomDivider(),
                    MenuItems(
                        imageSrc: MyImages.language,
                        label: MyStrings.language.tr,
                        onPressed: () =>
                            Get.toNamed(RouteHelper.languageScreen)),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.space15),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.space15,
                      horizontal: Dimensions.space15),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      MenuItems(
                          imageSrc: MyImages.faq,
                          label: MyStrings.faq.tr,
                          onPressed: () => Get.toNamed(RouteHelper.faqScreen)),
                      const CustomDivider(),
                      MenuItems(
                          imageSrc: MyImages.deleteAccount,
                          label: MyStrings.deleteAccount.tr,
                          onPressed: () => CustomBottomSheet(
                                  isNeedMargin: true,
                                  isNeedPadding: false,
                                  child: const DeleteAccountBottomsheetBody())
                              .customBottomSheet(context)),
                      const CustomDivider(),
                      MenuItems(
                          imageSrc: MyImages.dPolicy,
                          label: MyStrings.privacyPolicy,
                          onPressed: () =>
                              Get.toNamed(RouteHelper.privacyPolicyScreen)),
                      const CustomDivider(),
                      controller.logoutLoading
                          ? const Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: MyColor.primaryColor,
                                    strokeWidth: 2.00),
                              ),
                            )
                          : MenuItems(
                              imageSrc: MyImages.dLogout,
                              label: MyStrings.dLogout,
                              onPressed: () => controller.logout())
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
