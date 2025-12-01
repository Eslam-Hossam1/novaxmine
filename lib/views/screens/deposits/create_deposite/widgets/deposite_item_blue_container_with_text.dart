import 'package:flutter/material.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/styles.dart';

class DepositeItemBlueContainerWithText extends StatelessWidget {
  const DepositeItemBlueContainerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 35,
      decoration: BoxDecoration(
        color: const Color(0xff0D6EFD),
        borderRadius: BorderRadius.circular(
          Dimensions.defaultRadius,
        ),
      ),
      child: Center(
        child: Text(
          'BEP20',
          style: interBoldDefault.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
