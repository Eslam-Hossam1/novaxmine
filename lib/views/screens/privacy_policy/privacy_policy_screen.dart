import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/privacy/privacy_controller.dart';
import 'package:mine_lab/data/repo/privacy_repo/privacy_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/buttons/category_button.dart';
import 'package:mine_lab/views/components/custom_loader.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PrivacyRepo(apiClient: Get.find()));
    final controller = Get.put(PrivacyController(repo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          title: MyStrings!.privacyPolicy,
          bgColor: MyColor.primaryColor,
          isShowActionBtn: true,
        ),
        body: GetBuilder<PrivacyController>(
          builder: (controller) => SizedBox(
            width: MediaQuery.of(context).size.width,
            child: controller.isLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: SizedBox(
                          height: 35, width: 35, child: CustomLoader()),
                    ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: Dimensions.space10, top: Dimensions.space15),
                        child: SizedBox(
                          height: 30,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                controller.list.length,
                                (index) => Row(
                                  children: [
                                    CategoryButton(
                                        color: controller.selectedIndex == index
                                            ? MyColor.primaryColor
                                            : MyColor.colorWhite,
                                        horizontalPadding: 8,
                                        verticalPadding: 7,
                                        textColor:
                                            controller.selectedIndex == index
                                                ? MyColor.colorWhite
                                                : MyColor.colorBlack,
                                        text: controller.list[index].dataValues
                                                ?.title ??
                                            '',
                                        press: () {
                                          controller.changeIndex(index);
                                        }),
                                    const SizedBox(width: Dimensions.space10)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.space15),
                      Expanded(
                          child: SingleChildScrollView(
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: HtmlWidget(controller.selectedHtml,
                                      textStyle: interRegularDefault.copyWith(
                                          color: Colors.black),
                                      onLoadingBuilder:
                                          (context, element, loadingProgress) =>
                                              const CustomLoader()))))
                    ],
                  ),
          ),
        ));
  }
}
