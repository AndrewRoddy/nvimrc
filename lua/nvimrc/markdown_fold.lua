-- Fold markdown by heading level *and* by indentation. "# Title" opens a level 1
-- fold, "## Sub" a level 2 fold nested inside it, and any line indented past the
-- line above it nests one level deeper again. That way list items, nested
-- bullets and indented code inside a section stay foldable, which the plain
-- foldmethod=indent default gave up on headings to get.
local M = {}

-- foldexpr is called once per line on every redraw, so scanning the buffer for
-- code fences inside it would be O(lines^2). Instead the whole buffer is
-- scanned once and the result cached until the buffer changes.
local cache = {}

-- Width of the leading whitespace, counting a tab as the jump to the next tabstop.
local function indent_width(line, tabstop)
  local width = 0
  for i = 1, #line do
    local char = line:sub(i, i)
    if char == " " then
      width = width + 1
    elseif char == "\t" then
      width = width + tabstop - (width % tabstop)
    else
      break
    end
  end
  return width
end

local function compute(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local tabstop = vim.bo[buf].tabstop

  -- First pass: which lines are headings, and at what level
  local headings = {}
  local fence = nil

  local start = 1
  -- YAML frontmatter: the closing "---" would otherwise read as a setext heading
  if lines[1] == "---" then
    for i = 2, #lines do
      if lines[i] == "---" or lines[i] == "..." then
        start = i + 1
        break
      end
    end
  end

  for i = start, #lines do
    local line = lines[i]
    local ticks = line:match("^ ? ? ?(```+)") or line:match("^ ? ? ?(~~~+)")

    if fence then
      -- Only a fence of the same character closes the block
      if ticks and ticks:sub(1, 1) == fence then
        fence = nil
      end
    elseif ticks then
      fence = ticks:sub(1, 1)
    else
      local hashes = line:match("^ ? ? ?(#+)%s") or line:match("^ ? ? ?(#+)$")
      if hashes and #hashes <= 6 then
        headings[i] = #hashes
      elseif i > start and not headings[i - 1] then
        -- Setext headings: text underlined with === (h1) or --- (h2). Requires a
        -- non-blank line above, which is what separates it from a horizontal rule.
        local prev = lines[i - 1]
        if prev and prev:match("%S") then
          if line:match("^=+%s*$") then
            headings[i - 1] = 1
          elseif line:match("^%-%-+%s*$") then
            headings[i - 1] = 2
          end
        end
      end
    end
  end

  -- Second pass: turn that into a foldexpr value per line
  local exprs = {}
  local section = 0
  -- Indent widths of the enclosing blocks, outermost first. Depth is measured
  -- relative to whatever the file already uses rather than against shiftwidth,
  -- so 2-space list indents nest just as well as 4-space or tab ones.
  local stack = {}

  for i = 1, #lines do
    local line = lines[i]
    if headings[i] then
      section = headings[i]
      stack = {}
      -- ">N" starts a fold at level N, which also closes any deeper folds above it
      exprs[i] = ">" .. section
    elseif not line:match("%S") then
      -- Blank lines take the level of whichever neighbour is shallower, so a gap
      -- between two paragraphs does not chop the fold in half
      exprs[i] = "-1"
    else
      local width = indent_width(line, tabstop)
      while #stack > 0 and width < stack[#stack] do
        table.remove(stack)
      end
      if #stack == 0 or width > stack[#stack] then
        stack[#stack + 1] = width
      end
      exprs[i] = tostring(section + #stack - 1)
    end
  end

  return exprs
end

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local entry = cache[buf]

  if not entry or entry.tick ~= tick then
    entry = { tick = tick, exprs = compute(buf) }
    cache[buf] = entry
  end

  return entry.exprs[vim.v.lnum] or "0"
end

function M.forget(buf)
  cache[buf] = nil
end

return M
