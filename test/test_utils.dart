library guinness2.test_utils;

import 'package:guinness2/guinness2.dart' as guinness2;

final _context = new _DummyContext();

noop() {}

createSuite() => new guinness2.Suite(_context);

createDescribe({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinness2.Describe(
    name, parent, _context, func, exclusive: exclusive, excluded: excluded);

createIt({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinness2.It(
    name, parent, func, exclusive: exclusive, excluded: excluded);

class _DummyContext implements guinness2.Context {
  withDescribe(guinness2.Describe describe, Function definition) {}
}
