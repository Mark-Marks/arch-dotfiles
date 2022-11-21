#!/bin/bash

dopackages=true
doyay=true
doposh=true
doposhconfig=true
donerdfonts=true
dosymlink=true
dotfilespath="~/arch-dotfiles/"

while getopts ":hpyoOnsa:" option do
	case $option in
		h) echo "-h = view script usage\n-p = don't install packages\n-y = don't install yay\n-o = don't install oh-my-posh\n-O = don't configure oh-my-posh \n-n = don't install nerd fonts complete jetbrains\n-s = don't do symlinks\n-a = change the path for my dotfiles"
			exit;;
		p) dopackages=false;;
		y) doyay=false;;
		o) doposh=false;;
		O) doposhconfig=false;;
		n) donerdfonts=false;;
		s) dosymlink=false;;
		a) dotfilespath=$OPTARG;;
	esac
done

if [ "$dopackages" = false ] && [ "$doyay" = false ] && [ "$donerdfonts" = false ] && [ "$doposh" = false ] && [ "$doposhconfig" = false ] && [ "$dosymlink" = false ]
then
	echo "why are you running this script if you don't want it to do anything?"
	exit 1
fi

echo "-- !!started setting up!! --"

cd ~

if [ "$dopackages" = true ]
then
	echo "started installing packages"
	# install wanted packages
	sudo pacman -S --needed zsh wget noto-fonts noto-fonts-emoji git base-devel
	echo "completed installing packages"
fi

if [ "$doyay" = true ]
then
	echo "started installing yay"
	# install yay
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si

	cd ~
	echo "completed installing yay"
fi

if [ "$dopackages" = true ]
then
	echo "started installing yay packages"
	yay -S macchina

	echo "completed installing yay packages"
fi

if [ "$doposh" = true ]
then
	echo "started installing oh-my-posh"
	# install oh-my-posh
	sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
	sudo chmod +x /usr/local/bin/oh-my-posh
	echo "completed installing oh-my-posh"
fi

if [ "$doposhconfig" = true ]
then
	echo "started customizing oh-my-posh"
	# download oh-my-posh themes
	mkdir ~/.poshthemes
	wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
	unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
	chmod u+rw ~/.poshthemes/*.omp.*
	rm ~/.poshthemes/themes.zip
	echo "completed customizing oh-my-posh"
fi

# download & install nerdfont complete jetbrains mono
if [ "$donerdfonts" = true ]
then
	echo "started downloading & installing jetbrains mono"
	mkdir /tmp/fontsInstallation
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip -O /tmp/fontsInstallation/JetBrainsMono.zip
	unzip /tmp/fontsInstallation/JetBrainsMono.zip
	mkdir ~/.local/share/fonts/
	mv /tmp/fontsInstallation/'JetBrains Mono Bold Italic Nerd Font Complete.ttf' ~/.local/share/fonts/
	mv /tmp/fontsInstallation/'JetBrains Mono Bold Nerd Font Complete.ttf' ~/.local/share/fonts/
	mv /tmp/fontsInstallation/'JetBrains Mono Italic Nerd Font Complete.ttf' ~/.local/share/fonts/
	mv /tmp/fontsInstallation/'JetBrains Mono Regular Nerd Font Complete.ttf' ~/.local/share/fonts/
	rm /tmp/fontsInstallation/*
	fc-cache
	echo "completed downloading & installing jetbrains mono"
fi

# start symlinking, yay!
if [ "$dosymlink" = true ]
then
	echo "started symlinking"
	#ln -s ~/arch-dotfiles/.gitconfig ~/.gitconfig
	ln -s ~/arch-dotfiles/.zshrc ~/.zshrc
	ln -s ~/arch-dotfiles/.bashrc ~/.bashrc
	ln -s ~/arch-dotfiles/.bash_profile ~/.bash_profile
	mkdir ~/arch-config/macchina
	mkdir ~/arch-config/macchina/themes
	ln -s ~/arch-dotfiles/macchina.toml ~/.config/macchina/macchina.toml
	ln -s ~/arch-dotfiles/hydromez.toml ~/.config/macchina/themes/hydromez.toml
	ln -s ~/arch-dotfiles/konsole.prof ~/.local/share/konsole/konsole.prof
	echo "completed symlinking"
fi

echo "-- !!completed setting up!! --"
exit 0
