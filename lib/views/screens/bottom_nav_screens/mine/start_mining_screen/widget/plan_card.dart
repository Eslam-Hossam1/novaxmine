import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/plan/buy_plan/buy_plan_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/animated_widget/expanded_widget.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/divider/custom_divider.dart';

class PlanCard extends StatefulWidget {
  final String title;
  final String amount;
  final String currency;
  final String validationTime;
  final List<String> features;
  final VoidCallback onPressed;
  final int index;
  const PlanCard(
      {super.key,
      required this.title,
      required this.amount,
      required this.currency,
      required this.validationTime,
      required this.features,
      required this.onPressed,
      required this.index});

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool isVisible = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<BuyPlanController>(
        builder: (controller) => Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space10, horizontal: Dimensions.space15),
              decoration: BoxDecoration(
                color: MyColor.colorWhite,
                borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title,
                              style: interRegularSmall.copyWith(
                                  color: MyColor.labelTextColor)),
                          const SizedBox(height: Dimensions.space5),
                          Row(
                            children: [
                              Text(
                                  "${MyConverter.twoDecimalPlaceFixedWithoutRounding(widget.amount)} ${widget.currency}",
                                  style: interRegularLarge.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: MyColor.colorBlack)),
                              Text(" / ",
                                  style: interRegularSmall.copyWith(
                                      color: MyColor.colorBlack)),
                              Text(widget.validationTime,
                                  style: interRegularSmall.copyWith(
                                      color: MyColor.colorBlack,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          if (controller.selectedIndex == widget.index) {
                            controller.changeIndex(-1);
                          } else {
                            controller.changeIndex(widget.index);
                          }
                        },
                        icon: widget.index == controller.selectedIndex
                            ? const Icon(Icons.keyboard_arrow_up,
                                color: MyColor.colorBlack, size: 25)
                            : const Icon(Icons.keyboard_arrow_down,
                                color: MyColor.colorBlack, size: 25),
                      )
                    ],
                  ),
                  ExpandedSection(
                    expand: widget.index == controller.selectedIndex,
                    child: Column(
                      children: [
                        const CustomDivider(space: Dimensions.space15),
                        Row(
                          children: [
                            Image.asset(MyImages.checkMark,
                                height: 15, width: 15),
                            const SizedBox(width: Dimensions.space10),
                            Expanded(
                              child: Text(
                                "${MyStrings!.hashRate}: ${controller.planList[widget.index].speed} ${controller.planList[widget.index].speedUnitText} ",
                                style: interRegularDefault.copyWith(
                                    color: MyColor.colorBlack),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(MyImages.checkMark,
                                height: 15, width: 15),
                            const SizedBox(width: Dimensions.space10),
                            Expanded(
                              child: Text(
                                "${MyStrings.returnDay}:  ${StringMinMaxFormatter.formatRange(
                                  min: controller
                                      .planList[widget.index].minReturnPerDay,
                                  max: controller
                                      .planList[widget.index].maxReturnPerDay,
                                  symbol: controller
                                          .walletList[controller.walletIndex]
                                          .coinCode ??
                                      "",
                                )}",
                                style: interRegularDefault.copyWith(
                                    color: MyColor.colorBlack),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(MyImages.checkMark,
                                height: 15, width: 15),
                            const SizedBox(width: Dimensions.space10),
                            Expanded(
                              child: Text(
                                "${MyStrings.maintenanceCost}:  ${controller.planList[widget.index].maintenanceCost.toNumber()}% /${MyStrings.day.tr}",
                                style: interRegularDefault.copyWith(
                                    color: MyColor.colorBlack),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.features.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: Dimensions.space15),
                            itemBuilder: (context, index) => Row(
                                  children: [
                                    Image.asset(MyImages.checkMark,
                                        height: 15, width: 15),
                                    const SizedBox(width: Dimensions.space10),
                                    Expanded(
                                      child: Text(
                                        widget.features[index],
                                        style: interRegularDefault.copyWith(
                                            color: MyColor.colorBlack),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                )),
                        const SizedBox(height: Dimensions.space35),
                        RoundedButton(
                          press: widget.onPressed,
                          text: MyStrings.startMining,
                          textColor: MyColor.colorWhite,
                          color: MyColor.primaryColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}
