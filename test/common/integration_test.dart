library guinnessb.test.integration_test;

import 'dart:async';

import 'package:guinnessb/guinnessb.dart' as guinnessb;
import 'package:test/test.dart';

class DummyVisitor implements guinnessb.SpecVisitor {
  List<Future> allFutures = [];

  void visitSuite(guinnessb.Suite suite) {
    suite.children.forEach((c) => c.visit(this));
  }

  void visitDescribe(guinnessb.Describe describe) {
    describe.children.forEach((c) => c.visit(this));
  }

  void visitIt(guinnessb.It it) {
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
    context = new guinnessb.Context();
    guinnessb.guinnessb.resetContext(context);
  });

  test("runs specs once", () {
    var log = [];

    guinnessb.describe("outer describe", () {
      guinnessb.it("outer it", () {
        log.add("outer it");
      });

      guinnessb.describe("inner describe", () {
        guinnessb.it("inner it", () {
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

    guinnessb.describe("outer describe", () {
      guinnessb.beforeEach(() {
        log.add("outer beforeEach");
      });

      guinnessb.afterEach(() {
        log.add("outer afterEach");
      });

      guinnessb.describe("inner describe", () {
        guinnessb.beforeEach(() {
          log.add("inner beforeEach");
        });

        guinnessb.afterEach(() {
          log.add("inner afterEach");
        });

        guinnessb.it("inner it", () {
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

      guinnessb.describe("outer describe", () {
        guinnessb.beforeEach(() => futurePrinting("outer beforeEach"));
        guinnessb.afterEach(() => futurePrinting("outer afterEach"));

        guinnessb.describe("inner describe", () {
          guinnessb.beforeEach(() => futurePrinting("inner beforeEach"));
          guinnessb.afterEach(() => futurePrinting("inner afterEach"));

          guinnessb.it("inner it", () => futurePrinting("inner it"));
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
    guinnessb.describe("pending describe");
    guinnessb.xdescribe("pending excluded describe");
    guinnessb.ddescribe("pending exclusive describe");

    guinnessb.it("pending it");
    guinnessb.xit("pending exlcluded it");
    guinnessb.iit("pending exclusive it");
    verify(() {});
  });
}
