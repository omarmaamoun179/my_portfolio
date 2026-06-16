import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final padV = sectionPaddingV(w);
    final stacked = w <= Breaks.lg;

    final copy = _Copy();
    final card = const Reveal(delayMs: 200, child: _HighlightsCard());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padV),
      child: ContentWrap(
        child: stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [copy, const SizedBox(height: 36), card],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 10, child: copy),
                  const SizedBox(width: 56),
                  Expanded(flex: 9, child: card),
                ],
              ),
      ),
    );
  }
}

class _Copy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final p = AppTheme.body(size: 17.5, color: t.text2, height: 1.6);
    final strong = AppTheme.body(
        size: 17.5, color: t.text, weight: FontWeight.w600, height: 1.6);
    final accent = AppTheme.body(size: 17.5, color: t.accent, height: 1.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Reveal(child: Eyebrow('03 — whoami')),
        const SizedBox(height: 16),
        Reveal(
          child: Text(
            'Engineer who ships, measures, and improves.',
            style:
                AppTheme.display(size: clampVw(28, 4, 40, w), color: t.text),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(
          delayMs: 100,
          child: RichText(
            text: TextSpan(style: p, children: [
              const TextSpan(text: "I'm a "),
              TextSpan(text: 'mid-level Flutter developer', style: strong),
              const TextSpan(
                  text:
                      ' with 2+ years turning product ideas into polished, cross-platform apps that real people use every day — across e-commerce, fintech, logistics, and education.'),
            ]),
          ),
        ),
        const SizedBox(height: 18),
        Reveal(
          delayMs: 100,
          child: RichText(
            text: TextSpan(style: p, children: [
              const TextSpan(text: 'My work lives at the intersection of '),
              TextSpan(text: 'clean engineering', style: accent),
              const TextSpan(text: ' and '),
              TextSpan(text: 'measurable impact', style: accent),
              const TextSpan(
                  text:
                      ': Clean Architecture and BLoC for maintainability, hardened Dio interceptors and secure storage for trust, and CI/CD with automated testing so every release ships with confidence.'),
            ]),
          ),
        ),
        const SizedBox(height: 18),
        Reveal(
          delayMs: 200,
          child: RichText(
            text: TextSpan(style: p, children: [
              const TextSpan(text: "The numbers I'm proudest of? "),
              TextSpan(text: '25% fewer crashes', style: strong),
              const TextSpan(text: ', '),
              TextSpan(text: '20% faster feature delivery', style: strong),
              const TextSpan(
                  text:
                      ', and a string of 4.5★–5.0★ apps live on both stores.'),
            ]),
          ),
        ),
      ],
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  const _HighlightsCard();

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(14),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 26, 26, 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('// how I work',
                    style: AppTheme.mono(size: 12, color: t.accent)),
                const SizedBox(height: 9),
                Text('Principles that ship',
                    style: AppTheme.display(size: 21, color: t.text)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 18, 26, 6),
            child: Column(
              children: [
                for (final pr in kPrinciples)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _PrincipleRow(principle: pr),
                  ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.fromLTRB(26, 16, 26, 24),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: t.border)),
            ),
            child: Row(
              children: [
                Expanded(child: _Stat(value: '0', label: 'rollback releases')),
                Expanded(child: _Stat(value: '100%', label: 'code-reviewed PRs')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrincipleRow extends StatelessWidget {
  final Principle principle;
  const _PrincipleRow({required this.principle});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 25,
          height: 25,
          margin: const EdgeInsets.only(top: 1, right: 13),
          decoration: BoxDecoration(
            color: t.greenSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.check, size: 14, color: t.accent),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(principle.title,
                  style: AppTheme.display(
                      size: 15.5, weight: FontWeight.w600, color: t.text)),
              const SizedBox(height: 2),
              Text(principle.detail,
                  style: AppTheme.body(size: 13, color: t.text3)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: AppTheme.display(
                size: 25,
                weight: FontWeight.w700,
                color: t.accent,
                letterSpacing: -0.02)),
        const SizedBox(height: 2),
        Text(label, style: AppTheme.mono(size: 11, color: t.text3)),
      ],
    );
  }
}
