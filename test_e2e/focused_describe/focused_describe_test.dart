import 'package:guinness2/guinness2.dart';

main() {
  ddescribe('focused describe', () {
    it('should run', () {
      expect(2).toEqual(2);
    });
  });

  describe('wrapper', () {
    ddescribe('nested focused describe', () {
      it('should run', () {
        expect(3).toEqual(3);
      });
    });
  });

  it('should not run', () {
    expect(1).toEqual(2);
  });
}
