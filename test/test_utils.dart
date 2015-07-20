library guinnessb.test_utils;

import 'package:guinnessb/guinnessb.dart' as guinnessb;

final _context = new _DummyContext();

noop() {}

createSuite() => new guinnessb.Suite(_context);

createDescribe({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinnessb.Describe(
    name, parent, _context, func, exclusive: exclusive, excluded: excluded);

createIt({bool exclusive: false, bool excluded: false, parent,
    Function func: noop, String name: ""}) => new guinnessb.It(
    name, parent, func, exclusive: exclusive, excluded: excluded);

class _DummyContext implements guinnessb.Context {
  withDescribe(guinnessb.Describe describe, Function definition) {}
}
