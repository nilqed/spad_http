(in-package :webspad)


(defun bool-to-str (s) (if s "true" "false"))

(defun encode-json (data)
  (setf flags (webspad-data-format-flags data))
  (format nil "{ \"input\":~S,~
                 \"stdout\":~S,~
                 \"stderr\":~S,~
                 \"multiline?\":~S,~
                 \"spad-type\":~S,~
                 \"algebra\":~S,~
                 \"charybdis\":~S,~
                 \"tex\":~S,~
                 \"html\":~S,~
                 \"mathml\":~S,~
                 \"formula\":~S,~
                 \"fortran\":~S,~
                 \"texmacs\":~S,~
                 \"openmath\":~S,~
                 \"format-flags\": {~
                   \"algebra\":~S,~
                   \"tex\":~S,~
                   \"html\":~S,~
                   \"mathml\":~S,~
                   \"formula\":~S,~
                   \"fortran\":~S,~
                   \"texmcas\":~S,~
                   \"openmath\":~S~
                   }}"
                   (webspad-data-input data)
                   (webspad-data-stdout data)
                   (webspad-data-stderr data)
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
                   
                   
                   
                   
                   
                    
