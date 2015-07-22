part of guinness2_html;

Expect expect(actual, [matcher]) {
  final expect = new Expect(actual);
  if (matcher != null) expect.to(matcher);
  return expect;
}
