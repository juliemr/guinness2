library guinness2_html;

import 'guinness2.dart' as gns;
import 'package:test/test.dart' as dartTest;
import 'src/html_utils.dart' as htmlUtils;

export 'guinness2.dart';

part 'src/html/interfaces.dart';
part 'src/html/expect.dart';
part 'src/html/syntax.dart';
part 'src/html/test_html_matchers.dart';

void guinnessEnableHtmlMatchers() {
  gns.guinness.matchers = new TestMatchersWithHtml();
}

@Deprecated('Use guinnessEnableHtmlMatchers instead')
void GuinnessEnableHtmlMatchers() {
  guinnessEnableHtmlMatchers();
}
