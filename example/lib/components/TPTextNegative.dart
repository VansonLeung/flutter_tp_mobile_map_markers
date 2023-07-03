import 'package:flutter/material.dart';

class TPTextNegative extends StatelessWidget {
  final String? text;
  final TextAlign? textAlign;
  final Color color;
  final VoidCallback? onClick;
  final TextStyle? style;

  const TPTextNegative(this.text, {
    super.key,
    this.textAlign = TextAlign.left,
    this.color = const Color(0xFFFFFFFF),
    this.onClick,
    this.style,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      child: onClick == null
          ? Text(
        text ?? "",
        textAlign: textAlign,
        style: (style ?? TextStyle()).copyWith(
            color: color
        ),
      )
          : TextButton(
        onPressed: () {
          onClick?.call();
        },
        child: Text(
          text ?? "",
          textAlign: textAlign,
          style: (style ?? TextStyle()).copyWith(
              color: color
          ),
        ),
      ),
    );
  }
}