/// Non-web (Dart VM) fallback for [Analytics]. There is no `gtag` outside the
/// browser, so every call is a no-op — this keeps `flutter test` and any
/// future desktop/mobile build compiling without analytics side effects.
library;

void gaPageView(String path, String title) {}

void gaEvent(String name, Map<String, Object?> params) {}
