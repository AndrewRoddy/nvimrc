" Splunk XML Dashboard syntax — XML structure + embedded SPL queries
if exists("b:current_syntax")
  finish
endif

" Load standard XML syntax
runtime! syntax/xml.vim
unlet! b:current_syntax

" Embed Splunk SPL inside <query> ... </query>
syn include @SplunkSPL <sfile>:p:h/splunk.vim
unlet! b:current_syntax

" splunk.vim sets 'syn case ignore'; restore case-sensitive matching so that
" XML keyword/match patterns (loaded above) continue to work correctly and
" so that the regions defined below are compiled under the right case rules.
syn case match

" SPL inside <query> tags
syn region splunkXMLQuery matchgroup=xmlTag
      \ start="<query>" end="</query>"
      \ contains=@SplunkSPL keepend

" SPL inside <earliest> and <latest> tags (time range fields)
syn region splunkXMLTimeField matchgroup=xmlTag
      \ start="<earliest>" end="</earliest>"
      \ contains=@SplunkSPL keepend
syn region splunkXMLTimeField matchgroup=xmlTag
      \ start="<latest>" end="</latest>"
      \ contains=@SplunkSPL keepend

syn sync fromstart

let b:current_syntax = "splunkxml"
