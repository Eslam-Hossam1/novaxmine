import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/auth/login/login_controller.dart';
import 'package:mine_lab/data/repo/auth/login/login_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/will_pop_widget.dart';
import 'package:mine_lab/views/screens/auth/login/widget/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    MyUtils.authScreenUtils();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(LoginController(loginRepo: Get.find()));
    super.initState();
  }

  @override
  void dispose() {
    MyUtils.authScreenUtils();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return WillPopWidget(
      nextRoute: '',
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: MyColor.screenBgColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: MyColor.screenBgColor,
            body: GetBuilder<LoginController>(
              builder: (controller) => SafeArea(
                child: SingleChildScrollView(
                  padding: Dimensions.screenPadding,
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.space30),

                      /// عنوان الشاشة
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          // كان: MyStrings.signIn.tr.toTitleCase()
                          l10n.signIn.toTitleCase(),
                          style: interRegularDefault.copyWith(fontSize: 32),
                        ),
                      ),

                      /// الرسالة تحت العنوان
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          // كان: MyStrings.loginMsg.tr
                          l10n.loginMsg(l10n.appName),
                          style: interRegularDefault.copyWith(
                            fontSize: 16,
                            color: MyColor.bodyTextColor.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(height: Dimensions.space30),
                      const LoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
