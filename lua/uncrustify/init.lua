local config = require("uncrustify.config")
local config_data = config.get_config()

local M = {}

--- Run uncrustify on the provided string with the provided args
--- @param opts { text: string, args: table } table containing the arguments and text with which to run uncrustify
--- @return { stdout: table, stderr: table }? results returns a table containing stdout and stderr if successful, or nil if there is an error
--- @package
local function run_uncrustify(opts)
  if not opts or not opts.text or not opts.args then
    print("opts must contain `text` and `args`")
    return
  end

  local Job = require("plenary.job")

  local format_job = Job:new({
    command = config_data.uncrustify_bin_path,
    args = opts.args,
    writer = opts.text,
    enable_recording = true,
  })
  local stdout = format_job:sync(config_data.format_timeout)

  return { stdout = stdout, stderr = format_job:stderr_result() }
end

--- Get selected range
--- @return { first: integer, last: integer } range
--- @package
local function get_range()
  local a = vim.fn.getpos("v")[2]
  local b = vim.fn.getpos(".")[2]
  return {
    first = a < b and a or b,
    last = a < b and b or a,
  }
end

--- Format function, formats selected range in visual mode, or the whole file otherwise
--- @return nil
M.format = function()
  local mode = vim.api.nvim_get_mode()
  local args = { "-c", config_data.uncrustify_cfg_path, "-l", config_data.filetype_mapping[vim.bo.filetype] }
  local range = {
    first = 0,
    last = -1,
  }

  if mode.mode == "v" or mode.mode == "V" then
    range = get_range()
    table.insert(args, "--frag")
  end

  local text = table.concat(vim.api.nvim_buf_get_lines(0, range.first, range.last, false), "\n")

  local results = run_uncrustify({ args = args, text = text })
  if not results then
    print("Internal error: No results from format command")
    return
  end

  if results.stdout then
    vim.api.nvim_buf_set_lines(0, range.first, range.last, false, results.stdout)
  else
    print("Formatting error!")
    if results.stderr then
      print(vim.inspect(results.stderr))
    end
  end
end

--- Setup the plugin
--- @param opts? Config plugin options
M.setup = function(opts)
  if opts then
    config.set_config(opts)
    config_data = config.get_config()
  end
end

M.setup()

return M
