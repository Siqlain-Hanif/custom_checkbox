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
    this.shape,
    this.side,
  })  : assert(tristate || value != null),
        assert(autofocus != null);

  final bool? value;

  final ValueChanged<bool?>? onChanged;

  final MouseCursor? mouseCursor;

  final Color? activeColor;

  final MaterialStateProperty<Color?>? fillColor;

  final Color? checkColor;
  final bool tristate;

  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;

  final Color? focusColor;

  final Color? hoverColor;

  final MaterialStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  final FocusNode? focusNode;

  final bool autofocus;

  final OutlinedBorder? shape;

  final BorderSide? side;

  static const double width = 18.0;
  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox>
    with TickerProviderStateMixin {
  bool? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
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

  Set<MaterialState> get states => <MaterialState>{
        if (!isInteractive) MaterialState.disabled,
        if (_hovering) MaterialState.hovered,
        if (_focused) MaterialState.focused,
        if (value ?? true) MaterialState.selected,
      };
  bool _focused = false;
  void _handleFocusHighlightChanged(bool focused) {
    if (focused != _focused) {
      setState(() {
        _focused = focused;
      });
      if (focused) {
        // _reactionFocusFadeController.forward();
      } else {
        // _reactionFocusFadeController.reverse();
      }
    }
  }

  bool _hovering = false;
  void _handleHoverEnter(PointerEnterEvent event) {
    _downPosition = event.localPosition;
    _hovering = true;
    setState(() {});
  }

  void _handleHoverExit(PointerExitEvent event) {
    _downPosition = event.localPosition;
    _hovering = false;
    setState(() {});
  }

  void _handleTap([Intent? _]) {
    if (!isInteractive) {
      return;
    }
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
    Size size;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(
            kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
        break;
    }
    print(size);
    print(effectiveVisualDensity.baseSizeAdjustment);
    size += effectiveVisualDensity.baseSizeAdjustment;
    print(size);
    print(kMinInteractiveDimension);
    return Semantics(
      checked: widget.value ?? false,
      child: MouseRegion(
        onEnter: _handleHoverEnter,
        onExit: _handleHoverExit,
        // onHover: _handleHoverChanged,
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
              ..isHovered = _hovering,
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    width: 2.0,
                    color: value == true || value == null
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.5),
                  ),
                  color: value == true || value == null
                      ? Colors.blue
                      : Colors.transparent,
                ),
                child: getEffectiveIconWidgetStateWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? get getEffectiveIconWidgetStateWidget {
    late final Widget? effectiveIconWidget;
    if (value == true) {
      effectiveIconWidget = const Icon(
        Icons.check,
        size: 10,
      );
    } else if (value == false) {
      effectiveIconWidget = null;
    } else {
      effectiveIconWidget = const Icon(Icons.remove);
    }

    return effectiveIconWidget;
  }
}

// Duration of the animation that moves the toggle from one state to another.
const Duration _kToggleDuration = Duration(milliseconds: 200);

// Duration of the fade animation for the reaction when focus and hover occur.
const Duration _kReactionFadeDuration = Duration(milliseconds: 50);

const double _kEdgeSize = CustomCheckbox.width;
const double _kStrokeWidth = 2.0;
