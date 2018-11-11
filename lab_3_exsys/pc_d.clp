;defrule to initialize the k-base
(defrule init
	(initial-fact)
=>
  (printout t "Выберите проблему: " crlf)
	(printout t "  1. Процессор" crlf)
	(printout t "  2. Оперативная память" crlf)
	(printout t "  3. Материнская плата" crlf)
	(printout t "  4. Жесткий диск" crlf)
	(printout t "  5. Источник проблемы не известен" crlf)
  (bind ?problem (read))

  (if (eq ?problem 1)
    then (assert(cpu-prob 1))
  )
	(if (eq ?problem 2)
    then (assert(ram-prob 1))
  )
	(if (eq ?problem 3)
    then (assert(mb-prob 1))
  )
	(if (eq ?problem 4)
    then (assert(hdd-prob 1))
  )
	(if (eq ?problem 5)
    then (assert(inspect-prob 1))
  )

  (if (and :(integerp ?problem) (< ?problem 1) (> ?problem 5))
    then (printout t "Введите целое число от 1 до 5" crlf)
  )
)

(defrule cpu-problems
	(cpu-prob 1)
=>
	; (printout t "Вы недавно собирали ПК или проводил аппаратное обновление?" crlf)
	; (bind ?upgrade (read))
	; (if  (or (eq ?upgrade y) (eq ?upgrade да))
	; 	then (assert (pc-upgrade 1))
	; )

	(printout t "Перегривается ли процессор?" crlf)
	(bind ?oheat (read))
	(if  (or (eq ?oheat y) (eq ?oheat да))
		then (assert (cpu-oheat 1))
		else (assert (cpu-oheat 0))
	)

	(printout t "Настройки BIOS корректны?" crlf)
	(bind ?bios (read))
	(if  (or (eq ?bios y) (eq ?bios да))
		then (assert (cpu-bios 1))
		else (assert (cpu-bios 0))
	)

	(printout t "Поддерживается ли процессор данной материнской платой?" crlf)
	(bind ?mboard (read))
	(if  (or (eq ?mboard n) (eq ?mboard нет))
		then (assert (cpu-notsupport 1))
		else (assert (cpu-notsupport 0))
	)

	(printout t "Перезагружается ли система без предупреждения?" crlf)
	(bind ?crash (read))
	(if  (or (eq ?crash y) (eq ?crash да))
		then (assert (cpu-crash 1))
		else (assert (cpu-crash 0))
	)

	(printout t "Процессор работает медленнее (при этом возможно появление системных уведомлений о некорректной работе процессора)?" crlf)
	(bind ?speed (read))
	(if  (or (eq ?speed y) (eq ?speed да))
		then (assert (cpu-slow 1))
		else (assert (cpu-slow 0))
	)
)

(defrule cpu-overheating
	(cpu-oheat 1)
=>
(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t "Измерьте температуру процессора: " crlf)
	(printout t "  1. Запустите ресурсоемкое приложение на некоторое время (бенчмарк)" crlf)
	(printout t "  2. Запустите специальную утилиту для диагностики процессора (cpu-z, aida) или перезагрузите ПК, чтобы посмотреть темпеартуру в BIOS" crlf)
	(printout t "Если температура процессора больше 80 градусов, то это серьезная проблема:" crlf)
	(printout t "  - Проверьте установку процессора: он должен быть закреплен в сокете, сверху плотно прижат кулером." crlf)
	(printout t "  - Проверите, что процессор получает необходимы вольтаж." crlf)
	(printout t "  - Удостоверьтесь, что кулер подходит для данного процессора (по рассеиваемой мощности)." crlf)
	(printout t "  - Если кулер сильно загрязнен пылью, необходимо его очистить." crlf)
	(printout t "  - Попробуйте нанести свежую термопасту между процессором и кулером." crlf)
)

(defrule cpu-incorrect-bios
	(cpu-bios 1)
=>
	(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t "Если вы проверили настройки BIOS и они некорректны, попробуйте выполнить установку настроек по-умолчанию." crlf)
)

(defrule cpu-mboard-support
	(cpu-notsupport 1)
=>
	(printout t "-------------------------------------------------------------------------------------------------------------------------" crlf)
	(printout t "Если процессор несовместим с материнской платой:" crlf)
	(printout t "  - Возможно, необходимо обновление BIOS." crlf)
	(printout t "  - Свяжитесь с тех. поддержкой производителя." crlf)
)

(defrule cpu-crashing
	(cpu-crash 1)
=>

)

; CLIPS> (clear)
; CLIPS> (reset)
; CLIPS> (assert (red 100) (green 125) (blue 200))
; <Fact-3>
; CLIPS> (reset)
; CLIPS> (deffacts rgb "color" (red 100) (green 125) (blue 200))
; CLIPS> (defrule data-input
;   (initial-fact)
; =>
;   (printout t crlf "start" crlf)
;   (assert (red 100) (green 125) (blue 200)))
; ==> Activation 0      data-input: f-0
; CLIPS> (defrule Y
;     (red ?r)
;     (green ?g)
;     (test (and (> ?r 0) (> ?g 0)))
; =>
;     (printout t crlf crlf "get yellow" crlf)
;     (assert (yellow 255)))
; CLIPS> (defrule C
;     (blue ?b)
;     (green ?g)
;     (test (and (> ?b 0) (> ?g 0)))
; =>
;     (printout t crlf crlf "get cyan" crlf)
;     (assert (cyan 255)))
; CLIPS> (defrule W
;     (yellow ?y)
;     (cyan ?c)
;     (test (and (> ?y 0) (> ?c 0)))
; =>
;     (printout t crlf crlf "get white" crlf)
;     (assert (white 255)))
; CLIPS> (watch facts)
; CLIPS> (watch activations)
; CLIPS> (watch rules)
; CLIPS> (reset)
; CLIPS> (run)
; FIRE    1 data-input: f-0
;
; start
; ==> f-1     (red 100)
; ==> f-2     (green 125)
; ==> Activation 0      Y: f-1,f-2
; ==> f-3     (blue 200)
; ==> Activation 0      C: f-3,f-2
; FIRE    2 C: f-3,f-2
;
;
; get cyan
; ==> f-4     (cyan 255)
; FIRE    3 Y: f-1,f-2
;
;
; get yellow
; ==> f-5     (yellow 255)
; ==> Activation 0      W: f-5,f-4
; FIRE    4 W: f-5,f-4
;
;
; get white
; ==> f-6     (white 255)
