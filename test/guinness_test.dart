@TestOn("browser")


library guinness_2_test;

import 'package:guinness_2/guinness_2_html.dart' as guinness_2;

import 'common_test.dart' as common;
import 'html/html_utils_test.dart' as htmlUtilsTest;
import 'html/test_backend_test.dart' as test_backend;

void main() {
  guinness_2.GuinnessEnableHtmlMatchers();
  guinness_2.guinness.autoInit = false;

  common.main();
  htmlUtilsTest.main();
  test_backend.main();
}
