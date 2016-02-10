import 'package:guinness2/guinness2.dart';

main() {
  describe("spy", () {
    it("supports spy functions", () {
      final s = guinness.createSpy("my spy");
      expect(s).not.toHaveBeenCalled();

      s(1);
      expect(s).toHaveBeenCalled();
      expect(s).toHaveBeenCalledOnce();
      expect(s).toHaveBeenCalledWith(1);
      expect(s).toHaveBeenCalledOnceWith(1);
      expect(s).not.toHaveBeenCalledWith(2);

      s(2);
      expect(() {
        expect(s).toHaveBeenCalledOnce();
      }).toThrowWith();

      expect(() {
        expect(s).toHaveBeenCalledOnceWith(1);
      }).toThrowWith();
    });
  });
}
