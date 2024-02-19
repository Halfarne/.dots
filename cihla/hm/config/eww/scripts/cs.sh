#!/usr/bin/env bash

playerctl --follow metadata --format "{{ artist }} - {{ title }}" || true
