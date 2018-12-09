;defrule for initializing
(defrule initialize
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
	(inspect-prob 1)
=>
	(printout t "Вы недавно собирали ПК или проводил аппаратное обновление?" crlf)
	(bind ?assembled (read))
	(if  (or (eq ?assembled y) (eq ?assembled да))
		then
		(printout t "Возможно, проблема вызвана процессором или материнской платой:"
		crlf)
		(printout t "  1. Процессор" crlf)
		(printout t "  2. Материнская плата" crlf)
		(bind ?problem (read))

		(if (eq ?problem 1)
			then (assert(cpu-prob 1))
		)
		(if (eq ?problem 2)
			then (assert(mb-prob 1))
		)

		(if (and :(integerp ?problem) (< ?problem 1) (> ?problem 2))
			then (printout t "Введите целое число от 1 до 2" crlf)
		)
	)

	(printout t "Обслуживание ПК проводилось более года назад?" crlf)
	(bind ?upgrade (read))
	(if  (or (eq ?upgrade y) (eq ?upgrade да))
		then
		(printout t "Возможно, вам помогут советы из пунктов:" crlf)
		(printout t "  1. Процессор" crlf)
		(printout t "  2. Материнская плата" crlf)
		(bind ?problem (read))

		(if (eq ?problem 1)
			then (assert(cpu-prob 1))
		)
		(if (eq ?problem 2)
			then (assert(mb-prob 1))
		)

		(if (and :(integerp ?problem) (< ?problem 1) (> ?problem 2))
			then (printout t "Введите целое число от 1 до 2" crlf)
		)
	)

	(printout t "Загрузка проходит нормально, но при длительной работе скорость работы
	ухудшается?" crlf)
	(bind ?upgrade (read))
	(if  (or (eq ?upgrade y) (eq ?upgrade да))
		then
		(printout t "Симптомы неполадок процессора и памяти:" crlf)
		(printout t "  1. Процессор" crlf)
		(printout t "  2. ОЗУ" crlf)
		(bind ?problem (read))

		(if (eq ?problem 1)
			then (assert(cpu-prob 1))
		)
		(if (eq ?problem 2)
			then (assert(ram-prob 1))
		)

		(if (and :(integerp ?problem) (< ?problem 1) (> ?problem 2))
			then (printout t "Введите целое число от 1 до 2" crlf)
		)
	)

	(printout t "Проблемы при загрузке ПК, медленные запуск некоторых программ и
	открытие файлов?" crlf)
	(bind ?upgrade (read))
	(if  (or (eq ?upgrade y) (eq ?upgrade да))
		then
		(printout t "Стоит проверить жесткий диск" crlf)
		(assert (hdd-prob 1))
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
	(printout t
	 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Проверьте системные логи для уточнения ошибки." crlf)
	(printout t "Если это происходит при работе с ресурсоемкими приложениями,
	то проблема вызвана, скорее всего, перегревом." crlf)
	(printout t "Если процессор новый, обратитесь за гарантийной помощью." crlf)
)

; cpu is slowing down
(defrule cpu-speed
	(cpu-slow 1)
=>
	(printout t
	 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Установите настройки BIOS по-умолчанию, процессор может не получать
	необходимый вольтаж." crlf)
	(printout t "Если это происходит при работе с ресурсоемкими приложениями,
	то проблема вызвана, скорее всего, перегревом." crlf)
	(printout t "Исследуйте систему на наличие вредоносного ПО." crlf)
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
=> (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если проблема возникла после обновления оперативной памяти:" crlf)
	(printout t "  - Возможно, необходимо обновление BIOS." crlf)
	(printout t "  - Возможно, ваша материнская плата не поддерживает данную RAM." crlf)
	(printout t "  - Возможно, ваша материнская плата не работает в двухканальном режиме с данной RAM." crlf)
	(printout t "  - Свяжитесь с тех. поддержкой производителя." crlf)
)

; incorrect bios settings (frequency, clocks)
(defrule ram-biossettings
	(ram-bios 1)
=> (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если проблема совместимости RAM и настроек BIOS:" crlf)
	(printout t "  - Проверьте выставленное в BIOS значение частоты и действующую частоту RAM (на задней крышке упаковки)." crlf)
	(printout t "  - Сбросьте настройки BIOS." crlf)
)

; problems after os update
(defrule ram-osupdate
	(ram-osupd 1)
=> (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если проблема возникла после обновления ОС:" crlf)
	(printout t "  - Обратитесь в тех. поддержку ОС." crlf)
	(printout t "  - Сделайте бекап, если имеется." crlf)
)

; replacment of other parts of pc
(defrule ram-other
	(ram-other 1)
=> (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если проблема возникает из-за несовместимости с другими частями ПК:" crlf)
	(printout t "  - В настройках BIOS выставьте соотвествующую частоту для корректной работы с другими элементами." crlf)
	(printout t "  - Замените отстающие элементы." crlf)

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

=> (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если материнская плата не видит контроллер, подключенный через PCI:" crlf)
	(printout t "  - Проверьте удлинитель питания PCI." crlf)
	(printout t "  - Проверьте правильность назначения портов в BIOS." crlf)
)

; bad capacitors on motherboard
(defrule motherboard-capacitors
	(mb-cap 1)

=>	(printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если проблема связана с конденсаторами:" crlf)
	(printout t "  - Поменяйте конденасторы сами или отнесите в сервисный центр." crlf)
	(printout t "  - Поменяйте плату целиком." crlf)
)

; problem with connecting peripheral devices
(defrule motherboard-periphery
	(mb-per 1)
=> (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если проблема связана с периферийными устройствами:" crlf)
	(printout t "  - Проверьте периферийные устройства на другом компьютере, возможно, они неисправны." crlf)
	(printout t "  - Обновите BIOS." crlf)
	(printout t "  - Свяжитесь с тех поддержкой." crlf)
)

; problem with connecting hdd
(defrule motherboard-sata
	(mb-sata 1)

=> (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Если проблема связана с SATA контроллером:" crlf)
	(printout t "  - Проверьте SATA кабель." crlf)
	(printout t "  - Обновите BIOS." crlf)
	(printout t "  - Свяжитесь с тех поддержкой." crlf)
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

	=> (printout t "Проверьте подключение жесткого диска, проверьте кабель SATA." crlf)
	(printout t "Кабель исправен?" crlf)
	(bind ?sata-cable (read))
	(if  (or (eq ?sata-cable y) (eq ?sata-cable да))
	    then (assert (hdd-replace 1))
	    else (assert (mb-sata 1))
	)
)

; bad blocks
(defrule hdd-badblocks
	(hdd-blocks 1)
	=> (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Проведите проверку количество \"плохих\" блоков в жестком диске при помощи одной из доступных утилит." crlf)
	(printout t "Количество плохих блоков велико (больше 100-1000)? " crlf)
	(bind ?badblocks (read))
	(if  (or (eq ?badblocks y) (eq ?badblocks да))
	    then (assert (hdd-replace 1))
	    else (assert (hdd-replace 0))
	)
)

; warranty case
(defrule hdd-defect
  (hdd-def 1)
  (hdd-replace 1)
  => (printout t
		     "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Скорее всего, ваш жесткий диск неисправен." crlf)
	(printout t "Обратитесь в сервисный центр или место приобретения для ремонта или замены жесткого диска по гарантии." crlf)
	)

; damaged system files
(defrule hdd-badsysfiles
	(hdd-sysfiles 1)

	=> (printout t
		     "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Запустите вашу операционную систему в безопасном режиме (safe mode) или в режиме восстановления." crlf)
	(printout t "Операционная система должна самостоятельно решить проблему с её системными файлами. Возможно потребуется переустановка ОС." crlf)
	(printout t "Не выключайте больеш компьютер иначе как через команду \"Выключение\" в операционной системе." crlf)
	)

; hdd overheating
(defrule hdd-overheating
	(hdd-oheat 1)
	=> (printout t
		     "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
	(printout t "Очистите ваш жесткий диск от пыли. Убедитесь, что вокруг него достаточно свободного пространства, что обеспечивается беспрепятственный поток воздуха." crlf)

)


; hdd replacement, no warranty
(defrule hdd-replacement
  (hdd-replace 1)
  (hdd-def 0)
  => (printout t
		 "-----------------------------------------------------------------------------
	--------------------------------------------" crlf)
  (printout t "Скорее всего, ваш жесткий диск неисправен." crlf)
  (printout t "Обратитесь к специалисту для восстановления данных, и приобретите новый жесткий диск." crlf)
)

; hdd is okay
(defrule hdd-is-okay
  (hdd-replace 0)
  => (printout t "Не выявлено критичный проблем с вашим жестким диском." crlf)
  (printout t "Рекомендуется регулярно делать бекап (резервное сохранение данных) и проверять количество \"плохих\" блоков (bad blocks). Если их число начнёт резко расти, следует заменить жесткий диск." crlf)
)
