import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/data/controller/bottom_nav/home/home_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/screens/bottom_nav_screens/home/widget/miner_item_card.dart';

class HomeCardSection extends StatefulWidget {
  const HomeCardSection({super.key});

  @override
  State<HomeCardSection> createState() => _HomeCardSectionState();
}

class _HomeCardSectionState extends State<HomeCardSection> {
  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<HomeController>(
      builder: (controller) => Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.space10),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MinerCardItem(
                  image: MyImages.balance,
                  title: MyStrings!.depositWallet,
                  data: controller.balance,
                  bottomTitle: MyStrings.deposit,
                  onTap: () {
                    Get.toNamed(RouteHelper.depositOptionsScreen);
                  },
                ),
              ),
              const SizedBox(width: Dimensions.space10),
              Expanded(
                child: MinerCardItem(
                  image: MyImages.walletBag,
                  title: MyStrings.earningWallet,
                  data: controller.profitBalance,
                  bottomTitle: MyStrings.withdraw,
                  onTap: () {
                    Get.toNamed(RouteHelper.addWithdrawScreen);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
