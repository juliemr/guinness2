part of guinness2;

class TestAdapter {
  const TestAdapter();
  void group(String name, Function fn) => dartTest.group(name, fn);
  void test(String name, Function fn) => dartTest.test(name, fn);
}

class TestVisitor implements SpecVisitor {
  bool containsExclusiveIt = false;
  bool containsExclusiveDescribe = false;
  Set initializedSpecs;
  dynamic dartTest;

  TestVisitor(this.initializedSpecs, {this.dartTest: const TestAdapter()});

  void visitSuite(Suite suite) {
    final v = new ExclusiveVisitor();
    v.visitSuite(suite);
    // v now has containsExclusiveIt and containsExclusiveDescibe properties for the whole suite

    containsExclusiveIt = v.containsExclusiveIt;

    // If there is an exclusive it, ignore exclusive describes.
    containsExclusiveDescribe = !containsExclusiveIt && v.containsExclusiveDescribe;

    if (containsExclusiveDescribe) {
      _visitChildDescribes(suite.children);
    } else {
      _visitChildren(suite.children);
    }
  }

  void visitDescribe(Describe describe) {
    _once(describe, () {
      if (describe.excluded) return;

      // If there exists an exclusive describe, and this isn't it, only look
      // at children that are instances of Describe.
      if (containsExclusiveDescribe && !describe.exclusive) {
        _visitChildDescribes(describe.children);
      }

      dartTest.group(describe.name, () {
        _visitChildren(describe.children);
      });
    });
  }

  void visitIt(It it) {
    _once(it, () {
      if (it.excluded) return;

      if (containsExclusiveIt && !it.exclusive) return;

      dartTest.test(it.name, it.withSetupAndTeardown);
    });
  }

  _visitChildren(children) {
    children.forEach((c) => c.visit(this));
  }

  _visitChildDescribes(children) {
    children.forEach((c) {
      if (c is Describe) {
        c.visit(this);
      }
    });
  }

  _once(spec, Function func) {
    if (initializedSpecs.contains(spec)) return;
    func();
    initializedSpecs.add(spec);
  }
}

class TestMatchers implements Matchers {
  get config => {};

  void expect(actual, matcher, {String reason}) =>
      dartTest.expect(actual, matcher, reason: reason);

  void toEqual(actual, expected) => dartTest.expect(actual, dartTest.equals(expected));

  void toContain(actual, expected) =>
      dartTest.expect(actual, dartTest.contains(expected));

  void toBe(actual, expected) => dartTest.expect(actual,
      dartTest.predicate((actual) => identical(expected, actual), '$expected'));

  void toBeLessThan(num actual, num expected) =>
      dartTest.expect(actual, dartTest.lessThan(expected));

  void toBeGreaterThan(num actual, num expected) =>
      dartTest.expect(actual, dartTest.greaterThan(expected));

  void toBeCloseTo(num actual, num expected, num precision) =>
      dartTest.expect(actual, dartTest.closeTo(expected, math.pow(10, -precision) / 2));

  void toBeA(actual, expected) =>
      dartTest.expect(actual, new IsSubtypeOf(expected));

  void toBeAnInstanceOf(actual, expected) =>
      dartTest.expect(actual, new IsInstanceOf(expected));

  void toThrow(actual, [Pattern pattern]) => dartTest.expect(actual, pattern == null
      ? dartTest.throws
      : dartTest.throwsA(new ExceptionMatcher(message: pattern)));

  void toThrowWith(actual,
      {Type anInstanceOf, Type type, Pattern message, Function where}) {
    final matcher = new ExceptionMatcher(
        anInstanceOf: anInstanceOf, type: type, message: message, where: where);
    dartTest.expect(actual, dartTest.throwsA(matcher));
  }

  void toBeFalsy(actual) =>
      dartTest.expect(actual, _isFalsy, reason: '"$actual" is not Falsy');

  void toBeTruthy(actual) => dartTest.expect(actual, (v) => !_isFalsy(v),
      reason: '"$actual" is not Truthy');

  void toBeFalse(actual) => dartTest.expect(actual, dartTest.isFalse);

