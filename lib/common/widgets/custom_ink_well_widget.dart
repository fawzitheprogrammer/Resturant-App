import 'package:flutter/material.dart';

class CustomInkWellWidget extends StatelessWidget {
  final double? radius;
  final Widget child;
  final VoidCallback onTap;
  final Color? highlightColor;
  const CustomInkWellWidget({super.key, this.radius,required this.child,required this.onTap, this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? 0.0),
        highlightColor: highlightColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.05),
        child: child,
      ),
    );
  }
}

