## RuStore Godot плагин для приема платежей через сторонние приложения

### [🔗 Документация разработчика](https://www.rustore.ru/help/sdk/payments)

Плагин “RuStoreGodotBilling” помогает интегрировать в ваш проект механизм оплаты через сторонние приложения (например, SberPay или СБП).

Репозиторий содержит плагины “RuStoreGodotBilling” и “RuStoreGodotCore”, а также демонстрационное приложение с примерами использования и настроек. Поддерживаются версии Godot 4+.


### Сборка плагина

1. Откройте в вашей IDE проект Android из папки _“godot_plugin_libraries”_.

2. Поместите в папку _“godot_plugin_libraries / libs”_ пакет _“godot-lib.xxx.yyy.template_release.aar”_, где _xxx.yyy_ версия вашей редакции Godot Engine.

3. Выполните сборку проекта командой gradle assemble.

При успешном выполнении сборки в папке _“godot_example / android / plugins”_ будут созданы файлы:
- RuStoreGodotBilling.gdap
- RuStoreGodotBilling.aar
- RuStoreGodotCore.gdap
- RuStoreGodotCore.aar

> ⚠️ Обратите особое внимание, что библиотеки плагинов должны быть собраны под вашу версию Godot Engine.


### Сборка примера приложения

Вы можете ознакомиться с демонстрационным приложением содержащим представление работы всех методов sdk:
- [README](godot_example/README.md)
- [godot_example](https://gitflic.ru/project/rustore/godot-rustore-billing/file?file=godot_example)


### Установка плагина в свой проект

1. Выполните шаги раздела “Сборка плагина”.

2. Скопируйте содержимое папки _“godot_example / android / plugins”_ в папку _“*your_project* / android / plugins”_.

3. В пресете сборки Android в списке "Плагины" отметьте плагины “Ru Store Godot Billing” и “Ru Store Godot Core”


### История изменений

[CHANGELOG](CHANGELOG.md)


### Условия распространения

Данное программное обеспечение, включая исходные коды, бинарные библиотеки и другие файлы распространяется под лицензией MIT. Информация о лицензировании доступна в документе [MIT-LICENSE](../MIT-LICENSE.txt).


### Техническая поддержка

Дополнительная помощь и инструкции доступны на странице [help.rustore.ru](https://help.rustore.ru/) и по электронной почте [support@rustore.ru](mailto:support@rustore.ru).
