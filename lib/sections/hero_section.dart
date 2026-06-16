import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/nav_bar.dart';
import '../widgets/reveal.dart';
import '../widgets/typing_text.dart';
import '../widgets/ui.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onViewWork;
  const HeroSection({super.key, required this.onViewWork});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final h1 = w <= Breaks.sm ? 40.0 : clampVw(40, 6.4, 74, w);
    final roleSize = clampVw(15, 2, 19, w);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // hero-glow
        Positioned(
          top: -60,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 900,
              height: 520,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [t.greenSoft, Colors.transparent],
                  radius: 0.62,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, kNavHeight + 70, 0, 60),
          child: ContentWrap(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // status pill
                Reveal(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 26),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                    decoration: BoxDecoration(
                      color: t.surface,
                      border: Border.all(color: t.border),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LiveDot(),
                        const SizedBox(width: 9),
                        Text('Available for new opportunities',
                            style: AppTheme.mono(size: 13, color: t.text2)),
                      ],
                    ),
                  ),
                ),
                // name
                Reveal(
                  delayMs: 100,
                  child: Wrap(
                    children: [
                      Text('Omar ',
                          style: AppTheme.display(
                              size: h1,
                              weight: FontWeight.w600,
                              color: t.text,
                              letterSpacing: -0.035)),
                      GradientText(
                        'Maamoun',
                        style: AppTheme.display(
                            size: h1,
                            weight: FontWeight.w600,
                            letterSpacing: -0.035),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // role line
                Reveal(
                  delayMs: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('~/omar \$',
                          style: AppTheme.mono(size: roleSize, color: t.green)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TypingText(
                          words: kTypingWords,
                          caretColor: t.cyan,
                          style: AppTheme.mono(size: roleSize, color: t.text),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                // lede
                Reveal(
                  delayMs: 200,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: _Lede(),
                  ),
                ),
                const SizedBox(height: 32),
                // actions
                Reveal(
                  delayMs: 300,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      PortfolioButton(
                        label: 'View my work',
                        icon: Icons.arrow_forward,
                        primary: true,
                        onTap: onViewWork,
                      ),
                      PortfolioButton(
                        label: 'Download CV',
                        icon: Icons.file_download_outlined,
                        onTap: () => openUrl(Contact.cvUrl),
                      ),
                      PortfolioButton(
                        label: 'GitHub',
                        icon: FontAwesomeIcons.github,
                        onTap: () => openUrl(Contact.github),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Lede extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final base = AppTheme.body(size: 17.5, color: t.text2, height: 1.6);
    final strong =
        AppTheme.body(size: 17.5, color: t.text, weight: FontWeight.w600, height: 1.6);
    return RichText(
      text: TextSpan(style: base, children: [
        const TextSpan(text: 'I build '),
        TextSpan(text: 'cross-platform mobile products', style: strong),
        const TextSpan(text: ' with Flutter — shipping '),
        TextSpan(text: '10+ apps', style: strong),
        const TextSpan(text: ' to the App Store and Google Play, reaching '),
        TextSpan(text: '5,000+ users', style: strong),
        const TextSpan(
            text:
                ' with Clean Architecture, BLoC, and rock-solid 99% crash-free sessions.'),
      ]),
    );
  }
}
