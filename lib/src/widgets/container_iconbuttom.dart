import 'package:clima_app/src/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerIconbutton extends StatelessWidget {
  final String image;
  final double border;
  final VoidCallback onPressed;
  final bool selected;
  final double? height;
  final double? width;
  const ContainerIconbutton({
    super.key,
    required this.image,
    required this.border,
    required this.onPressed,
    this.selected = false,
    this.height = 30.0,
    this.width = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.text,
        borderRadius: BorderRadius.circular(border),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: selected == false
            ? Image.asset(
                image,
                height: height,
                width: width,
              )
            : Image.network(
                image,
                height: height,
                width: width,
              ),
      ),
    );
  }
}
