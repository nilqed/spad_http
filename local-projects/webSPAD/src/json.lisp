(in-package :webspad)


(defun bool-to-str (s) (if s "true" "false"))

(defun encode-json (data)
  (defvar flags (webspad-data-format-flags data))
  (format nil "{ \"input\":\"~A\",~
                 \"multiline?\":\"~A\",~
                 \"spad-type\":\"~A\",~
                 \"algebra\":\"~A\",~
                 \"charybdis\":\"~A\",~
                 \"tex\":\"~A\",~
                 \"html\":\"~A\",~
                 \"mathml\":\"~A\",~
                 \"formula\":\"~A\",~
                 \"fortran\":\"~A\",~
                 \"texmacs\":\"~A\",~
                 \"openmath\":\"~A\",~
                 \"format-flags\": {~
                   \"algebra\":\"~A\",~
                   \"tex\":\"~A\",~
                   \"html\":\"~A\",~
                   \"mathml\":\"~A\",~
                   \"formula\":\"~A\",~
                   \"fortran\":\"~A\",~
                   \"texmcas\":\"~A\",~
                   \"openmath\":\"~A\"~
                   }}"
                   (webspad-data-input data)
                   (bool-to-str (webspad-data-multiline? data))
                   (webspad-data-spad-type data)
                   (webspad-data-algebra data)
                   (webspad-data-charybdis data)
                   (webspad-data-tex data)
                   (webspad-data-html data)
                   (webspad-data-mathml data)
                   (webspad-data-formula data)
                   (webspad-data-fortran data)
                   (webspad-data-texmacs data)
                   (webspad-data-openmath data)
                   (bool-to-str (ws-format-algebra flags))
                   (bool-to-str (ws-format-tex flags))
                   (bool-to-str (ws-format-html flags))
                   (bool-to-str (ws-format-mathml flags))
                   (bool-to-str (ws-format-formula flags))
                   (bool-to-str (ws-format-fortran flags))
                   (bool-to-str (ws-format-texmacs flags))
                   (bool-to-str (ws-format-openmath flags))))
                   
                   
                   
                   
                   
                    