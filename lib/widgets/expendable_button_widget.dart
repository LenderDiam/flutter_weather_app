import 'package:flutter/material.dart';

class ExpandableButton extends StatelessWidget {
  final bool expanded;
  final String expandedLabel;
  final String collapsedLabel;
  final VoidCallback onPressed;
  final IconData expandedIcon;
  final IconData collapsedIcon;
  final Color? iconColor;
  final TextStyle? textStyle;

  const ExpandableButton({
    super.key,
    required this.expanded,
    required this.expandedLabel,
    required this.collapsedLabel,
    required this.onPressed,
    this.expandedIcon = Icons.expand_less,
    this.collapsedIcon = Icons.expand_more,
    this.iconColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: Icon(
          expanded ? expandedIcon : collapsedIcon,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
        ),
        label: Text(
          expanded ? expandedLabel : collapsedLabel,
          style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
        onPressed: onPressed,
      ),
    );
  }
}