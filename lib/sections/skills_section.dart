import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/hover.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final padV = sectionPaddingV(w);
    final cols = w <= Breaks.lg ? 1 : 2;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padV),
      child: ContentWrap(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHead(
              eyebrow: '04 — toolbox',
              title: 'The stack I build with',
              subtitle:
                  'Two years of choosing the right tool for the job — from state management to store releases.',
            ),
            const SizedBox(height: 46),
            _Grid(cols: cols),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final int cols;
  const _Grid({required this.cols});

  @override
  Widget build(BuildContext context) {
    const gap = 18.0;
    return LayoutBuilder(builder: (context, constraints) {
      final cardW = cols == 1
          ? constraints.maxWidth
          : (constraints.maxWidth - gap) / 2;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (int i = 0; i < kSkills.length; i++)
            SizedBox(
              width: cardW,
              child: Reveal(
                delayMs: (i.isOdd ? 100 : 0),
                child: _SkillCard(group: kSkills[i]),
              ),
            ),
        ],
      );
    });
  }
}

class _SkillCard extends StatelessWidget {
  final SkillGroup group;
  const _SkillCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final iconColor = group.cyan ? t.cyan : t.green;
    final iconBg = group.cyan ? t.cyanSoft : t.greenSoft;

    return Hover(
      cursor: SystemMouseCursors.basic,
      builder: (context, hovering) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, hovering ? -3 : 0, 0),
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
        decoration: BoxDecoration(
          color: t.surface,
          border: Border.all(color: hovering ? t.border2 : t.border),
          borderRadius: BorderRadius.circular(13),
          boxShadow: hovering ? t.cardShadow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(group.icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 11),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.title,
                        style: AppTheme.display(size: 17, color: t.text)),
                    Text(group.sub,
                        style: AppTheme.mono(size: 11.5, color: t.text3)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final c in group.chips) Tag(c)],
            ),
          ],
        ),
      ),
    );
  }
}
