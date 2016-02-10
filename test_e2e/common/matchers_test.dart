import 'package:guinness2/guinness2.dart';

class TestClass {}

main() {
  describe("guinness2", () {
    it("has various built-in matchers", () {
      expect(2).toEqual(2);

      expect([1, 2]).toContain(2);

      expect(2).toBe(2);

      expect(2).toBeA(num);

      expect(1).toBeLessThan(2);
      expect(2).toBeGreaterThan(1);
      expect(1.234).toBeCloseTo(1.23, 2);

      expect(new TestClass()).toBeAnInstanceOf(TestClass);
      expect("sfs").not.toBeAnInstanceOf(TestClass);
      expect(() => throw "BOOM").toThrowWith();
      expect(() => throw "BOOM").toThrowWith(message: "BOOM");
      expect(() => throw "BOOM").toThrowWith(message: new RegExp("B[O]{2}M"));
      expect(() => throw new TestClass()).toThrowWith(anInstanceOf: TestClass);
      expect(() => throw new TestClass()).toThrowWith(type: TestClass);
      expect(() => throw new TestClass()).toThrowWith(where: (e) {
        expect(e).toBeDefined();
      });
      expect(false).toBeFalsy();
      expect(null).toBeFalsy();
      expect(true).toBeTruthy();
      expect("any object").toBeTruthy();
      expect(false).toBeFalse();
      expect(true).toBeTrue();
      expect("any object").toBeDefined();
      expect(null).toBeNull();
      expect("not null").toBeNotNull();

      expect(2).not.toEqual(1);

      expect([1, 2]).not.toContain(3);

      expect([1, 2]).not.toBe([1, 2]);

      expect(() {}).not.toThrow();

      expect(null).not.toBeDefined();

      expect(1).not.toBeLessThan(0);
      expect(0).not.toBeGreaterThan(1);
      expect(1.234).not.toBeCloseTo(1.23, 3);
    });
  });
}
