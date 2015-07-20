library guinnessb_html;

import 'guinnessb.dart' as gns;
import 'package:test/test.dart' as unit;
import 'src/html_utils.dart' as htmlUtils;

export 'guinnessb.dart';

part 'src/html/interfaces.dart';
part 'src/html/expect.dart';
part 'src/html/syntax.dart';
part 'src/html/test_html_matchers.dart';

void guinnessbEnableHtmlMatchers() {
  gns.guinnessb.matchers = new UnitTestMatchersWithHtml();
}
