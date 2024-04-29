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

# Install Neovim 0.9.5
sudo apt remove neovim
if [ -f /tmp/nvim.tar.gz ]; then
	rm -rf /tmp/nvim.tar.gz
fi
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz -O /tmp/nvim.tar.gz
mkdir -p ~/Documents/Apps
tar xvzf /tmp/nvim.tar.gz -C ~/Documents/Apps
rm -rf /tmp/nvim.tar.gz
ln -sf ~/Documents/Apps/nvim-linux64/bin/nvim ~/.local/bin/nvim

# Install Neovide
if [ $IS_WSL = true ]; then
	# Install Neovide for Windows
	if [ -f /tmp/neovide.zip ]; then
		rm -rf /tmp/neovide.zip
	fi
	wget https://github.com/neovide/neovide/releases/download/0.12.2/neovide.exe.zip -O /tmp/neovide.zip
	NEOVIDE_PATH=${WINDOWS_USER_FOLDER}/AppData/Local/Programs/neovide
	mkdir -p ${NEOVIDE_PATH}
	unzip /tmp/neovide.zip -d ${NEOVIDE_PATH}
	rm -rf /tmp/neovide.zip
else
	# Install Neovide for Linux
	if [ -f /tmp/neovide.tar.gz ]; then
		rm -rf /tmp/neovide.tar.gz
	fi
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
sudo apt install -y build-essential jq strace ltrace rubygems tmux gcc dnsutils netcat-traditional gcc-multilib net-tools vim gdb gdb-multiarch patchelf zip unzip python3-full ipython3 python-is-python3 python3-pip python3-dev lib32z1 libssl-dev libc6-dev-i386 libffi-dev git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev libc6:i386 libstdc++6:i386 ruby-dev
sudo gem install one_gadget seccomp-tools
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install capstone requests pwntools r2pipe ropper

# Download Sarasa Nerd Font
style="mono"
orthography="sc"
sarasaFontFileName="sarasa-${style}-${orthography}-nerd-font.zip"
pattern="sarasa-${style}-${orthography}-*-nerd-font.ttf"
fontDir="$HOME/.local/share/fonts"

rm -f "/tmp/${sarasaFontFileName}"

curl -fsSL "https://api.github.com/repos/jonz94/Sarasa-Gothic-Nerd-Fonts/releases/latest" |
	grep "browser_download_url.*${sarasaFontFileName}" |
	head -n 1 |
	cut -d '"' -f 4 |
	xargs curl -fL -o "/tmp/${sarasaFontFileName}"

# Download Cascadia Code Nerd Font
url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip"
rm -f "/tmp/CascadiaCode.zip"
wget $url -O "/tmp/CascadiaCode.zip"

if [ $IS_WSL = false ]; then
	# Install the fonts
	unzip -d /tmp "/tmp/${sarasaFontFileName}"

	find -L /tmp -name $pattern 2>/dev/null | cut -d '/' -f 3 | xargs -I {} rm -f ${fontDir}/{}
	mkdir -p $fontDir
	find -L /tmp -name $pattern 2>/dev/null | xargs -I {} mv {} ${fontDir}/

	unzip -d ${fontDir} "/tmp/CascadiaCode.zip"

	rm -r /tmp/*.zip
	rm -r /tmp/*.ttf
	fc-cache -r

	# install kitty
	sudo apt install -y kitty

	# if gnome, change terminal to kitty
	if [ -n "$DESKTOP_SESSION" ]; then
		if [ "$DESKTOP_SESSION" = "gnome" ]; then
			gsettings set org.gnome.desktop.default-applications.terminal exec kitty
		fi
	fi
else
	echo "WSL detected, skip font installation. Only download the font file. You need to install the font manually."
	mkdir -p ${WINDOWS_USER_FOLDER}/Documents/Fonts/Sarasa
	unzip -d ${WINDOWS_USER_FOLDER}/Documents/Fonts/Sarasa "/tmp/${sarasaFontFileName}"
	mkdir -p ${WINDOWS_USER_FOLDER}/Documents/Fonts/CascadiaCode
	unzip -d ${WINDOWS_USER_FOLDER}/Documents/Fonts/CascadiaCode "/tmp/CascadiaCode.zip"
	rm -f /tmp/*.zip
	explorer.exe ${WINDOWS_USER_FOLDER}/Documents/Fonts
fi

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

# init neovim
mv ~/.config/nvim ~/.config/nvim.bak
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
if [ -f /tmp/gdbPlugins.zip ]; then
	rm -rf /tmp/gdbPlugins.zip
fi
wget https://file.timlzh.com/gdbPlugins.zip -O /tmp/gdbPlugins.zip
unzip /tmp/gdbPlugins.zip -d ~/
rm -rf /tmp/gdbPlugins.zip
