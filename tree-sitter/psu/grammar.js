// Academic pseudocode has no fixed syntax, so this reads a flat stream of tokens
// and never fails on unusual input. queries/psu/highlights.scm classifies words.
// After editing: tree-sitter generate --abi 14, then :TSInstall! psu
module.exports = grammar({
  name: "psu",
  extras: () => [/\s/],
  rules: {
    source_file: ($) =>
      repeat(
        choice(
          $.comment,
          $.string,
          $.number,
          $.identifier,
          $.operator,
          $.delimiter,
          $.other,
        ),
      ),
    comment: () => token(prec(3, choice(/\/\/.*/, /#.*/, /--.*/))),
    string: () =>
      token(
        prec(
          3,
          choice(/"([^"\\]|\\(.|\r?\n))*"/, /'([^'\\]|\\(.|\r?\n))*'/),
        ),
      ),
    number: () => token(prec(2, /\d+(\.\d+)?/)),
    identifier: () => token(prec(1, /[A-Za-z0-9_]+/)),
    operator: () =>
      choice("<-", "<=", ">=", "!=", "==", "=", "<", ">", "+", "-", "*", "/", "%"),
    delimiter: () => choice("[", "]", "(", ")", ",", ":", ";"),
    // Anything else, such as an arrow symbol or an unmatched quote.
    other: () => token(prec(-1, /[^\s]/)),
  },
});
