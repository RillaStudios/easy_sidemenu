import 'package:flutter/material.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_item_with_global.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';

import 'global/global.dart';

class SideMenuExpansionItemWithGlobal extends StatefulWidget {
  /// #### Side Menu Item
  ///
  /// This is a widget as [SideMenu] items with text and icon
  /// Fold name
  final String? title;

  /// Global object of [SideMenu]
  final Global global;

  /// A Icon to display before [title]
  final Icon? icon;

  /// This is displayed instead if [icon] is null
  final Widget? iconWidget;

  /// The Children widgets
  final List<SideMenuItemWithGlobal> children;

  /// for maintaining record of the state
  final int index;

  /// The icon to display when the menu is expanded
  final IconData? expandedOpenIcon;

  /// The icon to display when the menu is collapsed
  final IconData? expandedCloseIcon;

  /// Bool to show the divider or not
  final bool? showDivider;

  /// Divider thickness
  final double? dividerThickness;

  /// Divider height
  final double? dividerHeight;

  /// A function that will be called when tap on [SideMenuExpansionItem] corresponding
  /// to this [SideMenuExpansionItem]
  final void Function(int index, SideMenuController sideMenuController, bool isExpanded)? onTap;

  const SideMenuExpansionItemWithGlobal(
      {Key? key,
      required this.global,
      this.title,
      this.icon,
      this.iconWidget,
      this.expandedOpenIcon,
      this.expandedCloseIcon,
      this.showDivider,
      this.dividerThickness,
      this.dividerHeight,
      this.onTap,
      required this.index,
      required this.children})
      : assert(title != null || icon != null, 'Title and icon should not be empty at the same time'),
        super(key: key);

  @override
  State<SideMenuExpansionItemWithGlobal> createState() => _SideMenuExpansionState();
}

class _SideMenuExpansionState extends State<SideMenuExpansionItemWithGlobal> {
  /// Set icon for of [SideMenuExpansionItemWithGlobal]
  late bool isExpanded;

  ValueNotifier<bool> isHovered = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    isExpanded = widget.global.expansionStateList[widget.index];
  }

  // Generates an icon widget based on the main icon and icon widget provided.
  // If the main icon is null, returns the icon widget or a SizedBox if no icon widget is provided.
  // Determines the icon color and size based on the expansion state and global styling.
  // Returns an Icon widget with the specified icon, color, and size.
  Widget _generateIconWidget(Icon? mainIcon, Widget? iconWidget) {
    if (mainIcon == null) return iconWidget ?? const SizedBox();

    final bool isExpanded = widget.global.expansionStateList[widget.index];
    final Color iconColor = isExpanded
        ? widget.global.style.selectedIconColorExpandable ?? widget.global.style.selectedColor ?? Colors.black
        : widget.global.style.unselectedIconColorExpandable ??
            widget.global.style.unselectedIconColor ??
            Colors.black54;
    final double iconSize = widget.global.style.iconSizeExpandable ?? widget.global.style.iconSize ?? 24;

    return Icon(mainIcon.icon, color: iconColor, size: iconSize);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isExpanded && widget.showDivider == true)
          Divider(
            color: widget.global.style.expandedDividerColor ?? Colors.black,
            height: widget.dividerHeight ?? 0.5,
            thickness: widget.dividerThickness ?? 0.5,
          ),
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
              widget.global.expansionStateList[widget.index] = isExpanded;
            });
            widget.onTap?.call(widget.index, widget.global.controller, isExpanded);
          },
          onHover: (value) {
            isHovered.value = value;
          },
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Padding(
            padding: widget.global.style.itemOuterPadding,
            child: ValueListenableBuilder<bool>(
              valueListenable: isHovered,
              builder: (context, value, child) {
                return Container(
                  height: widget.global.style.itemHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: widget.global.style.itemBorderRadius,
                    color: value ? widget.global.style.hoverColor : widget.global.style.backgroundColor,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: widget.global.displayModeState,
                    builder: (context, value, child) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: widget.global.style.itemInnerSpacing),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: widget.global.style.itemInnerSpacing * 2),
                                _generateIconWidget(widget.icon, widget.iconWidget),
                                SizedBox(width: widget.global.style.itemInnerSpacing),
                                (value == SideMenuDisplayMode.open)
                                    ? Text(
                                        widget.title ?? '',
                                        style: widget.global.expansionStateList[widget.index]
                                            ? const TextStyle(fontSize: 17, color: Colors.black).merge(
                                                widget.global.style.selectedTitleTextStyleExpandable ??
                                                    widget.global.style.selectedTitleTextStyle)
                                            : const TextStyle(fontSize: 17, color: Colors.black54).merge(
                                                widget.global.style.unselectedTitleTextStyleExpandable ??
                                                    widget.global.style.unselectedTitleTextStyle),
                                      )
                                    : const Text(''),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  isExpanded
                                      ? (widget.expandedOpenIcon ?? Icons.expand_less)
                                      : (widget.expandedCloseIcon ?? Icons.expand_more),
                                  color: isExpanded ? widget.global.style.arrowOpen : widget.global.style.arrowCollapse,
                                ),
                                SizedBox(
                                  width: widget.global.style.itemInnerSpacing * 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        if (isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.children,
              if (isExpanded && widget.showDivider == true)
                Divider(
                  color: widget.global.style.expandedDividerColor ?? Colors.black,
                  height: widget.dividerHeight ?? 0.5,
                  thickness: widget.dividerThickness ?? 0.5,
                ),
            ],
          ),
      ],
    );
  }
}
