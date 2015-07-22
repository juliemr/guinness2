@TestOn("browser")


library guinness2_test;

import 'package:guinness2/guinness2_html.dart' as guinness2;

import 'common_test.dart' as common;
import 'html/html_utils_test.dart' as htmlUtilsTest;
import 'html/test_backend_test.dart' as test_backend;

void main() {
  guinness2.GuinnessEnableHtmlMatchers();
  guinness2.guinness.autoInit = false;

  common.main();
  htmlUtilsTest.main();
  test_backend.main();
}
