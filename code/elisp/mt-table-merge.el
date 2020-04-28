;;; mt-table-merge.el --- This is part of MenoTaB -*- lexical-binding: t -*-

;; Copyright (C) 2020 Alex Speed Kjeldsen

;; Author: Alex Speed Kjeldsen <alex.kjeldsen@gmail.com>
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.



(defun mt-util-merge-lemmatised-and-non-lemmatised-tables (file-name
                                                           path-to-lemmatised-files-folder
                                                           path-to-non-lemmatised-files-folder
                                                           path-to-merged-files-folder)
  "The function adds lemma, PoS/Word Class and normalised text level from the 
lemmatised transcription table to the non-lemmatised transcription table (the 
should have identical filenames (the lemmatised files should be placed in the 
folder PATH-TO-LEMMATISED-FILES-FOLDER, the non-lemmatised in 
PATH-TO-NON-LEMMATISED-FILES-FOLDER. The merged files will
be generated in the folder PATH-TO-MERGED-FILES-FOLDER.

Potential BUG: if there are more word forms in the same charter line with the
exact same dipl form, but different lemmatas and/or word classes, the first form
will be applied to all of them. Since lemmatisation and normalisation should be
proofread anyway, this should not pose too much of a problem."
  (let ((lemmatised-table-as-string (mt-util-merge-lemmatised-and-non-lemmatised-tables-extract-lemmatised-table-from-file path-to-lemmatised-files-folder file-name))
        (lemmatised-rows '())
        current-row
        adjusted-table)
    (with-temp-buffer
      (insert lemmatised-table-as-string)
      (goto-char (point-min))
      (keep-lines "^| +[wn]")
      (buffer-string)
      (while (search-forward-regexp "^|" nil t nil)
        (setq current-row (mt-grab-line))
        ;; onto lemmatised-rows we push alists whose CARs are strings of this
        ;; kind "oc-323-02" (i.e. the concatenation of dipl form and position
        ;; element), and whose CDR's are lists with three elements: msa, lemma
        ;; and normalised level, e.g. (("xCC" "ok" "og"). In  other words,
        ;; we push elements like this onto lemmatised-rows:
        ;; ("oc-323-02" ("xCC" "ok" "og"))
        (push (list (format "%s-%s"
                            (mt-extract-dipl-element-from-table-row current-row)
                            (mt-extract-position-element-from-table-row current-row))
                    (list (mt-extract-msa-element-from-table-row current-row)
                          (mt-extract-lemma2-element-from-table-row current-row)
                          (mt-extract-norm1-element-from-table-row current-row)))
              lemmatised-rows))
      (setq lemmatised-rows (reverse lemmatised-rows)))

    (with-temp-buffer
      (insert-file-contents (format "%s%s" path-to-non-lemmatised-files-folder file-name))
      (goto-char (point-min))
      (while (search-forward-regexp "^| +[wn]" nil t nil)
        (setq match (assoc (format "%s-%s"
                                   (mt-extract-dipl-element-from-table-row (mt-grab-line))
                                   (mt-extract-position-element-from-table-row (mt-grab-line)))
                           lemmatised-rows))
        (if match
            (progn
              (mt-jump-to-lemma2-column)
              (insert (nth 1 (cadr match)))
              (mt-jump-to-msa-column)
              (insert (nth 0 (cadr match)))
              (mt-jump-to-norm1-column)
              (insert (nth 2 (cadr match))))
          ;; else, we just print CHECK! in lemma, msa and norm1 elements:
          (mt-jump-to-lemma2-column)
          (insert "CHECK!")
          (mt-jump-to-msa-column)
          (insert "CHECK!")
          (mt-jump-to-norm1-column)
          (insert "CHECK!")))
          (org-mode)
          (goto-char (point-min))
          (search-forward-regexp "^| +w ")
          (org-table-align)
          (write-file (format "%s%s" path-to-merged-files-folder file-name) nil))))

(defun mt-util-merge-lemmatised-and-non-lemmatised-tables-extract-lemmatised-table-from-file (file-name path-to-lemmatised-files-folder)
  (with-temp-buffer
    (insert-file-contents (format "%s%s" path-to-lemmatised-files-folder file-name))
    (goto-char (point-min))
    (search-forward ":s:")
    (delete-region (point-min) (1- (line-beginning-position)))
    (buffer-string)))

(defun mt-util-merge-lemmatised-and-non-lemmatised-tables-from-list (list-of-file-names
                                                                     path-to-lemmatised-files-folder
                                                                     path-to-non-lemmatised-files-folder
                                                                     path-to-merged-files-folder)
  (loop for i in list-of-file-names do
        (mt-util-merge-lemmatised-and-non-lemmatised-tables i
                                                            path-to-lemmatised-files-folder
                                                            path-to-non-lemmatised-files-folder
                                                            path-to-merged-files-folder)))

;; Example of how to generate som merged tables:
;; (mt-util-merge-lemmatised-and-non-lemmatised-tables-from-list '("323.org" "325.org" "326.org" "334.org" "337.org")
;;                                                               "/home/ask/Downloads/sammenfletning/lemmatiserede/"
;;                                                               "/home/ask/Downloads/sammenfletning/ulemmatiserede/"
;;                                                               "/home/ask/Downloads/sammenfletning/korrigerede/")

(provide 'mt-table-merge)
