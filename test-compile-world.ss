#lang scheme/gui

(require "compile-world.ss" 
         scheme/runtime-path)

(define (start-up-debug-printing)
  (let ([receiver (make-log-receiver (current-logger) 
                                     #;'debug
                                     'error)])
    (thread (lambda ()
               (let loop ()
                 (let ([v (sync receiver)])
                   (display (vector-ref v 1))
                   (newline))
                 (loop))))
    receiver))
(define receiver (start-up-debug-printing))

;; Test programs live in t.
(define-runtime-path test-path "t")

;; Applications will be written to t-app.
(define-runtime-path test-app-j2me-path "t-app-j2me")
(define-runtime-path test-app-android-path "t-app-android")


;; make-test: string -> void
;; Builds the test application.
(define (make-test filename)
  (lambda (generator where)
    (generator
     (regexp-replace #rx".(ss|scm)$" (format "~a" filename) "")
     (build-path test-path filename)
     (build-path where (regexp-replace #rx".(ss|scm)$" (format "~a" filename) "")))))


;; Here are a few small examples that exercise small portions of the compiler.
(define test-falling-ball (make-test "falling-ball.ss"))
(define test-falling-cow (make-test "falling-cow.ss"))
(define test-falling-ball-posn (make-test "falling-ball-posn.ss"))
(define test-falling-ball-pair (make-test "falling-ball-pair.ss"))
(define test-pinholes (make-test "pinholes.ss"))
(define test-rectangles (make-test "rectangles.ss"))
(define test-hello-world (make-test "hello-world.ss"))
(define test-approx-equal (make-test "approx-equal.ss"))
(define test-struct-question (make-test "struct-question.ss"))


;; The programs here are the five programs of
;; How To Design Worlds (http://world.cs.brown.edu)
(define test-cowabunga (make-test "cowabunga.ss"))
(define test-flight-lander (make-test "flight-lander.ss"))
(define test-chicken (make-test "chicken.ss"))
(define test-fire-fighter (make-test "fire-fighter.ss"))
(define test-spaceflight (make-test "spaceflight.ss"))


;; Exercises the application generator.
(define (test-all g w)
  (for ([test (list 
               test-hello-world
               test-falling-ball 
               test-falling-cow 
               test-falling-ball-posn 
               test-falling-ball-pair 
               test-pinholes 
               test-rectangles 
               test-approx-equal 
               test-struct-question 
               
               test-cowabunga 
               test-flight-lander
               test-chicken
               test-fire-fighter
               test-spaceflight)])
    (test g w)))


(test-all generate-j2me-application test-app-j2me-path)
(test-all generate-android-application test-app-android-path)