  void toBeTrue(actual) => dartTest.expect(actual, dartTest.isTrue);

  void toBeDefined(actual) => dartTest.expect(actual, dartTest.isNotNull);

  void toBeNull(actual) => dartTest.expect(actual, dartTest.isNull);

  void toBeNotNull(actual) => dartTest.expect(actual, dartTest.isNotNull);

  void toHaveBeenCalled(actual) =>
      dartTest.expect(actual.called, true, reason: 'method not called');

  void toHaveBeenCalledOnce(actual) => dartTest.expect(actual.count, 1,
      reason: 'method invoked ${actual.count} expected once');

  void toHaveBeenCalledWith(actual,
      [a = _u, b = _u, c = _u, d = _u, e = _u, f = _u]) => dartTest.expect(
          actual.firstArgsMatch(a, b, c, d, e, f), true,
          reason: 'method invoked with correct arguments');

  void toHaveBeenCalledOnceWith(actual,
      [a = _u, b = _u, c = _u, d = _u, e = _u, f = _u]) => dartTest.expect(
          actual.count == 1 && actual.firstArgsMatch(a, b, c, d, e, f), true,
          reason: 'method invoked once with correct arguments.'
          '(Called ${actual.count} times)');

  void toHaveSameProps(actual, expected) =>
      dartTest.expect(actual, new SamePropsMatcher(expected));

  void notToEqual(actual, expected) =>
      dartTest.expect(actual, dartTest.isNot(dartTest.equals(expected)));

  void notToContain(actual, expected) =>
      dartTest.expect(actual, dartTest.isNot(dartTest.contains(expected)));

  void notToBe(actual, expected) => dartTest.expect(actual, dartTest.predicate(
      (actual) => !identical(expected, actual), 'not $expected'));

  void notToBeLessThan(num actual, num expected) =>
      dartTest.expect(actual, dartTest.isNot(dartTest.lessThan(expected)));

  void notToBeGreaterThan(num actual, num expected) =>
      dartTest.expect(actual, dartTest.isNot(dartTest.greaterThan(expected)));

  void notToBeCloseTo(num actual, num expected, num precision) =>
      dartTest.expect(actual,
          dartTest.isNot(dartTest.closeTo(expected, math.pow(10, -precision) / 2)));

  void notToBeA(actual, expected) =>
      dartTest.expect(actual, dartTest.isNot(new IsSubtypeOf(expected)));

  void notToBeAnInstanceOf(actual, expected) =>
      dartTest.expect(actual, dartTest.isNot(new IsInstanceOf(expected)));

  void toReturnNormally(actual) => dartTest.expect(actual, dartTest.returnsNormally);

  void toBeUndefined(actual) => dartTest.expect(actual, dartTest.isNull);

  void notToHaveBeenCalled(actual) =>
      dartTest.expect(actual.called, false, reason: 'method called');

  void notToHaveBeenCalledWith(actual,
      [a = _u, b = _u, c = _u, d = _u, e = _u, f = _u]) => dartTest.expect(
          actual.firstArgsMatch(a, b, c, d, e, f), false,
          reason: 'method invoked with correct arguments');

  void notToHaveSameProps(actual, expected) =>
      dartTest.expect(actual, dartTest.isNot(new SamePropsMatcher(expected)));
}

bool _isFalsy(v) => v == null ? true : v is bool ? v == false : false;

/// Matches an exception against its type, class, and message
class ExceptionMatcher extends dartTest.Matcher {
  final List<dartTest.Matcher> _matchers = [];

  ExceptionMatcher(
      {Type anInstanceOf, Type type, Pattern message, Function where}) {
    if (message != null) _matchers.add(new PatternMatcher(message));
    if (type != null) _matchers.add(new IsSubtypeOf(type));
    if (anInstanceOf != null) _matchers.add(new IsInstanceOf(anInstanceOf));
    if (where != null) _matchers.add(new WhereMatcher(where));
  }

  bool matches(item, Map matchState) =>
      _matchers.every((matcher) => matcher.matches(item, matchState));

