import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/animated_counter.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class _Stat {
  final num count;
  final String suffix;
  final String label;
  const _Stat(this.count, this.suffix, this.label);
}

const _stats = [
  _Stat(2, '+', 'years in production'),
  _Stat(10, '+', 'apps shipped to stores'),
  _Stat(5000, '+', 'active users reached'),
  _Stat(99, '%', 'crash-free sessions'),
];

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final cols = w <= Breaks.lg ? 2 : 4;

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(
          top: BorderSide(color: t.border),
          bottom: BorderSide(color: t.border),
        ),
      ),
      child: ContentWrap(
        child: GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: cols == 4 ? 1.3 : 2.0,
          children: [
            for (int i = 0; i < _stats.length; i++)
              _StatCell(stat: _stats[i], index: i, cols: cols),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final _Stat stat;
  final int index;
  final int cols;
  const _StatCell({required this.stat, required this.index, required this.cols});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final numSize = clampVw(34, 4, 48, w);

    // Cell borders: right divider except last in row; bottom divider on first
    // row when wrapped to 2 columns.
    final isLastInRow = (index + 1) % cols == 0;
    final inFirstRow = index < cols;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          right: isLastInRow
              ? BorderSide.none
              : BorderSide(color: t.border),
          bottom: (cols == 2 && inFirstRow)
              ? BorderSide(color: t.border)
              : BorderSide.none,
        ),
      ),
      child: Reveal(
        delayMs: (index * 100).clamp(0, 300),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedCounter(
                  target: stat.count,
                  style: AppTheme.display(
                    size: numSize,
                    weight: FontWeight.w700,
                    color: t.text,
                    letterSpacing: -0.03,
                  ),
                ),
                Text(
                  stat.suffix,
                  style: AppTheme.display(
                    size: numSize * 0.6,
                    weight: FontWeight.w700,
                    color: t.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(stat.label,
                style: AppTheme.mono(size: 13, color: t.text2)),
            ],
          ),
        ),
      ),
    );
  }
}
