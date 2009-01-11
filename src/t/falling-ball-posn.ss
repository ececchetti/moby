;; The first three lines of this file were inserted by DrScheme. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname falling-ball-posn) (read-case-sensitive #t) (teachpacks ((lib "world.ss" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "world.ss" "teachpack" "htdp")))))
;; Simple falling ball example, with posns.

;; A world is a posn representing the x,y position of the red ball.

(define WIDTH 100)
(define HEIGHT 100)
(define RADIUS 5)

(define (tick w)
  (make-posn (+ (posn-x w) 5)
             (+ (posn-y w) 5)))

(define (hits-floor? w)
  (>= (posn-y w) HEIGHT))

(define (draw-scene w)
  (place-image (circle RADIUS "solid" "red") 
               (posn-x w)
               (posn-y w)
               (empty-scene WIDTH HEIGHT)))

(big-bang WIDTH HEIGHT 1/15 (make-posn 0 0))
(on-tick-event tick)
(on-redraw draw-scene)
(stop-when hits-floor?)