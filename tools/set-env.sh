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

ENV=$(echo "$1" | sed "s/=.*//")
VALUE=$(echo "$1" | sed "s/[^>]*=//")
# escape value for sed
VALUE_FOR_SED=$(echo "$VALUE" | sed -e 's/[\/&]/\\&/g')

case $ENV in
    MASTERNODE)
        if grep "MASTERNODE=" "$BASEDIR/../.env" > /dev/null; then
            TEMP=$(sed "s/MASTERNODE=.*/MASTERNODE=$VALUE_FOR_SED/g" "$BASEDIR/../.env")
            printf "%s" "$TEMP" > "$BASEDIR/../.env"
        else
            printf "MASTERNODE=%s" "$VALUE" >> "$BASEDIR/../.env"
        fi	
    ;;
    TOKEN)
       if grep "TOKEN=" "$BASEDIR/../.env" > /dev/null; then
            TEMP=$(sed "s/TOKEN=.*/TOKEN=$VALUE_FOR_SED/g" "$BASEDIR/../.env")
            printf "%s" "$TEMP" > "$BASEDIR/../.env"
        else
            printf "TOKEN=%s" "$VALUE" >> "$BASEDIR/../.env"
        fi
    ;;
esac
