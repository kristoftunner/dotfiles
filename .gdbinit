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
# TUI: off by default, toggle with Ctrl-X A (Ctrl-L redraws if the program
# output garbles it)
# ---------------------------------------------------------------------------
set tui border-kind acs
set tui compact-source on

# ---------------------------------------------------------------------------
# Breakpoints per program: `sb` saves them, `lb` loads them, and they are
# loaded automatically at the first prompt. Works for both `gdb <app>` and
# `gdb --args <app> <args>`; files live in ~/.cache/gdb/breakpoints, keyed by
# the program's absolute path.
# ---------------------------------------------------------------------------
python
import os

def _bp_file():
    prog = gdb.current_progspace().filename
    if not prog:
        raise gdb.GdbError("no program loaded")
    d = os.path.expanduser("~/.cache/gdb/breakpoints")
    os.makedirs(d, exist_ok=True)
    return os.path.join(d, os.path.abspath(prog).strip("/").replace("/", "%"))

class SaveBreakpoints(gdb.Command):
    """Save this program's breakpoints (loaded again on the next gdb start)."""
    def __init__(self):
        super().__init__("sb", gdb.COMMAND_BREAKPOINTS)
    def invoke(self, arg, from_tty):
        path = _bp_file()
        if not gdb.breakpoints():
            if os.path.exists(path):
                os.remove(path)
            print("No breakpoints; removed saved set.")
            return
        gdb.execute("save breakpoints " + path, to_string=True)
        print("Saved %d breakpoint(s) to %s" % (len(gdb.breakpoints()), path))

class LoadBreakpoints(gdb.Command):
    """Load this program's saved breakpoints."""
    def __init__(self):
        super().__init__("lb", gdb.COMMAND_BREAKPOINTS)
    def invoke(self, arg, from_tty):
        path = _bp_file()
        if not os.path.exists(path):
            print("No saved breakpoints for this program.")
            return
        gdb.execute("source " + path, to_string=True)
        print("Loaded %d breakpoint(s) from %s" % (len(gdb.breakpoints()), path))

SaveBreakpoints()
LoadBreakpoints()

def _autoload_breakpoints():
    gdb.events.before_prompt.disconnect(_autoload_breakpoints)
    if gdb.current_progspace().filename and os.path.exists(_bp_file()):
        gdb.execute("lb")

gdb.events.before_prompt.connect(_autoload_breakpoints)
end
