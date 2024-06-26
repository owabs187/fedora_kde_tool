#!/bin/bash

# This script is liscenced under the 3-Clause BSD License.
#
# Copyright (c) 2024, owabs187
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Function for checking command execution
check_command() {
  if [ $? -eq 0 ]; then
    echo "Command executed successfully"
  else
    echo "Error executing command. Exiting..."
    exit 1
  fi
}

# Function to prompt user with yes/no question
prompt_yes_no() {
  read -p "$1 (y/n): " choice
  case "$choice" in
    [Yy]) return 0 ;;
    [Nn]) return 1 ;;
    *) return 1 ;;
  esac
}

# Debloat KDE (optional)
prompt_yes_no "Do you want to debloat KDE?"
if [ $? -eq 0 ]; then
  echo -e "\nPress enter to debloat KDE"
  read
  sudo dnf remove akregator kamoso mediawriter elisa-player kmag kgpg qt5-qdbusviewer qt6-qdbusviewer kcharselect kcolorchooser dragon kmines kmahjongg kmouth kpat kruler kmousetool kmouth kolourpaint konversation krdc kfind kaddressbook kmail kontact dragon-player krfb korganizer ktnef libreoffice-* kf5-akonadi-* kf6-akonadi-* akonadi-*
  check_command
  echo "KDE debloat completed successfully."
fi

# Install RPM Fusion Repositories (optional)
prompt_yes_no "Do you want to install RPM Fusion Repositories?"
if [ $? -eq 0 ]; then
  echo -e "\nPress enter to install RPM Fusion repositories"
  read
  sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  check_command
  sudo dnf config-manager --enable fedora-cisco-openh264
  check_command
  sudo dnf install rpmfusion-free-release-tainted
  check_command
  sudo dnf groupupdate core
  check_command
  echo "RPM Fusion repositories installed successfully."

  # Install Multimedia Codecs (optional)
  prompt_yes_no "Do you want to install Multimedia Codecs?"
  if [ $? -eq 0 ]; then
    echo -e "\nPress enter to install multimedia codecs"
    read
    sudo dnf swap ffmpeg-free ffmpeg --allowerasing
    check_command
    sudo dnf groupupdate multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
    check_command
    sudo dnf groupupdate sound-and-video
    check_command
    echo "Multimedia codecs installed successfully."
  fi
fi

# Graphics Driver Selection (optional)
prompt_yes_no "Do you want to install enhanced graphics drivers?"
if [ $? -eq 0 ]; then
  read -p "Enter a character (I[intel], A[amd], N[nvidia], or X[none]): " char
  case $char in
    [iI])
      echo "Selected graphics driver: Intel"
      # Install Intel graphics driver (recent SKUs only)
      sudo dnf install intel-media-driver
      check_command
      ;;
    [aA])
      echo "Selected graphics driver: AMD"
      # Install AMD graphics driver
      sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
      check_command
      sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
      check_command
      ;;
    [nN])
      echo "Selected graphics driver: Nvidia"
      # Install Nvidia graphics driver
      sudo dnf install sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs nvidia-vaapi-driver libva-utils vdpauinfo
      check_command
      ;;
    [xX])
      echo "No graphics driver selected"
      ;;
    *)
      echo "Invalid input. Please enter I, A, N, or X."
      ;;
  esac
fi

# Install Development Packages (optional)
prompt_yes_no "Do you want to install development packages?"
if [ $? -eq 0 ]; then
  echo -e "\nPress enter to install development packages"
  read
  sudo dnf install make cmake ccache git git-lfs automake autoconf bison flex gcc gcc-c++ gcc-gfortran gcc-gdc gdb llvm clang lldb lld python3 python3-pip kernel-devel rust cargo nasm golang java-latest-openjdk java-latest-openjdk-devel lua SDL2 SDL2-devel SFML SFML-devel boost boost-devel openblas openblas-devel gmp gmp-devel gmp-c++ mpfr mpfr-devel fmt fmt-devel openssl openssl-libs openssl-devel espeak-ng espeak-ng-devel
  check_command
  echo "Development packages installed successfully."
fi

# Install Homebrew (optional)
prompt_yes_no "Do you want to install Homebrew?"
if [ $? -eq 0 ]; then
  echo -e "\nPress enter to install Homebrew"
  read
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  check_command
  echo "Homebrew installed successfully. (NOTE - You may need to add homebrew to $PATH. Read above log for more information.)"
fi

# Confirm completion
echo -e "\nScript execution completed successfully."
