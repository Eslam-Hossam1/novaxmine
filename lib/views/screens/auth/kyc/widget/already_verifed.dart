import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/controller/kyc_controller/kyc_controller.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/column_widget/card_column.dart';
import 'package:mine_lab/views/components/file_download_dialog/download_dialogue.dart';

import '../../../../components/image/custom_svg_picture.dart';

class AlreadyVerifiedWidget extends StatefulWidget {
  final bool isPending;

  const AlreadyVerifiedWidget({super.key, this.isPending = false});

  @override
  State<AlreadyVerifiedWidget> createState() => _AlreadyVerifiedWidgetState();
}

class _AlreadyVerifiedWidgetState extends State<AlreadyVerifiedWidget> {
  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<KycController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.space20),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColor.screenBgColor,
        ),
        child: controller.pendingData.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: controller.pendingData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(Dimensions.space8),
                          margin: const EdgeInsets.symmetric(
                              vertical: Dimensions.space10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: MyColor.borderColor, width: .5),
                            borderRadius:
                                BorderRadius.circular(Dimensions.defaultRadius),
                          ),
                          child: controller.pendingData[index].type == "file"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        controller.pendingData[index].name ??
                                            '',
                                        style: interSemiBoldDefault.copyWith(
                                            fontSize: Dimensions.fontDefault)),
                                    const SizedBox(height: Dimensions.space5),
                                    GestureDetector(
                                      onTap: () {
                                        String url =
                                            "${UrlContainer.baseUrl}${controller.path}/${controller.pendingData[index].value.toString()}";

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DownloadingDialog(
                                              url: url,
                                              fileName: controller
                                                      .pendingData[index]
                                                      .name ??
                                                  MyStrings!.appName,
                                              isImage: true,
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.file_download,
                                            size: 17,
                                            color: MyColor.primaryColor,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            MyStrings!.attachment.tr,
                                            style: interRegularDefault.copyWith(
                                                color: MyColor.primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : CardColumn(
                                  header:
                                      controller.pendingData[index].name ?? '',
                                  body: MyConverter
                                      .removeQuotationAndSpecialCharacterFromString(
                                          controller.pendingData[index].value ??
                                              ''),
                                  // headerTextStyle: heading.copyWith(fontSize: Dimensions.fontDefault),
                                  // bodyTextStyle: regularDefault.copyWith(),
                                  bodyMaxLine: 3,
                                ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: RoundedButton(
                      press: () {
                        Get.back();
                      },
                      text: "Back",
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSvgPicture(
                    image: widget.isPending
                        ? MyImages.pendingIcon
                        : MyImages.verifiedIcon,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 25),
                  Text(
                      widget.isPending
                          ? MyStrings!.kycUnderReviewMsg.tr
                          : MyStrings!.kycAlreadyVerifiedMsg.tr,
                      style: interRegularDefault.copyWith(
                          color: MyColor.colorBlack,
                          fontSize: Dimensions.fontExtraLarge)),
                  const SizedBox(height: 40)
                ],
              ),
      );
    });
  }
}

