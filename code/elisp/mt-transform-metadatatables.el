(defun mt-transform-metadata-table-satitas (file-name
                                              path-to-input-folder
                                              path-to-output-folder)
  "The function transform the a metadata table in the old format to the revised 
format used in the SATITAS project since May 2020.

The function reads from the input folder and places a modified file in the 
output folder. Both folders should exist."
  (let ((new-table-format "| :m:                               |   |
| NEW---text number                       |   |
| NEW---year-min                          |   |
| NEW---year-max                          |   |
| NEW---date                              |   |
| NEW---location/place of issue           |   |
| NEW---colection                         |   |
| NEW---shelf-mark                        |   |
| NEW---material                          |   |
| NEW---script                            |   |
| NEW---scribe                            |   |
| NEW---charter height (cm)               |   |
| NEW---charter width (cm)                |   |
| NEW---plica height (cm)                 |   |
| NEW---character variants                |   |
| NEW---language                          |   |
| NEW---charter type                      |   |
| NEW---archival signs                    |   |
| NEW---number of seals / seals preserved |   |
| NEW---primary image(s) recto side(s)    |   |
| NEW---secondary image(s) recto side(s)  |   |
| NEW---primary image(s) verso side(s)    |   |
| NEW---secondary image(s) verso side(s)  |   |
| NEW---primary image(s) of seal(s)       |   |
| NEW---Secondary image(s) of seal(s)     |   |
| NEW---sender                            |   |
| NEW---Jexlev                            |   |
| NEW---Rep.                              |   |
| NEW---Dipl. Dan.                        |   |
| NEW---Reg. Dan.                         |   |
| NEW---Æa.                               |   |
| NEW---SDHK                              |   |
| NEW---related documents                 |   |
| :e:                               |   |
")
        grabbed-text
        old-table-beg)
    (with-temp-buffer
      (insert-file-contents (format "%s%s" path-to-input-folder file-name))
      (goto-char (point-min))
      (search-forward "SDHK")
      (forward-line)
      (insert new-table-format)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 1)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---text number")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 2)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---shelf-mark")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 3)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---year-min")
      (org-table-goto-column 2)
      (insert grabbed-text)
      (forward-line 1)
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 4)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---date")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 5)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---location/place of issue")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 6)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---language")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 7)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---scribe")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 8)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---material")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 9)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---sender")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 10)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---Jexlev")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 11)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---Rep.")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 12)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---Dipl. Dan.")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 13)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---Reg. Dan.")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 14)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---Æa.")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (goto-char (point-min))
      (search-forward ":m:")
      (forward-line 15)
      (setq grabbed-text (mt-grab-org-table-cell 2))
      (search-forward "NEW---SDHK")
      (org-table-goto-column 2)
      (insert grabbed-text)

      (mt-replace-all "NEW---" "")
      (goto-char (point-min))
      (search-forward ":m:")
      (setq old-table-beg (line-beginning-position))
      (search-forward "SDHK")
      (delete-region old-table-beg (line-end-position))
      (search-forward "m:")
      (org-table-align)
      (write-file (format "%s%s" path-to-output-folder file-name) nil)))))


(defun mt-transform-metadata-table-satitas-from-list-of-files (list-of-file-names
                                                               path-to-input-folder
                                                               path-to-output-folder)
  (loop for i in list-of-file-names do
        (mt-transform-metadata-table-satitas i path-to-input-folder path-to-output-folder)))

;; Eksempel på kald
;; (mt-transform-metadata-table-satitas-from-list-of-files '("100.org"
;;                                                           "98.org"
;;                                                           "99.org")
;;                                                         "~/Downloads/tabletransform/original-files/"
;;                                                         "~/Downloads/tabletransform/transformed-files/")



;;; EAE

(defun mt-transform-metadata-table-msk ()
  "The function transforms each metadatatable in the current buffer from the old
single row format to the new multirow format.

The function is destructive and changes the buffer contents."
  (let (text-number
        shelf-mark
        year
        collection)
    (while (search-forward-regexp "^| +:m:" nil t nil)
      (setq text-number (mt-grab-org-table-cell 2))
      (setq shelf-mark (mt-grab-org-table-cell 4))
      (setq year (mt-grab-org-table-cell 5))
      (setq collection (mt-grab-org-table-cell 7))
      (mt-delete-line)
      (insert "| :NEW---m:                     |   |
| NEW---text number             |   |
| NEW---year                    |   |
| NEW---date                    |   |
| NEW---location/place of issue |   |
| NEW---colection               |   |
| NEW---shelf-mark              |   |
| NEW---material                |   |
| NEW---script                  |   |
| NEW---scribe                  |   |
| NEW---chapter title           |   |
| :e:                           |   |
")
      (search-backward ":NEW---m:")
      (forward-line)
      (org-table-goto-column 2)
      (insert text-number)

      (forward-line)
      (org-table-goto-column 2)
      (insert year)

      (forward-line 3)
      (org-table-goto-column 2)
      (insert collection)

      (forward-line)
      (org-table-goto-column 2)
      (insert shelf-mark)
      (org-table-align))
    (mt-replace-all "NEW---" "")))


(defun mt-transform-metadata-table-marine ()
  "The function transforms each metadatatable in the current buffer from the old
single row format to the new multirow format.

The function is destructive and changes the buffer contents."
  (let (text-number
        shelf-mark
        year
        collection)
    (while (search-forward-regexp "^| +:m:" nil t nil)
      (setq text-number (mt-grab-org-table-cell 2))
      (setq chapter-title (mt-grab-org-table-cell 3))
      (setq shelf-mark (mt-grab-org-table-cell 4))
      (setq year (mt-grab-org-table-cell 5))
      (setq collection (mt-grab-org-table-cell 7))
      (mt-delete-line)
      (insert "| :NEW---m:                     |   |
| NEW---text number             |   |
| NEW---year                    |   |
| NEW---date                    |   |
| NEW---location/place of issue |   |
| NEW---colection               |   |
| NEW---shelf-mark              |   |
| NEW---material                |   |
| NEW---script                  |   |
| NEW---scribe                  |   |
| NEW---chapter title           |   |
| :e:                           |   |
")
      (search-backward ":NEW---m:")
      (forward-line)
      (org-table-goto-column 2)
      (insert text-number)

      (forward-line)
      (org-table-goto-column 2)
      (insert year)

      (forward-line 3)
      (org-table-goto-column 2)
      (insert collection)

      (forward-line)
      (org-table-goto-column 2)
      (insert shelf-mark)

      (forward-line 4)
      (org-table-goto-column 2)
      (insert chapter-title)

      (org-table-align))
    (mt-replace-all "NEW---" "")))
