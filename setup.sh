DOTFILES_DIR=~/.dotfiles
SSH_KEY_PATH=~/.ssh/id_rsa

set -e

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning .dotfiles"
  git clone https://github.com/aguzubiaga/.dotfiles.git $DOTFILES_DIR
fi

function install_package {
  if [ "$(uname)" == "Darwin" ]; then
    brew install "$@"
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sudo apt-get install "$@"
  fi
}

function setup_brew {
  # brew setup
  echo "Downloading and installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function setup_zsh {
  # zsh setup
  echo -e "Installing zsh"
  install_package zsh
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo "Linking zshrc file"
  ln -s $DOTFILES_DIR/zsh/zshrc ~/.zshrc
  echo "Linking zsh prompt"
  ln -s $DOTFILES_DIR/zsh/prompt.zsh .oh-my-zsh/custom/plugins/prompt.zsh
}

function setup_tmux {
  # tmux setup
  echo "Installing tmux"
  install_package tmux
  echo "Linking tmux configuration file"
  ln -s $DOTFILES_DIR/tmux/tmux.conf ~/.tmux.conf
  echo "Installing tmuxinator"
  gem install tmuxinator
}

function setup_nvim {
  # neovim setup
  echo "Installing neovim"

  if [ "$(uname)" == "Darwin" ]; then
    install_package neovim/neovim/neovim
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    install_package neovim
  fi

  echo "Linking neovim configuration"
  ln -s $DOTFILES_DIR/.nvim ~/.config/nvim
}

function setup_node {
  # node setup
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
  echo "Loading nvm"
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  echo "Installing node 7.10.0"
  nvm install 7.10.0
  echo "Installing yarn and react-native-cli"
  npm install -g yarn react-native-cli
}

function setup_ssh {
  # ssh setup
  echo "Generating ssh key"
  ssh-keygen -f $SSH_KEY_PATH -N ""

  echo "\nAdd this key to GitHub (copied to the clipboard)"
  cat $SSH_KEY_PATH.pub
  cat $SSH_KEY_PATH.pub | pbcopy
}

function setup_projects {
  # projects setup
  echo "Creating ~/Projects/pinata"
  mkdir -p ~/Projects/pinata
  cd ~/Projects/pinata

  echo "Cloning projects"
  git clone git@github.com:ForceBrands/api.git
  git clone git@github.com:ForceBrands/immobile.git && cd immobile && yarn && cd ..
  git clone git@github.com:ForceBrands/brand-app.git && cd brand-app && yarn && cd ..
  git clone git@github.com:ForceBrands/core-api.git && cd core-api && bundle install && cd ..
  git clone git@github.com:ForceBrands/notification-service.git && cd notification-service && bundle install && cd ..
  git clone git@github.com:ForceBrands/pinata-admin.git && cd pinata-admin && bundle install && cd ..
  git clone git@github.com:ForceBrands/pinata-ios.git
}

function setup_aws {
  # setup AWS
  install_package awscli
  aws configure
}

function setup_all {
  if [ "$(uname)" == "Darwin" ]; then
    setup_brew
  fi

  setup_zsh
  setup_tmux
  setup_nvim
  setup_node
  setup_ssh
  read -p "Press enter when you have added the key"
  setup_projects
}

echo "Options:"
echo "  - all"
echo "  - brew (do not run on linux)"
echo "  - zsh"
echo "  - tmux"
echo "  - nvim"
echo "  - node"
echo "  - ssh"
echo "  - projects"
echo "  - aws"

echo "Select an option and press enter:"
read option

eval "setup_$option"
