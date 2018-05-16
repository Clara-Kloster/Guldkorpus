(defun velux-generate-word-list ()
  "This function, which was hacked together in a hurry, returns a list of nested
lists of word forms from the lemmatised texts found in DSL's middelaldertekster 
repository (https://github.com/dsldk/middelaldertekster) and their corresponding 
lemma-id's."
  (let ((list-of-texts
         '("bodloest-maal.xml"
           "den-kyske-dronning.xml"
           "droemte-mig-en-droem.xml"
           "dvaergekongen-laurin.xml"
           "flensborg-stadsret.xml"
           "flores-og-blanseflor.xml"
           "fortalen-til-jyske-lov.xml"
           "hertug-frederik-af-normandi.xml"
           "ivan-loeveridder.xml"
           "julemaerker.xml"
           "peder-laale-ordsprog-1506.xml"
           "persenober-og-konstantianobis.xml"
           "ridderen-i-hjorteham.xml"
           "tyrkens-tog.xml"))
        (text-folder "~/Dropbox/velux/middelaldertekster/data/")
        word-tag-beg
        word-tag-end
        word-tag
        word-list
        word-id
        word-form)
    (with-temp-buffer
      (loop for i in list-of-texts do
            (insert-file-contents (concat text-folder i)))
      (goto-char (point-min))
      (while (search-forward-regexp "<w +lemma" nil t nil)
        (search-backward "<w")
        (setq word-tag-beg (point))
        (search-forward "</w>")
        (setq word-tag-end (point))
        (setq word-tag (replace-regexp-in-string "\n+" " " (buffer-substring-no-properties word-tag-beg word-tag-end)))
        (setq word-id (s-trim (replace-regexp-in-string ".*lemma=\"\\(.*?\\)\">.*" "\\1" word-tag)))
        (setq word-form (s-trim (replace-regexp-in-string "<w.*?>\\(.*?\\)</w>.*" "\\1" word-tag)))
        (setq word-form (replace-regexp-in-string "<pb .*?/>" "" word-form))
        (setq word-form (replace-regexp-in-string "<lb .*?/>" "" word-form))
        (setq word-form (replace-regexp-in-string "<hi .*?>" "" word-form))
        (setq word-form (replace-regexp-in-string "<hi>" "" word-form))
        (setq word-form (replace-regexp-in-string "</hi>" "" word-form))
        ;; (setq word-form (replace-regexp-in-string "<ex>" "" word-form))
        ;; (setq word-form (replace-regexp-in-string "</ex>" "" word-form))
        (push (list word-id word-form) word-list)))
    word-list))


;; (loop for i in (velux-generate-word-list) do
;;       (insert (format "%s ¦¦ %s\n" (car i) (cadr i))))

;; (while (search-forward-regexp "65[0-9][0-9][0-9][0-9][0-9][0-9]" nil t nil)
;;   (setq word-id (buffer-substring-no-properties (- (point) 8) (point)))
;;   (goto-char (line-end-position))
;;   (setq lemma-info-list (gethash word-id *dsl-go-id-lemma-hash-table*))
;;   (insert (format "%s | %s | %s |" (nth 0 lemma-info-list) (nth 1 lemma-info-list) (nth 2 lemma-info-list))))

