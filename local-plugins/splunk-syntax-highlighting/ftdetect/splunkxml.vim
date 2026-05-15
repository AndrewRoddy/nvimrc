" Detect Splunk dashboard XML files by checking for <dashboard or <form in first 30 lines
au BufNewFile,BufRead *.xml call s:DetectSplunkXML()
function! s:DetectSplunkXML()
  for line in getline(1, 30)
    if line =~# '<dashboard\|<form\b'
      setfiletype splunkxml
      return
    endif
  endfor
endfunction
