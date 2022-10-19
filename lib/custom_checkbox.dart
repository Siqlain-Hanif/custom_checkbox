import 'package:custom_checkbox/radial_reaction_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.borderRadius,
    this.activeIcon,
    this.inactiveIcon,
    this.tristateIcon,
  }) : assert(tristate || value != null);

  final bool? value;

  final ValueChanged<bool?>? onChanged;

  final MouseCursor? mouseCursor;

  final MaterialStateProperty<Color?>? fillColor;
  final Color? activeColor;
  final Color? checkColor;

  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final IconData? tristateIcon;

  final bool tristate;

  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;

  final Color? focusColor;

  final Color? hoverColor;

  final MaterialStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final FocusNode? focusNode;

  final bool autofocus;

  final BorderRadius? borderRadius;

  ///Will support in future
  // final OutlinedBorder? shape;
  ///Will support in future
  // final BorderSide? side;

  static const double width = 18.0;
  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox>
    with TickerProviderStateMixin {
  // bool? _previousValue;
  Set<MaterialState> get states => <MaterialState>{
        if (!isInteractive) MaterialState.disabled,
        if (_hovering) MaterialState.hovered,
        if (_focused) MaterialState.focused,
        if (value ?? true) MaterialState.selected,
      };
  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _handleTap),
  };
  @override
  void initState() {
    super.initState();
    // _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      // _previousValue = oldWidget.value;
      // animateToValue();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ValueChanged<bool?>? get onChanged => widget.onChanged;
  bool get tristate => widget.tristate;
  bool? get value => widget.value;

  MaterialStateProperty<Color?> get _widgetFillColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return widget.activeColor;
      }
      return null;
    });
  }

  MaterialStateProperty<Color> get _defaultFillColor {
    final ThemeData themeData = Theme.of(context);
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return themeData.disabledColor;
      }
      if (states.contains(MaterialState.selected)) {
        return themeData.toggleableActiveColor;
      }
      return themeData.unselectedWidgetColor;
    });
  }

  BorderSide? _resolveSide(BorderSide? side) {
    if (side is MaterialStateBorderSide) {
      return MaterialStateProperty.resolveAs<BorderSide?>(side, states);
    }
    if (!states.contains(MaterialState.selected)) {
      return side;
    }
    return null;
  }

  bool get isInteractive => onChanged != null;
  bool _focused = false;
  void _handleFocusHighlightChanged(bool focused) {
    if (focused != _focused) {
      _focused = focused;
      setState(() {});
    }
  }

  bool _hovering = false;
  void _handleHoverEnter(PointerEnterEvent event) {
    if (!isInteractive) return;
    _downPosition = event.localPosition;
    _hovering = true;
    setState(() {});
  }

  void _handleHoverExit(PointerExitEvent event) {
    if (!isInteractive) return;
    _downPosition = event.localPosition;
    _hovering = false;
    setState(() {});
  }

  void _handleTap([Intent? _]) {
    if (!isInteractive) return;

    switch (value) {
      case false:
        onChanged!(true);
        break;
      case true:
        onChanged!(tristate ? null : false);
        break;
      case null:
        onChanged!(false);
        break;
    }
    context.findRenderObject()!.sendSemanticsEvent(const TapSemanticEvent());
  }

  Offset? get downPosition => _downPosition;
  Offset? _downPosition;

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) {
      _downPosition = details.localPosition;
      setState(() {});
    }
  }

  void _handleTapEnd([TapUpDetails? _]) {
    if (_downPosition != null) {
      _downPosition = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    final CheckboxThemeData checkboxTheme = CheckboxTheme.of(context);
    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        widget.materialTapTargetSize ??
            checkboxTheme.materialTapTargetSize ??
            themeData.materialTapTargetSize;
    final VisualDensity effectiveVisualDensity = widget.visualDensity ??
        checkboxTheme.visualDensity ??
        themeData.visualDensity;
    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Color effectiveActiveColor =
        widget.fillColor?.resolve(activeStates) ??
            _widgetFillColor.resolve(activeStates) ??
            checkboxTheme.fillColor?.resolve(activeStates) ??
            _defaultFillColor.resolve(activeStates);

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    final Color effectiveFocusOverlayColor =
        widget.overlayColor?.resolve(focusedStates) ??
            widget.focusColor ??
            checkboxTheme.overlayColor?.resolve(focusedStates) ??
            themeData.focusColor;

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    final Color effectiveHoverOverlayColor =
        widget.overlayColor?.resolve(hoveredStates) ??
            widget.hoverColor ??
            checkboxTheme.overlayColor?.resolve(hoveredStates) ??
            themeData.hoverColor;

    final Color effectiveBorderColor =
        widget.fillColor?.resolve(activeStates) ??
            _widgetFillColor.resolve(states) ??
            _defaultFillColor.resolve(states);
    final Color effectiveCheckColor = widget.checkColor ??
        checkboxTheme.checkColor?.resolve(states) ??
        const Color(0xFFFFFFFF);

    Size size;
    double iconSize;
    double marginAdjuster;
    double iconSizeAdjuster;
    EdgeInsets effectiveMargin;

    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        marginAdjuster = _kContainerPadddedMarginAdjuster;
        iconSizeAdjuster = _kPaddedIconSizeAdjuster;
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(
            kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
        marginAdjuster = _kContainerShrinkMarginAdjuster;
        iconSizeAdjuster = _kShrinkIconSizeAdjuster;
        break;
    }
    size += effectiveVisualDensity.baseSizeAdjustment;
    effectiveMargin = EdgeInsets.all(size.height / marginAdjuster);
    iconSize = size.height / iconSizeAdjuster;

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor =
        MaterialStateProperty.resolveWith<MouseCursor>(
            (Set<MaterialState> states) {
      return MaterialStateProperty.resolveAs<MouseCursor?>(
              widget.mouseCursor, states) ??
          checkboxTheme.mouseCursor?.resolve(states) ??
          MaterialStateMouseCursor.clickable.resolve(states);
    });
    BorderRadius effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(1.0);

    return Semantics(
      checked: widget.value ?? false,
      child: FocusableActionDetector(
        mouseCursor: effectiveMouseCursor.resolve(states),
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        enabled: isInteractive,
        onShowFocusHighlight: _handleFocusHighlightChanged,
        actions: _actionMap,
        child: MouseRegion(
          onEnter: _handleHoverEnter,
          onExit: _handleHoverExit,
          child: GestureDetector(
            excludeFromSemantics: !isInteractive,
            onTap: _handleTap,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapEnd,
            onTapCancel: _handleTapEnd,
            child: CustomPaint(
              size: size,
              painter: RadialReactionPainter()
                ..downPosition = _downPosition
                ..splashRadius = widget.splashRadius ?? kRadialReactionRadius
                ..hoverColor = effectiveHoverOverlayColor
                ..focusColor = effectiveFocusOverlayColor
                ..isHovered = _hovering
                ..isFocused = _focused,
              child: SizedBox.fromSize(
                size: size,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: effectiveMargin,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: effectiveBorderRadius,
                    border: Border.all(
                      width: 2.0,
                      color: value == true || value == null
                          ? Colors.transparent
                          : effectiveBorderColor,
                    ),
                    color: value == true || value == null
                        ? effectiveActiveColor
                        : Colors.transparent,
                  ),
                  child: getEffectiveIconWidgetStateWidget(
                    effectiveCheckColor,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? getEffectiveIconWidgetStateWidget(Color iconColor,
      {double size = 14}) {
    late final Widget? effectiveIconWidget;
    final effectiveActiveIcon = widget.activeIcon ?? Icons.check;
    final effectiveInactiveIcon = widget.inactiveIcon;
    final effectiveTristateIcon = widget.tristateIcon ?? Icons.remove;

    if (value == true) {
      effectiveIconWidget = _getIconBase(
        effectiveActiveIcon,
        iconColor,
        size,
      );
    } else if (value == false) {
      if (effectiveInactiveIcon != null) {
        effectiveIconWidget = _getIconBase(
          effectiveInactiveIcon,
          iconColor,
          size,
        );
      } else {
        effectiveIconWidget = null;
      }
    } else {
      //tristate
      effectiveIconWidget = _getIconBase(
        effectiveTristateIcon,
        iconColor,
        size,
      );
    }
    return effectiveIconWidget;
  }

  Widget _getIconBase(IconData icon, Color color, double size) {
    return Text(
      String.fromCharCode(icon.codePoint),
      style: TextStyle(
        inherit: false,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );
  }
}

const double _kContainerPadddedMarginAdjuster = 4.0;
const double _kContainerShrinkMarginAdjuster = 4.5;
const double _kPaddedIconSizeAdjuster = 2.8;
const double _kShrinkIconSizeAdjuster = 2.75;
