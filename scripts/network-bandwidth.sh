#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"

get_bandwidth() {
  netstat -ibn | awk 'FNR > 1 {
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

format_speed() {
  local str=`numfmt -z --to=iec-i --suffix "B/s" --format "%.2f" $1`
  echo -n ${str/".00"/""}
}

main() {
  local sleep_time=$(get_tmux_option "status-interval")
  local old_value=$(get_tmux_option "@network-bandwidth-previous-value")

  if [ -z "$old_value"]
  then
    $(set_tmux_option "@network-bandwidth-previous-value" "-")
    echo -n "Please wait..."
    return 0
  else
    local first_measure=( $(get_bandwidth) )
    sleep $sleep_time
    local second_measure=( $(get_bandwidth) )
    local download_speed=$(((${second_measure[0]} - ${first_measure[0]}) / $sleep_time))
    local upload_speed=$(((${second_measure[1]} - ${first_measure[1]}) / $sleep_time))
    $(set_tmux_option "@network-bandwidth-previous-value" "↓$(format_speed $download_speed) • ↑$(format_speed $upload_speed)")
  fi

  echo -n $(get_tmux_option "@network-bandwidth-previous-value")
}

main
