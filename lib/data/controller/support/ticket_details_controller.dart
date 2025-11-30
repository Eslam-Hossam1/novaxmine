import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/data/controller/support/support_controller.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/support/support_ticket_view_response_model.dart';
import 'package:mine_lab/data/repo/support/support_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

import '../../../core/utils/my_color.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class TicketDetailsController extends GetxController {
  final SupportRepo repo;
  final String ticketId;

  TicketDetailsController({required this.repo, required this.ticketId});

  String username = '';
  bool isRtl = false;

  // helper للوصول للـ l10n من خلال Get.context
  AppLocalizations? get _l10n =>
      Get.context != null ? AppLocalizations.of(Get.context!) : null;

  bool isLoading = false;

  final TextEditingController replyController = TextEditingController();

  MyTickets? receivedTicketModel;
  List<File> attachmentList = [];

  String noFileChosen = '';
  String chooseFile = '';

  String ticketImagePath = "";

  SupportTicketViewResponseModel model = SupportTicketViewResponseModel();
  List<SupportMessage> messageList = [];
  String ticket = '';
  String subject = '';
  String status = '-1';
  String ticketName = '';

  TargetPlatform? platform;
  String _localPath = '';
  String downLoadId = "";

  bool isSubmitLoading = false;
  int selectedIndex = -1;

  bool closeLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    update();

    final languageCode = repo.apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.languageCode) ??
        'eng';
    isRtl = languageCode == 'ar';

    // تهيئة النصوص المترجمة
    final l10n = _l10n;
    if (l10n != null) {
      noFileChosen = l10n.noFileChosen;
      chooseFile = l10n.chooseFile;
    }

    loadUserName();
    await loadTicketDetailsData();
    isLoading = false;
    update();
  }

  void loadUserName() {
    username = repo.apiClient.getCurrencyOrUsername(isCurrency: false);
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
    );
    if (result == null) return;

    attachmentList.add(File(result.files.single.path!));
    update();
  }

  bool isImage(String path) {
    return path.contains('.jpg') ||
        path.contains('.png') ||
        path.contains('.jpeg');
  }

  bool isXlsx(String path) {
    return path.contains('.xlsx') ||
        path.contains('.xls') ||
        path.contains('.xlx');
  }

  bool isDoc(String path) {
    return path.contains('.doc') || path.contains('.docs');
  }

  void removeAttachmentFromList(int index) {
    if (attachmentList.length > index) {
      attachmentList.removeAt(index);
      update();
    }
  }

  Future<void> loadTicketDetailsData({bool shouldLoad = true}) async {
    final l10n = _l10n;
    isLoading = shouldLoad;
    update();

    ResponseModel response = await repo.getSingleTicket(ticketId);

    if (response.statusCode == 200) {
      model = SupportTicketViewResponseModel.fromJson(
        jsonDecode(response.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        ticket = model.data?.myTickets?.ticket ?? '';
        subject = model.data?.myTickets?.subject ?? '';
        status = model.data?.myTickets?.status ?? '';
        ticketName = model.data?.myTickets?.name ?? '';
        receivedTicketModel = model.data?.myTickets;

        final List<SupportMessage>? tempTicketList = model.data?.myMessages;
        if (tempTicketList != null && tempTicketList.isNotEmpty) {
          messageList
            ..clear()
            ..addAll(tempTicketList);
        }
      } else {
        CustomSnackBar.error(
          errorList:
              model.message?.error ?? [l10n?.somethingWentWrong ?? 'Error'],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();
  }

  bool submitLoading = false;
  Future<void> uploadTicketViewReply(BuildContext context) async {
    final l10n = _l10n;

    if (replyController.text.toString().isEmpty) {
      CustomSnackBar.error(
        errorList: [l10n?.replyTicketEmptyMsg ?? 'Reply cannot be empty'],
      );
      return;
    }

    submitLoading = true;
    update();

    try {
      final bool b = await repo.replyTicket(
        context,
        replyController.text,
        attachmentList,
        receivedTicketModel?.id.toString() ?? "-1",
      );

      if (b) {
        await loadTicketDetailsData(shouldLoad: false);
        CustomSnackBar.success(
          successList: [
            l10n?.repliedSuccessfully ?? 'Replied successfully',
          ],
        );
        replyController.text = '';
        refreshAttachmentList();
      }
    } catch (e) {
      submitLoading = false;
      update();
    } finally {
      submitLoading = false;
      update();
    }
  }

  void setTicketModel(MyTickets? ticketModel) {
    receivedTicketModel = ticketModel;
    update();
  }

  void clearAllData() {
    refreshAttachmentList();
    replyController.clear();
    messageList.clear();
  }

  void refreshAttachmentList() {
    attachmentList.clear();
    update();
  }

  void closeTicket(String supportTicketID) async {
    final l10n = _l10n;

    closeLoading = true;
    update();

    ResponseModel responseModel = await repo.closeTicket(supportTicketID);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel authModel =
          AuthorizationResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      if (authModel.status?.toLowerCase() == 'success') {
        clearAllData();
        Get.back();
        CustomSnackBar.success(
          successList: [l10n?.requestSuccess ?? 'Request successful'],
        );
        // مع التعديل الجديد لـ SupportController
        Get.find<SupportController>().loadData(Get.context!);
      } else {
        CustomSnackBar.error(
          errorList: [l10n?.requestFail ?? 'Request failed'],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    closeLoading = false;
    update();
  }

  String getStatusText(
    String priority, {
    bool isPriority = false,
    bool isStatus = false,
  }) {
    final l10n = _l10n;
    if (l10n == null) return '';

    // 0 = Open, 1 = Answered, 2 = Replied, 3 = Closed
    return priority == '0'
        ? l10n.open
        : priority == '1'
            ? l10n.answered
            : priority == '2'
                ? l10n.replied
                : priority == '3'
                    ? l10n.closed
                    : '';
  }

  Color getStatusColor(String status, {bool isPriority = false}) {
    late Color output;
    if (isPriority) {
      output = status == '1'
          ? MyColor.pendingColor
          : status == '2'
              ? MyColor.greenSuccessColor
              : status == '3'
                  ? MyColor.redCancelTextColor
                  : MyColor.pendingColor;
    } else {
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

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath()) ?? '';
    final savedDir = Directory(_localPath);
    final bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        return directory.path;
      } else {
        return (await getExternalStorageDirectory())?.path ?? "";
      }
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      return null;
    }
  }

  Future<void> downloadAttachment(
    String url,
    int index,
    String extension,
  ) async {
    final l10n = _l10n;

    selectedIndex = index;
    isSubmitLoading = true;
    update();

    await _prepareSaveDir();

    final headers = {
      'Authorization': "Bearer ${repo.apiClient.token}",
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      final appName = l10n?.appName ?? 'app';
      await saveAndOpenFile(
        bytes,
        '${appName}_${DateTime.now()}.$extension',
        extension,
      );
    } else {
      try {
        AuthorizationResponseModel model =
            AuthorizationResponseModel.fromJson(jsonDecode(response.body));
        CustomSnackBar.error(
          errorList:
              model.message?.error ?? [l10n?.somethingWentWrong ?? 'Error'],
        );
      } catch (e) {
        CustomSnackBar.error(
          errorList: [l10n?.somethingWentWrong ?? 'Error'],
        );
      }
    }

    selectedIndex = -1;
    isSubmitLoading = false;
    update();
  }

  Future<void> saveAndOpenFile(
    Uint8List bytes,
    String fileName,
    String extension,
  ) async {
    final l10n = _l10n;

    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      if (extension == 'pdf' || extension == 'doc' || extension == 'docx') {
        await OpenFile.open(filePath);
      } else {
        CustomSnackBar.error(
          errorList: [
            l10n?.unsupportedFileType ?? 'Unsupported file type',
          ],
        );
      }
    } else {
      CustomSnackBar.error(
        errorList: [
          l10n?.unableToAccessStorage ?? 'Unable to access storage',
        ],
      );
    }
  }

  Future<void> saveAndOpenPDF(List<int> bytes, String fileName) async {
    final path = '$_localPath/$fileName';
    final file = File(path);
    await file.writeAsBytes(bytes);
    await openPDF(path);
  }

  Future<void> openPDF(String path) async {
    final l10n = _l10n;

    final file = File(path);
    if (await file.exists()) {
      final result = await OpenFile.open(path);
      if (result.type == ResultType.done) {
        // opened successfully
      } else {
        CustomSnackBar.error(
          errorList: [l10n?.fileNotFound ?? 'File not found'],
        );
      }
    } else {
      CustomSnackBar.error(
        errorList: [l10n?.fileNotFound ?? 'File not found'],
      );
    }
  }
}

