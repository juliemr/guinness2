part of guinness2_html;

class TestMatchersConfig {
  Function preprocessHtml = (node) => node;
}

class TestMatchersWithHtml extends gns.TestMatchers
    implements HtmlMatchers {
  final TestMatchersConfig config = new TestMatchersConfig();

  void toHaveHtml(actual, expected) => dartTest.expect(
      htmlUtils.toHtml(actual, preprocess: config.preprocessHtml),
      dartTest.equals(expected));

  void toHaveText(actual, expected) =>
      dartTest.expect(htmlUtils.elementText(actual), dartTest.equals(expected));

  void toContainText(actual, expected) =>
      dartTest.expect(htmlUtils.elementText(actual), dartTest.contains(expected));

  void toHaveClass(actual, cls) => dartTest.expect(
      actual.classes.contains(cls), true,
      reason: ' Expected $actual to have css class "$cls"');

  void toHaveAttribute(actual, name, [value = null]) {
    dartTest.expect(actual.attributes.containsKey(name), true,
        reason: 'Epxected $actual to have attribute "$name"');

    if (value != null) {
      dartTest.expect(actual.attributes[name], value,
          reason: 'Epxected $actual attribute "$name" to be "$value"');
    }
  }

  void toEqualSelect(actual, options) {
    var actualOptions = [];
    for (var option in actual.querySelectorAll('option')) {
      actualOptions.add(option.selected ? [option.value] : option.value);
    }
    return dartTest.expect(actualOptions, options);
  }

  void notToHaveHtml(actual, expected) => dartTest.expect(
      htmlUtils.toHtml(actual, preprocess: config.preprocessHtml),
      dartTest.isNot(dartTest.equals(expected)));

  void notToHaveText(actual, expected) => dartTest.expect(
      htmlUtils.elementText(actual), dartTest.isNot(dartTest.equals(expected)));

  void notToContainText(actual, expected) => dartTest.expect(
      htmlUtils.elementText(actual), dartTest.isNot(dartTest.contains(expected)));

  void notToHaveClass(actual, cls) => dartTest.expect(
      actual.classes.contains(cls), false,
      reason: ' Expected $actual not to have css class "$cls"');

  void notToHaveAttribute(actual, name) => dartTest.expect(
      actual.attributes.containsKey(name), false,
      reason: 'Epxected $actual not to have attribute "$name"');
}
