library guinness2.test.integration_test;

import 'dart:async';

import 'package:guinness2/guinness2.dart' as guinness2;
import 'package:test/test.dart';

class DummyVisitor implements guinness2.SpecVisitor {
  List<Future> allFutures = [];

  void visitSuite(guinness2.Suite suite) {
    suite.children.forEach((c) => c.visit(this));
  }

  void visitDescribe(guinness2.Describe describe) {
    describe.children.forEach((c) => c.visit(this));
  }

  void visitIt(guinness2.It it) {
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
    context = new guinness2.Context();
    guinness2.guinness.resetContext(context);
  });

  test("runs specs once", () {
    var log = [];

    guinness2.describe("outer describe", () {
      guinness2.it("outer it", () {
        log.add("outer it");
      });

      guinness2.describe("inner describe", () {
        guinness2.it("inner it", () {
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

    guinness2.describe("outer describe", () {
      guinness2.beforeEach(() {
        log.add("outer beforeEach");
      });

      guinness2.afterEach(() {
        log.add("outer afterEach");
      });

      guinness2.describe("inner describe", () {
        guinness2.beforeEach(() {
          log.add("inner beforeEach");
        });

        guinness2.afterEach(() {
          log.add("inner afterEach");
        });

        guinness2.it("inner it", () {
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

      guinness2.describe("outer describe", () {
        guinness2.beforeEach(() => futurePrinting("outer beforeEach"));
        guinness2.afterEach(() => futurePrinting("outer afterEach"));

        guinness2.describe("inner describe", () {
          guinness2.beforeEach(() => futurePrinting("inner beforeEach"));
          guinness2.afterEach(() => futurePrinting("inner afterEach"));

          guinness2.it("inner it", () => futurePrinting("inner it"));
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
    guinness2.describe("pending describe");
    guinness2.xdescribe("pending excluded describe");
    guinness2.ddescribe("pending exclusive describe");

    guinness2.it("pending it");
    guinness2.xit("pending exlcluded it");
    guinness2.iit("pending exclusive it");
    verify(() {});
  });
}
