; Later patterns win, matching the order of the plugin's old syntax file.
((word) @keyword.directive
  (#match? @keyword.directive "\\c\\v^(abstract|accum|accumulate|addcoltotals|addinfo|addtotals|analyzefields|anomalies|anomalydetection|anomalousvalue|append|appendcols|appendpipe|apply|arules|associate|audit|autoregress|bin|bucket|bucketdir|chart|cluster|collect|concurrency|contingency|convert|correlate|crawl|datamodel|dbinspect|dbxquery|dedup|delete|delta|diff|erex|eval|eventcount|eventstats|extract|fieldformat|fields|fieldsummary|fieldalias|filldown|fillnull|findtypes|folderize|fit|foreach|format|gauge|gentimes|geom|geomfilter|geostats|head|highlight|history|iconify|input|inputcsv|inputlookup|iplocation|join|kmeans|kvform|kv|loadjob|localize|localop|logreduce|lookup|makecontinuous|makeresults|makemv|map|mcatalog|mcollect|metadata|metasearch|mstats|multikv|multisearch|mvcombine|mvexpand|noop|nomv|normalize|outlier|outputcsv|outputlookup|outputtext|overlap|pivot|predict|rangemap|rare|regex|reltime|relevancy|rename|replace|rest|return|reverse|rex|rtorder|run|savedsearch|score|script|scrub|search|searchtxn|selfjoin|sendalert|sendemail|sendresults|sendsplunk|set|setfields|sichart|sirare|sistats|sitimechart|sitop|sort|spath|stats|strcat|streamstats|table|tags|tail|timechart|timewrap|transaction|transpose|trendline|tstats|typeahead|typelearner|typer|uniq|union|untable|walklex|where|x11|xmlkv|xmlunescape|xpath|xyseries|from)$"))

((word) @keyword
  (#match? @keyword "\\c\\v^(by|as|over|output|outputnew|groupby|limit|delim|nullstr|keepempty|maxspan|maxpause|mvlist|mvmax|mvmin|startswith|connected|uselookups|in|like|notin|span|agg|allnum|bins|bottom|top|cont|fixedrange|minspan|otherstr|usenull|useother|partial|sep|single|truelabel|falselabel|field|end|start|fillna)$"))

((word) @function.call
  (#match? @function.call "\\c\\v^(abs|ceiling|ceil|floor|round|exp|ln|log|pow|sqrt|sigfig|exact|len|lower|upper|ltrim|rtrim|trim|substr|replace|split|tostring|tonumber|isbool|isint|isnum|isstr|isnull|isnotnull|isnan|coalesce|nullif|mvappend|mvcount|mvdedup|mvfilter|mvfind|mvindex|mvjoin|mvrange|mvsort|mvzip|mvmap|time|strftime|strptime|relative_time|cosh|sinh|tanh|acos|asin|atan|atan2|cos|hypot|sin|tan|pi|max|min|random|urldecode|md5|sha1|sha256|sha512|typeof|validate|searchmatch|match|cidrmatch|printf|if|case|spath|commands|avg|mean|c|count|dc|distinct_count|distinctcount|earliest|earliest_time|latest|latest_time|estdc|estdc_error|estdcerr|exactperc|first|last|list|values|median|mode|p|perc|percentile|upperperc|per_day|per_hour|per_minute|per_second|range|sparkline|stdev|stdevp|sum|sumsq|var|varp|json_array|json_array_to_mv|json_extract|json_extract_exact|json_keys|json_object|json_set|json_set_exact|json_valid|json_append|json_delete|json_dict_to_mv|json_mv_to_dict|bool|num|str|haversine)$"))

((word) @boolean
  (#match? @boolean "\\c\\v^(true|false)$"))

((word) @constant.builtin
  (#match? @constant.builtin "\\c\\v^(null)$"))

((word) @keyword.operator
  (#match? @keyword.operator "\\c\\v^(AND|OR|NOT)$"))

((word) @variable.builtin
  (#match? @variable.builtin "\\c\\v^(_time|_raw|_bkt|_cd|_indextime|_kv|_serial|_si|_sourcetype|_subsecond|host|index|linecount|punct|source|sourcetype|splunk_server|splunk_server_group|timeendpos|timestartpos|_fullpath|_multivalue|_tc|date_hour|date_mday|date_minute|date_month|date_second|date_wday|date_year|date_zone)$"))

((word) @constant.macro
  (#match? @constant.macro "\\c\\v^(now)$"))

((word) @constant.macro
  (#match? @constant.macro "\\c\\v^(sec|secs|second|seconds|min|mins|minute|minutes|hr|hrs|hour|hours|day|days|week|weeks|mon|month|months|qtr|quarter|quarters|yr|year|years)$"))

(pipe) @operator
(operator) @operator
(bracket) @punctuation.bracket
(macro) @function.macro
(string) @string
(escape_sequence) @string.escape
(number) @number
(time_expression) @constant.macro
(comment) @comment @spell
