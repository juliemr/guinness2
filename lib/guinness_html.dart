library guinnessb_html;

import 'guinnessb.dart' as gns;
import 'package:unittest/unittest.dart' as unit;
import 'src/html_utils.dart' as htmlUtils;

export 'guinnessb.dart';

part 'src/html/interfaces.dart';
part 'src/html/expect.dart';
part 'src/html/syntax.dart';
part 'src/html/unittest_html_matchers.dart';

void guinnessbEnableHtmlMatchers() {
  gns.guinnessb.matchers = new UnitTestMatchersWithHtml();
}
