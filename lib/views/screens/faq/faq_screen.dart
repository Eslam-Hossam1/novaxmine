import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/data/controller/faq_controller/local_faq_controller.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import 'faq_widget.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(LocalFaqController());
  }

  @override
  void dispose() {
    Get.delete<LocalFaqController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myStrings = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: MyColor.secondaryScreenBgColor,
      appBar: CustomAppBar(
        bgColor: MyColor.primaryColor,
        isShowBackBtn: true,
        title: myStrings.faq,
      ),
      body: GetBuilder<LocalFaqController>(
        builder: (controller) => SingleChildScrollView(
          padding: Dimensions.screenPadding,
          physics: const ClampingScrollPhysics(),
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.faqList.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: Dimensions.space10),
            itemBuilder: (context, index) {
              final faq = controller.faqList[index];
              
              
              String question = _getLocalizedString(myStrings, faq.questionKey);
              String answer = _getLocalizedString(myStrings, faq.answerKey);
              
              return FaqListItem(
                answer: answer,
                question: question,
                index: index,
                press: () {
                  controller.changeSelectedIndex(index);
                },
                selectedIndex: controller.selectedIndex,
              );
            },
          ),
        ),
      ),
    );
  }

  
  String _getLocalizedString(AppLocalizations strings, String key) {
    switch (key) {
      case 'faqQuestion1':
        return strings.faqQuestion1;
      case 'faqAnswer1':
        return strings.faqAnswer1;
      case 'faqQuestion2':
        return strings.faqQuestion2;
      case 'faqAnswer2':
        return strings.faqAnswer2;
      case 'faqQuestion3':
        return strings.faqQuestion3;
      case 'faqAnswer3':
        return strings.faqAnswer3;
      case 'faqQuestion4':
        return strings.faqQuestion4;
      case 'faqAnswer4':
        return strings.faqAnswer4;
      case 'faqQuestion5':
        return strings.faqQuestion5;
      case 'faqAnswer5':
        return strings.faqAnswer5;
      default:
        return '';
    }
  }
}


