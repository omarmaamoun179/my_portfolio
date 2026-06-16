import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'hover.dart';
import 'ui.dart';

const double kNavHeight = 68;

/// Fixed top navigation bar (`.nav`). Collapses links into a menu button on
/// narrow viewports (the prototype simply hid them ≤720px; we surface a drawer
/// instead so mobile users keep navigation).
class NavBar extends StatelessWidget {
  final bool scrolled;
  final void Function(String id) onNavTap;
  final VoidCallback onHire;
  final VoidCallback onMenu;
  final VoidCallback onHome;

  const NavBar({
    super.key,
    required this.scrolled,
    required this.onNavTap,
    required this.onHire,
    required this.onMenu,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    // Collapse the inline links into a drawer once the full row stops fitting
    // comfortably (the prototype hid them at 720px; we keep them only while
    // there is room, and surface a drawer otherwise).
    final compact = w <= 860;

    return Container(
      height: kNavHeight,
      decoration: BoxDecoration(
        color: t.bg.withValues(alpha: 0.72),
        border: Border(
          bottom: BorderSide(
            color: scrolled ? t.border : Colors.transparent,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilterBar(
          child: ContentWrap(
            child: Row(
              children: [
                _Brand(onTap: onHome),
                const Spacer(),
                if (!compact) ...[
                  ..._navLinks(t),
                  const SizedBox(width: 10),
                ],
                _ThemeToggle(),
                if (!compact) ...[
                  const SizedBox(width: 10),
                  PortfolioButton(
                    label: 'Hire me',
                    icon: Icons.arrow_outward,
                    primary: true,
                    onTap: onHire,
                  ),
                ] else ...[
                  const SizedBox(width: 10),
                  _IconBtn(icon: Icons.menu, onTap: onMenu),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _navLinks(AppTheme t) {
    return [
      for (int i = 0; i < kNavSections.length; i++)
        _NavLink(
          index: '0${i + 1}',
          label: kNavSections[i].label,
          onTap: () => onNavTap(kNavSections[i].id),
        ),
    ];
  }
}

/// BackdropFilter blur for the translucent nav background
/// (CSS: backdrop-filter: blur(14px) saturate(1.4)).
class BackdropFilterBar extends StatelessWidget {
  final Widget child;
  const BackdropFilterBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: child,
    );
  }
}

class _Brand extends StatelessWidget {
  final VoidCallback onTap;
  const _Brand({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Hover(
      builder: (context, _) => GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: t.green,
                borderRadius: BorderRadius.circular(8),
                boxShadow: t.glow,
              ),
              child: Text(
                'OM',
                style: AppTheme.display(
                  size: 15,
                  weight: FontWeight.w700,
                  color: t.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 11),
            RichText(
              text: TextSpan(
                style: AppTheme.mono(
                    size: 14, weight: FontWeight.w500, color: t.text),
                children: [
                  const TextSpan(text: 'omar'),
                  TextSpan(
                    text: '.dev',
                    style: AppTheme.mono(size: 14, color: t.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String index;
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.index, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Hover(
      builder: (context, hovering) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: hovering ? t.surface2 : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: RichText(
            text: TextSpan(
              style: AppTheme.mono(
                size: 13.5,
                color: hovering ? t.text : t.text2,
              ),
              children: [
                TextSpan(
                  text: '$index ',
                  style: AppTheme.mono(
                      size: 13.5, color: t.accent.withValues(alpha: 0.8)),
                ),
                TextSpan(text: label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return _IconBtn(
      icon: t.isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
      tooltip: 'Toggle theme',
      onTap: () => context.read<AppTheme>().toggleTheme(),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  const _IconBtn({required this.icon, required this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final btn = Hover(
      builder: (context, hovering) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 38,
          height: 38,
          transform: Matrix4.translationValues(0, hovering ? -1 : 0, 0),
          decoration: BoxDecoration(
            color: t.surface2,
            border: Border.all(color: hovering ? t.border2 : t.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: hovering ? t.text : t.text2),
        ),
      ),
    );
    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
  }
}

/// Slide-in navigation drawer for mobile.
class NavDrawer extends StatelessWidget {
  final void Function(String id) onNavTap;
  final VoidCallback onHire;
  const NavDrawer({super.key, required this.onNavTap, required this.onHire});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Drawer(
      backgroundColor: t.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('navigate',
                  style: AppTheme.mono(size: 12.5, color: t.accent)),
              const SizedBox(height: 20),
              for (int i = 0; i < kNavSections.length; i++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text('0${i + 1}',
                      style: AppTheme.mono(size: 14, color: t.accent)),
                  title: Text(kNavSections[i].label,
                      style:
                          AppTheme.display(size: 20, color: t.text)),
                  onTap: () {
                    Navigator.of(context).pop();
                    onNavTap(kNavSections[i].id);
                  },
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PortfolioButton(
                  label: 'Hire me',
                  icon: Icons.arrow_outward,
                  primary: true,
                  onTap: () {
                    Navigator.of(context).pop();
                    onHire();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
