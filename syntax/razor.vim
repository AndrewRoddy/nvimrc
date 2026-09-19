" Razor is HTML with C# spliced in at every "@" transition, so both runtime
" syntax files are pulled in and the transitions are layered on top.

if exists("b:current_syntax")
  finish
endif

" html.vim keys several decisions off main_syntax and only unsets it again when
" it owns the buffer, so claim it here and clean up at the bottom.
if !exists("main_syntax")
  let main_syntax = "razor"
endif

runtime! syntax/html.vim
unlet! b:current_syntax

" Loaded after html.vim on purpose: when two items match at the same column the
" later definition wins, so C# beats HTML inside the "@" blocks below. The tags
" that may appear inside those blocks are re-declared further down to win back.
syn include @razorCSharp syntax/cs.vim
unlet! b:current_syntax

syn case match
" Razor blocks nest arbitrarily deep, so a partial redraw cannot be trusted.
syn sync fromstart

" ---------------------------------------------------------------------------
" Markup inside a C# block
" ---------------------------------------------------------------------------

" Mirrors html.vim's htmlTag/htmlEndTag, contained so it only applies inside
" razor blocks. Without it cs.vim's generic-argument rule claims the "<".
syn region razorTag contained start=+<[^/!?[:space:]]+ end=+>+ keepend
      \ contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,
      \ htmlCssDefinition,@htmlPreproc,@htmlArgCluster
syn region razorEndTag contained start=+</+ end=+>+ keepend
      \ contains=htmlTagN,htmlTagError

" Blazor components are PascalCase and so miss html.vim's tag-name keywords.
syn match razorComponentName contained /\<\u\w*\>/
syn cluster htmlTagNameCluster add=razorComponentName

" ---------------------------------------------------------------------------
" Transitions into C#
" ---------------------------------------------------------------------------

syn match razorAt contained /@/

" Implicit expression: @name, @item.Title, @Html.Raw(x), @items[0].
" The lookbehind keeps email addresses and the like out of it.
syn match razorExpression
      \ /\w\@<!@\h\w*\%(\.\h\w*\|(\%([^()]\|([^()]*)\)*)\|\[[^][]*\]\)*/
      \ contains=razorAt,@razorCSharp

" Directive attributes: @onclick, @bind-Value, @ref, @key. Declared after
" razorExpression so the "@" of an attribute is not read as an expression.
syn match razorAttribute contained /\w\@<!@\h[-:.a-zA-Z0-9_]*/
syn cluster htmlArgCluster add=razorAttribute

" Explicit expression: @(a + b). csBracketed balances the inner parentheses.
syn region razorExplicitExpression matchgroup=razorDelimiter start=/@(/ end=/)/
      \ keepend contains=@razorCSharp,csBracketed

" @: writes the rest of the line out as markup.
syn region razorLineMarkup contained matchgroup=razorDelimiter start=/@:/ end=/$/
      \ contains=@htmlTop,@razorTransition

syn match razorEscapedAt /@@/
syn region razorComment start=/@\*/ end=/\*@/ keepend contains=@Spell

" ---------------------------------------------------------------------------
" C# blocks
" ---------------------------------------------------------------------------

" Statement blocks may drop back into markup; member blocks may not, so they
" get separate contents.
syn cluster razorTransition contains=razorExpression,razorExplicitExpression,
      \ razorEscapedAt,razorComment,razorLineMarkup
syn cluster razorStatement contains=@razorCSharp,razorNestedBrace,razorNestedParen,
      \ razorTag,razorEndTag,htmlComment,htmlSpecialChar,@razorTransition,
      \ razorConditional,razorRepeat,razorException
syn cluster razorMember contains=@razorCSharp,csBraced,csBracketed,razorComment

syn region razorNestedBrace contained matchgroup=razorBrace start=/{/ end=/}/
      \ contains=@razorStatement
