import 'package:flutter/material.dart';

import 'scroll_in_view.dart';

/// Count-up number that animates from 0 to [target] when scrolled into view,
/// then formats with thousands separators. Mirrors the prototype's
/// `animateCount` (1.5s, ease-out cubic).
class AnimatedCounter extends StatefulWidget {
  final num target;
  final int decimals;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.target,
    this.decimals = 0,
    this.style,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin, ScrollInViewMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  double get inViewMargin => 0.0;

  @override
  void onEnterView() {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(double v) {
    if (widget.decimals > 0) return v.toStringAsFixed(widget.decimals);
    final n = v.round();
    final s = n.toString();
    // Thousands separators (toLocaleString equivalent).
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final eased = Curves.easeOutCubic.transform(_controller.value);
        return Text(
          _format(widget.target * eased),
          style: widget.style,
        );
      },
    );
  }
}
