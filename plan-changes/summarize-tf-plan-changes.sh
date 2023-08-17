#!/bin/bash
#
# File: show-changes.sh
# Author: Alex Ott
# Created: Thursday, August 17 2023
#

plan_file=$$.plan
json_file=$$.json
terraform plan -out=$plan_file
terraform show -json $plan_file|jq . >| $json_file

echo "Changes to be made:"
jq '.resource_changes[]|select(.change.actions[] |contains ("no-op")|not)|{type, address, action: .change.actions[0]}' $json_file \
    |jq -s 'group_by(.action)| map({ key: (.[0].action), value: [.[] | {type, address}] }) | from_entries'

#jq '.resource_changes[]|select(.change.actions[] |contains ("no-op")|not)|{type, address, action: .change.actions[0]}|from_entries' $json_file
