import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import 'hover.dart';
import 'reveal.dart';

/// Centered, max-width content column with responsive horizontal padding.
/// Equivalent to `.wrap` (max-width 1140, padding 0 28px / 20px on mobile).
class ContentWrap extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ContentWrap({super.key, required this.child, this.maxWidth = Breaks.maxContent});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final pad = w <= Breaks.md ? 20.0 : 28.0;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pad),
          child: child,
        ),
      ),
    );
  }
}

/// Vertical padding for a `.section` (96px desktop, 72px mobile).
double sectionPaddingV(double width) => width <= Breaks.md ? 72 : 96;

/// CSS `clamp(min, vw%, max)` for responsive font sizes.
double clampVw(double min, double vw, double max, double width) =>
    (vw / 100 * width).clamp(min, max);

/// Open an external URL in a new tab (web) / browser.
Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// Open a document (e.g. the bundled CV PDF) in a new browser tab. Relative
/// paths are resolved against the current page so a file served from the web
/// root — like `Omar-Maamoun-CV.pdf` — opens and is shown to the visitor.
Future<void> openDoc(String url) async {
  final uri = Uri.base.resolve(url);
  await launchUrl(uri, webOnlyWindowName: '_blank');
}

/// Two-tone gradient text used for the highlighted name / headline words.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  const GradientText(this.text, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        begin: const Alignment(-0.7, -0.7),
        end: const Alignment(0.7, 0.7),
        colors: [t.green, t.cyan],
      ).createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}

/// Monospace section eyebrow with a leading accent hairline (`.eyebrow`).
class Eyebrow extends StatelessWidget {
  final String text;
  final bool center;
  const Eyebrow(this.text, {super.key, this.center = false});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 1,
          margin: const EdgeInsets.only(right: 9),
          color: t.accent.withValues(alpha: 0.6),
        ),
        Text(
          text,
          style: AppTheme.mono(
            size: 12.5,
            color: t.accent,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// Standard section header: eyebrow, title, optional subtitle (`.section-head`).
class SectionHead extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool center;
  const SectionHead({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final size = clampVw(28, 4, 40, w);
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: center ? double.infinity : 640),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Reveal(child: Eyebrow(eyebrow, center: center)),
          const SizedBox(height: 16),
          Reveal(
            delayMs: 100,
            child: Text(
              title,
              textAlign: center ? TextAlign.center : TextAlign.start,
              style: AppTheme.display(size: size, color: t.text),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 14),
            Reveal(
              delayMs: 200,
              child: Text(
                subtitle!,
                textAlign: center ? TextAlign.center : TextAlign.start,
                style: AppTheme.body(size: 17, color: t.text2, height: 1.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Parse a bullet string with `*emphasis*` markers into rich spans
/// (emphasis renders bold in the primary text color, like `<em>`).
List<InlineSpan> emphasisSpans(String raw, TextStyle base, TextStyle em) {
  final spans = <InlineSpan>[];
  final parts = raw.split('*');
  for (int i = 0; i < parts.length; i++) {
    if (parts[i].isEmpty) continue;
    spans.add(TextSpan(text: parts[i], style: i.isOdd ? em : base));
  }
  return spans;
}

/// Monospace pill tag (`.tag`).
class Tag extends StatelessWidget {
  final String label;
  const Tag(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: AppTheme.mono(size: 12, color: t.text2)),
    );
  }
}

/// Pulsing "live" status dot (`.dot-live`).
class LiveDot extends StatefulWidget {
  final double size;
  const LiveDot({super.key, this.size = 8});

  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final p = _c.value;
        // Expanding ring fading out (0 -> 8px), like the CSS pulse keyframes.
        final ringAlpha = (0.5 * (1 - p)).clamp(0.0, 0.5);
        final spread = 8 * p;
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: t.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: t.green.withValues(alpha: ringAlpha),
                spreadRadius: spread,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Primary / secondary action button (`.btn`, `.btn-primary`).
class PortfolioButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const PortfolioButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Hover(
      builder: (context, hovering) {
        final bg = primary ? t.green : t.surface2;
        final fg = primary ? t.onPrimary : t.text;
        final borderColor = primary
            ? t.green
            : (hovering ? t.accent : t.border2);
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            transform: Matrix4.translationValues(0, hovering ? -2 : 0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(9),
              boxShadow: (primary && hovering) ? t.glow : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 9),
                Text(
                  label,
                  style: AppTheme.mono(
                    size: 14,
                    color: fg,
                    weight: primary ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// App-store / Google-Play link badge (`.store-badge`).
class StoreBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? url;
  final bool disabled;

  const StoreBadge({
    super.key,
    required this.label,
    required this.icon,
    this.url,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    if (disabled) {
      return Opacity(
        opacity: 0.55,
        child: _badge(t, hovering: false),
      );
    }
    return Hover(
      builder: (context, hovering) => GestureDetector(
        onTap: url == null ? null : () => openUrl(url!),
        child: _badge(t, hovering: hovering),
      ),
    );
  }

  Widget _badge(AppTheme t, {required bool hovering}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      transform: Matrix4.translationValues(0, hovering ? -2 : 0, 0),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: t.surface2,
        border: Border.all(color: hovering ? t.accent : t.border2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: t.text),
          const SizedBox(width: 8),
          Text(label, style: AppTheme.mono(size: 12.5, color: t.text)),
        ],
      ),
    );
  }
}
