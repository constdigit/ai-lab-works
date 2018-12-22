; representes game board
(deftemplate board
  ; chips matrix
  (slot top-left(type NUMBER))
  (slot top-mid(type NUMBER))
  (slot top-right(type NUMBER))
  (slot mid-left(type NUMBER))
  (slot mid(type NUMBER))
  (slot mid-right(type NUMBER))
  (slot bottom-left(type NUMBER))
  (slot bottom-mid(type NUMBER))
  (slot bottom-right(type NUMBER))
  ; current node depth
  (slot depth(type NUMBER))
  ; 0 - new state
  ; 1 - treated
  ; 2 - goal
  (slot state(type NUMBER) (default 0))
)

(defglobal
  ?*step* = 0
)

(defglobal
  ?*limit* = 0
)

; get limit from user input
(defrule get-limit
(declare (salience 1000))
  (initial-fact)
=>
  (while (< ?*limit* 1)
    (printout t crlf "input max depth: " crlf ">> ")
    (bind ?*limit* (read))
    (printout t "limit =  " ?*limit* crlf)
  )
  ; make begin state
  (assert (board (top-left 5)        (top-mid 8)    (top-right 3)
         (mid-left 4)     (mid 0) (mid-right 2)
         (bottom-left 7)     (bottom-mid 6) (bottom-right 1)
         (depth 0) (state 0)
  ))
)

; delete repeated nodes
(defrule unique
  (declare (salience 1000))
  ?board-1<-(board  (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                    (mid-left ?ml) (mid ?m) (mid-right ?mr)
                    (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                    (state 1) (depth ?L& :(<= ?L ?*limit*)))
  ?board-2<-(board  (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                    (mid-left ?ml) (mid ?m) (mid-right ?mr)
                    (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                    (state 0) (depth ?L& :(<= ?L ?*limit*)))
=>
  (retract ?board-2)
)

(defrule get-successor-top-left
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left 0)    (top-mid ?mt) (top-right ?tr)
     (mid-left ?ml) (mid ?m) (mid-right ?mr)
     (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br))
=>
 (bind ?*step* (+ ?*step* 1))
  (modify ?f(state 1))
  (assert (board (top-left ?ml) (top-mid ?mt) (top-right ?tr)
                (mid-left 0) (mid ?m) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
          )
   )
  (assert (board (top-left ?mt) (top-mid 0) (top-right ?tr)
                 (mid-left ?ml) (mid ?m) (mid-right ?mr)
                 (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                 (depth (+ ?L 1))
         )
  )
)

(defrule get-successor-top-mid
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left ?tl)    (top-mid 0) (top-right ?tr)
     (mid-left ?ml) (mid ?m) (mid-right ?mr)
     (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br))
=>
 (bind ?*step* (+ ?*step* 1))
  (modify ?f(state 1))
  (assert (board (top-left ?tl) (top-mid ?m) (top-right ?tr)
                 (mid-left ?ml) (mid 0) (mid-right ?mr)
                 (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                 (depth (+ ?L 1))
          )
  )
  (assert (board (top-left 0) (top-mid ?tl) (top-right ?tr)
                 (mid-left ?ml) (mid ?m) (mid-right ?mr)
                 (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                 (depth (+ ?L 1))
          )
  )
  (assert (board (top-left ?tl) (top-mid ?tr) (top-right 0)
                 (mid-left ?ml) (mid ?m) (mid-right ?mr)
                 (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                 (depth (+ ?L 1))
          )
  )
)

(defrule get-successor-top-right
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left ?tl)    (top-mid ?mt) (top-right 0)
     (mid-left ?ml) (mid ?m) (mid-right ?mr)
     (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br))
=>
 (bind ?*step* (+ ?*step* 1))
 (modify ?f(state 1))
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?mr)
                (mid-left ?ml) (mid ?m) (mid-right 0)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
 (assert (board (top-left ?tl) (top-mid 0) (top-right ?mt)
                (mid-left ?ml) (mid ?m) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
 )
)

(defrule get-successor-mid-left
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left ?tl)    (top-mid ?mt) (top-right ?tr)
     (mid-left 0) (mid ?m) (mid-right ?mr)
     (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br))
=>
 (bind ?*step* (+ ?*step* 1))
 (modify ?f(state 1))
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?bl) (mid ?m) (mid-right ?mr)
                (bottom-left 0) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
 (assert (board (top-left 0) (top-mid ?mt) (top-right ?tr)
                (mid-left ?tl) (mid ?m) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
 )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?m) (mid 0) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
)

