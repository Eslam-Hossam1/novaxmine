import 'package:flutter/material.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/views/screens/deposits/create_deposite/widgets/deposite_crypto_item.dart';

class CreateDepositeScreen extends StatelessWidget {
  const CreateDepositeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: MyColor.primaryColor,
        title: Text(
          'Deposit via Crypto Coins',
          style: interBoldMediumLarge.copyWith(
            color: MyColor.colorWhite,
          ),
        ),
      ),
      body: SafeArea(
          child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: 15,
        itemBuilder: (context, index) {
          return DepositeCryptoItem();
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 20,
          );
        },
      )),
    );
  }
}
