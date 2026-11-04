; Later patterns win, so function calls come before the keywords.
((identifier) @function.call
  . (delimiter "("))

((identifier) @_declaration
  . (identifier) @function
  (#any-of? @_declaration "Algorithm" "Procedure" "Function" "Routine"))

((identifier) @function.builtin
  (#any-of? @function.builtin
    "EmptyPriorityQueue" "EmptyQueue" "EmptyStack" "EmptyMap" "EmptySet"
    "InsertWithPriority" "RemoveMinimum" "Enqueue" "Dequeue" "Push" "Pop"
    "Contains" "Add" "Remove" "Set" "Get" "Length" "Neighbors" "EdgeCost"
    "Heuristic" "Print" "Read" "Swap" "Sort" "Append" "Min" "Max"))

((identifier) @keyword.function
  (#any-of? @keyword.function "Algorithm" "Procedure" "Function" "Routine"))
((identifier) @keyword
  (#any-of? @keyword "begin" "end" "do" "then" "else" "elseif"))
((identifier) @keyword.conditional
  (#any-of? @keyword.conditional "if" "unless"))
((identifier) @keyword.repeat
  (#any-of? @keyword.repeat "while" "for" "foreach" "repeat" "until" "to" "downto" "in"))
((identifier) @keyword.return
  (#any-of? @keyword.return "return" "break" "continue" "pass"))
((identifier) @boolean
  (#any-of? @boolean "true" "false" "TRUE" "FALSE"))
((identifier) @constant.builtin
  (#any-of? @constant.builtin "NIL" "NULL" "null" "nil"))
((identifier) @keyword.operator
  (#any-of? @keyword.operator "not" "and" "or" "xor"))

(operator) @operator
(number) @number
(string) @string
(delimiter) @punctuation.delimiter
(comment) @comment @spell
