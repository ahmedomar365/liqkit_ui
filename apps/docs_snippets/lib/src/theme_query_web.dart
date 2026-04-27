import 'dart:js_interop';

@JS('window.location.search')
external JSString get _locationSearch;

/// Returns "dark" if the URL has `?theme=dark`, else "light".
String readThemeQueryParam() {
  final s = _locationSearch.toDart;
  if (s.contains('theme=dark')) return 'dark';
  return 'light';
}
