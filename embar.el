(defvar embar/frame)
(defvar embar/functions nil)

(add-to-list 'embar/functions (lambda () (insert "A")))

(defun embar/create () "Create Embar frame."
       (if (bufferp (get-buffer "*embar*")) (kill-buffer "*embar*"))
       (when embar/frame (delete-frame embar/frame))
       (let ((window-min-height 1))
         (with-current-buffer (get-buffer-create "*embar*")
           (setq embar/frame (make-frame
                              `((name . "embar")
                                (parent-frame . nil)
                                (width . ,(/ (display-pixel-width) (default-font-width)))
                                (height . 1)
                                (cursor-color . ,(face-attribute 'default :background))
                                (border-width . 0)
                                (internal-border-width . 0)
                                (unsplittable . t)
                                (undecorated . t)
                                (minibuffer . nil)
                                (left-fringe . 0)
                                (right-fringe . 0)
                                (no-accept-focus . t)
                                (visibility . t)
                                )))
           (let ((window (frame-root-window embar/frame)))
             (set-window-parameter window 'mode-line-format 'none)
             (set-window-parameter window 'header-line-format 'none))
           (set-frame-height embar/frame 1)
           (set-frame-position embar/frame 0 0)
           ;; set window hints
           (mapcar (lambda (atom)
                     (x-send-client-message nil 0 embar/frame "_NET_WM_STATE" 32 `(2 ,atom 0)))
                   '("_NET_WM_STATE_STICKY" "_NET_WM_STATE_ABOVE"))
           (x-change-window-property "_NET_WM_STRUT_PARTIAL"
                                     `(,(display-pixel-width) 0 0 0 0 ,(default-font-height) 0 0 0 0)
                                     embar/frame "CARDINAL" 32 nil)

           (x-change-window-property "_NET_WM_WINDOW_TYPE" '("_NET_WM_WINDOW_TYPE_DOCK") embar/frame
                                     "ATOM" 32 t)
           (make-frame-visible embar/frame))))

(embar/create)
(delete-frame embar/frame)
