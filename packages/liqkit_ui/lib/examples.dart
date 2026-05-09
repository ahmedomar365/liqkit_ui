/// Example compositions for every liqkit_ui component.
///
/// These are *recipes* — concrete demo widgets that compose primitives
/// from `package:liqkit_ui/liqkit_ui.dart` into ready-to-render
/// patterns. They are the single source of truth for the showcase app
/// (`apps/showcase_app/`) and the live previews on liqkit.com
/// (`apps/docs_snippets/`).
///
/// **Not shipped to pub.dev.** This file and `lib/src/examples/` are
/// listed in `.pubignore` so the published `liqkit_ui` archive stays
/// focused on primitives. Workspace members consume the local copy via
/// path resolution; outside library consumers don't see this surface.
///
/// To add a new variant:
/// 1. Add a `final class XxxExample extends StatefulWidget` to the
///    matching file in `lib/src/examples/`.
/// 2. Re-export it from this barrel.
/// 3. Reference it from the showcase demo screen and from a
///    docs_snippets route — both via this barrel.
library liqkit_ui_examples;

// Component examples — alphabetical.
// (Each export gets uncommented as the corresponding file lands.)

export 'src/examples/action_sheet.dart';
// export 'src/examples/activity_view.dart';
// export 'src/examples/alert.dart';
// export 'src/examples/animations.dart';
// export 'src/examples/app_icon.dart';
// export 'src/examples/button.dart';
// export 'src/examples/color_picker.dart';
// export 'src/examples/colors.dart';
// export 'src/examples/context_menu.dart';
export 'src/examples/device_bezel.dart';
// export 'src/examples/empty_state.dart';
export 'src/examples/face_id.dart';
// export 'src/examples/keyboard.dart';
// export 'src/examples/list.dart';
export 'src/examples/materials.dart';
export 'src/examples/menu.dart';
export 'src/examples/notification.dart';
export 'src/examples/page_control.dart';
export 'src/examples/picker.dart';
export 'src/examples/popover.dart';
export 'src/examples/popup_button.dart';
export 'src/examples/progress.dart';
// export 'src/examples/segmented_control.dart';
// export 'src/examples/sheet.dart';
export 'src/examples/sidebar.dart';
// export 'src/examples/slider.dart';
// export 'src/examples/status_bar.dart';
// export 'src/examples/stepper.dart';
// export 'src/examples/text_field.dart';
// export 'src/examples/text_styles.dart';
// export 'src/examples/toggle.dart';
// export 'src/examples/toolbar.dart';
// export 'src/examples/top_bar.dart';
// export 'src/examples/wallpaper.dart';
// export 'src/examples/widget.dart';
