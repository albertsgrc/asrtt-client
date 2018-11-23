#!/usr/bin/env bash

set -x

if [ "$#" -ne 2 ]; then
    echo "Usage: install.sh server-url-without-last-slash user-id"
    exit 1
fi

ATT_EXECUTABLE="https://raw.githubusercontent.com/albertsgrc/att-client/master/att"
REQUIREMENTS="https://raw.githubusercontent.com/albertsgrc/att-client/master/requirements.txt"

ATT_SHOULD_TRACK_URL="$1/should-track/$2"
ATT_IS_WORKING_URL="$1/is-working/$2"
ATT_STOP_WORKING_URL="$1/stop-working/$2"
ATT_LOG_FILE="/tmp/att.log"

COMMAND="ATT_SHOULD_TRACK_URL=$ATT_SHOULD_TRACK_URL ATT_IS_WORKING_URL=$ATT_IS_WORKING_URL ATT_STOP_WORKING_URL=$ATT_STOP_WORKING_URL ATT_LOG_FILE=$ATT_LOG_FILE /usr/local/bin/att"

if [[ "$OSTYPE" == "darwin" ]]; then
    rm -rf /tmp/att-macos.zip /tmp/att.app /tmp/__MACOSX

    brew install python3

    cd /tmp && { curl -O -L "$REQUIREMENTS" ; cd -; }

    pip3 install -r /tmp/requirements.txt

    cd /usr/local/bin && { curl -O "$ATT_EXECUTABLE" ; cd -; }

    chmod +x /usr/local/bin/att

    cd /tmp && { curl -O -L "https://github.com/albertsgrc/att-client/raw/master/att-macos.zip" ; cd -; }

    unzip /tmp/att-macos.zip -d /tmp/

    sed -i'' -e "s@attCommand@$COMMAND@g" /tmp/att.app/Contents/document.wflow

    rm -rf /Applications/att.app
    mv /tmp/att.app /Applications

    echo "Please add /Applications/att.app to Settings->Security->Accessibility."
    echo "Please add /Applications/att.app to Settings->Users and Groups->Startup items"

elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    wget -O /tmp/requirements-att.txt "$REQUIREMENTS"

    sudo apt-get -y update
    sudo apt-get -y install python3.7
    sudo apt-get -y install python3-pip

    pip3 install -r /tmp/requirements-att.txt

    sudo ln -s $(which python3) /usr/local/bin/python3

    rm -f /usr/local/bin/att

    sudo wget -O /usr/local/bin/att "$ATT_EXECUTABLE"

    sudo chmod +x /usr/local/bin/att

    crontab -l | { cat; echo "@reboot $COMMAND"; } | crontab -
fi
