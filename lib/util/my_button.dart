import 'package:flutter/material.dart';
import 'package:todoflutter/util/colors.dart';

class CommonElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const CommonElevatedButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: AppColors.primaryColor,
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
      ),
      child: Icon(icon, color: AppColors.whiteColor),
    );
  }
}
