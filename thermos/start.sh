#!/bin/bash

if [ -z "$SERVER_JARFILE" ]; then
    SERVER_JARFILE="server.jar"
fi

CHK_FILE="/home/container/${SERVER_JARFILE}"

if [ -f $CHK_FILE ]; then
   echo "A ${SERVER_JARFILE} file already exists in this location, not downloading a new one."
else
   echo "Downloading required filed"
   wget https://github.com/CyberdyneCC/Thermos/releases/download/58/Thermos-1.7.10-1614-server.jar -O ${SERVER_JARFILE}
fi

cd /home/container

if [ ! -d "libaries" ]; then
   wget https://github.com/CyberdyneCC/Thermos/releases/download/58/libraries.zip
   unzip libraries.zip
   rm libraries.zip
fi

if [ -z "$STARTUP"  ]; then
    # Output java version to console for debugging purposes if needed.
    java -version

    echo "$ java -jar server.jar"

    # Run the server.
    java -jar ${SERVER_JARFILE}
else
    # Output java version to console for debugging purposes if needed.
    java -version

    # Pass in environment variables.
    MODIFIED_STARTUP=`echo ${STARTUP} | perl -pe 's@\{\{(.*?)\}\}@$ENV{$1}@g'`
    echo "$ java ${MODIFIED_STARTUP}"

    # Run the server.
    java ${MODIFIED_STARTUP}
fi