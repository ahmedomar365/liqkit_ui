@JS()
library;

import 'dart:js_interop';

@JS('liqShowcaseReady')
external set _liqShowcaseReady(JSBoolean value);

/// Web implementation: sets `window.liqShowcaseReady = true` so that
/// the Playwright fidelity loop can `waitForFunction` on it.
void setReadyFlag() {
  _liqShowcaseReady = true.toJS;
}
