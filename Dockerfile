FROM python:3.11-alpine


RUN apk update && \
    apk add --no-cache bash sudo git curl fish nodejs bat exa gitui btop openssh openssh-client-common ripgrep skim fd rustup go build-base cmake \
    libtool pkgconf coreutils unzip gettext-tiny-dev starship shadow perl tree-sitter tree-sitter-cli openssl openssl-dev && \
    apk add --no-cache vivid --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    apk add ---no-cache neovim --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community/ && \
    pip install pynvim


RUN adduser -s /usr/bin/fish -D kron && \
    mkdir -p /etc/sudoers.d && \
    echo "kron ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/kron && \
    chmod 0440 /etc/sudoers.d/kron && \
    cd /home/kron && \
    git config --global --add safe.directory '*' && \
    git clone https://github.com/JMarkin/dotfiles.git . && \
    git submodule update --init --recursive --remote && \
    chown -R kron /home/kron

USER kron
WORKDIR /home/kron

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    cd ~/.pyenv && \
    src/configure && make -C src

