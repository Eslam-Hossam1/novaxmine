import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/deposit/confirm_coin_wallet_controller.dart';
import 'package:mine_lab/data/repo/deposit/deposit_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/views/screens/deposits/create_deposite/widgets/confirm_deposit_field.dart';
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
  late final ConfirmCoinWalletController _confirmController;
  int? _walletId;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  void initState() {
    super.initState();
    _ensureDependencies();
    _confirmController =
        Get.put(ConfirmCoinWalletController(depositRepo: Get.find()));
  }

  void _ensureDependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<DepositRepo>()) {
      Get.put(DepositRepo(apiClient: Get.find()));
    }
  }

  @override
  void dispose() {
    _transactionIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitConfirmation() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
      return;
    }

    final walletId = _walletId;
    if (walletId == null) {
      CustomSnackBar.error(errorList: ['Wallet information missing']);
      return;
    }

    final txHash = _transactionIdController.text.trim();
    final amount = _amountController.text.trim();

    final success = await _confirmController.submitCoinWalletDeposit(
      coinWalletId: walletId,
      txHash: txHash,
      amount: amount,
    );

    if (success) {
      Get.offAllNamed(RouteHelper.depositHistoryScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final selectedNetwork = args?['network'] as String? ?? widget.network;
    final walletAddress =
        args?['walletAddress'] as String? ?? widget.walletAddress;
    _walletId = args?['walletId'] as int? ?? _walletId;
    final strings = AppLocalizations.of(context);
    return GetBuilder<ConfirmCoinWalletController>(
      init: _confirmController,
      builder: (controller) {
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
                      strings?.confirmYourDeposit ?? 'Confirm Your Deposit',
                      style: interSemiBoldDefault.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConfirmDepositField(
                            label:
                                strings?.selectedNetwork ?? 'Selected Network',
                            initialValue: selectedNetwork,
                            enabled: false,
                          ),
                          const SizedBox(height: 16),
                          ConfirmDepositField(
                            label: strings?.walletAddress ?? 'Wallet Address',
                            initialValue: walletAddress,
                            enabled: false,
                            maxLines: null,
                          ),
                          const SizedBox(height: 16),
                          ConfirmDepositField(
                            label: strings?.transactionIdHash ??
                                'Transaction ID / Hash',
                            controller: _transactionIdController,
                            hintText: strings?.enterTransactionHash ??
                                'Enter your transaction hash',
                            isRequired: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return strings?.enterTransactionHash ??
                                    'Please enter the transaction hash';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ConfirmDepositField(
                            label: strings?.amountTransferred ??
                                'Amount Transferred',
                            controller: _amountController,
                            hintText: strings?.enterTransferredAmount ??
                                'Enter transferred amount',
                            isRequired: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return strings?.enterTransferredAmount ??
                                    'Please enter the amount';
                              }
                              if (int.tryParse(value) == null) {
                                return strings?.amountMustBeNumeric ??
                                    'Amount must be numeric without decimal point';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            strings?.enterSameNetworkAmount ??
                                'Enter the amount in the same coin / network you transferred.',
                            style: interMediumDefault.copyWith(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
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
                        title:
                            AppLocalizations.of(context)?.confirmYourDeposit ??
                                'Confirm Your Deposit',
                        onPressed: _submitConfirmation,
                        isLoading: controller.isSubmitting,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
