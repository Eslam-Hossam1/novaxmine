import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/support/support_ticket_response_model.dart';
import 'package:mine_lab/data/repo/support/support_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class SupportController extends GetxController {
  final SupportRepo repo;
  SupportController({required this.repo});

  /// نصوص تعتمد على الـ l10n
  String noFileChosen = '';
  String chooseFile = '';

  /// المرفقات
  List<FileChooserModel> attachmentList = [];

  final TextEditingController replyController = TextEditingController();

  bool submitLoading = false;
  bool isLoading = false;

  List<String> messageList = [];
  int page = 0;
  String? nextPageUrl;
  List<TicketData> ticketList = [];
  String imagePath = '';

  /// يتم استدعاؤها من الـ Widget (مثلاً في initState أو أول build)
  void initTexts(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    noFileChosen = l10n.noFileChosen;
    chooseFile = l10n.chooseFile;

    // أول عنصر في قائمة المرفقات بالنص المترجم
    attachmentList = [FileChooserModel(fileName: noFileChosen)];

    update();
  }

  Future<void> loadData(BuildContext context) async {
    ticketList.clear();
    page = 0;
    messageList.clear();
    isLoading = true;
    update();

    await getSupportTicket(context);

    isLoading = false;
    update();
  }

  Future<void> getSupportTicket(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    page = page + 1;

    if (page == 1) {
      ticketList.clear();
      update();
    }
    isLoading = true;
    update();

    ResponseModel responseModel =
        await repo.getSupportTicketList(page.toString());
    if (responseModel.statusCode == 200) {
      SupportTicketListResponseModel model =
          SupportTicketListResponseModel.fromJson(
              jsonDecode(responseModel.responseJson));

      if (model.status?.toLowerCase() == 'success') {
        nextPageUrl = model.data?.tickets?.nextPageUrl;
        List<TicketData>? tempList = model.data?.tickets?.data;
        imagePath = model.data?.tickets?.path.toString() ?? '';
        if (tempList != null && tempList.isNotEmpty) {
          ticketList.addAll(tempList);
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [l10n.somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  Color getStatusColor(String status, {bool isPriority = false}) {
    late Color output;
    if (isPriority) {
      // ألوان الأولوية
      output = status == '1'
          ? MyColor.pendingColor
          : status == '2'
              ? MyColor.greenSuccessColor
              : status == '3'
                  ? MyColor.redCancelTextColor
                  : MyColor.pendingColor;
    } else {
      // ألوان حالة التيكت
      output = status == '1'
          ? MyColor.textFieldDisableBorderColor
          : status == '2'
              ? MyColor.highPriorityPurpleColor
              : status == '3'
                  ? MyColor.redCancelTextColor
                  : MyColor.greenSuccessColor;
    }

    return output;
  }

  /// ترجمة حالة التيكت أو الأولوية
  String getStatus(
    String status,
    BuildContext context, {
    bool isPriority = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    String output = '';

    if (isPriority) {
      // 1 = Low, 2 = Medium, 3 = High
      output = status == '1'
          ? l10n.low
          : status == '2'
              ? l10n.medium
              : status == '3'
                  ? l10n.high
                  : '';
    } else {
      // 0 = Open, 1 = Answered, 2 = Customer Reply, 3 = Closed
      output = status == '0'
          ? l10n.open
          : status == '1'
              ? l10n.answered
              : status == '2'
                  ? l10n.customerReply
                  : l10n.closed;
    }
    return output;
  }

  /// ترجمة نص حالة التيكت برقم الحالة
  String getStatusText(
    String priority,
    BuildContext context, {
    bool isPriority = false,
    bool isStatus = false,
  }) {
    final l10n = AppLocalizations.of(context)!;

    // 0 = Open, 1 = Answered, 2 = Replied, 3 = Closed
    String text = priority == '0'
        ? l10n.open
        : priority == '1'
            ? l10n.answered
            : priority == '2'
                ? l10n.replied
                : priority == '3'
                    ? l10n.closed
                    : '';
    return text;
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty;
  }
}

class FileChooserModel {
  late String fileName;
  late File? choosenFile;
  FileChooserModel({required this.fileName, this.choosenFile});
}

