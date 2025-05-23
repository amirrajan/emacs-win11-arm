;;; button.el --- clickable buttons -*- lexical-binding: t -*-
;;
;; Copyright (C) 2001-2024 Free Software Foundation, Inc.
;;
;; Author: Miles Bader <miles@gnu.org>
;; Keywords: extensions, hypermedia
;; Package: emacs
;;
;; This file is part of GNU Emacs.
;;
;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; This package defines functions for inserting and manipulating
;; clickable buttons in Emacs buffers, such as might be used for help
;; hyperlinks, etc.
;;
;; In some ways it duplicates functionality also offered by the
;; `widget' package, but the button package has the advantage that it
;; is (1) much faster, (2) much smaller, and (3) much, much, simpler
;; (the code, that is, not the interface).
;;
;; Buttons can either use overlays, in which case the button is
;; represented by the overlay itself, or text-properties, in which case
;; the button is represented by a marker or buffer-position pointing
;; somewhere in the button.  In the latter case, no markers into the
;; buffer are retained, which is important for speed if there are
;; extremely large numbers of buttons.  Note however that if there is
;; an existing face text-property at the site of the button, the
;; button face may not be visible.  Using overlays avoids this.
;;
;; Using `define-button-type' to define default properties for buttons
;; is not necessary, but it is encouraged, since doing so makes the
;; resulting code clearer and more efficient.
;;

;;; Code:


;;; Globals

