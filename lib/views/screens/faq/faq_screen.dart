import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/data/controller/faq_controller/faq_controller.dart';
import 'package:mine_lab/data/repo/faq_repo/faq_repo.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/custom_loader.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../data/services/api_service.dart';
import 'faq_widget.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(FaqRepo(apiClient: Get.find()));
    final controller = Get.put(FaqController(faqRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = AppLocalizations.of(context);
    return Scaffold(
        backgroundColor: MyColor.secondaryScreenBgColor,
        appBar: CustomAppBar(
            bgColor: MyColor.primaryColor,
            isShowBackBtn: true,
            title: MyStrings!.faq.tr),
        body: GetBuilder<FaqController>(
          builder: (controller) => controller.isLoading
              ? const CustomLoader()
              : SingleChildScrollView(
                  padding: Dimensions.screenPadding,
                  physics: const ClampingScrollPhysics(),
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.faqList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Dimensions.space10),
                    itemBuilder: (context, index) => FaqListItem(
                        answer:
                            (controller.faqList[index].dataValues?.answer ?? '')
                                .tr,
                        question:
                            (controller.faqList[index].dataValues?.question ??
                                    '')
                                .tr,
                        index: index,
                        press: () {
                          controller.changeSelectedIndex(index);
                        },
                        selectedIndex: controller.selectedIndex),
                  ),
                ),
        ));
  }
}
