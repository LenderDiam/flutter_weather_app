import 'package:flutter/material.dart';

/// A button widget that toggles between expanded and collapsed states,
/// displaying different labels and icons accordingly.
///
/// Typically used to show or hide additional content, such as in expandable panels,
/// FAQ sections, or any UI element requiring a visible expand/collapse action.
///
/// Example usage:
/// ```dart
/// ExpandableButton(
///   expanded: isExpanded,
///   expandedLabel: 'Show less',
///   collapsedLabel: 'Show more',
///   onPressed: toggleExpanded,
/// )
/// ```
///
/// Fields:
/// - [expanded]: Whether the button is currently in the expanded state. (Required)
/// - [expandedLabel]: The label to display when expanded. (Required)
/// - [collapsedLabel]: The label to display when collapsed. (Required)
/// - [onPressed]: Callback invoked when the button is pressed. (Required)
/// - [expandedIcon]: Icon to display when expanded. Defaults to [Icons.expand_less]. (Optional)
/// - [collapsedIcon]: Icon to display when collapsed. Defaults to [Icons.expand_more]. (Optional)
/// - [iconColor]: The color of the icon. Defaults to the primary color of the current theme. (Optional)
/// - [textStyle]: The style of the label text. Defaults to [Theme.of(context).textTheme.bodyMedium]. (Optional)

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
