-- Build with cargo and return the executables it produced.
-- `args` selects what gets built, e.g. { "build", "--bins" } or { "test", "--no-run" }.
local function cargo_artifacts(args, kind)
  local cmd = vim.list_extend({ "cargo" }, args)
  vim.list_extend(cmd, { "--message-format=json" })

  vim.notify("Running: " .. table.concat(cmd, " "), vim.log.levels.INFO, { title = "cargo" })
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify(table.concat(lines, "\n"), vim.log.levels.ERROR, { title = "cargo build failed" })
    return {}
  end

  local exes = {}
  for _, line in ipairs(lines) do
    local ok, msg = pcall(vim.json.decode, line)
    if ok and type(msg) == "table" and msg.reason == "compiler-artifact" and msg.executable then
      if not kind or vim.tbl_contains(msg.target.kind or {}, kind) then
        table.insert(exes, { path = msg.executable, name = msg.target.name })
      end
    end
  end
  return exes
end

-- nvim-dap resolves configs inside a coroutine, so we can block on vim.ui.select.
local function pick(items, prompt)
  if #items == 0 then
    return nil
  end
  if #items == 1 then
    return items[1].path
  end

  local co = coroutine.running()
  vim.ui.select(items, {
    prompt = prompt,
    format_item = function(item)
      return item.name .. "  (" .. vim.fn.fnamemodify(item.path, ":~:.") .. ")"
    end,
  }, function(choice)
    coroutine.resume(co, choice and choice.path or nil)
  end)
  return coroutine.yield()
end

local function cargo_target(args, kind, prompt)
  return function()
    return pick(cargo_artifacts(args, kind), prompt)
  end
end

return {
  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  { "jay-babu/mason-nvim-dap.nvim" },
  { "theHamsta/nvim-dap-virtual-text" },
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      { "<leader>dt", function() require("dap-python").test_method() end, ft = "python", desc = "Debug: Test Method" },
      { "<leader>dT", function() require("dap-python").test_class() end, ft = "python", desc = "Debug: Test Class" },
      { "<leader>ds", function() require("dap-python").debug_selection() end, ft = "python", mode = "v", desc = "Debug: Selection" },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "python" },
        automatic_installation = true,
      })

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Rust gets its own configs: cargo does the build and hands us the exact
      -- binary, and sourceLanguages turns on codelldb's Rust data formatters so
      -- Vec/String/HashMap/Option render as values instead of raw structs.
      local rust_common = {
        type = "codelldb",
        request = "launch",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        sourceLanguages = { "rust" },
      }

      local function rust_config(overrides)
        return vim.tbl_extend("force", vim.deepcopy(rust_common), overrides)
      end

      dap.configurations.rust = {
        rust_config({
          name = "Debug binary (cargo build)",
          program = cargo_target({ "build", "--bins" }, "bin", "Select binary to debug"),
        }),
        rust_config({
          name = "Debug binary with args (cargo build)",
          program = cargo_target({ "build", "--bins" }, "bin", "Select binary to debug"),
          args = function()
            local input = vim.fn.input("Program args: ")
            return vim.split(input, " +", { trimempty = true })
          end,
        }),
        rust_config({
          name = "Debug unit tests (cargo test --no-run)",
          program = cargo_target({ "test", "--no-run" }, nil, "Select test binary to debug"),
          -- Test harnesses swallow output unless you ask them not to.
          args = { "--nocapture" },
        }),
        rust_config({
          name = "Debug example (cargo build --examples)",
          program = cargo_target({ "build", "--examples" }, "example", "Select example to debug"),
        }),
        rust_config({
          name = "Launch (pick executable manually)",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
        }),
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceLanguages = { "rust" },
        },
      }

      -- Python: debugpy runs from Mason's own venv, while the program runs with the
      -- project's interpreter ($VIRTUAL_ENV, else ./.venv), so imports resolve the
      -- same way as `python file.py` in the activated shell.
      local dap_python = require("dap-python")
      dap_python.setup(vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter", { include_configs = false })
      dap_python.test_runner = "pytest"

      local python_common = {
        type = "python",
        request = "launch",
        cwd = "${workspaceFolder}",
        -- runs in the dap-ui console, so input() works
        console = "integratedTerminal",
        justMyCode = true,
      }

      local function python_config(overrides)
        return vim.tbl_extend("force", vim.deepcopy(python_common), overrides)
      end

      dap.configurations.python = {
        python_config({
          name = "Debug file",
          program = "${file}",
        }),
        python_config({
          name = "Debug file with args",
          program = "${file}",
          args = function()
            return require("dap.utils").splitstr(vim.fn.input("Program args: "))
          end,
        }),
        python_config({
          name = "Debug file (step into libraries)",
          program = "${file}",
          justMyCode = false,
        }),
        python_config({
          name = "Debug module (python -m)",
          module = function()
            -- default to the current file as a dotted module path
            return vim.fn.input("Module: ", (vim.fn.expand("%:.:r"):gsub("/", ".")))
          end,
        }),
        python_config({
          name = "Debug pytest (current file)",
          module = "pytest",
          args = { "${file}", "-x" },
        }),
        -- ptrace_scope=1 on this machine, so attaching by PID is not possible.
        -- Start the program with `python -m debugpy --listen 5678 --wait-for-client file.py`.
        {
          name = "Attach (debugpy --listen)",
          type = "python",
          request = "attach",
          connect = function()
            local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
            return { host = "127.0.0.1", port = port }
          end,
          justMyCode = true,
        },
      }

      -- Layout lives here: a bare dapui.setup() would reset it to the defaults.
      -- Element ids are scopes/breakpoints/stacks/watches/repl/console.
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.45 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks",      size = 0.20 },
              { id = "watches",     size = 0.15 },
            },
            size     = 45,
            position = "left",
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size     = 12,
            position = "bottom",
          },
        },
      })
      require("nvim-dap-virtual-text").setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- Close the UI once the last session is gone. terminated/exited alone are
      -- not enough: codelldb doesn't always send them when the session is
      -- killed with <leader>dq, which left the panels open.
      dap.listeners.on_session["dapui_config"] = function(_, new)
        if not new then
          dapui.close()
        end
      end
    end,
  },
}
