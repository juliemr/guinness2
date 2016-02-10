import 'package:guinness2/guinness2.dart';

main() {
  describe('describe', () {
    it('should run', () {
      expect(2).toEqual(2);
    });
  });

  describe('wrapper', () {
    describe('nested describe', () {
      it('should run', () {
        expect(3).toEqual(3);
      });
    });
  });

  xit('skipped spec should not run', () {
    expect(1).toEqual(2);
  });
}
