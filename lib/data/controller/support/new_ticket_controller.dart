import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/controller/support/support_controller.dart';
import 'package:mine_lab/data/model/support/new_ticket_store_model.dart';
import 'package:mine_lab/data/repo/support/support_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class NewTicketController extends GetxController {
  final SupportRepo repo;
  NewTicketController({required this.repo});

  bool isLoading = false;

  final FocusNode subjectFocusNode = FocusNode();
  final FocusNode priorityFocusNode = FocusNode();
  final FocusNode messageFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  /// نصوص تعتمد على الـ l10n
  String noFileChosen = '';
  String chooseFile = '';

  bool isRtl = false;

  /// قائمة الأولوية (مترجمة)
  List<String> priorityList = [];
  String? selectedPriority;

  List<File> attachmentList = [];

  /// يتم استدعاؤها من الـ Widget (مثلاً في initState أو في build أول مرة)
  void initTexts(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    noFileChosen = l10n.noFileChosen;
    chooseFile = l10n.chooseFile;

    priorityList = [
      l10n.low,
      l10n.medium,
      l10n.high,
    ];

    selectedPriority = priorityList.isNotEmpty ? priorityList.first : null;

    // تحديد اتجاه اللغة
    isRtl = Directionality.of(context) == TextDirection.rtl;

    update();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result == null) return;

    for (var i = 0; i < result.files.length; i++) {
      attachmentList.add(File(result.files[i].path!));
    }
    update();
  }

  void removeAttachmentFromList(int index) {
    if (attachmentList.length > index) {
      attachmentList.removeAt(index);
      update();
    }
  }

  /// هنا نحتاج الـ context فقط لرسالة الخطأ
  void addNewAttachment(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (attachmentList.length > 4) {
      CustomSnackBar.error(
        errorList: [l10n.somethingWentWrong],
      );
      return;
    }

    update();
  }

  void refreshAttachmentList() {
    attachmentList.clear();
    update();
  }

  int selectedIndex = 0;
  void setPriority(String? newValue) {
    selectedPriority = newValue;
    if (newValue != null) {
      selectedIndex = priorityList.indexOf(newValue);
    }
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

  bool submitLoading = false;

  /// عدّلناها لتستقبل BuildContext عشان نجيب النصوص من AppLocalizations
  Future<void> submit(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String subject = subjectController.text.trim();
    final String priority = "${selectedIndex + 1}";
    final String message = messageController.text.trim();

    if (message.isEmpty) {
      CustomSnackBar.error(
        errorList: [l10n.messageRequired],
      );
      return;
    }

    if (subject.isEmpty) {
      CustomSnackBar.error(
        errorList: [l10n.subjectRequired],
      );
      return;
    }

    submitLoading = true;
    update();

    final TicketStoreModel model = TicketStoreModel(
      name: name,
      email: email,
      subject: subject,
      priority: priority,
      message: message,
      list: attachmentList,
    );

    final bool isSuccess = await repo.storeTicket(context, model);

    try {
      if (isSuccess) {
        Get.find<SupportController>().loadData(context);
        Get.back();
        CustomSnackBar.success(
          successList: [l10n.ticketCreateSuccessfully],
        );
        clearSelectedData();
      }
    } catch (e) {
      printX(e);
    }

    submitLoading = false;
    update();
  }

  void clearSelectedData() {
    subjectController.text = '';
    messageController.text = '';
    refreshAttachmentList();
  }
}

