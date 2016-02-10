import 'package:guinness2/guinness2.dart';

main() {
  describe('unfocused test in other file', () {
	  it('should not run', () {
	    expect(1).toEqual(2);
	  });
  });
}
