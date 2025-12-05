// lib/data/controller/faq_controller/local_faq_controller.dart
import 'package:get/get.dart';
import 'package:mine_lab/data/model/faq_model/local_faq_model.dart';

class LocalFaqController extends GetxController {
  int selectedIndex = -1;
  List<LocalFaqModel> faqList = [];

  @override
  void onInit() {
    super.onInit();
    loadLocalFaqs();
  }

  void loadLocalFaqs() {
    // Define your FAQs with localization keys
    faqList = [
      LocalFaqModel(
        questionKey: 'faqQuestion1',
        answerKey: 'faqAnswer1',
      ),
      LocalFaqModel(
        questionKey: 'faqQuestion2',
        answerKey: 'faqAnswer2',
      ),
      LocalFaqModel(
        questionKey: 'faqQuestion3',
        answerKey: 'faqAnswer3',
      ),
      LocalFaqModel(
        questionKey: 'faqQuestion4',
        answerKey: 'faqAnswer4',
      ),
      LocalFaqModel(
        questionKey: 'faqQuestion5',
        answerKey: 'faqAnswer5',
      ),
      // Add more FAQs as needed
    ];
    update();
  }

  void changeSelectedIndex(int index) {
    if (selectedIndex == index) {
      selectedIndex = -1; // Collapse if already selected
    } else {
      selectedIndex = index;
    }
    update();
  }
}
