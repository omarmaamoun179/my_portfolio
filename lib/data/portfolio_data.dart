import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Static content for the portfolio, lifted verbatim from the prototype.

class Contact {
  static const email = 'omarmaamoun6@gmail.com';
  static const phone = '+201064780620';
  static const phoneDisplay = '+20 106 478 0620';
  static const whatsapp = 'https://wa.me/201064780620';
  static const github = 'https://github.com/omarmaamoun179';
  static const linkedin = 'https://www.linkedin.com/in/omar-maamoun-05b085238';
  static const location = 'Cairo, Egypt 🇪🇬';
  static const cvUrl = 'Omar-Maamoun-CV.pdf';
}

class StoreLink {
  final String label;
  final IconData icon;
  final String? url;
  final bool disabled;
  const StoreLink({
    required this.label,
    required this.icon,
    this.url,
    this.disabled = false,
  });
}

class WorkStat {
  final String value;
  final String suffix;
  final String label;
  const WorkStat(this.value, this.suffix, this.label);
}

class AppProject {
  final String name;
  final String org;
  final bool live;
  final List<WorkStat> stats;
  final List<StoreLink> links;

  /// Longer description shown in the detail dialog when the card is tapped.
  final String description;

  /// Bundled app icon asset path (e.g. `assets/work/paletta_icon.png`), may be
  /// null for unpublished apps — falls back to the placeholder phone mock.
  final String? iconUrl;

  /// Bundled app screenshot asset paths (portrait). The first is shown on the
  /// card; the full list powers the swipeable carousel in the detail dialog.
  final List<String> screenshots;

  const AppProject({
    required this.name,
    required this.org,
    this.live = false,
    required this.stats,
    required this.links,
    this.description = '',
    this.iconUrl,
    this.screenshots = const [],
  });
}

const _gplay = FontAwesomeIcons.googlePlay;
const _appstore = FontAwesomeIcons.appStoreIos;

