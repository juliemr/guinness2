part of guinnessb;

void beforeEach(Function fn, {int priority: 0}) =>
    guinnessb._context.addBeforeEach(fn, priority: priority);

void afterEach(Function fn, {int priority: 0}) =>
    guinnessb._context.addAfterEach(fn, priority: priority);

void it(name, [Function fn]) => guinnessb._context.addIt(name.toString(), fn,
    excluded: false, exclusive: false);

void xit(name, [Function fn]) => guinnessb._context.addIt(name.toString(), fn,
    excluded: true, exclusive: false);

void iit(name, [Function fn]) => guinnessb._context.addIt(name.toString(), fn,
    excluded: false, exclusive: true);

void describe(name, [Function fn]) => guinnessb._context.addDescribe(
    name.toString(), fn, excluded: false, exclusive: false);

void xdescribe(name, [Function fn]) => guinnessb._context.addDescribe(
    name.toString(), fn, excluded: true, exclusive: false);

void ddescribe(name, [Function fn]) => guinnessb._context.addDescribe(
    name.toString(), fn, excluded: false, exclusive: true);

Expect expect(actual, [matcher]) {
  final expect = new Expect(actual);
  if (matcher != null) expect.to(matcher);
  return expect;
}
