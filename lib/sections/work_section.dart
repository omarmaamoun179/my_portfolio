import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/portfolio_data.dart';
import '../services/analytics.dart';
import '../theme/app_theme.dart';
import '../widgets/hover.dart';
import '../widgets/phone_mock.dart';
import '../widgets/project_dialog.dart';
import '../widgets/reveal.dart';
import '../widgets/ui.dart';

class WorkSection extends StatefulWidget {
  const WorkSection({super.key});

  @override
  State<WorkSection> createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  final _controller = ScrollController();
  bool _atStart = true;
  bool _atEnd = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_sync);
  }

  void _sync() {
    if (!_controller.hasClients) return;
    final max = _controller.position.maxScrollExtent;
    final off = _controller.offset;
    final atStart = off <= 4;
    final atEnd = off >= max - 4;
    if (atStart != _atStart || atEnd != _atEnd) {
      setState(() {
        _atStart = atStart;
        _atEnd = atEnd;
      });
    }
  }

  void _scrollBy(double dir) {
    if (!_controller.hasClients) return;
    final step = 320 * 1.4 * dir;
    final target = (_controller.offset + step).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    final w = MediaQuery.sizeOf(context).width;
    final padV = sectionPaddingV(w);
    final headSize = clampVw(28, 4, 40, w);
    final edgePad = w <= Breaks.md ? 20.0 : 28.0;
    final railLead = ((w - Breaks.maxContent) / 2 + edgePad).clamp(
      edgePad,
      double.infinity,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentWrap(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Reveal(child: Eyebrow('01 — selected work')),
                      const SizedBox(height: 16),
                      Reveal(
                        delayMs: 100,
                        child: Text(
                          'Apps live in the stores',
                          style: AppTheme.display(
                            size: headSize,
                            color: t.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Reveal(
                  delayMs: 100,
                  child: Row(
                    children: [
                      _Arrow(
                        icon: Icons.chevron_left,
                        disabled: _atStart,
                        onTap: () => _scrollBy(-1),
                      ),
                      const SizedBox(width: 10),
                      _Arrow(
                        icon: Icons.chevron_right,
                        disabled: _atEnd,
                        onTap: () => _scrollBy(1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Reveal(
            delayMs: 200,
            child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(railLead, 8, railLead, 28),
              child: SizedBox(
                height: 660,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < kProjects.length; i++) ...[
                      _WorkCard(project: kProjects[i]),
                      if (i != kProjects.length - 1) const SizedBox(width: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  final IconData icon;
  final bool disabled;
  final VoidCallback onTap;
  const _Arrow({
    required this.icon,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Hover(
        builder: (context, hovering) => GestureDetector(
          onTap: disabled ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            transform: Matrix4.translationValues(
              0,
              hovering && !disabled ? -1 : 0,
              0,
            ),
            decoration: BoxDecoration(
              color: t.surface2,
              border: Border.all(
                color: hovering && !disabled ? t.border2 : t.border,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: hovering && !disabled ? t.text : t.text2,
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  final AppProject project;
  const _WorkCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Hover(
      cursor: SystemMouseCursors.click,
      builder: (context, hovering) => GestureDetector(
        onTap: () {
          Analytics.projectOpen(project.name);
          showProjectDialog(context, project);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          width: 300,
          transform: Matrix4.translationValues(0, hovering ? -5 : 0, 0),
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(color: hovering ? t.border2 : t.border),
            borderRadius: BorderRadius.circular(18),
            boxShadow: hovering ? t.cardShadow : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // shot
                Container(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 26),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [t.greenSoft, t.surface2, t.cyanSoft],
                      stops: const [0, 0.5, 1],
                    ),
                  ),
                  child: Center(
                    child: PhoneMock(
                      label: project.name,
                      screenshotUrl: project.screenshots.isNotEmpty
                          ? project.screenshots[3]
                          : null,
                      iconUrl: project.iconUrl,
                    ),
                  ),
                ),
                // body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: AppTheme.display(size: 20, color: t.text),
                        ),
                        const SizedBox(height: 5),
                        _orgLine(t),
                        const SizedBox(height: 18),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < project.stats.length; i++) ...[
                              _statBlock(t, project.stats[i]),
                              if (i != project.stats.length - 1)
                                const SizedBox(width: 24),
                            ],
                          ],
                        ),
                        const Spacer(),
                        const SizedBox(height: 18),
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
                                          source: 'card',
                                        );
                                        openUrl(link.url!);
                                      },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _orgLine(AppTheme t) {
    final parts = <InlineSpan>[];
    if (project.live) {
      parts.add(
        TextSpan(
          text: '● Live',
          style: AppTheme.mono(size: 11.5, color: t.green),
        ),
      );
      parts.add(
        TextSpan(
          text: ' · ${project.org}',
          style: AppTheme.mono(size: 11.5, color: t.text3),
        ),
      );
    } else {
      parts.add(
        TextSpan(
          text: project.org,
          style: AppTheme.mono(size: 11.5, color: t.text3),
        ),
      );
    }
    return RichText(text: TextSpan(children: parts));
  }

  Widget _statBlock(AppTheme t, WorkStat s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: s.value,
                style: AppTheme.display(
                  size: 19,
                  weight: FontWeight.w700,
                  color: t.text,
                ),
              ),
              if (s.suffix.isNotEmpty)
                TextSpan(
                  text: s.suffix,
                  style: AppTheme.display(
                    size: 19,
                    weight: FontWeight.w700,
                    color: t.accent,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Text(s.label, style: AppTheme.mono(size: 10.5, color: t.text3)),
      ],
    );
  }
}
