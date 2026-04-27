import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

const Color _border = Color(0xFFD8DCE3);
const Color _bg = Color(0xFFFFFFFF);
const Color _sectionBorder = Color(0xFFD8DCE3);
const Color _itemBorder = Color(0xFFE2E7EF);
const Color _itemBg = Color(0xFFF8FAFC);
const Color _h3Color = Color(0xFF111111);
const Color _bodyColor = Color(0xFF4F5661);
const Color _h4Color = Color(0xFF111827);
const Color _metaColor = Color(0xFF526072);
const Color _itemNameColor = Color(0xFF0F172A);
const Color _itemMetaColor = Color(0xFF475569);
const Color _codeColor = Color(0xFF1D4ED8);

/// Documentation panel — 12pt rounded white card with hairline border,
/// optional 590-weight 18/22 title, optional body text, then the slot
/// content.
///
/// Sourced from `native/components/examples.css` (`.ios26-examples-
/// showcase` and `.ios26-examples-section`).
final class LiqExamplesPanel extends StatelessWidget {
  /// Creates a panel.
  const LiqExamplesPanel({
    required this.child,
    this.title,
    this.body,
    super.key,
  });

  /// Optional 590-weight 18/22 SF Pro Text heading.
  final String? title;

  /// Optional body paragraph rendered in #4F5661.
  final String? body;

  /// Slot content beneath the heading.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.fromBorderSide(BorderSide(color: _border)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (title != null) ...<Widget>[
              Text(
                title!,
                style: const TextStyle(
                  color: _h3Color,
                  fontFamily: 'SF Pro Text',
                  fontSize: 18,
                  height: 22 / 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (body != null) ...<Widget>[
              Text(
                body!,
                style: const TextStyle(
                  color: _bodyColor,
                  fontFamily: 'SF Pro Text',
                  fontSize: 14,
                  height: 19 / 14,
                ),
              ),
              const SizedBox(height: 8),
            ],
            child,
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('body', body));
  }
}

/// Section panel — 590-weight 15/20 title + 12/16 meta + slot content.
final class LiqExamplesSection extends StatelessWidget {
  /// Creates a section.
  const LiqExamplesSection({
    required this.title,
    required this.child,
    this.meta,
    super.key,
  });

  /// Section title.
  final String title;

  /// Optional meta text rendered in 500-weight 12/16.
  final String? meta;

  /// Section content (typically a grid of [LiqExamplesItem]).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.fromBorderSide(BorderSide(color: _sectionBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: _h4Color,
                fontFamily: 'SF Pro Text',
                fontSize: 15,
                height: 20 / 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (meta != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                meta!,
                style: const TextStyle(
                  color: _metaColor,
                  fontFamily: 'SF Pro Text',
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('meta', meta));
  }
}

/// Compact item card — name (590 12/16) + optional meta (500 11/14).
final class LiqExamplesItem extends StatelessWidget {
  /// Creates an item.
  const LiqExamplesItem({
    required this.name,
    this.meta,
    this.code,
    super.key,
  });

  /// Item display name.
  final String name;

  /// Optional meta caption.
  final String? meta;

  /// Optional inline code label rendered in #1D4ED8 monospace.
  final String? code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: _itemBg,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.fromBorderSide(BorderSide(color: _itemBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(
              color: _itemNameColor,
              fontFamily: 'SF Pro Text',
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (meta != null || code != null) ...<Widget>[
            const SizedBox(height: 4),
            DefaultTextStyle(
              style: const TextStyle(
                color: _itemMetaColor,
                fontFamily: 'SF Pro Text',
                fontSize: 11,
                height: 14 / 11,
                fontWeight: FontWeight.w500,
              ),
              child: Wrap(
                spacing: 4,
                runSpacing: 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  if (meta != null) Text(meta!),
                  if (code != null)
                    Text(
                      code!,
                      style: const TextStyle(
                        color: _codeColor,
                        fontFamily: 'ui-monospace',
                        fontFamilyFallback: <String>[
                          'SFMono-Regular',
                          'Menlo',
                          'Monaco',
                          'Courier New',
                        ],
                        fontSize: 11,
                        height: 14 / 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('name', name))
      ..add(StringProperty('meta', meta))
      ..add(StringProperty('code', code));
  }
}
