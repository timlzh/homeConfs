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

# Install extra plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin

# Install powerlevel10k
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Init gdb
sudo apt update
sudo apt install -y kitty build-essential jq strace ltrace rubygems tmux gcc dnsutils netcat-traditional gcc-multilib net-tools vim gdb gdb-multiarch patchelf zip unzip python3-full ipython3 python-is-python3 python3-pip python3-dev lib32z1 libssl-dev libc6-dev-i386 libffi-dev git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev libc6:i386 libstdc++6:i386 ruby-dev
sudo gem install one_gadget seccomp-tools
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install capstone requests pwntools r2pipe ropper

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

# init kitty
ln -sf ~/.homeConfs/kitty/kitty.conf ~/.config/kitty/kitty.conf

# init tmux
ln -sf ~/.homeConfs/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/.homeConfs/tmux/.tmux.conf.local ~/.tmux.conf.local

# init tmux plugins
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# init gdb
ln -sf ~/.homeConfs/gdb/.gdbinit ~/.gdbinit
if [ -f /tmp/gdbPlugins.zip ]; then
	rm -rf /tmp/gdbPlugins.zip
fi
wget https://file.timlzh.com/gdbPlugins.zip -O /tmp/gdbPlugins.zip
unzip /tmp/gdbPlugins.zip -d ~/
rm -rf /tmp/gdbPlugins.zip

# setup neovim
curl -SsL https://raw.githubusercontent.com/timlzh/tvim/main/initNeovim.sh -o /tmp/tvim.sh
chmod +x /tmp/tvim.sh
/tmp/tvim.sh
