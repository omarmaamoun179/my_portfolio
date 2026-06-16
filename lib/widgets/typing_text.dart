import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';

/// Hero role line: types/deletes through a list of phrases with a blinking
/// caret. Mirrors the prototype's `bindTyping` timings (62ms type, 30ms
/// delete, 1500ms hold, 280ms gap).
class TypingText extends StatefulWidget {
  final List<String> words;
  final TextStyle style;
  final Color caretColor;

  const TypingText({
    super.key,
    required this.words,
    required this.style,
    required this.caretColor,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int _w = 0;
  int _c = 0;
  bool _deleting = false;
  String _text = '';
  Timer? _timer;
  bool _reduce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce && !_reduce) {
      _reduce = true;
      _timer?.cancel();
      setState(() => _text = widget.words.first);
    } else if (!reduce && _text.isEmpty && _timer == null) {
      _timer = Timer(const Duration(milliseconds: 600), _tick);
    }
  }

  void _tick() {
    if (!mounted) return;
    final word = widget.words[_w];
    if (!_deleting) {
      _c++;
      setState(() => _text = word.substring(0, _c));
      if (_c == word.length) {
        _deleting = true;
        _timer = Timer(const Duration(milliseconds: 1500), _tick);
        return;
      }
      _timer = Timer(const Duration(milliseconds: 62), _tick);
    } else {
      _c--;
      setState(() => _text = word.substring(0, _c));
      if (_c == 0) {
        _deleting = false;
        _w = (_w + 1) % widget.words.length;
        _timer = Timer(const Duration(milliseconds: 280), _tick);
        return;
      }
      _timer = Timer(const Duration(milliseconds: 30), _tick);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(_text, style: widget.style)),
        _Caret(color: widget.caretColor),
      ],
    );
  }
}

class _Caret extends StatefulWidget {
  final Color color;
  const _Caret({required this.color});

  @override
  State<_Caret> createState() => _CaretState();
}

class _CaretState extends State<_Caret> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1050),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    context.watch<AppTheme>();
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final visible = reduce ? true : _c.value < 0.5;
        return Opacity(
          opacity: visible ? 1 : 0,
          child: Container(
            width: 2,
            height: 18,
            margin: const EdgeInsets.only(left: 2),
            color: widget.color,
          ),
        );
      },
    );
  }
}
