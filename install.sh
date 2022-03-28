#!/bin/sh

WINGS_HOME="$HOME/.wings/"
BIN="bin/"
LATEST_VERSION="v0.0.7-alpha"
ARCH=$(uname -m)
OS=$(uname -s)
INSTALLED=""

DEFAULT="\033[0m"
RED="\033[0;31m"
YELLOW='\033[0;33m'
GREEN="\033[0;32m"

case $ARCH in
  "x86_64")
    ARCH="64bit"
    ;;
  "x86")
    ARCH="32bit"
    ;;
  "ARMv6")
    ARCH="arm"
    ;;
  "ARMv8")
    ARCH="arm"
    ;;
  *)
    echo "$RED""ERROR""$DEFAULT"": Unsupported system architechture. Halting installation..."
    exit 1
    ;;
esac

case $OS in
  "Darwin")
    OS="macosx"
    BASH_FILE=".bash_profile"
    ;;
  "Linux")
    OS="linux"
    BASH_FILE=".bashrc"
    ;;
  *)
    echo "$RED""ERROR""$DEFAULT"": Unsupported OS. Halting installation..."
    exit 1
    ;;
esac

download() {
  if [ "$WINGS_DOWNLOAD_ONLY" = "TRUE" ]; then
    WINGS_OUTPUT_FILE="wings"
  else
    WINGS_OUTPUT_FILE="$WINGS_HOME""$LATEST_VERSION""/wings"
  fi

  echo
  echo "Downloading latest version (""$LATEST_VERSION"") of wings..."
  curl -s -L --output "$WINGS_OUTPUT_FILE" "https://github.com/binhonglee/wings/releases/download/""$LATEST_VERSION""/wings_""$ARCH""_""$OS"
  chmod +x "$WINGS_OUTPUT_FILE"
  if [ "$WINGS_DOWNLOAD_ONLY" != "TRUE" ]; then
    cp "$WINGS_OUTPUT_FILE" "$WINGS_HOME""$BIN""wings"
  fi
}

help() {
  echo "Welcome to wings install script!"
  echo
  echo "If you run the script without any option or argument, it will install wings inside the user directory in '.wings/'. However, there are some options it can take as mentioned below."
  echo
  echo "-d Only download the correct binary and do nothing else. when completed, there will be a binary file name 'wings' in the directory of where the script is ran."
  echo "-h Show this menu."
}

while getopts dh opt; do
  case $opt in
    d)
      WINGS_DOWNLOAD_ONLY="TRUE"
      download
      exit
      ;;
    h)
      help
      exit
      ;;
    \?)
      help
      exit 1
      ;;
  esac
done

echo
echo "Creating directories..."
if [ ! -d $WINGS_HOME ]; then
  mkdir "$WINGS_HOME" || INSTALLED="TRUE"
  mkdir "$WINGS_HOME""$BIN"
  mkdir "$WINGS_HOME""$LATEST_VERSION"
else
  INSTALLED="TRUE"
fi

download

echo
echo "Adding PATH info into your rc file..."
if [ "$INSTALLED" = "TRUE" ]; then
  echo "$YELLOW""WARNING""$DEFAULT"": Unable to determine which shell is in use. Please add \`export PATH=\"\$HOME/.wings/bin\":\$PATH\` to your rc file and source it before you continue to use \`wings\`."
  exit
fi

if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
  SHELL_FILE=".zshrc"
elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
  SHELL_FILE="$BASH"
else
  echo "$YELLOW""WARNING""$DEFAULT"": Unable to determine which shell is in use. Please add \`export PATH=\"\$HOME/.wings/bin\":\$PATH\` to your rc file and source it before you continue to use \`wings\`."
  exit
fi

cat <<EOF >> "$HOME/$SHELL_FILE"

# wings
export PATH="$WINGS_HOME$BIN:\$PATH"
EOF

echo "$GREEN""SUCCESS""$DEFAULT"": Download completed successfully. You might need to restart your shell or source ""$SHELL_FILE"" to use wings."
export PATH="$WINGS_HOME$BIN:\$PATH"
