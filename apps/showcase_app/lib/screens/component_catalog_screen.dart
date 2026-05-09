import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../core/theme/liquid_theme.dart';
import 'demos/device_bezel_demo_screen_v2.dart';
import 'demos/face_id_demo_screen.dart';
import 'demos/keyboard_demo_screen.dart';
import 'demos/popup_button_demo_screen_v2.dart';
import 'demos/sidebar_demo_screen_v2.dart';
import 'demos/status_bar_demo_screen_v2.dart';
import 'demos/toolbar_demo_screen.dart';
import 'demos/system_ui_demo_screen.dart';
import 'demos/widget_demo_screen.dart';
import 'demos/animations_demo_screen.dart';
import 'demos/ios_demo_screen.dart';
import 'demos/macos_demo_screen.dart';



import 'demos/app_icon_demo_screen.dart';
import 'demos/activity_indicators_all_in_one_demo_screen.dart';
import 'demos/buttons_all_in_one_demo_screen.dart';
import 'demos/dialogs_sheets_all_in_one_demo_screen.dart';
import 'demos/color_picker_demo_screen.dart';
import 'demos/colors_demo_screen.dart';
import 'demos/context_menu_demo_screen.dart';
import 'demos/empty_state_demo_screen.dart';
import 'demos/lists_demo_screen.dart';
import 'demos/material_demo_screen_v2.dart';
import 'demos/menu_demo_screen_v2.dart';
import 'demos/notifications_demo_screen.dart';
import 'demos/page_control_demo_screen.dart';
import 'demos/picker_demo_screen.dart';
import 'demos/popover_demo_screen.dart';

import 'demos/segmented_control_demo_screen.dart';

import 'demos/slider_demo_screen.dart';
import 'demos/stepper_demo_screen.dart';
import 'demos/text_field_demo_screen.dart';
import 'demos/text_styles_demo_screen.dart';
import 'demos/toggle_demo_screen.dart';
import 'demos/top_bar_demo_screen.dart';
import 'demos/wallpaper_demo_screen.dart';

// Component category model
class ComponentCategory {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<ComponentItem> components;

  const ComponentCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.components,
  });
}

// Individual component item
class ComponentItem {
  final String name;
  final String description;
  final Widget Function(BuildContext) demoBuilder;

  const ComponentItem({
    required this.name,
    required this.description,
    required this.demoBuilder,
  });
}

// Component catalog screen
class ComponentCatalogScreen extends ConsumerWidget {
  const ComponentCatalogScreen({super.key});

