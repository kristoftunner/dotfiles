# Debugging cheat sheet (nvim-dap)

C++ uses **codelldb**, Python uses **debugpy**. Same keys and UI for both.

## Setup (once)

- Debuggers come from Mason (`:Mason`): `codelldb`, `debugpy`. Missing ones install the first time dap loads, or run `:MasonInstall debugpy`.
  - Mason's pip goes through Artifactory, so you need the VPN.
- **C++**: build with debug info (`-g`, Debug/RelWithDebInfo).
- **Python**: start nvim with the venv active, or have a `./.venv`. The program runs with that interpreter.
  - Test debugging needs `pytest` **inside** the venv (`uv add --dev pytest`) and the treesitter python parser (`:TSInstall python`).
- Start nvim from the **project root**: `${workspaceFolder}` and `.vscode/launch.json` resolve from `:pwd`.

## Start

1. `<leader>db` on a line to set a breakpoint.
2. `<F5>` and pick a configuration. dap-ui opens on start and closes on exit.
3. `<leader>dl` re-runs the last configuration without the picker.

## Keys

| Key | Action |
|---|---|
| `<F5>` | Start / continue |
| `<F10>` `<F11>` `<F12>` | Step over / into / out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Run to cursor |
| `<leader>dl` | Run last config |
| `<leader>de` | Eval word under cursor (visual: selection) |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle dap-ui |
| `<leader>dq` | Terminate |
| `<leader>dt` | *Python:* debug test method under cursor |
| `<leader>dT` | *Python:* debug test class under cursor |
| `<leader>ds` | *Python, visual:* debug selection |

## Built-in configurations (`lua/plugins/dap.lua`)

**C / C++**
- *Launch*: asks for the executable path.

**Python** (output/`input()` in the dap-ui console)
- *Debug file*: the current file, like `python file.py`.
- *Debug file with args*: asks for arguments.
- *Debug file (step into libraries)*: `justMyCode = false`.
- *Debug module*: `python -m <module>`, pre-filled from the current file.
- *Debug pytest (current file)*: `pytest <file> -x`.
- *Attach (debugpy --listen)*: run `python -m debugpy --listen 5678 --wait-for-client file.py`, then attach.
  - No attaching by PID: `ptrace_scope=1`.

Rust has its own cargo-based configs (binary, tests, examples, attach).

## Per-project configs: `.vscode/launch.json`

- Read from `<cwd>/.vscode/launch.json` on every `<F5>` and listed next to the built-in ones.
- Same format as VS Code (comments, `${file}`, `${workspaceFolder}`, `${env:VAR}`).
- `"type"` must be an adapter defined in nvim:
  - C++: `"codelldb"`.
  - Python: `"debugpy"` or `"python"` (venv picked up automatically).

```jsonc
{
  "configurations": [
    {
      "type": "codelldb", "request": "launch", "name": "my_app",
      "program": "${workspaceFolder}/build/my_app",
      "args": ["--flag"], "cwd": "${workspaceFolder}"
    },
    {
      "type": "debugpy", "request": "launch", "name": "script",
      "program": "${file}", "console": "integratedTerminal", "justMyCode": true
    }
  ]
}
```
