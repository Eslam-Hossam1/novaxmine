import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/views/screens/deposits/create_deposite/widgets/deposite_cancel_button.dart';
import 'package:mine_lab/views/screens/deposits/create_deposite/widgets/deposite_confirm_button.dart';
import 'package:mine_lab/views/screens/deposits/create_deposite/widgets/sliver_sticky_footer.dart';

class ConfirmDepositScreen extends StatefulWidget {
  final String network;
  final String walletAddress;

  const ConfirmDepositScreen({
    super.key,
    this.network = 'BSC (BEP20)',
    this.walletAddress = '0xd4fd873d88b20155064ab799027baeb16e1a3f',
  });

  @override
  State<ConfirmDepositScreen> createState() => _ConfirmDepositScreenState();
}

class _ConfirmDepositScreenState extends State<ConfirmDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _transactionIdController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _transactionIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitConfirmation() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    Get.defaultDialog(
      title: 'Confirmation Submitted',
      middleText:
          'Your deposit confirmation is being reviewed. We will notify you soon.',
      textConfirm: 'OK',
      confirmTextColor: MyColor.colorWhite,
      onConfirm: Get.back,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * .05,
                ),
              ),
              SliverToBoxAdapter(
                child: Text(
                  'Confirm Your Deposit',
                  style: interSemiBoldDefault.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ConfirmDepositField(
                        label: 'Selected Network',
                        initialValue: widget.network,
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      _ConfirmDepositField(
                        label: 'Wallet Address',
                        initialValue: widget.walletAddress,
                        enabled: false,
                        maxLines: null,
                      ),
                      const SizedBox(height: 16),
                      _ConfirmDepositField(
                        label: 'Transaction ID / Hash',
                        controller: _transactionIdController,
                        hintText: 'Enter your transaction hash',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the transaction hash';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _ConfirmDepositField(
                        label: 'Amount Transferred',
                        controller: _amountController,
                        hintText: 'Enter transferred amount',
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Amount must be numeric';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Enter the amount in the same coin / network you transferred.',
                        style: interMediumDefault.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverStickyFooter(
                bottomPadding: 24,
                children: [
                  DepositeCancelButton(
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(height: 12),
                  DepositeConfirmButton(
                    onPressed: _submitConfirmation,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmDepositField extends StatelessWidget {
  final String label;
  final int? maxLines;
  final bool enabled;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _ConfirmDepositField({
    required this.label,
    this.enabled = true,
    this.maxLines=1,
    this.controller,
    this.initialValue,
    this.hintText,
    this.keyboardType,
    this.validator,
  }) : assert(
          controller == null || initialValue == null,
          'controller and initialValue cannot be provided together',
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: interMediumDefault.copyWith(
            fontSize: 14,
            color: MyColor.colorBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          controller: enabled ? controller : null,
          initialValue: enabled ? null : initialValue,
          readOnly: !enabled,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          style: interMediumDefault.copyWith(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            // filled: !enabled,
            // fillColor: enabled ? null : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: MyColor.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
