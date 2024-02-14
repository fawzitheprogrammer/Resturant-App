import 'package:flutter/material.dart';

class TextHoverWidget extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  const TextHoverWidget({super.key,required this.builder});

  @override
  State<TextHoverWidget> createState() => _TextHoverWidgetState();
}

class _TextHoverWidgetState extends State<TextHoverWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: widget.builder(isHovered),
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }

}
