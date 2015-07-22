library guinness_2.test.syntax_test;

import 'package:guinness_2/guinness_2.dart' as guinness_2;
import 'package:test/test.dart';

void main() {
  var context;

  setUp(() {
    context = new guinness_2.Context();
    guinness_2.guinness.resetContext(context);
  });

  group("[describe]", () {
    test("adds a describe to the current describe block", () {
      guinness_2.describe("new describe", () {});

      final actualDescribe = context.suite.children.first;

      expect(actualDescribe.name, equals("new describe"));
    });
  });

  group("[xdescribe]", () {
    test(
        "adds a describe to the current describe block with excluded set to true",
        () {
      guinness_2.xdescribe("new xdescribe", () {});

      final actualDescribe = context.suite.children.first;

      expect(actualDescribe.name, equals("new xdescribe"));
      expect(actualDescribe.excluded, isTrue);
    });
  });

  group("[ddescribe]", () {
    test(
        "adds a describe to the current describe block with exclusive set to true",
        () {
      guinness_2.ddescribe("new ddescribe", () {});

      final actualDescribe = context.suite.children.first;

      expect(actualDescribe.name, equals("DDESCRIBE: new ddescribe"));
      expect(actualDescribe.exclusive, isTrue);
    });
  });

  group("[it]", () {
    test("adds an `it` to the current describe block", () {
      guinness_2.it("new it", () {});

      final actualIt = context.suite.children.first;

      expect(actualIt.name, equals("new it"));
      expect(actualIt.excluded, isFalse);
      expect(actualIt.exclusive, isFalse);
    });
  });

  group("[xit]", () {
    test("adds an `it` to the current describe block with excluded set to true",
        () {
      guinness_2.xit("new xit", () {});

      final actualIt = context.suite.children.first;

      expect(actualIt.name, equals("new xit"));
      expect(actualIt.excluded, isTrue);
    });
  });

  group("[iit]", () {
    test(
        "adds an `it` to the current describe block with exclusive set to true",
        () {
      guinness_2.iit("new iit", () {});

      final actualIt = context.suite.children.first;

      expect(actualIt.name, equals("new iit"));
      expect(actualIt.exclusive, isTrue);
    });
  });

  group("[beforeEach]", () {
    test("adds a before each fn to the current describe block", () {
      guinness_2.beforeEach(() {});

      expect(context.suite.beforeEachFns.length, equals(1));
      expect(context.suite.beforeEachFns[0].priority, equals(0));
    });

    test("supports different priorities", () {
      guinness_2.beforeEach(() {}, priority: 2);

      expect(context.suite.beforeEachFns[0].priority, equals(2));
    });
  });

  group("[afterEach]", () {
    test("adds a after each fn to the current describe block", () {
      guinness_2.afterEach(() {});

      expect(context.suite.afterEachFns.length, equals(1));
      expect(context.suite.afterEachFns[0].priority, equals(0));
    });

    test("supports different priorities", () {
      guinness_2.afterEach(() {}, priority: 2);

      expect(context.suite.afterEachFns[0].priority, equals(2));
    });
  });

  test("handles nested describes and its", () {
    guinness_2.describe("outer describe", () {
      guinness_2.it("outer it", () {});
      guinness_2.describe("inner describe", () {
        guinness_2.it("inner it", () {});
      });
    });

    expect(context.suite.children.length, equals(1));

    final outerDescribe = context.suite.children[0];
    expect(outerDescribe.name, equals("outer describe"));
    expect(outerDescribe.children[0].name, equals("outer it"));
    expect(outerDescribe.children[1].name, equals("inner describe"));

    final innerDescribe = outerDescribe.children[1];
    expect(innerDescribe.children.length, equals(1));
    expect(innerDescribe.children[0].name, equals("inner it"));
  });

  group("[expect]", () {
    test("creates an Expect object", () {
      final e = guinness_2.expect("actual");

      expect(e.actual, equals("actual"));
    });

    test("executes the given matcher", () {
      expect(() {
        guinness_2.expect(true, isFalse);
      }, throws);
    });
  });
}
