#!/bin/bash

COMMAND_NAME="getpatch"

DIR="$HOME/.local/bin"

mkdir -p "$DIR"

install -m 755 fetch-patch.sh "$DIR/$COMMAND_NAME"


