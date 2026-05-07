import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/segmented/liq_segmented_control.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';

/// A two-pane layout for documentation/playground/demo screens — a
/// control panel on one side and the live demo canvas on the other.
///
/// On wide viewports (≥ [mobileBreakpoint]) the controls are pinned
/// to the left in a fixed-width gutter, separated from the canvas by
/// a 1pt divider.
///
/// On narrow viewports the same controls + canvas are stacked behind a
/// 2-segment [LiqSegmentedControl] (`Demo` / `Controls`) so the user
/// only sees one panel at a time.
///
/// Both builders are called every rebuild — wrap heavy widgets in
/// `const` constructors to keep mobile tab-switching cheap. The split
/// is a `LayoutBuilder`, so the breakpoint is the parent's max width,
/// not the device width — this means the same screen can render in
/// both modes side-by-side inside a wider scaffold.
final class LiqDemoSplitLayout extends StatefulWidget with Diagnosticable {
  /// Creates a demo split layout.
  const LiqDemoSplitLayout({
    required this.controlPanelBuilder,
    required this.demoContentBuilder,
    this.controlPanelWidth = 360,
    this.controlPanelPadding,
    this.demoContentPadding,
    this.demoAreaBackgroundColor,
    this.mobileBreakpoint = 768,
    super.key,
  });

  /// Builder that returns the controls/inspector pane.
  final Widget Function(BuildContext context) controlPanelBuilder;

  /// Builder that returns the live preview / canvas pane.
  final Widget Function(BuildContext context) demoContentBuilder;

  /// Width of the controls gutter on the desktop layout.
  final double controlPanelWidth;

  /// Padding around the controls pane. Defaults to 16/20pt.
  final EdgeInsetsGeometry? controlPanelPadding;

  /// Padding around the demo pane. Defaults to 16/32pt.
  final EdgeInsetsGeometry? demoContentPadding;

  /// Background color behind the demo pane. Defaults to the system
  /// grouped-background color from the active palette.
  final Color? demoAreaBackgroundColor;

  /// Layout-builder breakpoint at which the layout collapses from
  /// two-pane to tabbed.
  final double mobileBreakpoint;

  @override
  State<LiqDemoSplitLayout> createState() => _LiqDemoSplitLayoutState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('controlPanelWidth', controlPanelWidth))
      ..add(DoubleProperty('mobileBreakpoint', mobileBreakpoint));
  }
}

class _LiqDemoSplitLayoutState extends State<LiqDemoSplitLayout> {
  String _selectedTab = 'demo';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < widget.mobileBreakpoint;
        if (isMobile) return _buildMobile(context);
        return _buildDesktop(context);
      },
    );
  }

  Widget _buildMobile(BuildContext context) {
    final palette = context.appleColors;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: LiqSegmentedControl<String>(
            value: _selectedTab,
            segments: const <({String value, String label})>[
              (value: 'demo', label: 'Demo'),
              (value: 'controls', label: 'Controls'),
            ],
            onChanged: (v) => setState(() => _selectedTab = v),
          ),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(color: palette.separator),
        ),
        Expanded(
          child: IndexedStack(
            index: _selectedTab == 'demo' ? 0 : 1,
            sizing: StackFit.expand,
            children: <Widget>[
              ColoredBox(
                color: widget.demoAreaBackgroundColor ??
                    palette.systemGroupedBackground,
                child: SingleChildScrollView(
                  padding:
                      widget.demoContentPadding ?? const EdgeInsets.all(16),
                  child: widget.demoContentBuilder(context),
                ),
              ),
              SingleChildScrollView(
                padding:
                    widget.controlPanelPadding ?? const EdgeInsets.all(16),
                child: widget.controlPanelBuilder(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final palette = context.appleColors;
    return Row(
      children: <Widget>[
        Container(
          width: widget.controlPanelWidth,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: palette.separator),
            ),
          ),
          child: SingleChildScrollView(
            padding: widget.controlPanelPadding ?? const EdgeInsets.all(20),
            child: widget.controlPanelBuilder(context),
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: widget.demoAreaBackgroundColor ??
                palette.systemGroupedBackground,
            child: SingleChildScrollView(
              padding: widget.demoContentPadding ?? const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: widget.demoContentBuilder(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