  static final List<ComponentCategory> categories = [
    ComponentCategory(
      name: 'Buttons',
      description:
          'Every button variant — primary, secondary, destructive, ghost, '
          'icon buttons, popup, pull-down, split.',
      icon: LiqMaterialIcons.smartButton,
      color: const Color(0xFF007AFF),
      components: [
        ComponentItem(
          name: 'All Buttons',
          description: 'Buttons + popup buttons in one scroll',
          demoBuilder: (context) => const ButtonsAllInOneDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Input Fields',
      description: 'Text input and form components',
      icon: LiqMaterialIcons.textFields,
      color: const Color(0xFF34C759),
      components: [
        ComponentItem(
          name: 'Text Fields (All Variants)',
          description: 'Comprehensive text field components demo',
          demoBuilder: (context) => const TextFieldDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Lists',
      description: 'List views and list tiles',
      icon: LiqIcons.list,
      color: const Color(0xFF32ADE6),
      components: [
        ComponentItem(
          name: 'Lists (All Variants)',
          description: 'Complete list system with all types',
          demoBuilder: (context) => const ListsDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Dialogs & Sheets',
      description:
          'Alert dialogs, action sheets, and modal sheets — every variant '
          'in one scroll.',
      icon: LiqIcons.layers,
      color: const Color(0xFFFF9500),
      components: [
        ComponentItem(
          name: 'All Dialogs & Sheets',
          description:
              'Alert dialogs + action sheets + sheets in one combined demo',
          demoBuilder: (context) => const DialogsSheetsAllInOneDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Activity Indicators',
      description:
          'Activity views, share sheets, progress bars, spinners, loading '
          'overlays, and skeleton loaders — every variant in one scroll.',
      icon: LiqMaterialIcons.hourglassEmpty,
      color: const Color(0xFFFF3B30),
      components: [
        ComponentItem(
          name: 'All Activity Indicators',
          description:
              'Activity views + progress indicators in one combined demo',
          demoBuilder: (context) =>
              const ActivityIndicatorsAllInOneDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Switches & Toggles',
      description: 'Toggle switches and checkbox components',
      icon: LiqMaterialIcons.toggleOn,
      color: const Color(0xFF00C7BE),
      components: [
        ComponentItem(
          name: 'Toggles (All Variants)',
          description: 'Comprehensive toggle switches demo',
          demoBuilder: (context) => const ToggleDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Segmented Controls',
      description: 'Tab-style segmented controls',
      icon: LiqMaterialIcons.viewWeek,
      color: const Color(0xFFFF2D55),
      components: [
        ComponentItem(
          name: 'Segmented Controls',
          description: 'All segmented control variants',
          demoBuilder: (context) => const SegmentedControlDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Sliders',
      description: 'Range and value selection components',
      icon: LiqMaterialIcons.tune,
      color: const Color(0xFFAF52DE),
      components: [
        ComponentItem(
          name: 'Sliders (All Variants)',
          description: 'All slider types and configurations',
          demoBuilder: (context) => const SliderDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Notifications',
      description: 'Alert banners and notification components',
      icon: LiqMaterialIcons.notifications,
      color: const Color(0xFFFFCC00),
      components: [
        ComponentItem(
          name: 'Notifications (All Types)',
          description: 'Banners, toasts, cards, and badges',
          demoBuilder: (context) => const NotificationsDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Page Controls',
      description: 'Page indicators and navigation',
      icon: LiqMaterialIcons.moreHoriz,
      color: const Color(0xFF8E8E93),
      components: [
        ComponentItem(
          name: 'Page Controls (All Types)',
          description: 'Dots, progress, numbered, and custom indicators',
          demoBuilder: (context) => const PageControlDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Pickers',
      description: 'Date, time, and value pickers',
      icon: LiqMaterialIcons.calendarToday,
      color: const Color(0xFF30B0C7),
      components: [
        ComponentItem(
          name: 'Pickers (All Types)',
          description: 'Date, time, number, and custom pickers',
          demoBuilder: (context) => const PickerDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'App Icons',
      description: 'App icon components and folders',
      icon: LiqMaterialIcons.apps,
      color: const Color(0xFFFF6482),
      components: [
        ComponentItem(
          name: 'App Icons (All Variants)',
          description: 'Icons, folders, dock, and badges',
          demoBuilder: (context) => const AppIconDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Colors System',
      description: 'Apple system colors and theme',
      icon: LiqMaterialIcons.colorLens,
      color: const Color(0xFF007AFF),
      components: [
        ComponentItem(
          name: 'System Colors',
          description: 'All Apple system colors',
          demoBuilder: (context) => const ColorsDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Typography',
      description: 'Text styles and typography system',
      icon: LiqMaterialIcons.textFormat,
      color: const Color(0xFF5856D6),
      components: [
        ComponentItem(
          name: 'Text Styles',
          description: 'Comprehensive text styles demo',
          demoBuilder: (context) => const TextStylesDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Color Pickers',
      description: 'Color selection components',
      icon: LiqIcons.palette,
      color: const Color(0xFFFF375F),
      components: [
        ComponentItem(
          name: 'Color Pickers (All Types)',
          description: 'Color wheel, sliders, hex input, and presets',
          demoBuilder: (context) => const ColorPickerDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Context Menus',
      description: 'Contextual menu components',
      icon: LiqIcons.menu,
      color: const Color(0xFF65C466),
      components: [
        ComponentItem(
          name: 'Context Menus (All Types)',
          description: 'Long-press menus with preview',
          demoBuilder: (context) => const ContextMenuDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Popovers',
      description: 'Popover tooltips and overlays',
      icon: LiqMaterialIcons.chatBubble,
      color: const Color(0xFF5E5CE6),
      components: [
        ComponentItem(
          name: 'Popovers (All Types)',
          description: 'Basic, arrow, menu, and rich popovers',
          demoBuilder: (context) => const PopoverDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Empty States',
      description: 'Empty and error state screens',
      icon: LiqMaterialIcons.inbox,
      color: const Color(0xFF8E8E93),
      components: [
        ComponentItem(
          name: 'Empty States (All Types)',
          description: 'No data, error, illustrated, and loading states',
          demoBuilder: (context) => const EmptyStateDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Steppers',
      description: 'Step-by-step progress components',
      icon: LiqMaterialIcons.linearScale,
      color: const Color(0xFF00C7BE),
      components: [
        ComponentItem(
          name: 'Steppers (All Types)',
          description: 'Vertical, horizontal, numeric, and onboarding',
          demoBuilder: (context) => const StepperDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Device Bezels',
      description: 'Device frame components for showcasing',
      icon: LiqMaterialIcons.phoneIphone,
      color: const Color(0xFF8E8E93),
      components: [
        ComponentItem(
          name: 'Device Frames',
          description: 'iPhone, iPad, Mac frames',
          demoBuilder: (context) => const DeviceBezelDemoScreenV2(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Authentication',
      description: 'Biometric authentication UI',
      icon: LiqMaterialIcons.fingerprint,
      color: const Color(0xFF007AFF),
      components: [
        ComponentItem(
          name: 'Face ID & Touch ID',
          description: 'Biometric authentication interfaces',
          demoBuilder: (context) => const FaceIDDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Keyboards',
      description: 'Custom keyboard layouts',
      icon: LiqMaterialIcons.keyboard,
      color: const Color(0xFF5856D6),
      components: [
        ComponentItem(
          name: 'Custom Keyboards',
          description: 'iOS-style keyboard layouts',
          demoBuilder: (context) => const KeyboardDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Materials',
      description: 'Liquid glass material effects',
      icon: LiqIcons.layers,
      color: const Color(0xFF00C7BE),
      components: [
        ComponentItem(
          name: 'Material Types',
          description: 'Various blur and transparency effects',
          demoBuilder: (context) => const MaterialDemoScreenV2(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Menus',
      description: 'Menu and dropdown components',
      icon: LiqMaterialIcons.menuOpen,
      color: const Color(0xFFFF9500),
      components: [
        ComponentItem(
          name: 'Dropdown Menus',
          description: 'Context menus and dropdowns',
          demoBuilder: (context) => const MenuDemoScreenV2(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Popup Buttons',
      description: 'Dropdown and split button components',
      icon: LiqMaterialIcons.arrowDropDownCircle,
      color: const Color(0xFFFF9500),
      components: [
        ComponentItem(
          name: 'Popup Buttons',
          description: 'Dropdown, pull-down, and split buttons',
          demoBuilder: (context) => const PopupButtonDemoScreenV2(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Sidebars',
      description: 'Navigation sidebar components',
      icon: LiqMaterialIcons.viewSidebar,
      color: const Color(0xFF32ADE6),
      components: [
        ComponentItem(
          name: 'Sidebar Navigation',
          description: 'Collapsible sidebars with liquid glass',
          demoBuilder: (context) => const SidebarDemoScreenV2(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Status Bars',
      description: 'Status bars and dynamic island',
      icon: LiqMaterialIcons.phoneIphone,
      color: const Color(0xFF8E8E93),
      components: [
        ComponentItem(
          name: 'Status Bars',
          description: 'System status bars and indicators',
          demoBuilder: (context) => const StatusBarDemoScreenV2(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Toolbars',
      description: 'Toolbar components with blur effects',
      icon: LiqMaterialIcons.viewHeadline,
      color: const Color(0xFF5856D6),
      components: [
        ComponentItem(
          name: 'Toolbars',
          description: 'Various toolbar configurations',
          demoBuilder: (context) => const ToolbarDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Navigation',
      description: 'Top bars and navigation components',
      icon: LiqMaterialIcons.navigation,
      color: const Color(0xFF30D158),
      components: [
        ComponentItem(
          name: 'Top Bars',
          description: 'Comprehensive top bar demos',
          demoBuilder: (context) => const TopBarDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'System UI',
      description: 'System-level UI components',
      icon: LiqMaterialIcons.settingsSystemDaydream,
      color: const Color(0xFF007AFF),
      components: [
        ComponentItem(
          name: 'System Components',
          description: 'Overlays, alerts, navigation, and controls',
          demoBuilder: (context) => const SystemUIDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Wallpapers',
      description: 'Background wallpaper components',
      icon: LiqMaterialIcons.wallpaper,
      color: const Color(0xFFFF6482),
      components: [
        ComponentItem(
          name: 'Wallpaper Components',
          description: 'Gradient, mesh, pattern, and dynamic wallpapers',
          demoBuilder: (context) => const WallpaperDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Widgets',
      description: 'Home screen widget components',
      icon: LiqIcons.widgets,
      color: const Color(0xFFFF9500),
      components: [
        ComponentItem(
          name: 'Widget Components',
          description: 'Interactive widgets with liquid glass effects',
          demoBuilder: (context) => const WidgetDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Animations',
      description: 'Liquid flow animations and effects',
      icon: LiqMaterialIcons.animation,
      color: const Color(0xFFAF52DE),
      components: [
        ComponentItem(
          name: 'Animation Effects',
          description: 'Liquid flow, shimmer, and gesture animations',
          demoBuilder: (context) => const AnimationsDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Platform iOS',
      description: 'iOS-specific components and behaviors',
      icon: LiqMaterialIcons.phoneIphone,
      color: const Color(0xFF007AFF),
      components: [
        ComponentItem(
          name: 'iOS Components',
          description: 'Cupertino-style widgets with liquid glass',
          demoBuilder: (context) => const IOSDemoScreen(),
        ),
      ],
    ),
    ComponentCategory(
      name: 'Platform macOS',
      description: 'macOS-specific components and behaviors',
      icon: LiqMaterialIcons.laptopMac,
      color: const Color(0xFF6E6E73),
      components: [
        ComponentItem(
          name: 'macOS Components',
          description: 'Desktop widgets with liquid glass effects',
          demoBuilder: (context) => const MacOSDemoScreen(),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = LiqTheme.of(context).brightness == Brightness.dark;

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Component Catalog',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(
            icon: isDarkMode ? LiqMaterialIcons.lightMode : LiqMaterialIcons.darkMode,
            onPressed: () {
              ref.read(liquidThemeProvider.notifier).toggleTheme();
            },
            semanticLabel: 'Toggle Theme',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              context.appleColors.blue.withValues(alpha: 0.05),
              context.appleColors.purple.withValues(alpha: 0.05),
              context.appleColors.pink.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              category: category,
              onTap: () {
                // Single-component categories: skip the intermediate
                // "pick a component" page and land directly on the
                // demo — every variant scrolls inside that one screen.
                // Multi-component categories still go through the
                // detail list (will be merged into one scroll later).
                if (category.components.length == 1) {
                  Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: category.components.first.demoBuilder,
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    LiqPageRoute<void>(
                      builder: (context) =>
                          CategoryDetailScreen(category: category),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

// Category card widget
class _CategoryCard extends StatelessWidget {
  final ComponentCategory category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  category.color,
                  category.color.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(category.icon, color: LiqColors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            category.name,
            style: context.textStyles.headline.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${category.components.length} components',
            style: context.textStyles.caption1.secondary,
          ),
        ],
      ),
    );
  }
}

// Category detail screen
class CategoryDetailScreen extends ConsumerWidget {
  final ComponentCategory category;

  const CategoryDetailScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          category.name,
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: category.components.length,
        itemBuilder: (context, index) {
          final component = category.components[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LiqCard(
              padding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).push(
                  LiqPageRoute<void>(
                    builder: component.demoBuilder,
                  ),
                );
              },
              child: LiqListRow(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 24,
                  ),
                ),
                title: component.name,
                subtitle: component.description,
                showChevron: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

// All demo screens are now directly referenced in the categories above