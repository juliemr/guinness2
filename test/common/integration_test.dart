library guinness_2.test.integration_test;

import 'dart:async';

import 'package:guinness_2/guinness_2.dart' as guinness_2;
import 'package:test/test.dart';

class DummyVisitor implements guinness_2.SpecVisitor {
  List<Future> allFutures = [];

  void visitSuite(guinness_2.Suite suite) {
    suite.children.forEach((c) => c.visit(this));
  }

  void visitDescribe(guinness_2.Describe describe) {
    describe.children.forEach((c) => c.visit(this));
  }

  void visitIt(guinness_2.It it) {
    allFutures.add(it.withSetupAndTeardown());
  }

  waitForAll() => Future.wait(allFutures);
}

main() {
  var context;

  void verify(Function fn) {
    final visitor = new DummyVisitor();
    context.suite.visit(visitor);
    visitor
        .waitForAll()
        .then(expectAsync((_) => fn()))
        .catchError((e) => print(e));
  }

  setUp(() {
    context = new guinness_2.Context();
    guinness_2.guinness.resetContext(context);
  });

  test("runs specs once", () {
    var log = [];

    guinness_2.describe("outer describe", () {
      guinness_2.it("outer it", () {
        log.add("outer it");
      });

      guinness_2.describe("inner describe", () {
        guinness_2.it("inner it", () {
          log.add("inner it");
        });
      });
    });

    verify(() {
      expect(log, equals(["outer it", "inner it"]));
    });
  });

  test("runs beforeEach and afterEach blocks", () {
    var log = [];

    guinness_2.describe("outer describe", () {
      guinness_2.beforeEach(() {
        log.add("outer beforeEach");
      });

      guinness_2.afterEach(() {
        log.add("outer afterEach");
      });

      guinness_2.describe("inner describe", () {
        guinness_2.beforeEach(() {
          log.add("inner beforeEach");
        });

        guinness_2.afterEach(() {
          log.add("inner afterEach");
        });

        guinness_2.it("inner it", () {
          log.add("inner it");
        });
      });
    });

    verify(() {
      expect(log, equals([
        "outer beforeEach",
        "inner beforeEach",
        "inner it",
        "inner afterEach",
        "outer afterEach"
      ]));
    });
  });

  group("when beforeEach, afterEach, and it return futures", () {
    test("waits for them to be completed", () {
      var log = [];

      futurePrinting(message) => new Future.microtask(() {
        log.add(message);
      });

      guinness_2.describe("outer describe", () {
        guinness_2.beforeEach(() => futurePrinting("outer beforeEach"));
        guinness_2.afterEach(() => futurePrinting("outer afterEach"));

        guinness_2.describe("inner describe", () {
          guinness_2.beforeEach(() => futurePrinting("inner beforeEach"));
          guinness_2.afterEach(() => futurePrinting("inner afterEach"));

          guinness_2.it("inner it", () => futurePrinting("inner it"));
        });
      });

      verify(() {
        expect(log, equals([
          "outer beforeEach",
          "inner beforeEach",
          "inner it",
          "inner afterEach",
          "outer afterEach"
        ]));
      });
    });
  });

  test("pending describes and its", () {
    guinness_2.describe("pending describe");
    guinness_2.xdescribe("pending excluded describe");
    guinness_2.ddescribe("pending exclusive describe");

    guinness_2.it("pending it");
    guinness_2.xit("pending exlcluded it");
    guinness_2.iit("pending exclusive it");
    verify(() {});
  });
}
