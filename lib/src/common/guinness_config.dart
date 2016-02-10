part of guinness2;

class Guinness {
  dynamic matchers;

  Guinness({this.matchers}) {
  }

  SpyFunction createSpy([String name]) => new SpyFunction(name);

  SpyFunction spyOn(obj, String name) {
    throw "Not implemented";
  }
}
