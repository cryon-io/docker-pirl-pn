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

ver=$(cat ./version)
type="PIRL_PN"

block_number=$(curl -sX POST --url http://localhost:6588 \
    --header 'Cache-Control: no-cache' \
    --header 'Content-Type: application/json' \
    --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":["latest", false],"id":1}' | \
    jq .result -r)
block_count=$(printf "%d\n" $block_number)

RESULT=$(curl -sX POST --url http://localhost:6588     --header 'Cache-Control: no-cache'     --header 'Content-Type: application/json'     --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}')
syncing=$(printf "%s" "$RESULT" | jq .result -r)
sync_status=false
if [ "$syncing" = "false" ]; then
    sync_status=true
else 
    block_count=$(printf "%d" "$(printf "%s" "$RESULT" | jq .result.currentBlock -r)")
    sync_status=false
fi

RESULT=$(curl -sX POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", false],"id":1}' --header 'Cache-Control: no-cache' --header 'Content-Type: application/json' --url http://localhost:6588)
block_hash=$(printf "%s" "$RESULT" | jq .result.hash -r)

mn_status="checks failed"
mn_status_level="error"
if marlin stats repo | grep "All is OK" > /dev/null; then
   mn_status="all ok"
   if [ "$sync_status" = "false" ]; then
      mn_status_level="warning"
   else 
      mn_status_level="ok"
   fi
fi

printf "\
TYPE: %s
VERSION: %s
BLOCKS: %s
BLOCK_HASH: %s
MN STATUS: %s
MN STATUS LEVEL: %s
SYNCED: %s
" "$type" "$ver" "$block_count" "$block_hash" "$mn_status" "$mn_status_level" "$sync_status" > /home/pirl/.pirl/node.info

printf "\
TYPE: %s
VERSION: %s
BLOCKS: %s
BLOCK_HASH: %s
MN STATUS: %s
MN STATUS LEVEL: %s
SYNCED: %s
" "$type" "$ver" "$block_count" "$block_hash" "$mn_status" "$mn_status_level" "$sync_status"
