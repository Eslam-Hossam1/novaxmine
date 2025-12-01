import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/deposit/coin_wallet_controller.dart';
import 'package:mine_lab/data/repo/deposit/deposit_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/screens/deposits/create_deposite/widgets/deposite_crypto_item.dart';

class CreateDepositeScreen extends StatefulWidget {
  const CreateDepositeScreen({super.key});

  @override
  State<CreateDepositeScreen> createState() => _CreateDepositeScreenState();
}

class _CreateDepositeScreenState extends State<CreateDepositeScreen> {
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
          backgroundColor: MyColor.screenBgColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Get.back(),
            ),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            backgroundColor: const Color(0xff212121),
            title: Text(
              MyStrings?.createDepositScreenAppBarText ??
                  'Deposit via Crypto Coins',
              style: interBoldMediumLarge.copyWith(
                color: MyColor.colorWhite,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
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
              style: interMediumDefault,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: controller.fetchCoinWallets,
              child: Text(MyStrings?.retry ?? 'Retry'),
            ),
          ],
        ),
      );
    }

    if (controller.wallets.isEmpty) {
      return Center(
        child: Text(
          MyStrings?.noDataToShow ?? 'No coin wallets found.',
          style: interMediumDefault,
        ),
      );
    }

    return ListView.separated(
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
