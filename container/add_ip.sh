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

if grep "IP=" "/home/pirl/.env"; then 
        IP=$(grep "IP=" "/home/pirl/.env" | sed "s/[^>]*=//")
        INTERFACE=$(ls /sys/class/net | grep -v lo | head -n1)
        INTERNAL_IP="$(ip address show dev eth0 | awk -F'[ /]' '/inet /{print $6"/"$7" brd "$9}')"
        DEFAULT_IP_ROUTE=$(ip route | grep default)
        ip addr del $INTERNAL_IP dev $INTERFACE
        result=$(ip addr add $IP/24 dev $INTERFACE)
        ip addr add $INTERNAL_IP dev $INTERFACE
        ip route add $DEFAULT_IP_ROUTE
        echo $result
fi