import 'dart:js_interop';

@JS('window')
external _Window get _window;

extension type _Window._(JSObject _) implements JSObject {
  external _Window get parent;
  external void postMessage(JSAny? message, JSString targetOrigin);
}

/// Posts `{type: 'liq.height', px: N}` to `window.parent` via postMessage.
void postHeightToParent(int px) {
  final payload = {'type': 'liq.height', 'px': px}.jsify();
  _window.parent.postMessage(payload, '*'.toJS);
}
