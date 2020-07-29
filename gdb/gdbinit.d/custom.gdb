set print asm-demangle on
set print object on
set print vtbl on
set print array on
set print symbol-filename on
set print sevenbit-strings off

define vo
python
import os
sal = gdb.selected_frame().find_sal()
current_line = sal.line
if current_line != 0:
    theCmd = "vim +"+str(current_line) + " " + sal.symtab.fullname()
    os.system("tmux split-window \"" + theCmd + "\"")
end
end

define eo
python
import os
sal = gdb.selected_frame().find_sal()
current_line = sal.line
if current_line != 0:
    theCmd = "gvim +"+str(current_line) + " " + sal.symtab.fullname()
    os.system("tmux split-window \"" + theCmd + "\"")
end
end

# multiple commands
python
import gdb


class Cmds(gdb.Command):
  """run multiple commands separated by ';'"""
  def __init__(self):
    gdb.Command.__init__(
      self,
      "cmds",
      gdb.COMMAND_DATA,
      gdb.COMPLETE_SYMBOL,
      True,
    )

  def invoke(self, arg, from_tty):
    for fragment in arg.split(';'):
      # from_tty is true. These commands should be considered interactive.
      # to_string is false. We just want to write the output of the commands, not capture it.
      gdb.execute(fragment, from_tty=True, to_string=False)
      print


Cmds()
end
