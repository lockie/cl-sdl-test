#!/usr/bin/env bash

set -e

sbcl --script build.lisp
tar -czvf cl-sdl-test-linux.tar.gz -C src/bin .
