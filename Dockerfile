FROM python
WORKDIR ~
RUN apt-get update \
    && apt-get install vim \
    && git clone https:github.com/yakotsar/dotfile.git ~/.dotfile \
    && ln -s ~/.dotfile/.vimrc ~/.vimrc \
    && git clone https:github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle. \
    && apt-get install fonts-powerline
    && vim -c PluginInstall
