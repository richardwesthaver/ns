;;; ns.el --- Elisp namespaces -*- lexical-binding: t; -*-

;; Copyright (C) 2023  ellis

;; Author: ellis <ellis@rwest.io>
;; Keywords: convenience, maint, languages, lisp, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; `ns' is an elisp library for making 'namespaces'. It is similar to Cloj
;;; Code:
(eval-when-compile (require 'cl-lib))
;; (require 'repeat)
;; (require 'repeat-help)

(defgroup ns nil
  "Elisp namespaces."
  :prefix "ns-")

(defvar *ns* nil
  "The current namespace.")

(defcustom ns-name-prefix "ns"
  "Prefix for `ns'. Don't include the separator -- that is configured via `ns-name-separator'.")

(defcustom ns-name-separator ":"
  "Separator used in `ns' symbol names. It is recommended to use something other than '-'.")

(defmacro make-ns-name (&rest names)
  "Build `ns'-style name given NAMES."
  (cl-loop with res
	   for n in names
	   when (symbolp n) do (setf n (symbol-name n))
	   for i from 1
	   if (null (cdr names)) concat (concat ns-name-prefix ns-name-separator n) into res
	   else if (eq i (length names)) concat (concat ns-name-separator n) into res
	   else if (cl-oddp i) concat n into res
	   else concat (concat ns-name-separator n ns-name-separator) into res
	   finally return res))

(defmacro make-ns (name &optional docstring props enable)
  "Make a new namespace with given NAME, DOCSTRING, and PROPS. If
 ENABLE is non-nil, also sets `*ns*'."
  (declare (indent 2))
  `(let ((ns (intern (make-ns-name ,name))))
    (when ,enable (setq *ns* ns))
    (setq ns (cons (symbol-name ns) ,props))))

(provide 'ns)
;;; ns.el ends here
