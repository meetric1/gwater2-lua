local strings = {
	["gwater2.menu.title"]="GWater2 (%s)",

	["gwater2.menu.About Tab.title"] = "О моде",
	["gwater2.menu.About Tab.titletext"] = "Добро пожаловать в GWater2 (v%s)",
	["gwater2.menu.About Tab.welcome"]=[[
			Спасибо за то что скачали gwater2 beta! В этом меню и интерфейсе ты будешь контролировать все что связаноо с gwater. Так-что привыкай! :D

			Так-же прочитайте список изменений и посмотрите что изменилось!

			Список изменений (v0.5b):
			- Добавлена ткань в спавн-меню
			- Добавлена черная дыра
			- Добавлен слив и эмиттер
			- Добавлено время жизни партиклов
			- Теперь можно управлять водой грави-пушкой!
			- Теперь графика воды более реалистичная!
			- Изменены визуал диффуза
			- Теперь пресет портал геля более похож на портал гелью.
			- Теперь партиклы не будут проходить через обьекты у которых выключена коллизия
			- Пофиксино много багов клипанья партиклов
			- Теперь нельзя летать с жидкостью приклееной к тебе
			- Почистили код от мусора и улучшили API
	]],
	["gwater2.menu.About Tab.help"]=[[
		В каждой вкладке в этой части будет написана важная информация.

		Например:
		Кликанье где-то вне меню, или опять нажимая кнопку меню закроет его.

		Убедитесь что прочитали эту часть!
	]],

	["gwater2.menu.Parameters.title"]="Параметры",
	["gwater2.menu.Parameters.titletext"]="Параметры",
	["gwater2.menu.Parameters.help"]=[[
		В этой вкладке вы можете изменить параметры как вода будет взаимодействовать с окружением.

		Наведите курсор на параметр, чтобы увидеть его функциональность.
	]],

	["gwater2.menu.Visuals.title"]="Визуал",
	["gwater2.menu.Visuals.titletext"]="Визуал",
	["gwater2.menu.Visuals.help"]=[[
		В этой вкладке вы можете изменять как вода будет выглядеть.

		Наведите курсор на параметр, чтобы увидеть его функциональность.
	]],

	["gwater2.menu.Performance.title"]="Производительность",
	["gwater2.menu.Performance.titletext"]="Производительность",
	["gwater2.menu.Performance.help"]=[[
		Тут вы можете настроить что-бы у вас не так лагало.

		В каждой настройке будет от красного до зеленого индекатора что-бы понять как нагружается игра.

		Все параметры напрямую влияют на ГПУ.
	]],

	["gwater2.menu.Interactions.title"]="Взаимодействия",
	["gwater2.menu.Interactions.titletext"]="Взаимодействия",
	["gwater2.menu.Interactions.help"]=[[
		Настраивает то, как жидкость взаимодействует с игроками.
	]],

	["gwater2.menu.Presets.title"]="Пресеты",
	["gwater2.menu.Presets.titletext"]="Пресеты",
	["gwater2.menu.Presets.help"]=[[
		Тут вы можете выбрать пресет.
	]],
	["gwater2.menu.Presets.import_preset"]="Импортировать пресет",
	["gwater2.menu.Presets.import.paste_here"]="Вставьте пресет тут",
	["gwater2.menu.Presets.import.detected"]="Обнаружен: %s пресет",
	["gwater2.menu.Presets.import.bad_data"]="Данные повреждены или неизвестный тип пресета.",
	["gwater2.menu.Presets.save"]="Сохранить пресет",
	["gwater2.menu.Presets.save.preset_name"]="Имя пресета",
	["gwater2.menu.Presets.save.include_params"]="Включить следущие параметры",
	["gwater2.menu.Presets.copy"]="Скопировать в буфер обмена",
	["gwater2.menu.Presets.copy.as_json"]="...как JSON",
	["gwater2.menu.Presets.copy.as_b64pi"]="...как B64-PI",
	["gwater2.menu.Presets.delete"]="Удалить",

	["gwater2.menu.Patrons.title"] = "Патреоны",
	["gwater2.menu.Patrons.titletext"]="Патреоны",
	["gwater2.menu.Patrons.help"]=[[
		Тут все мои патреоны.

		Все в алфавитном порядке.

		Они будут рутинно обновлятся до релиза.
	]],
	["gwater2.menu.Patrons.text"]=[[
		Спасибо всем кто меня поддержал во время разработки GWater2!
			
		Все средства которые я получил отсюда пойдут на оплату колледжа! Спасибо вам большое ребята :)
		-----------------------------------------
	]],

	["gwater2.menu.Parameters.Physics Parameters"]="Физические параметры",
	["gwater2.menu.Parameters.Advanced Physics Parameters"]="Расширенные физические параметры",
	["gwater2.menu.Parameters.Reaction Force Parameters"]="Параметры реакционных сил",

	["gwater2.menu.Parameters.Adhesion"]="Липучесть",
	["gwater2.menu.Parameters.Adhesion.desc"]=[[
		Контролирует насколько жидкость будет прилипать к поверхностям.

		Обратите внимание, что этот конкретный параметр не очень хорошо отражает изменения в предварительном просмотре, и его, возможно, придется просмотреть извне.
	]],
	["gwater2.menu.Parameters.Gravity"]="Гравитация",
	["gwater2.menu.Parameters.Gravity.desc"]=[[
		Изменяет гравитацию. Изчисляется в метрах в секунду.

		Заметьте, что начальная гравитация -15.24 не совпадает с гравитацией на земле которая равняется -9.81.
	]],
	["gwater2.menu.Parameters.Cohesion"]="Слипчивость",
	["gwater2.menu.Parameters.Cohesion.desc"]=[[
		Контролирует насколько жидкость будет густой.

		Более высокие значения делают жидкость более твердой/жесткой, а более низкие значения делают ее более текучей и рыхлой.
	]],
	["gwater2.menu.Parameters.Surface Tension"]="Поверхностное натяжение",
	["gwater2.menu.Parameters.Surface Tension.desc"]=[[
		Управляет тем, насколько сильно частицы минимизируют площадь поверхности.

		Этот параметр имеет тенденцию к странному поведению частиц, если он установлен слишком высоко.

		Обычно в комплекте с сплочённостью.
	]],
	["gwater2.menu.Parameters.Viscosity"]="Тянучесть",
	["gwater2.menu.Parameters.Viscosity.desc"]=[[
		Контролирует насколько жидкость будет сопрятивлятся к физическому вмешательству.

		Высокие значения делают жидкость похожей на мед или сироп.
	]],
	["gwater2.menu.Parameters.Radius"]="Радиус",
	["gwater2.menu.Parameters.Radius.desc"]=[[
		Управляет размером каждой частицы.

		В превью оно ограничено до 15, чтобы избежать странностей.

		Радиус измеряется в исходных единицах и одинаков для всех частиц.
	]],
	["gwater2.menu.Parameters.Timescale"]="Временной множитель",
	["gwater2.menu.Parameters.Timescale.desc"]=[[
		Устанавливает скорость моделирования.

		Обратите внимание, что некоторые параметры, такие как сцепление и поверхностное натяжение, могут вести себя по-разному из-за меньшего или большего времени расчета.
	]],
	["gwater2.menu.Parameters.Dynamic Friction"]="Динамическое трение",
	["gwater2.menu.Parameters.Dynamic Friction.desc"]=[[
        Контролирует количество частиц трения, попадающих на поверхности.

		При значении близких к 0, прилипчивость ведет себя странно.
	]],
	["gwater2.menu.Parameters.Vorticity Confinement"]="Удержание завихренности",
	["gwater2.menu.Parameters.Vorticity Confinement.desc"]=[[
		Увеличивает эффект завихренности за счет приложения к частицам вращательных сил.

		Это существует потому, что давление воздуха невозможно эффективно смоделировать.
	]],
	["gwater2.menu.Parameters.Collision Distance"]="Дистанция коллизии",
	["gwater2.menu.Parameters.Collision Distance.desc"]=[[
		Управляет расстоянием столкновения между частицами и объектами.

		Обратите внимание, что чем меньше расстояние столкновения, тем чаще частицы будут проходить сквозь объекты.
	]],
	["gwater2.menu.Parameters.Fluid Rest Distance"]="Дистанция покоя",
	["gwater2.menu.Parameters.Fluid Rest Distance.desc"]=[[
		Управляет расстоянием столкновения между частицами.

		Более высокие значения приводят к получению более комковатых жидкостей, тогда как более низкие значения приводят к более гладким жидкостям.
	]],
	["gwater2.menu.Parameters.Force Buoyancy"]="Сила всплывчивости",
	["gwater2.menu.Parameters.Force Buoyancy.desc"]=[[
		Выталкивающая сила, действующая на пропы в воде.

		Реализация ни в коем случае не является точной и, вероятно, не должна использоваться для пропов-лодок.
	]],
	["gwater2.menu.Parameters.Force Dampening"]="Сила демпфирования",
	["gwater2.menu.Parameters.Force Dampening.desc"]=[[
		Демпфирующая сила, приложенная к пропам.

		Немного помогает, если проп имеет тенденцию подпрыгивать на поверхности воды.
	]],
	["gwater2.menu.Parameters.Force Multiplier"]="Множитель сил",
	["gwater2.menu.Parameters.Force Multiplier.desc"]=[[
		Определяет силу, с которой вода действует на пропы.
	]],

	["gwater2.menu.Visuals.Diffuse Threshold"]="Порог диффуза",
	["gwater2.menu.Visuals.Diffuse Threshold.desc"]=[[
		Управляет величиной силы, необходимой для образования пузырьков/частиц пены.
	]],
	["gwater2.menu.Visuals.Color"]="Цвет",
	["gwater2.menu.Visuals.Color.desc"]=[[
		Управляет цветом жидкости.

		Альфа-канал (прозрачность) контролирует степень поглощения цвета.

		Значение альфа 255 (максимальное) делает жидкость непрозрачной.
	]],
	["gwater2.menu.Visuals.Anisotropy Max"]="Максимум анизотропии",
	["gwater2.menu.Visuals.Anisotropy Max.desc"]=[[
		Управляет максимальным визуальным размером частиц.
	]],
	["gwater2.menu.Visuals.Diffuse Lifetime"]="Время жизни диффуза",
	["gwater2.menu.Visuals.Diffuse Lifetime.desc"]=[[
		Управляет сроком существования пузырьков/частиц пены после создания.

		На это влияет временной множитель.

		Установка этого параметра на ноль приведет к отключению диффузных частиц.
	]],
	["gwater2.menu.Visuals.Anisotropy Min"]="Минимум анизотропии",
	["gwater2.menu.Visuals.Anisotropy Min.desc"]=[[
		Управляет минимальным визуальным размером частиц.
	]],
	["gwater2.menu.Visuals.Reflectance"]="Отражаемость",
	["gwater2.menu.Visuals.Reflectance.desc"]=[[
		Решает насколько сильно будет отражать вода.
	]],
	["gwater2.menu.Visuals.Anisotropy Scale"]="Размер анизотропии",
	["gwater2.menu.Visuals.Anisotropy Scale.desc"]=[[
        Управляет визуальным размером растяжения между частицами.

		Установка этого значения в ноль отключит растяжение.
	]],
	["gwater2.menu.Visuals.Color Value Multiplier"]="Умножение цвета",
	["gwater2.menu.Visuals.Color Value Multiplier.desc"]=[[
		Управляет множителем цвета жидкости.

		Установка значения выше 1 заставляет жидкость "светиться"" при определенных условиях.
	]],

	["gwater2.menu.Performance.Blur Passes"]="Фазы размытия",
	["gwater2.menu.Performance.Blur Passes.desc"]=[[
		Управляет количеством проходов размытия, выполняемых на кадр. Больше проходов создает более гладкую поверхность воды. Нулевые проходы не приводят к размытию.

		Низкое влияние на производительность.
	]],
	["gwater2.menu.Performance.Reaction Forces"]="Реакционные силы",
	["gwater2.menu.Performance.Reaction Forces.desc"]=[[
		0 = Нет сил

		1 = Простые силы реакций. (Плавание)

		2 = Полные силы реакций (Вода может перемещать пропы).
	]],
	["gwater2.menu.Performance.Absorption"]="Поглощение",
	["gwater2.menu.Performance.Absorption.desc"]=[[
		Обеспечивает поглощение света на расстоянии внутри жидкости.

		(больше глубины = более темный цвет)

		Среднее влияние на производительность.
	]],
	["gwater2.menu.Performance.Substeps"]="Сабстепы",
	["gwater2.menu.Performance.Substeps.desc"]=[[
		Управляет количеством шагов физики, выполняемых за такт.

		Обратите внимание, что параметры для разных подшагов могут быть настроены неправильно!

		Средне-высокое влияние на производительность.
	]],
	["gwater2.menu.Performance.Depth Fix"]="Фикс глубины",
	["gwater2.menu.Performance.Depth Fix.desc"]=[[
		Делает частицы сферическими, а не плоскими, создавая более чистую и гладкую поверхность воды.

		Вызывает перерисовку шейдера.

		Средне-высокое влияние на производительность.
	]],
	["gwater2.menu.Performance.Particle Limit"]="Лимит партиклов",
	["gwater2.menu.Performance.Particle Limit.desc"]=[[
		ИСПОЛЬЗУЙТЕ ЭТОТ ПАРАМЕТР НА СВОЙ СТРАХ И РИСК.

		Изменяет лимит частиц.

		Обратите внимание, что более высокий предел отрицательно повлияет на производительность даже при том же количестве создаваемых партиклов.
	]],
	["gwater2.menu.Performance.Iterations"]="Итерации",
	["gwater2.menu.Performance.Iterations.desc"]=[[
		Управляет тем, сколько раз физический решатель попытается прийти к решению на каждом подшаге.

		Среднее влияние на производительность.
	]],

	["gwater2.menu.Interactions.SwimSpeed"]="Скорость плаванья",
	["gwater2.menu.Interactions.SwimSpeed.desc"]="Контролирует насколько сильно изменится твоя скорость при плавании",
	["gwater2.menu.Interactions.SwimFriction"]="Трение при плаваньи",
	["gwater2.menu.Interactions.SwimFriction.desc"]="Контролирует насколько вода будет сопротивлятся твоим движениям",
	["gwater2.menu.Interactions.SwimBuoyancy"]="Вспыльчивость при плавании",
	["gwater2.menu.Interactions.SwimBuoyancy.desc"]="Контролирует насколько сильно вода будет толкать тебя вверх",
	["gwater2.menu.Interactions.DrownTime"]="Время задыхания",
	["gwater2.menu.Interactions.DrownTime.desc"]="Контролирует насколько много времени понадобится что-бы ты начал тонуть",
	["gwater2.menu.Interactions.DrownParticles"]="Партиклы утопания",
	["gwater2.menu.Interactions.DrownParticles.desc"]="Контролирует насколько много партиклов вам надо задеть перед тем как тонуть",
	["gwater2.menu.Interactions.DrownDamage"]="Урон утопания",
	["gwater2.menu.Interactions.DrownDamage.desc"]="Контролирует урон получаемый при утопании",
	["gwater2.menu.Interactions.MultiplyParticles"]="Множитель партиклов",
	["gwater2.menu.Interactions.MultiplyParticles.desc"]="Контролирует со скольки партиклами вам надо контактировать перед тем как множители вступят в силу",
	["gwater2.menu.Interactions.MultiplyWalk"]="Множитель скорости ходьбы",
	["gwater2.menu.Interactions.MultiplyWalk.desc"]="Контролирует насколько будет умножаться ваша скорость ходьбы и бега",
	["gwater2.menu.Interactions.MultiplyJump"]="Множитель прыжка",
	["gwater2.menu.Interactions.MultiplyJump.desc"]="Контролирует насколько будет умножаться ваша сила прыжка",
	["gwater2.menu.Interactions.TouchDamage"]="Урон при касании",
	["gwater2.menu.Interactions.TouchDamage.desc"]="Контролирует сколько урона ты будешь получать при контакте с водой"
}

return strings, "russian"