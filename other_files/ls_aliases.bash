# Alias for the ls, find and du commands

## File Displaying

### Normal

# -A is used instead of -a as it excludes "." and ".."
# "-h" is also given. This has no effect normally, but when "-l" is passed it shows sizes in human readable format
# "-N" means no quotes used around names with spaces

alias l='/usr/bin/ls --group-directories-first --file-type -N -1 -h --color=auto'
alias ls='/usr/bin/ls --group-directories-first --file-type -N -h --color=auto'
alias la='/usr/bin/ls --group-directories-first --file-type -NA -1 -h --color=auto'
alias lsa='/usr/bin/ls --group-directories-first --file-type -NA -h --color=auto'

### Directories Only

alias ld='/usr/bin/ls --group-directories-first -N -1 -h --color=auto -d */ 2> /dev/null'
alias lda='/usr/bin/ls --group-directories-first -N -1 -h --color=auto -d */ .*/ 2> /dev/null'
alias lsd='/usr/bin/ls --group-directories-first -N -h --color=auto -d */ 2> /dev/null'
alias lsda='/usr/bin/ls --group-directories-first -N -h --color=auto -d */ .*/ 2> /dev/null'

### For FAT filesystems, to make it readble

alias lfat='/usr/bin/ls --group-directories-first --file-type -N -1 -h --color=no'
alias lsfat='/usr/bin/ls --group-directories-first --file-type -N -h --color=no'
alias lafat='/usr/bin/ls --group-directories-first --file-type -NA -1 -h --color=no'
alias lsafat='/usr/bin/ls --group-directories-first --file-type -NA -h --color=no'

### Directories Only (FAT)

alias ldfat='/usr/bin/ls --group-directories-first -N -1 -h --color=no -d */ 2> /dev/null'
alias ldafat='/usr/bin/ls --group-directories-first -N -1 -h --color=no -d */ .*/ 2> /dev/null'
alias lsdfat='/usr/bin/ls --group-directories-first -N -h --color=no -d */ 2> /dev/null'
alias lsdafat='/usr/bin/ls --group-directories-first -N -h --color=no -d */ .*/ 2> /dev/null'

## File Counting

### Normal

alias lc='ls | wc -l'
alias lca='ls -A | wc -l'
alias lcd='ls -d */ | wc -l'
alias lcda='ls -d */ .*/ | wc -l'

### Recursive

alias lcr="find . -not -path '*/[@.]*' -type f | wc -l"
alias lcra="find . -type f | wc -l"
alias lcdr="find . -not -path '*/[@.]*' -type d | wc -l"
alias lcdra="find . -type d | wc -l"

## File Sizes

alias ldu='du -Sh --exclude "./.*" | tail -n 1'
alias ldua='du -Sh | tail -n 1'
alias ldur='du -h --exclude "./.*" | tail -n 1'
alias ldura='du -h | tail -n 1'
