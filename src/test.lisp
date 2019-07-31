(in-package :test)

(defparameter *screen-width* 800)
(defparameter *screen-height* 600)

(defun main (&key (delay 10000))
  (sdl2:with-init (:video)
    (sdl2:with-window (window :title "SDL2 Window" :w *screen-width* :h *screen-height*)
      (let ((screen-surface (sdl2:get-window-surface window)))
        (sdl2:fill-rect screen-surface
                        nil
                        (sdl2:map-rgb (sdl2:surface-format screen-surface) 255 255 255))
        (sdl2:update-window window)
        (sdl2:delay delay)))))
