-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Basic config
config.automatically_reload_config = true
config.enable_scroll_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.scrollback_lines = 8848
config.window_padding = {
    left = 20,
    right = 20,
    top = 0,
    bottom = 10
}

-- Spawn window position middle
wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local ratio = 0.6
  local width, height = screen.width * ratio, screen.height * ratio
  local tab, pane, window = wezterm.mux.spawn_window {
    position = {
      x = (screen.width - width) / 2,
      y = (screen.height - height) / 2 - 40,
      origin = 'ActiveScreen' }
  }
  window:gui_window():set_inner_size(width, height)
end)

-- Color scheme and background
config.color_scheme = "Catppuccin Frappe"
config.window_background_opacity = 0.9

-- Font
config.font = wezterm.font_with_fallback({
    "CaskaydiaCove Nerd Font",
    "Cascadia Code"
})
config.font_size = 14

-- shell
config.default_prog = {
    "C:\\Users\\Akashiya\\AppData\\Local\\Programs\\nu\\bin\\nu.exe"
}

-- Tab bar
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- Key bindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- Split pane and move cursor
  { key = "-",  mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "|",  mods = "LEADER|SHIFT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "j",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k",  mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "h",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l",  mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "x",  mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
  -- Tab
  { key = "n",  mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w",  mods = "CTRL", action = act.CloseCurrentTab { confirm = true } },
  -- Toggle Scrollbar
  {
    key = "s",  mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      scrollbar_enabled = not scrollbar_enabled
      window:set_config_overrides({
        enable_scroll_bar = scrollbar_enabled,
      })
    end)
  },
}

-- Mouse bindings
config.mouse_bindings = {
  { -- Drag window with CTRL-MouseLeft
    event = { Drag = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.StartWindowDrag,
  }
}

-- Plugins
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    icons_enabled = true,
    -- theme = 'Catppuccin Frappe',
    theme = 'GruvboxDark',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = {
      {
        'mode',
        padding = 1,
        fmt = function(mode, window)
          if window:leader_is_active() then
            return wezterm.nerdfonts.md_keyboard_outline
          elseif mode == "NORMAL" then
            return wezterm.nerdfonts.cod_terminal
          elseif mode == "COPY" then
            return wezterm.nerdfonts.md_scissors_cutting
          elseif mode == "SEARCH" then
            return wezterm.nerdfonts.oct_search
          end
        end
      },
    },
    -- tabline_b = { 'workspace' },
    tabline_b = {  },
    tabline_c = { ' ' },
    tab_active = {'<', 'index', 'Current >'},
    tab_inactive = { 'index', 'process' },
    tabline_x = {  },
    tabline_y = { 'ram', 'cpu' },
    -- tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'domain' },
  },
  extensions = {},
})

-- and finally, return the configuration to wezterm
return config