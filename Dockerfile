FROM alpine:3.17


RUN apk update && \
    apk add --no-cache bash sudo git curl fish nodejs bat exa gitui btop openssh openssh-client-common ripgrep skim fd rustup go build-base cmake \
    libtool pkgconf coreutils unzip gettext-tiny-dev starship shadow perl tree-sitter tree-sitter-cli \
    dpkg-dev dpkg gcc gdbm-dev libc-dev libffi-dev libnsl-dev libtirpc-dev  \
    make ncurses-dev openssl-dev patch util-linux-dev zlib-dev bzip2-dev sqlite-dev xz-dev \
    openssl readline-dev && \
    apk add --no-cache vivid --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    apk add ---no-cache neovim --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community/


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
ENV HOME=/home/kron
WORKDIR $HOME

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set-up necessary Env vars for PyEnv
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

ENV PYTHON_VERSION 3.10.10

# Install pyenv
RUN set -ex \
    && curl https://pyenv.run | bash \
    && pyenv update \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pyenv rehash

VOLUME $HOME
