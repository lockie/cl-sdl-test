#!/usr/bin/env -S sbcl --script

(load (merge-pathnames ".sbclrc" (user-homedir-pathname)))
(ql:quickload "deploy")

(push (truename ".") asdf:*central-registry*)
#+windows (push #p"c:\\mingw64\\bin\\" deploy:*system-source-directories*)
(asdf:make :test)
