import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import '../models/news_models.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherInfo weather;

  const WeatherWidget({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return LiqCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Icon(weather.icon, size: 44),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  weather.location,
                  style: context.textStyles.caption1.secondary,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${weather.temperature.toInt()}°',
                      style: context.textStyles.largeTitle.copyWith(
                        fontWeight: LiqAppleTypography.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          weather.condition,
                          style: context.textStyles.body,
                        ),
                        Text(
                          'H: ${weather.high.toInt()}° L: ${weather.low.toInt()}°',
                          style: context.textStyles.caption1.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
