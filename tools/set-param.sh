#!/bin/sh

# PIRL Premium Node docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

BASEDIR=$(dirname "$0")

PARAM=$(echo "$1" | sed "s/=.*//")
VALUE=$(echo "$1" | sed "s/[^>]*=//")
# escape value for sed
VALUE_FOR_SED=$(echo "$VALUE" | sed -e 's/[\/&]/\\&/g')

case $PARAM in
    MARLIN_VERSION)
        if grep "MARLIN_VERSION=" "$BASEDIR/../containers/limits.conf" > /dev/null; then
            TEMP=$(sed "s/MARLIN_VERSION=.*/MARLIN_VERSION=$VALUE_FOR_SED/g" "$BASEDIR/../containers/limits.conf")
            printf "%s" "$TEMP" > "$BASEDIR/../containers/limits.conf"
        else
            printf "MARLIN_VERSION=%s" "$VALUE" >> "$BASEDIR/../containers/limits.conf"
        fi
    ;;
    NODE_VERSION) 
        if grep "NODE_VERSION=" "$BASEDIR/../containers/limits.conf"  > /dev/null; then
            TEMP=$(sed "s/NODE_VERSION=.*/NODE_VERSION=$VALUE_FOR_SED/g" "$BASEDIR/../containers/limits.conf")
            printf "%s" "$TEMP" > "$BASEDIR/../containers/limits.conf"
        else 
            printf "NODE_VERSION=%s" "$VALUE" >> "$BASEDIR/../containers/limits.conf"
        fi
    ;;
    NO_PORTS)
      if [ -f "$BASEDIR/../docker-compose.override.yml" ]; then
        mv "$BASEDIR/../docker-compose.override.yml" "$BASEDIR/../docker-compose.override.yml2"
      fi	
    ;;
    PROJECT)
        printf "PROJECT=%s" "$VALUE" >  "$BASEDIR/../project_id"
    ;;
    ip)
        TEMP=$(sed "s/IP=.*/IP=$VALUE_FOR_SED/g" "$BASEDIR/../.env")
        printf "%s" "$TEMP" > "$BASEDIR/../.env"
    ;;
esac