(defface button '((t :inherit link))
  "Default face used for buttons."
  :group 'basic-faces)

(defvar-keymap button-buffer-map
  :doc "Keymap useful for buffers containing buttons.
Mode-specific keymaps may want to use this as their parent keymap."
  "TAB" #'forward-button
  "ESC TAB" #'backward-button
  "<backtab>" #'backward-button)

(defvar-keymap button-map
  :doc "Keymap used by buttons."
  :parent button-buffer-map
  "RET" #'push-button
  "<mouse-2>" #'push-button
  "<follow-link>" 'mouse-face
  ;; FIXME: You'd think that for keymaps coming from text-properties on the
  ;; mode-line or header-line, the `mode-line' or `header-line' prefix
  ;; shouldn't be necessary!
  "<mode-line> <mouse-2>" #'push-button
  "<header-line> <mouse-2>" #'push-button)

(define-minor-mode button-mode
  "A minor mode for navigating to buttons with the TAB key."
  :keymap button-buffer-map)

;; Default properties for buttons.
(put 'default-button 'face 'button)
(put 'default-button 'mouse-face 'highlight)
(put 'default-button 'keymap button-map)
(put 'default-button 'type 'button)
;; `action' may be either a function to call, or a marker to go to.
(put 'default-button 'action #'ignore)
(put 'default-button 'help-echo (purecopy "mouse-2, RET: Push this button"))
;; Make overlay buttons go away if their underlying text is deleted.
(put 'default-button 'evaporate t)
;; Prevent insertions adjacent to text-property buttons from
;; inheriting their properties.
(put 'default-button 'rear-nonsticky t)

;; A `category-symbol' property for the default button type.
(put 'button 'button-category-symbol 'default-button)


;;; Button types (which can be used to hold default properties for buttons)

;; Because button-type properties are inherited by buttons using the
;; special `category' property (implemented by both overlays and
;; text-properties), we need to store them on a symbol to which the
;; `category' properties can point.  Instead of using the symbol that's
;; the name of each button-type, however, we use a separate symbol (with
;; `-button' appended, and uninterned) to store the properties.  This is
;; to avoid name clashes.

;; [this is an internal function]
(defsubst button-category-symbol (type)
  "Return the symbol used by `button-type' TYPE to store properties.
Buttons inherit them by setting their `category' property to that symbol."
  (or (get type 'button-category-symbol)
      (error "Unknown button type `%s'" type)))

(defun define-button-type (name &rest properties)
  "Define a `button type' called NAME (a symbol).
The remaining PROPERTIES arguments form a plist of PROPERTY VALUE
pairs, specifying properties to use as defaults for buttons with
this type (a button's type may be set by giving it a `type'
property when creating the button, using the :type keyword
argument).

In addition, the keyword argument :supertype may be used to specify a
`button-type' from which NAME inherits its default property values
(however, the inheritance happens only when NAME is defined; subsequent
changes to a supertype are not reflected in its subtypes)."
  (declare (indent defun))
  (let ((catsym (make-symbol (concat (symbol-name name) "-button")))
	(super-catsym
	 (button-category-symbol
	  (or (plist-get properties 'supertype)
	      (plist-get properties :supertype)
	      'button))))
    ;; Provide a link so that it's easy to find the real symbol.
    (put name 'button-category-symbol catsym)
    ;; Initialize NAME's properties using the global defaults.
    (let ((default-props (symbol-plist super-catsym)))
      (while default-props
	(put catsym (pop default-props) (pop default-props))))
    ;; Add NAME as the `type' property, which will then be returned as
    ;; the type property of individual buttons.
    (put catsym 'type name)
    ;; Add the properties in PROPERTIES to the real symbol.
    (while properties
      (let ((prop (pop properties)))
	(when (eq prop :supertype)
	  (setq prop 'supertype))
	(put catsym prop (pop properties))))
    ;; Make sure there's a `supertype' property.
    (unless (get catsym 'supertype)
      (put catsym 'supertype 'button))
    name))

(defun button-type-put (type prop val)
  "Set the `button-type' TYPE's PROP property to VAL."
  (put (button-category-symbol type) prop val))

(defun button-type-get (type prop)
  "Get the property of `button-type' TYPE named PROP."
  (get (button-category-symbol type) prop))

(defun button-type-subtype-p (type supertype)
  "Return non-nil if `button-type' TYPE is a subtype of SUPERTYPE."
  (or (eq type supertype)
      (and type
	   (button-type-subtype-p (button-type-get type 'supertype)
				  supertype))))


;;; Button properties and other attributes

(defun button-start (button)
  "Return the position at which BUTTON starts.

This function only works when BUTTON is in the current buffer."
  (if (overlayp button)
      (overlay-start button)
    ;; Must be a text-property button.
    (or (previous-single-property-change (1+ button) 'button)
	(point-min))))

(defun button-end (button)
  "Return the position at which BUTTON ends.

This function only works when BUTTON is in the current buffer."
  (if (overlayp button)
      (overlay-end button)
    ;; Must be a text-property button.
    (or (next-single-property-change button 'button)
	(point-max))))

(defun button-get (button prop)
  "Get the property of button BUTTON named PROP.

This function only works when BUTTON is in the current buffer."
  (cond ((overlayp button)
	 (overlay-get button prop))
	((button--area-button-p button)
	 (get-text-property (cdr button)
			    prop (button--area-button-string button)))
	((markerp button)
	 (get-text-property button prop (marker-buffer button)))
	(t ; Must be a text-property button.
	 (get-text-property button prop))))

(defun button-put (button prop val)
  "Set BUTTON's PROP property to VAL.

This function only works when BUTTON is in the current buffer."
  ;; Treat some properties specially.
  (cond ((memq prop '(type :type))
         ;; We translate a `type' property to a `category' property,
         ;; since that's what's actually used by overlay and
         ;; text-property buttons for inheriting properties.
	 (setq prop 'category)
	 (setq val (button-category-symbol val)))
	((eq prop 'category)
	 ;; Disallow updating the `category' property directly.
	 (error "Button `category' property may not be set directly")))
  ;; Add the property.
  (cond ((overlayp button)
	 (overlay-put button prop val))
	((button--area-button-p button)
	 (setq button (button--area-button-string button))
	 (put-text-property 0 (length button) prop val button))
	(t ; Must be a text-property button.
	 (put-text-property
	  (or (previous-single-property-change (1+ button) 'button)
	      (point-min))
	  (or (next-single-property-change button 'button)
	      (point-max))
	  prop val))))

(defun button-activate (button &optional use-mouse-action)
  "Call BUTTON's `action' property.
If USE-MOUSE-ACTION is non-nil, invoke the button's `mouse-action'
property instead of `action'; if the button has no `mouse-action',
the value of `action' is used instead.

The action can either be a marker or a function.  If it's a
marker then goto it.  Otherwise if it is a function then it is
called with BUTTON as only argument.  BUTTON is either an
overlay, a buffer position, or (for buttons in the mode-line or
header-line) a string.

If BUTTON has a `button-data' value, call the function with this
value instead of BUTTON.

This function only works when BUTTON is in the current buffer."
  (let ((action (or (and use-mouse-action (button-get button 'mouse-action))
		    (button-get button 'action)))
        (data (button-get button 'button-data)))
    (if (markerp action)
	(save-selected-window
	  (select-window (display-buffer (marker-buffer action)))
	  (goto-char action)
	  (recenter 0))
      (funcall action (or data button)))))

(defun button-label (button)
  "Return BUTTON's text label.

This function only works when BUTTON is in the current buffer."
  (if (button--area-button-p button)
      (substring-no-properties (button--area-button-string button))
    (buffer-substring-no-properties (button-start button)
				    (button-end button))))

(defsubst button-type (button)
  "Return BUTTON's `button-type'."
  (button-get button 'type))

(defun button-has-type-p (button type)
  "Return non-nil if BUTTON has `button-type' TYPE, or one of its subtypes."
  (button-type-subtype-p (button-get button 'type) type))

(defun button--area-button-p (b)
  "Return non-nil if BUTTON is an area button.
Such area buttons are used for buttons in the mode-line and header-line."
  (stringp (car-safe b)))

(defalias 'button--area-button-string #'car
  "Return area button BUTTON's button-string.")

;;; Creating overlay buttons

(defun make-button (beg end &rest properties)
  "Make a button from BEG to END in the current buffer.
The remaining PROPERTIES arguments form a plist of PROPERTY VALUE
pairs, specifying properties to add to the button.
In addition, the keyword argument :type may be used to specify a
`button-type' from which to inherit other properties; see
`define-button-type'.

Also see `make-text-button', `insert-button'."
  (let ((overlay (make-overlay beg end nil t nil)))
    (while properties
      (button-put overlay (pop properties) (pop properties)))
    ;; Put a pointer to the button in the overlay, so it's easy to get
    ;; when we don't actually have a reference to the overlay.
    (overlay-put overlay 'button overlay)
    ;; If the user didn't specify a type, use the default.
    (unless (overlay-get overlay 'category)
      (overlay-put overlay 'category 'default-button))
    ;; OVERLAY is the button, so return it.
    overlay))

(defun insert-button (label &rest properties)
  "Insert a button with the label LABEL.
The remaining arguments form a plist of PROPERTY VALUE pairs,
specifying properties to add to the button.
In addition, the keyword argument :type may be used to specify a
`button-type' from which to inherit other properties; see
`define-button-type'.

Also see `insert-text-button', `make-button'."
  (apply #'make-button
	 (prog1 (point) (insert label))
	 (point)
	 properties))


;;; Creating text-property buttons

(defun make-text-button (beg end &rest properties)
  "Make a button from BEG to END in the current buffer.
The remaining PROPERTIES arguments form a plist of PROPERTY VALUE
pairs, specifying properties to add to the button.
In addition, the keyword argument :type may be used to specify a
`button-type' from which to inherit other properties; see
`define-button-type'.

This function is like `make-button', except that the button is actually
part of the text instead of being a property of the buffer.  That is,
this function uses text properties, the other uses overlays.
Creating large numbers of buttons can also be somewhat faster
using `make-text-button'.  Note, however, that if there is an existing
face property at the site of the button, the button face may not be visible.
You may want to use `make-button' in that case.

If the property `button-data' is present, it will later be used
as the argument for the `action' callback function instead of the
default argument, which is the button itself.

BEG can also be a string, in which case a copy of it is made into
a button and returned.

Also see `insert-text-button'."
  (let ((object nil)
        (type-entry
	 (or (plist-member properties 'type)
	     (plist-member properties :type))))
    ;; Disallow setting the `category' property directly.
    (when (plist-get properties 'category)
      (error "Button `category' property may not be set directly"))
    (if (null type-entry)
	;; The user didn't specify a `type' property, use the default.
	(setq properties (cons 'category (cons 'default-button properties)))
      ;; The user did specify a `type' property.  Translate it into a
      ;; `category' property, which is what's actually used by
      ;; text-properties for inheritance.
      (setcar type-entry 'category)
      (setcar (cdr type-entry)
              (button-category-symbol (cadr type-entry))))
    (when (stringp beg)
      (setq object (copy-sequence beg))
      (setq beg 0)
      (setq end (length object)))
    ;; Now add all the text properties at once.
    (add-text-properties beg end
                         ;; Each button should have a non-eq `button'
                         ;; property so that next-single-property-change can
                         ;; detect boundaries reliably.
                         (cons 'button (cons (list t) properties))
                         object)
    ;; Return something that can be used to get at the button.
    (or object beg)))

(defun insert-text-button (label &rest properties)
  "Insert a button with the label LABEL.
The remaining PROPERTIES arguments form a plist of PROPERTY VALUE
pairs, specifying properties to add to the button.
In addition, the keyword argument :type may be used to specify a
`button-type' from which to inherit other properties; see
`define-button-type'.

This function is like `insert-button', except that the button is
actually part of the text instead of being a property of the buffer.
Creating large numbers of buttons can also be somewhat faster using
`insert-text-button'.

Also see `make-text-button'."
  (apply #'make-text-button
	 (prog1 (point) (insert label))
	 (point)
	 properties))


;;; Finding buttons in a buffer

(defun button-at (pos)
  "Return the button at position POS in the current buffer, or nil.
If the button at POS is a text property button, the return value
is a marker pointing to POS."
  (let ((button (get-char-property pos 'button)))
    (and button (get-char-property pos 'category)
         (if (overlayp button)
             button
           ;; Must be a text-property button;
           ;; return a marker pointing to it.
           (copy-marker pos t)))))

(defun next-button (pos &optional count-current)
  "Return the next button after position POS in the current buffer.
If COUNT-CURRENT is non-nil, count any button at POS in the search,
instead of starting at the next button."
    (unless count-current
      ;; Search for the next button boundary.
      (setq pos (next-single-char-property-change pos 'button)))
    (and (< pos (point-max))
	 (or (button-at pos)
	     ;; We must have originally been on a button, and are now in
	     ;; the inter-button space.  Recurse to find a button.
	     (next-button pos))))

(defun previous-button (pos &optional count-current)
  "Return the previous button before position POS in the current buffer.
If COUNT-CURRENT is non-nil, count any button at POS in the search,
instead of starting at the next button."
  (let ((button (button-at pos)))
    (if button
	(if count-current
	    button
	  ;; We started out on a button, so move to its start and look
	  ;; for the previous button boundary.
	  (setq pos (previous-single-char-property-change
		     (button-start button) 'button))
	  (let ((new-button (button-at pos)))
	    (if new-button
		;; We are in a button again; this can happen if there
		;; are adjacent buttons (or at bob).
		(unless (= pos (button-start button)) new-button)
	      ;; We are now in the space between buttons.
	      (previous-button pos))))
      ;; We started out in the space between buttons.
      (setq pos (previous-single-char-property-change pos 'button))
      (or (button-at pos)
	  (and (> pos (point-min))
	       (button-at (1- pos)))))))


;;; User commands

(defun push-button (&optional pos use-mouse-action)
  "Perform the action specified by a button at location POS.
POS may be either a buffer position or a mouse-event.  If
USE-MOUSE-ACTION is non-nil, invoke the button's `mouse-action'
property instead of its `action' property; if the button has no
`mouse-action', the value of `action' is used instead.

The action in both cases may be either a function to call or a
marker to display and is invoked using `button-activate' (which
see).

POS defaults to point, except when `push-button' is invoked
interactively as the result of a mouse-event, in which case, the
mouse event is used.

If there's no button at POS, do nothing and return nil, otherwise
return t.

To get a description of the function that will be invoked when
pushing a button, use the `button-describe' command."
  (interactive
   (list (if (integerp last-command-event) (point) last-command-event)))
  (if (and (not (integerp pos)) (eventp pos))
      ;; POS is a mouse event; switch to the proper window/buffer
      (let ((posn (event-start pos)))
	(with-current-buffer (window-buffer (posn-window posn))
          (let* ((str (posn-string posn))
                 (str-button (and str (get-text-property (cdr str) 'button (car str)))))
	    (if str-button
	        ;; mode-line, header-line, or display string event.
	        (button-activate str t)
	      (push-button (posn-point posn) t)))))
    ;; POS is just normal position
    (let ((button (button-at (or pos (point)))))
      (when button
	(button-activate button use-mouse-action)
	t))))

(defun button--help-echo (button)
  "Evaluate BUTTON's `help-echo' property and return its value.
If the result is non-nil, pass it through `substitute-command-keys'
before returning it, as is done for `show-help-function'."
  (let* ((help (button-get button 'help-echo))
         (help (if (functionp help)
                   (funcall help
                            (selected-window)
                            (if (overlayp button) button (current-buffer))
                            (button-start button))
                 (eval help lexical-binding))))
    (and help (substitute-command-keys help))))

(defun forward-button (n &optional wrap display-message no-error)
  "Move to the Nth next button, or Nth previous button if N is negative.
If N is 0, move to the start of any button at point.
If WRAP is non-nil, moving past either end of the buffer continues from the
other end.
If DISPLAY-MESSAGE is non-nil, the button's `help-echo' property
is displayed.  Any button with a non-nil `skip' property is
skipped over.

If NO-ERROR, return nil if no further buttons could be found
instead of erroring out.

Returns the button found."
  (interactive "p\nd\nd")
  (let (button)
    (if (zerop n)
	;; Move to start of current button
	(if (setq button (button-at (point)))
	    (goto-char (button-start button)))
      ;; Move to Nth next button
      (let ((iterator (if (> n 0) #'next-button #'previous-button))
	    (wrap-start (if (> n 0) (point-min) (point-max)))
	    opoint fail)
	(setq n (abs n))
	(setq button t)			; just to start the loop
	(while (and (null fail) (> n 0) button)
	  (setq button (funcall iterator (point)))
	  (when (and (not button) wrap)
	    (setq button (funcall iterator wrap-start t)))
	  (when button
	    (goto-char (button-start button))
	    ;; Avoid looping forever (e.g., if all the buttons have
	    ;; the `skip' property).
	    (cond ((null opoint)
		   (setq opoint (point)))
		  ((= opoint (point))
		   (setq fail t)))
	    (unless (button-get button 'skip)
	      (setq n (1- n)))))))
    (if (null button)
        (unless no-error
	  (user-error (if wrap "No buttons!" "No more buttons")))
      (let ((msg (and display-message (button--help-echo button))))
	(when msg
	  (message "%s" msg)))
      button)))

(defun backward-button (n &optional wrap display-message no-error)
  "Move to the Nth previous button, or Nth next button if N is negative.
If N is 0, move to the start of any button at point.
If WRAP is non-nil, moving past either end of the buffer continues from the
other end.
If DISPLAY-MESSAGE is non-nil, the button's `help-echo' property
is displayed.  Any button with a non-nil `skip' property is
skipped over.

If NO-ERROR, return nil if no further buttons could be found
instead of erroring out.

Returns the button found."
  (interactive "p\nd\nd")
  (forward-button (- n) wrap display-message no-error))

(defun button--describe (properties)
  "Describe a button's PROPERTIES (an alist) in a *Help* buffer.
This is a helper function for `button-describe', in order to be possible to
use `help-setup-xref'.

Each element of PROPERTIES should be of the form (PROPERTY . VALUE)."
  (help-setup-xref (list #'button--describe properties)
                   (called-interactively-p 'interactive))
  (with-help-window (help-buffer)
    (with-current-buffer (help-buffer)
      (insert (format-message "This button's type is `%s'."
                              (alist-get 'type properties)))
      (dolist (prop '(action mouse-action))
        (let ((name (symbol-name prop))
              (val (alist-get prop properties)))
          (when (functionp val)
            (insert "\n\n"
                    (propertize (capitalize name) 'face 'bold)
                    "\nThe " name " of this button is")
            (if (symbolp val)
                (progn
                  (insert (format-message " `%s',\nwhich is " val))
                  (describe-function-1 val))
              (insert "\n")
              (princ val))))))))

(defun button-describe (&optional button-or-pos)
  "Display a buffer with information about the button at point.

When called from Lisp, pass BUTTON-OR-POS as the button to describe, or a
buffer position where a button is present.  If BUTTON-OR-POS is nil, the
button at point is the button to describe."
  (interactive "d")
  (let* ((help-buffer-under-preparation t)
         (button (cond ((integer-or-marker-p button-or-pos)
                        (button-at button-or-pos))
                       ((null button-or-pos) (button-at (point)))
                       ((overlayp button-or-pos) button-or-pos)))
         (props (and button
                     (mapcar (lambda (prop)
                               (cons prop (button-get button prop)))
                             '(type action mouse-action)))))
    (when props
      (button--describe props)
      t)))

(define-obsolete-function-alias 'button-buttonize #'buttonize "29.1")

(defun buttonize (string callback &optional data help-echo)
  "Make STRING into a button and return it.
When clicked, CALLBACK will be called with the DATA as the
function argument.  If DATA isn't present (or is nil), the button
itself will be used instead as the function argument.

If HELP-ECHO, use that as the `help-echo' property.

Also see `buttonize-region'."
  (let ((string
         (apply #'propertize string
                (button--properties callback data help-echo))))
    ;; Add the face to the end so that it can be overridden.
    (add-face-text-property 0 (length string) 'button t string)
    string))

(defun button--properties (callback data help-echo)
  (list 'font-lock-face 'button
        'mouse-face 'highlight
        'help-echo help-echo
        'button t
        'follow-link t
        'category t
        'button-data data
        'keymap button-map
        'action callback))

(defun buttonize-region (start end callback &optional data help-echo)
  "Make the region between START and END into a button.
When clicked, CALLBACK will be called with the DATA as the
function argument.  If DATA isn't present (or is nil), the button
itself will be used instead as the function argument.

If HELP-ECHO, use that as the `help-echo' property.

Also see `buttonize'."
  (add-text-properties start end (button--properties callback data help-echo))
  (add-face-text-property start end 'button t))

(provide 'button)

;;; button.el ends here
