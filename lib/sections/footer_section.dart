import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../services/analytics.dart';
import '../theme/app_theme.dart';
import '../widgets/hover.dart';
import '../widgets/ui.dart';
import 'privacy_policy_page.dart';

class FooterSection extends StatelessWidget {
  final void Function(String id) onNavTap;
  const FooterSection({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final year = DateTime.now().year;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: t.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 34),
      child: ContentWrap(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTheme.mono(size: 13, color: t.text3),
                    children: [
                      TextSpan(text: '© $year '),
                      TextSpan(
                          text: 'Omar Osama Maamoun',
                          style: AppTheme.mono(
                              size: 13,
                              weight: FontWeight.w500,
                              color: t.text2)),
                      const TextSpan(text: ' · Flutter Developer'),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 18,
                  runSpacing: 8,
                  children: [
                    _FLink(label: 'About', onTap: () => onNavTap('about')),
                    _FLink(label: 'Work', onTap: () => onNavTap('work')),
                    _FLink(
                        label: 'GitHub',
                        onTap: () {
                          Analytics.contactClick('github');
                          openUrl(Contact.github);
                        }),
                    _FLink(
                        label: 'Email',
                        onTap: () {
                          Analytics.contactClick('email');
                          openUrl('mailto:${Contact.email}');
                        }),
                    _FLink(
                      label: 'Privacy',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Divider(height: 1, thickness: 1, color: t.border),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1, right: 9),
                  child: Icon(Icons.bar_chart_rounded,
                      size: 15, color: t.text3),
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'This site uses Google Analytics with IP anonymisation '
                        'to understand anonymous, aggregate traffic. No personal '
                        'data is collected or sold. ',
                        style: AppTheme.mono(
                            size: 12, color: t.text3, height: 1.6),
                      ),
                      _FLink(
                        label: 'Learn more',
                        size: 12,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const PrivacyPolicyPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double size;
  const _FLink({required this.label, required this.onTap, this.size = 13});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Hover(
      builder: (context, hovering) => GestureDetector(
        onTap: onTap,
        child: Text(label,
            style: AppTheme.mono(
                size: size, color: hovering ? t.accent : t.text3)),
      ),
    );
  }
}
