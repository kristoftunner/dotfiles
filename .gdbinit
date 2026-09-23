# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
set history save on
set history filename ~/.gdb_history
set history size 10000
set history remove-duplicates 100

# ---------------------------------------------------------------------------
# Printing
# NOTE: gdb only recognises `#` comments at the start of a line, never after
# a command, so keep these lines bare.
# ---------------------------------------------------------------------------
# indent structs/classes over multiple lines
set print pretty on
# show the real (derived) type behind a base pointer/reference
set print object on
set print vtbl on
# less noise when dumping C++ objects
set print static-members off
set print array-indexes on
set print asm-demangle on
set print frame-arguments scalars
set disassembly-flavor intel

# ---------------------------------------------------------------------------
# Behaviour
# ---------------------------------------------------------------------------
# no "are you sure?" on delete/quit
set confirm off
# no "---Type <return> to continue---" pager
set pagination off
set startup-quietly on
set backtrace past-main off
set follow-fork-mode parent

# ---------------------------------------------------------------------------
# Debugger keys live in ~/.inputrc (readline), not here -- see the `$if gdb`
# block there: Alt-n step over, Alt-s step into, Alt-o step out, Alt-c
# continue, Alt-k kill, Alt-w focus next window, Alt-l next layout.
# gdb's own built-ins: Ctrl-X O focus next window, Ctrl-X A toggle the TUI,
# Ctrl-L redraw, and Ctrl-X S for SingleKey mode (bare n/s/f/c/u/d/r keys).
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# TUI: source window on top, command window below
# ---------------------------------------------------------------------------
set tui border-kind acs
set tui compact-source on

# Only enable the TUI on a real terminal, so `gdb -batch ...` and piped
# invocations keep working.
python
import os
try:
    # gdb replaces sys.stdout, whose isatty() always claims True, so ask the
    # real file descriptor instead.
    if os.isatty(1):
        gdb.execute("tui enable")
        gdb.execute("layout src")
        gdb.execute("focus cmd")
except gdb.error as e:
    print("gdbinit: could not enable TUI: %s" % e)
end

# The TUI source window goes stale when the inferior writes to the terminal;
# force a redraw after the commands that move the current line.
define hook-next
  refresh
end
define hook-step
  refresh
end
define hook-finish
  refresh
end
define hook-continue
  refresh
end
define hook-up
  refresh
end
define hook-down
  refresh
end
