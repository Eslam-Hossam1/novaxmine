import 'package:flutter/material.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';

import 'deposite_item_blue_container_with_text.dart';
import 'deposite_item_green_button.dart';

class DepositeCryptoItem extends StatelessWidget {
  const DepositeCryptoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 250),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.sizeOf(context).width * .7,
      decoration: BoxDecoration(
        border: Border.all(color: MyColor.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        color: MyColor.colorWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BSC',
            style: interMediumOverLarge,
          ),
          const SizedBox(height: 8),
          const DepositeItemBlueContainerWithText(),
          const SizedBox(height: 16),
          Text(
            'Withdraw Address: ',
            style: interMediumLarge.copyWith(
              color: MyColor.bodyTextColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '0xd4fd873d88b20155064ab799027baeb16e1a3f12',
            style: interMediumLarge.copyWith(
              color: MyColor.bodyTextColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          const DepositeItemGreenButton(),
        ],
      ),
    );
  }
}
