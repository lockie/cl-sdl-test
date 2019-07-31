(asdf:defsystem :test
  :description "SDL2 Common Lisp test"
  :author "Andrew Kravchuk <awkravchuk@gmail.com>"
  :license "MIT"
  :depends-on (:sdl2
               :sdl2-image
               :sdl2-mixer
               :sdl2-ttf)
  :pathname "src"
  :components ((:file "package")
               (:file "test"))
  :defsystem-depends-on (:deploy)
  :build-operation "deploy:deploy-op"
  :build-pathname "test"
  :entry-point "test:main")
