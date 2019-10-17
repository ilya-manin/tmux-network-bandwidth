# Network bandwidth plugin for tmux
[![GitHub](https://img.shields.io/github/license/xamut/tmux-network-bandwidth)](https://opensource.org/licenses/MIT)

## Installation
### Requirements
* awk
* netstat
* numfmt

### With Tmux Plugin Manager
Add the plugin in `.tmux.conf`:
```
set -g @plugin 'xamut/tmux-network-bandwidth'
```
Press `prefix + I` to fetch the plugin and source it. Done.

### Manual
Clone the repo somewhere. Add `run-shell` in `.tmux.conf`:

```
run-shell PATH_TO_REPO/tmux-network-bandwidth.tmux
```
Press `prefix + :` and type `source-file ~/.tmux.conf`. Done.

## Usage
Add `#{network_bandwidth}` somewhere in the right status line:
```
set-option -g status-right "#{network_bandwidth}"
```
then you will see the bandwidth in the status line: `↓3.5MiB/s • ↑134KiB/s`

## License
tmux-network-bandwidth plugin is released under the [MIT License](https://opensource.org/licenses/MIT).