const List<AppProject> kProjects = [
  AppProject(
    name: 'EduMarket',
    org: 'iOS & Android',
    live: true,
    stats: [
      WorkStat('1,500', '+', 'active users'),
      WorkStat('99', '%', 'crash-free'),
    ],
    description:
        'A cross-platform educational marketplace built with Flutter and '
        'GraphQL, serving 1,500+ active users at 99% crash-free sessions across '
        'iOS and Android. Production builds are hardened with R8 shrinking and '
        'obfuscation to protect payment and PII data, with end-to-end Appium '
        'test suites guarding every store release.',
    iconUrl: 'assets/work/edumarket_icon.png',
    screenshots: [
      'assets/work/edumarket_ss1.jpg',
      'assets/work/edumarket_ss2.jpg',
      'assets/work/edumarket_ss3.jpg',
      'assets/work/edumarket_ss4.jpg',
      'assets/work/edumarket_ss5.jpg',
    ],
    links: [
      StoreLink(
        label: 'Google Play',
        icon: _gplay,
        url:
            'https://play.google.com/store/apps/details?id=com.raiseright.edumarketapp',
      ),
      StoreLink(
        label: 'App Store',
        icon: _appstore,
        url:
            'https://apps.apple.com/eg/app/%D8%A5%D8%AF%D9%8A%D9%88-%D9%85%D8%A7%D8%B1%D9%83%D8%AA-edu-market/id6749850424',
      ),
    ],
  ),
  AppProject(
    name: 'Paletta',
    org: 'iOS & Android',
    live: true,
    stats: [
      WorkStat('5.0', ' ★', 'app rating'),
      WorkStat('500', '+', 'downloads'),
    ],
    description:
        'A B2B wholesale marketplace delivered end-to-end and launched with a '
        '5.0★ average rating. Rebuilt on Clean Architecture with modular feature '
        'packages, it features a real-time order-tracking flow and a '
        'profit-on-purchase + cashback engine that gives merchants instant '
        'margin visibility at checkout — shipped with zero rollback releases.',
    iconUrl: 'assets/work/paletta_icon.png',
    screenshots: [
      'assets/work/paletta_ss1.jpg',
      'assets/work/paletta_ss2.jpg',
      'assets/work/paletta_ss3.jpg',
      'assets/work/paletta_ss4.jpg',
      'assets/work/paletta_ss5.jpg',
    ],
    links: [
      StoreLink(
        label: 'Google Play',
        icon: _gplay,
        url:
            'https://play.google.com/store/apps/details?id=com.zamzam.palettaapp',
      ),
      StoreLink(
        label: 'App Store',
        icon: _appstore,
        url: 'https://apps.apple.com/sa/app/paletta-b2b/id6760196797?l=ar',
      ),
    ],
  ),
  AppProject(
    name: 'Adel Store',
    org: 'iOS & Android',
    live: true,
    stats: [
      WorkStat('Live', '', 'on stores'),
      WorkStat('iOS', '', '& Android'),
    ],
    description:
        'A mobile storefront for browsing, ordering, and tracking products, '
        'published live on both Google Play and the App Store. Built in Flutter '
        'with a clean, responsive catalog-to-checkout flow and full Arabic '
        'support.',
    iconUrl: 'assets/work/adelstore_icon.png',
    screenshots: [
      'assets/work/adelstore_ss1.jpg',
      'assets/work/adelstore_ss2.jpg',
      'assets/work/adelstore_ss3.jpg',
      'assets/work/adelstore_ss4.jpg',
    ],
    links: [
      StoreLink(
        label: 'Google Play',
        icon: _gplay,
        url:
            'https://play.google.com/store/apps/details?id=com.omar.adel_store',
      ),
      StoreLink(
        label: 'App Store',
        icon: _appstore,
        url: 'https://apps.apple.com/eg/app/adel-store/id6744822826',
      ),
    ],
  ),
  AppProject(
    name: 'Smart Trade',
    org: 'All Safe',
    live: true,
    stats: [
      WorkStat('10K', '+', 'downloads'),
      WorkStat('AI', '', 'signals & bots'),
    ],
    description:
        'A crypto trading companion with 10K+ downloads, surfacing AI-driven '
        'market signals and automated trading bots. Built in Flutter with '
        'hardened Dio interceptors and real-time data streams for a fast, '
        'reliable trading experience.',
    iconUrl: 'assets/work/smarttrade_icon.png',
    screenshots: [
      'assets/work/smarttrade_ss1.jpg',
      'assets/work/smarttrade_ss2.jpg',
      'assets/work/smarttrade_ss3.jpg',
      'assets/work/smarttrade_ss4.jpg',
      'assets/work/smarttrade_ss5.jpg',
    ],
    links: [
      StoreLink(
        label: 'Google Play',
        icon: _gplay,
        url: 'https://play.google.com/store/apps/details?id=com.smart.trade.ai',
      ),
    ],
  ),
  AppProject(
    name: 'Insta-Order',
    org: 'All Safe · Delivery',
    live: true,
    stats: [
      WorkStat('2,000', '+', 'monthly users'),
      WorkStat('25', '%', 'fewer crashes'),
    ],
    description:
        'A food & grocery delivery app serving 2,000+ monthly active users. '
        'Re-architected on BLoC + MVVM with hardened Dio interceptors to cut '
        'crash reports by 25%, and integrated Paymob payments at a 99% success '
        'rate.',
    iconUrl: 'assets/work/instaorder_icon.png',
    screenshots: [
      'assets/work/instaorder_ss1.jpg',
      'assets/work/instaorder_ss2.jpg',
      'assets/work/instaorder_ss3.jpg',
      'assets/work/instaorder_ss4.jpg',
      'assets/work/instaorder_ss5.jpg',
    ],
    links: [
      StoreLink(
        label: 'Google Play',
        icon: _gplay,
        url:
            'https://play.google.com/store/apps/details?id=com.allsafe.insta.order',
      ),
    ],
  ),
  AppProject(
    name: 'Stock B2B',
    org: 'Spark · iOS & Android',
    live: true,
    stats: [
      WorkStat('B2B', '', 'wholesale platform'),
      WorkStat('iOS', '', '& Android'),
    ],
    description:
        'A B2B wholesale ordering platform for retailers, live on both iOS and '
        'Android. Built in Flutter with a catalog, bulk-order cart, and order '
        'history backed by a shared networking and theming package reused '
        'across multiple apps.',
    iconUrl: 'assets/work/stockb2b_icon.png',
    screenshots: [
      'assets/work/stockb2b_ss1.jpg',
      'assets/work/stockb2b_ss2.jpg',
      'assets/work/stockb2b_ss3.jpg',
      'assets/work/stockb2b_ss4.jpg',
      'assets/work/stockb2b_ss5.jpg',
    ],
    links: [
      StoreLink(
        label: 'Google Play',
        icon: _gplay,
        url:
            'https://play.google.com/store/apps/details?id=com.spark.stockclientapp',
      ),
      StoreLink(
        label: 'App Store',
        icon: _appstore,
        url: 'https://apps.apple.com/eg/app/stock-b2b/id1639101527',
      ),
    ],
  ),
  AppProject(
    name: 'Fishtail',
    org: 'Swimming platform',
    live: true,
    stats: [
      WorkStat('800', '+', 'active users'),
      WorkStat('99', '%', 'uptime'),
    ],
    description:
        'A swimming-events and tutorials platform scaled to 800+ active users at '
        '~99% uptime. Built on Cubit + Clean Architecture with Google Maps and '
        'a Firebase stack, plus Stripe Payment Intents for recurring premium '
        'subscriptions — zero payment incidents post-launch.',
    iconUrl: 'assets/work/fishtail_icon.png',
    screenshots: [
      'assets/work/fishtail_ss1.jpg',
      'assets/work/fishtail_ss2.jpg',
      'assets/work/fishtail_ss3.jpg',
      'assets/work/fishtail_ss4.jpg',
      'assets/work/fishtail_ss5.jpg',
    ],
    links: [
      StoreLink(
        label: 'Google Play',
        icon: _gplay,
        url:
            'https://play.google.com/store/apps/details?id=com.perfectneeds.fishtailapp',
      ),
      StoreLink(
        label: 'App Store',
        icon: _appstore,
        url: 'https://apps.apple.com/eg/app/fishtail-app/id6463719006',
      ),
    ],
  ),
  AppProject(
    name: 'Mashwar Thaqeel',
    org: 'App Store & Play',
    live: true,
    stats: [
      WorkStat('Solo', '', 'developer'),
      WorkStat('Live', '', 'on stores'),
    ],
    description:
        'A freight-matching app connecting shippers with truck drivers, '
        'designed, built, and published solo on both stores. Built with '
        'BLoC + MVVM and Dio — every stage owned independently, from '
        'architecture and UI/UX to store submission and post-launch support.',
    iconUrl: 'assets/work/mashwar_icon.png',
    screenshots: [
      'assets/work/mashwar_ss1.jpg',
      'assets/work/mashwar_ss2.jpg',
      'assets/work/mashwar_ss3.jpg',
      'assets/work/mashwar_ss4.jpg',
      'assets/work/mashwar_ss5.jpg',
    ],
    links: [
      StoreLink(
        label: 'Google Play',
        icon: _gplay,
        url: 'https://play.google.com/store/apps/details?id=com.mishwar.thakil',
      ),
      StoreLink(
        label: 'App Store',
        icon: _appstore,
        url:
            'https://apps.apple.com/eg/app/%D9%85%D8%B4%D9%88%D8%A7%D8%B1-%D8%AB%D9%82%D9%8A%D9%84/id6740751681',
      ),
    ],
  ),
  AppProject(
    name: 'Black Market',
    org: 'Google Play',
    live: true,
    stats: [
      WorkStat('Real-time', '', 'FX rates'),
      WorkStat('In-app', '', 'converter'),
    ],
    description:
        'A live currency-rates app released on Google Play, offering real-time '
        'black-market vs. official rate comparison and an in-app converter. '
        'Built and shipped independently end-to-end.',
    links: [StoreLink(label: 'Google Play', icon: _gplay)],
  ),
];

