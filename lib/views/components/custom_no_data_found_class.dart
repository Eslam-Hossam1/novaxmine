import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/views/components/buttons/custom_round_border_shape.dart';
import 'package:mine_lab/views/components/image/custom_svg_picture.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class NoDataOrInternetScreen extends StatefulWidget {
  final String message; // رسالة العنوان (لو فاضية هنستخدم الترجمة الافتراضية)
  final double paddingTop;
  final double imageHeight;
  final bool fromReview;
  final bool isNoInternet;
  final Function(bool)? onChanged;
  final String
      message2; // الرسالة التانية (لو فاضية هنستخدم الترجمة الافتراضية)
  final String image;

  const NoDataOrInternetScreen({
    super.key,
    this.message = '',
    this.paddingTop = 6,
    this.imageHeight = .5,
    this.fromReview = false,
    this.isNoInternet = false,
    this.onChanged,
    this.message2 = '',
    this.image = MyImages.noDataImage,
  });

  @override
  State<NoDataOrInternetScreen> createState() => _NoDataOrInternetScreenState();
}

class _NoDataOrInternetScreenState extends State<NoDataOrInternetScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // نص العنوان
    final String titleText = widget.isNoInternet
        ? l10n.noInternet // مفتاح من localization
        : (widget.message.isNotEmpty ? widget.message : l10n.noData);

    // النص التحت العنوان (لو مفيش إنترنت غالباً مش محتاجين message2)
    final String subText = widget.isNoInternet
        ? ''
        : (widget.message2.isNotEmpty ? widget.message2 : l10n.noDataToShow);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ListView(
          physics: widget.fromReview
              ? const NeverScrollableScrollPhysics()
              : const ClampingScrollPhysics(),
          children: [
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height * widget.imageHeight,
                  width: widget.isNoInternet
                      ? MediaQuery.of(context).size.width * .6
                      : MediaQuery.of(context).size.width * .4,
                  child: widget.isNoInternet
                      ? Lottie.asset(
                          MyImages.noInternet,
                          height: MediaQuery.of(context).size.height *
                              widget.imageHeight,
                          width: MediaQuery.of(context).size.width * .6,
                        )
                      : CustomSvgPicture(
                          image: widget.image,
                          height: 100,
                          width: 100,
                          color: MyColor.colorGrey,
                        ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 30, right: 30),
                    child: Column(
                      children: [
                        Text(
                          titleText,
                          textAlign: TextAlign.center,
                          style: interSemiBoldDefault.copyWith(
                            color: widget.isNoInternet
                                ? MyColor.colorRed
                                : MyColor.colorBlack,
                            fontSize: Dimensions.fontExtraLarge,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // message2 يظهر بس في حالة لا يوجد بيانات
                        if (!widget.isNoInternet && subText.isNotEmpty)
                          Text(
                            subText,
                            style: interRegularDefault.copyWith(
                              color: MyColor.bodyTextColor,
                              fontSize: Dimensions.fontLarge,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (widget.isNoInternet) const SizedBox(height: 15),
                        // زرار retry لو مفيش إنترنت
                        if (widget.isNoInternet)
                          InkWell(
                            onTap: () async {
                              final conn =
                                  await Connectivity().checkConnectivity();
                              final hasConnection =
                                  (!conn.contains(ConnectivityResult.none));
                              if (hasConnection) {
                                widget.onChanged?.call(true);
                              }
                            },
                            child: RoundedBorderContainer(
                              text: l10n.retry,
                              bgColor: MyColor.colorRed,
                              borderColor: MyColor.colorRed,
                              textColor: MyColor.colorWhite,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

