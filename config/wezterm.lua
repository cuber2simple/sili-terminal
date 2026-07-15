local wezterm = require 'wezterm'
local act = wezterm.action

-- ── Sili: auto-open tabs from ~/.wezterm/tabs.env ──────────────────────────
-- Each non-comment line is  NAME="shell command".  On GUI startup we open one
-- tab per line: the tab title is NAME, and the command runs in an interactive
-- shell so aliases (e.g. cxd) resolve; the shell stays open after it exits.
local function sili_read_tabs(path)
  local entries = {}
  local f = io.open(path, "r")
  if not f then return entries end
  for line in f:lines() do
    local s = line:gsub("^%s+", ""):gsub("%s+$", "")
    if s ~= "" and s:sub(1, 1) ~= "#" then
      local name, val = s:match("^([%w_]+)%s*=%s*(.+)$")
      if name and val then
        val = val:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
        table.insert(entries, { name = name, cmd = val })
      end
    end
  end
  f:close()
  return entries
end

wezterm.on("gui-startup", function(cmd)
  local mux = wezterm.mux
  -- If wezterm was launched with an explicit command, honor it and skip tabs.
  if cmd then
    mux.spawn_window(cmd)
    return
  end
  local shell = os.getenv("SHELL") or "/bin/zsh"
  local entries = sili_read_tabs(wezterm.home_dir .. "/.wezterm/tabs.env")
  if #entries == 0 then
    mux.spawn_window({})
    return
  end
  local function args_for(entry)
    return { shell, "-i", "-c", entry.cmd .. "; exec " .. shell .. " -i" }
  end
  local first_tab, _, window = mux.spawn_window({ args = args_for(entries[1]) })
  first_tab:set_title(entries[1].name)
  for i = 2, #entries do
    local t = window:spawn_tab({ args = args_for(entries[i]) })
    t:set_title(entries[i].name)
  end
end)
-- ───────────────────────────────────────────────────────────────────────────

return {
  font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "Symbols Nerd Font Mono"
  }),

  font_size = 14.0,
  line_height = 1.1,

  color_scheme = "Catppuccin Mocha",

  -- Hide tab bar (Zellij has its own)
  enable_tab_bar = false,

  window_background_opacity = 0.92,
  macos_window_background_blur = 30,

  scrollback_lines = 10000,
  default_cursor_style = "BlinkingBlock",

  -- Let Alt keys pass through to terminal apps
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,

  window_decorations = "TITLE | RESIZE",
  window_close_confirmation = "NeverPrompt",
  window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
  },

  keys = {
    -- Fullscreen
    { key = "Enter", mods = "CMD", action = act.ToggleFullScreen },

    -- Copy/Paste
    { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },

    -- Font size
    { key = "=", mods = "CMD", action = act.IncreaseFontSize },
    { key = "-", mods = "CMD", action = act.DecreaseFontSize },
    { key = "0", mods = "CMD", action = act.ResetFontSize },

  },

  -- Select to copy
  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = act.CompleteSelection("ClipboardAndPrimarySelection"),
    },
  },
}
