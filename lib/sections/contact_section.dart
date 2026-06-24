import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../services/analytics.dart';
import '../theme/app_theme.dart';
import '../widgets/hover.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final padV = sectionPaddingV(w);
    final headSize = clampVw(30, 4.5, 46, w);
    final cardPad = w <= Breaks.md
        ? const EdgeInsets.symmetric(horizontal: 26, vertical: 44)
        : const EdgeInsets.symmetric(horizontal: 56, vertical: 64);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padV),
      child: ContentWrap(
        child: Reveal(
          child: Container(
            width: double.infinity,
            padding: cardPad,
            decoration: BoxDecoration(
              color: t.surface,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [t.greenSoft, t.surface, t.cyanSoft],
                stops: const [0, 0.5, 1],
              ),
              border: Border.all(color: t.border2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: t.cardShadow,
            ),
            child: Column(
              children: [
                const Eyebrow('05 — let\'s talk', center: true),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Let's build something ",
                        style:
                            AppTheme.display(size: headSize, color: t.text)),
                    GradientText('that ships.',
                        style: AppTheme.display(size: headSize)),
                  ],
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Text(
                    'Open to mid-level Flutter roles, freelance builds, and interesting mobile problems. The fastest way to reach me is email.',
                    textAlign: TextAlign.center,
                    style: AppTheme.body(size: 18, color: t.text2, height: 1.6),
                  ),
                ),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    PortfolioButton(
                      label: 'Email me',
                      icon: Icons.mail_outline,
                      primary: true,
                      onTap: () {
                        Analytics.contactClick('email');
                        openUrl('mailto:${Contact.email}');
                      },
                    ),
                    PortfolioButton(
                      label: 'Download CV',
                      icon: Icons.file_download_outlined,
                      onTap: () {
                        Analytics.logEvent('cv_download');
                        openDoc(Contact.cvUrl);
                      },
                    ),
                    PortfolioButton(
                      label: 'WhatsApp',
                      icon: FontAwesomeIcons.whatsapp,
                      onTap: () {
                        Analytics.contactClick('whatsapp');
                        openUrl(Contact.whatsapp);
                      },
                    ),
                    PortfolioButton(
                      label: 'GitHub',
                      icon: FontAwesomeIcons.github,
                      onTap: () {
                        Analytics.contactClick('github');
                        openUrl(Contact.github);
                      },
                    ),
                    PortfolioButton(
                      label: 'LinkedIn',
                      icon: FontAwesomeIcons.linkedinIn,
                      onTap: () {
                        Analytics.contactClick('linkedin');
                        openUrl(Contact.linkedin);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Wrap(
                  spacing: 26,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _MetaLink(
                        text: Contact.email,
                        onTap: () => openUrl('mailto:${Contact.email}')),
                    _MetaLink(
                        text: Contact.phoneDisplay,
                        onTap: () => openUrl('tel:${Contact.phone}')),
                    Text(Contact.location,
                        style: AppTheme.mono(size: 13, color: t.text3)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _MetaLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Hover(
      builder: (context, hovering) => GestureDetector(
        onTap: onTap,
        child: Text(text,
            style: AppTheme.mono(
                size: 13, color: hovering ? t.accent : t.text2)),
      ),
    );
  }
}
