@TestOn('browser')

import 'package:guinness2/guinness2_html.dart';
import 'dart:html';

main() {
  guinnessEnableHtmlMatchers();

  describe("guinness2", () {
    it("has various built-in html matchers", () {
      expect(new DocumentFragment.html("<div>some html</div>"))
          .toHaveHtml("<div>some html</div>");

      expect(new DocumentFragment.html("<div>some text</div>"))
          .toHaveText("some text");

      expect(new DivElement()..classes.add('abc')).toHaveClass("abc");

      expect(new DivElement()..attributes['attr'] = 'value')
          .toHaveAttribute("attr");

      expect(new DocumentFragment.html("<div>some html</div>")).not
          .toHaveHtml("<div>some other html</div>");

      expect(new DocumentFragment.html("<div>some text</div>")).not
          .toHaveText("some other text");

      expect(new DivElement()..classes.add('abc')).not.toHaveClass("def");

      expect(new DivElement()..attributes['attr'] = 'value').not
          .toHaveAttribute("other-attr");

      final select = new SelectElement();
      select.children
        ..add(new OptionElement(value: "1"))
        ..add(new OptionElement(value: "2", selected: true))
        ..add(new OptionElement(value: "3"));

      expect(select).toEqualSelect(["1", ["2"], "3"]);
    });
  });
}
