;;; pre-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

;; Description: Enable native compilation and dynamically adjust
;; the number of Elisp files compiled in parallel.
;;
;; Compatible with: Emacs >= 28.1 (because `num-processors' is required)
;;
;; URL: https://www.jamescherti.com/emacs-native-compilation-config-jobs/
;; License: MIT
;; Author: James Cherti

(defvar my-native-comp-reserved-cpus 2
  "Number of CPUs to reserve and not use for `native-compile'.")

(defun my-calculate-native-comp-async-jobs ()
  "Set `native-comp-async-jobs-number' based on the available CPUs."
  ;; The `num-processors' function is only available in Emacs >= 28.1
  (max 1 (- (num-processors) my-native-comp-reserved-cpus)))

(if (and (featurep 'native-compile)
         (fboundp 'native-comp-available-p)
         (native-comp-available-p))
    ;; Activate `native-compile'
    (setq native-comp-async-jobs-number (my-calculate-native-comp-async-jobs)
          native-comp-deferred-compilation t
          package-native-compile t)
  ;; Deactivate the `native-compile' feature if it is not available
  (setq features (delq 'native-compile features)))
