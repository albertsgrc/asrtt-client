#!/usr/bin/env bash

set -x

COMMAND="asrtt start"

if [[ "$OSTYPE" == "darwin" ]]; then
    brew install python3

    pip3 install asrtt

    cd /tmp && { curl -O -L "https://github.com/albertsgrc/att-client/raw/master/att-macos.zip" ; cd -; }

    unzip /tmp/att-macos.zip -d /tmp/

    sed -i'' -e "s@asrttCommand@$COMMAND@g" /tmp/att.app/Contents/document.wflow

    rm -rf /Applications/att.app
    mv /tmp/att.app /Applications

    echo "Please add /Applications/att.app to Settings->Security->Accessibility."
    echo "Please add /Applications/att.app to Settings->Users and Groups->Startup items"

elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo apt-get -y update
    sudo apt-get -y install python3.7
    sudo apt-get -y install python3-pip

    pip3 install asrtt

    sudo ln -s $(which python3) /usr/local/bin/python3

    crontab -l | { cat; echo "@reboot $COMMAND"; } | crontab -
fi
