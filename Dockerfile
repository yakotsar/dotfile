FROM python
WORKDIR ~
RUN apt-get update \
    && apt-get install -y vim \
    && mkdir ~/.dotfile \
    && git clone https://github.com/yakotsar/dotfile.git ~/.dotfile \
    && ln -s ~/.dotfile/.vimrc ~/.vimrc \
    && mkdir -p ~/.vim/bundle/Vundle.vim \
    && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && apt-get install fonts-powerline \
    && vim +PluginInstall +qall
