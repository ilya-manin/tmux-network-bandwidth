#!/usr/bin/env bash

TMUX_BIN="/usr/local/bin/tmux"

get_tmux_option() {
  local option_name="$1"
  local option_value=$($TMUX_BIN show-option -gqv $option_name)
  echo $option_value
}

set_tmux_option() {
  local option_name="$1"
  local option_value="$2"
  $($TMUX_BIN set-option -gq $option_name "$option_value")
}

