;; Copyright (C) 2007 Vesa Karvonen
;;
;; MLton is released under a BSD-style license.
;; See the file MLton-LICENSE for details.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Background Processor

(defun bg-job-start (done? step finalize &rest args)
  "Starts a background job.  The job is considered active as longs as

  (apply done? args)

returns nil.  While the job is active,

  (apply step args)

will be called periodically to perform a (supposedly small) computation
step.  After the job becomes inactive,

  (apply finalize args)

will be called once and the job will be discarded.

A job may call `bg-job-start' to start new jobs and multiple background
jobs may be active simultaneously."
  (push (cons args (cons done? (cons step finalize))) bg-job-queue)
  (bg-job-timer-start))

(defun bg-job-done? (job)
  (apply (cadr job) (car job)))

(defun bg-job-step (job)
  (apply (caddr job) (car job)))

(defun bg-job-finalize (job)
  (apply (cdddr job) (car job)))

(defvar bg-job-queue nil)
(defvar bg-job-timer nil)

(defconst bg-job-period 0.10)
(defconst bg-job-cpu-ratio 0.2)

(defun bg-job-timer-start ()
  (unless bg-job-timer
    (setq bg-job-timer
          (run-with-timer
           bg-job-period bg-job-period (function bg-job-quantum)))))

(defun bg-job-timer-stop ()
  (when bg-job-timer
    (def-use-delete-timer bg-job-timer)
    (setq bg-job-timer nil)))

(defun bg-job-quantum ()
  (let ((end-time (+ (bg-job-time-to-double (current-time))
                     (* bg-job-period bg-job-cpu-ratio))))
    (while (and (< (bg-job-time-to-double (current-time))
                   end-time)
                bg-job-queue)
      (let ((job (pop bg-job-queue)))
        (if (bg-job-done? job)
            (bg-job-finalize job)
          (bg-job-step job)
          (setq bg-job-queue (nconc bg-job-queue (list job)))))))
  (unless bg-job-queue
    (bg-job-timer-stop)))

(defun bg-job-time-to-double (time)
  (+ (* (car time) 65536.0)
     (cadr time)
     (* (caddr time) 1e-06)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'bg-job)