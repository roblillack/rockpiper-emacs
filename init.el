(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("ba881f92a04cf56df49740324caea02d25442a327f1c33d1a1946f0b9a846f53" "b72ffe34e9ff6ec347cb8fc86d3f214e999363d46022e784324f2a4fe60dcff4" default))
 '(package-selected-packages
   '(helm-projectile helm company magit undo-tree markdown-mode highlight-symbol go-mode bm modus-vivendi-theme modus-operandi-theme olivetti projectile xml-rpc worklog sudoku lua-mode json javascript highline highlight-parentheses find-file-in-project css-mode columnify clojure-mode)))

(require 'package)
(add-to-list 'package-archives
                          '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; Ok, rule is: GUI windows get light background, terminal windows get background matching
;; the terminal settings. (I prefer light background, but thats not possible everywhere)
(if (or window-system (not (eq 'dark (terminal-parameter nil 'background-mode))))
    (load-theme 'modus-operandi)
  (load-theme 'modus-vivendi))

(setq inhibit-startup-message t)
(setq *is-a-mac* (eq system-type 'darwin))

;; Set basic looks pretty early after startup ...

(xterm-mouse-mode 1)

;; Some window system specific settings.
(if window-system
  (progn
    (menu-bar-mode (if (eq system-type 'darwin) t -1))
    (tool-bar-mode -1)
    (setq line-number-mode t)
    (setq column-number-mode t))
  (menu-bar-mode -1))

(add-hook 'before-save-hook #'gofmt-before-save)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

; LOOK
(setq-default cursor-type '(bar . 2))                 ; cursor soll ein strich sein
(blink-cursor-mode t)                                 ; und blinken
(global-hl-line-mode (if window-system 1 -1))         ; aktive zeile markieren
(set-face-background 'hl-line "#eeeef8")              ; ... und lachsfarben anmalen
(show-paren-mode t)                                   ; klammern markieren
(setq paren-match-face 'paren-face-match-light)       ; ... die benutzte farbe setzen
(mouse-wheel-mode t)                                ; ein bissl rummausen
(setq mouse-wheel-scroll-amount '(3))               ; ... aber wirklich nur ein bissl
(when window-system
  (setq show-paren-style 'expression))                ; ... den kompletten content markieren

(setq parse-sexp-ignore-comments t)                   ; ignore comments when balancing stuff
(setq transient-mark-mode t)                          ; markierung live anzeigen
(setq visible-bell t)                                 ; schwarzer kasten statt sound
(display-time-mode t)                                 ; uhrzeit anzeigen
(size-indication-mode t)                              ; groesse des files anzeigen
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

; FEEL
(when *is-a-mac*
  (setq ns-command-modifier 'super)
  (setq ns-option-modifier 'meta)
  (setq ns-right-option-modifier nil))
(cua-mode t)                                          ; shift zum selektieren + std. keycombos
(setq cua-keep-region-after-copy t)                   ; markierung bleibt nach kopieren
                                        ;(require 'redo)                                       ; wir wollen eine simple lineare geschichte
(savehist-mode 1)                                     ; minibuffer-kram merken
(setq savehist-additional-variables                   ; ... eigentlich
      '(search-ring regexp-search-ring))              ; ... koennen wir uns suchen auch merken
(recentf-mode 1)                                      ; achja, die letzten offnen files. genau.
(setq kill-whole-line t)                              ; ctrl-k laesst keine leere zeile stehen
(setq-default truncate-lines t)                       ; zeilen abschneiden, nicht umbrechen
(defalias 'yes-or-no-p 'y-or-n-p)                     ; "y or n" statt "yes or no"
(setq imenu-auto-rescan t)                            ; symbole selbst neu einlesen
(icomplete-mode t)                                    ; completion im minibuffer ohne tab
(setq-default indent-tabs-mode nil)                   ; einruecken mit space
(setq-default tab-width 4)                            ; ein tab ist 4 zeichen breit
(setq-default c-basic-offset 4)                       ; indent ist 4 zeichen breit
(setq-default show-trailing-whitespace t)             ; whitespace am zeilenende zeigen
(setq scroll-conservatively 3)                        ; bei max 3 zeilen scrollen ohne recenter
(global-subword-mode t)                               ; CamelCase als EinzelWorte
(setq require-final-newline t)

; copy'n'paste behaviour
(when (eq window-system 'x)
  (setq mouse-drag-copy-region nil)                   ; mouse selection does NOT go into kill ring
  (setq x-select-enable-primary nil)                  ; NO killing/yanking with with primary X11 selection
  (setq x-select-enable-clipboard t)                  ; killing/yanking with clipboard X11 selection
  (setq select-active-regions t)                      ; active region sets primary X11 selection
  (when (>= emacs-major-version 23)
    (global-set-key [mouse-8] 'mouse-yank-primary)    ; use them crazy mouse buttons!
    (global-set-key [mouse-9] 'mouse-yank-primary)    ; indeed.
    (global-set-key [mouse-2] 'mouse-yank-primary)))  ; middle mouse button only pastes primary X11 selection

; shortcuts for font scaling
(global-set-key [(control mouse-2)] 'text-scale-mode)
(global-set-key [(control mouse-4)] 'text-scale-increase)
(global-set-key [(control mouse-5)] 'text-scale-decrease)
(global-set-key [(control wheel-up)] 'text-scale-increase)
(global-set-key [(control wheel-down)] 'text-scale-decrease)
(global-set-key [(super mouse-2)] 'text-scale-mode)
(global-set-key [(super mouse-4)] 'text-scale-increase)
(global-set-key [(super mouse-5)] 'text-scale-decrease)
(global-set-key [(super wheel-up)] 'text-scale-increase)
(global-set-key [(super wheel-down)] 'text-scale-decrease)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") 'text-scale-mode)
(global-set-key (kbd "C-<kp-add>") 'text-scale-increase)
(global-set-key (kbd "C-<kp-subtract>") 'text-scale-decrease)

(defun toggle-show-trailing-whitespace ()
  "Toggle the display of trailing whitespace, by changing the
buffer-local variable `show-trailing-whitespace'."
  (interactive)
  (save-excursion
    (setq show-trailing-whitespace
          (not show-trailing-whitespace))
    (redraw-display)
    (message (concat "Display of trailing whitespace "
                     (if show-trailing-whitespace
                         "enabled" "disabled")))))



; merkt sich, wo wir in welchem file waren
(require 'saveplace)
(setq save-place-file (convert-standard-filename "~/.emacs.d/places"))
(setq-default save-place t)

; skripte automatisch ausfuehrbar machen
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(random t)

(setq backup-directory-alist `(("." . ,(expand-file-name "~/.emacs.d/backups")))
      auto-save-default nil)

; edit as root
(defun sudo-edit (&optional arg)
  (interactive "p")
  (if arg
      (find-file (concat "/sudo::" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo::" buffer-file-name))))

(defun sudo-edit-current-file ()
  (interactive)
  (find-alternate-file (concat "/sudo::" (buffer-file-name (current-buffer)))))

(global-set-key (kbd "C-x !") 'sudo-edit-current-file)

(require 'tramp)
(add-to-list 'tramp-default-proxies-alist '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist '((regexp-quote (system-name)) nil nil))

; i do
;(ido-mode t)
;(setq ido-enable-flex-matching -1)
;(add-hook 'ido-setup-hook
;          (lambda ()
;            (define-key ido-completion-map [tab] 'ido-complete)))

; buffer cycling
(autoload 'cycle-buffer "cycle-buffer" "Cycle forward." t)
(global-set-key [(control tab)] 'cycle-buffer)
(global-set-key (kbd "<mode-line> <wheel-up>") 'cycle-buffer)
(global-set-key (kbd "<mode-line> <wheel-down>") 'cycle-buffer-backward)
(global-set-key (kbd "<mode-line> <mouse-4>") 'cycle-buffer)
(global-set-key (kbd "<mode-line> <mouse-5>") 'cycle-buffer-backward)

; frame switching
(global-set-key (kbd "C-`") 'next-multiframe-window)

; TODO: Broken
; do not open *Messages* when clicking into minibuffer
;(defun my-mouse-drag-region (event)
;  (interactive "e")
;  (run-hooks 'mouse-leave-buffer-hook)
;  (mouse-drag-track event t))
;(global-set-key [down-mouse-1] 'my-mouse-drag-region)

; mehrere files mit gleichem namen? verzeichnisse mit in puffernamen nehmen
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

(global-set-key (kbd "C-c q") 'refill-mode)
(setq fill-column 72)

(setq backup-by-copying-when-linked t)
(setq backup-by-copying-when-mismatch t)
(setq frame-title-format "%b — Emacs")

(defconst animate-n-steps 5)
(defun emacs-reloaded ()
  (animate-string (concat ";; Initialization successful, welcome to "
  			  (substring (emacs-version) 0 16)
			  ".")
		  0 0)
  (newline-and-indent)
  (newline-and-indent))
(when window-system
  (add-hook 'after-init-hook 'emacs-reloaded))


;(setq default-input-method "MacOSX")

;; full screen toggle using command+[RET]
(global-set-key [(super return)] 'toggle-frame-fullscreen)
(global-set-key [f11] 'toggle-frame-fullscreen)

; Terminal Key Sequence Translations
(if (null key-translation-map) (setq key-translation-map (make-sparse-keymap)))

; tab is tab
(define-key key-translation-map "\t" (kbd "<tab>"))

(define-key key-translation-map (kbd "\e[1;5A") (kbd "C-<up>"))
(define-key key-translation-map (kbd "\e[1;5B") (kbd "C-<down>"))
(define-key key-translation-map (kbd "\e[1;5C") (kbd "C-<right>"))
(define-key key-translation-map (kbd "\e[1;5D") (kbd "C-<left>"))
(define-key key-translation-map (kbd "\e[1;5H") (kbd "C-<home>"))
(define-key key-translation-map (kbd "\e[1;5F") (kbd "C-<end>"))

(define-key key-translation-map (kbd "\e[1;2A") (kbd "S-<up>"))
(define-key key-translation-map (kbd "\e[1;2B") (kbd "S-<down>"))
(define-key key-translation-map (kbd "\e[1;2C") (kbd "S-<right>"))
(define-key key-translation-map (kbd "\e[1;2D") (kbd "S-<left>"))
(define-key key-translation-map (kbd "\e[1;2H") (kbd "S-<home>"))
(define-key key-translation-map (kbd "\e[1;2F") (kbd "S-<end>"))

(define-key key-translation-map (kbd "\e[1;6A") (kbd "C-S-<up>"))
(define-key key-translation-map (kbd "\e[1;6B") (kbd "C-S-<down>"))
(define-key key-translation-map (kbd "\e[1;6C") (kbd "C-S-<right>"))
(define-key key-translation-map (kbd "\e[1;6D") (kbd "C-S-<left>"))
(define-key key-translation-map (kbd "\e[1;6H") (kbd "C-S-<home>"))
(define-key key-translation-map (kbd "\e[1;6F") (kbd "C-S-<end>"))

(define-key key-translation-map (kbd "\e[1~")   (kbd "<home>"))
(define-key key-translation-map (kbd "\e[4~")   (kbd "<end>"))
(define-key key-translation-map (kbd "\e[3~")   (kbd "<deletechar>"))
(define-key key-translation-map (kbd "\e[3;5~") (kbd "C-<delete>"))
(define-key key-translation-map (kbd "\e[5~")   (kbd "<prior>"))
(define-key key-translation-map (kbd "\e[6~")   (kbd "<next>"))
(define-key key-translation-map (kbd "\e[5;5~") (kbd "C-<prior>"))
(define-key key-translation-map (kbd "\e[5;6~") (kbd "C-<next>"))

(define-key key-translation-map (kbd "\e[rC;APOSTROPHE~") (kbd "C-'"))
(define-key key-translation-map (kbd "\e[rC;SEMICOLON~") (kbd "C-;"))
(define-key key-translation-map (kbd "\e[rC;SLASH~") (kbd "C-/"))
(define-key key-translation-map (kbd "\e[rC;QUOTE~") (kbd "C-\""))
(define-key key-translation-map (kbd "\e[rC;LT~") (kbd "C-<"))
(define-key key-translation-map (kbd "\e[rC;GT~") (kbd "C->"))
(define-key key-translation-map (kbd "\e[rC;DOT~") (kbd "C-."))
(define-key key-translation-map (kbd "\e[rC;COMMA~") (kbd "C-,"))
(define-key key-translation-map (kbd "\e[rC;BS~") (kbd "C-<backspace>"))
(define-key key-translation-map (kbd "\e[rC;DEL~") (kbd "C-<delete>"))
(define-key key-translation-map (kbd "\e[rA;LEFT~") (kbd "M-<left>"))
(define-key key-translation-map (kbd "\e[rA;RIGHT~") (kbd "M-<right>"))
(define-key key-translation-map (kbd "\e[rA;UP~") (kbd "M-<up>"))
(define-key key-translation-map (kbd "\e[rA;DOWN~") (kbd "M-<down>"))

(define-key key-translation-map (kbd "\e[rC;F~") (kbd "C-S-f"))
(define-key key-translation-map (kbd "\e[rC;O~") (kbd "C-S-o"))


; thx, http://www.emacswiki.org/emacs/BackwardDeleteWord
(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-word (- arg)))


(defun delete-line ()
  "Deletes the rest of the rest of the current line,
deletes the whole line, or joins with the following line
depending on the current position."
  (interactive)
  (let ((end (save-excursion (end-of-visible-line) (point))))
    (if (eq (point) end)
        (delete-char 1)
      (delete-region (point) end))))

(dolist (cmd
         '(delete-word backward-delete-word delete-line))
  (put cmd 'CUA 'move)
  )

(global-set-key (kbd "<home>") 'beginning-of-line)
(global-set-key (kbd "<end>") 'end-of-line)
(global-set-key (kbd "C-<home>") 'beginning-of-buffer)
(global-set-key (kbd "C-<end>") 'end-of-buffer)
(global-set-key (kbd "C-x C-n") 'make-frame)
                                        ;(global-set-key (kbd "<delete>") 'delete-char)
(global-set-key (kbd "<kp-delete>") 'delete-char)
(global-set-key (kbd "C-<kp-delete>") 'delete-word)
(global-set-key (kbd "<backspace>") 'delete-backward-char)
(global-set-key (kbd "C-<backspace>") 'backward-delete-word)
(global-set-key (kbd "C-w") 'backward-delete-word)
(global-set-key (kbd "C-k") 'delete-line)
(global-set-key (kbd "S-C-k") 'kill-line)

(defun join-with-next-line ()
  "Join the current and the following line."
  (interactive)
  (next-line)
  (join-line))

(global-set-key (kbd "M-j") 'join-with-next-line)

                                        ; Search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "C-f") 'isearch-forward-regexp)
(global-set-key (kbd "C-S-f") 'isearch-backward-regexp)
(define-key isearch-mode-map (kbd "<backspace>") 'isearch-del-char)
(define-key isearch-mode-map (kbd "<escape>") 'isearch-exit)
(define-key isearch-mode-map (kbd "<return>") 'isearch-repeat-forward)
(define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat)
(define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
(define-key isearch-mode-map (kbd "C-S-f") 'isearch-repeat-backward)
(define-key isearch-mode-map (kbd "C-g") 'isearch-repeat-forward)
(define-key isearch-mode-map (kbd "C-v") 'isearch-yank-kill)

; moving in panes/„windows“
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<down>") 'windmove-down)
(global-set-key (kbd "M-<delete>") 'delete-window)
(global-set-key (kbd "M-<kp-delete>") 'delete-window)
(global-set-key (kbd "M-<backspace>") 'delete-window)
(global-set-key (kbd "S-M-<delete>") 'delete-other-windows)
(global-set-key (kbd "S-M-<kp-delete>") 'delete-other-windows)
(global-set-key (kbd "S-M-<backspace>") 'delete-other-windows)
(global-set-key (kbd "M-<space>") 'split-window-horizontally)
(global-set-key (kbd "M-SPC") 'split-window-horizontally)
(global-set-key (kbd "S-M-<space>") 'split-window-vertically)
(global-set-key (kbd "S-M-SPC") 'split-window-vertically)
(global-set-key (kbd "M-<insert>") 'split-window-horizontally)
(global-set-key (kbd "M-=") 'enlarge-window-horizontally)
(global-set-key (kbd "M--")  'shrink-window-horizontally)
(global-set-key (kbd "M-+") 'enlarge-window)
(global-set-key (kbd "M-_") 'shrink-window)
(global-set-key (kbd "S-M-<insert>")  'split-window-vertically)

(global-set-key (kbd "s-<left>") 'windmove-left)
(global-set-key (kbd "s-<right>") 'windmove-right)
(global-set-key (kbd "s-<up>") 'windmove-up)
(global-set-key (kbd "s-<down>") 'windmove-down)
(global-set-key (kbd "s-<delete>") 'delete-window)
(global-set-key (kbd "s-<kp-delete>") 'delete-window)
(global-set-key (kbd "s-<backspace>") 'delete-window)
(global-set-key (kbd "S-s-<delete>") 'delete-other-windows)
(global-set-key (kbd "S-s-<kp-delete>") 'delete-other-windows)
(global-set-key (kbd "S-s-<backspace>") 'delete-other-windows)
(global-set-key (kbd "s-<space>") 'split-window-horizontally)
(global-set-key (kbd "s-SPC") 'split-window-horizontally)
(global-set-key (kbd "s-\\") 'split-window-horizontally)
(global-set-key (kbd "s-/") 'split-window-vertically)
(global-set-key (kbd "S-s-<space>") 'split-window-vertically)
(global-set-key (kbd "S-s-SPC") 'split-window-vertically)
(global-set-key (kbd "s-<insert>") 'split-window-horizontally)
(global-set-key (kbd "s-=") 'enlarge-window-horizontally)
(global-set-key (kbd "s--")  'shrink-window-horizontally)
(global-set-key (kbd "s-+") 'enlarge-window)
(global-set-key (kbd "s-_") 'shrink-window)
(global-set-key (kbd "S-s-<insert>")  'split-window-vertically)

;; Auto completion
;;
;; For the record: auto-complete-mode seems to be dead[1], company-mode
;; looks like the new standard.
;;
;; [1]: https://github.com/auto-complete/auto-complete

(add-hook 'after-init-hook 'global-company-mode)

;; Code navigation, et. al
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(global-set-key (kbd "C-S-f") 'helm-projectile-grep) ; find file in project
(global-set-key (kbd "C-S-o") 'helm-imenu)           ; jump to definition
(global-set-key (kbd "C-j") 'helm-imenu)             ; “jump” -- remove this, as I'm so used to VSCode's C-S-o?
(global-set-key (kbd "C-p") 'helm-projectile)        ; jump to file in project
(global-set-key (kbd "M-x") 'helm-M-x)

;; *** MAJOR MODES ***

; send mails from mutt
(add-to-list 'auto-mode-alist '("mutt-" . mail-mode))
(add-hook 'mail-mode-hook (lambda ()
                            (turn-on-auto-fill)
                            (flush-lines "^\\(> \n\\)*> -- *\n\\(\n?> .*\\)*")
                            (not-modified)
                            (mail-text)))

; Org+Remember
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;(add-to-list 'auto-mode-alist '("/org/.*$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "~/org"
                             "~/org/yasni"
                             "~/org/yasni/architekturmeetings"))
;(setq org-agenda-file-regexp "\\`[^.]+?\\'")
(setq org-agenda-tags-column -120)
(setq org-CUA-compatible t)
;(org-remember-insinuate)
(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cr" 'org-remember)
(setq org-clock-persist t)
;(org-clock-persistence-insinuate)
(setq org-startup-folded nil)
(define-key global-map (kbd "<f9>") 'toggle-org-journal)
(define-key global-map (kbd "C-c j") 'toggle-org-journal)
(define-key global-map (kbd "<f12>") 'toggle-org-agenda-list)

(defun toggle-org-agenda-list ()
  "Shows or hides the org-agenda list view"
  (interactive)
  (if (and (boundp 'org-agenda-buffer-name)
           (get-buffer org-agenda-buffer-name))
      (progn
        (org-agenda-exit)
        (set-window-configuration toggle-org-agenda-list-window-config))
    (progn
      (message "Loading agenda list …")
      (setq toggle-org-agenda-list-window-config (current-window-configuration))
      (org-agenda-list))))

; Journaling:
; Taken from http://metajack.im/2009/01/01/journaling-with-emacs-orgmode/
; Modified to allow toggling.
(defvar org-journal-file "~/org/journal.org" "Path to OrgMode journal file.")
(defvar org-journal-buffer-name "*JOURNAL*" "Name of the journal buffer")
(defvar org-journal-date-format "%Y-%m-%d %A (W%W)" "Date format string for journal headings.")

(defun toggle-org-journal ()
  "Shows or hides the org-journal view"
  (interactive)
  (let ((buf (get-buffer org-journal-buffer-name)))
    (if buf
        (with-current-buffer buf
          (save-buffer)
          (kill-buffer))
      (org-journal-entry))))

(defun org-journal-entry ()
  "Create a new diary entry for today or append to an existing one."
  (interactive)
  (find-file org-journal-file)
  (rename-buffer org-journal-buffer-name)
  (widen)
  (let ((today (format-time-string org-journal-date-format)))
    (beginning-of-buffer)
    (unless (org-goto-local-search-headings today nil t)
      ((lambda ()
         (org-insert-heading)
         (insert today)
         (insert "\n- \n"))))
    (beginning-of-buffer)
    (hide-body)
    (org-show-entry)
    (org-narrow-to-subtree)
    (end-of-buffer)
    (while (= (line-beginning-position) (line-end-position))
      (delete-backward-char 1))
    (unless (= (current-column) 2)
      (insert "\n- ")))
    (widen))

; Don't break the signature separator!
(add-hook 'before-save-hook
          (lambda ()
            (unless (eq major-mode 'mail-mode)
              (delete-trailing-whitespace))))

;(require 'w3m-load)

; robs bufferlist
(require 'bufferlist)

; whitespace-mode
(setq whitespace-display-mappings
      '((space-mark 32 [183] [46])
        (space-mark 160 [164] [95])
        (space-mark 2208 [2212] [95])
        (space-mark 2336 [2340] [95])
        (space-mark 3616 [3620] [95])
        (space-mark 3872 [3876] [95])
        (newline-mark 10 [8629 10])
        (tab-mark 9 [9654 9] [92 9])))

(global-set-key [f1] 'whitespace-mode)
(global-set-key (kbd "S-<f1>") 'global-whitespace-mode)
(global-set-key [f2] 'linum-mode)
(global-set-key (kbd "S-<f2>") 'global-linum-mode)
(global-set-key [f3] 'bufferlist)
(global-set-key [f4] 'kill-buffer-and-window)
(global-set-key [f7] 'shell)

; my bufferlist rocks, but sometimes i'm in the mood for ...
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)

(defun smart-tab ()
  "Indents region if mark is active, indents current line, or completes current input."
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or mark-active
            (not (looking-at "\\_>")))
        (smart-indent)
      (call-interactively 'company-complete))))

(defun smart-indent ()
  "Indents region if mark is active, or current line otherwise."
  (interactive)
  (if mark-active
      (indent-region (region-beginning)
                     (region-end))
    (indent-for-tab-command))
  (setq smart-tab-active nil))

(global-set-key (kbd "<tab>") 'smart-tab)

; bookmarks, see el-get-sources above
(require 'bm)
(setq-default bm-buffer-persistence t)
(setq bm-highlight-style 'bm-highlight-line-and-fringe)


(defun bm-try-jump (jmpfn)
  (if (= (bm-count) 0)
      (cua-exchange-point-and-mark nil)
    (progn
      (cua--deactivate)
      (funcall jmpfn))))

(defun bm-mouse-toggle (event)
  (interactive "e")
  (save-excursion (mouse-set-point event) (bm-toggle)))

(global-set-key (kbd "C-'") 'bm-toggle)
(global-set-key (kbd "C-,") '(lambda () (interactive) (bm-try-jump 'bm-previous)))
(global-set-key (kbd "C-.") '(lambda () (interactive) (bm-try-jump 'bm-next)))
(global-set-key [left-margin mouse-1] 'bm-mouse-toggle)
(global-set-key [left-fringe mouse-1] 'bm-mouse-toggle)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bm-fringe-persistent-face ((t (:background "#ccccff" :foreground "black"))))
 '(bm-persistent-face ((t (:background "#ccccff" :foreground "black")))))

; fringe, scroll bars & margins
(when window-system
  (set-fringe-mode '(8 . 2))
  (set-scroll-bar-mode nil))
(set-frame-parameter nil 'internal-border-width 0)
(set-frame-parameter nil 'line-spacing 0)
(set-frame-parameter nil 'scroll-bar-width 4)
(set-default 'indicate-empty-lines t)
(set-default 'indicate-buffer-boundaries '((up . left) (down . left) (t . nil)))

; Setup sane undo/redo functionality
(global-undo-tree-mode)
(global-set-key [(control z)] 'undo-tree-undo)
(global-set-key [(shift control z)] 'undo-tree-redo)
(define-key undo-tree-map (kbd "C-/") nil)
(define-key undo-tree-map (kbd "C-?") nil)
(define-key undo-tree-map (kbd "C-_") nil)

; Setup global (un)comment action
(defun comment-line-or-region ()
  "(Un)comments the selection or the current line."
  (interactive)
    (let ((a (point)))
      (comment-line nil)
      (goto-char a)))
(global-set-key (kbd "C-/") 'comment-line-or-region)

(defun close-and-kill-this-pane ()
  "If there are multiple windows, then close this pane and kill the buffer in it also."
  (interactive)
  (kill-this-buffer)
  (if (not (one-window-p))
      (delete-window)))
(global-set-key (kbd "C-x C-k") 'close-and-kill-this-pane)

; no fringe for minibuffer
(defun setup-echo-area ()
  (interactive)
  (walk-windows (lambda (w) (when (window-minibuffer-p w)
                              (set-window-fringes w 2 2 0))) t t))
(add-hook 'window-configuration-change-hook 'setup-echo-area)

; special minibuffer keys
(define-key minibuffer-local-map (kbd "C-u") '(lambda ()
                                                (interactive)
                                                (move-beginning-of-line nil)
                                                (delete-line)))
(define-key minibuffer-local-map [escape] 'abort-recursive-edit)

; mouse quits minibuffer
; from http://trey-jackson.blogspot.com/2010/04/emacs-tip-36-abort-minibuffer-when.html
(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (>= (recursion-depth) 1)
    (abort-recursive-edit)))
(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

; highlight-symbol, see el-get-sources above
(require 'highlight-symbol)
(defun highlight-symbol-mouse-toggle (event)
  (interactive "e")
  (save-excursion (mouse-set-point event) (highlight-symbol-at-point)))
(global-set-key (kbd "C-\"") 'highlight-symbol-at-point)
(global-set-key (kbd "C-<") '(lambda () (interactive) (cua--deactivate) (highlight-symbol-prev)))
(global-set-key (kbd "C->") '(lambda () (interactive) (cua--deactivate) (highlight-symbol-next)))
(global-set-key [(control shift mouse-1)] 'highlight-symbol-mouse-toggle)
(global-set-key [(control shift mouse-4)] '(lambda () (interactive) (cua--deactivate) (highlight-symbol-prev)))
(global-set-key [(control shift mouse-5)] '(lambda () (interactive) (cua--deactivate) (highlight-symbol-next)))
(global-set-key [(control shift wheel-up)] '(lambda () (interactive) (cua--deactivate) (highlight-symbol-prev)))
(global-set-key [(control shift wheel-down)] '(lambda () (interactive) (cua--deactivate) (highlight-symbol-next)))

;(require 'lusty-explorer)

;(add-to-list 'load-path "~/.emacs.d/plugins/emacs-w3m")
;(when (string= system-type "darwin")
;  (setq w3m-command "/sw/bin/w3m"))
;(setq browse-url-browser-function 'w3m-browse-url)
;(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;; optional keyboard short-cut
;(global-set-key "\C-xm" 'browse-url-at-point)


; browser settings
(when (eq window-system 'x)
  (setq browse-url-generic-program "google-chrome"))
(setq browse-url-browser-function 'browse-url-generic)

(global-set-key (kbd "C-x g") 'magit-status)
; to make sure smart-tab is not getting in our way here
(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "<tab>") #'magit-section-toggle))

; load initialization stuff that should not go into github :)
(load (expand-file-name "~/.emacs.d/private.el") t)

(when window-system
  (server-start))

;; (require 'edit-server)
;; (edit-server-start)
