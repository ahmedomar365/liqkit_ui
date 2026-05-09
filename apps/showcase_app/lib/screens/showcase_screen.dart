import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import '../core/theme/liquid_theme.dart';
import 'component_catalog_screen.dart';
import 'settings_screen.dart';

class ShowcaseScreen extends ConsumerStatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  ConsumerState<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends ConsumerState<ShowcaseScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  int _selectedNavIndex = 0;
  bool _switchValue1 = true;
  bool _switchValue2 = false;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _soundEnabled = true;
  double _sliderValue1 = 0.5;
  double _sliderValue2 = 75;
  LiqRangeValues _rangeValues = const LiqRangeValues(25, 75);
  int _discreteSliderValue = 3;
  int _segmentedValue1 = 0;
  String _segmentedValue2 = 'list';
  final List<bool> _selectedItems = [false, false, false, false, false];
  int _currentPage = 0;
  final PageController _pageController = PageController();
  DateTime? _selectedDate;
  DateTime? _selectedDateTime;
  Duration _selectedDuration = const Duration(hours: 1, minutes: 30);
  String _selectedCountry = 'US';
  int _selectedNumber = 5;
  double _selectedWeight = 68.5;
  List<int> _multiColumnSelection = [1, 2];
  bool _isEditingIcons = false;
  double _downloadProgress = 0.0;
  Color _selectedColor = LiqColors.blue;
  final List<Color> _recentColors = [];
  int _currentStep = 0;
  int _numericStepperValue = 5;
  int _onboardingStep = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = LiqTheme.of(context).brightness == Brightness.dark;

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Liquid Glass Components',
          style: context.textStyles.headline,
        ),
        actions: [
          LiqIconButton(
            icon: isDarkMode ? LiqIcons.sun : LiqIcons.moon,
            onPressed: () {
              // Toggle theme
              ref.read(liquidThemeProvider.notifier).toggleTheme();
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.appleColors.blue.withValues(alpha: 0.1),
              context.appleColors.purple.withValues(alpha: 0.1),
              context.appleColors.pink.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Buttons Section
                _buildSectionTitle('Buttons'),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    LiqButton(
                      label: 'Primary Button',
                      onPressed: () => _showSnackBar('Primary button pressed'),
                      style: LiqButtonStyle.borderedProminent,
                    ),
                    LiqButton(
                      label: 'Secondary',
                      onPressed: () => _showSnackBar('Secondary button pressed'),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Destructive',
                      onPressed: () => _showSnackBar('Destructive button pressed'),
                      style: LiqButtonStyle.borderedProminent,
                      destructive: true,
                    ),
                    LiqButton(
                      label: 'Ghost',
                      onPressed: () => _showSnackBar('Ghost button pressed'),
                      style: LiqButtonStyle.borderless,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    LiqButton(
                      label: 'Small',
                      onPressed: () {},
                      size: LiqButtonSize.small,
                    ),
                    LiqButton(
                      label: 'Medium',
                      onPressed: () {},
                      size: LiqButtonSize.medium,
                    ),
                    LiqButton(
                      label: 'Large',
                      onPressed: () {},
                      size: LiqButtonSize.large,
                    ),
                    LiqButton(
                      label: 'Loading',
                      onPressed: () {},
                      isLoading: true,
                    ),
                    const LiqButton(
                      label: 'Disabled',
                      onPressed: null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    LiqButton(
                      label: 'With Icon',
                      leadingIcon: LiqIcons.star,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    LiqButton(
                      label: 'Trailing Icon',
                      trailingIcon: LiqMaterialIcons.arrowForward,
                      onPressed: () {},
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Input Fields Section
                _buildSectionTitle('Input Fields'),
                const SizedBox(height: 20),
                LiqTextField(
                  controller: _textController,
                  labelText: 'Name',
                  placeholder: 'Enter your name',
                  prefixIcon: Icon(
                    LiqMaterialIcons.person,
                    size: 20,
                    color: context.appleColors.gray,
                  ),
                ),
                const SizedBox(height: 16),
                LiqTextField(
                  controller: TextEditingController(),
                  labelText: 'Email',
                  placeholder: 'your@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    LiqMaterialIcons.email,
                    size: 20,
                    color: context.appleColors.gray,
                  ),
                ),
                const SizedBox(height: 16),
                LiqTextField(
                  controller: TextEditingController(),
                  labelText: 'Password',
                  placeholder: 'Enter password',
                  obscureText: true,
                  prefixIcon: Icon(
                    LiqIcons.lock,
                    size: 20,
                    color: context.appleColors.gray,
                  ),
                  suffixIcon: Icon(
                    LiqIcons.eye,
                    size: 20,
                    color: context.appleColors.gray,
                  ),
                ),
                const SizedBox(height: 16),
                LiqSearchField(
                  controller: _searchController,
                  onChanged: (value) {
                    // Handle search
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Cards Section
                _buildSectionTitle('Cards & Containers'),
                const SizedBox(height: 20),
                LiqCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  context.appleColors.blue,
                                  context.appleColors.purple,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              LiqIcons.layers,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Liquid Glass Card',
                                  style: context.textStyles.headline,
                                ),
                                Text(
                                  'With beautiful blur effect',
                                  style: context.textStyles.subheadline.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This card demonstrates the liquid glass effect with '
                        'real-time blur and translucency. Notice how it '
                        'beautifully blurs the background content.',
                        style: context.textStyles.body.secondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LiqCard(
                        padding: const EdgeInsets.all(20),
                        onTap: () => _showSnackBar('Card 1 tapped'),
                        child: Column(
                          children: [
                            Icon(
                              LiqIcons.heart,
                              size: 32,
                              color: context.appleColors.pink,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Favorites',
                              style: context.textStyles.headline,
                            ),
                            Text(
                              '23 items',
                              style: context.textStyles.caption1.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: LiqCard(
                        padding: const EdgeInsets.all(20),
                        onTap: () => _showSnackBar('Card 2 tapped'),
                        child: Column(
                          children: [
                            Icon(
                              LiqMaterialIcons.shoppingBag,
                              size: 32,
                              color: context.appleColors.orange,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Shopping',
                              style: context.textStyles.headline,
                            ),
                            Text(
                              '5 items',
                              style: context.textStyles.caption1.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Dialogs & Sheets Section
                _buildSectionTitle('Dialogs & Sheets'),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    LiqButton(
                      label: 'Show Alert',
                      leadingIcon: LiqIcons.warning,
                      onPressed: () => _showAlert(),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Action Sheet',
                      leadingIcon: LiqIcons.moreV,
                      onPressed: () => _showActionSheet(),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Text Input',
                      leadingIcon: LiqIcons.edit,
                      onPressed: () => _showTextInput(),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Bottom Sheet',
                      leadingIcon: LiqMaterialIcons.verticalAlignBottom,
                      onPressed: () => _showBottomSheet(),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Full Screen Sheet',
                      leadingIcon: LiqMaterialIcons.fullscreen,
                      onPressed: () => _showFullScreenSheet(),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Compact Sheet',
                      leadingIcon: LiqMaterialIcons.viewAgenda,
                      onPressed: () => _showCompactSheet(),
                      style: LiqButtonStyle.bordered,
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Activity Indicators Section
                _buildSectionTitle('Activity Indicators'),
                const SizedBox(height: 20),
                LiqCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const LiqSpinner(size: LiqSpinnerSize.small),
                              const SizedBox(height: 8),
                              Text(
                                'Small',
                                style: context.textStyles.caption1.secondary,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const LiqSpinner(),
                              const SizedBox(height: 8),
                              Text(
                                'Regular',
                                style: context.textStyles.caption1.secondary,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const LiqSpinner(),
                              const SizedBox(height: 8),
                              Text(
                                'Large',
                                style: context.textStyles.caption1.secondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const LiqActivityIndicatorView(
                        message: 'Loading content...',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Skeleton Loaders
                _buildSectionTitle('Skeleton Loaders'),
                const SizedBox(height: 20),
                Column(
                  children: List.generate(
                    3,
                    (i) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: LiqSkeleton(width: double.infinity, height: 64),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Switches & Toggles Section
                _buildSectionTitle('Switches & Toggles'),
                const SizedBox(height: 20),
                LiqCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Basic Switch',
                            style: context.textStyles.body,
                          ),
                          LiqToggle(
                            value: _switchValue1,
                            onChanged: (value) {
                              setState(() {
                                _switchValue1 = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Disabled Switch',
                            style: context.textStyles.body.secondary,
                          ),
                          const LiqToggle(
                            value: true,
                            onChanged: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Custom Colors',
                            style: context.textStyles.body,
                          ),
                          LiqToggle(
                            value: _switchValue2,
                            activeColor: context.appleColors.purple,
                            onChanged: (value) {
                              setState(() {
                                _switchValue2 = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'SETTINGS',
                    style: context.textStyles.caption1.copyWith(
                      color: context.appleColors.gray,
                      fontWeight: LiqAppleTypography.medium,
                    ),
                  ),
                ),
                LiqListSection(
                  children: [
                    LiqListRow(
                      title: 'Notifications',
                      subtitle: 'Receive push notifications',
                      leading: Icon(
                        LiqIcons.bell,
                        color: context.appleColors.orange,
                      ),
                      trailing: LiqToggle(
                        value: _notificationsEnabled,
                        onChanged: (v) =>
                            setState(() => _notificationsEnabled = v),
                      ),
                    ),
                    LiqListRow(
                      title: 'Dark Mode',
                      subtitle: 'Use dark theme',
                      leading: Icon(
                        LiqIcons.moon,
                        color: context.appleColors.indigo,
                      ),
                      trailing: LiqToggle(
                        value: _darkModeEnabled,
                        onChanged: (v) {
                          setState(() => _darkModeEnabled = v);
                          ref.read(liquidThemeProvider.notifier).toggleTheme();
                        },
                      ),
                    ),
                    LiqListRow(
                      title: 'Sound Effects',
                      subtitle: 'Play sounds in the app',
                      leading: Icon(
                        LiqMaterialIcons.volumeUp,
                        color: context.appleColors.green,
                      ),
                      trailing: LiqToggle(
                        value: _soundEnabled,
                        onChanged: (v) => setState(() => _soundEnabled = v),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Progress Indicators Section
                _buildSectionTitle('Progress Indicators'),
                const SizedBox(height: 20),
                LiqCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const LiqProgressBar(
                        value: 0.7,
                        showLabel: true,
                        label: 'Upload Progress',
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const LiqCircularProgress(
                            value: 0.65,
                            size: 80,
                          ),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                LiqCircularProgress(
                                  value: 0.85,
                                  size: 80,
                                  progressColor: context.appleColors.green,
                                  showPercentage: false,
                                ),
                                Icon(
                                  LiqIcons.check,
                                  color: context.appleColors.green,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                LiqProgressCard(
                  title: 'Downloading Files',
                  subtitle: '3 of 5 files completed',
                  progress: 0.6,
                  leading: Icon(
                    LiqMaterialIcons.cloudDownload,
                    color: context.appleColors.blue,
                    size: 32,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Segmented Controls Section
                _buildSectionTitle('Segmented Controls'),
                const SizedBox(height: 20),
                LiqSegmentedControl<int>(
                  value: _segmentedValue1,
                  segments: const [
                    (value: 0, label: 'All'),
                    (value: 1, label: 'Favorites'),
                    (value: 2, label: 'Recent'),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _segmentedValue1 = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                LiqTabSegmentedControl<String>(
                  value: _segmentedValue2,
                  segments: const [
                    LiqSegmentItem(
                        value: 'grid', label: 'Grid', icon: LiqIcons.grid),
                    LiqSegmentItem(
                        value: 'list', label: 'List', icon: LiqIcons.list),
                    LiqSegmentItem(
                        value: 'card',
                        label: 'Card',
                        icon: LiqMaterialIcons.creditCard),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _segmentedValue2 = value;
                    });
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Sliders Section
                _buildSectionTitle('Sliders'),
                const SizedBox(height: 20),
                LiqCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('Volume', style: context.textStyles.footnote),
                      ),
                      LiqSlider(
                        value: _sliderValue1,
                        onChanged: (value) =>
                            setState(() => _sliderValue1 = value),
                      ),
                      const SizedBox(height: 24),
                      LiqLabeledSlider(
                        label: 'Brightness',
                        value: _sliderValue2,
                        min: 0,
                        max: 100,
                        onChanged: (value) =>
                            setState(() => _sliderValue2 = value),
                        leading: Icon(
                          LiqMaterialIcons.brightness6,
                          color: context.appleColors.orange,
                        ),
                        valueFormatter: (value) => '${value.toInt()}%',
                      ),
                      const SizedBox(height: 24),
                      LiqRangeSlider(
                        values: _rangeValues,
                        min: 0,
                        max: 100,
                        onChanged: (values) =>
                            setState(() => _rangeValues = values),
                        startLabel: '${_rangeValues.start.toInt()}',
                        endLabel: '${_rangeValues.end.toInt()}',
                      ),
                      const SizedBox(height: 24),
                      LiqDiscreteSlider(
                        value: _discreteSliderValue,
                        onChanged: (value) =>
                            setState(() => _discreteSliderValue = value),
                        min: 1,
                        max: 5,
                        labels: const ['XS', 'S', 'M', 'L', 'XL'],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Lists Section
                _buildSectionTitle('Lists'),
                const SizedBox(height: 20),
                LiqListSection(
                  header: 'Basic List',
                  footer: 'This is a basic list with icons and subtitles',
                  children: [
                    LiqListRow(
                      leading: Icon(LiqIcons.user,
                          color: context.appleColors.blue),
                      title: 'Profile',
                      subtitle: 'View and edit your profile',
                      showChevron: true,
                      onTap: () => _showSnackBar('Profile tapped'),
                    ),
                    LiqListRow(
                      leading: Icon(LiqIcons.settings,
                          color: context.appleColors.gray),
                      title: 'Settings',
                      subtitle: 'App preferences and configuration',
                      showChevron: true,
                      onTap: () => _showSnackBar('Settings tapped'),
                    ),
                    LiqListRow(
                      leading: Icon(LiqIcons.help,
                          color: context.appleColors.green),
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      showChevron: true,
                      onTap: () => _showSnackBar('Help tapped'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'SELECTABLE LIST',
                    style: context.textStyles.caption1.copyWith(
                      color: context.appleColors.gray,
                      fontWeight: LiqAppleTypography.medium,
                    ),
                  ),
                ),
                LiqCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: List.generate(5, (index) {
                      return LiqSelectableListRow(
                        leading: Icon(
                          LiqIcons.folder,
                          color: context.appleColors.blue,
                        ),
                        title: 'Item ${index + 1}',
                        subtitle: 'Tap to select this item',
                        selected: _selectedItems[index],
                        onChanged: (v) =>
                            setState(() => _selectedItems[index] = v),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                LiqExpandableListRow(
                  leading: Icon(LiqMaterialIcons.folderOpen,
                      color: context.appleColors.orange),
                  title: 'Expandable Section',
                  subtitle: 'Tap to expand',
                  children: [
                    LiqListRow(
                      title: 'Child Item 1',
                      showChevron: true,
                      onTap: () => _showSnackBar('Child 1 tapped'),
                    ),
                    LiqListRow(
                      title: 'Child Item 2',
                      showChevron: true,
                      onTap: () => _showSnackBar('Child 2 tapped'),
                    ),
                    LiqListRow(
                      title: 'Child Item 3',
                      showChevron: true,
                      onTap: () => _showSnackBar('Child 3 tapped'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Notifications Section
                _buildSectionTitle('Notifications'),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    LiqButton(
                      label: 'Info Banner',
                      leadingIcon: LiqIcons.info,
                      onPressed: () => _showBanner(
                        title: 'Information',
                        body: 'This is an informational notification',
                        style: LiqBannerStyle.info,
                      ),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Success Toast',
                      leadingIcon: LiqIcons.success,
                      onPressed: () => LiqToastOverlay.show(
                        context,
                        'Action completed successfully!',
                        variant: LiqToastVariant.success,
                      ),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Warning',
                      leadingIcon: LiqIcons.warning,
                      onPressed: () => _showBanner(
                        title: 'Warning',
                        body: 'Please check your settings',
                        style: LiqBannerStyle.warning,
                      ),
                      style: LiqButtonStyle.bordered,
                    ),
                    LiqButton(
                      label: 'Error',
                      leadingIcon: LiqIcons.error,
                      onPressed: () => _showBanner(
                        title: 'Error',
                        body: 'Something went wrong. Please try again.',
                        style: LiqBannerStyle.error,
                      ),
                      style: LiqButtonStyle.bordered,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LiqDismissible(
                  key: const ValueKey('notif-card'),
                  direction: LiqDismissDirection.horizontal,
                  onDismissed: (_) => _showSnackBar('Notification dismissed'),
                  background: Container(color: context.appleColors.red),
                  child: LiqCard(
                    onTap: () => _showSnackBar('Notification tapped'),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: context.appleColors.blue,
                            child: const Icon(
                              LiqIcons.user,
                              color: Color(0xFFFFFFFF),
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('New Message',
                                  style: context.textStyles.headline.copyWith(
                                      fontWeight: LiqAppleTypography.semibold)),
                              const SizedBox(height: 2),
                              Text('John Doe',
                                  style:
                                      context.textStyles.subheadline.secondary),
                              const SizedBox(height: 4),
                              Text(
                                'Hey! How are you doing? I wanted to discuss the new project with you.',
                                style: context.textStyles.body.secondary,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  LiqButton(
                                    label: 'Reply',
                                    size: LiqButtonSize.small,
                                    style: LiqButtonStyle.borderedProminent,
                                    onPressed: () => _showSnackBar('Reply tapped'),
                                  ),
                                  const SizedBox(width: 8),
                                  LiqButton(
                                    label: 'Dismiss',
                                    size: LiqButtonSize.small,
                                    style: LiqButtonStyle.bordered,
                                    onPressed: () =>
                                        _showSnackBar('Dismiss tapped'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        LiqIconButton(
                          icon: LiqIcons.bell,
                          size: 48,
                          iconSize: 32,
                          style: LiqIconButtonStyle.borderless,
                          onPressed: () => _showSnackBar('Notifications opened'),
                        ),
                        const Positioned(
                          top: 0,
                          right: 0,
                          child: LiqBadge(count: 5),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Stack(
                      children: [
                        LiqIconButton(
                          icon: LiqIcons.mail,
                          size: 48,
                          iconSize: 32,
                          style: LiqIconButtonStyle.borderless,
                          onPressed: () => _showSnackBar('Mail opened'),
                        ),
                        const Positioned(
                          top: 0,
                          right: 0,
                          child: LiqBadge(count: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Page Controls Section
                _buildSectionTitle('Page Controls'),
                const SizedBox(height: 20),
                LiqCard(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 200,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (page) =>
                          setState(() => _currentPage = page),
                      children: [
                        for (final c in <Color>[
                          context.appleColors.blue,
                          context.appleColors.purple,
                          context.appleColors.pink,
                          context.appleColors.orange,
                          context.appleColors.green,
                        ])
                          Container(
                            color: c.withValues(alpha: 0.3),
                            child: Center(
                              child: Text(
                                'Page ${_pageController.initialPage + 1}',
                                style: context.textStyles.largeTitle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      'Different Page Indicators',
                      style: context.textStyles.headline,
                    ),
                    const SizedBox(height: 20),
                    // Basic page control
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Basic: ', style: context.textStyles.body),
                        const SizedBox(width: 16),
                        LiqPageControl(
                          count: 5,
                          activeIndex: _currentPage,
                          onPageChanged: (page) {
                            _pageController.animateToPage(
                              page,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Progress: ', style: context.textStyles.body),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 150,
                          height: 4,
                          child: LiqProgressBar(
                            value: ((_currentPage + 0.5) / 5).clamp(0.0, 1.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Numbered indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Numbered: ', style: context.textStyles.body),
                        const SizedBox(width: 16),
                        Text(
                          '${_currentPage + 1} / 5',
                          style: context.textStyles.body.copyWith(
                            color: context.appleColors.blue,
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Custom indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Custom: ', style: context.textStyles.body),
                        const SizedBox(width: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            final isActive = index == _currentPage;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: isActive ? 24 : 16,
                                height: isActive ? 24 : 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? context.appleColors.blue
                                      : context.appleColors.gray,
                                  border: Border.all(
                                    color: const Color(0xFFFFFFFF),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: const Color(0xFFFFFFFF),
                                      fontSize: isActive ? 12 : 10,
                                      fontWeight: isActive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Scrolling indicator for many pages
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Scrolling: ', style: context.textStyles.body),
                        const SizedBox(width: 16),
                        LiqPageControl(
                          count: 10,
                          activeIndex: _currentPage % 10,
                          maxVisible: 5,
                          onPageChanged: (page) {
                            _showSnackBar('Page $page selected');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Pickers Section
                _buildSectionTitle('Pickers'),
                const SizedBox(height: 20),
                LiqDatePickerField(
                  value: _selectedDate,
                  onChanged: (date) =>
                      setState(() => _selectedDate = date),
                  placeholder: 'Select date',
                ),
                const SizedBox(height: 16),
                LiqDatePickerField(
                  value: _selectedDateTime,
                  onChanged: (date) =>
                      setState(() => _selectedDateTime = date),
                  placeholder: 'Select date and time',
                ),
                const SizedBox(height: 16),
                LiqCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Timer Duration',
                        style: context.textStyles.headline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Selected: ${_selectedDuration.inHours}h ${_selectedDuration.inMinutes % 60}m',
                        style: context.textStyles.body,
                      ),
                      const SizedBox(height: 16),
                      LiqTimerPicker(
                        initialDuration: _selectedDuration,
                        onDurationChanged: (duration) =>
                            setState(() => _selectedDuration = duration),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                LiqPickerButton<String>(
                  label: 'Country',
                  items: const [
                    LiqPickerItem(value: 'US', label: 'United States'),
                    LiqPickerItem(value: 'CA', label: 'Canada'),
                    LiqPickerItem(value: 'UK', label: 'United Kingdom'),
                    LiqPickerItem(value: 'DE', label: 'Germany'),
                    LiqPickerItem(value: 'FR', label: 'France'),
                    LiqPickerItem(value: 'JP', label: 'Japan'),
                    LiqPickerItem(value: 'CN', label: 'China'),
                    LiqPickerItem(value: 'AU', label: 'Australia'),
                  ],
                  selectedValue: _selectedCountry,
                  onValueSelected: (value) {
                    if (value != null) {
                      setState(() => _selectedCountry = value);
                    }
                  },
                  placeholder: 'Select country',
                ),
                const SizedBox(height: 16),
                LiqCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number Picker',
                        style: context.textStyles.headline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Selected: $_selectedNumber',
                        style: context.textStyles.body,
                      ),
                      const SizedBox(height: 16),
                      LiqNumberPicker(
                        minValue: 1,
                        maxValue: 10,
                        selectedValue: _selectedNumber,
                        onValueChanged: (value) =>
                            setState(() => _selectedNumber = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                LiqCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight Picker',
                        style: context.textStyles.headline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Selected: ${_selectedWeight.toStringAsFixed(1)} kg',
                        style: context.textStyles.body,
                      ),
                      const SizedBox(height: 16),
                      LiqMeasurementPicker(
                        value: _selectedWeight,
                        onValueChanged: (value) =>
                            setState(() => _selectedWeight = value),
                        minValue: 40,
                        maxValue: 150,
                        unit: 'kg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                LiqCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Multi-Column Picker',
                        style: context.textStyles.headline,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Selected: ${_multiColumnSelection[0] + 1} hours, ${_multiColumnSelection[1] * 5} minutes',
                        style: context.textStyles.body,
                      ),
                      const SizedBox(height: 16),
                      LiqMultiColumnPicker(
                        columns: [
                          List.generate(
                            12,
                            (i) => LiqPickerItem<dynamic>(
                              value: i,
                              label: '${i + 1} hr',
                            ),
                          ),
                          List.generate(
                            12,
                            (i) => LiqPickerItem<dynamic>(
                              value: i,
                              label: '${i * 5} min',
                            ),
                          ),
                        ],
                        selectedIndices: _multiColumnSelection,
                        onSelectionChanged: (indices) =>
                            setState(() => _multiColumnSelection = indices),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                LiqDateRangePicker(
                  onRangeChanged: (start, end) {
                    if (start != null && end != null) {
                      _showSnackBar(
                          'Selected range: ${DateFormat('MMM d, y').format(start)} - ${DateFormat('MMM d, y').format(end)}');
                    }
                  },
                  startLabel: 'Check-in',
                  endLabel: 'Check-out',
                ),
                
                const SizedBox(height: 40),
                
                // App Icons Section
                _buildSectionTitle('App Icons'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit Mode', style: context.textStyles.body),
                    LiqToggle(
                      value: _isEditingIcons,
                      onChanged: (v) =>
                          setState(() => _isEditingIcons = v),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LiqAppIconGrid(
                  isEditing: _isEditingIcons,
                  icons: [
                    LiqHomeAppIcon(
                      icon: LiqIcons.phone,
                      label: 'Phone',
                      backgroundColor: context.appleColors.green,
                      onTap: () => _showSnackBar('Phone app tapped'),
                      showDeleteButton: _isEditingIcons,
                      isJiggling: _isEditingIcons,
                      onDelete: () => _showSnackBar('Delete Phone'),
                    ),
                    LiqHomeAppIcon(
                      icon: LiqIcons.message,
                      label: 'Messages',
                      backgroundColor: context.appleColors.green,
                      showBadge: true,
                      badgeCount: 5,
                      onTap: () => _showSnackBar('Messages app tapped'),
                      showDeleteButton: _isEditingIcons,
                      isJiggling: _isEditingIcons,
                      onDelete: () => _showSnackBar('Delete Messages'),
                    ),
                    LiqHomeAppIcon(
                      icon: LiqIcons.mail,
                      label: 'Mail',
                      backgroundColor: context.appleColors.blue,
                      showBadge: true,
                      badgeCount: 125,
                      onTap: () => _showSnackBar('Mail app tapped'),
                      showDeleteButton: _isEditingIcons,
                      isJiggling: _isEditingIcons,
                      onDelete: () => _showSnackBar('Delete Mail'),
                    ),
                    LiqHomeAppIcon(
                      icon: LiqMaterialIcons.cameraAlt,
                      label: 'Camera',
                      backgroundColor: context.appleColors.gray,
                      onTap: () => _showSnackBar('Camera app tapped'),
                      showDeleteButton: _isEditingIcons,
                      isJiggling: _isEditingIcons,
                      onDelete: () => _showSnackBar('Delete Camera'),
                    ),
                    LiqHomeAppIcon(
                      icon: LiqMaterialIcons.photo,
                      label: 'Photos',
                      backgroundColor: LiqColors.pink,
                      onTap: () => _showSnackBar('Photos app tapped'),
                      showDeleteButton: _isEditingIcons,
                      isJiggling: _isEditingIcons,
                      onDelete: () => _showSnackBar('Delete Photos'),
                    ),
                    LiqHomeAppIcon(
                      icon: LiqMaterialIcons.musicNote,
                      label: 'Music',
                      backgroundColor: context.appleColors.pink,
                      onTap: () => _showSnackBar('Music app tapped'),
                      showDeleteButton: _isEditingIcons,
                      isJiggling: _isEditingIcons,
                      onDelete: () => _showSnackBar('Delete Music'),
                    ),
                    LiqHomeAppIcon(
                      icon: LiqIcons.settings,
                      label: 'Settings',
                      backgroundColor: context.appleColors.gray,
                      showBadge: true,
                      badgeCount: 1,
                      onTap: () => _showSnackBar('Settings app tapped'),
                      showDeleteButton: _isEditingIcons,
                      isJiggling: _isEditingIcons,
                      onDelete: () => _showSnackBar('Delete Settings'),
                    ),
                    LiqHomeAppIcon(
                      icon: LiqMaterialIcons.cloud,
                      label: 'Weather',
                      backgroundColor: context.appleColors.blue,
                      isDownloading: true,
                      downloadProgress: _downloadProgress,
                      onTap: () => _showSnackBar('Weather app tapped'),
                      showDeleteButton: _isEditingIcons,
                      isJiggling: _isEditingIcons,
                      onDelete: () => _showSnackBar('Delete Weather'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LiqButton(
                  label: 'Simulate Download',
                  leadingIcon: LiqIcons.download,
                  onPressed: () {
                    setState(() {
                      _downloadProgress = 0.0;
                    });
                    // Simulate download progress
                    Future.doWhile(() async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (mounted) {
                        setState(() {
                          _downloadProgress += 0.1;
                        });
                      }
                      return _downloadProgress < 1.0 && mounted;
                    });
                  },
                  style: LiqButtonStyle.bordered,
                ),
                const SizedBox(height: 40),
                _buildSectionTitle('Folders'),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    LiqFolderIcon(
                      label: 'Utilities',
                      previewIcons: const [
                        LiqMaterialIcons.calculate,
                        LiqMaterialIcons.alarm,
                        LiqMaterialIcons.stickyNote2,
                        LiqMaterialIcons.qrCodeScanner,
                      ],
                      onTap: () => _showSnackBar('Utilities folder tapped'),
                    ),
                    LiqFolderIcon(
                      label: 'Social',
                      previewIcons: const [
                        LiqMaterialIcons.facebook,
                        LiqMaterialIcons.chat,
                        LiqMaterialIcons.people,
                        LiqIcons.share,
                      ],
                      backgroundColor: context.appleColors.blue,
                      onTap: () => _showSnackBar('Social folder tapped'),
                      isOpen: true,
                    ),
                    LiqFolderIcon(
                      label: 'Productivity',
                      previewIcons: const [
                        LiqMaterialIcons.note,
                        LiqMaterialIcons.task,
                        LiqIcons.calendar,
                        LiqIcons.folder,
                      ],
                      backgroundColor: context.appleColors.orange,
                      onTap: () => _showSnackBar('Productivity folder tapped'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _buildSectionTitle('App Dock'),
                const SizedBox(height: 20),
                Center(
                  child: LiqAppIconDock(
                    icons: [
                      LiqHomeAppIcon(
                        icon: LiqIcons.phone,
                        backgroundColor: context.appleColors.green,
                        onTap: () => _showSnackBar('Phone tapped'),
                      ),
                      LiqHomeAppIcon(
                        icon: LiqMaterialIcons.public,
                        backgroundColor: context.appleColors.blue,
                        onTap: () => _showSnackBar('Safari tapped'),
                      ),
                      LiqHomeAppIcon(
                        icon: LiqIcons.message,
                        backgroundColor: context.appleColors.green,
                        showBadge: true,
                        badgeCount: 3,
                        onTap: () => _showSnackBar('Messages tapped'),
                      ),
                      LiqHomeAppIcon(
                        icon: LiqMaterialIcons.musicNote,
                        backgroundColor: context.appleColors.pink,
                        onTap: () => _showSnackBar('Music tapped'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Color Picker Section
                _buildSectionTitle('Color Picker'),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LiqColorPickerButton(
                            color: _selectedColor,
                            onPressed: () async {
                              final color = await LiqColorPickerModal.show(
                                context: context,
                                initialColor: _selectedColor,
                                title: 'Choose Color',
                                presetColors: [
                                  context.appleColors.red,
                                  context.appleColors.orange,
                                  context.appleColors.yellow,
                                  context.appleColors.green,
                                  context.appleColors.teal,
                                  context.appleColors.blue,
                                  context.appleColors.indigo,
                                  context.appleColors.purple,
                                  context.appleColors.pink,
                                  context.appleColors.gray,
                                  LiqColors.black,
                                  LiqColors.white,
                                ],
                              );
                              if (color != null) {
                                setState(() {
                                  _selectedColor = color;
                                  if (!_recentColors.contains(color)) {
                                    _recentColors.insert(0, color);
                                    if (_recentColors.length > 8) {
                                      _recentColors.removeLast();
                                    }
                                  }
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 4),
                          Text('Selected Color',
                              style: context.textStyles.caption2),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_recentColors.isNotEmpty) ...[
                        Text(
                          'Recent Colors',
                          style: context.textStyles.footnote,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: _recentColors.map((color) {
                            return LiqColorPickerButton(
                              color: color,
                              size: LiqColorPickerButtonSize.small,
                              onPressed: () =>
                                  setState(() => _selectedColor = color),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                LiqCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Inline Color Picker',
                        style: context.textStyles.headline,
                      ),
                      const SizedBox(height: 20),
                      LiqColorPickerPanel(
                        color: _selectedColor,
                        onChanged: (color) =>
                            setState(() => _selectedColor = color),
                        savedColors: const [
                          LiqColors.red,
                          LiqColors.orange,
                          LiqColors.yellow,
                          LiqColors.green,
                          LiqColors.blue,
                          LiqColors.indigo,
                          LiqColors.purple,
                          LiqColors.pink,
                          LiqColors.teal,
                          LiqColors.cyan,
                          LiqColors.grey,
                          LiqColors.brown,
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Context Menu Section
                _buildSectionTitle('Context Menu'),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      LiqContextMenuArea(
                        items: [
                          LiqMenuItem(
                            label: 'Copy',
                            icon: const Icon(LiqIcons.copy, size: 20),
                            onPressed: () => _showSnackBar('Copy selected'),
                          ),
                          LiqMenuItem(
                            label: 'Share',
                            icon: const Icon(LiqIcons.share, size: 20),
                            onPressed: () => _showSnackBar('Share selected'),
                          ),
                          LiqMenuItem(
                            label: 'Edit',
                            icon: const Icon(LiqIcons.edit, size: 20),
                            onPressed: () => _showSnackBar('Edit selected'),
                          ),
                          LiqMenuItem(
                            label: 'Delete',
                            icon: const Icon(LiqIcons.trash, size: 20),
                            style: LiqMenuItemStyle.destructive,
                            onPressed: () => _showSnackBar('Delete selected'),
                          ),
                        ],
                        child: LiqCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                LiqIcons.image,
                                size: 64,
                                color: context.appleColors.blue,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Long Press Me',
                                style: context.textStyles.headline,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Long press to show context menu',
                                style: context.textStyles.footnote.secondary,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiqContextMenuArea(
                            items: [
                              LiqMenuItem(
                                label: 'Small',
                                onPressed: () => _showSnackBar('Small selected'),
                              ),
                              LiqMenuItem(
                                label: 'Medium',
                                onPressed: () =>
                                    _showSnackBar('Medium selected'),
                              ),
                              LiqMenuItem(
                                label: 'Large',
                                onPressed: () => _showSnackBar('Large selected'),
                              ),
                            ],
                            child: LiqButton(
                              label: 'Size Options',
                              leadingIcon: LiqMaterialIcons.formatSize,
                              onPressed: () {},
                              style: LiqButtonStyle.bordered,
                            ),
                          ),
                          const SizedBox(width: 16),
                          LiqContextMenuArea(
                            items: [
                              LiqMenuItem(
                                label: 'Download',
                                icon: const Icon(LiqIcons.download, size: 20),
                                onPressed: () =>
                                    _showSnackBar('Download started'),
                              ),
                              LiqMenuItem(
                                label: 'Save to Files',
                                icon: const Icon(LiqIcons.folder, size: 20),
                                onPressed: () => _showSnackBar('Saved to Files'),
                              ),
                              const LiqMenuItem(
                                label: 'Print',
                              ),
                            ],
                            child: LiqButton(
                              label: 'Export',
                              leadingIcon: LiqMaterialIcons.fileDownload,
                              onPressed: () {},
                              style: LiqButtonStyle.bordered,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Builder(builder: (innerCtx) {
                        return LiqButton(
                          label: 'Show Popup Menu',
                          leadingIcon: LiqIcons.menu,
                          onPressed: () {
                            final RenderBox button =
                                innerCtx.findRenderObject() as RenderBox;
                            final position = button.localToGlobal(Offset(
                                button.size.width / 2, button.size.height));
                            LiqMenu.showPopup<void>(
                              context: innerCtx,
                              position: position,
                              children: [
                                LiqMenuItem(
                                  label: 'New File',
                                  icon: const Icon(LiqMaterialIcons.addBox,
                                      size: 20),
                                  onPressed: () =>
                                      _showSnackBar('New file created'),
                                ),
                                LiqMenuItem(
                                  label: 'Open Recent',
                                  icon: const Icon(LiqMaterialIcons.history,
                                      size: 20),
                                  onPressed: () =>
                                      _showSnackBar('Recent files opened'),
                                ),
                                LiqMenuItem(
                                  label: 'Settings',
                                  icon: const Icon(LiqIcons.settings, size: 20),
                                  onPressed: () =>
                                      _showSnackBar('Settings opened'),
                                ),
                              ],
                            );
                          },
                          style: LiqButtonStyle.borderedProminent,
                        );
                      }),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Popover Section
                _buildSectionTitle('Popovers'),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      // Basic Popover
                      LiqPopoverArea(
                        side: LiqPopoverSide.bottom,
                        width: 280,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LiqIcons.info,
                              size: 48,
                              color: context.appleColors.blue,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Popover Content',
                              style: context.textStyles.headline,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This is a popover with liquid glass effects that can display any content.',
                              style: context.textStyles.body,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        child: LiqButton(
                          label: 'Tap for Popover',
                          leadingIcon: LiqMaterialIcons.arrowDropUp,
                          onPressed: () {},
                          style: LiqButtonStyle.bordered,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiqPopoverArea(
                            side: LiqPopoverSide.top,
                            content: Text('Top Popover',
                                style: context.textStyles.body),
                            child: LiqButton(
                              label: 'Top',
                              onPressed: () {},
                              size: LiqButtonSize.small,
                              style: LiqButtonStyle.bordered,
                            ),
                          ),
                          const SizedBox(width: 16),
                          LiqPopoverArea(
                            side: LiqPopoverSide.bottom,
                            content: Text('Bottom Popover',
                                style: context.textStyles.body),
                            child: LiqButton(
                              label: 'Bottom',
                              onPressed: () {},
                              size: LiqButtonSize.small,
                              style: LiqButtonStyle.bordered,
                            ),
                          ),
                          const SizedBox(width: 16),
                          LiqPopoverArea(
                            side: LiqPopoverSide.leading,
                            content: Text('Leading Popover',
                                style: context.textStyles.body),
                            child: LiqButton(
                              label: 'Left',
                              onPressed: () {},
                              size: LiqButtonSize.small,
                              style: LiqButtonStyle.bordered,
                            ),
                          ),
                          const SizedBox(width: 16),
                          LiqPopoverArea(
                            side: LiqPopoverSide.trailing,
                            content: Text('Trailing Popover',
                                style: context.textStyles.body),
                            child: LiqButton(
                              label: 'Right',
                              onPressed: () {},
                              size: LiqButtonSize.small,
                              style: LiqButtonStyle.bordered,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Tooltips
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiqTooltip(
                            message:
                                'This is a tooltip with liquid glass effects',
                            child: LiqIconButton(
                              icon: LiqIcons.help,
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          LiqTooltip(
                            message: 'Save your work',
                            child: LiqIconButton(
                              icon: LiqMaterialIcons.save,
                              onPressed: () => _showSnackBar('Saved!'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          LiqTooltip(
                            message: 'Delete this item',
                            child: LiqIconButton(
                              icon: LiqIcons.trash,
                              color: context.appleColors.red,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      LiqPopoverArea(
                        width: 280,
                        padding: EdgeInsets.zero,
                        side: LiqPopoverSide.bottom,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.appleColors.blue
                                    .withValues(alpha: 0.1),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('User Profile',
                                      style: context.textStyles.headline
                                          .copyWith(
                                              fontWeight:
                                                  LiqAppleTypography.semibold)),
                                  const SizedBox(height: 4),
                                  Text('john.doe@example.com',
                                      style: context.textStyles.footnote
                                          .secondary),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(LiqIcons.user,
                                          size: 20,
                                          color: context.appleColors.label),
                                      const SizedBox(width: 12),
                                      Text('View Profile',
                                          style: context.textStyles.body),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(LiqIcons.settings,
                                          size: 20,
                                          color: context.appleColors.label),
                                      const SizedBox(width: 12),
                                      Text('Settings',
                                          style: context.textStyles.body),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: context.appleColors.separator,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(LiqMaterialIcons.logout,
                                          size: 20,
                                          color: context.appleColors.red),
                                      const SizedBox(width: 12),
                                      Text('Sign Out',
                                          style: context.textStyles.body
                                              .copyWith(
                                                  color: context.appleColors.red)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        child: LiqButton(
                          label: 'User Menu',
                          leadingIcon: LiqMaterialIcons.accountCircle,
                          onPressed: () {},
                          style: LiqButtonStyle.borderedProminent,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Empty States Section
                _buildSectionTitle('Empty States'),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
                        child: LiqEmptyState(
                          icon: Icon(LiqMaterialIcons.inboxOutlined,
                              size: 48,
                              color: context.appleColors.gray),
                          iconBackground: true,
                          title: 'No Data',
                          description: 'Start adding items to see them here',
                          cta: LiqEmptyStateCta(
                            label: 'Add Items',
                            onPressed: () => _showSnackBar('Add items clicked'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 300,
                              height: 350,
                              child: LiqCard(
                                padding: const EdgeInsets.all(16),
                                child: LiqEmptyState(
                                  icon: Icon(LiqIcons.error,
                                      size: 48,
                                      color: context.appleColors.red),
                                  iconBackground: true,
                                  title: 'Something Went Wrong',
                                  description:
                                      'An error occurred. Please try again.',
                                  cta: LiqEmptyStateCta(
                                    label: 'Retry',
                                    onPressed: () =>
                                        _showSnackBar('Retry clicked'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 300,
                              height: 350,
                              child: LiqCard(
                                padding: const EdgeInsets.all(16),
                                child: LiqEmptyState(
                                  icon: Icon(LiqMaterialIcons.wifiOff,
                                      size: 48,
                                      color: context.appleColors.orange),
                                  iconBackground: true,
                                  title: 'No Connection',
                                  description:
                                      'Check your internet connection and try again.',
                                  cta: LiqEmptyStateCta(
                                    label: 'Try Again',
                                    onPressed: () =>
                                        _showSnackBar('Try again clicked'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 300,
                              height: 350,
                              child: LiqCard(
                                padding: const EdgeInsets.all(16),
                                child: LiqEmptyState(
                                  icon: Icon(LiqMaterialIcons.searchOff,
                                      size: 48,
                                      color: context.appleColors.blue),
                                  iconBackground: true,
                                  title: 'No Results Found',
                                  description: 'No results match your search',
                                  cta: LiqEmptyStateCta(
                                    label: 'Clear Search',
                                    onPressed: () =>
                                        _showSnackBar('Clear search clicked'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: LiqCompactEmptyState(
                              icon: LiqMaterialIcons.folderOpen,
                              text: 'No files yet',
                              onTap: () => _showSnackBar('Upload files'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: LiqCompactEmptyState(
                              icon: LiqMaterialIcons.notificationsNone,
                              text: 'No notifications',
                              onTap: () => _showSnackBar('Check later'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      LiqIllustratedEmptyState(
                        illustration: Icon(
                          LiqMaterialIcons.shoppingCartOutlined,
                          size: 120,
                          color: context.appleColors.blue,
                        ),
                        title: 'Your Cart is Empty',
                        subtitle:
                            'Add items to your cart to see them here',
                        actions: [
                          LiqButton(
                            label: 'Start Shopping',
                            onPressed: () =>
                                _showSnackBar('Start shopping clicked'),
                            style: LiqButtonStyle.borderedProminent,
                          ),
                          const SizedBox(height: 12),
                          LiqButton(
                            label: 'Browse Categories',
                            onPressed: () =>
                                _showSnackBar('Browse categories clicked'),
                            style: LiqButtonStyle.bordered,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(
                        height: 200,
                        child: LiqLoadingState(
                          message: 'Loading your content...',
                        ),
                      ),
                      const SizedBox(height: 24),
                      LiqEmptyState(
                        icon: Icon(LiqMaterialIcons.celebration,
                            size: 48, color: context.appleColors.blue),
                        iconBackground: true,
                        title: 'All Caught Up!',
                        description:
                            "You've seen all the new content. Check back later for more.",
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Persistent Sheet Example: rendered inline as a fixed
                // glass strip via LiqGlassSurface; the legacy "drag to
                // expand" behavior is dropped because LiqSheet handles
                // expanding sheets at the route layer (LiqSheet.show).
                _buildSectionTitle('Persistent Sheet'),
                const SizedBox(height: 20),
                LiqGlassSurface(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(28)),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: LiqSheetGrabber()),
                      const SizedBox(height: 16),
                      Text(
                        'Swipe up to expand',
                        style: context.textStyles.headline.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This is a persistent bottom sheet that can be dragged up and down. '
                        "It's perfect for showing additional content or controls.",
                        style: context.textStyles.body,
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: LiqCard(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  LiqIcons.folder,
                                  color: context.appleColors.blue,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Document ${index + 1}',
                                        style: context.textStyles.body
                                            .copyWith(
                                                fontWeight:
                                                    LiqAppleTypography
                                                        .semibold),
                                      ),
                                      Text(
                                        'Last modified 2 hours ago',
                                        style: context
                                            .textStyles.caption1.secondary,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  LiqIcons.forward,
                                  color: context.appleColors.tertiaryLabel,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Steppers Section
                _buildSectionTitle('Steppers'),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      // Horizontal Progress Stepper (4 steps)
                      LiqProgressStepper(
                        currentStep: _currentStep,
                        onStepTapped: (s) => setState(() => _currentStep = s),
                        steps: const [
                          LiqStep(title: 'Account'),
                          LiqStep(title: 'Details'),
                          LiqStep(title: 'Preferences'),
                          LiqStep(title: 'Complete'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiqButton(
                            label: 'Previous',
                            onPressed: _currentStep > 0
                                ? () => setState(() => _currentStep--)
                                : null,
                            style: LiqButtonStyle.bordered,
                            size: LiqButtonSize.small,
                          ),
                          const SizedBox(width: 16),
                          LiqButton(
                            label: 'Next',
                            onPressed: _currentStep < 3
                                ? () => setState(() => _currentStep++)
                                : null,
                            style: LiqButtonStyle.borderedProminent,
                            size: LiqButtonSize.small,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Numeric Stepper',
                        style: context.textStyles.headline.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LiqNumericStepper(
                        value: _numericStepperValue,
                        min: 0,
                        max: 10,
                        onChanged: (value) =>
                            setState(() => _numericStepperValue = value),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Value: $_numericStepperValue',
                        style: context.textStyles.body.secondary,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Onboarding Progress',
                        style: context.textStyles.headline.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LiqOnboardingStepper(
                        stepCount: 5,
                        currentStep: _onboardingStep,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiqButton(
                            label: 'Previous',
                            onPressed: _onboardingStep > 0
                                ? () => setState(() => _onboardingStep--)
                                : null,
                            style: LiqButtonStyle.bordered,
                            size: LiqButtonSize.small,
                          ),
                          const SizedBox(width: 16),
                          LiqButton(
                            label: 'Next',
                            onPressed: _onboardingStep < 4
                                ? () => setState(() => _onboardingStep++)
                                : null,
                            style: LiqButtonStyle.borderedProminent,
                            size: LiqButtonSize.small,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Interactive Demo
                _buildSectionTitle('Interactive Demo'),
                const SizedBox(height: 20),
                LiqCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Scroll the page to see the blur effect',
                        style: context.textStyles.headline,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Icon(
                        LiqMaterialIcons.swipeVertical,
                        size: 48,
                        color: context.appleColors.blue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'The liquid glass components blur whatever content '
                        'is behind them, creating a beautiful depth effect '
                        'that changes as you scroll.',
                        style: context.textStyles.body.secondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 100),
                
                // Color gradients for background
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        context.appleColors.orange,
                        context.appleColors.yellow,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.appleColors.green,
                        context.appleColors.teal,
                        context.appleColors.cyan,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
      ),
      bottomNavigationBar: LiqBottomNavBar(
        currentIndex: _selectedNavIndex,
        onChanged: _handleNavTap,
        items: const [
          LiqBottomNavItem(icon: LiqIcons.home, label: 'Home'),
          LiqBottomNavItem(icon: LiqIcons.widgets, label: 'Components'),
          LiqBottomNavItem(icon: LiqIcons.palette, label: 'Themes'),
          LiqBottomNavItem(icon: LiqIcons.settings, label: 'Settings'),
        ],
      ),
      floatingActionButton: LiqFloatingActionButton(
        onPressed: () => _showSnackBar('FAB pressed'),
        child: Icon(LiqIcons.plus, color: context.appleColors.label),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: context.textStyles.title2.bold,
    );
  }

  void _showBottomSheet() {
    LiqSheet.show<void>(
      context: context,
      title: 'Bottom Sheet',
      variant: LiqSheetVariant.inspector,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This is a sheet with liquid glass effects.',
              style: context.textStyles.body,
            ),
            const SizedBox(height: 24),
            LiqButton(
              label: 'Close Sheet',
              onPressed: () => Navigator.of(context).pop(),
              style: LiqButtonStyle.borderedProminent,
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenSheet() {
    LiqSheet.show<void>(
      context: context,
      title: 'Full Screen Sheet',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This is a full screen sheet that slides up from the bottom.',
              style: context.textStyles.body,
            ),
            const SizedBox(height: 24),
            LiqButton(
              label: 'Action 1',
              onPressed: () => _showSnackBar('Action 1 pressed'),
              style: LiqButtonStyle.bordered,
            ),
            const SizedBox(height: 12),
            LiqButton(
              label: 'Action 2',
              onPressed: () => _showSnackBar('Action 2 pressed'),
              style: LiqButtonStyle.bordered,
            ),
          ],
        ),
      ),
    );
  }

  void _showCompactSheet() {
    LiqActionSheet.show<void>(
      context: context,
      title: 'Quick Actions',
      actions: [
        LiqAlertAction(
          label: 'Copy',
          icon: LiqIcons.copy,
          onPressed: () {
            Navigator.of(context).pop();
            _showSnackBar('Copy selected');
          },
        ),
        LiqAlertAction(
          label: 'Share',
          icon: LiqIcons.share,
          onPressed: () {
            Navigator.of(context).pop();
            _showSnackBar('Share selected');
          },
        ),
        LiqAlertAction(
          label: 'Edit',
          icon: LiqIcons.edit,
          onPressed: () {
            Navigator.of(context).pop();
            _showSnackBar('Edit selected');
          },
        ),
        LiqAlertAction(
          label: 'Delete',
          icon: LiqIcons.trash,
          style: LiqAlertActionStyle.destructive,
          onPressed: () {
            Navigator.of(context).pop();
            _showSnackBar('Delete selected');
          },
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    LiqToastOverlay.show(context, message);
  }

  void _handleNavTap(int index) {
    setState(() => _selectedNavIndex = index);
    switch (index) {
      case 0:
        // Home — already on the showcase, scroll to top.
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        }
      case 1:
        Navigator.of(context).push(
          LiqPageRoute<void>(
            builder: (_) => const ComponentCatalogScreen(),
          ),
        );
      case 2:
        ref.read(liquidThemeProvider.notifier).toggleTheme();
        _showSnackBar('Theme switched');
      case 3:
        Navigator.of(context).push(
          LiqPageRoute<void>(builder: (_) => const SettingsScreen()),
        );
    }
  }

  void _showBanner({
    required String title,
    required String body,
    required LiqBannerStyle style,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: LiqBanner(
              title: title,
              body: body,
              style: style,
              onClose: () => entry.remove(),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future<void>.delayed(const Duration(seconds: 4), () {
      if (entry.mounted) entry.remove();
    });
  }

  void _showAlert() {
    LiqAlert.show<void>(
      context: context,
      title: 'Welcome to Liquid UI Kit',
      description:
          'This is a beautiful alert dialog with liquid glass effects.',
      actions: [
        LiqAlertAction(
          label: 'OK',
          style: LiqAlertActionStyle.filled,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  void _showActionSheet() {
    LiqActionSheet.show<void>(
      context: context,
      title: 'Choose an Action',
      description: 'Select one of the options below',
      actions: [
        LiqAlertAction(
          label: 'Share',
          icon: LiqIcons.share,
          onPressed: () {
            Navigator.of(context).pop();
            _showSnackBar('Share tapped');
          },
        ),
        LiqAlertAction(
          label: 'Edit',
          icon: LiqIcons.edit,
          onPressed: () {
            Navigator.of(context).pop();
            _showSnackBar('Edit tapped');
          },
        ),
        LiqAlertAction(
          label: 'Delete',
          icon: LiqIcons.trash,
          style: LiqAlertActionStyle.destructive,
          onPressed: () {
            Navigator.of(context).pop();
            _showSnackBar('Delete tapped');
          },
        ),
      ],
    );
  }

  Future<void> _showTextInput() async {
    final result = await LiqTextInputDialog.show(
      context: context,
      title: 'Enter Your Name',
      description: 'Please enter your name below',
      placeholder: 'John Doe',
      confirmText: 'Save',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
    );
    if (result != null) {
      _showSnackBar('Hello, $result!');
    }
  }
}