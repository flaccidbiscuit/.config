;; ustom init.el file for my own emacs configuration

;; add melpa packages to emacs
(require 'package)
 (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))  
 (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
 (package-initialize)

;; load use-package for cleaner package configuration
(eval-when-compile
 (require 'use-package))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-mode nil)
 '(package-selected-packages
   (quote
    (sublimity counsel helm minimap lsp-latex lsp-mode general use-package ewal evil-collection which-key org-evil evil-leader evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; remove emacs stock menu, scroll, and title bar (YUCK!)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(display-line-numbers-mode 1)

;; show matching parenthesis
(setq show-paren-delay 0)
(show-paren-mode 1)

;; set up babel-org mode for multiple langs
(org-babel-do-load-languages
 'org-babel-load-languages
 '((scheme . t)
   (C . t)))


;; allow evil mode everywhere
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;;enable which-key to show possible commands
(use-package which-key
  ;;(setq which-key-setup-side-window-bottom t)
  :config
  (which-key-mode 1))

;;use ewal to match current pywal theme
(use-package ewal
  :init (setq ewal-use-built-in-always-p nil
              ewal-use-built-in-on-failure-p t
              ewal-built-in-palette "sexy-material"))
(use-package ewal-spacemacs-themes
  :init (progn
          (setq spacemacs-theme-underline-parens t
                my:rice:font (font-spec
                              :family "Inconsolata"
                              :weight 'semi-bold
                              :size 11.0))
          (show-paren-mode +1)
          (global-hl-line-mode)
          (set-frame-font my:rice:font nil t)
          (add-to-list  'default-frame-alist
                        `(font . ,(font-xlfd-name my:rice:font))))
  :config (progn
            (load-theme 'ewal-spacemacs-modern t)
            (enable-theme 'ewal-spacemacs-modern)))
(use-package ewal-evil-cursors
  :after (ewal-spacemacs-themes)
  :config (ewal-evil-cursors-get-colors
           :apply t :spaceline t))
(use-package spaceline
  :after (ewal-evil-cursors winum)
  :init (setq powerline-default-separator nil)
  :config (spaceline-spacemacs-theme))

;; lsp-mode for language-specific completion
(use-package lsp-mode
  :config
  :hook (('c++-mode #'lsp)
	 ('scheme-mode #'lsp))
  (lsp-mode . lsp-enable-which-key-integration))
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

;; Geiser implementation for scheme
(use-package geiser)
(setq geiser-racket-binary "racket")
(setq geiser-default-implementation 'racket)

; Helm : for incremental completions and narrowing selections (with fuzzy matching)
(use-package helm
  :ensure t
  :init
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-candidate-number-list 50))

;; allow for tab autocomplete with helm
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") #'helm-select-action)

;; sublime-like minimap, smooth scrolling, and "beautification"
(use-package sublimity
  :init (setq sublimity-auto-hscroll-mode nil)
  :config (sublimity-mode 1))
(use-package sublimity-map
 ;; :after (sublimity)
  :init (setq sublimity-map-size 20)
	(setq sublimity-map-fraction 0.3)
	(setq sublimity-map-text-scale -7)
  :config	(sublimity-map-set-delay nil))
(use-package sublimity-scroll
  :init (setq sublimity-scroll-weight 10)
	(setq sublimity-scroll-drift-length 5))
(use-package sublimity-attractive
  :init (setq sublimity-attractive-centering-width nil))

;; enable using pdf-tools and viewing pdfs within emacs
(use-package pdf-tools
  :init (setq pdf-view-display-size 'fit-page))

;; set up org-agenda to be real cool and stuff
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "blue" :weight bold)
              ("PHONE" :foreground "blue" :weight bold))))
;;set colors for different priority levels
(setq org-priority-faces
      '((?A . (:foreground "#F0DFAF" :weight bold))
	(?B . (:foreground "LightSteelBlue"))
	(?C . (:foreground "OliveDrab"))))
;;default agenda file
(setq org-default-notes-file "~/org/agenda/refile.org")
;;directory/files to pull todo items from
(setq org-agenda-files (list
      "~/classes/ME 512-Finite Elements in ME Design/ME 512.org"
      "~/classes/ME 414-Mechanical Measurements/ME 414.org"
      "~/classes/ME 422-Machine Design II/ME 422.org"
      "~/classes/ME 415 Senior Mechanical Engineering Lab/ME 415.org"))
;;org capture templates
(setq org-capture-templates
      '(("t" "todo" entry
	 (file "~/org/agenda/refile.org")
	 "* TODO [#A] %?")
      ("m" "Meeting" entry
         (file "~/org/agenda/refile.org")
         "* MEETING %?")))


;;open agenda in current window
(setq org-agenda-window-setup
      (quote current-window))

;; Custom keybinding using general (spacemacs-esque)
(use-package general
  :ensure t
  :config (general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"
  "."   '(helm-find-files :which-key "find file")
  "/"   '(counsel-rg :which-key "ripgrep") ; You'll need counsel package for this
  "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
  "SPC" '(helm-M-x :which-key "M-x")
  "pf"  '(helm-find-file :which-key "find files")
  "e"  '(org-export-dispatch :which-key "export .org as:")
  ;;"mm"  '(toggle-sublimity-map :which-key "toggle code map")
  ;; Buffers
  "bb"  '(helm-buffers-list :which-key "buffers list")
  ;; Window
  "wl"  '(windmove-right :which-key "move right")
  "wh"  '(windmove-left :which-key "move left")
  "wk"  '(windmove-up :which-key "move up")
  "wj"  '(windmove-down :which-key "move bottom")
  "w/"  '(split-window-right :which-key "split right")
  "w-"  '(split-window-below :which-key "split bottom")
  "wx"  '(delete-window :which-key "delete window")
  ;; Others
  "at"  '(ansi-term :which-key "open terminal")
  ;; Org-mode
  "oe"  '(org-export-dispatch :which-key "export org file")
  "ox"  '(org-babel-execute-src-block :which-key "execute code block")
  ;; Org-agenda
  "oa"  '(org-agenda :which-key "open org agenda")
  "oc"  '(org-capture :which-key "capture todo items")
  "oi"  '(org-insert-todo-heading :which-key "insert todo item")
  "od"  '(org-deadline :which-key "set deadline") 
))

;; Custom function
(defun toggle-sublimity-map()
  "Toggle displaying the minimap to the left of the main buffer"
  (interactive)
  (if (sublimity-map-show)
      (setq sublimity-map-kill t) (message "minimap disabled") (setq sublimity-map-show nil)
      (setq sublimity-map-show t) (message "minimap enabled") (setq sublimity-map-kill nil)
	(redraw-display))
	;(revert-buffer))
