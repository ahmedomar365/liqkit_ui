// Conditional imports must use relative URIs - the analyzer evaluates
// the condition at compile time and resolves both branches relative to
// the importing file. Suppress lints for conditional export syntax.
// ignore: always_use_package_imports, conditional_uri_does_not_exist
export 'theme_query_io.dart'
    if (dart.library.js_interop) 'theme_query_web.dart';
