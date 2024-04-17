set $red="\033[0;31m"
set $green="\033[0;32m"
set $yellow="\033[0;33m"
set $blue="\033[0;34m"
set $purple="\033[0;35m"
set $cyan="\033[0;36m"
set $white="\033[0;37m"
set $nc="\033[0m"

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

define show_vector
    # set $vector_addr=$rebase($vector_base)
    set $vector_addr=$arg0
    printf "%s[+] Info of vector at %s0x%016lx%s:\n", $purple, $blue ,$vector_addr, $nc
    printf "%s\tVector Start:\t\t %s0x%016lx%s\n", $green, $nc, *(int64_t *)$vector_addr, $nc
    printf "%s\tVector Content End:\t %s0x%016lx%s\n", $green, $nc, *(int64_t *)($vector_addr + 0x8), $nc
    printf "%s\tVector Space End:\t %s0x%016lx%s\n", $green, $nc, *(int64_t *)($vector_addr + 0x10), $nc
    set $vector_size=(*(int64_t *)($vector_addr + 0x10) - *(int64_t *)($vector_addr))
    printf "%s\tVector Size:\t\t %s0x%016lx%s\n", $green, $nc, $vector_size, $nc
    printf "%s[+] Content in vector%s:\n", $purple, $nc
    set $i=0
    set $vector_start=*(int64_t *)$vector_addr
    while($i < $vector_size)
        printf "\t"
        x /2gx $vector_start+$i
        set $i=$i+0x10
    end
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
