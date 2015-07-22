library guinness2.test.suit_info_test;

import 'package:guinness2/guinness2.dart' as guinness2;
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    final context = new guinness2.Context();
    guinness2.guinness.resetContext(context);
  });

  test("describes", () {
    guinness2.describe("outer", () {
      guinness2.xdescribe("xdescribe", noop);
      guinness2.ddescribe("ddescribe", noop);
      guinness2.describe("inner describe", noop);
    });
    guinness2.describe("pending describe");

    final suiteInfo = guinness2.guinness.suiteInfo();
    expect(suiteInfo.numberOfDescribes, equals(5));
    expect(suiteInfo.exclusiveDescribes.length, equals(1));
    expect(suiteInfo.excludedDescribes.length, equals(1));
    expect(suiteInfo.pendingDescribes.length, equals(1));
  });

  test("its", () {
    guinness2.it("one", noop);
    guinness2.xit("two", noop);
    guinness2.iit("three", noop);
    guinness2.it("pending it");

    final suiteInfo = guinness2.guinness.suiteInfo();
    expect(suiteInfo.numberOfIts, equals(4));
    expect(suiteInfo.exclusiveIts.length, equals(1));
    expect(suiteInfo.excludedIts.length, equals(1));
    expect(suiteInfo.pendingIts.length, equals(1));
  });

  group("[activeIts]", () {
    test("ignores its in xdescribe", () {
      guinness2.it("one", noop);

      guinness2.xdescribe("xdescribe", () {
        guinness2.it("two", noop);
      });

      final suiteInfo = guinness2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("ignores pending its", () {
      guinness2.it("one");

      final suiteInfo = guinness2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(0));
    });

    test("counts only its in ddescribes", () {
      guinness2.it("one", noop);

      guinness2.ddescribe("ddescribe", () {
        guinness2.it("two", noop);
      });

      final suiteInfo = guinness2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("counts only iits", () {
      guinness2.it("one", noop);

      guinness2.describe("describe", () {
        guinness2.iit("two", noop);
      });

      final suiteInfo = guinness2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("ignores iits in xdescribe", () {
      guinness2.it("one", noop);

      guinness2.xdescribe("xdescribe", () {
        guinness2.iit("two", noop);
        guinness2.iit("three", noop);
      });

      final suiteInfo = guinness2.guinness.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    group('[activeItsPercent]', () {
      test("is the percent of active tests in the suite", () {
        guinness2.it("one", noop);
        guinness2.iit("one", noop);

        final suiteInfo = guinness2.guinness.suiteInfo();
        expect(suiteInfo.activeItsPercent, equals(50));
      });

      test("is zero when not specs", () {
        final suiteInfo = guinness2.guinness.suiteInfo();
        expect(suiteInfo.activeItsPercent, equals(0));
      });
    });
  });
}
