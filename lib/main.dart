import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/experience_section.dart';
import 'sections/footer_section.dart';
import 'sections/hero_section.dart';
import 'sections/skills_section.dart';
import 'sections/stats_section.dart';
import 'sections/work_section.dart';
import 'services/analytics.dart';
import 'theme/app_theme.dart';
import 'widgets/nav_bar.dart';
import 'widgets/scroll_in_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = AppTheme()..load();
  runApp(
    ChangeNotifierProvider.value(value: theme, child: const PortfolioApp()),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();
    return MaterialApp(
      title: 'Omar Maamoun — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: t.bg,
        brightness: t.isLight ? Brightness.light : Brightness.dark,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: t.green.withValues(alpha: 0.35),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scroll = ScrollController();
  bool _navScrolled = false;

  final Map<String, GlobalKey> _keys = {
    'work': GlobalKey(),
    'experience': GlobalKey(),
    'about': GlobalKey(),
    'skills': GlobalKey(),
    'contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    // SPA "landing" page-view — the browser load fires no GA hit (the snippet
    // sets send_page_view:false), so we record the home view here.
    Analytics.logPageView(path: '/', title: 'Home — Omar Maamoun');
    _scroll.addListener(() {
      final scrolled = _scroll.offset > 12;
      if (scrolled != _navScrolled) setState(() => _navScrolled = scrolled);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollTo(String id) {
    final ctx = _keys[id]?.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final target =
        _scroll.offset + box.localToGlobal(Offset.zero).dy - kNavHeight - 8;
    _scroll.animateTo(
      target.clamp(0.0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollTop() {
    _scroll.animateTo(0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<AppTheme>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: t.bg,
      endDrawer: NavDrawer(
        onNavTap: _scrollTo,
        onHire: () => _scrollTo('contact'),
      ),
      body: Stack(
        children: [
          // dotted-grid backdrop
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _DotGridPainter(t.bgGrid)),
            ),
          ),
          // scrollable content
          ScrollProvider(
            controller: _scroll,
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroSection(onViewWork: () => _scrollTo('work')),
                  const StatsSection(),
                  KeyedSubtree(key: _keys['work'], child: const WorkSection()),
                  KeyedSubtree(
                      key: _keys['experience'],
                      child: const ExperienceSection()),
                  KeyedSubtree(
                      key: _keys['about'], child: const AboutSection()),
                  KeyedSubtree(
                      key: _keys['skills'], child: const SkillsSection()),
                  KeyedSubtree(
                      key: _keys['contact'], child: const ContactSection()),
                  FooterSection(onNavTap: _scrollTo),
                ],
              ),
            ),
          ),
          // fixed nav
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              scrolled: _navScrolled,
              onNavTap: _scrollTo,
              onHire: () => _scrollTo('contact'),
              onHome: _scrollTop,
              onMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fixed dotted-grid backdrop (CSS: radial-gradient dots on a 22px tile).
class _DotGridPainter extends CustomPainter {
  final Color color;
  const _DotGridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const tile = 22.0;
    for (double y = 0; y < size.height; y += tile) {
      for (double x = 0; x < size.width; x += tile) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.color != color;
}
