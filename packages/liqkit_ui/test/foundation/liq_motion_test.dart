import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/foundation.dart';

void main() {
  group('LiqMotion curves', () {
    test('standard transforms 0 → 0 and 1 → 1', () {
      expect(LiqMotion.standard.transform(0), 0);
      expect(LiqMotion.standard.transform(1), 1);
    });

    test('snappy transforms 0 → 0 and 1 → 1', () {
      expect(LiqMotion.snappy.transform(0), 0);
      expect(LiqMotion.snappy.transform(1), 1);
    });

    test('smooth transforms 0 → 0 and 1 → 1', () {
      expect(LiqMotion.smooth.transform(0), 0);
      expect(LiqMotion.smooth.transform(1), 1);
    });

    test('the three curves are distinct instances', () {
      expect(identical(LiqMotion.standard, LiqMotion.snappy), isFalse);
      expect(identical(LiqMotion.standard, LiqMotion.smooth), isFalse);
      expect(identical(LiqMotion.snappy, LiqMotion.smooth), isFalse);
    });

    test('the three curves produce different mid-point values', () {
      // Curves with different shapes must disagree somewhere on (0, 1).
      final standardMid = LiqMotion.standard.transform(0.5);
      final snappyMid = LiqMotion.snappy.transform(0.5);
      final smoothMid = LiqMotion.smooth.transform(0.5);
      expect(standardMid, isNot(equals(snappyMid)));
      expect(standardMid, isNot(equals(smoothMid)));
    });
  });

  group('LiqMotion durations', () {
    test('all durations are strictly positive', () {
      expect(LiqMotion.fast.inMilliseconds, greaterThan(0));
      expect(LiqMotion.normal.inMilliseconds, greaterThan(0));
      expect(LiqMotion.slow.inMilliseconds, greaterThan(0));
    });

    test('durations strictly increase: fast < normal < slow', () {
      expect(LiqMotion.fast, lessThan(LiqMotion.normal));
      expect(LiqMotion.normal, lessThan(LiqMotion.slow));
    });
  });
}
