if [ -f /etc/os-release ]; then
	# Load the os-release file
	. /etc/os-release

	# Check for some common Linux distributions
	case "$ID" in
	ubuntu)
		echo "Ubuntu detected"
		sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
		;;
	kali)
		echo "Kali detected"
		echo "deb https://mirrors.ustc.edu.cn/kali kali-rolling main non-free non-free-firmware contrib" | sudo tee /etc/apt/sources.list
		echo "deb-src https://mirrors.ustc.edu.cn/kali kali-rolling main non-free non-free-firmware contrib" | sudo tee -a /etc/apt/sources.list
		;;
	*)
		echo "Unknown OS: $ID"
		echo "Supported OS: ubuntu, kali"
		exit 1
		;;
	esac
fi

IS_WSL=false
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
	IS_WSL=true
	WINDOWS_USER_FOLDER=$(wslpath $(cmd.exe /c "echo %USERPROFILE%"))
fi

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install zsh tmux git curl wget -y

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install space vim
# curl -sLf https://spacevim.org/cn/install.sh | bash

# Install Neovim 0.9.5
sudo apt remove neovim
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz -O /tmp/nvim.tar.gz
mkdir -p ~/Documents/Apps
tar xvzf /tmp/nvim.tar.gz -C ~/Documents/Apps
rm -rf /tmp/nvim.tar.gz
ln -sf ~/Documents/Apps/nvim-linux64/bin/nvim ~/.local/bin/nvim

# Install Neovide
if [ $IS_WSL = true ]; then
	# Install Neovide for Windows
	wget https://github.com/neovide/neovide/releases/download/0.12.2/neovide.exe.zip -O /tmp/neovide.zip
	NEOVIDE_PATH=${WINDOWS_USER_FOLDER}/AppData/Local/Programs/neovide
	mkdir -p ${NEOVIDE_PATH}
	unzip /tmp/neovide.zip -d ${NEOVIDE_PATH}
	rm -rf /tmp/neovide.zip
else
	# Install Neovide for Linux
	wget https://github.com/neovide/neovide/releases/download/0.12.2/neovide-linux-x86_64.tar.gz -O /tmp/neovide.tar.gz
	tar xvzf /tmp/neovide.tar.gz -C ~/Documents/Apps
	rm -rf /tmp/neovide.tar.gz
	ln -sf ~/Documents/Apps/neovide ~/.local/bin/neovide
fi

# Install extra plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin

# Install powerlevel10k
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Init gdb
sudo apt update
sudo apt install -y build-essential jq strace ltrace curl wget rubygems tmux gcc dnsutils netcat-traditional gcc-multilib net-tools vim gdb gdb-multiarch patchelf zip unzip python3-full ipython3 python-is-python3 python3-pip python3-dev lib32z1 libssl-dev libc6-dev-i386 libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev libc6:i386 libstdc++6:i386 ruby-dev
sudo gem install one_gadget seccomp-tools
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install capstone requests pwntools r2pipe ropper

# Install Cascadia Code Nerd Font
wget https://github.com/adam7/delugia-code/releases/download/v2111.01.2/delugia-powerline.zip -O /tmp/delugia-powerline.zip
unzip /tmp/delugia-powerline.zip -d ~/.local/share/fonts
mkdir -p ~/.local/share/fonts
fc-cache -f -v

# clone homeConfs
git clone https://git.timlzh.com/timlzh/homeConfs ~/.homeConfs
if [ ! -d ~/.homeconfs ]; then
	echo "Failed to clone homeConfs, try github"
	git clone https://github.com/timlzh/homeConfs ~/.homeConfs
fi
cd ~/.homeConfs

# init zsh
ln -sf ~/.homeConfs/zsh/.zshrc ~/.zshrc
ln -sf ~/.homeConfs/zsh/.p10k.zsh ~/.p10k.zsh
touch ~/.zshrc.local

# init tmux
ln -sf ~/.homeConfs/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/.homeConfs/tmux/.tmux.conf.local ~/.tmux.conf.local

# init neovim
git clone https://github.com/timlzh/tvim ~/.config/nvim

# init neovide
if [ $IS_WSL = true ]; then
	NEOVIDE_CONFIG_PATH=${WINDOWS_USER_FOLDER}/AppData/Roaming/neovide
else
	NOEVIDE_CONFIG_PATH=~/.config/neovide
fi
mkdir -p ${NOEVIDE_CONFIG_PATH}
ln -sf ~/.config/nvim/neovide/config.toml ${NOEVIDE_CONFIG_PATH}/config.toml

# init gdb
ln -sf ~/.homeConfs/gdb/.gdbinit ~/.gdbinit
rm -rf gdbPlugins.zip
wget https://file.timlzh.com/gdbPlugins.zip
unzip gdbPlugins.zip -d ~/
