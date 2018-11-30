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
