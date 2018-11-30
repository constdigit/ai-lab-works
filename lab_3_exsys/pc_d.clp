;defrule for initializing
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

; trying to find problem source
(defrule inspect-problem
	(inspect-prob)
=>
	(printout t "Вы недавно собирали ПК или проводил аппаратное обновление?" crlf)
	(bind ?assembled (read))
	(if  (or (eq ?assembled y) (eq ?assembled да))
		then
		(printout t "Возможно, проблема вызвана процессором или материнской платой
		(см. 1. и 3.)" crlf)
		(assert (initial-fact))
	)

	(printout t "Обслуживание ПК проводилось более года назад?" crlf)
	(bind ?upgrade (read))
	(if  (or (eq ?upgrade y) (eq ?upgrade да))
		then
		(printout t "Возможно, вам помогут советы из пунктов 1. и 3." crlf)
		(assert (initial-fact))
	)

	(printout t "Загрузка проходит нормально, но при длительной работе скорость работы
	ухудшается?" crlf)
	(bind ?upgrade (read))
	(if  (or (eq ?upgrade y) (eq ?upgrade да))
		then
		(printout t "Симптомы неполадок процессора и памяти (см. 1. и 2.)" crlf)
		(assert (initial-fact))
	)

	(printout t "Проблемы при загрузке ПК, медленные запуск некоторых программ и
	открытие файлов?" crlf)
	(bind ?upgrade (read))
	(if  (or (eq ?upgrade y) (eq ?upgrade да))
		then
		(printout t "Стоит проверить жесткий диск" crlf)
		(assert (initial-fact))
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cpu problems section ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; clarifying the cpu problem
(defrule cpu-problems
	(cpu-prob 1)
=>

	(printout t "Перегривается ли процессор?" crlf)
	(bind ?oheat (read))
	(if  (or (eq ?oheat y) (eq ?oheat да))
		then (assert (cpu-oheat 1))
		else (assert (cpu-oheat 0))
	)

	(printout t "Настройки BIOS корректны?" crlf)
	(bind ?bios (read))
	(if  (or (eq ?bios y) (eq ?bios да))
		then (assert (cpu-bios 0))
		else (assert (cpu-bios 1))
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

	(printout t "Процессор работает медленнее (при этом возможно появление системных
		уведомлений о некорректной работе процессора)?" crlf)
	(bind ?speed (read))
	(if  (or (eq ?speed y) (eq ?speed да))
		then (assert (cpu-slow 1))
		else (assert (cpu-slow 0))
	)
)

; advice for cpu overheating
(defrule cpu-overheating
	(cpu-oheat 1)
=>
(printout t
	 "-------------------------------------------------------------------------------
	 ------------------------------------------" crlf)
	(printout t "Измерьте температуру процессора: " crlf)
	(printout t "  1. Запустите ресурсоемкое приложение на некоторое время
	(бенчмарк)" crlf)
	(printout t "  2. Запустите специальную утилиту для диагностики процессора
	(cpu-z, aida) или перезагрузите ПК, чтобы посмотреть темпеартуру в BIOS" crlf)
	(printout t "Если температура процессора больше 80 градусов, то это серьезная
	проблема:" crlf)
	(printout t "  - Проверьте установку процессора: он должен быть закреплен в
	сокете, сверху плотно прижат кулером." crlf)
	(printout t "  - Проверите, что процессор получает необходимы вольтаж." crlf)
	(printout t "  - Удостоверьтесь, что кулер подходит для данного процессора (по
		рассеиваемой мощности)." crlf)
	(printout t "  - Если кулер сильно загрязнен пылью, необходимо его очистить."
	 crlf)
	(printout t "  - Попробуйте нанести свежую термопасту между процессором и
	кулером." crlf)
)

; incorrect bios settings
(defrule cpu-incorrect-bios
	(cpu-bios 1)
=>
	(printout t
		 "--------------------------------------------------------------------------
		 -----------------------------------------------" crlf)
	(printout t "Если вы проверили настройки BIOS и они некорректны, попробуйте
	выполнить установку настроек по-умолчанию." crlf)
)

; problem with motherboard support
(defrule cpu-mboard-support
	(cpu-notsupport 1)
=>
	(printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если процессор несовместим с материнской платой:" crlf)
	(printout t "  - Возможно, необходимо обновление BIOS." crlf)
	(printout t "  - Свяжитесь с тех. поддержкой производителя." crlf)
)

; unexpected system crashing and rebooting
(defrule cpu-crashing
	(cpu-crash 1)
=>

)

; cpu is slowing down
(defrule cpu-speed
	(cpu-slow 1)
=>

)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ram problems section ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; clarifying the ram problem
(defrule ram-problems
	(ram-prob 1)
=>
	(printout t "Вы недавно добавляли дополнительную память?" crlf)
	(bind ?upgrade (read))
	(if  (or (eq ?upgrade y) (eq ?upgrade да))
		then (assert (ram-upg 1))
		else (assert (ram-upg 0))
	)

	(printout t "Вы изменяли настройки BIOS, касающиеся ОЗУ?" crlf)
	(bind ?bios (read))
	(if  (or (eq ?bios y) (eq ?bios да))
		then (assert (ram-bios 1))
		else (assert (ram-bios 0))
	)

	(printout t "Вы недавно обновляли оперционную систему?" crlf)
	(bind ?osupd (read))
	(if  (or (eq ?osupd y) (eq ?osupd да))
		then (assert (ram-osupd 1))
		else (assert (ram-osupd 0))
	)

	(printout t "Вы меняли другие компоненты системного блока (процессор,
		 материнская плата)?" crlf)
	(bind ?other (read))
	(if  (or (eq ?other y) (eq ?other да))
		then (assert (ram-other 1))
		else (assert (ram-other 0))
	)
)

; ram upgrade caused this problem
(defrule ram-upgrade
	(ram-upg 1)
=>

)

; incorrect bios settings (frequency, clocks)
(defrule ram-biossettings
	(ram-bios 1)
=>

)

; problems after os update
(defrule ram-osupdate
	(ram-osupd 1)
=>

)

; replacment of other parts of pc
(defrule ram-other
	(ram- 1)
=>

)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; motherboard problems section ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; clarifying the motherboard problem
(defrule motherboard-problems
	(mb-prob 1)
=>
	(printout t "Проблема с подключением новых PCI устройств и планок ОЗУ?" crlf)
	(bind ?pci (read))
	(if  (or (eq ?pci y) (eq ?pci да))
		then (assert (mb-pci 1))
		else (assert (mb-pci 0))
	)

	(printout t "На плате имеются вздувшиеся конденсаторы?" crlf)
	(bind ?cap (read))
	(if  (or (eq ?cap y) (eq ?cap да))
		then (assert (mb-cap 1))
		else (assert (mb-cap 0))
	)

	(printout t "Проблемы с подключением периферийных устройств?" crlf)
	(bind ?per (read))
	(if  (or (eq ?per y) (eq ?per да))
		then (assert (mb-per 1))
		else (assert (mb-per 0))
	)

	(printout t "Проблемы с подключением HDD?" crlf)
	(bind ?sata (read))
	(if  (or (eq ?sata y) (eq ?sata да))
		then (assert (mb-sata 1))
		else (assert (mb-sata 0))
	)
)

; problem with pci
(defrule motherboard-pci
	(mb-pci 1)

=>
)

; bad capacitors on motherboard
(defrule motherboard-capacitors
	(mb-cap 1)

=>
)

; problem with connecting peripheral devices
(defrule motherboard-periphery
	(mb-per 1)

=>
)

; problem with connecting hdd
(defrule motherboard-sata
	(mb-sata 1)

=>
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; hdd problems section ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; clarifying the hdd problem
(defrule hdd-problems
	(hdd-prob 1)
=>
	(printout t "HDD не раскручивает шпиндель, не издавает каких-либо признаков
	работоспособности?" crlf)
	(bind ?pow (read))
	(if  (or (eq ?pow y) (eq ?pow да))
		then (assert (hdd-pow 1))
		else (assert (hdd-pow 0))
	)

	(printout t "Доступ к некоторым файлам значительно замедлился?" crlf)
	(bind ?blocks (read))
	(if  (or (eq ?blocks y) (eq ?blocks да))
		then (assert (hdd-blocks 1))
		else (assert (hdd-blocks 0))
	)

	(printout t "Жесткий диск был приобретен недавно?" crlf)
	(bind ?def (read))
	(if  (or (eq ?def y) (eq ?def да))
		then (assert (hdd-def 1))
		else (assert (hdd-def 0))
	)

	(printout t "Происходило ли недавно некорректное отключение ПК?" crlf)
	(bind ?sysfiles (read))
	(if  (or (eq ?sysfiles y) (eq ?sysfiles да))
		then (assert (hdd-sysfiles 1))
		else (assert (hdd-sysfiles 0))
	)

	(printout t "Жесткий диск перегревается?" crlf)
	(bind ?oheat (read))
	(if  (or (eq ?oheat y) (eq ?oheat да))
		then (assert (hdd-oheat 1))
		else (assert (hdd-oheat 0))
	)
)

; dead power controller
(defrule hdd-power
	(hdd-pow 1)

=>
)

; bad blocks
(defrule hdd-badblocks
	(hdd-blocks 1)

=>
)

; warranty case
(defrule hdd-defect
	(hdd-def 1)

=>
)

; damaged system files
(defrule hdd-badsysfiles
	(hdd-sysfiles 1)

=>
)

; hdd overheating
(defrule hdd-overheating
	(hdd-oheat 1)

=>
)
