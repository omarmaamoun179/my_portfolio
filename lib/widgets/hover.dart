import 'package:flutter/material.dart';

/// Tiny hover-state helper so cards/buttons can lift, recolor borders, and
/// glow on pointer-over — replicating the prototype's CSS `:hover` transitions.
class Hover extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovering) builder;
  final MouseCursor cursor;

  const Hover({
    super.key,
    required this.builder,
    this.cursor = SystemMouseCursors.click,
  });

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: widget.builder(context, _hovering),
    );
  }
}
