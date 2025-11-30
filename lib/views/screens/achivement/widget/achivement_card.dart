import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/controller/achievements/achievement_controller.dart';
import 'package:mine_lab/views/components/animated_widget/expanded_widget.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/image/my_image_widget.dart';

class AchievementCard extends StatefulWidget {
  final int index;
  final bool isOpen;
  final bool isUnlocked;
  final VoidCallback onTap;
  const AchievementCard(
      {super.key,
      required this.index,
      required this.isOpen,
      required this.isUnlocked,
      required this.onTap});

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> {
  @override
  Widget build(BuildContext context) {
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<AchievementController>(builder: (controller) {
      return Container(
        decoration: BoxDecoration(
            color: MyColor.colorWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColor.borderColor)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyImageWidget(
                  imageUrl:
                      "${UrlContainer.baseUrl}${controller.badgePath}/${controller.unlockBadges[widget.index].badge?.image ?? ""}",
                  height: 60,
                  width: 60,
                  radius: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          controller.unlockBadges[widget.index].badge?.name ??
                              "",
                          style: interSemiBoldDefault.copyWith()),
                      Text(
                          "Main Earning : ${controller.achievementRepo.apiClient.getCurrencyOrUsername(isSymbol: true)}${MyConverter.formatNumber(controller.unlockBadges[widget.index].earningAmount ?? '0.00')}",
                          style: interRegularDefault.copyWith()),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.isUnlocked
                            ? MyColor.greenP.withValues(alpha: 0.1)
                            : MyColor.redCancelTextColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: widget.isUnlocked
                                ? MyColor.greenP
                                : MyColor.redCancelTextColor,
                            width: .5),
                      ),
                      child: Text(
                        widget.isUnlocked ? "Unlocked".tr : "Locked".tr,
                        style: interRegularDefault.copyWith(
                            color: widget.isUnlocked
                                ? MyColor.greenP
                                : MyColor.redCancelTextColor),
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: widget.onTap,
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: 32,
                        width: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MyColor.colorGrey.withValues(alpha: 0.2),
                            shape: BoxShape.circle),
                        child: Icon(
                            widget.isOpen
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: MyColor.colorBlack,
                            size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ExpandedSection(
              expand: widget.isOpen,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  buildRow(
                    title: MyStrings!.discountOnMaintenanceAmount,
                    value: controller.unlockBadges[widget.index]
                            .discountMaintenanceCost ??
                        "null",
                  ),
                  buildRow(
                    title: MyStrings.discountOnPlanPrice,
                    value: controller
                            .unlockBadges[widget.index].planPriceDiscount ??
                        "null",
                    //    value: controller.unlockBadges[widget.index].planPriceDiscount == "0.00" ? "No".tr : "${controller.unlockBadges[widget.index].planPriceDiscount}%",
                  ),
                  buildRow(
                    title: MyStrings.increaseEarningBoost,
                    value: controller.unlockBadges[widget.index].earningBoost ??
                        "null",
                  ),
                  buildRow(
                    title: MyStrings.enhanceReferralBonus,
                    value: controller
                            .unlockBadges[widget.index].referralBonusBoost ??
                        "null",
                    isDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildRow(
      {required String title, required String value, bool isDivider = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(title.tr,
                  style: interLightDefault.copyWith(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              flex: 1,
              child: Text(
                value == "0.00"
                    ? "No".tr
                    : value == "null"
                        ? "Prev Level".tr
                        : "${MyConverter.formatNumber(value)}%",
                style:
                    interRegularDefault.copyWith(color: MyColor.bodyTextColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        if (isDivider) CustomDivider(),
      ],
    );
  }
}

