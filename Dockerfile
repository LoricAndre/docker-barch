FROM blackarchlinux/blackarch:latest
RUN pacman -Syu --noconfirm
RUN pacman -S --needed git sudo make base-devel --noconfirm
RUN useradd -m ba
RUN echo 'ba ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER ba
WORKDIR /home/ba
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay
RUN cd /tmp/yay && makepkg -si --noconfirm
RUN git clone https://github.com/LoricAndre/dotfiles.git
RUN make -C dotfiles -B nvim zsh ranger deps bin
RUN yay -S --noconfirm --needed zsh neovim fzf ripgrep bat lazygit ranger python-neovim bc
RUN sudo chsh ba -s /usr/bin/zsh
COPY ./pkgs.list /tmp/pkgs.list
RUN sudo pacman -S --needed --noconfirm $(cat /tmp/pkgs.list)
ENTRYPOINT ["zsh", "-l"]
