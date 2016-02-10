import 'package:guinness2/guinness2.dart';

main() {
  describe('focused test', () {
    iit('should run', () {
      expect(2).toEqual(2);
    });
  });

  it('unfocused test should not run', () {
    expect(1).toEqual(2);
  });
}
