library guinnessb.test.suit_info_test;

import 'package:guinnessb/guinnessb.dart' as guinnessb;
import 'package:unittest/unittest.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    final context = new guinnessb.Context();
    guinnessb.guinnessb.resetContext(context);
  });

  test("describes", () {
    guinnessb.describe("outer", () {
      guinnessb.xdescribe("xdescribe", noop);
      guinnessb.ddescribe("ddescribe", noop);
      guinnessb.describe("inner describe", noop);
    });
    guinnessb.describe("pending describe");

    final suiteInfo = guinnessb.guinnessb.suiteInfo();
    expect(suiteInfo.numberOfDescribes, equals(5));
    expect(suiteInfo.exclusiveDescribes.length, equals(1));
    expect(suiteInfo.excludedDescribes.length, equals(1));
    expect(suiteInfo.pendingDescribes.length, equals(1));
  });

  test("its", () {
    guinnessb.it("one", noop);
    guinnessb.xit("two", noop);
    guinnessb.iit("three", noop);
    guinnessb.it("pending it");

    final suiteInfo = guinnessb.guinnessb.suiteInfo();
    expect(suiteInfo.numberOfIts, equals(4));
    expect(suiteInfo.exclusiveIts.length, equals(1));
    expect(suiteInfo.excludedIts.length, equals(1));
    expect(suiteInfo.pendingIts.length, equals(1));
  });

  group("[activeIts]", () {
    test("ignores its in xdescribe", () {
      guinnessb.it("one", noop);

      guinnessb.xdescribe("xdescribe", () {
        guinnessb.it("two", noop);
      });

      final suiteInfo = guinnessb.guinnessb.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("ignores pending its", () {
      guinnessb.it("one");

      final suiteInfo = guinnessb.guinnessb.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(0));
    });

    test("counts only its in ddescribes", () {
      guinnessb.it("one", noop);

      guinnessb.ddescribe("ddescribe", () {
        guinnessb.it("two", noop);
      });

      final suiteInfo = guinnessb.guinnessb.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("counts only iits", () {
      guinnessb.it("one", noop);

      guinnessb.describe("describe", () {
        guinnessb.iit("two", noop);
      });

      final suiteInfo = guinnessb.guinnessb.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    test("ignores iits in xdescribe", () {
      guinnessb.it("one", noop);

      guinnessb.xdescribe("xdescribe", () {
        guinnessb.iit("two", noop);
        guinnessb.iit("three", noop);
      });

      final suiteInfo = guinnessb.guinnessb.suiteInfo();
      expect(suiteInfo.activeIts.length, equals(1));
    });

    group('[activeItsPercent]', () {
      test("is the percent of active tests in the suite", () {
        guinnessb.it("one", noop);
        guinnessb.iit("one", noop);

        final suiteInfo = guinnessb.guinnessb.suiteInfo();
        expect(suiteInfo.activeItsPercent, equals(50));
      });

      test("is zero when not specs", () {
        final suiteInfo = guinnessb.guinnessb.suiteInfo();
        expect(suiteInfo.activeItsPercent, equals(0));
      });
    });
  });
}
