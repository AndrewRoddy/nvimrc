if exists("b:current_syntax")
  finish
endif

syn case match
syn sync fromstart

" Algorithm and routine declarations.
syn keyword psuDeclaration Algorithm Procedure Function Routine
syn match psuDeclarationName /\<\(Algorithm\|Procedure\|Function\|Routine\)\>\s\+\zs[A-Za-z_][A-Za-z0-9_]*/

" Block structure and control flow.
syn keyword psuBlock begin end do then else elseif
syn keyword psuConditional if unless
syn keyword psuRepeat while for foreach repeat until
syn keyword psuLoopControl to downto in
syn keyword psuStatement return break continue pass

" Common pseudocode operations and data-structure helpers.
syn match psuBuiltin /\<\(EmptyPriorityQueue\|EmptyQueue\|EmptyStack\|EmptyMap\|EmptySet\|InsertWithPriority\|RemoveMinimum\|Enqueue\|Dequeue\|Push\|Pop\|Contains\|Add\|Remove\|Set\|Get\|Length\|Neighbors\|EdgeCost\|Heuristic\|Print\|Read\|Swap\|Sort\|Append\|Min\|Max\)\>/

" Logical and comparison operators.
syn keyword psuBoolean true false TRUE FALSE
syn keyword psuConstant NIL NULL null nil
syn keyword psuLogical not and or xor
syn match psuOperator /\(<-\|<=\|>=\|!=\|==\|=\|<\|>\|+\|-\|\*\|\/\|%\)/

" Function calls are highlighted after the built-in list so user-defined calls
" receive the same visual treatment.
syn match psuFunction /\<[A-Za-z_][A-Za-z0-9_]*\>\ze\s*(/

" Literals and delimiters.
syn match psuNumber /\<\d\+\%([.]\d\+\)\?\>/
syn region psuString start=/"/ skip=/\\"/ end=/"/
syn region psuString start=/'/ skip=/\\'/ end=/'/
syn match psuDelimiter /[][(),:;]/

" Comments are defined last so pseudocode keywords inside comments stay plain.
syn match psuComment /\/\/.*$/ contains=NONE
syn match psuComment /#.*/ contains=NONE
syn match psuComment /--.*$/ contains=NONE

hi def link psuDeclaration Statement
hi def link psuDeclarationName Function
hi def link psuBlock Keyword
hi def link psuConditional Conditional
hi def link psuRepeat Repeat
hi def link psuLoopControl Repeat
hi def link psuStatement Statement
hi def link psuBuiltin Function
hi def link psuFunction Function
hi def link psuBoolean Boolean
hi def link psuConstant Constant
hi def link psuLogical Operator
hi def link psuOperator Operator
hi def link psuNumber Number
hi def link psuString String
hi def link psuDelimiter Delimiter
hi def link psuComment Comment

let b:current_syntax = "psu"
