part of guinness2;

void beforeEach(Function fn) =>
    dartTest.setUp(fn);

void afterEach(Function fn) =>
    dartTest.tearDown(fn);

void it(name, [Function fn]) {
  if (fn != null) {
    dartTest.test(name, fn);
  } else {
    dartTest.test(name, () {}, skip: 'skipping empty it');   
  }
}

void xit(name, [Function fn]) => dartTest.test(name, fn, skip: 'skipping xit');

void iit(name, [Function fn]) => dartTest.test(name, fn, tags: 'solo');

void describe(name, [Function fn]) {
  if (fn != null) {
    dartTest.group(name, fn);
  } else {
    dartTest.group(name, () {}, skip: 'skipping empty describe');   
  }
}

void xdescribe(name, [Function fn]) => dartTest.group(name, fn, skip: 'skipping xdescribe');

void ddescribe(name, [Function fn]) => dartTest.group(name, fn, tags: 'solo');

Expect expect(actual, [matcher]) {
  final expect = new Expect(actual);
  if (matcher != null) expect.to(matcher);
  return expect;
}
