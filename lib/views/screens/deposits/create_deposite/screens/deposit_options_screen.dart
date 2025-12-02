import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/deposit/coin_wallet_controller.dart';
import 'package:mine_lab/data/repo/deposit/deposit_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/screens/deposits/create_deposite/theme/deposit_theme_extension.dart';
import 'package:mine_lab/views/screens/deposits/create_deposite/widgets/deposite_crypto_item.dart';

class DepositOptionsScreen extends StatefulWidget {
  const DepositOptionsScreen({super.key});

  @override
  State<DepositOptionsScreen> createState() => _DepositOptionsScreenState();
}

class _DepositOptionsScreenState extends State<DepositOptionsScreen> {
  late final CoinWalletController _controller;

  @override
  void initState() {
    super.initState();
    _initDependencies();
    _controller = Get.put(CoinWalletController(depositRepo: Get.find()));
  }

  void _initDependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()));
    }
    if (!Get.isRegistered<DepositRepo>()) {
      Get.put(DepositRepo(apiClient: Get.find()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = AppLocalizations.of(context);

    return GetBuilder<CoinWalletController>(
      init: _controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor: context.depositScaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: context.depositAppBarForeground,
              ),
              onPressed: () => Get.back(),
            ),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            backgroundColor: context.depositAppBarBackground,
            title: Text(
              MyStrings?.createDepositScreenAppBarText ??
                  'Deposit via Crypto Coins',
              style: interBoldMediumLarge.copyWith(
                color: context.depositAppBarForeground,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
              ),
              child: _buildBody(controller, MyStrings),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
      CoinWalletController controller, AppLocalizations? MyStrings) {
    if (controller.isLoading) {
      return const Center(child: CustomLoader());
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.errorMessage ??
                  (MyStrings?.somethingWentWrong ?? 'Something went wrong'),
              textAlign: TextAlign.center,
              style: interMediumDefault.copyWith(
                  fontSize: 16, color: context.depositPrimaryTextColor),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: controller.fetchCoinWallets,
              child: Text(
                MyStrings?.retry ?? 'Retry',
                style: interBoldLarge.copyWith(
                    fontSize: 16, color: context.depositColorScheme.primary),
              ),
            ),
          ],
        ),
      );
    }

    if (controller.wallets.isEmpty) {
      return Center(
        child: Text(
          MyStrings?.noDataToShow ?? 'No coin wallets found.',
          style: interMediumDefault.copyWith(
            color: context.depositPrimaryTextColor,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(top: 20),
      itemCount: controller.wallets.length,
      itemBuilder: (context, index) {
        final wallet = controller.wallets[index];
        final title = wallet.network ?? 'N/A';
        final subtitle = wallet.standard ?? '';
        final address = wallet.walletAddress ?? '';
        final walletId = wallet.id;

        return DepositeCryptoItem(
          coinTitle: title,
          coinSubtitle: subtitle.isEmpty ? '—' : subtitle,
          withdrawAddress: address,
          onDepositPressed: () {
            Get.toNamed(
              RouteHelper.depositeInstructionsScreen,
              arguments: {
                'coinTitle': title,
                'coinSubtitle': subtitle,
                'withdrawAddress': address,
                'walletId': walletId,
              },
            );
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 20),
    );
  }
}
