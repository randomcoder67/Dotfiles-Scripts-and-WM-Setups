#!/usr/bin/env bash

if ! pgrep boomer; then
	boomer -w
fi
