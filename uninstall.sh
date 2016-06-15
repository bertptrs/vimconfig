#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

find . -maxdepth 1 -mindepth 1 -type d -print0 | \
	xargs -0 -n 1 basename | \
	xargs stow -D -t "$HOME"
