; extends
; Splunk dashboards keep SPL inside these tags. Only applies to the splunkxml filetype.
((element
  (STag (Name) @_tag)
  (content) @injection.content)
  (#any-of? @_tag "query" "earliest" "latest")
  (#splunkxml? @injection.content)
  (#set! injection.language "splunk")
  (#set! injection.include-children))
