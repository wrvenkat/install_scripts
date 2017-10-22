#!/bin/bash

export ENV_HOME=/opt/webex
export FIREFOX_HOME=$ENV_HOME/firefox-sdk/bin
export MOZ_PLUGIN_PATH=$ENV_HOME/firefox-sdk/bin/browser/plugins
export JAVA_HOME=$ENV_HOME/jre
export PATH=$JAVA_HOME/bin:$PATH

#export JPI_PLUGIN2_DEBUG=1

$FIREFOX_HOME/firefox --new-instance -P