(defrule get-successor-mid
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left ?tl)    (top-mid ?mt) (top-right ?tr)
     (mid-left ?ml) (mid 0) (mid-right ?mr)
     (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br))
=>
 (bind ?*step* (+ ?*step* 1))
 (modify ?f(state 1))
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid ?bm) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid 0) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
 (assert (board (top-left ?tl) (top-mid 0) (top-right ?tr)
                (mid-left ?ml) (mid ?mt) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
 )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left 0) (mid ?ml) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid ?mr) (mid-right 0)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
)

(defrule get-successor-mid-right
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left ?tl)    (top-mid ?mt) (top-right ?tr)
     (mid-left ?ml) (mid ?m) (mid-right 0)
     (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br))
=>
 (bind ?*step* (+ ?*step* 1))
 (modify ?f(state 1))
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid ?m) (mid-right ?br)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right 0)
                (depth (+ ?L 1))
         )
  )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right 0)
                (mid-left ?ml) (mid ?m) (mid-right ?tr)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
 )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid 0) (mid-right ?m)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
)

(defrule get-successor-bottom-left
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left ?tl)    (top-mid ?mt) (top-right ?tr)
     (mid-left ?ml) (mid ?m) (mid-right ?mr)
     (bottom-left 0) (bottom-mid ?bm) (bottom-right ?br))
=>
 (bind ?*step* (+ ?*step* 1))
 (modify ?f(state 1))
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left 0) (mid ?m) (mid-right ?mr)
                (bottom-left ?ml) (bottom-mid ?bm) (bottom-right ?br)
                (depth (+ ?L 1))
         )
 )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid ?m) (mid-right ?mr)
                (bottom-left ?bm) (bottom-mid 0) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
)

(defrule get-successor-bottom-mid
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left ?tl)    (top-mid ?mt) (top-right ?tr)
     (mid-left ?ml) (mid ?m) (mid-right ?mr)
     (bottom-left ?bl) (bottom-mid 0) (bottom-right ?br))
=>
 (bind ?*step* (+ ?*step* 1))
 (modify ?f(state 1))
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid 0) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid ?m) (bottom-right ?br)
                (depth (+ ?L 1))
         )
  )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid ?m) (mid-right ?mr)
                (bottom-left 0) (bottom-mid ?bl) (bottom-right ?br)
                (depth (+ ?L 1))
         )
 )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid ?m) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid ?br) (bottom-right 0)
                (depth (+ ?L 1))
         )
  )
)

(defrule get-successor-bottom-right
  (declare (salience 100))
  ?f<-(board (state 0) (depth ?L& :(< ?L ?*limit*))
         (top-left ?tl)    (top-mid ?mt) (top-right ?tr)
     (mid-left ?ml) (mid ?m) (mid-right ?mr)
     (bottom-left ?bl) (bottom-mid ?bm) (bottom-right 0))
=>
 (bind ?*step* (+ ?*step* 1))
 (modify ?f(state 1))
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid ?m) (mid-right 0)
                (bottom-left ?bl) (bottom-mid ?bm) (bottom-right ?mr)
                (depth (+ ?L 1))
         )
 )
 (assert (board (top-left ?tl) (top-mid ?mt) (top-right ?tr)
                (mid-left ?ml) (mid ?m) (mid-right ?mr)
                (bottom-left ?bl) (bottom-mid 0) (bottom-right ?bm)
                (depth (+ ?L 1))
         )
  )
)

; comparison with goal state
(defrule is-goal
  (declare (salience 500))
  ?f<-(board (top-left 1)    (top-mid 2) (top-right 3)
     (mid-left 4) (mid 5) (mid-right 6)
     (bottom-left 7) (bottom-mid 8) (bottom-right 0)
     (state ~2) (depth ?L& :(<= ?L ?*limit*)))
=>
  (printout t "Goal found on depth = " (fact-slot-value ?f depth) crlf)
  (printout t "Opened nodes count =  " ?*step* crlf)
  (modify ?f(state 2))
)

; free nodes that are too deep
(defrule delete-deep
  (declare (salience 400))
  ?f<-(board (depth ?L& :(>= ?L ?*limit*)) (state ~2))
=>
  (retract ?f)
)

; free unused nodes
(defrule delete-not-answer
  (declare (salience 400))
  (board (state 2))
  ?f<-(board (state ~2))
=>
  (retract ?f)
)

(defrule not-found
  (declare (salience 200))
  (not (board(state 0|2)))
=>
  (halt)
  (printout t "Goal not found" crlf)
)

(defrule stop
  (declare (salience 200))
  (board(state 2))
=>
  (halt)
)