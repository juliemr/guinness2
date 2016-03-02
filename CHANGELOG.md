# v0.0.5 (2016-03-02)

- Fixed equality check for nested lists.

# v0.0.4 (2016-02-11)

- BREAKING CHANGE:
  `iit` and `ddescribe` NO LONGER modify which tests will run. Instead,
  they will mark those blocks with the tag "solo". To run only
  `iit` or `ddescribe` blocks, use the command line
  `pub run test --tags solo` (the same command you would use before,
  with the additional tags "solo").

- Update pub dependencies

- Remove all context keeping track of describe and it blocks,
  instead defer directly to package:test methods.

- Add a bunch of integration tests.

# v0.0.2 (2015-07-23)

- Fix a bug where some it blocks would still be called when using
  nested describes.

# v0.0.1 (2015-07-20)

- Initial release: Cloned from Guinness and made to adapt to dart:test
