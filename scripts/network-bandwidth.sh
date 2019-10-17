#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

getStat() {
  /usr/sbin/netstat -ibn | /usr/local/bin/awk 'FNR > 1 {
    interfaces[$1 ":bytesReceived"] = $(NF-4);
    interfaces[$1 ":bytesSent"]     = $(NF-1);
  } END {
    for (itemKey in interfaces) {
      split(itemKey, keys, ":");
      interface = keys[1]
      dataKind = keys[2]
      sum[dataKind] += interfaces[itemKey]
    }

    print sum["bytesReceived"], sum["bytesSent"]
  }'
}

formatSpeed() {
  local str=`/usr/local/bin/numfmt -z --to=iec-i --suffix "B/s" --format "%.2f" $1`
  echo -n ${str/".00"/""}
}

main() {
  local sleepTime=$(get_tmux_option "status-interval")
  local oldValue=$(get_tmux_option "@network_bandwidth_old_value")

  if [ -z "$oldValue"]
  then
    $(set_tmux_option "@network_bandwidth_old_value" "foo")
    local downloadSpeed=0
    local uploadSpeed=0
  else
    local firstMeasure=( $(getStat) )
    sleep $sleepTime
    local secondMeasure=( $(getStat) )
    local downloadSpeed=$(((${secondMeasure[0]} - ${firstMeasure[0]}) / $sleepTime))
    local uploadSpeed=$(((${secondMeasure[1]} - ${firstMeasure[1]}) / $sleepTime))
  fi

  local value="↓$(formatSpeed $downloadSpeed) • ↑$(formatSpeed $uploadSpeed)"
  echo -n $value
}

main
