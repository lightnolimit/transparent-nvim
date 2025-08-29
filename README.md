# transparent.nvim

A Neovim plugin that provides true terminal transparency by using terminal colors instead of GUI colors.

## Features

- Complete transparency support for Neovim
- Uses terminal's native color scheme  
- Preserves terminal transparency settings
- Easy toggle between transparent and regular themes
- Minimal and lightweight

## Installation

### Using lazy.nvim

```lua
{
  "lightnolimit/transparent-nvim",
  lazy = false,
  priority = 900,
  config = function()
    require("transparent").setup()
  end,
}
```

### Using packer.nvim

```lua
use {
  "lightnolimit/transparent-nvim",
  config = function()
    require("transparent").setup()
  end
}
```

## Usage

### Commands

- `:TransparentEnable` - Enable transparent theme
- `:TransparentDisable` - Disable transparent theme and restore previous colorscheme
- `:TransparentToggle` - Toggle between transparent and regular themes

### Keymaps

Default keymap (can be customized):
- `<leader>tp` - Toggle transparent theme

## Configuration

```lua
require("transparent").setup({
  -- Auto-enable transparent theme on startup
  auto_enable = false,
  
  -- Groups to make transparent
  groups = {
    "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
    "SignColumn", "EndOfBuffer", "LineNr", "CursorLineNr",
    -- Add more groups as needed
  },
  
  -- Extra groups to make transparent (added to defaults)
  extra_groups = {},
  
  -- Exclude specific groups from transparency
  exclude_groups = {},
})
```

## How It Works

This plugin achieves true transparency by:
1. Disabling `termguicolors` to use terminal colors
2. Clearing GUI color highlights
3. Setting backgrounds to "none" for UI elements
4. Mapping syntax groups to terminal color codes (0-15)

## Terminal Color Mapping

The plugin uses standard ANSI color codes:
- 0-7: Normal colors (black, red, green, yellow, blue, magenta, cyan, white)
- 8-15: Bright colors (bright versions of 0-7)

## License

MIT