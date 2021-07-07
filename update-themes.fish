#!/usr/local/bin/fish

rm ~/Code/.dotfiles/vim/theme
rm ~/Code/.dotfiles/kitty/theme.conf

if test $DARKMODE -eq "1"
  ln -s ~/Code/.dotfiles/vim/dark-theme ~/Code/.dotfiles/vim/theme
  ln -s ~/Code/.dotfiles/kitty/dark-theme.conf ~/Code/.dotfiles/kitty/theme.conf
else
  ln -s ~/Code/.dotfiles/vim/light-theme ~/Code/.dotfiles/vim/theme
  ln -s ~/Code/.dotfiles/kitty/light-theme.conf ~/Code/.dotfiles/kitty/theme.conf
end

/usr/local/bin/nvr --remote-send ':source ~/Code/.dotfiles/vim/theme<CR>'
/usr/local/bin/kitty  @ --to=unix:/tmp/(ls /tmp/ | grep mykitty)  set-colors --all --configured ~/Code/.dotfiles/kitty/theme.conf 
