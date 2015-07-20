library guinnessb_test;

import 'package:guinnessb/guinnessb_html.dart' as guinnessb;

import 'common_test.dart' as common;
import 'html/html_utils_test.dart' as htmlUtilsTest;
import 'html/test_backend_test.dart' as test_backend;

void main() {
  guinnessb.guinnessbEnableHtmlMatchers();
  guinnessb.guinnessb.autoInit = false;

  common.main();
  htmlUtilsTest.main();
  test_backend.main();
}
