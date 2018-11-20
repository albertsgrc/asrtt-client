#!/usr/bin/env sh
set -x

if [ "$#" -ne 2 ]; then
    echo "Usage: install.sh server-url-without-last-slash user-id"
    exit 1
fi

ATT_EXECUTABLE="https://github.com/albertsgrc/att-client/blob/master/att"

ATT_SHOULD_TRACK_URL="$0/should-track/$1"
ATT_IS_WORKING_URL="$0/is-working/$1"
ATT_STOP_WORKING_URL="$0/stop-working/$1"
ATT_LOG_FILE="/tmp/att.log"

COMMAND="ATT_SHOULD_TRACK_URL=$ATT_SHOULD_TRACK_URL ATT_IS_WORKING_URL=$ATT_IS_WORKING_URL ATT_STOP_WORKING_URL=$ATT_STOP_WORKING_URL ATT_LOG_FILE=$ATT_LOG_FILE /usr/local/bin/att"

if [ "$(uname)" == "Darwin" ]; then
    brew install python3

    cd /usr/local/bin && { curl -O "$ATT_EXECUTABLE" ; cd -; }

    chmod +x /usr/local/bin/att

    cd /tmp && { curl -O -L "https://github.com/albertsgrc/att-client/blob/master/att-macos.zip" ; cd -; }

    unzip /tmp/att-macos.zip -d /tmp/

    sed -i'' -e "s@attCommand@$COMMAND@g" /tmp/att.app/Contents/document.wflow

    mv /tmp/att.app /Applications

    echo "Please add /Applications/att.app to Settings->Security->Accessibility."
    echo "Please add /Applications/att.app to Settings->Users and Groups->Startup items"

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    wget -O /tmp/requirements-att.txt "https://github.com/albertsgrc/att-client/blob/master/requirements.txt"

    sudo apt-get -y update
    sudo apt-get -y install python3.7
    sudo apt-get -y install python3-pip

    pip3 install -r /tmp/requirements-att.txt

    sudo cp $(which python3) /usr/local/bin/python3

    wget -O /usr/local/bin/att "$ATT_EXECUTABLE"

    chmod +x /usr/local/bin/att

    sudo echo "@reboot $COMMAND" > /etc/cron.d/att
fi