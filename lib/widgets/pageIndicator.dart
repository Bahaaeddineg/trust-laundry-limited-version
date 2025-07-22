import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class PageIndicator extends StatelessWidget {
  final bool isActive;

  const PageIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: width * .015,
      width: isActive ? width*.08:width * .04,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isActive ? AppColors.kBlueLight : AppColors.kBlack.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
