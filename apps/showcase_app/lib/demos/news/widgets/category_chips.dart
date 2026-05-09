import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/news_models.dart';
import '../models/news_providers.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = NewsSampleData.categories;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.id;
          final categoryColor =
              Color(int.parse(category.color.replaceFirst('#', '0xFF')));

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state = category.id;
              },
              child: isSelected
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            categoryColor,
                            categoryColor.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _CategoryChipContent(
                        category: category,
                        isSelected: true,
                      ),
                    )
                  : LiqCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: _CategoryChipContent(
                        category: category,
                        isSelected: false,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryChipContent extends StatelessWidget {
  const _CategoryChipContent({
    required this.category,
    required this.isSelected,
  });

  final NewsCategory category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(category.icon, size: 18),
        const SizedBox(width: 8),
        Text(
          category.name,
          style: context.textStyles.body.copyWith(
            fontWeight: isSelected
                ? LiqAppleTypography.semibold
                : LiqAppleTypography.regular,
            color: isSelected
                ? const Color(0xFFFFFFFF)
                : context.appleColors.label,
          ),
        ),
      ],
    );
  }
}
