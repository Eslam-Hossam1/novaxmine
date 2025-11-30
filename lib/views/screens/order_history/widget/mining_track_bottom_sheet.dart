import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/date_converter.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/plan/mining_tracks/mining_tracks_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';
import 'package:mine_lab/views/components/text/default_text.dart';
import 'package:mine_lab/views/components/text/header_text.dart';
import 'package:mine_lab/views/components/text/small_text.dart';

class MiningTrackBottomSheet {
  static void bottomSheet(BuildContext context, int index) {
    final MyStrings = AppLocalizations.of(context);
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: MyColor.transparentColor,
      context: context,
      builder: (context) => GetBuilder<MiningTracksController>(
        builder: (controller) {
          final track = controller.miningTrackList[index];
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space10, horizontal: Dimensions.space15),
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
                            color: MyColor.colorGrey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space15),
                    HeaderText(
                        text: MyStrings!.miningTrackDetails,
                        textStyle: interSemiBoldLarge.copyWith(
                            color: MyColor.colorBlack)),
                    const CustomDivider(space: Dimensions.space15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.planTitle,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: track.planDetails?.title ?? "",
                                  textColor: MyColor.colorBlack)
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.date,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: DateConverter.isoStringToLocalDateOnly(
                                      track.createdAt ?? ""),
                                  textColor: MyColor.colorBlack)
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: Dimensions.space15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.amount,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text:
                                      "${MyConverter.twoDecimalPlaceFixedWithoutRounding(track.amount ?? "")} ${controller.currency}",
                                  textColor: MyColor.colorBlack)
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.miner,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: track.planDetails?.miner ?? "",
                                  textColor: MyColor.colorBlack)
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: Dimensions.space15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.speed,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: track.planDetails?.speed ?? "",
                                  textColor: MyColor.colorBlack),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.returnDay,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: track.minReturnPerDay ?? "",
                                  textColor: MyColor.colorBlack),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: Dimensions.space15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.totalDays,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: track.period.toString(),
                                  textColor: MyColor.colorBlack)
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.remainingDays,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: track.periodRemain.toString(),
                                  textColor: MyColor.colorBlack)
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: Dimensions.space15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.maintenanceCost,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: track.maintenanceCost.toString(),
                                  textColor: MyColor.colorBlack),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                  text: MyStrings.remainingDays,
                                  textColor: MyColor.colorGrey),
                              const SizedBox(height: Dimensions.space5),
                              DefaultText(
                                  text: track.periodRemain.toString(),
                                  textColor: MyColor.colorBlack)
                            ],
                          ),
                        )
                      ],
                    ),
                    if (track.status == "0") ...[
                      Column(
                        children: [
                          const CustomDivider(space: Dimensions.space20),
                          RoundedButton(
                            press: () {
                              String orderId = track.id.toString();
                              String amount = track.amount ?? '';
                              String title = track.planDetails?.title ?? '';
                              Get.back();
                              Get.toNamed(RouteHelper.planPaymentMethodScreen,
                                  arguments: [title, amount, orderId]);
                            },
                            text: MyStrings.payNow,
                            textColor: MyColor.colorWhite,
                            color: MyColor.primaryColor,
                          ),
                          const SizedBox(height: Dimensions.space20)
                        ],
                      )
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
