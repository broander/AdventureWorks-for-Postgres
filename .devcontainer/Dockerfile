# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/python-3-anaconda/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/anaconda:0-3

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
# this is failing.......
#ARG NODE_VERSION="none"
#RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends git npm \
    xsel xclip fonts-powerline tmux build-essential cmake vim-nox \
    python3-dev autotools-dev autoconf automake python3-docutils \
    libseccomp-dev libjansson-dev libyaml-dev libxml2-dev fish figlet \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# install firefox
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y firefox-esr \
    && apt-get autoremove -y && apt-get clean -y

# # Create custom user
# in build process vscode user is already created
#ARG USERNAME=vscode
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID

# # Create the user
# RUN groupadd --gid $USER_GID $USERNAME \
#     && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
#     #
#     # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
#     && apt-get update \
#     && apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#     && chmod 0440 /etc/sudoers.d/$USERNAME

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

WORKDIR "/home/vscode"

# copied from the forked repo's docker file
RUN apt-get update
RUN apt-get -y install unzip ruby dos2unix

RUN mkdir /data
COPY install.sql /data/
COPY update_csvs.rb /data/
COPY adventure_works_2014_OLTP_script.zip /data/
RUN cd /data && \
    unzip adventure_works_2014_OLTP_script.zip && \
    rm adventure_works_2014_OLTP_script.zip && \
    ruby update_csvs.rb && \
    rm update_csvs.rb && \
    apt-get autoremove -y && apt-get clean -y

COPY install.sh /docker-entrypoint-initdb.d/
RUN dos2unix /docker-entrypoint-initdb.d/*.sh

# [Optional] Set the default user. Omit if you want to keep the default as root.
# This lets you set the context to be the user for further installation
#USER $USERNAME

# go to the User Home directory
#RUN cd ~
# Install more stuff
