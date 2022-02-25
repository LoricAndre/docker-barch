FROM blackarchlinux/blackarch:latest
RUN echo 'ParallelDownloads = 5' >> /etc/pacman.conf
RUN pacman -Syu --noconfirm
RUN pacman -Sy --needed git sudo make base-devel --noconfirm
RUN useradd -m ba
RUN echo 'ba ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
USER ba
WORKDIR /home/ba
RUN git clone https://github.com/LoricAndre/dotfiles.git
RUN make -C dotfiles -B nvim zsh ranger deps bin
RUN sudo pacman -Sy --noconfirm --needed zsh neovim fzf ripgrep bat lazygit ranger python-neovim bc
RUN sudo chsh ba -s /usr/bin/zsh
RUN zsh $HOME/.zshrc || true
RUN git clone https://github.com/3ndG4me/KaliLists.git
RUN cd KaliLists && gunzip rockyou.txt.gz
COPY ./pkgs.list /tmp/pkgs.list
RUN sudo pacman -Sy --needed --noconfirm $(cat /tmp/pkgs.list)
ENTRYPOINT ["tmux"]
