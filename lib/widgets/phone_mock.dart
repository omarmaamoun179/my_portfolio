import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';

/// Phone-framed screenshot slot. When [screenshotUrl] is provided it renders the
/// bundled app screenshot asset inside the frame; otherwise it falls back to the
/// labelled empty state (a subtle gradient screen with the app name). When
/// [iconUrl] is provided the bundled app icon asset floats over the bottom of
/// the frame. Both paths point at assets under `assets/work/`.
class PhoneMock extends StatelessWidget {
  final String label;
  final String? screenshotUrl;
  final String? iconUrl;
  final double width;
  final double height;

  const PhoneMock({
    super.key,
    required this.label,
    this.screenshotUrl,
    this.iconUrl,
    this.width = 150,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: t.bg,
            border: Border.all(color: t.border2),
            borderRadius: BorderRadius.circular(20),
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
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -1),
                  radius: 1.0,
                  colors: [t.greenSoft, t.surface2],
                  stops: const [0, 0.6],
                ),
                color: t.surface2,
              ),
              alignment: Alignment.center,
              child: screenshotUrl != null
                  ? Image.asset(
                      screenshotUrl!,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => _placeholder(t),
                    )
                  : _placeholder(t),
            ),
          ),
        ),
        if (iconUrl != null)
          Positioned(
            bottom: -16,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.border2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  iconUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) =>
                      Icon(Icons.apps, size: 22, color: t.text3),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _placeholder(AppTheme t) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smartphone_outlined, size: 26, color: t.text3),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTheme.mono(size: 12, color: t.text3),
          ),
        ],
      ),
    );
  }
}
