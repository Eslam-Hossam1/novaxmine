import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/data/controller/common/theme_controller.dart';
import 'package:mine_lab/data/controller/localization/localization_controller.dart';
import 'package:mine_lab/data/controller/my_language_controller/my_language_controller.dart';
import 'package:mine_lab/data/repo/auth/general_setting_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/buttons/custom_elevated_button.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/general_components/no_data_found.dart';
import 'package:mine_lab/views/screens/language/widget/language_card.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String comeFrom = '';

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    ThemeController themeController =
        Get.put(ThemeController(sharedPreferences: Get.find()));
    Get.put(LocalizationController(sharedPreferences: Get.find()));
    final controller = Get.put(MyLanguageController(
        repo: Get.find(), localizationController: Get.find()));

    comeFrom = Get.arguments ?? '';

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = AppLocalizations.of(context);
    return GetBuilder<MyLanguageController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          bgColor: MyColor.primaryColor,
          isShowBackBtn: true,
          title: MyStrings!.language.tr,
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : controller.langList.isEmpty
                ? const NoDataFound()
                : SingleChildScrollView(
                    padding: Dimensions.screenPadding,
                    child: GridView.builder(
                      shrinkWrap: true,
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: controller.langList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              MediaQuery.of(context).size.width > 200 ? 2 : 1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 150),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          controller.changeSelectedIndex(index);
                        },
                        child: LanguageCard(
                          index: index,
                          selectedIndex: controller.selectedIndex,
                          langeName: controller.langList[index].languageName,
                          isShowTopRight: true,
                          imagePath:
                              "${controller.languageImagePath}/${controller.langList[index].imageUrl}",
                        ),
                      ),
                    ),
                  ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              vertical: Dimensions.space15, horizontal: Dimensions.space15),
          child: CustomElevatedBtn(
            text: MyStrings.confirm.tr,
            isLoading: controller.isChangeLangLoading,
            // color: MyColor.getButtonColor(),
            // textColor: MyColor.getButtonTextColor(),
            press: () {
              controller.changeLanguage(context, controller.selectedIndex);
            },
          ),
        ),
      ),
    );
  }
}
