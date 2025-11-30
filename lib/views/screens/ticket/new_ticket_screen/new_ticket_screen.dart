import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/my_icons.dart';
import 'package:mine_lab/core/utils/my_images.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/support/new_ticket_controller.dart';
import 'package:mine_lab/data/repo/support/support_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/buttons/rounded_button.dart';
import 'package:mine_lab/views/components/image/custom_svg_picture.dart';
import 'package:mine_lab/views/components/text-field/circle_icon_button.dart';
import 'package:mine_lab/views/components/text-field/custom_text_field.dart';
import 'package:mine_lab/views/components/text-field/label_text_field.dart';
import 'package:mine_lab/views/components/text/label_text.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key});

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SupportRepo(apiClient: Get.find()));
    Get.put(NewTicketController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<NewTicketController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          bgColor: MyColor.primaryColor,
          title: MyStrings!.addNewTicket.tr,
        ),
        body: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.space10),
                      CustomTextField(
                        needLabel: false,
                        labelText: MyStrings.subject.tr,
                        hintText: MyStrings.enterYourSubject.tr,
                        controller: controller.subjectController,
                        isPassword: false,
                        isShowSuffixIcon: false,
                        needOutlineBorder: true,
                        nextFocus: controller.messageFocusNode,
                        onSuffixTap: () {},
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: Dimensions.space17),
                      LabelText(
                        text: MyStrings.priority.tr,
                        textStyle: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: Dimensions.space8),
                      DropDownTextFieldContainer(
                        color: MyColor.transparentColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: DropdownButton<String>(
                            dropdownColor: MyColor.secondaryColor,
                            value: controller.selectedPriority,
                            elevation: 8,
                            icon: SvgPicture.asset(MyImages.arrowDown),
                            iconDisabledColor: Colors.grey,
                            iconEnabledColor: MyColor.primaryColor,
                            isExpanded: true,
                            underline: Container(
                              height: 0,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              controller.setPriority(newValue);
                            },
                            items: controller.priorityList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: interRegularDefault.copyWith(
                                      fontSize: Dimensions.fontDefault),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space20),
                      CustomTextField(
                        needLabel: false,
                        labelText: MyStrings.message.tr,
                        needOutlineBorder: true,
                        hintText: MyStrings.enterYourMessage.tr,
                        isPassword: false,
                        controller: controller.messageController,
                        maxLines: 5,
                        focusNode: controller.messageFocusNode,
                        isShowSuffixIcon: false,
                        onSuffixTap: () {},
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: Dimensions.space17),
                      InkWell(
                        onTap: () {
                          controller.pickFile();
                        },
                        child: LabelTextField(
                          readOnly: true,
                          contentPadding:
                              const EdgeInsets.all(Dimensions.space10),
                          isAttachment: true,
                          labelText: MyStrings.attachment.tr,
                          hintText: MyStrings.enterFile.tr,
                          inputAction: TextInputAction.done,
                          onChanged: (value) {
                            return;
                          },
                          suffixIcon: InkWell(
                            onTap: () {
                              controller.pickFile();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15,
                                  vertical: Dimensions.space10),
                              margin: const EdgeInsets.all(Dimensions.space5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: MyColor.primaryColor,
                              ),
                              child: Text(
                                MyStrings.upload,
                                style: interRegularDefault.copyWith(
                                    color: MyColor.colorWhite),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space5),
                      Text(MyStrings.supportedFileHint,
                          style: interRegularSmall.copyWith(
                              color: MyColor.pendingColor)),
                      if (controller.attachmentList.isNotEmpty) ...[
                        const SizedBox(height: Dimensions.space10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              controller.attachmentList.length,
                              (index) => Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(
                                            Dimensions.space5),
                                        decoration: const BoxDecoration(),
                                        child: controller.isImage(controller
                                                .attachmentList[index].path)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .mediumRadius),
                                                child: Image.file(
                                                  controller
                                                      .attachmentList[index],
                                                  width: context.width / 5,
                                                  height: context.width / 5,
                                                  fit: BoxFit.cover,
                                                ))
                                            : controller.isXlsx(controller
                                                    .attachmentList[index].path)
                                                ? Container(
                                                    width: context.width / 5,
                                                    height: context.width / 5,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorWhite,
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .mediumRadius),
                                                      border: Border.all(
                                                          color: MyColor
                                                              .borderColor,
                                                          width: 1),
                                                    ),
                                                    child: const Center(
                                                      child: CustomSvgPicture(
                                                        image: MyIcons.xlsx,
                                                        height: 45,
                                                        width: 45,
                                                      ),
                                                    ),
                                                  )
                                                : controller.isDoc(controller
                                                        .attachmentList[index]
                                                        .path)
                                                    ? Container(
                                                        width:
                                                            context.width / 5,
                                                        height:
                                                            context.width / 5,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: MyColor
                                                              .colorWhite,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .mediumRadius),
                                                          border: Border.all(
                                                              color: MyColor
                                                                  .borderColor,
                                                              width: 1),
                                                        ),
                                                        child: const Center(
                                                          child:
                                                              CustomSvgPicture(
                                                            image: MyIcons.doc,
                                                            height: 45,
                                                            width: 45,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width:
                                                            context.width / 5,
                                                        height:
                                                            context.width / 5,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: MyColor
                                                              .colorWhite,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .mediumRadius),
                                                          border: Border.all(
                                                              color: MyColor
                                                                  .borderColor,
                                                              width: 1),
                                                        ),
                                                        child: const Center(
                                                          child:
                                                              CustomSvgPicture(
                                                            image:
                                                                MyIcons.pdfFile,
                                                            height: 45,
                                                            width: 45,
                                                          ),
                                                        ),
                                                      ),
                                      ),
                                      CircleIconButton(
                                        onTap: () {
                                          controller
                                              .removeAttachmentFromList(index);
                                        },
                                        height: Dimensions.space20,
                                        width: Dimensions.space20,
                                        backgroundColor: MyColor.colorRed,
                                        child: const Icon(
                                          Icons.close,
                                          color: MyColor.colorWhite,
                                          size: Dimensions.space12,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                      const SizedBox(height: 30),
                      Center(
                        child: RoundedButton(
                          isLoading: controller.submitLoading,
                          isOutlined: true,
                          isColorChange: true,
                          verticalPadding: Dimensions.space15,
                          cornerRadius: Dimensions.space8,
                          color: MyColor.primaryColor,
                          text: MyStrings.submit.tr,
                          press: () {
                            controller.submit(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class DropDownTextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  const DropDownTextFieldContainer(
      {super.key, required this.child, this.color = MyColor.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.space5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.largeRadius),
        border:
            Border.all(color: MyColor.getTextFieldDisableBorder(), width: .5),
      ),
      child: child,
    );
  }
}
