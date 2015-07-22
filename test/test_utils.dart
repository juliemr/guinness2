library guinness_2.test_utils;

import 'package:guinness_2/guinness_2.dart' as guinness_2;

final _context = new _DummyContext();

noop() {}

createSuite() => new guinness_2.Suite(_context);

createDescribe({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinness_2.Describe(
    name, parent, _context, func, exclusive: exclusive, excluded: excluded);

createIt({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinness_2.It(
    name, parent, func, exclusive: exclusive, excluded: excluded);

class _DummyContext implements guinness_2.Context {
  withDescribe(guinness_2.Describe describe, Function definition) {}
}
