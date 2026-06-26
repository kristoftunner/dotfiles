-- Claude Code integration (https://github.com/coder/claudecode.nvim)
--
-- Two launch modes, chosen with :ClaudeMode (or <leader>am) BEFORE the first launch:
--   * "personal" -> plain `claude`            (login with personal account)
--   * "api"      -> ~/.tools/claude-start.sh  (API gateway billing)
--
-- The script just exports the gateway env vars and then execs `claude`, so the
-- plugin's IDE-integration env (SSE port, etc.) is inherited transparently.
--
-- The choice is read once, at load time, to set `terminal_cmd`. Pick the mode
-- before opening Claude; switching afterwards needs a Neovim restart.

local API_SCRIPT = vim.fn.expand("~/.tools/claude-start.sh")
local DEFAULT_MODE = "personal" -- mode used when none was chosen this session

local function cmd_for(mode)
  return mode == "api" and API_SCRIPT or "claude"
end

local function choose_mode()
  vim.ui.select({ "personal", "api" }, {
    prompt = "Claude Code launch mode:",
    format_item = function(item)
      local label = item == "api" and "API gateway (claude-start.sh)" or "Personal account (login)"
      if item == (vim.g.claudecode_mode or DEFAULT_MODE) then
        label = label .. "  [current]"
      end
      return label
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.g.claudecode_mode = choice
    if package.loaded["claudecode"] then
      vim.notify("Claude Code mode set to '" .. choice .. "' — restart Neovim to apply.", vim.log.levels.WARN)
    else
      vim.notify("Claude Code mode: " .. choice, vim.log.levels.INFO)
    end
  end)
end

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    { "<leader>a", nil, desc = "+claude" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code (toggle)" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code (focus)" },
    { "<leader>am", choose_mode, desc = "Claude Code: choose launch mode" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude Code: send selection" },
    { "<leader>aa", "<cmd>ClaudeCodeAdd<cr>", desc = "Claude Code: add current file" },
    { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", desc = "Claude Code: status" },
  },
  -- Defined eagerly so the mode can be chosen WITHOUT loading the plugin first.
  init = function()
    vim.api.nvim_create_user_command("ClaudeMode", choose_mode, {
      desc = "Choose Claude Code launch mode (personal account / API gateway)",
    })
  end,
  -- Evaluated at load time, so it picks up whatever :ClaudeMode set beforehand.
  opts = function()
    return {
      terminal_cmd = cmd_for(vim.g.claudecode_mode or DEFAULT_MODE),
      terminal = {
        split_side = "right",
        split_width_percentage = 0.35,
      },
    }
  end,
}
