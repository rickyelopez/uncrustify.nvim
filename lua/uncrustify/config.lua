local M = {}

--- @class Config
--- @field uncrustify_bin_path? string Path to use to run uncrustify
--- @field uncrustify_cfg_path? string Path to the uncrustify config file
--- @field filetype_mapping? table Table mapping vim filetypes to uncrustify filetypes
--- @field format_timeout? integer, Timeout when running uncrustify
local config_data = {
  uncrustify_bin_path = "uncrustify",
  uncrustify_cfg_path = vim.env.HOME .. "/.config/uncrustify.cfg",
  filetype_mapping = { c = "c", cpp = "cpp" },
  format_timeout = 3000,
}

--- Return the current configuration
--- @return Config config_data current configuration
M.get_config = function()
  return vim.fn.deepcopy(config_data)
end

--- Apply given config options. Only specified options will be applied
--- @param params Config config options to be set. Any options that are not specified will be left as default
--- @return nil
M.set_config = function(params)
  if not params then
    return
  end

  local apply_opt = function(opt)
    if params[opt] then
      config_data[opt] = vim.fn.deepcopy(params[opt])
    end
  end

  apply_opt("uncrustify_bin")
end

return M
