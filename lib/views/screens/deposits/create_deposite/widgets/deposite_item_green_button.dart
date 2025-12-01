import 'package:flutter/material.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';

class DepositeItemGreenButton extends StatelessWidget {
  const DepositeItemGreenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: MyColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {},
        child: Text(
          'Deposite with BSC',
          style: interMediumLarge.copyWith(
            color: MyColor.colorWhite,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
