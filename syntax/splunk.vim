" Splunk SPL syntax highlighting

if exists("b:current_syntax")
  finish
endif

syn case ignore

" Pipe operator
syn match splunkPipe /|/

" Subsearch brackets
syn region splunkSubsearch matchgroup=splunkBracket start="\[" end="\]" contains=ALL

" Macros (backtick-delimited)
syn region splunkMacro start="`" end="`" contains=splunkMacroArg
syn match splunkMacroArg /[^`]*/ contained

" Strings
syn region splunkString start=/"/ skip=/\\"/ end=/"/ contains=splunkStringEscape
syn region splunkString start=/'/ skip=/\\'/ end=/'/
syn match splunkStringEscape /\\[\\n"']/ contained

" Numbers
syn match splunkNumber /\<\d\+\(\.\d\+\)\?\>/

" Booleans and null
syn keyword splunkBoolean true false
syn keyword splunkNull null

" Boolean operators
syn keyword splunkBoolOp AND OR NOT

" Comparison operators
syn match splunkOperator /[=!<>]=\?/
syn match splunkOperator /[+\-*\/%]/

" ---- Commands ----
syn keyword splunkCommand
  \ search
  \ stats eventstats streamstats
  \ chart timechart sichart sistats sitimechart sitop
  \ eval
  \ table fields
  \ where
  \ sort
  \ dedup
  \ rename
  \ rex
  \ head tail
  \ top rare
  \ join
  \ append appendcols appendpipe
  \ union
  \ transaction
  \ cluster
  \ predict
  \ anomalydetection anomalousvalue
  \ fillnull filldown
  \ foreach
  \ map
  \ sendemail sendalert
  \ outputcsv
  \ outputlookup inputlookup
  \ lookup
  \ rest
  \ dbxquery
  \ gentimes makeresults
  \ multisearch multikv
  \ spath xmlkv xmlunescape xpath
  \ extract kv kvform
  \ logreduce
  \ mstats
  \ pivot
  \ trendline
  \ typeahead
  \ uniq untable
  \ xyseries
  \ iplocation geostats geom
  \ format gauge highlight
  \ history
  \ inputcsv
  \ loadjob
  \ localize localop
  \ metadata metasearch
  \ mvexpand
  \ overlap
  \ regex
  \ replace
  \ return
  \ reverse
  \ run
  \ savedsearch script
  \ selfjoin
  \ set setfields
  \ tag
  \ timewrap
  \ transpose
  \ walklex
  \ bin bucket
  \ from

" ---- Keywords / clauses ----
syn keyword splunkKeyword
  \ by as over where output outputnew
  \ groupby limit
  \ delim nullstr keepempty
  \ maxspan maxpause mvlist
  \ startswith connected uselookups
  \ case
  \ if then else
  \ in like
  \ span
  \ agg
  \ truelabel falselabel

" ---- Eval / statistical functions ----
syn keyword splunkFunction
  \ abs ceiling ceil floor round exp ln log pow sqrt sigfig
  \ len lower upper ltrim rtrim trim substr replace split
  \ tostring tonumber
  \ isbool isint isnum isstr isnull isnotnull isnan
  \ coalesce nullif
  \ mvappend mvcount mvdedup mvfilter mvfind mvindex mvjoin
  \ mvrange mvsort mvzip mvmap
  \ now time strftime strptime relative_time
  \ cosh sinh tanh acos asin atan atan2 cos hypot sin tan pi
  \ exact max min random
  \ urldecode
  \ md5 sha1 sha256 sha512
  \ typeof validate searchmatch match like cidrmatch
  \ printf
  \ if case
  \ count sum avg mean min max
  \ first last values list
  \ dc distinct_count
  \ var varp stdev stdevp
  \ range median mode sumsq
  \ perc percentile upperperc
  \ estdc estdcerr
  \ earliest latest earliest_time latest_time

" ---- Special/internal fields ----
syn keyword splunkField
  \ _time _raw _bkt _cd _indextime _kv _serial _si
  \ _sourcetype _subsecond
  \ host index linecount punct source sourcetype
  \ splunk_server splunk_server_group
  \ timeendpos timestartpos

" Link to standard highlight groups
hi def link splunkPipe       Operator
hi def link splunkBracket    Delimiter
hi def link splunkSubsearch  Normal
hi def link splunkMacro      Special
hi def link splunkMacroArg   Special
hi def link splunkString     String
hi def link splunkStringEscape SpecialChar
hi def link splunkNumber     Number
hi def link splunkBoolean    Boolean
hi def link splunkNull       Constant
hi def link splunkBoolOp     Keyword
hi def link splunkOperator   Operator
hi def link splunkCommand    Statement
hi def link splunkKeyword    Keyword
hi def link splunkFunction   Function
hi def link splunkField      Identifier

let b:current_syntax = "splunk"
