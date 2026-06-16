import 'package:flutter/material.dart';

/// Exposes the page [ScrollController] down the tree so scroll-driven widgets
/// (reveal animations, count-up stats) can react to scroll position without
/// each one owning a NotificationListener.
class ScrollProvider extends InheritedWidget {
  final ScrollController controller;

  const ScrollProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static ScrollController? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ScrollProvider>()
      ?.controller;

  @override
  bool updateShouldNotify(ScrollProvider oldWidget) =>
      oldWidget.controller != controller;
}

/// Fires [onEnterView] exactly once when the host widget scrolls into the
/// viewport. Reused by reveal animations and count-up numbers — matching the
/// prototype's scroll-position-based trigger (it deliberately avoided
/// IntersectionObserver).
mixin ScrollInViewMixin<T extends StatefulWidget> on State<T> {
  ScrollController? _controller;
  bool _entered = false;

  /// Margin from the bottom of the viewport, as a fraction of its height,
  /// before the widget counts as "in view".
  double get inViewMargin => 0.08;

  void onEnterView();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final c = ScrollProvider.maybeOf(context);
    if (c != _controller) {
      _controller?.removeListener(_check);
      _controller = c;
      _controller?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_entered || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final pos = box.localToGlobal(Offset.zero);
    final vh = MediaQuery.of(context).size.height;
    final margin = inViewMargin * vh;
    if (pos.dy < vh - margin && pos.dy + box.size.height > 0) {
      _entered = true;
      onEnterView();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_check);
    super.dispose();
  }
}