  dartTest.Description describe(dartTest.Description description) {
    if (_matchers.isEmpty) return description;

    description.add('an exception, which ');

    _matchers.first.describe(description);
    _matchers.skip(1).forEach((matcher) {
      description.add(", and ");
      matcher.describe(description);
    });

    return description;
  }
}

/// Matches when the object is verified by [_where]
class WhereMatcher extends dartTest.Matcher {
  final Function _where;

  const WhereMatcher(this._where);

  bool matches(obj, Map matchState) {
    try {
      return _where(obj) != false;
    } on dartTest.TestFailure catch (e) {
      matchState["nestedMatcherFailure"] = e;
      return false;
    }
  }

  dartTest.Description describe(dartTest.Description description) =>
      description.add("is verified by `where`");
}

class PatternMatcher extends dartTest.Matcher {
  final Pattern _pattern;

  const PatternMatcher(this._pattern);

  bool matches(obj, Map matchState) =>
      _pattern.allMatches(obj.toString()).isNotEmpty;

  dartTest.Description describe(dartTest.Description description) =>
      description.add('matches $_pattern');
}

/// Matches when the object is a subtype of [_type]
class IsSubtypeOf extends dartTest.Matcher {
  final Type _type;

  const IsSubtypeOf(this._type);

  bool matches(obj, Map matchState) {
    //Delete the try-catch when Dart2JS supports `isSubtypeOf`.
    try {
      return mirrors.reflect(obj).type.isSubtypeOf(mirrors.reflectClass(_type));
    } on UnimplementedError catch (e) {
      if (_isDart2js) {
        throw "The IsSubtypeOf matcher is not supported in Dart2JS";
      } else {
        rethrow;
      }
    }
  }

  dartTest.Description describe(dartTest.Description description) =>
      description.add('a subtype of $_type');
}

/// Matches when objects have the same properties
class SamePropsMatcher extends dartTest.Matcher {
  final Object _expected;

  const SamePropsMatcher(this._expected);

  bool matches(actual, Map matchState) {
    return compare(toData(_expected), toData(actual));
  }

  dartTest.Description describeMismatch(item, dartTest.Description mismatchDescription,
      Map matchState, bool verbose) => mismatchDescription
      .add('is equal to ${toData(item)}. Expected: ${toData(_expected)}');

  dartTest.Description describe(dartTest.Description description) =>
      description.add('has different properties');

  toData(obj) => new _ObjToData().call(obj);
  compare(d1, d2) => new DeepCollectionEquality().equals(d1, d2);
}

class _ObjToData {
  final visitedObjects = new Set();

  call(obj) {
    if (visitedObjects.contains(obj)) return null;
    visitedObjects.add(obj);

    if (obj is num || obj is String || obj is bool) return obj;
    if (obj is Iterable) return obj.map(call).toList();
    if (obj is Map) return mapToData(obj);
    return toDataUsingReflection(obj);
  }

  mapToData(obj) {
    var res = {};
    obj.forEach((k, v) {
      res[call(k)] = call(v);
    });
    return res;
  }

  toDataUsingReflection(obj) {
    final clazz = mirrors.reflectClass(obj.runtimeType);
    final instance = mirrors.reflect(obj);

    return clazz.declarations.values.fold({}, (map, decl) {
      if (decl is mirrors.VariableMirror && !decl.isPrivate && !decl.isStatic) {
        final field = instance.getField(decl.simpleName);
        final name = mirrors.MirrorSystem.getName(decl.simpleName);
        map[name] = call(field.reflectee);
      }
      return map;
    });
  }
}

/// Matches when the object is an instance of [_type]
class IsInstanceOf extends dartTest.Matcher {
  final Type _type;

  const IsInstanceOf(this._type);

  bool matches(obj, Map matchState) =>
      mirrors.reflect(obj).type.reflectedType == _type;

  dartTest.Description describe(dartTest.Description description) =>
      description.add('an instance of $_type');
}

Set _initializedSpecs = new Set();

void testInitSpecs(Suite suite) {
  var r = new TestVisitor(_initializedSpecs);
  suite.visit(r);
}

bool get _isDart2js => identical(1, 1.0);
