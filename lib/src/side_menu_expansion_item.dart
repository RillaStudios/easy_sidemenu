import 'package:flutter/material.dart';
import 'package:easy_sidemenu/src/side_menu_item.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';

class SideMenuExpansionItem {
  /// #### Side Menu Item
  ///
  /// This is a widget as [SideMenu] items with text and icon

  /// name
  final String? title;

  /// A function that will be called when tap on [SideMenuExpansionItem] corresponding
  /// to this [SideMenuExpansionItem]
  final void Function(int index, SideMenuController sideMenuController, bool isExpanded)? onTap;

  /// A Icon to display before [title]
  final Icon? icon;

  /// This is displayed instead if [icon] is null
  final Widget? iconWidget;

  final List<SideMenuItem> children;

  /// The icon to display when the menu is expanded
  final IconData? expandedOpenIcon;

  /// The icon to display when the menu is collapsed
  final IconData? expandedCloseIcon;

  /// The color of the divider between the menu items
  final Color? dividerColor;

  /// Bool to show the divider or not
  final bool? showDivider;

  /// Divider thickness
  final double? dividerThickness;

  /// Divider height
  final double? dividerHeight;

  /// Control whether or not the SideMenuExpansion should be expanded initialy or not.
  /// Default is collabsed
  final bool? initialExpanded;

  const SideMenuExpansionItem({
    Key? key,
    this.onTap,
    this.title,
    this.icon,
    this.iconWidget,
    this.initialExpanded,
    this.expandedOpenIcon,
    this.expandedCloseIcon,
    this.dividerColor,
    this.showDivider,
    this.dividerThickness,
    this.dividerHeight,
    required this.children,
  })  : assert(title != null || icon != null, 'Title and icon should not be empty at the same time'),
        super();
}
