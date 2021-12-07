FROM archlinux

RUN pacman -Syy && \
      pacman -S --noconfirm curl git neovim python3 lua luajit &&\
      git clone --depth 1 https://github.com/wbthomason/packer.nvim\
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim


