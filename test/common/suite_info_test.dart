library guinness_2.test.suit_info_test;

import 'package:guinness_2/guinness_2.dart' as guinness_2;
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    final context = new guinness_2.Context();
    guinness_2.guinness.resetContext(context);
  });

  test("describes", () {
    guinness_2.describe("outer", () {
      guinness_2.xdescribe("xdescribe", noop);
      guinness_2.ddescribe("ddescribe", noop);
      guinness_2.describe("inner describe", noop);
    });
    guinness_2.describe("pending describe");

    final suiteInfo = guinness_2.guinness.suiteInfo();
    expect(suiteInfo.numberOfDescribes, equals(5));
    expect(suiteInfo.exclusiveDescribes.length, equals(1));
    expect(suiteInfo.excludedDescribes.length, equals(1));
    expect(suiteInfo.pendingDescribes.length, equals(1));
  });

  test("its", () {
    guinness_2.it("one", noop);
    guinness_2.xit("two", noop);
    guinness_2.iit("three", noop);
    guinness_2.it("pending it");

    final suiteInfo = guinness_2.guinness.suiteInfo();
    expect(suiteInfo.numberOfIts, equals(4));
    expect(suiteInfo.exclusiveIts.length, equals(1));
    expect(suiteInfo.excludedIts.length, equals(1));
    expect(suiteInfo.pendingIts.length, equals(1));
  });

  group("[activeIts]", () {
    test("ignores its in xdescribe", () {
      guinness_2.it("one", noop);

      guinness_2.xdescribe("xdescribe", () {
        guinness_2.it("two", noop);
      });

      final suiteInfo = guinness_2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("ignores pending its", () {
      guinness_2.it("one");

      final suiteInfo = guinness_2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(0));
    });

    test("counts only its in ddescribes", () {
      guinness_2.it("one", noop);

      guinness_2.ddescribe("ddescribe", () {
        guinness_2.it("two", noop);
      });

      final suiteInfo = guinness_2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("counts only iits", () {
      guinness_2.it("one", noop);

      guinness_2.describe("describe", () {
        guinness_2.iit("two", noop);
      });

      final suiteInfo = guinness_2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("ignores iits in xdescribe", () {
      guinness_2.it("one", noop);

      guinness_2.xdescribe("xdescribe", () {
        guinness_2.iit("two", noop);
        guinness_2.iit("three", noop);
      });

      final suiteInfo = guinness_2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    group('[activeItsPercent]', () {
      test("is the percent of active tests in the suite", () {
        guinness_2.it("one", noop);
        guinness_2.iit("one", noop);

        final suiteInfo = guinness_2.guinness.suiteInfo();
        expect(suiteInfo.activeItsPercent, equals(50));
      });

      test("is zero when not specs", () {
        final suiteInfo = guinness_2.guinness.suiteInfo();
        expect(suiteInfo.activeItsPercent, equals(0));
      });
    });
  });
}
