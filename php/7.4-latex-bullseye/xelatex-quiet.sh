#!/usr/bin/env bash

set -o pipefail

tex_output=$(/usr/bin/xelatex --halt-on-error "$@")
tex_output_status=$?

if ! test $tex_output_status -eq 0; then
  echo "$tex_output" | grep --color=auto -E '^!.*' -A10;
else
  echo "$tex_output" | grep --color=auto 'Rerun to';
fi

if ! test $tex_output_status -eq 0; then
    echo "Failed to compile the provided TEX file!"
    exit $tex_output_status
else
    echo "The compilation was successful!"
    exit $tex_output_status
fi