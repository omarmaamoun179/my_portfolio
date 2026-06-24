/// Thin wrapper over Google Analytics 4 (gtag.js).
///
/// The actual `gtag` calls live in [analytics_web.dart] (compiled only for the
/// web target via `dart:js_interop`); on the Dart VM (tests, desktop) the
/// [analytics_stub.dart] no-ops are used instead. Wiring it this way means
/// section/widget code can call [Analytics.logEvent] unconditionally without
/// `kIsWeb` guards or breaking `flutter test`.
///
/// The GA4 Measurement ID itself is configured in `web/index.html`; this layer
/// only forwards page-views and events to whatever property is loaded there.
library;

import 'analytics_stub.dart' if (dart.library.js_interop) 'analytics_web.dart'
    as platform;

class Analytics {
  const Analytics._();

  /// Record a virtual page-view. Because the portfolio is a single-page Flutter
  /// app, the browser never reloads — we emit `page_view` manually whenever the
  /// visitor opens a logical "page" (e.g. the home view or the privacy policy).
  static void logPageView({required String path, required String title}) {
    platform.gaPageView(path, title);
  }

  /// Record a custom interaction event (e.g. `cv_download`, `contact_click`).
  static void logEvent(String name, [Map<String, Object?> params = const {}]) {
    platform.gaEvent(name, params);
  }
}
