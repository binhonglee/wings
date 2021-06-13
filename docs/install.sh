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

echo
echo "Creating directories..."
if [ ! -d $WINGS_HOME ]; then
  mkdir "$WINGS_HOME" || INSTALLED="TRUE"
  mkdir "$WINGS_HOME""$BIN"
  mkdir "$WINGS_HOME""$LATEST_VERSION"
else
  INSTALLED="TRUE"
fi

echo
echo "Downloading latest version (""$LATEST_VERSION"") of wings..."
curl -s -L --output "$WINGS_HOME""$LATEST_VERSION""/wings" "https://github.com/binhonglee/wings/releases/download/""$LATEST_VERSION""/wings_""$ARCH""_""$OS"
chmod +x "$WINGS_HOME""$LATEST_VERSION""/wings"
cp "$WINGS_HOME""$LATEST_VERSION""/wings" "$WINGS_HOME""$BIN""wings"

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
