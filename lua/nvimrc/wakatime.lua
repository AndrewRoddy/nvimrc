local M = {}

local function parse_env(path)
  local f = io.open(path, "r")
  if not f then return {} end
  local env = {}
  for line in f:lines() do
    if not line:match("^%s*#") and not line:match("^%s*$") then
      local k, v = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
      if k then
        v = v:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
        env[k] = v
      end
    end
  end
  f:close()
  return env
end

local function read_lines(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local lines = {}
  for line in f:lines() do table.insert(lines, line) end
  f:close()
  return lines
end

local function write_lines(path, lines)
  local f = io.open(path, "w")
  if not f then return end
  f:write(table.concat(lines, "\n") .. "\n")
  f:close()
end

local function upsert_setting(lines, key, value)
  local in_settings = false
  for i, line in ipairs(lines) do
    if line:match("^%[settings%]") then
      in_settings = true
    elseif line:match("^%[") then
      in_settings = false
    elseif in_settings and line:match("^%s*" .. key .. "%s*=") then
      lines[i] = key .. " = " .. value
      return lines
    end
  end
  local settings_idx
  for i, line in ipairs(lines) do
    if line:match("^%[settings%]") then settings_idx = i; break end
  end
  if settings_idx then
    table.insert(lines, settings_idx + 1, key .. " = " .. value)
  else
    table.insert(lines, 1, "[settings]")
    table.insert(lines, 2, key .. " = " .. value)
  end
  return lines
end

function M.setup()
  local env = parse_env(vim.fn.stdpath("config") .. "/.env")
  if not env.WAKATIME_API_KEY or env.WAKATIME_API_KEY == "" then return end
  local cfg_path = vim.fn.expand("~/.wakatime.cfg")
  local lines = read_lines(cfg_path) or { "[settings]" }
  lines = upsert_setting(lines, "api_url", env.WAKATIME_API_URL or "https://wakapi.dev/api")
  lines = upsert_setting(lines, "api_key", env.WAKATIME_API_KEY)
  write_lines(cfg_path, lines)
end

return M
