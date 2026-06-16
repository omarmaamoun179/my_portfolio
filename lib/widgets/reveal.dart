import 'package:flutter/material.dart';

import 'scroll_in_view.dart';

/// Entrance animation: a content block slides up + fades in once it enters the
/// viewport. Equivalent to the prototype's `.reveal` rule (0.75s,
/// cubic-bezier(0.22,0.61,0.36,1), staggered by delay class d1/d2/d3).
class Reveal extends StatefulWidget {
  final Widget child;

  /// Stagger delay in milliseconds (prototype: d1=100, d2=200, d3=300).
  final int delayMs;
  final double offsetY;

  const Reveal({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.offsetY = 24,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal>
    with SingleTickerProviderStateMixin, ScrollInViewMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );

  late final Animation<double> _anim = CurvedAnimation(
    parent: _controller,
    curve: const Cubic(0.22, 0.61, 0.36, 1),
  );

  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (_reduceMotion) _controller.value = 1;
  }

  @override
  void onEnterView() {
    if (_reduceMotion) {
      _controller.value = 1;
      return;
    }
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Opacity(
          opacity: _anim.value,
          child: Transform.translate(
            offset: Offset(0, widget.offsetY * (1 - _anim.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