class ExperienceEntry {
  final String date;
  final String place;
  final String role;
  final String org;
  final List<String> bullets;
  const ExperienceEntry({
    required this.date,
    required this.place,
    required this.role,
    required this.org,
    required this.bullets,
  });
}

const List<ExperienceEntry> kExperience = [
  ExperienceEntry(
    date: 'Jul 2025 — Present',
    place: 'Maadi, Cairo · On-site',
    role: 'Mobile Developer — Flutter',
    org: 'Raise Right',
    bullets: [
      'Engineered the *EduMarket* cross-platform app on Flutter + GraphQL, serving *1,500+ active users* with 99% crash-free sessions across iOS and Android.',
      'Hardened production builds against reverse-engineering with R8 code shrinking and obfuscation, protecting payment and PII data.',
      'Introduced automated end-to-end test suites with Appium, accelerating QA cycles and surfacing regressions before each store push.',
      'Led bi-weekly PR reviews across a 6-engineer team, lifting maintainability metrics by *~15%*.',
    ],
  ),
  ExperienceEntry(
    date: 'Jun 2025 — Apr 2026',
    place: 'Egypt · Remote',
    role: 'Mobile Developer — Flutter',
    org: 'Stock',
    bullets: [
      'Owned end-to-end delivery of *Paletta*, a B2B wholesale marketplace — launched on Google Play with a *5.0★* average rating.',
      'Refactored a legacy codebase to Clean Architecture and modular feature packages, accelerating subsequent feature work.',
      'Built a real-time order-tracking flow and a profit-on-purchase + cashback engine for instant margin visibility at checkout.',
      'Shipped continuous updates with *zero rollback releases* over an 11-month tenure.',
    ],
  ),
  ExperienceEntry(
    date: 'Nov 2024 — Jul 2025',
    place: 'Egypt · Remote',
    role: 'Flutter Developer',
    org: 'Fishtail',
    bullets: [
      'Scaled a swimming-events & tutorials app to *800+ active users*, integrating Google Maps and a Firebase stack at ~99% uptime.',
      'Cut integration defects by *~20%* and improved cold-start by ~10% via Cubit and a Clean Architecture data/domain split.',
      'Integrated Stripe Payment Intents for recurring premium subscriptions — zero payment incidents post-launch.',
    ],
  ),
  ExperienceEntry(
    date: 'Dec 2023 — Feb 2025',
    place: 'Nasr City, Cairo · On-site',
    role: 'Flutter Developer',
    org: 'All Safe — Software House',
    bullets: [
      'Shipped *4 production apps* across crypto, e-commerce, and reservation domains — each averaging 4.5★ ratings.',
      'Reduced crash reports by *25%* on Insta-Order (2,000+ MAU) via BLoC + MVVM and hardened Dio interceptors; integrated Paymob at 99% success.',
      'Accelerated feature delivery by *20%* by extracting reusable widgets, theming, and networking into a shared package across 4+ apps.',
    ],
  ),
  ExperienceEntry(
    date: 'Aug 2023 — Feb 2025',
    place: 'Remote · Independent',
    role: 'Freelance Flutter Developer',
    org: 'Independent',
    bullets: [
      'Designed, built, and published *Mashwar Thaqeel* on the App Store solo — a freight-matching app built with BLoC + MVVM and Dio.',
      'Released *Black Market: Live Currency Rates* on Google Play with real-time rate comparison and an in-app converter.',
      'Managed every stage independently — architecture, UI/UX, store submission, and post-launch support.',
    ],
  ),
];

