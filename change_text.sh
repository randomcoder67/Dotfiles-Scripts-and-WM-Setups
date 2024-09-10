#!/usr/bin/env bash

og="$1"
replacement="$2"

ORIGINALSTRING="$og"
REPLACEMENTSTRING="$replacement"

ORIGINALSTRING="$ORIGINALSTRING" REPLACEMENTSTRING="$REPLACEMENTSTRING" awk '
    BEGIN {
        old = ENVIRON["ORIGINALSTRING"]
        new = ENVIRON["REPLACEMENTSTRING"]
    }
    s = index($0,old) {
        $0 = substr($0,1,s-1) new substr($0,s+length(old))
    }
    { print }
' /tmp/temp_dotfiles_sub > /tmp/temp_dotfiles_sub_2

mv -f /tmp/temp_dotfiles_sub_2 /tmp/temp_dotfiles_sub
