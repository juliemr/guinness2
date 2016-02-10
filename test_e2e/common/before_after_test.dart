import 'package:guinness2/guinness2.dart';

main() {
  describe("beforeEach", () {
    var res = [];
    beforeEach(() {
      res.add("outer");
    });

    describe("nested describe", () {
      beforeEach(() {
        res.add("inner");
      });

      it("run callbacks in order", () {
        expect(res).toEqual(["outer", "inner"]);
      });
    });
  });

  describe("afterEach", () {
    var res = [];

    afterEach(() {
      res.add("outer");
    });

    describe("nested describe", () {
      afterEach(() {
        res.add("inner");
      });

      it("will run afterEach after this test", () {});

      it("runs callbacks in reverse order", () {
        expect(res).toEqual(["inner", "outer"]);
      });
    });
  });
}