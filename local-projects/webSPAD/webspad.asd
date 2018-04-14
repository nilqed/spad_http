(in-package :common-lisp-user)

(asdf:defsystem #:webspad
  :serial t
  :description "Hunchentoot webserver serving SPAD"
  :version "1.0.0"
  :author "Kurt Pagani, <nilqed@gmail.com>"
  :license "BSD, see file LICENSE"
  :depends-on (#:hunchentoot)
  :pathname "src/"
  :components ((:file "webspad") 
               (:file "eval") 
               (:file "json")
               (:file "server")))
