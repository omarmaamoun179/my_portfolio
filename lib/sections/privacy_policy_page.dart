import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../services/analytics.dart';
import '../theme/app_theme.dart';
import '../widgets/hover.dart';
import '../widgets/ui.dart';

/// Standalone privacy policy / analytics-disclosure page, pushed over the
/// single-page home via [Navigator]. Plain-language, no legalese — it exists to
/// honestly disclose the Google Analytics integration and how to opt out.
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  /// Last-updated date shown in the header. Kept here (not `DateTime.now()`) so
  /// it reflects when the policy text actually changed.
  static const String lastUpdated = 'June 2026';

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  void initState() {
    super.initState();
    Analytics.logPageView(path: '/privacy', title: 'Privacy Policy');
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final padV = sectionPaddingV(w);
    final headSize = clampVw(28, 4, 40, w);

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: padV),
          child: ContentWrap(
            maxWidth: 760,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BackLink(onTap: () => Navigator.of(context).maybePop()),
                const SizedBox(height: 28),
                const Eyebrow('legal — privacy'),
                const SizedBox(height: 16),
                Text('Privacy Policy',
                    style: AppTheme.display(size: headSize, color: t.text)),
                const SizedBox(height: 10),
                Text('Last updated · ${PrivacyPolicyPage.lastUpdated}',
                    style: AppTheme.mono(size: 13, color: t.text3)),
                const SizedBox(height: 36),
                _Para(
                  'This is the personal portfolio of Omar Osama Maamoun. It is a '
                  'static showcase — there are no accounts, no sign-ups, and no '
                  'forms that store what you type. The only data collected is '
                  'anonymous, aggregate usage analytics, described below.',
                ),
                _Heading('Analytics we use'),
                _Para(
                  'This site uses Google Analytics 4 (GA4) to understand how '
                  'visitors find and move through the page — for example which '
                  'projects get viewed and roughly where traffic comes from. '
                  'This helps me improve the portfolio.',
                ),
                _Bullets(const [
                  'A page-view is recorded when you open the site and when you '
                      'open this privacy page.',
                  'A few interaction events are recorded — for example tapping '
                      '"Download CV" or a contact link — with no message content.',
                  'IP addresses are anonymised before storage (IP anonymisation '
                      'is enabled), and no personally identifying information is '
                      'collected, sold, or shared.',
                ]),
                _Heading('Cookies'),
                _Para(
                  'Google Analytics sets first-party cookies (such as _ga) to '
                  'distinguish unique visitors across sessions. They contain a '
                  'random identifier, not your identity. The site itself also '
                  'stores your theme and accent-colour choices in your browser '
                  'so they persist between visits — that preference never leaves '
                  'your device.',
                ),
                _Heading('Your choices'),
                _Para(
                  'You can opt out of analytics at any time by:',
                ),
                _Bullets(const [
                  'Installing the official Google Analytics Opt-out Browser '
                      'Add-on.',
                  'Enabling "Do Not Track" or blocking analytics cookies in your '
                      'browser settings, or using a privacy/ad-blocking '
                      'extension — the site works fully either way.',
                ]),
                _Heading('Third-party services'),
                _Para(
                  'Outbound links (GitHub, LinkedIn, the app stores, WhatsApp, '
                  'and email) lead to third-party services governed by their own '
                  'privacy policies. Fonts are served by Google Fonts. This site '
                  'does not control how those providers handle your data.',
                ),
                _Heading('Contact'),
                _ContactLine(),
                const SizedBox(height: 40),
                _BackLink(onTap: () => Navigator.of(context).maybePop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  const _Heading(this.text);

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Padding(
      padding: const EdgeInsets.only(top: 34, bottom: 12),
      child: Text(text, style: AppTheme.display(size: 21, color: t.text)),
    );
  }
}

class _Para extends StatelessWidget {
  final String text;
  const _Para(this.text);

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: AppTheme.body(size: 16, color: t.text2, height: 1.7)),
    );
  }
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  const _Bullets(this.items);

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 12),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration:
                          BoxDecoration(color: t.accent, shape: BoxShape.circle),
                    ),
                  ),
                  Expanded(
                    child: Text(item,
                        style: AppTheme.body(
                            size: 16, color: t.text2, height: 1.6)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Questions about this policy or your data? Email ',
            style: AppTheme.body(size: 16, color: t.text2, height: 1.7)),
        Hover(
          builder: (context, hovering) => GestureDetector(
            onTap: () => openUrl('mailto:${Contact.email}'),
            child: Text(Contact.email,
                style: AppTheme.mono(
                    size: 15, color: hovering ? t.cyan : t.accent)),
          ),
        ),
        Text('.', style: AppTheme.body(size: 16, color: t.text2, height: 1.7)),
      ],
    );
  }
}

class _BackLink extends StatelessWidget {
  final VoidCallback onTap;
  const _BackLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Hover(
      builder: (context, hovering) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back,
                size: 16, color: hovering ? t.accent : t.text3),
            const SizedBox(width: 8),
            Text('Back to portfolio',
                style: AppTheme.mono(
                    size: 13, color: hovering ? t.accent : t.text3)),
          ],
        ),
      ),
    );
  }
}
