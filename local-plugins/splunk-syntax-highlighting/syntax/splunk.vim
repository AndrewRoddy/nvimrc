" Splunk SPL syntax highlighting

if exists("b:current_syntax")
  finish
endif

syn case ignore

" Pipe operator
syn match splunkPipe /|/

" Subsearch brackets
syn region splunkSubsearch matchgroup=splunkBracket start="\[" end="\]" contains=ALL

" ---- Macros (backtick-delimited) ----
" These must be defined BEFORE splunkComment so that splunkComment (defined
" later) has higher priority and wins when it sees three consecutive backticks.
syn region splunkMacro start="`" end="`" contains=splunkMacroArg
syn match splunkMacroArg /[^`]*/ contained

" ---- Comments ----
" Defined AFTER splunkMacro so they have higher priority at the same position.
" Triple-backtick block comments
syn region splunkComment start="```" end="```" contains=NONE
" comment() macro comments
syn region splunkCommentMacro start="`comment(" end=")`" contains=NONE

" ---- Strings ----
syn region splunkString start=/"/ skip=/\\"/ end=/"/ contains=splunkStringEscape
syn region splunkString start=/'/ skip=/\\'/ end=/'/
syn match splunkStringEscape /\\[\\n"']/ contained

" ---- Numbers ----
syn match splunkNumber /\<\d\+\(\.\d\+\)\?\>/

" ---- Booleans and null ----
syn keyword splunkBoolean true false
syn keyword splunkNull null

" ---- Boolean operators ----
syn keyword splunkBoolOp AND OR NOT

" ---- Comparison / arithmetic operators ----
syn match splunkOperator /[=!<>]=\?/
syn match splunkOperator /[+\-*\/%]/

" ---- Relative time expressions ----
" Matches patterns like: -24h@h  +7d  @h  now  -1mon@mon  +0s  -15m@m
syn match splunkTimeExpr /\([+-]\?\d*\)\?\(s\|sec\|secs\|second\|seconds\|m\|min\|mins\|minute\|minutes\|h\|hr\|hrs\|hour\|hours\|d\|day\|days\|w\|week\|weeks\|mon\|month\|months\|q\|qtr\|quarter\|quarters\|y\|yr\|year\|years\)\(@\(s\|sec\|secs\|second\|seconds\|m\|min\|minute\|minutes\|h\|hr\|hour\|hours\|d\|day\|days\|w\|week\|weeks\|mon\|month\|months\|q\|qtr\|quarter\|quarters\|y\|yr\|year\|years\)\)\?\>/
syn keyword splunkTimeExpr now

" ---- Time units (bare, as modifiers / span values) ----
syn keyword splunkTimeUnit
  \ s sec secs second seconds
  \ m min mins minute minutes
  \ h hr hrs hour hours
  \ d day days
  \ w week weeks
  \ mon month months
  \ q qtr quarter quarters
  \ y yr year years

" ============================================================
" ---- Commands ----
" ============================================================
syn keyword splunkCommand
  \ abstract
  \ accum accumulate
  \ addcoltotals addinfo addtotals
  \ analyzefields
  \ anomalies anomalydetection anomalousvalue
  \ append appendcols appendpipe
  \ arules associate audit autoregress
  \ bin bucket bucketdir
  \ chart
  \ cluster
  \ collect concurrency contingency convert
  \ correlate crawl
  \ datamodel dbinspect dbxquery
  \ dedup delete delta diff
  \ erex eval eventcount eventstats extract
  \ fieldformat fields fieldsummary
  \ filldown fillnull findtypes folderize
  \ foreach format
  \ gauge gentimes geom geostats
  \ head highlight history
  \ iconify input inputcsv inputlookup
  \ iplocation
  \ join
  \ kmeans kvform kv
  \ loadjob localize localop logreduce lookup
  \ makecontinuous makeresults makemv map
  \ mcatalog mcollect
  \ metadata metasearch
  \ mstats multikv multisearch
  \ mvcombine mvexpand
  \ noop nomv normalize
  \ outlier outputcsv outputlookup outputtext overlap
  \ pivot predict
  \ rangemap rare regex reltime relevancy rename replace rest
  \ return reverse rex rtorder run
  \ savedsearch script scrub search searchtxn selfjoin
  \ sendalert sendemail sendresults sendsplunk
  \ set setfields sichart sirare sistats sitimechart sitop
  \ sort spath stats strcat streamstats
  \ table tags tail timechart timewrap transaction transpose
  \ trendline typeahead typelearner typer
  \ uniq union untable
  \ walklex where
  \ x11 xmlkv xmlunescape xpath xyseries
  \ from

" ============================================================
" ---- Keywords / clauses ----
" ============================================================
syn keyword splunkKeyword
  \ by as over where output outputnew
  \ groupby limit
  \ delim nullstr keepempty
  \ maxspan maxpause mvlist mvmax mvmin
  \ startswith connected uselookups
  \ case
  \ if then else
  \ in like notin
  \ span
  \ agg
  \ allnum
  \ bins bottom top
  \ cont
  \ fixedrange
  \ minspan
  \ otherstr usenull useother
  \ partial sep
  \ single
  \ truelabel falselabel
  \ splunk_server splunk_server_group
  \ earliest latest
  \ index sourcetype source host
  \ field end start
  \ fillna

" ============================================================
" ---- Eval functions ----
" ============================================================
syn keyword splunkFunction
  \ abs ceiling ceil floor round exp ln log pow sqrt sigfig exact
  \ len lower upper ltrim rtrim trim substr replace split
  \ tostring tonumber
  \ isbool isint isnum isstr isnull isnotnull isnan
  \ coalesce nullif null
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
  \ spath
  \ commands
  \ tonumber tostring
  \ in

" ============================================================
" ---- Statistical / aggregation functions (stats, chart, timechart, eventstats) ----
" ============================================================
syn keyword splunkFunction
  \ avg mean
  \ c count dc distinct_count distinctcount
  \ earliest earliest_time
  \ estdc estdc_error estdcerr
  \ exactperc
  \ first last
  \ latest latest_time
  \ list values
  \ max min
  \ median mode
  \ p perc percentile upperperc
  \ per_day per_hour per_minute per_second
  \ range
  \ sparkline
  \ stdev stdevp
  \ sum sumsq
  \ var varp

" ============================================================
" ---- JSON / multivalue eval functions ----
" ============================================================
syn keyword splunkFunction
  \ json_array json_array_to_mv
  \ json_extract json_extract_exact
  \ json_keys json_object
  \ json_set json_set_exact json_valid
  \ json_append json_delete
  \ json_dict_to_mv json_mv_to_dict
  \ mv_to_json_array json_array_to_mv

" ============================================================
" ---- Type / conversion functions ----
" ============================================================
syn keyword splunkFunction
  \ isbool isint isnum isstr isnull isnotnull isnan
  \ typeof
  \ tostring tonumber
  \ bool num str

" ============================================================
" ---- Geo / IP functions ----
" ----  (iplocation is a command; cidrmatch is eval) ----
" ============================================================
syn keyword splunkFunction
  \ cidrmatch haversine

" ============================================================
" ---- Special / internal fields ----
" ============================================================
syn keyword splunkField
  \ _time _raw _bkt _cd _indextime _kv _serial _si
  \ _sourcetype _subsecond
  \ host index linecount punct source sourcetype
  \ splunk_server splunk_server_group
  \ timeendpos timestartpos
  \ _fullpath _multivalue _tc
  \ date_hour date_mday date_minute date_month date_second
  \ date_wday date_year date_zone

" ============================================================
" ---- Highlight links ----
" ============================================================
hi def link splunkComment        Comment
hi def link splunkCommentMacro   Comment
hi def link splunkPipe           Operator
hi def link splunkBracket        Delimiter
hi def link splunkSubsearch      Normal
hi def link splunkMacro          Special
hi def link splunkMacroArg       Special
hi def link splunkString         String
hi def link splunkStringEscape   SpecialChar
hi def link splunkNumber         Number
hi def link splunkBoolean        Boolean
hi def link splunkNull           Constant
hi def link splunkBoolOp         Keyword
hi def link splunkOperator       Operator
hi def link splunkCommand        Statement
hi def link splunkKeyword        Keyword
hi def link splunkFunction       Function
hi def link splunkField          Identifier
hi def link splunkTimeExpr       PreProc
hi def link splunkTimeUnit       PreProc

let b:current_syntax = "splunk"
