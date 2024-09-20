<h3 align="center">
  <img src="./.github/assets/logo.png" width="240" alt="Logo" style="border-radius:16px;"/>
</h3>

## Hyprland

![showcase1](.github/assets/showcase1.png) 
![showcase2](.github/assets/showcase2.png) 
![showcase3](.github/assets/showcase3.png) 

## Information
- **Operating System** • Arch Linux
- **Window Manager/DE** • Hyprland
- **Terminal** • wezterm
- **Shell** • zsh
- **Aur Helper** • yay
- **Panel** • ags
- **Launcher** • ags
- **File Manager** • nautilus
- **Notifications** • ags
- **Wallpaper Daemon** • swww
- **Text Editor** • neovim
- **Colorscheme** • Poimandres 

## ⚙️ Setup
  > [!WARNING]
  > This is a step by step guide for installing my dotfiles which is designed based on Arch Linux (and other Arch-based distributions). If you are running any other system, install the following packages with your respective OS's package manager.

## Installing Hyprland

> [!NOTE]
> Even though I use arch and can build hyprland using yay, I have not done so. I have cloned the main repo from github in my .local/src directory and then compiled Hyprland. 

Now Assuming your aur helper is 'yay', follow the steps below, follow the steps below:

1. Dependencies:
```bash
yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang hyprcursor hyprwayland-scanner xcb-util-errors hyprutils-git
```

> [!WARNING]
> Some Dependencies that you might need 
>- aquamarine
>- hyprlang
>- hyprcursor
>- hyprwayland-scanner (build-only)

2. CMake (recommended)

```bash
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all && sudo make install
```
> [!NOTE]
>For more Information please refer to the official hyprland documentation: [docs](https://wiki.hyprland.org/Getting-Started/Installation/) 

## Setting up my dotfiles.

> Cloning the repository into local system.

```bash
git clone https://github.com/Samar-exe/dotfiles.git
cd dotfiles
```
> Copy the configs to their respective directories. Don't forget to backup your previous configs!!

```bash
cp -r .config/* ~/.config/
```

### Hyprland


