local M = {}

-- Default configuration
M.config = {
  auto_enable = false,
  groups = {
    "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
    "SignColumn", "EndOfBuffer", "LineNr", "CursorLineNr",
    "Folded", "NonText", "SpecialKey", "VertSplit", "WinSeparator",
    "StatusLine", "StatusLineNC", "TabLine", "TabLineFill", "TabLineSel",
    "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb",
    "DiagnosticSignError", "DiagnosticSignWarn", 
    "DiagnosticSignInfo", "DiagnosticSignHint",
    "GitSignsAdd", "GitSignsChange", "GitSignsDelete",
    "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer",
    "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal",
    "WhichKeyFloat", "LspFloatWinNormal", "LspFloatWinBorder",
  },
  extra_groups = {},
  exclude_groups = {},
}

-- Function to enable transparent/terminal theme
function M.enable()
  -- Save current settings
  vim.g.transparent_previous_colorscheme = vim.g.colors_name
  vim.g.transparent_previous_termguicolors = vim.opt.termguicolors:get()
  
  -- Disable GUI colors to use terminal colors
  vim.opt.termguicolors = false
  
  -- Clear existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  
  -- Combine default groups with extra groups, excluding excluded groups
  local all_groups = vim.tbl_filter(function(group)
    return not vim.tbl_contains(M.config.exclude_groups, group)
  end, vim.tbl_extend("force", M.config.groups, M.config.extra_groups))
  
  -- Set transparent backgrounds for all UI elements
  for _, group in ipairs(all_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
  end
  
  -- Keep some essential highlights visible with terminal colors
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "none", cterm = { underline = true } })
  vim.api.nvim_set_hl(0, "Visual", { cterm = { reverse = true } })
  vim.api.nvim_set_hl(0, "Search", { cterm = { reverse = true } })
  vim.api.nvim_set_hl(0, "IncSearch", { cterm = { reverse = true } })
  
  -- Ensure syntax groups use terminal colors
  vim.api.nvim_set_hl(0, "Comment", { ctermfg = 8 })
  vim.api.nvim_set_hl(0, "String", { ctermfg = 2 })
  vim.api.nvim_set_hl(0, "Number", { ctermfg = 3 })
  vim.api.nvim_set_hl(0, "Function", { ctermfg = 4 })
  vim.api.nvim_set_hl(0, "Keyword", { ctermfg = 5 })
  vim.api.nvim_set_hl(0, "Type", { ctermfg = 6 })
  vim.api.nvim_set_hl(0, "Identifier", { ctermfg = 7 })
  vim.api.nvim_set_hl(0, "Constant", { ctermfg = 1 })
  vim.api.nvim_set_hl(0, "Special", { ctermfg = 13 })
  vim.api.nvim_set_hl(0, "Statement", { ctermfg = 14 })
  vim.api.nvim_set_hl(0, "PreProc", { ctermfg = 12 })
  vim.api.nvim_set_hl(0, "Todo", { ctermfg = 11, cterm = { bold = true } })
  vim.api.nvim_set_hl(0, "Error", { ctermfg = 9, cterm = { bold = true } })
  vim.api.nvim_set_hl(0, "Warning", { ctermfg = 11 })
  
  -- Diagnostic highlights with terminal colors
  vim.api.nvim_set_hl(0, "DiagnosticError", { ctermfg = 9 })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { ctermfg = 11 })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { ctermfg = 12 })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { ctermfg = 14 })
  
  vim.g.transparent_enabled = true
  vim.g.colors_name = "transparent"
end

-- Function to disable transparent theme
function M.disable()
  -- Restore previous termguicolors setting
  if vim.g.transparent_previous_termguicolors ~= nil then
    vim.opt.termguicolors = vim.g.transparent_previous_termguicolors
  else
    vim.opt.termguicolors = true
  end
  
  -- Restore previous colorscheme
  if vim.g.transparent_previous_colorscheme then
    vim.cmd("colorscheme " .. vim.g.transparent_previous_colorscheme)
  else
    -- Fallback to default if no previous theme
    vim.cmd("colorscheme default")
  end
  
  vim.g.transparent_enabled = false
end

-- Toggle function
function M.toggle()
  if vim.g.transparent_enabled then
    M.disable()
    vim.notify("Disabled transparent theme", vim.log.levels.INFO)
  else
    M.enable()
    vim.notify("Enabled transparent theme (using terminal colors)", vim.log.levels.INFO)
  end
end

-- Setup function
function M.setup(opts)
  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  
  -- Create commands
  vim.api.nvim_create_user_command("TransparentEnable", M.enable, {})
  vim.api.nvim_create_user_command("TransparentDisable", M.disable, {})
  vim.api.nvim_create_user_command("TransparentToggle", M.toggle, {})
  
  -- Create default keymap
  vim.keymap.set("n", "<leader>tp", M.toggle, { desc = "Toggle transparent/terminal theme" })
  
  -- Auto-enable if configured
  if M.config.auto_enable then
    M.enable()
  end
end

return M