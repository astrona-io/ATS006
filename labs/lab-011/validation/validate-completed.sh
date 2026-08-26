#!/usr/bin/env bash
set -u

DIR=/var/output-generator

if [ ! -d "$DIR" ]; then
  echo "FAIL: $DIR does not exist"
  exit 1
fi

for f in 1.out 2.out 3.out 4.out; do
  if [ ! -s "$DIR/$f" ]; then
    echo "FAIL: $DIR/$f is missing or empty"
    exit 1
  fi
done

if ! grep -q "OUTPUT_OK" "$DIR/1.out"; then
  echo "FAIL: $DIR/1.out does not contain the expected stdout payload"
  exit 1
fi

if grep -q "WARNING_STREAM" "$DIR/1.out"; then
  echo "FAIL: $DIR/1.out contains stderr content -- stdout was not isolated"
  exit 1
fi

if ! grep -q "WARNING_STREAM" "$DIR/2.out"; then
  echo "FAIL: $DIR/2.out does not contain the expected stderr payload"
  exit 1
fi

if grep -q "OUTPUT_OK" "$DIR/2.out"; then
  echo "FAIL: $DIR/2.out contains stdout content -- stderr was not isolated"
  exit 1
fi

if ! grep -q "OUTPUT_OK" "$DIR/3.out" || ! grep -q "WARNING_STREAM" "$DIR/3.out"; then
  echo "FAIL: $DIR/3.out does not contain both stdout and stderr content"
  exit 1
fi

exit_code=$(tr -d '[:space:]' < "$DIR/4.out")
if [ "$exit_code" != "7" ]; then
  echo "FAIL: $DIR/4.out contains '$exit_code', expected exit code '7'"
  exit 1
fi

echo "PASS: stdout, stderr, combined output, and exit code were all captured correctly"
exit 0
