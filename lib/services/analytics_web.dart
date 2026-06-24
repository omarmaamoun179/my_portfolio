/// Web implementation of [Analytics], talking to the global `gtag()` defined by
/// the GA4 snippet in `web/index.html`. Compiled only when `dart:js_interop` is
/// available (the web target).
library;

import 'dart:js_interop';

/// Bridges to the global `gtag(...)` function. gtag is variadic in JS; we only
/// ever need the `(command, target, params)` shape here. If the snippet failed
/// to load (e.g. blocked by an ad/privacy extension) `gtag` is undefined and
/// the call throws — callers are wrapped in [_safe] so that never surfaces.
@JS('gtag')
external void _gtag(String command, String target, JSAny? params);

void gaPageView(String path, String title) {
  _safe(() {
    _gtag(
      'event',
      'page_view',
      {'page_path': path, 'page_title': title}.jsify(),
    );
  });
}

void gaEvent(String name, Map<String, Object?> params) {
  _safe(() {
    _gtag('event', name, params.isEmpty ? null : params.jsify());
  });
}

/// Analytics must never break the UI: swallow any interop error (missing gtag,
/// blocked script, serialization issue).
void _safe(void Function() fn) {
  try {
    fn();
  } catch (_) {
    // best-effort; analytics outages are non-fatal.
  }
}
