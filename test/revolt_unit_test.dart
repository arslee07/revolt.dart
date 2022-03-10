import 'package:revolt/src/models/ulid.dart';
import 'package:revolt/src/utils/flags_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Test ULIDs', () {
    const ulidAYear = 2021;
    const ulidBYear = 2022;

    const ulidString = '00000000000000000000000000';

    final ulidA = Ulid.fromTimestamp(DateTime.utc(ulidAYear));
    final ulidB = Ulid.fromTimestamp(DateTime.utc(ulidBYear));

    test('ULIDs should have correct timestamps', () {
      expect(ulidA.toTimestamp().year, ulidAYear);
      expect(ulidB.toTimestamp().year, ulidBYear);
    });

    test('ULIDs should be compared correctly', () {
      expect(ulidA.compareTo(ulidB), -1);
    });

    test('ULIDs should be parsed and converted to string correctly', () {
      expect(Ulid(ulidString).toString(), ulidString);
    });
  });

  group('Test FlagsUtils', () {
    test('FlagsUtils.isApplied() should return correct values', () {
      expect(FlagsUtils.isApplied(0x10, 0x10), true);
      expect(FlagsUtils.isApplied(0x10, 0x01), false);
    });

    test('FlagsUtils.apply() should have correct values', () {
      expect(FlagsUtils.apply(0x000, true, 0x100), 0x100);
      expect(FlagsUtils.apply(0x010, false, 0x010), 0x010);
      expect(FlagsUtils.apply(0x001, null, 0x001), 0x001);
    });
  });
}
