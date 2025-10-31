#!/usr/bin/env bash
echo "Waiting for package manager..."
until adb -s emulator-5554 shell pm list packages >/dev/null 2>&1; do
  echo "Package manager not ready, waiting..."
  sleep 5
done
