" Svelte components are HTML with JavaScript between braces, a <script> block
" that may be TypeScript and a <style> block that may be SCSS, so the runtime
" syntax files are pulled in and the Svelte template syntax is layered on top.

if exists("b:current_syntax")
  finish
endif

" html.vim keys several decisions off main_syntax and only unsets it again when
" it owns the buffer, so claim it here and clean up at the bottom.
if !exists("main_syntax")
  let main_syntax = "svelte"
endif

" html.vim's rendering regions (<a>, <b>, <title>, ...) list their contents
" explicitly, so "{expr}" inside them would go unhighlighted. Skipping them
" leaves the top level free to hold the template syntax everywhere.
let s:had_no_rendering = exists("g:html_no_rendering")
let g:html_no_rendering = 1
runtime! syntax/html.vim
unlet! b:current_syntax
if !s:had_no_rendering
  unlet g:html_no_rendering
endif

syn include @svelteTypeScript syntax/typescript.vim
unlet! b:current_syntax
syn include @svelteScss syntax/scss.vim
unlet! b:current_syntax

syn case match
" Blocks and expressions nest arbitrarily deep, so a partial redraw cannot be
" trusted.
syn sync fromstart

" ---------------------------------------------------------------------------
" <script> and <style>
" ---------------------------------------------------------------------------

" Declared after html.vim's javaScript and cssStyle regions so these win when
" the lang attribute asks for another language.
syn region svelteTypeScript keepend
      \ start=+<script\>\%(\_[^>]\)*\<lang\s*=\s*["']\%(ts\|typescript\)["']\_[^>]*>+
      \ end=+</script\_[^>]*>+me=s-1
      \ contains=@svelteTypeScript,htmlScriptTag,svelteRune,svelteReactive
syn region svelteScss keepend
      \ start=+<style\>\%(\_[^>]\)*\<lang\s*=\s*["']scss["']\_[^>]*>+
      \ end=+</style>+
      \ contains=@svelteScss,htmlTag,htmlEndTag

" Runes ($state, $derived.by, ...) and auto-subscribed stores ($count).
syn match svelteRune /\%(\w\|\$\)\@<!\$\h\w*\%(\.\h\w*\)\=/ contained
syn match svelteReactive /^\s*\zs\$:/ contained
syn cluster htmlJavaScript add=svelteRune,svelteReactive
" TypeScript nests most code inside expression regions rather than leaving it
" at the top level.
syn cluster typescriptExpression add=svelteRune
syn cluster typescriptValue add=svelteRune

" ---------------------------------------------------------------------------
" Expressions
" ---------------------------------------------------------------------------

" {expr}. Object literals and blocks inside an expression get their own brace
" region so the first "}" does not close the expression.
syn region svelteExpression matchgroup=svelteBrace start=/{/ end=/}/
      \ contains=@htmlJavaScript,svelteNestedBrace
syn region svelteNestedBrace contained matchgroup=javaScriptBraces start=/{/ end=/}/
      \ contains=@htmlJavaScript,svelteNestedBrace

" {#if cond} {:else if cond} {#each items as item, i (item.id)} ...
syn region svelteBlock matchgroup=svelteBlockKeyword
      \ start=/{[#:]\%(if\|each\|await\|key\|snippet\|else\%(\s\+if\)\=\|then\|catch\)\>/
      \ end=/}/ contains=@htmlJavaScript,svelteNestedBrace,svelteBlockWord
syn keyword svelteBlockWord contained as then
syn match svelteBlockEnd /{\/\%(if\|each\|await\|key\|snippet\)}/

" {@html x} {@const y = x} {@render children()} ...
syn region svelteTag matchgroup=svelteTagKeyword
      \ start=/{@\%(html\|debug\|const\|render\|attach\)\>/
      \ end=/}/ contains=@htmlJavaScript,svelteNestedBrace

" ---------------------------------------------------------------------------
" Attributes
" ---------------------------------------------------------------------------

" attr={expr}. Starts on the "=" so html.vim's htmlValue does not claim it.
syn region svelteAttrExpression contained matchgroup=svelteBrace start=/=\s*{/ end=/}/
      \ contains=@htmlJavaScript,svelteNestedBrace

" Quoted values may splice in expressions: class="btn {active}".
syn region svelteString contained start=+"+ end=+"+
      \ contains=htmlSpecialChar,svelteExpression
syn region svelteString contained start=+'+ end=+'+
      \ contains=htmlSpecialChar,svelteExpression

" on:click|preventDefault, bind:value, class:active, style:color, use:action.
" The leading whitespace is part of the match so it starts before html.vim's
" htmlArg keywords "class" and "style", which would otherwise win.
syn match svelteDirective contained
      \ /\%(^\|\s\+\)\%(on\|bind\|class\|style\|use\|transition\|in\|out\|animate\|let\):[-a-zA-Z0-9_$.]*\%(|\w\+\)*/
      \ contains=svelteModifier
syn match svelteModifier contained /|\w\+/

syn cluster htmlArgCluster add=svelteAttrExpression,svelteExpression,svelteString,svelteDirective

" ---------------------------------------------------------------------------
" Tag names
" ---------------------------------------------------------------------------

" Components are PascalCase (<Button>, <Icons.Close>) and <svelte:head> has a
" ":" that htmlTagN stops at. Both start on the "<", like htmlTagN, so being
" declared later wins; htmlTagN would otherwise hand <Button> to html.vim's
" case-insensitive "button" keyword.
syn match svelteComponentName contained +<\s*\u[.a-zA-Z0-9_]*+hs=s+1
syn match svelteComponentName contained +</\s*\u[.a-zA-Z0-9_]*+hs=s+2
syn match svelteElementName contained +<\s*svelte:[-a-z]\++hs=s+1
syn match svelteElementName contained +</\s*svelte:[-a-z]\++hs=s+2
syn cluster htmlArgCluster add=svelteComponentName,svelteElementName
" html.vim's htmlEndTag has no cluster to extend.
syn region htmlEndTag start=+</+ end=+>+
      \ contains=htmlTagN,htmlTagError,svelteComponentName,svelteElementName

" ---------------------------------------------------------------------------

hi def link svelteBrace Delimiter
hi def link svelteBlockKeyword Conditional
hi def link svelteBlockWord Conditional
hi def link svelteBlockEnd Conditional
hi def link svelteTagKeyword PreProc
hi def link svelteDirective PreProc
hi def link svelteModifier Special
hi def link svelteRune Special
hi def link svelteReactive Special
hi def link svelteString htmlString
hi def link svelteComponentName Type
hi def link svelteElementName Type

let b:current_syntax = "svelte"

if main_syntax ==# "svelte"
  unlet main_syntax
endif
