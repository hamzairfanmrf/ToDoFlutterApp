import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CommonTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CommonTextButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}
