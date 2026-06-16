import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final padV = sectionPaddingV(w);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padV),
      child: ContentWrap(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHead(
              eyebrow: '02 — career.log',
              title: "Where I've shipped",
              subtitle:
                  'Five teams, one constant: production apps that stay stable and keep improving.',
            ),
            const SizedBox(height: 46),
            for (int i = 0; i < kExperience.length; i++)
              Reveal(
                child: _TimelineItem(
                  entry: kExperience[i],
                  isLast: i == kExperience.length - 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ExperienceEntry entry;
  final bool isLast;
  const _TimelineItem({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final stacked = w <= Breaks.md;

    final body = _Body(entry: entry, isLast: isLast);

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Rail(entry: entry, isLast: isLast, stacked: true),
          const SizedBox(height: 8),
          body,
        ],
      );
    }
    // The connector line is drawn in this outer Stack so it spans the row's
    // natural height — avoids IntrinsicHeight, which mis-measures the wrapping
    // bullet text in the Expanded body and caused a vertical overflow.
    return Stack(
      children: [
        if (!isLast)
          Positioned(
            left: 5,
            top: 7,
            bottom: 0,
            child: Container(width: 2, color: t.border),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 210,
              child: _Rail(entry: entry, isLast: isLast, stacked: false, drawLine: false),
            ),
            const SizedBox(width: 32),
            Expanded(child: body),
          ],
        ),
      ],
    );
  }
}

class _Rail extends StatelessWidget {
  final ExperienceEntry entry;
  final bool isLast;
  final bool stacked;
  final bool drawLine;
  const _Rail({
    required this.entry,
    required this.isLast,
    required this.stacked,
    this.drawLine = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Stack(
      children: [
        // vertical connector line
        if (!isLast && drawLine)
          Positioned(
            left: 5,
            top: 7,
            bottom: stacked ? 0 : -26,
            child: Container(width: 2, color: t.border),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.date,
                  style: AppTheme.mono(size: 12.5, color: t.accent)),
              const SizedBox(height: 4),
              Text(entry.place,
                  style: AppTheme.mono(size: 12.5, color: t.text3)),
            ],
          ),
        ),
        // node dot
        Positioned(
          left: 0,
          top: 4,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: t.bg,
              shape: BoxShape.circle,
              border: Border.all(color: t.green, width: 2),
              boxShadow: [
                BoxShadow(color: t.greenSoft, spreadRadius: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final ExperienceEntry entry;
  final bool isLast;
  const _Body({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final base = AppTheme.body(size: 15, color: t.text2, height: 1.55);
    final em = AppTheme.body(
        size: 15, color: t.text, weight: FontWeight.w600, height: 1.55);

    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: t.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: '${entry.role} · ',
                  style: AppTheme.display(
                      size: 19, weight: FontWeight.w600, color: t.text)),
              TextSpan(
                  text: entry.org,
                  style: AppTheme.display(
                      size: 19, weight: FontWeight.w600, color: t.accent)),
            ]),
          ),
          const SizedBox(height: 14),
          for (final b in entry.bullets) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 8),
                    child: Text('▸',
                        style: AppTheme.body(size: 12, color: t.accent)),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          style: base, children: emphasisSpans(b, base, em)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
