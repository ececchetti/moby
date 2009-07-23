#lang s-exp "lang.ss"

(require "env.ss")
(require "helpers.ss")


;; toplevel-env: env
(define toplevel-env
  (local [(define top-env-1
            (foldl (lambda (id+name env)
                     (env-extend-constant env (first id+name) (second id+name)))
                   empty-env
                   '((null "plt.types.Empty.EMPTY")
                     (empty "plt.types.Empty.EMPTY")
                     (true "plt.types.Logic.TRUE")
                     (false "plt.types.Logic.FALSE")
                     (eof "plt.types.EofObject.EOF")
                     (pi "plt.Kernel.pi")
                     (e "plt.Kernel.e"))))
    
          ;; Registers a new toplevel function, munging the name
          (define (r env a-name arity vararity?)
            (env-extend-function env
                                 a-name 
                                 (resolve-module-path 'lang/htdp-beginner false)
                                 arity 
                                 vararity?
                                 (string-append 
                                  "plt.Kernel."
                                  (symbol->string (identifier->munged-java-identifier 
                                   a-name)))))

          
          ;; A special registration function that doesn't munge the kernel function name.
          (define (r* env a-name arity java-string)
            (env-extend-function env
                                 a-name 
                                 (resolve-module-path 'lang/htdp-beginner false)
                                 arity 
                                 false
                                 java-string))
          
          (define top-env-2
            (foldl (lambda (name+arity env)
                     (cond
                       [(= (length name+arity) 2)
                        (r env 
                           (first name+arity)
                           (second name+arity)
                           false)]
                       [(= (length name+arity) 3)
                        (r env
                           (first name+arity)
                           (second name+arity)
                           (if (symbol=? (third name+arity) 'true) true false))]))
                   
                   top-env-1
                   
                   ;; Numerics
                   '((< 2 true)
                     (<= 2 true)
                     (= 2 true)
                     (> 2 true)
                     (>= 2 true)
                     (abs 1)
                     (acos 1)
                     (add1 1)
                     (angle 1)
                     (asin 1)
                     (atan 1)
                     (ceiling 1)
                     (complex? 1)
                     (conjugate 1)
                     (cos 1)
                     (cosh 1)
                     (denominator 1)
                     (even? 1)
                     (exact->inexact 1)
                     (exact? 1)               ;; *
                     (exp 1)
                     (expt 2)
                     (floor 1)
                     (gcd 2 true)
                     (imag-part 1)
                     (inexact->exact 1)
                     (inexact? 1)
                     (integer->char 1)
                     (integer-sqrt 1)         ;; *
                     (integer? 1)
                     (lcm 2 true)
                     (log 1)
                     (magnitude 1)
                     (make-polar 2)           ;; *
                     (make-rectangular 2)     ;; *
                     (max 1 true)
                     (min 1 true)
                     (modulo 2)
                     (negative? 1)
                     (number->string 1)
                     (number? 1)
                     (numerator 1)
                     (odd? 1)
                     (positive? 1)
                     (quotient 1)
                     (random 1)
                     (rational? 1)
                     (real-part 1)
                     (real? 1)
                     (remainder 1)
                     (round 1)
                     (sgn 1)
                     (sin 1)
                     (sinh 1)
                     (sqr 1)
                     (sqrt 1)
                     (sub1 1)
                     (tan 1)
                     (zero? 1)
                     
                     (+ 0 true)
                     (- 1 true)
                     (* 0 true)
                     (/ 1 true)
                     
                     ;; Logic
                     (not 1)
                     (false? 1)
                     (boolean? 1)
                     (boolean=? 2)
                     
                     ;; Symbols
                     (symbol->string 1)
                     (symbol=? 2)
                     (symbol? 1)
                     
                     ;; Lists
                     (append 1 true)
                     (assq 2)                 ;; *
                     (caaar 1)
                     (caadr 1)
                     (caar 1)
                     (cadar 1)
                     (cadddr 1)
                     (caddr 1)
                     (cadr 1)
                     (car 1)
                     (cddar 1)
                     (cdddr 1)
                     (cddr 1)
                     (cdr 1)
                     (cdaar 1)
                     (cdadr 1)
                     (cdar 1)
                     (cons? 1)
                     (cons 2)
                     (empty? 1)
                     (length 1)
                     (list 0 true)
                     (list* 1 true)
                     (list-ref 2)
                     (member 2)
                     (memq 2)
                     (memv 2)
                     (null? 1)
                     (pair? 1)
                     (rest 1)
                     (reverse 1)
                     (first 1)
                     (second 1)
                     (third 1)
                     (fourth 1)
                     (fifth 1)
                     (sixth 1)
                     (seventh 1)
                     (eighth 1)
                     
                     ;; Posn
                     (make-posn 2)
                     (posn-x 1)
                     (posn-y 1)
                     (posn? 1)
                     
                     ;; Characters
                     (char->integer 1)
                     (char-alphabetic? 1)
                     (char-ci<=? 2 true)
                     (char-ci<? 2 true)
                     (char-ci=? 2 true)
                     (char-ci>=? 2 true)
                     (char-ci>? 2 true)
                     (char-downcase 1)
                     (char-lower-case? 1)
                     (char-numeric? 1)
                     (char-upcase 1)
                     (char-upper-case? 1)
                     (char-whitespace? 1)
                     (char<=? 2 true)
                     (char<? 2 true)
                     (char=? 2 true)
                     (char>=? 2 true)
                     (char>? 2 true)
                     (char? 1)
                     
                     ;; Strings
                     (format 1 true)
                     (list->string 1)
                     (make-string 2)
                     (replicate 2)            ;; *
                     (string 0 true)
                     (string->list 1)
                     (string->number 1)
                     (string->symbol 1)
                     (string-alphabetic? 1)   ;; *
                     (string-append 0 true)
                     (string-ci<=? 2 true)
                     (string-ci<? 2 true)
                     (string-ci=? 2 true)
                     (string-ci>=? 2 true)
                     (string-ci>? 2 true)
                     (string-copy 1)
;                     (string-ith 2)           ;; *
                     (string-length 1)
                     (string-lower-case? 1)   ;; *
                     (string-numeric? 1)      ;; *
                     (string-ref 2)
                     (string-upper-case? 1)   ;; *
                     (string-whitespace? 1)   ;; *
                     (string<=? 2 true)
                     (string<? 2 true)
                     (string=? 2 true)
                     (string>=? 2 true)
                     (string>? 2 true)
                     (string? 1)
                     (substring 3 )
                     
                     ;; Eof
                     (eof-object? 1)
                     
                     ;; Misc
                     (=~ 3)
                     (eq? 2)
                     (equal? 2)
                     (equal~? 3)
                     (eqv? 2)
                     (error 2)
                     (identity 1)
                     (struct? 1)
                     (current-seconds 0)
                     
                     ;; Higher-Order Functions
                     (andmap 2)
;                     (apply 2 true)           ;; *
                     (argmax 2)               ;; *
                     (argmin 2)               ;; *
                     (build-list 2)
                     (build-string 2)         ;; *
                     (compose 0 true)         ;; *
                     (filter 2)               ;; *
                     (foldl 2 true)
                     (foldr 2)                ;; *
                     (map 1 true)
                     (memf 2)                 ;; *
                     (ormap 2)                ;; *
                     (procedure? 1)           ;; *
                     (quicksort 2)            ;; *
                     (sort 2)                 ;; *
                     )))
          
          
          ;; These are identifiers we'll need to do the bootstrapping.
          (define top-env-3 
            (foldl (lambda (id+arity+name env)
                     (r* env (first id+arity+name) (second id+arity+name) (third id+arity+name)))
                   top-env-2
                   '((hash-set 3 "plt.Kernel._kernelHashSet")
                     (hash-ref 3 "plt.Kernel._kernelHashRef")
                     (hash-remove 2 "plt.Kernel._kernelHashRemove")
                     (make-immutable-hasheq 1 "plt.Kernel._kernelMakeImmutableHashEq")
                     (hash-map 2 "plt.Kernel._kernelHashMap")
                     (hash? 1 "plt.Kernel._isHash")
                     (path->string 1 "plt.Kernel._pathToString")
                     (normalize-path 1 "plt.Kernel._normalizePath")
                     (resolve-module-path 2 "plt.Kernel._resolveModulePath")
                     (build-path 2 "plt.Kernel._buildPath")

                     )))]
    top-env-3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(provide/contract
 [toplevel-env env?])