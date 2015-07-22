part of guinness2;

class Guinness {
  Context _context = new Context();
  dynamic matchers;
  SpecRunner _initSpecs;
  bool autoInit = true;

  Guinness({this.matchers, SpecRunner initSpecs})
      : _initSpecs = initSpecs {
    _scheduleAutoInit();
  }

  SpyFunction createSpy([String name]) => new SpyFunction(name);

  SpyFunction spyOn(obj, String name) {
    throw "Not implemented";
  }

  void initSpecs() {
    _initSpecs(_context.suite);
  }

  void resetContext([Context context]) {
    _context = context == null ? new Context() : context;
  }

  SuiteInfo suiteInfo() => _suiteInfo(_context.suite);

  void _scheduleAutoInit() {
    async.scheduleMicrotask(() {
      if (autoInit) initSpecs();
    });
  }
}
