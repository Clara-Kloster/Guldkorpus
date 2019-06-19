(defun clara-rens-op-efter-pandoc ()
  "Den interaktive funktion renser op i det rod som er resultatet af at konvertere 
ved hjælp af kommandoen
unoconv --stdout -f html FILENAME.ods | pandoc -f html -t org -o FILENAME.org.
Funktionen virker på hele bufferen og fjerner alt andet end transskriptions-
tabellen (også metadata)."
  (interactive)
  (search-forward-regexp ":s:")
  (goto-char (line-beginning-position))
  (delete-region (point-min) (point))
  (mt-replace-all "\\" "")
  (mt-replace-all "#ERR520!" "")
  (goto-char (point-min))
  (insert "*** Transcription\n")
  (search-forward-regexp ":s:")
  (org-table-align))
  
