; -*- mode: lisp; package: editor -*-

;;; cmake-mode.l
;;
;; Copyright (c) 2011 bulb.
;;
;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
;; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;;; Code:

(eval-when (:compile-toplevel :load-toplevel :excute))

(defpackage "cmake-mode"
  (:use :lisp :editor))

(in-package "cmake-mode")
(export '(*cmake-mode-hook*
          *cmake-mode-map*
          *cmake-mode-abbrev-table*
          *cmake-local-hash-table*
          *cmake-mode-syntax-table*
          *cmake-regexp-keyword-list*))

(defvar *cmake-mode-hook* nil)

(defvar *cmake-mode-map* nil)
(unless *cmake-mode-map*
  (setq *cmake-mode-map* (make-sparse-keymap))
  ;(define-key *cmake-mode-map* #\TAB 'cmake-mode-indent-line)
  ;(define-key *cmake-mode-map* #\RET 'cmake-mode-newline-and-indent)
  )

(defvar *cmake-mode-abbrev-table* nil)
(unless *cmake-mode-abbrev-table*
  (define-abbrev-table '*cmake-mode-abbrev-table*))

(defvar *cmake-local-hash-table* nil)
(defvar *cmake-keyword-file* "CMake")

(defvar *cmake-mode-syntax-table* nil)
(unless *cmake-mode-syntax-table*
  (setq *cmake-mode-syntax-table* (make-syntax-table))
  #+:debug(do ((x #x21 (1+ x)))((>= x #x7f))
    (let ((c (code-char x)))
      (unless (alphanumericp c)
        (set-syntax-punctuation *cmake-mode-syntax-table* c))))

  (set-syntax-string *cmake-mode-syntax-table* #\")
  (set-syntax-string *cmake-mode-syntax-table* #\')
  (set-syntax-symbol-prefix *cmake-mode-syntax-table* #\$)
  (set-syntax-symbol *cmake-mode-syntax-table* #\_)
  (set-syntax-match *cmake-mode-syntax-table* #\( #\))
  (set-syntax-match *cmake-mode-syntax-table* #\{ #\})
  (set-syntax-match *cmake-mode-syntax-table* #\[ #\])
  (set-syntax-start-comment *cmake-mode-syntax-table* #\# t)
  (set-syntax-end-comment *cmake-mode-syntax-table* #\LFD nil t)
  )

(defvar *cmake-regexp-keyword-list* nil)


;;
;; CMake mode
;;
(in-package "editor")

(export '(cmake-mode
          ))

(defun cmake-mode ()
  "Major mode for editing CMake sources"
  (interactive)
  (kill-all-local-variables)
  (setq buffer-mode 'cmake-mode
        mode-name "CMake")

  (use-keymap cmake-mode::*cmake-mode-map*)
  (use-syntax-table cmake-mode::*cmake-mode-syntax-table*)
  (make-local-variable 'regexp-keyword-list)
  (setq regexp-keyword-list cmake-mode::*cmake-regexp-keyword-list*)

  (when (and cmake-mode::*cmake-keyword-file*
             (null cmake-mode::*cmake-local-hash-table*))
    (setq cmake-mode::*cmake-local-hash-table* (load-keyword-file cmake-mode::*cmake-keyword-file* t)))

  (when cmake-mode::*cmake-local-hash-table*
    (make-local-variable 'keyword-hash-table)
    (setq keyword-hash-table cmake-mode::*cmake-local-hash-table*))

  (setq *local-abbrev-table* cmake-mode::*cmake-mode-abbrev-table*)

  (run-hooks 'cmake-mode::*cmake-mode-hook*))

(provide "cmake-mode")

;;; End
