import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';


final selectedItemsProvider = StateProvider<Set<int>>((ref) => <int>{});
final reorderableItemsProvider = StateProvider<List<String>>((ref) => <String>[
      'Drag to reorder',
      'Long press and drag',
      'Item 3',
      'Item 4',
      'Item 5',
    ]);

class ListsDemoScreen extends ConsumerStatefulWidget {
  const ListsDemoScreen({super.key});

  @override
  ConsumerState<ListsDemoScreen> createState() => _ListsDemoScreenState();
}

class _ListsDemoScreenState extends ConsumerState<ListsDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Lists')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Basic',
              description: 'Plain list rows with title and subtitle.',
              child: LiqListGroup(
                rows: List<LiqListRow>.generate(
                  5,
                  (index) => LiqListRow(
                    title: 'List Item ${index + 1}',
                    subtitle: 'This is subtitle for item ${index + 1}',
                    onTap: () {},
                  ),
                ),
              ),
            ),
            _Section(
              title: 'With Icons',
              description: 'Leading icons help scan a settings-style list.',
              child: LiqListGroup(
                rows: <LiqListRow>[
                  for (final entry in <({IconData icon, String title})>[
                    (icon: LiqIcons.wifi, title: 'Wi-Fi'),
                    (icon: LiqMaterialIcons.bluetooth, title: 'Bluetooth'),
                    (icon: LiqMaterialIcons.batteryFull, title: 'Battery'),
                    (
                      icon: LiqMaterialIcons.airplanemodeActive,
                      title: 'Airplane Mode'
                    ),
                    (icon: LiqMaterialIcons.locationOn, title: 'Location'),
                  ])
                    LiqListRow(
                      leading:
                          Icon(entry.icon, color: context.appleColors.blue),
                      title: entry.title,
                      subtitle: 'Subtitle for ${entry.title}',
                      onTap: () {},
                    ),
                ],
              ),
            ),
            _Section(
              title: 'With Actions',
              description:
                  'Trailing toggle / chip widgets attached to list rows.',
              child: LiqListGroup(
                rows: List<LiqListRow>.generate(5, (index) {
                  return LiqListRow(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            context.appleColors.blue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: context.appleColors.blue,
                          fontWeight: LiqAppleTypography.bold,
                        ),
                      ),
                    ),
                    title: 'Action Item ${index + 1}',
                    subtitle: 'Tap for action',
                    trailing: index % 2 == 0
                        ? LiqToggle(value: index == 0, onChanged: (_) {})
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: context.appleColors.blue
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'Action',
                              style: context.textStyles.caption1.copyWith(
                                color: context.appleColors.blue,
                                fontWeight: LiqAppleTypography.semibold,
                              ),
                            ),
                          ),
                    onTap: () {},
                  );
                }),
              ),
            ),
            _Section(
              title: 'Selectable',
              description:
                  'Each row has a checkbox; tap rows to add/remove from selection.',
              child: _SelectableListBody(),
            ),
            _Section(
              title: 'Swipeable',
              description:
                  'Swipe left or right on rows to reveal contextual actions.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List<Widget>.generate(5, (index) {
                  return LiqSwipeableListRow(
                    leadingActions: <LiqSwipeAction>[
                      LiqSwipeAction(
                        icon: LiqMaterialIcons.archive,
                        label: 'Archive',
                        backgroundColor: context.appleColors.blue,
                        onTap: () => LiqToastOverlay.show(
                          context,
                          'Archived item ${index + 1}',
                        ),
                      ),
                    ],
                    trailingActions: <LiqSwipeAction>[
                      LiqSwipeAction(
                        icon: LiqMaterialIcons.delete,
                        label: 'Delete',
                        backgroundColor: context.appleColors.red,
                        onTap: () => LiqToastOverlay.show(
                          context,
                          'Deleted item ${index + 1}',
                        ),
                      ),
                      LiqSwipeAction(
                        icon: LiqMaterialIcons.moreHoriz,
                        label: 'More',
                        backgroundColor: context.appleColors.orange,
                        onTap: () => LiqToastOverlay.show(
                          context,
                          'More options for item ${index + 1}',
                        ),
                      ),
                    ],
                    child: LiqListRow(
                      leading: Icon(
                        LiqMaterialIcons.emailOutlined,
                        color: context.appleColors.blue,
                      ),
                      title: 'Swipeable Item ${index + 1}',
                      subtitle: 'Swipe left or right',
                    ),
                  );
                }),
              ),
            ),
            _Section(
              title: 'Grouped',
              description:
                  'Sectioned list with headers and footers per group.',
              child: LiqGroupedListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                sections: <LiqListSection>[
                  LiqListSection(
                    header: 'Group A',
                    footer: 'This is the first group of items',
                    children: List<LiqListRow>.generate(3, (index) {
                      return LiqListRow(
                        leading: Icon(LiqIcons.star,
                            color: context.appleColors.yellow),
                        title: 'Group A Item ${index + 1}',
                        subtitle: 'In first group',
                        onTap: () {},
                      );
                    }),
                  ),
                  LiqListSection(
                    header: 'Group B',
                    footer: 'This is the second group of items',
                    children: List<LiqListRow>.generate(3, (index) {
                      return LiqListRow(
                        leading: Icon(LiqMaterialIcons.favorite,
                            color: context.appleColors.red),
                        title: 'Group B Item ${index + 1}',
                        subtitle: 'In second group',
                        onTap: () {},
                      );
                    }),
                  ),
                  LiqListSection(
                    header: 'Group C',
                    children: List<LiqListRow>.generate(2, (index) {
                      return LiqListRow(
                        leading: Icon(LiqIcons.bookmark,
                            color: context.appleColors.green),
                        title: 'Group C Item ${index + 1}',
                        subtitle: 'In third group',
                        onTap: () {},
                      );
                    }),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Reorderable',
              description:
                  'Long-press and drag to reorder rows. State is persisted via Riverpod.',
              child: _ReorderableListBody(),
            ),
            _Section(
              title: 'Expandable',
              description:
                  'Each row expands to reveal nested children.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List<Widget>.generate(5, (index) {
                  return LiqExpandableListRow(
                    leading:
                        Icon(LiqIcons.folder, color: context.appleColors.blue),
                    title: 'Expandable Item ${index + 1}',
                    subtitle: 'Tap to expand / collapse',
                    children: List<Widget>.generate(3, (subIndex) {
                      return LiqListRow(
                        title: 'Sub-item ${subIndex + 1}',
                        subtitle: 'Child of item ${index + 1}',
                        onTap: () {},
                        contentPadding: const EdgeInsets.only(
                          left: 48,
                          right: 16,
                          top: 8,
                          bottom: 8,
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableListBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedItemsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${selectedItems.length} selected',
              style: context.textStyles.footnote.secondary,
            ),
          ),
        ),
        ...List<Widget>.generate(5, (index) {
          return LiqSelectableListRow(
            leading: Icon(LiqMaterialIcons.folderOutlined,
                color: context.appleColors.blue),
            title: 'Selectable Item ${index + 1}',
            subtitle: 'Tap to select',
            selected: selectedItems.contains(index),
            onChanged: (selected) {
              final current = ref.read(selectedItemsProvider);
              if (selected) {
                ref.read(selectedItemsProvider.notifier).state = <int>{
                  ...current,
                  index,
                };
              } else {
                ref.read(selectedItemsProvider.notifier).state = <int>{
                  ...current,
                }..remove(index);
              }
            },
          );
        }),
      ],
    );
  }
}

class _ReorderableListBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(reorderableItemsProvider);
    return LiqReorderableList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        var adjusted = newIndex;
        if (newIndex > oldIndex) adjusted -= 1;
        final next = List<String>.from(items);
        final item = next.removeAt(oldIndex);
        next.insert(adjusted, item);
        ref.read(reorderableItemsProvider.notifier).state = next;
      },
      children: <Widget>[
        for (var i = 0; i < items.length; i++)
          LiqListRow(
            key: ValueKey<String>(items[i]),
            leading: Icon(LiqMaterialIcons.dragHandle,
                color: context.appleColors.secondaryLabel),
            title: items[i],
            subtitle: 'Position ${i + 1}',
            trailing: Icon(
              LiqIcons.menu,
              color: context.appleColors.tertiaryLabel,
            ),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
