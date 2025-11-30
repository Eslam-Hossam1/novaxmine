import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/bottom_nav/home/home_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

import '../../../../../core/route/route.dart';
import '../../../../../core/utils/my_color.dart';

class KYCWarningSection extends StatelessWidget {
  const KYCWarningSection({super.key});

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();
    return GetBuilder<HomeController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(
            bottom: 10, left: Dimensions.space15, right: Dimensions.space15),
        child: Visibility(
          visible: !controller.isKycVerified && !controller.isLoading,
          child: InkWell(
            splashColor: MyColor.primaryColor.withValues(alpha: 0.2),
            onTap: () {
              Get.toNamed(RouteHelper.kycScreen);
            },
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space10,
                    vertical: Dimensions.space8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.defaultRadius),
                    color: controller.isKycPending
                        ? MyColor.pendingColor.withValues(alpha: .1)
                        : MyColor.redCancelTextColor.withValues(alpha: .1),
                    border: Border.all(
                        color: controller.isKycPending
                            ? MyColor.pendingColor.withValues(alpha: .5)
                            : MyColor.redCancelTextColor,
                        width: .5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.isKycRejected
                                ? MyStrings!.kycRejectedMsg.tr
                                : controller.isKycPending
                                    ? MyStrings!.kycUnderReviewMsg.tr
                                    : MyStrings!.kycVerificationRequired.tr,
                            style: interSemiBoldDefault.copyWith(
                                color: controller.isKycPending
                                    ? MyColor.pendingColor
                                    : MyColor.redCancelTextColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.space5),
                      Text(
                        controller.isKycRejected
                            ? MyStrings.kycRejectSubtitleMsg
                            : controller.isKycPending
                                ? MyStrings.kycPendingMsg.tr
                                : MyStrings.kycVerificationMsg.tr,
                        style: interRegularDefault.copyWith(
                            fontSize: Dimensions.fontExtraSmall,
                            color: controller.isKycPending
                                ? MyColor.pendingColor
                                : MyColor.redCancelTextColor),
                      ),
                    ],
                  ),
                ),
                if (controller.isKycRejected) ...[
                  Positioned(
                    right: 3,
                    top: 3,
                    child: InkWell(
                      onTap: () {
                        tooltipKey.currentState?.ensureTooltipVisible();
                      },
                      child: Tooltip(
                        key: tooltipKey,
                        message: controller.kycRejectReason,
                        decoration: BoxDecoration(
                            color: MyColor.pendingColor,
                            borderRadius: BorderRadius.circular(
                                Dimensions.defaultRadius)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space10,
                            vertical: Dimensions.space5),
                        margin: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space10,
                            vertical: Dimensions.space5),
                        textStyle: interRegularDefault.copyWith(
                            color: MyColor.colorWhite),
                        child: const Icon(Icons.info_outline,
                            color: MyColor.colorRed, size: 22),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      );
    });
  }
}
