import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../services/analytics.dart';
import '../theme/app_theme.dart';
import 'ui.dart';

/// Opens the tappable project detail sheet: a swipeable screenshot carousel
/// alongside the app description, stats, and store links.
Future<void> showProjectDialog(BuildContext context, AppProject project) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (_) => ChangeNotifierProvider.value(
      value: context.read<AppTheme>(),
      child: _ProjectDialog(project: project),
    ),
  );
}

class _ProjectDialog extends StatelessWidget {
  final AppProject project;
  const _ProjectDialog({required this.project});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final wide = w > Breaks.md;

    final carousel = _Carousel(
      screenshots: project.screenshots,
      label: project.name,
    );
    final details = _Details(project: project);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: wide ? 40 : 16,
        vertical: wide ? 40 : 24,
      ),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 880,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(color: t.border2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [t.greenSoft, t.surface2, t.cyanSoft],
                          ),
                        ),
                        child: carousel,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(child: details),
                    ),
                  ],
                )
              else
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 380,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [t.greenSoft, t.surface2, t.cyanSoft],
                          ),
                        ),
                        child: carousel,
                      ),
                      details,
                    ],
                  ),
                ),
              Positioned(
                top: 10,
                right: 10,
                child: _CloseButton(onTap: () => Navigator.of(context).pop()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Material(
      color: t.surface2,
      shape: CircleBorder(side: BorderSide(color: t.border2)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(Icons.close, size: 18, color: t.text2),
        ),
      ),
    );
  }
}

/// Swipeable screenshot carousel with arrows and page-dot indicators.
class _Carousel extends StatefulWidget {
  final List<String> screenshots;
  final String label;
  const _Carousel({required this.screenshots, required this.label});

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_page + delta).clamp(0, widget.screenshots.length - 1);
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final shots = widget.screenshots;

    if (shots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smartphone_outlined, size: 30, color: t.text3),
            const SizedBox(height: 10),
            Text(widget.label, style: AppTheme.mono(size: 13, color: t.text3)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: shots.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) => Center(
                    child: _PhoneFrame(asset: shots[i], label: widget.label),
                  ),
                ),
                if (shots.length > 1) ...[
                  Positioned(
                    left: 0,
                    child: _CarouselArrow(
                      icon: Icons.chevron_left,
                      disabled: _page == 0,
                      onTap: () => _go(-1),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: _CarouselArrow(
                      icon: Icons.chevron_right,
                      disabled: _page == shots.length - 1,
                      onTap: () => _go(1),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (shots.length > 1) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < shots.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == _page ? t.accent : t.border2,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  final String asset;
  final String label;
  const _PhoneFrame({required this.asset, required this.label});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: t.bg,
        border: Border.all(color: t.border2),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 38,
            spreadRadius: -20,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: t.surface2,
              alignment: Alignment.center,
              child: Icon(Icons.broken_image_outlined, color: t.text3),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  final IconData icon;
  final bool disabled;
  final VoidCallback onTap;
  const _CarouselArrow({
    required this.icon,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return AnimatedOpacity(
      opacity: disabled ? 0 : 1,
      duration: const Duration(milliseconds: 180),
      child: Material(
        color: t.surface.withValues(alpha: 0.85),
        shape: CircleBorder(side: BorderSide(color: t.border2)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: disabled ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 24, color: t.text),
          ),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final AppProject project;
  const _Details({required this.project});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (project.iconUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    project.iconUrl!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        Icon(Icons.apps, size: 26, color: t.text3),
                  ),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: AppTheme.display(size: 23, color: t.text),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (project.live) ...[
                          const LiveDot(size: 7),
                          const SizedBox(width: 7),
                          Text(
                            'Live',
                            style: AppTheme.mono(size: 12, color: t.green),
                          ),
                          Text(
                            ' · ',
                            style: AppTheme.mono(size: 12, color: t.text3),
                          ),
                        ],
                        Flexible(
                          child: Text(
                            project.org,
                            style: AppTheme.mono(size: 12, color: t.text3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (project.stats.isNotEmpty) ...[
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < project.stats.length; i++) ...[
                  _StatBlock(stat: project.stats[i]),
                  if (i != project.stats.length - 1) const SizedBox(width: 28),
                ],
              ],
            ),
          ],
          if (project.description.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(
              project.description,
              style: AppTheme.body(size: 15, color: t.text2, height: 1.7),
            ),
          ],
          if (project.links.isNotEmpty) ...[
            const SizedBox(height: 26),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: [
                for (final link in project.links)
                  StoreBadge(
                    label: link.label,
                    icon: link.icon,
                    url: link.url,
                    disabled: link.disabled,
                    onTap: link.url == null
                        ? null
                        : () {
                            Analytics.storeLinkClick(
                              app: project.name,
                              store: link.label,
                              source: 'dialog',
                            );
                            openUrl(link.url!);
                          },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final WorkStat stat;
  const _StatBlock({required this.stat});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: stat.value,
                style: AppTheme.display(
                  size: 21,
                  weight: FontWeight.w700,
                  color: t.text,
                ),
              ),
              if (stat.suffix.isNotEmpty)
                TextSpan(
                  text: stat.suffix,
                  style: AppTheme.display(
                    size: 21,
                    weight: FontWeight.w700,
                    color: t.accent,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Text(stat.label, style: AppTheme.mono(size: 11, color: t.text3)),
      ],
    );
  }
}