class Principle {
  final String title;
  final String detail;
  const Principle(this.title, this.detail);
}

const List<Principle> kPrinciples = [
  Principle(
    'Architecture before features',
    'Clean Architecture & SOLID from day one',
  ),
  Principle(
    'Measure, then optimize',
    'Crash rates, cold-start, delivery speed',
  ),
  Principle('Secure by default', 'Hardened interceptors, secure storage, R8'),
  Principle(
    'Ship small, ship often',
    'Two-week sprints, zero-rollback releases',
  ),
  Principle('Review every PR', 'Shared style guide across the whole team'),
];

class SkillGroup {
  final String title;
  final String sub;
  final IconData icon;
  final bool cyan;
  final List<String> chips;
  const SkillGroup({
    required this.title,
    required this.sub,
    required this.icon,
    required this.cyan,
    required this.chips,
  });
}

const List<SkillGroup> kSkills = [
  SkillGroup(
    title: 'Core & Languages',
    sub: '// the foundation',
    icon: FontAwesomeIcons.cube,
    cyan: false,
    chips: [
      'Flutter',
      'Dart',
      'Material 3',
      'Cupertino',
      'Kotlin',
      'Swift',
      'JavaScript',
      'SQL',
    ],
  ),
  SkillGroup(
    title: 'State & Architecture',
    sub: '// scalable by design',
    icon: FontAwesomeIcons.layerGroup,
    cyan: true,
    chips: [
      'BLoC',
      'Cubit',
      'Provider',
      'Clean Architecture',
      'MVVM',
      'SOLID',
      'Repository',
      'get_it / injectable',
    ],
  ),
  SkillGroup(
    title: 'APIs & Networking',
    sub: '// talking to backends',
    icon: FontAwesomeIcons.globe,
    cyan: false,
    chips: ['REST', 'GraphQL', 'Dio', 'Retrofit', 'WebSockets', 'Interceptors'],
  ),
  SkillGroup(
    title: 'Backend & Cloud',
    sub: '// the serverless side',
    icon: FontAwesomeIcons.database,
    cyan: true,
    chips: [
      'Firebase Auth',
      'Firestore',
      'FCM',
      'Crashlytics',
      'Remote Config',
      'Hasura',
    ],
  ),
  SkillGroup(
    title: 'Payments & Storage',
    sub: '// money & persistence',
    icon: FontAwesomeIcons.creditCard,
    cyan: false,
    chips: [
      'Stripe',
      'Paymob',
      'In-App Purchases',
      'Hive',
      'SQLite',
      'Secure Storage',
    ],
  ),
  SkillGroup(
    title: 'Testing & DevOps',
    sub: '// ship with confidence',
    icon: FontAwesomeIcons.codeBranch,
    cyan: true,
    chips: [
      'Unit / Widget / Integration',
      'Appium E2E',
      'GitHub Actions',
      'CI/CD',
      'R8 / ProGuard',
      'App Store Connect',
      'Play Console',
    ],
  ),
];

/// Hero typing-effect words.
const List<String> kTypingWords = [
  'Flutter Developer',
  'Cross-Platform Engineer',
  'Clean Architecture advocate',
  '10+ apps shipped to stores',
];

/// Section anchors (id, nav label).
class SectionRef {
  final String id;
  final String label;
  const SectionRef(this.id, this.label);
}

const List<SectionRef> kNavSections = [
  SectionRef('work', 'Work'),
  SectionRef('experience', 'Experience'),
  SectionRef('about', 'About'),
  SectionRef('skills', 'Skills'),
  SectionRef('contact', 'Contact'),
];
