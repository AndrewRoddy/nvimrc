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

" SPL inside <query> tags
syn region splunkXMLQuery matchgroup=xmlTag
      \ start="<query>" end="</query>"
      \ contains=@SplunkSPL

" SPL inside <earliest> and <latest> tags (time range fields)
syn region splunkXMLTimeField matchgroup=xmlTag
      \ start="<earliest>" end="</earliest>"
      \ contains=@SplunkSPL
syn region splunkXMLTimeField matchgroup=xmlTag
      \ start="<latest>" end="</latest>"
      \ contains=@SplunkSPL

syn sync fromstart

let b:current_syntax = "splunkxml"