" Stands in for cs.vim's csBracketed, which balances parentheses but would hide
" any "@" transition written between them.
syn region razorNestedParen contained matchgroup=razorParen start=/(/ end=/)/
      \ contains=@razorStatement

" @{ ... }
syn region razorStatementBlock matchgroup=razorDelimiter start=/@{/ end=/}/
      \ contains=@razorStatement

" @code { ... } and @functions { ... }
syn match razorCodeKeyword /\w\@<!@\%(code\|functions\)\>/
      \ nextgroup=razorMemberBlock skipwhite skipempty
syn region razorMemberBlock contained matchgroup=razorDelimiter start=/{/ end=/}/
      \ contains=@razorMember

" ---------------------------------------------------------------------------
" Control flow
" ---------------------------------------------------------------------------

syn match razorConditional /\w\@<!@\%(if\|switch\)\>/
      \ nextgroup=razorCondition skipwhite skipempty
syn match razorRepeat /\w\@<!@\%(foreach\|for\|while\|do\)\>/
      \ nextgroup=razorCondition,razorControlBody skipwhite skipempty
syn match razorException /\w\@<!@\%(try\|lock\)\>/
      \ nextgroup=razorCondition,razorControlBody skipwhite skipempty

syn region razorCondition contained matchgroup=razorParen start=/(/ end=/)/
      \ keepend contains=@razorCSharp,csBracketed
      \ nextgroup=razorControlBody skipwhite skipempty

" The continuation keywords carry no "@" of their own, so they are picked up
" from the block they follow.
syn region razorControlBody contained matchgroup=razorDelimiter start=/{/ end=/}/
      \ contains=@razorStatement
      \ nextgroup=razorElse,razorCatch,razorWhileTail skipwhite skipempty

syn match razorElse contained /\<else\%(\s\+if\)\=\>/
      \ nextgroup=razorCondition,razorControlBody skipwhite skipempty
syn match razorCatch contained /\<\%(catch\|finally\)\>/
      \ nextgroup=razorCondition,razorControlBody skipwhite skipempty
syn match razorWhileTail contained /\<while\>/
      \ nextgroup=razorCondition skipwhite skipempty

" ---------------------------------------------------------------------------
" Directives
" ---------------------------------------------------------------------------

syn region razorDirective matchgroup=razorDirectiveName oneline keepend
      \ start=/^\s*\zs@\%(page\|using\|inject\|inherits\|implements\|layout\|namespace\|model\|attribute\|typeparam\|rendermode\|preservewhitespace\|addTagHelper\|removeTagHelper\|tagHelperPrefix\)\>/
      \ end=/$/ contains=@razorCSharp,csBracketed

syn match razorDirectiveName /^\s*\zs@section\>/
      \ nextgroup=razorSectionName skipwhite
syn match razorSectionName contained /\h\w*/
      \ nextgroup=razorControlBody skipwhite skipempty

" ---------------------------------------------------------------------------

" Razor expressions are legal wherever html.vim allows a preprocessor, which
" covers attribute values, <script> and <style>.
syn cluster htmlPreproc add=@razorTransition

hi def link razorAt PreProc
hi def link razorDelimiter PreProc
hi def link razorDirectiveName PreProc
hi def link razorCodeKeyword PreProc
hi def link razorEscapedAt SpecialChar
hi def link razorAttribute PreProc
hi def link razorComment Comment
hi def link razorExpression Identifier
hi def link razorSectionName Function
hi def link razorComponentName Type
hi def link razorBrace Delimiter
hi def link razorParen Delimiter
hi def link razorConditional Conditional
hi def link razorElse Conditional
hi def link razorRepeat Repeat
hi def link razorWhileTail Repeat
hi def link razorException Exception
hi def link razorCatch Exception
hi def link razorTag htmlTag
hi def link razorEndTag htmlEndTag

let b:current_syntax = "razor"

if main_syntax ==# "razor"
  unlet main_syntax
endif
