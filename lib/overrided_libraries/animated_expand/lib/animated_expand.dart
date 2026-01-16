import 'package:flutter/material.dart';

/// Defines the possible states for expansion.
enum ExpandState {
  /// The state when the widget is fully expanded.
  expanded,

  /// The state when the widget is fully collapsed.
  collapsed;

  /// Returns `true` if the state is [expanded].
  bool get isExpanded => this == ExpandState.expanded;

  /// Returns `true` if the state is [collapsed].
  bool get isCollapsed => this == ExpandState.collapsed;
}

/// A controller to manage the expansion state of [AnimatedExpand].
///
/// Allows programmatic control of expansion and collapse.
class ExpandController extends ValueNotifier<ExpandState> {
  /// Creates an [ExpandController] with an optional initial state.
  ///
  /// The default state is [ExpandState.collapsed].
  ExpandController({ExpandState initialValue = ExpandState.collapsed})
      : super(initialValue);

  /// Expands the widget if it's not already expanded.
  void expand() {
    if (value.isExpanded) return;

    value = ExpandState.expanded;
    notifyListeners();
  }

  /// Collapses the widget if it's not already collapsed.
  void collapse() {
    if (value.isCollapsed) return;

    value = ExpandState.collapsed;
    notifyListeners();
  }

  /// Toggles between expanded and collapsed states.
  void toggle() {
    value = value.isCollapsed ? ExpandState.expanded : ExpandState.collapsed;
    notifyListeners();
  }

  /// Returns `true` if the widget is currently expanded.
  bool get isExpanded => value.isExpanded;

  /// Returns `true` if the widget is currently collapsed.
  bool get isCollapsed => value.isCollapsed;
}

/// A customizable widget that expands and collapses with animation.
///
/// It supports both **vertical** and **horizontal** expansion, custom headers, and
/// external controllers for programmatic control.
class AnimatedExpand extends StatefulWidget {
  /// Creates an [AnimatedExpand] widget.
  ///
  /// By default, it starts in a collapsed state unless otherwise specified.
  const AnimatedExpand({
    super.key,
    required this.expandedHeader,
    this.collapsedHeader,
    this.content,
    this.controller,
    this.initialState = ExpandState.collapsed,
    this.axis = Axis.vertical,
    this.spacing = 0.0,
    this.curve = Curves.fastOutSlowIn,
    this.duration = Durations.medium1,
    this.reverseDuration = Duration.zero,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.clipBehavior = Clip.hardEdge,
    this.reversed = false,
    this.onEnd,
    this.animationAlignment = Alignment.center,
  });

  /// The controller used to manage the expand/collapse state.
  ///
  /// If not provided, the widget manages its own state internally.
  final ExpandController? controller;

  /// The widget displayed when the expand state is **expanded**.
  final Widget expandedHeader;

  /// The widget displayed when the expand state is **collapsed**.
  ///
  /// If `null`, [expandedHeader] will be used in both states.
  final Widget? collapsedHeader;

  /// The content that expands and collapses.
  final Widget? content;

  /// The initial state of the widget.
  final ExpandState initialState;

  /// The axis along which the widget expands. Default is [Axis.vertical].
  final Axis axis;

  /// The spacing between the header and the expandable content.
  final double spacing;

  /// The animation curve used for expansion and collapse.
  final Curve curve;

  /// The duration of the expansion animation.
  final Duration duration;

  /// The duration of the collapse animation.
  final Duration reverseDuration;

  /// Determines how much space the main axis should take.
  final MainAxisSize mainAxisSize;

  /// Defines how the child widgets are positioned along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// Defines how the child widgets are positioned along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// The clipping behavior applied to the expanding content.
  final Clip clipBehavior;

  /// If `true`, places the **content before the header**.
  final bool reversed;

  /// A callback triggered when the animation completes.
  final void Function()? onEnd;

  /// Defines how the expanding content is aligned within its available space.
  final AlignmentGeometry animationAlignment;

  @override
  State<AnimatedExpand> createState() => _AnimatedExpandState();
}

class _AnimatedExpandState extends State<AnimatedExpand> {
  late final ExpandController _ctrl;

  @override
  void initState() {
    super.initState();

    _ctrl = widget.controller ??
        ExpandController(initialValue: widget.initialState);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ExpandState>(
      valueListenable: _ctrl,
      builder: (context, expandState, child) {
        return widget.axis == Axis.horizontal
            ? Row(
                spacing: widget.spacing,
                mainAxisSize: widget.mainAxisSize,
                mainAxisAlignment: widget.mainAxisAlignment,
                crossAxisAlignment: widget.crossAxisAlignment,
                children: _children(expandState),
              )
            : Column(
                spacing: widget.spacing,
                mainAxisSize: widget.mainAxisSize,
                mainAxisAlignment: widget.mainAxisAlignment,
                crossAxisAlignment: widget.crossAxisAlignment,
                children: _children(expandState),
              );
      },
    );
  }

  List<Widget> _children(ExpandState expandState) {
    if (widget.reversed) {
      return [_animatedSize(expandState), _header(expandState)];
    }

    return [_header(expandState), _animatedSize(expandState)];
  }

  Widget _header(ExpandState expandState) {
    final headerContent =
        expandState.isCollapsed && widget.collapsedHeader != null
            ? widget.collapsedHeader!
            : widget.expandedHeader;

    if (widget.controller != null) {
      return headerContent;
    }

    return GestureDetector(
      onTap: _ctrl.toggle,
      child: headerContent,
    );
  }

  Widget _animatedSize(ExpandState expandState) => AnimatedSize(
        alignment: widget.animationAlignment,
        onEnd: widget.onEnd,
        duration: widget.duration,
        reverseDuration: widget.reverseDuration,
        curve: widget.curve,
        clipBehavior: widget.clipBehavior,
        child: AnimatedSwitcher(
          switchInCurve: widget.curve,
          switchOutCurve: widget.curve,
          duration: widget.duration,
          reverseDuration: widget.reverseDuration,
          child: expandState.isExpanded
              ? KeyedSubtree(
                  child: widget.content ?? const SizedBox.shrink(),
                )
              : const SizedBox.shrink(),
        ),
      );
}
