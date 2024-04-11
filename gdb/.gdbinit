add-auto-load-safe-path ~/Pwngdb/.gdbinit
source ~/pwndbg/gdbinit.py
set context-clear-screen on
set follow-fork-mode parent
set show-tips off

source ~/Pwngdb/pwngdb.py
source ~/Pwngdb/angelheap/gdbinit.py

define bpie
  b *$rebase($arg0)
  end
define print_libc_address
  libc
  printf "libc+offset: 0x%lx\n", $libc + $arg0
end
define print_offset_to_libc
  libc
  printf "offset: 0x%lx\n", $arg0 - $libc
end

define hook-run
python
import angelheap
angelheap.init_angelheap()
end
end

source ~/splitmind/gdbinit.py
python
import splitmind
(splitmind.Mind()
 .tell_splitter(show_titles=False)
 .right(display="regs", size="36%")
 .below(display="stack", size="59%")
 .above(of="main", display="disasm", size="42%")
 .right(display="backtrace", size="21%")
 .right(of="main", cmd="ipython3", size="30%")
 .show("legend", on="stack")
).build(nobanner=True)
end

set context-stack-lines 20
set context-code-lines 20

