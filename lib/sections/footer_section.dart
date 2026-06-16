import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/hover.dart';
import '../widgets/ui.dart';

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
        child: Wrap(
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
                          size: 13, weight: FontWeight.w500, color: t.text2)),
                  const TextSpan(text: ' · Flutter Developer'),
                ],
              ),
            ),
            Wrap(
              spacing: 18,
              children: [
                _FLink(label: 'About', onTap: () => onNavTap('about')),
                _FLink(label: 'Work', onTap: () => onNavTap('work')),
                _FLink(label: 'GitHub', onTap: () => openUrl(Contact.github)),
                _FLink(
                    label: 'Email',
                    onTap: () => openUrl('mailto:${Contact.email}')),
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
  const _FLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Hover(
      builder: (context, hovering) => GestureDetector(
        onTap: onTap,
        child: Text(label,
            style: AppTheme.mono(
                size: 13, color: hovering ? t.accent : t.text3)),
      ),
    );
  }
}
