import 'package:flutter/material.dart';
import 'package:todoflutter/util/colors.dart';

class CommonElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
final String? txt;
final bool isFromHome;
  const CommonElevatedButton({
    Key? key,
    required this.onPressed,
     this.icon,
    this.txt,
    required this.isFromHome
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: AppColors.primaryColor,
        shape: isFromHome?const CircleBorder():const RoundedRectangleBorder(),
        padding: EdgeInsets.all(16),
      ),
      child: icon==null?Text(txt!):Icon(icon, color: AppColors.whiteColor),
    );
  }
}
