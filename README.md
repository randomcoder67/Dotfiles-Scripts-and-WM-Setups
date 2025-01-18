# My Dotfiles and Window Manager Setups

## Window Managers

| Name | Folder Name | Type |
| :-: | :-: | :-: |	
| [Xfce 4](info/xfce4.md) | `xfce/` | Lightweight Floating Window Manager and Desktop Environment |
| [i3](info/i3.md) | `i3/` | Manual Tiling Window Manager |
| [GNOME](info/gnome.md) | `gnome/` | Floating Window Manager and Desktop Environment |
| [Awesome](info/awesome.md) | `awesome/` | Automatic Tiling Window Manager |

## General Dotfiles

Most of the configuration files/scripts are not specific to any window manager, so they are stored in a seperate folder and installed seperately (`./setup.sh --make dotfiles`).

For full details about all of my dotfiles and scripts, see [My Dotfiles](https://randomcoder67.github.io/dotfiles/index.html)

## Installation

Choose your desired window manager to see specific details about the install process for it's files

The folliwig are general install instructions:

`./init.sh --install` - Installs all necessary programs  
`./init.sh --setup` - Installs all included scripts and makes necessary directories  
`./init.sh --git-repos` - Installs some of my other git repositories (see below for detail)  

`./setup.sh --make dotfiles` - Moves all dotfiles to the correct location  
	* Some files have different options (reffered to as "substitutions")

## Setup Script/Dotfiles Management

Included in this repos are scripts to help manage the dotfiles (`./setup,sh`, `./substitute.sh`, `./change_text.sh`). 

I don't use symlinks or an inplace git repo to store my dotfiles as I prefer having the git repo in a seperate folder, so these scripts can be used to copy back and forth.

`./setup.sh --initialise` is used to install all of the programs I use, clone and make any other relevant repos (see below), and put all of my scripts in the correct locations.

`./substitute.sh` enables different options to be presented to the user when initialising, for example to choose application shortcuts, different fonts or different colour schemes.

To save the current active config to the repo, run `./setup.sh --save *category*`), where `category` is either `dotfiles` for the general dotfiles, or a specific window manager.

These scrips also remove references to your specific username, and add in the current user's username when initialising.

## Other Repos

`./init.sh --git-repos` installs some other git repositories. Included are:

* [Rust Organisation Utils (mine)](ADDLINK) - These are various small CLI utilities to help organisation
* [Consistent Syntax Highlighting (mine)](ADDLINK) - My attempt at consistent syntax highlighting appearance across various text editors
* [ksuperkey (not mine)](https://github.com/hanschen/ksuperkey) - Remaps Super to Alt+F1 when pressed without another key

## Other Programs I Use

These programs aren't installed by the install script

### Firefox Extensions

* [Video Speed Controller](https://addons.mozilla.org/en-GB/firefox/addon/videospeed/) - Allows video speed control with the keyboard, and on (basically) every site
* [uBlock Origin](https://addons.mozilla.org/en-GB/firefox/addon/ublock-origin/) - The best ad blocker
* [FoxyProxy](https://addons.mozilla.org/en-GB/firefox/addon/foxyproxy-standard/)
* [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/)
* [uBlacklist](https://addons.mozilla.org/en-GB/firefox/addon/ublacklist/) - I use this to block fandom wikis, as there are always the first result before official wiki's like the [Minecraft Wiki](https://minecraft.wiki/) or [Terraria Wiki](https://terraria.wiki.gg/wiki/Terraria_Wiki)

### PKGBUILDs

* [MultiMC](https://github.com/MultiMC/multimc-pkgbuild) - Alternative lightweight Minecraft launcher
* [Cubiomes Viewer](https://aur.archlinux.org/packages/cubiomes-viewer) - Minecraft seed viewer

### Other

* [qimgv](https://github.com/easymodo/qimgv) - Image viewer - Good alternative to Ristretto when not using Xfce
* [Lite XL](https://lite-xl.com/) - GUI text editor/IDE (sort of)
* [Firefox JMBI Theme (Firefox Color link)](https://color.firefox.com/?theme=XQAAAAIYAQAAAAAAAABBqYhm849SCia2CaaEGccwS-xMDPr7eB5S1IAYgPpJmMqoaMV1vHoqGUJf97lZdbcDKNqH0I68EyLfHMR-s5xjAWw7b22vd5BC2-MdrN9xMaJiPOVs8LqhqtItbrjXhgN9Bu9c-khdEvgQxKJEkm6OXQT5vCs3BNlfcSB8xT42ZEczIVMtB0rp5TtWMi_TqGb0t2F_kFJliAgw2j3psR4qDwFv3_9MsKoA)

## Credits

Most of the files here are files I have built up myself, but there are some files which are either fully or partically copied from elsewhere:

* `~/.config/mpv/scripts/oscPeek.lua` - Originally sourced from reddit, although I can't find the post anymore
* `~/.config/mpv/scripts/lockSize.lua` - From [this reddit thread](https://www.reddit.com/r/mpv/comments/ob22cd/any_way_to_stop_automatic_resizing_when_youre/), comment by user "dasgudshit"
* `~/.config/mpv/scripts/osc_tethys.lua` - [GitHub Link](https://github.com/Zren/mpv-osc-tethys), my version is slightly modified, adding in the speed number display and resolution display, and removing thumbnails
* `~/.config/micro/plug/micro-autofmt` - [GitHub Link](https://github.com/a11ce/micro-autofmt/), I only use it for markdown with a custom script
* `~/.config/conky/conky_clock.lua` - [bunsenlabs Link](https://forums.bunsenlabs.org/viewtopic.php?id=6939)
