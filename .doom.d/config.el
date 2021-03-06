;;; config.el -*- lexical-binding: t; -*-

;; Here are some additional functions/macros that could help you configure Doom:

;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys

;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.

;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq user-full-name "Robin Brusbo"
      user-mail-address "robinbrusbo@gmail.com")

;; Hack
;; JetBrains Mono
(setq doom-font (font-spec :family "JetBrains Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 16)
      )

(setq doom-theme 'doom-vibrant)
(delq! t custom-theme-load-path)

(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

;; Fullscreen
;; (add-to-list 'initial-frame-alist '(fullscreen . fullboth))

(setq
 +ivy-buffer-preview t
 auto-revert--lockout-interval 0.25
 auto-revert-interval 0.5
 auto-save-default t
 confirm-kill-emacs nil
 display-line-numbers-type 'relative
 display-time-24hr-format t
 display-time-default-load-average nil
 ivy-read-action-function #'ivy-hydra-read-action    ; C-o shows actions you can do while searching for files
 which-key-idle-delay 0.2
 )

(setq-default
 ;; auto-fill-function 'do-auto-fill                 ; Auto fill, start on new paragraph when too "thick"
 delete-by-moving-to-trash t
 tab-width 4
 window-combination-resize t
 )

(global-auto-revert-mode +1)                         ; Refresh buffers, e.g. pdf
(global-subword-mode +1)                             ; Iterate through CamelCase words

(map! :map evil-window-map
      ;; Change window
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Move window
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right
      )

(map!
 "<g-up>" #'evil-previous-visual-line
 "<g-down>" #'evil-next-visual-line
 )

(after! company
  (setq
   company-idle-delay 3
   company-show-numbers t
   )
  )

(setq
 lsp-signature-auto-activate nil
 lsp-ui-doc-enable nil
 )

(defun compilation-exit-autoclose (status code msg)
  ;; If M-x compile exists with a 0
  (when (and (eq status 'exit) (zerop code))
    ;; then bury the *compilation* buffer, so that C-x b doesn't go there
    (bury-buffer)
    ;; and delete the *compilation* window
    (delete-window (get-buffer-window (get-buffer "*compilation*"))))
  ;; Always return the anticipated result of compilation-exit-message-function
  (cons msg code))
;; Specify my function (maybe I should have done a lambda function)
(setq compilation-exit-message-function 'compilation-exit-autoclose)

(setq calendar-holidays nil)

(after! org-gcal
  (setq org-gcal-client-id "597804795230-vg4rb2u9kp2858rvos84066u38jhnvh7.apps.googleusercontent.com"
        org-gcal-client-secret "a4KJLMxw73uRQop1WKZcO2Xz"
        org-gcal-notify-p nil
        org-gcal-fetch-file-alist '(("randomthingyderp@gmail.com" .  "~/Sync/Gcal/flyslime.org")
                                    ("l10bcp86rfc7ip5og8qc7mmqn0@group.calendar.google.com" . "~/Sync/Gcal/pygmypuff.org")
                                    ))
  )

(defun my--cfw:open-calendar-buffer-view (orig-func &rest args &allow-other-keys)
  (apply orig-func :view 'two-weeks :allow-other-keys t args)
  )

(advice-add 'cfw:open-calendar-buffer :around #'my--cfw:open-calendar-buffer-view)

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; org-agenda source
    (cfw:org-create-file-source "personal" "~/Sync/Gcal/flyslime.org" "Orange")
    (cfw:org-create-file-source "elsa" "~/Sync/Gcal/pygmypuff.org" "Pink")
    (cfw:ical-create-source "school" "https://cloud.timeedit.net/chalmers/web/public/ri6YQ3ygZ05ZZnQ1X75v5Y075045x4Z66g080YQQ61765Q5.ics" "White")
    )))

(map!
 :desc "Open calendar"
 :leader "o c" #'my-open-calendar)

(add-hook! 'cfw:calendar-mode-hook
  (progn
    (+workspace-switch "Calendar" t)
    (+workspace/display))
  (add-hook! 'doom-switch-buffer-hook 'save-some-buffers))

(after! evil-snipe
  (evil-snipe-mode -1)                               ; Disable Doom's snipe mode, ruins other bindings
  )

(after! evil-surround
  (global-evil-surround-mode -1)                     ; Remove Doom's default for 's' and 'S'
  )

(map!
 :v "s" #'evil-surround-region                       ; Switch the lower-case and upper-case
 :v "S" #'evil-substitute
 :v "gS" #'evil-Surround-region
 )

(setq
 evil-escape-key-sequence "fd"                       ; Sequence to exit
 evil-escape-unordered-key-sequence t                ; Mash to exit
 evil-want-fine-undo t                               ; Fine tune the undo's, instead of one huge removal
 evil-split-window-below t                           ; Switch to new window
 evil-vsplit-window-right t                          ; ^
 )

(require 'auto-dictionary)
(add-hook 'flyspell-mode-hook (lambda () (auto-dictionary-mode 1)))

(setq
 haskell-interactive-popup-errors nil
 )

(map! :map cdlatex-mode-map
      :i "TAB" #'cdlatex-tab)
(setq
 +latex-viewers '(pdf-tools zathura okular)
 TeX-command-force "Clean All"                       ; C-c C-c to clean all instead of a menu
 )

;; Hooks
(add-hook! 'LaTeX-mode-hook
           ;; TeX-fold on save & opening LaTeX buffer
           (add-hook! 'before-save-hook #'TeX-fold-buffer)
           (add-hook! 'doom-switch-buffer-hook #'TeX-fold-buffer)
           ;; Compile after save
           (add-hook! 'after-save-hook :local
             (TeX-command "LatexMk" #'TeX-master-file)))

(after! pdf-tools
  ;; (add-hook 'pdf-tools-enabled-hook #'pdf-view-midnight-minor-mode)
  (setq-default
   pdf-view-display-size 'fit-width
   )
  )

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)
(after! elfeed
  (setq
   elfeed-search-filter "@6-months-ago "
   elfeed-db-directory "~/Sync/Elfeed/"
   )
  )

(setq
 treemacs-width 28
 )

(after! vterm
  (set-popup-rule!
    "^\\*doom:\\(?:v?term\\|e?shell\\)-popup"
    ;; :side 'right
    :size 0.2
    )
    (set-evil-initial-state! 'vterm-mode 'emacs)
  )

(setq org-directory "~/Sync/Org/")
(setq-hook! 'org-mode-hook line-spacing 5)

(after! org
  (setq
   calendar-week-start-day 1
   org-agenda-span 14
   ;; org-startup-with-inline-images t
   ;; org-startup-with-latex-preview t
   )
  (setq org-todo-keywords '((sequence
                             "TODO(t)"
                             "ACTIVE(a)"    ; Current task working on
                             "NEXT(n)"      ; Next task to complete
                             "SOMEDAY(s)"   ; Will pick up in the future
                             "WAITING(w)"   ; Awaiting more information / Put on hold
                             "DONE(d)"      ; Has to be after TODO
                             )
                            (sequence
                             "[ ](T)"
                             "[-](A)"       ; Current task working on
                             "[W](W)"       ; Awaiting more information / Put on hold
                             "[X](D)"
                             )))
  )

(use-package! org-super-agenda
  :commands (org-super-agenda-mode)
  )

(after! org-agenda
  (org-super-agenda-mode)
  )

(setq
 org-agenda-block-separator nil
 org-agenda-compact-blocks t
 org-agenda-include-deadlines t
 org-agenda-skip-deadline-if-done t
 org-agenda-skip-scheduled-if-done t
 org-agenda-tags-column 100
 )

(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 0)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 3)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 4)
                          (:name "Future"
                           :todo "SOMEDAY"
                           :order 5)
                          (:name "Important"
                           :priority "A"
                           :order 6)
                          (:name "University"
                           :tag "uni"
                           :order 10)
                          (:name "Reminders"
                           :tag "reminder"
                           :order 20)
                          (:name "Business and Technology"
                           :tag ("business" "tech")
                           :order 30)
                          (:name "Projects"
                           :tag ("project")
                           :order 40)
                          (:name "Reading"
                           :tag "read:book"
                           :order 50)
                          (:name "Check out"
                           :tag "read:web"
                           :order 55)
                          (:name "Awaiting more information / Put on hold"
                           :todo "WAITING"
                           :order 60)
                          (:name "Purchase"
                           :tag "buy"
                           :order 70)
                          (:name "Game List"
                           :tag "game"
                           :order 85)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

(use-package! doct
  :commands (doct))

(after! org-capture
  (defun org-capture-select-template-prettier (&optional keys)
    "Select a capture template, in a prettier way than default
Lisp programs can force the template by setting KEYS to a string."
    (let ((org-capture-templates
           (or (org-contextualize-keys
                (org-capture-upgrade-templates org-capture-templates)
                org-capture-templates-contexts)
               '(("t" "Task" entry (file+headline "" "Tasks")
                  "* TODO %?\n  %u\n  %a")))))
      (if keys
          (or (assoc keys org-capture-templates)
              (error "No capture template referred to by \"%s\" keys" keys))
        (org-mks org-capture-templates
                 "Select a capture template\n???????????????????????????????????????????????????????????????????????????"
                 "Template key: "
                 `(("q" ,(concat (all-the-icons-octicon "stop" :face 'all-the-icons-red :v-adjust 0.01) "\tAbort")))))))
  (advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)

  (defun org-mks-pretty (table title &optional prompt specials)
    "Select a member of an alist with multiple keys. Prettified.

TABLE is the alist which should contain entries where the car is a string.
There should be two types of entries.

1. prefix descriptions like (\"a\" \"Description\")
   This indicates that `a' is a prefix key for multi-letter selection, and
   that there are entries following with keys like \"ab\", \"ax\"???

2. Select-able members must have more than two elements, with the first
   being the string of keys that lead to selecting it, and the second a
   short description string of the item.

The command will then make a temporary buffer listing all entries
that can be selected with a single key, and all the single key
prefixes.  When you press the key for a single-letter entry, it is selected.
When you press a prefix key, the commands (and maybe further prefixes)
under this key will be shown and offered for selection.

TITLE will be placed over the selection in the temporary buffer,
PROMPT will be used when prompting for a key.  SPECIALS is an
alist with (\"key\" \"description\") entries.  When one of these
is selected, only the bare key is returned."
    (save-window-excursion
      (let ((inhibit-quit t)
            (buffer (org-switch-to-buffer-other-window "*Org Select*"))
            (prompt (or prompt "Select: "))
            case-fold-search
            current)
        (unwind-protect
            (catch 'exit
              (while t
                (setq-local evil-normal-state-cursor (list nil))
                (erase-buffer)
                (insert title "\n\n")
                (let ((des-keys nil)
                      (allowed-keys '("\C-g"))
                      (tab-alternatives '("\s" "\t" "\r"))
                      (cursor-type nil))
                  ;; Populate allowed keys and descriptions keys
                  ;; available with CURRENT selector.
                  (let ((re (format "\\`%s\\(.\\)\\'"
                                    (if current (regexp-quote current) "")))
                        (prefix (if current (concat current " ") "")))
                    (dolist (entry table)
                      (pcase entry
                        ;; Description.
                        (`(,(and key (pred (string-match re))) ,desc)
                         (let ((k (match-string 1 key)))
                           (push k des-keys)
                           ;; Keys ending in tab, space or RET are equivalent.
                           (if (member k tab-alternatives)
                               (push "\t" allowed-keys)
                             (push k allowed-keys))
                           (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) (propertize "???" 'face 'font-lock-comment-face) "  " desc "???" "\n")))
                        ;; Usable entry.
                        (`(,(and key (pred (string-match re))) ,desc . ,_)
                         (let ((k (match-string 1 key)))
                           (insert (propertize prefix 'face 'font-lock-comment-face) (propertize k 'face 'bold) "   " desc "\n")
                           (push k allowed-keys)))
                        (_ nil))))
                  ;; Insert special entries, if any.
                  (when specials
                    (insert "???????????????????????????????????????????????????????????????????????????\n")
                    (pcase-dolist (`(,key ,description) specials)
                      (insert (format "%s   %s\n" (propertize key 'face '(bold all-the-icons-red)) description))
                      (push key allowed-keys)))
                  ;; Display UI and let user select an entry or
                  ;; a sub-level prefix.
                  (goto-char (point-min))
                  (unless (pos-visible-in-window-p (point-max))
                    (org-fit-window-to-buffer))
                  (let ((pressed (org--mks-read-key allowed-keys prompt nil)))
                    (setq current (concat current pressed))
                    (cond
                     ((equal pressed "\C-g") (user-error "Abort"))
                     ;; Selection is a prefix: open a new menu.
                     ((member pressed des-keys))
                     ;; Selection matches an association: return it.
                     ((let ((entry (assoc current table)))
                        (and entry (throw 'exit entry))))
                     ;; Selection matches a special entry: return the
                     ;; selection prefix.
                     ((assoc current specials) (throw 'exit current))
                     (t (error "No entry available")))))))
          (when buffer (kill-buffer buffer))))))
  (advice-add 'org-mks :override #'org-mks-pretty)

  (defun +doct-icon-declaration-to-icon (declaration)
    "Convert :icon declaration to icon"
    (let ((name (pop declaration))
          (set  (intern (concat "all-the-icons-" (plist-get declaration :set))))
          (face (intern (concat "all-the-icons-" (plist-get declaration :color))))
          (v-adjust (or (plist-get declaration :v-adjust) 0.01)))
      (apply set `(,name :face ,face :v-adjust ,v-adjust))))

  (defun +doct-iconify-capture-templates (groups)
    "Add declaration's :icon to each template group in GROUPS."
    (let ((templates (doct-flatten-lists-in groups)))
      (setq doct-templates (mapcar (lambda (template)
                                     (when-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
                                                 (spec (plist-get (plist-get props :doct) :icon)))
                                       (setf (nth 1 template) (concat (+doct-icon-declaration-to-icon spec)
                                                                      "\t"
                                                                      (nth 1 template))))
                                     template)
                                   templates))))

  (setq doct-after-conversion-functions '(+doct-iconify-capture-templates))

  ;; Templates for org-capture
  (defun set-org-capture-templates ()
    (setq org-capture-templates
          (doct `(
                  ("Ideas" :keys "i"
                   :icon ("bubble_chart" :set "material" :color "silver")
                   :datetree t
                   :tree-type month
                   :file "ideas.org"
                   ;; :i-type "idea"
                   :type entry
                   ;; :template "* [ ] %? :%{i-type}:"
                   :template "* [ ] %? %^G"
                   )
                  ;; Change name?
                  ("Links" :keys "l"
                   :icon ("link" :set "octicon" :color "lcyan")
                   :file "links.org"
                   :type entry
                   :prepend t
                   :template "* [ ] %{desc} %?:%{i-type}:"
                   :children (
                              ("Articles" :keys "a"
                               :icon ("file-text" :set "octicon" :color "blue")
                               :desc "%(org-cliplink-capture)"
                               :headline "Articles"
                               :i-type "read:article"
                               )
                              ("Books" :keys "b"
                               :icon ("book" :set "material" :color "dmaroon")
                               ;; Automate?...
                               :desc ""
                               :headline "Books"
                               :i-type "read:book"
                               )
                              ("Web-pages" :keys "w"
                               :icon ("globe" :set "faicon" :color "yellow")
                               :desc "%(org-cliplink-capture)"
                               :headline "Web-page"
                               :i-type "read:web"
                               )
                              ))
                  ("Tasks" :keys "t"
                   :datetree t
                   :file "tasks.org"
                   :icon ("tasks" :set "faicon" :color "yellow")
                   :template "* TODO %? %^G%{extra}"
                   :tree-type month
                   :type entry
                   :children (
                              ("General Tasks" :keys "g"
                               :icon ("inbox" :set "octicon" :color "yellow")
                               :extra ""
                               :prepend t
                               )
                              ("Deadlines" :keys "d"
                               :icon ("timer" :set "material" :color "orange" :v-adjust -0.1)
                               :extra "\nDEADLINE: %^{Deadline:}t"
                               )
                              ("Scheduled" :keys "s"
                               :icon ("calendar" :set "octicon" :color "blue")
                               :extra "\nSCHEDULED: %^{Start time:}t"
                               )
                              ))
                  ("University" :keys "u"
                   :icon ("graduation-cap" :set "faicon" :color "purple")
                   :file "university.org"
                   ;; Change manually
                   :headline "??rskurs 1"
                   :type entry
                   :children (
                              ("Assignments" :keys "a"
                               :icon ("library_books" :set "material" :color "orange")
                               :template ("* TODO %? :uni:assignment:" "DEADLINE: %^{Due date:}T")
                               )
                              ("Exams" :keys "e"
                               :icon ("timer" :set "material" :color "red")
                               :template ("* TODO %? :uni:exam:" "SCHEDULED: %^{Exam date:}T")
                               )
                              ("Miscellaneous" :keys "m"
                               :icon ("list" :set "faicon" :color "yellow")
                               :prepend t
                               :template ("* TODO %? :uni:")
                               )
                              ))
                  ))))

  (set-org-capture-templates)
  (unless (display-graphic-p)
    (add-hook 'server-after-make-frame-hook
              (defun org-capture-reinitialise-hook ()
                (when (display-graphic-p)
                  (set-org-capture-templates)
                  (remove-hook 'server-after-make-frame-hook
                               #'org-capture-reinitialise-hook))))))
