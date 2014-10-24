(require 'loli-package "package")

(in-package #:loli)

(defun loli-validate-input (str &optional (p 0) (q t))
  (format *standard-output* "~A~%" str)
  (loop for c across str
     do
       (cond
         ((equal c #\()
          (if q
              (setq p (1+ p))))
         ((equal c #\))
          (if q
              (if (>= p 1)
                  (setq p (1- p))
                  (return-from loli-validate-input 'UNMATCHED-PARENTHESIS))))
         ((equal c #\")
          (setq q (not q)))))
  (return-from loli-validate-input (and q (= 0 p))))

(defun loli-get-input (&optional (in-stream *standard-input*))
  (let* ((tmp (read-line in-stream))
         (stat (loli-validate-input tmp)))
    (if (equal stat 'UNMATCHED-PARENTHESIS)
        (return-from loli-get-input 'UNIMPLEMENTED-ERROR)
        (loop while (not stat)
           do (setq tmp (concatenate 'string tmp (read-line in-stream))
                    stat (loli-validate-input tmp))))
    (return-from loli-get-input tmp)))

(defun tokenize (str)
  (loop for i = 0 then (1+ j)
     as j = (position #\Space str :start i)
     collect (subseq str i j)
     while j))

(defun loli-parse (str &optional (env '()))
  (let* ((trimed (string-trim '(#\Space #\Tab #\Newline) str))
         (token-lst (remove-if #'(lambda (x) (equalp x ""))
                               (tokenize trimed))))
    token-lst))

(defun loli-eval-sym (sym env)
  (cond
    ((equalp (loli-obj-value sym) "nil")
     loli-nil)
    ((equalp (loli-obj-value sym) "t")
     loli-t)
    ((null env)
     )
    )
  )

(defun loli-simple-eval (obj &optional (env '()))
  (cond
    ((sub-type-p (loli-obj-loli-type obj)
                 *type-sym*)
     'SYMBOL)
    ((sub-type-p (loli-obj-loli-type obj)
                 *type-cons*)
     'CONS)
    (t obj)))

(defun rep (top-env type-env &optional (in-stream *standard-input*))
  (loli-simple-eval
   (loli-get-input in-stream)))

(defun test-rep (&optional (in-stream *standard-input*))
  (loli-parse
   (loli-get-input in-stream)))

(provide 'loli-repl)