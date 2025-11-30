import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/url_container.dart';

class MyWebViewWidget extends StatefulWidget {
  const MyWebViewWidget({super.key, required this.url});

  final String url;

  @override
  State<MyWebViewWidget> createState() => _MyWebViewWidgetState();
}

class _MyWebViewWidgetState extends State<MyWebViewWidget> {
  String url = '';
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  bool isKycPending = false;
  bool isLoading = true;

  @override
  void initState() {
    url = widget.url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (Platform.isAndroid) {
      InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }

    return Stack(
      children: [
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox(),
        InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          initialSettings: settings,
          onLoadStart: (controller, url) {
            printX("url ->>>>>> $url");

            final currentUrl = url.toString();

            if (currentUrl ==
                '${UrlContainer.baseUrl}user/mining-tracks' ||
                currentUrl ==
                    '${UrlContainer.baseUrl}user/deposit/history') {
              Get.offAndToNamed(RouteHelper.miningTrackScreen);
            } else if (currentUrl ==
                '${UrlContainer.baseUrl}/user/dashboard' ||
                currentUrl == '${UrlContainer.baseUrl}user/deposit') {
              Get.back();
              // هنا استبدلنا MyStrings.requestFail بالترجمة من l10n
              CustomSnackBar.error(
                errorList: [l10n.requestFail],
              );
            }
          },
          onPermissionRequest: (controller, resources) async {
            return PermissionResponse(
              resources: resources.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final uri = navigationAction.request.url;

            if (uri == null) {
              return NavigationActionPolicy.ALLOW;
            }

            // السماح للبروتوكولات المعروفة داخل الويب فيو
            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about",
            ].contains(uri.scheme)) {
              final launchUri = Uri.parse(uri.toString());
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
                return NavigationActionPolicy.CANCEL;
              }
            }

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            setState(() {
              isLoading = false;
              this.url = url.toString();
            });
          },
          onReceivedError:
              (controller, resourceRequest, resourceError) {},
          onProgressChanged: (controller, progress) {},
          onUpdateVisitedHistory:
              (controller, url, androidIsReload) {
            setState(() {
              this.url = url.toString();
            });
          },
          onConsoleMessage: (controller, consoleMessage) {},
        ),
      ],
    );
  }
}
