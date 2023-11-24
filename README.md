## RuStore Godot плагин для обновления приложения

Плагин “RuStoreGodotAppUpdate” помогает поддерживать актуальную версию вашего приложения на устройстве пользователя.

Репозиторий содержит плагины “RuStoreGodotAppUpdate” и “RuStoreGodotCore”, а также демонстрационное приложение с примерами использования и настроек. Поддерживаются версии Godot 4+.

### Сборка плагина

1. Откройте в вашей IDE проект Android из папки _“godot_plugin_libraries”_.

2. Поместите в папку _“godot_plugin_libraries / libs”_ пакет _“godot-lib.xxx.yyy.template_release.aar”_, где _xxx.yyy_ версия вашей редакции Godot Engine.

3. Выполните сборку проекта командой gradle assemble.

При успешном выполнении сборки в папке _“godot_example / android / plugins”_ будут созданы файлы:
- RuStoreGodotAppUpdate.gdap
- RuStoreGodotAppUpdate.aar
- RuStoreGodotCore.gdap
- RuStoreGodotCore.aar

⚠️ Обратите особое внимание, что библиотеки плагинов должны быть собраны под вашу версию Godot Engine.


### Установка плагина в свой проект

1. Выполните шаги раздела “Сборка плагина”.

2. Скопируйте содержимое папки _“godot_example / android / plugins”_ в папку _“*your_project* / android / plugins”_.

3. В пресете сборки Android в списке "Плагины" отметьте плагины “Ru Store Godot App Update” и “Ru Store Godot Core”


### Сборка примера приложения

1. Выполните шаги раздела “Сборка плагина”. Собранные файлы (.aar и .gdap) будут автоматически скопированы в проект-пример.

2. Откройте godot проект в папке _“godot_example”_.

3. Выполните установку шаблона сборки Android (Проект → Установить шаблон сборки Android...).

4. Добавьте пресет сборки Android (Проект → Экспорт... → Добавить... → Android).

5. В пресете сборки Android в списке "Плагины" отметьте плагины “Ru Store Godot App Update” и “Ru Store Godot Core”

6. Настройте разделы “Хранилище ключей”, “Версия” и “Пакет” под параметры вашего приложения в RuStore. Подробная информация о публикации приложений в RuStore доступна на странице [help](https://help.rustore.ru/rustore/for_developers/publishing_and_verifying_apps).

7. Выполните сборку проекта командой “Экспорт проекта...” и проверьте работу приложения.


### Техническая поддержка

Дополнительная помощь и инструкции доступны на странице [help.rustore.ru](https://help.rustore.ru/).
