@JS()
library;

import 'dart:js_interop';

@JS('liqSnippetsReady')
external set _liqSnippetsReady(JSBoolean value);

/// Web implementation: sets `window.liqSnippetsReady = true` so the
/// docs-side `LiqPreview` wrapper can wait for first paint.
void setReadyFlag() {
  _liqSnippetsReady = true.toJS;
}
