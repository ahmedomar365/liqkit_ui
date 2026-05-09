import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import '../models/travel_models.dart';

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestions = TravelSampleData.popularSearches;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: LiqChip(
              label: suggestion,
              onPressed: () {
                // Handle suggestion tap
              },
            ),
          );
        },
      ),
    );
  }
}