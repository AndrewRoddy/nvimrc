// SPL is parsed as a flat stream of tokens so half-typed searches still highlight.
// queries/splunk/highlights.scm classifies words, ignoring case like Splunk does.
// After editing: tree-sitter generate --abi 14, then :TSInstall! splunk
const UNITS =
  "s|sec|secs|second|seconds|m|min|mins|minute|minutes|h|hr|hrs|hour|hours|d|day|days|w|week|weeks|mon|month|months|q|qtr|quarter|quarters|y|yr|year|years";

module.exports = grammar({
  name: "splunk",
  extras: () => [/\s/],
  rules: {
    source_file: ($) =>
      repeat(
        choice(
          $.comment,
          $.macro,
          $.string,
          $.time_expression,
          $.number,
          $.word,
          $.pipe,
          $.bracket,
          $.operator,
          $.other,
        ),
      ),
    comment: () =>
      token(
        prec(
          5,
          choice(
            /```([^`]|`[^`]|``[^`])*```/,
            /`[cC][oO][mM][mM][eE][nN][tT]\(([^)]|\)[^`])*\)`/,
            /<!--([^-]|-[^-]|--[^>])*-->/,
          ),
        ),
      ),
    macro: () => token(prec(4, /`[^`]*`/)),
    string: ($) =>
      choice(
        seq(
          '"',
          repeat(
            choice(
              token.immediate(prec(1, /[^"\\]+/)),
              $.escape_sequence,
              token.immediate("\\"),
            ),
          ),
          '"',
        ),
        token(/'([^'\\]|\\(.|\r?\n))*'/),
      ),
    escape_sequence: () => token.immediate(/\\[\\n"']/),
    time_expression: () =>
      token(prec(3, new RegExp(`[+-]?\\d+(${UNITS})(@(${UNITS}))?`, "i"))),
    number: () => token(prec(2, /\d+(\.\d+)?/)),
    word: () => token(prec(1, /[A-Za-z0-9_]+/)),
    pipe: () => "|",
    bracket: () => choice("[", "]"),
    operator: () => token(choice(/[=!<>]=?/, /[+\-*\/%]/)),
    // Anything else, such as "." or an unmatched quote.
    other: () => token(prec(-1, /[^\s]/)),
  },
});
