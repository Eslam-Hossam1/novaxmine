import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/data/controller/kyc_controller/kyc_controller.dart';
import 'package:mine_lab/data/model/kyc/kyc_response_model.dart';
import 'package:mine_lab/views/screens/auth/kyc/widget/widget/choose_file_list_item.dart';

class ConfirmKycFileItem extends StatefulWidget {
  final int index;

  const ConfirmKycFileItem({super.key, required this.index});

  @override
  State<ConfirmKycFileItem> createState() => _ConfirmKycFileItemState();
}

class _ConfirmKycFileItemState extends State<ConfirmKycFileItem> {
  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    return GetBuilder<KycController>(builder: (controller) {
      GlobalFormModel? model = controller.formList[widget.index];
      return InkWell(
          onTap: () {
            controller.pickFile(widget.index);
          },
          child: ChooseFileItem(
              fileName: model.selectedValue ?? MyStrings!.chooseFile));
    });
  }
}

