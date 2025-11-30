import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/model/deposit/deposit_insert_response_model.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/route/route.dart';
import '../../../../core/utils/url_container.dart';

class DepositWebViewScreen extends StatefulWidget {
  final DepositInsertData depositInsertData;
  const DepositWebViewScreen({super.key, required this.depositInsertData});

  @override
  State<DepositWebViewScreen> createState() => _DepositWebViewScreenState();
}

class _DepositWebViewScreenState extends State<DepositWebViewScreen> {
  String url = '';
  final GlobalKey webViewKey = GlobalKey();
  bool isLoading = true;

  @override
  void initState() {
    url = widget.depositInsertData.redirectUrl ?? "";
    super.initState();
  }

  InAppWebViewController? webViewController;
  // ignore: deprecated_member_use
  InAppWebViewSettings options = InAppWebViewSettings(
    allowFileAccess: true,
    allowsInlineMediaPlayback: true,
    useHybridComposition: true,
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    cacheEnabled: false,
    javaScriptEnabled: true,
  );

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return Scaffold(
      appBar: CustomAppBar(
        title: MyStrings!.payNow,
        bgColor: MyColor.primaryColor,
        isTitleCenter: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: options,
            onWebViewCreated: (controller) => webViewController = controller,
            onLoadStart: (controller, url) {
              printX("url ->>>>>> ${url.toString()}");
              printX("${widget.depositInsertData.deposit?.successUrl}");
              if (url.toString().contains("ipn/") && Platform.isIOS == true) {
                Get.offAndToNamed(RouteHelper.depositsScreen);
                CustomSnackBar.success(successList: [MyStrings.requestSuccess]);
              } else if (url.toString() ==
                  '${UrlContainer.baseUrl}user/deposit/history') {
                Get.offAndToNamed(RouteHelper.depositsScreen);
                CustomSnackBar.success(successList: [MyStrings.requestSuccess]);
              } else if (url.toString() ==
                  '${UrlContainer.baseUrl}user/deposit') {
                Get.back();
                CustomSnackBar.error(errorList: [MyStrings.requestFail]);
              }
              setState(() {
                this.url = url.toString();
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;

              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(uri.scheme)) {
                if (await canLaunchUrl(
                    Uri.parse(widget.depositInsertData.redirectUrl ?? ""))) {
                  await launchUrl(
                    Uri.parse(widget.depositInsertData.redirectUrl ?? ""),
                  );
                  return NavigationActionPolicy.CANCEL;
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              isLoading = false;
              setState(() {
                this.url = url.toString();
              });
            },
          ),
          isLoading
              ? const Center(child: CustomLoader(isFullScreen: true))
              : const SizedBox(),
        ],
      ),
    );
  }
}
